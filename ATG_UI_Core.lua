-- ATG_UI_Core.lua - UI Core หลัก (แก้ที่เดียว ใช้ได้ทุกเกม)
-- URL: https://raw.githubusercontent.com/YOUR_REPO/ATG_UI_Core.lua

repeat task.wait() until game:IsLoaded()

-- ========== โหลด Libraries ==========
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/atghub-sys/ATGUi/main/UiMain"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/ATGFAIL/ATGHub/Addons/autosave.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- ========== Services ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local camera = workspace.CurrentCamera

-- ========== Window Configuration ==========
local defaultConfig = {
    mode = "scale",
    widthScale = 0.6,
    heightScale = 0.6,
    widthPixels = 520,
    heightPixels = 420,
    minWidth = 400,
    maxWidth = 580,
    minHeight = 340,
    maxHeight = 460,
    Title = "ATG Hub",
    SubTitle = "by ATGFAIL",
    TabWidth = 140,
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl,
    autoResize = true,
}

local function getConfig()
    local cfg = {}
    for k,v in pairs(defaultConfig) do cfg[k] = v end
    if type(getgenv) == "function" and type(getgenv().ATG_UI) == "table" then
        for k,v in pairs(getgenv().ATG_UI) do cfg[k] = v end
    end
    return cfg
end

local function getWindowSize()
    local cfg = getConfig()
    local screen = camera and camera.ViewportSize or Vector2.new(1366,768)
    local width, height
    if cfg.mode == "pixels" then
        width = tonumber(cfg.widthPixels) or defaultConfig.widthPixels
        height = tonumber(cfg.heightPixels) or defaultConfig.heightPixels
    else
        local wScale = tonumber(cfg.widthScale) or defaultConfig.widthScale
        local hScale = tonumber(cfg.heightScale) or defaultConfig.heightScale
        width = screen.X * wScale
        height = screen.Y * hScale
    end
    width = math.clamp(width, cfg.minWidth or defaultConfig.minWidth, cfg.maxWidth or defaultConfig.maxWidth)
    height = math.clamp(height, cfg.minHeight or defaultConfig.minHeight, cfg.maxHeight or defaultConfig.maxHeight)
    return UDim2.fromOffset(math.floor(width), math.floor(height))
end

-- ========== Create Window ==========
local cfg = getConfig()
local Window = Fluent:CreateWindow({
    Title = cfg.Title or defaultConfig.Title,
    SubTitle = cfg.SubTitle or defaultConfig.SubTitle,
    TabWidth = cfg.TabWidth or defaultConfig.TabWidth,
    Size = getWindowSize(),
    Acrylic = cfg.Acrylic,
    Theme = cfg.Theme or defaultConfig.Theme,
    MinimizeKey = cfg.MinimizeKey or defaultConfig.MinimizeKey,
})

-- Auto-resize
if cfg.autoResize then
    camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        task.wait(0.08)
        if Window and Window.SetSize then Window:SetSize(getWindowSize()) end
    end)
end

-- ========== สร้าง Tabs พื้นฐาน ==========
local function createBasicTabs()
    return {
        Main = Window:AddTab({Title = "Main", Icon = "home"}),
        Humanoid = Window:AddTab({Title = "Humanoid", Icon = "user"}),
        Players = Window:AddTab({Title = "Players", Icon = "users"}),
        Teleport = Window:AddTab({Title = "Teleport", Icon = "plane"}),
        Server = Window:AddTab({Title = "Server", Icon = "server"}),
        Settings = Window:AddTab({Title = "Settings", Icon = "settings"})
    }
end

