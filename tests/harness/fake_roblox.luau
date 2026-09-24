--[[
	A small, deterministic stand-in for the parts of the Roblox engine and the
	executor API that MainUI.lua and InterfaceManager.lua touch.

	It is intentionally strict where Roblox is strict (unknown members and
	badly typed property writes raise errors) so that a test catches the same
	mistakes the real engine would. Rendering and layout are approximated:
	Absolute* properties are computed from Size/Position only and change
	signals for them fire only through World:bumpLayout().

	Each World is independent; tests create a fresh one per scenario.
]]

local roblox = require("@lune/roblox")
local luau = require("@lune/luau")
local task = require("@lune/task")
local JSON = require("./json")
local Types = require("./types")

local Engine = {}

local realTypeof = typeof
local fakeTypes = setmetatable({}, { __mode = "k" })

local function typeofValue(value: any): string
	local fake = fakeTypes[value]
	if fake then
		return fake
	end
	return Types.typeof(value) or realTypeof(value)
end
Engine.typeof = typeofValue

--------------------------------------------------------------------------------
-- Reflection
--------------------------------------------------------------------------------

local database = roblox.getReflectionDatabase()

local classCache = {}
local function getClass(className: string)
	local cached = classCache[className]
	if cached ~= nil then
		return cached or nil
	end
	local class = database:FindClass(className)
	classCache[className] = class or false
	return class
end

local superCache = {}
local function isA(className: string, target: string): boolean
	local key = className .. "\0" .. target
	local cached = superCache[key]
	if cached ~= nil then
		return cached
	end
	local current = className
	local result = false
	while current do
		if current == target then
			result = true
			break
		end
		local class = getClass(current)
		current = class and class.Superclass or nil
	end
	superCache[key] = result
	return result
end

local propertyCache = {}
local function findProperty(className: string, propertyName: string)
	local key = className .. "\0" .. propertyName
	local cached = propertyCache[key]
	if cached ~= nil then
		return cached or nil
	end
	local current = className
	local found
	while current do
		local class = getClass(current)
		if not class then
			break
		end
		local property = class.Properties[propertyName]
		if property then
			found = property
			break
		end
		current = class.Superclass
	end
	propertyCache[key] = found or false
	return found
end

local defaultCache = {}
local function defaultValue(className: string, propertyName: string)
	local key = className .. "\0" .. propertyName
	local cached = defaultCache[key]
	if cached ~= nil then
		return cached.value
	end
	local current = className
	local value
	while current do
		local class = getClass(current)
		if not class then
			break
		end
		local defaults = class.DefaultProperties
		if defaults and defaults[propertyName] ~= nil then
			value = defaults[propertyName]
			break
		end
		current = class.Superclass
	end
	defaultCache[key] = { value = Types.fromLune(value) }
	return defaultCache[key].value
end

--------------------------------------------------------------------------------
-- Signals
--------------------------------------------------------------------------------

local Connection = {}
Connection.__index = Connection

function Connection:Disconnect()
	if not self.Connected then
		return
	end
	self.Connected = false
	local signal = self._signal
	local handlers = signal._handlers
	for index = #handlers, 1, -1 do
		if handlers[index] == self then
			table.remove(handlers, index)
			break
		end
	end
	signal._world.counters.connectionsActive -= 1
	-- Roblox drops the handler of a disconnected connection, so holding the
	-- RBXScriptConnection does not keep the handler's upvalues alive.
	self._handler = nil
	self._signal = nil
end
Connection.disconnect = Connection.Disconnect

local Signal = {}
Signal.__index = Signal

local function newSignal(world, name: string, owner: any?)
	local signal = setmetatable({
		_handlers = {},
		_world = world,
		_name = name,
	}, Signal)
	fakeTypes[signal] = "RBXScriptSignal"
	return signal
end

function Signal:Connect(handler)
	if type(handler) ~= "function" then
		error("Attempt to connect failed: Passed value is not a function", 2)
	end
	local connection = setmetatable({
		Connected = true,
		_signal = self,
		_handler = handler,
	}, Connection)
	fakeTypes[connection] = "RBXScriptConnection"
	table.insert(self._handlers, connection)
	local counters = self._world.counters
	counters.connectionsCreated += 1
	counters.connectionsActive += 1
	return connection
end
Signal.connect = Signal.Connect

function Signal:Once(handler)
	local connection
	connection = self:Connect(function(...)
		connection:Disconnect()
		handler(...)
	end)
	return connection
end

function Signal:Wait()
	local thread = coroutine.running()
	local connection
	connection = self:Connect(function(...)
		connection:Disconnect()
		task.spawn(thread, ...)
	end)
	return coroutine.yield()
end
Signal.wait = Signal.Wait

local function recordError(world, message)
	table.insert(world.errors, message)
end

local function guarded(world, fn)
	return function(...)
		local ok, err = xpcall(fn, function(message)
			return debug.traceback(tostring(message), 2)
		end, ...)
		if not ok then
			recordError(world, err)
		end
	end
end
Engine.guarded = guarded

function Signal:Fire(...)
	local snapshot = table.clone(self._handlers)
	for _, connection in snapshot do
		if connection.Connected then
			task.spawn(guarded(self._world, connection._handler), ...)
		end
	end
end

function Signal:ConnectionCount(): number
	return #self._handlers
end

function Signal:DisconnectAll()
	for index = #self._handlers, 1, -1 do
		self._handlers[index]:Disconnect()
	end
end

Engine.newSignal = newSignal

--------------------------------------------------------------------------------
-- Instances
--------------------------------------------------------------------------------

local states = setmetatable({}, { __mode = "k" })

