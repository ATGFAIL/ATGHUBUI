--[[
	Counts destroyed fake instances that some table in the library still keeps
	reachable after a full garbage collection (a leak).

	Lune only allows collectgarbage("count"), so a full cycle is forced by
	allocating garbage until the incremental collector has swept.
]]

local Leaks = {}

local function forceFullCollection()
	for _ = 1, 4 do
		local junk = table.create(100000)
		for index = 1, 100000 do
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

return Leaks
