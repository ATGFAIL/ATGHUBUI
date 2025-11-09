repeat task.wait() until game:IsLoaded()

local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/atghub-sys/ATGUi/main/UiMain"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/ATGFAIL/ATGHub/Addons/autosave.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local camera = workspace.CurrentCamera

-- ======= Default config (can be overridden in loader by getgenv().ATG_UI) =======
local defaultConfig = {
    -- mode: "scale" (percent of viewport) or "pixels" (absolute size)
    mode = "scale",

    -- when mode == "scale": use these (0.0 - 1.0)
    widthScale = 0.6,
    heightScale = 0.6,

    -- when mode == "pixels": use these absolute values
    widthPixels = 520,
    heightPixels = 420,

    -- clamps (always applied)
    minWidth = 400,
    maxWidth = 580,
    minHeight = 360,
    maxHeight = 460,

    -- other window props (can be overridden too)
    Title = "ATG Hub Freemium",
    SubTitle = "by ATGFAIL",
    TabWidth = 140,
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl,

    -- auto-resize when viewport changes
    autoResize = true,
}

-- Merge user config (getgenv) with defaults
local function getConfig()
    local cfg = {}
    for k,v in pairs(defaultConfig) do cfg[k] = v end
    if type(getgenv) == "function" and type(getgenv().ATG_UI) == "table" then
        for k,v in pairs(getgenv().ATG_UI) do
            cfg[k] = v
        end
    end
    return cfg
end

-- 🧠 คำนวณขนาด UI ตาม config ปัจจุบัน
local function getWindowSize()
    local cfg = getConfig()
    local screen = camera and camera.ViewportSize or Vector2.new(1366,768)

    local width, height
    if cfg.mode == "pixels" then
        width  = tonumber(cfg.widthPixels)  or defaultConfig.widthPixels
        height = tonumber(cfg.heightPixels) or defaultConfig.heightPixels
    else -- default to "scale"
        local wScale = tonumber(cfg.widthScale)  or defaultConfig.widthScale
        local hScale = tonumber(cfg.heightScale) or defaultConfig.heightScale
        width  = screen.X * wScale
        height = screen.Y * hScale
    end

    -- apply clamps
    width  = math.clamp(width,  cfg.minWidth or defaultConfig.minWidth,  cfg.maxWidth or defaultConfig.maxWidth)
    height = math.clamp(height, cfg.minHeight or defaultConfig.minHeight, cfg.maxHeight or defaultConfig.maxHeight)

    return UDim2.fromOffset(math.floor(width), math.floor(height))
end

-- ===== Create window (uses Fluent from your environment) =====
if not Fluent then
    warn("[ATG UI] Fluent library not found. Window creation skipped.")
    return
end

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

-- Expose apply function so loader/user can call to re-apply config live
getgenv().ATG_ApplyUI = function()
    if Window and Window.SetSize then
        Window:SetSize(getWindowSize())
    end
end

-- Optional: expose a helper to update config programmatically
getgenv().ATG_UpdateConfig = function(newCfg)
    if type(newCfg) ~= "table" then return end
    getgenv().ATG_UI = getgenv().ATG_UI or {}
    for k,v in pairs(newCfg) do
        getgenv().ATG_UI[k] = v
    end
    -- immediately apply
    if getgenv().ATG_ApplyUI then getgenv().ATG_ApplyUI() end
end

-- ⚡ auto resize on viewport change (if enabled in config)
if cfg.autoResize then
    camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        task.wait(0.08) -- debounce tiny delay for fast resizes
        -- re-check config each resize so runtime changes take effect
        if getgenv().ATG_ApplyUI then getgenv().ATG_ApplyUI() end
    end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local cfg2 = getConfig()
    if input.KeyCode == (cfg2.MinimizeKey or Enum.KeyCode.LeftControl) then
    end
end)

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Humanoid = Window:AddTab({ Title = "Humanoid", Icon = "user" }),
    Players = Window:AddTab({ Title = "Players", Icon = "users" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "plane" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "locate"}),
    Server = Window:AddTab({ Title = "Server", Icon = "server"}),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- -----------------------
-- Player Info Paragraph (Status Panel)
-- -----------------------

-- ประกาศตัวแปรที่ใช้
local startTime = tick() -- เวลาเริ่มสคริปต์
local infoParagraph = nil
local char = nil
local hum = nil
local content = ""

-- สร้าง Paragraph
infoParagraph = Tabs.Main:AddParagraph({
    Title = "Player Info",
    Content = "Loading player info..."
})

-- ฟังก์ชันช่วยเติมเลขให้เป็น 2 หลัก (เช่น 4 -> "04")
local function pad2(n)
    return string.format("%02d", tonumber(n) or 0)
end

-- ฟังก์ชันอัพเดทข้อมูล
local function updateInfo()
    -- รับตัวละคร / humanoid (ถ้ามี)
    char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    hum = char and char:FindFirstChildWhichIsA("Humanoid")

    -- เวลาที่เล่น (วินาที, ปัดลง)
    local playedSeconds = math.floor(tick() - startTime)

    -- แยกชั่วโมง นาที วินาที
    local hours = math.floor(playedSeconds / 3600)
    local minutes = math.floor((playedSeconds % 3600) / 60)
    local seconds = playedSeconds % 60

    -- วันที่ปัจจุบัน รูปแบบ DD/MM/YYYY
    local dateStr = os.date("%d/%m/%Y")

    -- สร้างข้อความที่จะโชว์ (เอา Health/WalkSpeed/JumpPower ออกแล้ว)
    content = string.format([[
Name: %s (@%s)
Date : %s

Played Time : %s : %s : %s
]],
        LocalPlayer.DisplayName or LocalPlayer.Name,
        LocalPlayer.Name or "Unknown",
        dateStr,
        pad2(hours),
        pad2(minutes),
        pad2(seconds)
    )

    -- อัปเดต Paragraph ใน UI
    pcall(function()
        infoParagraph:SetDesc(content)
    end)
end

-- loop update ทุกๆ 1 วิ
task.spawn(function()
    while true do
        if Fluent.Unloaded then break end
        pcall(updateInfo)
        task.wait(1)
    end
end)

    -- สร้างตัวแปรเก็บค่า Dropdown ปัจจุบัน
local selectedZone = "Zone 1"

-- สร้าง Dropdown
local Dropdown = Tabs.Teleport:AddDropdown("Teleport", {
    Title = "Select to Teleport",
    Values = {"Zone 1", "Zone 2","Zone 3","Zone 4", "Zone 5", "Zone 6", "Zone 7", "Zone 8"},
    Multi = false,
    Default = 1,
})

-- ตั้งค่าเริ่มต้น
Dropdown:SetValue("Zone 1")

-- เมื่อ Dropdown เปลี่ยนค่า
Dropdown:OnChanged(function(Value)
    selectedZone = Value
    print("Dropdown changed:", Value)
end)

