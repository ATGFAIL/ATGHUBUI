--[[
	ATG Hub UI - in-game smoke test (run in your executor, e.g. Potassium).

	What it does
	  1. Loads MainUI.lua (from CONFIG.Url or a local file).
	  2. Runs automatic checks and prints PASS / FAIL / SKIP for each.
	  3. Prints a manual checklist for things only a person can judge.
	  4. Destroys everything it created.

	Run it on the ORIGINAL MainUI first (baseline), then on the new build, and
	paste both outputs back. Many checks are expected to FAIL on the original:
	they describe bugs the new build fixes.
]]

local CONFIG = {
	-- Raw URL of the MainUI.lua to test. Ignored when LocalFile is set.
	Url = "https://raw.githubusercontent.com/ATGFAIL/ATGHUBUI/claude/visible-files-wq5mqr/MainUI.lua",
	-- Path inside the executor workspace folder, e.g. "MainUI.lua".
	LocalFile = nil,
	-- Label printed with the results ("baseline" or "new").
	Label = "run",
}

local results = {}
local function record(status, name, detail)
	table.insert(results, { status = status, name = name, detail = detail })
end

local function check(name, fn)
	local ok, passed, detail = pcall(fn)
	if not ok then
		record("FAIL", name, "error: " .. tostring(passed))
	elseif passed == nil then
		record("SKIP", name, detail)
	else
		record(passed and "PASS" or "FAIL", name, detail)
	end
end

local function loadSource()
	if CONFIG.LocalFile then
		return readfile(CONFIG.LocalFile)
	end
	return game:HttpGet(CONFIG.Url)
end

local source = loadSource()
local function loadLibrary()
	local chunk = assert(loadstring(source, "=MainUI"))
	return chunk()
end

local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local function countDepthOfField()
	local count = 0
	for _, child in ipairs(Lighting:GetChildren()) do
		if child:IsA("DepthOfFieldEffect") then
			count = count + 1
		end
	end
	return count
end

local function newWindow(Library, extra)
	local config = {
		Title = "ATG Smoke",
		SubTitle = CONFIG.Label,
		TabWidth = 160,
		Size = UDim2.fromOffset(580, 460),
		Acrylic = false,
		Theme = "Dark",
		MinimizeKey = Enum.KeyCode.LeftControl,
	}
	for key, value in pairs(extra or {}) do
		config[key] = value
	end
	return Library:CreateWindow(config)
end

------------------------------------------------------------------------------
-- Checks that share one library instance
------------------------------------------------------------------------------

local dofBefore = countDepthOfField()
local Library = loadLibrary()
local window = newWindow(Library, { Acrylic = true })
local tab = window:AddTab({ Title = "Smoke", Icon = "home" })

check("Slider callback value is a number for whole numbers", function()
	local seen
	local slider = tab:AddSlider("SmokeSlider", {
		Title = "Slider",
		Default = 5,
		Min = 0,
		Max = 10,
		Rounding = 1,
		Callback = function(value)
			seen = value
		end,
	})
	slider:SetValue(7)
	return type(seen) == "number", "got " .. type(seen) .. " " .. tostring(seen)
end)

check("Multi dropdown without Default can be created", function()
	local ok, err = pcall(function()
		tab:AddDropdown("SmokeMultiNoDefault", { Title = "Multi", Values = { "A", "B" }, Multi = true })
	end)
	return ok, ok and "" or tostring(err)
end)

check("Multi dropdown Default list gives only value keys", function()
	local defaults = { "B" }
	local dropdown = tab:AddDropdown("SmokeMulti", {
		Title = "Multi",
		Values = { "A", "B", "C" },
		Multi = true,
		Default = defaults,
	})
	local keys = {}
	for key in pairs(dropdown.Value) do
		table.insert(keys, tostring(key))
	end
	table.sort(keys)
	return table.concat(keys, ",") == "B" and defaults.B == nil, "keys: " .. table.concat(keys, ",")
end)