local EVENTS = {
	Instance = {
		"Changed",
		"ChildAdded",
		"ChildRemoved",
		"DescendantAdded",
		"DescendantRemoving",
		"AncestryChanged",
		"Destroying",
		"AttributeChanged",
	},
	GuiObject = {
		"InputBegan",
		"InputChanged",
		"InputEnded",
		"MouseEnter",
		"MouseLeave",
		"MouseMoved",
		"MouseWheelForward",
		"MouseWheelBackward",
		"SelectionGained",
		"SelectionLost",
		"TouchTap",
		"TouchLongPress",
		"TouchPan",
		"TouchPinch",
		"TouchRotate",
		"TouchSwipe",
	},
	GuiButton = {
		"Activated",
		"MouseButton1Click",
		"MouseButton1Down",
		"MouseButton1Up",
		"MouseButton2Click",
		"MouseButton2Down",
		"MouseButton2Up",
	},
	TextBox = { "Focused", "FocusLost", "ReturnPressedFromOnScreenKeyboard" },
	TweenBase = { "Completed" },
}

local eventCache = {}
local function hasEvent(className: string, eventName: string): boolean
	local key = className .. "\0" .. eventName
	local cached = eventCache[key]
	if cached ~= nil then
		return cached
	end
	local result = false
	for baseClass, names in EVENTS do
		if isA(className, baseClass) and table.find(names, eventName) then
			result = true
			break
		end
	end
	eventCache[key] = result
	return result
end

local READ_ONLY = {
	ClassName = true,
	AbsoluteSize = true,
	AbsolutePosition = true,
	AbsoluteRotation = true,
	AbsoluteContentSize = true,
	AbsoluteCanvasSize = true,
	AbsoluteWindowSize = true,
	TextBounds = true,
	TextFits = true,
	ContentText = true,
	ViewportSize = true,
	GuiState = true,
}

local World = {}
World.__index = World

local function fullName(instance): string
	local state = states[instance]
	local names = {}
	local current = instance
	while current and states[current] do
		table.insert(names, 1, states[current].props.Name)
		current = states[current].parent
	end
	return table.concat(names, ".")
end

local function memberError(instance, key: string, level: number?)
	local state = states[instance]
	error(
		string.format('%s is not a valid member of %s "%s"', tostring(key), state.class, fullName(instance)),
		(level or 1) + 1
	)
end

local function getEvent(instance, name: string)
	local state = states[instance]
	local signal = state.events[name]
	if not signal then
		signal = newSignal(state.world, name, instance)
		state.events[name] = signal
	end
	return signal
end

local function getPropertySignal(instance, name: string)
	local state = states[instance]
	local signal = state.propertySignals[name]
	if not signal then
		signal = newSignal(state.world, name .. "Changed", instance)
		state.propertySignals[name] = signal
	end
	return signal
end

local function firePropertyChanged(instance, name: string)
	local state = states[instance]
	local propertySignal = state.propertySignals[name]
	if propertySignal then
		propertySignal:Fire()
	end
	local changed = state.events.Changed
	if changed then
		changed:Fire(name)
	end
end

local function guiParentOf(instance)
	local parent = states[instance].parent
	if parent and states[parent] and isA(states[parent].class, "GuiBase2d") then
		return parent
	end
	return nil
end

local function viewportOf(world)
	return world.viewport
end

local computeAbsoluteSize
local computeAbsolutePosition

function computeAbsoluteSize(instance)
	local state = states[instance]
	local world = state.world
	if isA(state.class, "LayerCollector") then
		return viewportOf(world)
	end
	local parent = guiParentOf(instance)
	local parentSize = parent and computeAbsoluteSize(parent) or viewportOf(world)
	local size = state.props.Size or defaultValue(state.class, "Size")
	if not size then
		return Types.Vector2.new(0, 0)
	end
	return Types.Vector2.new(
		parentSize.X * size.X.Scale + size.X.Offset,
		parentSize.Y * size.Y.Scale + size.Y.Offset
	)
end

function computeAbsolutePosition(instance)
	local state = states[instance]
	if isA(state.class, "LayerCollector") then
		return Types.Vector2.new(0, 0)
	end
	local parent = guiParentOf(instance)
	local parentPosition = parent and computeAbsolutePosition(parent) or Types.Vector2.new(0, 0)
	local parentSize = parent and computeAbsoluteSize(parent) or viewportOf(state.world)
	local position = state.props.Position or defaultValue(state.class, "Position")
	local anchor = state.props.AnchorPoint or defaultValue(state.class, "AnchorPoint") or Types.Vector2.new(0, 0)
	local size = computeAbsoluteSize(instance)
	if not position then
		return parentPosition
	end
	return Types.Vector2.new(
		parentPosition.X + parentSize.X * position.X.Scale + position.X.Offset - anchor.X * size.X,
		parentPosition.Y + parentSize.Y * position.Y.Scale + position.Y.Offset - anchor.Y * size.Y
	)
end

local function computeContentSize(instance)
	local state = states[instance]
	local parent = state.parent
	if not parent then
		return Types.Vector2.new(0, 0)
	end
	local horizontal = state.props.FillDirection == Types.Enum.FillDirection.Horizontal
	local padding = state.props.Padding
	local paddingOffset = padding and padding.Offset or 0
	local total, cross, count = 0, 0, 0
	for _, child in states[parent].children do
		local childState = states[child]
		if isA(childState.class, "GuiObject") and childState.props.Visible ~= false then
			local size = computeAbsoluteSize(child)
			count += 1
			if horizontal then
				total += size.X
				cross = math.max(cross, size.Y)
			else
				total += size.Y
				cross = math.max(cross, size.X)
			end
		end
	end
	if count > 1 then
		total += paddingOffset * (count - 1)
	end
	if horizontal then
		return Types.Vector2.new(total, cross)
	end
	return Types.Vector2.new(cross, total)
end

local function computeTextBounds(instance)
	local state = states[instance]
	local text = state.props.Text or ""
	local size = state.props.TextSize or 14
	local length = utf8.len(text) or #text
	if length == 0 then
		return Types.Vector2.new(0, 0)
	end
	return Types.Vector2.new(length * size * 0.5, size)
end

