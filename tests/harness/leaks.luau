--[[
	Counts destroyed fake instances that some table in the library still keeps
	reachable after a full garbage collection (a leak).

	Lune only allows collectgarbage("count"), so a full cycle is forced by
	allocating garbage until the incremental collector has swept.
]]

local Leaks = {}

local function forceFullCollection()
	-- Allocate about three times the current heap in short-lived tables, so
	-- at least one whole incremental cycle runs however large the heap is
	-- (it grows as earlier specs run).
	local tables = math.max(400000, math.floor(collectgarbage("count") * 1024 * 3 / 64))
	local chunk = 100000
	for _ = 1, math.ceil(tables / chunk) do
		local junk = table.create(chunk)
		for index = 1, chunk do
			junk[index] = { index }
		end
		junk = nil
	end
end

-- Counts only instances created after `sinceId`, so unrelated timers (such
-- as the splash screen tearing itself down) do not affect the result.
local function countRetained(world, sinceId: number?): number
	local count = 0
	for instance in world.allInstances do
		local state = world:stateOf(instance)
		if state.destroyed and state.id > (sinceId or 0) then
			count += 1
		end
	end
	return count
end

-- The incremental collector may need several cycles before weak entries are
-- cleared, so collect until the count is stable for three rounds.
function Leaks.retainedDestroyed(world, sinceId: number?): number
	local previous, stable = -1, 0
	for _ = 1, 30 do
		forceFullCollection()
		local current = countRetained(world, sinceId)
		if current == previous then
			stable += 1
			if stable >= 3 then
				return current
			end
		else
			stable = 0
		end
		previous = current
	end
	return previous
end

-- Lists retained instances as "id Class Name" lines, for failure messages.
function Leaks.describeRetained(world, sinceId: number?): string
	local lines = {}
	for instance in world.allInstances do
		local state = world:stateOf(instance)
		if state.destroyed and state.id > (sinceId or 0) then
			table.insert(lines, string.format("%d %s %s Size=%s Text=%s", state.id, state.class, tostring(state.props.Name), tostring(state.props.Size), tostring(state.props.Text)))
		end
	end
	table.sort(lines)
	return table.concat(lines, "\n")
end

return Leaks
