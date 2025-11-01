repeat
    task.wait()
until game:IsLoaded()
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- default config
local DefaultConfig = {
    ForceShowButton = true,
    Position = {Horizontal = "left", Vertical = "top", OffsetX = 140, OffsetY = 140},
    ButtonSize = {Min = 40, Max = 46},
    ImageId = "rbxassetid://114090251469395",
    Stroke = {
        BaseThickness = 1,
        PulseThickness = 1.5,
        PulseSpeed = 1.0,
        HueSpeed = 0.09,
        Saturation = 0.95,
        Value = 1.0,
        BaseTransparency = 0.05,
        PulseTransparency = 0.12
    },
    Keybind = {Key = Enum.KeyCode.M, Modifier = Enum.KeyCode.LeftControl}
}

-- deep merge helper
local function deepMerge(base, override)
    local result = {}
    for k, v in pairs(base) do
        if type(v) == "table" and type(override[k]) == "table" then
            result[k] = deepMerge(v, override[k])
        else
            if override[k] ~= nil then
                result[k] = override[k]
            else
                result[k] = v
            end
        end
    end
    -- include any extra keys in override not present in base
    for k, v in pairs(override) do
        if result[k] == nil then
            result[k] = v
        end
    end
    return result
end

-- load config from getgenv if provided (existing behavior preserved)
local Config = DefaultConfig
if getgenv and getgenv().ATGButtonUI then
    Config = deepMerge(DefaultConfig, getgenv().ATGButtonUI)
end

-- input capability
local function detectInput()
    local keyboard = UserInputService.KeyboardEnabled
    local touch = UserInputService.TouchEnabled
    local gamepad = UserInputService.GamepadEnabled
    return {
        keyboard = keyboard,
        touch = touch,
        gamepad = gamepad,
        shouldShowButton = Config.ForceShowButton or not keyboard or (touch and not keyboard) or (gamepad and not keyboard)
    }
end

-- size depending on touch/keyboard
local function getButtonSize()
    local touch = UserInputService.TouchEnabled
    local v = touch and Config.ButtonSize.Min or Config.ButtonSize.Max
    return UDim2.fromOffset(v, v)
end

-- compute position & anchor
local function getPositionAndAnchor()
    local xOff = Config.Position.OffsetX
    local yOff = Config.Position.OffsetY
    local hx, anchorX, anchorIndexX
    if Config.Position.Horizontal == "left" then
        hx = 0
        anchorX = xOff
        anchorIndexX = 0
    elseif Config.Position.Horizontal == "right" then
        hx = 1
        anchorX = -xOff
        anchorIndexX = 1
    else
        hx = 0.5
        anchorX = 0
        anchorIndexX = 0.5
    end
    local hy, anchorY, anchorIndexY
    if Config.Position.Vertical == "top" then
        hy = 0
        anchorY = yOff
        anchorIndexY = 0
    elseif Config.Position.Vertical == "bottom" then
        hy = 1
        anchorY = -yOff
        anchorIndexY = 1
    else
        hy = 0.5
        anchorY = 0
        anchorIndexY = 0.5
    end
    return UDim2.new(hx, anchorX, hy, anchorY), Vector2.new(anchorIndexX, anchorIndexY)
end

-- create button (returns button, stroke)
local FluentButton, FluentStroke, strokeConn -- store for runtime updates
local function createButton(parent)
    local btn = Instance.new("ImageButton")
    btn.Name = "FluentToggleButton"
    btn.Size = getButtonSize()
    local pos, ap = getPositionAndAnchor()
    btn.Position = pos
    btn.AnchorPoint = ap
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 0
    btn.Image = Config.ImageId
    btn.Active = true
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke", btn)
    stroke.Name = "FluentStroke"
    stroke.Thickness = Config.Stroke.BaseThickness
    stroke.Transparency = Config.Stroke.BaseTransparency
    stroke.LineJoinMode = Enum.LineJoinMode.Round

    return btn, stroke
end

