---@diagnostic disable: undefined-global
--[[
    ════════════════════════════════════════════════════════════
    🔐 ATG HUB - KeySystem Module
    ════════════════════════════════════════════════════════════
    ระบบ KeySystem ที่ใช้งานง่าย พร้อมระบบบันทึกคีย์
    รองรับ HWID Lock และเชื่อมต่อ API ได้
    ════════════════════════════════════════════════════════════
--]]

repeat task.wait() until game:IsLoaded()

local KeySystemModule = {}

-- ══════════════════════════════════════════════════════════════
-- 🔧 การตั้งค่าเริ่มต้น
-- ══════════════════════════════════════════════════════════════

local DEFAULT_CONFIG = {
    -- ชื่อ KeySystem
    Title = "ATG Hub - Key System",
    SubTitle = "Enter your key to continue",

    -- คีย์ที่ถูกต้อง (สามารถเป็น string หรือ table)
    ValidKeys = {
        "ATG-FREE-2024",
        "DEMO-KEY-123",
        "TEST-KEY-456"
    },

    -- ลิงก์รับคีย์ (เปลี่ยนเป็นของคุณเอง)
    KeyLink = "https://discord.gg/uyRxC66fw6",

    -- API สำหรับเช็คคีย์ (ถ้าใช้ API แทนคีย์ hardcode)
    UseAPI = false,
    APIUrl = "https://yourdomain.com/api/checkkey?key=", -- จะต่อด้วยคีย์ที่ผู้เล่นใส่

    -- ระบบบันทึกคีย์
    SaveKey = true, -- บันทึกคีย์หลังจากใส่ถูกต้อง
    SaveFileName = "ATGHub_SavedKey.txt",

    -- HWID Lock
    UseHWID = false, -- เปิดใช้งาน HWID Lock

    -- หมดอายุของคีย์ (วินาที) - ถ้าไม่ต้องการให้ใส่ nil
    KeyExpiration = nil, -- เช่น 86400 = 1 วัน, 604800 = 1 สัปดาห์

    -- ธีมของ KeySystem UI
    Theme = "Dark",
    Acrylic = true,
}

-- ══════════════════════════════════════════════════════════════
-- 🛠️ ฟังก์ชันช่วยเหลือ
-- ══════════════════════════════════════════════════════════════

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- รับ HWID (Hardware ID)
local function getHWID()
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    return hwid
end

-- บันทึกคีย์ลงไฟล์
local function saveKey(key)
    if not writefile then
        warn("[KeySystem] Executor ของคุณไม่รองรับการบันทึกไฟล์")
        return false
    end

    local data = {
        key = key,
        hwid = getHWID(),
        timestamp = os.time(),
    }

    local success = pcall(function()
        writefile(DEFAULT_CONFIG.SaveFileName, HttpService:JSONEncode(data))
    end)

    return success
end

-- โหลดคีย์จากไฟล์
local function loadSavedKey()
    if not readfile or not isfile then return nil end

    if not isfile(DEFAULT_CONFIG.SaveFileName) then
        return nil
    end

    local success, data = pcall(function()
        local content = readfile(DEFAULT_CONFIG.SaveFileName)
        return HttpService:JSONDecode(content)
    end)

    if not success or not data then return nil end

    -- ตรวจสอบ HWID
    if DEFAULT_CONFIG.UseHWID then
        if data.hwid ~= getHWID() then
            warn("[KeySystem] HWID ไม่ตรงกัน - คีย์ถูกใช้บนเครื่องอื่น")
            return nil
        end
    end

    -- ตรวจสอบวันหมดอายุ
    if DEFAULT_CONFIG.KeyExpiration then
        local elapsed = os.time() - data.timestamp
        if elapsed > DEFAULT_CONFIG.KeyExpiration then
            warn("[KeySystem] คีย์หมดอายุแล้ว")
            return nil
        end
    end

    return data.key
end

