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
end
