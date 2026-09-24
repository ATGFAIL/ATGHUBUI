--[[
	ATG Hub UI - in-game benchmark (run in your executor, e.g. Potassium).

	Measures, for the MainUI.lua given in CONFIG:
	  * time to build a standard UI (tabs x elements + large dropdowns)
	  * Luau heap (collectgarbage "count") before/after build and after Destroy
	  * time for Toggle:SetValue x N and Notify x N
	  * frame time (average and p95 of Heartbeat dt) in several scenarios

	Run it several times on the ORIGINAL MainUI (baseline) and on the new
	build, on PC and on a phone, and paste the outputs back. The report is
	also copied to the clipboard when the executor supports it.
]]

local CONFIG = {
	Url = "https://raw.githubusercontent.com/ATGFAIL/ATGHUBUI/claude/visible-files-wq5mqr/MainUI.lua",
	LocalFile = nil,
	Label = "run",
	Rounds = 3,
	Tabs = 8,
	ElementsPerTab = 30,
	BigDropdowns = 2,
	BigDropdownSize = 300,
	ToggleSetValues = 200,
	Notifies = 20,
	FrameSampleSeconds = 4,
	-- Passed to CreateWindow; nil keeps each build's default. Set to true or
	-- false to compare the tab fade (CanvasGroup) on/off in the new build.
	TabFade = nil,
}

local RunService = game:GetService("RunService")

local function loadSource()
	if CONFIG.LocalFile then
		return readfile(CONFIG.LocalFile)
	end
	return game:HttpGet(CONFIG.Url)
end
local source = loadSource()

local function heapKB()
	return collectgarbage("count")
end

