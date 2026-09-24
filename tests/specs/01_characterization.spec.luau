--[[
	Characterization: records what the library does today (including known
	bugs) so refactors can prove they change nothing. When a later phase
	fixes a bug on purpose, regenerate with UPDATE_SNAPSHOTS=1 and review the
	diff of tests/snapshots/*.txt.
]]

local task = require("@lune/task")

local Boot = require("../harness/boot")
local KitchenSink = require("../harness/kitchen_sink")
local Snapshot = require("../harness/snapshot")

return function(t)
	t.test("kitchen sink builds without engine errors and matches the snapshot", function()
		local context = Boot.new()
		local world = context.world
		local sink = KitchenSink.build(context)

		t.equal(#world.errors, 0, "engine errors:\n" .. table.concat(world.errors, "\n---\n"))

		t.snapshot("kitchen_sink_tree", Snapshot.tree(world, context.Library.GUI))
		t.snapshot("kitchen_sink_log", table.concat(sink.log, "\n"))

		local optionValues = {}
		local names = {}
		for name in sink.Options do
			table.insert(names, name)
		end
		table.sort(names)
		for _, name in names do
			local option = sink.Options[name]
			table.insert(
				optionValues,
				name .. " " .. tostring(option.Type) .. " " .. KitchenSink.describe(option.Value)
			)
		end
		t.snapshot("kitchen_sink_options", table.concat(optionValues, "\n"))

		-- Workspace saves on a 0.35 s debounce and drops a pending save when
		-- its scope changes, so which files exist at this point depends on
		-- timing. Save the current state and wait, so the snapshot is stable.
		context.Library.Workspace:SaveSoon()
		task.wait(1)
		local files = {}
		for path, contents in world.files do
			table.insert(files, path .. " = " .. contents)
		end
		table.sort(files)
		t.snapshot("kitchen_sink_files", table.concat(files, "\n"))

		local notices = {}
		for _, entry in context.Library.Workspace.Notifications do
			table.insert(notices, entry.Title .. " | " .. entry.Content)
		end
		t.snapshot("kitchen_sink_notifications", table.concat(notices, "\n"))
		t.snapshot("kitchen_sink_warnings", table.concat(world.warnings, "\n") .. "\n--prints--\n" .. table.concat(world.prints, "\n"))
	end)
end
