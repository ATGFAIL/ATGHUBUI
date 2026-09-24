--[[
	Deterministic performance counters (plan phase 4.0). These do not depend
	on machine speed: they count property writes, live connections and
	instances that stay referenced after being destroyed.

	The snapshot records the baseline of the current code. Later phases add
	assertions (e.g. a toggle click must not scale with UI size) and update
	the snapshot deliberately.
]]

local task = require("@lune/task")

local Boot = require("../harness/boot")
local KitchenSink = require("../harness/kitchen_sink")
local Leaks = require("../harness/leaks")

local function newWindow(context)
	local env = context.world.env
	return context.Library:CreateWindow({
		Title = "Perf",
		SubTitle = "spec",
		TabWidth = 160,
		Size = env.UDim2.fromOffset(580, 460),
		Acrylic = false,
		Theme = "Dark",
		MinimizeKey = env.Enum.KeyCode.LeftControl,
	})
end

local function buildToggles(count: number)
	local context = Boot.new()
	local world = context.world
	local window = newWindow(context)
	local tab = window:AddTab({ Title = "Main" })
	local before = world.counters.propertyWrites
	local toggles = {}
	for index = 1, count do
		toggles[index] = tab:AddToggle("T" .. index, { Title = "Toggle " .. index, Default = false })
	end
	local buildWrites = world.counters.propertyWrites - before
	world:settle(2)
	task.wait(0.3)
	world:settle(1)
	local clickBefore = world.counters.propertyWrites
	world:click(toggles[1].Frame)
	local clickWrites = world.counters.propertyWrites - clickBefore
	local peakRender = world:renderSteppedConnections()
	world:settle(3)
	return {
		buildWrites = buildWrites,
		clickWrites = clickWrites,
		peakRenderStepped = peakRender,
		idleRenderStepped = world:renderSteppedConnections(),
		errors = #world.errors,
	}
end

return function(t)
	t.test("baseline counters", function()
		local lines = {}

		local small = buildToggles(25)
		local large = buildToggles(100)
		table.insert(lines, string.format("toggles 25: build writes=%d click writes=%d peak RS=%d idle RS=%d", small.buildWrites, small.clickWrites, small.peakRenderStepped, small.idleRenderStepped))
		table.insert(lines, string.format("toggles 100: build writes=%d click writes=%d peak RS=%d idle RS=%d", large.buildWrites, large.clickWrites, large.peakRenderStepped, large.idleRenderStepped))
		t.equal(small.errors + large.errors, 0, "engine errors while building toggles")

		-- Dropdown rebuilds (search typing) and retained instances.
		do
			local context = Boot.new()
			local world = context.world
			local window = newWindow(context)
			local tab = window:AddTab({ Title = "Main" })
			local values = {}
			for index = 1, 40 do
				values[index] = "Item " .. index
			end
			local dropdown = tab:AddDropdown("Big", { Title = "Big", Values = values, Default = 1 })
			local button = KitchenSink.findDescendant(world, dropdown.Frame, function(_, state)
				return state.class == "TextButton"
			end)
			world:click(button)
			task.wait(0.05)
			local search = KitchenSink.findDescendant(world, context.Library.GUI, function(_, state)
				return state.class == "TextBox" and state.props.PlaceholderText == "🔍 Search..."
			end)
			local sinceId = world.counters.instancesCreated
			for round = 1, 20 do
				search.Text = "Item " .. (round % 5)
				-- the search debounce runs on the next Heartbeat
				world:step()
				task.wait()
			end
			world:click(button)
			task.wait(0.3)
			local retained = Leaks.retainedDestroyed(world, sinceId)
			table.insert(lines, string.format("dropdown 40 items, 20 searches: retained destroyed instances=%d", retained))
			t.equal(#world.errors, 0, "engine errors in dropdown search")
		end

		-- Notifications that closed and were destroyed.
		do
			local context = Boot.new()
			local world = context.world
			newWindow(context)
			local sinceId = world.counters.instancesCreated
			for index = 1, 10 do
				context.Library:Notify({ Title = "N" .. index, Content = "x", Duration = 0.05 })
			end
			task.wait(1)
			world:settle(1)
			local retained = Leaks.retainedDestroyed(world, sinceId)
			table.insert(lines, string.format("10 notifications closed: retained destroyed instances=%d", retained))
			t.equal(#world.errors, 0, "engine errors in notifications")
		end

		-- Window drag with many closed dropdowns: writes caused by layout change.
		do
			local context = Boot.new()
			local world = context.world
			local window = newWindow(context)
			local tab = window:AddTab({ Title = "Main" })
			for index = 1, 30 do
				tab:AddDropdown("D" .. index, { Title = "D" .. index, Values = { "a", "b" }, Default = 1 })
			end
			world:settle(1)
			local before = world.counters.propertyWrites
			world:bumpLayout(window.Root)
			task.wait()
			table.insert(lines, string.format("layout bump with 30 closed dropdowns: writes=%d", world.counters.propertyWrites - before))
		end

		-- Requests made while building a UI when the language is not English.
		do
			local context = Boot.new()
			local world = context.world
			context.Library.I18n:SetLanguage("th")
			local window = newWindow(context)
			local tab = window:AddTab({ Title = "Main" })
			for index = 1, 10 do
				tab:AddToggle("R" .. index, { Title = "Feature " .. index })
			end
			task.wait(0.5)
			table.insert(lines, string.format("build 10 toggles in th (mode %s): requests=%d", context.Library.I18n.Mode, #world.requests))
		end

		t.snapshot("perf_baseline", table.concat(lines, "\n"))
	end)
end