local function sampleFrames(seconds, onFrame)
	local samples = {}
	local connection
	connection = RunService.Heartbeat:Connect(function(dt)
		table.insert(samples, dt)
		if onFrame then
			onFrame(#samples)
		end
	end)
	task.wait(seconds)
	connection:Disconnect()
	table.sort(samples)
	local total = 0
	for _, dt in ipairs(samples) do
		total = total + dt
	end
	local count = #samples
	if count == 0 then
		return { avg = 0, p95 = 0, frames = 0 }
	end
	return {
		avg = total / count * 1000,
		p95 = samples[math.max(1, math.floor(count * 0.95))] * 1000,
		frames = count,
	}
end

local function buildUI(Library)
	local config = {
		Title = "ATG Bench",
		SubTitle = CONFIG.Label,
		TabWidth = 160,
		Size = UDim2.fromOffset(580, 460),
		Acrylic = false,
		Theme = "Dark",
		MinimizeKey = Enum.KeyCode.LeftControl,
	}
	if CONFIG.TabFade ~= nil then
		config.TabFade = CONFIG.TabFade
	end
	local window = Library:CreateWindow(config)
	local toggles, paragraphs, dropdowns = {}, {}, {}
	for tabIndex = 1, CONFIG.Tabs do
		local tab = window:AddTab({ Title = "Tab " .. tabIndex, Icon = "home" })
		for index = 1, CONFIG.ElementsPerTab do
			local id = "B" .. tabIndex .. "_" .. index
			local kind = index % 8
			if kind == 0 then
				table.insert(toggles, tab:AddToggle(id, { Title = "Toggle " .. id, Default = false }))
			elseif kind == 1 then
				tab:AddSlider(id, { Title = "Slider " .. id, Default = 5, Min = 0, Max = 10, Rounding = 1 })
			elseif kind == 2 then
				tab:AddDropdown(id, { Title = "Dropdown " .. id, Values = { "A", "B", "C", "D", "E" }, Default = 1 })
			elseif kind == 3 then
				tab:AddInput(id, { Title = "Input " .. id, Default = "", Finished = true })
			elseif kind == 4 then
				tab:AddButton({ Title = "Button " .. id, Callback = function() end })
			elseif kind == 5 then
				table.insert(paragraphs, tab:AddParagraph({ Title = "Paragraph " .. id, Content = "status" }))
			elseif kind == 6 then
				tab:AddKeybind(id, { Title = "Keybind " .. id, Default = "Q" })
			else
				tab:AddColorpicker(id, { Title = "Color " .. id, Default = Color3.fromRGB(96, 205, 255) })
			end
		end
	end
	local bigTab = window:AddTab({ Title = "Big lists", Icon = "list" })
	for index = 1, CONFIG.BigDropdowns do
		local values = {}
		for item = 1, CONFIG.BigDropdownSize do
			values[item] = "Item " .. item
		end
		table.insert(dropdowns, bigTab:AddDropdown("Big" .. index, { Title = "Big " .. index, Values = values, Default = 1 }))
	end
	window:SelectTab(1)
	return window, toggles, paragraphs, dropdowns
end

local rounds = {}
for round = 1, CONFIG.Rounds do
	local result = {}
	collectgarbage("count")
	local heapBefore = heapKB()
	local Library = assert(loadstring(source, "=MainUI"))()
	task.wait(2) -- let the splash (if any) finish

	local started = os.clock()
	local window, toggles, paragraphs, dropdowns = buildUI(Library)
	result.buildMs = (os.clock() - started) * 1000
	task.wait(1)
	result.heapBuiltKB = heapKB() - heapBefore

	started = os.clock()
	for index = 1, CONFIG.ToggleSetValues do
		local toggle = toggles[(index % #toggles) + 1]
		toggle:SetValue(index % 2 == 0)
	end
	result.toggleSetValueMs = (os.clock() - started) * 1000 / CONFIG.ToggleSetValues

	started = os.clock()
	for index = 1, CONFIG.Notifies do
		Library:Notify({ Title = "Bench " .. index, Content = "x", Duration = 0.5 })
	end
	result.notifyMs = (os.clock() - started) * 1000 / CONFIG.Notifies
	task.wait(2)

	result.idle = sampleFrames(CONFIG.FrameSampleSeconds)

	-- a paragraph updated every frame (status text) inside the tab content
	local paragraph = paragraphs[1]
	result.paragraphUpdates = sampleFrames(CONFIG.FrameSampleSeconds, function(frame)
		paragraph:SetDesc("status " .. frame)
	end)

	-- a big dropdown opened while its search box receives text every frame
	window:SelectTab(CONFIG.Tabs + 1)
	task.wait(0.5)
	local dropdown = dropdowns[1]
	dropdown:Open()
	task.wait(0.5)
	local searchBox
	for _, descendant in ipairs(Library.GUI:GetDescendants()) do
		if descendant:IsA("TextBox") and descendant.PlaceholderText:find("Search", 1, true) and descendant.Visible then
			local parentFrame = descendant.Parent and descendant.Parent.Parent
			if parentFrame and parentFrame.Visible then
				searchBox = descendant
			end
		end
	end
	result.dropdownSearch = sampleFrames(CONFIG.FrameSampleSeconds, function(frame)
		if searchBox then
			searchBox.Text = "Item " .. (frame % 30)
		end
	end)
	dropdown:Close()

	started = os.clock()
	Library:Destroy()
	result.destroyMs = (os.clock() - started) * 1000
	task.wait(2)
	result.heapAfterDestroyKB = heapKB() - heapBefore
	table.insert(rounds, result)
	task.wait(1)
end

local function median(values)
	table.sort(values)
	return values[math.floor((#values + 1) / 2)]
end

local function metric(getter)
	local values = {}
	for _, result in ipairs(rounds) do
		table.insert(values, getter(result))
	end
	return median(values)
end

local lines = {
	string.format(
		"ATG bench [%s] rounds=%d tabs=%d elements/tab=%d big dropdowns=%dx%d touch=%s",
		CONFIG.Label,
		CONFIG.Rounds,
		CONFIG.Tabs,
		CONFIG.ElementsPerTab,
		CONFIG.BigDropdowns,
		CONFIG.BigDropdownSize,
		tostring(game:GetService("UserInputService").TouchEnabled)
	),
	string.format("build ms (median)            %.1f", metric(function(r) return r.buildMs end)),
	string.format("heap after build KB          %.0f", metric(function(r) return r.heapBuiltKB end)),
	string.format("heap after destroy KB        %.0f", metric(function(r) return r.heapAfterDestroyKB end)),
	string.format("Toggle:SetValue ms/call      %.3f", metric(function(r) return r.toggleSetValueMs end)),
	string.format("Notify ms/call               %.2f", metric(function(r) return r.notifyMs end)),
	string.format("Destroy ms                   %.1f", metric(function(r) return r.destroyMs end)),
	string.format("frame idle avg/p95 ms        %.2f / %.2f", metric(function(r) return r.idle.avg end), metric(function(r) return r.idle.p95 end)),
	string.format("frame paragraph avg/p95 ms   %.2f / %.2f", metric(function(r) return r.paragraphUpdates.avg end), metric(function(r) return r.paragraphUpdates.p95 end)),
	string.format("frame dd search avg/p95 ms   %.2f / %.2f", metric(function(r) return r.dropdownSearch.avg end), metric(function(r) return r.dropdownSearch.p95 end)),
}
local report = table.concat(lines, "\n")
print(report)
if type(setclipboard) == "function" then
	pcall(setclipboard, report)
	print("(report copied to clipboard)")
end
return rounds