check("Multi dropdown SetValue accepts a list", function()
	local dropdown = tab:AddDropdown("SmokeMultiList", {
		Title = "Multi",
		Values = { "A", "B", "C" },
		Multi = true,
		Default = {},
	})
	dropdown:SetValue({ "A", "C" })
	return dropdown.Value.A == true and dropdown.Value.C == true, "A=" .. tostring(dropdown.Value.A) .. " C=" .. tostring(dropdown.Value.C)
end)

check("Notify does not yield", function()
	local started = os.clock()
	Library:Notify({ Title = "Smoke", Content = "notify timing", Duration = 1 })
	local elapsed = os.clock() - started
	return elapsed < 0.05, string.format("took %.3fs", elapsed)
end)

check("Keybind SetValue(nil) keeps the current key", function()
	local keybind = tab:AddKeybind("SmokeKeybind", { Title = "Key", Default = "Q" })
	local ok, err = pcall(function()
		keybind:SetValue(nil)
	end)
	return ok and keybind.Value == "Q", ok and ("value " .. tostring(keybind.Value)) or tostring(err)
end)

check("SafeCallback survives a non-string error", function()
	local ok, err = pcall(function()
		Library:SafeCallback(function()
			error({ code = 1 })
		end)
	end)
	return ok, ok and "" or tostring(err)
end)

check("A corrupt workspace profile does not break ApplyProfile", function()
	if not Library.Workspace then
		return nil, "no Workspace"
	end
	Library.Workspace.State.Profiles.Corrupt = {
		SmokeKeybind = { Type = "Keybind", Value = { __atg = "Enum", Type = "NotAnEnum", Name = "Nope" } },
	}
	local ok, err = pcall(function()
		Library.Workspace:ApplyProfile("Corrupt")
	end)
	Library.Workspace.State.Profiles.Corrupt = nil
	return ok, ok and "" or tostring(err)
end)

check("Library exposes OnUnload", function()
	return type(Library.OnUnload) == "table" and type(Library.OnUnload.Connect) == "function", type(Library.OnUnload)
end)

check("Dropdown closes when the window is minimized", function()
	local dropdown = tab:AddDropdown("SmokeOpen", { Title = "Open me", Values = { "A", "B" }, Default = 1 })
	dropdown:Open()
	task.wait(0.3)
	window:Minimize()
	task.wait(0.4)
	local stillOpen = dropdown.Opened
	window:Minimize()
	task.wait(0.1)
	if dropdown.Opened then
		dropdown:Close()
	end
	return stillOpen == false, "Opened after minimize = " .. tostring(stillOpen)
end)

local unloadFired = false
if type(Library.OnUnload) == "table" and type(Library.OnUnload.Connect) == "function" then
	Library.OnUnload:Connect(function()
		unloadFired = true
	end)
end
task.wait(0.5)
Library:Destroy()
task.wait(0.5)

check("OnUnload fired on Destroy", function()
	if type(Library.OnUnload) ~= "table" then
		return nil, "OnUnload not available"
	end
	return unloadFired, ""
end)

check("Destroy with Acrylic leaves no extra DepthOfFieldEffect", function()
	local after = countDepthOfField()
	return after <= dofBefore, string.format("before=%d after=%d", dofBefore, after)
end)

------------------------------------------------------------------------------
-- Checks that need their own library instance
------------------------------------------------------------------------------

check("CreateWindow without MinimizeKey: Minimize() does not error", function()
	local lib = loadLibrary()
	local win = lib:CreateWindow({ Title = "NoKey", SubTitle = "", TabWidth = 160, Size = UDim2.fromOffset(580, 460), Acrylic = false })
	win:AddTab({ Title = "A" })
	local ok, err = pcall(function()
		win:Minimize()
		win:Minimize()
	end)
	lib:Destroy()
	return ok, ok and "" or tostring(err)
end)

