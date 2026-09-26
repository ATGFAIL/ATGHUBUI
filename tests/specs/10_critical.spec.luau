--[[
	Phase 1 (critical bugs). Each test here was written to fail on the code
	before the fix, then the fix made it pass. Test names carry the plan item.
]]

local task = require("@lune/task")

local Boot = require("../harness/boot")
local KitchenSink = require("../harness/kitchen_sink")
local Leaks = require("../harness/leaks")

local function newWindow(context, extra)
	local env = context.world.env
	local config = {
		Title = "Critical",
		SubTitle = "spec",
		TabWidth = 160,
		Size = env.UDim2.fromOffset(580, 460),
		Acrylic = false,
		Theme = "Dark",
		MinimizeKey = env.Enum.KeyCode.LeftControl,
	}
	for key, value in extra or {} do
		config[key] = value
	end
	return context.Library:CreateWindow(config)
end

local function assertNoErrors(t, world)
	t.equal(#world.errors, 0, "engine errors:\n" .. table.concat(world.errors, "\n---\n"))
end

local function addScreenGuis(world, parent, names)
	local created = {}
	for _, name in names do
		local gui = world.env.Instance.new("ScreenGui")
		gui.Name = name
		gui.Parent = parent
		created[name] = gui
	end
	return created
end

local function childNames(parent)
	local names = {}
	for _, child in parent:GetChildren() do
		-- The splash screen removes itself on a timer; ignore it.
		if child.Name ~= "CoreSplash" then
			table.insert(names, child.Name)
		end
	end
	table.sort(names)
	return table.concat(names, ",")
end

local function clearButtonOf(world, Library)
	return KitchenSink.findDescendant(world, Library.GUI, function(_, state)
		return state.class == "TextButton" and state.props.Text == "❌"
	end)
end

local function openDropdown(world, dropdown)
	local button = KitchenSink.findDescendant(world, dropdown.Frame, function(_, state)
		return state.class == "TextButton"
	end)
	world:click(button)
	task.wait(0.05)
	return button
end

local function sortedKeys(value)
	local keys = {}
	for key, enabled in value do
		table.insert(keys, tostring(key) .. "=" .. tostring(enabled))
	end
	table.sort(keys)
	return table.concat(keys, ",")
end

return function(t)
	t.test("1.1 close button only removes the library's own GUIs", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context)
		window:AddTab({ Title = "Main" })
		local playerGui = world.env.game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
		addScreenGuis(world, world.CoreGui, { "ChatGui", "StatGui", "CombatGui", "FluentToggleGui", "ATGToggleGui", "OtherHub" })
		addScreenGuis(world, playerGui, { "ATGStats", "FluentToggleGui" })
		local globalWindowDestroyed = false
		world.env.Window = {
			Destroy = function()
				globalWindowDestroyed = true
			end,
		}
		world.env.ATGButtonUI_Running = true

		world:click(window.TitleBar.CloseButton.Frame)
		task.wait(0.05)
		local yes = KitchenSink.findTextButton(world, window.Root, "Yes")
		t.truthy(yes, "close dialog has a Yes button")
		world:click(yes)
		task.wait(0.5)

		t.equal(childNames(world.CoreGui), "ChatGui,CombatGui,OtherHub,StatGui", "CoreGui after close")
		t.equal(childNames(playerGui), "ATGStats", "PlayerGui after close")
		t.falsy(globalWindowDestroyed, "a global named Window is not touched")
		t.truthy(world.env.Window ~= nil, "global Window is not cleared")
		t.equal(world.env.ATGButtonUI_Running, false, "legacy toggle loop flag is cleared")
		t.truthy(context.Library.Unloaded, "library unloaded")
		t.truthy(world:isDestroyed(context.Library.GUI), "library GUI destroyed")
		assertNoErrors(t, world)
	end)

	t.test("1.1 Library:Destroy() does the same cleanup as the close button", function()
		local context = Boot.new()
		local world = context.world
		newWindow(context)
		addScreenGuis(world, world.CoreGui, { "ChatGui", "FluentToggleGui", "MyFluentThing" })
		context.Library:Destroy()
		task.wait(0.1)
		t.equal(childNames(world.CoreGui), "ChatGui,MyFluentThing", "CoreGui after Destroy")
		assertNoErrors(t, world)
	end)

	t.test("1.2 minimize key: tap, chords, focus loss and text boxes", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })
		local input = tab:AddInput("Name", { Title = "Name", Default = "" })
		window:SelectTab(1)
		task.wait(0.4)
		local function visible()
			return window.Root.Visible
		end

		world:tapKey("LeftControl")
		task.wait(0.25)
		t.equal(visible(), false, "a quick tap minimizes")
		world:tapKey("RightControl")
		t.equal(visible(), false, "only the configured Ctrl key counts")
		world:tapKey("LeftControl")
		t.equal(visible(), true, "a second tap restores")

		world:pressKey("LeftControl")
		task.wait(0.5)
		world:releaseKey("LeftControl")
		t.equal(visible(), false, "holding Ctrl alone minimizes on release")
		world:tapKey("LeftControl")
		t.equal(visible(), true, "restored")

		world:pressKey("LeftControl")
		t.equal(visible(), true, "nothing happens while Ctrl is held")
		world:tapKey("K")
		world:releaseKey("LeftControl")
		t.equal(visible(), true, "Ctrl+K does not minimize")

		world:pressKey("LeftControl")
		world:pressKey("W")
		task.wait(0.3)
		world:releaseKey("W")
		world:releaseKey("LeftControl")
		t.equal(visible(), true, "Ctrl held while walking does not minimize")

		world:pressKey("LeftControl")
		world:mouseDown(window.Root)
		world:releaseKey("LeftControl")
		t.equal(visible(), true, "Ctrl+click does not minimize")

		world:pressKey("LeftControl")
		world:loseWindowFocus()
		world:releaseKey("LeftControl")
		t.equal(visible(), true, "alt-tab while holding Ctrl does not minimize")

		local box = KitchenSink.findDescendant(world, input.Frame, function(_, state)
			return state.class == "TextBox"
		end)
		world:focusTextBox(box)
		world:tapKey("LeftControl")
		t.equal(visible(), true, "Ctrl in a focused text box does not minimize")
		world:releaseTextBox(false)
		assertNoErrors(t, world)
	end)

	t.test("1.2 non-modifier minimize key minimizes on press", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context, { MinimizeKey = world.env.Enum.KeyCode.Insert })
		window:AddTab({ Title = "Main" })
		world:pressKey("Insert")
		t.equal(window.Root.Visible, false, "minimized on key down")
		world:releaseKey("Insert")
		t.equal(window.Root.Visible, false, "release does not toggle again")
		assertNoErrors(t, world)
	end)

	t.test("1.2 Shift as minimize key follows the modifier rule", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context, { MinimizeKey = world.env.Enum.KeyCode.RightShift })
		window:AddTab({ Title = "Main" })
		world:pressKey("RightShift")
		t.equal(window.Root.Visible, true, "nothing happens on key down")
		world:releaseKey("RightShift")
		t.equal(window.Root.Visible, false, "minimized on release")
		world:pressKey("RightShift")
		world:tapKey("A")
		world:releaseKey("RightShift")
		t.equal(window.Root.Visible, false, "Shift+A does not toggle")
		assertNoErrors(t, world)
	end)

	t.test("1.2 Ctrl+M toggles the window exactly once through the floating button", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context)
		window:AddTab({ Title = "Main" })
		task.wait(0.4)
		t.truthy(context.Library.FloatingToggle, "floating toggle exists")
		world:pressKey("LeftControl")
		world:pressKey("M")
		world:releaseKey("M")
		world:releaseKey("LeftControl")
		t.equal(window.Root.Visible, false, "Ctrl+M hides once")
		world:pressKey("LeftControl")
		world:pressKey("M")
		world:releaseKey("M")
		world:releaseKey("LeftControl")
		t.equal(window.Root.Visible, true, "Ctrl+M shows once")
		assertNoErrors(t, world)
	end)

	t.test("1.3 MinimizeKey is optional and accepts a key name", function()
		local context = Boot.new()
		local world = context.world
		local window = context.Library:CreateWindow({ Title = "No key", Size = world.env.UDim2.fromOffset(580, 460), TabWidth = 160 })
		window:AddTab({ Title = "Main" })
		t.equal(context.Library.MinimizeKey, world.env.Enum.KeyCode.LeftControl, "default key kept")
		world:tapKey("LeftControl")
		t.equal(window.Root.Visible, false, "default key minimizes")
		assertNoErrors(t, world)

		local named = Boot.new()
		local namedWindow = named.Library:CreateWindow({ Title = "Named", Size = named.world.env.UDim2.fromOffset(580, 460), TabWidth = 160, MinimizeKey = "RightShift" })
		namedWindow:AddTab({ Title = "Main" })
		t.equal(named.Library.MinimizeKey, named.world.env.Enum.KeyCode.RightShift, "key name converted")
		named.world:tapKey("RightShift")
		t.equal(namedWindow.Root.Visible, false, "named key minimizes")
		assertNoErrors(t, named.world)

		local invalid = Boot.new()
		invalid.Library:CreateWindow({ Title = "Invalid", Size = invalid.world.env.UDim2.fromOffset(580, 460), TabWidth = 160, MinimizeKey = "NotAKey" })
		t.equal(invalid.Library.MinimizeKey, invalid.world.env.Enum.KeyCode.LeftControl, "invalid name falls back to the default")
		assertNoErrors(t, invalid.world)
	end)

	t.test("1.3 minimize notification names the key without a typo", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context)
		window:AddTab({ Title = "Main" })
		window:Minimize()
		task.wait(0.3)
		local text = KitchenSink.findDescendant(world, context.Library.GUI, function(_, state)
			return state.class == "TextLabel" and type(state.props.Text) == "string" and state.props.Text:find("to toggle the", 1, true) ~= nil
		end)
		t.truthy(text, "minimize notification shown")
		t.equal(text and text.Text, "Press LeftControl to toggle the interface.")
		assertNoErrors(t, world)
	end)

	t.test("1.4 multi dropdown defaults, SetValue forms and saving", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })
		local values = { "A", "B", "C" }

		local empty = tab:AddDropdown("Empty", { Title = "Empty", Values = values, Multi = true })
		t.equal(type(empty.Value), "table", "no default gives an empty selection")
		t.equal(sortedKeys(empty.Value), "")

		local listDefault = { "A", "C" }
		local fromList = tab:AddDropdown("FromList", { Title = "From list", Values = values, Multi = true, Default = listDefault })
		t.equal(sortedKeys(fromList.Value), "A=true,C=true", "list default")
		t.equal(sortedKeys(listDefault), "1=A,2=C", "the Default table is not modified")

		local fromDict = tab:AddDropdown("FromDict", { Title = "From dict", Values = values, Multi = true, Default = { B = true } })
		t.equal(sortedKeys(fromDict.Value), "B=true", "dict default")

		fromDict:SetValue({ "A", "B" })
		t.equal(sortedKeys(fromDict.Value), "A=true,B=true", "SetValue with a list")
		fromDict:SetValue({ C = true, Z = true })
		t.equal(sortedKeys(fromDict.Value), "C=true", "SetValue with a dict ignores unknown values")

		local HttpService = world.env.game:GetService("HttpService")
		local saved = HttpService:JSONEncode(fromList.Value)
		empty:SetValue(HttpService:JSONDecode(saved))
		t.equal(sortedKeys(empty.Value), "A=true,C=true", "value survives a JSON round trip")
		assertNoErrors(t, world)
	end)

	t.test("1.4 clear button respects AllowNull and Select All matches what is shown", function()
		local context = Boot.new()
		local world = context.world
		local Library = context.Library
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })

		local single = tab:AddDropdown("Single", { Title = "Single", Values = { "A", "B" }, Default = 1 })
		openDropdown(world, single)
		local clear = clearButtonOf(world, Library)
		t.truthy(clear, "clear button exists")
		if clear.Visible then
			world:click(clear)
		end
		t.equal(single.Value, "A", "single dropdown without AllowNull keeps its value")
		single:Close()
		task.wait(0.3)

		local nullable = tab:AddDropdown("Nullable", { Title = "Nullable", Values = { "A", "B" }, Default = 1, AllowNull = true })
		openDropdown(world, nullable)
		local nullableClear
		for candidate in world.allInstances do
			local state = world:stateOf(candidate)
			if not state.destroyed and state.class == "TextButton" and state.props.Text == "❌" and candidate:IsDescendantOf(Library.GUI) and candidate ~= clear then
				nullableClear = candidate
			end
		end
		t.truthy(nullableClear, "second clear button exists")
		world:click(nullableClear)
		t.equal(nullable.Value, nil, "AllowNull dropdown can be cleared")
		nullable:Close()
		task.wait(0.3)

		local colored = tab:AddDropdown("Colored", {
			Title = "Colored",
			Values = { "[COLOR:255,0,0]Red", "[COLOR:0,0,255]Blue", 7 },
			Multi = true,
		})
		openDropdown(world, colored)
		local search = KitchenSink.findDescendant(world, Library.GUI, function(instance, state)
			return state.class == "TextBox" and state.props.PlaceholderText == "🔍 Search..." and instance.Parent and instance.Parent.Parent and instance.Parent.Parent.Visible
		end)
		t.truthy(search, "search box of the open dropdown")
		search.Text = "red"
		world:step()
		task.wait()
		local selectAll = KitchenSink.findTextButton(world, Library.GUI, "✅ Select All")
		t.truthy(selectAll, "select all button")
		world:click(selectAll)
		t.equal(sortedKeys(colored.Value), "[COLOR:255,0,0]Red=true", "select all picks the shown colored value")
		search.Text = ""
		world:step()
		task.wait()
		world:click(selectAll)
		t.equal(sortedKeys(colored.Value), "7=true,[COLOR:0,0,255]Blue=true,[COLOR:255,0,0]Red=true", "select all with numbers")
		assertNoErrors(t, world)
	end)

	t.test("1.5 Round returns a rounded number", function()
		local context = Boot.new()
		local Library = context.Library
		t.equal(Library:Round(5.7, 0), 6)
		t.equal(Library:Round(5.2, 0), 5)
		t.equal(Library:Round(1.25, 1), 1.3)
		t.equal(Library:Round(3, 2), 3)
		t.equal(type(Library:Round(2.5, 1)), "number")
		t.equal(Library:Round(-1.26, 1), -1.3)

		local world = context.world
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })
		local changed = {}
		local slider = tab:AddSlider("S", { Title = "S", Default = 1, Min = 0, Max = 10, Rounding = 2 })
		slider:OnChanged(function(value)
			table.insert(changed, value)
		end)
		slider:SetValue(2.346)
		t.equal(slider.Value, 2.35)
		t.equal(type(changed[#changed]), "number", "callbacks receive numbers")
		assertNoErrors(t, world)
	end)

	t.test("1.6 Notify returns without yielding", function()
		local context = Boot.new()
		local world = context.world
		newWindow(context)
		local returned = false
		local notification
		task.spawn(function()
			notification = context.Library:Notify({ Title = "Info", Content = "no yield", Duration = 1 })
			returned = true
		end)
		t.truthy(returned, "Notify returned in the same frame")
		t.truthy(notification and notification.Close, "Notify returns the notification")
		task.wait(0.5)
		t.equal(notification.IconFrame.Size, world.env.UDim2.fromOffset(40, 40), "icon animation still runs")
		assertNoErrors(t, world)
	end)

	t.test("1.7 rebuilt dropdown rows and closed notifications are released", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })
		local values = {}
		for index = 1, 40 do
			values[index] = "Item " .. index
		end
		local dropdown = tab:AddDropdown("Big", { Title = "Big", Values = values, Default = 1 })
		local button = openDropdown(world, dropdown)
		local sinceId = world.counters.instancesCreated
		local destroyedBefore = world.counters.instancesDestroyed
		-- SetValues rebuilds the rows (a search only hides them).
		for round = 1, 20 do
			local shorter = table.move(values, 1, 40 - (round % 5), 1, {})
			dropdown:SetValues(shorter)
			world:step()
			task.wait()
		end
		t.truthy(world.counters.instancesDestroyed - destroyedBefore > 1000, "rows were rebuilt")
		world:click(button)
		for index = 1, 10 do
			context.Library:Notify({ Title = "N" .. index, Content = "x", Duration = 0.05 })
		end
		task.wait(1)
		-- Let running animations finish; a running spring holds its instance.
		world:settle(3)
		local retained = Leaks.retainedDestroyed(world, sinceId)
		t.equal(retained, 0, "destroyed instances still referenced:\n" .. Leaks.describeRetained(world, sinceId))
		assertNoErrors(t, world)
	end)

	t.test("1.9 Destroy fires OnUnload once, removes the blur and guards CreateWindow", function()
		local context = Boot.new()
		local world = context.world
		local Library = context.Library
		local gameDof = world.env.Instance.new("DepthOfFieldEffect")
		gameDof.Enabled = true
		gameDof.Parent = world.Lighting
		local window = newWindow(context, { Acrylic = true })
		t.truthy(window, "window created")
		local again = newWindow(context)
		t.equal(again, window, "a second CreateWindow returns the existing window")

		local fired = 0
		Library.OnUnload:Connect(function()
			fired += 1
			t.falsy(world:isDestroyed(Library.GUI), "OnUnload runs before the GUI is destroyed")
		end)
		Library:Destroy()
		Library:Destroy()
		task.wait(0.1)
		t.equal(fired, 1, "OnUnload fired once")
		local dofCount = 0
		for _, child in world.Lighting:GetChildren() do
			if child:IsA("DepthOfFieldEffect") then
				dofCount += 1
			end
		end
		t.equal(dofCount, 1, "only the game's own DepthOfFieldEffect remains")
		t.equal(gameDof.Enabled, true, "the game's DepthOfFieldEffect is untouched")
		t.equal(newWindow(context), nil, "CreateWindow after Destroy returns nil")
		assertNoErrors(t, world)
	end)
end
