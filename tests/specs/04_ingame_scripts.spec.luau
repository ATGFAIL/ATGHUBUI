--[[
	Runs tests/ingame/smoke.lua and bench.lua inside the fake engine. The
	point is not their numbers (the fake has no real frame timing) but that
	the scripts themselves run to the end without errors before the user is
	asked to run them in a real executor.
]]

local fs = require("@lune/fs")

local Boot = require("../harness/boot")

local function prepare(scriptPath: string, replacements: { [string]: string }?)
	local context = Boot.new()
	local world = context.world
	world.files["MainUI.lua"] = fs.readFile(Boot.sourcePath("MainUI"))
	local source = fs.readFile(scriptPath)
	source = source:gsub("LocalFile = nil", 'LocalFile = "MainUI.lua"')
	for pattern, replacement in replacements or {} do
		source = source:gsub(pattern, replacement)
	end
	return context, world, source
end

return function(t)
	t.test("smoke.lua runs to the end in the fake engine", function()
		local _, world, source = prepare("tests/ingame/smoke.lua")
		local stop = world:startClock()
		local chunk = assert(world.env.loadstring(source, "=smoke"))
		local ok, results = pcall(chunk)
		stop()
		t.truthy(ok, "smoke.lua raised: " .. tostring(results))
		t.truthy(type(results) == "table" and #results > 0, "smoke.lua returned results")
		t.truthy(world.clipboard and world.clipboard:find("ATG smoke", 1, true), "report copied")
		-- Checks deliberately trigger known library bugs, so library errors
		-- raised inside spawned threads are expected on the original code.
	end)

	t.test("bench.lua runs to the end in the fake engine", function()
		local _, world, source = prepare("tests/ingame/bench.lua", {
			["Rounds = 3"] = "Rounds = 1",
			["Tabs = 8"] = "Tabs = 2",
			["ElementsPerTab = 30"] = "ElementsPerTab = 8",
			["BigDropdownSize = 300"] = "BigDropdownSize = 20",
			["ToggleSetValues = 200"] = "ToggleSetValues = 10",
			["Notifies = 20"] = "Notifies = 2",
			["FrameSampleSeconds = 4"] = "FrameSampleSeconds = 0.2",
		})
		local stop = world:startClock()
		local chunk = assert(world.env.loadstring(source, "=bench"))
		local ok, rounds = pcall(chunk)
		stop()
		t.truthy(ok, "bench.lua raised: " .. tostring(rounds))
		t.truthy(type(rounds) == "table" and #rounds == 1, "one round recorded")
		t.truthy(world.clipboard and world.clipboard:find("ATG bench", 1, true), "report copied")
		t.equal(#world.errors, 0, "engine errors:\n" .. table.concat(world.errors, "\n---\n"))
	end)
end