-- stroke animation
local function startStrokeAnimation(stroke)
    if strokeConn then
        pcall(function() strokeConn:Disconnect() end)
        strokeConn = nil
    end
    if not stroke or not stroke.Parent then
        return
    end
    local startTick = tick()
    strokeConn =
        RunService.RenderStepped:Connect(function()
            if not stroke or not stroke.Parent then
                if strokeConn then
                    strokeConn:Disconnect()
                    strokeConn = nil
                end
                return
            end
            local elapsed = tick() - startTick
            local hue = (elapsed * Config.Stroke.HueSpeed) % 1
            local pulse = (math.sin(elapsed * Config.Stroke.PulseSpeed * math.pi * 2) + 1) / 2
            stroke.Color = Color3.fromHSV(hue, Config.Stroke.Saturation, Config.Stroke.Value)
            stroke.Thickness = Config.Stroke.BaseThickness + pulse * Config.Stroke.PulseThickness
            stroke.Transparency = Config.Stroke.BaseTransparency + pulse * Config.Stroke.PulseTransparency
        end)
    return strokeConn
end

-- keep onscreen (snap back) after drag or viewport change
local function keepOnScreen(guiObj)
    local view = Camera.ViewportSize
    local pos = guiObj.AbsolutePosition
    local size = guiObj.AbsoluteSize
    local left = pos.X
    local right = pos.X + size.X
    local top = pos.Y
    local bottom = pos.Y + size.Y
    local changed = false
    local newX, newY = pos.X, pos.Y
    if left < 0 then newX = 0 changed = true
    elseif right > view.X then newX = view.X - size.X changed = true end
    if top < 0 then newY = 0 changed = true
    elseif bottom > view.Y then newY = view.Y - size.Y changed = true end
    if changed then
        guiObj.Position = UDim2.fromOffset(newX, newY)
    end
end

-- draggable behavior
local function makeDraggable(H)
    local dragging = false
    local dragInput, dragStart, startPos

    H.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            dragStart = input.Position
            startPos = H.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    keepOnScreen(H)
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            H.Position = newPos
            keepOnScreen(H)
        end
    end)

    Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        task.wait(0.1)
        H.Size = getButtonSize()
        if not dragging then
            local pos, anchor = getPositionAndAnchor()
            H.Position = pos
            H.AnchorPoint = anchor
        else
            keepOnScreen(H)
        end
        task.wait(0.05)
        keepOnScreen(H)
    end)

    task.wait(0.2)
    keepOnScreen(H)
end