-- สร้างปุ่ม Teleport
Tabs.Teleport:AddButton({
    Title = "Teleport",
    Description = "Click To Teleport",
    Callback = function()
        Window:Dialog({
            Title = "Teleport to ...",
            Content = "Are you sure you want to teleport to " .. selectedZone .. "?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        -- วาปตามค่า Dropdown
                        local player = game.Players.LocalPlayer
                        local char = player.Character or player.CharacterAdded:Wait()
                        local hrp = char:WaitForChild("HumanoidRootPart")
                        
                        if selectedZone == "Zone 1" then
                            hrp.CFrame = CFrame.new(17240, 40, 850)
                        elseif selectedZone == "Zone 2" then
                            hrp.CFrame = CFrame.new(17300, 50, -15)
                        elseif selectedZone == "Zone 3" then
                            hrp.CFrame = CFrame.new(-1, 50, -501)
                        elseif selectedZone == "Zone 4" then
                            hrp.CFrame = CFrame.new(200, 30, -300)
                        elseif selectedZone == "Zone 5" then
                            hrp.CFrame = CFrame.new(45, 30, 70)
                        elseif selectedZone == "Zone 6" then
                            hrp.CFrame = CFrame.new(430, 50, 450)
                        elseif selectedZone == "Zone 7" then
                            hrp.CFrame = CFrame.new(430, 50, 707)
                        elseif selectedZone == "Zone 8" then
                            hrp.CFrame = CFrame.new(480, 50, 960)
                        end
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                    end
                }
            }
        })
    end
})