local COMPUTED = {
	AbsoluteSize = computeAbsoluteSize,
	AbsolutePosition = computeAbsolutePosition,
	AbsoluteContentSize = computeContentSize,
	TextBounds = computeTextBounds,
	AbsoluteRotation = function()
		return 0
	end,
	AbsoluteCanvasSize = function(instance)
		return computeAbsoluteSize(instance)
	end,
	AbsoluteWindowSize = function(instance)
		return computeAbsoluteSize(instance)
	end,
	TextFits = function()
		return true
	end,
	ContentText = function(instance)
		return states[instance].props.Text or ""
	end,
}

local function coerceProperty(instance, name: string, value: any, descriptor)
	local datatype = descriptor and Types.describeDatatype(descriptor.Datatype)
	if not datatype then
		return value
	end
	local kind, enumName = datatype.kind, datatype.enum
	if kind == "String" or kind == "Content" then
		if type(value) == "number" then
			return tostring(value)
		end
		if type(value) ~= "string" then
			error(string.format("invalid argument #3 (string expected, got %s)", typeofValue(value)), 3)
		end
		return value
	elseif kind == "Number" then
		local number = tonumber(value)
		if number == nil then
			error(string.format("invalid argument #3 (number expected, got %s)", typeofValue(value)), 3)
		end
		return number
	elseif kind == "Bool" then
		if type(value) ~= "boolean" then
			error(string.format("invalid argument #3 (boolean expected, got %s)", typeofValue(value)), 3)
		end
		return value
	elseif kind == "Enum" then
		local item = Types.coerceEnum(enumName, value)
		if item == nil then
			error(string.format('Invalid value "%s" for enum %s', tostring(value), tostring(enumName)), 3)
		end
		return item
	elseif kind == "Ref" then
		if value ~= nil and typeofValue(value) ~= "Instance" then
			error(string.format("invalid argument #3 (Instance expected, got %s)", typeofValue(value)), 3)
		end
		return value
	elseif kind == "Datatype" then
		local actual = typeofValue(value)
		if actual ~= datatype.name then
			error(
				string.format("invalid argument #3 (%s expected, got %s)", datatype.name, actual),
				3
			)
		end
		return value
	end
	return value
end

local function setParent(instance, newParent)
	local state = states[instance]
	if state.parentLocked then
		error(
			string.format(
				"The Parent property of %s is locked, current parent: NULL, new parent %s",
				state.props.Name,
				newParent and states[newParent] and states[newParent].props.Name or "NULL"
			),
			3
		)
	end
	if newParent ~= nil then
		if typeofValue(newParent) ~= "Instance" or not states[newParent] then
			error("invalid argument #3 (Instance expected, got " .. typeofValue(newParent) .. ")", 3)
		end
		local cursor = newParent
		while cursor do
			if cursor == instance then
				error("Attempt to set parent of " .. state.props.Name .. " to itself or a descendant", 3)
			end
			cursor = states[cursor].parent
		end
	end
	local oldParent = state.parent
	if oldParent == newParent then
		return
	end
	if oldParent then
		local siblings = states[oldParent].children
		local index = table.find(siblings, instance)
		if index then
			table.remove(siblings, index)
		end
	end
	state.parent = newParent
	if newParent then
		table.insert(states[newParent].children, instance)
	end
	state.world.counters.propertyWrites += 1
	firePropertyChanged(instance, "Parent")
	if oldParent and states[oldParent].events.ChildRemoved then
		states[oldParent].events.ChildRemoved:Fire(instance)
	end
	if newParent and states[newParent].events.ChildAdded then
		states[newParent].events.ChildAdded:Fire(instance)
	end
	if state.events.AncestryChanged then
		state.events.AncestryChanged:Fire(instance, newParent)
	end
end

local InstanceMT = {}

local function destroyInstance(instance)
	local state = states[instance]
	if state.destroyed then
		return
	end
	state.destroyed = true
	if state.events.Destroying then
		state.events.Destroying:Fire()
	end
	for _, child in table.clone(state.children) do
		destroyInstance(child)
	end
	if state.parent then
		state.parentLocked = false
		setParent(instance, nil)
	end
	state.parentLocked = true
	for _, signal in state.events do
		signal:DisconnectAll()
	end
	for _, signal in state.propertySignals do
		signal:DisconnectAll()
	end
	local counters = state.world.counters
	counters.instancesAlive -= 1
	counters.instancesDestroyed += 1
end

local METHODS = {}

function METHODS.IsA(self, className)
	return isA(states[self].class, className)
end

function METHODS.GetChildren(self)
	return table.clone(states[self].children)
end

function METHODS.GetDescendants(self)
	local result = {}
	local function walk(instance)
		for _, child in states[instance].children do
			table.insert(result, child)
			walk(child)
		end
	end
	walk(self)
	return result
end

function METHODS.FindFirstChild(self, name, recursive)
	if name == nil then
		error("Argument 1 missing or nil", 2)
	end
	for _, child in states[self].children do
		if states[child].props.Name == name then
			return child
		end
	end
	if recursive then
		for _, child in states[self].children do
			local found = METHODS.FindFirstChild(child, name, true)
			if found then
				return found
			end
		end
	end
	return nil
end

function METHODS.FindFirstChildOfClass(self, className)
	for _, child in states[self].children do
		if states[child].class == className then
			return child
		end
	end
	return nil
end

function METHODS.FindFirstChildWhichIsA(self, className, recursive)
	for _, child in states[self].children do
		if isA(states[child].class, className) then
			return child
		end
	end
	if recursive then
		for _, child in states[self].children do
			local found = METHODS.FindFirstChildWhichIsA(child, className, true)
			if found then
				return found
			end
		end
	end
	return nil
end

function METHODS.FindFirstAncestorOfClass(self, className)
	local current = states[self].parent
	while current do
		if states[current].class == className then
			return current
		end
		current = states[current].parent
	end
	return nil
end

function METHODS.IsDescendantOf(self, ancestor)
	local current = states[self].parent
	while current do
		if current == ancestor then
			return true
		end
		current = states[current].parent
	end
	return false
end

function METHODS.IsAncestorOf(self, descendant)
	return METHODS.IsDescendantOf(descendant, self)
end

function METHODS.Destroy(self)
	destroyInstance(self)
end

