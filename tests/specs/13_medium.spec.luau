--[[
	Phase 2: medium bugs, opt-in defaults and UX. Each test failed on the code
	before its change; names carry the plan item.
]]

local task = require("@lune/task")

local Boot = require("../harness/boot")
local KitchenSink = require("../harness/kitchen_sink")

local function newWindow(context, extra)
	local env = context.world.env
	local config = {
		Title = "Medium",
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

local function openDropdown(world, dropdown)
	local button = KitchenSink.findDescendant(world, dropdown.Frame, function(_, state)
		return state.class == "TextButton"
	end)
	world:click(button)
	task.wait(0.05)
	return button
end

return function(t)
	t.test("2.1 broken enum names in saved data do not stop a profile from loading", function()
		local context = Boot.new()
		local world = context.world
		local Library = context.Library
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })
		local toggle = tab:AddToggle("Farm", { Title = "Farm", Default = false })
		local keybind = tab:AddKeybind("Bind", { Title = "Bind", Default = "E", Mode = "Hold" })
		Library.Workspace.State.Profiles.Broken = {
			Bind = { Type = "Keybind", Value = { __atg = "Enum", Type = "NotAnEnum", Name = "Nope" } },
			Farm = { Type = "Toggle", Value = true },
		}
		local ok, err = pcall(function()
			return Library.Workspace:ApplyProfile("Broken")
		end)
		t.truthy(ok, "ApplyProfile raised: " .. tostring(err))
		t.equal(toggle.Value, true, "the rest of the profile is applied")

		keybind:SetValue("NotAKey", "Hold")
		local stateOk, stateErr = pcall(function()
			return keybind:GetState()
		end)
		t.truthy(stateOk, "GetState raised: " .. tostring(stateErr))

		local floating = Library:CreateFloatingToggle({ ForceShowButton = true, Keybind = { Key = "NotAKey", Modifier = "AlsoNot" } })
		t.truthy(floating, "a floating toggle with bad key names still builds")
		assertNoErrors(t, world)
	end)

	t.test("2.2 SafeCallback reports errors that are not strings", function()
		local context = Boot.new()
		local world = context.world
		newWindow(context)
		local ok, err = pcall(function()
			context.Library:SafeCallback(function()
				error({ code = 42 })
			end)
		end)
		t.truthy(ok, "SafeCallback raised: " .. tostring(err))
		assertNoErrors(t, world)
	end)

	t.test("2.3 open dropdowns close when the window is minimized or the tab changes", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context)
		local first = window:AddTab({ Title = "First" })
		window:AddTab({ Title = "Second" })
		window:SelectTab(1)
		local dropdown = first:AddDropdown("D", { Title = "D", Values = { "a", "b" }, Default = 1 })
		openDropdown(world, dropdown)
		t.truthy(dropdown.Opened, "opened")
		window:Minimize()
		t.falsy(dropdown.Opened, "closed by minimizing")
		window:Minimize()
		openDropdown(world, dropdown)
		t.truthy(dropdown.Opened, "opened again")
		window:SelectTab(2)
		t.falsy(dropdown.Opened, "closed by changing tab")
		task.wait(0.1)
		assertNoErrors(t, world)
	end)

	t.test("2.4 keybind SetValue(nil), touch while picking, and two keys at once", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })
		local keybind = tab:AddKeybind("Bind", { Title = "Bind", Default = "E", Mode = "Toggle" })
		local ok, err = pcall(function()
			keybind:SetValue(nil)
		end)
		t.truthy(ok, "SetValue(nil) raised: " .. tostring(err))
		t.equal(keybind.Value, "E", "SetValue(nil) keeps the key")

		local display = KitchenSink.findDescendant(world, keybind.Frame, function(_, state)
			return state.class == "TextButton"
		end)
		local label = KitchenSink.findDescendant(world, display, function(_, state)
			return state.class == "TextLabel"
		end)
		world:click(display)
		task.wait(0.3)
		t.equal(label.Text, "...", "waiting for a key")
		world:touch(nil)
		t.equal(label.Text, "E", "a touch cancels picking")
		local toggled = keybind.Toggled
		world:tapKey("E")
		t.equal(keybind.Toggled, not toggled, "the keybind works again after cancelling")

		world:click(display)
		task.wait(0.3)
		world:pressKey("A")
		world:pressKey("B")
		world:releaseKey("A")
		t.equal(keybind.Value, "A", "first key pressed is picked")
		world:releaseKey("B")
		t.equal(keybind.Value, "A", "a second key released later does not replace it")
		assertNoErrors(t, world)
	end)
	t.test("2.6 guessing confirmations from button titles is opt-in and whole-word", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })
		local clicks = 0
		local button = tab:AddButton({ Title = "Reset stats", Callback = function()
			clicks += 1
		end })
		world:click(button.Frame)
		task.wait(0.1)
		t.equal(clicks, 1, "runs without a dialog by default")
		local explicit = tab:AddButton({ Title = "Save", Confirm = true, Callback = function()
			clicks += 1
		end })
		world:click(explicit.Frame)
		task.wait(0.1)
		t.equal(clicks, 1, "an explicit Confirm still asks")
		local continue = KitchenSink.findTextButton(world, window.Root, "Continue")
		t.truthy(continue, "confirm dialog shown")
		world:click(continue)
		task.wait(0.1)
		t.equal(clicks, 2, "runs after confirming")
		assertNoErrors(t, world)

		local opted = Boot.new()
		local optedWindow = newWindow(opted, { SmartConfirm = true })
		local optedTab = optedWindow:AddTab({ Title = "Main" })
		local guessed = 0
		local reset = optedTab:AddButton({ Title = "Reset stats", Callback = function()
			guessed += 1
		end })
		local clearance = optedTab:AddButton({ Title = "Clearance sale", Callback = function()
			guessed += 10
		end })
		opted.world:click(clearance.Frame)
		task.wait(0.1)
		t.equal(guessed, 10, "a word inside another word does not ask")
		opted.world:click(reset.Frame)
		task.wait(0.1)
		t.equal(guessed, 10, "a destructive word asks when SmartConfirm is on")
		assertNoErrors(t, opted.world)
	end)

	t.test("2.7 sidebar search is opt-in; the Workspace API still works", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })
		tab:AddToggle("Farm", { Title = "Auto farm" })
		local workspace = context.Library.Workspace
		t.equal(workspace.SidebarSearch, nil, "no search box by default")
		t.equal(window.TabArea.Position, world.env.UDim2.new(0, 12, 0, 54), "tabs keep Fluent's position")
		t.equal(#workspace:FindEntries("farm"), 1, "entries are still registered")
		world:pressKey("LeftControl")
		world:tapKey("K")
		world:releaseKey("LeftControl")
		task.wait(0.1)
		workspace:SetCompact(true)
		workspace:SetCompact(false)
		t.equal(window.TabArea.Position, world.env.UDim2.new(0, 12, 0, 54), "leaving compact mode restores the same position")
		workspace:RenderFavorites()
		assertNoErrors(t, world)

		local opted = Boot.new()
		local optedWindow = newWindow(opted, { Search = true })
		optedWindow:AddTab({ Title = "Main" })
		t.truthy(opted.Library.Workspace.SidebarSearch, "search box with Search = true")
		t.equal(optedWindow.TabArea.Position, opted.world.env.UDim2.new(0, 12, 0, 88), "tabs move below the search box")
		assertNoErrors(t, opted.world)
	end)

	t.test("2.8 the splash screen is opt-in", function()
		local context = Boot.new()
		local world = context.world
		t.equal(world.CoreGui:FindFirstChild("CoreSplash"), nil, "no splash by default")
		t.equal(world.Lighting:FindFirstChild("CoreSplashBlur"), nil, "no splash blur by default")
		newWindow(context, { Splash = true })
		t.truthy(world.CoreGui:FindFirstChild("CoreSplash"), "CreateWindow{Splash = true} shows it")
		context.Library:ShowSplash()
		local count = 0
		for _, child in world.CoreGui:GetChildren() do
			if child.Name == "CoreSplash" then
				count += 1
			end
		end
		t.equal(count, 1, "shown once")

		local early = Boot.new({ genv = { ATGSplash = true } })
		t.truthy(early.world.CoreGui:FindFirstChild("CoreSplash"), "getgenv().ATGSplash = true shows it on load")
		assertNoErrors(t, world)
	end)

	t.test("2.9 Recent lists controls the user changed, not values set by scripts", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })
		local toggle = tab:AddToggle("Farm", { Title = "Farm" })
		local slider = tab:AddSlider("Speed", { Title = "Speed", Default = 1, Min = 0, Max = 10, Rounding = 0 })
		local workspace = context.Library.Workspace
		toggle:SetValue(true)
		slider:SetValue(5)
		t.equal(#workspace.State.Recent, 0, "script SetValue is not recent")
		world:click(toggle.Frame)
		t.equal(workspace.State.Recent[1], "option:Farm", "a click is recent")
		assertNoErrors(t, world)
	end)
	t.test("2.5 scrolling a dropdown list does not pick the row under the finger", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })
		local values = {}
		for index = 1, 30 do
			values[index] = "Item " .. index
		end
		local dropdown = tab:AddDropdown("Long", { Title = "Long", Values = values, Default = 1 })
		openDropdown(world, dropdown)
		task.wait(0.2)
		local function rowFor(text)
			local label = KitchenSink.findDescendant(world, context.Library.GUI, function(_, state)
				return state.class == "TextLabel" and state.props.Name == "ButtonLabel" and state.props.Text == text
			end)
			return label and label.Parent.Parent
		end
		local row = rowFor("Item 3")
		t.truthy(row, "row found")
		local label = KitchenSink.findDescendant(world, row, function(_, state)
			return state.props.Name == "ButtonLabel"
		end)
		local scroll = row.Parent
		-- A finger lands on the row's label, drags the list, and lifts.
		local input = world:mouseDown(label)
		t.equal(dropdown.Value, "Item 1", "pressing does not select")
		scroll.CanvasPosition = world.env.Vector2.new(0, 60)
		world:mouseUp(row, input)
		t.equal(dropdown.Value, "Item 1", "a press that scrolled the list selects nothing")
		input = world:mouseDown(label)
		world:mouseUp(row, input)
		t.equal(dropdown.Value, "Item 3", "a tap selects on release")
		assertNoErrors(t, world)
	end)
	t.test("2.10 a window larger than the screen is fitted and cannot be lost off screen", function()
		local context = Boot.new({ viewport = { X = 400, Y = 320 } })
		local world = context.world
		local window = newWindow(context)
		window:AddTab({ Title = "Main" })
		world:settle(2)
		t.truthy(window.Size.X.Offset <= 400 - 32, "width fits: " .. tostring(window.Size))
		t.truthy(window.Size.Y.Offset <= 320 - 32, "height fits: " .. tostring(window.Size))
		local titleBar = window.TitleBar.Frame
		world:moveMouse(100, 20)
		local input = world:mouseDown(titleBar)
		world:stateOf(titleBar).events.InputChanged:Fire(world:moveMouse(900, -300))
		world:moveMouse(900, -300)
		world:stateOf(world.UserInputService).extra.InputChanged:Fire(input)
		world:mouseUp(titleBar, input)
		world:settle(1)
		t.truthy(window.Position.X.Offset <= 400 - 40, "title bar stays on screen horizontally: " .. tostring(window.Position))
		t.truthy(window.Position.Y.Offset >= 0, "title bar stays on screen vertically: " .. tostring(window.Position))
		assertNoErrors(t, world)
	end)

	t.test("2.11 tapping the slider rail sets the value", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })
		local slider = tab:AddSlider("S", { Title = "S", Default = 0, Min = 0, Max = 100, Rounding = 0 })
		world:settle(1)
		local hitArea = KitchenSink.findDescendant(world, slider.Frame, function(_, state)
			return state.props.Name == "HitArea"
		end)
		t.truthy(hitArea, "rail hit area")
		local rail = hitArea and hitArea.Parent
		if rail then
			local x = rail.AbsolutePosition.X + rail.AbsoluteSize.X * 0.75
			world:moveMouse(x, rail.AbsolutePosition.Y)
			local input = world:mouseDown(hitArea)
			world:mouseUp(nil, input)
			t.near(slider.Value, 75, 1, "value from the tap position")
		end
		assertNoErrors(t, world)
	end)
	t.test("2.12 search box, Select All and input lines follow the theme", function()
		local context = Boot.new()
		local world = context.world
		local Library = context.Library
		local rgb = world.env.Color3.fromRGB
		local window = newWindow(context, { Search = true })
		local tab = window:AddTab({ Title = "Main" })
		tab:AddDropdown("Multi", { Title = "Multi", Values = { "a" }, Multi = true })
		local input = tab:AddInput("Name", { Title = "Name", Default = "" })
		Library:SetTheme("Light")
		local search = Library.Workspace.SidebarSearch
		local selectAll = KitchenSink.findTextButton(world, Library.GUI, "✅ Select All")
		t.equal(search.BackgroundColor3, rgb(252, 252, 252), "search box uses Light DialogInput")
		t.equal(search.TextColor3, rgb(10, 10, 10), "search text uses Light Text")
		t.equal(selectAll.TextColor3, rgb(0, 103, 192), "Select All uses Light Accent")
		local box = KitchenSink.findDescendant(world, input.Frame, function(_, state)
			return state.class == "TextBox"
		end)
		world:focusTextBox(box)
		task.wait(0.4)
		local highlight, baseLine = nil, nil
		for _, child in box.Parent.Parent:GetChildren() do
			if child:IsA("Frame") and child.Size.Y.Offset == 2 then
				if child.ZIndex == 2 then
					highlight = child
				else
					baseLine = child
				end
			end
		end
		t.equal(highlight and highlight.BackgroundColor3, rgb(0, 103, 192), "focused underline uses Accent")
		t.equal(baseLine and baseLine.BackgroundColor3, rgb(10, 10, 10), "base line uses Text")
		world:releaseTextBox(false)
		assertNoErrors(t, world)
	end)
	t.test("2.13 the RGB theme cycles its accent colors and stops when not needed", function()
		local context = Boot.new()
		local world = context.world
		local Library = context.Library
		local rgb = world.env.Color3.fromRGB
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })
		local toggle = tab:AddToggle("T", { Title = "T" })
		local border = toggle.Frame:FindFirstChildOfClass("UIStroke")
		t.truthy(border, "element border")
		task.wait(0.4)
		local idle = world:heartbeatConnections()
		Library:SetTheme("RGB")
		world:settle(0.5)
		local first = border.Color
		world:settle(1)
		local second = border.Color
		t.notEqual(first, rgb(255, 0, 255), "not the static magenta")
		t.notEqual(first, second, "the color moves")
		t.equal(world:heartbeatConnections(), idle + 1, "one loop while RGB is active")

		window:Minimize()
		local frozen = border.Color
		world:settle(1)
		t.equal(border.Color, frozen, "no updates while minimized")
		window:Minimize()

		Library:SetTheme("Dark")
		t.equal(world:heartbeatConnections(), idle, "loop stopped by another theme")
		t.equal(border.Color, rgb(35, 35, 35), "Dark border restored")
		assertNoErrors(t, world)
	end)
end
