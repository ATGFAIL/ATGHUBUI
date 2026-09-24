--[[
	JSON encode/decode with the same observable rules as Roblox's
	HttpService:JSONEncode / JSONDecode that matter to this library:

	* A table whose [1] is non-nil is encoded as an array of its 1..n part and
	  every non-integer key is dropped (Roblox behaves this way for mixed
	  tables, see devforum "HttpService:JSONEncode ignores some keys").
	* An empty table encodes as "[]".
	* Other tables must use string keys and encode as objects.
	* Unsupported values (functions, userdata, threads) raise an error.
]]

local serde = require("@lune/serde")

local JSON = {}

local function escapeString(value: string): string
	local escaped = value
		:gsub("\\", "\\\\")
		:gsub('"', '\\"')
		:gsub("\n", "\\n")
		:gsub("\r", "\\r")
		:gsub("\t", "\\t")
		:gsub("[%z\1-\31]", function(character)
			return string.format("\\u%04x", string.byte(character))
		end)
	return '"' .. escaped .. '"'
end

local function encodeNumber(value: number): string
	if value ~= value or value == math.huge or value == -math.huge then
		error("Cannot convert number " .. tostring(value) .. " to JSON", 0)
	end
	if value == math.floor(value) and math.abs(value) < 2 ^ 53 then
		return string.format("%d", value)
	end
	return string.format("%.17g", value)
end

local encodeValue

local function encodeTable(value: { [any]: any }, seen: { [any]: boolean }): string
	if seen[value] then
		error("Cannot convert a table that contains itself to JSON", 0)
	end
	seen[value] = true

	local parts = {}
	if value[1] ~= nil or next(value) == nil then
		local index = 1
		while value[index] ~= nil do
			table.insert(parts, encodeValue(value[index], seen))
			index += 1
		end
		seen[value] = nil
		return "[" .. table.concat(parts, ",") .. "]"
	end

	local keys = {}
	for key in value do
		if type(key) ~= "string" then
			error("Invalid table key type used for JSON: " .. type(key), 0)
		end
		table.insert(keys, key)
	end
	table.sort(keys)
	for _, key in keys do
		table.insert(parts, escapeString(key) .. ":" .. encodeValue(value[key], seen))
	end
	seen[value] = nil
	return "{" .. table.concat(parts, ",") .. "}"
end

function encodeValue(value: any, seen: { [any]: boolean }): string
	local valueType = type(value)
	if valueType == "nil" then
		return "null"
	elseif valueType == "boolean" then
		return value and "true" or "false"
	elseif valueType == "number" then
		return encodeNumber(value)
	elseif valueType == "string" then
		return escapeString(value)
	elseif valueType == "table" then
		return encodeTable(value, seen)
	end
	error("Cannot convert " .. typeof(value) .. " to JSON", 0)
end

function JSON.encode(value: any): string
	return encodeValue(value, {})
end

function JSON.decode(source: string): any
	if type(source) ~= "string" then
		error("Argument 1 missing or nil", 0)
	end
	local ok, result = pcall(serde.decode, "json" :: any, source)
	if not ok then
		error("Can't parse JSON", 0)
	end
	return result
end

return JSON