function METHODS.ClearAllChildren(self)
	for _, child in table.clone(states[self].children) do
		destroyInstance(child)
	end
end

function METHODS.GetPropertyChangedSignal(self, name)
	local state = states[self]
	if not findProperty(state.class, name) and name ~= "Parent" and name ~= "Name" then
		memberError(self, name, 2)
	end
	return getPropertySignal(self, name)
end

function METHODS.GetFullName(self)
	return fullName(self)
end

function METHODS.WaitForChild(self, name, timeout)
	local existing = METHODS.FindFirstChild(self, name)
	if existing then
		return existing
	end
	local signal = getEvent(self, "ChildAdded")
	local deadline = timeout and (os.clock() + timeout)
	while true do
		local child = signal:Wait()
		if states[child].props.Name == name then
			return child
		end
		if deadline and os.clock() > deadline then
			return nil
		end
	end
end

function METHODS.GetAttribute(self, name)
	return states[self].attributes[name]
end

function METHODS.SetAttribute(self, name, value)
	states[self].attributes[name] = value
	if states[self].events.AttributeChanged then
		states[self].events.AttributeChanged:Fire(name)
	end
end

function METHODS.GetAttributes(self)
	return table.clone(states[self].attributes)
end

function METHODS.Clone(self)
	local state = states[self]
	local copy = state.world:newInstance(state.class)
	for key, value in state.props do
		states[copy].props[key] = value
	end
	for _, child in state.children do
		local childCopy = METHODS.Clone(child)
		setParent(childCopy, copy)
	end
	return copy
end

-- TextBox
function METHODS.CaptureFocus(self)
	local world = states[self].world
	world:focusTextBox(self)
end

function METHODS.ReleaseFocus(self, submitted)
	local world = states[self].world
	if world.focusedTextBox == self then
		world:releaseTextBox(submitted == true)
	end
end

function METHODS.IsFocused(self)
	return states[self].world.focusedTextBox == self
end

local CLASS_METHODS = {
	CaptureFocus = "TextBox",
	ReleaseFocus = "TextBox",
	IsFocused = "TextBox",
}

InstanceMT.__index = function(self, key)
	local state = states[self]
	local extra = state.extra
	if extra then
		local value = extra[key]
		if value ~= nil then
			return value
		end
	end
	if key == "Parent" then
		return state.parent
	elseif key == "ClassName" then
		return state.class
	elseif key == "Name" then
		return state.props.Name
	end
	local method = METHODS[key]
	if method then
		local requiredClass = CLASS_METHODS[key]
		if requiredClass == nil or isA(state.class, requiredClass) then
			return method
		end
	end
	if hasEvent(state.class, key) then
		return getEvent(self, key)
	end
	local computed = COMPUTED[key]
	if computed and findProperty(state.class, key) then
		return computed(self)
	end
	local stored = state.props[key]
	if stored ~= nil then
		return stored
	end
	if findProperty(state.class, key) then
		return defaultValue(state.class, key)
	end
	for _, child in state.children do
		if states[child].props.Name == key then
			return child
		end
	end
	memberError(self, key, 2)
	return nil
end

InstanceMT.__newindex = function(self, key, value)
	local state = states[self]
	if state.extraWritable and state.extraWritable[key] then
		state.extra[key] = value
		return
	end
	if key == "Parent" then
		setParent(self, value)
		return
	end
	if READ_ONLY[key] then
		error(string.format("Unable to assign property %s. Property is read only", key), 2)
	end
	local descriptor = findProperty(state.class, key)
	if not descriptor and key ~= "Name" then
		memberError(self, key, 2)
	end
	if key == "Name" then
		value = tostring(value)
	end
	value = coerceProperty(self, key, value, descriptor)
	state.world.counters.propertyWrites += 1
	local previous = state.props[key]
	if previous == nil then
		previous = defaultValue(state.class, key)
	end
	state.props[key] = value
	if key == "FontFace" and state.props.Font == nil then
		state.props.Font = Types.Enum.Font.Unknown
	elseif key == "Font" then
		state.props.FontFace = Types.fontFromEnum(value) or state.props.FontFace
	end
	if previous ~= value then
		firePropertyChanged(self, key)
	end
end

InstanceMT.__tostring = function(self)
	return states[self].props.Name
end

InstanceMT.__metatable = "The metatable is locked"

-- Classes whose freshly created instances are not named after the class.
-- The reflection database does not carry default names.
local DEFAULT_NAMES = {
	SpecialMesh = "Mesh",
	BlockMesh = "Mesh",
	CylinderMesh = "Mesh",
	FileMesh = "Mesh",
}

function World:newInstance(className: string, parent: any?)
	if type(className) ~= "string" then
		error("invalid argument #1 to 'new' (string expected)", 2)
	end
	local class = getClass(className)
	if not class then
		error("Unable to create an Instance of type \"" .. className .. "\"", 2)
	end
	local instance = setmetatable({}, InstanceMT)
	fakeTypes[instance] = "Instance"
	states[instance] = {
		world = self,
		class = className,
		props = { Name = DEFAULT_NAMES[className] or className },
		children = {},
		events = {},
		propertySignals = {},
		attributes = {},
		parent = nil,
		destroyed = false,
		parentLocked = false,
	}
	self.counters.instancesCreated += 1
	self.counters.instancesAlive += 1
	states[instance].id = self.counters.instancesCreated
	self.allInstances[instance] = true
	if parent ~= nil then
		setParent(instance, parent)
	end
	return instance
end

function World:newService(className: string, extra: { [string]: any }?, writable: { [string]: boolean }?)
	local service = self:newInstance(className)
	local state = states[service]
	state.extra = extra or {}
	state.extraWritable = writable
	state.parent = nil
	return service
end

function World:setExtra(instance, key: string, value: any)
	local state = states[instance]
	state.extra = state.extra or {}
	state.extra[key] = value
end

--------------------------------------------------------------------------------
-- Input objects and the mouse
--------------------------------------------------------------------------------