do
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local Workspace = workspace

    -- assume UI libs exist
    if not Tabs.Players then Tabs.Players = Window:AddTab({ Title = "Teleport" }) end
    local PlayerSection = Tabs.Players:AddSection("Player")
    local TeleportSection = Tabs.Players:AddSection("Teleport")

    -- UI
    local playerListDropdown = PlayerSection:AddDropdown("TeleportToPlayerDropdown", {
        Title = "Player", Values = {}, Multi = false, Default = 1
    })
    PlayerSection:AddButton({ Title = "Refresh list", Description = "รีเฟชรายชื่อผู้เล่น", Callback = function()
        local vals = {}
        for _, p in ipairs(Players:GetPlayers()) do if p ~= Players.LocalPlayer then table.insert(vals, p.Name) end end
        if #vals == 0 then vals = {"No players"} end
        playerListDropdown:SetValues(vals)
        playerListDropdown:SetValue(vals[1])
    end})

    local TeleportMethodDropdown = TeleportSection:AddDropdown("TeleportMethod", {
        Title = "Method", Description = "Instant / Tween / MoveTo",
        Values = {"Instant","Tween","MoveTo"}, Multi = false, Default = 1
    })
    TeleportSection:AddButton({ Title = "Teleport Now", Description = "วาปทันทีไปคนที่เลือก", Callback = function()
        local sel = playerListDropdown.Value
        if not sel or sel == "No players" then return end
        local target = Players:FindFirstChild(sel)
        if target then task.spawn(function() _G.TeleportToPlayerModule.TeleportTo(target) end) end
    end})
    local AutoFollowToggle = TeleportSection:AddToggle("TeleportAutoFollowToggle", { Title = "Auto-Follow", Description = "ติดตามผู้เล่น", Default = false })

    -- config (set here, not UI)
    local Y_OFFSET = 0
    local TWEEN_TIME = 0.001
    local COOLDOWN = 0.001
    local SAFE_GROUND_MAX_DIST = 20
    local TWEEN_TIMEOUT = 3
    local MOVETO_TIMEOUT = 4

    local LocalPlayer = Players.LocalPlayer
    local LastTeleport = 0
    local TeleportDebounce = false
    local ActiveTweens = {}
    local AutoFollowConn

    local function getHRP(p)
        if not p or not p.Character then return nil end
        return p.Character:FindFirstChild("HumanoidRootPart") or p.Character.PrimaryPart
    end
    local function getLocalHRP()
        if not LocalPlayer or not LocalPlayer.Character then return nil end
        return LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character.PrimaryPart
    end

    local function raycastDown(fromPos, maxDist)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = { LocalPlayer.Character }
        params.IgnoreWater = true
        return Workspace:Raycast(fromPos, Vector3.new(0, -maxDist, 0), params)
    end
    local function isGroundBelow(pos, maxDist)
        local r = raycastDown(pos, maxDist or SAFE_GROUND_MAX_DIST)
        if r and r.Position then return true, r.Position end
        return false, nil
    end

    local function playTweenNonBlocking(instance, prop, time, cb)
        local info = TweenInfo.new(math.max(0.01, time), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(instance, info, prop)
        ActiveTweens[tween] = true
        local done = false
        local con; con = tween.Completed:Connect(function() done=true; ActiveTweens[tween]=nil; con:Disconnect(); if cb then pcall(cb,true) end end)
        tween:Play()
        task.spawn(function()
            local t0 = tick()
            while not done and tick()-t0 < TWEEN_TIMEOUT do task.wait(0.05) end
            if not done then pcall(function() tween:Cancel() end) ActiveTweens[tween]=nil if con and con.Connected then con:Disconnect() end if cb then pcall(cb,false) end end
        end)
    end

    local function teleportToPlayer(player)
        if TeleportDebounce then return false end
        if not player or not player.Parent then return false end
        if tick() - LastTeleport < COOLDOWN then return false end
        LastTeleport = tick()
        TeleportDebounce = true
        task.delay(0.05, function() TeleportDebounce = false end)

        local targetHRP = getHRP(player)
        local localHRP = getLocalHRP()
        if not localHRP then return false end

        local baseCF = (targetHRP and targetHRP.CFrame) or (player.Character and player.Character:GetModelCFrame())
        if not baseCF then return false end
        local destPos = baseCF.Position + Vector3.new(0, Y_OFFSET, 0)

        local ok, gp = isGroundBelow(destPos, SAFE_GROUND_MAX_DIST)
        if not ok then
            local found = false
            local tryPos = destPos
            for i=1,6 do
                tryPos = tryPos - Vector3.new(0,2,0)
                local ok2, g2 = isGroundBelow(tryPos, 2.5)
                if ok2 then destPos = Vector3.new(destPos.X, g2.Y+1.2, destPos.Z); found = true; break end
            end
            if not found then return false end
        else
            destPos = Vector3.new(destPos.X, gp.Y+1.2, destPos.Z)
        end

        local method = TeleportMethodDropdown and TeleportMethodDropdown.Value or "Instant"
        if method == "Instant" then
            pcall(function() localHRP.CFrame = CFrame.new(destPos) end)
            return true
        elseif method == "Tween" then
            pcall(function() playTweenNonBlocking(localHRP, {CFrame = CFrame.new(destPos)}, TWEEN_TIME) end)
            return true
        elseif method == "MoveTo" then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and typeof(humanoid.MoveTo) == "function" then
                local done=false
                local con = humanoid.MoveToFinished:Connect(function() done=true; if con and con.Connected then con:Disconnect() end end)
                pcall(function() humanoid:MoveTo(destPos) end)
                task.spawn(function()
                    local t0=tick()
                    while not done and tick()-t0 < MOVETO_TIMEOUT do task.wait(0.05) end
                    if not done then pcall(function() localHRP.CFrame = CFrame.new(destPos) end) if con and con.Connected then con:Disconnect() end end
                end)
                return true
            else
                pcall(function() localHRP.CFrame = CFrame.new(destPos) end)
                return true
            end
        else
            pcall(function() localHRP.CFrame = CFrame.new(destPos) end)
            return true
        end
    end

    -- ===== new real-time sticky follow implementation =====
    local function startAutoFollow()
        if AutoFollowConn then return end
        AutoFollowConn = RunService.Heartbeat:Connect(function()
            local sel = playerListDropdown.Value
            if not sel or sel == "No players" then return end

            local target = Players:FindFirstChild(sel)
            if not target or not target.Parent then return end

            local targetHRP = getHRP(target)
            local localHRP = getLocalHRP()
            if not targetHRP or not localHRP then return end

            -- set local HRP CFrame to target HRP CFrame every frame (sticky)
            -- include Y_OFFSET if you want to offset vertically
            local ok, _ = pcall(function()
                localHRP.CFrame = targetHRP.CFrame * CFrame.new(0, Y_OFFSET, 0)
            end)
            -- if pcall fails (e.g., during respawn), just silently continue; next frame will re-check
        end)
    end

    local function stopAutoFollow()
        if AutoFollowConn then
            AutoFollowConn:Disconnect()
            AutoFollowConn = nil
        end
    end

    AutoFollowToggle:OnChanged(function(v) if v then startAutoFollow() else stopAutoFollow() end end)

    local function refreshPlayerDropdown()
        local vals = {}
        for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(vals, p.Name) end end
        if #vals == 0 then vals = {"No players"} end
        playerListDropdown:SetValues(vals)
        playerListDropdown:SetValue(vals[1])
    end

    -- initial fill (no continuous listeners)
    refreshPlayerDropdown()

    local function cleanup()
        stopAutoFollow()
        for t,_ in pairs(ActiveTweens) do pcall(function() t:Cancel() end) ActiveTweens[t]=nil end
    end

    _G.TeleportToPlayerModule = {
        TeleportTo = teleportToPlayer,
        RefreshPlayers = refreshPlayerDropdown,
        Cleanup = cleanup
    }
end

-- -----------------------
-- Setup
-- -----------------------
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- state table
local state = {
    flyEnabled = false,
    noclipEnabled = false,
    espEnabled = false,
    espTable = {}
}

-- ใช้ Fluent:Notify แทน
local function notify(title, content, duration)
    Fluent:Notify({
        Title = title,
        Content = content,
        Duration = duration or 3
    })
end

do
local Section = Tabs.Humanoid:AddSection("Speed & Jump")
-- wait for LocalPlayer if not ready (safe in LocalScript)
if not LocalPlayer or typeof(LocalPlayer) == "Instance" and LocalPlayer.ClassName == "" then
    LocalPlayer = Players.LocalPlayer
end

do
    -- config
    local enforcementRate = 0.1 -- วินาที (0.1 = 10 ครั้ง/วินาที) -> ตอบสนองดีขึ้น แต่ไม่เกินไป
    local WalkMin, WalkMax = 8, 200
    local JumpMin, JumpMax = 10, 300

    local DesiredWalkSpeed = 16
    local DesiredJumpPower = 50

    local WalkEnabled = false
    local JumpEnabled = false

    -- เก็บค่าเดิมของ humanoid (weak table ตาม instance)
    local originalValues = setmetatable({}, {__mode = "k"})

    local currentHumanoid = nil
    local heartbeatConn = nil
    local lastApplyTick = 0

    local function clamp(v, a, b)
        if v < a then
            return a
        end
        if v > b then
            return b
        end
        return v
    end

    local function findHumanoid()
        if not Players.LocalPlayer then
            return nil
        end
        local char = Players.LocalPlayer.Character
        if not char then
            return nil
        end
        return char:FindFirstChildWhichIsA("Humanoid")
    end

    local function saveOriginal(hum)
        if not hum then
            return
        end
        if not originalValues[hum] then
            local ok, ws, jp, usejp =
                pcall(
                function()
                    return hum.WalkSpeed, hum.JumpPower, hum.UseJumpPower
                end
            )
            if ok then
                originalValues[hum] = {WalkSpeed = ws or 16, JumpPower = jp or 50, UseJumpPower = usejp}
            else
                originalValues[hum] = {WalkSpeed = 16, JumpPower = 50, UseJumpPower = true}
            end
        end
    end

    local function restoreOriginal(hum)
        if not hum then
            return
        end
        local orig = originalValues[hum]
        if orig then
            pcall(
                function()
                    if orig.UseJumpPower ~= nil then
                        hum.UseJumpPower = orig.UseJumpPower
                    end
                    hum.WalkSpeed = orig.WalkSpeed or 16
                    hum.JumpPower = orig.JumpPower or 50
                end
            )
            originalValues[hum] = nil
        end
    end

    local function applyToHumanoid(hum)
        if not hum then
            return
        end
        saveOriginal(hum)

        -- Walk
        if WalkEnabled then
            local desired = clamp(math.floor(DesiredWalkSpeed + 0.5), WalkMin, WalkMax)
            if hum.WalkSpeed ~= desired then
                pcall(
                    function()
                        hum.WalkSpeed = desired
                    end
                )
            end
        end

        -- Jump: ensure UseJumpPower true, then set JumpPower
        if JumpEnabled then
            pcall(
                function()
                    -- set UseJumpPower true to ensure JumpPower is respected
                    if hum.UseJumpPower ~= true then
                        hum.UseJumpPower = true
                    end
                end
            )

            local desiredJ = clamp(math.floor(DesiredJumpPower + 0.5), JumpMin, JumpMax)
            if hum.JumpPower ~= desiredJ then
                pcall(
                    function()
                        hum.JumpPower = desiredJ
                    end
                )
            end
        end
    end

    local function startEnforcement()
        if heartbeatConn then
            return
        end
        local acc = 0
        heartbeatConn =
            RunService.Heartbeat:Connect(
            function(dt)
                acc = acc + dt
                if acc < enforcementRate then
                    return
                end
                acc = 0

                local hum = findHumanoid()
                if hum then
                    currentHumanoid = hum
                    -- apply only when enabled; if both disabled, avoid applying
                    if WalkEnabled or JumpEnabled then
                        applyToHumanoid(hum)
                    end
                else
                    -- no humanoid: clear currentHumanoid
                    currentHumanoid = nil
                end
            end
        )
    end

    local function stopEnforcement()
        if heartbeatConn then
            heartbeatConn:Disconnect()
            heartbeatConn = nil
        end
    end

    -- Toggle handlers
    local function setWalkEnabled(v)
        WalkEnabled = not (not v)
        if WalkEnabled then
            -- immediately apply
            local hum = findHumanoid()
            if hum then
                applyToHumanoid(hum)
            end
            startEnforcement()
        else
            -- restore walk value on current humanoid if we recorded it
            if currentHumanoid then
                -- only restore WalkSpeed (not touching Jump here)
                local orig = originalValues[currentHumanoid]
                if orig and orig.WalkSpeed ~= nil then
                    pcall(
                        function()
                            currentHumanoid.WalkSpeed = orig.WalkSpeed
                        end
                    )
                end
            end

            -- if both disabled, we can stop enforcement and restore jump if needed
            if not JumpEnabled then
                if currentHumanoid then
                    restoreOriginal(currentHumanoid)
                end
                stopEnforcement()
            end
        end
    end

    local function setJumpEnabled(v)
        JumpEnabled = not (not v)
        if JumpEnabled then
            local hum = findHumanoid()
            if hum then
                applyToHumanoid(hum)
            end
            startEnforcement()
        else
            if currentHumanoid then
                -- restore JumpPower and UseJumpPower
                local orig = originalValues[currentHumanoid]
                if orig and (orig.JumpPower ~= nil or orig.UseJumpPower ~= nil) then
                    pcall(
                        function()
                            if orig.UseJumpPower ~= nil then
                                currentHumanoid.UseJumpPower = orig.UseJumpPower
                            end
                            if orig.JumpPower ~= nil then
                                currentHumanoid.JumpPower = orig.JumpPower
                            end
                        end
                    )
                end
            end

            if not WalkEnabled then
                if currentHumanoid then
                    restoreOriginal(currentHumanoid)
                end
                stopEnforcement()
            end
        end
    end

    -- sliders callbacks
    local function setWalkSpeed(v)
        DesiredWalkSpeed = clamp(v, WalkMin, WalkMax)
        if WalkEnabled then
            local hum = findHumanoid()
            if hum then
                applyToHumanoid(hum)
            end
            startEnforcement()
        end
    end

    local function setJumpPower(v)
        DesiredJumpPower = clamp(v, JumpMin, JumpMax)
        if JumpEnabled then
            local hum = findHumanoid()
            if hum then
                applyToHumanoid(hum)
            end
            startEnforcement()
        end
    end

    -- CharacterAdded handling to apply as soon as possible
    if Players.LocalPlayer then
        Players.LocalPlayer.CharacterAdded:Connect(
            function(char)
                -- small wait for humanoid to exist
                local hum = nil
                for i = 1, 20 do
                    hum = char:FindFirstChildWhichIsA("Humanoid")
                    if hum then
                        break
                    end
                    task.wait(0.05)
                end
                if hum and (WalkEnabled or JumpEnabled) then
                    applyToHumanoid(hum)
                    startEnforcement()
                end
            end
        )
    end

    -- UI
    local speedSlider =
        Section:AddSlider(
        "WalkSpeedSlider",
        {
            Title = "Walk Speed",
            Description = "ความเร็ววิ่ง",
            Default = DesiredWalkSpeed,
            Min = WalkMin,
            Max = WalkMax,
            Rounding = 0,
            Callback = function(Value)
                setWalkSpeed(Value)
            end
        }
    )
    speedSlider:OnChanged(setWalkSpeed)

    local jumpSlider =
        Section:AddSlider(
        "JumpPowerSlider",
        {
            Title = "Jump Power",
            Description = "ความสูงกระโดด",
            Default = DesiredJumpPower,
            Min = JumpMin,
            Max = JumpMax,
            Rounding = 0,
            Callback = function(Value)
                setJumpPower(Value)
            end
        }
    )
    jumpSlider:OnChanged(setJumpPower)

    local walkToggle =
        Section:AddToggle(
        "EnableWalkToggle",
        {
            Title = "Enable Walk",
            Description = "เปิด/ปิดการบังคับ WalkSpeed",
            Default = WalkEnabled,
            Callback = function(value)
                setWalkEnabled(value)
            end
        }
    )
    walkToggle:OnChanged(setWalkEnabled)

    local jumpToggle =
        Section:AddToggle(
        "EnableJumpToggle",
        {
            Title = "Enable Jump",
            Description = "เปิด/ปิดการบังคับ JumpPower",
            Default = JumpEnabled,
            Callback = function(value)
                setJumpEnabled(value)
            end
        }
    )
    jumpToggle:OnChanged(setJumpEnabled)

    Section:AddButton(
        {
            Title = "Reset to defaults",
            Description = "คืนค่า Walk/Jump ไปค่าเริ่มต้น (16, 50)",
            Callback = function()
                DesiredWalkSpeed = 16
                DesiredJumpPower = 50
                speedSlider:SetValue(DesiredWalkSpeed)
                jumpSlider:SetValue(DesiredJumpPower)
                if WalkEnabled or JumpEnabled then
                    local hum = findHumanoid()
                    if hum then
                        applyToHumanoid(hum)
                    end
                end
            end
        }
    )

    -- start enforcement if either is enabled initially
    if WalkEnabled or JumpEnabled then
        startEnforcement()
    end
end

-- ============================
-- Fly & Noclip (รองรับมือถือ) - เวอร์ชันแก้บั๊ก
-- ============================

local Section = Tabs.Humanoid:AddSection("Fly & Noclip")
do
    local state = {flyEnabled = false, noclipEnabled = false}
    local bindName = "ATG_FlyStep"
    local fly = {bv = nil, bg = nil, speed = 60, smoothing = 0.35, bound = false, conn = nil}
    local savedCanCollide = {}

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local ContextActionService = game:GetService("ContextActionService")

    local function getHRP()
        local char = LocalPlayer.Character
        if not char then
            char = LocalPlayer.CharacterAdded:Wait()
        end
        return char and char:FindFirstChild("HumanoidRootPart")
    end

    local function createForces(hrp)
        if not hrp then
            return
        end
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
        if fly.bv then
            pcall(
                function()
                    fly.bv:Destroy()
                end
            )
            fly.bv = nil
        end
        if fly.bg then
            pcall(
                function()
                    fly.bg:Destroy()
                end
            )
            fly.bg = nil
        end
    end

    -- API สำหรับปุ่มมือถือ (ให้ GUI เรียกใช้)
    local ascendPressed, descendPressed = false, false
    local flyControls = {}
    function flyControls.SetAscend(v)
        ascendPressed = v and true or false
    end
    function flyControls.SetDescend(v)
        descendPressed = v and true or false
    end

    -- Bind keyboard keys via ContextActionService แต่ไม่ "กิน" input ถ้า Fly ปิดอยู่
    ContextActionService:BindAction(
        "ATG_Fly_AscendKey",
        function(name, inputState, inputObj)
            -- ถ้า Fly ปิด ให้คืน pass เพื่อไม่ขัดการกระโดดปกติของเกม
            if not state.flyEnabled then
                return Enum.ContextActionResult.Pass
            end
            ascendPressed = (inputState == Enum.UserInputState.Begin)
            return Enum.ContextActionResult.Sink
        end,
        false,
        Enum.KeyCode.Space
    )

    ContextActionService:BindAction(
        "ATG_Fly_DescendKey",
        function(name, inputState, inputObj)
            if not state.flyEnabled then
                return Enum.ContextActionResult.Pass
            end
            descendPressed = (inputState == Enum.UserInputState.Begin)
            return Enum.ContextActionResult.Sink
        end,
        false,
        Enum.KeyCode.LeftControl
    )

    local function bindFlyStep()
        if fly.bound then
            return
        end
        fly.bound = true

        -- ใช้ Heartbeat สำหรับ physics-consistent updates (ดีกว่า render step บนมือถือ)
        fly.conn =
            RunService.Heartbeat:Connect(
            function(delta)
                if Fluent and Fluent.Unloaded then
                    destroyForces()
                    if fly.conn then
                        fly.conn:Disconnect()
                        fly.conn = nil
                    end
                    fly.bound = false
                    return
                end
                if not state.flyEnabled then
                    return
                end
                local char = LocalPlayer.Character
                if not char then
                    return
                end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp or not fly.bv or not fly.bg then
                    return
                end
                local cam = workspace.CurrentCamera
                if not cam then
                    return
                end

                -- 1) พยายามใช้ Keyboard (ถ้ามี)
                local moveDir = Vector3.new()
                local isKeyboard = UserInputService.KeyboardEnabled

                if isKeyboard then
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDir = moveDir + cam.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDir = moveDir - cam.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDir = moveDir - cam.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDir = moveDir + cam.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) or ascendPressed then
                        moveDir = moveDir + Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or descendPressed then
                        moveDir = moveDir - Vector3.new(0, 1, 0)
                    end
                else
                    -- 2) มือถือ/จอย: ใช้ Humanoid.MoveDirection เป็นหลัก (joystick ของ Roblox จะกรอกค่านี้)
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        local hd = humanoid.MoveDirection -- Vector3 in world space
                        if hd and hd.Magnitude > 0 then
                            -- เก็บเฉพาะแกน XZ เป็นการเคลื่อนที่แนวนอน
                            local horizontal = Vector3.new(hd.X, 0, hd.Z)
                            if horizontal.Magnitude > 0 then
                                -- แก้: Lua ไม่มี += -> ใช้ assignment เต็ม
                                moveDir = moveDir + horizontal.Unit * horizontal.Magnitude
                            end
                        end
                        -- ขึ้น: ใช้ทั้ง Jump และปุ่ม GUI ascend
                        if humanoid.Jump or ascendPressed then
                            moveDir = moveDir + Vector3.new(0, 1, 0)
                        end
                        -- ลง: ถ้ามีปุ่ม descend (GUI) ให้ใช้ก่อน
                        if descendPressed then
                            moveDir = moveDir - Vector3.new(0, 1, 0)
                        else
                            -- ถ้าผู้เล่นผลักจอย "ถอยหลัง" ต่อกล้อง (backwards) ให้ตีความเป็น descend (มือถือจะลงง่ายขึ้น)
                            if humanoid.MoveDirection and humanoid.MoveDirection.Magnitude > 0 then
                                local camForward = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
                                if camForward.Magnitude > 0 then
                                    local forwardDot = humanoid.MoveDirection.Unit:Dot(camForward.Unit)
                                    -- forwardDot < -0.5 => กำลังผลักย้อนกลับ (ถอยหลัง) относительноกล้อง
                                    if forwardDot < -0.5 then
                                        moveDir = moveDir - Vector3.new(0, 1, 0)
                                    end
                                end
                            end
                        end
                    else
                        -- fallback: ถ้ามือถือแต่ไม่มี Humanoid (แปลว่ามีปัญหา) ให้ใช้ ascend/descend ที่ผูกด้วยปุ่ม
                        if ascendPressed then
                            moveDir = moveDir + Vector3.new(0, 1, 0)
                        end
                        if descendPressed then
                            moveDir = moveDir - Vector3.new(0, 1, 0)
                        end
                    end
                end

                -- 3) Normalize และปรับความเร็ว
                local targetVel = Vector3.new()
                if moveDir.Magnitude > 0 then
                    targetVel = moveDir.Unit * fly.speed
                end
                -- Lerp velocity ให้ smooth
                fly.bv.Velocity = fly.bv.Velocity:Lerp(targetVel, math.clamp(fly.smoothing, 0, 1))

                -- จัดทิศทาง BodyGyro ให้หันไปตามกล้อง แต่รักษาจุดอ้างอิงเป็นตำแหน่ง HRP
                -- ป้องกันการเปลี่ยน CFrame แบบกระโดด
                fly.bg.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
            end
        )
    end

    local function unbindFlyStep()
        if fly.conn then
            pcall(
                function()
                    fly.conn:Disconnect()
                end
            )
            fly.conn = nil
        end
        fly.bound = false
    end

    local function enableFly(enable)
        state.flyEnabled = enable and true or false
        if enable then
            local hrp = getHRP()
            if not hrp then
                state.flyEnabled = false
                return
            end
            createForces(hrp)
            bindFlyStep()
        else
            destroyForces()
            unbindFlyStep()
        end
    end

    -- ===========================
    -- Noclip (เดิม) - ทำงานได้บนมือถือ
    -- ===========================
    local noclipConn = nil

    local function setNoclip(enable)
        if enable == state.noclipEnabled then
            return
        end
        state.noclipEnabled = enable

        local char = LocalPlayer.Character
        if not char or not char:FindFirstChildOfClass("Humanoid") then
            return
        end

        if enable then
            savedCanCollide = {}
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    savedCanCollide[part] = part.CanCollide
                    part.CanCollide = false
                end
            end

            noclipConn =
                RunService.Stepped:Connect(
                function()
                    local c = LocalPlayer.Character
                    if c then
                        for _, part in ipairs(c:GetDescendants()) do
                            if part:IsA("BasePart") and part.CanCollide then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            )
        else
            if noclipConn then
                noclipConn:Disconnect()
                noclipConn = nil
            end

            for part, val in pairs(savedCanCollide) do
                if part and part.Parent then
                    part.CanCollide = val
                end
            end
            savedCanCollide = {}
        end
    end

    -- Auto reapply on respawn
    LocalPlayer.CharacterAdded:Connect(
        function(char)
            task.wait(0.2)
            if state.noclipEnabled then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
            -- Reapply fly forces after respawn if needed
            if state.flyEnabled then
                task.wait(0.1)
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    createForces(hrp)
                end
            end
        end
    )
    local flySpeedSlider =
        Tabs.Humanoid:AddSlider(
        "FlySpeedSlider",
        {
            Title = "Fly Speed",
            Description = "ปรับความเร็วการบิน",
            Default = fly.speed,
            Min = 10,
            Max = 350,
            Rounding = 0,
            Callback = function(v)
                fly.speed = v
            end
        }
    )
    flySpeedSlider:SetValue(fly.speed)

    -- UI controls (Tab bindings)
    local flyToggle = Tabs.Humanoid:AddToggle("FlyToggle", {Title = "Fly", Description = "บิน", Default = false})
    flyToggle:OnChanged(
        function(v)
            enableFly(v)
        end
    )

    local noclipToggle = Tabs.Humanoid:AddToggle("NoclipToggle", {Title = "Noclip", Description = "ทะลุ", Default = false})
    noclipToggle:OnChanged(
        function(v)
            setNoclip(v)
        end
    )

    Tabs.Humanoid:AddKeybind(
        "FlyKey",
        {
            Title = "Fly Key",
            Description = "คีย์ลัดบิน",
            Mode = "Toggle",
            Default = "None",
            Callback = function(val)
                enableFly(val)
                pcall(
                    function()
                        flyToggle:SetValue(val)
                    end
                )
            end
        }
    )

    -- expose flyControls so GUI script สามารถใช้ได้ (ตัวอย่าง: สคริปต์ GUI จะเรียก flyControls.SetAscend(true) ตอน touch begin)
    _G.ATG_FlyControls = flyControls

    task.spawn(
        function()
            while true do
                if Fluent and Fluent.Unloaded then
                    enableFly(false)
                    setNoclip(false)
                    break
                end
                task.wait(0.5)
            end
        end
    )