-- ตรวจสอบคีย์ (ตรวจสอบกับ ValidKeys หรือ API)
local function validateKey(key)
    -- ถ้าใช้ API
    if DEFAULT_CONFIG.UseAPI and DEFAULT_CONFIG.APIUrl then
        local success, result = pcall(function()
            local response = game:HttpGet(DEFAULT_CONFIG.APIUrl .. key)
            local data = HttpService:JSONDecode(response)
            return data.valid == true
        end)

        if success then
            return result
        else
            warn("[KeySystem] ไม่สามารถเชื่อมต่อ API ได้")
            return false
        end
    end

    -- ตรวจสอบกับคีย์ที่กำหนดไว้
    if type(DEFAULT_CONFIG.ValidKeys) == "table" then
        for _, validKey in ipairs(DEFAULT_CONFIG.ValidKeys) do
            if key == validKey then
                return true
            end
        end
    elseif type(DEFAULT_CONFIG.ValidKeys) == "string" then
        return key == DEFAULT_CONFIG.ValidKeys
    end

    return false
end

-- ══════════════════════════════════════════════════════════════
-- 🎨 สร้าง KeySystem UI
-- ══════════════════════════════════════════════════════════════

function KeySystemModule:CreateKeySystem(config)
    -- ผสาน config
    if config then
        for k, v in pairs(config) do
            DEFAULT_CONFIG[k] = v
        end
    end

    -- โหลด Fluent Library
    local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/ATGFAIL/ATGHUBUI/main/MainUI.lua"))()

    if not Fluent then
        warn("[KeySystem] ไม่สามารถโหลด Fluent UI ได้")
        return false
    end

    -- ตรวจสอบคีย์ที่บันทึกไว้
    if DEFAULT_CONFIG.SaveKey then
        local savedKey = loadSavedKey()
        if savedKey then
            if validateKey(savedKey) then
                print("[KeySystem] ✅ ใช้คีย์ที่บันทึกไว้: " .. savedKey)
                return true -- คีย์ถูกต้อง ไม่ต้องแสดง UI
            else
                warn("[KeySystem] คีย์ที่บันทึกไว้ไม่ถูกต้อง")
            end
        end
    end

    -- สร้างหน้าต่าง KeySystem
    local KeyWindow = Fluent:CreateWindow({
        Title = DEFAULT_CONFIG.Title,
        SubTitle = DEFAULT_CONFIG.SubTitle,
        TabWidth = 160,
        Size = UDim2.fromOffset(500, 350),
        Acrylic = DEFAULT_CONFIG.Acrylic,
        Theme = DEFAULT_CONFIG.Theme,
        MinimizeKey = nil, -- ปิดการย่อหน้าต่าง
    })

    local Tabs = {
        Main = KeyWindow:AddTab({ Title = "Key", Icon = "key" }),
    }

    -- ข้อมูลคีย์
    local enteredKey = ""
    local keyValidated = false

    -- แสดงข้อมูล
    Tabs.Main:AddParagraph({
        Title = "🔐 Welcome to ATG Hub",
        Content = [[
To use this script, you need a valid key.
Get your key from our Discord or website.

• Keys are saved automatically
• HWID Protection enabled
• Secure & Fast verification
        ]]
    })

    Tabs.Main:AddSection("Enter Your Key")

    -- ช่องใส่คีย์
    local KeyInput = Tabs.Main:AddInput("KeyInput", {
        Title = "🔑 License Key",
        Default = "",
        Placeholder = "Enter your key here...",
        Numeric = false,
        Finished = false,
        Callback = function(value)
            enteredKey = tostring(value)
        end
    })

    KeyInput:OnChanged(function(value)
        enteredKey = tostring(value)
    end)

    -- ปุ่มยืนยันคีย์
    Tabs.Main:AddButton({
        Title = "✅ Verify Key",
        Description = "Click to check your key",
        Callback = function()
            if enteredKey == "" then
                Fluent:Notify({
                    Title = "⚠️ Error",
                    Content = "Please enter a key first!",
                    Duration = 3
                })
                return
            end

            -- ตรวจสอบคีย์
            if validateKey(enteredKey) then
                keyValidated = true

                -- บันทึกคีย์
                if DEFAULT_CONFIG.SaveKey then
                    saveKey(enteredKey)
                end

                Fluent:Notify({
                    Title = "✅ Success!",
                    Content = "Key verified successfully!\nLoading main UI...",
                    Duration = 3
                })

                -- ปิด KeySystem UI
                task.wait(1)
                if KeyWindow and KeyWindow.Unload then
                    KeyWindow:Unload()
                elseif KeyWindow and KeyWindow.Root then
                    KeyWindow.Root:Destroy()
                end

            else
                Fluent:Notify({
                    Title = "❌ Invalid Key",
                    Content = "The key you entered is incorrect.\nPlease try again or get a new key.",
                    Duration = 4
                })
            end
        end
    })

    Tabs.Main:AddSection("Get Your Key")

    -- ปุ่มคัดลอกลิงก์
    Tabs.Main:AddButton({
        Title = "📋 Copy Key Link",
        Description = "Copy the link to get your key",
        Callback = function()
            if setclipboard then
                setclipboard(DEFAULT_CONFIG.KeyLink)
                Fluent:Notify({
                    Title = "✅ Copied!",
                    Content = "Key link copied to clipboard!",
                    Duration = 3
                })
            else
                Fluent:Notify({
                    Title = "ℹ️ Link",
                    Content = DEFAULT_CONFIG.KeyLink,
                    Duration = 5
                })
            end
        end
    })

    -- ปุ่มเปิดลิงก์ Discord
    Tabs.Main:AddButton({
        Title = "🌐 Get Key (Discord)",
        Description = "Open Discord to get your free key",
        Callback = function()
            KeyWindow:Dialog({
                Title = "Get Your Key",
                Content = "Join our Discord to get a free key!\n\nLink: " .. DEFAULT_CONFIG.KeyLink,
                Buttons = {
                    {
                        Title = "Copy Link",
                        Callback = function()
                            if setclipboard then
                                setclipboard(DEFAULT_CONFIG.KeyLink)
                            end
                        end
                    },
                    {
                        Title = "Close",
                        Callback = function() end
                    }
                }
            })
        end
    })

    -- แสดง HWID ถ้าเปิดใช้งาน
    if DEFAULT_CONFIG.UseHWID then
        Tabs.Main:AddSection("Your HWID")
        Tabs.Main:AddParagraph({
            Title = "🔒 Hardware ID",
            Content = "Your HWID: " .. getHWID() .. "\n\n(Copy this if you need to whitelist your device)"
        })

        Tabs.Main:AddButton({
            Title = "📋 Copy HWID",
            Description = "Copy your Hardware ID",
            Callback = function()
                if setclipboard then
                    setclipboard(getHWID())
                    Fluent:Notify({
                        Title = "✅ Copied!",
                        Content = "HWID copied to clipboard!",
                        Duration = 3
                    })
                end
            end
        })
    end

    -- รอให้ผู้เล่นใส่คีย์ถูกต้อง
    repeat task.wait(0.5) until keyValidated

    return true
end

-- ══════════════════════════════════════════════════════════════
-- 📌 ฟังก์ชันหลักที่ง่ายที่สุด (แบบ AddKeysystem)
-- ══════════════════════════════════════════════════════════════

function KeySystemModule:AddKeysystem(tab, config)
    local cfg = {
        Title = config.Title or "Key System",
        SubTitle = config.SubTitle or "Enter your key",
        ValidKeys = config.ValidKeys or {"DEMO-KEY"},
        KeyLink = config.KeyLink or "https://discord.gg/yourlink",
        UseAPI = config.UseAPI or false,
        APIUrl = config.APIUrl or "",
        SaveKey = config.SaveKey ~= false, -- default true
        SaveFileName = config.SaveFileName or "ATGHub_SavedKey.txt",
        UseHWID = config.UseHWID or false,
        KeyExpiration = config.KeyExpiration or nil,
        Theme = config.Theme or "Dark",
        Acrylic = config.Acrylic ~= false,
    }

    return self:CreateKeySystem(cfg)
end

return KeySystemModule