local function newInputObject(world, fields)
	local data = {}
	for key, value in fields do
		data[key] = value
	end
	data.Delta = data.Delta or Types.Vector3.new(0, 0, 0)
	data.Position = data.Position or Types.Vector3.new(world.mouse.X, world.mouse.Y, 0)
	data.KeyCode = data.KeyCode or Types.Enum.KeyCode.Unknown
	local changed = newSignal(world, "Changed")
	local proxy = setmetatable({}, {
		__index = function(_, key)
			if key == "Changed" then
				return changed
			end
			if key == "GetPropertyChangedSignal" then
				return function(_, name)
					return changed
				end
			end
			return data[key]
		end,
		__newindex = function(_, key, value)
			data[key] = value
			changed:Fire(key)
		end,
	})
	fakeTypes[proxy] = "InputObject"
	return proxy
end

--------------------------------------------------------------------------------
-- World construction
--------------------------------------------------------------------------------

export type WorldOptions = {
	viewport: { X: number, Y: number }?,
	touchEnabled: boolean?,
	keyboardEnabled: boolean?,
	fileSystem: boolean?,
	customAssets: boolean?,
	clipboard: boolean?,
	request: ((options: { [string]: any }) -> any)?,
	requestAvailable: boolean?,
}

function Engine.new(options: WorldOptions?)
	options = options or {}
	local self = setmetatable({}, World)
	self.counters = {
		propertyWrites = 0,
		instancesCreated = 0,
		instancesAlive = 0,
		instancesDestroyed = 0,
		connectionsCreated = 0,
		connectionsActive = 0,
	}
	self.allInstances = setmetatable({}, { __mode = "k" })
	self.now = 0
	local viewportOption = options.viewport or { X = 1280, Y = 720 }
	self.viewport = Types.Vector2.new(viewportOption.X, viewportOption.Y)
	self.keysDown = {}
	self.mouseButtonsDown = {}
	self.focusedTextBox = nil
	self.mouse = { X = 0, Y = 0 }
	self.requests = {}
	self.clipboard = nil
	self.files = {}
	self.folders = { [""] = true }
	self.warnings = {}
	self.prints = {}
	self.errors = {}
	self.genv = {}

	-- Services -----------------------------------------------------------
	local world = self

	self.RunService = self:newService("RunService", {
		RenderStepped = newSignal(self, "RenderStepped"),
		Heartbeat = newSignal(self, "Heartbeat"),
		Stepped = newSignal(self, "Stepped"),
		PreRender = newSignal(self, "PreRender"),
		IsStudio = function()
			return false
		end,
		IsClient = function()
			return true
		end,
		IsServer = function()
			return false
		end,
		IsRunning = function()
			return true
		end,
	})

	self.UserInputService = self:newService("UserInputService", {
		InputBegan = newSignal(self, "InputBegan"),
		InputChanged = newSignal(self, "InputChanged"),
		InputEnded = newSignal(self, "InputEnded"),
		WindowFocused = newSignal(self, "WindowFocused"),
		WindowFocusReleased = newSignal(self, "WindowFocusReleased"),
		TextBoxFocused = newSignal(self, "TextBoxFocused"),
		TextBoxFocusReleased = newSignal(self, "TextBoxFocusReleased"),
		LastInputTypeChanged = newSignal(self, "LastInputTypeChanged"),
		TouchEnabled = options.touchEnabled == true,
		KeyboardEnabled = options.keyboardEnabled ~= false,
		MouseEnabled = options.touchEnabled ~= true,
		GamepadEnabled = false,
		-- Lune creates a new EnumItem userdata on every access, so input
		-- state is keyed by item name rather than by identity.
		IsKeyDown = function(_, keyCode)
			return keyCode ~= nil and world.keysDown[keyCode.Name] == true
		end,
		IsMouseButtonPressed = function(_, inputType)
			return inputType ~= nil and world.mouseButtonsDown[inputType.Name] == true
		end,
		GetFocusedTextBox = function()
			return world.focusedTextBox
		end,
		GetMouseLocation = function()
			return Types.Vector2.new(world.mouse.X, world.mouse.Y)
		end,
	})

	self.TweenService = self:newService("TweenService", {
		Create = function(_, instance, info, goals)
			return world:createTween(instance, info, goals)
		end,
	})

	self.HttpService = self:newService("HttpService", {
		JSONEncode = function(_, value)
			return JSON.encode(value)
		end,
		JSONDecode = function(_, value)
			return JSON.decode(value)
		end,
		GenerateGUID = function(_, wrap)
			local guid = string.format("%08x-0000-4000-8000-%012x", math.random(0, 0xffffffff), math.random(0, 0xffffff))
			return wrap == false and guid or "{" .. guid .. "}"
		end,
	})

	self.TextService = self:newService("TextService", {
		GetTextSize = function(_, text, size, font, frameSize)
			if Engine.typeof(font) ~= "EnumItem" then
				error("Unable to cast Font to token", 2)
			end
			local length = utf8.len(text) or #text
			return Types.Vector2.new(length * size * 0.5, size)
		end,
	})

	self.LocalizationService = self:newService("LocalizationService", {
		RobloxLocaleId = "en-us",
		SystemLocaleId = "en-us",
		GetTranslatorForLocaleAsync = function(_, locale)
			local translator = {
				LocaleId = locale,
				Translate = function(_, context, text)
					return text
				end,
			}
			fakeTypes[translator] = "Instance"
			return translator
		end,
	})

	self.ContentProvider = self:newService("ContentProvider", {
		PreloadAsync = function() end,
	})

	self.TouchInputService = self:newService("TouchInputService", {})

	self.CoreGui = self:newService("CoreGui")
	self.Lighting = self:newService("Lighting")
	self.StarterGui = self:newService("StarterGui")

	local camera = self:newInstance("Camera")
	self.Camera = camera
	states[camera].extra = {
		ViewportSize = self.viewport,
		ScreenPointToRay = function(_, x, y, depth)
			return Types.Ray.new(Types.Vector3.new(0, 0, 0), Types.Vector3.new(0, 0, -1))
		end,
		ViewportPointToRay = function(_, x, y, depth)
			return Types.Ray.new(Types.Vector3.new(0, 0, 0), Types.Vector3.new(0, 0, -1))
		end,
	}
	self.Workspace = self:newService("Workspace", { CurrentCamera = camera }, { CurrentCamera = true })
	states[camera].parent = self.Workspace
	table.insert(states[self.Workspace].children, camera)

	local playerGui = self:newInstance("PlayerGui")
	self.PlayerGui = playerGui
	local mouseObject = setmetatable({}, {
		__index = function(_, key)
			if key == "X" then
				return world.mouse.X
			elseif key == "Y" then
				return world.mouse.Y
			elseif key == "Hit" then
				return Types.CFrame.new()
			end
			return nil
		end,
	})
	fakeTypes[mouseObject] = "Instance"
	self.MouseObject = mouseObject
	local player = self:newInstance("Player")
	states[player].props.Name = "TestPlayer"
	states[player].extra = {
		GetMouse = function()
			return mouseObject
		end,
		UserId = 1,
		DisplayName = "TestPlayer",
	}
	setParent(playerGui, player)
	self.LocalPlayer = player
	self.Players = self:newService("Players", { LocalPlayer = player })
	setParent(player, self.Players)

	local services = {
		RunService = self.RunService,
		UserInputService = self.UserInputService,
		TweenService = self.TweenService,
		HttpService = self.HttpService,
		TextService = self.TextService,
		LocalizationService = self.LocalizationService,
		ContentProvider = self.ContentProvider,
		TouchInputService = self.TouchInputService,
		CoreGui = self.CoreGui,
		Lighting = self.Lighting,
		StarterGui = self.StarterGui,
		Workspace = self.Workspace,
		Players = self.Players,
	}
	self.services = services

	self.game = self:newService("DataModel", {
		GetService = function(_, name)
			local service = services[name]
			if not service then
				error("'" .. tostring(name) .. "' is not a valid Service name", 2)
			end
			return service
		end,
		FindService = function(_, name)
			return services[name]
		end,
		Workspace = self.Workspace,
		Players = self.Players,
		Lighting = self.Lighting,
		CoreGui = self.CoreGui,
	})
	states[self.game].props.Name = "Game"
	for _, service in services do
		if states[service].parent == nil then
			states[service].parent = self.game
			table.insert(states[self.game].children, service)
		end
	end

	-- Executor API --------------------------------------------------------
	self.executor = self:buildExecutor(options)
	self.env = self:buildEnvironment()
	return self