end
end
-- Helper: safe HTTP JSON decode
local function safeGetJson(url)
    local ok, res = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    if ok and res then return res end
    return nil
end

-- Helper: iterate through server pages and collect server entries
local function collectAllServers()
    local servers = {}
    local cursor = ""
    local placeId = game.PlaceId
    repeat
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
        local page = safeGetJson(url)
        if not page or not page.data then
            break
        end
        for _, server in ipairs(page.data) do
            -- store only needed fields to reduce memory
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

-- Find the best server for "Server Hop (many players but not full)"
local function findBestHighPopulationServer()
    local servers = collectAllServers()
    if #servers == 0 then return nil end

    local candidates = {}
    -- primary: servers that have >0 players and are not full and not current job
    for _, s in ipairs(servers) do
        if s.id ~= game.JobId and s.playing > 0 and s.playing < s.maxPlayers then
            table.insert(candidates, s)
        end
    end

    -- if we have candidates, choose the one with the highest player count (closest to full but not full)
    if #candidates > 0 then
        table.sort(candidates, function(a,b) return a.playing > b.playing end)
        -- to avoid always hitting the exact same server, choose randomly among top 4 (or fewer)
        local topN = math.min(4, #candidates)
        local pickIndex = math.random(1, topN)
        return candidates[pickIndex].id
    end

    -- fallback 1: choose any non-full server (including 0)
    local fallback = {}
    for _, s in ipairs(servers) do
        if s.id ~= game.JobId and s.playing < s.maxPlayers then
            table.insert(fallback, s)
        end
    end
    if #fallback > 0 then
        return fallback[math.random(1,#fallback)].id
    end

    -- no server found
    return nil
end

-- Find the lowest population server (including 0)
local function findLowestServer()
    local servers = collectAllServers()
    if #servers == 0 then return nil end

    local lowestServer = nil
    local lowestPlayers = math.huge
    for _, s in ipairs(servers) do
        if s.id ~= game.JobId and s.playing < s.maxPlayers then
            if s.playing < lowestPlayers then
                lowestPlayers = s.playing
                lowestServer = s
            end
        end
    end

    if lowestServer then
        return lowestServer.id
    end

    -- fallback: random non-current server (if none meet condition)
    for _, s in ipairs(servers) do
        if s.id ~= game.JobId then
            return s.id
        end
    end

    return nil
end

-- Find a random server (non-full), used rarely as final fallback
local function findRandomNonFullServer()
    local servers = collectAllServers()
    local pool = {}
    for _, s in ipairs(servers) do
        if s.id ~= game.JobId and s.playing < s.maxPlayers then
            table.insert(pool, s.id)
        end
    end
    if #pool > 0 then
        return pool[math.random(1,#pool)]
    end
    return nil
end

-- Server Hop: go to server with many players but not full
Tabs.Server:AddButton({
    Title = "Server Hop",
    Description = "Join a Random server",
    Callback = function()
        Window:Dialog({
            Title = "Server Hop?",
            Content = "Do you want Hop?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        local ok, err = pcall(function()
                            -- find best high-pop server
                            local serverId = findBestHighPopulationServer()
                            if serverId then
                                TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, LocalPlayer)
                            else
                                local fallback = findRandomNonFullServer()
                                if fallback then
                                    TeleportService:TeleportToPlaceInstance(game.PlaceId, fallback, LocalPlayer)
                                else
                                    Window:Dialog({
                                        Title = "No Servers Found",
                                        Content = "Couldn't locate a suitable server to hop to.",
                                        Buttons = { { Title = "OK", Callback = function() end } }
                                    })
                                end
                            end
                        end)
                        if not ok then
                            Window:Dialog({
                                Title = "Teleport Error",
                                Content = "An error occurred while trying to hop:\n" .. tostring(err),
                                Buttons = { { Title = "OK", Callback = function() end } }
                            })
                        end
                    end
                },
                { Title = "Cancel", Callback = function() end }
            }
        })
    end
})

-- Rejoin (English dialog)
Tabs.Server:AddButton({
    Title = "Rejoin",
    Description = "Rejoin this server",
    Callback = function()
        if not LocalPlayer then
            Window:Dialog({
                Title = "Not Ready",
                Content = "LocalPlayer not accessible right now.",
                Buttons = { { Title = "OK", Callback = function() end } }
            })
            return
        end

        Window:Dialog({
            Title = "Rejoin?",
            Content = "Do you want to rejoin this server?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        local ok, err = pcall(function()
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                        end)
                        if not ok then
                            Window:Dialog({
                                Title = "Error",
                                Content = "Failed to rejoin:\n" .. tostring(err),
                                Buttons = { { Title = "OK", Callback = function() end } }
                            })
                        end
                    end
                },
                { Title = "Cancel", Callback = function() end }
            }
        })
    end
})

