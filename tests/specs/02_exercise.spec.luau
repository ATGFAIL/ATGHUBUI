--[[
	Broad characterization of behaviour outside the kitchen sink: Workspace
	(search, favorites, profiles, modes), window chrome (minimize, maximize,
	drag, floating toggle), keybind modes, i18n and font APIs, notifications,
	and unloading. Each test uses a fresh world and snapshots what it saw.
]]

local task = require("@lune/task")

local Boot = require("../harness/boot")
local KitchenSink = require("../harness/kitchen_sink")
local Snapshot = require("../harness/snapshot")

local function newWindow(context, extra)
	local env = context.world.env
	local config = {
		Title = "Exercise",
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

return function(t)
	t.test("workspace search, favorites, profiles and modes", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context, { Search = true })
		local main = window:AddTab({ Title = "Main", Icon = "home" })
		local combat = window:AddTab({ Title = "Combat", Icon = "sword" })
		local toggle = main:AddToggle("AutoFarm", { Title = "Auto farm", Default = false })
		local slider = combat:AddSlider("Reach", { Title = "Reach", Default = 10, Min = 0, Max = 20, Rounding = 0 })
		combat:AddButton({ Title = "Hit", Callback = function() end })
		window:SelectTab(1)
		task.wait(0.4)
		world:settle(1)

		local workspace = context.Library.Workspace
		local lines = {}
		local function tabVisibility()
			local parts = {}
			for _, tab in workspace.Tabs do
				table.insert(parts, tab.Name .. "=" .. tostring(tab.Frame.Visible))
			end
			return table.concat(parts, " ")
		end

		workspace.SidebarSearch.Text = "reach"
		task.wait(0.2)
		table.insert(lines, "search reach: " .. tabVisibility())
		local found = workspace:FindEntries("auto")
		for _, entry in found do
			table.insert(lines, "found: " .. entry.Id .. " " .. entry.Type)
		end
		workspace.SidebarSearch.Text = ""
		task.wait(0.1)
		table.insert(lines, "search cleared: " .. tabVisibility())

		workspace:ToggleFavorite(found[1] and found[1].Id or "option:AutoFarm")
		workspace:RenderFavorites()
		table.insert(lines, "panel kind: " .. tostring(workspace.PanelKind))
		workspace:RenderRecent()
		workspace:RenderHistory()
		context.Library:Notify({ Title = "Info", Content = "history entry" })
		workspace:RenderHistory()
		table.insert(lines, "history count: " .. #workspace.Notifications)

		toggle:SetValue(true)
		slider:SetValue(15)
		local saved, saveError = workspace:SaveProfile("Farm")
		table.insert(lines, "save profile: " .. tostring(saved) .. " " .. tostring(saveError))
		toggle:SetValue(false)
		slider:SetValue(2)
		local applied, applyError = workspace:ApplyProfile("Farm")
		table.insert(lines, "apply profile: " .. tostring(applied) .. " " .. tostring(applyError))
		table.insert(lines, "after apply: toggle=" .. tostring(toggle.Value) .. " slider=" .. tostring(slider.Value))
		workspace:RenderProfiles()
		workspace:RenderWorkspaceMenu()

		workspace:SetCompact(true)
		table.insert(lines, "compact tab width: " .. tostring(window.TabWidth))
		workspace:SetCompact(false)
		workspace:SetFocus(true)
		table.insert(lines, "focus: " .. tabVisibility())
		workspace:SetFocus(false)
		workspace:SetArrangeMode(true)
		workspace:MoveTabTo(workspace.Tabs[2], workspace.Tabs[1])
		workspace:SetArrangeMode(false)
		local order = {}
		for _, id in workspace.State.TabOrder do
			table.insert(order, id)
		end
		table.insert(lines, "tab order: " .. table.concat(order, ","))
		workspace:ShowPanel(false)
		workspace:OpenPalette()
		task.wait(0.1)
		table.insert(lines, "focused search: " .. tostring(world.focusedTextBox == workspace.SidebarSearch))
		world:releaseTextBox(false)

		local confirmed = false
		workspace.State.SmartConfirm = false
		workspace:Confirm("Are you sure?", function()
			confirmed = true
		end)
		table.insert(lines, "confirm without dialog: " .. tostring(confirmed))
		task.wait(0.5)
		world:settle(1)
		assertNoErrors(t, world)
		t.snapshot("exercise_workspace", table.concat(lines, "\n"))
		t.snapshot("exercise_workspace_tree", Snapshot.tree(world, context.Library.GUI))
	end)

	t.test("minimize key, floating toggle, maximize and drag", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context)
		window:AddTab({ Title = "Main" })
		window:SelectTab(1)
		task.wait(0.4)
		local lines = {}
		local function visible()
			return tostring(window.Root.Visible)
		end

		world:tapKey("LeftControl")
		task.wait(0.25)
		table.insert(lines, "quick tap ctrl: visible=" .. visible())
		world:pressKey("LeftControl")
		task.wait(0.25)
		world:releaseKey("LeftControl")
		table.insert(lines, "hold ctrl: visible=" .. visible())
		world:pressKey("LeftControl")
		task.wait(0.25)
		world:releaseKey("LeftControl")
		table.insert(lines, "hold ctrl again: visible=" .. visible())

		task.wait(0.3)
		local floating = context.Library.FloatingToggle
		table.insert(lines, "floating toggle exists: " .. tostring(floating ~= nil))
		if floating then
			world:click(floating.Button)
			table.insert(lines, "floating click: visible=" .. visible())
			world:click(floating.Button)
			table.insert(lines, "floating click again: visible=" .. visible())
			world:pressKey("LeftControl")
			world:pressKey("M")
			world:releaseKey("M")
			task.wait(0.25)
			world:releaseKey("LeftControl")
			table.insert(lines, "ctrl+m: visible=" .. visible())
		end

		window.Maximize(true)
		world:settle(2)
		table.insert(lines, "maximized size: " .. tostring(window.Root.Size))
		window.Maximize(false)
		world:settle(2)
		table.insert(lines, "restored size: " .. tostring(window.Root.Size))

		local titleBar = window.TitleBar.Frame
		world:moveMouse(300, 200)
		local input = world:mouseDown(titleBar)
		world:stateOf(titleBar).events.InputChanged:Fire(world:moveMouse(350, 260))
		world:moveMouse(350, 260)
		world:mouseUp(titleBar, input)
		world:settle(1)
		table.insert(lines, "dragged position: " .. tostring(window.Root.Position))
		assertNoErrors(t, world)
		t.snapshot("exercise_chrome", table.concat(lines, "\n"))
	end)

	t.test("keybind modes, slider drag, input variants, element destroy", function()
		local context = Boot.new()
		local world = context.world
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })
		local lines = {}
		local toggleBind = tab:AddKeybind("ToggleBind", {
			Title = "Toggle bind",
			Mode = "Toggle",
			Default = "E",
			Callback = function(value)
				table.insert(lines, "toggle bind " .. KitchenSink.describe(value))
			end,
		})
		local holdBind = tab:AddKeybind("HoldBind", { Title = "Hold bind", Mode = "Hold", Default = "R" })
		local alwaysBind = tab:AddKeybind("AlwaysBind", { Title = "Always", Mode = "Always", Default = "T" })
		local mouseBind = tab:AddKeybind("MouseBind", { Title = "Mouse", Mode = "Hold", Default = "MouseLeft" })
		world:tapKey("E")
		world:tapKey("E")
		world:pressKey("R")
		table.insert(lines, "hold state while down: " .. tostring(holdBind:GetState()))
		world:releaseKey("R")
		table.insert(lines, "hold state after up: " .. tostring(holdBind:GetState()))
		table.insert(lines, "always: " .. tostring(alwaysBind:GetState()))
		table.insert(lines, "mouse bind idle: " .. tostring(mouseBind:GetState()))
		toggleBind:SetValue("F", "Hold")
		table.insert(lines, "after SetValue: " .. toggleBind.Value .. " " .. toggleBind.Mode)

		local numeric = tab:AddInput("Numeric", { Title = "Numeric", Default = "1", Numeric = true, Finished = false })
		local numericBox = KitchenSink.findDescendant(world, numeric.Frame, function(_, state)
			return state.class == "TextBox"
		end)
		numericBox.Text = "12"
		numericBox.Text = "12a"
		table.insert(lines, "numeric value: " .. tostring(numeric.Value))
		local limited = tab:AddInput("Limited", { Title = "Limited", Default = "", MaxLength = 3, Finished = false })
		limited:SetValue("abcdef")
		table.insert(lines, "limited value: " .. tostring(limited.Value))

		local slider = tab:AddSlider("Drag", { Title = "Drag", Default = 1, Min = 0, Max = 100, Rounding = 2 })
		local thumb = KitchenSink.findDescendant(world, slider.Frame, function(_, state)
			return state.class == "ImageLabel"
		end)
		local pressed = world:mouseDown(thumb)
		world:moveMouse(10000, 0)
		world:mouseUp(thumb, pressed)
		table.insert(lines, "slider after drag right: " .. KitchenSink.describe(slider.Value))
		local valueBox = KitchenSink.findDescendant(world, slider.Frame, function(_, state)
			return state.class == "TextBox"
		end)
		world:typeInto(valueBox, "42,5", true)
		table.insert(lines, "slider after typing: " .. KitchenSink.describe(slider.Value))

		local paragraph = tab:AddParagraph({ Title = "Status", Content = "idle" })
		paragraph:SetTitle("Status 2")
		paragraph:SetDesc("running")
		paragraph:SetDesc("")
		local button = tab:AddButton({ Title = "Temp", Callback = function() end })
		button:Destroy()
		numeric:Destroy()
		table.insert(lines, "options after destroy: Numeric=" .. tostring(context.Library.Options.Numeric))
		task.wait(0.3)
		world:settle(1)
		assertNoErrors(t, world)
		t.snapshot("exercise_elements", table.concat(lines, "\n"))
		t.snapshot("exercise_elements_tree", Snapshot.tree(world, context.Library.GUI))
	end)

	t.test("i18n packs, machine translation and fonts", function()
		local responses = 0
		local context = Boot.new({
			request = function(options)
				responses += 1
				local body = context and nil
				return {
					Success = true,
					StatusCode = 200,
					Body = '{"translatedText":"[mt] ' .. tostring(responses) .. '"}',
					Headers = {},
				}
			end,
		})
		local world = context.world
		local Library = context.Library
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })
		tab:AddToggle("Farm", { Title = "Auto farm", Description = "Farms automatically" })
		tab:AddButton({ Title = "Teleport", Callback = function() end })
		window:SelectTab(1)
		task.wait(0.4)
		local lines = {}
		local assets = Library.RemoteAssets
		local pack, packError = assets:ImportLanguage(
			'{"meta":{"locale":"th","id":"test-th","name":"Test TH"},"translations":{"Auto farm":"ฟาร์มอัตโนมัติ"}}'
		)
		table.insert(lines, "pack: " .. tostring(pack and pack.Id) .. " " .. tostring(packError))
		Library.I18n:SetMode("community")
		Library.I18n:SetLanguage("th")
		task.wait(0.2)
		local translated = KitchenSink.findDescendant(world, Library.GUI, function(_, state)
			return state.class == "TextLabel" and state.props.Text == "ฟาร์มอัตโนมัติ"
		end)
		table.insert(lines, "community translation applied: " .. tostring(translated ~= nil))
		table.insert(lines, "requests in community mode: " .. #world.requests)
		Library.I18n:SetMode("machine")
		task.wait(0.5)
		table.insert(lines, "requests in machine mode > 0: " .. tostring(#world.requests > 0))
		local directResult
		Library.Translation:TranslateText("Hello", "th", function(result)
			directResult = result
		end)
		task.wait(0.3)
		table.insert(lines, "TranslateText callback: " .. tostring(directResult ~= nil))
		Library.I18n:SetLanguage("en")
		task.wait(0.1)
		local exported, exportError = assets:ExportDefaultLanguagePack("ja")
		table.insert(lines, "export: " .. tostring(exported ~= nil) .. " copied=" .. tostring(exported and exported.Copied) .. " " .. tostring(exportError))
		table.insert(lines, "clipboard has template: " .. tostring(world.clipboard ~= nil and world.clipboard:find('"ja"', 1, true) ~= nil))
		table.insert(lines, "languages: " .. table.concat(Library.I18n:GetLanguageOptions(), ", "))

		local profile, fontError = assets:ImportFont("rbxassetid://12187365364", { Name = "Asset font", Target = "both" })
		table.insert(lines, "font profile: " .. tostring(profile and profile.Id) .. " " .. tostring(fontError))
		local ok, styleError = Library.Fonts:SetTextStyleConfig({ Enabled = true, SizeScale = 120, Weight = "Bold" })
		table.insert(lines, "text style: " .. tostring(ok) .. " " .. tostring(styleError))
		Library.Fonts:ApplyProfile("default")
		Library.Fonts:SetTextStyleConfig({ Enabled = false })
		local status = Library.Customization:GetStatus()
		table.insert(lines, "status: " .. Snapshot.value(status, world))
		task.wait(0.3)
		world:settle(1)
		assertNoErrors(t, world)
		t.snapshot("exercise_i18n", table.concat(lines, "\n"))
	end)

	t.test("notifications close, library destroy and title bar close", function()
		local context = Boot.new()
		local world = context.world
		local Library = context.Library
		local window = newWindow(context)
		window:AddTab({ Title = "Main" })
		local lines = {}
		local closing = Library:Notify({ Title = "Error", Content = "short", Duration = 0.2 })
		local manual = Library:Notify({ Title = "Info", Content = "manual" })
		manual:Close()
		task.wait(1)
		world:settle(1)
		table.insert(lines, "closing notification destroyed: " .. tostring(world:isDestroyed(closing.Holder)))
		table.insert(lines, "manual notification destroyed: " .. tostring(world:isDestroyed(manual.Holder)))

		-- ScreenGuis another script (or the game) might own.
		local names = { "ChatGui", "StatGui", "CombatGui", "FluentToggleGui", "OtherHub" }
		for _, name in names do
			local gui = world.env.Instance.new("ScreenGui")
			gui.Name = name
			gui.Parent = world.CoreGui
		end
		local closeButton = window.TitleBar.CloseButton.Frame
		world:click(closeButton)
		task.wait(0.05)
		local yes = KitchenSink.findTextButton(world, window.Root, "Yes")
		table.insert(lines, "close dialog shown: " .. tostring(yes ~= nil))
		if yes then
			world:click(yes)
		end
		task.wait(0.5)
		local remaining = {}
		for _, child in world.CoreGui:GetChildren() do
			table.insert(remaining, child.Name)
		end
		table.sort(remaining)
		table.insert(lines, "CoreGui after close: " .. table.concat(remaining, ","))
		table.insert(lines, "unloaded: " .. tostring(Library.Unloaded))
		table.insert(lines, "gui destroyed: " .. tostring(world:isDestroyed(Library.GUI)))
		assertNoErrors(t, world)
		t.snapshot("exercise_unload", table.concat(lines, "\n"))
	end)
end