end

--------------------------------------------------------------------------------
-- Tweens
--------------------------------------------------------------------------------

function World:createTween(instance, info, goals)
	if Engine.typeof(instance) ~= "Instance" then
		error("Unable to cast value to Object", 3)
	end
	if Engine.typeof(info) ~= "TweenInfo" then
		error("Unable to cast value to TweenInfo", 3)
	end
	if type(goals) ~= "table" then
		error("Unable to cast to Dictionary", 3)
	end
	local world = self
	local tween = self:newInstance("Tween")
	local completed = getEvent(tween, "Completed")
	local playbackState = Types.Enum.PlaybackState.Begin
	states[tween].extra = {
		Instance = instance,
		TweenInfo = info,
		Play = function()
			playbackState = Types.Enum.PlaybackState.Playing
			for key, value in goals do
				instance[key] = value
			end
			playbackState = Types.Enum.PlaybackState.Completed
			task.defer(function()
				completed:Fire(Types.Enum.PlaybackState.Completed)
			end)
		end,
		Cancel = function()
			playbackState = Types.Enum.PlaybackState.Cancelled
		end,
		Pause = function()
			playbackState = Types.Enum.PlaybackState.Paused
		end,
	}
	setmetatable(states[tween].extra, {
		__index = function(_, key)
			if key == "PlaybackState" then
				return playbackState
			end
			return nil
		end,
	})
	world.counters.tweensCreated = (world.counters.tweensCreated or 0) + 1
	return tween
end

--------------------------------------------------------------------------------
-- Simulated time and input
--------------------------------------------------------------------------------

function World:step(dt: number?, count: number?)
	dt = dt or 1 / 60
	for _ = 1, count or 1 do
		self.now += dt
		states[self.RunService].extra.Stepped:Fire(self.now, dt)
		states[self.RunService].extra.RenderStepped:Fire(dt)
		states[self.RunService].extra.Heartbeat:Fire(dt)
	end
end

function World:settle(seconds: number?)
	self:step(1 / 60, math.floor((seconds or 2) * 60))
end

-- Steps the frame clock in real time (60 Hz) until the returned function is
-- called. Used when running whole scripts that sample Heartbeat themselves.
function World:startClock()
	local running = true
	task.spawn(function()
		while running do
			self:step(1 / 60)
			task.wait(1 / 60)
		end
	end)
	return function()
		running = false
	end
end

local function uis(world)
	return states[world.UserInputService].extra
end

local function keyCode(name)
	if type(name) == "string" then
		return Types.Enum.KeyCode[name]
	end
	return name
end

function World:pressKey(name, gameProcessed: boolean?)
	local code = keyCode(name)
	self.keysDown[code.Name] = true
	local input = newInputObject(self, {
		KeyCode = code,
		UserInputType = Types.Enum.UserInputType.Keyboard,
		UserInputState = Types.Enum.UserInputState.Begin,
	})
	self.lastKeyInputs = self.lastKeyInputs or {}
	self.lastKeyInputs[code.Name] = input
	uis(self).InputBegan:Fire(input, gameProcessed == true)
	return input
end

function World:releaseKey(name, gameProcessed: boolean?)
	local code = keyCode(name)
	self.keysDown[code.Name] = nil
	local input = (self.lastKeyInputs and self.lastKeyInputs[code.Name])
		or newInputObject(self, {
			KeyCode = code,
			UserInputType = Types.Enum.UserInputType.Keyboard,
		})
	input.UserInputState = Types.Enum.UserInputState.End
	uis(self).InputEnded:Fire(input, gameProcessed == true)
	return input
