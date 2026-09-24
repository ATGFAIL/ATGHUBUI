--[[
	Roblox datatypes for the fake engine.

	Most come straight from @lune/roblox. Two are reimplemented because the
	library relies on behaviour Lune does not provide:
	  * Color3: the deprecated lowercase .r/.g/.b fields and the static
	    Color3.toHSV(color) are used by the Colorpicker.
	  * TweenInfo: not a serialisable datatype, so Lune has none.
	Constructors that take colours (ColorSequence, ColorSequenceKeypoint) are
	wrapped to translate our Color3 into Lune's.
]]

local roblox = require("@lune/roblox")

local Types = {}

local ownTypes = setmetatable({}, { __mode = "k" })

--------------------------------------------------------------------------------
-- Color3
--------------------------------------------------------------------------------

local Color3 = {}
local Color3MT = {}

local function newColor(r: number, g: number, b: number)
	local color = setmetatable({ R = r, G = g, B = b }, Color3MT)
	ownTypes[color] = "Color3"
	return color
end

Color3MT.__index = function(self, key)
	if key == "r" then
		return rawget(self, "R")
	elseif key == "g" then
		return rawget(self, "G")
	elseif key == "b" then
		return rawget(self, "B")
	end
	local method = Color3[key]
	if method and (key == "ToHex" or key == "ToHSV" or key == "Lerp") then
		return method
	end
	error(tostring(key) .. " is not a valid member of Color3", 2)
end

Color3MT.__newindex = function(_, key)
	error(tostring(key) .. " cannot be assigned to", 2)
end

Color3MT.__eq = function(a, b)
	return math.abs(a.R - b.R) < 1e-6 and math.abs(a.G - b.G) < 1e-6 and math.abs(a.B - b.B) < 1e-6
end

Color3MT.__tostring = function(self)
	return string.format("%g, %g, %g", self.R, self.G, self.B)
end

function Color3.new(r: number?, g: number?, b: number?)
	return newColor(tonumber(r) or 0, tonumber(g) or 0, tonumber(b) or 0)
end

function Color3.fromRGB(r: number?, g: number?, b: number?)
	local rn, gn, bn = tonumber(r), tonumber(g), tonumber(b)
	if r ~= nil and rn == nil or g ~= nil and gn == nil or b ~= nil and bn == nil then
		error("invalid argument to Color3.fromRGB (number expected)", 2)
	end
	return newColor((rn or 0) / 255, (gn or 0) / 255, (bn or 0) / 255)
end

function Color3.fromHSV(h: number, s: number, v: number)
	h = tonumber(h) or 0
	s = tonumber(s) or 0
	v = tonumber(v) or 0
	local i = math.floor(h * 6)
	local f = h * 6 - i
	local p = v * (1 - s)
	local q = v * (1 - f * s)
	local t = v * (1 - (1 - f) * s)
	i = i % 6
	if i == 0 then
		return newColor(v, t, p)
	elseif i == 1 then
		return newColor(q, v, p)
	elseif i == 2 then
		return newColor(p, v, t)
	elseif i == 3 then
		return newColor(p, q, v)
	elseif i == 4 then
		return newColor(t, p, v)
	end
	return newColor(v, p, q)
end

function Color3.toHSV(color)
	local r, g, b = color.R, color.G, color.B
	local maximum = math.max(r, g, b)
	local minimum = math.min(r, g, b)
	local delta = maximum - minimum
	local h = 0
	if delta > 0 then
		if maximum == r then
			h = ((g - b) / delta) % 6
		elseif maximum == g then
			h = (b - r) / delta + 2
		else
			h = (r - g) / delta + 4
		end
		h /= 6
	end
	local s = maximum == 0 and 0 or delta / maximum
	return h, s, maximum
end

function Color3.fromHex(hex: string)
	if type(hex) ~= "string" then
		error("Unable to convert characters to hex value", 2)
	end
	local digits = hex:gsub("^#", "")
	if #digits == 3 then
		digits = digits:gsub(".", "%0%0")
	end
	if #digits ~= 6 or digits:find("[^%x]") then
		error("Unable to convert characters to hex value", 2)
	end
	return newColor(
		tonumber(digits:sub(1, 2), 16) / 255,
		tonumber(digits:sub(3, 4), 16) / 255,
		tonumber(digits:sub(5, 6), 16) / 255
	)
end

function Color3.ToHex(self)
	local function channel(value)
		return math.clamp(math.floor(value * 255 + 0.5), 0, 255)
	end
	return string.format("%02X%02X%02X", channel(self.R), channel(self.G), channel(self.B))
end

function Color3.ToHSV(self)
	return Color3.toHSV(self)
end

function Color3.Lerp(self, goal, alpha: number)
	return newColor(
		self.R + (goal.R - self.R) * alpha,
		self.G + (goal.G - self.G) * alpha,
		self.B + (goal.B - self.B) * alpha
	)
end

Types.Color3 = {
	new = Color3.new,
	fromRGB = Color3.fromRGB,
	fromHSV = Color3.fromHSV,
	fromHex = Color3.fromHex,
	toHSV = Color3.toHSV,
}

local function toLuneColor(color)
	if ownTypes[color] == "Color3" then
		return roblox.Color3.new(color.R, color.G, color.B)
	end
	return color