-- Lower Server: go to server with least players (including empty)
Tabs.Server:AddButton({
    Title = "Lower Server",
    Description = "Join the Lower server",
    Callback = function()
        Window:Dialog({
            Title = "Lower Server?",
            Content = "Do you want to join lower",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        local ok, err = pcall(function()
                            local serverId = findLowestServer()
                            if serverId then
                                TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, LocalPlayer)
                            else
                                Window:Dialog({
                                    Title = "Failed",
                                    Content = "No available low-population servers found.",
                                    Buttons = { { Title = "OK", Callback = function() end } }
                                })
                            end
                        end)
                        if not ok then
                            Window:Dialog({
                                Title = "Error",
                                Content = "An error occurred while trying to teleport:\n" .. tostring(err),
                                Buttons = { { Title = "OK", Callback = function() end } }
                            })
                        end
                    end
                },
                { Title = "Cancel", Callback = function() end }
            }
        })
    end
})

local Section = Tabs.Server:AddSection("Job ID")

-- เก็บค่าจาก Input
local jobIdInputValue = ""

-- สร้าง Input (ใช้ของเดิมที่ให้มา ปรับ Default ให้ว่าง)
local Input = Tabs.Server:AddInput("Input", {
    Title = "Input Job ID",
    Default = "",
    Placeholder = "วาง Job ID ที่นี่",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        jobIdInputValue = tostring(Value or "")
    end
})

