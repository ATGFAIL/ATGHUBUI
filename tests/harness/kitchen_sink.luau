--[[
	Builds a window that uses every element, component and public method of
	the library, drives each one the way a user would, and records every
	callback in `log`. Used by the characterization snapshot (phase 0 / R) and
	by later specs as a known-good fixture.

	Timing: some library code waits in real time (task.wait), so the builder
	waits in real time as well and steps the fake frame clock to let springs
	settle. Callers should call context.world:settle() before snapshotting.
]]

local task = require("@lune/task")

local Engine = require("./fake_roblox")

local KitchenSink = {}

local function findDescendant(world, root, predicate)
	for _, instance in root:GetDescendants() do
		if predicate(instance, world:stateOf(instance)) then
			return instance
		end
	end
	return nil
end

local function findTextButton(world, root, text)
	return findDescendant(world, root, function(instance, state)
		if state.class ~= "TextButton" then
			return false
		end
		if state.props.Text == text then
			return true
		end
		for _, child in instance:GetChildren() do
			local childState = world:stateOf(child)
			if childState.class == "TextLabel" and childState.props.Text == text then
				return true
			end
		end
		return false
	end)
end
KitchenSink.findDescendant = findDescendant
KitchenSink.findTextButton = findTextButton

local function describe(value)
	local kind = Engine.typeof(value)
	if kind == "table" then
		local keys = {}
		for key, item in value do
			table.insert(keys, tostring(key) .. "=" .. tostring(item))
		end
		table.sort(keys)
		return "table{" .. table.concat(keys, ",") .. "}"
	end
	return kind .. ":" .. tostring(value)
end
KitchenSink.describe = describe

