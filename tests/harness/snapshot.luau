--[[
	Serialises an instance tree into stable text so two runs (for example
	before and after renaming locals) can be compared byte for byte.
	Only properties that were explicitly written are included.
]]

local Engine = require("./fake_roblox")

local Snapshot = {}

local function formatNumber(value: number): string
	if value ~= value then
		return "nan"
	end
	local rounded = math.floor(value * 10000 + 0.5) / 10000
	if rounded == math.floor(rounded) then
		return string.format("%d", rounded)
	end
	return (string.format("%.4f", rounded):gsub("0+$", ""))
end

local function formatValue(value: any, world): string
	local kind = Engine.typeof(value)
	if kind == "number" then
		return formatNumber(value)
	elseif kind == "string" then
		return string.format("%q", value)
	elseif kind == "boolean" or kind == "nil" then
		return tostring(value)
	elseif kind == "Color3" then
		return string.format("Color3(%s,%s,%s)", formatNumber(value.R), formatNumber(value.G), formatNumber(value.B))
	elseif kind == "Instance" then
		local state = world:stateOf(value)
		return "<" .. (state and state.props.Name or "?") .. ">"
	elseif kind == "UDim2" then
		return string.format(
			"UDim2(%s,%s,%s,%s)",
			formatNumber(value.X.Scale),
			formatNumber(value.X.Offset),
			formatNumber(value.Y.Scale),
			formatNumber(value.Y.Offset)
		)
	elseif kind == "Vector2" then
		return string.format("Vector2(%s,%s)", formatNumber(value.X), formatNumber(value.Y))
	elseif kind == "UDim" then
		return string.format("UDim(%s,%s)", formatNumber(value.Scale), formatNumber(value.Offset))
	end
	return kind .. "(" .. tostring(value) .. ")"
end

function Snapshot.tree(world, root, options: { exclude: { [string]: boolean }? }?): string
	local exclude = options and options.exclude or {}
	local lines = {}
	local function walk(instance, depth: number)
		local state = world:stateOf(instance)
		local keys = {}
		for key in state.props do
			if key ~= "Name" and not exclude[key] then
				table.insert(keys, key)
			end
		end
		table.sort(keys)
		local parts = {}
		for _, key in keys do
			table.insert(parts, key .. "=" .. formatValue(state.props[key], world))
		end
		table.insert(
			lines,
			string.rep("  ", depth) .. state.class .. " " .. string.format("%q", state.props.Name) .. " " .. table.concat(parts, " ")
		)
		for _, child in state.children do
			walk(child, depth + 1)
		end
	end
	walk(root, 0)
	return table.concat(lines, "\n")
end

function Snapshot.value(value: any, world): string
	local seen = {}
	local function serialise(current: any, depth: number): string
		if type(current) ~= "table" or Engine.typeof(current) ~= "table" then
			return formatValue(current, world)
		end
		if seen[current] then
			return "<cycle>"
		end
		seen[current] = true
		local keys = {}
		for key in current do
			table.insert(keys, key)
		end
		table.sort(keys, function(a, b)
			return tostring(a) < tostring(b)
		end)
		local parts = {}
		for _, key in keys do
			local item = current[key]
			if type(item) ~= "function" then
				table.insert(parts, tostring(key) .. "=" .. serialise(item, depth + 1))
			end
		end
		seen[current] = nil
		return "{" .. table.concat(parts, ",") .. "}"
	end
	return serialise(value, 0)
end

return Snapshot
