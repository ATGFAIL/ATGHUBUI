--[[
	Phase 3: translation privacy and safety. Machine translation sends text to
	a remote server, so it must be opt-in, must never see dynamic text, and
	must stay within a quota. Each test failed on the code before the change.
]]

local task = require("@lune/task")

local Boot = require("../harness/boot")
local KitchenSink = require("../harness/kitchen_sink")

local function translatingServer()
	local count = 0
	return function(options)
		count += 1
		return {
			Success = true,
			StatusCode = 200,
			Body = '{"translatedText":"[mt ' .. count .. ']"}',
			Headers = {},
		}
	end
end

local function newWindow(context)
	local env = context.world.env
	return context.Library:CreateWindow({
		Title = "Translate",
		SubTitle = "spec",
		TabWidth = 160,
		Size = env.UDim2.fromOffset(580, 460),
		Acrylic = false,
		Theme = "Dark",
		MinimizeKey = env.Enum.KeyCode.LeftControl,
	})
end

local function sentTexts(world)
	local texts = {}
	for _, request in world.requests do
		local body = request.Body
		if type(body) == "string" and body:find('"q"', 1, true) then
			local decoded = world.env.game:GetService("HttpService"):JSONDecode(body)
			table.insert(texts, decoded.q)
		end
	end
	table.sort(texts)
	return texts
end