-- ========== Module: Player Info Panel ==========
local function setupPlayerInfo(Tabs)
    local startTime = tick()
    local infoParagraph = Tabs.Main:AddParagraph({
        Title = "Player Info",
        Content = "Loading..."
    })
    
    local function pad2(n)
        return string.format("%02d", tonumber(n) or 0)
    end
    
    local function updateInfo()
        local playedSeconds = math.floor(tick() - startTime)
        local hours = math.floor(playedSeconds / 3600)
        local minutes = math.floor((playedSeconds % 3600) / 60)
        local seconds = playedSeconds % 60
        local dateStr = os.date("%d/%m/%Y")
        
        local content = string.format([[
Name: %s (@%s)
Date: %s
Played Time: %s:%s:%s
]],
            LocalPlayer.DisplayName or LocalPlayer.Name,
            LocalPlayer.Name or "Unknown",
            dateStr,
            pad2(hours),
            pad2(minutes),
            pad2(seconds)
        )
        
        pcall(function() infoParagraph:SetDesc(content) end)
    end
    
    task.spawn(function()
        while true do
            if Fluent.Unloaded then break end
            pcall(updateInfo)
            task.wait(1)
        end
    end)
end

-- ========== Module: Speed & Jump ==========
local function setupSpeedJump(Tabs)
    local Section = Tabs.Humanoid:AddSection("Speed & Jump")
    
    local WalkMin, WalkMax = 8, 200
    local JumpMin, JumpMax = 10, 300
    local DesiredWalkSpeed = 16
    local DesiredJumpPower = 50
    local WalkEnabled = false
    local JumpEnabled = false
    local originalValues = setmetatable({}, {__mode = "k"})
    local currentHumanoid = nil
    local heartbeatConn = nil
    
    local function clamp(v, a, b)
        return math.clamp(v, a, b)
    end
    
    local function findHumanoid()
        if not Players.LocalPlayer then return nil end
        local char = Players.LocalPlayer.Character
        if not char then return nil end
        return char:FindFirstChildWhichIsA("Humanoid")
    end
    
    local function saveOriginal(hum)
        if not hum or originalValues[hum] then return end
        local ok, ws, jp, usejp = pcall(function()
            return hum.WalkSpeed, hum.JumpPower, hum.UseJumpPower
        end)
        if ok then
            originalValues[hum] = {WalkSpeed = ws or 16, JumpPower = jp or 50, UseJumpPower = usejp}
        else
            originalValues[hum] = {WalkSpeed = 16, JumpPower = 50, UseJumpPower = true}
        end
    end
    
    local function applyToHumanoid(hum)
        if not hum then return end
        saveOriginal(hum)
        
        if WalkEnabled then
            local desired = clamp(math.floor(DesiredWalkSpeed + 0.5), WalkMin, WalkMax)
            if hum.WalkSpeed ~= desired then
                pcall(function() hum.WalkSpeed = desired end)
            end
        end
        
        if JumpEnabled then
            pcall(function()
                if hum.UseJumpPower ~= true then
                    hum.UseJumpPower = true
                end
            end)
            local desiredJ = clamp(math.floor(DesiredJumpPower + 0.5), JumpMin, JumpMax)
            if hum.JumpPower ~= desiredJ then
                pcall(function() hum.JumpPower = desiredJ end)
            end
        end
    end
    
    local function startEnforcement()
        if heartbeatConn then return end
        local acc = 0
        heartbeatConn = RunService.Heartbeat:Connect(function(dt)
            acc = acc + dt
            if acc < 0.1 then return end
            acc = 0
            local hum = findHumanoid()
            if hum then
                currentHumanoid = hum
                if WalkEnabled or JumpEnabled then
                    applyToHumanoid(hum)
                end
            else
                currentHumanoid = nil
            end
        end)
    end
    
    local function setWalkEnabled(v)
        WalkEnabled = not not v
        if WalkEnabled then
            local hum = findHumanoid()
            if hum then applyToHumanoid(hum) end
            startEnforcement()
        end
    end
    
    local function setJumpEnabled(v)
        JumpEnabled = not not v
        if JumpEnabled then
            local hum = findHumanoid()
            if hum then applyToHumanoid(hum) end
            startEnforcement()
        end
    end
    
    -- UI
    local speedSlider = Section:AddSlider("WalkSpeedSlider", {
        Title = "Walk Speed",
        Default = DesiredWalkSpeed,
        Min = WalkMin,
        Max = WalkMax,
        Rounding = 0,
        Callback = function(v)
            DesiredWalkSpeed = clamp(v, WalkMin, WalkMax)
            if WalkEnabled then
                local hum = findHumanoid()
                if hum then applyToHumanoid(hum) end
            end
        end
    })
    
    local jumpSlider = Section:AddSlider("JumpPowerSlider", {
        Title = "Jump Power",
        Default = DesiredJumpPower,
        Min = JumpMin,
        Max = JumpMax,
        Rounding = 0,
        Callback = function(v)
            DesiredJumpPower = clamp(v, JumpMin, JumpMax)
            if JumpEnabled then
                local hum = findHumanoid()
                if hum then applyToHumanoid(hum) end
            end
        end
    })
    
    Section:AddToggle("EnableWalkToggle", {
        Title = "Enable Walk",
        Default = false,
        Callback = setWalkEnabled
    })
    
    Section:AddToggle("EnableJumpToggle", {
        Title = "Enable Jump",
        Default = false,
        Callback = setJumpEnabled
    })