-- find fluent-like GUIs in PlayerGui/CoreGui (existing logic preserved)
local function findFluentGuis()
    local found = {}
    local seen = {}
    local function addIfUnique(gui)
        if seen[gui] then return end
        seen[gui] = true
        table.insert(found, gui)
    end
    local keywords = {"TabDisplay", "ContainerCanvas", "AcrylicPaint", "TitleBar", "TabHolder", "Fluent"}
    local function scan(root)
        if root:IsA("ScreenGui") and root.Name:lower():find("fluent") then
            addIfUnique(root)
        end
        for _, child in ipairs(root:GetDescendants()) do
            if child:IsA("GuiObject") then
                local nameLower = child.Name:lower()
                for _, kw in ipairs(keywords) do
                    if nameLower:find(kw:lower()) then
                        local anc = child:FindFirstAncestorOfClass("ScreenGui")
                        if anc then addIfUnique(anc) end
                        break
                    end
                end
                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                    local txt = (child.Text or ""):lower()
                    if txt:find("fluent") or txt:find("interface") or txt:find("by dawid") then
                        local anc = child:FindFirstAncestorOfClass("ScreenGui")
                        if anc then addIfUnique(anc) end
                    end
                end
            end
        end
    end
    for _, gui in ipairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then scan(gui) end
    end
    pcall(function()
        for _, gui in ipairs(CoreGui:GetChildren()) do
            if gui:IsA("ScreenGui") then scan(gui) end
        end
    end)
    if #found == 0 then
        for _, gui in ipairs(PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then addIfUnique(gui) end
        end
    end
    return found
end

-- protective check for exempt GUI
local exemptRoot = nil
local function isExempt(inst)
    if not inst then return true end
    if exemptRoot and (inst == exemptRoot or inst:IsDescendantOf(exemptRoot)) then return true end
    return false
end

-- Toggle (minimize/switch visibility) function (originally ap)
local toggling = false
local function ToggleAll()
    if toggling then return end
    toggling = true
    task.delay(0.18, function() toggling = false end)

    local attempted = pcall(function()
        if typeof(Window) == "table" and type(Window.Minimize) == "function" then
            Window:Minimize()
            return true
        end
    end)
    if attempted then return end

    local guis = findFluentGuis()
    if #guis == 0 then
        for _, gui in ipairs(PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and not isExempt(gui) then
                pcall(function() gui.Enabled = not gui.Enabled end)
            end
        end
        return
    end

    for _, gui in ipairs(guis) do
        if not isExempt(gui) then
            pcall(function()
                if gui:IsA("ScreenGui") then
                    gui.Enabled = not gui.Enabled
                elseif gui:IsA("GuiObject") then
                    gui.Visible = not gui.Visible
                end
            end)
        end
    end
end

-- create/attach UI (originally ar)
local function CreateButton()
    local capabilities = detectInput()
    if not capabilities.shouldShowButton then return end

    if exemptRoot and exemptRoot.Parent and exemptRoot.Parent:IsA("ScreenGui") then
        -- keep existing exempt root as-is
    end

    exemptRoot = Instance.new("ScreenGui")
    exemptRoot.Name = "FluentToggleGui"
    exemptRoot.ResetOnSpawn = false
    exemptRoot.DisplayOrder = 9999
    exemptRoot.IgnoreGuiInset = true
    local ok = pcall(function() exemptRoot.Parent = CoreGui end)
    if not ok then exemptRoot.Parent = PlayerGui end

    FluentButton, FluentStroke = createButton(exemptRoot)
    startStrokeAnimation(FluentStroke)
    makeDraggable(FluentButton)
    FluentButton.Activated:Connect(function() pcall(ToggleAll) end)

    if detectInput().keyboard then
        UserInputService.InputBegan:Connect(function(inp, gpe)
            if gpe then return end
            if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Config.Keybind.Key and UserInputService:IsKeyDown(Config.Keybind.Modifier) then
                pcall(ToggleAll)
            end
        end)
    end
    return FluentButton, FluentStroke
end

-- helper to update config at runtime and apply changes
local function SetConfig(newCfg)
    if type(newCfg) ~= "table" then return false, "newCfg must be table" end
    Config = deepMerge(Config, newCfg)
    -- also update getgenv().ATGButtonUI for persistence if desired
    if getgenv then
        pcall(function() getgenv().ATGButtonUI = Config end)
    end
    -- apply changes to existing UI if present
    if FluentButton then
        -- size & position
        FluentButton.Size = getButtonSize()
        local pos, ap = getPositionAndAnchor()
        FluentButton.Position = pos
        FluentButton.AnchorPoint = ap
        FluentButton.Image = Config.ImageId
    end
    if FluentStroke then
        FluentStroke.Thickness = Config.Stroke.BaseThickness
        FluentStroke.Transparency = Config.Stroke.BaseTransparency
        -- restart animation with new stroke settings
        startStrokeAnimation(FluentStroke)
    end
    return true
end

-- minimize helper (exposes Window.Minimize behavior)
local function MinimizeWindow()
    pcall(function()
        if typeof(Window) == "table" and type(Window.Minimize) == "function" then
            Window:Minimize()
        end
    end)
end

-- EXPORT functions via getgenv
local exported = {
    ToggleAll = ToggleAll,
    CreateButton = CreateButton,
    MinimizeWindow = MinimizeWindow,
    SetConfig = SetConfig,
    Config = function() return Config end
}

-- create a convenience function getnv in getgenv if not present
if getgenv then
    pcall(function()
        if not getgenv().ATGButtonUIFunctions then
            getgenv().ATGButtonUIFunctions = exported
        else
            -- merge/overwrite exposed functions
            for k,v in pairs(exported) do getgenv().ATGButtonUIFunctions[k] = v end
        end

        if not getgenv().getnv then
            getgenv().getnv = function(name, ...)
                if type(name) ~= "string" then
                    error("getnv expects function name (string) as first argument")
                end
                local fn = getgenv().ATGButtonUIFunctions[name] or getgenv().ATGButtonUIFunctions[name:sub(1,1):upper()..name:sub(2)]
                if type(fn) == "function" then
                    return fn(...)
                else
                    error("getnv: function '" .. tostring(name) .. "' not found")
                end
            end
        else
            -- If there already is a getnv, just ensure ATGButtonUIFunctions exists
            if not getgenv().ATGButtonUIFunctions then
                getgenv().ATGButtonUIFunctions = exported
            end
        end
    end)
end

-- auto-create button on load (preserve previous behaviour)
CreateButton()