local function assertNoErrors(t, world)
	t.equal(#world.errors, 0, "engine errors:\n" .. table.concat(world.errors, "\n---\n"))
end

return function(t)
	t.test("3.1 machine translation is off by default", function()
		local context = Boot.new({ request = translatingServer() })
		local world = context.world
		t.equal(context.Library.I18n.Mode, "community", "default mode")
		context.Library.I18n:SetLanguage("th")
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })
		for index = 1, 10 do
			tab:AddToggle("R" .. index, { Title = "Feature " .. index })
		end
		task.wait(0.5)
		t.equal(#world.requests, 0, "requests while building a UI")
		context.Library.I18n:SetMode("nonsense")
		t.equal(context.Library.I18n.Mode, "community", "an unknown mode falls back to community")
		assertNoErrors(t, world)
	end)

	t.test("3.4 dynamic text is never sent for machine translation", function()
		local context = Boot.new({ request = translatingServer() })
		local world = context.world
		local Library = context.Library
		Library.I18n:SetMode("machine")
		Library.I18n:SetLanguage("th")
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })
		local paragraph = tab:AddParagraph({ Title = "Status", Content = "Idle" })
		local toggle = tab:AddToggle("Farm", { Title = "Auto farm" })
		task.wait(0.5)
		local before = #sentTexts(world)
		paragraph:SetDesc("Coins: 12345")
		paragraph:SetTitle("Player: SecretName")
		toggle:SetDesc("Last run 12:01")
		Library:Notify({ Title = "Reward", Content = "You got 50 coins", SubContent = "from SecretName" })
		task.wait(0.5)
		local texts = sentTexts(world)
		t.truthy(before > 0, "static text is still machine translated in machine mode")
		for _, text in texts do
			t.falsy(text:find("12345", 1, true) or text:find("SecretName", 1, true) or text:find("50 coins", 1, true) or text:find("12:01", 1, true), "sent dynamic text: " .. text)
		end
		assertNoErrors(t, world)
	end)

	t.test("3.5 the machine quota is per language and survives revisions", function()
		local context = Boot.new({ request = translatingServer() })
		local world = context.world
		local I18n = context.Library.I18n
		I18n.MachineRequestLimit = 3
		I18n:SetMode("machine")
		I18n:SetLanguage("th")
		local window = newWindow(context)
		local tab = window:AddTab({ Title = "Main" })
		for index = 1, 6 do
			tab:AddToggle("Q" .. index, { Title = "Quota " .. index })
		end
		task.wait(0.5)
		local afterBuild = #world.requests
		t.truthy(afterBuild <= 3, "requests after build: " .. afterBuild)
		I18n:SetLanguage("en")
		I18n:SetLanguage("th")
		task.wait(0.5)
		t.equal(#world.requests, afterBuild, "switching language does not reset the quota")
		I18n:SetLanguage("vi")
		task.wait(0.5)
		t.truthy(#world.requests > afterBuild, "another language has its own quota")
		assertNoErrors(t, world)
	end)

	t.test("3.5 TranslateText follows the mode and the quota", function()
		local context = Boot.new({ request = translatingServer() })
		local world = context.world
		local I18n = context.Library.I18n
		local results = {}
		I18n:TranslateText("Hello there", "th", function(text)
			table.insert(results, text)
		end)
		task.wait(0.2)
		t.equal(#world.requests, 0, "community mode sends nothing")
		t.equal(results[1], "Hello there", "community mode returns the source text")
		I18n:SetMode("machine")
		I18n:TranslateText("Hello there", "th", function(text)
			table.insert(results, text)
		end)
		task.wait(0.2)
		t.equal(#world.requests, 1, "machine mode sends one request")
		t.equal(results[2], "[mt 1]", "machine translation returned")
		t.equal(I18n.MachineRequestsByLocale.th, 1, "counted against the quota")
		assertNoErrors(t, world)
	end)

	t.test("3.6 an exact-locale pack wins over a base-locale pack", function()
		local context = Boot.new()
		local world = context.world
		local Library = context.Library
		local window = newWindow(context)
		window:AddTab({ Title = "Hello" })
		Library.RemoteAssets:ImportLanguage('{"meta":{"locale":"pt-br","id":"br"},"translations":{"Hello":"Olá BR"}}')
		Library.RemoteAssets:ImportLanguage('{"meta":{"locale":"pt-pt","id":"pt"},"translations":{"Hello":"Olá PT"}}')
		Library.I18n:SetLanguage("pt-br")
		local label = KitchenSink.findDescendant(world, Library.GUI, function(instance)
			return instance.Name == "TabLabel"
		end)
		t.equal(label.Text, "Olá BR")
		t.equal(Library.I18n:GetLanguageCode("th-TH"), "th-th", "a locale without a pack is accepted")
		t.equal(Library.I18n:GetLanguageCode("not a locale"), "en", "invalid text falls back to the source")
		Library.I18n:SetLanguage("pt-ao")
		t.equal(label.Text, "Olá PT", "falls back to the most recent base-locale pack")
		assertNoErrors(t, world)
	end)

	t.test("3.7 translations shown in RichText labels are escaped", function()
		local context = Boot.new()
		local world = context.world
		local Library = context.Library
		local window = newWindow(context)
		window:AddTab({ Title = "Main" })
		window:AddTab({ Title = "<b>Bold</b>" })
		Library.RemoteAssets:ImportLanguage('{"meta":{"locale":"th","id":"th"},"translations":{"Main":"A < B & C","<b>Bold</b>":"<b>หนา</b>"}}')
		Library.I18n:SetLanguage("th")
		local texts = {}
		for _, label in Library.GUI:GetDescendants() do
			if label.Name == "TabLabel" then
				table.insert(texts, label.Text)
			end
		end
		table.sort(texts)
		t.equal(table.concat(texts, " | "), "<b>หนา</b> | A &lt; B &amp; C")
		assertNoErrors(t, world)
	end)

	t.test("3.8 remote URLs that point inside the network are refused", function()
		local context = Boot.new({ request = translatingServer() })
		local world = context.world
		local assets = context.Library.RemoteAssets
		local refused = {
			"https://user@example.com/pack.json",
			"https://example.com@10.0.0.1/pack.json",
			"https://[::1]/pack.json",
			"https://0.0.0.0/pack.json",
			"https://169.254.169.254/latest",
			"https://2130706433/pack.json",
			"https://0x7f000001/pack.json",
			"https://localhost./pack.json",
			"https://printer.local/pack.json",
			"https://LOCALHOST:8080/pack.json",
		}
		for _, url in refused do
			local body, err = assets:Fetch(url)
			t.equal(body, nil, url)
			t.truthy(type(err) == "string", "error message for " .. url)
		end
		t.equal(#world.requests, 0, "no request was made")
		local body = assets:Fetch("https://raw.githubusercontent.com/org/repo/main/th.json")
		t.truthy(body ~= nil, "a public HTTPS URL is fetched")
		assertNoErrors(t, world)
	end)

	t.test("3.3 saved auto mode migrates to community once, machine is kept", function()
		local function loadWith(scopedSettings)
			local context = Boot.new()
			local world = context.world
			local InterfaceManager = context.loadInterfaceManager()
			InterfaceManager:SetLibrary(context.Library)
			InterfaceManager:SetFolder("FluentSettings")
			InterfaceManager:Configure({ ScriptId = "migrate.test" })
			InterfaceManager:BuildFolderTree()
			world.files["FluentSettings/i18n/migrate.test/interface.json"] = scopedSettings
			InterfaceManager:LoadSettings()
			return InterfaceManager, world
		end

		local manager, world = loadWith('{"TranslationMode":"auto","Language":"th"}')
		t.equal(manager.Settings.TranslationMode, "community", "auto becomes community")
		local saved = world.files["FluentSettings/i18n/migrate.test/interface.json"]
		t.truthy(saved:find('"SettingsVersion":2', 1, true), "migration is saved: " .. saved)
		t.truthy(saved:find('"TranslationMode":"community"', 1, true), "saved mode: " .. saved)

		manager = loadWith('{"TranslationMode":"machine"}')
		t.equal(manager.Settings.TranslationMode, "machine", "an explicit machine choice is kept")
		t.equal(manager.Settings.MachineTranslationConsent, true, "and counts as consent")

		manager = loadWith('{"TranslationMode":"auto","SettingsVersion":2,"MachineTranslationConsent":true}')
		t.equal(manager.Settings.TranslationMode, "auto", "a choice made after the migration is kept")
	end)

	t.test("3.2 choosing machine translation asks for consent first", function()
		local context = Boot.new({ request = translatingServer() })
		local world = context.world
		local Library = context.Library
		local InterfaceManager = context.loadInterfaceManager()
		InterfaceManager:SetLibrary(Library)
		InterfaceManager:SetFolder("FluentSettings")
		local window = newWindow(context)
		local settingsTab = window:AddTab({ Title = "Settings" })
		InterfaceManager:BuildInterfaceSection(settingsTab, { ScriptId = "consent.test" })
		task.wait(0.3)
		local mode = Library.Options.InterfaceTranslationMode
		t.equal(mode.Value, "JSON pack", "default choice")

		mode:SetValue("Machine")
		task.wait(0.1)
		t.equal(Library.I18n.Mode, "community", "nothing changes before the answer")
		local cancel = KitchenSink.findTextButton(world, window.Root, "Cancel")
		t.truthy(cancel, "consent dialog shown")
		world:click(cancel)
		task.wait(0.3)
		t.equal(mode.Value, "JSON pack", "cancel restores the previous choice")
		t.equal(Library.I18n.Mode, "community")
		t.equal(InterfaceManager.Settings.MachineTranslationConsent, false)

		mode:SetValue("Machine")
		task.wait(0.1)
		local allow = KitchenSink.findTextButton(world, window.Root, "Allow")
		t.truthy(allow, "consent dialog shown again")
		world:click(allow)
		task.wait(0.3)
		t.equal(Library.I18n.Mode, "machine", "machine mode after consent")
		t.equal(InterfaceManager.Settings.MachineTranslationConsent, true)
		local saved = world.files["FluentSettings/i18n/consent.test/interface.json"]
		t.truthy(saved and saved:find('"MachineTranslationConsent":true', 1, true), "consent saved")

		mode:SetValue("JSON pack")
		mode:SetValue("Auto")
		task.wait(0.1)
		t.equal(Library.I18n.Mode, "auto", "no second question once consent is given")
		assertNoErrors(t, world)
	end)
end