-- อัปเดตค่าแบบ realtime เวลาเปลี่ยน
Input:OnChanged(function(Value)
    jobIdInputValue = tostring(Value or "")
end)

-- ปุ่ม Teleport
Tabs.Server:AddButton({
    Title = "Teleport to Job",
    Description = "Teleport ไปยัง Job ID ที่ใส่ข้างบน",
    Callback = function()
        -- validation เบื้องต้น
        if jobIdInputValue == "" or jobIdInputValue == "Default" then
            Window:Dialog({
                Title = "กรอกก่อน!!",
                Content = "กรอก Job ID ก่อนนะ จิ้มปุ่มอีกทีจะ teleport ให้",
                Buttons = {
                    { Title = "OK", Callback = function() end }
                }
            })
            return
        end

        -- เช็คว่าเป็น Job เดียวกับที่เราอยู่หรือยัง
        if tostring(game.JobId) == jobIdInputValue then
            Window:Dialog({
                Title = "same Job ID",
                Content = "คุณอยู่ในเซิร์ฟเวอร์นี้อยู่แล้ว (same Job ID).",
                Buttons = { { Title = "OK", Callback = function() end } }
            })
            return
        end

        -- ยืนยันก่อน teleport
        Window:Dialog({
            Title = "Confirm?",
            Content = "จะย้ายไปเซิร์ฟเวอร์ Job ID:\n" .. jobIdInputValue .. "\nยืนยันไหม?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        -- เรียก Teleport ใน pcall กัน error
                        local ok, err = pcall(function()
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobIdInputValue)
                        end)

                        if ok then
                        else
                            Window:Dialog({
                                Title = "Teleport ล้มเหลว",
                                Content = "เกิดข้อผิดพลาด: " .. tostring(err),
                                Buttons = { { Title = "OK", Callback = function() end } }
                            })
                        end
                    end
                },
                { Title = "Cancel", Callback = function() end }
            }
        })
    end
})

-- ปุ่มคัดลอก Job ID ปัจจุบัน
Tabs.Server:AddButton({
    Title = "Copy Current Job ID",
    Description = "คัดลอก Job ID ที่คุณอยู่ตอนนี้",
    Callback = function()
        local currentJobId = tostring(game.JobId or "")
        if currentJobId == "" then
            Window:Dialog({
                Title = "ไม่พบ Job ID",
                Content = "ไม่สามารถดึง Job ID ปัจจุบันได้",
                Buttons = { { Title = "OK", Callback = function() end } }
            })
            return
        end

        -- คัดลอกเข้าคลิปบอร์ด
        pcall(function()
            setclipboard(currentJobId)
        end)

        Window:Dialog({
            Title = "สำเร็จ!",
            Content = "คัดลอก Job ID ปัจจุบันเรียบร้อย:\n" .. currentJobId,
            Buttons = { { Title = "OK", Callback = function() end } }
        })
    end
})

