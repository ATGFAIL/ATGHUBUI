--[[
	ATG Hub UI - playground for the manual checklist (run in your executor).

	Opens a window with every element, long lists, notification buttons, a
	theme picker and the InterfaceManager settings, so each item of the smoke
	test's manual checklist can be tried by hand. Run it once with the build
	you are checking.

	Settings: edit CONFIG, or before running set, for example,
	  getgenv().ATGTest = { Url = "https://.../main/MainUI.lua", Label = "baseline" }
	To check the splash screen, also set getgenv().ATGSplash = true first.
]]

local CONFIG = {
	-- Raw URL of the MainUI.lua to test. Ignored when LocalFile is set.
	Url = "https://raw.githubusercontent.com/ATGFAIL/ATGHUBUI/claude/visible-files-wq5mqr/MainUI.lua",
	-- InterfaceManager from the same place as MainUI when left empty.
	InterfaceManagerUrl = nil,
	-- Paths inside the executor workspace folder, used instead of the URLs.
	LocalFile = nil,
	InterfaceManagerFile = nil,
	Label = "playground",
}

do
	local ok, overrides = pcall(function()
		return getgenv().ATGTest
	end)
	if ok and type(overrides) == "table" then
		for key, value in pairs(overrides) do
			CONFIG[key] = value
		end
	end
end

local function fetch(url, file)
	if file then
		return readfile(file)
	end
	return game:HttpGet(url)
end

local Library = assert(loadstring(fetch(CONFIG.Url, CONFIG.LocalFile), "=MainUI"))()

local window = Library:CreateWindow({
	Title = "ATG Playground",
	SubTitle = tostring(CONFIG.Label),
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	Acrylic = false,
	Theme = "Dark",
	MinimizeKey = Enum.KeyCode.LeftControl,
	-- Opt-in extras of the new build; older builds ignore them.
	Search = true,
	SmartConfirm = true,
})

local tabs = {
	Elements = window:AddTab({ Title = "Elements", Icon = "sliders" }),
	Lists = window:AddTab({ Title = "Lists", Icon = "list" }),
	Notify = window:AddTab({ Title = "Notifications", Icon = "bell" }),
	Themes = window:AddTab({ Title = "Themes", Icon = "palette" }),
	Settings = window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local function say(text)
	Library:Notify({ Title = "Playground", Content = tostring(text), Duration = 2 })
end

-- Elements ---------------------------------------------------------------

tabs.Elements:AddParagraph({
	Title = "Keys to try",
	Content = "Tap Ctrl: hide/show. Ctrl+K: search. Ctrl+M: toggle once. Hold Ctrl while walking: nothing.",
})
tabs.Elements:AddToggle("PlayToggle", {
	Title = "Toggle",
	Default = false,
	Callback = function(value)
		print("[playground] toggle", value)
	end,
})
tabs.Elements:AddSlider("PlaySlider", {
	Title = "Slider (tap the bar, not only the dot)",
	Default = 50,
	Min = 0,
	Max = 100,
	Rounding = 0,
	Callback = function(value)
		print("[playground] slider", typeof(value), value)
	end,
})
tabs.Elements:AddInput("PlayInput", { Title = "Input", Default = "", Placeholder = "Type here" })
tabs.Elements:AddKeybind("PlayKeybind", { Title = "Keybind (tap it on a phone: should cancel)", Default = "Q" })
tabs.Elements:AddColorpicker("PlayColor", { Title = "Colorpicker", Default = Color3.fromRGB(96, 205, 255) })
tabs.Elements:AddDropdown("PlaySingle", { Title = "Single (no clear button)", Values = { "Alpha", "Beta", "Gamma" }, Default = 1 })
tabs.Elements:AddDropdown("PlayNullable", {
	Title = "Single with AllowNull (clear button)",
	Values = { "Alpha", "Beta", "Gamma" },
	Default = 1,
	AllowNull = true,
})
tabs.Elements:AddButton({
	Title = "Reset stats",
	Description = "Should ask first (SmartConfirm)",
	Callback = function()
		say("Reset stats ran")
	end,
})
tabs.Elements:AddButton({
	Title = "Clearance sale",
	Description = "Should run without asking",
	Callback = function()
		say("Clearance sale ran")
	end,
})
tabs.Elements:AddButton({
	Title = "Unload playground",
	Callback = function()
		Library:Destroy()
	end,
})

-- Lists ------------------------------------------------------------------

local long = {}
for index = 1, 60 do
	long[index] = "Item " .. index
end
tabs.Lists:AddParagraph({
	Title = "On a phone",
	Content = "Scroll these lists with your finger: nothing should get selected until you lift a still finger.",
})
tabs.Lists:AddDropdown("PlayLong", { Title = "60 items", Values = long, Default = 1 })
tabs.Lists:AddDropdown("PlayLongMulti", {
	Title = "60 items, multi",
	Values = long,
	Multi = true,
	Default = { "Item 2", "Item 5" },
})
tabs.Lists:AddDropdown("PlayColored", {
	Title = "Colored values (search 'red', then Select All)",
	Values = { "[COLOR:255,80,80]Red", "[COLOR:80,160,255]Blue", "[COLOR:80,220,120]Green" },
	Multi = true,
	-- Builds before 2.0.0 fail on a multi dropdown without Default.
	Default = {},
})

-- Notifications -------------------------------------------------------------

tabs.Notify:AddParagraph({
	Title = "Watch closely",
	Content = "Does a white box flash behind a notification while it slides in or out?",
})
for _, title in ipairs({ "Info", "Success", "Error", "Warning" }) do
	tabs.Notify:AddButton({
		Title = title .. " notification",
		Callback = function()
			Library:Notify({ Title = title, Content = "Sample " .. title:lower() .. " message", SubContent = "sub content", Duration = 4 })
		end,
	})
end

-- Themes -----------------------------------------------------------------

tabs.Themes:AddParagraph({
	Title = "Check",
	Content = "RGB: borders cycle through colours. Light: search box, input underline and Select All follow the theme.",
})
tabs.Themes:AddDropdown("PlayTheme", {
	Title = "Theme",
	Values = Library.Themes,
	Default = "Dark",
	Callback = function(value)
		Library:SetTheme(value)
	end,
})

-- Settings (InterfaceManager) --------------------------------------------

tabs.Settings:AddParagraph({
	Title = "Consent dialog",
	Content = "Turn on Advanced tools, then Language tools > Translate by > Machine: a dialog should ask first.",
})
local interfaceManagerUrl = CONFIG.InterfaceManagerUrl or tostring(CONFIG.Url):gsub("MainUI%.lua$", "InterfaceManager.lua")
local loadedManager, InterfaceManager = pcall(function()
	return assert(loadstring(fetch(interfaceManagerUrl, CONFIG.InterfaceManagerFile), "=InterfaceManager"))()
end)
if loadedManager and type(InterfaceManager) == "table" then
	InterfaceManager:SetLibrary(Library)
	InterfaceManager:SetFolder("ATGPlayground")
	InterfaceManager:BuildInterfaceSection(tabs.Settings, { ScriptId = "atg.playground" })
else
	warn("[playground] InterfaceManager did not load: " .. tostring(InterfaceManager))
end

window:SelectTab(1)
print(string.format("[playground] ready: %s (ATGVersion %s)", tostring(CONFIG.Label), tostring(Library.ATGVersion)))
return Library