function KitchenSink.build(context, options)
	options = options or {}
	local world = context.world
	local env = world.env
	local Library = context.Library
	local log = {}
	local function record(label, ...)
		local parts = {}
		for index = 1, select("#", ...) do
			table.insert(parts, describe((select(index, ...))))
		end
		table.insert(log, label .. "(" .. table.concat(parts, ", ") .. ")")
	end

	local window = Library:CreateWindow({
		Title = "Kitchen Sink",
		SubTitle = "harness",
		TabWidth = 160,
		Size = env.UDim2.fromOffset(580, 460),
		Acrylic = false,
		Theme = "Dark",
		MinimizeKey = env.Enum.KeyCode.LeftControl,
	})

	local tabs = {
		Main = window:AddTab({ Title = "Main", Icon = "home" }),
		Elements = window:AddTab({ Title = "Elements", Icon = "list" }),
		Settings = window:AddTab({ Title = "Settings", Icon = "settings" }),
	}
	local Options = Library.Options

	-- Main tab: buttons, paragraph, notifications and dialogs
	tabs.Main:AddParagraph({ Title = "Welcome", Content = "Paragraph content" })
	local button = tabs.Main:AddButton({
		Title = "Plain button",
		Description = "does nothing dangerous",
		Callback = function()
			record("button")
		end,
	})
	local dangerous = tabs.Main:AddButton({
		Title = "Reset stats",
		Description = "smart confirm keyword",
		Callback = function()
			record("reset")
		end,
	})

	-- Elements tab: one of every input element, inside a section
	local section = tabs.Elements:AddSection("Inputs")
	local toggle = section:AddToggle("Toggle", {
		Title = "Toggle",
		Default = false,
		Callback = function(value)
			record("toggle", value)
		end,
	})
	local slider = section:AddSlider("Slider", {
		Title = "Slider",
		Description = "0 to 10",
		Default = 5,
		Min = 0,
		Max = 10,
		Rounding = 1,
		Callback = function(value)
			record("slider", value)
		end,
	})
	local dropdown = section:AddDropdown("Dropdown", {
		Title = "Dropdown",
		Values = { "Alpha", "Beta", "Gamma", "[COLOR:255,0,0]Red" },
		Multi = false,
		Default = 1,
		Callback = function(value)
			record("dropdown", value)
		end,
	})
	local multi = section:AddDropdown("MultiDropdown", {
		Title = "Multi",
		Values = { "One", "Two", "Three" },
		Multi = true,
		Default = { "Two" },
		Callback = function(value)
			record("multi", value)
		end,
	})
	local input = section:AddInput("Input", {
		Title = "Input",
		Default = "hello",
		Placeholder = "type",
		Numeric = false,
		Finished = true,
		Callback = function(value)
			record("input", value)
		end,
	})
	local keybind = section:AddKeybind("Keybind", {
		Title = "Keybind",
		Mode = "Toggle",
		Default = "Q",
		Callback = function(value)
			record("keybind", value)
		end,
		ChangedCallback = function(value)
			record("keybindChanged", value)
		end,
	})
	local colorpicker = section:AddColorpicker("Colorpicker", {
		Title = "Colorpicker",
		Default = env.Color3.fromRGB(96, 205, 255),
		Transparency = 0.25,
		Callback = function(value)
			record("color", value)
		end,
	})

	toggle:OnChanged(function(value)
		record("toggle.OnChanged", value)
	end)
	slider:OnChanged(function(value)
		record("slider.OnChanged", value)
	end)

	-- Interactions -------------------------------------------------------
	world:settle(0.5)
	task.wait(0.3)

	world:click(toggle.Frame)
	world:click(toggle.Frame)
	slider:SetValue(7)
	slider:SetValue(3.33)
	toggle:SetValue(true)

	-- open the dropdown, pick "Beta", close it
	local dropdownButton = findDescendant(world, dropdown.Frame, function(_, state)
		return state.class == "TextButton"
	end)
	world:click(dropdownButton)
	task.wait(0.05)
	local betaLabel = findDescendant(world, Library.GUI, function(_, state)
		return state.class == "TextLabel" and state.props.Name == "ButtonLabel" and state.props.Text == "Beta"
	end)
	if betaLabel then
		local pressed = world:mouseDown(betaLabel)
		world:mouseUp(betaLabel, pressed)
	else
		record("missing Beta row")
	end
	world:click(dropdownButton)
	task.wait(0.3)
	dropdown:SetValue("Gamma")
	dropdown:SetValues({ "Gamma", "Delta" })
	multi:SetValue({ One = true, Three = true })

	local textBox = findDescendant(world, input.Frame, function(_, state)
		return state.class == "TextBox"
	end)
	world:typeInto(textBox, "typed text", true)

	-- keybind: start picking, then press K
	local keybindButton = findDescendant(world, keybind.Frame, function(_, state)
		return state.class == "TextButton"
	end)
	world:mouseDown(keybindButton)
	task.wait(0.3)
	world:pressKey("K")
	world:releaseKey("K")
	task.wait(0.05)
	world:tapKey("K")
	task.wait(0.05)

	colorpicker:SetValueRGB(env.Color3.fromRGB(255, 0, 0), 0.5)

	-- open the colorpicker dialog and press Done
	world:click(colorpicker.Frame)
	task.wait(0.05)
	local done = findTextButton(world, window.Root, "Done")
	if done then
		world:click(done)
	else
		record("missing Done")
	end
	task.wait(0.3)

	-- smart-confirm button opens a dialog; press Continue
	world:click(dangerous.Frame)
	task.wait(0.05)
	local continue = findTextButton(world, window.Root, "Continue")
	if continue then
		world:click(continue)
	else
		record("no confirm dialog")
	end
	task.wait(0.3)
	world:click(button.Frame)

	window:Dialog({
		Title = "Question",
		Content = "Pick one",
		Buttons = {
			{
				Title = "Yes",
				Callback = function()
					record("dialog yes")
				end,
			},
			{ Title = "No" },
		},
	})
	task.wait(0.05)
	local yes = findTextButton(world, window.Root, "Yes")
	if yes then
		world:click(yes)
	end
	task.wait(0.3)

	Library:Notify({ Title = "Success", Content = "Saved", SubContent = "sub" })
	Library:Notify({
		Title = "Warning",
		Content = "With buttons",
		Buttons = {
			{
				Text = "OK",
				KeepOpen = true,
				Callback = function()
					record("notify button")
				end,
			},
		},
	})

	-- tabs and themes
	window:SelectTab(2)
	task.wait(0.3)
	window:SelectTab(1)
	task.wait(0.3)
	for _, themeName in Library.Themes do
		Library:SetTheme(themeName)
	end
	Library:SetTheme("Dark")
	Library:ToggleTransparency(false)
	Library:ToggleTransparency(true)

	-- InterfaceManager on the settings tab
	local interfaceManager
	if options.interfaceManager ~= false then
		interfaceManager = context.loadInterfaceManager()
		interfaceManager:SetLibrary(Library)
		interfaceManager:SetFolder("KitchenSink")
		interfaceManager:BuildInterfaceSection(tabs.Settings, { ScriptId = "kitchen.sink", SourceLocale = "en" })
		task.wait(0.5)
	end

	world:settle(3)
	task.wait(0.5)
	world:settle(1)

	return {
		window = window,
		tabs = tabs,
		log = log,
		Options = Options,
		elements = {
			button = button,
			dangerous = dangerous,
			toggle = toggle,
			slider = slider,
			dropdown = dropdown,
			multi = multi,
			input = input,
			keybind = keybind,
			colorpicker = colorpicker,
		},
		interfaceManager = interfaceManager,
	}
end

return KitchenSink