-- -----------------------
-- Anti-AFK
-- -----------------------
do
    local vu = nil
    -- VirtualUser trick: works in many environments (Roblox default)
    local function enableAntiAFK(enable)
        if enable then
            if not vu then
                -- VirtualUser exists only in Roblox client; we get via game:GetService("VirtualUser") (works in studio / client)
                pcall(function() vu = game:GetService("VirtualUser") end)
            end
            if vu then
                Players.LocalPlayer.Idled:Connect(function()
                    pcall(function()
                        vu:Button2Down(Vector2.new(0,0))
                        task.wait(1)
                        vu:Button2Up(Vector2.new(0,0))
                    end)
                end)
            end
        end
    end

    local antiAFKToggle = Tabs.Settings:AddToggle("AntiAFKToggle", { Title = "Anti-AFK", Default = true })
    antiAFKToggle:OnChanged(function(v) enableAntiAFK(v) end)
    -- default on
    antiAFKToggle:SetValue(true)
    enableAntiAFK(true)
end
-- รอ RobloxPromptGui ให้โหลดก่อน
repeat task.wait() until game.CoreGui:FindFirstChild('RobloxPromptGui')
local promptOverlay = game.CoreGui.RobloxPromptGui.promptOverlay
local TeleportService = game:GetService('TeleportService')
local Players = game:GetService('Players')
local lp = Players.LocalPlayer

-- สร้าง Toggle ก่อนแล้วค่อยใช้มัน (แก้ปัญหาใช้ตัวแปรก่อนประกาศ)
local Toggle = Tabs.Settings:AddToggle("AutoRejoin", {
    Title = "Auto Rejoin",
    Default = true
})

local conn = nil
local loopActive = false
local stopLoop = false

local function startTeleportLoop()
    if loopActive then return end
    loopActive = true
    stopLoop = false

    task.spawn(function()
        while not stopLoop do
            if lp and lp.Character then
                pcall(function()
                    -- Teleport player ไปที่เดิม (rejoin)
                    TeleportService:Teleport(game.PlaceId, lp)
                end)
            end
            task.wait(2) -- เว้น 2 วินาทีก่อนลองอีกครั้ง
        end
        loopActive = false
    end)
end

local function stopTeleportLoop()
    stopLoop = true
end

local function onChildAdded(child)
    if child and child.Name == 'ErrorPrompt' then
        startTeleportLoop()
    end
end

-- เมื่อ Toggle เปลี่ยนสถานะ
Toggle:OnChanged(function(state)
    if state then
        -- เปิด: เชื่อมต่อถ้ายังไม่เชื่อม
        if not conn then
            conn = promptOverlay.ChildAdded:Connect(onChildAdded)
        end

        -- ถ้ามี ErrorPrompt อยู่แล้วตอนเปิด ให้เริ่มทันที
        for _, v in ipairs(promptOverlay:GetChildren()) do
            if v.Name == 'ErrorPrompt' then
                startTeleportLoop()
                break
            end
        end
    else
        -- ปิด: ตัด connection และหยุดลูป
        if conn then
            pcall(function() conn:Disconnect() end)
            conn = nil
        end
        stopTeleportLoop()
    end

    -- ถ้า lib ของคุณใช้ Options[...] ให้ sync ค่าด้วย (safe check)
    if Options and Options.AutoRejoin then
        pcall(function() Options.AutoRejoin:SetValue(state) end)
    end
end)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({
    Title = "ATG Hub Freemium",
    Content = "Loading...",
    Duration = 3
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig() 

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local playerGui = localPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- ⚙️ การตั้งค่าเริ่มต้น
local DEFAULT_CONFIG = {
	ForceShowButton = true,
	
	Position = {
		Horizontal = "left",
		Vertical = "top",
		OffsetX = 140,
		OffsetY = 140
	},
	
	ButtonSize = {
		Min = 40,
		Max = 46
	},
	
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
	
	Keybind = {
		Key = Enum.KeyCode.M,
		Modifier = Enum.KeyCode.LeftControl
	}
}

-- 🔧 ผสาน Config จาก getgenv
local function mergeConfig(default, custom)
	local result = {}
	for key, value in pairs(default) do
		if type(value) == "table" and custom[key] and type(custom[key]) == "table" then
			result[key] = mergeConfig(value, custom[key])
		else
			result[key] = custom[key] ~= nil and custom[key] or value
		end
	end
	return result
end

-- โหลด Config จาก getgenv (ถ้ามี)
local CONFIG = DEFAULT_CONFIG
if getgenv and getgenv().ATGButtonUI then
	CONFIG = mergeConfig(DEFAULT_CONFIG, getgenv().ATGButtonUI)
end

-- 🔍 ตรวจจับอุปกรณ์
local function detectDevice()
	local hasKeyboard = UserInputService.KeyboardEnabled
	local hasTouch = UserInputService.TouchEnabled
	local hasGamepad = UserInputService.GamepadEnabled
	
	return {
		keyboard = hasKeyboard,
		touch = hasTouch,
		gamepad = hasGamepad,
		shouldShowButton = CONFIG.ForceShowButton or not hasKeyboard or (hasTouch and not hasKeyboard) or (hasGamepad and not hasKeyboard)
	}
end

-- 📐 คำนวณขนาดและตำแหน่ง
local function calculateButtonSize()
	local viewport = Camera.ViewportSize
	local hasTouch = UserInputService.TouchEnabled
	local size = hasTouch and CONFIG.ButtonSize.Min or CONFIG.ButtonSize.Max
	return UDim2.fromOffset(size, size)
end

local function calculateButtonPosition()
	local viewport = Camera.ViewportSize
	local offsetX = CONFIG.Position.OffsetX
	local offsetY = CONFIG.Position.OffsetY
	
	-- คำนวณตำแหน่งแนวนอน
	local xScale, xOffset, anchorX
	if CONFIG.Position.Horizontal == "left" then
		xScale = 0
		xOffset = offsetX
		anchorX = 0
	elseif CONFIG.Position.Horizontal == "right" then
		xScale = 1
		xOffset = -offsetX
		anchorX = 1
	else -- center
		xScale = 0.5
		xOffset = 0
		anchorX = 0.5
	end
	
	-- คำนวณตำแหน่งแนวตั้ง
	local yScale, yOffset, anchorY
	if CONFIG.Position.Vertical == "top" then
		yScale = 0
		yOffset = offsetY
		anchorY = 0
	elseif CONFIG.Position.Vertical == "bottom" then
		yScale = 1
		yOffset = -offsetY
		anchorY = 1
	else -- center
		yScale = 0.5
		yOffset = 0
		anchorY = 0.5
	end
	
	return UDim2.new(xScale, xOffset, yScale, yOffset), Vector2.new(anchorX, anchorY)
end

-- 🎨 สร้าง UI
local function createToggleButton(parent)
	local button = Instance.new("ImageButton")
	button.Name = "FluentToggleButton"
	button.Size = calculateButtonSize()
	
	-- ตั้งตำแหน่งและ AnchorPoint
	local position, anchor = calculateButtonPosition()
	button.Position = position
	button.AnchorPoint = anchor
	
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.BackgroundTransparency = 0
	button.BorderSizePixel = 0
	button.Image = CONFIG.ImageId
	button.Active = true
	button.Parent = parent
	
	-- มุมโค้ง
	local corner = Instance.new("UICorner", button)
	corner.CornerRadius = UDim.new(0, 8)
	
	-- เส้นเรืองแสง
	local stroke = Instance.new("UIStroke", button)
	stroke.Name = "FluentStroke"
	stroke.Thickness = CONFIG.Stroke.BaseThickness
	stroke.Transparency = CONFIG.Stroke.BaseTransparency
	stroke.LineJoinMode = Enum.LineJoinMode.Round
	
	return button, stroke
end

-- 🌈 เอฟเฟกต์เรืองแสง RGB
local function animateStroke(stroke)
	local startTime = tick()
	local connection
	
	connection = RunService.RenderStepped:Connect(function()
		if not stroke or not stroke.Parent then
			if connection then connection:Disconnect() end
			return
		end
		
		local elapsed = tick() - startTime
		local hue = (elapsed * CONFIG.Stroke.HueSpeed) % 1
		local pulse = (math.sin(elapsed * CONFIG.Stroke.PulseSpeed * math.pi * 2) + 1) / 2
		
		stroke.Color = Color3.fromHSV(hue, CONFIG.Stroke.Saturation, CONFIG.Stroke.Value)
		stroke.Thickness = CONFIG.Stroke.BaseThickness + (pulse * CONFIG.Stroke.PulseThickness)
		stroke.Transparency = CONFIG.Stroke.BaseTransparency + (pulse * CONFIG.Stroke.PulseTransparency)
	end)
	
	return connection
end

-- 🔒 ระบบจำกัดตำแหน่งให้อยู่ในจอ
local function clampPositionToScreen(button)
	local viewport = Camera.ViewportSize
	local absPos = button.AbsolutePosition
	local absSize = button.AbsoluteSize
	
	-- คำนวณ bounds ของปุ่ม
	local left = absPos.X
	local right = absPos.X + absSize.X
	local top = absPos.Y
	local bottom = absPos.Y + absSize.Y
	
	-- ตรวจสอบว่าหลุดจอหรือไม่
	local needsAdjustment = false
	local newX = absPos.X
	local newY = absPos.Y
	
	-- ตรวจสอบขอบซ้าย-ขวา
	if left < 0 then
		newX = 0
		needsAdjustment = true
	elseif right > viewport.X then
		newX = viewport.X - absSize.X
		needsAdjustment = true
	end
	
	-- ตรวจสอบขอบบน-ล่าง
	if top < 0 then
		newY = 0
		needsAdjustment = true
	elseif bottom > viewport.Y then
		newY = viewport.Y - absSize.Y
		needsAdjustment = true
	end
	
	-- ปรับตำแหน่งถ้าจำเป็น
	if needsAdjustment then
		button.Position = UDim2.fromOffset(newX, newY)
	end
end

-- 🖱️ ระบบลากปุ่ม (พร้อมระบบจำกัดตำแหน่ง)
local function setupDragging(button)
	local dragging = false
	local dragInput = nil
	local dragStart = nil
	local startPos = nil
	
	-- เริ่มลาก
	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or 
		   input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragInput = input
			dragStart = input.Position
			startPos = button.Position
			
			-- ติดตามเมื่อ input สิ้นสุด
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					-- จำกัดตำแหน่งเมื่อปล่อยปุ่ม
					clampPositionToScreen(button)
				end
			end)
		end
	end)
	
	-- อัพเดทตำแหน่งขณะลาก
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
		                 input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			local newPos = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
			button.Position = newPos
			
			-- จำกัดตำแหน่งขณะลาก (real-time)
			clampPositionToScreen(button)
		end
	end)
	
	-- ปรับขนาดและตำแหน่งเมื่อเปลี่ยนหน้าจอ
	Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		task.wait(0.1)
		
		-- อัพเดทขนาดปุ่ม
		button.Size = calculateButtonSize()
		
		-- ถ้ายังไม่ได้ลาก ให้กลับไปตำแหน่งเริ่มต้น
		if not dragging then
			local position, anchor = calculateButtonPosition()
			button.Position = position
			button.AnchorPoint = anchor
		else
			-- ถ้ากำลังลาก ให้จำกัดตำแหน่งไม่ให้หลุดจอ
			clampPositionToScreen(button)
		end
		
		-- เช็คอีกครั้งหลังจากขนาดเปลี่ยน
		task.wait(0.05)
		clampPositionToScreen(button)
	end)
	
	-- เช็คตำแหน่งเริ่มต้นว่าหลุดจอหรือไม่
	task.wait(0.2)
	clampPositionToScreen(button)