end

-- ========== Module: Fly & Noclip ==========
local function setupFlyNoclip(Tabs)
    local Section = Tabs.Humanoid:AddSection("Fly & Noclip")
    local state = {flyEnabled = false, noclipEnabled = false}
    local fly = {bv = nil, bg = nil, speed = 60, smoothing = 0.35, bound = false, conn = nil}
    local savedCanCollide = {}
    
    local function getHRP()
        local char = LocalPlayer.Character
        if not char then char = LocalPlayer.CharacterAdded:Wait() end
        return char and char:FindFirstChild("HumanoidRootPart")
    end
    
    local function createForces(hrp)
        if not hrp then return end
        if not fly.bv then
            fly.bv = Instance.new("BodyVelocity")
            fly.bv.Name = "ATG_Fly_BV"
            fly.bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            fly.bv.P = 1250
        end
        if not fly.bg then
            fly.bg = Instance.new("BodyGyro")
            fly.bg.Name = "ATG_Fly_BG"
            fly.bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            fly.bg.D = 1000
        end
        fly.bv.Parent = hrp
        fly.bg.Parent = hrp
    end
    
    local function destroyForces()
        if fly.bv then pcall(function() fly.bv:Destroy() end) fly.bv = nil end
        if fly.bg then pcall(function() fly.bg:Destroy() end) fly.bg = nil end
    end
    
    local function bindFlyStep()
        if fly.bound then return end
        fly.bound = true
        
        fly.conn = RunService.Heartbeat:Connect(function(delta)
            if not state.flyEnabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp or not fly.bv or not fly.bg then return end
            local cam = workspace.CurrentCamera
            if not cam then return end
            
            local moveDir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            
            local targetVel = Vector3.new()
            if moveDir.Magnitude > 0 then targetVel = moveDir.Unit * fly.speed end
            fly.bv.Velocity = fly.bv.Velocity:Lerp(targetVel, math.clamp(fly.smoothing, 0, 1))
            fly.bg.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
        end)
    end
    
    local function enableFly(enable)
        state.flyEnabled = enable
        if enable then
            local hrp = getHRP()
            if not hrp then return end
            createForces(hrp)
            bindFlyStep()
        else
            destroyForces()
            if fly.conn then fly.conn:Disconnect() fly.conn = nil end
            fly.bound = false
        end
    end
    
    local function setNoclip(enable)
        if enable == state.noclipEnabled then return end
        state.noclipEnabled = enable
        
        local char = LocalPlayer.Character
        if not char then return end
        
        if enable then
            savedCanCollide = {}
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    savedCanCollide[part] = part.CanCollide
                    part.CanCollide = false
                end
            end
            
            local noclipConn
            noclipConn = RunService.Stepped:Connect(function()
                if not state.noclipEnabled then
                    if noclipConn then noclipConn:Disconnect() end
                    return
                end
                local c = LocalPlayer.Character
                if c then
                    for _, part in ipairs(c:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            for part, val in pairs(savedCanCollide) do
                if part and part.Parent then part.CanCollide = val end
            end
            savedCanCollide = {}
        end
    end
    
    -- UI
    Tabs.Humanoid:AddSlider("FlySpeedSlider", {
        Title = "Fly Speed",
        Default = fly.speed,
        Min = 10,
        Max = 350,
        Rounding = 0,
        Callback = function(v) fly.speed = v end
    })
    
    Tabs.Humanoid:AddToggle("FlyToggle", {
        Title = "Fly",
        Default = false,
        Callback = enableFly
    })
    
    Tabs.Humanoid:AddToggle("NoclipToggle", {
        Title = "Noclip",
        Default = false,
        Callback = setNoclip
    })
end

-- ========== Module: Teleport to Player ==========
local function setupTeleportToPlayer(Tabs, Window)
    local PlayerSection = Tabs.Players:AddSection("Player")
    local TeleportSection = Tabs.Players:AddSection("Teleport")
    
    local playerListDropdown = PlayerSection:AddDropdown("TeleportToPlayerDropdown", {
        Title = "Player",
        Values = {},
        Multi = false,
        Default = 1
    })
    
    PlayerSection:AddButton({
        Title = "Refresh list",
        Callback = function()
            local vals = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then table.insert(vals, p.Name) end
            end
            if #vals == 0 then vals = {"No players"} end
            playerListDropdown:SetValues(vals)
            playerListDropdown:SetValue(vals[1])
        end
    })
    
    TeleportSection:AddButton({
        Title = "Teleport Now",
        Callback = function()
            local sel = playerListDropdown.Value
            if not sel or sel == "No players" then return end
            local target = Players:FindFirstChild(sel)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                    end)
                end
            end
        end
    })
end

-- ========== Module: Server Hop ==========
local function setupServerHop(Tabs, Window)
    local function safeGetJson(url)
        local ok, res = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        return ok and res or nil
    end
    
    local function collectAllServers()
        local servers = {}
        local cursor = ""
        local placeId = game.PlaceId
        repeat
            local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
            local page = safeGetJson(url)
            if not page or not page.data then break end
            for _, server in ipairs(page.data) do
                table.insert(servers, {
                    id = server.id,
                    playing = server.playing,
                    maxPlayers = server.maxPlayers
                })
            end
            cursor = page.nextPageCursor or ""
        until cursor == ""
        return servers
    end
    
    local function findBestServer()
        local servers = collectAllServers()
        if #servers == 0 then return nil end
        
        local candidates = {}
        for _, s in ipairs(servers) do
            if s.id ~= game.JobId and s.playing > 0 and s.playing < s.maxPlayers then
                table.insert(candidates, s)
            end
        end
        
        if #candidates > 0 then
            table.sort(candidates, function(a,b) return a.playing > b.playing end)
            return candidates[math.random(1, math.min(4, #candidates))].id
        end
        
        return nil
    end
    
    Tabs.Server:AddButton({
        Title = "Server Hop",
        Callback = function()
            Window:Dialog({
                Title = "Server Hop?",
                Content = "Do you want to hop?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            local serverId = findBestServer()
                            if serverId then
                                TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, LocalPlayer)
                            end
                        end
                    },
                    {Title = "Cancel"}
                }
            })
        end
    })
    
    Tabs.Server:AddButton({
        Title = "Rejoin",
        Callback = function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    })
end

-- ========== Module: Anti-AFK ==========
local function setupAntiAFK(Tabs)
    local vu = nil
    local idledConn = nil
    
    local function enableAntiAFK(enable)
        if enable then
            pcall(function() vu = game:GetService("VirtualUser") end)
            if vu and not idledConn then
                idledConn = LocalPlayer.Idled:Connect(function()
                    pcall(function()
                        vu:Button2Down(Vector2.new(0,0))
                        task.wait(1)
                        vu:Button2Up(Vector2.new(0,0))
                    end)
                end)
            end
        else
            if idledConn then
                idledConn:Disconnect()
                idledConn = nil
            end
        end
    end
    
    local toggle = Tabs.Settings:AddToggle("AntiAFKToggle", {
        Title = "Anti-AFK",
        Default = true,
        Callback = enableAntiAFK
    })
end

-- ========== Module: Toggle Button UI ==========
local function setupToggleButton(Window)
    repeat task.wait() until game:IsLoaded()
    
    local CoreGui = game:GetService("CoreGui")
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    local CONFIG = {
        Position = {Horizontal = "left", Vertical = "top", OffsetX = 140, OffsetY = 140},
        ButtonSize = {Min = 40, Max = 46},
        ImageId = "rbxassetid://114090251469395"
    }
    
    local function calculateButtonSize()
        local hasTouch = UserInputService.TouchEnabled
        local size = hasTouch and CONFIG.ButtonSize.Min or CONFIG.ButtonSize.Max
        return UDim2.fromOffset(size, size)
    end
    
    local function calculateButtonPosition()
        local offsetX = CONFIG.Position.OffsetX
        local offsetY = CONFIG.Position.OffsetY
        local xScale, xOffset, anchorX = 0, offsetX, 0
        local yScale, yOffset, anchorY = 0, offsetY, 0
        return UDim2.new(xScale, xOffset, yScale, yOffset), Vector2.new(anchorX, anchorY)
    end
    
    local toggleGui = Instance.new("ScreenGui")
    toggleGui.Name = "FluentToggleGui"
    toggleGui.ResetOnSpawn = false
    toggleGui.DisplayOrder = 9999
    toggleGui.IgnoreGuiInset = true
    
    pcall(function() toggleGui.Parent = CoreGui end)
    if not toggleGui.Parent then toggleGui.Parent = playerGui end
    
    local button = Instance.new("ImageButton")
    button.Name = "FluentToggleButton"
    button.Size = calculateButtonSize()
    local position, anchor = calculateButtonPosition()
    button.Position = position
    button.AnchorPoint = anchor
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.BackgroundTransparency = 0
    button.BorderSizePixel = 0
    button.Image = CONFIG.ImageId
    button.Active = true
    button.Parent = toggleGui
    
    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", button)
    stroke.Thickness = 1
    stroke.Transparency = 0.05
    
    -- RGB Animation
    local startTime = tick()
    RunService.RenderStepped:Connect(function()
        if not stroke or not stroke.Parent then return end
        local elapsed = tick() - startTime
        local hue = (elapsed * 0.09) % 1
        local pulse = (math.sin(elapsed * 1.0 * math.pi * 2) + 1) / 2
        stroke.Color = Color3.fromHSV(hue, 0.95, 1.0)
        stroke.Thickness = 1 + (pulse * 1.5)
        stroke.Transparency = 0.05 + (pulse * 0.12)
    end)
    
    button.Activated:Connect(function()
        pcall(function()
            if Window and Window.Minimize then
                Window:Minimize()
            end
        end)
    end)
end

-- ========== สร้างและ Return API ==========
local Tabs = createBasicTabs()
local Options = Fluent.Options

-- Setup ทุก Modules
setupPlayerInfo(Tabs)
setupSpeedJump(Tabs)
setupFlyNoclip(Tabs)
setupTeleportToPlayer(Tabs, Window)
setupServerHop(Tabs, Window)
setupAntiAFK(Tabs)
setupToggleButton(Window)

-- Finalize
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- ========== Return API สำหรับเกมเฉพาะ ==========
return {
    -- Core Components
    Window = Window,
    Tabs = Tabs,
    Options = Options,
    Fluent = Fluent,
    SaveManager = SaveManager,
    InterfaceManager = InterfaceManager,
    
    -- Services
    Players = Players,
    LocalPlayer = LocalPlayer,
    RunService = RunService,
    UserInputService = UserInputService,
    HttpService = HttpService,
    TeleportService = TeleportService,
    TweenService = TweenService,
    
    -- Helper Functions
    getConfig = getConfig,
    
    -- Finalize Function
    Finalize = function(customTitle)
        if customTitle then
            pcall(function()
                Window.Title = customTitle
            end)
        end
        
        Window:SelectTab(1)
        Fluent:Notify({
            Title = "ATG Hub",
            Content = "Loaded Successfully!",
            Duration = 3
        })
        
        SaveManager:LoadAutoloadConfig()
    end
}