end

--------------------------------------------------------------------------------
-- TweenInfo
--------------------------------------------------------------------------------

local TweenInfoMT = {}
TweenInfoMT.__index = function(_, key)
	error(tostring(key) .. " is not a valid member of TweenInfo", 2)
end

Types.TweenInfo = {
	new = function(time, easingStyle, easingDirection, repeatCount, reverses, delayTime)
		local info = setmetatable({
			Time = tonumber(time) or 1,
			EasingStyle = easingStyle or roblox.Enum.EasingStyle.Quad,
			EasingDirection = easingDirection or roblox.Enum.EasingDirection.Out,
			RepeatCount = repeatCount or 0,
			Reverses = reverses == true,
			DelayTime = delayTime or 0,
		}, TweenInfoMT)
		ownTypes[info] = "TweenInfo"
		return info
	end,
}

--------------------------------------------------------------------------------
-- Lune datatypes
--------------------------------------------------------------------------------

Types.Enum = roblox.Enum
Types.Vector2 = roblox.Vector2
Types.Vector3 = roblox.Vector3
Types.UDim = roblox.UDim
Types.UDim2 = roblox.UDim2
Types.Rect = roblox.Rect
Types.CFrame = roblox.CFrame
Types.Ray = roblox.Ray
Types.Font = roblox.Font
Types.NumberRange = roblox.NumberRange
Types.NumberSequence = roblox.NumberSequence
Types.NumberSequenceKeypoint = roblox.NumberSequenceKeypoint

Types.ColorSequenceKeypoint = {
	new = function(time, color)
		return roblox.ColorSequenceKeypoint.new(time, toLuneColor(color))
	end,
}

Types.ColorSequence = {
	new = function(a, b)
		if type(a) == "table" and ownTypes[a] == nil then
			return roblox.ColorSequence.new(a)
		end
		if b ~= nil then
			return roblox.ColorSequence.new(toLuneColor(a), toLuneColor(b))
		end
		return roblox.ColorSequence.new(toLuneColor(a))
	end,
}

function Types.typeof(value: any): string?
	return ownTypes[value]
end

-- Reflection defaults arrive as Lune values; colours are converted so that
-- equality checks against values written by the library behave.
function Types.fromLune(value: any): any
	if typeof(value) == "Color3" then
		return newColor(value.R, value.G, value.B)
	end
	return value
end

function Types.fontFromEnum(item)
	local ok, font = pcall(roblox.Font.fromEnum, item)
	return ok and font or nil
end

local NUMBER_TYPES = { Float32 = true, Float64 = true, Int32 = true, Int64 = true }
local STRING_TYPES = { String = true, BinaryString = true }
local CONTENT_TYPES = { Content = true, ContentId = true }
local VALUE_TYPES = {
	Color3 = true,
	UDim2 = true,
	UDim = true,
	Vector2 = true,
	Vector3 = true,
	Rect = true,
	NumberSequence = true,
	ColorSequence = true,
	Font = true,
	CFrame = true,
	NumberRange = true,
}

local describeCache = {}
function Types.describeDatatype(datatype: string?)
	if datatype == nil then
		return nil
	end
	local cached = describeCache[datatype]
	if cached ~= nil then
		return cached or nil
	end
	local result
	if STRING_TYPES[datatype] then
		result = { kind = "String" }
	elseif CONTENT_TYPES[datatype] then
		result = { kind = "Content" }
	elseif NUMBER_TYPES[datatype] then
		result = { kind = "Number" }
	elseif datatype == "Bool" then
		result = { kind = "Bool" }
	elseif datatype == "Ref" then
		result = { kind = "Ref" }
	elseif datatype:sub(1, 5) == "Enum." then
		result = { kind = "Enum", enum = datatype:sub(6) }
	elseif VALUE_TYPES[datatype] then
		result = { kind = "Datatype", name = datatype }
	end
	describeCache[datatype] = result or false
	return result
end

function Types.coerceEnum(enumName: string, value: any)
	local ok, enum = pcall(function()
		return roblox.Enum[enumName]
	end)
	if not ok then
		return nil
	end
	if typeof(value) == "EnumItem" then
		if value.EnumType == enum then
			return value
		end
		return nil
	end
	if type(value) == "string" then
		local found, item = pcall(function()
			return enum[value]
		end)
		return found and item or nil
	end
	if type(value) == "number" then
		for _, item in enum:GetEnumItems() do
			if item.Value == value then
				return item
			end
		end
	end
	return nil
end

-- Datatype constructors exposed as globals to the code under test.
function Types.globals()
	return {
		Color3 = Types.Color3,
		TweenInfo = Types.TweenInfo,
		Enum = Types.Enum,
		Vector2 = Types.Vector2,
		Vector3 = Types.Vector3,
		UDim = Types.UDim,
		UDim2 = Types.UDim2,
		Rect = Types.Rect,
		CFrame = Types.CFrame,
		Ray = Types.Ray,
		Font = Types.Font,
		NumberRange = Types.NumberRange,
		NumberSequence = Types.NumberSequence,
		NumberSequenceKeypoint = Types.NumberSequenceKeypoint,
		ColorSequence = Types.ColorSequence,
		ColorSequenceKeypoint = Types.ColorSequenceKeypoint,
	}
end

return Types