end

function World:tapKey(name, gameProcessed: boolean?)
	self:pressKey(name, gameProcessed)
	self:releaseKey(name, gameProcessed)
end

function World:loseWindowFocus()
	self.keysDown = {}
	uis(self).WindowFocusReleased:Fire()
end

function World:moveMouse(x: number, y: number)
	local delta = Types.Vector3.new(x - self.mouse.X, y - self.mouse.Y, 0)
	self.mouse.X, self.mouse.Y = x, y
	local input = newInputObject(self, {
		UserInputType = Types.Enum.UserInputType.MouseMovement,
		UserInputState = Types.Enum.UserInputState.Change,
		Position = Types.Vector3.new(x, y, 0),
		Delta = delta,
	})
	uis(self).InputChanged:Fire(input, false)
	return input
end

--[[
	Simulates pressing a mouse button over `target` (a GuiObject). The
	target's own InputBegan/MouseButton1Down fire, then UserInputService's.
	Returns the InputObject so the caller can release it.
]]
function World:mouseDown(target, button: string?)
	local inputType = Types.Enum.UserInputType[button or "MouseButton1"]
	self.mouseButtonsDown[inputType.Name] = true
	local input = newInputObject(self, {
		UserInputType = inputType,
		UserInputState = Types.Enum.UserInputState.Begin,
		Position = Types.Vector3.new(self.mouse.X, self.mouse.Y, 0),
	})
	if target then
		local state = states[target]
		if state.events.InputBegan then
			state.events.InputBegan:Fire(input)
		end
		if inputType == Types.Enum.UserInputType.MouseButton1 and state.events.MouseButton1Down then
			state.events.MouseButton1Down:Fire(self.mouse.X, self.mouse.Y)
		end
	end
	uis(self).InputBegan:Fire(input, target ~= nil)
	return input
end

function World:mouseUp(target, input, button: string?)
	local inputType = Types.Enum.UserInputType[button or "MouseButton1"]
	self.mouseButtonsDown[inputType.Name] = nil
	input = input
		or newInputObject(self, {
			UserInputType = inputType,
			Position = Types.Vector3.new(self.mouse.X, self.mouse.Y, 0),
		})
	input.UserInputState = Types.Enum.UserInputState.End
	if target then
		local state = states[target]
		if state.events.InputEnded then
			state.events.InputEnded:Fire(input)
		end
		if inputType == Types.Enum.UserInputType.MouseButton1 then
			if state.events.MouseButton1Up then
				state.events.MouseButton1Up:Fire(self.mouse.X, self.mouse.Y)
			end
			if state.events.MouseButton1Click then
				state.events.MouseButton1Click:Fire()
			end
			if state.events.Activated then
				state.events.Activated:Fire(input, 1)
			end
		end
	end
	uis(self).InputEnded:Fire(input, target ~= nil)
	return input
end

function World:click(target)
	local input = self:mouseDown(target)
	self:mouseUp(target, input)
end

function World:hover(target, inside: boolean)
	local state = states[target]
	local event = inside and state.events.MouseEnter or state.events.MouseLeave
	if event then
		event:Fire(self.mouse.X, self.mouse.Y)
	end
end

function World:touch(target)
	local input = newInputObject(self, {
		UserInputType = Types.Enum.UserInputType.Touch,
		UserInputState = Types.Enum.UserInputState.Begin,
		Position = Types.Vector3.new(self.mouse.X, self.mouse.Y, 0),
	})
	if target then
		local state = states[target]
		if state.events.InputBegan then
			state.events.InputBegan:Fire(input)
		end
	end
	uis(self).InputBegan:Fire(input, target ~= nil)
	input.UserInputState = Types.Enum.UserInputState.End
	if target then
		local state = states[target]
		if state.events.InputEnded then
			state.events.InputEnded:Fire(input)
		end
		if state.events.Activated then
			state.events.Activated:Fire(input, 1)
		end
	end
	uis(self).InputEnded:Fire(input, target ~= nil)
	return input
end

function World:focusTextBox(textBox)
	if self.focusedTextBox and self.focusedTextBox ~= textBox then
		self:releaseTextBox(false)
	end
	self.focusedTextBox = textBox
	local state = states[textBox]
	if state.events.Focused then
		state.events.Focused:Fire()
	end
	uis(self).TextBoxFocused:Fire(textBox)
end

function World:releaseTextBox(enterPressed: boolean)
	local textBox = self.focusedTextBox
	if not textBox then
		return
	end
	self.focusedTextBox = nil
	local state = states[textBox]
	if state.events.FocusLost then
		state.events.FocusLost:Fire(enterPressed, nil)
	end
	uis(self).TextBoxFocusReleased:Fire(textBox)
end

function World:typeInto(textBox, text: string, enterPressed: boolean?)
	self:focusTextBox(textBox)
	textBox.Text = text
	self:releaseTextBox(enterPressed ~= false)
end

function World:setViewport(x: number, y: number)
	self.viewport = Types.Vector2.new(x, y)
	states[self.Camera].extra.ViewportSize = self.viewport
	firePropertyChanged(self.Camera, "ViewportSize")
end

-- Fires AbsolutePosition/AbsoluteSize change signals for every instance in
-- the subtree, as the engine does when layout moves (dragging a window).
function World:bumpLayout(root)
	local function walk(instance)
		local state = states[instance]
		for _, name in { "AbsolutePosition", "AbsoluteSize" } do
			local signal = state.propertySignals[name]
			if signal then
				signal:Fire()
			end
		end
		for _, child in state.children do
			walk(child)
		end
	end
	walk(root)
end

function World:stateOf(instance)
	return states[instance]
end

function World:isDestroyed(instance): boolean
	local state = states[instance]
	return state == nil or state.destroyed
end

function World:connectionCount(signal): number
	return #signal._handlers
end

function World:renderSteppedConnections(): number
	return #states[self.RunService].extra.RenderStepped._handlers
end

function World:heartbeatConnections(): number
	return #states[self.RunService].extra.Heartbeat._handlers