check("Close button keeps other ScreenGuis (e.g. StatGui)", function()
	if type(firesignal) ~= "function" then
		return nil, "executor has no firesignal"
	end
	local foreign = Instance.new("ScreenGui")
	foreign.Name = "StatGui_SmokeTest"
	foreign.Parent = CoreGui
	local lib = loadLibrary()
	local win = newWindow(lib)
	win:AddTab({ Title = "A" })
	firesignal(win.TitleBar.CloseButton.Frame.MouseButton1Click)
	task.wait(0.3)
	local yes
	for _, descendant in ipairs(win.Root:GetDescendants()) do
		if descendant:IsA("TextLabel") and descendant.Text == "Yes" and descendant.Parent:IsA("TextButton") then
			yes = descendant.Parent
		end
	end
	if not yes then
		foreign:Destroy()
		pcall(function()
			lib:Destroy()
		end)
		return nil, "could not find the Yes button"
	end
	firesignal(yes.MouseButton1Click)
	task.wait(0.5)
	local survived = foreign.Parent == CoreGui
	pcall(function()
		foreign:Destroy()
	end)
	pcall(function()
		lib:Destroy()
	end)
	return survived, survived and "" or "StatGui_SmokeTest was destroyed"
end)

check("Building a UI in Thai sends no translation requests by default", function()
	local env = getgenv()
	local original = env.request
	if type(original) ~= "function" then
		return nil, "executor has no request"
	end
	local calls = 0
	env.request = function(options)
		if type(options) == "table" and tostring(options.Url):find("/translate", 1, true) then
			calls = calls + 1
			return { Success = false, StatusCode = 503, Body = "" }
		end
		return original(options)
	end
	local ok, err = pcall(function()
		local lib = loadLibrary()
		lib.I18n:SetLanguage("th")
		local win = newWindow(lib)
		local t = win:AddTab({ Title = "A" })
		for index = 1, 5 do
			t:AddToggle("SmokeReq" .. index, { Title = "Feature " .. index })
		end
		task.wait(1)
		lib:Destroy()
	end)
	env.request = original
	if not ok then
		return false, tostring(err)
	end
	return calls == 0, "translation requests: " .. calls
end)

check("Invalid key name in ATGButtonUI config still creates the floating button", function()
	local env = getgenv()
	local previous = env.ATGButtonUI
	env.ATGButtonUI = { Keybind = { Key = "NotAKey" } }
	local lib = loadLibrary()
	local win = newWindow(lib)
	win:AddTab({ Title = "A" })
	task.wait(0.6)
	local created = lib.FloatingToggle ~= nil
	lib:Destroy()
	env.ATGButtonUI = previous
	return created, created and "" or "floating button missing"
end)

------------------------------------------------------------------------------
-- Report
------------------------------------------------------------------------------

local counts = { PASS = 0, FAIL = 0, SKIP = 0 }
local lines = { "ATG smoke [" .. CONFIG.Label .. "]" }
for _, result in ipairs(results) do
	counts[result.status] = counts[result.status] + 1
	table.insert(lines, string.format("%-4s %s %s", result.status, result.name, result.detail and ("(" .. result.detail .. ")") or ""))
end
table.insert(lines, string.format("PASS %d  FAIL %d  SKIP %d", counts.PASS, counts.FAIL, counts.SKIP))
table.insert(lines, "")
table.insert(lines, "Manual checklist (answer yes/no):")
for _, item in ipairs({
	"Tap Ctrl quickly: does the UI hide/show?",
	"Hold Ctrl and press K: does the search open WITHOUT hiding the UI? (new build with Search=true)",
	"Hold Ctrl and press M: does the UI toggle exactly once?",
	"Hold Ctrl while walking (WASD), release: UI should NOT toggle (new build)",
	"Mobile: scroll a long dropdown list with your finger: does it select items by accident?",
	"Open/close a notification: do you see a white flash behind it?",
	"Theme RGB: do borders cycle through colours? (new build)",
	"Theme Light: do the search box, panel and input underline follow the theme? (new build)",
	"Phone in landscape: does the whole window fit on screen?",
}) do
	table.insert(lines, "  [ ] " .. item)
end
local report = table.concat(lines, "\n")
print(report)
if type(setclipboard) == "function" then
	pcall(setclipboard, report)
	print("(report copied to clipboard)")
end
return results
