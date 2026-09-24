--[[
	Performance fixes that do not change how the UI looks (plan P1, P2, P4,
	P6). Assertions use deterministic counters from the fake engine, so they
	do not depend on machine speed. Each failed on the code before its fix.
]]

local task = require("@lune/task")

local Boot = require("../harness/boot")

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
	task.wait(0.4) -- let the floating toggle appear first
	local idleBefore = world:renderSteppedConnections()
	local before = world.counters.propertyWrites
	local toggles = {}
	for index = 1, count do
		toggles[index] = tab:AddToggle("T" .. index, { Title = "Toggle " .. index, Default = false })
	end
	local buildWrites = world.counters.propertyWrites - before
	world:settle(3)
	local clickBefore = world.counters.propertyWrites
	world:click(toggles[1].Frame)
	local clickWrites = world.counters.propertyWrites - clickBefore
	local peak = world:renderSteppedConnections()
	world:settle(3)
	return {
		buildWrites = buildWrites,
		clickWrites = clickWrites,
		peakExtraRenderStepped = peak - idleBefore,
		errors = #world.errors,
	}
end

return function(t)
	t.test("P1 toggle click cost does not grow with the number of elements", function()
		local small = buildToggles(25)
		local large = buildToggles(100)
		t.equal(small.errors + large.errors, 0, "engine errors")
		t.equal(large.clickWrites, small.clickWrites, "writes for one toggle click")
		-- Building 4x the toggles should cost about 4x the writes, not 16x.
		t.truthy(large.buildWrites <= small.buildWrites * 4.5, string.format("build writes grow linearly (25: %d, 100: %d)", small.buildWrites, large.buildWrites))
	end)

	t.test("P1 hovering one element is not reset by clicking a toggle", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })
		local button = tab:AddButton({ Title = "Hover me", Callback = function() end })
		local toggle = tab:AddToggle("T", { Title = "Toggle", Default = false })
		world:settle(2)
		world:hover(button.Frame, true)
		world:settle(2)
		local hovered = button.Frame.BackgroundTransparency
		world:click(toggle.Frame)
		world:settle(2)
		t.equal(button.Frame.BackgroundTransparency, hovered, "hover transparency kept")
		t.equal(#world.errors, 0, "engine errors")
	end)

	t.test("P2 animations share one RenderStepped connection", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })
		local buttons = {}
		for index = 1, 10 do
			buttons[index] = tab:AddButton({ Title = "B" .. index, Callback = function() end })
		end
		task.wait(0.4)
		world:settle(3)
		local idle = world:renderSteppedConnections()
		for _, button in buttons do
			world:hover(button.Frame, true)
		end
		local peak = world:renderSteppedConnections()
		t.truthy(peak - idle <= 1, "extra RenderStepped connections while 10 elements animate: " .. (peak - idle))
		world:settle(3)
		t.equal(world:renderSteppedConnections(), idle, "the shared connection is released when idle")
		t.equal(#world.errors, 0, "engine errors")
	end)

	t.test("P6 switching language with the default font profile writes only Text", function()
		local context = Boot.new()
		local world = context.world
		local Library = context.Library
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })
		for index = 1, 10 do
			tab:AddToggle("L" .. index, { Title = "Auto farm " .. index, Description = "Farms automatically" })
		end
		tab:AddToggle("Farm", { Title = "Auto farm" })
		task.wait(0.4)
		world:settle(2)
		Library.RemoteAssets:ImportLanguage(
			'{"meta":{"locale":"th","id":"test-th","name":"Test TH"},"translations":{"Auto farm":"ฟาร์มอัตโนมัติ"}}'
		)
		Library.I18n:SetMode("community")
		-- Measured around the call only: the splash screen animates meanwhile.
		-- Community packs are applied synchronously.
		local before = table.clone(world.counters.writesByProperty)
		Library.I18n:SetLanguage("th")
		local written = {}
		for property, count in world.counters.writesByProperty do
			if count ~= (before[property] or 0) then
				table.insert(written, property)
			end
		end
		table.sort(written)
		t.equal(table.concat(written, ","), "Text", "properties written by SetLanguage")
		local translated = false
		for _, label in Library.GUI:GetDescendants() do
			translated = translated or (label:IsA("TextLabel") and label.Text == "ฟาร์มอัตโนมัติ")
		end
		t.truthy(translated, "the pack translation was applied")
		t.equal(#world.errors, 0, "engine errors")
	end)

	t.test("P8 the floating button animates on Heartbeat and only while shown", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context)
		window:AddTab({ Title = "Main" })
		task.wait(0.4)
		world:settle(3)
		local floating = context.Library.FloatingToggle
		t.truthy(floating, "floating toggle exists")
		t.equal(world:renderSteppedConnections(), 0, "no RenderStepped connection when idle")
		world:settle(0.5)
		local shown = floating.Stroke.Color
		world:settle(0.5)
		t.notEqual(floating.Stroke.Color, shown, "the stroke animates while shown")
		floating.Button.Visible = false
		local hidden = floating.Stroke.Color
		world:settle(1)
		t.equal(floating.Stroke.Color, hidden, "no updates while hidden")
		t.equal(#world.errors, 0, "engine errors")
	end)

	t.test("P7 machine translations are cached on disk and requests are rate limited", function()
		local function server()
			local count = 0
			return function()
				count += 1
				return { Success = true, StatusCode = 200, Body = '{"translatedText":"[mt ' .. count .. ']"}', Headers = {} }
			end
		end
		local function build(context)
			context.Library.I18n:SetMode("machine")
			context.Library.I18n:SetLanguage("th")
			local window = newWindow(context)
			local tab = window:AddTab({ Title = "Main" })
			for index = 1, 10 do
				tab:AddToggle("M" .. index, { Title = "Machine " .. index })
			end
		end

		local first = Boot.new({ request = server() })
		build(first)
		task.wait(0.3)
		t.truthy(#first.world.requests <= 4, "at most 4 requests in the first second: " .. #first.world.requests)
		task.wait(4.5)
		local sent = #first.world.requests
		t.truthy(sent >= 10, "all texts requested eventually: " .. sent)

		local second = Boot.new({ request = server() })
		for path in first.world.folders do
			second.world.folders[path] = true
		end
		for path, contents in first.world.files do
			second.world.files[path] = contents
		end
		build(second)
		task.wait(0.5)
		t.equal(#second.world.requests, 0, "a second session reuses the saved translations")
		local translated = false
		for _, label in second.Library.GUI:GetDescendants() do
			translated = translated or (label:IsA("TextLabel") and label.Text:find("[mt", 1, true) ~= nil)
		end
		t.truthy(translated, "saved translations are shown")
		t.equal(#first.world.errors + #second.world.errors, 0, "engine errors")
	end)

	t.test("P4 closed dropdowns do not react to layout changes", function()
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
		t.equal(world.counters.propertyWrites - before, 0, "writes caused by moving the window")
		t.equal(#world.errors, 0, "engine errors")
	end)
end