end

--------------------------------------------------------------------------------
-- Executor API
--------------------------------------------------------------------------------

local function normalizePath(path: string): string
	path = tostring(path):gsub("\\", "/"):gsub("/+", "/"):gsub("^/", ""):gsub("/$", "")
	return path
end

function World:buildExecutor(options)
	local world = self
	local executor = {}
	if options.fileSystem ~= false then
		function executor.writefile(path, contents)
			path = normalizePath(path)
			local folder = path:match("^(.*)/[^/]+$")
			if folder and not world.folders[folder] then
				error("Folder does not exist: " .. folder, 2)
			end
			if type(contents) ~= "string" then
				error("invalid argument #2 to 'writefile' (string expected)", 2)
			end
			world.files[path] = contents
		end
		function executor.readfile(path)
			path = normalizePath(path)
			local contents = world.files[path]
			if contents == nil then
				error("File does not exist: " .. path, 2)
			end
			return contents
		end
		function executor.isfile(path)
			return world.files[normalizePath(path)] ~= nil
		end
		function executor.isfolder(path)
			return world.folders[normalizePath(path)] == true
		end
		function executor.makefolder(path)
			path = normalizePath(path)
			local parent = path:match("^(.*)/[^/]+$")
			if parent and not world.folders[parent] then
				error("Parent folder does not exist: " .. parent, 2)
			end
			world.folders[path] = true
		end
		function executor.listfiles(path)
			path = normalizePath(path)
			local result = {}
			for filePath in world.files do
				local folder = filePath:match("^(.*)/[^/]+$") or ""
				if folder == path then
					table.insert(result, filePath)
				end
			end
			for folderPath in world.folders do
				local folder = folderPath:match("^(.*)/[^/]+$") or ""
				if folderPath ~= "" and folder == path then
					table.insert(result, folderPath)
				end
			end
			table.sort(result)
			return result
		end
		function executor.delfile(path)
			path = normalizePath(path)
			if world.files[path] == nil then
				error("File does not exist: " .. path, 2)
			end
			world.files[path] = nil
		end
		function executor.delfolder(path)
			world.folders[normalizePath(path)] = nil
		end
	end
	if options.customAssets ~= false and options.fileSystem ~= false then
		function executor.getcustomasset(path)
			path = normalizePath(path)
			if world.files[path] == nil then
				error("File does not exist: " .. path, 2)
			end
			return "rbxasset://customasset/" .. path
		end
	end
	if options.clipboard ~= false then
		function executor.setclipboard(text)
			world.clipboard = tostring(text)
		end
	end
	if options.requestAvailable ~= false then
		function executor.request(requestOptions)
			table.insert(world.requests, requestOptions)
			if options.request then
				return options.request(requestOptions)
			end
			return {
				Success = false,
				StatusCode = 503,
				StatusMessage = "Service Unavailable (fake)",
				Headers = {},
				Body = "",
			}
		end
	end
	function executor.getgenv()
		return world.genv
	end
	function executor.identifyexecutor()
		return "FakeExecutor", "1.0.0"
	end
	return executor
end

--------------------------------------------------------------------------------
-- Global environment for loaded chunks
--------------------------------------------------------------------------------

function World:buildEnvironment()
	local world = self
	local env = {}
	for key, value in Types.globals() do
		env[key] = value
	end
	env.typeof = typeofValue
	env.game = self.game
	env.workspace = self.Workspace
	env.Instance = {
		new = function(className, parent)
			return world:newInstance(className, parent)
		end,
	}
	env.os = {
		clock = function()
			return world.now
		end,
		time = os.time,
		date = os.date,
		difftime = os.difftime,
	}
	env.tick = function()
		return world.now
	end
	env.time = function()
		return world.now
	end
	-- Threads started by the library report errors into world.errors so a
	-- failure inside a spawned callback fails the test instead of only
	-- printing to stderr.
	local function wrapTarget(target)
		if type(target) == "function" then
			return guarded(world, target)
		end
		return target
	end
	env.task = {
		spawn = function(target, ...)
			return task.spawn(wrapTarget(target), ...)
		end,
		defer = function(target, ...)
			return task.defer(wrapTarget(target), ...)
		end,
		delay = function(seconds, target, ...)
			return task.delay(seconds, wrapTarget(target), ...)
		end,
		wait = task.wait,
		cancel = task.cancel,
	}
	env.wait = function(seconds)
		return task.wait(seconds)
	end
	env.delay = env.task.delay
	env.spawn = env.task.spawn
	env.warn = function(...)
		local parts = {}
		for index = 1, select("#", ...) do
			table.insert(parts, tostring((select(index, ...))))
		end
		table.insert(world.warnings, table.concat(parts, " "))
	end
	env.print = function(...)
		local parts = {}
		for index = 1, select("#", ...) do
			table.insert(parts, tostring((select(index, ...))))
		end
		table.insert(world.prints, table.concat(parts, " "))
	end
	env.shared = {}
	env._G = env
	env.script = nil
	-- Executors return their shared global table from getgenv(); scripts see
	-- writes to it as globals. Mirror that by using the environment itself.
	for key, value in world.genv do
		env[key] = value
	end
	world.genv = env
	env.loadstring = function(source, chunkName)
		local ok, result = pcall(luau.load, source, {
			debugName = chunkName or "loadstring",
			environment = env,
			injectGlobals = true,
		})
		if not ok then
			return nil, tostring(result)
		end
		return result
	end
	env.firesignal = function(signal, ...)
		signal:Fire(...)
	end
	for key, value in self.executor do
		env[key] = value
	end
	env.getgenv = function()
		return world.genv
	end
	-- Instrumentation for plan item P9: record whether the bundler ever
	-- asks for an environment.
	world.fenvCalls = { getfenv = 0, setfenv = 0 }
	env.getfenv = function(...)
		world.fenvCalls.getfenv += 1
		return getfenv(...)
	end
	env.setfenv = function(...)
		world.fenvCalls.setfenv += 1
		return setfenv(...)
	end
	return env
end

return Engine