end

-- 🔎 ค้นหา Fluent UI
local function findFluentUI()
	local candidates = {}
	local added = {}
	
	local function addCandidate(obj)
		if added[obj] then return end
		added[obj] = true
		table.insert(candidates, obj)
	end
	
	local markers = {"TabDisplay", "ContainerCanvas", "AcrylicPaint", "TitleBar", "TabHolder", "Fluent"}
	
	local function scanGui(gui)
		if gui:IsA("ScreenGui") and gui.Name:lower():find("fluent") then
			addCandidate(gui)
		end
		
		for _, obj in ipairs(gui:GetDescendants()) do
			if obj:IsA("GuiObject") then
				local name = obj.Name:lower()
				
				for _, marker in ipairs(markers) do
					if name:find(marker:lower()) then
						local sg = obj:FindFirstAncestorOfClass("ScreenGui")
						if sg then addCandidate(sg) end
						break
					end
				end
				
				if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
					local text = obj.Text:lower()
					if text:find("fluent") or text:find("interface") or text:find("by dawid") then
						local sg = obj:FindFirstAncestorOfClass("ScreenGui")
						if sg then addCandidate(sg) end
					end
				end
			end
		end
	end
	
	for _, gui in ipairs(playerGui:GetChildren()) do
		if gui:IsA("ScreenGui") then
			scanGui(gui)
		end
	end
	
	pcall(function()
		for _, gui in ipairs(CoreGui:GetChildren()) do
			if gui:IsA("ScreenGui") then
				scanGui(gui)
			end
		end
	end)
	
	if #candidates == 0 then
		for _, gui in ipairs(playerGui:GetChildren()) do
			if gui:IsA("ScreenGui") then
				addCandidate(gui)
			end
		end
	end
	
	return candidates
end

-- ⚡ Toggle UI
local toggleDebounce = false
local toggleGui = nil

local function shouldSkip(obj)
	if not obj then return true end
	if toggleGui and (obj == toggleGui or obj:IsDescendantOf(toggleGui)) then return true end
	return false
end

local function toggleUI()
	if toggleDebounce then return end
	toggleDebounce = true
	task.delay(0.18, function() toggleDebounce = false end)
	
	local success = pcall(function()
		if typeof(Window) == "table" and type(Window.Minimize) == "function" then
			Window:Minimize()
			return true
		end
	end)
	
	if success then return end
	
	local candidates = findFluentUI()
	
	if #candidates == 0 then
		for _, gui in ipairs(playerGui:GetChildren()) do
			if gui:IsA("ScreenGui") and not shouldSkip(gui) then
				pcall(function()
					gui.Enabled = not gui.Enabled
				end)
			end
		end
		return
	end
	
	for _, gui in ipairs(candidates) do
		if not shouldSkip(gui) then
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

-- 🚀 เริ่มต้นระบบ
local function initialize()
	local device = detectDevice()
	
	if not device.shouldShowButton then return end
	
	toggleGui = Instance.new("ScreenGui")
	toggleGui.Name = "FluentToggleGui"
	toggleGui.ResetOnSpawn = false
	toggleGui.DisplayOrder = 9999
	toggleGui.IgnoreGuiInset = true
	
	local success = pcall(function()
		toggleGui.Parent = CoreGui
	end)
	
	if not success then
		toggleGui.Parent = playerGui
	end
	
	local button, stroke = createToggleButton(toggleGui)
	
	animateStroke(stroke)
	setupDragging(button)
	
	button.Activated:Connect(function()
		pcall(toggleUI)
	end)
	
	if device.keyboard then
		UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then return end
			
			if input.UserInputType == Enum.UserInputType.Keyboard and
			   input.KeyCode == CONFIG.Keybind.Key and
			   UserInputService:IsKeyDown(CONFIG.Keybind.Modifier) then
				pcall(toggleUI)
			end
		end)
	end
end

-- ▶️ รันสคริปต์
initialize()
-- End of script
