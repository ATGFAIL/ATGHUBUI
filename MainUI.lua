-- Splash screen. Opt-in: set getgenv().ATGSplash = true before loading,
-- pass CreateWindow{Splash = true}, or call Library:ShowSplash(). Shown once.
local splashShown = false
local function showSplash()
    if splashShown then
        return
    end
    splashShown = true
    -- Runs on its own thread: PreloadAsync yields, and callers such as
    -- CreateWindow must not.
    task.spawn(function()
        local TweenService = game:GetService("TweenService")
        local ContentProvider = game:GetService("ContentProvider")
        local CoreGui = game:GetService("CoreGui")
        local Lighting = game:GetService("Lighting")
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local camera = workspace.CurrentCamera
        local logoImage = "rbxassetid://90989180960460"
        local showTitle = true
        local titleText = "ATG HUB"
        local okTitleFont, titleFace = pcall(Font.new, "rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        local fallbackSplashFont = Enum.Font.BuilderSansBold
        local fadeInTime = 0.35
        local holdTime = 0.8
        local fadeOutTime = 0.35
        local startScale = 0.82
        local endScale = 1.12
        local baseImageScale = 0.6
        local pulseScale = 0.9
        local blurSize = 8
        if CoreGui:FindFirstChild("CoreSplash") then
            CoreGui.CoreSplash:Destroy()
        end
        pcall(
            function()
                ContentProvider:PreloadAsync({logoImage})
            end
        )
        local function tween(instance, goals, duration, easingStyle, easingDirection)
            local info = TweenInfo.new(duration, easingStyle or Enum.EasingStyle.Sine, easingDirection or Enum.EasingDirection.Out)
            local playing = TweenService:Create(instance, info, goals)
            playing:Play()
            return playing
        end
        local splashGui = Instance.new("ScreenGui")
        splashGui.Name = "CoreSplash"
        splashGui.IgnoreGuiInset = true
        splashGui.ResetOnSpawn = false
        splashGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        splashGui.DisplayOrder = 999999999
        splashGui.Parent = CoreGui
        local function getViewportSize()
            return camera and camera.ViewportSize or Vector2.new(1280, 720)
        end
        local function getLayoutMetrics()
            local viewport = getViewportSize()
            local shortestSide = math.min(viewport.X, viewport.Y)
            local scaleFactor = shortestSide / 1080
            local imageScale = math.clamp(baseImageScale * scaleFactor, 0.18, 0.72)
            return {imageScale = imageScale, textSize = math.clamp(26 * scaleFactor, 14, 56)}
        end
        local overlay = Instance.new("Frame")
        overlay.Name = "Overlay"
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.Position = UDim2.fromScale(0, 0)
        overlay.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
        overlay.BackgroundTransparency = 1
        overlay.BorderSizePixel = 0
        overlay.ZIndex = 99999999
        overlay.Parent = splashGui
        local blur
        do
            blur = Lighting:FindFirstChild("CoreSplashBlur") or Instance.new("BlurEffect")
            blur.Name = "CoreSplashBlur"
            blur.Parent = Lighting
            blur.Size = 0
            blur.Enabled = true
        end
        local center = Instance.new("Frame")
        center.Name = "Center"
        center.AnchorPoint = Vector2.new(0.5, 0.5)
        center.Position = UDim2.fromScale(0.5, 0.5)
        center.Size = UDim2.fromOffset(0, 0)
        center.BackgroundTransparency = 1
        center.ZIndex = 99999999
        center.Parent = splashGui
        local logo = Instance.new("ImageLabel")
        logo.Name = "Logo"
        logo.AnchorPoint = Vector2.new(0.5, 0.5)
        logo.Position = UDim2.fromScale(0.5, 0.5)
        logo.Size = UDim2.fromScale(0.4, 0.4)
        logo.BackgroundTransparency = 1
        logo.Image = logoImage
        logo.ImageTransparency = 1
        logo.ScaleType = Enum.ScaleType.Fit
        logo.ZIndex = 99999999
        logo.Parent = center
        local rim = Instance.new("ImageLabel")
        rim.Name = "Rim"
        rim.AnchorPoint = Vector2.new(0.5, 0.5)
        rim.Position = UDim2.fromScale(0.5, 0.5)
        rim.Size = UDim2.fromScale(1, 1)
        rim.BackgroundTransparency = 1
        rim.Image = logoImage
        rim.ImageTransparency = 0.985
        rim.ScaleType = Enum.ScaleType.Fit
        rim.ZIndex = 99999999
        rim.Parent = logo
        local titleShadow = Instance.new("TextLabel")
        titleShadow.Name = "TextShadow"
        titleShadow.AnchorPoint = Vector2.new(0.5, 0)
        titleShadow.Position = UDim2.new(0.5, 1, 0, 16)
        titleShadow.Size = UDim2.new(0.9, 0, 0, 30)
        titleShadow.BackgroundTransparency = 1
        titleShadow.ZIndex = 99999999
        titleShadow.Text = showTitle and titleText or ""
        titleShadow.TextColor3 = Color3.fromRGB(10, 10, 10)
        titleShadow.TextTransparency = 0.35
        if okTitleFont and titleFace then
            titleShadow.FontFace = titleFace
        else
            titleShadow.Font = fallbackSplashFont
        end
        titleShadow.TextSize = 18
        titleShadow.Parent = center
        local title = Instance.new("TextLabel")
        title.Name = "Text"
        title.AnchorPoint = Vector2.new(0.5, 0)
        title.Position = titleShadow.Position
        title.Size = titleShadow.Size
        title.BackgroundTransparency = 1
        title.ZIndex = 99999999
        title.Text = showTitle and titleText or ""
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextStrokeTransparency = 0.7
        if okTitleFont and titleFace then
            title.FontFace = titleFace
        else
            title.Font = fallbackSplashFont
        end
        title.TextSize = 18
        title.Parent = center
        local function applyLayout()
            local metrics = getLayoutMetrics()
            local imageScale = metrics.imageScale
            logo.Size = UDim2.fromScale(imageScale, imageScale)
            rim.Size = UDim2.fromScale(1, 1)
            local viewport = getViewportSize()
            center.Size = UDim2.fromOffset(math.max(400, viewport.X * imageScale * 0.95), math.max(300, viewport.Y * imageScale * 0.8))
            title.TextSize = metrics.textSize
            titleShadow.TextSize = metrics.textSize
            local logoHeight = logo.AbsoluteSize.Y
            local titleOffset = math.clamp(logoHeight / 2 + metrics.textSize * 0.9 + 18, 48, 420)
            title.Position = UDim2.new(0.5, 0, 0.5, titleOffset)
            titleShadow.Position = UDim2.new(0.5, 2, 0.5, titleOffset + 2)
        end
        applyLayout()
        local viewportConnection
        viewportConnection =
            camera:GetPropertyChangedSignal("ViewportSize"):Connect(
            function()
                applyLayout()
            end
        )
        task.spawn(
            function()
                tween(overlay, {BackgroundTransparency = 0.45}, 0.35, Enum.EasingStyle.Quad)
                tween(blur, {Size = blurSize}, 0.45, Enum.EasingStyle.Quad)
                local metrics = getLayoutMetrics()
                logo.Size = UDim2.fromScale(metrics.imageScale * startScale, metrics.imageScale * startScale)
                tween(logo, {ImageTransparency = 0}, fadeInTime, Enum.EasingStyle.Sine)
                tween(logo, {Size = UDim2.fromScale(metrics.imageScale * 1.02, metrics.imageScale * 1.02)}, fadeInTime, Enum.EasingStyle.Quart)
                task.wait(fadeInTime * 0.9)
                local growTween =
                    tween(
                    logo,
                    {Size = UDim2.fromScale(metrics.imageScale * 1.06, metrics.imageScale * 1.06)},
                    0.9,
                    Enum.EasingStyle.Quad,
                    Enum.EasingDirection.InOut
                )
                growTween.Completed:Connect(
                    function()
                        if logo and logo.Parent then
                            tween(
                                logo,
                                {Size = UDim2.fromScale(metrics.imageScale * 1.02, metrics.imageScale * 1.02)},
                                0.9,
                                Enum.EasingStyle.Quad,
                                Enum.EasingDirection.InOut
                            )
                        end
                    end
                )
                task.wait(fadeInTime + holdTime)
                tween(overlay, {BackgroundTransparency = 1}, fadeOutTime, Enum.EasingStyle.Quad)
                tween(blur, {Size = 0}, fadeOutTime, Enum.EasingStyle.Quad)
                tween(
                    logo,
                    {ImageTransparency = 1, Size = UDim2.fromScale(metrics.imageScale * endScale, metrics.imageScale * endScale)},
                    fadeOutTime,
                    Enum.EasingStyle.Quad
                )
                tween(title, {TextTransparency = 1}, fadeOutTime * 0.9, Enum.EasingStyle.Quad)
                tween(titleShadow, {TextTransparency = 1}, fadeOutTime * 0.9, Enum.EasingStyle.Quad)
                task.wait(fadeOutTime + 0.05)
                if viewportConnection then
                    viewportConnection:Disconnect()
                end
                pcall(
                    function()
                        splashGui:Destroy()
                        if blur and blur.Parent then
                            blur:Destroy()
                        end
                    end
                )
            end
        )
    end)
end
do
    local requested = false
    pcall(function()
        requested = type(getgenv) == "function" and getgenv().ATGSplash == true
    end)
    if requested then
        showSplash()
    end
end

-- Legacy translation API. Its methods are provided by the compatibility
-- facade over the I18n system at the end of CustomizationSystem below; only
-- the server address and the fields older scripts may read are declared
-- here (the facade points them at the I18n state).
local TranslationSystem = {
    API_URL = "https://translate.atgofficial.net",
    Cache = {},
    Registry = {},
    CurrentLanguage = "en",
    SourceLanguage = "en",
    Enabled = true,
    AvailableLanguages = {}
}
-- ============================================================================

--[[
    User customization layer

    This is intentionally kept outside the bundled Fluent modules below.  The
    modules still use TranslationSystem:Register(), so the compatibility facade
    at the end of this block lets old scripts opt into the new system without
    changing their AddButton/AddToggle/etc. calls.

    Remote input is treated as data only: language packs are JSON and font
    downloads are saved as assets.  Nothing downloaded here is ever executed.
]]
local CustomizationSystem = {}
do
    local cloneRef = cloneref or clonereference or function(instance)
        return instance
    end
    local HttpService = cloneRef(game:GetService("HttpService"))
    local localizationOk, LocalizationService = pcall(function()
        return cloneRef(game:GetService("LocalizationService"))
    end)

    local function getExecutorGlobal(name)
        local direct = {
            request = request,
            http_request = http_request,
            httpget = httpget,
            writefile = writefile,
            readfile = readfile,
            isfile = isfile,
            isfolder = isfolder,
            makefolder = makefolder,
            listfiles = listfiles,
            delfile = delfile,
            getcustomasset = getcustomasset,
            getsynasset = getsynasset,
            setclipboard = setclipboard
        }

        if type(direct[name]) == "function" then
            return direct[name]
        end

        if type(getgenv) == "function" then
            local ok, environment = pcall(getgenv)
            if ok and type(environment) == "table" and type(environment[name]) == "function" then
                return environment[name]
            end
        end

        if type(_G) == "table" and type(_G[name]) == "function" then
            return _G[name]
        end

        return nil
    end

    local function trim(value)
        if type(value) ~= "string" then
            return ""
        end
        return value:match("^%s*(.-)%s*$") or ""
    end

    local function sanitizeSegment(value, fallback)
        value = tostring(value or fallback or "default")
        value = value:gsub("[^%w%-%._]", "_")
        value = value:gsub("_+", "_")
        value = value:sub(1, 80)
        if value == "" or value == "." or value == ".." then
            return fallback or "default"
        end
        return value
    end

    local function sanitizeRelativePath(value, fallback)
        local parts = {}
        value = tostring(value or ""):gsub("\\", "/")
        for part in string.gmatch(value, "[^/]+") do
            table.insert(parts, sanitizeSegment(part, "folder"))
        end
        if #parts == 0 then
            return sanitizeSegment(fallback, "FluentSettings")
        end
        return table.concat(parts, "/")
    end

    local function joinPath(...)
        local parts = {...}
        return table.concat(parts, "/")
    end

    local function stableHash(value)
        value = tostring(value or "")
        local hash = 7
        for index = 1, #value do
            -- Kept below 2^53 so the result is stable on Luau doubles too.
            hash = (hash * 131 + string.byte(value, index)) % 2147483647
        end
        return string.format("%08x", hash)
    end

    local function normalizeLocale(locale)
        locale = tostring(locale or "en"):lower():gsub("_", "-")
        locale = locale:gsub("%s+", "")
        if locale == "" then
            return "en"
        end
        return locale
    end

    local function localeBase(locale)
        return normalizeLocale(locale):match("^[^-]+") or "en"
    end

    local function robloxLocale(locale)
        local normalized = normalizeLocale(locale)
        local aliases = {
            en = "en-us",
            th = "th-th",
            vi = "vi-vn",
            es = "es-es"
        }
        return aliases[normalized] or normalized
    end

    -- Called for every instance the library creates, so it avoids pcall and
    -- IsA. These three classes have no subclasses.
    local TEXT_CLASSES = {TextLabel = true, TextButton = true, TextBox = true}
    local function isTextObject(object)
        return typeof(object) == "Instance" and TEXT_CLASSES[object.ClassName] == true
    end

    local nestedHttpRequest = type(http) == "table" and type(http.request) == "function" and http.request or nil
    local synRequest = type(syn) == "table" and type(syn.request) == "function" and syn.request or nil
    local synCustomAsset = type(syn) == "table" and type(syn.getcustomasset) == "function" and syn.getcustomasset or nil
    local gameHttpGetOk, gameHttpGetAvailable = pcall(function()
        return type(game.HttpGet) == "function"
    end)

    local Capabilities = {
        Request = getExecutorGlobal("request") or getExecutorGlobal("http_request") or nestedHttpRequest or synRequest,
        HttpGet = getExecutorGlobal("httpget"),
        WriteFile = getExecutorGlobal("writefile"),
        ReadFile = getExecutorGlobal("readfile"),
        IsFile = getExecutorGlobal("isfile"),
        IsFolder = getExecutorGlobal("isfolder"),
        MakeFolder = getExecutorGlobal("makefolder"),
        ListFiles = getExecutorGlobal("listfiles"),
        DeleteFile = getExecutorGlobal("delfile"),
        GetCustomAsset = getExecutorGlobal("getcustomasset") or getExecutorGlobal("getsynasset") or synCustomAsset,
        GameHttpGet = gameHttpGetOk and gameHttpGetAvailable,
        SetClipboard = getExecutorGlobal("setclipboard")
    }

    Capabilities.FileSystem = Capabilities.WriteFile ~= nil
        and Capabilities.ReadFile ~= nil
        and Capabilities.IsFile ~= nil
        and Capabilities.IsFolder ~= nil
        and Capabilities.MakeFolder ~= nil
    Capabilities.CustomFonts = Capabilities.FileSystem and Capabilities.GetCustomAsset ~= nil
    Capabilities.RemoteFetch = Capabilities.Request ~= nil or Capabilities.HttpGet ~= nil or Capabilities.GameHttpGet == true
    Capabilities.MachineTranslation = Capabilities.Request ~= nil
    Capabilities.RobloxTranslation = localizationOk and LocalizationService ~= nil

    function Capabilities:Supports(feature)
        return self[feature] == true or type(self[feature]) == "function"
    end

    local Storage = {
        Root = "FluentSettings"
    }

    function Storage:SetRoot(folder)
        self.Root = sanitizeRelativePath(folder, "FluentSettings")
    end

    function Storage:CanUseFiles()
        return Capabilities.FileSystem
    end

    function Storage:Ensure(folder)
        if not self:CanUseFiles() then
            return false, "This executor does not expose a file system."
        end

        local current = ""
        for segment in string.gmatch(folder, "[^/]+") do
            current = current == "" and segment or joinPath(current, segment)
            local exists, isFolder = pcall(Capabilities.IsFolder, current)
            if not exists or not isFolder then
                local created, err = pcall(Capabilities.MakeFolder, current)
                if not created then
                    return false, tostring(err)
                end
            end
        end

        return true
    end

    function Storage:Read(path)
        if not self:CanUseFiles() then
            return nil, "This executor does not expose a file system."
        end
        local exists, isFile = pcall(Capabilities.IsFile, path)
        if not exists or not isFile then
            return nil, "File not found."
        end
        local ok, contents = pcall(Capabilities.ReadFile, path)
        if not ok then
            return nil, tostring(contents)
        end
        return contents
    end

    function Storage:Write(path, contents)
        if not self:CanUseFiles() then
            return false, "This executor does not expose a file system."
        end
        local folder = path:match("^(.*)/[^/]+$")
        if folder and folder ~= "" then
            local ensured, ensureError = self:Ensure(folder)
            if not ensured then
                return false, ensureError
            end
        end
        local ok, err = pcall(Capabilities.WriteFile, path, contents)
        if not ok then
            return false, tostring(err)
        end
        return true
    end

    function Storage:Delete(path)
        if type(Capabilities.DeleteFile) ~= "function" then
            return false, "This executor does not expose delfile."
        end
        local ok, err = pcall(Capabilities.DeleteFile, path)
        return ok, ok and nil or tostring(err)
    end

    function Storage:List(folder)
        if type(Capabilities.ListFiles) ~= "function" then
            return {}
        end
        local ok, files = pcall(Capabilities.ListFiles, folder)
        if not ok or type(files) ~= "table" then
            return {}
        end
        return files
    end

    local function jsonEncode(data)
        local ok, encoded = pcall(HttpService.JSONEncode, HttpService, data)
        if ok then
            return encoded
        end
        return nil, tostring(encoded)
    end

    local function jsonDecode(data)
        local ok, decoded = pcall(HttpService.JSONDecode, HttpService, data)
        if ok and type(decoded) == "table" then
            return decoded
        end
        return nil, ok and "JSON must decode to an object." or tostring(decoded)
    end

    local function normalizeRemoteUrl(url)
        url = trim(url)
        if url == "" then
            return nil, "Enter a URL first."
        end

        local owner, repository, branchAndPath = url:match("^https://github%.com/([^/]+)/([^/]+)/blob/(.+)$")
        if owner and repository and branchAndPath then
            url = "https://raw.githubusercontent.com/" .. owner .. "/" .. repository .. "/" .. branchAndPath
        end

        if not url:match("^https://") then
            return nil, "Only HTTPS URLs are accepted."
        end

        -- A basic guard against addresses inside the user's network. It cannot
        -- catch a public name that resolves to a private address.
        local authority = url:match("^https://([^/%?#]*)") or ""
        if authority:find("@", 1, true) or authority:find("[", 1, true) then
            return nil, "URLs with credentials or IPv6 addresses are not allowed."
        end
        local host = (authority:match("^([^:]*)") or ""):lower():gsub("%.$", "")
        if host == "" or host == "localhost" or host:match("%.localhost$") or host:match("%.local$")
            or host:match("^%d+$") or host:match("^0x") or host:match("^0")
            or host:match("^127%.") or host:match("^10%.") or host:match("^169%.254%.")
            or host:match("^192%.168%.") or host:match("^172%.1[6-9]%.")
            or host:match("^172%.2[0-9]%.") or host:match("^172%.3[0-1]%.") then
            return nil, "Local-network URLs are not allowed."
        end

        return url
    end

    local function isLikelyJson(text)
        text = trim(text)
        return text:sub(1, 1) == "{" or text:sub(1, 1) == "["
    end

    local RemoteAssets = {
        Enabled = true
    }

    function RemoteAssets:SetEnabled(enabled)
        self.Enabled = enabled ~= false
    end

    function RemoteAssets:Fetch(url)
        if not self.Enabled then
            return nil, "Remote assets are disabled for this script by its InterfaceManager configuration."
        end
        local safeUrl, validationError = normalizeRemoteUrl(url)
        if not safeUrl then
            return nil, validationError
        end

        if type(Capabilities.Request) == "function" then
            local ok, response = pcall(Capabilities.Request, {
                Url = safeUrl,
                Method = "GET",
                Headers = {
                    ["Accept"] = "application/json, text/plain, */*",
                    ["User-Agent"] = "ATG-Fluent-Customization"
                }
            })
            if ok then
                if type(response) == "string" then
                    return response, nil, safeUrl
                end
                if type(response) == "table" then
                    local status = tonumber(response.StatusCode or response.Status or response.status_code or 200) or 0
                    local body = response.Body or response.body
                    local succeeded = response.Success
                    if (succeeded == nil and status >= 200 and status < 300) or succeeded == true then
                        if type(body) == "string" then
                            return body, nil, safeUrl
                        end
                    end
                    return nil, response.StatusMessage or response.StatusDescription or ("HTTP " .. tostring(status))
                end
            end
        end

        if type(Capabilities.HttpGet) == "function" then
            local ok, body = pcall(Capabilities.HttpGet, safeUrl)
            if ok and type(body) == "string" then
                return body, nil, safeUrl
            end
        end

        if Capabilities.GameHttpGet then
            local ok, body = pcall(function()
                return game:HttpGet(safeUrl)
            end)
            if ok and type(body) == "string" then
                return body, nil, safeUrl
            end
        end

        return nil, "No supported HTTP function is available in this executor."
    end

    local FontManager = {
        Registry = setmetatable({}, {__mode = "k"}),
        Profiles = {},
        ProfileOrder = {},
        CurrentProfile = "default",
        LoadedRegistryPath = nil,
        FaceCache = {},
        -- These are presentation overrides, not part of a downloaded font
        -- profile.  InterfaceManager persists them per script scope.
        TextStyleConfig = {
            Enabled = false,
            SizeScale = 100,
            Weight = "Auto",
            Style = "Auto",
            LineHeight = 100,
            Stroke = 0
        },
        LastError = nil
    }

    FontManager.Profiles.default = {
        Id = "default",
        Name = "Inter (Default)",
        UseOriginal = true,
        BuiltIn = true
    }
    FontManager.Profiles["builder-sans"] = {
        Id = "builder-sans",
        Name = "Builder Sans",
        BuiltIn = true,
        Roles = {
            Latin = {AssetId = "rbxasset://fonts/families/BuilderSans.json"},
            Thai = {AssetId = "rbxasset://fonts/families/BuilderSans.json"}
        }
    }
    FontManager.Profiles.gotham = {
        Id = "gotham",
        Name = "Gotham Classic",
        BuiltIn = true,
        Roles = {
            Latin = {AssetId = "rbxasset://fonts/families/GothamSSm.json"},
            Thai = {AssetId = "rbxasset://fonts/families/GothamSSm.json"}
        }
    }
    FontManager.ProfileOrder = {"default", "builder-sans", "gotham"}

    local I18n = {
        Registry = setmetatable({}, {__mode = "k"}),
        Packs = {},
        PackOrder = {},
        MachineCache = {},
        MachineCacheOrder = {},
        MachinePending = {},
        MachineQueue = {},
        MachineActive = 0,
        MachineMaxConcurrent = 2,
        -- Machine requests allowed per target language per session.
        MachineRequestLimit = 200,
        MachineRequests = 0,
        MachineRequestsByLocale = {},
        -- At most this many machine requests start in any one second.
        MachineRateLimit = 4,
        MachineRateTokens = 4,
        -- Translations received are also kept on disk per script scope and
        -- language pair (least recently used entries are dropped).
        MachineDiskCacheLimit = 2000,
        MachineDiskCaches = {},
        RobloxCache = {},
        RobloxCacheOrder = {},
        RobloxPending = {},
        RobloxTranslators = {},
        RobloxTranslatorPending = {},
        CurrentLocale = "en",
        SourceLocale = "en",
        -- Language packs only. Roblox and machine translation are opt-in.
        Mode = "community",
        Enabled = true,
        Scope = "shared",
        Revision = 0,
        LoadedScopePath = nil,
        CacheLimit = 750,
        AvailableLanguages = {
            {code = "en", name = "English", flag = ""},
            {code = "th", name = "Thai", flag = ""},
            {code = "vi", name = "Vietnamese", flag = ""},
            {code = "es", name = "Spanish", flag = ""}
        }
    }

    local function getEntryKey(text, explicitKey)
        if type(explicitKey) == "string" and explicitKey ~= "" then
            return explicitKey
        end
        return "legacy." .. stableHash(text)
    end

    local function cacheTranslation(owner, cacheName, orderName, key, value)
        local cache = owner[cacheName]
        local order = owner[orderName]
        if cache[key] == nil then
            table.insert(order, key)
        end
        cache[key] = value
        local limit = tonumber(owner.CacheLimit) or 750
        while #order > limit do
            local oldest = table.remove(order, 1)
            cache[oldest] = nil
        end
    end

    -- A translation shown in a RichText label is escaped unless the source
    -- text already uses markup, so a pack or server cannot inject tags.
    local function forDisplay(textObject, entry, translated)
        local source = entry.OriginalText
        if type(translated) ~= "string" or source:find("<", 1, true) or source:find("&[%w#]+;") then
            return translated
        end
        local richText = false
        if textObject then
            pcall(function()
                richText = textObject.RichText == true
            end)
        end
        if not richText then
            return translated
        end
        return (translated:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
    end

    local function setEntryText(textObject, entry, text, expectedRevision)
        if expectedRevision and expectedRevision ~= I18n.Revision then
            return
        end
        if not textObject or not entry then
            return
        end
        local changed = false
        if textObject[entry.Property] ~= text then
            local ok = pcall(function()
                textObject[entry.Property] = text
            end)
            if ok then
                changed = true
            end
        end
        if changed and FontManager:NeedsApply() then
            local fontEntry = FontManager.Registry[textObject]
            if fontEntry then
                FontManager:ApplyObject(textObject, fontEntry)
            end
        end
    end

    local function addKnownLocale(locale)
        local normalized = normalizeLocale(locale)
        for _, item in ipairs(I18n.AvailableLanguages) do
            if normalizeLocale(item.code) == normalized then
                return
            end
        end
        table.insert(I18n.AvailableLanguages, {
            code = normalized,
            name = normalized,
            flag = ""
        })
    end

    local function normalizePack(data, fallbackId)
        if type(data) ~= "table" then
            return nil, "Language pack must be a JSON object."
        end

        local meta = type(data.meta) == "table" and data.meta or {}
        local rawTranslations = data.translations or data.entries or data.messages
        if type(rawTranslations) ~= "table" then
            -- A compact source-key -> translation map is intentionally supported.
            rawTranslations = data
        end

        local translations = {}
        for key, value in pairs(rawTranslations) do
            if type(key) == "string" then
                local translated
                if type(value) == "string" then
                    translated = value
                elseif type(value) == "table" then
                    translated = value.translation or value.text or value.value
                end
                if type(translated) == "string" and translated ~= "" then
                    translations[key] = translated
                end
            end
        end

        local locale = normalizeLocale(meta.locale or data.locale or data.language or "")
        if locale == "en" and not (meta.locale or data.locale or data.language) then
            return nil, "Language pack is missing meta.locale (for example th or th-TH)."
        end

        local packId = sanitizeSegment(meta.id or data.id or fallbackId or ("pack_" .. stableHash(locale .. tostring(data.name or ""))), "pack")
        return {
            Id = packId,
            Name = tostring(meta.name or data.name or packId),
            Locale = locale,
            SourceLocale = normalizeLocale(meta.sourceLocale or data.sourceLocale or I18n.SourceLocale),
            Version = tostring(meta.version or data.version or "1"),
            Author = tostring(meta.author or data.author or ""),
            Url = tostring(meta.url or data.url or ""),
            Translations = translations,
            Raw = data
        }
    end

    function I18n:GetScopeFolder()
        return joinPath(Storage.Root, "i18n", sanitizeSegment(self.Scope, "shared"))
    end

    function I18n:GetRegistryPath()
        return joinPath(self:GetScopeFolder(), "registry.json")
    end

    function I18n:SaveRegistry()
        if not Storage:CanUseFiles() then
            return false, "This executor does not expose a file system."
        end
        local packs = {}
        for _, id in ipairs(self.PackOrder) do
            local pack = self.Packs[id]
            if pack then
                table.insert(packs, {
                    id = pack.Id,
                    name = pack.Name,
                    locale = pack.Locale,
                    sourceLocale = pack.SourceLocale,
                    version = pack.Version,
                    author = pack.Author,
                    url = pack.Url,
                    path = pack.Path
                })
            end
        end
        local encoded, encodeError = jsonEncode({
            schema = "atg.i18n.registry.v1",
            packs = packs
        })
        if not encoded then
            return false, encodeError
        end
        return Storage:Write(self:GetRegistryPath(), encoded)
    end

    function I18n:LoadPacks()
        local registryPath = self:GetRegistryPath()
        if self.LoadedScopePath == registryPath then
            return
        end

        self.Packs = {}
        self.PackOrder = {}
        self.LoadedScopePath = registryPath
        if not Storage:CanUseFiles() then
            return
        end

        local contents = Storage:Read(registryPath)
        if not contents then
            return
        end
        local registry = jsonDecode(contents)
        if not registry or type(registry.packs) ~= "table" then
            return
        end

        for _, saved in ipairs(registry.packs) do
            if type(saved) == "table" and type(saved.path) == "string" then
                local raw = Storage:Read(saved.path)
                if raw then
                    local decoded = jsonDecode(raw)
                    local pack = decoded and normalizePack(decoded, saved.id)
                    if pack then
                        pack.Path = saved.path
                        pack.Url = saved.url or pack.Url
                        self.Packs[pack.Id] = pack
                        table.insert(self.PackOrder, pack.Id)
                        addKnownLocale(pack.Locale)
                    end
                end
            end
        end
    end

    function I18n:InstallPack(data, options)
        options = options or {}
        local pack, packError = normalizePack(data, options.Id)
        if not pack then
            return nil, packError
        end

        pack.Url = options.Url or pack.Url
        local fileName = sanitizeSegment(pack.Locale, "locale") .. "." .. sanitizeSegment(pack.Id, "pack") .. ".json"
        pack.Path = joinPath(self:GetScopeFolder(), fileName)
        local shouldPersist = options.Persist ~= false

        if shouldPersist and Storage:CanUseFiles() then
            local encoded, encodeError = jsonEncode(data)
            if not encoded then
                return nil, encodeError
            end
            local written, writeError = Storage:Write(pack.Path, encoded)
            if not written then
                return nil, writeError
            end
        elseif not shouldPersist or not Storage:CanUseFiles() then
            pack.Path = nil
        end

        local alreadyKnown = self.Packs[pack.Id] ~= nil
        self.Packs[pack.Id] = pack
        if not alreadyKnown then
            table.insert(self.PackOrder, pack.Id)
        end
        addKnownLocale(pack.Locale)
        if shouldPersist then
            self:SaveRegistry()
        end
        self:AdvanceRevision()
        self:UpdateAllText()
        return pack
    end

    function I18n:RemovePack(packId)
        packId = sanitizeSegment(packId, "")
        local pack = self.Packs[packId]
        if not pack then
            return false, "Language pack was not found."
        end
        self.Packs[packId] = nil
        for index = #self.PackOrder, 1, -1 do
            if self.PackOrder[index] == packId then
                table.remove(self.PackOrder, index)
            end
        end
        if pack.Path then
            Storage:Delete(pack.Path)
        end
        self:SaveRegistry()
        self:AdvanceRevision()
        self:UpdateAllText()
        return true
    end

    function I18n:GetInstalledPacks()
        local result = {}
        for _, id in ipairs(self.PackOrder) do
            local pack = self.Packs[id]
            if pack then
                table.insert(result, {
                    Id = pack.Id,
                    Name = pack.Name,
                    Locale = pack.Locale,
                    Version = pack.Version,
                    Author = pack.Author,
                    Url = pack.Url
                })
            end
        end
        return result
    end

    function I18n:GetManualTranslation(entry, locale)
        local requested = normalizeLocale(locale)
        local requestedBase = localeBase(requested)
        -- Packs for the exact locale (th-th) win over packs that only share
        -- the base language (th); within each pass the newest pack wins.
        for pass = 1, 2 do
            for index = #self.PackOrder, 1, -1 do
                local pack = self.Packs[self.PackOrder[index]]
                local matches = pack and (
                    (pass == 1 and normalizeLocale(pack.Locale) == requested)
                    or (pass == 2 and localeBase(pack.Locale) == requestedBase)
                )
                if matches then
                    local translated = pack.Translations[entry.Key] or pack.Translations[entry.OriginalText]
                    if type(translated) == "string" and translated ~= "" then
                        return translated, pack
                    end
                end
            end
        end
        return nil
    end

    function I18n:GetLanguageOptions()
        local options = {}
        for _, language in ipairs(self.AvailableLanguages) do
            local prefix = language.flag ~= "" and (language.flag .. " ") or ""
            table.insert(options, prefix .. language.name .. " (" .. language.code .. ")")
        end
        return options
    end

    function I18n:GetLanguageCode(value)
        if type(value) == "number" then
            local language = self.AvailableLanguages[value]
            return language and language.code or self.SourceLocale
        end
        if type(value) == "string" then
            local normalized = normalizeLocale(value)
            for _, language in ipairs(self.AvailableLanguages) do
                local display = ((language.flag ~= "" and language.flag .. " " or "") .. language.name .. " (" .. language.code .. ")")
                if value == display or normalized == normalizeLocale(language.code) then
                    return language.code
                end
            end
            local code = value:match("%(([^%(%)]+)%)$")
            if code then
                normalized = normalizeLocale(code)
            end
            -- Permit a valid BCP-47-like locale before a pack has been
            -- installed (for example th-TH, ja-JP, id-ID). Lua patterns have
            -- no repeated groups, so the subtags are checked separately.
            local base, subtags = normalized:match("^([a-z][a-z][a-z]?)(.*)$")
            if base and (subtags == "" or (subtags:gsub("%-[a-z0-9]+", "")) == "") then
                return normalized
            end
        end
        return self.SourceLocale
    end

    function I18n:GetLanguageIndex()
        for index, language in ipairs(self.AvailableLanguages) do
            if normalizeLocale(language.code) == normalizeLocale(self.CurrentLocale) then
                return index
            end
        end
        return 1
    end

    function I18n:AdvanceRevision()
        self.Revision = self.Revision + 1
        -- In-flight callbacks are intentionally retained: a request is keyed
        -- by source+target text, so when the user switches away and back its
        -- result is still valid. Clearing them here creates a race where an
        -- old completion can consume callbacks from a newly queued same-key
        -- request. Prune only jobs which have not started and target a locale
        -- that is no longer current. The machine quota is not reset here.
        local retainedQueue = {}
        for _, job in ipairs(self.MachineQueue) do
            if job.SourceLocale == self.SourceLocale and job.TargetLocale == self.CurrentLocale then
                table.insert(retainedQueue, job)
            else
                self.MachinePending[job.Key] = nil
            end
        end
        self.MachineQueue = retainedQueue
    end

    function I18n:CancelPending()
        -- Used only while unloading the whole UI. No future request can reuse
        -- these callback lists, so releasing them immediately is safe.
        self:AdvanceRevision()
        self.MachineQueue = {}
        self.MachinePending = {}
        self.RobloxPending = {}
        self.RobloxTranslatorPending = {}
    end

    function I18n:SetEnabled(enabled)
        local nextEnabled = enabled ~= false
        if self.Enabled == nextEnabled and TranslationSystem.Enabled == nextEnabled then
            return
        end
        self.Enabled = nextEnabled
        TranslationSystem.Enabled = self.Enabled
        self:AdvanceRevision()
        self:UpdateAllText()
    end

    function I18n:SetMode(mode)
        local accepted = {
            auto = true,
            community = true,
            roblox = true,
            machine = true,
            source = true
        }
        if not accepted[mode] then
            mode = "community"
        end
        if self.Mode == mode then
            return
        end
        self.Mode = mode
        self:AdvanceRevision()
        self:UpdateAllText()
    end

    function I18n:SetLanguage(locale)
        locale = self:GetLanguageCode(locale)
        locale = normalizeLocale(locale)
        addKnownLocale(locale)
        if locale == self.CurrentLocale then
            return
        end
        self.CurrentLocale = locale
        self:AdvanceRevision()
        TranslationSystem.CurrentLanguage = locale
        if type(getgenv) == "function" then
            local ok, environment = pcall(getgenv)
            if ok and type(environment) == "table" then
                if type(environment.Fluent) == "table" then
                    environment.Fluent.CurrentLanguage = locale
                end
                if type(environment.Acryven) == "table" then
                    environment.Acryven.CurrentLanguage = locale
                end
            end
        end
        self:UpdateAllText()
        -- The font depends on the language only when a custom profile or
        -- text tuning is active; otherwise every label keeps its own font.
        if FontManager:NeedsApply() then
            FontManager:ApplyAll()
        end
    end

    function I18n:SetScope(scope, sourceLocale)
        local nextScope = sanitizeSegment(scope, "shared")
        local nextSourceLocale = sourceLocale and normalizeLocale(sourceLocale) or self.SourceLocale
        local scopeChanged = nextScope ~= self.Scope
        local sourceChanged = nextSourceLocale ~= self.SourceLocale
        if not scopeChanged and not sourceChanged then
            self:LoadPacks()
            return
        end
        self.Scope = nextScope
        if sourceLocale then
            self.SourceLocale = nextSourceLocale
            TranslationSystem.SourceLanguage = self.SourceLocale
        end
        self.LoadedScopePath = nil
        self:LoadPacks()
        self:AdvanceRevision()
        self:UpdateAllText()
    end

    function I18n:Register(textObject, originalText, propertyName, options)
        if not textObject or type(originalText) ~= "string" then
            return nil
        end
        options = type(options) == "table" and options or {}
        propertyName = propertyName or "Text"
        local entry = {
            OriginalText = originalText,
            Property = propertyName,
            Key = getEntryKey(originalText, options.Key),
            Context = options.Context or "",
            Skip = options.Skip == true,
            -- Runtime text (status lines, notifications, SetTitle/SetDesc
            -- after creation) may contain player data: packs and Roblox
            -- only, never machine translation.
            Dynamic = options.Dynamic == true
        }
        self.Registry[textObject] = entry
        FontManager:Track(textObject, options.FontRole)
        self:ApplyEntry(textObject, entry)
        return textObject
    end

    function I18n:AutoRegister(textObject, properties)
        if not isTextObject(textObject) then
            return
        end
        properties = properties or {}
        local text = properties.Text
        if properties.I18nSkip or type(text) ~= "string" or text == "" then
            -- Empty clickable TextButton containers never render text; skip font tracking for them.
            if textObject.ClassName ~= "TextButton" or properties.FontRole ~= nil or (type(text) == "string" and text ~= "") then
                FontManager:Track(textObject, properties.FontRole)
            end
            return
        end
        self:Register(textObject, text, "Text", {
            Key = properties.I18nKey,
            Context = properties.I18nContext,
            FontRole = properties.FontRole,
            Dynamic = properties.I18nDynamic == true
        })
    end

    function I18n:WithRobloxTranslator(locale, callback)
        if not localizationOk or not LocalizationService then
            callback(nil)
            return
        end

        locale = robloxLocale(locale)
        if self.RobloxTranslators[locale] ~= nil then
            callback(self.RobloxTranslators[locale] or nil)
            return
        end

        local waiting = self.RobloxTranslatorPending[locale]
        if waiting then
            table.insert(waiting, callback)
            return
        end

        self.RobloxTranslatorPending[locale] = {callback}
        task.spawn(function()
            local translator
            local gotTranslator = pcall(function()
                translator = LocalizationService:GetTranslatorForLocaleAsync(locale)
            end)
            self.RobloxTranslators[locale] = gotTranslator and translator or false
            local callbacks = self.RobloxTranslatorPending[locale] or {}
            self.RobloxTranslatorPending[locale] = nil
            for _, waitingCallback in ipairs(callbacks) do
                waitingCallback(gotTranslator and translator or nil)
            end
        end)
    end

    function I18n:TryRoblox(textObject, entry, revision, callback)
        if not localizationOk or not LocalizationService then
            callback(nil)
            return
        end

        local locale = self.CurrentLocale
        local cacheKey = normalizeLocale(locale) .. "|" .. entry.OriginalText
        if self.RobloxCache[cacheKey] then
            callback(self.RobloxCache[cacheKey])
            return
        end

        local waiting = self.RobloxPending[cacheKey]
        if waiting then
            table.insert(waiting, callback)
            return
        end
        self.RobloxPending[cacheKey] = {callback}

        self:WithRobloxTranslator(locale, function(translator)
            task.spawn(function()
                local translated
                if translator then
                    local ok, result = pcall(function()
                        return translator:Translate(textObject, entry.OriginalText)
                    end)
                    if ok and type(result) == "string" and result ~= "" and result ~= entry.OriginalText then
                        translated = result
                        cacheTranslation(self, "RobloxCache", "RobloxCacheOrder", cacheKey, result)
                    end
                end
                local callbacks = self.RobloxPending[cacheKey] or {}
                self.RobloxPending[cacheKey] = nil
                for _, waitingCallback in ipairs(callbacks) do
                    waitingCallback(translated)
                end
            end)
        end)
    end

    function I18n:GetMachineCachePath(sourceLocale, targetLocale)
        local fileName = "machine." .. sanitizeSegment(sourceLocale, "source") .. "-" .. sanitizeSegment(targetLocale, "target") .. ".json"
        return joinPath(self:GetScopeFolder(), fileName)
    end

    -- Loaded once per file. Saved as an array of {source, translation}
    -- pairs, oldest first, so the JSON never mixes array and object keys.
    function I18n:GetMachineDiskCache(sourceLocale, targetLocale)
        local path = self:GetMachineCachePath(sourceLocale, targetLocale)
        local cache = self.MachineDiskCaches[path]
        if cache then
            return cache
        end
        -- Stamps[source] records when an entry was last used; the oldest one
        -- is dropped when the cache is full.
        cache = {Path = path, Entries = {}, Stamps = {}, Count = 0, Clock = 0, SaveQueued = false}
        self.MachineDiskCaches[path] = cache
        if Storage:CanUseFiles() then
            local contents = Storage:Read(path)
            local decoded = contents and jsonDecode(contents)
            if type(decoded) == "table" and type(decoded.entries) == "table" then
                for _, pair in ipairs(decoded.entries) do
                    if type(pair) == "table" and type(pair[1]) == "string" and type(pair[2]) == "string"
                        and cache.Entries[pair[1]] == nil then
                        cache.Entries[pair[1]] = pair[2]
                        cache.Count = cache.Count + 1
                        cache.Clock = cache.Clock + 1
                        cache.Stamps[pair[1]] = cache.Clock
                    end
                end
            end
        end
        return cache
    end

    local function touchDiskEntry(cache, source)
        cache.Clock = cache.Clock + 1
        cache.Stamps[source] = cache.Clock
    end

    function I18n:SaveMachineDiskCache(cache)
        if cache.SaveQueued or not Storage:CanUseFiles() then
            return
        end
        cache.SaveQueued = true
        -- Coalesce the writes of one burst of translations.
        task.delay(2, function()
            cache.SaveQueued = false
            local sources = {}
            for source in pairs(cache.Entries) do
                table.insert(sources, source)
            end
            table.sort(sources, function(left, right)
                return cache.Stamps[left] < cache.Stamps[right]
            end)
            local entries = {}
            for _, source in ipairs(sources) do
                table.insert(entries, {source, cache.Entries[source]})
            end
            local encoded = jsonEncode({schema = "atg.i18n.machine-cache.v1", entries = entries})
            if encoded then
                Storage:Write(cache.Path, encoded)
            end
        end)
    end

    function I18n:RememberMachineTranslation(sourceLocale, targetLocale, source, translated)
        local cache = self:GetMachineDiskCache(sourceLocale, targetLocale)
        if cache.Entries[source] == nil then
            cache.Count = cache.Count + 1
        end
        cache.Entries[source] = translated
        touchDiskEntry(cache, source)
        local limit = tonumber(self.MachineDiskCacheLimit) or 2000
        while cache.Count > limit do
            local oldest, oldestStamp = nil, math.huge
            for candidate, stamp in pairs(cache.Stamps) do
                if stamp < oldestStamp then
                    oldest, oldestStamp = candidate, stamp
                end
            end
            cache.Entries[oldest] = nil
            cache.Stamps[oldest] = nil
            cache.Count = cache.Count - 1
        end
        self:SaveMachineDiskCache(cache)
    end

    function I18n:DrainMachineQueue()
        while self.MachineActive < self.MachineMaxConcurrent and #self.MachineQueue > 0 and self.MachineRateTokens > 0 do
            local job = table.remove(self.MachineQueue, 1)
            self.MachineActive = self.MachineActive + 1
            -- Each start uses a token that comes back one second later.
            self.MachineRateTokens = self.MachineRateTokens - 1
            task.delay(1, function()
                self.MachineRateTokens = math.min(self.MachineRateTokens + 1, tonumber(self.MachineRateLimit) or 4)
                self:DrainMachineQueue()
            end)
            task.spawn(function()
                local translated
                local body = jsonEncode({
                    q = job.Text,
                    source = job.SourceLocale,
                    target = job.TargetLocale
                })
                if body then
                    local ok, response = pcall(Capabilities.Request, {
                        Url = job.Endpoint:gsub("/$", "") .. "/translate",
                        Method = "POST",
                        Headers = {["Content-Type"] = "application/json"},
                        Body = body
                    })
                    local rawResponse
                    if ok and type(response) == "string" then
                        rawResponse = response
                    elseif ok and type(response) == "table" and response.Success ~= false then
                        rawResponse = response.Body or response.body
                    end
                    local decoded = type(rawResponse) == "string" and jsonDecode(rawResponse)
                    local result = decoded and decoded.translatedText
                    if type(result) == "string" and result ~= "" then
                        translated = result
                        cacheTranslation(self, "MachineCache", "MachineCacheOrder", job.Key, result)
                        self:RememberMachineTranslation(job.SourceLocale, job.TargetLocale, job.Text, result)
                    end
                end

                local callbacks = self.MachinePending[job.Key] or {}
                self.MachinePending[job.Key] = nil
                self.MachineActive = math.max(0, self.MachineActive - 1)
                for _, waitingCallback in ipairs(callbacks) do
                    waitingCallback(translated)
                end
                self:DrainMachineQueue()
            end)
        end
    end

    function I18n:TryMachine(entry, revision, callback, targetLocale)
        local endpoint = TranslationSystem.API_URL
        if type(Capabilities.Request) ~= "function" or type(endpoint) ~= "string" or endpoint == "" then
            callback(nil)
            return
        end

        targetLocale = normalizeLocale(targetLocale or self.CurrentLocale)
        local cacheKey = self.SourceLocale .. "|" .. targetLocale .. "|" .. entry.OriginalText
        if self.MachineCache[cacheKey] then
            callback(self.MachineCache[cacheKey])
            return
        end
        -- Translations from earlier sessions cost no request or quota.
        local disk = self:GetMachineDiskCache(self.SourceLocale, targetLocale)
        local stored = disk.Entries[entry.OriginalText]
        if stored then
            touchDiskEntry(disk, entry.OriginalText)
            cacheTranslation(self, "MachineCache", "MachineCacheOrder", cacheKey, stored)
            callback(stored)
            return
        end

        local waiting = self.MachinePending[cacheKey]
        if waiting then
            table.insert(waiting, callback)
            return
        end
        local used = self.MachineRequestsByLocale[targetLocale] or 0
        if used >= (tonumber(self.MachineRequestLimit) or 0) then
            callback(nil)
            return
        end

        self.MachineRequestsByLocale[targetLocale] = used + 1
        self.MachineRequests = self.MachineRequests + 1
        self.MachinePending[cacheKey] = {callback}
        table.insert(self.MachineQueue, {
            Key = cacheKey,
            Text = entry.OriginalText,
            SourceLocale = self.SourceLocale,
            TargetLocale = targetLocale,
            Endpoint = endpoint
        })
        self:DrainMachineQueue()
    end

    function I18n:ApplyEntry(textObject, entry)
        if not textObject or not entry or entry.Skip then
            return
        end

        local revision = self.Revision
        local source = entry.OriginalText
        if not self.Enabled or TranslationSystem.Enabled == false or self.Mode == "source"
            or localeBase(self.CurrentLocale) == localeBase(self.SourceLocale) then
            setEntryText(textObject, entry, source, revision)
            return
        end

        local manual = self:GetManualTranslation(entry, self.CurrentLocale)
        if manual then
            setEntryText(textObject, entry, forDisplay(textObject, entry, manual), revision)
            return
        end

        setEntryText(textObject, entry, source, revision)
        if self.Mode == "community" then
            return
        end

        local tryMachine = (self.Mode == "machine" or self.Mode == "auto") and not entry.Dynamic
        local tryRoblox = self.Mode == "roblox" or self.Mode == "auto"
        local function afterRoblox(translated)
            if revision ~= self.Revision then
                return
            end
            if translated then
                setEntryText(textObject, entry, forDisplay(textObject, entry, translated), revision)
            elseif tryMachine then
                self:TryMachine(entry, revision, function(machineTranslated)
                    if machineTranslated then
                        setEntryText(textObject, entry, forDisplay(textObject, entry, machineTranslated), revision)
                    end
                end)
            end
        end

        if tryRoblox then
            self:TryRoblox(textObject, entry, revision, afterRoblox)
        elseif tryMachine then
            self:TryMachine(entry, revision, function(machineTranslated)
                if machineTranslated then
                    setEntryText(textObject, entry, forDisplay(textObject, entry, machineTranslated), revision)
                end
            end)
        end
    end

    function I18n:UpdateText(textObject)
        local entry = self.Registry[textObject]
        if entry then
            self:ApplyEntry(textObject, entry)
        end
    end

    function I18n:UpdateAllText()
        for textObject, entry in pairs(self.Registry) do
            if textObject and textObject.Parent then
                self:ApplyEntry(textObject, entry)
            else
                self.Registry[textObject] = nil
            end
        end
    end

    function I18n:ClearRegistry()
        for textObject in pairs(self.Registry) do
            self.Registry[textObject] = nil
        end
    end

    function I18n:TranslateText(text, targetLocale, callback)
        local sourceText = tostring(text or "")
        targetLocale = normalizeLocale(targetLocale or self.CurrentLocale)
        if not self.Enabled or TranslationSystem.Enabled == false or sourceText == ""
            or localeBase(targetLocale) == localeBase(self.SourceLocale) then
            if callback then
                callback(sourceText)
            end
            return sourceText
        end

        -- Keep old executor translator behavior safe around emoji strings.
        -- (Thai UTF-8 begins below 240, while normal emoji uses 4-byte UTF-8.)
        for index = 1, #sourceText do
            if string.byte(sourceText, index) >= 240 then
                if callback then
                    callback(sourceText)
                end
                return sourceText
            end
        end

        local entry = {
            OriginalText = sourceText,
            Key = getEntryKey(sourceText),
            Property = "Text"
        }
        local manual = self.Mode ~= "source" and self:GetManualTranslation(entry, targetLocale)
        if manual then
            if callback then
                callback(manual)
            end
            return manual
        end

        -- Only the modes that allow it send text out, through the same queue
        -- and quota as interface text.
        if self.Mode ~= "machine" and self.Mode ~= "auto" then
            if callback then
                callback(sourceText)
            end
            return sourceText
        end
        local cached = self.MachineCache[self.SourceLocale .. "|" .. targetLocale .. "|" .. sourceText]
        if cached then
            if callback then
                callback(cached)
            end
            return cached
        end
        self:TryMachine(entry, self.Revision, function(translated)
            if callback then
                callback(translated or sourceText)
            end
        end, targetLocale)
        return sourceText
    end

    function I18n:BuildDefaultPack(targetLocale)
        local entries = {}
        local normalizedTargetLocale = normalizeLocale(targetLocale or self.CurrentLocale)
        for textObject, entry in pairs(self.Registry) do
            if textObject and entry and entry.OriginalText ~= "" then
                entries[entry.Key] = {
                    source = entry.OriginalText,
                    context = entry.Context,
                    translation = ""
                }
            end
        end
        return {
            schema = "atg.i18n.v1",
            meta = {
                id = sanitizeSegment(self.Scope, "script") .. "-" .. sanitizeSegment(normalizedTargetLocale, "locale") .. "-template",
                name = "Translation template",
                locale = normalizedTargetLocale,
                sourceLocale = self.SourceLocale,
                generatedBy = "Acryven"
            },
            entries = entries
        }
    end

    function I18n:ExportDefaultPack(targetLocale)
        local pack = self:BuildDefaultPack(targetLocale)
        return jsonEncode(pack), pack
    end

    function RemoteAssets:ImportLanguage(source, options)
        options = options or {}
        local raw = source
        local sourceUrl
        if not isLikelyJson(raw) then
            local localFileExists = false
            if Capabilities.FileSystem and type(source) == "string" then
                local checked, exists = pcall(Capabilities.IsFile, source)
                localFileExists = checked and exists
            end
            if localFileExists then
                local readError
                raw, readError = Storage:Read(source)
                if not raw then
                    return nil, readError
                end
            else
                local fetchError
                raw, fetchError, sourceUrl = self:Fetch(source)
                if not raw then
                    return nil, fetchError
                end
            end
        end
        if type(raw) ~= "string" then
            return nil, "Language data must be JSON text, a local JSON file, or an HTTPS URL."
        end
        if #raw > 1500000 then
            return nil, "Language pack is larger than 1.5 MB."
        end
        local decoded, decodeError = jsonDecode(raw)
        if not decoded then
            return nil, decodeError
        end
        return I18n:InstallPack(decoded, {
            Id = options.Id,
            Url = sourceUrl or options.Url,
            Persist = options.Persist
        })
    end

    function RemoteAssets:ExportDefaultLanguagePack(targetLocale)
        local encoded, pack = I18n:ExportDefaultPack(targetLocale)
        if not encoded then
            return nil, pack
        end

        -- Clipboard is the fastest hand-off for normal users: they can paste
        -- the template straight into an AI/editor even if file writing later
        -- fails.  It is deliberately attempted before the optional file save.
        local copied = false
        if type(Capabilities.SetClipboard) == "function" then
            copied = pcall(Capabilities.SetClipboard, encoded)
        end

        local path
        local saveError
        if Storage:CanUseFiles() then
            path = joinPath(
                I18n:GetScopeFolder(),
                "exports",
                sanitizeSegment(I18n.Scope, "script") .. "." .. sanitizeSegment(pack.meta.locale, "locale") .. ".template.json"
            )
            local written, writeError = Storage:Write(path, encoded)
            if not written then
                path = nil
                saveError = writeError
            end
        end
        if not path and not copied and saveError then
            return nil, saveError
        end
        return {
            Path = path,
            Json = encoded,
            Pack = pack,
            Copied = copied,
            SaveError = saveError
        }
    end

    function RemoteAssets:UpdateLanguage(packId)
        local pack = I18n.Packs[packId]
        if not pack or type(pack.Url) ~= "string" or pack.Url == "" then
            return nil, "This language pack has no saved remote URL."
        end
        return self:ImportLanguage(pack.Url, {Id = pack.Id})
    end

    -- Font Family JSON uses CSS-style values ("normal", "italic", 400),
    -- while Font.new needs Roblox EnumItems.  Never dynamically index an Enum
    -- here: Enum.FontStyle["normal"] throws instead of returning nil.
    local FONT_WEIGHTS = {
        [100] = Enum.FontWeight.Thin,
        [200] = Enum.FontWeight.ExtraLight,
        [300] = Enum.FontWeight.Light,
        [400] = Enum.FontWeight.Regular,
        [500] = Enum.FontWeight.Medium,
        [600] = Enum.FontWeight.SemiBold,
        [700] = Enum.FontWeight.Bold,
        [800] = Enum.FontWeight.ExtraBold,
        [900] = Enum.FontWeight.Heavy
    }

    local FONT_WEIGHT_NAMES = {
        thin = 100,
        hairline = 100,
        extralight = 200,
        ultralight = 200,
        light = 300,
        regular = 400,
        normal = 400,
        book = 400,
        medium = 500,
        semibold = 600,
        demibold = 600,
        bold = 700,
        extrabold = 800,
        ultrabold = 800,
        heavy = 900,
        black = 900
    }

    local function isEnumItemOfType(value, enumType)
        if typeof(value) ~= "EnumItem" then
            return false
        end
        local ok, valueType = pcall(function()
            return value.EnumType
        end)
        return ok and valueType == enumType
    end

    local function canonicalFontWeight(value)
        if isEnumItemOfType(value, Enum.FontWeight) then
            local ok, numeric = pcall(function()
                return value.Value
            end)
            if ok then
                value = numeric
            end
        end

        local numeric
        if type(value) == "number" then
            numeric = value
        elseif type(value) == "string" then
            local normalized = value:lower():gsub("[%s_%-]", "")
            numeric = tonumber(normalized) or FONT_WEIGHT_NAMES[normalized]
        end
        numeric = tonumber(numeric) or 400

        -- CSS variable-font ranges and uncommon values are represented by the
        -- closest Roblox FontWeight instead of failing the entire UI.
        local bestWeight = 400
        local bestDistance = math.huge
        for weight in pairs(FONT_WEIGHTS) do
            local distance = math.abs(weight - numeric)
            if distance < bestDistance then
                bestWeight = weight
                bestDistance = distance
            end
        end
        return bestWeight
    end

    local function canonicalFontStyle(value)
        if isEnumItemOfType(value, Enum.FontStyle) then
            local ok, name = pcall(function()
                return value.Name
            end)
            if ok and tostring(name):lower() == "italic" then
                return "italic"
            end
            return "normal"
        end
        if type(value) == "string" then
            local normalized = value:lower():gsub("^enum%.fontstyle%.", ""):gsub("[%s_%-]", "")
            -- Google CSS can use italic, oblique, or the `ital` axis name.
            if normalized:find("italic", 1, true) or normalized:find("oblique", 1, true) or normalized == "ital" then
                return "italic"
            end
        end
        return "normal"
    end

    local function enumWeight(value)
        if isEnumItemOfType(value, Enum.FontWeight) then
            return value
        end
        return FONT_WEIGHTS[canonicalFontWeight(value)] or Enum.FontWeight.Regular
    end

    local function enumStyle(value)
        if isEnumItemOfType(value, Enum.FontStyle) then
            return value
        end
        return canonicalFontStyle(value) == "italic" and Enum.FontStyle.Italic or Enum.FontStyle.Normal
    end

    -- These are deliberately conservative.  Font tuning changes every text
    -- control in the library, so bounded values keep an oversized setting from
    -- breaking the layout while still giving users a meaningful range.
    local TEXT_STYLE_WEIGHT_OPTIONS = {
        Thin = 100,
        ExtraLight = 200,
        Light = 300,
        Regular = 400,
        Medium = 500,
        SemiBold = 600,
        Bold = 700,
        ExtraBold = 800,
        Heavy = 900
    }

    local TEXT_STYLE_WEIGHT_NAMES = {
        thin = "Thin",
        extralight = "ExtraLight",
        light = "Light",
        regular = "Regular",
        normal = "Regular",
        medium = "Medium",
        semibold = "SemiBold",
        bold = "Bold",
        extrabold = "ExtraBold",
        heavy = "Heavy",
        black = "Heavy"
    }

    local function clampNumber(value, minimum, maximum, fallback)
        value = tonumber(value)
        if not value then
            return fallback
        end
        value = math.floor(value + 0.5)
        return math.max(minimum, math.min(maximum, value))
    end

    local function normalizeTextStyleWeight(value)
        if value == nil then
            return "Auto"
        end
        if type(value) == "string" then
            local normalized = value:lower():gsub("[%s_%-]", "")
            if normalized == "auto" then
                return "Auto"
            end
            if TEXT_STYLE_WEIGHT_NAMES[normalized] then
                return TEXT_STYLE_WEIGHT_NAMES[normalized]
            end
        elseif type(value) == "number" then
            local numeric = canonicalFontWeight(value)
            for name, weight in pairs(TEXT_STYLE_WEIGHT_OPTIONS) do
                if weight == numeric then
                    return name
                end
            end
        end
        return "Auto"
    end

    local function normalizeTextStyleStyle(value)
        if value == nil then
            return "Auto"
        end
        if type(value) == "string" and value:lower():gsub("%s+", "") == "auto" then
            return "Auto"
        end
        return canonicalFontStyle(value) == "italic" and "Italic" or "Normal"
    end

    local function copyTextStyleConfig(config)
        config = config or {}
        return {
            Enabled = config.Enabled == true,
            SizeScale = clampNumber(config.SizeScale, 70, 160, 100),
            Weight = normalizeTextStyleWeight(config.Weight),
            Style = normalizeTextStyleStyle(config.Style),
            LineHeight = clampNumber(config.LineHeight, 80, 160, 100),
            Stroke = clampNumber(config.Stroke, 0, 100, 0)
        }
    end

    local function textStyleWeight(value)
        local numeric = TEXT_STYLE_WEIGHT_OPTIONS[value]
        return numeric and enumWeight(numeric) or nil
    end

    local function textStyleStyle(value)
        if value == "Normal" then
            return Enum.FontStyle.Normal
        end
        if value == "Italic" then
            return Enum.FontStyle.Italic
        end
        return nil
    end

    function FontManager:GetTextStyleConfig()
        return copyTextStyleConfig(self.TextStyleConfig)
    end

    function FontManager:SetTextStyleConfig(config, deferApply)
        if type(config) ~= "table" then
            return false, "Font style settings must be a table."
        end

        local previous = self:GetTextStyleConfig()
        local merged = {
            Enabled = config.Enabled == nil and previous.Enabled or config.Enabled == true,
            SizeScale = config.SizeScale == nil and previous.SizeScale or config.SizeScale,
            Weight = config.Weight == nil and previous.Weight or config.Weight,
            Style = config.Style == nil and previous.Style or config.Style,
            LineHeight = config.LineHeight == nil and previous.LineHeight or config.LineHeight,
            Stroke = config.Stroke == nil and previous.Stroke or config.Stroke
        }
        local normalized = copyTextStyleConfig(merged)
        if previous.Enabled == normalized.Enabled
            and previous.SizeScale == normalized.SizeScale
            and previous.Weight == normalized.Weight
            and previous.Style == normalized.Style
            and previous.LineHeight == normalized.LineHeight
            and previous.Stroke == normalized.Stroke then
            return true
        end
        self.TextStyleConfig = normalized
        self.FaceCache = {}
        if not deferApply then
            self:ApplyAll()
        end
        return true
    end

    local function textContainsThai(text)
        if type(text) ~= "string" or text == "" then
            return false
        end
        local found = false
        local ok = pcall(function()
            for _, codepoint in utf8.codes(text) do
                if codepoint >= 0x0E00 and codepoint <= 0x0E7F then
                    found = true
                    break
                end
            end
        end)
        if ok then
            return found
        end
        -- Fallback for uncommon environments without utf8.codes.
        return text:find(string.char(224) .. "[\184-\185]") ~= nil
    end

    local function fontRoleForText(role, text)
        role = type(role) == "string" and role:lower() or "auto"
        if role == "mono" or role == "code" then
            return "Mono"
        end
        if role == "latin" or role == "english" then
            return "Latin"
        end
        if role == "thai" then
            return "Thai"
        end
        if textContainsThai(text) then
            return "Thai"
        end
        return localeBase(I18n.CurrentLocale) == "th" and "Thai" or "Latin"
    end

    function FontManager:GetFolder()
        return joinPath(Storage.Root, "fonts")
    end

    function FontManager:GetRegistryPath()
        return joinPath(self:GetFolder(), "registry.json")
    end

    function FontManager:SaveProfiles()
        if not Storage:CanUseFiles() then
            return false, "This executor does not expose a file system."
        end

        local function copyForStorage(value)
            if type(value) ~= "table" then
                return value
            end
            local copy = {}
            for key, nestedValue in pairs(value) do
                -- RuntimeFamily is a getcustomasset URI and becomes invalid
                -- after restart. Persist only the original local file paths.
                if key ~= "RuntimeFamily" then
                    copy[key] = copyForStorage(nestedValue)
                end
            end
            return copy
        end

        local profiles = {}
        for _, id in ipairs(self.ProfileOrder) do
            local profile = self.Profiles[id]
            if profile and not profile.BuiltIn then
                table.insert(profiles, copyForStorage(profile))
            end
        end
        local encoded, encodeError = jsonEncode({
            schema = "atg.font.registry.v1",
            profiles = profiles
        })
        if not encoded then
            return false, encodeError
        end
        return Storage:Write(self:GetRegistryPath(), encoded)
    end

    function FontManager:LoadProfiles()
        local registryPath = self:GetRegistryPath()
        if self.LoadedRegistryPath == registryPath then
            return
        end
        self.LoadedRegistryPath = registryPath

        local builtInProfiles = {}
        local builtInOrder = {}
        for _, id in ipairs(self.ProfileOrder) do
            local p = self.Profiles[id]
            if p and p.BuiltIn then
                builtInProfiles[id] = p
                table.insert(builtInOrder, id)
            end
        end
        self.Profiles = builtInProfiles
        self.ProfileOrder = builtInOrder
        self.FaceCache = {}
        if not Storage:CanUseFiles() then
            return
        end

        local contents = Storage:Read(registryPath)
        local decoded = contents and jsonDecode(contents)
        if not decoded or type(decoded.profiles) ~= "table" then
            return
        end
        for _, profile in ipairs(decoded.profiles) do
            if type(profile) == "table" and type(profile.Id) == "string" and type(profile.Roles) == "table" then
                local normId = sanitizeSegment(profile.Id, "font")
                if not (self.Profiles[normId] and self.Profiles[normId].BuiltIn) then
                    profile.Id = normId
                    -- getcustomasset returns a session-local URI. Never trust a
                    -- serialized one; rebuild the Font Family from saved files.
                    for _, role in pairs(profile.Roles) do
                        if type(role) == "table" then
                            role.RuntimeFamily = nil
                        end
                    end
                    self.Profiles[profile.Id] = profile
                    table.insert(self.ProfileOrder, profile.Id)
                end
            end
        end
    end

    function FontManager:GetProfileOptions()
        local options = {}
        for _, id in ipairs(self.ProfileOrder) do
            local profile = self.Profiles[id]
            if profile then
                table.insert(options, profile.Name .. " [" .. profile.Id .. "]")
            end
        end
        return options
    end

    function FontManager:GetProfileId(value)
        if type(value) == "number" then
            return self.ProfileOrder[value] or "default"
        end
        if type(value) == "string" then
            if self.Profiles[value] then
                return value
            end
            local id = value:match("%[([^%[%]]+)%]$")
            if id and self.Profiles[id] then
                return id
            end
        end
        return "default"
    end

    function FontManager:GetProfiles()
        local result = {}
        for _, id in ipairs(self.ProfileOrder) do
            local profile = self.Profiles[id]
            if profile then
                table.insert(result, {
                    Id = profile.Id,
                    Name = profile.Name,
                    BuiltIn = profile.BuiltIn == true
                })
            end
        end
        return result
    end

    function FontManager:ResolveLocalFamily(profile, roleName, role)
        if type(role) ~= "table" then
            return nil, "Font role is invalid."
        end
        if type(role.AssetId) == "string" and role.AssetId ~= "" then
            return role.AssetId
        end
        if type(role.RuntimeFamily) == "string" and role.RuntimeFamily ~= "" then
            return role.RuntimeFamily
        end
        if type(role.Faces) ~= "table" or #role.Faces == 0 then
            return nil, "No font face is installed for this role."
        end
        if type(Capabilities.GetCustomAsset) ~= "function" then
            return nil, "This executor does not support getcustomasset."
        end

        local faces = {}
        for _, face in ipairs(role.Faces) do
            if type(face) == "table" and type(face.Path) == "string" then
                local exists, isFile = pcall(Capabilities.IsFile, face.Path)
                if exists and isFile then
                    local ok, assetId = pcall(Capabilities.GetCustomAsset, face.Path)
                    if ok and type(assetId) == "string" and assetId ~= "" then
                        table.insert(faces, {
                            name = tostring(face.Name or "Regular"),
                            -- FontFamily JSON expects CSS values, not Roblox
                            -- enum names.  Normalize user/Google FontPack data
                            -- before writing it to the runtime family.
                            weight = canonicalFontWeight(face.Weight),
                            style = canonicalFontStyle(face.Style),
                            assetId = assetId
                        })
                    end
                end
            end
        end
        if #faces == 0 then
            return nil, "The downloaded font files are no longer available."
        end

        local familyPath = joinPath(self:GetFolder(), sanitizeSegment(profile.Id, "font"), "runtime-" .. roleName:lower() .. ".fontfamily.json")
        local familyJson, encodeError = jsonEncode({
            name = profile.Name .. " " .. roleName,
            faces = faces
        })
        if not familyJson then
            return nil, encodeError
        end
        local written, writeError = Storage:Write(familyPath, familyJson)
        if not written then
            return nil, writeError
        end
        local ok, familyAsset = pcall(Capabilities.GetCustomAsset, familyPath)
        if not ok or type(familyAsset) ~= "string" or familyAsset == "" then
            return nil, ok and "getcustomasset did not return a Font Family asset." or tostring(familyAsset)
        end
        role.RuntimeFamily = familyAsset
        return familyAsset
    end

    local function enumNumericWeight(weight)
        local value = 400
        pcall(function()
            value = weight.Value
        end)
        return tonumber(value) or 400
    end

    local function chooseInstalledFace(role, desiredWeight, desiredStyle)
        if type(role) ~= "table" or type(role.Faces) ~= "table" or #role.Faces == 0 then
            return desiredWeight, desiredStyle
        end
        local desiredNumber = enumNumericWeight(desiredWeight)
        local bestFace
        local bestScore
        for _, face in ipairs(role.Faces) do
            if type(face) == "table" then
                local faceWeight = canonicalFontWeight(face.Weight)
                local faceStyle = enumStyle(face.Style)
                local stylePenalty = faceStyle == desiredStyle and 0 or 10000
                local score = stylePenalty + math.abs(faceWeight - desiredNumber)
                if not bestScore or score < bestScore then
                    bestFace = face
                    bestScore = score
                end
            end
        end
        if bestFace then
            return enumWeight(bestFace.Weight), enumStyle(bestFace.Style)
        end
        return desiredWeight, desiredStyle
    end

    local function buildTunedOriginalFace(originalFace, config)
        if not originalFace or not config or not config.Enabled then
            return originalFace
        end
        local weightOverride = textStyleWeight(config.Weight)
        local styleOverride = textStyleStyle(config.Style)
        if not weightOverride and not styleOverride then
            return originalFace
        end

        local family, weight, style
        local readOk = pcall(function()
            family = originalFace.Family
            weight = originalFace.Weight
            style = originalFace.Style
        end)
        if not readOk or family == nil or tostring(family) == "" then
            return originalFace
        end
        local built, tunedFace = pcall(Font.new, family, weightOverride or weight, styleOverride or style)
        return built and tunedFace or originalFace
    end

    function FontManager:BuildFace(profile, roleName, originalFace)
        local textStyle = self.TextStyleConfig
        if not profile or profile.UseOriginal then
            return buildTunedOriginalFace(originalFace, textStyle)
        end
        local role = profile.Roles and profile.Roles[roleName]
        -- A partial profile is useful: a user can install a Latin font first,
        -- then add a Thai font later. Until then, leave the missing script in
        -- the UI's original FontFace instead of silently applying Latin to it.
        if not role then
            return originalFace
        end
        local family, familyError = self:ResolveLocalFamily(profile, roleName, role)
        if not family then
            return nil, familyError
        end

        local weight = role and enumWeight(role.Weight) or Enum.FontWeight.Regular
        local style = role and enumStyle(role.Style) or Enum.FontStyle.Normal
        if originalFace then
            pcall(function()
                weight = originalFace.Weight
                style = originalFace.Style
            end)
        end
        if textStyle.Enabled then
            weight = textStyleWeight(textStyle.Weight) or weight
            style = textStyleStyle(textStyle.Style) or style
        end
        -- A downloaded TTF often contains only Regular. Select the closest
        -- installed face instead of requesting an unavailable Bold/SemiBold.
        weight, style = chooseInstalledFace(role, weight, style)
        local cacheKey = table.concat({
            tostring(profile.Id),
            tostring(roleName),
            tostring(family),
            tostring(enumNumericWeight(weight)),
            tostring(style)
        }, "|")
        if self.FaceCache[cacheKey] then
            return self.FaceCache[cacheKey]
        end
        local ok, face = pcall(Font.new, family, weight, style)
        if not ok then
            return nil, tostring(face)
        end
        self.FaceCache[cacheKey] = face
        return face
    end

    function FontManager:Track(textObject, role)
        if not isTextObject(textObject) then
            return
        end
        local entry = self.Registry[textObject]
        if not entry then
            -- ClassName was already checked by isTextObject, so direct reads avoid
            -- creating a closure + pcall for every single label during boot.
            -- Weak-key Registry auto-collects destroyed labels because entry holds
            -- no back-reference to textObject (zero per-label Destroying connections).
            entry = {
                OriginalFace = textObject.FontFace,
                OriginalTextSize = textObject.TextSize,
                OriginalLineHeight = textObject.LineHeight,
                OriginalStrokeTransparency = textObject.TextStrokeTransparency,
                Role = role
            }
            self.Registry[textObject] = entry
        elseif role then
            entry.Role = role
        end
        -- A new object already has its script FontFace. Avoid assigning that
        -- same value again unless a custom profile or text tuning is active.
        if self.CurrentProfile ~= "default" then
            self:ApplyObject(textObject, entry)
        elseif self.TextStyleConfig and self.TextStyleConfig.Enabled then
            self:ApplyObject(textObject, entry)
        end
    end

    function FontManager:ApplyTextStyle(textObject, entry)
        if typeof(textObject) ~= "Instance" and type(textObject) == "table" then
            entry = textObject
            textObject = entry.Object
        end
        if not textObject or not entry then
            return
        end
        local config = self.TextStyleConfig

        local function setProperty(name, value)
            if value ~= nil then
                pcall(function()
                    textObject[name] = value
                end)
            end
        end

        if not config.Enabled then
            setProperty("TextSize", entry.OriginalTextSize)
            setProperty("LineHeight", entry.OriginalLineHeight)
            setProperty("TextStrokeTransparency", entry.OriginalStrokeTransparency)
            return
        end

        if type(entry.OriginalTextSize) == "number" then
            local size = math.max(6, math.min(96, math.floor(entry.OriginalTextSize * config.SizeScale / 100 + 0.5)))
            setProperty("TextSize", size)
        end
        if type(entry.OriginalLineHeight) == "number" then
            local height = math.max(0.5, math.min(3, entry.OriginalLineHeight * config.LineHeight / 100))
            setProperty("LineHeight", height)
        end
        -- 0 means "keep the script's outline".  Above 0 is a user-selected
        -- outline strength where 100 is fully opaque.
        if config.Stroke > 0 then
            setProperty("TextStrokeTransparency", 1 - config.Stroke / 100)
        else
            setProperty("TextStrokeTransparency", entry.OriginalStrokeTransparency)
        end
    end

    function FontManager:ApplyObject(textObject, entry)
        if typeof(textObject) ~= "Instance" and type(textObject) == "table" then
            entry = textObject
            textObject = entry.Object
        end
        if not textObject or not entry then
            return false
        end
        local profile = self.Profiles[self.CurrentProfile] or self.Profiles.default
        local displayedText = ""
        pcall(function()
            displayedText = textObject.Text
        end)
        -- A malformed external font must never stop the script from building
        -- its UI. Keep the original face and remember the error instead.
        local built, face, faceError = pcall(
            self.BuildFace,
            self,
            profile,
            fontRoleForText(entry.Role, displayedText),
            entry.OriginalFace
        )
        if not built then
            entry.LastError = tostring(face)
            self:ApplyTextStyle(textObject, entry)
            return false, entry.LastError
        end
        if face then
            pcall(function()
                textObject.FontFace = face
            end)
            self:ApplyTextStyle(textObject, entry)
            return true
        elseif profile and profile.UseOriginal and entry.OriginalFace then
            pcall(function()
                textObject.FontFace = entry.OriginalFace
            end)
            self:ApplyTextStyle(textObject, entry)
            return true
        elseif faceError then
            entry.LastError = faceError
            self:ApplyTextStyle(textObject, entry)
            return false, faceError
        end
        self:ApplyTextStyle(textObject, entry)
        return false
    end

    -- True when fonts differ from each label's own font: a custom profile or
    -- enabled text tuning. With neither, applying a font is a no-op.
    function FontManager:NeedsApply()
        local profile = self.Profiles[self.CurrentProfile] or self.Profiles.default
        local customProfile = profile ~= nil and not profile.UseOriginal
        return customProfile or (self.TextStyleConfig ~= nil and self.TextStyleConfig.Enabled == true)
    end

    function FontManager:ApplyAll()
        for textObject, entry in pairs(self.Registry) do
            if textObject and textObject.Parent then
                self:ApplyObject(textObject, entry)
            else
                self.Registry[textObject] = nil
            end
        end
    end

    function FontManager:ClearRegistry()
        for textObject in pairs(self.Registry) do
            self.Registry[textObject] = nil
        end
    end

    function FontManager:RegisterProfile(profile, shouldPersist)
        if type(profile) ~= "table" or type(profile.Roles) ~= "table" then
            return nil, "Invalid font profile."
        end
        profile.Id = sanitizeSegment(profile.Id or ("font_" .. stableHash(profile.Name)), "font")
        profile.Name = tostring(profile.Name or profile.Id)
        local previousProfile = self.Profiles[profile.Id]
        local exists = previousProfile ~= nil
        self.Profiles[profile.Id] = profile
        self.FaceCache = {}
        if not exists then
            table.insert(self.ProfileOrder, profile.Id)
        end
        if shouldPersist ~= false then
            local saved, saveError = self:SaveProfiles()
            if not saved and Storage:CanUseFiles() then
                self.Profiles[profile.Id] = previousProfile
                if not exists then
                    for index = #self.ProfileOrder, 1, -1 do
                        if self.ProfileOrder[index] == profile.Id then
                            table.remove(self.ProfileOrder, index)
                            break
                        end
                    end
                end
                self.FaceCache = {}
                return nil, saveError
            end
        end
        return profile
    end

    function FontManager:ValidateProfile(profile)
        if not profile or profile.UseOriginal then
            return true
        end
        local validatedRoles = {}
        local foundRole = false
        for roleName, role in pairs(profile.Roles or {}) do
            if type(role) == "table" and not validatedRoles[role] then
                foundRole = true
                validatedRoles[role] = true
                local family, familyError = self:ResolveLocalFamily(profile, roleName, role)
                if not family then
                    return false, familyError
                end
                local ok, fontError = pcall(Font.new, family, enumWeight(role.Weight), enumStyle(role.Style))
                if not ok then
                    return false, tostring(fontError)
                end
            end
        end
        if not foundRole then
            return false, "The font profile has no installed roles."
        end
        return true
    end

    function FontManager:ApplyProfile(profileId)
        profileId = self:GetProfileId(profileId)
        local profile = self.Profiles[profileId]
        if not profile then
            self.LastError = "Font profile was not found."
            return false, "Font profile was not found."
        end
        local valid, validationError = self:ValidateProfile(profile)
        if not valid then
            self.LastError = "This executor cannot use this font profile: " .. tostring(validationError)
            return false, self.LastError
        end
        self.LastError = nil
        self.CurrentProfile = profileId
        self:ApplyAll()
        return true
    end

    function FontManager:RemoveProfile(profileId)
        profileId = self:GetProfileId(profileId)
        if profileId == "default" or (self.Profiles[profileId] and self.Profiles[profileId].BuiltIn) then
            return false, "Built-in font profiles cannot be removed."
        end
        if not self.Profiles[profileId] then
            return false, "Font profile was not found."
        end
        self.Profiles[profileId] = nil
        self.FaceCache = {}
        for index = #self.ProfileOrder, 1, -1 do
            if self.ProfileOrder[index] == profileId then
                table.remove(self.ProfileOrder, index)
            end
        end
        if self.CurrentProfile == profileId then
            self.CurrentProfile = "default"
            self:ApplyAll()
        end
        self:SaveProfiles()
        return true
    end

    local function urlDecode(value)
        return (value:gsub("%%(%x%x)", function(hex)
            return string.char(tonumber(hex, 16))
        end))
    end

    local function fileExtension(url)
        local clean = tostring(url):match("^([^%?#]+)") or tostring(url)
        return (clean:match("%.([%a%d]+)$") or ""):lower()
    end

    local function chooseGoogleFontFile(listing)
        if type(listing) ~= "table" then
            return nil
        end
        local candidate
        local variableCandidate
        for _, item in ipairs(listing) do
            if type(item) == "table" and type(item.download_url) == "string" then
                local name = tostring(item.name or ""):lower()
                if name:match("%.ttf$") and not name:find("italic", 1, true) then
                    if name:find("regular", 1, true) then
                        return item.download_url, item.name
                    end
                    if not candidate and not name:find("variable", 1, true) then
                        candidate = {item.download_url, item.name}
                    end
                    -- A growing number of Google families ship only as a
                    -- VariableFont. It is still a valid TTF for a local
                    -- FontFamily, so use it only after a static face.
                    if not variableCandidate then
                        variableCandidate = {item.download_url, item.name}
                    end
                end
            end
        end
        local chosen = candidate or variableCandidate
        return chosen and chosen[1], chosen and chosen[2]
    end

    function RemoteAssets:ResolveGoogleFont(url)
        -- Google now serves some families below a collection path, e.g.
        -- fonts.google.com/noto/specimen/Noto+Sans+Thai.
        local family = url:match("fonts%.google%.com/specimen/([^%?#/]+)")
            or url:match("fonts%.google%.com/.-/specimen/([^%?#/]+)")
        if not family then
            family = url:match("[?&]family=([^:&]+)")
        end
        if not family then
            return nil, "Could not find a Google Fonts family in this URL."
        end
        family = urlDecode(family):gsub("%+", " ")
        local slug = family:lower():gsub("[^%w]", "")
        if slug == "" then
            return nil, "Could not normalize the Google Fonts family name."
        end

        for _, root in ipairs({"ofl", "apache", "ufl"}) do
            local raw = self:Fetch("https://api.github.com/repos/google/fonts/contents/" .. root .. "/" .. slug)
            if raw then
                local listing = jsonDecode(raw)
                local downloadUrl, fileName = chooseGoogleFontFile(listing)
                if downloadUrl then
                    return {
                        Url = downloadUrl,
                        Name = family,
                        FileName = fileName
                    }
                end
            end
        end
        return nil, "Google Fonts could not resolve a usable TTF. Paste a direct .ttf/.otf URL or ATG FontPack URL instead."
    end

    local function normalizeFontTarget(target)
        target = tostring(target or "both"):lower()
        if target == "english" or target == "latin" then
            return {"Latin"}
        end
        if target == "thai" then
            return {"Thai"}
        end
        return {"Latin", "Thai"}
    end

    local function downloadFontFile(url, profileId, roleName, suffix)
        local extension = fileExtension(url)
        if extension == "woff" or extension == "woff2" or extension == "css" then
            return nil, "Roblox FontFace cannot use CSS, WOFF, or WOFF2 files. Use a TTF/OTF or FontPack."
        end
        if extension ~= "ttf" and extension ~= "otf" then
            return nil, "Font URL must point to a .ttf or .otf file."
        end
        local contents, fetchError = RemoteAssets:Fetch(url)
        if not contents then
            return nil, fetchError
        end
        if #contents > 25000000 then
            return nil, "Font file is larger than 25 MB."
        end
        local path = joinPath(FontManager:GetFolder(), sanitizeSegment(profileId, "font"), roleName:lower() .. "-" .. tostring(suffix or 1) .. "." .. extension)
        local written, writeError = Storage:Write(path, contents)
        if not written then
            return nil, writeError
        end
        return path
    end

    local function copyLocalFontFile(sourcePath, profileId, roleName, suffix)
        local extension = fileExtension(sourcePath)
        if extension ~= "ttf" and extension ~= "otf" then
            return nil, "Local font file must end in .ttf or .otf."
        end
        local contents, readError = Storage:Read(sourcePath)
        if not contents then
            return nil, readError
        end
        if #contents > 25000000 then
            return nil, "Font file is larger than 25 MB."
        end
        local path = joinPath(FontManager:GetFolder(), sanitizeSegment(profileId, "font"), roleName:lower() .. "-" .. tostring(suffix or 1) .. "." .. extension)
        local written, writeError = Storage:Write(path, contents)
        if not written then
            return nil, writeError
        end
        return path
    end

    local function fontPackRoles(data)
        if type(data) ~= "table" then
            return nil
        end
        return data.roles or data.fonts
    end

    local function cloneFontData(value)
        if type(value) ~= "table" then
            return value
        end
        local copy = {}
        for key, child in pairs(value) do
            copy[key] = cloneFontData(child)
        end
        return copy
    end

    function RemoteAssets:ImportFont(source, options)
        options = options or {}
        source = trim(source)
        if source == "" then
            return nil, "Enter a Font Family asset ID or a remote URL."
        end

        local profileName = tostring(options.Name or "Custom font")
        local profileId = sanitizeSegment(options.Id or ("font_" .. stableHash(source)), "font")
        local baseProfile
        if type(options.MergeProfile) == "string" and options.MergeProfile ~= "" and options.MergeProfile ~= "default" then
            baseProfile = FontManager.Profiles[sanitizeSegment(options.MergeProfile, "")]
        end
        if baseProfile and not baseProfile.UseOriginal then
            profileId = baseProfile.Id
            profileName = tostring(options.Name or baseProfile.Name or profileName)
        else
            baseProfile = nil
        end
        local previousProfile = baseProfile and cloneFontData(baseProfile) or nil
        local function rollbackProfile(profileId)
            if previousProfile then
                FontManager:RegisterProfile(previousProfile)
                FontManager:ApplyProfile(previousProfile.Id)
            else
                FontManager:RemoveProfile(profileId)
            end
        end
        local function makeProfile(extra)
            local profile = {
                Id = profileId,
                Name = profileName,
                Roles = {}
            }
            if baseProfile then
                for roleName, role in pairs(baseProfile.Roles or {}) do
                    profile.Roles[roleName] = cloneFontData(role)
                end
                profile.Url = baseProfile.Url
                profile.LocalSource = baseProfile.LocalSource
            end
            for key, value in pairs(extra or {}) do
                profile[key] = value
            end
            return profile
        end
        if source:match("^rbxassetid://") or source:match("^rbxasset://") or source:match("^%d+$") then
            local family = source:match("^%d+$") and ("rbxassetid://" .. source) or source
            local valid, validationError = pcall(Font.new, family)
            if not valid then
                return nil, "This Font Family asset is not supported by the current executor/client: " .. tostring(validationError)
            end
            local profile = makeProfile()
            for _, roleName in ipairs(normalizeFontTarget(options.Target)) do
                profile.Roles[roleName] = {AssetId = family}
            end
            local saved, saveError = FontManager:RegisterProfile(profile)
            if not saved then
                return nil, saveError
            end
            local applied, applyError = FontManager:ApplyProfile(saved.Id)
            if not applied then
                rollbackProfile(saved.Id)
                return nil, applyError
            end
            return saved
        end

        if not Capabilities.CustomFonts then
            return nil, "This executor cannot install local/remote TTF or OTF fonts. It needs readfile, writefile, folder APIs, and getcustomasset (or getsynasset). Roblox Font Family asset IDs can still be used."
        end

        -- Optional local-file route for executors with a filesystem. The file
        -- is copied into our own folder so a user can later clean up Downloads.
        local localFileExists = false
        local localFontPackRaw
        if Capabilities.FileSystem then
            local checked, exists = pcall(Capabilities.IsFile, source)
            localFileExists = checked and exists
        end
        if localFileExists and fileExtension(source) == "json" then
            local rawPack, readError = Storage:Read(source)
            if not rawPack then
                return nil, readError
            end
            localFontPackRaw = rawPack
            localFileExists = false
        end
        if localFileExists then
            local targetRoles = normalizeFontTarget(options.Target)
            local storageRole = targetRoles[1] or "Latin"
            -- Keep files distinct when a user adds Latin and Thai to the same
            -- profile in separate steps; otherwise the second install could
            -- overwrite the first font on disk.
            local path, copyError = copyLocalFontFile(source, profileId, storageRole, stableHash(source))
            if not path then
                return nil, copyError
            end
            local localProfile = makeProfile({LocalSource = source})
            for _, roleName in ipairs(targetRoles) do
                localProfile.Roles[roleName] = {
                    Faces = {{
                        Path = path,
                        Name = "Regular",
                        Weight = 400,
                        Style = "normal"
                    }}
                }
            end
            local valid, validationError = FontManager:ValidateProfile(localProfile)
            if not valid then
                return nil, "This executor/client cannot load the local font: " .. tostring(validationError)
            end
            local saved, saveError = FontManager:RegisterProfile(localProfile)
            if not saved then
                return nil, saveError
            end
            local applied, applyError = FontManager:ApplyProfile(saved.Id)
            if not applied then
                rollbackProfile(saved.Id)
                return nil, applyError
            end
            return saved
        end

        local raw = localFontPackRaw or source
        local originalUrl = source
        if not isLikelyJson(raw) then
            if source:find("fonts.google.com", 1, true) or source:find("fonts.googleapis.com", 1, true) then
                local resolved, resolveError = self:ResolveGoogleFont(source)
                if not resolved then
                    return nil, resolveError
                end
                source = resolved.Url
                originalUrl = source
                if not baseProfile then
                    profileName = options.Name or resolved.Name
                end
                raw = nil
            else
                local extension = fileExtension(source)
                if extension == "json" then
                    raw = self:Fetch(source)
                    if not raw then
                        return nil, "Could not download the FontPack JSON."
                    end
                end
            end
        end

        local pack
        if type(raw) == "string" and isLikelyJson(raw) then
            pack = jsonDecode(raw)
            if not pack then
                return nil, "FontPack JSON is invalid."
            end
        end

        if not baseProfile and pack then
            profileName = tostring(((pack.meta or {}).name or pack.name) or profileName)
        end
        local profile = makeProfile({Url = originalUrl})

        if pack then
            local roles = fontPackRoles(pack)
            if type(roles) ~= "table" then
                return nil, "FontPack needs a roles object (latin/thai) with direct TTF or OTF URLs."
            end
            for roleKey, definition in pairs(roles) do
                local roleName = tostring(roleKey):lower() == "thai" and "Thai" or "Latin"
                local faces = type(definition) == "table" and (definition.faces or definition) or {definition}
                if type(faces) == "table" and faces.url then
                    faces = {faces}
                end
                local installedFaces = {}
                for index, face in ipairs(faces) do
                    local faceUrl = type(face) == "table" and face.url or face
                    if type(faceUrl) == "string" then
                        local path, downloadError = downloadFontFile(
                            faceUrl,
                            profileId,
                            roleName,
                            stableHash(faceUrl) .. "_" .. tostring(index)
                        )
                        if not path then
                            return nil, downloadError
                        end
                        table.insert(installedFaces, {
                            Path = path,
                            Name = type(face) == "table" and face.name or "Regular",
                            Weight = type(face) == "table" and face.weight or 400,
                            Style = type(face) == "table" and face.style or "normal"
                        })
                    end
                end
                if #installedFaces > 0 then
                    profile.Roles[roleName] = {Faces = installedFaces}
                end
            end
        else
            local targetRoles = normalizeFontTarget(options.Target)
            local storageRole = targetRoles[1] or "Latin"
            local path, downloadError = downloadFontFile(source, profileId, storageRole, stableHash(source))
            if not path then
                return nil, downloadError
            end
            for _, roleName in ipairs(targetRoles) do
                profile.Roles[roleName] = {
                    Faces = {{
                        Path = path,
                        Name = "Regular",
                        Weight = 400,
                        Style = "normal"
                    }}
                }
            end
        end

        if not profile.Roles.Latin and not profile.Roles.Thai then
            return nil, "No usable fonts were found in the FontPack."
        end
        local valid, validationError = FontManager:ValidateProfile(profile)
        if not valid then
            return nil, "This executor/client cannot load the downloaded font: " .. tostring(validationError)
        end
        local saved, saveError = FontManager:RegisterProfile(profile)
        if not saved then
            return nil, saveError
        end
        local applied, applyError = FontManager:ApplyProfile(saved.Id)
        if not applied then
            rollbackProfile(saved.Id)
            return nil, applyError
        end
        return saved
    end

    function RemoteAssets:GetLanguagePacks()
        return I18n:GetInstalledPacks()
    end

    function RemoteAssets:GetFontProfiles()
        return FontManager:GetProfiles()
    end

    function RemoteAssets:RemoveLanguage(packId)
        return I18n:RemovePack(packId)
    end

    function RemoteAssets:RemoveFont(profileId)
        return FontManager:RemoveProfile(profileId)
    end

    function CustomizationSystem:Configure(options)
        options = options or {}
        self.LastError = nil
        if options.Folder then
            Storage:SetRoot(options.Folder)
            I18n.LoadedScopePath = nil
            FontManager.LoadedRegistryPath = nil
        end
        I18n:SetScope(options.ScriptId or I18n.Scope, options.SourceLocale or I18n.SourceLocale)
        FontManager:LoadProfiles()
        if options.Locale then
            I18n:SetLanguage(options.Locale)
        end
        if options.Mode then
            I18n:SetMode(options.Mode)
        end
        if options.Enabled ~= nil then
            I18n:SetEnabled(options.Enabled)
        end
        if options.EnableRemoteAssets ~= nil then
            RemoteAssets:SetEnabled(options.EnableRemoteAssets)
        end
        if type(options.FontTuning) == "table" then
            -- Defer the sweep: ApplyProfile/ApplyAll below performs one pass
            -- after every saved setting has been loaded.
            FontManager:SetTextStyleConfig(options.FontTuning, true)
        end
        if options.FontProfile then
            local applied, applyError = FontManager:ApplyProfile(options.FontProfile)
            if not applied then
                self.LastError = applyError
            end
        else
            FontManager:ApplyAll()
        end
        return self
    end

    function CustomizationSystem:GetStatus()
        return {
            FileSystem = Capabilities.FileSystem,
            RemoteFetch = Capabilities.RemoteFetch,
            RemoteAssetsEnabled = RemoteAssets.Enabled,
            CustomFonts = Capabilities.CustomFonts,
            Locale = I18n.CurrentLocale,
            SourceLocale = I18n.SourceLocale,
            Mode = I18n.Mode,
            FontProfile = FontManager.CurrentProfile,
            FontTuning = FontManager:GetTextStyleConfig(),
            Scope = I18n.Scope,
            LastError = self.LastError or FontManager.LastError
        }
    end

    CustomizationSystem.Capabilities = Capabilities
    CustomizationSystem.Storage = Storage
    CustomizationSystem.I18n = I18n
    CustomizationSystem.Fonts = FontManager
    CustomizationSystem.RemoteAssets = RemoteAssets

    -- Preserve the original public TranslationSystem surface for existing scripts.
    TranslationSystem.Registry = I18n.Registry
    TranslationSystem.Cache = I18n.MachineCache
    TranslationSystem.AvailableLanguages = I18n.AvailableLanguages
    TranslationSystem.CurrentLanguage = I18n.CurrentLocale
    TranslationSystem.SourceLanguage = I18n.SourceLocale
    TranslationSystem.Enabled = I18n.Enabled

    function TranslationSystem:Register(textObject, originalText, propertyName, options)
        return I18n:Register(textObject, originalText, propertyName, options)
    end

    function TranslationSystem:UpdateText(textObject)
        return I18n:UpdateText(textObject)
    end

    function TranslationSystem:UpdateAllText()
        return I18n:UpdateAllText()
    end

    function TranslationSystem:SetLanguage(locale)
        return I18n:SetLanguage(locale)
    end

    function TranslationSystem:SetEnabled(enabled)
        return I18n:SetEnabled(enabled)
    end

    function TranslationSystem:SetMode(mode)
        return I18n:SetMode(mode)
    end

    function TranslationSystem:GetLanguageOptions()
        return I18n:GetLanguageOptions()
    end

    function TranslationSystem:GetLanguageCode(value)
        return I18n:GetLanguageCode(value)
    end

    function TranslationSystem:GetLanguageIndex()
        return I18n:GetLanguageIndex()
    end

    function TranslationSystem:TranslateText(text, targetLanguage, callback)
        return I18n:TranslateText(text, targetLanguage, callback)
    end
end

local moduleTree, moduleContext = {
	{
		1,
		"ModuleScript",
		{"MainModule"},
		{
			{18, "ModuleScript", {"Creator"}},
			{28, "ModuleScript", {"Icons"}},
			{
				47,
				"ModuleScript",
				{"Themes"},
				{
					{50, "ModuleScript", {"Dark V2"}},
					{52, "ModuleScript", {"Light"}},
					{51, "ModuleScript", {"Darker V2"}},
					{53, "ModuleScript", {"Rose"}},
					{49, "ModuleScript", {"Aqua"}},
					{48, "ModuleScript", {"Amethyst"}},
					{54, "ModuleScript", {"Ocean"}},
					{55, "ModuleScript", {"Forest"}},
					{56, "ModuleScript", {"Sunset"}},
					{57, "ModuleScript", {"Midnight"}},
					{58, "ModuleScript", {"Cherry"}},
					{59, "ModuleScript", {"Lavender"}},
					{60, "ModuleScript", {"Gold"}},
					{61, "ModuleScript", {"Mint"}},
					{62, "ModuleScript", {"Crimson"}},
					{63, "ModuleScript", {"Sapphire"}},
					{64, "ModuleScript", {"Peach"}},
					{65, "ModuleScript", {"Galaxy"}},
					{66, "ModuleScript", {"RGB"}},
					{67, "ModuleScript", {"Dark"}},
					{68, "ModuleScript", {"Darker"}},
					{69, "ModuleScript", {"Acryven"}}
				}
			},
			{
				19,
				"ModuleScript",
				{"Elements"},
				{
					{21, "ModuleScript", {"Colorpicker"}},
					{27, "ModuleScript", {"Toggle"}},
					{23, "ModuleScript", {"Input"}},
					{20, "ModuleScript", {"Button"}},
					{25, "ModuleScript", {"Paragraph"}},
					{22, "ModuleScript", {"Dropdown"}},
					{26, "ModuleScript", {"Slider"}},
					{24, "ModuleScript", {"Keybind"}},
					{70, "ModuleScript", {"ActionRow"}},
					{71, "ModuleScript", {"Callout"}},
					{72, "ModuleScript", {"CodeBlock"}},
					{73, "ModuleScript", {"Divider"}},
					{74, "ModuleScript", {"LiveConsole"}},
					{75, "ModuleScript", {"PlayerSelector"}},
					{76, "ModuleScript", {"ProgressBar"}},
					{77, "ModuleScript", {"RangeSlider"}},
					{78, "ModuleScript", {"SegmentedControl"}},
					{79, "ModuleScript", {"StatGrid"}},
					{80, "ModuleScript", {"Stepper"}},
					{81, "ModuleScript", {"TagInput"}},
					{90, "ModuleScript", {"Skeleton"}},
					{91, "ModuleScript", {"Spinner"}}
				}
			},
			{
				29,
				"Folder",
				{"Packages"},
				{
					{
						30,
						"ModuleScript",
						{"Flipper"},
						{
							{33, "ModuleScript", {"GroupMotor"}},
							{39, "ModuleScript", {"Signal"}},
							{45, "ModuleScript", {"isMotor"}},
							{31, "ModuleScript", {"BaseMotor"}},
							{43, "ModuleScript", {"Spring"}},
							{35, "ModuleScript", {"Instant"}},
							{37, "ModuleScript", {"Linear"}},
							{41, "ModuleScript", {"SingleMotor"}}
						}
					}
				}
			},
			{
				2,
				"ModuleScript",
				{"Acrylic"},
				{
					{3, "ModuleScript", {"AcrylicBlur"}},
					{5, "ModuleScript", {"CreateAcrylic"}},
					{6, "ModuleScript", {"Utils"}},
					{4, "ModuleScript", {"AcrylicPaint"}}
				}
			},
			{
				7,
				"Folder",
				{"Components"},
				{
					{9, "ModuleScript", {"Button"}},
					{12, "ModuleScript", {"Notification"}},
					{13, "ModuleScript", {"Section"}},
					{17, "ModuleScript", {"Window"}},
					{14, "ModuleScript", {"Tab"}},
					{10, "ModuleScript", {"Dialog"}},
					{8, "ModuleScript", {"Assets"}},
					{16, "ModuleScript", {"TitleBar"}},
					{15, "ModuleScript", {"Textbox"}},
					{11, "ModuleScript", {"Element"}},
					{82, "ModuleScript", {"CommandPalette"}},
					{83, "ModuleScript", {"ContextMenu"}},
					{84, "ModuleScript", {"DependencyBox"}},
					{85, "ModuleScript", {"FloatingPill"}},
					{86, "ModuleScript", {"HUD"}},
					{87, "ModuleScript", {"Row"}},
					{88, "ModuleScript", {"SubTabs"}},
					{89, "ModuleScript", {"Tooltip"}},
					{92, "ModuleScript", {"ProfileMenu"}},
					{93, "ModuleScript", {"SettingsModal"}}
				}
			}
		}
	}
}
local moduleFunctions = {
	function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(1)
		local libraryRoot = moduleScript
		local Creator = requireModule(libraryRoot.Creator)
		local Lighting = Creator.GetService("Lighting")
		local RunService = Creator.GetService("RunService")
		local Players = Creator.GetService("Players")
		local UserInputService = Creator.GetService("UserInputService")
		local TweenService = Creator.GetService("TweenService")
		local WorkspaceService = Creator.GetService("Workspace")
		local localPlayer, camera = Players.LocalPlayer, WorkspaceService.CurrentCamera
		local mouse = localPlayer:GetMouse()
		local elementModules, Acrylic, Components = requireModule(libraryRoot.Elements), requireModule(libraryRoot.Acrylic), libraryRoot.Components
		local Notification, New, protectGui = requireModule(Components.Notification), Creator.New, protectgui or (syn and syn.protect_gui) or function()
		end
		local guiParent = RunService:IsStudio() and localPlayer.PlayerGui or Creator.GetService("CoreGui")
		local gui = New("ScreenGui", {Name = "AcryvenMainGui", DisplayOrder = 0, Parent = guiParent})
		protectGui(gui)
		local overlayGui = New("ScreenGui", {Name = "AcryvenOverlayGui", DisplayOrder = 220, IgnoreGuiInset = false, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = guiParent})
		protectGui(overlayGui)
		local notifyGui = New("ScreenGui", {Name = "AcryvenNotificationGui", DisplayOrder = 240, IgnoreGuiInset = false, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = guiParent})
		protectGui(notifyGui)
		Notification:Init(notifyGui)
		-- Indexing an Enum with an unknown name throws; return nil instead.
		local function safeEnumItem(enumType, name)
			if typeof(name) == "EnumItem" then
				return name
			end
			if type(name) ~= "string" then
				return nil
			end
			local ok, item = pcall(function()
				return enumType[name]
			end)
			return ok and item or nil
		end
		local Library = {
			-- Brand identity (Acryven v3.0, 100% backward compatible with Fluent / ATGHUBUI).
			Brand = "Acryven",
			AcryvenVersion = "3.0.0",
			-- Fluent's version, kept for scripts that check it.
			Version = "1.6.0",
			-- Legacy ATG version field kept for compatibility.
			ATGVersion = "2.0.0",
			-- Automatic frame-budget yielding during heavy UI mount bursts (prevents >50ms hitches).
			AutoYieldMount = true,
			MountBudgetMs = 6,
			MountBatchCap = 10,
			OpenFrames = {},
			Options = {},
			Themes = requireModule(libraryRoot.Themes).Names,
			Window = nil,
			WindowFrame = nil,
			Unloaded = false,
			Theme = "Dark",
			DialogOpen = false,
			UseAcrylic = false,
			Acrylic = false,
			Transparency = true,
			MinimizeKeybind = nil,
			MinimizeKey = Enum.KeyCode.LeftControl,
			GUI = gui,
			OverlayGUI = overlayGui,
			NotificationGUI = notifyGui,
			-- Compatibility facade plus the modern customization and motion APIs.
			Motion = Creator.Motion,
			ReducedMotion = false,
			DPIScale = 1,
			NotifySide = "BottomRight",
			Translation = TranslationSystem,
			I18n = CustomizationSystem.I18n,
			Fonts = CustomizationSystem.Fonts,
			RemoteAssets = CustomizationSystem.RemoteAssets,
			Capabilities = CustomizationSystem.Capabilities,
			Customization = CustomizationSystem,
			CurrentLanguage = "en"
		}
		Library.PrivacyMode = {
			Hidden = false,
			Alias = "Anonymous",
			HideAvatar = false
		}

		-- Dropdowns currently open; closed on minimize, tab change and unload.
		Library._OpenDropdowns = {}
		function Library._CloseDropdowns()
			for dropdown in pairs(Library._OpenDropdowns) do
				pcall(dropdown.Close, dropdown)
			end
			if Library.ProfileMenu and Library.ProfileMenu.Opened then
				pcall(Library.ProfileMenu.Close, Library.ProfileMenu)
			end
		end

		-- Keybind tracker for live HUD KeybindList synchronization
		Library._TrackedKeybinds = {}
		Library._KeybindLists = {}
		Library._ActiveHUDs = {}
		function Library._NotifyKeybindChanged()
			for _, kbList in ipairs(Library._KeybindLists) do
				if kbList and not kbList.Destroyed and type(kbList.Refresh) == "function" then
					pcall(kbList.Refresh, kbList)
				end
			end
		end
		function Library._TrackKeybind(kb)
			if type(kb) == "table" and not table.find(Library._TrackedKeybinds, kb) then
				table.insert(Library._TrackedKeybinds, kb)
				Library._NotifyKeybindChanged()
			end
		end
		function Library._UntrackKeybind(kb)
			local idx = table.find(Library._TrackedKeybinds, kb)
			if idx then
				table.remove(Library._TrackedKeybinds, idx)
				Library._NotifyKeybindChanged()
			end
		end

		-- Phase 3 Singletons: CommandPalette, Tooltip, ContextMenu, HUD, FloatingPill, SettingsModal, ProfileMenu
		local CommandPalette = requireModule(Components.CommandPalette)(Library)
		local TooltipService = requireModule(Components.Tooltip)(Library)
		local ContextMenuService = requireModule(Components.ContextMenu)(Library)
		local HUDModule = requireModule(Components.HUD)
		local FloatingPillFactory = requireModule(Components.FloatingPill)
		local SettingsModalService = requireModule(Components.SettingsModal)(Library)
		local ProfileMenuService = requireModule(Components.ProfileMenu)(Library)
		Library.CommandPalette = CommandPalette
		Library.Tooltip = TooltipService
		Library.ContextMenu = ContextMenuService
		Library.SettingsModal = SettingsModalService
		Library.ProfileMenu = ProfileMenuService

		function Library.OpenSettings(_, tabName)
			if SettingsModalService then
				SettingsModalService:Open(tabName)
			end
		end
		function Library.CloseSettings(_)
			if SettingsModalService then
				SettingsModalService:Close()
			end
		end
		function Library.ToggleSettings(_, tabName)
			if SettingsModalService then
				SettingsModalService:Toggle(tabName)
			end
		end
		function Library.ToggleProfileMenu(_, anchorGui)
			if ProfileMenuService then
				ProfileMenuService:Toggle(anchorGui)
			end
		end
		local settingPrivacyMode = false
		function Library.SetPrivacyMode(_, hidden, alias, hideAvatar)
			if settingPrivacyMode then
				return Library.PrivacyMode
			end
			settingPrivacyMode = true
			if hidden ~= nil then
				Library.PrivacyMode.Hidden = hidden == true
			end
			if type(alias) == "string" and alias ~= "" then
				Library.PrivacyMode.Alias = alias
			end
			if hideAvatar ~= nil then
				Library.PrivacyMode.HideAvatar = hideAvatar == true
			end
			if Library.Window and type(Library.Window.UpdateProfileCard) == "function" then
				pcall(Library.Window.UpdateProfileCard)
			end
			if ProfileMenuService then
				pcall(ProfileMenuService.Refresh, ProfileMenuService)
			end
			if SettingsModalService and SettingsModalService.Opened and not SettingsModalService._Syncing then
				pcall(SettingsModalService.SyncValues, SettingsModalService)
			end
			settingPrivacyMode = false
			return Library.PrivacyMode
		end
		function Library.GetPrivacyMode(_)
			return {
				Hidden = Library.PrivacyMode.Hidden == true,
				Alias = Library.PrivacyMode.Alias or "Anonymous",
				HideAvatar = Library.PrivacyMode.HideAvatar == true
			}
		end

		function Library.OpenCommandPalette(_)
			if CommandPalette then
				CommandPalette:Open()
			end
		end
		function Library.CloseCommandPalette(_)
			if CommandPalette then
				CommandPalette:Close()
			end
		end
		function Library.ToggleCommandPalette(_)
			if CommandPalette then
				CommandPalette:Toggle()
			end
		end
		function Library.RegisterCommand(_, cmd)
			if CommandPalette then
				return CommandPalette:RegisterCommand(cmd)
			end
			return nil
		end
		function Library.AttachTooltip(_, guiObject, textOrGetter, delaySec)
			if TooltipService then
				TooltipService:Attach(guiObject, textOrGetter, delaySec)
			end
		end
		function Library.OpenContextMenu(_, items, screenPos)
			if ContextMenuService then
				ContextMenuService:Open(items, screenPos)
			end
		end
		function Library.AttachContextMenu(_, guiObject, itemsOrBuilder)
			if ContextMenuService then
				ContextMenuService:Attach(guiObject, itemsOrBuilder)
			end
		end
		function Library.CreateWatermark(_, opts)
			local wm = HUDModule.CreateWatermark(Library, opts)
			table.insert(Library._ActiveHUDs, wm)
			return wm
		end
		function Library.CreateKeybindList(_, opts)
			local kl = HUDModule.CreateKeybindList(Library, opts)
			table.insert(Library._ActiveHUDs, kl)
			return kl
		end
		function Library.CreateSpinner(_, parentGui, opts)
			local SpinnerModule = requireModule(libraryRoot.Elements.Spinner)
			if type(parentGui) == "table" and opts == nil and typeof(parentGui) ~= "Instance" then
				opts = parentGui
				parentGui = nil
			end
			return SpinnerModule.CreateIndicator(parentGui or gui, opts)
		end
		function Library.SetFont(_, profileId)
			return CustomizationSystem.Fonts:ApplyProfile(profileId)
		end
		function Library.GetFontProfiles(_)
			return CustomizationSystem.Fonts:GetProfiles()
		end
		function Library.CreateFloatingPill(_, opts)
			if Library.FloatingPill then
				Library.FloatingPill:Destroy()
			end
			local pill = FloatingPillFactory(Library, Library.Window, opts)
			Library.FloatingPill = pill
			if Library.Window and type(Library.Window.OnMinimizeChanged) == "function" then
				Library.Window:OnMinimizeChanged(function(isMin)
					if pill and not pill.Destroyed and not pill.AlwaysVisible then
						pill:SetVisible(isMin)
					end
				end)
			end
			return pill
		end
		function Library.SetFloatingPill(_, enabledOrOpts)
			if enabledOrOpts == false then
				if Library.FloatingPill then
					Library.FloatingPill:Destroy()
				end
				return nil
			end
			return Library:CreateFloatingPill(type(enabledOrOpts) == "table" and enabledOrOpts or nil)
		end
		-- Library.OnUnload:Connect(fn) runs fn once, first thing in Destroy.
		local unloadHandlers = {}
		Library.OnUnload = {}
		function Library.OnUnload.Connect(_, callback)
			assert(type(callback) == "function", "OnUnload:Connect expects a function")
			local handler = {Callback = callback, Connected = true}
			function handler.Disconnect()
				handler.Connected = false
			end
			table.insert(unloadHandlers, handler)
			return handler
		end
		local safeCallbackDepth = 0
		local lastErrorNotifyAt = 0
		function Library.SafeCallback(_, callback, ...)
			if not callback then
				return
			end
			if safeCallbackDepth >= 16 then
				return
			end
			safeCallbackDepth += 1
			local ok, err = pcall(callback, ...)
			safeCallbackDepth -= 1
			if not ok then
				local now = os.clock()
				if (now - lastErrorNotifyAt) < 0.5 then
					return
				end
				lastErrorNotifyAt = now
				err = tostring(err)
				local _, matchEnd = err:find ":%d+: "
				if not matchEnd then
					return Library:Notify {Title = "Interface", Content = "Callback error", SubContent = err, Duration = 5}
				end
				return Library:Notify {
					Title = "Interface",
					Content = "Callback error",
					SubContent = err:sub(matchEnd + 1),
					Duration = 5
				}
			end
		end
		function Library.Round(_, value, decimals)
			-- Always returns a number, rounded half up to `decimals` places.
			local number = tonumber(value)
			if number == nil then
				return value
			end
			local factor = 10 ^ (tonumber(decimals) or 0)
			return math.floor(number * factor + 0.5) / factor
		end
		function Library.ShowSplash(_)
			showSplash()
		end
		-- Adds an element to Workspace Recent. Elements call this from user
		-- input only, so values set by scripts or loaded configs stay out.
		function Library._TouchElement(element)
			local workspace = Library.Workspace
			if workspace and type(element) == "table" and element._ATGEntry then
				workspace:TouchEntry(element._ATGEntry)
			end
		end
		local iconAssets = requireModule(libraryRoot.Icons).assets
		function Library.GetIcon(selfOrName, name)
			if type(selfOrName) == "string" and name == nil then
				name = selfOrName
			end
			if type(name) ~= "string" or name == "" then
				return nil
			end
			local clean = name:lower():gsub("^lucide%-", "")
			return iconAssets[clean]
		end
		--[[
			Workspace is deliberately independent from InterfaceManager.  Old scripts
			get the productivity surface automatically, while InterfaceManager only
			provides persistence scope/customization settings.  It owns no script
			callbacks and never scans CoreGui, so it remains inexpensive in long
			sessions and safe on executors without a file system.
		]]
		local WorkspaceHttpService = Creator.GetService("HttpService")
		local Workspace = {
			Version = 1,
			Library = Library,
			Scope = "shared",
			Window = nil,
			Tabs = {},
			TabById = {},
			Entries = {},
			EntryById = {},
			Notifications = {},
			Connections = {},
			State = {
				Favorites = {},
				Recent = {},
				RecentProfiles = {},
				TabOrder = {},
				Profiles = {},
				CompactMode = false,
				FocusMode = false,
				SmartConfirm = true
			},
			ArrangeMode = false,
			SaveScheduled = false
		}
		Library.Workspace = Workspace

		local function workspaceSafeSegment(value, fallback)
			value = tostring(value or fallback or "shared")
			value = value:gsub("[^%w%-%._]", "_"):gsub("_+", "_"):sub(1, 80)
			if value == "" or value == "." or value == ".." then
				return fallback or "shared"
			end
			return value
		end
		local function workspaceTrim(value)
			return type(value) == "string" and (value:match("^%s*(.-)%s*$") or "") or ""
		end
		local function workspaceObjectText(object)
			if type(object) == "string" then return object end
			if object == nil then return "" end
			local ok, text = pcall(function() return object.Text end)
			return ok and type(text) == "string" and text or ""
		end
		local function workspaceIndex(list, item)
			for index, value in ipairs(list or {}) do
				if value == item then
					return index
				end
				end
			return nil
		end
		local function workspacePush(list, item, limit)
			local index = workspaceIndex(list, item)
			if index then
				table.remove(list, index)
			end
			table.insert(list, 1, item)
			while #list > (limit or 12) do
				table.remove(list)
			end
		end
		local function workspaceCopy(value)
			if type(value) ~= "table" then
				return value
			end
			local copy = {}
			for key, item in pairs(value) do
				copy[key] = workspaceCopy(item)
			end
			return copy
		end
		local function workspaceEncodeValue(value)
			local kind = typeof(value)
			if kind == "Color3" then
				return {__atg = "Color3", R = value.R, G = value.G, B = value.B}
			end
			if kind == "EnumItem" then
				local ok, enumName, itemName = pcall(function()
					return value.EnumType.Name, value.Name
				end)
				if ok then
					return {__atg = "Enum", Type = enumName, Name = itemName}
				end
				return tostring(value)
			end
			if type(value) == "table" then
				local encoded = {}
				for key, item in pairs(value) do
					encoded[key] = workspaceEncodeValue(item)
				end
				return encoded
			end
			if type(value) == "string" or type(value) == "number" or type(value) == "boolean" then
				return value
			end
			return nil
		end
		local function workspaceDecodeValue(value)
			if type(value) ~= "table" then
				return value
			end
			if value.__atg == "Color3" then
				return Color3.new(tonumber(value.R) or 1, tonumber(value.G) or 1, tonumber(value.B) or 1)
			end
			if value.__atg == "Enum" and type(value.Type) == "string" and type(value.Name) == "string" then
				local item
				pcall(function()
					item = Enum[value.Type][value.Name]
				end)
				return item or value.Name
			end
			local decoded = {}
			for key, item in pairs(value) do
				if key ~= "__atg" then
					decoded[key] = workspaceDecodeValue(item)
				end
			end
			return decoded
		end

		function Workspace:Connect(signal, handler)
			local connection = signal:Connect(handler)
			table.insert(self.Connections, connection)
			return connection
		end
		-- Connections owned by a transient search/profile row are released when
		-- that row is destroyed.  Do not retain them in the workspace registry.
		function Workspace:Bind(signal, handler)
			return signal:Connect(handler)
		end
		function Workspace:GetStorage()
			local storage = Library.Customization and Library.Customization.Storage
			return type(storage) == "table" and storage or nil
		end
		function Workspace:GetPath()
			local storage = self:GetStorage()
			local root = storage and storage.Root or "FluentSettings"
			return tostring(root) .. "/productivity/" .. workspaceSafeSegment(self.Scope, "shared") .. "/workspace.json"
		end
		function Workspace:SaveSoon()
			self.SaveRevision = (self.SaveRevision or 0) + 1
			local revision = self.SaveRevision
			if self.SaveScheduled then
				return
			end
			self.SaveScheduled = true
			local scope = self.Scope
			local state = self.State
			task.delay(0.35, function()
				self.SaveScheduled = false
				if revision ~= self.SaveRevision then
					self:SaveSoon()
					return
				end
				if self.Scope ~= scope or self.State ~= state then
					return
				end
				local storage = self:GetStorage()
				if not storage or type(storage.CanUseFiles) ~= "function" or not storage:CanUseFiles() then
					return
				end
				local ok, encoded = pcall(WorkspaceHttpService.JSONEncode, WorkspaceHttpService, self.State)
				if ok then
					pcall(storage.Write, storage, self:GetPath(), encoded)
				end
			end)
		end
		function Workspace:Load()
			local storage = self:GetStorage()
			if not storage or type(storage.CanUseFiles) ~= "function" or not storage:CanUseFiles() then
				return false
			end
			local contents, readError = storage:Read(self:GetPath())
			if type(contents) ~= "string" then
				return false, readError
			end
			local ok, decoded = pcall(WorkspaceHttpService.JSONDecode, WorkspaceHttpService, contents)
			if not ok or type(decoded) ~= "table" then
				return false, "Workspace file is not valid JSON."
			end
			local state = self.State
			for key, defaultValue in pairs(state) do
				if type(decoded[key]) == type(defaultValue) then
					state[key] = decoded[key]
				end
			end
			if type(state.SmartConfirm) ~= "boolean" then
				state.SmartConfirm = true
			end
			-- Focus is intentionally session-only.  Restoring it at startup can
			-- make every tab except the first one look as if it vanished.
			state.FocusMode = false
			return true
		end
		function Workspace:Configure(options)
			options = type(options) == "table" and options or {}
			local scope = workspaceSafeSegment(options.ScriptId or (Library.I18n and Library.I18n.Scope) or self.Scope, "shared")
			if scope ~= self.Scope then
				self.Scope = scope
				self.State = {
					Favorites = {}, Recent = {}, RecentProfiles = {}, TabOrder = {}, Profiles = {},
					CompactMode = false, FocusMode = false, SmartConfirm = true
				}
				self:Load()
				self:ApplyTabOrder()
				self:ApplyModes()
				self:RefreshSurface()
			end
			return self
		end
		function Workspace:IsFavorite(id)
			return workspaceIndex(self.State.Favorites, id) ~= nil
		end
		function Workspace:ToggleFavorite(id)
			if type(id) ~= "string" then
				return
			end
			local index = workspaceIndex(self.State.Favorites, id)
			if index then
				table.remove(self.State.Favorites, index)
			else
				workspacePush(self.State.Favorites, id, 24)
			end
			self:SaveSoon()
			self:RefreshSurface()
		end
		function Workspace:TouchEntry(entry)
			local id = type(entry) == "table" and entry.Id or entry
			if type(id) == "string" then
				workspacePush(self.State.Recent, id, 12)
				self:SaveSoon()
			end
		end
		function Workspace:TouchTab(tab)
			if type(tab) ~= "table" then
				return
			end
			self:TouchEntry(tab.Id)
			self:ApplyModes()
			if self.SearchActive then
				self:ApplySearchControlVisibility(tab)
			end
		end
		function Workspace:RegisterTab(tab, _)
			if type(tab) ~= "table" or not tab.Frame or self.TabById[tab.Id] then
				return tab
			end
			tab.OriginalName = tab.OriginalName or tab.Name
			tab.OriginalLabelText = tab.Label and tab.Label.Text or tab.Name
			self.TabById[tab.Id] = tab
			table.insert(self.Tabs, tab)
			self:Connect(tab.Frame.InputBegan, function(input)
				if self.ArrangeMode and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
					self.Drag = {Tab = tab, Start = input.Position, Input = input, Moved = false}
				end
			end)
			-- Coalesce layout order + mode updates across rapid AddTab bursts during boot.
			if not self._TabRefreshQueued then
				self._TabRefreshQueued = true
				task.defer(function()
					self._TabRefreshQueued = false
					if not self.Window then
						return
					end
					self:ApplyTabOrder()
					self:ApplyModes()
				end)
			end
			return tab
		end
		function Workspace:RegisterElement(element, section, options, elementType, optionKey)
			if type(element) ~= "table" then
				return nil
			end
			options = type(options) == "table" and options or {}
			local label = type(optionKey) == "string" and optionKey or options.Id or options.Title or elementType or "element"
			local id = "option:" .. workspaceSafeSegment(label, "element")
			if self.EntryById[id] then
				id = id .. "-" .. tostring(#self.Entries + 1)
			end
			local entry = {
				Id = id,
				Title = tostring(options.Title or element.Title or label),
				Description = tostring(options.Description or ""),
				Type = tostring(elementType or element.Type or "Control"),
				Object = element,
				Frame = element.Frame or element.Root,
				Section = section,
				Tab = section and section.Tab or nil,
				TabTitle = section and section.TabTitle or ""
			}
			self.EntryById[entry.Id] = entry
			table.insert(self.Entries, entry)
			-- Elements report user changes through Library._TouchElement.
			element._ATGEntry = entry
			return entry
		end
		function Workspace:ApplyTabOrder()
			if #self.Tabs == 0 then
				return
			end
			local ordered, seen = {}, {}
			for _, id in ipairs(self.State.TabOrder or {}) do
				local tab = self.TabById[id]
				if tab then
					table.insert(ordered, tab)
					seen[tab.Id] = true
				end
			end
			for _, tab in ipairs(self.Tabs) do
				if not seen[tab.Id] then
					table.insert(ordered, tab)
				end
			end
			self.State.TabOrder = {}
			for index, tab in ipairs(ordered) do
				tab.Frame.LayoutOrder = index * 10
				table.insert(self.State.TabOrder, tab.Id)
			end
		end
		function Workspace:MoveTabTo(tab, target)
			local ordered = {}
			for _, tab in ipairs(self.Tabs) do
				table.insert(ordered, tab)
			end
			table.sort(ordered, function(left, right)
				return left.Frame.LayoutOrder < right.Frame.LayoutOrder
			end)
			local fromIndex = workspaceIndex(ordered, tab)
			local toIndex = workspaceIndex(ordered, target)
			if not fromIndex or not toIndex or fromIndex == toIndex then
				return
			end
			table.remove(ordered, fromIndex)
			table.insert(ordered, toIndex, tab)
			self.State.TabOrder = {}
			for index, tab in ipairs(ordered) do
				tab.Frame.LayoutOrder = index * 10
				table.insert(self.State.TabOrder, tab.Id)
			end
			self:SaveSoon()
		end
		function Workspace:MoveDraggingTab(cursorY)
			if not self.Drag or not self.Drag.Tab then
				return
			end
			local dragged, target = self.Drag.Tab, nil
			-- self.Tabs is in tab-creation order, not current visual order, so it
			-- must be sorted by LayoutOrder before hit-testing against cursor Y
			-- (same sort MoveTabTo already does before computing indices) —
			-- otherwise this picks the wrong drop target once a drag has moved a
			-- tab away from its creation-order position.
			local ordered = {}
			for _, tab in ipairs(self.Tabs) do
				table.insert(ordered, tab)
			end
			table.sort(ordered, function(left, right)
				return left.Frame.LayoutOrder < right.Frame.LayoutOrder
			end)
			for _, tab in ipairs(ordered) do
				if tab ~= dragged and tab.Frame.Visible and cursorY < tab.Frame.AbsolutePosition.Y + tab.Frame.AbsoluteSize.Y * 0.5 then
					target = tab
					break
				end
			end
			if not target then
				for index = #ordered, 1, -1 do
					if ordered[index] ~= dragged and ordered[index].Frame.Visible then
						target = ordered[index]
						break
					end
				end
			end
			if target then
				self:MoveTabTo(dragged, target)
			end
		end
		function Workspace:ApplyModes()
			local compact = self.State.CompactMode == true or (self.Window and self.Window.SidebarCollapsed == true)
			local focus = self.State.FocusMode == true
			for _, tab in ipairs(self.Tabs) do
				if tab.Frame then
					if self.SearchActive then
						tab.Frame.Visible = self.SearchMatchedTabs and self.SearchMatchedTabs[tab.Id] == true
					else
						tab.Frame.Visible = not focus or tab.Selected
					end
				end
				if type(tab.SetCollapsed) == "function" then
					tab.SetCollapsed(compact)
				end
			end
		end
		function Workspace:SetCompact(enabled)
			enabled = enabled == true
			self.State.CompactMode = enabled
			if enabled and self.SidebarSearch and self.SidebarSearch.Text ~= "" then
				-- Compact mode intentionally has no search field, so never leave
				-- the tab rail replaced by invisible search rows.
				self.SidebarSearch.Text = ""
			end
			if self.Window and type(self.Window.SetSidebarCollapsed) == "function" then
				self.Window:SetSidebarCollapsed(enabled, true)
			elseif self.Window and type(self.Window.SetTabWidth) == "function" then
				self.Window:SetTabWidth(enabled and 46 or self.OriginalTabWidth, true)
			end
			if self.Sidebar then
				self.Sidebar.Size = UDim2.new(0, enabled and 46 or self.OriginalTabWidth, 0, enabled and 0 or 26)
				self.SidebarSearch.Visible = not enabled
			end
			if self.Window and self.Window.TabArea then
				-- Reserve space at the bottom of the sidebar for the collapse button + profile card.
				local top = (self.Sidebar and not enabled) and 92 or 56
				local reserve = self.Window.SidebarFooterReserve or 98
				self.Window.TabArea.Position = UDim2.new(0, 12, 0, top)
				self.Window.TabArea.Size = UDim2.new(0, self.Window.TabWidth, 1, -(top + reserve))
			end
			if self.Panel then
				self.Panel.Size = UDim2.new(0, enabled and 230 or self.OriginalTabWidth, 0, 260)
			end
			self:ApplyModes()
			self:SaveSoon()
		end
		function Workspace:UpdateSearchHint()
			if self.SidebarSearch then
				local hint = self.State.FocusMode and "Focus mode on  •  Ctrl+K to exit" or "Search...  Ctrl+K"
				self.SidebarSearch.PlaceholderText = hint
				TranslationSystem:Register(self.SidebarSearch, hint, "PlaceholderText")
			end
		end
		function Workspace:SetFocus(enabled)
			enabled = enabled == true
			if enabled then
				local anySelected = false
				for _, tab in ipairs(self.Tabs) do
					anySelected = anySelected or tab.Selected
				end
				if not anySelected and self.Tabs[1] and type(self.Tabs[1].Select) == "function" then
					self.Tabs[1]:Select()
				end
			end
			self.State.FocusMode = enabled
			self:ApplyModes()
			self:UpdateSearchHint()
			self:SaveSoon()
		end
		function Workspace:SetArrangeMode(enabled)
			self.ArrangeMode = enabled == true
			for _, tab in ipairs(self.Tabs) do
				if tab.Frame then
					tab.Frame.Active = self.ArrangeMode
					tab.Frame.BackgroundTransparency = self.ArrangeMode and 0.94 or (tab.Selected and 0.89 or 1)
				end
			end
			if Library.Window then
				Library:Notify {
					Title = "Tabs",
					Content = self.ArrangeMode and "Drag tabs to rearrange. Click Arrange again when done." or "Tab order saved.",
					Duration = 3
				}
			end
		end
		function Workspace:Navigate(entry)
			if type(entry) ~= "table" then
				return
			end
			if entry.Tab and type(entry.Tab.Select) == "function" then
				entry.Tab:Select()
			end
			self:TouchEntry(entry)
			if entry.Frame and entry.Tab and entry.Tab.ScrollFrame then
				task.delay(0.18, function()
					if not entry.Frame.Parent or not entry.Tab.ScrollFrame.Parent then
						return
					end
					local scrollFrame = entry.Tab.ScrollFrame
					local scale = Creator.GetEffectiveScale(scrollFrame)
					local canvasY = math.max(0, (entry.Frame.AbsolutePosition.Y - scrollFrame.AbsolutePosition.Y) / scale + scrollFrame.CanvasPosition.Y - 12)
					scrollFrame.CanvasPosition = Vector2.new(0, canvasY)
					local highlight = Instance.new("UIStroke")
					highlight.Name = "ATGWorkspaceHighlight"
					highlight.Color = Creator.GetThemeProperty("Accent")
					highlight.Thickness = 1.5
					highlight.Transparency = 1
					highlight.Parent = entry.Frame
					TweenService:Create(highlight, TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Transparency = 0.1}):Play()
					task.delay(0.85, function()
						if highlight.Parent then
							local fadeOut = TweenService:Create(highlight, TweenInfo.new(0.22), {Transparency = 1})
							fadeOut:Play()
							fadeOut.Completed:Connect(function()
								if highlight.Parent then highlight:Destroy() end
							end)
						end
					end)
				end)
			end
		end
		function Workspace:GetTabDisplayTitle(tab)
			if type(tab) ~= "table" then return "" end
			if tab.Selected and self.Window then
				local displayed = workspaceObjectText(self.Window.TabDisplay)
				if displayed ~= "" then return displayed end
			end
			local label = workspaceObjectText(tab.Label)
			return label ~= "" and label or tostring(tab.Name or "")
		end
		function Workspace:GetEntryDisplayText(entry)
			if type(entry) ~= "table" then return "", "" end
			local object = type(entry.Object) == "table" and entry.Object or nil
			local title = workspaceObjectText(object and object.TitleLabel)
			local description = workspaceObjectText(object and object.DescLabel)
			return title ~= "" and title or tostring(entry.Title or ""), description ~= "" and description or tostring(entry.Description or "")
		end
		function Workspace:TabMatchesSearch(tab, query)
			query = workspaceTrim(query):lower()
			if query == "" or type(tab) ~= "table" then return query == "" end
			local name = tostring(tab.Name or "")
			local originalName = tostring(tab.OriginalName or "")
			local labelText = tostring(tab.OriginalLabelText or "")
			local displayTitle = self:GetTabDisplayTitle(tab)
			return (name .. " " .. originalName .. " " .. labelText .. " " .. displayTitle):lower():find(query, 1, true) ~= nil
		end
		function Workspace:RestoreSearchControlVisibility()
			for object, visible in pairs(self.SearchControlVisibility or {}) do
				if object and object.Parent then pcall(function() object.Visible = visible end) end
			end
			self.SearchControlVisibility = {}
			for object, visible in pairs(self.SearchSectionVisibility or {}) do
				if object and object.Parent then pcall(function() object.Visible = visible end) end
			end
			self.SearchSectionVisibility = {}
		end
		function Workspace:ApplySearchControlVisibility(tab)
			self:RestoreSearchControlVisibility()
			if not self.SearchActive or not tab then return end
			-- A title match means this is the exact requested Tab: retain its
			-- complete, original UI.  Only an indirect control match is filtered.
			if self.SearchDirectTabs and self.SearchDirectTabs[tab.Id] then return end
			local sectionMatches = {}
			for _, entry in ipairs(self.Entries) do
				if entry and entry.Tab == tab and entry.Section and entry.Section.Root then
					sectionMatches[entry.Section.Root] = sectionMatches[entry.Section.Root] or false
					if self.SearchMatchedEntries and self.SearchMatchedEntries[entry.Id] then sectionMatches[entry.Section.Root] = true end
				end
			end
			for section, visible in pairs(sectionMatches) do
				if section.Parent then
					self.SearchSectionVisibility[section] = section.Visible
					section.Visible = visible
				end
			end
			for _, entry in ipairs(self.Entries) do
				local frame = entry and entry.Frame
				if entry and entry.Tab == tab and frame and frame.Parent then
					self.SearchControlVisibility[frame] = frame.Visible
					frame.Visible = self.SearchMatchedEntries and self.SearchMatchedEntries[entry.Id] == true
				end
			end
		end
		function Workspace:FindEntries(query)
			query = workspaceTrim(query):lower()
			local results = {}
			if query == "" then
				for _, id in ipairs(self.State.Recent) do
					local item = self.EntryById[id] or self.TabById[id]
					if item then
						if item.Type == "Tab" then
							table.insert(results, {Id = item.Id, Title = item.Name, Description = "Tab", Type = "Tab", Tab = item})
						else
							table.insert(results, item)
						end
					end
				end
				return results
			end
			for _, entry in ipairs(self.Entries) do
				-- Controls created by older scripts do not always provide every
				-- display field. Search is optional UI, so normalize missing data
				-- instead of letting it interrupt the main UI creation flow.
				if type(entry) == "table" then
					local title, description = self:GetEntryDisplayText(entry)
					local tabTitle = self:GetTabDisplayTitle(entry.Tab)
					local haystack = (tostring(entry.Title or "") .. " " .. tostring(entry.Description or "") .. " " .. tostring(entry.TabTitle or "") .. " " .. tostring(entry.Type or "") .. " " .. title .. " " .. description .. " " .. tabTitle):lower()
					if haystack:find(query, 1, true) then
						table.insert(results, entry)
					end
				end
			end
			for _, tab in ipairs(self.Tabs) do
				local name = type(tab) == "table" and tostring(tab.Name or "") or ""
				local displayTitle = self:GetTabDisplayTitle(tab)
				if (name .. " " .. displayTitle):lower():find(query, 1, true) then
					table.insert(results, {Id = tab.Id, Title = displayTitle, Description = "Tab", Type = "Tab", Tab = tab})
				end
			end
			return results
		end
		function Workspace:RecordNotification(notification)
			if type(notification) ~= "table" then
				return
			end
			table.insert(self.Notifications, 1, {
				Title = tostring(notification.Title or "Notification"),
				Content = tostring(notification.Content or notification.SubContent or ""),
				At = os.clock()
			})
			while #self.Notifications > 40 do
				table.remove(self.Notifications)
			end
			if self.PanelKind == "history" then
				self:RenderHistory()
			end
		end
		function Workspace:CaptureProfile()
			local profile = {}
			for key, option in pairs(Library.Options) do
				if type(option) == "table" and option.Type and option.Value ~= nil then
					profile[key] = {
						Type = option.Type,
						Value = workspaceEncodeValue(option.Value),
						Transparency = option.Transparency
					}
				end
			end
			return profile
		end
		function Workspace:SaveProfile(name)
			name = workspaceTrim(name):sub(1, 36)
			if name == "" then
				return false, "Enter a profile name first."
			end
			self.State.Profiles[name] = self:CaptureProfile()
			workspacePush(self.State.RecentProfiles, name, 5)
			self:SaveSoon()
			return true
		end
		function Workspace:ApplyProfile(name)
			local profile = self.State.Profiles[name]
			if type(profile) ~= "table" then
				return false, "Profile was not found."
			end
			for key, saved in pairs(profile) do
				local option = Library.Options[key]
				if type(option) == "table" then
					pcall(function()
						local value = workspaceDecodeValue(saved.Value)
						if saved.Type == "Colorpicker" and type(option.SetValueRGB) == "function" and typeof(value) == "Color3" then
							option:SetValueRGB(value, saved.Transparency)
						elseif type(option.SetValue) == "function" then
							option:SetValue(value)
						end
					end)
				end
			end
			workspacePush(self.State.RecentProfiles, name, 5)
			self:SaveSoon()
			return true
		end
		function Workspace:Confirm(prompt, callback, ...)
			local args, argCount = { ... }, select("#", ...)
			if self.State.SmartConfirm == false or not self.Window or type(self.Window.Dialog) ~= "function" then
				return Library:SafeCallback(callback, unpack(args, 1, argCount))
			end
			local options = type(prompt) == "table" and prompt or {}
			self.Window:Dialog {
				Title = tostring(options.Title or "Please confirm"),
				Content = tostring(options.Content or (type(prompt) == "string" and prompt or "This action cannot be undone.")),
				Buttons = {
					{Title = tostring(options.ConfirmText or "Continue"), Callback = function() Library:SafeCallback(callback, unpack(args, 1, argCount)) end},
					{Title = tostring(options.CancelText or "Cancel")}
				}
			}
		end
		-- Workspace colors follow the theme: a color option may be a Color3 or a
		-- theme key such as "SubText"; defaults are theme keys.
		local function themed(properties, property, color)
			if type(color) == "string" then
				properties.ThemeTag = properties.ThemeTag or {}
				properties.ThemeTag[property] = color
			else
				properties[property] = color
			end
			return properties
		end
		function Workspace:Text(parent, text, textSize, options)
			options = options or {}
			local zIndex = options.ZIndex or ((parent and parent.ZIndex or 0) + 1)
			return New("TextLabel", themed({
				Name = options.Name or "ATGWorkspaceText",
				Parent = parent,
				BackgroundTransparency = 1,
				Text = tostring(text or ""),
				I18nSkip = true,
				FontFace = Creator.Font(options.Weight or Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				TextTransparency = options.Transparency or 0,
				TextSize = textSize or 12,
				TextXAlignment = options.Align or Enum.TextXAlignment.Left,
				TextYAlignment = options.VerticalAlign or Enum.TextYAlignment.Center,
				TextTruncate = options.Truncate or Enum.TextTruncate.AtEnd,
				TextWrapped = options.Wrapped == true,
				Size = options.Size or UDim2.fromScale(1, 1),
				Position = options.Position or UDim2.fromScale(0, 0),
				ZIndex = zIndex
			}, "TextColor3", options.Color or "Text"))
		end
		function Workspace:Button(parent, text, icon, callback, options)
			local zIndex = options and options.ZIndex or ((parent and parent.ZIndex or 0) + 1)
			local button = New("TextButton", themed({
				Name = "ATGWorkspaceButton",
				Parent = parent,
				Size = options and options.Size or UDim2.new(1, 0, 0, options and options.Height or 34),
				Position = options and options.Position or UDim2.new(),
				BackgroundTransparency = options and options.BackgroundTransparency or 0.08,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Text = "",
				ZIndex = zIndex
			}, "BackgroundColor3", options and options.Background or "DialogButton"))
			New("UICorner", {CornerRadius = UDim.new(0, 7), Parent = button})
			New("UIStroke", themed({
				Transparency = options and options.StrokeTransparency or 0.62,
				Thickness = 1,
				Parent = button
			}, "Color", options and options.StrokeColor or "DialogButtonBorder"))
			if icon then
				New("ImageLabel", themed({
					Name = "Icon",
					Parent = button,
					BackgroundTransparency = 1,
					Image = Library.GetIcon(icon) or icon,
					Size = UDim2.fromOffset(14, 14),
					Position = UDim2.new(0, 9, 0.5, -7),
					ZIndex = zIndex + 1
				}, "ImageColor3", options and options.IconColor or "Text"))
			end
			self:Text(button, text, options and options.TextSize or 12, {
				Name = "Title",
				Weight = options and options.Weight or Enum.FontWeight.Medium,
				Size = UDim2.new(1, icon and -34 or -16, 1, 0),
				Position = UDim2.new(0, icon and 30 or 8, 0, 0),
				ZIndex = zIndex + 1
			})
			self:Bind(button.MouseEnter, function()
				TweenService:Create(button, TweenInfo.new(0.14, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
			end)
			self:Bind(button.MouseLeave, function()
				TweenService:Create(button, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = options and options.BackgroundTransparency or 0.08}):Play()
			end)
			self:Bind(button.MouseButton1Click, function()
				Library:SafeCallback(callback)
			end)
			return button
		end
		function Workspace:SquareButton(parent, icon, callback)
			local zIndex = (parent and parent.ZIndex or 0) + 1
			local button = New("ImageButton", {
				Name = "ATGWorkspaceAction",
				Parent = parent,
				Size = UDim2.fromOffset(22, 22),
				BackgroundTransparency = 0.14,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Image = Library.GetIcon(icon) or icon,
				ZIndex = zIndex,
				ThemeTag = {BackgroundColor3 = "DialogButton", ImageColor3 = "Text"}
			})
			New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = button})
			New("UIStroke", {Transparency = 0.75, Parent = button, ThemeTag = {Color = "DialogButtonBorder"}})
			self:Bind(button.MouseEnter, function()
				TweenService:Create(button, TweenInfo.new(0.14, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
					BackgroundTransparency = 0,
					ImageColor3 = Color3.fromRGB(255, 99, 113)
				}):Play()
			end)
			self:Bind(button.MouseLeave, function()
				TweenService:Create(button, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
					BackgroundTransparency = 0.14,
					ImageColor3 = Creator.GetThemeProperty("Text")
				}):Play()
			end)
			self:Bind(button.MouseButton1Click, function()
				Library:SafeCallback(callback)
			end)
			return button
		end
		function Workspace:ClearList(list)
			for _, child in ipairs(list:GetChildren()) do
				child:Destroy()
			end
			local layout = New("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list})
			layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if list.Parent then
					list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 4)
				end
			end)
			return layout
		end
		function Workspace:ShowPanel(visible)
			if not self.Panel then
				return
			end
			if not visible then
				local hide = TweenService:Create(self.Panel, TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
					GroupTransparency = 1,
					Position = UDim2.fromOffset(12, 78)
				})
				hide:Play()
				hide.Completed:Connect(function()
					if self.Panel and self.Panel.GroupTransparency >= 0.99 then
						self.Panel.Visible = false
					end
				end)
				self.PanelKind = nil
				return
			end
			self.Panel.Visible = true
			self.Panel.GroupTransparency = 1
			self.Panel.Position = UDim2.fromOffset(12, 78)
			TweenService:Create(self.Panel, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				GroupTransparency = 0,
				Position = UDim2.fromOffset(12, 82)
			}):Play()
		end
		function Workspace:BeginPanel(kind, title)
			if not self.Panel then
				return nil
			end
			local reopened = self.PanelKind ~= kind or not self.Panel.Visible
			self.PanelKind = kind
			self.PanelTitle.Text = title
			if reopened then self:ShowPanel(true) end
			self:ClearList(self.PanelContent)
			return self.PanelContent
		end
		function Workspace:RenderEntries(parent, entries, emptyText)
			entries = type(entries) == "table" and entries or {}
			if #entries == 0 then
				self:Text(parent, emptyText or "Nothing here yet.", 12, {
					Color = "SubText",
					Wrapped = true,
					Size = UDim2.new(1, 0, 0, 38)
				})
				return
			end
			for _, entry in ipairs(entries) do
				if type(entry) == "table" then
					local title = tostring(entry.Title or entry.Name or "Untitled")
					local tabTitle = type(entry.TabTitle) == "string" and entry.TabTitle or ""
					local description = type(entry.Description) == "string" and entry.Description or ""
					local entryType = type(entry.Type) == "string" and entry.Type or "Control"
					local subtitle = (tabTitle ~= "" and tabTitle .. "  /  " or "") .. (description ~= "" and description or entryType)
					local row = self:Button(parent, title, nil, function()
						self:Navigate(entry)
						self:ShowPanel(false)
					end, {Height = 42})
				local titleLabel = row:FindFirstChild("Title")
				if titleLabel then
					titleLabel.Size = UDim2.new(1, -42, 0, 18)
					titleLabel.Position = UDim2.fromOffset(8, 3)
				end
				local zIndex = row.ZIndex
				self:Text(row, subtitle, 10, {
					Color = "SubText",
					Size = UDim2.new(1, -42, 0, 16),
					Position = UDim2.fromOffset(8, 21),
					ZIndex = zIndex + 1
				})
				local favorite = New("ImageButton", {
					Name = "Favorite",
					Parent = row,
					Size = UDim2.fromOffset(26, 26),
					Position = UDim2.new(1, -31, 0.5, -13),
					BackgroundTransparency = 1,
					AutoButtonColor = false,
					Image = Library.GetIcon("star"),
					ImageColor3 = self:IsFavorite(entry.Id) and Color3.fromRGB(255, 198, 82) or Creator.GetThemeProperty("SubText"),
					ZIndex = zIndex + 2
				})
				self:Bind(favorite.MouseButton1Click, function()
					if entry.Id then self:ToggleFavorite(entry.Id) end
					if self.PanelKind == "favorites" then self:RenderFavorites() else self:RenderSearch(self.SearchQuery or "") end
				end)
				end
			end
		end
		function Workspace:RenderSearch(query)
			query = type(query) == "string" and query or ""
			-- Keep the legacy method, but route it through the same in-place
			-- filtering path as the sidebar input. No proxy search results exist.
			self:RenderSidebarSearch(query)
		end
		-- Legacy card helpers below are no longer used by live search. Search now
		-- filters the original tabs and original controls in place.
		function Workspace:CreateSearchSurface()
			return nil
		end
		function Workspace:ClearSearchSurface()
			return nil
		end
		function Workspace:AddSearchControlCard(_entry, _order)
			return nil
		end
		function Workspace:RenderSearchSurface()
			-- Compatibility no-op. Sidebar search now works only with the real UI.
			return nil
		end
		function Workspace:RenderSidebarSearch(query)
			query = type(query) == "string" and query or ""
			self.SearchQuery = query
			local trimmed = workspaceTrim(query)
			if not self.Window then return end
			if trimmed == "" then
				self.SearchActive, self.SearchMatchedTabs, self.SearchMatchedEntries, self.SearchDirectTabs = false, {}, {}, {}
				self:RestoreSearchControlVisibility()
				if self.Window.TabSelector then self.Window.TabSelector.Visible = true end
				self:ApplyModes()
				return
			end
			local found = self:FindEntries(trimmed)
			local matchedTabs, directTabs, matchedEntries = {}, {}, {}
			for _, tab in ipairs(self.Tabs) do
				if self:TabMatchesSearch(tab, trimmed) then
					matchedTabs[tab.Id], directTabs[tab.Id] = true, true
				end
			end
			for _, entry in ipairs(found) do
				if entry.Tab and entry.Tab.Id then matchedTabs[entry.Tab.Id] = true end
				if entry.Type ~= "Tab" and entry.Id then matchedEntries[entry.Id] = true end
			end
			self.SearchActive, self.SearchMatchedTabs = true, matchedTabs
			self.SearchMatchedEntries, self.SearchDirectTabs = matchedEntries, directTabs
			if self.Window.TabSelector then self.Window.TabSelector.Visible = true end
			self:ApplyModes()
			local selected
			for _, tab in ipairs(self.Tabs) do
				if tab.Selected then selected = tab break end
			end
			if not selected or not matchedTabs[selected.Id] then
				local candidates = {}
				for _, tab in ipairs(self.Tabs) do
					if matchedTabs[tab.Id] then table.insert(candidates, tab) end
				end
				table.sort(candidates, function(left, right)
					return (left.Frame and left.Frame.LayoutOrder or 0) < (right.Frame and right.Frame.LayoutOrder or 0)
				end)
				if candidates[1] and type(candidates[1].Select) == "function" then
					candidates[1]:Select()
					return
				end
			end
			self:ApplySearchControlVisibility(selected)
		end
		function Workspace:QueueSidebarSearch(query)
			query = type(query) == "string" and query or ""
			self.SearchRenderRevision = (self.SearchRenderRevision or 0) + 1
			local revision = self.SearchRenderRevision
			local function run()
				if revision ~= self.SearchRenderRevision then return end
				local ok, err = pcall(function() self:RenderSidebarSearch(query) end)
				if not ok then warn("[ATG Workspace] Search error: " .. tostring(err)) end
			end
			if workspaceTrim(query) == "" then
				run()
			else
				-- Avoid re-filtering every tab/control for every keystroke while
				-- keeping the delay too small to feel anything but instant.
				task.delay(0.08, run)
			end
		end
		function Workspace:RenderFavorites()
			local content, entries = self:BeginPanel("favorites", "Favorites"), {}
			for _, id in ipairs(self.State.Favorites) do
				local item = self.EntryById[id] or self.TabById[id]
				if item then
					if item.Type == "Tab" then
						table.insert(entries, {Id = item.Id, Title = item.Name, Description = "Tab", Type = "Tab", Tab = item})
					else
						table.insert(entries, item)
					end
				end
			end
			if content then self:RenderEntries(content, entries, "Search a control, then use the star to pin it here.") end
		end
		function Workspace:RenderRecent()
			local content = self:BeginPanel("recent", "Recent")
			if content then self:RenderEntries(content, self:FindEntries(""), "Your recent controls appear here.") end
		end
		function Workspace:RenderHistory()
			local content = self:BeginPanel("history", "Notification history")
			if not content then return end
			if #self.Notifications == 0 then
				self:Text(content, "New notifications are saved here for this session.", 12, {
					Color = "SubText", Wrapped = true, Size = UDim2.new(1, 0, 0, 38)
				})
				return
			end
			for _, notification in ipairs(self.Notifications) do
				local row = self:Button(content, notification.Title, "history", function() end, {Height = 41})
				local titleLabel = row:FindFirstChild("Title")
				if titleLabel then titleLabel.Size = UDim2.new(1, -38, 0, 18); titleLabel.Position = UDim2.fromOffset(30, 3) end
				self:Text(row, notification.Content, 10, {
					Color = "SubText", Size = UDim2.new(1, -38, 0, 16), Position = UDim2.fromOffset(30, 21), ZIndex = row.ZIndex + 1
				})
			end
		end
		function Workspace:RenderProfiles()
			local content = self:BeginPanel("profiles", "Profiles")
			if not content then return end
			local storage = self:GetStorage()
			if not storage or type(storage.CanUseFiles) ~= "function" or not storage:CanUseFiles() then
				self:Text(content, "Session only - this executor cannot save files.", 10, {
					Color = Color3.fromRGB(187, 150, 103), Size = UDim2.new(1, 0, 0, 17)
				})
			end
			local nameBox = New("TextBox", {
				Name = "ProfileName", Parent = content, Size = UDim2.new(1, 0, 0, 30),
				BackgroundTransparency = 0.04, BorderSizePixel = 0, ClearTextOnFocus = false, Text = self.ProfileDraft or "", PlaceholderText = "Profile name",
				ThemeTag = {BackgroundColor3 = "DialogInput", TextColor3 = "Text", PlaceholderColor3 = "SubText"}, TextSize = 12,
				FontFace = Creator.Font(Enum.FontWeight.Regular, Enum.FontStyle.Normal), TextXAlignment = Enum.TextXAlignment.Left, I18nSkip = true, ZIndex = content.ZIndex + 1
			})
			New("UICorner", {CornerRadius = UDim.new(0, 7), Parent = nameBox})
			New("UIPadding", {PaddingLeft = UDim.new(0, 9), PaddingRight = UDim.new(0, 9), Parent = nameBox})
			New("UIStroke", {Transparency = 0.62, Parent = nameBox, ThemeTag = {Color = "DialogButtonBorder"}})
			self:Bind(nameBox.FocusLost, function() self.ProfileDraft = nameBox.Text end)
			self:Button(content, "Save current settings", "bookmark-plus", function()
				self.ProfileDraft = nameBox.Text
				local saved, saveError = self:SaveProfile(nameBox.Text)
				if saved then
					Library:Notify {Title = "Profiles", Content = "Profile saved.", Duration = 2}
					self:RenderProfiles()
				else
					Library:Notify {Title = "Profiles", Content = saveError, Duration = 3}
				end
			end)
			local recent = {}
			for _, name in ipairs(self.State.RecentProfiles) do
				if self.State.Profiles[name] then table.insert(recent, name) end
			end
			if #recent > 0 then
				self:Text(content, "Recent profiles", 10, {
					Color = "SubText", Weight = Enum.FontWeight.SemiBold, Size = UDim2.new(1, 0, 0, 18)
				})
				for _, name in ipairs(recent) do
					self:Button(content, name, "history", function()
						local applied, applyError = self:ApplyProfile(name)
						Library:Notify {Title = "Profiles", Content = applied and ("Applied " .. name) or applyError, Duration = 2}
						self:ShowPanel(false)
					end)
				end
			end
			local names = {}
			for name in pairs(self.State.Profiles) do table.insert(names, name) end
			table.sort(names)
			for _, name in ipairs(names) do
				local row = self:Button(content, name, "bookmark", function()
					local applied, applyError = self:ApplyProfile(name)
					Library:Notify {Title = "Profiles", Content = applied and ("Applied " .. name) or applyError, Duration = 2}
					self:ShowPanel(false)
				end)
				local deleteButton = New("ImageButton", {
					Parent = row, Size = UDim2.fromOffset(24, 24), Position = UDim2.new(1, -29, 0.5, -12), BackgroundTransparency = 1,
					Image = Library.GetIcon("x"), ImageColor3 = Color3.fromRGB(190, 130, 138), AutoButtonColor = false, ZIndex = row.ZIndex + 2
				})
				self:Bind(deleteButton.MouseButton1Click, function()
					self:Confirm({Title = "Delete profile", Content = "Remove " .. name .. "?", ConfirmText = "Delete"}, function()
						self.State.Profiles[name] = nil
						self:SaveSoon()
						self:RenderProfiles()
					end)
				end)
			end
		end
		function Workspace:RenderWorkspaceMenu()
			local content = self:BeginPanel("workspace", "Workspace")
			if not content then return end
			self:Button(content, "Compact sidebar: " .. (self.State.CompactMode and "On" or "Off"), "layout", function()
				self:SetCompact(not self.State.CompactMode)
				self:RenderWorkspaceMenu()
			end)
			self:Button(content, "Focus current tab: " .. (self.State.FocusMode and "On" or "Off"), "focus", function()
				self:SetFocus(not self.State.FocusMode)
				self:RenderWorkspaceMenu()
			end)
			self:Button(content, "Smart confirmations: " .. (self.State.SmartConfirm == false and "Off" or "On"), "shield-check", function()
				self.State.SmartConfirm = not self.State.SmartConfirm
				self:SaveSoon()
				self:RenderWorkspaceMenu()
			end)
			self:Button(content, "Recent controls", "history", function() self:RenderRecent() end)
		end
		function Workspace:RefreshSurface()
			if self.SearchActive then self:RenderSidebarSearch(self.SearchQuery or "") end
			if self.PanelKind == "search" then self:RenderSearch(self.SearchQuery or "")
			elseif self.PanelKind == "favorites" then self:RenderFavorites()
			elseif self.PanelKind == "history" then self:RenderHistory()
			elseif self.PanelKind == "profiles" then self:RenderProfiles()
			elseif self.PanelKind == "workspace" then self:RenderWorkspaceMenu() end
		end
		function Workspace:CreatePanel()
			local window = self.Window
			self.Panel = New("CanvasGroup", {
				Name = "ATGWorkspacePanel", Parent = window.Root, Size = UDim2.new(0, self.OriginalTabWidth, 0, 260),
				Position = UDim2.fromOffset(12, 82), ThemeTag = {BackgroundColor3 = "DropdownHolder"},
				BackgroundTransparency = 0.02, BorderSizePixel = 0, Visible = false, GroupTransparency = 1, ZIndex = 35
			})
			New("UICorner", {CornerRadius = UDim.new(0, 9), Parent = self.Panel})
			New("UIStroke", {Transparency = 0.35, Parent = self.Panel, ThemeTag = {Color = "Accent"}})
			self.PanelTitle = self:Text(self.Panel, "Workspace", 13, {
				Weight = Enum.FontWeight.SemiBold, Size = UDim2.new(1, -38, 0, 34), Position = UDim2.fromOffset(10, 0), ZIndex = 36
			})
			local closeButton = New("ImageButton", {
				Name = "Close", Parent = self.Panel, Size = UDim2.fromOffset(22, 22), Position = UDim2.new(1, -27, 0, 6),
				BackgroundTransparency = 1, Image = Library.GetIcon("x"), ThemeTag = {ImageColor3 = "SubText"}, AutoButtonColor = false, ZIndex = 37
			})
			self:Connect(closeButton.MouseButton1Click, function() self:ShowPanel(false) end)
			self.PanelContent = New("ScrollingFrame", {
				Name = "Content", Parent = self.Panel, Size = UDim2.new(1, -16, 1, -46), Position = UDim2.fromOffset(8, 38),
				BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(), ScrollBarThickness = 3,
				ThemeTag = {ScrollBarImageColor3 = "Accent"}, ScrollBarImageTransparency = 0.42, ZIndex = 36
			})
		end
		function Workspace:CreateChrome()
			local window = self.Window
			self.Sidebar = New("Frame", {
				Name = "ATGWorkspaceSidebar", Parent = window.Root, Size = UDim2.new(0, self.OriginalTabWidth, 0, 26),
				Position = UDim2.fromOffset(12, 56), BackgroundTransparency = 1, ZIndex = 20
			})
			self.SidebarSearch = New("TextBox", {
				Name = "Search", Parent = self.Sidebar, Size = UDim2.new(1, 0, 0, 26), Position = UDim2.fromOffset(0, 0),
				BackgroundTransparency = 0.52, BorderSizePixel = 0, ClearTextOnFocus = false,
				Text = "", PlaceholderText = "Search...  Ctrl+K",
				ThemeTag = {BackgroundColor3 = "Element", TextColor3 = "Text", PlaceholderColor3 = "SubText"},
				TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, FontFace = Creator.Font(Enum.FontWeight.Regular, Enum.FontStyle.Normal), I18nSkip = true, ZIndex = 21
			})
			New("UICorner", {CornerRadius = UDim.new(0, 7), Parent = self.SidebarSearch})
			local searchStroke = New("UIStroke", {Transparency = 0.58, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = self.SidebarSearch, ThemeTag = {Color = "InElementBorder"}})
			self:Connect(self.SidebarSearch.Focused, function()
				Creator.OverrideTag(searchStroke, {Color = "Accent"})
				Creator.SpringValue(searchStroke, "Transparency", 0.25, 10, 1)
			end)
			self:Connect(self.SidebarSearch.FocusLost, function()
				Creator.OverrideTag(searchStroke, {Color = "InElementBorder"})
				Creator.SpringValue(searchStroke, "Transparency", 0.58, 10, 1)
			end)
			New("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = self.SidebarSearch})
			self:UpdateSearchHint()
			self:Connect(self.SidebarSearch:GetPropertyChangedSignal("Text"), function()
				local text = self.SidebarSearch.Text
				self:QueueSidebarSearch(text)
			end)
			local reserve = window.SidebarFooterReserve or 98
			window.TabArea.Position = UDim2.new(0, 12, 0, 92)
			window.TabArea.Size = UDim2.new(0, self.OriginalTabWidth, 1, -(92 + reserve))
			self:CreatePanel()
		end
		-- The command palette was replaced by the sidebar search, which shows
		-- the real controls. These stay as no-ops for old callers.
		function Workspace:CreatePalette()
			return nil
		end
		function Workspace:RenderPalette(_query)
			return nil
		end
		function Workspace:ClosePalette()
			return nil
		end
		function Workspace:OpenPalette()
			-- Compatibility alias: Ctrl+K used to open an artificial result panel.
			-- It now focuses the real sidebar search so results stay as real UI.
			if self.State.CompactMode then self:SetCompact(false) end
			self:ShowPanel(false)
			task.defer(function()
				if self.SidebarSearch and self.SidebarSearch.Parent then
					self.SidebarSearch:CaptureFocus()
				end
			end)
		end
		function Workspace:Attach(window)
			if self.Window then return self end
			self.Window = window
			self.OriginalTabWidth = tonumber(window.TabWidth) or 180
			self:Load()
			-- Sidebar search box is opt-in only via SidebarSearch = true so the sidebar
			-- stays clean and uncluttered (Acryven v3.0 collapsible/resizable sidebar).
			self.SearchEnabled = Library.SidebarSearchEnabled == true
			if self.SearchEnabled then
				self:CreateChrome()
			end
			self:SetCompact(self.State.CompactMode)
			self:SetFocus(self.State.FocusMode)
			self:Connect(UserInputService.InputBegan, function(input, gameProcessed)
				if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
				if not gameProcessed and input.KeyCode == Enum.KeyCode.K and not UserInputService:GetFocusedTextBox() and
					(UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
					if self.SearchEnabled then
						self:OpenPalette()
					elseif Library.CommandPalette then
						Library.CommandPalette:Toggle()
					end
				end
			end)
			self:Connect(UserInputService.InputChanged, function(input)
				if not self.Drag or not (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then return end
				local delta = input.Position - self.Drag.Start
				if delta.Magnitude > 6 then
					self.Drag.Moved = true
					self:MoveDraggingTab(input.Position.Y)
				end
			end)
			self:Connect(UserInputService.InputEnded, function(input)
				if self.Drag and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
					if self.Drag.Moved and self.Drag.Tab then self.Drag.Tab.SuppressClick = true end
					self.Drag = nil
				end
			end)
			return self
		end
		function Workspace:Destroy()
			for _, connection in ipairs(self.Connections) do pcall(function() connection:Disconnect() end) end
			self.Connections = {}
			self.Window = nil
			self.Tabs, self.TabById, self.Entries, self.EntryById = {}, {}, {}, {}
			self.Sidebar, self.SidebarSearch = nil, nil
			self.Panel, self.PanelContent, self.PanelTitle = nil, nil, nil
			self.SearchMatchedTabs = nil
		end
		-- Built-in floating minimize/open button. This replaces the old
		-- per-script FluentToggleGui snippet and talks to this window directly
		-- instead of scanning every ScreenGui in CoreGui.
		local FloatingToggleDefaults = {
			Enabled = true,
			-- If a legacy ATG/Fluent script creates its own marked button, keep
			-- that one instead of showing two floating toggles.
			RespectExistingToggle = true,
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
				PulseSpeed = 1,
				HueSpeed = 0.09,
				Saturation = 0.95,
				Value = 1,
				BaseTransparency = 0.05,
				PulseTransparency = 0.12
			},
			Keybind = {
				Enabled = true,
				Key = Enum.KeyCode.M,
				Modifier = Enum.KeyCode.LeftControl
			}
		}
		local function mergeFloatingToggleConfig(defaults, overrides)
			local merged = {}
			for key, value in pairs(defaults or {}) do
				if type(value) == "table" then
					merged[key] = mergeFloatingToggleConfig(value, type(overrides) == "table" and overrides[key] or nil)
				elseif type(overrides) == "table" and overrides[key] ~= nil then
					merged[key] = overrides[key]
				else
					merged[key] = value
				end
			end
			if type(overrides) == "table" then
				for key, value in pairs(overrides) do
					if merged[key] == nil then
						merged[key] = value
					end
				end
			end
			return merged
		end
		local function getFloatingToggleConfig(overrides)
			local globalConfig
			if type(getgenv) == "function" then
				local ok, environment = pcall(getgenv)
				if ok and type(environment) == "table" and type(environment.ATGButtonUI) == "table" then
					globalConfig = environment.ATGButtonUI
				end
			end
			local config = mergeFloatingToggleConfig(mergeFloatingToggleConfig(FloatingToggleDefaults, globalConfig), overrides)
			local function keyCodeOrDefault(value, fallback)
				return safeEnumItem(Enum.KeyCode, value) or fallback
			end
			config.Keybind.Key = keyCodeOrDefault(config.Keybind.Key, FloatingToggleDefaults.Keybind.Key)
			config.Keybind.Modifier = keyCodeOrDefault(config.Keybind.Modifier, FloatingToggleDefaults.Keybind.Modifier)
			return config
		end
		local function floatingToggleSize(config)
			local size = UserInputService.TouchEnabled and config.ButtonSize.Min or config.ButtonSize.Max
			return UDim2.fromOffset(tonumber(size) or 42, tonumber(size) or 42)
		end
		local function floatingTogglePosition(config)
			local xScale, xOffset, anchorX
			if config.Position.Horizontal == "right" then
				xScale, xOffset, anchorX = 1, -(tonumber(config.Position.OffsetX) or 140), 1
			elseif config.Position.Horizontal == "center" then
				xScale, xOffset, anchorX = 0.5, 0, 0.5
			else
				xScale, xOffset, anchorX = 0, tonumber(config.Position.OffsetX) or 140, 0
			end
			local yScale, yOffset, anchorY
			if config.Position.Vertical == "bottom" then
				yScale, yOffset, anchorY = 1, -(tonumber(config.Position.OffsetY) or 140), 1
			elseif config.Position.Vertical == "center" then
				yScale, yOffset, anchorY = 0.5, 0, 0.5
			else
				yScale, yOffset, anchorY = 0, tonumber(config.Position.OffsetY) or 140, 0
			end
			return UDim2.new(xScale, xOffset, yScale, yOffset), Vector2.new(anchorX, anchorY)
		end
		local LegacyFloatingToggleNames = {
			FluentToggleGui = true,
			ATGToggleGui = true,
			ATGFloatingToggleGui = true
		}
		local function isLegacyFloatingToggle(candidate)
			local matches = false
			pcall(function()
				matches = candidate and candidate:IsA("ScreenGui") and candidate ~= gui and LegacyFloatingToggleNames[candidate.Name] == true
			end)
			return matches
		end
		local function getLegacyFloatingToggleParents()
			local parents = {}
			pcall(function()
				table.insert(parents, game:GetService("CoreGui"))
			end)
			pcall(function()
				local player = game:GetService("Players").LocalPlayer
				local playerGui = player and player:FindFirstChildOfClass("PlayerGui")
				if playerGui then
					table.insert(parents, playerGui)
				end
			end)
			return parents
		end
		-- Removes floating toggles left by older ATG scripts. Only exact names in
		-- LegacyFloatingToggleNames are removed, never other scripts' GUIs.
		local function removeLegacyFloatingToggles()
			for _, parent in ipairs(getLegacyFloatingToggleParents()) do
				for _, child in ipairs(parent:GetChildren()) do
					if isLegacyFloatingToggle(child) then
						pcall(function()
							child:Destroy()
						end)
					end
				end
			end
			if getgenv then
				pcall(function()
					local environment = getgenv()
					environment.ATGButtonUI = nil
					environment.FluentToggleGui = nil
					environment.ATGButtonUI_Running = false
				end)
			end
		end
		local function hasLegacyFloatingToggle()
			for _, parent in ipairs(getLegacyFloatingToggleParents()) do
				for name in pairs(LegacyFloatingToggleNames) do
					local child = parent:FindFirstChild(name)
					if isLegacyFloatingToggle(child) then
						return true
					end
				end
			end
			return false
		end
		function Library.CreateFloatingToggle(_, overrides)
			if Library.FloatingToggle then
				Library.FloatingToggle:Destroy()
			end
			local config = getFloatingToggleConfig(overrides)
			local shouldShow = config.Enabled ~= false and
				(config.ForceShowButton or not UserInputService.KeyboardEnabled or (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled) or
					(UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled))
			if not shouldShow then
				return nil
			end
			if config.RespectExistingToggle ~= false and hasLegacyFloatingToggle() then
				return nil
			end

			local button = Instance.new("ImageButton")
			button.Name = "ATGFloatingToggleButton"
			button.Size = floatingToggleSize(config)
			button.Position, button.AnchorPoint = floatingTogglePosition(config)
			button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			button.BackgroundTransparency = 0
			button.BorderSizePixel = 0
			button.Image = tostring(config.ImageId or "")
			button.Active = true
			button.AutoButtonColor = true
			button.ZIndex = 1000
			button.Parent = gui
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 8)
			corner.Parent = button
			local stroke = Instance.new("UIStroke")
			stroke.Name = "ATGFloatingToggleStroke"
			stroke.Thickness = tonumber(config.Stroke.BaseThickness) or 1
			stroke.Transparency = tonumber(config.Stroke.BaseTransparency) or 0.05
			stroke.LineJoinMode = Enum.LineJoinMode.Round
			stroke.ZIndex = 1000
			stroke.Parent = button

			local dragStateConnection
			local toggle = {
				Button = button,
				Stroke = stroke,
				Config = config,
				Connections = {},
				Destroyed = false
			}
			local function track(connection)
				table.insert(toggle.Connections, connection)
				return connection
			end
			local function clampToViewport()
				if not button.Parent then
					return
				end
				local camera = game:GetService("Workspace").CurrentCamera
				local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
				local width, height = button.AbsoluteSize.X, button.AbsoluteSize.Y
				if width <= 0 or height <= 0 then
					return
				end
				local clampedX = math.clamp(button.AbsolutePosition.X, 0, math.max(0, viewport.X - width))
				local clampedY = math.clamp(button.AbsolutePosition.Y, 0, math.max(0, viewport.Y - height))
				if math.abs(clampedX - button.AbsolutePosition.X) > 0.5 or math.abs(clampedY - button.AbsolutePosition.Y) > 0.5 then
					button.AnchorPoint = Vector2.new(0, 0)
					button.Position = UDim2.fromOffset(clampedX, clampedY)
				end
			end
			function toggle.Toggle()
				if Library.Window and type(Library.Window.Minimize) == "function" then
					Library.Window:Minimize()
				elseif Library.Window and Library.Window.Root then
					Library.Window.Root.Visible = not Library.Window.Root.Visible
				end
			end
			function toggle.Destroy()
				if toggle.Destroyed then
					return
				end
				toggle.Destroyed = true
				if dragStateConnection then
					pcall(function()
						dragStateConnection:Disconnect()
					end)
					dragStateConnection = nil
				end
				for _, connection in ipairs(toggle.Connections) do
					pcall(function()
						connection:Disconnect()
					end)
				end
				toggle.Connections = {}
				if button then
					pcall(function()
						button:Destroy()
					end)
				end
				if Library.FloatingToggle == toggle then
					Library.FloatingToggle = nil
				end
			end
			Library.FloatingToggle = toggle
			if config.RespectExistingToggle ~= false then
				for _, parent in ipairs(getLegacyFloatingToggleParents()) do
					track(
						parent.ChildAdded:Connect(function(child)
							if isLegacyFloatingToggle(child) and not toggle.Destroyed then
								toggle:Destroy()
							end
						end)
					)
				end
			end

			local dragging, dragStart, startPosition, moved = false, nil, nil, nil
			track(
				button.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						if dragStateConnection then
							pcall(function()
								dragStateConnection:Disconnect()
							end)
							dragStateConnection = nil
						end
						dragging = true
						dragStart = input.Position
						startPosition = button.Position
						moved = false
						dragStateConnection = input.Changed:Connect(function()
							if input.UserInputState == Enum.UserInputState.End then
								dragging = false
								clampToViewport()
								local connection = dragStateConnection
								dragStateConnection = nil
								if connection then
									pcall(function()
										connection:Disconnect()
									end)
								end
							end
						end)
					end
				end)
			)
			track(
				UserInputService.InputChanged:Connect(function(input)
					if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragStart and startPosition then
						local delta = input.Position - dragStart
						if delta.Magnitude > 6 then
							moved = true
						end
						button.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
					end
				end)
			)
			track(
				button.Activated:Connect(function()
					if moved then
						moved = false
						return
					end
					toggle.Toggle()
				end)
			)
			local elapsed = 0
			-- Stroke animation (20 Hz). Heartbeat does not hold up rendering the
			-- way RenderStepped does, and nothing is written while hidden.
			track(
				RunService.Heartbeat:Connect(function(deltaTime)
					elapsed = elapsed + deltaTime
					if elapsed < 0.05 or not stroke.Parent or not button.Visible or not gui.Enabled then
						return
					end
					elapsed = 0
					local now = os.clock()
					local hue = (now * (tonumber(config.Stroke.HueSpeed) or 0.09)) % 1
					local pulse = (math.sin(now * (tonumber(config.Stroke.PulseSpeed) or 1) * math.pi * 2) + 1) / 2
					stroke.Color = Color3.fromHSV(hue, tonumber(config.Stroke.Saturation) or 0.95, tonumber(config.Stroke.Value) or 1)
					stroke.Thickness = (tonumber(config.Stroke.BaseThickness) or 1) + pulse * (tonumber(config.Stroke.PulseThickness) or 1.5)
					stroke.Transparency =
						(tonumber(config.Stroke.BaseTransparency) or 0.05) + pulse * (tonumber(config.Stroke.PulseTransparency) or 0.12)
				end)
			)
			local camera = game:GetService("Workspace").CurrentCamera
			if camera then
				track(
					camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
						button.Size = floatingToggleSize(config)
						clampToViewport()
					end)
				)
			end
			if config.Keybind.Enabled ~= false and UserInputService.KeyboardEnabled then
				track(
					UserInputService.InputBegan:Connect(function(input, gameProcessed)
						if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and
							input.KeyCode == config.Keybind.Key and not UserInputService:GetFocusedTextBox() and
							UserInputService:IsKeyDown(config.Keybind.Modifier) then
							toggle.Toggle()
						end
					end)
				)
			end
			task.defer(clampToViewport)
			return toggle
		end
		function Library.SetFloatingToggleConfig(_, config)
			if config == false then
				if Library.FloatingToggle then
					Library.FloatingToggle:Destroy()
				end
				return nil
			end
			return Library:CreateFloatingToggle(config)
		end
		-- Button titles that ask for confirmation with CreateWindow{SmartConfirm = true}.
		local DestructiveWords = {"delete", "remove", "reset", "clear", "wipe", "shutdown", "rejoin", "leave"}
		local function looksDestructive(title)
			title = tostring(title or ""):lower()
			for _, word in ipairs(DestructiveWords) do
				if title:find("%f[%w]" .. word .. "%f[%W]") then
					return true
				end
			end
			return false
		end
		local mountBurstStart = 0
		local mountLastAt = 0
		local mountBurstItems = 0
		local mountYieldNext = false
		local function armPostWindowYield()
			mountBurstStart = os.clock()
			mountLastAt = mountBurstStart
			mountBurstItems = 0
			mountYieldNext = true
		end
		local function budgetYieldMount()
			if Library.AutoYieldMount == false then
				return
			end
			local budgetMs = tonumber(Library.MountBudgetMs) or 6
			local batchCap = tonumber(Library.MountBatchCap) or 10
			if budgetMs <= 0 and batchCap <= 0 then
				return
			end
			local now = os.clock()
			if mountYieldNext then
				mountYieldNext = false
				if (now - mountLastAt) <= 0.05 and type(coroutine.isyieldable) == "function" and coroutine.isyieldable() then
					task.wait()
					mountBurstStart = os.clock()
					mountLastAt = mountBurstStart
					mountBurstItems = 1
					return
				end
			end
			if now - mountLastAt > 0.05 then
				mountBurstStart = now
				mountBurstItems = 0
			end
			mountLastAt = now
			mountBurstItems += 1
			local timeExceeded = budgetMs > 0 and (now - mountBurstStart) >= (budgetMs / 1000)
			local countExceeded = batchCap > 0 and mountBurstItems >= batchCap
			if (timeExceeded or countExceeded) and type(coroutine.isyieldable) == "function" and coroutine.isyieldable() then
				task.wait()
				mountBurstStart = os.clock()
				mountLastAt = mountBurstStart
				mountBurstItems = 0
			end
		end

		local DependencyBoxFactory = requireModule(Components.DependencyBox)
		local RowFactory = requireModule(Components.Row)
		local SubTabsFactory = requireModule(Components.SubTabs)

		local function copyToClipboardSafe(text)
			local fn = setclipboard or toclipboard or (syn and syn.write_clipboard)
			if type(fn) == "function" then
				pcall(fn, tostring(text))
			end
		end

		local Elements = {}
		Elements.__index = Elements
		Elements.__namecall = function(_, methodName, ...)
			return Elements[methodName](...)
		end

		function Elements.AddDependencyBox(parent, config)
			budgetYieldMount()
			return DependencyBoxFactory(parent, config)
		end
		function Elements.AddRow(parent, config)
			budgetYieldMount()
			return RowFactory(parent, config)
		end
		Elements.AddHStack = Elements.AddRow
		function Elements.AddColumns(parent, countOrConfig)
			budgetYieldMount()
			if type(countOrConfig) == "number" then
				return RowFactory(parent, {Columns = countOrConfig})
			end
			local cfg = type(countOrConfig) == "table" and countOrConfig or {}
			if not cfg.Columns then
				cfg.Columns = 2
			end
			return RowFactory(parent, cfg)
		end
		function Elements.AddSubTabs(parent, config)
			budgetYieldMount()
			return SubTabsFactory(parent, config)
		end

		for _, elementModule in ipairs(elementModules) do
			Elements["Add" .. elementModule.__type] = function(parent, key, config)
				budgetYieldMount()
				elementModule.Container = parent.Container
				elementModule.Type = parent.Type
				elementModule.ScrollFrame = parent.ScrollFrame
				elementModule.Library = Library
				local options = type(config) == "table" and config or (type(key) == "table" and key or nil)
				local isInternal = (parent and parent._Internal == true) or (options and options._Internal == true)
				if isInternal and type(options) == "table" then
					options._Internal = true
				end
				-- Confirmation is explicit (Confirm = true/string/table). Guessing it
				-- from a destructive word in the title is opt-in with
				-- CreateWindow{SmartConfirm = true}; SmartConfirm = false on a
				-- button opts that button out.
				local confirm = options and options.Confirm
				if elementModule.__type == "Button" and options and confirm == nil and Library.SmartConfirm == true
					and options.SmartConfirm ~= false and looksDestructive(options.Title) then
					confirm = {Title = "Please confirm", Content = "Continue with " .. tostring(options.Title) .. "?"}
				end
				if elementModule.__type == "Button" and options and confirm and type(options.Callback) == "function" and not options._ATGConfirmWrapped then
					options._ATGConfirmWrapped = true
					local callback = options.Callback
					options.Callback = function(...)
						return Library.Workspace:Confirm(confirm, callback, ...)
					end
				end
				local element = elementModule:New(key, config)
				if isInternal and type(key) == "string" and Library.Options[key] == element then
					Library.Options[key] = nil
				end
				local entry = nil
				if Library.Workspace and not isInternal then
					entry = Library.Workspace:RegisterElement(element, parent, options, elementModule.__type, type(key) == "string" and key or nil)
				end
				-- Auto-attach Tooltip if provided in element options
				if options and type(options.Tooltip) == "string" and options.Tooltip ~= "" and element and element.Frame then
					Library:AttachTooltip(element.Frame, options.Tooltip)
				end
				-- Auto-attach ContextMenu on interactive elements (right-click Reset / Copy / Favorite)
				if not isInternal and options and options.ContextMenu ~= false and element and element.Frame and (type(element.SetValue) == "function" or type(element.SetValueRGB) == "function") then
					local defaultVal = options.Default
					local defaultAlpha = options.Transparency
					Library:AttachContextMenu(element.Frame, function()
						local items = {}
						if defaultVal ~= nil then
							table.insert(items, {
								Title = "Reset to Default",
								Icon = "refresh-cw",
								Callback = function()
									if element.Type == "Colorpicker" and type(element.SetValueRGB) == "function" and typeof(defaultVal) == "Color3" then
										element:SetValueRGB(defaultVal, defaultAlpha)
									elseif type(element.SetValue) == "function" then
										element:SetValue(defaultVal)
									end
								end
							})
						end
						table.insert(items, {
							Title = "Copy Title",
							Icon = "copy",
							Callback = function()
								copyToClipboardSafe(options.Title or element.Type)
							end
						})
						if entry and entry.Id and Library.Workspace then
							local isFav = Library.Workspace:IsFavorite(entry.Id)
							table.insert(items, {
								Title = isFav and "Remove Favorite" or "Pin Favorite",
								Icon = "star",
								Callback = function()
									Library.Workspace:ToggleFavorite(entry.Id)
								end
							})
						end
						return items
					end)
				end
				return element
			end
		end
		Library.Elements = Elements
		function Library.CreateWindow(_, config)
			assert(config.Title, "Window - Missing Title")
			if Library.Unloaded then
				warn "CreateWindow: the interface was destroyed; load the library again to create a new window."
				return nil
			end
			if Library.Window then
				warn "CreateWindow: a window already exists; returning it."
				return Library.Window
			end
			-- Optional and additive: old CreateWindow calls continue to work.
			-- InterfaceManager normally configures this later, but accepting it
			-- here gives standalone scripts an early, flicker-free setup path.
			if type(config.I18n) == "table" or type(config.Customization) == "table" then
				local customization = config.I18n or config.Customization
				CustomizationSystem:Configure {
					Folder = customization.Folder,
					ScriptId = customization.ScriptId,
					SourceLocale = customization.SourceLocale,
					Locale = customization.Locale,
					Mode = customization.Mode,
					Enabled = customization.Enabled,
					EnableRemoteAssets = customization.EnableRemoteAssets,
					FontProfile = customization.FontProfile,
					FontTuning = customization.FontTuning
				}
			end
			Library.CurrentLanguage = CustomizationSystem.I18n.CurrentLocale
			if config.MinimizeKey ~= nil then
				Library.MinimizeKey = safeEnumItem(Enum.KeyCode, config.MinimizeKey) or Library.MinimizeKey
			end
			-- Opt-in extras (all off for scripts written before they existed).
			Library.SmartConfirm = config.SmartConfirm == true
			Library.SearchEnabled = config.Search == true
			Library.SidebarSearchEnabled = config.SidebarSearch == true
			if config.AutoYieldMount ~= nil then
				Library.AutoYieldMount = config.AutoYieldMount == true
			end
			if type(config.MountBudgetMs) == "number" then
				Library.MountBudgetMs = config.MountBudgetMs
			end
			if type(config.MountBatchCap) == "number" then
				Library.MountBatchCap = config.MountBatchCap
			end
			if config.ReducedMotion ~= nil then
				Library:SetReducedMotion(config.ReducedMotion == true)
			end
			if type(config.DPIScale) == "number" then
				Library:SetDPIScale(config.DPIScale)
			end
			if type(config.NotifySide) == "string" then
				Library:SetNotifySide(config.NotifySide)
			end
			if config.Theme and table.find(Library.Themes, config.Theme) then
				Library.Theme = config.Theme
			end
			if config.Splash == true then
				showSplash()
			end
			Library.UseAcrylic = config.Acrylic == true
			Library.Acrylic = Library.UseAcrylic
			if Library.UseAcrylic then
				Acrylic.init()
			end
			if config.HidePlayerName ~= nil or config.PrivacyAlias ~= nil or config.HideAvatar ~= nil then
				Library:SetPrivacyMode(config.HidePlayerName, config.PrivacyAlias, config.HideAvatar)
			end
			local window =
				requireModule(Components.Window) {Parent = gui, Size = config.Size, Title = config.Title, SubTitle = config.SubTitle, TabWidth = config.TabWidth, ShowProfileCard = config.ShowProfileCard}
			window.Library = Library
			Library.Window = window
			if Library.Workspace then
				-- Scripts that never call CustomizationSystem:Configure leave
				-- I18n.Scope at its "shared" default, which made every script's
				-- Favorites / Recent / TabOrder bleed into every other script's
				-- workspace.json. Fall back to Title+SubTitle so each script gets
				-- its own isolated Workspace scope. Title alone is not enough:
				-- every Premium script reuses the same brand string ("ATG Hub
				-- Premium") for Title and puts the actual per-game name in
				-- SubTitle (e.g. "[ The Forge ]"), so Title-only still collapsed
				-- every game back into one shared scope.
				local workspaceScope = CustomizationSystem.I18n.Scope
				if workspaceScope == "shared" then
					local subtitle = type(config.SubTitle) == "string" and config.SubTitle or ""
					workspaceScope = tostring(config.Title or "shared") .. (subtitle ~= "" and (" " .. subtitle) or "")
				end
				Library.Workspace:Configure {ScriptId = workspaceScope}
				Library.Workspace:Attach(window)
			end
			if config.Theme == "RGB" then
				Library:SetTheme(config.Theme)
			end
			armPostWindowYield()
			if config.FloatingPill then
				local pillOpts = type(config.FloatingPill) == "table" and config.FloatingPill or {}
				if not pillOpts.Title then
					pillOpts.Title = config.Title
				end
				Library:CreateFloatingPill(pillOpts)
			end
			local wantsLegacyToggle = (config.FloatingToggle == true) or (type(config.FloatingToggle) == "table") or (config.FloatingToggle == nil and not config.FloatingPill)
			if wantsLegacyToggle then
				local floatingConfig = type(config.FloatingToggle) == "table" and config.FloatingToggle or nil
				-- Give legacy scripts that append FluentToggleGui after CreateWindow
				-- one scheduler turn to register it before we add our own button.
				task.defer(function()
					task.wait(0.25)
					if not Library.Unloaded and Library.Window == window and not Library.FloatingToggle then
						Library:CreateFloatingToggle(floatingConfig)
					end
				end)
			end
			return window
		end
		function Library.SetTheme(_, themeName, instant)
			if Library.Window and table.find(Library.Themes, themeName) then
				Library.Theme = themeName
				Creator.UpdateTheme(instant == true)
			end
		end
		function Library.SetDPIScale(_, scale)
			Library.DPIScale = Creator.SetDPIScale(scale)
			return Library.DPIScale
		end
		function Library.SetReducedMotion(_, enabled)
			Library.ReducedMotion = Creator.SetReducedMotion(enabled == true)
			return Library.ReducedMotion
		end
		function Library.SetNotifySide(_, side)
			Library.NotifySide = Notification:SetSide(side)
			return Library.NotifySide
		end
		function Library.Destroy(_)
			if not Library.Window or Library.Unloaded then
				return
			end
			Library.Unloaded = true
			for _, handler in ipairs(unloadHandlers) do
				if handler.Connected then
					local ok, err = pcall(handler.Callback)
					if not ok then
						warn("OnUnload callback error:", err)
					end
				end
			end
			-- Invalidates and detaches any in-flight/queued translation work.
			CustomizationSystem.I18n:CancelPending()
			CustomizationSystem.I18n:ClearRegistry()
			CustomizationSystem.Fonts:ClearRegistry()
			if Library.Workspace then
				Library.Workspace:Destroy()
			end
			if Library.FloatingToggle then
				Library.FloatingToggle:Destroy()
			end
			if Library.FloatingPill then
				Library.FloatingPill:Destroy()
			end
			if CommandPalette then
				pcall(CommandPalette.Destroy, CommandPalette)
			end
			if TooltipService then
				pcall(TooltipService.Destroy, TooltipService)
			end
			if ContextMenuService then
				pcall(ContextMenuService.Destroy, ContextMenuService)
			end
			if SettingsModalService then
				pcall(SettingsModalService.Destroy, SettingsModalService)
			end
			if ProfileMenuService then
				pcall(ProfileMenuService.Destroy, ProfileMenuService)
			end
			for _, hud in ipairs(Library._ActiveHUDs) do
				if hud and type(hud.Destroy) == "function" then
					pcall(hud.Destroy, hud)
				end
			end
			table.clear(Library._ActiveHUDs)
			table.clear(Library._KeybindLists)
			table.clear(Library._TrackedKeybinds)
			removeLegacyFloatingToggles()
			Library._CloseDropdowns()
			if Library.UseAcrylic then
				if Library.Window and Library.Window.AcrylicPaint and type(Library.Window.AcrylicPaint.Destroy) == "function" then
					pcall(Library.Window.AcrylicPaint.Destroy)
				end
				if type(Acrylic.Destroy) == "function" then
					pcall(Acrylic.Destroy)
				elseif type(Acrylic.Disable) == "function" then
					pcall(Acrylic.Disable)
				end
			end
			Creator.Disconnect()
			Creator.StopRainbow()
			if Library.OverlayGUI then
				pcall(function() Library.OverlayGUI:Destroy() end)
			end
			if Library.NotificationGUI then
				pcall(function() Library.NotificationGUI:Destroy() end)
			end
			Library.GUI:Destroy()
		end
		function Library.ToggleAcrylic(_, enabled)
			if Library.Window then
				if Library.UseAcrylic then
					Library.Acrylic = enabled == true
					if Library.Window.AcrylicPaint and type(Library.Window.AcrylicPaint.SyncVisibility) == "function" then
						Library.Window.AcrylicPaint.SyncVisibility()
					elseif Library.Acrylic then
						Acrylic.Enable()
					else
						Acrylic.Disable()
					end
				end
			end
		end
		function Library.ToggleTransparency(_, enabled)
			if Library.Window then
				Library.Window.AcrylicPaint.Frame.Background.BackgroundTransparency = enabled and 0.32 or 0
			end
		end
		function Library.Notify(_, options)
			if Library.Workspace then
				Library.Workspace:RecordNotification(options)
			end
			return Notification:New(options)
		end
		if getgenv then
			getgenv().Fluent = Library
			getgenv().Acryven = Library
		end
		return Library
	end,
	function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(2)
		local Creator = requireModule(moduleScript.Parent.Creator)
		local Lighting = Creator.GetService("Lighting")
		local Workspace = Creator.GetService("Workspace")

		local Acrylic = {
			AcrylicBlur = requireModule(moduleScript.AcrylicBlur),
			CreateAcrylic = requireModule(moduleScript.CreateAcrylic),
			AcrylicPaint = requireModule(moduleScript.AcrylicPaint),
			BLUR_FOLDER_NAME = "AcryvenBlurLayer",
			DOF_NAME = "AcryvenDoF"
		}

		local baseEffect = nil
		local depthOfFieldDefaults = {}
		local isInitialized = false
		local isEnabled = false

		local function isLegacyFluentDoF(object)
			if not object or not object:IsA("DepthOfFieldEffect") then
				return false
			end
			if object.Name == Acrylic.DOF_NAME then
				return true
			end
			local ok, managed = pcall(function()
				return object:GetAttribute("AcryvenManaged") == true
			end)
			if ok and managed then
				return true
			end
			-- Legacy unnamed Fluent DepthOfFieldEffect fingerprint
			return object.Name == "DepthOfField"
				and object.FarIntensity == 0
				and object.NearIntensity == 1
				and math.abs(object.InFocusRadius - 0.1) < 0.001
		end

		-- Purge any orphaned glass blur parts or DoF effects left by previous sessions
		-- or crashed legacy Fluent runs so no stuck blur rectangle ever remains.
		function Acrylic.PurgeStale()
			for _, child in ipairs(Lighting:GetChildren()) do
				if child ~= baseEffect and isLegacyFluentDoF(child) then
					pcall(function()
						child:Destroy()
					end)
				end
			end
			local camera = Workspace.CurrentCamera
			if camera then
				for _, child in ipairs(camera:GetChildren()) do
					if child.Name == Acrylic.BLUR_FOLDER_NAME then
						pcall(function()
							child:Destroy()
						end)
					elseif child:IsA("Folder") then
						local hasOnlyGlassBody = false
						for _, sub in ipairs(child:GetChildren()) do
							if sub:IsA("BasePart") and sub.Material == Enum.Material.Glass and (sub.Name == "Body" or sub.Name == "AcryvenBlurPart") then
								hasOnlyGlassBody = true
							end
						end
						if hasOnlyGlassBody and child.Name == "Folder" then
							pcall(function()
								child:Destroy()
							end)
						end
					end
				end
			end
			for _, child in ipairs(Workspace:GetChildren()) do
				if child:IsA("BasePart") and child.Material == Enum.Material.Glass and (child.Name == "Body" or child.Name == "AcryvenBlurPart") then
					pcall(function()
						child:Destroy()
					end)
				end
			end
		end

		function Acrylic.GetBlurFolder()
			local camera = Workspace.CurrentCamera
			if not camera then
				return nil
			end
			local folder = camera:FindFirstChild(Acrylic.BLUR_FOLDER_NAME)
			if not folder then
				folder = Instance.new("Folder")
				folder.Name = Acrylic.BLUR_FOLDER_NAME
				folder.Parent = camera
			end
			return folder
		end

		function Acrylic.Enable()
			if not baseEffect then
				return
			end
			isEnabled = true
			for effectInstance, state in pairs(depthOfFieldDefaults) do
				if effectInstance and effectInstance.Parent then
					pcall(function()
						effectInstance.Enabled = false
					end)
				end
			end
			baseEffect.Enabled = true
			if baseEffect.Parent ~= Lighting then
				baseEffect.Parent = Lighting
			end
		end

		function Acrylic.Disable()
			isEnabled = false
			for effectInstance, state in pairs(depthOfFieldDefaults) do
				if effectInstance and effectInstance.Parent then
					pcall(function()
						effectInstance.Enabled = state.enabled
					end)
				end
			end
			if baseEffect then
				baseEffect.Enabled = false
				baseEffect.Parent = nil
			end
		end

		function Acrylic.Destroy()
			Acrylic.Disable()
			if baseEffect then
				pcall(function()
					baseEffect:Destroy()
				end)
				baseEffect = nil
			end
			local camera = Workspace.CurrentCamera
			if camera then
				local folder = camera:FindFirstChild(Acrylic.BLUR_FOLDER_NAME)
				if folder then
					pcall(function()
						folder:Destroy()
					end)
				end
			end
			table.clear(depthOfFieldDefaults)
			isInitialized = false
			isEnabled = false
		end

		function Acrylic.init()
			if isInitialized and baseEffect then
				Acrylic.Enable()
				return
			end
			Acrylic.PurgeStale()
			table.clear(depthOfFieldDefaults)

			local function register(object)
				if object:IsA("DepthOfFieldEffect") and not isLegacyFluentDoF(object) then
					depthOfFieldDefaults[object] = {enabled = object.Enabled}
				end
			end
			for _, child in ipairs(Lighting:GetChildren()) do
				register(child)
			end
			local camera = Workspace.CurrentCamera
			if camera then
				for _, child in ipairs(camera:GetChildren()) do
					register(child)
				end
			end

			baseEffect = Instance.new("DepthOfFieldEffect")
			baseEffect.Name = Acrylic.DOF_NAME
			baseEffect.FarIntensity = 0
			baseEffect.InFocusRadius = 0.1
			baseEffect.NearIntensity = 1
			pcall(function()
				baseEffect:SetAttribute("AcryvenManaged", true)
			end)
			isInitialized = true
			Acrylic.Enable()
		end

		function Acrylic.IsEnabled()
			return isEnabled
		end

		return Acrylic
	end,
	function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(3)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local createAcrylic = requireModule(moduleScript.Parent.CreateAcrylic)
		local viewportPointToWorld, getOffset = unpack(requireModule(moduleScript.Parent.Utils))
		local Workspace = Creator.GetService("Workspace")
		local RunService = Creator.GetService("RunService")

		local activeBlurCount = 0
		local nextBlurId = 0

		return function(distance)
			local AcrylicModule = requireModule(moduleScript.Parent)
			local Library = requireModule(Root)

			nextBlurId += 1
			local renderStepName = "AcryvenAcrylic_" .. tostring(nextBlurId)
			distance = distance or 0.004
			local positions = {
				topLeft = Vector2.new(),
				topRight = Vector2.new(),
				bottomLeft = Vector2.new(),
				bottomRight = Vector2.new()
			}
			local model = createAcrylic()
			local mesh = model:FindFirstChildOfClass("SpecialMesh")

			local destroyed = false
			local currentlyVisible = false
			local renderBound = false
			local boundParent = nil
			local boundGui = nil
			local cameraSignals = {}
			local lifecycleSignals = {}
			local lastCamCF, lastFov, lastVp = nil, nil, nil
			local boundsDirty = true

			local function disconnectList(list)
				for index = #list, 1, -1 do
					local conn = table.remove(list, index)
					pcall(function()
						conn:Disconnect()
					end)
				end
			end

			local function unbindRenderStep()
				if renderBound then
					renderBound = false
					pcall(RunService.UnbindFromRenderStep, RunService, renderStepName)
				end
			end

			local function render()
				if destroyed or not currentlyVisible or not model or not model.Parent then
					return
				end
				local camera = Workspace.CurrentCamera
				if not camera then
					return
				end
				local viewCFrame = camera.CFrame
				local topLeft3D = viewportPointToWorld(positions.topLeft, distance)
				local topRight3D = viewportPointToWorld(positions.topRight, distance)
				local bottomLeft3D = viewportPointToWorld(positions.bottomLeft, distance)
				local bottomRight3D = viewportPointToWorld(positions.bottomRight, distance)
				local width = (topRight3D - topLeft3D).Magnitude
				local height = (bottomLeft3D - topLeft3D).Magnitude
				model.CFrame = CFrame.fromMatrix((topLeft3D + bottomRight3D) * 0.5, viewCFrame.XVector, viewCFrame.YVector, viewCFrame.ZVector)
				if mesh then
					mesh.Scale = Vector3.new(width, height, 0.001)
				end
				lastCamCF = viewCFrame
				lastFov = camera.FieldOfView
				lastVp = camera.ViewportSize
				boundsDirty = false
			end

			local function stepRender()
				if destroyed or not currentlyVisible or not model or not model.Parent then
					return
				end
				local camera = Workspace.CurrentCamera
				if not camera then
					return
				end
				if not boundsDirty and lastCamCF == camera.CFrame and lastFov == camera.FieldOfView and lastVp == camera.ViewportSize then
					return
				end
				render()
			end

			local function bindCameraSignals()
				disconnectList(cameraSignals)
				unbindRenderStep()
				if destroyed or not currentlyVisible then
					return
				end
				local camera = Workspace.CurrentCamera
				if not camera then
					return
				end
				-- Bind right after Camera update so turning the camera never causes 1-frame glass lag/skew
				renderBound = true
				pcall(function()
					RunService:BindToRenderStep(renderStepName, Enum.RenderPriority.Camera.Value + 1, stepRender)
				end)
				table.insert(cameraSignals, camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
					boundsDirty = true
					render()
				end))
				table.insert(cameraSignals, camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
					boundsDirty = true
					render()
				end))
				boundsDirty = true
				render()
			end

			local frame = Creator.New("Frame", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)})

			local function updateBounds()
				if destroyed then
					return
				end
				local offset = getOffset()
				local absSize = frame.AbsoluteSize
				local size = Vector2.new(math.max(0, absSize.X - offset), math.max(0, absSize.Y - offset))
				local position = frame.AbsolutePosition + Vector2.new(offset * 0.5, offset * 0.5)
				positions.topLeft = position
				positions.topRight = position + Vector2.new(size.X, 0)
				positions.bottomLeft = position + Vector2.new(0, size.Y)
				positions.bottomRight = position + size
				boundsDirty = true
				if currentlyVisible then
					render()
				end
			end

			local function shouldBeVisible()
				if destroyed or Library.Unloaded then
					return false
				end
				if Library.Window and Library.Window.Minimized then
					return false
				end
				if not Library.UseAcrylic or Library.Acrylic == false then
					return false
				end
				if not frame or not frame.Parent or not frame:IsDescendantOf(game) then
					return false
				end
				if boundParent then
					if not boundParent.Visible or not boundParent:IsDescendantOf(game) then
						return false
					end
				end
				if boundGui then
					if not boundGui.Enabled or not boundGui:IsDescendantOf(game) then
						return false
					end
				end
				return true
			end

			local function setActiveState(visible)
				visible = visible == true
				if visible == currentlyVisible then
					return
				end
				currentlyVisible = visible
				if visible then
					activeBlurCount += 1
					local folder = AcrylicModule.GetBlurFolder()
					if folder then
						model.Transparency = 0.988
						model.Reflectance = 0
						model.Parent = folder
					end
					AcrylicModule.Enable()
					updateBounds()
					bindCameraSignals()
				else
					activeBlurCount = math.max(0, activeBlurCount - 1)
					disconnectList(cameraSignals)
					unbindRenderStep()
					if model then
						model.Transparency = 1
						model.Parent = nil
					end
					if activeBlurCount == 0 then
						AcrylicModule.Disable()
					end
				end
			end

			local Blur = {}

			function Blur.SyncVisibility()
				setActiveState(shouldBeVisible())
			end

			function Blur.SetVisibility(visible)
				if visible then
					Blur.SyncVisibility()
				else
					setActiveState(false)
				end
			end

			function Blur.Destroy()
				if destroyed then
					return
				end
				destroyed = true
				if currentlyVisible then
					currentlyVisible = false
					activeBlurCount = math.max(0, activeBlurCount - 1)
					if activeBlurCount == 0 then
						AcrylicModule.Disable()
					end
				end
				disconnectList(cameraSignals)
				unbindRenderStep()
				disconnectList(lifecycleSignals)
				if model then
					pcall(function()
						model:Destroy()
					end)
					model = nil
				end
				mesh = nil
			end

			-- Re-parent blur layer if the game replaces CurrentCamera.
			table.insert(lifecycleSignals, Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
				if destroyed or not currentlyVisible then
					return
				end
				local folder = AcrylicModule.GetBlurFolder()
				if folder and model then
					model.Parent = folder
				end
				bindCameraSignals()
			end))

			table.insert(lifecycleSignals, frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateBounds))
			table.insert(lifecycleSignals, frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateBounds))
			Creator.RegisterDPIScale(frame, function()
				task.defer(updateBounds)
			end)
			table.insert(lifecycleSignals, frame.Destroying:Connect(Blur.Destroy))
			table.insert(lifecycleSignals, frame.AncestryChanged:Connect(function()
				if not frame:IsDescendantOf(game) then
					setActiveState(false)
				else
					Blur.SyncVisibility()
				end
			end))

			function Blur.AddParent(parentFrame)
				if destroyed or not parentFrame then
					return
				end
				boundParent = parentFrame
				boundGui = parentFrame:FindFirstAncestorOfClass("ScreenGui") or Library.GUI
				table.insert(lifecycleSignals, parentFrame:GetPropertyChangedSignal("Visible"):Connect(Blur.SyncVisibility))
				table.insert(lifecycleSignals, parentFrame.Destroying:Connect(Blur.Destroy))
				table.insert(lifecycleSignals, parentFrame.AncestryChanged:Connect(Blur.SyncVisibility))
				local node = frame
				local depth = 0
				while node and depth < 12 do
					local uiScale = node:FindFirstChildOfClass("UIScale")
					if uiScale then
						table.insert(lifecycleSignals, uiScale:GetPropertyChangedSignal("Scale"):Connect(updateBounds))
					end
					if node == parentFrame then
						break
					end
					node = node.Parent
					depth += 1
				end
				if boundGui then
					table.insert(lifecycleSignals, boundGui:GetPropertyChangedSignal("Enabled"):Connect(Blur.SyncVisibility))
					table.insert(lifecycleSignals, boundGui.Destroying:Connect(Blur.Destroy))
				end
				Blur.SyncVisibility()
			end

			Blur.Frame = frame
			Blur.Model = model
			return Blur
		end
	end,
	function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(4)
		local Creator, AcrylicBlur = requireModule(moduleScript.Parent.Parent.Creator), requireModule(moduleScript.Parent.AcrylicBlur)
		local New = Creator.New
		return function(props)
			local radius = (type(props) == "table" and tonumber(props.Radius)) or Creator.Radius.Window or 12
			local showShadow = (type(props) ~= "table") or (props.Shadow ~= false)
			local surfaceTrans = (type(props) == "table" and tonumber(props.SurfaceTransparency)) or 0.32
			local gradTrans = (type(props) == "table" and tonumber(props.GradientTransparency)) or 0.44
			local corner = UDim.new(0, radius)
			local Paint = {}
			local children = {}
			if showShadow then
				-- Soft elevated ambient shadow (disabled inside CanvasGroup toasts where it would be clipped)
				table.insert(children, New(
					"ImageLabel",
					{
						Name = "Shadow",
						Image = "rbxassetid://8992230677",
						ScaleType = "Slice",
						SliceCenter = Rect.new(Vector2.new(99, 99), Vector2.new(99, 99)),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Size = UDim2.new(1, 76, 1, 76),
						Position = UDim2.new(0.5, 0, 0.5, 4),
						BackgroundTransparency = 1,
						ImageColor3 = Color3.fromRGB(0, 0, 0),
						ImageTransparency = 0.72
					}
				))
			end
			table.insert(children, New("UICorner", {CornerRadius = corner}))
			table.insert(children, New(
				"Frame",
				{
					BackgroundTransparency = surfaceTrans,
					Size = UDim2.fromScale(1, 1),
					Name = "Background",
					ThemeTag = {BackgroundColor3 = "AcrylicMain"}
				},
				{New("UICorner", {CornerRadius = corner})}
			))
			table.insert(children, New(
				"Frame",
				{
					Name = "GradientSurface",
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = gradTrans,
					Size = UDim2.fromScale(1, 1)
				},
				{
					New("UICorner", {CornerRadius = corner}),
					New("UIGradient", {Rotation = 90, ThemeTag = {Color = "AcrylicGradient"}})
				}
			))
			-- Subtle frosted grain overlay
			table.insert(children, New(
				"ImageLabel",
				{
					Image = "rbxassetid://9968344105",
					ImageTransparency = 0.975,
					ScaleType = Enum.ScaleType.Tile,
					TileSize = UDim2.new(0, 128, 0, 128),
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1
				},
				{New("UICorner", {CornerRadius = corner})}
			))
			table.insert(children, New(
				"ImageLabel",
				{
					Image = "rbxassetid://9968344227",
					ImageTransparency = 0.92,
					ScaleType = Enum.ScaleType.Tile,
					TileSize = UDim2.new(0, 128, 0, 128),
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					ThemeTag = {ImageTransparency = "AcrylicNoise"}
				},
				{New("UICorner", {CornerRadius = corner})}
			))
			-- Specular top sheen line (catches subtle top rim light)
			table.insert(children, New(
				"Frame",
				{
					Name = "TopRimSheen",
					Size = UDim2.new(1, -radius * 2, 0, 1),
					Position = UDim2.new(0, radius, 0, 0),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.82,
					BorderSizePixel = 0,
					ZIndex = 3
				},
				{
					New(
						"UIGradient",
						{
							Transparency = NumberSequence.new({
								NumberSequenceKeypoint.new(0, 1),
								NumberSequenceKeypoint.new(0.2, 0.25),
								NumberSequenceKeypoint.new(0.5, 0),
								NumberSequenceKeypoint.new(0.8, 0.25),
								NumberSequenceKeypoint.new(1, 1)
							})
						}
					)
				}
			))
			-- Outer Glass Rim gradient stroke (brighter at top, deeper at bottom)
			table.insert(children, New(
				"Frame",
				{Name = "GlassRim", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 3},
				{
					New("UICorner", {CornerRadius = corner}),
					New(
						"UIStroke",
						{
							Transparency = 0.3,
							Thickness = 1,
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							ThemeTag = {Color = "AcrylicBorder"}
						},
						{
							New(
								"UIGradient",
								{
									Rotation = 90,
									Transparency = NumberSequence.new({
										NumberSequenceKeypoint.new(0, 0.12),
										NumberSequenceKeypoint.new(0.35, 0.55),
										NumberSequenceKeypoint.new(1, 0.72)
									})
								}
							)
						}
					)
				}
			))
			Paint.Frame =
				New(
					"Frame",
					{
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BorderSizePixel = 0
					},
					children
				)
			local useBlur = (type(props) ~= "table") or (props.UseBlur ~= false)
			local blur
			if useBlur and requireModule(moduleScript.Parent.Parent).UseAcrylic then
				blur = AcrylicBlur()
				blur.Frame.Parent = Paint.Frame
				Paint.Model = blur.Model
				Paint.AddParent = blur.AddParent
				Paint.SetVisibility = blur.SetVisibility
				Paint.SyncVisibility = blur.SyncVisibility
				Paint.Destroy = blur.Destroy
			else
				Paint.AddParent = function() end
				Paint.SetVisibility = function() end
				Paint.SyncVisibility = function() end
				Paint.Destroy = function() end
			end
			return Paint
		end
	end,
	function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(5)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local createAcrylic = function()
			local part =
				Creator.New(
					"Part",
					{
						Name = "AcryvenBlurPart",
						Color = Color3.new(0, 0, 0),
						Material = Enum.Material.Glass,
						Reflectance = 0,
						Size = Vector3.new(1, 1, 1),
						Anchored = true,
						CanCollide = false,
						CanTouch = false,
						CanQuery = false,
						Massless = true,
						Locked = true,
						CastShadow = false,
						Transparency = 0.988
					},
					{Creator.New("SpecialMesh", {MeshType = Enum.MeshType.Brick, Scale = Vector3.new(1, 1, 0.001), Offset = Vector3.new(0, 0, -1E-6)})}
				)
			return part
		end
		return createAcrylic
	end,
	function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(6)
		local Creator = requireModule(moduleScript.Parent.Parent.Creator)
		local Workspace = Creator.GetService("Workspace")

		-- Project a ScreenGui pixel coordinate strictly onto a plane parallel to the
		-- camera at depth `abs(NearPlaneZ) + distance`. Keeping all 4 corners coplanar
		-- eliminates perspective skew / edge overshoot across any FOV, DPI, or window position.
		local function viewportPointToWorld(location, distance)
			local camera = Workspace.CurrentCamera
			if not camera then
				return Vector3.new()
			end
			local ray = camera:ScreenPointToRay(location.X, location.Y)
			local camCF = camera.CFrame
			local look = camCF.LookVector
			local denom = ray.Direction:Dot(look)
			local planeDepth = math.abs(camera.NearPlaneZ) + (distance or 0.004)
			if math.abs(denom) > 1e-6 then
				local originDepth = (ray.Origin - camCF.Position):Dot(look)
				local t = (planeDepth - originDepth) / denom
				return ray.Origin + ray.Direction * t
			end
			return ray.Origin + ray.Direction * (distance or 0.004)
		end

		-- ~6px-per-side inset scaled by DPI keeps the DoF bokeh blur kernel and
		-- rectangular glass corners strictly inside the rounded UICorner(12) window
		-- with zero halo spilling outside.
		local function getOffset()
			return math.floor(12 * Creator.DPIScale + 0.5)
		end

		return {viewportPointToWorld, getOffset}
	end,
	[8] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(8)
		return {
			Close = "rbxassetid://110786993356448",
			Min = "rbxassetid://118026365011536",
			Max = "rbxassetid://73085922906397",
			Restore = "rbxassetid://116269596042539"
		}
	end,
	[9] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(9)
		local Root = moduleScript.Parent.Parent
		local Flipper, Creator = requireModule(Root.Packages.Flipper), requireModule(Root.Creator)
		local New, Spring = Creator.New, Flipper.Spring.new
		return function(_theme, parent, dialogCheck)
			dialogCheck = dialogCheck or false
			local Button = {}
			Button.Title =
				New(
					"TextLabel",
					{
						FontFace = Creator.Font(),
						TextColor3 = Color3.fromRGB(200, 200, 200),
						TextSize = 14,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Center,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 1),
						ThemeTag = {TextColor3 = "Text"}
					}
				)
			Button.HoverFrame =
				New(
					"Frame",
					{Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ThemeTag = {BackgroundColor3 = "Hover"}},
					{New("UICorner", {CornerRadius = UDim.new(0, 8)})}
				)
			Button.Frame =
				New(
					"TextButton",
					{Size = UDim2.new(0, 0, 0, 32), Parent = parent, ThemeTag = {BackgroundColor3 = "DialogButton"}},
					{
						New("UICorner", {CornerRadius = UDim.new(0, Creator.Radius.Card)}),
						New(
							"UIStroke",
							{
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								Transparency = 0.55,
								ThemeTag = {Color = "DialogButtonBorder"}
							}
						),
						Button.HoverFrame,
						Button.Title
					}
				)
			local motor, setTransparency = Creator.SpringMotor(1, Button.HoverFrame, "BackgroundTransparency", dialogCheck)
			Creator.AddSignal(
				Button.Frame.MouseEnter,
				function()
					setTransparency(0.97)
				end
			)
			Creator.AddSignal(
				Button.Frame.MouseLeave,
				function()
					setTransparency(1)
				end
			)
			Creator.AddSignal(
				Button.Frame.MouseButton1Down,
				function()
					setTransparency(1)
				end
			)
			Creator.AddSignal(
				Button.Frame.MouseButton1Up,
				function()
					setTransparency(0.97)
				end
			)
			return Button
		end
	end,
	[10] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(10)
		local Root = moduleScript.Parent.Parent
		local Flipper, Creator = requireModule(Root.Packages.Flipper), requireModule(Root.Creator)
		local Spring, Instant, New, Dialog = Flipper.Spring.new, Flipper.Instant.new, Creator.New, {Window = nil}
		function Dialog.Init(_self, window)
			Dialog.Window = window
			return Dialog
		end
		function Dialog.Create(_self)
			local NewDialog = {Buttons = 0, _closed = false}
			local radius = Creator.Radius.Window or 12
			NewDialog.TintFrame =
				New(
					"TextButton",
					{
						Text = "",
						Size = UDim2.fromScale(1, 1),
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						BackgroundTransparency = 1,
						ZIndex = 30,
						Parent = Dialog.Window.Root
					},
					{New("UICorner", {CornerRadius = UDim.new(0, radius)})}
				)
			local tintMotor, setTintTransparency = Creator.SpringMotor(1, NewDialog.TintFrame, "BackgroundTransparency", true)
			NewDialog.ButtonHolder =
				New(
					"Frame",
					{
						Size = UDim2.new(1, -40, 1, -40),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						BackgroundTransparency = 1,
						ZIndex = 32
					},
					{
						New(
							"UIListLayout",
							{
								Padding = UDim.new(0, 10),
								FillDirection = Enum.FillDirection.Horizontal,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								SortOrder = Enum.SortOrder.LayoutOrder
							}
						)
					}
				)
			NewDialog.ButtonHolderFrame =
				New(
					"Frame",
					{
						Size = UDim2.new(1, 0, 0, 70),
						Position = UDim2.new(0, 0, 1, -70),
						ZIndex = 32,
						ThemeTag = {BackgroundColor3 = "DialogHolder"}
					},
					{
						New("Frame", {Size = UDim2.new(1, 0, 0, 1), ZIndex = 33, ThemeTag = {BackgroundColor3 = "DialogHolderLine"}}),
						NewDialog.ButtonHolder
					}
				)
			NewDialog.Title =
				New(
					"TextLabel",
					{
						FontFace = Creator.Font(Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
						Text = "Dialog",
						TextColor3 = Color3.fromRGB(240, 240, 240),
						TextSize = 22,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(1, 0, 0, 22),
						Position = UDim2.fromOffset(20, 25),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						ZIndex = 32,
						ThemeTag = {TextColor3 = "Text"}
					}
				)
			NewDialog.Scale = New("UIScale", {Scale = 1})
			local scaleMotor, setScale = Creator.SpringMotor(1.1, NewDialog.Scale, "Scale")
			local dialogStroke = New("UIStroke", {Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "DialogBorder"}})
			local dialogBorderFrame = New(
				"Frame",
				{Name = "Border", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 34},
				{New("UICorner", {CornerRadius = UDim.new(0, 10)}), dialogStroke}
			)
			NewDialog.Root =
				New(
					"CanvasGroup",
					{
						Size = UDim2.fromOffset(300, 165),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						GroupTransparency = 1,
						ZIndex = 31,
						Parent = NewDialog.TintFrame,
						ThemeTag = {BackgroundColor3 = "Dialog"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 10)}),
						dialogBorderFrame,
						NewDialog.Scale,
						NewDialog.Title,
						NewDialog.ButtonHolderFrame
					}
				)
			local rootMotor, setRootTransparency = Creator.SpringMotor(1, NewDialog.Root, "GroupTransparency")
			function NewDialog.Open(_self)
				requireModule(Root).DialogOpen = true
				NewDialog.Scale.Scale = Creator.ReducedMotion and 1 or 1.08
				setTintTransparency(0.65)
				setRootTransparency(0)
				Creator.SpringValue(dialogStroke, "Transparency", 0.5, 10, 1)
				setScale(1)
			end
			function NewDialog.Close(_self)
				if NewDialog._closed then
					return
				end
				NewDialog._closed = true
				requireModule(Root).DialogOpen = false
				setTintTransparency(1)
				setRootTransparency(1)
				Creator.SpringValue(dialogStroke, "Transparency", 1, 13, 1)
				for _, desc in ipairs(NewDialog.Root:GetDescendants()) do
					if desc:IsA("UIStroke") then
						Creator.SpringValue(desc, "Transparency", 1, 13, 1)
					end
				end
				setScale(1.06)
				task.delay(Creator.ReducedMotion and 0 or 0.16, function()
					if NewDialog.TintFrame and NewDialog.TintFrame.Parent then
						NewDialog.TintFrame:Destroy()
					end
				end)
			end
			function NewDialog.Button(_self, title, callback)
				NewDialog.Buttons = NewDialog.Buttons + 1
				title = title or "Button"
				callback = callback or function()
				end
				local button = requireModule(Root.Components.Button)("", NewDialog.ButtonHolder, true)
				button.Title.Text = title
				TranslationSystem:Register(button.Title, title, "Text")
				for _, child in next, NewDialog.ButtonHolder:GetChildren() do
					if child:IsA "TextButton" then
						child.Size = UDim2.new(1 / NewDialog.Buttons, -(((NewDialog.Buttons - 1) * 10) / NewDialog.Buttons), 0, 32)
					end
				end
				Creator.AddSignal(
					button.Frame.MouseButton1Click,
					function()
						requireModule(Root):SafeCallback(callback)
						pcall(
							function()
								NewDialog:Close()
							end
						)
					end
				)
				return button
			end
			return NewDialog
		end
		return Dialog
	end,
	[11] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(11)
		local Root = moduleScript.Parent.Parent
		local Flipper, Creator = requireModule(Root.Packages.Flipper), requireModule(Root.Creator)
		local New, Spring = Creator.New, Flipper.Spring.new
		return function(title, desc, parent, hover)
			local Element = {}
			Element.TitleLabel =
				New(
					"TextLabel",
					{
						FontFace = Creator.Font(Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
						Text = title,
						TextColor3 = Color3.fromRGB(240, 240, 240),
						TextSize = 14,
						LineHeight = 1.12,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 0),
						LayoutOrder = 1,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						ThemeTag = {TextColor3 = "Text"}
					}
				)
			local initialDesc = desc == nil and "" or tostring(desc)
			Element.DescLabel =
				New(
					"TextLabel",
					{
						FontFace = Creator.Font(Enum.FontWeight.Medium, Enum.FontStyle.Normal),
						Text = initialDesc,
						Visible = initialDesc ~= "",
						TextColor3 = Color3.fromRGB(200, 200, 200),
						TextSize = 12,
						LineHeight = 1.15,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						LayoutOrder = 2,
						ThemeTag = {TextColor3 = "SubText"}
					}
				)
			Element.LabelHolder =
				New(
					"Frame",
					{
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						Position = UDim2.fromOffset(12, 0),
						Size = UDim2.new(1, -30, 0, 0)
					},
					{
						New(
							"UIListLayout",
							{Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center}
						),
						New("UIPadding", {PaddingBottom = UDim.new(0, 11), PaddingTop = UDim.new(0, 11)}),
						Element.TitleLabel,
						Element.DescLabel
					}
				)
			Element.Border =
				New(
					"UIStroke",
					{
						Transparency = 0.36,
						Thickness = 1,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = Color3.fromRGB(0, 0, 0),
						ThemeTag = {Color = "ElementBorder"}
					}
				)
			Element.Frame =
				New(
					"TextButton",
					{
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 0.89,
						BackgroundColor3 = Color3.fromRGB(130, 130, 130),
						Parent = parent,
						AutomaticSize = Enum.AutomaticSize.Y,
						Text = "",
						LayoutOrder = 7,
						ThemeTag = {BackgroundColor3 = "Element", BackgroundTransparency = "ElementTransparency"}
					},
					{New("UICorner", {CornerRadius = UDim.new(0, Creator.Radius.Card)}), Element.Border, Element.LabelHolder}
				)

			-- Optional StatusBadge pill (lazy created only when SetBadge is called)
			local badgeFrame, badgeDot, badgeText = nil, nil, nil
			function Element.SetBadge(_self, text, color, showDot)
				if text == nil or text == "" then
					if badgeFrame then
						badgeFrame.Visible = false
					end
					return
				end
				if not badgeFrame then
					badgeDot = New(
						"Frame",
						{
							Name = "Dot",
							Size = UDim2.fromOffset(6, 6),
							BackgroundColor3 = Color3.fromRGB(52, 211, 153),
							Visible = false
						},
						{New("UICorner", {CornerRadius = UDim.new(1, 0)})}
					)
					badgeText = New(
						"TextLabel",
						{
							Name = "BadgeLabel",
							Text = "",
							I18nSkip = true,
							FontFace = Creator.Font(Enum.FontWeight.SemiBold),
							TextSize = 10,
							AutomaticSize = Enum.AutomaticSize.X,
							Size = UDim2.new(0, 0, 1, 0),
							BackgroundTransparency = 1
						}
					)
					badgeFrame = New(
						"Frame",
						{
							Name = "StatusBadge",
							AutomaticSize = Enum.AutomaticSize.X,
							Size = UDim2.fromOffset(0, 18),
							Position = UDim2.new(1, -12, 0, 8),
							AnchorPoint = Vector2.new(1, 0),
							BackgroundTransparency = 0.16,
							ZIndex = 4,
							Parent = Element.Frame,
							ThemeTag = {BackgroundColor3 = "Accent"}
						},
						{
							New("UICorner", {CornerRadius = UDim.new(1, 0)}),
							New("UIPadding", {PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 7)}),
							New("UIListLayout", {
								FillDirection = Enum.FillDirection.Horizontal,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								Padding = UDim.new(0, 4)
							}),
							badgeDot,
							badgeText
						}
					)
				end
				badgeText.Text = tostring(text)
				badgeDot.Visible = showDot == true
				if typeof(color) == "Color3" then
					Creator.OverrideTag(badgeFrame, {})
					badgeFrame.BackgroundColor3 = color
					badgeText.TextColor3 = Creator.AutoContrast(color)
					badgeDot.BackgroundColor3 = Creator.AutoContrast(color)
				else
					local acc = Creator.GetThemeProperty("Accent")
					Creator.OverrideTag(badgeFrame, {BackgroundColor3 = "Accent"})
					badgeText.TextColor3 = Creator.AutoContrast(acc)
					badgeDot.BackgroundColor3 = Creator.AutoContrast(acc)
				end
				badgeFrame.Visible = true
			end

			-- TitleLabel and DescLabel were already registered once by Creator.New above.
			-- Subsequent SetTitle/SetDesc calls are runtime text (status, counters, player names).
			function Element.SetTitle(_self, text)
				Element.TitleLabel.Text = text
				TranslationSystem:Register(Element.TitleLabel, text, "Text", {Dynamic = true})
			end
			function Element.SetDesc(_self, text)
				if text == nil then
					text = ""
				end
				if text == "" then
					Element.DescLabel.Visible = false
				else
					Element.DescLabel.Visible = true
				end
				Element.DescLabel.Text = text
				if text ~= "" then
					TranslationSystem:Register(Element.DescLabel, text, "Text", {Dynamic = true})
				end
			end
			function Element.Destroy(_self)
				Element.Frame:Destroy()
			end
			if hover then
				local _themes, motor, setTransparency =
					Root.Themes,
				Creator.SpringMotor(
					Creator.GetThemeProperty "ElementTransparency",
					Element.Frame,
					"BackgroundTransparency",
					false,
					true
				)
				Creator.AddSignal(
					Element.Frame.MouseEnter,
					function()
						setTransparency(Creator.GetThemeProperty "ElementTransparency" - Creator.GetThemeProperty "HoverChange")
						Creator.SpringValue(Element.Border, "Transparency", 0.16, 10, 1)
					end
				)
				Creator.AddSignal(
					Element.Frame.MouseLeave,
					function()
						setTransparency(Creator.GetThemeProperty "ElementTransparency")
						Creator.SpringValue(Element.Border, "Transparency", 0.36, 10, 1)
					end
				)
				Creator.AddSignal(
					Element.Frame.MouseButton1Down,
					function()
						setTransparency(Creator.GetThemeProperty "ElementTransparency" + Creator.GetThemeProperty "HoverChange")
						Creator.SpringValue(Element.Border, "Transparency", 0.08, 12, 1)
					end
				)
				Creator.AddSignal(
					Element.Frame.MouseButton1Up,
					function()
						setTransparency(Creator.GetThemeProperty "ElementTransparency" - Creator.GetThemeProperty "HoverChange")
						Creator.SpringValue(Element.Border, "Transparency", 0.16, 10, 1)
					end
				)
			end
			return Element
		end
	end,
	[12] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(12)
		local Root = moduleScript.Parent.Parent
		local Creator, Acrylic = requireModule(Root.Creator), requireModule(Root.Acrylic)
		local RunService = Creator.GetService("RunService")
		local Workspace = Creator.GetService("Workspace")
		local New = Creator.New

		local Notification = {
			Side = "BottomRight",
			Holder = nil,
			ListLayout = nil
		}

		local SIDE_CONFIG = {
			BottomRight = {anchor = Vector2.new(1, 1), xScale = 1, yScale = 1, xSign = -1, ySign = -1, vAlign = Enum.VerticalAlignment.Bottom, slideDir = 1},
			TopRight = {anchor = Vector2.new(1, 0), xScale = 1, yScale = 0, xSign = -1, ySign = 1, vAlign = Enum.VerticalAlignment.Top, slideDir = 1},
			BottomLeft = {anchor = Vector2.new(0, 1), xScale = 0, yScale = 1, xSign = 1, ySign = -1, vAlign = Enum.VerticalAlignment.Bottom, slideDir = -1},
			TopLeft = {anchor = Vector2.new(0, 0), xScale = 0, yScale = 0, xSign = 1, ySign = 1, vAlign = Enum.VerticalAlignment.Top, slideDir = -1}
		}

		local function normalizeSide(side)
			if type(side) ~= "string" then
				return "BottomRight"
			end
			local compact = side:gsub("[%s_%-]", ""):lower()
			if compact == "topright" or compact == "righttop" then
				return "TopRight"
			elseif compact == "bottomleft" or compact == "leftbottom" or compact == "left" then
				return "BottomLeft"
			elseif compact == "topleft" or compact == "lefttop" then
				return "TopLeft"
			end
			return "BottomRight"
		end

		local function computeHolderLayout()
			local camera = Workspace.CurrentCamera
			local isMobile = camera and camera.ViewportSize.X < 600
			local sideMargin = isMobile and 12 or 24
			local topSafe = isMobile and 14 or 16
			local cfg = SIDE_CONFIG[Notification.Side] or SIDE_CONFIG.BottomRight
			local width = isMobile and 286 or 336
			local yOffset = cfg.ySign > 0 and topSafe or -sideMargin
			local pos = UDim2.new(cfg.xScale, cfg.xSign * sideMargin, cfg.yScale, yOffset)
			local size = UDim2.new(0, width, 1, -(sideMargin + topSafe))
			return pos, size, cfg
		end

		function Notification.SetSide(_self, side)
			Notification.Side = normalizeSide(side)
			if not Notification.Holder then
				return Notification.Side
			end
			local pos, size, cfg = computeHolderLayout()
			Notification.Holder.AnchorPoint = cfg.anchor
			Notification.Holder.Position = pos
			Notification.Holder.Size = size
			if Notification.ListLayout then
				Notification.ListLayout.VerticalAlignment = cfg.vAlign
			end
			return Notification.Side
		end

		function Notification.Init(_self, gui)
			local pos, size, cfg = computeHolderLayout()
			Notification.ListLayout = New(
				"UIListLayout",
				{
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = cfg.vAlign,
					Padding = UDim.new(0, 10)
				}
			)
			local holderScale = New("UIScale", {Scale = Creator.DPIScale})
			Notification.UIScale = holderScale
			Creator.RegisterDPIScale(holderScale)
			Notification.Holder = New(
				"Frame",
				{
					Name = "AcryvenNotifications",
					Position = pos,
					Size = size,
					AnchorPoint = cfg.anchor,
					BackgroundTransparency = 1,
					Parent = gui
				},
				{holderScale, Notification.ListLayout}
			)
			local camera = Workspace.CurrentCamera
			if camera then
				Creator.AddSignal(camera:GetPropertyChangedSignal("ViewportSize"), function()
					Notification:SetSide(Notification.Side)
				end)
			end
		end

		local function resolveAccentAndIcon(Library, config)
			local kind = type(config.Type) == "string" and config.Type:lower() or ""
			local titleLower = tostring(config.Title or ""):lower()
			local accentColor = typeof(config.AccentColor) == "Color3" and config.AccentColor or nil
			local icon = nil
			if type(config.Icon) == "string" and config.Icon ~= "" then
				icon = Library:GetIcon(config.Icon) or config.Icon
			end

			if kind == "success" or (kind == "" and (titleLower:find("success") or titleLower:find("complete") or titleLower:find("saved"))) then
				icon = icon or Library:GetIcon("check-circle") or "rbxassetid://10709790387"
				accentColor = accentColor or Color3.fromRGB(52, 211, 153)
			elseif kind == "error" or (kind == "" and (titleLower:find("error") or titleLower:find("fail"))) then
				icon = icon or Library:GetIcon("alert-circle") or "rbxassetid://10734933655"
				accentColor = accentColor or Color3.fromRGB(248, 113, 113)
			elseif kind == "warn" or kind == "warning" or (kind == "" and titleLower:find("warn")) then
				icon = icon or Library:GetIcon("alert-triangle") or "rbxassetid://10709753149"
				accentColor = accentColor or Color3.fromRGB(251, 191, 36)
			else
				icon = icon or Library:GetIcon("bell") or "rbxassetid://10723415903"
				accentColor = accentColor or Creator.GetThemeProperty("Accent")
			end
			return accentColor, icon
		end

		function Notification.New(_self, config)
			local Library = requireModule(Root)
			config = type(config) == "table" and config or {}
			config.Title = config.Title or "Notification"
			config.Content = config.Content or ""
			config.SubContent = config.SubContent or ""
			config.Buttons = config.Buttons or {}

			local accentColor, icon = resolveAccentAndIcon(Library, config)
			local sideCfg = SIDE_CONFIG[Notification.Side] or SIDE_CONFIG.BottomRight
			local slideStart = sideCfg.slideDir * 36

			local NewNotification = {
				Closed = false,
				Paused = false,
				Duration = tonumber(config.Duration),
				Remaining = tonumber(config.Duration),
				ManualProgress = nil
			}

			-- Pure 2D Glass Surface (higher opacity for crisp readability over bright 3D scenes, no clipped outer shadow)
			NewNotification.AcrylicPaint = Acrylic.AcrylicPaint({UseBlur = false, Radius = 10, Shadow = false, SurfaceTransparency = 0.16, GradientTransparency = 0.28})

			local iconStroke = New("UIStroke", {Color = accentColor, Transparency = 1, Thickness = 1})
			NewNotification.IconFrame = New(
				"Frame",
				{
					Name = "IconBadge",
					Size = UDim2.fromOffset(34, 34),
					Position = UDim2.fromOffset(12, 12),
					BackgroundColor3 = accentColor,
					BackgroundTransparency = 0.86,
					BorderSizePixel = 0,
					ZIndex = 4
				},
				{
					New("UICorner", {CornerRadius = UDim.new(0, 9)}),
					iconStroke,
					New(
						"ImageLabel",
						{
							Name = "Icon",
							Size = UDim2.fromOffset(18, 18),
							Position = UDim2.fromScale(0.5, 0.5),
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							Image = icon,
							ImageColor3 = accentColor,
							ZIndex = 5
						}
					)
				}
			)

			NewNotification.Title = New(
				"TextLabel",
				{
					Position = UDim2.new(0, 56, 0, 11),
					Text = tostring(config.Title),
					I18nDynamic = true,
					RichText = true,
					TextTransparency = 0,
					FontFace = Creator.Font(Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					Size = UDim2.new(1, -92, 0, 17),
					TextTruncate = Enum.TextTruncate.AtEnd,
					BackgroundTransparency = 1,
					ZIndex = 4,
					ThemeTag = {TextColor3 = "Text"}
				}
			)

			NewNotification.ContentLabel = New(
				"TextLabel",
				{
					FontFace = Creator.Font(Enum.FontWeight.Regular, Enum.FontStyle.Normal),
					Text = tostring(config.Content),
					I18nDynamic = true,
					RichText = true,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1,
					TextWrapped = true,
					Visible = config.Content ~= "",
					ZIndex = 4,
					ThemeTag = {TextColor3 = "Text"}
				}
			)

			NewNotification.SubContentLabel = New(
				"TextLabel",
				{
					FontFace = Creator.Font(),
					Text = tostring(config.SubContent),
					I18nDynamic = true,
					RichText = true,
					TextSize = 11,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1,
					TextWrapped = true,
					Visible = config.SubContent ~= "",
					ZIndex = 4,
					ThemeTag = {TextColor3 = "SubText"}
				}
			)

			NewNotification.LabelHolder = New(
				"Frame",
				{
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(56, 30),
					Size = UDim2.new(1, -68, 0, 0),
					ZIndex = 4
				},
				{
					New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)}),
					NewNotification.ContentLabel,
					NewNotification.SubContentLabel
				}
			)

			NewNotification.ButtonHolder = New(
				"Frame",
				{
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 56, 1, -38),
					Size = UDim2.new(1, -68, 0, 26),
					Visible = #config.Buttons > 0,
					ZIndex = 5
				},
				{
					New(
						"UIListLayout",
						{
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 6),
							HorizontalAlignment = Enum.HorizontalAlignment.Right,
							FillDirection = Enum.FillDirection.Horizontal
						}
					)
				}
			)

			for _, btnData in ipairs(config.Buttons) do
				local text = btnData.Text or btnData.Title or "Action"
				local color = btnData.Color or accentColor
				local textColor = Creator.AutoContrast(color)
				local estWidth = math.clamp(#tostring(text) * 7 + 22, 62, 136)
				local btn = New(
					"TextButton",
					{
						Text = text,
						FontFace = Creator.Font(Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
						TextSize = 12,
						TextColor3 = textColor,
						Size = UDim2.fromOffset(estWidth, 24),
						BackgroundColor3 = color,
						BackgroundTransparency = 0.1,
						BorderSizePixel = 0,
						AutoButtonColor = false,
						ZIndex = 6,
						Parent = NewNotification.ButtonHolder
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 6)}),
						New("UIStroke", {Color = color, Transparency = 0.45, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
					}
				)
				Creator.AddSignal(btn.MouseEnter, function()
					Creator.SpringValue(btn, "BackgroundTransparency", 0, 10, 1)
				end)
				Creator.AddSignal(btn.MouseLeave, function()
					Creator.SpringValue(btn, "BackgroundTransparency", 0.1, 10, 1)
				end)
				Creator.AddSignal(btn.MouseButton1Click, function()
					if type(btnData.Callback) == "function" then
						local ok, err = pcall(btnData.Callback)
						if not ok then
							warn("Notification button callback error:", err)
						end
					end
					if not btnData.KeepOpen then
						NewNotification:Close()
					end
				end)
			end

			NewNotification.ProgressFill = New(
				"Frame",
				{
					Name = "ProgressFill",
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = accentColor,
					BackgroundTransparency = 0.15,
					BorderSizePixel = 0
				},
				{New("UICorner", {CornerRadius = UDim.new(1, 0)})}
			)

			NewNotification.ProgressBar = New(
				"Frame",
				{
					Name = "ProgressTrack",
					Size = UDim2.new(1, -20, 0, 3),
					Position = UDim2.new(0, 10, 1, -7),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.9,
					BorderSizePixel = 0,
					Visible = NewNotification.Duration ~= nil or config.Progress ~= nil,
					ZIndex = 5
				},
				{New("UICorner", {CornerRadius = UDim.new(1, 0)}), NewNotification.ProgressFill}
			)

			NewNotification.CloseButton = New(
				"TextButton",
				{
					Text = "",
					Position = UDim2.new(1, -10, 0, 10),
					Size = UDim2.fromOffset(22, 22),
					AnchorPoint = Vector2.new(1, 0),
					BackgroundTransparency = 1,
					ZIndex = 6,
					ThemeTag = {BackgroundColor3 = "Text"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(0, 6)}),
					New(
						"ImageLabel",
						{
							Image = Library:GetIcon("x") or "rbxassetid://10747384394",
							Size = UDim2.fromOffset(12, 12),
							Position = UDim2.fromScale(0.5, 0.5),
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							ZIndex = 7,
							ThemeTag = {ImageColor3 = "SubText"}
						}
					)
				}
			)

			-- Accent severity rim placed on a child Frame (never directly on CanvasGroup)
			-- and animated in sync with GroupTransparency so strokes never linger when fading out.
			local cardBorder = New(
				"UIStroke",
				{
					Color = accentColor,
					Transparency = 1,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				}
			)
			local cardBorderFrame = New(
				"Frame",
				{
					Name = "CardBorder",
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ZIndex = 6
				},
				{New("UICorner", {CornerRadius = UDim.new(0, 10)}), cardBorder}
			)
			local glassRim = NewNotification.AcrylicPaint.Frame:FindFirstChild("GlassRim")
			local glassRimStroke = glassRim and glassRim:FindFirstChildOfClass("UIStroke") or nil
			if glassRimStroke then
				glassRimStroke.Transparency = 1
			end

			-- True CanvasGroup root: fades background, border, icons, and text together cleanly
			NewNotification.Root = New(
				"CanvasGroup",
				{
					Name = "ToastCard",
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromOffset(slideStart, 0),
					GroupTransparency = 1,
					BorderSizePixel = 0
				},
				{
					New("UICorner", {CornerRadius = UDim.new(0, 10)}),
					NewNotification.AcrylicPaint.Frame,
					cardBorderFrame,
					NewNotification.IconFrame,
					NewNotification.Title,
					NewNotification.CloseButton,
					NewNotification.LabelHolder,
					NewNotification.ButtonHolder,
					NewNotification.ProgressBar
				}
			)

			NewNotification.Holder = New(
				"Frame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 64),
					Parent = Notification.Holder
				},
				{NewNotification.Root}
			)

			local function recomputeHeight()
				if NewNotification.Closed or not NewNotification.Holder or not NewNotification.Holder.Parent then
					return
				end
				local scale = Creator.GetEffectiveScale(NewNotification.LabelHolder)
				local labelHeight = math.ceil(NewNotification.LabelHolder.AbsoluteSize.Y / scale)
				local extraButtons = (#config.Buttons > 0) and 38 or 0
				local extraProgress = NewNotification.ProgressBar.Visible and 10 or 0
				local targetH = math.max(58, 40 + labelHeight + extraButtons + extraProgress)
				NewNotification.Holder.Size = UDim2.new(1, 0, 0, targetH)
			end
			Creator.AddSignal(NewNotification.LabelHolder:GetPropertyChangedSignal("AbsoluteSize"), recomputeHeight)
			Creator.RegisterDPIScale(NewNotification.Holder, function()
				task.defer(recomputeHeight)
			end)

			-- Pause-on-hover countdown timer (still auto-dismisses when Duration > 0 even with ManualProgress)
			local timerConn = nil
			local function stopTimer()
				if timerConn then
					timerConn:Disconnect()
					timerConn = nil
				end
			end

			local function startTimer()
				stopTimer()
				if not NewNotification.Duration or NewNotification.Duration <= 0 then
					return
				end
				NewNotification.ProgressBar.Visible = true
				timerConn = RunService.Heartbeat:Connect(function(dt)
					if NewNotification.Closed then
						stopTimer()
						return
					end
					if NewNotification.Paused then
						return
					end
					NewNotification.Remaining = math.max(0, (NewNotification.Remaining or 0) - dt)
					if NewNotification.ManualProgress == nil then
						local ratio = NewNotification.Duration > 0 and (NewNotification.Remaining / NewNotification.Duration) or 0
						NewNotification.ProgressFill.Size = UDim2.new(math.clamp(ratio, 0, 1), 0, 1, 0)
					end
					if NewNotification.Remaining <= 0 then
						stopTimer()
						NewNotification:Close()
					end
				end)
			end

			Creator.AddSignal(NewNotification.Root.MouseEnter, function()
				NewNotification.Paused = true
				Creator.SpringValue(cardBorder, "Transparency", 0.28, 10, 1)
			end)
			Creator.AddSignal(NewNotification.Root.MouseLeave, function()
				NewNotification.Paused = false
				Creator.SpringValue(cardBorder, "Transparency", 0.62, 10, 1)
			end)
			Creator.AddSignal(NewNotification.CloseButton.MouseEnter, function()
				Creator.SpringValue(NewNotification.CloseButton, "BackgroundTransparency", 0.88, 10, 1)
			end)
			Creator.AddSignal(NewNotification.CloseButton.MouseLeave, function()
				Creator.SpringValue(NewNotification.CloseButton, "BackgroundTransparency", 1, 10, 1)
			end)
			Creator.AddSignal(NewNotification.CloseButton.MouseButton1Click, function()
				NewNotification:Close()
			end)

			-- Live update API: toast:Update({ Title = ..., Content = ..., SubContent = ..., Progress = 0..1, Duration = ... })
			function NewNotification.Update(_self, patch)
				if NewNotification.Closed or type(patch) ~= "table" then
					return
				end
				if patch.Title ~= nil then
					NewNotification.Title.Text = tostring(patch.Title)
				end
				if patch.Content ~= nil then
					local str = tostring(patch.Content)
					NewNotification.ContentLabel.Text = str
					NewNotification.ContentLabel.Visible = str ~= ""
				end
				if patch.SubContent ~= nil then
					local str = tostring(patch.SubContent)
					NewNotification.SubContentLabel.Text = str
					NewNotification.SubContentLabel.Visible = str ~= ""
				end
				if type(patch.Progress) == "number" then
					local clamped = math.clamp(patch.Progress, 0, 1)
					NewNotification.ManualProgress = clamped
					NewNotification.ProgressBar.Visible = true
					local startRatio = NewNotification.ProgressFill.Size.X.Scale
					Creator.SpringValue(NewNotification.ProgressFill, "Size", clamped, 10, 1, function(ratio)
						NewNotification.ProgressFill.Size = UDim2.new(math.clamp(ratio, 0, 1), 0, 1, 0)
					end, startRatio)
				end
				if type(patch.Duration) == "number" then
					NewNotification.ManualProgress = nil
					NewNotification.Duration = patch.Duration
					NewNotification.Remaining = patch.Duration
					startTimer()
				end
				task.defer(recomputeHeight)
			end

			function NewNotification.Open(_self)
				recomputeHeight()
				task.defer(recomputeHeight)
				if type(config.Progress) == "number" then
					NewNotification.ManualProgress = math.clamp(config.Progress, 0, 1)
					NewNotification.ProgressFill.Size = UDim2.new(NewNotification.ManualProgress, 0, 1, 0)
				end
				if Creator.ReducedMotion then
					NewNotification.Root.Position = UDim2.fromOffset(0, 0)
					NewNotification.Root.GroupTransparency = 0
					cardBorder.Transparency = 0.62
					iconStroke.Transparency = 0.65
					if glassRimStroke then glassRimStroke.Transparency = 0.42 end
				else
					Creator.SpringValue(NewNotification.Root, "GroupTransparency", 0, 9, 1)
					Creator.SpringValue(cardBorder, "Transparency", 0.62, 9, 1)
					Creator.SpringValue(iconStroke, "Transparency", 0.65, 9, 1)
					if glassRimStroke then Creator.SpringValue(glassRimStroke, "Transparency", 0.42, 9, 1) end
					Creator.SpringValue(NewNotification.Root, "Position", 0, 8, 0.85, function(x)
						NewNotification.Root.Position = UDim2.fromOffset(x, 0)
					end, slideStart)
				end
			end

			function NewNotification.Close(_self)
				if NewNotification.Closed then
					return
				end
				NewNotification.Closed = true
				stopTimer()
				local function cleanup()
					if NewNotification.AcrylicPaint and type(NewNotification.AcrylicPaint.Destroy) == "function" then
						pcall(NewNotification.AcrylicPaint.Destroy)
					end
					if NewNotification.Holder and NewNotification.Holder.Parent then
						pcall(function()
							NewNotification.Holder:Destroy()
						end)
					end
				end
				if Creator.ReducedMotion then
					cleanup()
					return
				end
				Creator.SpringValue(NewNotification.Root, "GroupTransparency", 1, 11, 1)
				Creator.SpringValue(cardBorder, "Transparency", 1, 12, 1)
				Creator.SpringValue(iconStroke, "Transparency", 1, 12, 1)
				if glassRimStroke then Creator.SpringValue(glassRimStroke, "Transparency", 1, 12, 1) end
				for _, btn in ipairs(NewNotification.ButtonHolder:GetChildren()) do
					local st = btn:IsA("TextButton") and btn:FindFirstChildOfClass("UIStroke")
					if st then
						Creator.SpringValue(st, "Transparency", 1, 12, 1)
					end
				end
				local startX = NewNotification.Root.Position.X.Offset
				Creator.SpringValue(NewNotification.Root, "Position", slideStart, 10, 1, function(x)
					if NewNotification.Root and NewNotification.Root.Parent then
						NewNotification.Root.Position = UDim2.fromOffset(x, 0)
					end
				end, startX)
				task.delay(0.24, cleanup)
			end

			NewNotification:Open()
			if NewNotification.Duration and NewNotification.Duration > 0 then
				startTimer()
			end

			return NewNotification
		end

		return Notification
	end,
	[13] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(13)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local New = Creator.New

		return function(titleOrConfig, parent, extraOpts)
			local Library = requireModule(Root)
			local opts = {}
			if type(titleOrConfig) == "table" then
				opts = titleOrConfig
			else
				opts.Title = tostring(titleOrConfig or "")
				if type(extraOpts) == "table" then
					for k, v in next, extraOpts do
						opts[k] = v
					end
				end
			end

			local title = tostring(opts.Title or "")
			local collapsible = opts.Collapsible == true
			local collapsed = collapsible and (opts.Collapsed == true) or false
			local isCard = opts.Style == "Card" or opts.Card == true
			local iconAsset = nil
			if type(opts.Icon) == "string" and opts.Icon ~= "" then
				local resolved = Library:GetIcon(opts.Icon)
				if resolved then
					iconAsset = resolved
				elseif opts.Icon:match("^rbxassetid://") or opts.Icon:match("^rbxasset://") then
					iconAsset = opts.Icon
				end
			end

			local Section = {
				Visible = true,
				Collapsible = collapsible,
				Collapsed = collapsed,
				Style = isCard and "Card" or "Plain"
			}

			local headerHeight = isCard and 34 or 24
			local bodyPadX = isCard and 10 or 2
			local bodyPadTop = isCard and 4 or 4
			local bodyPadBottom = isCard and 10 or 4

			Section.Layout = New("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})
			Section.Container = New(
				"Frame",
				{
					Name = "Content",
					Size = UDim2.new(1, -bodyPadX * 2, 0, 0),
					Position = UDim2.fromOffset(bodyPadX, bodyPadTop),
					BackgroundTransparency = 1
				},
				{Section.Layout}
			)
			local containerHolder = New(
				"Frame",
				{
					Name = "ContainerHolder",
					Size = UDim2.new(1, 0, 0, 0),
					Position = UDim2.fromOffset(0, headerHeight),
					BackgroundTransparency = 1,
					ClipsDescendants = true
				},
				{Section.Container}
			)

			local headerChildren = {}
			local textLeft = isCard and 12 or 10

			if not isCard then
				table.insert(
					headerChildren,
					New(
						"Frame",
						{
							Name = "AccentBar",
							Size = UDim2.fromOffset(3, 12),
							Position = UDim2.new(0, 1, 0.5, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							ThemeTag = {BackgroundColor3 = "Accent"}
						},
						{New("UICorner", {CornerRadius = UDim.new(1, 0)})}
					)
				)
			end

			if iconAsset then
				table.insert(
					headerChildren,
					New(
						"ImageLabel",
						{
							Name = "Icon",
							Image = iconAsset,
							Size = UDim2.fromOffset(16, 16),
							Position = UDim2.new(0, textLeft, 0.5, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundTransparency = 1,
							ImageTransparency = 0,
							ThemeTag = {ImageColor3 = "Accent"}
						}
					)
				)
				textLeft += 22
			end

			local titleLabel = New(
				"TextLabel",
				{
					Name = "Title",
					RichText = true,
					Text = title,
					TextTransparency = 0,
					FontFace = Creator.Font(Enum.FontWeight.Bold, Enum.FontStyle.Normal, "Display"),
					TextSize = 14,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 0, 1, 0),
					Position = UDim2.fromOffset(textLeft, 0),
					BackgroundTransparency = 1,
					ThemeTag = {TextColor3 = "Text"}
				}
			)
			table.insert(headerChildren, titleLabel)

			local badgeLabel = New(
				"TextLabel",
				{
					Name = "BadgeText",
					Text = "",
					I18nSkip = true,
					FontFace = Creator.Font(Enum.FontWeight.SemiBold),
					TextSize = 10,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 1,
					TextColor3 = Color3.fromRGB(246, 248, 254)
				}
			)
			local badgePill = New(
				"Frame",
				{
					Name = "Badge",
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, collapsible and -30 or -10, 0.5, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.fromOffset(0, 18),
					BackgroundTransparency = 0.18,
					Visible = false,
					ThemeTag = {BackgroundColor3 = "Accent"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(1, 0)}),
					New("UIPadding", {PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 7)}),
					badgeLabel
				}
			)
			table.insert(headerChildren, badgePill)

			local chevronIcon = nil
			if collapsible then
				chevronIcon = New(
					"ImageLabel",
					{
						Name = "Chevron",
						Image = Library:GetIcon("chevron-down") or "rbxassetid://10709790948",
						Size = UDim2.fromOffset(14, 14),
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, isCard and -10 or -4, 0.5, 0),
						BackgroundTransparency = 1,
						ImageTransparency = 0.04,
						Rotation = collapsed and -90 or 0,
						ThemeTag = {ImageColor3 = "SubText"}
					}
				)
				table.insert(headerChildren, chevronIcon)
			end

			local headerClass = collapsible and "TextButton" or "Frame"
			local headerProps = {
				Name = "Header",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, headerHeight),
				Position = UDim2.fromOffset(0, 0)
			}
			if collapsible then
				headerProps.Text = ""
				headerProps.AutoButtonColor = false
			end
			local headerRow = New(headerClass, headerProps, headerChildren)

			local rootChildren = {headerRow, containerHolder}
			local cardStroke = nil
			if isCard then
				cardStroke = New(
					"UIStroke",
					{
						Transparency = 0.34,
						Thickness = 1,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						ThemeTag = {Color = "ElementBorder"}
					}
				)
				table.insert(rootChildren, New("UICorner", {CornerRadius = UDim.new(0, Creator.Radius.Card + 2)}))
				table.insert(rootChildren, cardStroke)
			end

			Section.Root = New(
				"Frame",
				{
					Name = "Section_" .. title:gsub("[^%w_]", ""),
					BackgroundTransparency = isCard and 0.44 or 1,
					Size = UDim2.new(1, 0, 0, headerHeight + 4),
					LayoutOrder = opts.LayoutOrder or 7,
					ClipsDescendants = false,
					Parent = parent,
					ThemeTag = isCard and {BackgroundColor3 = "Element"} or nil
				},
				rootChildren
			)

			local currentBodyHeight = 0
			local currentTargetBodyH = 0
			local lastContentY = -1
			local lastCollapsed = Section.Collapsed
			local function applyBodyHeight(bodyH)
				currentBodyHeight = bodyH
				containerHolder.Size = UDim2.new(1, 0, 0, math.max(0, bodyH))
				containerHolder.Visible = bodyH > 0.5
				containerHolder.ClipsDescendants = Section.Collapsed or math.abs(bodyH - currentTargetBodyH) > 0.8
				if Section.Visible then
					local totalH = headerHeight + (bodyH > 0.5 and bodyH or (isCard and 0 or 4))
					Section.Root.Size = UDim2.new(1, 0, 0, totalH)
				end
			end

			local function getExpandedBodyHeight()
				if not Section.Root or not Section.Root.Parent then
					return 0
				end
				local scale = Creator.GetEffectiveScale(Section.Container)
				local contentY = math.ceil(Section.Layout.AbsoluteContentSize.Y / scale)
				return contentY, contentY + bodyPadTop + bodyPadBottom
			end

			local function recomputeSectionHeight(animate, force)
				if not Section.Root or not Section.Root.Parent then
					return
				end
				local contentY, fullBodyH = getExpandedBodyHeight()
				if contentY == lastContentY and Section.Collapsed == lastCollapsed and not animate and not force then
					return
				end
				lastContentY = contentY
				lastCollapsed = Section.Collapsed
				Section.Container.Size = UDim2.new(1, -bodyPadX * 2, 0, contentY)
				local targetBodyH = Section.Collapsed and 0 or fullBodyH
				currentTargetBodyH = targetBodyH
				if animate and not Creator.ReducedMotion then
					containerHolder.ClipsDescendants = true
					Creator.SpringValue(containerHolder, "BodyHeight", targetBodyH, 8.5, 0.94, applyBodyHeight, currentBodyHeight)
				else
					Creator.CancelSpring(containerHolder, "BodyHeight")
					applyBodyHeight(targetBodyH)
				end
			end

			Creator.AddSignal(Section.Layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
				recomputeSectionHeight(false)
			end)
			Creator.RegisterDPIScale(Section.Root, function()
				lastContentY = -1
				task.defer(function()
					recomputeSectionHeight(false)
				end)
			end)

			local badgeUsesAccent = true
			Creator.AddSignal(badgePill:GetPropertyChangedSignal("BackgroundColor3"), function()
				if badgeUsesAccent and badgePill.Visible then
					badgeLabel.TextColor3 = Creator.AutoContrast(badgePill.BackgroundColor3)
				end
			end)

			function Section.SetBadge(text, color)
				if text == nil or text == "" then
					badgePill.Visible = false
					return
				end
				badgeLabel.Text = tostring(text)
				if typeof(color) == "Color3" then
					badgeUsesAccent = false
					Creator.OverrideTag(badgePill, {})
					badgePill.BackgroundColor3 = color
					badgeLabel.TextColor3 = Creator.AutoContrast(color)
				else
					badgeUsesAccent = true
					Creator.OverrideTag(badgePill, {BackgroundColor3 = "Accent"})
					badgeLabel.TextColor3 = Creator.AutoContrast(Creator.GetThemeProperty("Accent"))
				end
				badgePill.Visible = true
			end

			if opts.Badge then
				Section.SetBadge(opts.Badge, opts.BadgeColor)
			end

			function Section.SetCollapsed(isCollapsed, instant)
				if not Section.Collapsible then
					return
				end
				Section.Collapsed = isCollapsed == true
				if chevronIcon then
					local targetRot = Section.Collapsed and -90 or 0
					if instant or Creator.ReducedMotion then
						Creator.CancelSpring(chevronIcon, "Rotation")
						chevronIcon.Rotation = targetRot
					else
						Creator.SpringValue(chevronIcon, "Rotation", targetRot, 9, 0.88)
					end
				end
				recomputeSectionHeight(not instant, true)
				if type(opts.OnToggle) == "function" then
					Library:SafeCallback(opts.OnToggle, not Section.Collapsed)
				end
			end

			function Section.Toggle(instant)
				Section.SetCollapsed(not Section.Collapsed, instant)
			end

			if collapsible then
				Creator.AddSignal(headerRow.MouseEnter, function()
					if chevronIcon then
						Creator.SpringValue(chevronIcon, "ImageTransparency", 0, 10, 1)
					end
					if cardStroke then
						Creator.SpringValue(cardStroke, "Transparency", 0.16, 10, 1)
					end
				end)
				Creator.AddSignal(headerRow.MouseLeave, function()
					if chevronIcon then
						Creator.SpringValue(chevronIcon, "ImageTransparency", 0.04, 10, 1)
					end
					if cardStroke then
						Creator.SpringValue(cardStroke, "Transparency", 0.34, 10, 1)
					end
				end)
				Creator.AddSignal(headerRow.MouseButton1Click, function()
					Section.Toggle(false)
				end)
			end

			function Section.SetVisible(visible)
				Section.Visible = visible == true
				Section.Root.Visible = Section.Visible
				if Section.Visible then
					lastContentY = -1
					recomputeSectionHeight(false)
				else
					Creator.CancelSpring(containerHolder, "BodyHeight")
					Section.Root.Size = UDim2.new(1, 0, 0, 0)
				end
			end

			function Section.SetTitle(newTitle)
				titleLabel.Text = tostring(newTitle or "")
			end

			task.defer(function()
				recomputeSectionHeight(false)
			end)

			return Section
		end
	end,
	[14] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(14)
		local Root = moduleScript.Parent.Parent
		local Flipper, Creator = requireModule(Root.Packages.Flipper), requireModule(Root.Creator)
		local New, Spring, Instant, Components, TabModule =
			Creator.New,
		Flipper.Spring.new,
		Flipper.Instant.new,
		Root.Components,
		{Window = nil, Tabs = {}, Containers = {}, SelectedTab = 0, TabCount = 0}
		function TabModule.Init(_self, window)
			TabModule.Window = window
			return TabModule
		end
		function TabModule.GetCurrentTabPos(_self)
			local activeTab = TabModule.Tabs[TabModule.SelectedTab]
			if not activeTab or not activeTab.Frame or not TabModule.Window or not TabModule.Window.TabHolder then
				return 0
			end
			local tabHolderY, tabY = TabModule.Window.TabHolder.AbsolutePosition.Y, activeTab.Frame.AbsolutePosition.Y
			local scale = Creator.GetEffectiveScale(TabModule.Window.TabHolder)
			return (tabY - tabHolderY) / scale
		end
		function TabModule.New(_self, title, icon, parent)
			local Library, window = requireModule(Root), TabModule.Window
			local elements = Library.Elements
			TabModule.TabCount = TabModule.TabCount + 1
			local tabIndex, Tab = TabModule.TabCount, {Selected = false, Name = title, Type = "Tab", Index = TabModule.TabCount}
			Tab.Id = "tab-" .. tostring(tabIndex) .. "-" .. tostring(title)
			if type(icon) == "string" and icon ~= "" then
				local resolved = Library:GetIcon(icon)
				if resolved then
					icon = resolved
				elseif not icon:match("^rbxassetid://") and not icon:match("^https?://") and not icon:match("^rbxasset://") then
					icon = nil
				end
			else
				icon = nil
			end
			local tabStroke = New(
				"UIStroke",
				{
					Transparency = 1,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					ThemeTag = {Color = "InElementBorder"}
				}
			)
			Tab.Stroke = tabStroke
			local initialLetter = tostring(title or "?"):gsub("<[^>]+>", ""):match("%S") or "?"
			local tabBadge = New(
				"TextLabel",
				{
					Name = "TabInitial",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(20, 20),
					Text = initialLetter:upper(),
					I18nSkip = true,
					FontFace = Creator.Font(Enum.FontWeight.SemiBold),
					TextSize = 12,
					BackgroundTransparency = 1,
					Visible = false,
					ThemeTag = {TextColor3 = "Text"}
				}
			)
			Tab.Frame =
				New(
					"TextButton",
					{
						Size = UDim2.new(1, 0, 0, 34),
						Name = "ATGTab_" .. tostring(tabIndex),
						LayoutOrder = tabIndex,
						BackgroundTransparency = 1,
						ClipsDescendants = true,
						Parent = parent,
						ThemeTag = {BackgroundColor3 = "Tab"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 8)}),
						tabStroke,
						New(
							"TextLabel",
							{
								Name = "TabLabel",
								AnchorPoint = Vector2.new(0, 0.5),
								Position = icon and UDim2.new(0, 32, 0.5, 0) or UDim2.new(0, 12, 0.5, 0),
								Text = title,
								RichText = true,
								TextColor3 = Color3.fromRGB(255, 255, 255),
								TextTransparency = 0.08,
								FontFace = Creator.Font(Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
								TextSize = 13,
								TextXAlignment = "Left",
								TextYAlignment = "Center",
								TextTruncate = Enum.TextTruncate.AtEnd,
								Size = icon and UDim2.new(1, -40, 1, 0) or UDim2.new(1, -20, 1, 0),
								BackgroundTransparency = 1,
								ThemeTag = {TextColor3 = "Text"}
							}
						),
						New(
							"ImageLabel",
							{
								Name = "TabIcon",
								AnchorPoint = Vector2.new(0, 0.5),
								Size = UDim2.fromOffset(16, 16),
								Position = UDim2.new(0, 10, 0.5, 0),
								BackgroundTransparency = 1,
								Image = icon and icon or "",
								Visible = icon ~= nil,
								ImageTransparency = 0.04,
								ThemeTag = {ImageColor3 = "SubText"}
							}
						),
						tabBadge
					}
				)
			Tab.Label = Tab.Frame:FindFirstChild("TabLabel")
			Tab.IconObject = Tab.Frame:FindFirstChild("TabIcon")
			Tab.HasIcon = icon ~= nil
			local tabBadgeText = New(
				"TextLabel",
				{
					Name = "BadgeLabel",
					Text = "",
					I18nSkip = true,
					FontFace = Creator.Font(Enum.FontWeight.SemiBold),
					TextSize = 10,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 1
				}
			)
			local tabBadgePill = New(
				"Frame",
				{
					Name = "TabBadge",
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -8, 0.5, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.fromOffset(0, 16),
					BackgroundTransparency = 0.14,
					Visible = false,
					ZIndex = 3,
					Parent = Tab.Frame,
					ThemeTag = {BackgroundColor3 = "Accent"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(1, 0)}),
					New("UIPadding", {PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}),
					tabBadgeText
				}
			)
			local tabDot = New(
				"Frame",
				{
					Name = "TabDot",
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -5, 0, 5),
					Size = UDim2.fromOffset(6, 6),
					Visible = false,
					ZIndex = 4,
					Parent = Tab.Frame,
					ThemeTag = {BackgroundColor3 = "Accent"}
				},
				{New("UICorner", {CornerRadius = UDim.new(1, 0)})}
			)
			local hasTabBadge = false
			local isTabCollapsed = false
			local tabBadgeUsesAccent = true
			Creator.AddSignal(tabBadgePill:GetPropertyChangedSignal("BackgroundColor3"), function()
				if tabBadgeUsesAccent and hasTabBadge then
					tabBadgeText.TextColor3 = Creator.AutoContrast(tabBadgePill.BackgroundColor3)
				end
			end)
			function Tab.SetBadge(_s, text, color)
				if text == nil or text == "" then
					hasTabBadge = false
					tabBadgePill.Visible = false
					tabDot.Visible = false
					return
				end
				hasTabBadge = true
				tabBadgeText.Text = tostring(text)
				if typeof(color) == "Color3" then
					tabBadgeUsesAccent = false
					Creator.OverrideTag(tabBadgePill, {})
					Creator.OverrideTag(tabDot, {})
					tabBadgePill.BackgroundColor3 = color
					tabDot.BackgroundColor3 = color
					tabBadgeText.TextColor3 = Creator.AutoContrast(color)
				else
					tabBadgeUsesAccent = true
					local acc = Creator.GetThemeProperty("Accent")
					Creator.OverrideTag(tabBadgePill, {BackgroundColor3 = "Accent"})
					Creator.OverrideTag(tabDot, {BackgroundColor3 = "Accent"})
					tabBadgeText.TextColor3 = Creator.AutoContrast(acc)
				end
				tabBadgePill.Visible = not isTabCollapsed
				tabDot.Visible = isTabCollapsed
			end
			Tab.SetCollapsed = function(collapsed)
				collapsed = collapsed == true
				isTabCollapsed = collapsed
				if Tab.Label then
					Tab.Label.Visible = not collapsed
				end
				if Tab.IconObject and Tab.HasIcon then
					if collapsed then
						Tab.IconObject.AnchorPoint = Vector2.new(0.5, 0.5)
						Tab.IconObject.Position = UDim2.fromScale(0.5, 0.5)
					else
						Tab.IconObject.AnchorPoint = Vector2.new(0, 0.5)
						Tab.IconObject.Position = UDim2.new(0, 10, 0.5, 0)
					end
				end
				tabBadge.Visible = collapsed and (not Tab.HasIcon)
				if hasTabBadge then
					tabBadgePill.Visible = not collapsed
					tabDot.Visible = collapsed
				end
			end
			if window and window.SidebarCollapsed then
				Tab.SetCollapsed(true)
			end
			-- Tab.Label is already registered with I18n by Creator.New above.
			local listLayout = New("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder})
			Tab.ContainerFrame =
				New(
					"ScrollingFrame",
					{
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						Parent = window.ContainerHolder,
						Visible = false,
						BottomImage = "rbxassetid://6889812791",
						MidImage = "rbxassetid://6889812721",
						TopImage = "rbxassetid://6276641225",
						ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
						ScrollBarImageTransparency = 0.95,
						ScrollBarThickness = 3,
						BorderSizePixel = 0,
						CanvasSize = UDim2.fromScale(0, 0),
						ScrollingDirection = Enum.ScrollingDirection.Y
					},
					{
						listLayout,
						New(
							"UIPadding",
							{
								PaddingRight = UDim.new(0, 10),
								PaddingLeft = UDim.new(0, 2),
								PaddingTop = UDim.new(0, 2),
								PaddingBottom = UDim.new(0, 6)
							}
						)
					}
				)
			local function syncTabCanvasSize()
				if not Tab.ContainerFrame or not Tab.ContainerFrame.Parent then
					return
				end
				local scale = Creator.GetEffectiveScale(Tab.ContainerFrame)
				Tab.ContainerFrame.CanvasSize = UDim2.new(0, 0, 0, math.ceil(listLayout.AbsoluteContentSize.Y / scale) + 8)
			end
			Creator.AddSignal(
				listLayout:GetPropertyChangedSignal "AbsoluteContentSize",
				syncTabCanvasSize
			)
			Creator.RegisterDPIScale(Tab.ContainerFrame, function()
				task.defer(syncTabCanvasSize)
			end)
			Tab.Motor, Tab.SetTransparency = Creator.SpringMotor(1, Tab.Frame, "BackgroundTransparency")
			Creator.AddSignal(
				Tab.Frame.MouseEnter,
				function()
					if window and type(window.HoverTab) == "function" then
						window:HoverTab(Tab)
					end
					Tab.SetTransparency(Tab.Selected and 0.88 or 1)
				end
			)
			Creator.AddSignal(
				Tab.Frame.MouseLeave,
				function()
					if window and type(window.UnhoverTab) == "function" then
						window:UnhoverTab(Tab)
					end
					Tab.SetTransparency(Tab.Selected and 0.88 or 1)
				end
			)
			Creator.AddSignal(
				Tab.Frame.MouseButton1Down,
				function()
					Tab.SetTransparency(0.92)
				end
			)
			Creator.AddSignal(
				Tab.Frame.MouseButton1Up,
				function()
					Tab.SetTransparency(Tab.Selected and 0.85 or 0.89)
				end
			)
			Creator.AddSignal(
				Tab.Frame.MouseButton1Click,
				function()
					if Tab.SuppressClick then
						Tab.SuppressClick = false
						return
					end
					TabModule:SelectTab(tabIndex)
				end
			)
			TabModule.Containers[tabIndex] = Tab.ContainerFrame
			TabModule.Tabs[tabIndex] = Tab
			Tab.Container = Tab.ContainerFrame
			Tab.ScrollFrame = Tab.Container
			Tab.Select = function()
				TabModule:SelectTab(tabIndex)
			end
			local function decorateSectionTitle(sectionTitle)
				return sectionTitle
			end
			function Tab.AddSection(_self, sectionTitle, sectionOpts)
				local Section, sectionComponent =
					{Type = "Section"},
					requireModule(Components.Section)(type(sectionTitle) == "table" and sectionTitle or decorateSectionTitle(sectionTitle), Tab.Container, sectionOpts)
				Section.Container = sectionComponent.Container
				-- Expose the section frame as an optional, backwards-compatible
				-- handle. Addons can use LayoutOrder/Visible without depending on
				-- private descendants of the tab.
				Section.Root = sectionComponent.Root
				Section.SetVisible = function(selfOrVisible, visible)
					return sectionComponent.SetVisible(type(selfOrVisible) == "boolean" and selfOrVisible or visible)
				end
				Section.SetCollapsed = function(selfOrVal, val, instant)
					if type(selfOrVal) == "boolean" then
						return sectionComponent.SetCollapsed(selfOrVal, val)
					end
					return sectionComponent.SetCollapsed(val, instant)
				end
				Section.Toggle = function(_s, instant)
					return sectionComponent.Toggle(instant)
				end
				Section.SetBadge = function(_s, text, color)
					return sectionComponent.SetBadge(text, color)
				end
				Section.SetTitle = function(_s, newTitle)
					return sectionComponent.SetTitle(newTitle)
				end
				Section.ScrollFrame = Tab.Container
				Section.Tab = Tab
				Section.TabId = Tab.Id
				Section.TabTitle = Tab.Name
				setmetatable(Section, elements)
				return Section
			end
			setmetatable(Tab, elements)
			return Tab
		end
		function TabModule.SelectTab(_self, tabIndex)
			local targetTab = TabModule.Tabs[tabIndex]
			if not targetTab then
				return
			end
			local window = TabModule.Window
			local library = requireModule(Root)
			if type(library._CloseDropdowns) == "function" then
				library._CloseDropdowns()
			end
			TabModule.SelectedTab = tabIndex
			TabModule._TransitionId = (TabModule._TransitionId or 0) + 1
			local transitionId = TabModule._TransitionId
			for _, tab in next, TabModule.Tabs do
				tab.SetTransparency(1)
				tab.Selected = false
				if tab.Stroke then
					Creator.SpringValue(tab.Stroke, "Transparency", 1, 10, 1)
				end
				if tab.Label then
					Creator.SpringValue(tab.Label, "TextTransparency", 0.08, 10, 1)
				end
				if tab.IconObject then
					Creator.OverrideTag(tab.IconObject, {ImageColor3 = "SubText"})
					Creator.SpringValue(tab.IconObject, "ImageTransparency", 0.04, 10, 1)
				end
			end
			targetTab.SetTransparency(0.88)
			targetTab.Selected = true
			if targetTab.Stroke then
				Creator.SpringValue(targetTab.Stroke, "Transparency", 0.78, 10, 1)
			end
			if targetTab.Label then
				Creator.SpringValue(targetTab.Label, "TextTransparency", 0, 10, 1)
			end
			if targetTab.IconObject then
				Creator.OverrideTag(targetTab.IconObject, {ImageColor3 = "Accent"})
				Creator.SpringValue(targetTab.IconObject, "ImageTransparency", 0, 10, 1)
			end
			if library.Workspace and type(library.Workspace.TouchTab) == "function" then
				library.Workspace:TouchTab(targetTab)
			end
			window.TabDisplay.Text = targetTab.Name
			TranslationSystem:Register(window.TabDisplay, targetTab.Name, "Text")
			window.SelectorPosMotor:setGoal(Spring(TabModule:GetCurrentTabPos(), {frequency = 4.0, dampingRatio = 0.86}))
			for _, container in next, TabModule.Containers do
				container.Visible = false
			end
			if TabModule.Containers[tabIndex] then
				TabModule.Containers[tabIndex].Visible = true
			end
			if Creator.ReducedMotion then
				window.ContainerPosMotor:setGoal(Instant(92))
				window.ContainerBackMotor:setGoal(Instant(0))
				return
			end
			-- Instant crisp tab swap + subtle spring glide-in (no nested CanvasGroup UIStroke ghosting).
			window.ContainerPosMotor:setGoal(Instant(100))
			window.ContainerPosMotor:setGoal(Spring(92, {frequency = 7.5}))
			window.ContainerBackMotor:setGoal(Instant(0))
		end
		return TabModule
	end,
	[15] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(15)
		local Root = moduleScript.Parent.Parent
		local Flipper, Creator = requireModule(Root.Packages.Flipper), requireModule(Root.Creator)
		local TextService = Creator.GetService("TextService")
		local New = Creator.New
		local TweenService = Creator.GetService("TweenService")

		return function(parent, acrylic)
			acrylic = acrylic or false
			local Textbox = {}

			-- Input (TextBox) - font size 16 to match CSS
			Textbox.Input =
				New(
					"TextBox",
					{
						FontFace = Creator.Font(Enum.FontWeight.Medium, Enum.FontStyle.Normal),
						TextColor3 = Color3.fromRGB(0, 0, 0),
						TextTransparency = 0,
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 1),
						Position = UDim2.fromOffset(2, 0),
						ClearTextOnFocus = false,
						PlaceholderText = "",
						ZIndex = 1,
						ThemeTag = {TextColor3 = "Text", PlaceholderColor3 = "SubText"}
					}
				)

			-- Container frame (clips descendants)
			Textbox.Container =
				New(
					"Frame",
					{
						BackgroundTransparency = 1,
						ClipsDescendants = true,
						Position = UDim2.new(0, 8, 0, 0),
						Size = UDim2.new(1, -16, 1, 0),
						ZIndex = 1
					},
					{Textbox.Input}
				)

			-- Main frame stroke & corner radius (we'll reuse corner radius for the lines)
			local frameCornerRadius = UDim.new(0, 8) -- same corner radius as main box

			local frameStroke = New(
				"UIStroke",
				{
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Thickness = 1.2,
					Transparency = acrylic and 0.38 or 0.42,
					ThemeTag = {Color = acrylic and "InElementBorder" or "DialogButtonBorder"},
					ZIndex = 1
				}
			)

			-- Stroke color is resolved live from the current theme on FocusLost
			-- so switching themes never reverts the border to an outdated color.
			local defaultStrokeThemeKey = acrylic and "InElementBorder" or "DialogButtonBorder"

			-- Main frame
			Textbox.Frame =
				New(
					"Frame",
					{
						Size = UDim2.new(0, 0, 0, 36),
						BackgroundTransparency = acrylic and 0.28 or 0,
						Parent = parent,
						ThemeTag = {BackgroundColor3 = acrylic and "DialogHolder" or "DialogInput"},
						ZIndex = 0
					},
					{
						New("UICorner", {CornerRadius = frameCornerRadius}),
						frameStroke,
						Textbox.Container
					}
				)

			-- Base line (จาง ๆ) — now inset and with UICorner soปลายโค้งตามกล่องหลัก
			local inset = 3 -- same inset we use for highlight, so ends line up
			Textbox.BaseLine =
				New(
					"Frame",
					{
						Size = UDim2.new(1, -2 * inset, 0, 2), -- full width minus inset each side
						Position = UDim2.new(0, inset, 1, -2),
						AnchorPoint = Vector2.new(0, 0),
						BackgroundColor3 = Creator.GetThemeProperty("Text"),
						BackgroundTransparency = 0.85, -- default: very faint
						ZIndex = 1
					},
					{
						New("UICorner", {CornerRadius = frameCornerRadius}) -- ทำให้ปลายโค้งตามกล่องหลัก
					}
				)
			Textbox.BaseLine.Parent = Textbox.Frame

			-- Highlight / underline (ไฮไลต์สีน้ำเงิน) - starts width 0, also rounded
			Textbox.Highlight =
				New(
					"Frame",
					{
						Size = UDim2.new(0, 0, 0, 2), -- start at width 0
						Position = UDim2.new(0, inset, 1, -2), -- same inset as baseline
						AnchorPoint = Vector2.new(0, 0),
						BackgroundTransparency = 0,
						ZIndex = 2,
						ThemeTag = {BackgroundColor3 = acrylic and "InputIndicator" or "DialogInputLine"}
					},
					{
						New("UICorner", {CornerRadius = frameCornerRadius}) -- ปลายโค้ง
					}
				)
			Textbox.Highlight.Parent = Textbox.Frame

			-- Floating label (input-label)
			Textbox.Label =
				New(
					"TextLabel",
					{
						Text = "",
						FontFace = Creator.Font(Enum.FontWeight.Regular),
						TextSize = 16,
						TextColor3 = Creator.GetThemeProperty("SubText"),
						TextTransparency = 1, -- เริ่มโปร่งตาม CSS
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -24, 0, 18),
						Position = UDim2.new(0, 12, 0, 0),
						AnchorPoint = Vector2.new(0, 0),
						ZIndex = 3,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						ThemeTag = {TextColor3 = "SubText"}
					}
				)
			Textbox.Label.Parent = Textbox.Frame

			-- Helper tweens to match CSS transitions: duration 0.3, easing "ease" -> use Sine Out
			local TWEEN_TIME = 0.3
			local EASING = Enum.EasingStyle.Sine
			local DIR = Enum.EasingDirection.Out

			-- Functions to animate label and highlight exactly like CSS rules
			local function floatLabel(instant)
				instant = instant or false
				local targetPos = UDim2.new(0, 12, 0, -20) -- top: -20px
				local targetSize = 12
				local color = Creator.GetThemeProperty("Accent")
				if instant then
					Textbox.Label.Position = targetPos
					Textbox.Label.TextSize = targetSize
					Textbox.Label.TextColor3 = color
					Textbox.Label.TextTransparency = 0
				else
					TweenService:Create(Textbox.Label, TweenInfo.new(TWEEN_TIME, EASING, DIR), {
						Position = targetPos,
						TextTransparency = 0
					}):Play()
					TweenService:Create(Textbox.Label, TweenInfo.new(TWEEN_TIME, EASING, DIR), {TextSize = targetSize, TextColor3 = color}):Play()
				end
			end

			local function sinkLabel(instant)
				instant = instant or false
				local originPos = UDim2.new(0, 12, 0, 0) -- top: 0
				local originSize = 16
				local originColor = Creator.GetThemeProperty("SubText")
				if instant then
					Textbox.Label.Position = originPos
					Textbox.Label.TextSize = originSize
					Textbox.Label.TextColor3 = originColor
					Textbox.Label.TextTransparency = 1
				else
					TweenService:Create(Textbox.Label, TweenInfo.new(TWEEN_TIME, EASING, DIR), {
						Position = originPos,
						TextTransparency = 1
					}):Play()
					TweenService:Create(Textbox.Label, TweenInfo.new(TWEEN_TIME, EASING, DIR), {TextSize = originSize, TextColor3 = originColor}):Play()
				end
			end

			local function expandHighlight(instant)
				instant = instant or false
				-- ขยายให้เต็มความกว้าง minus inset เพื่อให้มุมโค้งยังเห็นผลทั้งสองด้าน
				local target = UDim2.new(1, -2 * inset, 0, 2)
				local targetPos = UDim2.new(0, inset, 1, -2)
				if instant then
					Textbox.Highlight.Size = target
					Textbox.Highlight.Position = targetPos
				else
					TweenService:Create(Textbox.Highlight, TweenInfo.new(TWEEN_TIME, EASING, DIR), {Size = target, Position = targetPos}):Play()
				end
			end

			local function collapseHighlight(instant)
				instant = instant or false
				local target = UDim2.new(0, 0, 0, 2)
				local pos = UDim2.new(0, inset, 1, -2)
				if instant then
					Textbox.Highlight.Size = target
					Textbox.Highlight.Position = pos
				else
					TweenService:Create(Textbox.Highlight, TweenInfo.new(TWEEN_TIME, EASING, DIR), {Size = target, Position = pos}):Play()
				end
			end

			-- Animate baseline "เข้มขึ้น" เมื่อโฟกัส/พิมพ์: ลด transparency (มากขึ้น) และเปลี่ยนโทนสีเล็กน้อย
			local function emphasizeBaseLine(instant)
				instant = instant or false
				if instant then
					Textbox.BaseLine.BackgroundTransparency = 0.6
					Textbox.BaseLine.BackgroundColor3 = Creator.GetThemeProperty("Text")
				else
					TweenService:Create(Textbox.BaseLine, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.6, BackgroundColor3 = Creator.GetThemeProperty("Text")}):Play()
				end
			end

			local function deEmphasizeBaseLine(instant)
				instant = instant or false
				if instant then
					Textbox.BaseLine.BackgroundTransparency = 0.85
					Textbox.BaseLine.BackgroundColor3 = Creator.GetThemeProperty("Text")
				else
					TweenService:Create(Textbox.BaseLine, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.85, BackgroundColor3 = Creator.GetThemeProperty("Text")}):Play()
				end
			end

			-- Keep the caret visible without moving the whole TextBox off-screen.
			-- The old calculation ran before AbsoluteSize/TextBounds had settled,
			-- which could leave a focused input at a negative X offset until blur.
			local function setInputOffset(offset)
				if Textbox.Input.Position.X.Offset ~= offset or Textbox.Input.Position.Y.Offset ~= 0 then
					Textbox.Input.Position = UDim2.fromOffset(offset, 0)
				end
			end

			local function getCursorWidth(beforeCursor, textWidth)
				if #beforeCursor == 0 then
					return 0
				end

				local inputFont = Textbox.Input.Font
				if inputFont ~= Enum.Font.Unknown then
					local measured, textSize = pcall(function()
						return TextService:GetTextSize(
							beforeCursor,
							Textbox.Input.TextSize,
							inputFont,
							Vector2.new(math.huge, math.huge)
						)
					end)
					if measured and textSize then
						return textSize.X
					end
				end

				-- Custom FontFace reports Enum.Font.Unknown to TextService. Use the
				-- rendered TextBounds for a safe approximation instead of emitting
				-- an error or shifting all input text outside its clipped container.
				local fullText = Textbox.Input.Text
				if textWidth > 0 and #fullText > 0 then
					return textWidth * math.clamp(#beforeCursor / #fullText, 0, 1)
				end
				return 0
			end

			local function adjustInputPosition()
				local pad = 2
				local width = Textbox.Container.AbsoluteSize.X
				if width <= 2 * pad then
					-- Layout has not resolved yet. Leave the input in a safe position;
					-- AbsoluteSize will trigger a second pass once it is visible.
					setInputOffset(pad)
					return
				end

				local textWidth = math.max(0, Textbox.Input.TextBounds.X)
				if not Textbox.Input:IsFocused() or textWidth <= width - 2 * pad then
					setInputOffset(pad)
					return
				end

				local cursorPosition = Textbox.Input.CursorPosition
				if not cursorPosition or cursorPosition < 1 then
					return
				end

				local beforeCursor = string.sub(Textbox.Input.Text, 1, cursorPosition - 1)
				local cursorWidth = getCursorWidth(beforeCursor, textWidth)
				local targetOffset = Textbox.Input.Position.X.Offset
				local cursorX = targetOffset + cursorWidth
				local rightEdge = width - pad
				if cursorX < pad then
					targetOffset = pad - cursorWidth
				elseif cursorX > rightEdge then
					targetOffset = rightEdge - cursorWidth
				end

				-- Clamp to the text's real rendered bounds so a stale metric cannot
				-- hide the entire value while the user is still typing.
				local minimumOffset = math.min(pad, width - pad - textWidth)
				setInputOffset(math.clamp(targetOffset, minimumOffset, pad))
			end

			if Textbox.Input.Text and #Textbox.Input.Text > 0 then
				task.spawn(adjustInputPosition)
			end
			Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("Text"), adjustInputPosition)
			Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("CursorPosition"), adjustInputPosition)
			Creator.AddSignal(Textbox.Container:GetPropertyChangedSignal("AbsoluteSize"), adjustInputPosition)
			pcall(function()
				Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("TextBounds"), adjustInputPosition)
			end)

			-- Focus behavior: match CSS :focus rules (0.3s transitions), plus our extra emphasis
			Creator.AddSignal(Textbox.Input.Focused, function()
				adjustInputPosition()
				floatLabel(false)
				expandHighlight(false)

				-- Emphasize baseline
				emphasizeBaseLine(false)

				-- Stroke animation: make it darker/visible
				TweenService:Create(frameStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Transparency = 0.14,
					Thickness = 1.6,
					Color = Creator.GetThemeProperty("Accent")
				}):Play()

				TweenService:Create(Textbox.Frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = acrylic and 0.14 or 0}):Play()
				Creator.OverrideTag(Textbox.Frame, {BackgroundColor3 = "DialogHolder"})
				Creator.OverrideTag(Textbox.Highlight, {BackgroundColor3 = "Accent"})
			end)

			Creator.AddSignal(Textbox.Input.FocusLost, function()
				adjustInputPosition()
				local hasText = Textbox.Input.Text and #Textbox.Input.Text > 0
				if not hasText then
					sinkLabel(false)
				else
					floatLabel(false)
				end

				collapseHighlight(false)

				-- De-emphasize baseline
				deEmphasizeBaseLine(false)

				-- Stroke return: revert color/transparency/thickness back using live theme
				TweenService:Create(frameStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Transparency = acrylic and 0.38 or 0.42,
					Thickness = 1.2,
					Color = Creator.GetThemeProperty(defaultStrokeThemeKey)
				}):Play()

				TweenService:Create(Textbox.Frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = acrylic and 0.28 or 0}):Play()
				Creator.OverrideTag(Textbox.Frame, {BackgroundColor3 = acrylic and "DialogHolder" or "DialogInput"})
				Creator.OverrideTag(Textbox.Highlight, {BackgroundColor3 = acrylic and "InputIndicator" or "DialogInputLine"})
			end)

			-- Text change: emphasize baseline while typing
			Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("Text"), function()
				if Textbox.Input.Text and #Textbox.Input.Text > 0 then
					-- if user types and the field is focused we keep baseline emphasized
					if Textbox.Input:IsFocused() then
						emphasizeBaseLine(false)
					else
						-- if not focused but has text keep label floated
						floatLabel(false)
					end
				else
					if not Textbox.Input:IsFocused() then
						deEmphasizeBaseLine(false)
					end
				end
			end)

			-- initial state: follow CSS initial
			if Textbox.Input.Text and #Textbox.Input.Text > 0 then
				floatLabel(true)
				collapseHighlight(true)
				deEmphasizeBaseLine(true)
			else
				sinkLabel(true)
				collapseHighlight(true)
				deEmphasizeBaseLine(true)
			end

			return Textbox
		end
	end,
	[16] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(16)
		local Root, Assets = moduleScript.Parent.Parent, requireModule(moduleScript.Parent.Assets)
		local Creator = requireModule(Root.Creator)
		local New, AddSignal = Creator.New, Creator.AddSignal
		return function(config)
			local TitleBar, Library = {}, requireModule(Root)

			local function BarButton(icon, position, parent, callback, isDanger)
				local Button = {
					Callback = callback or function()
					end
				}
				local hoverBg = isDanger and Color3.fromRGB(232, 68, 86) or nil
				local iconImg = New(
					"ImageLabel",
					{
						Image = icon,
						Size = UDim2.fromOffset(14, 14),
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Name = "Icon",
						ThemeTag = {ImageColor3 = "Text"}
					}
				)
				Button.Frame =
					New(
						"TextButton",
						{
							Size = UDim2.fromOffset(30, 30),
							AnchorPoint = Vector2.new(1, 0.5),
							BackgroundTransparency = 1,
							BackgroundColor3 = hoverBg or Color3.fromRGB(255, 255, 255),
							Parent = parent,
							Position = position,
							Text = "",
							ThemeTag = isDanger and {} or {BackgroundColor3 = "Text"}
						},
						{
							New("UICorner", {CornerRadius = UDim.new(0, 8)}),
							iconImg
						}
					)
				local hoverAlpha = isDanger and 0.16 or 0.91
				local downAlpha = isDanger and 0.05 or 0.86
				AddSignal(Button.Frame.MouseEnter, function()
					Creator.SpringValue(Button.Frame, "BackgroundTransparency", hoverAlpha, 10, 1)
					if isDanger then
						Creator.AnimateColor(iconImg, "ImageColor3", Color3.fromRGB(255, 255, 255), 0.12)
					end
				end)
				AddSignal(Button.Frame.MouseLeave, function()
					Creator.SpringValue(Button.Frame, "BackgroundTransparency", 1, 10, 1)
					if isDanger then
						Creator.AnimateColor(iconImg, "ImageColor3", Creator.GetThemeProperty("Text"), 0.15)
					end
				end)
				AddSignal(Button.Frame.MouseButton1Down, function()
					Creator.SpringValue(Button.Frame, "BackgroundTransparency", downAlpha, 12, 1)
				end)
				AddSignal(Button.Frame.MouseButton1Up, function()
					Creator.SpringValue(Button.Frame, "BackgroundTransparency", hoverAlpha, 10, 1)
				end)
				AddSignal(Button.Frame.MouseButton1Click, function()
					Button.Callback()
				end)
				Button.SetCallback = function(cb)
					Button.Callback = cb
				end
				return Button
			end

			local hasSubTitle = type(config.SubTitle) == "string" and config.SubTitle ~= ""
			local subTitlePill = New(
				"Frame",
				{
					Name = "SubTitlePill",
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.fromOffset(0, 20),
					BackgroundTransparency = 0.84,
					Visible = hasSubTitle,
					LayoutOrder = 3,
					ThemeTag = {BackgroundColor3 = "Accent"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(1, 0)}),
					New("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}),
					New("UIStroke", {Transparency = 0.72, Thickness = 1, ThemeTag = {Color = "Accent"}}),
					New(
						"TextLabel",
						{
							Name = "SubTitleLabel",
							RichText = true,
							Text = config.SubTitle or "",
							TextTransparency = 0,
							FontFace = Creator.Font(Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
							TextSize = 11,
							TextXAlignment = "Center",
							TextYAlignment = "Center",
							AutomaticSize = Enum.AutomaticSize.X,
							Size = UDim2.new(0, 0, 1, 0),
							BackgroundTransparency = 1,
							ThemeTag = {TextColor3 = "Text"}
						}
					)
				}
			)

			TitleBar.TitleText = config.Title or ""
			TitleBar.Frame =
				New(
					"Frame",
					{Size = UDim2.new(1, 0, 0, 46), BackgroundTransparency = 1, ZIndex = 5, Parent = config.Parent},
					{
						New(
							"Frame",
							{Size = UDim2.new(1, -222, 1, 0), Position = UDim2.new(0, 14, 0, 0), BackgroundTransparency = 1},
							{
								New(
									"UIListLayout",
									{
										Padding = UDim.new(0, 8),
										FillDirection = Enum.FillDirection.Horizontal,
										SortOrder = Enum.SortOrder.LayoutOrder,
										VerticalAlignment = Enum.VerticalAlignment.Center
									}
								),
								New(
									"ImageLabel",
									{
										Name = "WindowIcon",
										Image = config.Icon or "rbxassetid://90989180960460",
										Size = UDim2.fromOffset(26, 26),
										BackgroundTransparency = 1,
										LayoutOrder = 1,
										ScaleType = Enum.ScaleType.Fit,
										ThemeTag = {ImageColor3 = "Text"}
									}
								),
								New(
									"TextLabel",
									{
										Name = "TitleLabel",
										RichText = true,
										Text = config.Title or "",
										FontFace = Creator.Font(Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
										TextSize = 14,
										TextXAlignment = "Left",
										TextYAlignment = "Center",
										AutomaticSize = Enum.AutomaticSize.X,
										Size = UDim2.new(0, 0, 1, 0),
										BackgroundTransparency = 1,
										LayoutOrder = 2,
										ThemeTag = {TextColor3 = "Text"}
									}
								),
								subTitlePill
							}
						),
						New(
							"Frame",
							{
								BackgroundTransparency = 0.55,
								Size = UDim2.new(1, -16, 0, 1),
								Position = UDim2.new(0, 8, 1, -1),
								ThemeTag = {BackgroundColor3 = "TitleBarLine"}
							},
							{
								New(
									"UIGradient",
									{
										Transparency = NumberSequence.new({
											NumberSequenceKeypoint.new(0, 0.85),
											NumberSequenceKeypoint.new(0.1, 0.15),
											NumberSequenceKeypoint.new(0.9, 0.15),
											NumberSequenceKeypoint.new(1, 0.85)
										})
									}
								)
							}
						)
					}
				)

			TitleBar.CloseButton =
				BarButton(
					Assets.Close,
					UDim2.new(1, -8, 0.5, 0),
					TitleBar.Frame,
					function()
						Library.Window:Dialog {
							Title = "Close",
							Content = "Are you sure you want to unload the interface?",
							Buttons = {
								{
									Title = "Yes",
									Callback = function()
										Library:Destroy()
									end
								},
								{Title = "No"}
							}
						}
					end,
					true
				)

			TitleBar.MaxButton =
				BarButton(
					Assets.Max,
					UDim2.new(1, -42, 0.5, 0),
					TitleBar.Frame,
					function()
						config.Window.Maximize(not config.Window.Maximized)
					end,
					false
				)
			TitleBar.MinButton =
				BarButton(
					Assets.Min,
					UDim2.new(1, -76, 0.5, 0),
					TitleBar.Frame,
					function()
						Library.Window:Minimize()
					end,
					false
				)

			-- Sleek Ctrl+K Spotlight trigger pill (clickable on both PC and Mobile)
			local searchStroke = New(
				"UIStroke",
				{
					Transparency = 0.4,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					ThemeTag = {Color = "InElementBorder"}
				}
			)
			local searchPill = New(
				"TextButton",
				{
					Name = "CommandPaletteButton",
					Text = "",
					AutoButtonColor = false,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -112, 0.5, 0),
					Size = UDim2.fromOffset(82, 24),
					BackgroundTransparency = 0.46,
					Parent = TitleBar.Frame,
					ThemeTag = {BackgroundColor3 = "Element"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(0, 7)}),
					searchStroke,
					New("ImageLabel", {
						Name = "Icon",
						Image = Library:GetIcon("search") or "",
						Size = UDim2.fromOffset(12, 12),
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 8, 0.5, 0),
						BackgroundTransparency = 1,
						ImageTransparency = 0,
						ThemeTag = {ImageColor3 = "SubText"}
					}),
					New("TextLabel", {
						Name = "Hint",
						Text = "Ctrl+K",
						I18nSkip = true,
						FontFace = Creator.Font(Enum.FontWeight.SemiBold),
						TextSize = 10,
						TextXAlignment = Enum.TextXAlignment.Right,
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -8, 0.5, 0),
						Size = UDim2.fromOffset(46, 16),
						BackgroundTransparency = 1,
						TextTransparency = 0,
						ThemeTag = {TextColor3 = "SubText"}
					})
				}
			)
			AddSignal(searchPill.MouseEnter, function()
				Creator.SpringValue(searchPill, "BackgroundTransparency", 0.24, 10, 1)
				Creator.SpringValue(searchStroke, "Transparency", 0.18, 10, 1)
			end)
			AddSignal(searchPill.MouseLeave, function()
				Creator.SpringValue(searchPill, "BackgroundTransparency", 0.46, 10, 1)
				Creator.SpringValue(searchStroke, "Transparency", 0.4, 10, 1)
			end)
			AddSignal(searchPill.MouseButton1Click, function()
				if type(Library.ToggleCommandPalette) == "function" then
					Library:ToggleCommandPalette()
				end
			end)
			TitleBar.CommandPaletteButton = searchPill
			return TitleBar
		end
	end,
	[17] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(17)
		local Root = moduleScript.Parent.Parent
		local Flipper, Creator, Acrylic, Assets, Components = requireModule(Root.Packages.Flipper), requireModule(Root.Creator), requireModule(Root.Acrylic), requireModule(moduleScript.Parent.Assets), moduleScript.Parent
		local UserInputService, Players, Workspace = Creator.GetService("UserInputService"), Creator.GetService("Players"), Creator.GetService("Workspace")
		local mouse, camera = Players.LocalPlayer:GetMouse(), Workspace.CurrentCamera
		local Spring, Instant, New = Flipper.Spring.new, Flipper.Instant.new, Creator.New
		-- Space kept between the window and the screen edges on small screens,
		-- and how much of the title bar must stay on screen while dragging.
		local SCREEN_MARGIN = 16
		local VISIBLE_TITLE = 40
		return function(config)
			-- A window larger than the screen is shrunk to fit (phones).
			local viewport = camera.ViewportSize
			config.Size = UDim2.fromOffset(
				math.max(200, math.min(config.Size.X.Offset, viewport.X - SCREEN_MARGIN * 2)),
				math.max(160, math.min(config.Size.Y.Offset, viewport.Y - SCREEN_MARGIN * 2))
			)
			local Library, Window, dragging, dragInput, mousePos, startPos =
				requireModule(Root),
			{
				Minimized = false,
				Maximized = false,
				Size = config.Size,
				CurrentPos = 0,
				Position = UDim2.fromOffset(
					camera.ViewportSize.X / 2 - config.Size.X.Offset / 2,
					camera.ViewportSize.Y / 2 - config.Size.Y.Offset / 2
				)
			},
			false
			local resizing, resizePos = false
			local minimizeNotified = false
			local defaultTabWidth = math.clamp(tonumber(config.TabWidth) or 166, 120, 260)
			config.TabWidth = defaultTabWidth
			local COLLAPSED_SIDEBAR_W = 46
			local MIN_SIDEBAR_W = 120
			local MAX_SIDEBAR_W = 260
			local SNAP_COLLAPSE_W = 88
			Window.SidebarCollapsed = false
			Window.ExpandedTabWidth = defaultTabWidth
			Window.AcrylicPaint = Acrylic.AcrylicPaint({Radius = Creator.Radius.Window, Shadow = false})
			local selector, resizeStartFrame =
				New(
					"Frame",
					{
						Size = UDim2.fromOffset(3, 16),
						BackgroundColor3 = Color3.fromRGB(99, 179, 255),
						Position = UDim2.fromOffset(2, 17),
						AnchorPoint = Vector2.new(0, 0.5),
						ZIndex = 4,
						ThemeTag = {BackgroundColor3 = "Accent"}
					},
					{New("UICorner", {CornerRadius = UDim.new(1, 0)})}
				),
			New(
				"Frame",
				{Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, Active = true, Position = UDim2.new(1, -20, 1, -20), ZIndex = 8}
			)
			Window.TabHolder =
				New(
					"ScrollingFrame",
					{
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						ScrollBarImageTransparency = 1,
						ScrollBarThickness = 0,
						BorderSizePixel = 0,
						CanvasSize = UDim2.fromScale(0, 0),
						ScrollingDirection = Enum.ScrollingDirection.Y
					},
					{
						New("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}),
						New(
							"UIPadding",
							{
								PaddingTop = UDim.new(0, 2),
								PaddingBottom = UDim.new(0, 2),
								PaddingLeft = UDim.new(0, 2),
								PaddingRight = UDim.new(0, 2)
							}
						)
					}
				)
			local tabHoverStroke = New(
				"UIStroke",
				{
					Transparency = 1,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					ThemeTag = {Color = "InElementBorder"}
				}
			)
			local tabHoverPill = New(
				"Frame",
				{
					Name = "TabHoverPill",
					Size = UDim2.new(1, -4, 0, 34),
					Position = UDim2.fromOffset(2, 0),
					BackgroundTransparency = 1,
					ZIndex = 0,
					ThemeTag = {BackgroundColor3 = "Tab"}
				},
				{New("UICorner", {CornerRadius = UDim.new(0, 8)}), tabHoverStroke}
			)
			local showProfileCard = config.ShowProfileCard ~= false
			local footerReserve = showProfileCard and 98 or 50
			Window.SidebarFooterReserve = footerReserve
			local tabFrame =
				New(
					"Frame",
					{
						Size = UDim2.new(0, config.TabWidth, 1, -(56 + footerReserve)),
						Position = UDim2.new(0, 12, 0, 56),
						BackgroundTransparency = 1,
						ClipsDescendants = true
					},
					{tabHoverPill, Window.TabHolder, selector}
				)
			-- Bottom Sidebar Collapse/Expand Footer Button (pinned above Profile Card)
			local sidebarCloseIcon = Library:GetIcon("panel-left-close") or Library:GetIcon("chevrons-left") or Assets.Min
			local sidebarOpenIcon = Library:GetIcon("panel-left-open") or Library:GetIcon("chevrons-right") or Assets.Max
			local sidebarFooterIcon = New(
				"ImageLabel",
				{
					Name = "Icon",
					Image = sidebarCloseIcon,
					Size = UDim2.fromOffset(16, 16),
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 10, 0.5, 0),
					BackgroundTransparency = 1,
					ImageTransparency = 0,
					ThemeTag = {ImageColor3 = "Text"}
				}
			)
			local sidebarFooterLabel = New(
				"TextLabel",
				{
					Name = "Label",
					Text = "Collapse",
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 32, 0.5, 0),
					Size = UDim2.new(1, -40, 1, 0),
					FontFace = Creator.Font(Enum.FontWeight.Medium),
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					BackgroundTransparency = 1,
					TextTransparency = 0.04,
					ThemeTag = {TextColor3 = "SubText"}
				}
			)
			local sidebarFooterSep = New(
				"Frame",
				{
					Name = "SidebarFooterSep",
					Size = UDim2.new(0, config.TabWidth, 0, 1),
					Position = UDim2.new(0, 12, 1, showProfileCard and -94 or -46),
					BackgroundTransparency = 0.62,
					ZIndex = 6,
					ThemeTag = {BackgroundColor3 = "TitleBarLine"}
				}
			)
			local sidebarFooterStroke = New(
				"UIStroke",
				{
					Transparency = 1,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					ThemeTag = {Color = "InElementBorder"}
				}
			)
			local sidebarFooterBtn = New(
				"TextButton",
				{
					Name = "SidebarCollapseButton",
					Size = UDim2.new(0, config.TabWidth, 0, showProfileCard and 28 or 32),
					Position = UDim2.new(0, 12, 1, showProfileCard and -88 or -40),
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Text = "",
					ZIndex = 6,
					ThemeTag = {BackgroundColor3 = "Tab"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(0, 8)}),
					sidebarFooterStroke,
					sidebarFooterIcon,
					sidebarFooterLabel
				}
			)
			Creator.AddSignal(sidebarFooterBtn.MouseEnter, function()
				Creator.SpringValue(sidebarFooterBtn, "BackgroundTransparency", 0.84, 5.2, 1)
				Creator.SpringValue(sidebarFooterStroke, "Transparency", 0.62, 5.2, 1)
				Creator.SpringValue(sidebarFooterIcon, "ImageTransparency", 0, 5.2, 1)
				Creator.SpringValue(sidebarFooterLabel, "TextTransparency", 0, 5.2, 1)
			end)
			Creator.AddSignal(sidebarFooterBtn.MouseLeave, function()
				Creator.SpringValue(sidebarFooterBtn, "BackgroundTransparency", 1, 5.2, 1)
				Creator.SpringValue(sidebarFooterStroke, "Transparency", 1, 5.2, 1)
				Creator.SpringValue(sidebarFooterIcon, "ImageTransparency", 0.12, 5.2, 1)
				Creator.SpringValue(sidebarFooterLabel, "TextTransparency", 0.12, 5.2, 1)
			end)
			Creator.AddSignal(sidebarFooterBtn.MouseButton1Click, function()
				Window:ToggleSidebar()
			end)
			Window.SidebarCollapseButton = sidebarFooterBtn

			-- Luaward-style Sidebar Profile Card (borderless at rest, lifts on hover/open, Avatar with accent ring)
			local localPlr = Players.LocalPlayer
			local uid = localPlr and localPlr.UserId or 1
			local avatarThumb = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(uid) .. "&w=100&h=100"
			local avatarImg = New("ImageLabel", {
				Name = "AvatarImage",
				Image = avatarThumb,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1
			}, {New("UICorner", {CornerRadius = UDim.new(1, 0)})})
			local shieldImg = New("ImageLabel", {
				Name = "PrivacyIcon",
				Image = Library:GetIcon("shield") or "",
				Size = UDim2.fromOffset(15, 15),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
				Visible = false,
				ThemeTag = {ImageColor3 = "Accent"}
			})
			local avatarRingStroke = New("UIStroke", {Transparency = 0.42, Thickness = 1.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "Accent"}})
			local avatarHolder = New(
				"Frame",
				{
					Name = "Avatar",
					Size = UDim2.fromOffset(30, 30),
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 7, 0.5, 0),
					BackgroundTransparency = 0.2,
					ThemeTag = {BackgroundColor3 = "DialogHolder"}
				},
				{New("UICorner", {CornerRadius = UDim.new(1, 0)}), avatarRingStroke, avatarImg, shieldImg}
			)
			local profileDisplayLbl = New("TextLabel", {
				Name = "DisplayName",
				Text = localPlr and localPlr.DisplayName or "Player",
				I18nSkip = true,
				FontFace = Creator.Font(Enum.FontWeight.Bold),
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Position = UDim2.fromOffset(0, 3),
				Size = UDim2.new(1, 0, 0, 16),
				BackgroundTransparency = 1,
				ThemeTag = {TextColor3 = "Text"}
			})
			local profileUserLbl = New("TextLabel", {
				Name = "Username",
				Text = "@" .. (localPlr and localPlr.Name or "player"),
				I18nSkip = true,
				FontFace = Creator.Font(Enum.FontWeight.Medium),
				TextSize = 11,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Position = UDim2.fromOffset(0, 19),
				Size = UDim2.new(1, 0, 0, 14),
				BackgroundTransparency = 1,
				ThemeTag = {TextColor3 = "SubText"}
			})
			local profileTextCol = New(
				"Frame",
				{
					Name = "TextCol",
					Position = UDim2.fromOffset(44, 5),
					Size = UDim2.new(1, -68, 1, -10),
					BackgroundTransparency = 1,
					ClipsDescendants = true
				},
				{profileDisplayLbl, profileUserLbl}
			)
			local profileChev = New("ImageLabel", {
				Name = "Chevron",
				Image = Library:GetIcon("chevrons-up-down") or Library:GetIcon("chevron-down") or "",
				Size = UDim2.fromOffset(14, 14),
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -8, 0.5, 0),
				BackgroundTransparency = 1,
				ThemeTag = {ImageColor3 = "SubText"}
			})
			local profileCardStroke = New("UIStroke", {Transparency = 1, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "InElementBorder"}})
			local profileCard = New(
				"TextButton",
				{
					Name = "SidebarProfileCard",
					Size = UDim2.new(0, config.TabWidth, 0, 46),
					Position = UDim2.new(0, 12, 1, -56),
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Visible = showProfileCard,
					Text = "",
					ZIndex = 6,
					ThemeTag = {BackgroundColor3 = "Tab"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(0, 10)}),
					profileCardStroke,
					avatarHolder,
					profileTextCol,
					profileChev
				}
			)
			Window.ProfileCard = profileCard

			local profileCardHovered = false
			local profileMenuOpened = false
			local function syncProfileCardVisual()
				local bgT = profileMenuOpened and 0.78 or (profileCardHovered and 0.85 or 1)
				local stT = profileMenuOpened and 0.48 or (profileCardHovered and 0.66 or 1)
				Creator.SpringValue(profileCard, "BackgroundTransparency", bgT, 5.2, 1)
				Creator.SpringValue(profileCardStroke, "Transparency", stT, 5.2, 1)
			end
			function Window.SetProfileMenuOpen(isOpen)
				profileMenuOpened = isOpen == true
				syncProfileCardVisual()
			end

			function Window.UpdateProfileCard()
				local priv = type(Library.GetPrivacyMode) == "function" and Library:GetPrivacyMode() or {Hidden = false, Alias = "Anonymous", HideAvatar = false}
				if priv.Hidden then
					profileDisplayLbl.Text = tostring(priv.Alias or "Anonymous")
					profileUserLbl.Text = "Name hidden"
					Creator.OverrideTag(avatarRingStroke, {Color = "Accent"})
					avatarRingStroke.Transparency = 0.22
				else
					profileDisplayLbl.Text = localPlr and localPlr.DisplayName or "Player"
					profileUserLbl.Text = "@" .. (localPlr and localPlr.Name or "player")
					Creator.OverrideTag(avatarRingStroke, {Color = "Accent"})
					avatarRingStroke.Transparency = 0.45
				end
				local hideAv = priv.HideAvatar == true
				avatarImg.Visible = not hideAv
				shieldImg.Visible = hideAv
			end
			Window.UpdateProfileCard()

			Creator.AddSignal(profileCard.MouseEnter, function()
				profileCardHovered = true
				syncProfileCardVisual()
			end)
			Creator.AddSignal(profileCard.MouseLeave, function()
				profileCardHovered = false
				syncProfileCardVisual()
			end)
			Creator.AddSignal(profileCard.MouseButton1Click, function()
				if type(Library.ToggleProfileMenu) == "function" then
					Library:ToggleProfileMenu(profileCard)
				end
			end)
			local sidebarDividerLine =
				New(
					"Frame",
					{
						Name = "Line",
						AnchorPoint = Vector2.new(0.5, 0),
						Size = UDim2.new(0, 1, 1, 0),
						Position = UDim2.fromScale(0.5, 0),
						BackgroundTransparency = 0.65,
						BorderSizePixel = 0,
						ThemeTag = {BackgroundColor3 = "TitleBarLine"}
					},
					{
						New(
							"UIGradient",
							{
								Rotation = 90,
								Transparency = NumberSequence.new({
									NumberSequenceKeypoint.new(0, 0.8),
									NumberSequenceKeypoint.new(0.12, 0.15),
									NumberSequenceKeypoint.new(0.88, 0.15),
									NumberSequenceKeypoint.new(1, 0.85)
								})
							}
						)
					}
				)
			-- Interactive 10px drag handle on the right edge of the sidebar (Luaward Dashboard style)
			local sidebarDivider =
				New(
					"Frame",
					{
						Name = "SidebarDivider",
						Size = UDim2.new(0, 10, 1, -56),
						Position = UDim2.new(0, config.TabWidth + 15, 0, 50),
						BackgroundTransparency = 1,
						Active = true,
						ZIndex = 7
					},
					{sidebarDividerLine}
				)
			Window.SidebarDivider = sidebarDivider
			Window.TabArea = tabFrame
			Window.TabSelector = selector
			Window.TabWidth = config.TabWidth
			Window.TabDisplay =
				New(
					"TextLabel",
					{
						RichText = true,
						Text = "Tab",
						I18nSkip = true,
						TextTransparency = 0,
						FontFace = Creator.Font(Enum.FontWeight.SemiBold, Enum.FontStyle.Normal, "Display"),
						TextSize = 24,
						TextXAlignment = "Left",
						TextYAlignment = "Center",
						Size = UDim2.new(1, -config.TabWidth - 46, 0, 28),
						Position = UDim2.fromOffset(config.TabWidth + 32, 56),
						BackgroundTransparency = 1,
						ThemeTag = {TextColor3 = "Text"}
					}
				)
			-- Frame (not nested CanvasGroup) so UIStrokes inside tabs never desync or linger
			-- behind Window.VisualFrame's outer CanvasGroup during minimize/restore or tab switches.
			Window.ContainerHolder =
				New(
					"Frame",
					{
						Size = UDim2.new(1, -config.TabWidth - 40, 1, -104),
						Position = UDim2.fromOffset(config.TabWidth + 32, 92),
						BackgroundTransparency = 1,
						ClipsDescendants = true
					}
				)
			-- Separate DPI UIScale (on Window.Root) from symmetrical Center Animation UIScale (on VisualFrame)
			-- and keep the elevated Shadow outside VisualFrame's CanvasGroup so it is never clipped.
			local windowUIScale = New("UIScale", {Scale = Creator.DPIScale})
			Window.UIScale = windowUIScale
			local animUIScale = New("UIScale", {Scale = 1})
			Window.AnimUIScale = animUIScale
			local windowShadow = New(
				"ImageLabel",
				{
					Name = "Shadow",
					Image = "rbxassetid://8992230677",
					ScaleType = "Slice",
					SliceCenter = Rect.new(Vector2.new(99, 99), Vector2.new(99, 99)),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.new(1, 76, 1, 76),
					Position = UDim2.new(0.5, 0, 0.5, 4),
					BackgroundTransparency = 1,
					ImageColor3 = Color3.fromRGB(0, 0, 0),
					ImageTransparency = 0.72,
					ZIndex = 0
				}
			)
			Window.Shadow = windowShadow
			local visualFrame = New(
				"Frame",
				{
					Name = "WindowBody",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ZIndex = 1
				},
				{
					animUIScale,
					New("UICorner", {CornerRadius = UDim.new(0, Creator.Radius.Window)}),
					Window.AcrylicPaint.Frame,
					sidebarDivider,
					Window.TabDisplay,
					Window.ContainerHolder,
					tabFrame,
					sidebarFooterSep,
					sidebarFooterBtn,
					profileCard,
					resizeStartFrame
				}
			)
			Window.VisualFrame = visualFrame
			Window.Root =
				New(
					"Frame",
					{BackgroundTransparency = 1, Active = true, Size = Window.Size, Position = Window.Position, Parent = config.Parent},
					{windowUIScale, windowShadow, visualFrame}
				)
			local animYOffset = 0
			local function setVisualYOffset(y)
				animYOffset = y
				visualFrame.Position = UDim2.new(0.5, 0, 0.5, y)
				windowShadow.Position = UDim2.new(0.5, 0, 0.5, y + 4)
			end
			local function applyCombinedScale()
				windowUIScale.Scale = Creator.DPIScale
			end
			-- Smooth macOS/Apple Glass entrance spring (center-scaled + subtle float-up) without CanvasGroup downsampling blur.
			if not Creator.ReducedMotion then
				animUIScale.Scale = 0.92
				windowShadow.ImageTransparency = 1
				setVisualYOffset(14)
				Creator.SpringValue(animUIScale, "Scale", 1, 6.4, 0.86)
				Creator.SpringValue(windowShadow, "ImageTransparency", 0.72, 6.8, 1)
				Creator.SpringValue(visualFrame, "YOffset", 0, 6.4, 0.88, setVisualYOffset, animYOffset)
			end
			Window.TitleBar = requireModule(moduleScript.Parent.TitleBar) {Title = config.Title, SubTitle = config.SubTitle, Parent = visualFrame, Window = Window}
			if requireModule(Root).UseAcrylic then
				Window.AcrylicPaint.AddParent(Window.Root)
				if not Creator.ReducedMotion then
					Window.AcrylicPaint.SetVisibility(false)
					task.delay(0.08, function()
						if not Window.Minimized and Window.Root and Window.Root.Parent then
							Window.AcrylicPaint.SyncVisibility()
						end
					end)
				end
			end
			local sizeMotor, posMotor =
				Flipper.GroupMotor.new {X = Window.Size.X.Offset, Y = Window.Size.Y.Offset},
			Flipper.GroupMotor.new {X = Window.Position.X.Offset, Y = Window.Position.Y.Offset}
			Window.SelectorPosMotor = Flipper.SingleMotor.new(17)
			Window.SelectorSizeMotor = Flipper.SingleMotor.new(16)
			-- Compatible proxies for Tab transitions (ContainerHolder is a Frame; no nested CanvasGroup).
			local containerPosY = 92
			local containerAlpha = 0
			Window.ContainerBackMotor = {
				getValue = function()
					return containerAlpha
				end,
				setGoal = function(_, goal)
					if type(goal) == "table" and goal._targetValue ~= nil then
						containerAlpha = goal._targetValue
					end
				end
			}
			Window.ContainerPosMotor = {
				getValue = function()
					return containerPosY
				end,
				setGoal = function(_, goal)
					if type(goal) == "table" and goal._targetValue ~= nil then
						if goal._frequency and not Creator.ReducedMotion then
							Creator.SpringValue(Window.ContainerHolder, "Position", goal._targetValue, goal._frequency, goal._dampingRatio or 1, function(y)
								containerPosY = y
								Window.ContainerHolder.Position = UDim2.fromOffset(config.TabWidth + 32, y)
							end, containerPosY)
						else
							Creator.CancelSpring(Window.ContainerHolder, "Position")
							containerPosY = goal._targetValue
							Window.ContainerHolder.Position = UDim2.fromOffset(config.TabWidth + 32, containerPosY)
						end
					end
				end
			}
			sizeMotor:onStep(
				function(size)
					Window.Root.Size = UDim2.new(0, size.X, 0, size.Y)
				end
			)
			posMotor:onStep(
				function(position)
					Window.Root.Position = UDim2.new(0, position.X, 0, position.Y)
				end
			)
			local lastValue, lastTime = 0, os.clock()
			Window.SelectorPosMotor:onStep(
				function(value)
					if value ~= value then
						return
					end
					selector.Position = UDim2.new(0, 2, 0, value + 17)
					local now = os.clock()
					local deltaTime = now - lastTime
					if lastValue ~= nil and deltaTime > 0.001 then
						local stretch = math.clamp((math.abs(value - lastValue) / (deltaTime * 60)) + 16, 16, 48)
						Window.SelectorSizeMotor:setGoal(Spring(stretch))
						lastValue = value
						lastTime = now
					end
				end
			)
			Window.SelectorSizeMotor:onStep(
				function(value)
					if value == value then
						selector.Size = UDim2.new(0, 3, 0, math.clamp(value, 6, 48))
					end
				end
			)
			-- Sidebar width, collapse (Icon Rail), and interactive drag-resize (Luaward Dashboard style).
			local TabModule = nil
			local function applyTabWidthImmediate(width)
				width = math.clamp(tonumber(width) or defaultTabWidth, COLLAPSED_SIDEBAR_W, MAX_SIDEBAR_W)
				config.TabWidth = width
				Window.TabWidth = width
				tabFrame.Size = UDim2.new(0, width, 1, tabFrame.Size.Y.Offset)
				sidebarFooterSep.Size = UDim2.new(0, width, 0, 1)
				sidebarFooterBtn.Size = UDim2.new(0, width, 0, showProfileCard and 28 or 32)
				if showProfileCard then
					profileCard.Size = UDim2.new(0, width, 0, 46)
				end
				sidebarDivider.Position = UDim2.new(0, width + 15, 0, 50)
				Window.TabDisplay.Position = UDim2.fromOffset(width + 32, 56)
				Window.TabDisplay.Size = UDim2.new(1, -width - 46, 0, 28)
				Window.ContainerHolder.Size = UDim2.new(1, -width - 40, 1, -104)
				Window.ContainerHolder.Position = UDim2.fromOffset(width + 32, Window.ContainerPosMotor:getValue())
			end
			local function updateTabsCollapsedVisual(collapsed)
				collapsed = collapsed == true
				sidebarFooterIcon.Image = collapsed and sidebarOpenIcon or sidebarCloseIcon
				sidebarFooterLabel.Visible = not collapsed
				if collapsed then
					sidebarFooterIcon.AnchorPoint = Vector2.new(0.5, 0.5)
					sidebarFooterIcon.Position = UDim2.fromScale(0.5, 0.5)
					profileTextCol.Visible = false
					profileChev.Visible = false
					avatarHolder.AnchorPoint = Vector2.new(0.5, 0.5)
					avatarHolder.Position = UDim2.fromScale(0.5, 0.5)
				else
					sidebarFooterIcon.AnchorPoint = Vector2.new(0, 0.5)
					sidebarFooterIcon.Position = UDim2.new(0, 10, 0.5, 0)
					profileTextCol.Visible = true
					profileChev.Visible = true
					avatarHolder.AnchorPoint = Vector2.new(0, 0.5)
					avatarHolder.Position = UDim2.new(0, 7, 0.5, 0)
				end
				if TabModule and TabModule.Tabs then
					for _, tab in next, TabModule.Tabs do
						if type(tab.SetCollapsed) == "function" then
							tab.SetCollapsed(collapsed)
						end
					end
				end
			end
			function Window.SetTabWidth(_self, width, instant)
				width = math.clamp(tonumber(width) or defaultTabWidth, COLLAPSED_SIDEBAR_W, MAX_SIDEBAR_W)
				local collapsed = width <= COLLAPSED_SIDEBAR_W + 6
				Window.SidebarCollapsed = collapsed
				if not collapsed then
					Window.ExpandedTabWidth = math.clamp(width, MIN_SIDEBAR_W, MAX_SIDEBAR_W)
				end
				updateTabsCollapsedVisual(collapsed)
				if instant ~= false or Creator.ReducedMotion then
					Creator.CancelSpring(tabFrame, "SidebarWidth")
					applyTabWidthImmediate(width)
				else
					Creator.SpringValue(tabFrame, "SidebarWidth", width, 7.2, 0.92, applyTabWidthImmediate, Window.TabWidth)
				end
			end
			function Window.SetSidebarCollapsed(_self, collapsed, instant)
				collapsed = collapsed == true
				Window.SidebarCollapsed = collapsed
				updateTabsCollapsedVisual(collapsed)
				local targetW = collapsed and COLLAPSED_SIDEBAR_W or math.clamp(Window.ExpandedTabWidth or defaultTabWidth, MIN_SIDEBAR_W, MAX_SIDEBAR_W)
				if instant or Creator.ReducedMotion then
					Creator.CancelSpring(tabFrame, "SidebarWidth")
					applyTabWidthImmediate(targetW)
				else
					Creator.SpringValue(tabFrame, "SidebarWidth", targetW, 7.0, 0.9, applyTabWidthImmediate, Window.TabWidth)
				end
			end
			function Window.ToggleSidebar(_self, instant)
				Window:SetSidebarCollapsed(not Window.SidebarCollapsed, instant)
			end

			-- Sidebar divider drag-resize + hover accent feedback + double-click reset
			local sidebarDragging = false
			local lastDividerClickAt = 0
			local function setDividerActive(active)
				if active then
					Creator.OverrideTag(sidebarDividerLine, {BackgroundColor3 = "Accent"})
					Creator.SpringValue(sidebarDividerLine, "BackgroundTransparency", 0.1, 12, 1)
					sidebarDividerLine.Size = UDim2.new(0, 2, 1, 0)
				else
					Creator.OverrideTag(sidebarDividerLine, {BackgroundColor3 = "TitleBarLine"})
					Creator.SpringValue(sidebarDividerLine, "BackgroundTransparency", 0.65, 10, 1)
					sidebarDividerLine.Size = UDim2.new(0, 1, 1, 0)
				end
			end
			Creator.AddSignal(sidebarDivider.MouseEnter, function()
				setDividerActive(true)
			end)
			Creator.AddSignal(sidebarDivider.MouseLeave, function()
				if not sidebarDragging then
					setDividerActive(false)
				end
			end)
			Creator.AddSignal(sidebarDivider.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					local now = os.clock()
					if (now - lastDividerClickAt) < 0.35 then
						lastDividerClickAt = 0
						Window.ExpandedTabWidth = defaultTabWidth
						Window:SetSidebarCollapsed(false, false)
						return
					end
					lastDividerClickAt = now
					sidebarDragging = true
					setDividerActive(true)
					Creator.CancelSpring(tabFrame, "SidebarWidth")
					local startX = input.Position.X
					local startW = Window.TabWidth
					local scale = math.max(0.01, Creator.DPIScale)
					Creator.BeginDrag(function(moveInput)
						if not sidebarDragging then
							return
						end
						local rawW = startW + (moveInput.Position.X - startX) / scale
						local maxAllowed = math.min(MAX_SIDEBAR_W, math.max(MIN_SIDEBAR_W, Window.Size.X.Offset - 260))
						if rawW < SNAP_COLLAPSE_W then
							if not Window.SidebarCollapsed then
								Window.SidebarCollapsed = true
								updateTabsCollapsedVisual(true)
							end
							applyTabWidthImmediate(COLLAPSED_SIDEBAR_W)
						else
							local clamped = math.clamp(rawW, MIN_SIDEBAR_W, maxAllowed)
							if Window.SidebarCollapsed then
								Window.SidebarCollapsed = false
								updateTabsCollapsedVisual(false)
							end
							Window.ExpandedTabWidth = clamped
							applyTabWidthImmediate(clamped)
						end
					end, function()
						sidebarDragging = false
						setDividerActive(false)
					end)
				end
			end)
			-- Ctrl+B shortcut to collapse/expand sidebar (Luaward Dashboard / VSCode standard)
			Creator.AddSignal(UserInputService.InputBegan, function(input, gameProcessed)
				if gameProcessed or UserInputService:GetFocusedTextBox() then
					return
				end
				if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.B then
					if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
						Window:ToggleSidebar()
					end
				end
			end)
			local oldSizeX, oldSizeY
			local function getUsableViewport()
				local screen = camera.ViewportSize
				local insetY = Creator.GetGuiInsetY()
				return screen.X, math.max(160, screen.Y - insetY)
			end
			Window.Maximize = function(maximized, noPos, instant)
				Window.Maximized = maximized
				Window.TitleBar.MaxButton.Frame.Icon.Image = maximized and Assets.Restore or Assets.Max
				if maximized then
					oldSizeX = Window.Size.X.Offset
					oldSizeY = Window.Size.Y.Offset
				end
				local usableW, usableH = getUsableViewport()
				local scale = math.max(0.01, Creator.DPIScale)
				local sizeX = maximized and math.floor(usableW / scale) or (oldSizeX or Window.Size.X.Offset)
				local sizeY = maximized and math.floor(usableH / scale) or (oldSizeY or Window.Size.Y.Offset)
				local useInstant = instant or Creator.ReducedMotion
				sizeMotor:setGoal {
					X = Flipper[useInstant and "Instant" or "Spring"].new(sizeX, {frequency = 6}),
					Y = Flipper[useInstant and "Instant" or "Spring"].new(sizeY, {frequency = 6})
				}
				Window.Size = UDim2.fromOffset(sizeX, sizeY)
				if not noPos then
					posMotor:setGoal {
						X = Flipper[useInstant and "Instant" or "Spring"].new(maximized and 0 or Window.Position.X.Offset, {frequency = 6}),
						Y = Flipper[useInstant and "Instant" or "Spring"].new(maximized and 0 or Window.Position.Y.Offset, {frequency = 6})
					}
				end
			end
			local function syncTabHolderCanvas()
				local scale = Creator.GetEffectiveScale(Window.TabHolder)
				Window.TabHolder.CanvasSize = UDim2.new(0, 0, 0, math.ceil(Window.TabHolder.UIListLayout.AbsoluteContentSize.Y / scale) + 4)
			end
			Creator.RegisterDPIScale(windowUIScale, function(newScale)
				applyCombinedScale()
				if Window.Maximized then
					local usableW, usableH = getUsableViewport()
					local s = math.max(0.01, newScale)
					local sizeX, sizeY = math.floor(usableW / s), math.floor(usableH / s)
					Window.Size = UDim2.fromOffset(sizeX, sizeY)
					sizeMotor:setGoal {X = Instant(sizeX), Y = Instant(sizeY)}
					posMotor:setGoal {X = Instant(0), Y = Instant(0)}
				else
					local usableW, usableH = getUsableViewport()
					local renderedW = Window.Size.X.Offset * newScale
					local x = math.clamp(Window.Position.X.Offset, VISIBLE_TITLE - renderedW, math.max(VISIBLE_TITLE - renderedW, usableW - VISIBLE_TITLE))
					local y = math.clamp(Window.Position.Y.Offset, 0, math.max(0, usableH - VISIBLE_TITLE))
					if x ~= Window.Position.X.Offset or y ~= Window.Position.Y.Offset then
						Window.Position = UDim2.fromOffset(x, y)
						posMotor:setGoal {X = Instant(x), Y = Instant(y)}
					end
				end
				task.defer(syncTabHolderCanvas)
			end)
			Creator.AddSignal(
				Window.TitleBar.Frame.InputBegan,
				function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						mousePos = input.Position
						startPos = Window.Root.Position
						if Window.Maximized then
							startPos =
								UDim2.fromOffset(
									mouse.X - (mouse.X * ((oldSizeX - 100) / Window.Root.AbsoluteSize.X)),
									mouse.Y - (mouse.Y * (oldSizeY / Window.Root.AbsoluteSize.Y))
								)
						end
						input.Changed:Connect(
							function()
								if input.UserInputState == Enum.UserInputState.End then
									dragging = false
								end
							end
						)
					end
				end
			)
			Creator.AddSignal(
				Window.TitleBar.Frame.InputChanged,
				function(input)
					if
						input.UserInputType == Enum.UserInputType.MouseMovement or
						input.UserInputType == Enum.UserInputType.Touch
					then
						dragInput = input
					end
				end
			)
			Creator.AddSignal(
				resizeStartFrame.InputBegan,
				function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						resizing = true
						resizePos = input.Position
					end
				end
			)
			Creator.AddSignal(
				UserInputService.InputChanged,
				function(input)
					if input == dragInput and dragging then
						local delta = input.Position - mousePos
						-- Keep part of the title bar on screen so the window can
						-- always be dragged back.
						local usableW, usableH = getUsableViewport()
						local width = Window.Size.X.Offset * Creator.DPIScale
						local x = math.clamp(startPos.X.Offset + delta.X, VISIBLE_TITLE - width, math.max(VISIBLE_TITLE - width, usableW - VISIBLE_TITLE))
						local y = math.clamp(startPos.Y.Offset + delta.Y, 0, math.max(0, usableH - VISIBLE_TITLE))
						Window.Position = UDim2.fromOffset(x, y)
						posMotor:setGoal {X = Instant(Window.Position.X.Offset), Y = Instant(Window.Position.Y.Offset)}
						if Window.Maximized then
							Window.Maximize(false, true, true)
						end
					end
					if
						(input.UserInputType == Enum.UserInputType.MouseMovement or
							input.UserInputType == Enum.UserInputType.Touch) and
						resizing
					then
						local scale = math.max(0.01, Creator.DPIScale)
						local delta, startSize = (input.Position - resizePos) / scale, Window.Size
						local targetSize = Vector3.new(startSize.X.Offset, startSize.Y.Offset, 0) + Vector3.new(1, 1, 0) * delta
						-- The minimum size shrinks on screens smaller than it.
						local usableW, usableH = getUsableViewport()
						local minimumX = math.max(200, math.min(470, (usableW - SCREEN_MARGIN * 2) / scale))
						local minimumY = math.max(160, math.min(380, (usableH - SCREEN_MARGIN * 2) / scale))
						local clampedSize = Vector2.new(math.clamp(targetSize.X, minimumX, 2048), math.clamp(targetSize.Y, minimumY, 2048))
						sizeMotor:setGoal {X = Flipper.Instant.new(clampedSize.X), Y = Flipper.Instant.new(clampedSize.Y)}
					end
				end
			)
			Creator.AddSignal(
				UserInputService.InputEnded,
				function(input)
					if resizing == true or input.UserInputType == Enum.UserInputType.Touch then
						resizing = false
						Window.Size = UDim2.fromOffset(sizeMotor:getValue().X, sizeMotor:getValue().Y)
					end
				end
			)
			Creator.AddSignal(
				Window.TabHolder.UIListLayout:GetPropertyChangedSignal "AbsoluteContentSize",
				syncTabHolderCanvas
			)
			-- Minimize key. A modifier key (Ctrl, Shift, Alt) minimizes when it is
			-- released, and only if nothing else was pressed while it was held, so
			-- Ctrl+K, Ctrl+M, Ctrl+W or Ctrl+click never minimize. Other keys
			-- minimize as soon as they are pressed. Keys are compared by name.
			local modifierKeyNames = {
				LeftControl = true,
				RightControl = true,
				LeftShift = true,
				RightShift = true,
				LeftAlt = true,
				RightAlt = true
			}
			local function isMinimizeKey(input)
				local keybind = Library.MinimizeKeybind
				if type(keybind) == "table" and keybind.Type == "Keybind" then
					return input.KeyCode.Name == keybind.Value
				end
				local key = Library.MinimizeKey
				if type(key) == "string" then
					return input.KeyCode.Name == key
				end
				return key ~= nil and input.KeyCode == key
			end
			local heldModifier, heldChord = nil, false
			Creator.AddSignal(
				UserInputService.InputBegan,
				function(input)
					if heldModifier and input.KeyCode.Name ~= heldModifier and input.UserInputType ~= Enum.UserInputType.Focus then
						heldChord = true
					end
					if not isMinimizeKey(input) or UserInputService:GetFocusedTextBox() then
						return
					end
					if modifierKeyNames[input.KeyCode.Name] then
						heldModifier, heldChord = input.KeyCode.Name, false
					else
						Window:Minimize()
					end
				end
			)
			Creator.AddSignal(
				UserInputService.InputEnded,
				function(input)
					if heldModifier == nil or input.KeyCode.Name ~= heldModifier then
						return
					end
					local chord = heldChord
					heldModifier, heldChord = nil, false
					if not chord and not UserInputService:GetFocusedTextBox() then
						Window:Minimize()
					end
				end
			)
			Creator.AddSignal(
				UserInputService.WindowFocusReleased,
				function()
					heldModifier, heldChord = nil, false
				end
			)
			local minimizeTransitionId = 0
			Window._MinimizeListeners = {}
			function Window.OnMinimizeChanged(_self, fn)
				if type(fn) == "function" then
					table.insert(Window._MinimizeListeners, fn)
				end
			end
			Window.TitleText = config.Title
			function Window.OpenCommandPalette(_self)
				if Library and type(Library.OpenCommandPalette) == "function" then
					Library:OpenCommandPalette()
				end
			end
			function Window.ToggleCommandPalette(_self)
				if Library and type(Library.ToggleCommandPalette) == "function" then
					Library:ToggleCommandPalette()
				end
			end
			function Window.SetFloatingPill(_self, enabledOrOpts)
				if Library and type(Library.SetFloatingPill) == "function" then
					return Library:SetFloatingPill(enabledOrOpts)
				end
				return nil
			end
			function Window.Minimize(_self)
				Window.Minimized = not Window.Minimized
				minimizeTransitionId += 1
				local myTransition = minimizeTransitionId
				if Window.Minimized and type(Library._CloseDropdowns) == "function" then
					Library._CloseDropdowns()
				end
				for _, listener in ipairs(Window._MinimizeListeners) do
					pcall(listener, Window.Minimized)
				end
				if Window.Minimized then
					-- Immediately hide 3D AcrylicBlur before animating out so blur never lingers.
					if Window.AcrylicPaint and type(Window.AcrylicPaint.SetVisibility) == "function" then
						Window.AcrylicPaint.SetVisibility(false)
					end
					if Creator.ReducedMotion then
						Creator.CancelSpring(animUIScale, "Scale")
						Creator.CancelSpring(visualFrame, "YOffset")
						Creator.CancelSpring(windowShadow, "ImageTransparency")
						animUIScale.Scale = 1
						windowShadow.ImageTransparency = 0.72
						setVisualYOffset(0)
						Window.Root.Visible = false
					else
						Creator.SpringValue(animUIScale, "Scale", 0.92, 8.0, 1)
						Creator.SpringValue(windowShadow, "ImageTransparency", 1, 9.0, 1)
						Creator.SpringValue(visualFrame, "YOffset", 14, 8.0, 1, setVisualYOffset, animYOffset)
						task.delay(0.18, function()
							if myTransition == minimizeTransitionId and Window.Minimized and Window.Root and Window.Root.Parent then
								Window.Root.Visible = false
								if Window.AcrylicPaint and type(Window.AcrylicPaint.SyncVisibility) == "function" then
									Window.AcrylicPaint.SyncVisibility()
								end
							end
						end)
					end
				else
					Window.Root.Visible = true
					if Creator.ReducedMotion then
						Creator.CancelSpring(animUIScale, "Scale")
						Creator.CancelSpring(visualFrame, "YOffset")
						Creator.CancelSpring(windowShadow, "ImageTransparency")
						animUIScale.Scale = 1
						windowShadow.ImageTransparency = 0.72
						setVisualYOffset(0)
						if Window.AcrylicPaint and type(Window.AcrylicPaint.SyncVisibility) == "function" then
							Window.AcrylicPaint.SyncVisibility()
						end
					else
						Creator.CancelSpring(animUIScale, "Scale")
						Creator.CancelSpring(visualFrame, "YOffset")
						Creator.CancelSpring(windowShadow, "ImageTransparency")
						animUIScale.Scale = 0.92
						windowShadow.ImageTransparency = 1
						setVisualYOffset(14)
						Creator.SpringValue(animUIScale, "Scale", 1, 6.4, 0.86)
						Creator.SpringValue(windowShadow, "ImageTransparency", 0.72, 6.8, 1)
						Creator.SpringValue(visualFrame, "YOffset", 0, 6.4, 0.88, setVisualYOffset, animYOffset)
						task.delay(0.06, function()
							if myTransition == minimizeTransitionId and not Window.Minimized and Window.Root and Window.Root.Parent then
								if Window.AcrylicPaint and type(Window.AcrylicPaint.SyncVisibility) == "function" then
									Window.AcrylicPaint.SyncVisibility()
								end
							end
						end)
					end
				end
				if not minimizeNotified then
					minimizeNotified = true
					local key = Library.MinimizeKeybind and Library.MinimizeKeybind.Value or Library.MinimizeKey
					if typeof(key) == "EnumItem" then
						key = key.Name
					end
					Library:Notify {Title = "Interface", Content = "Press " .. tostring(key) .. " to toggle the interface.", Duration = 6}
				end
			end
			function Window.Destroy(_self)
				if Window.AcrylicPaint and type(Window.AcrylicPaint.Destroy) == "function" then
					pcall(Window.AcrylicPaint.Destroy)
				end
				Window.Root:Destroy()
			end
			local DialogModule = requireModule(Components.Dialog):Init(Window)
			function Window.Dialog(_self, dialogConfig)
				local dialog = DialogModule:Create()
				dialog.Title.Text = dialogConfig.Title
				TranslationSystem:Register(dialog.Title, dialogConfig.Title, "Text")
				local content =
					New(
						"TextLabel",
						{
							FontFace = Creator.Font(),
							Text = dialogConfig.Content,
							TextColor3 = Color3.fromRGB(240, 240, 240),
							TextSize = 14,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Top,
							Size = UDim2.new(1, -40, 1, 0),
							Position = UDim2.fromOffset(20, 60),
							BackgroundTransparency = 1,
							ZIndex = 32,
							Parent = dialog.Root,
							ClipsDescendants = false,
							ThemeTag = {TextColor3 = "Text"}
						}
					)
				New(
					"UISizeConstraint",
					{MinSize = Vector2.new(300, 165), MaxSize = Vector2.new(620, math.huge), Parent = dialog.Root}
				)
				dialog.Root.Size = UDim2.fromOffset(content.TextBounds.X + 40, 165)
				if content.TextBounds.X + 40 > Window.Size.X.Offset - 120 then
					dialog.Root.Size = UDim2.fromOffset(Window.Size.X.Offset - 120, 165)
					content.TextWrapped = true
					dialog.Root.Size = UDim2.fromOffset(Window.Size.X.Offset - 120, content.TextBounds.Y + 150)
				end
				for _, button in next, dialogConfig.Buttons do
					dialog:Button(button.Title, button.Callback)
				end
				dialog:Open()
			end
			TabModule = requireModule(Components.Tab):Init(Window)
			function Window.AddTab(_self, tabConfig)
				local tab = TabModule:New(tabConfig.Title, tabConfig.Icon, Window.TabHolder)
				if Window.Library and Window.Library.Workspace and type(Window.Library.Workspace.RegisterTab) == "function" then
					Window.Library.Workspace:RegisterTab(tab, tabConfig)
				end
				return tab
			end
			function Window.SelectTab(_self, tab)
				if type(tab) == "table" and type(tab.Index) == "number" then
					TabModule:SelectTab(tab.Index)
				elseif type(tab) == "number" then
					TabModule:SelectTab(tab)
				else
					TabModule:SelectTab(1)
				end
			end
			local hoveredTab, hoverPillY, hoverPillVisible, hoverLeaveGen = nil, 0, false, 0
			local function setHoverPillY(y)
				hoverPillY = y
				tabHoverPill.Position = UDim2.fromOffset(2, y)
			end
			function Window.HoverTab(_self, tab)
				if not tab or not tab.Frame or not Window.TabHolder then
					return
				end
				hoverLeaveGen += 1
				hoveredTab = tab
				local scale = Creator.GetEffectiveScale(Window.TabHolder)
				local targetY = (tab.Frame.AbsolutePosition.Y - Window.TabHolder.AbsolutePosition.Y) / scale
				if not hoverPillVisible then
					hoverPillVisible = true
					Creator.CancelSpring(tabHoverPill, "HoverY")
					setHoverPillY(targetY)
				else
					Creator.SpringValue(tabHoverPill, "HoverY", targetY, 5.2, 0.88, setHoverPillY, hoverPillY)
				end
				Creator.SpringValue(tabHoverPill, "BackgroundTransparency", 0.86, 5.2, 1)
				Creator.SpringValue(tabHoverStroke, "Transparency", 0.56, 5.2, 1)
			end
			function Window.UnhoverTab(_self, tab)
				if hoveredTab ~= tab then
					return
				end
				hoverLeaveGen += 1
				local myGen = hoverLeaveGen
				task.delay(0.03, function()
					if myGen == hoverLeaveGen and hoveredTab == tab then
						hoveredTab = nil
						hoverPillVisible = false
						Creator.SpringValue(tabHoverPill, "BackgroundTransparency", 1, 5.2, 1)
						Creator.SpringValue(tabHoverStroke, "Transparency", 1, 5.2, 1)
					end
				end)
			end
			Window.TabHoverPill = tabHoverPill
			Creator.AddSignal(
				Window.TabHolder:GetPropertyChangedSignal "CanvasPosition",
				function()
					lastValue = TabModule:GetCurrentTabPos() + 16
					lastTime = 0
					Window.SelectorPosMotor:setGoal(Instant(TabModule:GetCurrentTabPos()))
					if hoveredTab and hoveredTab.Frame then
						local scale = Creator.GetEffectiveScale(Window.TabHolder)
						setHoverPillY((hoveredTab.Frame.AbsolutePosition.Y - Window.TabHolder.AbsolutePosition.Y) / scale)
					end
				end
			)
			return Window
		end
	end,
	[18] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(18)
		local Root = moduleScript.Parent
		local cloneRef = cloneref or clonereference or function(instance)
			return instance
		end
		local serviceCache = {}
		local function getService(name)
			local cached = serviceCache[name]
			if cached then
				return cached
			end
			local service = cloneRef(game:GetService(name))
			serviceCache[name] = service
			return service
		end

		local RunService = getService("RunService")
		local UserInputService = getService("UserInputService")
		local GuiService = getService("GuiService")
		local Themes, Flipper = requireModule(Root.Themes), requireModule(Root.Packages.Flipper)

		-- Strong registries with dead-parent pruning + Disconnect clear.
		-- Avoids both per-instance Destroying connections AND Luau weak-wrapper GC
		-- evicting live Roblox Instances that only exist in the C++ GUI tree.
		local Creator = {
			CloneRef = cloneRef,
			GetService = getService,
			Registry = {},
			Signals = {},
			TransparencyMotors = {},
			TransparencyTargets = {},
			DPIScale = 1,
			ReducedMotion = false,
			Radius = {
				Window = 12,
				Card = 8,
				Control = 7,
				Pill = 999
			},
			Fonts = {
				UI = "rbxassetid://12187365364",
				Display = "rbxassetid://12187365364",
				Mono = "rbxasset://fonts/families/RobotoMono.json",
				BuilderSans = "rbxasset://fonts/families/BuilderSans.json",
				Gotham = "rbxasset://fonts/families/GothamSSm.json"
			}
		}

		local fontFaceCache = {}
		function Creator.Font(weight, style, familyKey)
			local resolvedWeight = weight or Enum.FontWeight.Regular
			local resolvedStyle = style or Enum.FontStyle.Normal
			local key = familyKey or "UI"
			local family = Creator.Fonts[key] or (type(familyKey) == "string" and familyKey) or Creator.Fonts.UI
			local cacheKey = tostring(family) .. "|" .. tostring(resolvedWeight) .. "|" .. tostring(resolvedStyle)
			local cached = fontFaceCache[cacheKey]
			if cached then
				return cached
			end
			local ok, face = pcall(Font.new, family, resolvedWeight, resolvedStyle)
			if not ok or not face then
				local fbOk, fbFace = pcall(Font.new, Creator.Fonts.BuilderSans, resolvedWeight, resolvedStyle)
				face = fbOk and fbFace or Font.fromEnum(Enum.Font.BuilderSans)
			end
			fontFaceCache[cacheKey] = face
			return face
		end

		Creator.DefaultProperties = {
				ScreenGui = {ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling},
				Frame = {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderColor3 = Color3.new(0, 0, 0),
					BorderSizePixel = 0
				},
				ScrollingFrame = {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderColor3 = Color3.new(0, 0, 0),
					ScrollBarImageColor3 = Color3.new(0, 0, 0)
				},
				TextLabel = {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderColor3 = Color3.new(0, 0, 0),
					FontFace = Creator.Font(),
					Text = "",
					TextColor3 = Color3.new(0, 0, 0),
					BackgroundTransparency = 1,
					TextSize = 14
				},
				TextButton = {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderColor3 = Color3.new(0, 0, 0),
					AutoButtonColor = false,
					FontFace = Creator.Font(),
					Text = "",
					TextColor3 = Color3.new(0, 0, 0),
					TextSize = 14
				},
				TextBox = {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderColor3 = Color3.new(0, 0, 0),
					ClearTextOnFocus = false,
					FontFace = Creator.Font(),
					Text = "",
					TextColor3 = Color3.new(0, 0, 0),
					TextSize = 14
				},
				ImageLabel = {
					BackgroundTransparency = 1,
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderColor3 = Color3.new(0, 0, 0),
					BorderSizePixel = 0
				},
				ImageButton = {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderColor3 = Color3.new(0, 0, 0),
					AutoButtonColor = false
				},
				CanvasGroup = {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderColor3 = Color3.new(0, 0, 0),
					BorderSizePixel = 0
				}
			}

		local TEXT_CLASSES = {TextLabel = true, TextButton = true, TextBox = true}
		local META_KEYS = {
			Parent = true,
			ThemeTag = true,
			I18nKey = true,
			I18nContext = true,
			I18nSkip = true,
			I18nDynamic = true,
			FontRole = true
		}

		local libraryRef = nil
		local function getLibrary()
			if not libraryRef then
				libraryRef = requireModule(Root)
			end
			return libraryRef
		end

		-- Connections to destroyed instances are already disconnected; prune
		-- whenever the list doubles so memory stays proportional to live ones.
		local nextSignalPrune = 64
		local function pruneSignals()
			local signals, kept = Creator.Signals, 0
			for index = 1, #signals do
				local connection = signals[index]
				if connection.Connected ~= false then
					kept = kept + 1
					signals[kept] = connection
				end
			end
			for index = #signals, kept + 1, -1 do
				signals[index] = nil
			end
			nextSignalPrune = math.max(64, kept * 2)
		end
		function Creator.AddSignal(signal, callback)
			local connection = signal:Connect(callback)
			table.insert(Creator.Signals, connection)
			if #Creator.Signals >= nextSignalPrune then
				pruneSignals()
			end
			return connection
		end

		-- ============================================================================
		-- Oklab Perceptual Color Interpolation & Auto-Contrast
		-- Prevents muddy gray midpoints during theme and state color transitions.
		-- ============================================================================
		local function srgbToLinear(c)
			return c <= 0.04045 and (c / 12.92) or ((c + 0.055) / 1.055) ^ 2.4
		end

		local function linearToSrgb(c)
			if c <= 0 then
				return 0
			elseif c >= 1 then
				return 1
			end
			return c <= 0.0031308 and (12.92 * c) or (1.055 * (c ^ (1 / 2.4)) - 0.055)
		end

		local function colorToOklab(color)
			local r = srgbToLinear(color.R)
			local g = srgbToLinear(color.G)
			local b = srgbToLinear(color.B)
			local l = (0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b) ^ (1 / 3)
			local m = (0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b) ^ (1 / 3)
			local s = (0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b) ^ (1 / 3)
			return
				0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s,
				1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s,
				0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s
		end

		local function oklabToColor(L, a, b)
			local l_ = L + 0.3963377774 * a + 0.2158037573 * b
			local m_ = L - 0.1055613458 * a - 0.0638541728 * b
			local s_ = L - 0.0894841775 * a - 1.2914855480 * b
			local l = l_ * l_ * l_
			local m = m_ * m_ * m_
			local s = s_ * s_ * s_
			local r = 4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s
			local g = -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s
			local bl = -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
			return Color3.new(linearToSrgb(r), linearToSrgb(g), linearToSrgb(bl))
		end

		function Creator.LerpColorOklab(fromColor, toColor, alpha)
			if alpha <= 0 then
				return fromColor
			elseif alpha >= 1 then
				return toColor
			end
			local L1, a1, b1 = colorToOklab(fromColor)
			local L2, a2, b2 = colorToOklab(toColor)
			return oklabToColor(L1 + (L2 - L1) * alpha, a1 + (a2 - a1) * alpha, b1 + (b2 - b1) * alpha)
		end

		-- Perceived brightness contrast picker (YIQ luminance).
		function Creator.AutoContrast(color, lightColor, darkColor)
			if typeof(color) ~= "Color3" then
				return lightColor or Color3.fromRGB(244, 246, 252)
			end
			local luminance = 0.299 * color.R + 0.587 * color.G + 0.114 * color.B
			if luminance > 0.58 then
				return darkColor or Color3.fromRGB(14, 16, 22)
			end
			return lightColor or Color3.fromRGB(246, 248, 254)
		end

		-- ============================================================================
		-- Shared zero-alloc scalar spring + Oklab color animator
		-- Drives hover / fade / theme color / micro-interaction animations on one
		-- RenderStepped loop without allocating Flipper motors or signals at mount.
		-- ============================================================================
		local activeSprings = {}
		local activeSpringCount = 0
		local activeColorTweens = {}
		local activeColorCount = 0
		local springConnection = nil
		local SPRING_EPSILON = 0.001

		local function stopSpringScheduler()
			if springConnection then
				springConnection:Disconnect()
				springConnection = nil
			end
			table.clear(activeSprings)
			activeSpringCount = 0
			table.clear(activeColorTweens)
			activeColorCount = 0
		end

		local function stepSprings(deltaTime)
			if deltaTime > 0.05 then
				deltaTime = 0.05
			end
			for instance, propMap in next, activeSprings do
				if not instance or not instance.Parent then
					for _ in next, propMap do
						activeSpringCount -= 1
					end
					activeSprings[instance] = nil
				else
					local remaining = 0
					for prop, state in next, propMap do
						local f = state.angularFreq
						local d = state.damping
						local offset = state.value - state.target
						local velocity = state.velocity
						local decay = math.exp(-d * f * deltaTime)
						local nextValue, nextVelocity
						if d == 1 then
							nextValue = (offset * (1 + f * deltaTime) + velocity * deltaTime) * decay + state.target
							nextVelocity = (velocity * (1 - f * deltaTime) - offset * (f * f * deltaTime)) * decay
						elseif d < 1 then
							local c = math.sqrt(1 - d * d)
							local i = math.cos(f * c * deltaTime)
							local j = math.sin(f * c * deltaTime)
							nextValue = (offset * i + ((velocity + d * f * offset) / (f * c)) * j) * decay + state.target
							nextVelocity = (velocity * (i - (d / c) * j) - offset * (f / c) * j) * decay
						else
							local c = math.sqrt(d * d - 1)
							local r1 = -f * (d - c)
							local r2 = -f * (d + c)
							local co2 = (velocity - r1 * offset) / (2 * f * c)
							local co1 = offset - co2
							local e1 = co1 * math.exp(r1 * deltaTime)
							local e2 = co2 * math.exp(r2 * deltaTime)
							nextValue = e1 + e2 + state.target
							nextVelocity = r1 * e1 + r2 * e2
						end
						if math.abs(nextValue - state.target) <= SPRING_EPSILON and math.abs(nextVelocity) <= SPRING_EPSILON then
							state.value = state.target
							state.velocity = 0
							if state.setter then
								state.setter(state.target)
							else
								instance[state.property] = state.target
							end
							propMap[prop] = nil
							activeSpringCount -= 1
						else
							state.value = nextValue
							state.velocity = nextVelocity
							if state.setter then
								state.setter(nextValue)
							else
								instance[state.property] = nextValue
							end
							remaining += 1
						end
					end
					if remaining == 0 then
						activeSprings[instance] = nil
					end
				end
			end

			for instance, propMap in next, activeColorTweens do
				if not instance or not instance.Parent then
					for _ in next, propMap do
						activeColorCount -= 1
					end
					activeColorTweens[instance] = nil
				else
					local remaining = 0
					for prop, tween in next, propMap do
						tween.elapsed += deltaTime
						local t = tween.duration > 0 and math.clamp(tween.elapsed / tween.duration, 0, 1) or 1
						-- Smooth cubic ease-out in Oklab space
						local inv = 1 - t
						local eased = 1 - (inv * inv * inv)
						if t >= 1 then
							instance[prop] = tween.toColor
							propMap[prop] = nil
							activeColorCount -= 1
						else
							instance[prop] = oklabToColor(
								tween.L1 + (tween.L2 - tween.L1) * eased,
								tween.a1 + (tween.a2 - tween.a1) * eased,
								tween.b1 + (tween.b2 - tween.b1) * eased
							)
							remaining += 1
						end
					end
					if remaining == 0 then
						activeColorTweens[instance] = nil
					end
				end
			end

			if activeSpringCount <= 0 and activeColorCount <= 0 and springConnection then
				springConnection:Disconnect()
				springConnection = nil
				activeSpringCount = 0
				activeColorCount = 0
			end
		end

		local function ensureSpringScheduler()
			if not springConnection then
				springConnection = RunService.RenderStepped:Connect(stepSprings)
			end
		end

		function Creator.SpringValue(instance, property, target, frequency, damping, setter, startValue)
			if not instance then
				return
			end
			if Creator.ReducedMotion then
				Creator.CancelSpring(instance, property)
				if setter then
					setter(target)
				else
					instance[property] = target
				end
				return
			end
			local propMap = activeSprings[instance]
			local existing = propMap and propMap[property] or nil
			if existing then
				existing.target = target
				existing.angularFreq = (frequency or 8) * 2 * math.pi
				existing.damping = damping or 1
				if setter then
					existing.setter = setter
				end
				return
			end
			local currentValue = target
			if type(startValue) == "number" then
				currentValue = startValue
			elseif not setter then
				local ok, val = pcall(function()
					return instance[property]
				end)
				if ok and type(val) == "number" then
					currentValue = val
				end
			end
			if math.abs(currentValue - target) <= SPRING_EPSILON then
				if setter then
					setter(target)
				else
					instance[property] = target
				end
				return
			end
			if not propMap then
				propMap = {}
				activeSprings[instance] = propMap
			end
			propMap[property] = {
				instance = instance,
				property = property,
				value = currentValue,
				velocity = 0,
				target = target,
				angularFreq = (frequency or 8) * 2 * math.pi,
				damping = damping or 1,
				setter = setter
			}
			activeSpringCount += 1
			ensureSpringScheduler()
		end

		local function cancelColorTween(instance, property)
			local propMap = activeColorTweens[instance]
			if not propMap then
				return
			end
			if property == nil then
				for _ in next, propMap do
					activeColorCount = math.max(0, activeColorCount - 1)
				end
				activeColorTweens[instance] = nil
			elseif propMap[property] then
				propMap[property] = nil
				activeColorCount = math.max(0, activeColorCount - 1)
				if next(propMap) == nil then
					activeColorTweens[instance] = nil
				end
			end
		end

		function Creator.AnimateColor(instance, property, targetColor, duration)
			if not instance or typeof(targetColor) ~= "Color3" then
				return
			end
			if Creator.ReducedMotion or (duration ~= nil and duration <= 0) then
				cancelColorTween(instance, property)
				instance[property] = targetColor
				return
			end
			local ok, current = pcall(function()
				return instance[property]
			end)
			if not ok or typeof(current) ~= "Color3" then
				cancelColorTween(instance, property)
				instance[property] = targetColor
				return
			end
			if math.abs(current.R - targetColor.R) < 0.002 and math.abs(current.G - targetColor.G) < 0.002 and math.abs(current.B - targetColor.B) < 0.002 then
				cancelColorTween(instance, property)
				instance[property] = targetColor
				return
			end
			local L1, a1, b1 = colorToOklab(current)
			local L2, a2, b2 = colorToOklab(targetColor)
			local propMap = activeColorTweens[instance]
			local existing = propMap and propMap[property] or nil
			if existing then
				existing.L1, existing.a1, existing.b1 = L1, a1, b1
				existing.L2, existing.a2, existing.b2 = L2, a2, b2
				existing.toColor = targetColor
				existing.elapsed = 0
				existing.duration = duration or 0.22
				return
			end
			if not propMap then
				propMap = {}
				activeColorTweens[instance] = propMap
			end
			propMap[property] = {
				L1 = L1, a1 = a1, b1 = b1,
				L2 = L2, a2 = a2, b2 = b2,
				toColor = targetColor,
				elapsed = 0,
				duration = duration or 0.22
			}
			activeColorCount += 1
			ensureSpringScheduler()
		end

		function Creator.CancelSpring(instance, property)
			local propMap = activeSprings[instance]
			if not propMap then
				return
			end
			if property == nil then
				for _ in next, propMap do
					activeSpringCount = math.max(0, activeSpringCount - 1)
				end
				activeSprings[instance] = nil
			elseif propMap[property] then
				propMap[property] = nil
				activeSpringCount = math.max(0, activeSpringCount - 1)
				if next(propMap) == nil then
					activeSprings[instance] = nil
				end
			end
		end

		-- Compute the real rendered UIScale multiplier affecting `instance` so any
		-- AbsoluteSize / AbsoluteContentSize / AbsolutePosition reading can be cleanly
		-- converted back to unscaled UDim2 offsets without DPI^2 bloat or entrance drift.
		function Creator.GetEffectiveScale(instance)
			local scale = 1
			local node = instance
			local depth = 0
			while node and depth < 16 do
				if node:IsA("ScreenGui") then
					break
				end
				local uiScale = node:FindFirstChildOfClass("UIScale")
				if uiScale then
					scale *= uiScale.Scale
				end
				node = node.Parent
				depth += 1
			end
			if scale <= 0.01 then
				return math.max(0.01, Creator.DPIScale)
			end
			return scale
		end

		function Creator.GetGuiInsetY()
			local ok, tl = pcall(function()
				return GuiService:GetGuiInset()
			end)
			if ok and typeof(tl) == "Vector2" then
				return tl.Y
			end
			return 36
		end

		-- DPI Scale Registry: allows Library:SetDPIScale(scale) to scale Window,
		-- Notifications, and Popovers consistently while preserving spring anim multipliers.
		-- Strong map with parent-pruning + Disconnect clear prevents Roblox Instance wrapper GC eviction.
		local dpiTargets = {}
		function Creator.RegisterDPIScale(uiScale, onUpdate)
			if not uiScale then
				return
			end
			dpiTargets[uiScale] = onUpdate or true
			if type(onUpdate) == "function" then
				onUpdate(Creator.DPIScale)
			else
				uiScale.Scale = Creator.DPIScale
			end
		end

		function Creator.SetDPIScale(scale)
			scale = math.clamp(tonumber(scale) or 1, 0.75, 1.5)
			Creator.DPIScale = scale
			for uiScale, handler in next, dpiTargets do
				if uiScale and uiScale.Parent then
					if type(handler) == "function" then
						pcall(handler, scale)
					else
						uiScale.Scale = scale
					end
				else
					dpiTargets[uiScale] = nil
				end
			end
			return scale
		end

		function Creator.SetReducedMotion(enabled)
			Creator.ReducedMotion = enabled == true
			if Creator.ReducedMotion then
				-- Flush active animations immediately to their target values.
				for instance, propMap in next, activeSprings do
					if instance and instance.Parent then
						for _, state in next, propMap do
							if state.setter then
								pcall(state.setter, state.target)
							else
								pcall(function() instance[state.property] = state.target end)
							end
						end
					end
					activeSprings[instance] = nil
				end
				for instance, propMap in next, activeColorTweens do
					if instance and instance.Parent then
						for prop, tween in next, propMap do
							pcall(function() instance[prop] = tween.toColor end)
						end
					end
					activeColorTweens[instance] = nil
				end
				stopSpringScheduler()
			end
			return Creator.ReducedMotion
		end

		Creator.Motion = {
			Spring = Creator.SpringValue,
			Color = Creator.AnimateColor,
			LerpColorOklab = Creator.LerpColorOklab,
			AutoContrast = Creator.AutoContrast,
			Cancel = Creator.CancelSpring,
			SetReduced = Creator.SetReducedMotion,
			IsReduced = function()
				return Creator.ReducedMotion
			end
		}

		-- ============================================================================
		-- Shared InputRouter: single UserInputService dispatcher for drags & keybinds.
		-- Eliminates O(N) global UIS connections across Sliders and Keybinds.
		-- ============================================================================
		local activeDragMove = nil
		local activeDragEnd = nil
		local dragChangedConn = nil
		local dragEndedConn = nil

		local keybindByEntry = {}
		local keybindCount = 0
		local keybindBeganConn = nil

		local function stopDragConnections()
			activeDragMove = nil
			activeDragEnd = nil
			if dragChangedConn then
				dragChangedConn:Disconnect()
				dragChangedConn = nil
			end
			if dragEndedConn then
				dragEndedConn:Disconnect()
				dragEndedConn = nil
			end
		end

		function Creator.BeginDrag(onMove, onEnd)
			if activeDragEnd then
				local prevEnd = activeDragEnd
				activeDragMove = nil
				activeDragEnd = nil
				pcall(prevEnd)
			end
			activeDragMove = onMove
			activeDragEnd = onEnd
			if not dragChangedConn then
				dragChangedConn = UserInputService.InputChanged:Connect(function(input)
					if not activeDragMove then
						return
					end
					if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
						activeDragMove(input)
					end
				end)
			end
			if not dragEndedConn then
				dragEndedConn = UserInputService.InputEnded:Connect(function(input)
					if not activeDragEnd then
						return
					end
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						local finish = activeDragEnd
						stopDragConnections()
						finish(input)
					end
				end)
			end
		end

		function Creator.EndDrag()
			stopDragConnections()
		end

		local function ensureKeybindListener()
			if keybindBeganConn then
				return
			end
			keybindBeganConn = UserInputService.InputBegan:Connect(function(input)
				if keybindCount <= 0 or UserInputService:GetFocusedTextBox() then
					return
				end
				local pressedKey = nil
				if input.UserInputType == Enum.UserInputType.Keyboard then
					pressedKey = input.KeyCode.Name
				elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
					pressedKey = "MouseLeft"
				elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
					pressedKey = "MouseRight"
				else
					return
				end
				for entry in next, keybindByEntry do
					if not entry.IsPicking() and entry.GetMode() == "Toggle" and entry.GetKey() == pressedKey then
						entry.Trigger()
					end
				end
			end)
		end

		function Creator.RegisterKeybind(entry)
			if not keybindByEntry[entry] then
				keybindByEntry[entry] = true
				keybindCount += 1
				ensureKeybindListener()
			end
			return entry
		end

		function Creator.UnregisterKeybind(entry)
			if keybindByEntry[entry] then
				keybindByEntry[entry] = nil
				keybindCount = math.max(0, keybindCount - 1)
				if keybindCount == 0 and keybindBeganConn then
					keybindBeganConn:Disconnect()
					keybindBeganConn = nil
				end
			end
		end

		-- ============================================================================
		-- RGB theme & Registry
		-- ============================================================================
		local RAINBOW_KEYS = {
			Accent = true,
			AcrylicBorder = true,
			TitleBarLine = true,
			ElementBorder = true,
			InElementBorder = true,
			DropdownBorder = true,
			InputIndicator = true,
			DialogHolderLine = true,
			DialogButtonBorder = true,
			DialogBorder = true,
			DialogInputLine = true
		}
		local rainbowTargets = {}
		local rainbowColor = nil
		local rainbowConnection = nil
		local function usesRainbowKey(properties)
			for _, themeKey in next, properties do
				if RAINBOW_KEYS[themeKey] then
					return true
				end
			end
			return false
		end
		local function rainbowNow()
			return Color3.fromHSV((os.clock() * 0.1) % 1, 0.85, 1)
		end
		local function stepRainbow()
			rainbowColor = rainbowNow()
			for object in next, rainbowTargets do
				if not object or not object.Parent then
					rainbowTargets[object] = nil
					Creator.Registry[object] = nil
				else
					local properties = Creator.Registry[object]
					if properties then
						for property, themeKey in next, properties do
							if RAINBOW_KEYS[themeKey] then
								object[property] = rainbowColor
							end
						end
					end
				end
			end
		end
		local function stopRainbow()
			if rainbowConnection then
				rainbowConnection:Disconnect()
				rainbowConnection = nil
			end
			rainbowColor = nil
		end
		local function startRainbow()
			if rainbowConnection then
				return
			end
			rainbowColor = rainbowNow()
			local elapsed = 0
			rainbowConnection = RunService.Heartbeat:Connect(function(deltaTime)
				elapsed = elapsed + deltaTime
				if elapsed < 0.1 then
					return
				end
				elapsed = 0
				local library = getLibrary()
				if library.Window and library.Window.Minimized then
					return
				end
				stepRainbow()
			end)
		end
		Creator.StopRainbow = stopRainbow

		function Creator.Disconnect()
			stopSpringScheduler()
			stopDragConnections()
			table.clear(dpiTargets)
			table.clear(Creator.Registry)
			table.clear(Creator.TransparencyTargets)
			table.clear(rainbowTargets)
			if keybindBeganConn then
				keybindBeganConn:Disconnect()
				keybindBeganConn = nil
			end
			table.clear(keybindByEntry)
			keybindCount = 0
			for index = #Creator.Signals, 1, -1 do
				local connection = table.remove(Creator.Signals, index)
				connection:Disconnect()
			end
		end

		function Creator.GetThemeProperty(property)
			if rainbowColor and RAINBOW_KEYS[property] then
				return rainbowColor
			end
			local themeTable = Themes[getLibrary().Theme]
			if themeTable and themeTable[property] ~= nil then
				return themeTable[property]
			end
			return Themes.Dark[property]
		end

		function Creator.UpdateTheme(instant)
			local theme = Themes[getLibrary().Theme]
			if theme and theme.IsRGB then
				startRainbow()
			else
				stopRainbow()
			end
			local useOklab = (instant ~= true) and (not Creator.ReducedMotion) and (not (theme and theme.IsRGB))
			local elementTransparency = Creator.GetThemeProperty("ElementTransparency")
			for object, properties in next, Creator.Registry do
				if object and object.Parent then
					for property, themeKey in next, properties do
						local targetVal = Creator.GetThemeProperty(themeKey)
						if useOklab and typeof(targetVal) == "Color3" then
							Creator.AnimateColor(object, property, targetVal, 0.22)
						else
							cancelColorTween(object, property)
							object[property] = targetVal
						end
					end
				else
					Creator.Registry[object] = nil
					rainbowTargets[object] = nil
				end
			end
			for instance, property in next, Creator.TransparencyTargets do
				if instance and instance.Parent then
					if useOklab then
						Creator.SpringValue(instance, property, elementTransparency, 10, 1)
					else
						Creator.CancelSpring(instance, property)
						instance[property] = elementTransparency
					end
				else
					Creator.TransparencyTargets[instance] = nil
				end
			end
			for _, motor in next, Creator.TransparencyMotors do
				motor:setGoal(Flipper.Instant.new(elementTransparency))
			end
		end

		function Creator.AddThemeObject(object, properties)
			Creator.Registry[object] = properties
			rainbowTargets[object] = usesRainbowKey(properties) or nil
			for property, themeKey in next, properties do
				cancelColorTween(object, property)
				object[property] = Creator.GetThemeProperty(themeKey)
			end
			return object
		end

		function Creator.OverrideTag(object, properties)
			properties = properties or {}
			Creator.Registry[object] = properties
			rainbowTargets[object] = usesRainbowKey(properties) or nil
			for property, themeKey in next, properties do
				cancelColorTween(object, property)
				object[property] = Creator.GetThemeProperty(themeKey)
			end
		end

		function Creator.New(className, properties, children)
			local object = Instance.new(className)
			local defaults = Creator.DefaultProperties[className]
			if defaults then
				for name, value in next, defaults do
					object[name] = value
				end
			end
			local parent = nil
			local themeTag = nil
			if properties then
				parent = properties.Parent
				themeTag = properties.ThemeTag
				for name, value in next, properties do
					if not META_KEYS[name] then
						object[name] = value
					end
				end
			end
			if children then
				for _, child in next, children do
					child.Parent = object
				end
			end
			if themeTag then
				Creator.AddThemeObject(object, themeTag)
			end
			if TEXT_CLASSES[className] then
				CustomizationSystem.I18n:AutoRegister(object, properties)
			end
			-- Set Parent LAST so Roblox layout / DataModel notifications fire once.
			if parent ~= nil then
				object.Parent = parent
			end
			return object
		end

		-- Backwards-compatible SpringMotor backed by the zero-alloc shared spring scheduler.
		function Creator.SpringMotor(initial, instance, property, ignoreDialogCheck, resetOnThemeChange)
			ignoreDialogCheck = ignoreDialogCheck or false
			resetOnThemeChange = resetOnThemeChange or false
			if resetOnThemeChange and instance then
				Creator.TransparencyTargets[instance] = property
			end
			local currentVal = initial
			local proxy = {
				getValue = function()
					local ok, val = pcall(function()
						return instance[property]
					end)
					return (ok and type(val) == "number") and val or currentVal
				end,
				setGoal = function(_, goal)
					if type(goal) == "table" then
						local target = goal._targetValue
						if target ~= nil then
							currentVal = target
							if goal._frequency then
								Creator.SpringValue(instance, property, target, goal._frequency, goal._dampingRatio or 1)
							else
								Creator.CancelSpring(instance, property)
								instance[property] = target
							end
						end
					end
				end,
				stop = function()
					Creator.CancelSpring(instance, property)
				end
			}
			local setValue = function(value, ignore)
				ignore = ignore or false
				if not ignoreDialogCheck and not ignore then
					if property == "BackgroundTransparency" and getLibrary().DialogOpen then
						return
					end
				end
				currentVal = value
				Creator.SpringValue(instance, property, value, 8, 1)
			end
			return proxy, setValue
		end
		return Creator
	end,
	[19] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(19)
		local Elements = {}
		for _, child in next, moduleScript:GetChildren() do
			table.insert(Elements, requireModule(child))
		end
		return Elements
	end,
	[20] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(20)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local New, Components, Element = Creator.New, Root.Components, {}
		Element.__index = Element
		Element.__type = "Button"

		local DANGER_BG = Color3.fromRGB(220, 38, 38)
		local DANGER_BORDER = Color3.fromRGB(248, 113, 113)
		local WARN_BG = Color3.fromRGB(217, 119, 6)

		function Element.New(parent, config)
			assert(config.Title, "Button - Missing Title")
			config.Callback = config.Callback or function()
			end
			local variant = config.Variant or "Default"
			local inlineConfirm = config.InlineConfirm == true
			local buttonFrame = requireModule(Components.Element)(config.Title, config.Description, parent.Container, variant == "Default")
			buttonFrame.TitleLabel.Size = UDim2.new(1, -40, 0, 14)
			buttonFrame.DescLabel.Size = UDim2.new(1, -40, 0, 14)

			local iconName = config.Icon
			local rightIconAsset = (type(iconName) == "string" and (parent.Library:GetIcon(iconName) or (iconName:match("^rbxassetid://") and iconName)))
				or parent.Library:GetIcon("chevron-right")
				or "rbxassetid://10709791437"

			local icon = New(
				"ImageLabel",
				{
					Image = rightIconAsset,
					Size = UDim2.fromOffset(16, 16),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -12, 0.5, 0),
					BackgroundTransparency = 1,
					ImageTransparency = 0.04,
					Parent = buttonFrame.Frame,
					ThemeTag = variant == "Default" and {ImageColor3 = "SubText"} or nil
				}
			)

			local function applyVariantVisual(mode)
				if mode == "Primary" then
					local accent = Creator.GetThemeProperty("Accent")
					local contrast = Creator.AutoContrast(accent)
					Creator.OverrideTag(buttonFrame.Frame, {BackgroundColor3 = "Accent"})
					Creator.OverrideTag(buttonFrame.Border, {Color = "Accent"})
					Creator.OverrideTag(buttonFrame.TitleLabel, {})
					Creator.OverrideTag(buttonFrame.DescLabel, {})
					buttonFrame.Frame.BackgroundTransparency = 0.14
					buttonFrame.Border.Transparency = 0.2
					buttonFrame.TitleLabel.TextColor3 = contrast
					buttonFrame.DescLabel.TextColor3 = contrast
					buttonFrame.DescLabel.TextTransparency = 0.04
					icon.ImageColor3 = contrast
				elseif mode == "Danger" then
					Creator.OverrideTag(buttonFrame.Frame, {})
					Creator.OverrideTag(buttonFrame.Border, {})
					Creator.OverrideTag(buttonFrame.TitleLabel, {})
					Creator.OverrideTag(buttonFrame.DescLabel, {})
					buttonFrame.Frame.BackgroundColor3 = DANGER_BG
					buttonFrame.Frame.BackgroundTransparency = 0.22
					buttonFrame.Border.Color = DANGER_BORDER
					buttonFrame.Border.Transparency = 0.25
					buttonFrame.TitleLabel.TextColor3 = Color3.fromRGB(255, 245, 245)
					buttonFrame.DescLabel.TextColor3 = Color3.fromRGB(254, 215, 215)
					icon.ImageColor3 = Color3.fromRGB(255, 245, 245)
				elseif mode == "ConfirmPending" then
					Creator.OverrideTag(buttonFrame.Frame, {})
					Creator.OverrideTag(buttonFrame.Border, {})
					Creator.OverrideTag(buttonFrame.TitleLabel, {})
					buttonFrame.Frame.BackgroundColor3 = WARN_BG
					buttonFrame.Frame.BackgroundTransparency = 0.14
					buttonFrame.Border.Color = Color3.fromRGB(251, 191, 36)
					buttonFrame.Border.Transparency = 0.15
					buttonFrame.TitleLabel.TextColor3 = Color3.fromRGB(255, 251, 235)
					icon.ImageColor3 = Color3.fromRGB(255, 251, 235)
				else
					Creator.OverrideTag(buttonFrame.Frame, {BackgroundColor3 = "Element", BackgroundTransparency = "ElementTransparency"})
					Creator.OverrideTag(buttonFrame.Border, {Color = "ElementBorder"})
					Creator.OverrideTag(buttonFrame.TitleLabel, {TextColor3 = "Text"})
					Creator.OverrideTag(buttonFrame.DescLabel, {TextColor3 = "SubText"})
					Creator.OverrideTag(icon, {ImageColor3 = "SubText"})
					buttonFrame.DescLabel.TextTransparency = 0
				end
			end

			if variant ~= "Default" then
				applyVariantVisual(variant)
				if variant == "Primary" then
					Creator.AddSignal(buttonFrame.Frame:GetPropertyChangedSignal("BackgroundColor3"), function()
						if not confirmPending then
							local contrast = Creator.AutoContrast(buttonFrame.Frame.BackgroundColor3)
							buttonFrame.TitleLabel.TextColor3 = contrast
							buttonFrame.DescLabel.TextColor3 = contrast
							icon.ImageColor3 = contrast
						end
					end)
				end
				Creator.AddSignal(buttonFrame.Frame.MouseEnter, function()
					Creator.SpringValue(buttonFrame.Frame, "BackgroundTransparency", 0.04, 10, 1)
				end)
				Creator.AddSignal(buttonFrame.Frame.MouseLeave, function()
					Creator.SpringValue(buttonFrame.Frame, "BackgroundTransparency", variant == "Primary" and 0.14 or 0.22, 10, 1)
				end)
			end

			Creator.AddSignal(buttonFrame.Frame.MouseEnter, function()
				Creator.SpringValue(icon, "ImageTransparency", 0, 10, 1)
				Creator.SpringValue(icon, "Position", -9, 10, 0.85, function(xOff)
					icon.Position = UDim2.new(1, xOff, 0.5, 0)
				end, icon.Position.X.Offset)
			end)
			Creator.AddSignal(buttonFrame.Frame.MouseLeave, function()
				Creator.SpringValue(icon, "ImageTransparency", 0.04, 10, 1)
				Creator.SpringValue(icon, "Position", -12, 10, 0.85, function(xOff)
					icon.Position = UDim2.new(1, xOff, 0.5, 0)
				end, icon.Position.X.Offset)
			end)

			local confirmPending = false
			local confirmGen = 0
			local savedTitle = config.Title
			local loading = false
			local loadingSpinner = nil

			function buttonFrame:SetLoading(isLoading, loadingText)
				local on = isLoading ~= false
				if on then
					if not loading then
						savedTitle = buttonFrame.TitleLabel.Text
					end
					loading = true
					if type(loadingText) == "string" and loadingText ~= "" then
						buttonFrame.TitleLabel.Text = loadingText
					end
					icon.Visible = false
					if not loadingSpinner then
						local SpinnerModule = requireModule(Root.Elements.Spinner)
						local colorOverride = variant ~= "Default" and Creator.AutoContrast(buttonFrame.Frame.BackgroundColor3) or nil
						loadingSpinner = SpinnerModule.CreateIndicator(buttonFrame.Frame, {
							Variant = "Ring",
							Size = 15,
							Color = colorOverride,
							Active = true,
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -12, 0.5, 0)
						})
					else
						if variant ~= "Default" then
							loadingSpinner:SetColor(Creator.AutoContrast(buttonFrame.Frame.BackgroundColor3))
						end
						loadingSpinner:SetActive(true)
					end
					if variant == "Default" then
						Creator.SpringValue(buttonFrame.Frame, "BackgroundTransparency", 0.92, 10, 1)
					else
						Creator.SpringValue(buttonFrame.Frame, "BackgroundTransparency", 0.34, 10, 1)
					end
				else
					loading = false
					buttonFrame.TitleLabel.Text = savedTitle
					if loadingSpinner then
						loadingSpinner:SetActive(false)
					end
					icon.Visible = true
					applyVariantVisual(confirmPending and "ConfirmPending" or variant)
				end
				return buttonFrame
			end

			local baseDestroy = buttonFrame.Destroy
			function buttonFrame:Destroy()
				if loadingSpinner then
					loadingSpinner:Destroy()
					loadingSpinner = nil
				end
				if type(baseDestroy) == "function" then
					baseDestroy(buttonFrame)
				end
			end

			Creator.AddSignal(buttonFrame.Frame.Destroying, function()
				if loadingSpinner then
					loadingSpinner:Destroy()
					loadingSpinner = nil
				end
			end)

			Creator.AddSignal(
				buttonFrame.Frame.MouseButton1Click,
				function()
					if loading then
						return
					end
					if inlineConfirm and not confirmPending then
						confirmPending = true
						confirmGen += 1
						local myGen = confirmGen
						savedTitle = buttonFrame.TitleLabel.Text
						buttonFrame.TitleLabel.Text = config.ConfirmText or "Click again to confirm"
						applyVariantVisual("ConfirmPending")
						task.delay(3, function()
							if myGen == confirmGen and confirmPending and buttonFrame.Frame and buttonFrame.Frame.Parent then
								confirmPending = false
								buttonFrame.TitleLabel.Text = savedTitle
								applyVariantVisual(variant)
							end
						end)
						return
					end
					if confirmPending then
						confirmPending = false
						confirmGen += 1
						buttonFrame.TitleLabel.Text = savedTitle
						applyVariantVisual(variant)
					end
					parent.Library._TouchElement(buttonFrame)
					parent.Library:SafeCallback(config.Callback)
				end
			)
			return buttonFrame
		end
		return Element
	end,
	[21] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(21)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local TweenService = Creator.GetService("TweenService")
		local UserInputService = Creator.GetService("UserInputService")
		local Players = Creator.GetService("Players")
		local Workspace = Creator.GetService("Workspace")
		local mouse = Players.LocalPlayer:GetMouse()
		local New, Components, Element = Creator.New, Root.Components, {}
		Element.__index = Element
		Element.__type = "Colorpicker"

		local PRESET_SWATCHES = {
			Color3.fromRGB(99, 179, 255),
			Color3.fromRGB(129, 140, 248),
			Color3.fromRGB(168, 85, 247),
			Color3.fromRGB(244, 114, 182),
			Color3.fromRGB(248, 113, 113),
			Color3.fromRGB(251, 191, 36),
			Color3.fromRGB(52, 211, 153),
			Color3.fromRGB(244, 246, 252)
		}

		local function copyToClipboard(text)
			local fn = setclipboard or toclipboard or (syn and syn.write_clipboard)
			if type(fn) == "function" then
				return pcall(fn, tostring(text))
			end
			return false
		end

		function Element.New(parent, idx, config)
			if type(idx) == "table" and config == nil then
				config = idx
				idx = nil
			end
			local Library = parent.Library
			local isInline = config and config._InlineHolder ~= nil
			if not isInline then
				assert(config.Title, "Colorpicker - Missing Title")
			end
			assert(config.Default, "AddColorPicker: Missing default value.")
			local Colorpicker = {
				Value = config.Default,
				Transparency = config.Transparency or 0,
				HasAlpha = config.Transparency ~= nil,
				Type = "Colorpicker",
				Opened = false,
				Title = type(config.Title) == "string" and config.Title or "Colorpicker",
				Callback = config.Callback or function(_color)
				end
			}
			function Colorpicker.SetHSVFromRGB(_self, color)
				local hue, sat, vib = Color3.toHSV(color)
				Colorpicker.Hue = hue
				Colorpicker.Sat = sat
				Colorpicker.Vib = vib
			end
			Colorpicker:SetHSVFromRGB(Colorpicker.Value)

			local colorpickerFrame, hexPreviewLabel, displayFrame, swatchButton, hitAnchorFrame
			if isInline then
				displayFrame = New(
					"Frame",
					{Size = UDim2.fromScale(1, 1), BackgroundColor3 = Colorpicker.Value, BackgroundTransparency = Colorpicker.Transparency},
					{New("UICorner", {CornerRadius = UDim.new(0, 5)})}
				)
				swatchButton = New(
					"TextButton",
					{
						Name = "InlineColorSwatch",
						Text = "",
						Size = UDim2.fromOffset(22, 18),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 0.85,
						AutoButtonColor = false,
						LayoutOrder = config._LayoutOrder or 2,
						ZIndex = 4,
						Parent = config._InlineHolder
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 5)}),
						New("UIStroke", {Transparency = 0.34, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "InElementBorder"}}),
						displayFrame
					}
				)
				hitAnchorFrame = swatchButton
				Colorpicker.Frame = swatchButton
			else
				colorpickerFrame = requireModule(Components.Element)(config.Title, config.Description, parent.Container, true)
				colorpickerFrame.TitleLabel.Size = UDim2.new(1, -118, 0, 14)
				colorpickerFrame.DescLabel.Size = UDim2.new(1, -118, 0, 14)
				Colorpicker.SetTitle = colorpickerFrame.SetTitle
				Colorpicker.SetDesc = colorpickerFrame.SetDesc
				Colorpicker.SetBadge = colorpickerFrame.SetBadge
				Colorpicker.Frame = colorpickerFrame.Frame
				hitAnchorFrame = colorpickerFrame.Frame

				hexPreviewLabel = New(
					"TextLabel",
					{
						Name = "HexPreview",
						FontFace = Creator.Font(Enum.FontWeight.Medium, Enum.FontStyle.Normal),
						Text = "#" .. Colorpicker.Value:ToHex():upper(),
						I18nSkip = true,
						TextSize = 11,
						TextXAlignment = Enum.TextXAlignment.Right,
						Size = UDim2.fromOffset(58, 22),
						Position = UDim2.new(1, -48, 0.5, 0),
						AnchorPoint = Vector2.new(1, 0.5),
						BackgroundTransparency = 1,
						Parent = colorpickerFrame.Frame,
						ThemeTag = {TextColor3 = "SubText"}
					}
				)

				displayFrame = New(
					"Frame",
					{Size = UDim2.fromScale(1, 1), BackgroundColor3 = Colorpicker.Value, BackgroundTransparency = Colorpicker.Transparency},
					{New("UICorner", {CornerRadius = UDim.new(0, 6)})}
				)
				swatchButton = New(
					"ImageLabel",
					{
						Name = "Swatch",
						Size = UDim2.fromOffset(30, 20),
						Position = UDim2.new(1, -12, 0.5, 0),
						AnchorPoint = Vector2.new(1, 0.5),
						Parent = colorpickerFrame.Frame,
						Image = "rbxassetid://14204231522",
						ImageTransparency = 0.45,
						ScaleType = Enum.ScaleType.Tile,
						TileSize = UDim2.fromOffset(24, 24)
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 6)}),
						New("UIStroke", {Transparency = 0.34, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "InElementBorder"}}),
						displayFrame
					}
				)
			end

			-- Lazy Anchored Popover state (built on first open, zero boot cost)
			local scrollFrame = parent.ScrollFrame
			local popoverBuilt = false
			local popoverCanvas, popoverCard, popoverScale, popoverShadow, popoverStroke
			local satVibMap, satCursor, hueBar, hueThumb, alphaBar, alphaThumb, alphaGradFrame
			local hexBox, copyBtnIcon, previewNew, previewOld
			local openConnections = {}
			local openTransitionId = 0
			local initialSnapshotColor = Colorpicker.Value
			local initialSnapshotAlpha = Colorpicker.Transparency
			local POPOVER_WIDTH = 248
			local POPOVER_HEIGHT = Colorpicker.HasAlpha and 284 or 262

			local function disconnectWhileOpen()
				for i = #openConnections, 1, -1 do
					openConnections[i]:Disconnect()
					openConnections[i] = nil
				end
			end

			local function syncPopoverVisuals()
				if not popoverBuilt then
					return
				end
				local h, s, v = Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib
				local current = Color3.fromHSV(h, s, v)
				satVibMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
				satCursor.Position = UDim2.new(s, 0, 1 - v, 0)
				hueThumb.Position = UDim2.new(h, 0, 0.5, 0)
				previewNew.BackgroundColor3 = current
				previewNew.BackgroundTransparency = Colorpicker.Transparency
				if hexBox and not hexBox:IsFocused() then
					hexBox.Text = "#" .. current:ToHex():upper()
				end
				if Colorpicker.HasAlpha and alphaThumb and alphaGradFrame then
					alphaGradFrame.BackgroundColor3 = current
					alphaThumb.Position = UDim2.new(1 - Colorpicker.Transparency, 0, 0.5, 0)
				end
			end

			local function commitColor(touch)
				Colorpicker.Value = Color3.fromHSV(Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib)
				displayFrame.BackgroundColor3 = Colorpicker.Value
				displayFrame.BackgroundTransparency = Colorpicker.Transparency
				if hexPreviewLabel then
					hexPreviewLabel.Text = "#" .. Colorpicker.Value:ToHex():upper()
				end
				syncPopoverVisuals()
				Library:SafeCallback(Colorpicker.Callback, Colorpicker.Value)
				Library:SafeCallback(Colorpicker.Changed, Colorpicker.Value)
				if touch then
					Library._TouchElement(Colorpicker)
				end
			end

			local function repositionPopover()
				if not popoverBuilt then
					return
				end
				local camera = Workspace.CurrentCamera
				local rawViewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
				local insetY = Creator.GetGuiInsetY()
				local usableW = rawViewport.X
				local usableH = math.max(160, rawViewport.Y - insetY)
				local pos = swatchButton.AbsolutePosition
				local sz = swatchButton.AbsoluteSize
				local scale = Creator.DPIScale
				local scaledW = POPOVER_WIDTH * scale
				local scaledH = POPOVER_HEIGHT * scale

				local x = pos.X + sz.X + 14
				if x + scaledW > usableW - 10 then
					x = pos.X - scaledW - 14
				end
				x = math.clamp(x, 10, math.max(10, usableW - scaledW - 10))

				local y = pos.Y - 24
				y = math.clamp(y, 10, math.max(10, usableH - scaledH - 10))
				popoverCanvas.Position = UDim2.fromOffset(x, y)
			end

			local function ensurePopover()
				if popoverBuilt then
					return
				end
				popoverBuilt = true

				local hueKeypoints = {}
				for step = 0, 10 do
					local t = step / 10
					table.insert(hueKeypoints, ColorSequenceKeypoint.new(t, Color3.fromHSV(t, 1, 1)))
				end

				satCursor = New(
					"Frame",
					{
						Size = UDim2.fromOffset(14, 14),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						ZIndex = 45
					},
					{
						New("UICorner", {CornerRadius = UDim.new(1, 0)}),
						New("UIStroke", {Color = Color3.fromRGB(255, 255, 255), Thickness = 2}),
						New("Frame", {
							Size = UDim2.fromOffset(16, 16),
							Position = UDim2.fromScale(0.5, 0.5),
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							ZIndex = 43
						}, {
							New("UICorner", {CornerRadius = UDim.new(1, 0)}),
							New("UIStroke", {Color = Color3.fromRGB(0, 0, 0), Thickness = 1, Transparency = 0.45})
						})
					}
				)

				-- Pure 2-layer vector UIGradient SV pad (0ms load, crisp at any DPI, no external image asset)
				satVibMap = New(
					"Frame",
					{
						Name = "SVPad",
						Size = UDim2.new(1, -24, 0, 128),
						Position = UDim2.fromOffset(12, 34),
						BackgroundColor3 = Color3.fromHSV(Colorpicker.Hue, 1, 1),
						BackgroundTransparency = 0,
						ClipsDescendants = true,
						Active = true,
						ZIndex = 42
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 8)}),
						-- Saturation white-to-transparent horizontal layer
						New("Frame", {
							Name = "SatGradient",
							Size = UDim2.fromScale(1, 1),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BorderSizePixel = 0,
							ZIndex = 42
						}, {
							New("UICorner", {CornerRadius = UDim.new(0, 8)}),
							New("UIGradient", {
								Rotation = 0,
								Transparency = NumberSequence.new({
									NumberSequenceKeypoint.new(0, 0),
									NumberSequenceKeypoint.new(1, 1)
								})
							})
						}),
						-- Value transparent-to-black vertical layer
						New("Frame", {
							Name = "ValGradient",
							Size = UDim2.fromScale(1, 1),
							BackgroundColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							ZIndex = 43
						}, {
							New("UICorner", {CornerRadius = UDim.new(0, 8)}),
							New("UIGradient", {
								Rotation = 90,
								Transparency = NumberSequence.new({
									NumberSequenceKeypoint.new(0, 1),
									NumberSequenceKeypoint.new(1, 0)
								})
							})
						}),
						New("UIStroke", {Transparency = 0.55, Thickness = 1, ZIndex = 44, ThemeTag = {Color = "InElementBorder"}}),
						satCursor
					}
				)

				hueThumb = New(
					"Frame",
					{
						Size = UDim2.fromOffset(14, 14),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0, 0, 0.5, 0),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						ZIndex = 44
					},
					{
						New("UICorner", {CornerRadius = UDim.new(1, 0)}),
						New("UIStroke", {Color = Color3.fromRGB(15, 17, 24), Thickness = 1.5})
					}
				)

				hueBar = New(
					"Frame",
					{
						Name = "HueBar",
						Size = UDim2.new(1, -24, 0, 12),
						Position = UDim2.fromOffset(12, 172),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						Active = true,
						ZIndex = 42
					},
					{
						New("UICorner", {CornerRadius = UDim.new(1, 0)}),
						New("UIGradient", {Color = ColorSequence.new(hueKeypoints), Rotation = 0}),
						hueThumb
					}
				)

				local nextY = 194
				if Colorpicker.HasAlpha then
					alphaThumb = New(
						"Frame",
						{
							Size = UDim2.fromOffset(14, 14),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(1, 0, 0.5, 0),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							ZIndex = 44
						},
						{
							New("UICorner", {CornerRadius = UDim.new(1, 0)}),
							New("UIStroke", {Color = Color3.fromRGB(15, 17, 24), Thickness = 1.5})
						}
					)
					alphaGradFrame = New(
						"Frame",
						{Size = UDim2.fromScale(1, 1), BackgroundColor3 = Colorpicker.Value, ZIndex = 43},
						{
							New("UICorner", {CornerRadius = UDim.new(1, 0)}),
							New("UIGradient", {
								Transparency = NumberSequence.new({
									NumberSequenceKeypoint.new(0, 1),
									NumberSequenceKeypoint.new(1, 0)
								}),
								Rotation = 0
							})
						}
					)
					alphaBar = New(
						"ImageLabel",
						{
							Name = "AlphaBar",
							Size = UDim2.new(1, -24, 0, 12),
							Position = UDim2.fromOffset(12, nextY),
							Image = "rbxassetid://14204231522",
							ImageTransparency = 0.4,
							ScaleType = Enum.ScaleType.Tile,
							TileSize = UDim2.fromOffset(16, 16),
							Active = true,
							ZIndex = 42
						},
						{New("UICorner", {CornerRadius = UDim.new(1, 0)}), alphaGradFrame, alphaThumb}
					)
					nextY += 22
				end

				-- Hex input + Copy button + Old/New preview chip row
				previewOld = New("Frame", {Size = UDim2.new(0.5, 0, 1, 0), BackgroundColor3 = Colorpicker.Value, ZIndex = 43})
				previewNew = New("Frame", {Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.fromScale(0.5, 0), BackgroundColor3 = Colorpicker.Value, ZIndex = 43})
				local previewChip = New(
					"TextButton",
					{
						Name = "CompareChip",
						Text = "",
						Size = UDim2.fromOffset(42, 26),
						Position = UDim2.fromOffset(12, nextY),
						BackgroundTransparency = 1,
						ClipsDescendants = true,
						ZIndex = 42
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 6)}),
						New("UIStroke", {Transparency = 0.45, Thickness = 1, ThemeTag = {Color = "InElementBorder"}}),
						previewOld,
						previewNew
					}
				)
				-- Clicking left/compare chip resets to color before opening
				Creator.AddSignal(previewChip.MouseButton1Click, function()
					Colorpicker:SetHSVFromRGB(initialSnapshotColor)
					Colorpicker.Transparency = initialSnapshotAlpha
					commitColor(true)
				end)

				hexBox = New(
					"TextBox",
					{
						Name = "HexInput",
						Size = UDim2.new(1, -106, 0, 26),
						Position = UDim2.fromOffset(60, nextY),
						BackgroundTransparency = 0.22,
						Text = "#" .. Colorpicker.Value:ToHex():upper(),
						PlaceholderText = "#RRGGBB",
						I18nSkip = true,
						FontFace = Creator.Font(Enum.FontWeight.Medium),
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left,
						ZIndex = 42,
						ThemeTag = {BackgroundColor3 = "DialogHolder", TextColor3 = "Text", PlaceholderColor3 = "SubText"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 6)}),
						New("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}),
						New("UIStroke", {Transparency = 0.38, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "InElementBorder"}})
					}
				)

				local copyAsset = Library:GetIcon("copy") or "rbxassetid://10709812159"
				local checkAsset = Library:GetIcon("check") or "rbxassetid://10709790644"
				copyBtnIcon = New(
					"ImageLabel",
					{
						Image = copyAsset,
						Size = UDim2.fromOffset(13, 13),
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						ZIndex = 43,
						ThemeTag = {ImageColor3 = "Text"}
					}
				)
				local copyButton = New(
					"TextButton",
					{
						Name = "CopyHex",
						Text = "",
						Size = UDim2.fromOffset(28, 26),
						Position = UDim2.new(1, -40, 0, nextY),
						BackgroundTransparency = 0.28,
						ZIndex = 42,
						ThemeTag = {BackgroundColor3 = "DialogButton"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 6)}),
						New("UIStroke", {Transparency = 0.38, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "InElementBorder"}}),
						copyBtnIcon
					}
				)
				Creator.AddSignal(copyButton.MouseButton1Click, function()
					copyToClipboard("#" .. Colorpicker.Value:ToHex():upper())
					copyBtnIcon.Image = checkAsset
					Creator.OverrideTag(copyBtnIcon, {ImageColor3 = "Accent"})
					task.delay(0.9, function()
						if copyBtnIcon and copyBtnIcon.Parent then
							copyBtnIcon.Image = copyAsset
							Creator.OverrideTag(copyBtnIcon, {ImageColor3 = "Text"})
						end
					end)
				end)

				-- Swatches row
				local swatchesRow = New(
					"Frame",
					{
						Name = "Swatches",
						Size = UDim2.new(1, -24, 0, 22),
						Position = UDim2.fromOffset(12, nextY + 34),
						BackgroundTransparency = 1,
						ZIndex = 42
					},
					{
						New("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							Padding = UDim.new(0, 6)
						})
					}
				)
				for _, swatchColor in ipairs(PRESET_SWATCHES) do
					local chip = New(
						"TextButton",
						{
							Text = "",
							Size = UDim2.fromOffset(22, 20),
							BackgroundColor3 = swatchColor,
							ZIndex = 43,
							Parent = swatchesRow
						},
						{
							New("UICorner", {CornerRadius = UDim.new(0, 6)}),
							New("UIStroke", {Transparency = 0.55, Thickness = 1, Color = Color3.fromRGB(255, 255, 255)})
						}
					)
					Creator.AddSignal(chip.MouseButton1Click, function()
						Colorpicker:SetHSVFromRGB(swatchColor)
						commitColor(true)
					end)
				end

				local headerTitle = New(
					"TextLabel",
					{
						Text = Colorpicker.Title,
						FontFace = Creator.Font(Enum.FontWeight.SemiBold),
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(1, -46, 0, 24),
						Position = UDim2.fromOffset(12, 6),
						BackgroundTransparency = 1,
						TextTruncate = Enum.TextTruncate.AtEnd,
						ZIndex = 42,
						ThemeTag = {TextColor3 = "Text"}
					}
				)
				local closeBtn = New(
					"TextButton",
					{
						Text = "",
						Size = UDim2.fromOffset(22, 22),
						Position = UDim2.new(1, -10, 0, 7),
						AnchorPoint = Vector2.new(1, 0),
						BackgroundTransparency = 1,
						ZIndex = 43,
						ThemeTag = {BackgroundColor3 = "Text"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 6)}),
						New("ImageLabel", {
							Image = Library:GetIcon("x") or "rbxassetid://10747384394",
							Size = UDim2.fromOffset(12, 12),
							Position = UDim2.fromScale(0.5, 0.5),
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							ZIndex = 44,
							ThemeTag = {ImageColor3 = "SubText"}
						})
					}
				)
				Creator.AddSignal(closeBtn.MouseButton1Click, function()
					Colorpicker:Close()
				end)

				popoverStroke = New("UIStroke", {Thickness = 1.2, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "DropdownBorder"}})
				local popoverBorderFrame = New(
					"Frame",
					{Name = "Border", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 46},
					{New("UICorner", {CornerRadius = UDim.new(0, 10)}), popoverStroke}
				)
				local cardChildren = {
					New("UICorner", {CornerRadius = UDim.new(0, 10)}),
					popoverBorderFrame,
					headerTitle,
					closeBtn,
					satVibMap,
					hueBar,
					previewChip,
					hexBox,
					copyButton,
					swatchesRow
				}
				if alphaBar then
					table.insert(cardChildren, alphaBar)
				end

				popoverCard = New(
					"CanvasGroup",
					{
						Name = "PopoverCard",
						Size = UDim2.fromScale(1, 1),
						GroupTransparency = 1,
						Active = true,
						ZIndex = 41,
						ThemeTag = {BackgroundColor3 = "DropdownHolder"}
					},
					cardChildren
				)

				local animS = 1
				popoverScale = New("UIScale", {Scale = Creator.DPIScale})
				local function syncPopScale()
					popoverScale.Scale = Creator.DPIScale * animS
				end
				Creator.RegisterDPIScale(popoverScale, function()
					syncPopScale()
					if Colorpicker.Opened then
						task.defer(repositionPopover)
					end
				end)

				popoverShadow = New("ImageLabel", {
					BackgroundTransparency = 1,
					Image = "rbxassetid://5554236805",
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(23, 23, 277, 277),
					Size = UDim2.new(1, 24, 1, 24),
					Position = UDim2.fromOffset(-12, -10),
					ImageColor3 = Color3.fromRGB(0, 0, 0),
					ImageTransparency = 1,
					ZIndex = 40
				})
				popoverCanvas = New(
					"Frame",
					{
						Name = "AcryvenColorPopover",
						BackgroundTransparency = 1,
						Size = UDim2.fromOffset(POPOVER_WIDTH, POPOVER_HEIGHT),
						Visible = false,
						ZIndex = 40,
						Parent = Library.OverlayGUI or Library.GUI
					},
					{
						popoverScale,
						popoverShadow,
						popoverCard
					}
				)
				table.insert(Library.OpenFrames, popoverCanvas)

				-- Hex text entry
				Creator.AddSignal(hexBox.FocusLost, function()
					local cleaned = tostring(hexBox.Text):gsub("^%s+", ""):gsub("%s+$", "")
					local ok, parsed = pcall(Color3.fromHex, cleaned)
					if ok and typeof(parsed) == "Color3" then
						Colorpicker:SetHSVFromRGB(parsed)
						commitColor(true)
					else
						syncPopoverVisuals()
					end
				end)

				-- Drag handlers via shared Creator.BeginDrag (zero blocking while loops!)
				local function updateSV(pos)
					local minX, minY = satVibMap.AbsolutePosition.X, satVibMap.AbsolutePosition.Y
					local w, h = math.max(1, satVibMap.AbsoluteSize.X), math.max(1, satVibMap.AbsoluteSize.Y)
					Colorpicker.Sat = math.clamp((pos.X - minX) / w, 0, 1)
					Colorpicker.Vib = 1 - math.clamp((pos.Y - minY) / h, 0, 1)
					commitColor(false)
				end
				Creator.AddSignal(satVibMap.InputBegan, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						updateSV(input.Position)
						Creator.BeginDrag(function(mv)
							updateSV(mv.Position)
						end, function()
							Library._TouchElement(Colorpicker)
						end)
					end
				end)

				local function updateHue(pos)
					local minX = hueBar.AbsolutePosition.X
					local w = math.max(1, hueBar.AbsoluteSize.X)
					Colorpicker.Hue = math.clamp((pos.X - minX) / w, 0, 1)
					commitColor(false)
				end
				Creator.AddSignal(hueBar.InputBegan, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						updateHue(input.Position)
						Creator.BeginDrag(function(mv)
							updateHue(mv.Position)
						end, function()
							Library._TouchElement(Colorpicker)
						end)
					end
				end)

				if alphaBar then
					local function updateAlpha(pos)
						local minX = alphaBar.AbsolutePosition.X
						local w = math.max(1, alphaBar.AbsoluteSize.X)
						Colorpicker.Transparency = 1 - math.clamp((pos.X - minX) / w, 0, 1)
						commitColor(false)
					end
					Creator.AddSignal(alphaBar.InputBegan, function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							updateAlpha(input.Position)
							Creator.BeginDrag(function(mv)
								updateAlpha(mv.Position)
							end, function()
								Library._TouchElement(Colorpicker)
							end)
						end
					end)
				end

				Colorpicker._SetAnimScale = function(target, instant)
					if instant or Creator.ReducedMotion then
						Creator.CancelSpring(popoverScale, "Scale")
						animS = target
						syncPopScale()
					else
						Creator.SpringValue(popoverScale, "Scale", target, 10, 0.85, function(v)
							animS = v
							syncPopScale()
						end, animS)
					end
				end
			end

			function Colorpicker.Open(_self)
				if Colorpicker.Opened then
					return
				end
				-- Close other open dropdowns/popovers first
				Library._CloseDropdowns()
				ensurePopover()
				openTransitionId += 1
				Colorpicker.Opened = true
				Library._OpenDropdowns[Colorpicker] = true
				if scrollFrame then
					scrollFrame.ScrollingEnabled = false
				end
				initialSnapshotColor = Colorpicker.Value
				initialSnapshotAlpha = Colorpicker.Transparency
				if previewOld then
					previewOld.BackgroundColor3 = initialSnapshotColor
					previewOld.BackgroundTransparency = initialSnapshotAlpha
				end
				syncPopoverVisuals()
				repositionPopover()
				popoverCanvas.Visible = true

				local function fadePopoverStrokes(toHidden, instant)
					if not popoverCard then return end
					for _, desc in ipairs(popoverCard:GetDescendants()) do
						if desc:IsA("UIStroke") then
							local rest = desc:GetAttribute("AcryvenRestTrans")
							if rest == nil then
								rest = (desc == popoverStroke) and 0.35 or desc.Transparency
								desc:SetAttribute("AcryvenRestTrans", rest)
							end
							local target = toHidden and 1 or rest
							if instant then
								Creator.CancelSpring(desc, "Transparency")
								desc.Transparency = target
							else
								Creator.SpringValue(desc, "Transparency", target, toHidden and 13 or 10, 1)
							end
						end
					end
				end

				if Creator.ReducedMotion then
					popoverCard.GroupTransparency = 0
					if popoverShadow then popoverShadow.ImageTransparency = 0.58 end
					fadePopoverStrokes(false, true)
					Colorpicker._SetAnimScale(1, true)
				else
					popoverCard.GroupTransparency = 1
					if popoverShadow then popoverShadow.ImageTransparency = 1 end
					fadePopoverStrokes(true, true)
					Colorpicker._SetAnimScale(0.92, true)
					Creator.SpringValue(popoverCard, "GroupTransparency", 0, 10, 1)
					fadePopoverStrokes(false, false)
					if popoverShadow then
						Creator.SpringValue(popoverShadow, "ImageTransparency", 0.58, 10, 1)
					end
					Colorpicker._SetAnimScale(1)
				end

				table.insert(openConnections, Creator.AddSignal(swatchButton:GetPropertyChangedSignal("AbsolutePosition"), repositionPopover))
				table.insert(openConnections, Creator.AddSignal(UserInputService.InputBegan, function(input)
					if not Colorpicker.Opened then
						return
					end
					if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Escape then
						Colorpicker:Close()
						return
					end
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						local ix, iy = input.Position.X, input.Position.Y
						local pPos, pSz = popoverCard.AbsolutePosition, popoverCard.AbsoluteSize
						local sPos, sSz = hitAnchorFrame.AbsolutePosition, hitAnchorFrame.AbsoluteSize
						local outPop = ix < pPos.X or ix > pPos.X + pSz.X or iy < pPos.Y or iy > pPos.Y + pSz.Y
						local outRow = ix < sPos.X or ix > sPos.X + sSz.X or iy < sPos.Y or iy > sPos.Y + sSz.Y
						if outPop and outRow then
							Colorpicker:Close()
						end
					end
				end))
			end

			function Colorpicker.Close(_self)
				if not Colorpicker.Opened then
					return
				end
				openTransitionId += 1
				local myTransition = openTransitionId
				Colorpicker.Opened = false
				Library._OpenDropdowns[Colorpicker] = nil
				disconnectWhileOpen()
				if scrollFrame then
					scrollFrame.ScrollingEnabled = true
				end
				if not popoverBuilt or not popoverCanvas then
					return
				end
				if Creator.ReducedMotion then
					popoverCanvas.Visible = false
					return
				end
				Creator.SpringValue(popoverCard, "GroupTransparency", 1, 12, 1)
				for _, desc in ipairs(popoverCard:GetDescendants()) do
					if desc:IsA("UIStroke") then
						Creator.SpringValue(desc, "Transparency", 1, 14, 1)
					end
				end
				if popoverShadow then
					Creator.SpringValue(popoverShadow, "ImageTransparency", 1, 12, 1)
				end
				if Colorpicker._SetAnimScale then
					Colorpicker._SetAnimScale(0.94)
				end
				task.delay(0.16, function()
					if myTransition == openTransitionId and not Colorpicker.Opened and popoverCanvas and popoverCanvas.Parent then
						popoverCanvas.Visible = false
					end
				end)
			end

			function Colorpicker.Display(_self)
				commitColor(false)
			end
			function Colorpicker.SetValue(_self, hsv, transparency)
				local color = Color3.fromHSV(hsv[1], hsv[2], hsv[3])
				if transparency ~= nil then
					Colorpicker.Transparency = transparency
				end
				Colorpicker:SetHSVFromRGB(color)
				Colorpicker:Display()
			end
			function Colorpicker.SetValueRGB(_self, color, transparency)
				if transparency ~= nil then
					Colorpicker.Transparency = transparency
				end
				Colorpicker:SetHSVFromRGB(color)
				Colorpicker:Display()
			end
			function Colorpicker.OnChanged(_self, callback)
				Colorpicker.Changed = callback
				callback(Colorpicker.Value)
			end
			function Colorpicker.Destroy(_self)
				Colorpicker:Close()
				disconnectWhileOpen()
				Library._OpenDropdowns[Colorpicker] = nil
				if popoverCanvas then
					local openIdx = table.find(Library.OpenFrames, popoverCanvas)
					if openIdx then
						table.remove(Library.OpenFrames, openIdx)
					end
					pcall(function()
						popoverCanvas:Destroy()
					end)
					popoverCanvas = nil
				end
				if colorpickerFrame then
					colorpickerFrame:Destroy()
				elseif swatchButton and swatchButton.Parent then
					swatchButton:Destroy()
				end
				if idx ~= nil then
					Library.Options[idx] = nil
				end
			end

			Creator.AddSignal(hitAnchorFrame.MouseButton1Click, function()
				if Colorpicker.Opened then
					Colorpicker:Close()
				else
					Colorpicker:Open()
				end
			end)

			Colorpicker:Display()
			if idx ~= nil then
				Library.Options[idx] = Colorpicker
			end
			return Colorpicker
		end
		return Element
	end,
	[22] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(22)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local TweenService = Creator.GetService("TweenService")
		local UserInputService = Creator.GetService("UserInputService")
		local Players = Creator.GetService("Players")
		local Workspace = Creator.GetService("Workspace")
		local TextService = Creator.GetService("TextService")
		local mouse = Players.LocalPlayer:GetMouse()
		local New, Components, Element = Creator.New, Root.Components, {}
		Element.__index = Element
		Element.__type = "Dropdown"

		local function parseColorCode(text)
			if type(text) ~= "string" then
				return nil, tostring(text)
			end
			local r, g, b, cleanText = text:match("^%[COLOR:(%d+),(%d+),(%d+)%](.+)$")
			if r and g and b and cleanText then
				return Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b)), cleanText
			end
			return nil, text
		end

		function Element.New(parent, idx, config)
			local Library = parent.Library
			local Dropdown = {
				Values = config.Values or {},
				Value = (config.Multi and {}) or config.Default,
				Multi = config.Multi,
				Buttons = {},
				Opened = false,
				Type = "Dropdown",
				SearchText = "",
				Callback = config.Callback or function()
				end
			}
			local dropdownFrame = requireModule(Components.Element)(config.Title, config.Description, parent.Container, false)
			dropdownFrame.TitleLabel.Size = UDim2.new(1, -190, 0, 0)
			dropdownFrame.DescLabel.Size = UDim2.new(1, -190, 0, 0)
			Dropdown.SetTitle = dropdownFrame.SetTitle
			Dropdown.SetDesc = dropdownFrame.SetDesc
			Dropdown.Frame = dropdownFrame.Frame

			local dropdownDisplay =
				New(
					"TextLabel",
					{
						FontFace = Creator.Font(Enum.FontWeight.Medium, Enum.FontStyle.Normal),
						Text = "--",
						I18nSkip = true,
						TextColor3 = Color3.fromRGB(240, 240, 240),
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(1, -34, 0, 16),
						Position = UDim2.new(0, 10, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						TextTruncate = Enum.TextTruncate.AtEnd,
						ThemeTag = {TextColor3 = "Text"}
					}
				)
			local countText = New(
				"TextLabel",
				{
					Name = "Count",
					Text = "0",
					I18nSkip = true,
					FontFace = Creator.Font(Enum.FontWeight.Bold),
					TextSize = 10,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 1
				}
			)
			local countBadge = New(
				"Frame",
				{
					Name = "SelectedBadge",
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.fromOffset(0, 18),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -28, 0.5, 0),
					BackgroundTransparency = 0.08,
					Visible = false,
					ThemeTag = {BackgroundColor3 = "Accent"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(1, 0)}),
					New("UIPadding", {PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}),
					countText
				}
			)
			local dropdownIcon =
				New(
					"ImageLabel",
					{
						Image = parent.Library:GetIcon("chevron-down") or "rbxassetid://134243273101015",
						Size = UDim2.fromOffset(15, 15),
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -9, 0.5, 0),
						BackgroundTransparency = 1,
						ImageTransparency = 0,
						ThemeTag = {ImageColor3 = "SubText"}
					}
				)
			local triggerStroke =
				New(
					"UIStroke",
					{
						Thickness = 1.2,
						Transparency = 0.28,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						ThemeTag = {Color = "InElementBorder"}
					}
				)
			local dropdownInner =
				New(
					"TextButton",
					{
						Size = UDim2.fromOffset(176, 34),
						Position = UDim2.new(1, -10, 0.5, 0),
						AnchorPoint = Vector2.new(1, 0.5),
						BackgroundTransparency = 0.14,
						Text = "",
						ClipsDescendants = true,
						Parent = dropdownFrame.Frame,
						ThemeTag = {BackgroundColor3 = "DialogButton"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 8)}),
						New(
							"UIGradient",
							{
								Rotation = 90,
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
									ColorSequenceKeypoint.new(1, Color3.fromRGB(224, 228, 236))
								})
							}
						),
						triggerStroke,
						countBadge,
						dropdownIcon,
						dropdownDisplay
					}
				)

			local triggerHovered = false
			local function syncTriggerVisual()
				local active = triggerHovered or Dropdown.Opened
				Creator.OverrideTag(triggerStroke, {Color = active and "Accent" or "InElementBorder"})
				Creator.SpringValue(triggerStroke, "Transparency", active and 0.08 or 0.28, 10, 1)
				Creator.OverrideTag(dropdownIcon, {ImageColor3 = active and "Accent" or "SubText"})
				Creator.SpringValue(dropdownInner, "BackgroundTransparency", active and 0.06 or 0.14, 10, 1)
			end
			Creator.AddSignal(dropdownInner.MouseEnter, function()
				triggerHovered = true
				syncTriggerVisual()
			end)
			Creator.AddSignal(dropdownInner.MouseLeave, function()
				triggerHovered = false
				syncTriggerVisual()
			end)

			local function getTextWidth(label, text)
				local ok, size = pcall(function()
					return TextService:GetTextSize(
						text or label.Text,
						label.TextSize,
						Enum.Font.BuilderSans,
						Vector2.new(10000, math.max(label.AbsoluteSize.Y, 34))
					)
				end)
				return ok and size.X or label.TextBounds.X
			end

			local selectedLabelDefaultPosition = UDim2.new(0, 10, 0.5, 0)
			local selectedLabelDefaultSize = UDim2.new(1, -34, 0, 16)
			local selectedLabelScrollTween = nil
			local function stopSelectedLabelScroll()
				if selectedLabelScrollTween then
					selectedLabelScrollTween:Cancel()
					selectedLabelScrollTween = nil
				end
				dropdownDisplay.TextTruncate = Enum.TextTruncate.AtEnd
				dropdownDisplay.Size = UDim2.new(1, countBadge.Visible and -58 or -34, 0, 16)
				dropdownDisplay.Position = selectedLabelDefaultPosition
			end
			local function startSelectedLabelScroll()
				local scale = Creator.GetEffectiveScale(dropdownInner)
				local visibleWidth = math.max((dropdownInner.AbsoluteSize.X / scale) - (countBadge.Visible and 58 or 34), 0)
				local textWidth = getTextWidth(dropdownDisplay, dropdownDisplay.Text) + 8
				if textWidth <= visibleWidth then
					return
				end
				stopSelectedLabelScroll()
				dropdownDisplay.TextTruncate = Enum.TextTruncate.None
				dropdownDisplay.Size = UDim2.fromOffset(textWidth, 16)
				local travel = textWidth - visibleWidth
				selectedLabelScrollTween =
					TweenService:Create(
						dropdownDisplay,
						TweenInfo.new(math.clamp(travel / 35, 1.2, 5), Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0.25),
						{Position = UDim2.new(0, 10 - travel, 0.5, 0)}
					)
				selectedLabelScrollTween:Play()
			end

			local function toSelectionSet(value)
				local set = {}
				if type(value) == "table" then
					for key, item in next, value do
						local candidate = item
						if type(item) == "boolean" then
							candidate = item and key or nil
						end
						if candidate ~= nil and table.find(Dropdown.Values, candidate) then
							set[candidate] = true
						end
					end
				end
				return set
			end

			local canClear = config.Multi or config.AllowNull
			local scrollFrame = parent.ScrollFrame

			-- Lazy popup state: none of the popup instances or signals are created until
			-- Dropdown:Open() is invoked for the first time, keeping boot fast and lean.
			local popupBuilt = false
			local dropdownBuilt = false
			local dropdownRows = {}
			local searchRevision = 0
			local listSizeX = 196
			local isClearButtonVisible = false
			local hasSelectionState = false
			local openedUpward = false
			local ddCardYOffset = 0
			local openConnections = {}

			local searchBox, searchBoxStroke, clearButton, clearButtonStroke, clearIcon
			local selectAllButton, dropdownListLayout, dropdownScrollFrame, dropdownHolderFrame, dropdownHolderCanvas, dropdownShadow, emptyStateLabel
			local ddAnimScale, ddHoverStroke

			local function showClearButton(instant)
				if not popupBuilt or not clearButton or isClearButtonVisible then
					return
				end
				isClearButtonVisible = true
				clearButton.Visible = true
				if instant then
					clearButton.Size = UDim2.fromOffset(34, 34)
					clearButton.BackgroundTransparency = 0.9
					clearButton.Rotation = 0
					if clearIcon then clearIcon.ImageTransparency = 0 end
					if clearButtonStroke then clearButtonStroke.Transparency = 0.5 end
					return
				end
				TweenService:Create(
					clearButton,
					TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
					{Size = UDim2.fromOffset(34, 34), BackgroundTransparency = 0.9, Rotation = 0}
				):Play()
				if clearIcon then
					TweenService:Create(clearIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
				end
				if clearButtonStroke then
					TweenService:Create(clearButtonStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0.5}):Play()
				end
			end

			local function hideClearButton(instant)
				if not popupBuilt or not clearButton or not isClearButtonVisible then
					return
				end
				isClearButtonVisible = false
				if instant then
					clearButton.Size = UDim2.fromOffset(0, 0)
					clearButton.BackgroundTransparency = 1
					clearButton.Rotation = -90
					clearButton.Visible = false
					if clearIcon then clearIcon.ImageTransparency = 1 end
					if clearButtonStroke then clearButtonStroke.Transparency = 1 end
					return
				end
				local hideTween = TweenService:Create(
					clearButton,
					TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In),
					{Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1, Rotation = 90}
				)
				if clearIcon then
					TweenService:Create(clearIcon, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()
				end
				if clearButtonStroke then
					TweenService:Create(clearButtonStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1}):Play()
				end
				hideTween:Play()
				hideTween.Completed:Connect(function()
					if not isClearButtonVisible and clearButton and clearButton.Parent then
						clearButton.Visible = false
						clearButton.Rotation = -90
					end
				end)
			end

			local function setCardYOffset(y)
				ddCardYOffset = y
				if dropdownHolderFrame then
					dropdownHolderFrame.Position = UDim2.new(0.5, 0, openedUpward and 1 or 0, y)
				end
			end

			local function recalculateListPosition()
				if not popupBuilt then return end
				local camera = Workspace.CurrentCamera
				local rawViewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
				local insetY = Creator.GetGuiInsetY()
				local usableW = rawViewport.X
				local usableH = math.max(160, rawViewport.Y - insetY)
				local mainFrame = dropdownInner.AbsolutePosition
				local mainSize = dropdownInner.AbsoluteSize
				local scale = math.max(0.01, Creator.DPIScale)
				local panelW = math.max(listSizeX, math.ceil(mainSize.X / scale))
				if dropdownHolderCanvas.Size.X.Offset ~= panelW then
					dropdownHolderCanvas.Size = UDim2.fromOffset(panelW, dropdownHolderCanvas.Size.Y.Offset)
				end
				local dropdownWidth = panelW * scale
				local dropdownHeight = dropdownHolderCanvas.Size.Y.Offset * scale

				-- Luaward GlassSelect placement: bottom end by default, flipping to top end near viewport bottom
				local xPos = mainFrame.X + mainSize.X - dropdownWidth
				xPos = math.clamp(xPos, 10, math.max(10, usableW - dropdownWidth - 10))

				local belowY = mainFrame.Y + mainSize.Y + 6
				local aboveY = mainFrame.Y - dropdownHeight - 6
				local yPos
				if belowY + dropdownHeight <= usableH - 10 or aboveY < 10 then
					openedUpward = false
					yPos = math.clamp(belowY, 10, math.max(10, usableH - dropdownHeight - 10))
				else
					openedUpward = true
					yPos = math.clamp(aboveY, 10, math.max(10, usableH - dropdownHeight - 10))
				end
				if dropdownHolderFrame then
					dropdownHolderFrame.AnchorPoint = Vector2.new(0.5, openedUpward and 1 or 0)
					dropdownHolderFrame.Position = UDim2.new(0.5, 0, openedUpward and 1 or 0, ddCardYOffset)
				end
				dropdownHolderCanvas.Position = UDim2.fromOffset(xPos, yPos)
			end

			local function recalculateListSize()
				if not popupBuilt then return end
				local scale = Creator.GetEffectiveScale(dropdownScrollFrame)
				local maxHeight = 280
				local unscaledContent = math.ceil(dropdownListLayout.AbsoluteContentSize.Y / scale) + 6
				local contentHeight = unscaledContent + (config.Multi and 87 or 54)
				local finalHeight = math.clamp(contentHeight, config.Multi and 122 or 94, maxHeight)
				local dpi = math.max(0.01, Creator.DPIScale)
				local panelW = math.max(listSizeX, math.ceil(dropdownInner.AbsoluteSize.X / dpi))
				dropdownHolderCanvas.Size = UDim2.fromOffset(panelW, finalHeight)
				recalculateListPosition()
			end

			local function recalculateCanvasSize()
				if not popupBuilt then return end
				local scale = Creator.GetEffectiveScale(dropdownScrollFrame)
				dropdownScrollFrame.CanvasSize = UDim2.fromOffset(0, math.ceil(dropdownListLayout.AbsoluteContentSize.Y / scale) + 6)
			end

			local function applySearchFilter()
				if not popupBuilt then return end
				local query = Dropdown.SearchText
				local shownCount = 0
				for _, row in ipairs(dropdownRows) do
					local shown = query == "" or row.SearchTarget:find(query, 1, true) ~= nil
					if shown then
						shownCount += 1
					end
					if row.Button.Visible ~= shown then
						row.Button.Visible = shown
						if not shown then
							row:ResetHover()
						end
					end
				end
				if emptyStateLabel then
					emptyStateLabel.Visible = (shownCount == 0)
				end
				recalculateCanvasSize()
				recalculateListSize()
			end

			local function rebuildDropdown()
				Dropdown:BuildDropdownList()
				dropdownBuilt = true
			end

			local function closeOnOutsideInput(input)
				if not Dropdown.Opened or not popupBuilt then
					return
				end
				if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Escape then
					Dropdown:Close()
					return
				end
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					local ix, iy = input.Position.X, input.Position.Y
					local holderPos, holderSize = dropdownHolderFrame.AbsolutePosition, dropdownHolderFrame.AbsoluteSize
					local innerPos, innerSize = dropdownInner.AbsolutePosition, dropdownInner.AbsoluteSize
					local outsideDropdown = ix < holderPos.X or ix > holderPos.X + holderSize.X or iy < holderPos.Y or iy > holderPos.Y + holderSize.Y
					local outsideButton = ix < innerPos.X or ix > innerPos.X + innerSize.X or iy < innerPos.Y or iy > innerPos.Y + innerSize.Y
					if outsideDropdown and outsideButton then
						Dropdown:Close()
					end
				end
			end

			local function connectWhileOpen()
				table.insert(openConnections, Creator.AddSignal(dropdownInner:GetPropertyChangedSignal("AbsolutePosition"), recalculateListPosition))
				table.insert(openConnections, Creator.AddSignal(UserInputService.InputBegan, closeOnOutsideInput))
				table.insert(openConnections, Creator.AddSignal(dropdownListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
					recalculateCanvasSize()
					recalculateListSize()
				end))
			end

			local function disconnectWhileOpen()
				for index = #openConnections, 1, -1 do
					openConnections[index]:Disconnect()
					openConnections[index] = nil
				end
			end

			local function ensurePopup()
				if popupBuilt then
					return
				end
				popupBuilt = true

				local searchIconAsset = Library:GetIcon("search") or "rbxassetid://10734943674"
				local clearIconAsset = Library:GetIcon("x") or "rbxassetid://10747384394"
				local selectAllIconAsset = Library:GetIcon("check-square") or Library:GetIcon("check") or "rbxassetid://10709790644"

				searchBoxStroke = New(
					"UIStroke",
					{
						Transparency = 0.38,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						ThemeTag = {Color = "InElementBorder"}
					}
				)

				searchBox = New(
					"TextBox",
					{
						Size = UDim2.new(1, canClear and -50 or -10, 0, 34),
						Position = UDim2.fromOffset(5, 5),
						BackgroundTransparency = 0.12,
						PlaceholderText = "Search...",
						Text = "",
						TextColor3 = Color3.fromRGB(240, 240, 240),
						PlaceholderColor3 = Color3.fromRGB(168, 178, 198),
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Left,
						FontFace = Creator.Font(Enum.FontWeight.Medium),
						ThemeTag = {BackgroundColor3 = "DialogHolder", TextColor3 = "Text"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 8)}),
						New("UIPadding", {PaddingLeft = UDim.new(0, 28), PaddingRight = UDim.new(0, 8)}),
						New(
							"ImageLabel",
							{
								Name = "SearchIcon",
								Image = searchIconAsset,
								Size = UDim2.fromOffset(15, 15),
								Position = UDim2.new(0, -19, 0.5, 0),
								AnchorPoint = Vector2.new(0, 0.5),
								BackgroundTransparency = 1,
								ImageTransparency = 0,
								ThemeTag = {ImageColor3 = "SubText"}
							}
						),
						searchBoxStroke
					}
				)
				TranslationSystem:Register(searchBox, "Search...", "PlaceholderText")

				clearIcon = New(
					"ImageLabel",
					{
						Name = "ClearIcon",
						Image = clearIconAsset,
						Size = UDim2.fromOffset(15, 15),
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						ImageColor3 = Color3.fromRGB(255, 92, 92),
						ImageTransparency = 1
					}
				)

				clearButtonStroke = New(
					"UIStroke",
					{
						Transparency = 1,
						Color = Color3.fromRGB(255, 80, 80),
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					}
				)

				clearButton = New(
					"TextButton",
					{
						Size = UDim2.fromOffset(0, 0),
						Position = UDim2.new(1, -22, 0, 22),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Text = "",
						Visible = false,
						ThemeTag = {BackgroundColor3 = "DialogButton"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 8)}),
						clearButtonStroke,
						clearIcon
					}
				)

				if config.Multi then
					local selectAllLabel = New(
						"TextLabel",
						{
							Name = "Title",
							Text = "Select All",
							TextSize = 12,
							FontFace = Creator.Font(Enum.FontWeight.Medium),
							BackgroundTransparency = 1,
							AutomaticSize = Enum.AutomaticSize.X,
							Size = UDim2.new(0, 0, 1, 0),
							LayoutOrder = 2,
							ThemeTag = {TextColor3 = "Accent"}
						}
					)
					selectAllButton = New(
						"TextButton",
						{
							Size = UDim2.new(1, -10, 0, 28),
							Position = UDim2.fromOffset(5, 44),
							BackgroundTransparency = 0.9,
							Text = "",
							ThemeTag = {BackgroundColor3 = "DialogButton"}
						},
						{
							New("UICorner", {CornerRadius = UDim.new(0, 8)}),
							New(
								"UIStroke",
								{
									Transparency = 0.5,
									ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
									ThemeTag = {Color = "Accent"}
								}
							),
							New(
								"Frame",
								{Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1},
								{
									New("UIListLayout", {
										FillDirection = Enum.FillDirection.Horizontal,
										HorizontalAlignment = Enum.HorizontalAlignment.Center,
										VerticalAlignment = Enum.VerticalAlignment.Center,
										Padding = UDim.new(0, 6),
										SortOrder = Enum.SortOrder.LayoutOrder
									}),
									New(
										"ImageLabel",
										{
											Image = selectAllIconAsset,
											Size = UDim2.fromOffset(14, 14),
											BackgroundTransparency = 1,
											LayoutOrder = 1,
											ThemeTag = {ImageColor3 = "Accent"}
										}
									),
									selectAllLabel
								}
							)
						}
					)
				end

				dropdownListLayout = New("UIListLayout", {Padding = UDim.new(0, 4)})
				local scrollYPos = config.Multi and 77 or 44
				local scrollYSize = config.Multi and -82 or -49

				dropdownScrollFrame = New(
					"ScrollingFrame",
					{
						Size = UDim2.new(1, -10, 1, scrollYSize),
						Position = UDim2.fromOffset(5, scrollYPos),
						BackgroundTransparency = 1,
						BottomImage = "rbxassetid://6889812791",
						MidImage = "rbxassetid://6889812721",
						TopImage = "rbxassetid://6276641225",
						ScrollBarImageTransparency = 0.92,
						ScrollBarThickness = 5,
						BorderSizePixel = 0,
						ZIndex = 37,
						CanvasSize = UDim2.fromScale(0, 0),
						ThemeTag = {ScrollBarImageColor3 = "Accent"}
					},
					{
						dropdownListLayout,
						New(
							"UIPadding",
							{
								PaddingTop = UDim.new(0, 2),
								PaddingBottom = UDim.new(0, 4),
								PaddingLeft = UDim.new(0, 2),
								PaddingRight = UDim.new(0, 2)
							}
						)
					}
				)

				ddHoverStroke = New(
					"UIStroke",
					{
						Transparency = 1,
						Thickness = 1,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						ThemeTag = {Color = "InElementBorder"}
					}
				)
				local ddHoverPill = New(
					"Frame",
					{
						Name = "DropdownHoverPill",
						Size = UDim2.new(1, -14, 0, 34),
						Position = UDim2.fromOffset(2, 0),
						BackgroundTransparency = 1,
						ZIndex = 36,
						ThemeTag = {BackgroundColor3 = "DropdownOption"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 7)}),
						ddHoverStroke
					}
				)
				local ddHoverLayer = New(
					"Frame",
					{
						Name = "HoverLayer",
						Size = UDim2.new(1, -10, 1, scrollYSize),
						Position = UDim2.fromOffset(5, scrollYPos),
						BackgroundTransparency = 1,
						ClipsDescendants = true,
						ZIndex = 36
					},
					{ddHoverPill}
				)
				Dropdown._HoverPill = ddHoverPill
				Dropdown._HoverStroke = ddHoverStroke
				Dropdown._HoverVisible = false
				Dropdown._HoverY = 0
				Creator.AddSignal(dropdownScrollFrame.MouseLeave, function()
					Dropdown._HoverVisible = false
					Creator.SpringValue(ddHoverPill, "BackgroundTransparency", 1, 5.5, 1)
					Creator.SpringValue(ddHoverStroke, "Transparency", 1, 5.5, 1)
				end)

				emptyStateLabel = New(
					"TextLabel",
					{
						Name = "EmptyState",
						Text = "No matching options",
						FontFace = Creator.Font(Enum.FontWeight.Medium),
						TextSize = 12,
						Size = UDim2.new(1, -16, 0, 32),
						Position = UDim2.new(0.5, 0, 0.5, math.floor(scrollYPos * 0.45)),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Visible = false,
						ZIndex = 38,
						ThemeTag = {TextColor3 = "SubText"}
					}
				)

				local uChildren = {
					searchBox,
					clearButton,
					ddHoverLayer,
					dropdownScrollFrame,
					emptyStateLabel,
					New("UICorner", {CornerRadius = UDim.new(0, 10)}),
					New(
						"UIGradient",
						{
							Rotation = 90,
							Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
								ColorSequenceKeypoint.new(1, Color3.fromRGB(234, 238, 246))
							})
						}
					),
					New(
						"UIStroke",
						{
							Thickness = 1.2,
							Transparency = 0.18,
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							ThemeTag = {Color = "DropdownBorder"}
						}
					)
				}
				if config.Multi and selectAllButton then
					table.insert(uChildren, selectAllButton)
				end

				ddAnimScale = New("UIScale", {Scale = 1})
				table.insert(uChildren, ddAnimScale)
				dropdownHolderFrame = New(
					"Frame",
					{
						Size = UDim2.fromScale(1, 1),
						AnchorPoint = Vector2.new(0.5, 0),
						Position = UDim2.fromScale(0.5, 0),
						ClipsDescendants = true,
						Active = true,
						BackgroundTransparency = 0.03,
						ZIndex = 36,
						ThemeTag = {BackgroundColor3 = "DropdownHolder"}
					},
					uChildren
				)

				local ddScale = New("UIScale", {Scale = Creator.DPIScale})
				Creator.RegisterDPIScale(ddScale, function(scale)
					ddScale.Scale = scale
					if Dropdown.Opened then
						task.defer(function()
							recalculateCanvasSize()
							recalculateListSize()
						end)
					end
				end)
				dropdownShadow = New(
					"ImageLabel",
					{
						BackgroundTransparency = 1,
						Image = "rbxassetid://5554236805",
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(23, 23, 277, 277),
						Size = UDim2.new(1, 24, 1, 24),
						Position = UDim2.fromOffset(-12, -10),
						ImageColor3 = Color3.fromRGB(0, 0, 0),
						ImageTransparency = 1,
						ZIndex = 35
					}
				)
				dropdownHolderCanvas = New(
					"Frame",
					{
						Name = "AcryvenDropdownPopup",
						BackgroundTransparency = 1,
						Size = UDim2.fromOffset(listSizeX, 250),
						Parent = parent.Library.OverlayGUI or parent.Library.GUI,
						ZIndex = 35,
						Visible = false
					},
					{
						ddScale,
						dropdownShadow,
						dropdownHolderFrame
					}
				)
				table.insert(Library.OpenFrames, dropdownHolderCanvas)

				-- Search box focus & debounced filter
				Creator.AddSignal(searchBox.Focused, function()
					Creator.OverrideTag(searchBoxStroke, {Color = "Accent"})
					TweenService:Create(searchBoxStroke, TweenInfo.new(0.2), {Transparency = 0.12}):Play()
				end)
				Creator.AddSignal(searchBox.FocusLost, function()
					Creator.OverrideTag(searchBoxStroke, {Color = "InElementBorder"})
					TweenService:Create(searchBoxStroke, TweenInfo.new(0.2), {Transparency = 0.38}):Play()
				end)
				Creator.AddSignal(searchBox:GetPropertyChangedSignal("Text"), function()
					searchRevision = searchRevision + 1
					local revision = searchRevision
					task.defer(function()
						if revision ~= searchRevision then
							return
						end
						Dropdown.SearchText = searchBox.Text:lower()
						dropdownScrollFrame.CanvasPosition = Vector2.new(0, 0)
						if dropdownBuilt then
							applySearchFilter()
						elseif Dropdown.Opened then
							rebuildDropdown()
						end
					end)
				end)

				-- Clear button hover & click
				Creator.AddSignal(clearButton.MouseEnter, function()
					Creator.SpringValue(clearButton, "BackgroundTransparency", 0.8, 8, 1)
					TweenService:Create(clearButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(38, 38)}):Play()
				end)
				Creator.AddSignal(clearButton.MouseLeave, function()
					Creator.SpringValue(clearButton, "BackgroundTransparency", 0.9, 8, 1)
					TweenService:Create(clearButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(34, 34)}):Play()
				end)
				Creator.AddSignal(clearButton.MouseButton1Click, function()
					if not canClear then
						return
					end
					local bounceSequence = TweenService:Create(clearButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(30, 30)})
					bounceSequence:Play()
					bounceSequence.Completed:Connect(function()
						if clearButton and clearButton.Parent then
							TweenService:Create(clearButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(34, 34)}):Play()
						end
					end)
					if config.Multi then
						Dropdown.Value = {}
					else
						Dropdown.Value = nil
					end
					for _, buttonData in pairs(Dropdown.Buttons) do
						buttonData:UpdateButton()
					end
					Dropdown:Display()
					Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
					Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
					Library._TouchElement(Dropdown)
				end)

				-- Select All button
				if config.Multi and selectAllButton then
					Creator.AddSignal(selectAllButton.MouseEnter, function()
						Creator.SpringValue(selectAllButton, "BackgroundTransparency", 0.85, 8, 1)
					end)
					Creator.AddSignal(selectAllButton.MouseLeave, function()
						Creator.SpringValue(selectAllButton, "BackgroundTransparency", 0.9, 8, 1)
					end)
					Creator.AddSignal(selectAllButton.MouseButton1Click, function()
						for _, value in pairs(Dropdown.Values) do
							local _, cleanText = parseColorCode(value)
							if Dropdown.SearchText == "" or cleanText:lower():find(Dropdown.SearchText, 1, true) then
								Dropdown.Value[value] = true
							end
						end
						for _, buttonData in pairs(Dropdown.Buttons) do
							buttonData:UpdateButton()
						end
						Dropdown:Display()
						Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
						Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
						Library._TouchElement(Dropdown)
					end)
				end

				if hasSelectionState and canClear then
					showClearButton(true)
				end
			end

			-- Main trigger interactions
			Creator.AddSignal(dropdownInner.MouseEnter, startSelectedLabelScroll)
			Creator.AddSignal(dropdownInner.MouseLeave, stopSelectedLabelScroll)
			Creator.AddSignal(dropdownInner.MouseButton1Click, function()
				if Dropdown.Opened then
					Dropdown:Close()
				else
					Dropdown:Open()
				end
			end)

			local ddTransitionId = 0
			local selectCloseGen = 0
			function Dropdown.Open(_self)
				if Dropdown.Opened then
					return
				end
				-- Close other open dropdowns or colorpicker popovers so popups never stack.
				Library._CloseDropdowns()
				ensurePopup()
				ddTransitionId += 1
				Dropdown.Opened = true
				syncTriggerVisual()
				Library._OpenDropdowns[Dropdown] = true
				connectWhileOpen()
				if scrollFrame then
					scrollFrame.ScrollingEnabled = false
				end
				dropdownHolderCanvas.Visible = true
				searchBox.Text = ""
				Dropdown.SearchText = ""
				dropdownScrollFrame.CanvasPosition = Vector2.new(0, 0)
				if not dropdownBuilt then
					rebuildDropdown()
				else
					applySearchFilter()
				end
				recalculateListSize()
				recalculateListPosition()

				Creator.SpringValue(dropdownIcon, "Rotation", 180, 4.6, 0.85)
				Dropdown._HoverVisible = false
				if Dropdown._HoverPill then
					Creator.CancelSpring(Dropdown._HoverPill, "BackgroundTransparency")
					Dropdown._HoverPill.BackgroundTransparency = 1
				end
				if Dropdown._HoverStroke then
					Creator.CancelSpring(Dropdown._HoverStroke, "Transparency")
					Dropdown._HoverStroke.Transparency = 1
				end

				if Creator.ReducedMotion then
					if ddAnimScale then ddAnimScale.Scale = 1 end
					setCardYOffset(0)
					if dropdownShadow then dropdownShadow.ImageTransparency = 0.52 end
				else
					-- HeroUI / Luaward Select Popover entrance: subtle scale + directional slide (never squishes height)
					local startY = openedUpward and 6 or -6
					if ddAnimScale then
						Creator.CancelSpring(ddAnimScale, "Scale")
						ddAnimScale.Scale = 0.94
						Creator.SpringValue(ddAnimScale, "Scale", 1, 5.0, 0.86)
					end
					setCardYOffset(startY)
					Creator.SpringValue(dropdownHolderFrame, "CardY", 0, 5.0, 0.88, setCardYOffset, startY)
					if dropdownShadow then
						dropdownShadow.ImageTransparency = 1
						Creator.SpringValue(dropdownShadow, "ImageTransparency", 0.52, 5.4, 1)
					end
				end
			end

			function Dropdown.Close(_self)
				if not Dropdown.Opened then
					return
				end
				ddTransitionId += 1
				local myTransition = ddTransitionId
				Dropdown.Opened = false
				syncTriggerVisual()
				Library._OpenDropdowns[Dropdown] = nil
				disconnectWhileOpen()
				if scrollFrame then
					scrollFrame.ScrollingEnabled = true
				end
				Creator.SpringValue(dropdownIcon, "Rotation", 0, 4.6, 0.85)
				if not popupBuilt then
					return
				end
				Dropdown._HoverVisible = false
				if Dropdown._HoverPill then
					Creator.SpringValue(Dropdown._HoverPill, "BackgroundTransparency", 1, 6.2, 1)
				end
				if Dropdown._HoverStroke then
					Creator.SpringValue(Dropdown._HoverStroke, "Transparency", 1, 6.2, 1)
				end
				if Creator.ReducedMotion then
					dropdownHolderCanvas.Visible = false
					return
				end
				if dropdownShadow then
					Creator.SpringValue(dropdownShadow, "ImageTransparency", 1, 6.8, 1)
				end
				if ddAnimScale then
					Creator.SpringValue(ddAnimScale, "Scale", 0.95, 6.4, 1)
				end
				Creator.SpringValue(dropdownHolderFrame, "CardY", openedUpward and 4 or -4, 6.4, 1, setCardYOffset, ddCardYOffset)
				task.delay(0.14, function()
					if myTransition == ddTransitionId and not Dropdown.Opened and dropdownHolderCanvas and dropdownHolderCanvas.Parent then
						dropdownHolderCanvas.Visible = false
					end
				end)
			end

			function Dropdown.Display(_self)
				local values, text = Dropdown.Values, ""
				local hasSelection = false
				local multiCount = 0
				if config.Multi then
					local parts = {}
					for _, value in next, values do
						if Dropdown.Value[value] then
							local _, cleanText = parseColorCode(value)
							table.insert(parts, cleanText)
							hasSelection = true
							multiCount += 1
						end
					end
					text = table.concat(parts, ", ")
				else
					local displayText = Dropdown.Value or ""
					if displayText ~= "" then
						local _, cleanText = parseColorCode(displayText)
						displayText = cleanText
					end
					text = displayText
					hasSelection = Dropdown.Value ~= nil and Dropdown.Value ~= ""
				end
				if config.Multi and multiCount > 0 then
					countText.Text = tostring(multiCount)
					countText.TextColor3 = Creator.AutoContrast(Creator.GetThemeProperty("Accent"))
					countBadge.Visible = true
				else
					countBadge.Visible = false
				end
				hasSelectionState = hasSelection
				stopSelectedLabelScroll()
				dropdownDisplay.Text = (text == "" and "--" or text)

				if popupBuilt then
					if hasSelection and canClear then
						showClearButton(false)
					else
						hideClearButton(false)
					end
				end
			end

			function Dropdown.GetActiveValues(_self)
				if config.Multi then
					local active = {}
					for value, _ in next, Dropdown.Value do
						table.insert(active, value)
					end
					return active
				else
					return Dropdown.Value and 1 or 0
				end
			end

			function Dropdown.BuildDropdownList(_self)
				ensurePopup()
				local values, buttons = Dropdown.Values, {}
				for _, child in next, dropdownScrollFrame:GetChildren() do
					if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
						child:Destroy()
					end
				end
				Dropdown.Buttons = {}
				dropdownRows = {}
				local checkIconAsset = Library:GetIcon("check") or ""
				local accentContrast = Creator.AutoContrast(Creator.GetThemeProperty("Accent"))

				for _, value in next, values do
					local customColor, cleanText = parseColorCode(value)
					local row = {}

					local bgColor = Color3.fromRGB(255, 255, 255)
					local bgTransparency = 1
					if customColor then
						local r, g, b = customColor.R * 255, customColor.G * 255, customColor.B * 255
						bgColor = Color3.fromRGB(
							math.floor(r * 0.6 + 15),
							math.floor(g * 0.6 + 15),
							math.floor(b * 0.6 + 15)
						)
						bgTransparency = 0.65
					end

					local selected = config.Multi and (Dropdown.Value[value] == true) or (Dropdown.Value == value)
					local defaultTransparency = customColor and bgTransparency or 1
					local hoverTransparency = customColor and math.max(bgTransparency - 0.2, 0.3) or 0.92
					local selectedTransparency = customColor and math.max(bgTransparency - 0.3, 0.2) or 0.80

					local buttonSelector = New(
						"Frame",
						{
							Size = UDim2.fromOffset(3, selected and 18 or 6),
							BackgroundColor3 = Color3.fromRGB(76, 194, 255),
							BackgroundTransparency = selected and 0 or 1,
							Position = UDim2.fromOffset(5, 17),
							AnchorPoint = Vector2.new(0, 0.5),
							ZIndex = 39,
							ThemeTag = {BackgroundColor3 = "Accent"}
						},
						{New("UICorner", {CornerRadius = UDim.new(1, 0)})}
					)

					local checkIcon = New(
						"ImageLabel",
						{
							Name = "Check",
							Image = checkIconAsset,
							Size = UDim2.fromOffset(11, 11),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.fromScale(0.5, 0.5),
							BackgroundTransparency = 1,
							ImageTransparency = selected and 0 or 1,
							ImageColor3 = accentContrast,
							ZIndex = 40
						}
					)
					local checkScale = New("UIScale", {Scale = selected and 1 or 0.35})
					local checkBadge = New(
						"Frame",
						{
							Name = "CheckBadge",
							Size = UDim2.fromOffset(18, 18),
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -10, 0.5, 0),
							BackgroundTransparency = selected and 0.04 or 1,
							Visible = selected,
							ZIndex = 39,
							ThemeTag = {BackgroundColor3 = "Accent"}
						},
						{
							checkScale,
							New("UICorner", {CornerRadius = UDim.new(1, 0)}),
							checkIcon
						}
					)
					Creator.AddSignal(checkBadge:GetPropertyChangedSignal("BackgroundColor3"), function()
						checkIcon.ImageColor3 = Creator.AutoContrast(checkBadge.BackgroundColor3)
					end)

					local buttonLabel = New(
						"TextLabel",
						{
							FontFace = Creator.Font(selected and Enum.FontWeight.SemiBold or Enum.FontWeight.Medium, Enum.FontStyle.Normal),
							Text = cleanText,
							I18nSkip = true,
							TextSize = 13,
							TextXAlignment = Enum.TextXAlignment.Left,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							Size = UDim2.fromScale(1, 1),
							Position = UDim2.fromOffset(0, 0),
							Name = "ButtonLabel",
							TextTruncate = Enum.TextTruncate.AtEnd,
							TextColor3 = Color3.fromRGB(255, 255, 255),
							ZIndex = 39,
							ThemeTag = {TextColor3 = "Text"}
						}
					)

					local labelClip = New(
						"Frame",
						{
							Size = UDim2.new(1, -44, 1, 0),
							Position = UDim2.fromOffset(14, 0),
							BackgroundTransparency = 1,
							ClipsDescendants = true
						},
						{buttonLabel}
					)

					local rowStroke = New(
						"UIStroke",
						{
							Thickness = 1.2,
							Transparency = selected and 0.24 or 1,
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							ThemeTag = {Color = selected and "Accent" or "InElementBorder"}
						}
					)

					local rowScale = New("UIScale", {Scale = 1})
					local button = New(
						"TextButton",
						{
							Size = UDim2.new(1, -10, 0, 34),
							BackgroundColor3 = bgColor,
							BackgroundTransparency = selected and selectedTransparency or defaultTransparency,
							ClipsDescendants = true,
							ZIndex = 38,
							Text = "",
							Parent = dropdownScrollFrame,
							ThemeTag = customColor and {} or {BackgroundColor3 = selected and "Accent" or "DropdownOption"}
						},
						{
							rowScale,
							buttonSelector,
							labelClip,
							checkBadge,
							New("UICorner", {CornerRadius = UDim.new(0, 7)}),
							rowStroke
						}
					)

					local labelDefaultPosition = UDim2.fromOffset(0, 0)
					local labelDefaultSize = UDim2.fromScale(1, 1)
					local labelScrollTween = nil
					local function stopLabelScroll()
						if labelScrollTween then
							labelScrollTween:Cancel()
							labelScrollTween = nil
						end
						buttonLabel.TextTruncate = Enum.TextTruncate.AtEnd
						buttonLabel.Size = labelDefaultSize
						buttonLabel.Position = labelDefaultPosition
					end
					local function startLabelScroll()
						local scale = Creator.GetEffectiveScale(labelClip)
						local visibleWidth = math.max(labelClip.AbsoluteSize.X / scale, 0)
						local textWidth = getTextWidth(buttonLabel, cleanText) + 6
						if textWidth <= visibleWidth then
							return
						end
						stopLabelScroll()
						buttonLabel.TextTruncate = Enum.TextTruncate.None
						buttonLabel.Size = UDim2.fromOffset(textWidth, math.ceil(button.AbsoluteSize.Y / scale))
						local travel = textWidth - visibleWidth
						labelScrollTween = TweenService:Create(
							buttonLabel,
							TweenInfo.new(math.clamp(travel / 35, 1.2, 5), Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0.25),
							{Position = UDim2.fromOffset(-travel, 0)}
						)
						labelScrollTween:Play()
					end

					local hovered = false
					button.MouseEnter:Connect(function()
						hovered = true
						if Dropdown._HoverPill and dropdownScrollFrame then
							local scale = Creator.GetEffectiveScale(dropdownScrollFrame)
							local targetY = (button.AbsolutePosition.Y - dropdownScrollFrame.AbsolutePosition.Y) / scale
							if not Dropdown._HoverVisible then
								Dropdown._HoverVisible = true
								Creator.CancelSpring(Dropdown._HoverPill, "HoverY")
								Dropdown._HoverY = targetY
								Dropdown._HoverPill.Position = UDim2.fromOffset(2, targetY)
							else
								Creator.SpringValue(Dropdown._HoverPill, "HoverY", targetY, 5.2, 0.88, function(y)
									Dropdown._HoverY = y
									Dropdown._HoverPill.Position = UDim2.fromOffset(2, y)
								end, Dropdown._HoverY)
							end
							Creator.SpringValue(Dropdown._HoverPill, "BackgroundTransparency", 0.74, 5.5, 1)
							if Dropdown._HoverStroke then
								Creator.SpringValue(Dropdown._HoverStroke, "Transparency", 0.52, 5.5, 1)
							end
						end
						Creator.SpringValue(button, "BackgroundTransparency", selected and selectedTransparency or hoverTransparency, 5.2, 1)
						startLabelScroll()
					end)
					button.MouseLeave:Connect(function()
						hovered = false
						Creator.SpringValue(rowScale, "Scale", 1, 6.0, 0.85)
						Creator.SpringValue(button, "BackgroundTransparency", selected and selectedTransparency or defaultTransparency, 5.2, 1)
						stopLabelScroll()
					end)
					button.MouseButton1Down:Connect(function()
						Creator.SpringValue(rowScale, "Scale", 0.98, 6.5, 0.9)
						Creator.SpringValue(button, "BackgroundTransparency", customColor and 0.3 or 0.92, 5.5, 1)
					end)
					button.MouseButton1Up:Connect(function()
						Creator.SpringValue(rowScale, "Scale", 1, 5.5, 0.8)
						Creator.SpringValue(button, "BackgroundTransparency", selected and selectedTransparency or hoverTransparency, 5.5, 1)
					end)

					function row.ResetHover(_self)
						if not hovered then return end
						hovered = false
						Creator.SpringValue(rowScale, "Scale", 1, 6.0, 0.85)
						Creator.SpringValue(button, "BackgroundTransparency", selected and selectedTransparency or defaultTransparency, 5.2, 1)
						stopLabelScroll()
					end

					local wasSelected = selected
					local selectorHeight = selected and 18 or 6
					local checkAnimGen = 0
					function row.UpdateButton(_self)
						if config.Multi then
							selected = Dropdown.Value[value] == true
						else
							selected = Dropdown.Value == value
						end
						if not customColor then
							Creator.OverrideTag(button, {BackgroundColor3 = selected and "Accent" or "DropdownOption"})
						end
						Creator.OverrideTag(rowStroke, {Color = selected and "Accent" or "InElementBorder"})
						Creator.SpringValue(rowStroke, "Transparency", selected and 0.24 or 1, 5.2, 1)
						if selected ~= wasSelected then
							checkAnimGen += 1
							local myAnim = checkAnimGen
							if Creator.ReducedMotion then
								Creator.CancelSpring(checkScale, "Scale")
								checkScale.Scale = selected and 1 or 0.38
								checkBadge.BackgroundTransparency = selected and 0.04 or 1
								checkIcon.ImageTransparency = selected and 0 or 1
								checkBadge.Visible = selected
							elseif selected then
								checkBadge.Visible = true
								checkScale.Scale = 0.38
								Creator.SpringValue(checkScale, "Scale", 1, 4.6, 0.62)
								Creator.SpringValue(checkBadge, "BackgroundTransparency", 0.04, 5.2, 1)
								Creator.SpringValue(checkIcon, "ImageTransparency", 0, 5.2, 1)
							else
								Creator.SpringValue(checkScale, "Scale", 0.38, 5.8, 1)
								Creator.SpringValue(checkBadge, "BackgroundTransparency", 1, 5.8, 1)
								Creator.SpringValue(checkIcon, "ImageTransparency", 1, 5.8, 1)
								task.delay(0.17, function()
									if myAnim == checkAnimGen and not selected and checkBadge and checkBadge.Parent then
										checkBadge.Visible = false
									end
								end)
							end
							wasSelected = selected
						end
						buttonLabel.FontFace = Creator.Font(selected and Enum.FontWeight.SemiBold or Enum.FontWeight.Medium, Enum.FontStyle.Normal)
						Creator.SpringValue(button, "BackgroundTransparency", selected and selectedTransparency or (hovered and hoverTransparency or defaultTransparency), 5.2, 1)
						Creator.SpringValue(buttonSelector, "BackgroundTransparency", selected and 0 or 1, 5.2, 1)
						local targetHeight = selected and 18 or 6
						if targetHeight ~= selectorHeight then
							selectorHeight = targetHeight
							Creator.SpringValue(buttonSelector, "Size", targetHeight, 5.0, 0.82, function(h)
								buttonSelector.Size = UDim2.fromOffset(3, h)
							end, buttonSelector.Size.Y.Offset)
						end
					end

					local canvasAtPress = nil
					local function recordPress(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							canvasAtPress = dropdownScrollFrame.CanvasPosition
						end
					end
					button.InputBegan:Connect(recordPress)
					buttonLabel.InputBegan:Connect(recordPress)
					button.Activated:Connect(function()
						local pressedAt = canvasAtPress
						canvasAtPress = nil
						local scrolled = pressedAt ~= nil and (dropdownScrollFrame.CanvasPosition - pressedAt).Magnitude > 4
						if not scrolled then
							local newSelected = not selected
							if Dropdown:GetActiveValues() == 1 and not newSelected and not config.AllowNull then
								return
							end
							if config.Multi then
								selected = newSelected
								Dropdown.Value[value] = selected and true or nil
							else
								selected = newSelected
								Dropdown.Value = selected and value or nil
								for _, otherRow in next, buttons do
									if otherRow ~= row then
										otherRow:UpdateButton()
									end
								end
							end
							row:UpdateButton()
							Dropdown:Display()
							Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
							Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
							Library._TouchElement(Dropdown)
							if not config.Multi and config.CloseOnSelect ~= false then
								selectCloseGen += 1
								local myGen = selectCloseGen
								local myOpenId = ddTransitionId
								task.delay(Creator.ReducedMotion and 0 or 0.18, function()
									if myGen == selectCloseGen and myOpenId == ddTransitionId and Dropdown.Opened then
										Dropdown:Close()
									end
								end)
							end
						end
					end)

					row.Button = button
					row.SearchTarget = cleanText:lower()
					table.insert(dropdownRows, row)
					buttons[button] = row
					Dropdown.Buttons[button] = row
				end
				Dropdown:Display()
				applySearchFilter()
			end

			function Dropdown.SetValues(_self, values)
				if values then
					Dropdown.Values = values
				end
				if popupBuilt and dropdownScrollFrame then
					dropdownScrollFrame.CanvasPosition = Vector2.new(0, 0)
				end
				dropdownBuilt = false
				if Dropdown.Opened then
					rebuildDropdown()
				end
				Dropdown:Display()
			end

			function Dropdown.OnChanged(_self, callback)
				Dropdown.Changed = callback
				callback(Dropdown.Value)
			end

			function Dropdown.SetValue(_self, value, silent)
				if Dropdown.Multi then
					Dropdown.Value = toSelectionSet(value)
				else
					if not value then
						Dropdown.Value = nil
					elseif table.find(Dropdown.Values, value) then
						Dropdown.Value = value
					end
				end
				-- Update existing rows in place instead of destroying and rebuilding all rows.
				if popupBuilt and dropdownBuilt then
					for _, buttonData in pairs(Dropdown.Buttons) do
						buttonData:UpdateButton()
					end
				end
				Dropdown:Display()
				if not silent then
					Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
					Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
				end
			end

			function Dropdown.Destroy(_self)
				Dropdown:Close()
				disconnectWhileOpen()
				Library._OpenDropdowns[Dropdown] = nil
				if dropdownHolderCanvas then
					local openIdx = table.find(Library.OpenFrames, dropdownHolderCanvas)
					if openIdx then
						table.remove(Library.OpenFrames, openIdx)
					end
					pcall(function()
						dropdownHolderCanvas:Destroy()
					end)
					dropdownHolderCanvas = nil
				end
				dropdownFrame:Destroy()
				Library.Options[idx] = nil
			end

			-- Resolve initial defaults BEFORE calling Display() once.
			local defaultIndexes = {}
			if type(config.Default) == "string" then
				local index = table.find(Dropdown.Values, config.Default)
				if index then
					table.insert(defaultIndexes, index)
				end
			elseif type(config.Default) == "table" then
				for key, defaultValue in next, config.Default do
					local item = defaultValue
					if type(defaultValue) == "boolean" then
						item = defaultValue and key or nil
					end
					local index = item ~= nil and table.find(Dropdown.Values, item)
					if index then
						table.insert(defaultIndexes, index)
					end
				end
			elseif type(config.Default) == "number" and Dropdown.Values[config.Default] ~= nil then
				table.insert(defaultIndexes, config.Default)
			end
			if next(defaultIndexes) then
				for i = 1, #defaultIndexes do
					local valueIndex = defaultIndexes[i]
					if config.Multi then
						Dropdown.Value[Dropdown.Values[valueIndex]] = true
					else
						Dropdown.Value = Dropdown.Values[valueIndex]
					end
					if not config.Multi then
						break
					end
				end
			end
			Dropdown:Display()
			Library.Options[idx] = Dropdown
			return Dropdown
		end
		return Element
	end,
	[23] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(23)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local New, AddSignal, Components, Element = Creator.New, Creator.AddSignal, Root.Components, {}
		Element.__index = Element
		Element.__type = "Input"
		function Element.New(parent, idx, config)
			local Library = parent.Library
			assert(config.Title, "Input - Missing Title")
			config.Callback = config.Callback or function()
			end
			local Input, inputFrame =
				{
					Value = config.Default or "",
					Numeric = config.Numeric or false,
					Finished = config.Finished or false,
					Callback = config.Callback or function(_value)
					end,
					Type = "Input"
				},
			requireModule(Components.Element)(config.Title, config.Description, parent.Container, false)
			inputFrame.TitleLabel.Size = UDim2.new(1, -180, 0, 0)
			inputFrame.DescLabel.Size = UDim2.new(1, -180, 0, 0)
			Input.SetTitle = inputFrame.SetTitle
			Input.SetDesc = inputFrame.SetDesc
			Input.Frame = inputFrame.Frame
			local textbox = requireModule(Components.Textbox)(inputFrame.Frame, true)
			textbox.Frame.Position = UDim2.new(1, -10, 0.5, 0)
			textbox.Frame.AnchorPoint = Vector2.new(1, 0.5)
			textbox.Frame.Size = UDim2.fromOffset(160, 30)
			textbox.Input.Text = config.Default or ""
			textbox.Input.PlaceholderText = config.Placeholder or ""
			local inputBox = textbox.Input
			local settingProgrammatically = false
			function Input.SetValue(_self, text, silent)
				text = tostring(text or "")
				if config.MaxLength and #text > config.MaxLength then
					text = text:sub(1, config.MaxLength)
				end
				if Input.Numeric then
					if (not tonumber(text)) and text:len() > 0 then
						text = Input.Value
					end
				end
				Input.Value = text
				if inputBox.Text ~= text then
					settingProgrammatically = true
					inputBox.Text = text
					settingProgrammatically = false
				end
				if not silent then
					Library:SafeCallback(Input.Callback, Input.Value)
					Library:SafeCallback(Input.Changed, Input.Value)
				end
			end
			if Input.Finished then
				AddSignal(
					inputBox.FocusLost,
					function()
						-- Finished inputs should commit when focus leaves for any reason.
						-- Roblox only sets this event argument for Enter, so requiring it
						-- made clicks/taps outside the field silently discard the value.
						Input:SetValue(inputBox.Text)
						Library._TouchElement(Input)
					end
				)
			else
				AddSignal(
					inputBox:GetPropertyChangedSignal "Text",
					function()
						if settingProgrammatically then
							return
						end
						Input:SetValue(inputBox.Text)
						-- Text also changes when a script calls SetValue.
						if inputBox:IsFocused() then
							Library._TouchElement(Input)
						end
					end
				)
			end
			function Input.OnChanged(_self, callback)
				Input.Changed = callback
				callback(Input.Value)
			end
			function Input.Destroy(_self)
				inputFrame:Destroy()
				Library.Options[idx] = nil
			end
			Library.Options[idx] = Input
			return Input
		end
		return Element
	end,
	[24] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(24)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local UserInputService = Creator.GetService("UserInputService")
		local New, Components, Element = Creator.New, Root.Components, {}
		Element.__index = Element
		Element.__type = "Keybind"
		function Element.New(parent, idx, config)
			local Library = parent.Library
			assert(config.Title, "KeyBind - Missing Title")
			assert(config.Default, "KeyBind - Missing default value.")
			local Keybind, picking, keybindFrame =
				{
					Value = config.Default,
					Default = config.Default,
					Title = config.Title,
					Toggled = false,
					Mode = config.Mode or "Toggle",
					Type = "Keybind",
					Callback = config.Callback or function(_toggled)
					end,
					ChangedCallback = config.ChangedCallback or function(_key)
					end
				},
			false,
			requireModule(Components.Element)(config.Title, config.Description, parent.Container, true)
			keybindFrame.TitleLabel.Size = UDim2.new(1, -110, 0, 14)
			keybindFrame.DescLabel.Size = UDim2.new(1, -110, 0, 14)
			Keybind.SetTitle = keybindFrame.SetTitle
			Keybind.SetDesc = keybindFrame.SetDesc
			Keybind.Frame = keybindFrame.Frame
			local keybindDisplayLabel =
				New(
					"TextLabel",
					{
						FontFace = Creator.Font(Enum.FontWeight.Regular, Enum.FontStyle.Normal),
						Text = config.Default,
						I18nSkip = true,
						TextColor3 = Color3.fromRGB(240, 240, 240),
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Center,
						Size = UDim2.new(0, 0, 0, 14),
						Position = UDim2.new(0, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						AutomaticSize = Enum.AutomaticSize.X,
						BackgroundTransparency = 1,
						ThemeTag = {TextColor3 = "Text"}
					}
				)
			local keybindDisplayFrame =
				New(
					"TextButton",
					{
						Size = UDim2.fromOffset(0, 30),
						Position = UDim2.new(1, -10, 0.5, 0),
						AnchorPoint = Vector2.new(1, 0.5),
						BackgroundTransparency = 0.24,
						Parent = keybindFrame.Frame,
						AutomaticSize = Enum.AutomaticSize.X,
						ThemeTag = {BackgroundColor3 = "DialogButton"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 5)}),
						New("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}),
						New(
							"UIStroke",
							{
								Transparency = 0.38,
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								ThemeTag = {Color = "InElementBorder"}
							}
						),
						keybindDisplayLabel
					}
				)
			function Keybind.GetState(_self)
				if UserInputService:GetFocusedTextBox() and Keybind.Mode ~= "Always" then
					return false
				end
				if Keybind.Mode == "Always" then
					return true
				elseif Keybind.Mode == "Hold" then
					if Keybind.Value == "None" then
						return false
					end
					local key = Keybind.Value
					if key == "MouseLeft" or key == "MouseRight" then
						return key == "MouseLeft" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or
							key == "MouseRight" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
					else
						local found, keyCode = pcall(function()
							return Enum.KeyCode[key]
						end)
						return found and keyCode ~= nil and UserInputService:IsKeyDown(keyCode)
					end
				else
					return Keybind.Toggled
				end
			end
			function Keybind.SetValue(_self, key, mode)
				key = key or Keybind.Value
				mode = mode or Keybind.Mode
				keybindDisplayLabel.Text = key
				Keybind.Value = key
				Keybind.Mode = mode
				if type(Library._NotifyKeybindChanged) == "function" then
					Library._NotifyKeybindChanged()
				end
			end
			function Keybind.OnClick(_self, callback)
				Keybind.Clicked = callback
			end
			function Keybind.OnChanged(_self, callback)
				Keybind.Changed = callback
				callback(Keybind.Value)
			end
			function Keybind.DoClick(_self)
				Library:SafeCallback(Keybind.Callback, Keybind.Toggled)
				Library:SafeCallback(Keybind.Clicked, Keybind.Toggled)
				if type(Library._NotifyKeybindChanged) == "function" then
					Library._NotifyKeybindChanged()
				end
			end

			-- Route through Creator's single shared keybind listener instead of
			-- allocating one global UserInputService.InputBegan per Keybind.
			local routerEntry = Creator.RegisterKeybind({
				IsPicking = function()
					return picking
				end,
				GetMode = function()
					return Keybind.Mode
				end,
				GetKey = function()
					return Keybind.Value
				end,
				Trigger = function()
					Keybind.Toggled = not Keybind.Toggled
					Keybind:DoClick()
				end
			})
			if not config._Internal and type(Library._TrackKeybind) == "function" then
				Library._TrackKeybind(Keybind)
			end

			function Keybind.Destroy(_self)
				Creator.UnregisterKeybind(routerEntry)
				if type(Library._UntrackKeybind) == "function" then
					Library._UntrackKeybind(Keybind)
				end
				keybindFrame:Destroy()
				Library.Options[idx] = nil
			end
			Creator.AddSignal(
				keybindDisplayFrame.InputBegan,
				function(input)
					if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
						and not picking then
						picking = true
						keybindDisplayLabel.Text = "..."
						task.wait(0.2)
						local beganConnection
						beganConnection =
							UserInputService.InputBegan:Connect(
								function(keyInput)
									local key
									if keyInput.UserInputType == Enum.UserInputType.Keyboard then
										key = keyInput.KeyCode.Name
									elseif keyInput.UserInputType == Enum.UserInputType.MouseButton1 then
										key = "MouseLeft"
									elseif keyInput.UserInputType == Enum.UserInputType.MouseButton2 then
										key = "MouseRight"
									end
									beganConnection:Disconnect()
									if key == nil then
										picking = false
										keybindDisplayLabel.Text = Keybind.Value
										return
									end
									local endedConnection
									endedConnection =
									UserInputService.InputEnded:Connect(
										function(endInput)
											if
												endInput.KeyCode.Name == key or
												key == "MouseLeft" and endInput.UserInputType == Enum.UserInputType.MouseButton1 or
												key == "MouseRight" and endInput.UserInputType == Enum.UserInputType.MouseButton2
											then
												picking = false
												keybindDisplayLabel.Text = key
												Keybind.Value = key
												Library._TouchElement(Keybind)
												Library:SafeCallback(Keybind.ChangedCallback, endInput.KeyCode or endInput.UserInputType)
												Library:SafeCallback(Keybind.Changed, endInput.KeyCode or endInput.UserInputType)
												endedConnection:Disconnect()
											end
										end
									)
								end
							)
					end
				end
			)
			Library.Options[idx] = Keybind
			return Keybind
		end
		return Element
	end,
	[25] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(25)
		local Root = moduleScript.Parent.Parent
		local Components, Creator, Paragraph = Root.Components, requireModule(Root.Creator), {}
		Paragraph.__index = Paragraph
		Paragraph.__type = "Paragraph"
		function Paragraph.New(parent, config)
			if type(parent) == "table" and config == nil and parent.Title ~= nil then
				config = parent
				parent = Paragraph
			end
			assert(config and config.Title, "Paragraph - Missing Title")
			config.Content = config.Content or ""
			local container = (parent and parent.Container) or Paragraph.Container
			local paragraph = requireModule(Components.Element)(config.Title, config.Content, container, false)
			paragraph.Border.Transparency = 0.36
			return paragraph
		end
		return Paragraph
	end,
	[26] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(26)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local New, Components, Element = Creator.New, Root.Components, {}
		Element.__index = Element
		Element.__type = "Slider"
		function Element.New(parent, idx, config)
			local Library = parent.Library
			assert(config.Title, "Slider - Missing Title.")
			assert(config.Default, "Slider - Missing default value.")
			assert(config.Min, "Slider - Missing minimum value.")
			assert(config.Max, "Slider - Missing maximum value.")
			assert(config.Rounding, "Slider - Missing rounding value.")
			local Slider, dragging, sliderFrame =
				{
					Value = nil,
					Min = config.Min,
					Max = config.Max,
					Rounding = config.Rounding,
					Prefix = type(config.Prefix) == "string" and config.Prefix or "",
					Suffix = type(config.Suffix) == "string" and config.Suffix or "",
					Callback = config.Callback or function(_value)
					end,
					Type = "Slider"
				},
			false,
			requireModule(Components.Element)(config.Title, config.Description, parent.Container, false)
			sliderFrame.TitleLabel.Size = UDim2.new(1, -210, 0, 0)
			sliderFrame.DescLabel.Size = UDim2.new(1, -210, 0, 0)
			Slider.SetTitle = sliderFrame.SetTitle
			Slider.SetDesc = sliderFrame.SetDesc
			Slider.Frame = sliderFrame.Frame

			-- Pure Vector Thumb with crisp accent ring (replaces legacy circle asset)
			local thumbStroke = New(
				"UIStroke",
				{
					Thickness = 2,
					Transparency = 0.05,
					ThemeTag = {Color = "Accent"}
				}
			)
			local sliderDot = New(
				"Frame",
				{
					Name = "Thumb",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.fromOffset(13, 13),
					BackgroundColor3 = Color3.fromRGB(248, 250, 255),
					BackgroundTransparency = 0,
					ZIndex = 3,
					ThemeTag = {BackgroundColor3 = "Text"}
				},
				{New("UICorner", {CornerRadius = UDim.new(1, 0)}), thumbStroke}
			)

			local sliderRail = New(
				"Frame",
				{BackgroundTransparency = 1, Position = UDim2.fromOffset(6, 0), Size = UDim2.new(1, -12, 1, 0)},
				{sliderDot}
			)
			local sliderFill = New(
				"Frame",
				{Size = UDim2.new(0, 0, 1, 0), ThemeTag = {BackgroundColor3 = "Accent"}},
				{New("UICorner", {CornerRadius = UDim.new(1, 0)})}
			)

			-- Styled editable value pill next to track
			local pillStroke = New(
				"UIStroke",
				{
					Transparency = 0.38,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					ThemeTag = {Color = "InElementBorder"}
				}
			)
			local sliderDisplay = New(
				"TextBox",
				{
					Name = "ValueInput",
					FontFace = Creator.Font(Enum.FontWeight.Medium, Enum.FontStyle.Normal),
					Text = "0",
					I18nSkip = true,
					TextSize = 11,
					ClearTextOnFocus = false,
					TextWrapped = false,
					TextXAlignment = Enum.TextXAlignment.Center,
					BackgroundTransparency = 0.24,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.fromOffset(36, 22),
					Position = UDim2.new(0, -10, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5),
					ThemeTag = {BackgroundColor3 = "DialogHolder", TextColor3 = "Text"},
					TextEditable = true
				},
				{
					New("UICorner", {CornerRadius = UDim.new(0, 6)}),
					New("UIPadding", {PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 7)}),
					New("UISizeConstraint", {MinSize = Vector2.new(36, 22), MaxSize = Vector2.new(88, 22)}),
					pillStroke
				}
			)

			local sliderInner = New(
				"Frame",
				{
					Name = "Track",
					Size = UDim2.new(1, 0, 0, 5),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -12, 0.5, 0),
					BackgroundTransparency = 0.72,
					Parent = sliderFrame.Frame,
					ThemeTag = {BackgroundColor3 = "SliderRail"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(1, 0)}),
					New("UISizeConstraint", {MaxSize = Vector2.new(146, math.huge)}),
					sliderDisplay,
					sliderFill,
					sliderRail
				}
			)

			local editingNumber = false
			local function setThumbSize(px)
				Creator.SpringValue(sliderDot, "Size", px, 12, 0.8, function(sz)
					sliderDot.Size = UDim2.fromOffset(sz, sz)
				end, sliderDot.Size.X.Offset)
			end

			local function formatValue(val)
				if Slider.Prefix ~= "" or Slider.Suffix ~= "" then
					return Slider.Prefix .. tostring(val) .. Slider.Suffix
				end
				return tostring(val)
			end

			local dragRailX, dragRailW = nil, nil
			local function updateFromPosition(posX, useSnapshot)
				local railX = (useSnapshot and dragRailX) or sliderRail.AbsolutePosition.X
				local width = (useSnapshot and dragRailW) or sliderRail.AbsoluteSize.X
				if width <= 0 then
					return
				end
				local ratio = math.clamp((posX - railX) / width, 0, 1)
				Slider:SetValue(Slider.Min + ((Slider.Max - Slider.Min) * ratio))
			end

			local function startDrag(_input)
				if editingNumber then
					return
				end
				dragging = true
				-- Snapshot rail bounds so sliders that resize their own window (e.g. DPI Scale)
				-- never oscillate in a feedback loop while dragging.
				dragRailX = sliderRail.AbsolutePosition.X
				dragRailW = sliderRail.AbsoluteSize.X
				setThumbSize(16)
				Library._TouchElement(Slider)
				Creator.BeginDrag(function(moveInput)
					if not dragging or editingNumber then
						return
					end
					updateFromPosition(moveInput.Position.X, true)
				end, function()
					dragging = false
					dragRailX = nil
					dragRailW = nil
					setThumbSize(13)
				end)
			end

			local railHitArea = New("Frame", {
				Name = "HitArea",
				BackgroundTransparency = 1,
				Active = true,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, -6, 0.5, 0),
				Size = UDim2.new(1, 12, 0, 26),
				Parent = sliderRail
			})
			Creator.AddSignal(railHitArea.MouseEnter, function()
				if not dragging then
					setThumbSize(15)
				end
			end)
			Creator.AddSignal(railHitArea.MouseLeave, function()
				if not dragging then
					setThumbSize(13)
				end
			end)
			Creator.AddSignal(
				sliderDot.InputBegan,
				function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						startDrag(input)
					end
				end
			)
			Creator.AddSignal(
				railHitArea.InputBegan,
				function(input)
					if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
						and not editingNumber and sliderRail.AbsoluteSize.X > 0 then
						startDrag(input)
						updateFromPosition(input.Position.X, true)
					end
				end
			)

			sliderDisplay.Focused:Connect(function()
				editingNumber = true
				if dragging then
					dragging = false
					setThumbSize(13)
					Creator.EndDrag()
				end
				if Slider.Value ~= nil then
					sliderDisplay.Text = tostring(Slider.Value)
				end
				Creator.SpringValue(pillStroke, "Transparency", 0.14, 10, 1)
				Creator.OverrideTag(pillStroke, {Color = "Accent"})
			end)

			sliderDisplay.FocusLost:Connect(function()
				editingNumber = false
				Creator.SpringValue(pillStroke, "Transparency", 0.38, 10, 1)
				Creator.OverrideTag(pillStroke, {Color = "InElementBorder"})
				local text = tostring(sliderDisplay.Text):gsub(",", "."):match("[-+]?%d*%.?%d+")
				local num = text and tonumber(text) or nil
				if num then
					local newVal = Library:Round(math.clamp(num, Slider.Min, Slider.Max), Slider.Rounding)
					Slider:SetValue(newVal)
					Library._TouchElement(Slider)
				else
					sliderDisplay.Text = formatValue(Slider.Value ~= nil and Slider.Value or config.Default)
				end
			end)

			function Slider.OnChanged(_self, callback)
				Slider.Changed = callback
				callback(Slider.Value)
			end
			function Slider.SetValue(target, value, silent)
				target.Value = Library:Round(math.clamp(value, Slider.Min, Slider.Max), Slider.Rounding)
				local range = Slider.Max - Slider.Min
				local ratio = range ~= 0 and ((target.Value - Slider.Min) / range) or 0
				sliderDot.Position = UDim2.new(ratio, 0, 0.5, 0)
				sliderFill.Size = UDim2.fromScale(ratio, 1)
				sliderDisplay.Text = formatValue(target.Value)
				if not silent then
					Library:SafeCallback(Slider.Callback, target.Value)
					Library:SafeCallback(Slider.Changed, target.Value)
				end
			end
			function Slider.Destroy(_self)
				if dragging then
					dragging = false
					Creator.EndDrag()
				end
				sliderFrame:Destroy()
				Library.Options[idx] = nil
			end
			Slider:SetValue(config.Default)
			Library.Options[idx] = Slider
			return Slider
		end
		return Element
	end,
	[27] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(27)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local TweenService = Creator.GetService("TweenService")
		local UserInputService = Creator.GetService("UserInputService")
		local New, Components, Element = Creator.New, Root.Components, {}
		Element.__index = Element
		Element.__type = "Toggle"
		local SLIDE_TWEEN = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		local STRETCH_IN = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local STRETCH_OUT = TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

		function Element.New(parent, idx, config)
			if type(idx) == "table" and config == nil then
				config = idx
				idx = nil
			end
			local Library = parent.Library
			assert(config.Title, "Toggle - Missing Title")
			local Toggle, toggleFrame =
				{
					Value = config.Default or false,
					Default = config.Default or false,
					Title = config.Title,
					Callback = config.Callback or function(_value)
					end,
					Type = "Toggle",
					Addons = {}
				},
			requireModule(Components.Element)(config.Title, config.Description, parent.Container, true)
			toggleFrame.TitleLabel.Size = UDim2.new(1, -60, 0, 0)
			toggleFrame.DescLabel.Size = UDim2.new(1, -60, 0, 0)
			Toggle.SetTitle = toggleFrame.SetTitle
			Toggle.SetDesc = toggleFrame.SetDesc
			Toggle.SetBadge = toggleFrame.SetBadge
			Toggle.Frame = toggleFrame.Frame
			local parentScrollFrame = parent.ScrollFrame

			-- Pure Vector Pill Thumb (replaces legacy raster circle asset, crisp at any DPI)
			local toggleThumb = New(
				"Frame",
				{
					Name = "Thumb",
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.fromOffset(14, 14),
					Position = UDim2.new(0, 3, 0.5, 0),
					BackgroundTransparency = 0.2,
					BorderSizePixel = 0,
					ThemeTag = {BackgroundColor3 = "ToggleSlider"}
				},
				{New("UICorner", {CornerRadius = UDim.new(1, 0)})}
			)
			local toggleBorder = New("UIStroke", {Transparency = 0.36, Thickness = 1, ThemeTag = {Color = "ToggleSlider"}})
			local toggleTrack = New(
				"Frame",
				{
					Name = "Track",
					Size = UDim2.fromOffset(40, 20),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -12, 0.5, 0),
					Parent = toggleFrame.Frame,
					BackgroundTransparency = 0.88,
					ThemeTag = {BackgroundColor3 = "ToggleSlider"}
				},
				{New("UICorner", {CornerRadius = UDim.new(1, 0)}), toggleBorder, toggleThumb}
			)

			-- Inline Addons container (sits neatly to the left of the Toggle switch)
			local addonHolder, addonLayout = nil, nil
			local function ensureAddonHolder()
				if addonHolder then
					return addonHolder
				end
				addonLayout = New(
					"UIListLayout",
					{
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 6)
					}
				)
				addonHolder = New(
					"Frame",
					{
						Name = "Addons",
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -60, 0.5, 0),
						Size = UDim2.fromOffset(160, 26),
						BackgroundTransparency = 1,
						ZIndex = 4,
						Parent = toggleFrame.Frame
					},
					{addonLayout}
				)
				local function syncLabelBudget()
					if not addonHolder or not addonHolder.Parent then
						return
					end
					local scale = Creator.GetEffectiveScale(addonHolder)
					local usedW = math.ceil(addonLayout.AbsoluteContentSize.X / scale)
					local rightReserve = 66 + usedW
					toggleFrame.TitleLabel.Size = UDim2.new(1, -rightReserve, 0, 0)
					toggleFrame.DescLabel.Size = UDim2.new(1, -rightReserve, 0, 0)
				end
				Creator.AddSignal(addonLayout:GetPropertyChangedSignal("AbsoluteContentSize"), syncLabelBudget)
				Creator.RegisterDPIScale(addonHolder, function()
					task.defer(syncLabelBudget)
				end)
				task.defer(syncLabelBudget)
				return addonHolder
			end

			-- Inline Addon: Toggle:AddKeybind(idx, opts)
			function Toggle.AddKeybind(_self, keyIdx, keyOpts)
				if type(keyIdx) == "table" and keyOpts == nil then
					keyOpts = keyIdx
					keyIdx = nil
				end
				keyOpts = type(keyOpts) == "table" and keyOpts or {}
				local holder = ensureAddonHolder()
				local syncToggle = keyOpts.SyncToggleState ~= false
				local picking = false
				local Kb = {
					Value = tostring(keyOpts.Default or "None"),
					Default = tostring(keyOpts.Default or "None"),
					Mode = keyOpts.Mode or "Toggle",
					Title = tostring(keyOpts.Title or Toggle.Title or "Keybind"),
					Toggled = Toggle.Value,
					Type = "Keybind",
					SyncToggleState = syncToggle,
					Callback = keyOpts.Callback or function() end,
					ChangedCallback = keyOpts.ChangedCallback or function() end
				}

				local kbLabel = New(
					"TextLabel",
					{
						Name = "KeyLabel",
						FontFace = Creator.Font(Enum.FontWeight.Medium),
						Text = Kb.Value,
						I18nSkip = true,
						TextSize = 11,
						TextXAlignment = Enum.TextXAlignment.Center,
						AutomaticSize = Enum.AutomaticSize.X,
						Size = UDim2.new(0, 0, 1, 0),
						BackgroundTransparency = 1,
						ThemeTag = {TextColor3 = "Text"}
					}
				)
				local kbStroke = New(
					"UIStroke",
					{
						Transparency = 0.38,
						Thickness = 1,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						ThemeTag = {Color = "InElementBorder"}
					}
				)
				local kbBtn = New(
					"TextButton",
					{
						Name = "InlineKeybind",
						Text = "",
						AutomaticSize = Enum.AutomaticSize.X,
						Size = UDim2.fromOffset(0, 22),
						BackgroundTransparency = 0.24,
						AutoButtonColor = false,
						LayoutOrder = #Toggle.Addons + 1,
						ZIndex = 5,
						Parent = holder,
						ThemeTag = {BackgroundColor3 = "DialogButton"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 6)}),
						New("UIPadding", {PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 7)}),
						New("UISizeConstraint", {MinSize = Vector2.new(26, 22), MaxSize = Vector2.new(110, 22)}),
						kbStroke,
						kbLabel
					}
				)
				Kb.Frame = kbBtn

				local function notifyHud()
					if type(Library._NotifyKeybindChanged) == "function" then
						Library._NotifyKeybindChanged()
					end
				end

				function Kb.GetState(_s)
					if UserInputService:GetFocusedTextBox() and Kb.Mode ~= "Always" then
						return false
					end
					if Kb.Mode == "Always" then
						return true
					elseif Kb.Mode == "Hold" then
						if Kb.Value == "None" then
							return false
						end
						if Kb.Value == "MouseLeft" then
							return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
						elseif Kb.Value == "MouseRight" then
							return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
						end
						local ok, kc = pcall(function() return Enum.KeyCode[Kb.Value] end)
						return ok and kc ~= nil and UserInputService:IsKeyDown(kc)
					else
						return syncToggle and Toggle.Value or Kb.Toggled
					end
				end

				function Kb.SetValue(_s, key, mode)
					Kb.Value = tostring(key or Kb.Value)
					Kb.Mode = mode or Kb.Mode
					kbLabel.Text = Kb.Value
					notifyHud()
				end
				function Kb.OnChanged(_s, cb)
					Kb.Changed = cb
					cb(Kb.Value)
				end
				function Kb.OnClick(_s, cb)
					Kb.Clicked = cb
				end

				local routerEntry = Creator.RegisterKeybind({
					IsPicking = function() return picking end,
					GetMode = function() return Kb.Mode end,
					GetKey = function() return Kb.Value end,
					Trigger = function()
						if syncToggle then
							Toggle:SetValue(not Toggle.Value)
							Kb.Toggled = Toggle.Value
						else
							Kb.Toggled = not Kb.Toggled
						end
						Library:SafeCallback(Kb.Callback, Kb.Toggled)
						Library:SafeCallback(Kb.Clicked, Kb.Toggled)
						notifyHud()
					end
				})

				if type(Library._TrackKeybind) == "function" then
					Library._TrackKeybind(Kb)
				end

				function Kb.Destroy(_s)
					Creator.UnregisterKeybind(routerEntry)
					if type(Library._UntrackKeybind) == "function" then
						Library._UntrackKeybind(Kb)
					end
					if kbBtn and kbBtn.Parent then
						kbBtn:Destroy()
					end
					if keyIdx ~= nil then
						Library.Options[keyIdx] = nil
					end
				end

				Creator.AddSignal(kbBtn.MouseEnter, function()
					Creator.SpringValue(kbStroke, "Transparency", 0.16, 10, 1)
				end)
				Creator.AddSignal(kbBtn.MouseLeave, function()
					if not picking then
						Creator.SpringValue(kbStroke, "Transparency", 0.38, 10, 1)
					end
				end)
				Creator.AddSignal(kbBtn.MouseButton1Click, function()
					if picking then
						return
					end
					picking = true
					kbLabel.Text = "..."
					Creator.OverrideTag(kbStroke, {Color = "Accent"})
					task.delay(0.12, function()
						local beganConn
						beganConn = UserInputService.InputBegan:Connect(function(keyInput)
							local key = nil
							if keyInput.UserInputType == Enum.UserInputType.Keyboard then
								if keyInput.KeyCode == Enum.KeyCode.Escape or keyInput.KeyCode == Enum.KeyCode.Backspace then
									key = "None"
								else
									key = keyInput.KeyCode.Name
								end
							elseif keyInput.UserInputType == Enum.UserInputType.MouseButton1 then
								key = "MouseLeft"
							elseif keyInput.UserInputType == Enum.UserInputType.MouseButton2 then
								key = "MouseRight"
							end
							if beganConn then
								beganConn:Disconnect()
							end
							picking = false
							Creator.OverrideTag(kbStroke, {Color = "InElementBorder"})
							if key == nil then
								kbLabel.Text = Kb.Value
								return
							end
							Kb.Value = key
							kbLabel.Text = key
							Library._TouchElement(Toggle)
							Library:SafeCallback(Kb.ChangedCallback, keyInput.KeyCode or keyInput.UserInputType)
							Library:SafeCallback(Kb.Changed, key)
							notifyHud()
						end)
					end)
				end)

				table.insert(Toggle.Addons, Kb)
				if keyIdx ~= nil then
					Library.Options[keyIdx] = Kb
				end
				notifyHud()
				return Kb
			end

			-- Inline Addon: Toggle:AddColorpicker(idx, opts)
			function Toggle.AddColorpicker(_self, cpIdx, cpOpts)
				if type(cpIdx) == "table" and cpOpts == nil then
					cpOpts = cpIdx
					cpIdx = nil
				end
				cpOpts = type(cpOpts) == "table" and cpOpts or {}
				local holder = ensureAddonHolder()
				local ColorpickerModule = requireModule(Root.Elements.Colorpicker)
				local inlineConfig = {}
				for k, v in next, cpOpts do
					inlineConfig[k] = v
				end
				inlineConfig.Title = cpOpts.Title or Toggle.Title
				inlineConfig.Default = cpOpts.Default or Color3.fromRGB(99, 179, 255)
				inlineConfig._InlineHolder = holder
				inlineConfig._LayoutOrder = #Toggle.Addons + 1
				local fakeParent = {Library = Library, Container = holder, ScrollFrame = parentScrollFrame}
				local cp = ColorpickerModule.New(fakeParent, cpIdx, inlineConfig)
				table.insert(Toggle.Addons, cp)
				return cp
			end

			function Toggle.OnChanged(_self, callback)
				Toggle.Changed = callback
				callback(Toggle.Value)
			end

			local animGen = 0
			local function applyVisual(value, instant)
				animGen += 1
				local myGen = animGen
				local useInstant = instant or Creator.ReducedMotion
				Creator.OverrideTag(toggleBorder, {Color = value and "Accent" or "ToggleSlider"})
				Creator.OverrideTag(toggleTrack, {BackgroundColor3 = value and "Accent" or "ToggleSlider"})
				Creator.OverrideTag(toggleThumb, {BackgroundColor3 = value and "ToggleToggled" or "ToggleSlider"})

				local targetX = value and 23 or 3
				local targetPos = UDim2.new(0, targetX, 0.5, 0)
				local targetBg = value and 0 or 0.88
				local targetThumbAlpha = value and 0 or 0.18
				local targetBorderAlpha = value and 0.12 or 0.36

				if useInstant then
					toggleThumb.Position = targetPos
					toggleThumb.Size = UDim2.fromOffset(14, 14)
					toggleThumb.BackgroundTransparency = targetThumbAlpha
					toggleTrack.BackgroundTransparency = targetBg
					toggleBorder.Transparency = targetBorderAlpha
				else
					-- Tactile squash-and-stretch pill elongation while sliding
					TweenService:Create(toggleThumb, SLIDE_TWEEN, {Position = targetPos, BackgroundTransparency = targetThumbAlpha}):Play()
					TweenService:Create(toggleTrack, SLIDE_TWEEN, {BackgroundTransparency = targetBg}):Play()
					TweenService:Create(toggleBorder, SLIDE_TWEEN, {Transparency = targetBorderAlpha}):Play()
					local stretch = TweenService:Create(toggleThumb, STRETCH_IN, {Size = UDim2.fromOffset(18, 13)})
					stretch:Play()
					stretch.Completed:Connect(function()
						if myGen == animGen and toggleThumb.Parent then
							TweenService:Create(toggleThumb, STRETCH_OUT, {Size = UDim2.fromOffset(14, 14)}):Play()
						end
					end)
				end
			end

			function Toggle.SetValue(_self, value, instant, silent)
				value = not (not value)
				Toggle.Value = value
				applyVisual(value, instant == true)
				if not silent then
					Library:SafeCallback(Toggle.Callback, Toggle.Value)
					Library:SafeCallback(Toggle.Changed, Toggle.Value)
				end
				if type(Library._NotifyKeybindChanged) == "function" and #Toggle.Addons > 0 then
					Library._NotifyKeybindChanged()
				end
			end

			function Toggle.Destroy(_self)
				for _, addon in ipairs(Toggle.Addons) do
					if type(addon.Destroy) == "function" then
						pcall(addon.Destroy, addon)
					end
				end
				table.clear(Toggle.Addons)
				toggleFrame:Destroy()
				if idx ~= nil then
					Library.Options[idx] = nil
				end
			end

			Creator.AddSignal(
				toggleFrame.Frame.MouseButton1Click,
				function()
					Toggle:SetValue(not Toggle.Value)
					Library._TouchElement(Toggle)
				end
			)
			Toggle:SetValue(Toggle.Value, true)
			if idx ~= nil then
				Library.Options[idx] = Toggle
			end
			return Toggle
		end
		return Element
	end,
	[28] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(28)
		local rawAssets = {
			["a-arrow-down"] = "rbxassetid://92867583610071",
			["a-arrow-up"] = "rbxassetid://132318504999733",
			["a-large-small"] = "rbxassetid://111491496660216",
			["accessibility"] = "rbxassetid://114029945302017",
			["activity"] = "rbxassetid://94212016861936",
			["air-vent"] = "rbxassetid://81517226012329",
			["airplay"] = "rbxassetid://115020759309179",
			["alarm-clock"] = "rbxassetid://126259032907535",
			["alarm-clock-check"] = "rbxassetid://76437352099157",
			["alarm-clock-minus"] = "rbxassetid://77364179863205",
			["alarm-clock-off"] = "rbxassetid://97904885874823",
			["alarm-clock-plus"] = "rbxassetid://80468822979214",
			["alarm-smoke"] = "rbxassetid://96965448419685",
			["album"] = "rbxassetid://127358331163602",
			["align-center-horizontal"] = "rbxassetid://81570549209434",
			["align-center-vertical"] = "rbxassetid://118470463752466",
			["align-end-horizontal"] = "rbxassetid://139502909745427",
			["align-end-vertical"] = "rbxassetid://96528869059554",
			["align-horizontal-distribute-center"] = "rbxassetid://97220086126656",
			["align-horizontal-distribute-end"] = "rbxassetid://106128590702022",
			["align-horizontal-distribute-start"] = "rbxassetid://76074660002997",
			["align-horizontal-justify-center"] = "rbxassetid://75732302772427",
			["align-horizontal-justify-end"] = "rbxassetid://129167626402283",
			["align-horizontal-justify-start"] = "rbxassetid://130161830325281",
			["align-horizontal-space-around"] = "rbxassetid://91646106782950",
			["align-horizontal-space-between"] = "rbxassetid://103886093046990",
			["align-start-horizontal"] = "rbxassetid://125674804697729",
			["align-start-vertical"] = "rbxassetid://105020230154823",
			["align-vertical-distribute-center"] = "rbxassetid://93791183635525",
			["align-vertical-distribute-end"] = "rbxassetid://139354223511433",
			["align-vertical-distribute-start"] = "rbxassetid://74961997822126",
			["align-vertical-justify-center"] = "rbxassetid://134754696166569",
			["align-vertical-justify-end"] = "rbxassetid://92569381441969",
			["align-vertical-justify-start"] = "rbxassetid://99692844572718",
			["align-vertical-space-around"] = "rbxassetid://96206012459190",
			["align-vertical-space-between"] = "rbxassetid://124998077349706",
			["ambulance"] = "rbxassetid://78599995190651",
			["ampersand"] = "rbxassetid://75272915739209",
			["ampersands"] = "rbxassetid://126947193455996",
			["amphora"] = "rbxassetid://137370389604364",
			["anchor"] = "rbxassetid://92181172123618",
			["angry"] = "rbxassetid://74237056000103",
			["annoyed"] = "rbxassetid://80064369052011",
			["antenna"] = "rbxassetid://99628923540956",
			["anvil"] = "rbxassetid://100203029845919",
			["aperture"] = "rbxassetid://83396154449972",
			["app-window"] = "rbxassetid://93142176757189",
			["app-window-mac"] = "rbxassetid://79587216113811",
			["apple"] = "rbxassetid://104349242902442",
			["archive"] = "rbxassetid://122180020814574",
			["archive-restore"] = "rbxassetid://78956681942188",
			["archive-x"] = "rbxassetid://75830115088395",
			["armchair"] = "rbxassetid://105384358373973",
			["arrow-big-down"] = "rbxassetid://81081164158885",
			["arrow-big-down-dash"] = "rbxassetid://137987229582002",
			["arrow-big-left"] = "rbxassetid://85973092492641",
			["arrow-big-left-dash"] = "rbxassetid://97827621354677",
			["arrow-big-right"] = "rbxassetid://82960676755590",
			["arrow-big-right-dash"] = "rbxassetid://117825834972403",
			["arrow-big-up"] = "rbxassetid://93136954756149",
			["arrow-big-up-dash"] = "rbxassetid://99260194327483",
			["arrow-down"] = "rbxassetid://98764963621439",
			["arrow-down-0-1"] = "rbxassetid://120961896217875",
			["arrow-down-1-0"] = "rbxassetid://93474255891850",
			["arrow-down-a-z"] = "rbxassetid://99554596207900",
			["arrow-down-from-line"] = "rbxassetid://132045845807798",
			["arrow-down-left"] = "rbxassetid://102899325237364",
			["arrow-down-narrow-wide"] = "rbxassetid://129105261655061",
			["arrow-down-right"] = "rbxassetid://123109928624974",
			["arrow-down-to-dot"] = "rbxassetid://101675355931221",
			["arrow-down-to-line"] = "rbxassetid://87050478931254",
			["arrow-down-up"] = "rbxassetid://85780258549577",
			["arrow-down-wide-narrow"] = "rbxassetid://88461733425991",
			["arrow-down-z-a"] = "rbxassetid://76115279362232",
			["arrow-left"] = "rbxassetid://102531941843733",
			["arrow-left-from-line"] = "rbxassetid://87857914437603",
			["arrow-left-right"] = "rbxassetid://131324733048447",
			["arrow-left-to-line"] = "rbxassetid://118645136026970",
			["arrow-right"] = "rbxassetid://113692007244654",
			["arrow-right-from-line"] = "rbxassetid://74073639809355",
			["arrow-right-left"] = "rbxassetid://77015754304300",
			["arrow-right-to-line"] = "rbxassetid://78632510329852",
			["arrow-up"] = "rbxassetid://89282378235317",
			["arrow-up-0-1"] = "rbxassetid://105257823943016",
			["arrow-up-1-0"] = "rbxassetid://134175521693798",
			["arrow-up-a-z"] = "rbxassetid://77763416595160",
			["arrow-up-down"] = "rbxassetid://81019887641527",
			["arrow-up-from-dot"] = "rbxassetid://124408496673275",
			["arrow-up-from-line"] = "rbxassetid://95777664626453",
			["arrow-up-left"] = "rbxassetid://123490598231261",
			["arrow-up-narrow-wide"] = "rbxassetid://73006024672636",
			["arrow-up-right"] = "rbxassetid://129280608535523",
			["arrow-up-to-line"] = "rbxassetid://108818207813537",
			["arrow-up-wide-narrow"] = "rbxassetid://87437426951568",
			["arrow-up-z-a"] = "rbxassetid://107546173611884",
			["arrows-up-from-line"] = "rbxassetid://133710016938621",
			["asterisk"] = "rbxassetid://88552752106723",
			["at-sign"] = "rbxassetid://79059152889146",
			["atom"] = "rbxassetid://73167696981648",
			["audio-lines"] = "rbxassetid://70930641819242",
			["audio-waveform"] = "rbxassetid://86462036665209",
			["award"] = "rbxassetid://132740088158419",
			["axe"] = "rbxassetid://132405197863294",
			["axis-3d"] = "rbxassetid://122438676546804",
			["baby"] = "rbxassetid://93472926933440",
			["backpack"] = "rbxassetid://140420225386018",
			["badge"] = "rbxassetid://116620312917084",
			["badge-alert"] = "rbxassetid://101829200081951",
			["badge-cent"] = "rbxassetid://133345018873154",
			["badge-check"] = "rbxassetid://76078495178149",
			["badge-dollar-sign"] = "rbxassetid://127139803581141",
			["badge-euro"] = "rbxassetid://120016477674659",
			["badge-indian-rupee"] = "rbxassetid://75659682309981",
			["badge-info"] = "rbxassetid://131995373201472",
			["badge-japanese-yen"] = "rbxassetid://99081574588615",
			["badge-minus"] = "rbxassetid://140321561183881",
			["badge-percent"] = "rbxassetid://121359224294885",
			["badge-plus"] = "rbxassetid://100325578561866",
			["badge-pound-sterling"] = "rbxassetid://119688217279444",
			["badge-question-mark"] = "rbxassetid://121464963737502",
			["badge-russian-ruble"] = "rbxassetid://108839463659864",
			["badge-swiss-franc"] = "rbxassetid://91447608372740",
			["badge-turkish-lira"] = "rbxassetid://137839965873529",
			["badge-x"] = "rbxassetid://122931434733842",
			["baggage-claim"] = "rbxassetid://86922213051957",
			["balloon"] = "rbxassetid://97489111621526",
			["ban"] = "rbxassetid://90767043015246",
			["banana"] = "rbxassetid://140713420056179",
			["bandage"] = "rbxassetid://129660129590770",
			["banknote"] = "rbxassetid://104840231536668",
			["banknote-arrow-down"] = "rbxassetid://139366449345199",
			["banknote-arrow-up"] = "rbxassetid://133758343082529",
			["banknote-x"] = "rbxassetid://95348701438065",
			["barcode"] = "rbxassetid://118473018143689",
			["barrel"] = "rbxassetid://130647115622774",
			["baseline"] = "rbxassetid://124677132511270",
			["bath"] = "rbxassetid://76031400297942",
			["battery"] = "rbxassetid://70765800346189",
			["battery-charging"] = "rbxassetid://80139357470047",
			["battery-full"] = "rbxassetid://70906718268972",
			["battery-low"] = "rbxassetid://139659256984314",
			["battery-medium"] = "rbxassetid://105934079398915",
			["battery-plus"] = "rbxassetid://91931341486966",
			["battery-warning"] = "rbxassetid://115230083817257",
			["beaker"] = "rbxassetid://80902539995520",
			["bean"] = "rbxassetid://89491967076869",
			["bean-off"] = "rbxassetid://98164436608714",
			["bed"] = "rbxassetid://97726529032925",
			["bed-double"] = "rbxassetid://73820193212911",
			["bed-single"] = "rbxassetid://113423940880634",
			["beef"] = "rbxassetid://105850162318915",
			["beef-off"] = "rbxassetid://99869959725200",
			["beer"] = "rbxassetid://116404978807744",
			["beer-off"] = "rbxassetid://120333134736361",
			["bell"] = "rbxassetid://97392696311902",
			["bell-dot"] = "rbxassetid://93161277118810",
			["bell-electric"] = "rbxassetid://100277767266983",
			["bell-minus"] = "rbxassetid://126334890449727",
			["bell-off"] = "rbxassetid://78560046118930",
			["bell-plus"] = "rbxassetid://77014333795836",
			["bell-ring"] = "rbxassetid://94612128913941",
			["between-horizontal-end"] = "rbxassetid://81602774794322",
			["between-horizontal-start"] = "rbxassetid://76112384929846",
			["between-vertical-end"] = "rbxassetid://72817612571631",
			["between-vertical-start"] = "rbxassetid://85278312190301",
			["biceps-flexed"] = "rbxassetid://82004462003936",
			["bike"] = "rbxassetid://102930322246035",
			["binary"] = "rbxassetid://91751953950088",
			["binoculars"] = "rbxassetid://101460003267896",
			["biohazard"] = "rbxassetid://95956532900432",
			["bird"] = "rbxassetid://132284145117371",
			["birdhouse"] = "rbxassetid://83999157401433",
			["bitcoin"] = "rbxassetid://95459240442938",
			["blend"] = "rbxassetid://111679612185257",
			["blinds"] = "rbxassetid://71164165283925",
			["blocks"] = "rbxassetid://72212693357737",
			["bluetooth"] = "rbxassetid://90506573139443",
			["bluetooth-connected"] = "rbxassetid://96315134002985",
			["bluetooth-off"] = "rbxassetid://80600044218117",
			["bluetooth-searching"] = "rbxassetid://100673019606426",
			["bold"] = "rbxassetid://116141470019166",
			["bolt"] = "rbxassetid://102881251417484",
			["bomb"] = "rbxassetid://139223800924636",
			["bone"] = "rbxassetid://111242153474115",
			["book"] = "rbxassetid://125383279695672",
			["book-a"] = "rbxassetid://104067275658465",
			["book-alert"] = "rbxassetid://124159928044853",
			["book-audio"] = "rbxassetid://109208148317037",
			["book-check"] = "rbxassetid://115999656081696",
			["book-copy"] = "rbxassetid://108543407492005",
			["book-dashed"] = "rbxassetid://127430784795958",
			["book-down"] = "rbxassetid://101011730128222",
			["book-headphones"] = "rbxassetid://108670200799574",
			["book-heart"] = "rbxassetid://112788845135284",
			["book-image"] = "rbxassetid://80808285757226",
			["book-key"] = "rbxassetid://116024426170705",
			["book-lock"] = "rbxassetid://118765061220571",
			["book-marked"] = "rbxassetid://73211024251780",
			["book-minus"] = "rbxassetid://112724962046282",
			["book-open"] = "rbxassetid://129845326810392",
			["book-open-check"] = "rbxassetid://130848362492667",
			["book-open-text"] = "rbxassetid://100629528672195",
			["book-plus"] = "rbxassetid://140267785051233",
			["book-search"] = "rbxassetid://132585409504950",
			["book-text"] = "rbxassetid://94011772484232",
			["book-type"] = "rbxassetid://97817304725443",
			["book-up"] = "rbxassetid://98640174079190",
			["book-up-2"] = "rbxassetid://130161620853665",
			["book-user"] = "rbxassetid://128489189240523",
			["book-x"] = "rbxassetid://118754548186537",
			["bookmark"] = "rbxassetid://121093149326239",
			["bookmark-check"] = "rbxassetid://93940443347986",
			["bookmark-minus"] = "rbxassetid://96807096039910",
			["bookmark-plus"] = "rbxassetid://121469724491615",
			["bookmark-x"] = "rbxassetid://112272342584706",
			["boom-box"] = "rbxassetid://99901322535868",
			["bot"] = "rbxassetid://80451686744860",
			["bot-message-square"] = "rbxassetid://96145330292478",
			["bot-off"] = "rbxassetid://140417690560013",
			["bottle-wine"] = "rbxassetid://131675403196921",
			["bow-arrow"] = "rbxassetid://124089655150375",
			["box"] = "rbxassetid://101768155599700",
			["boxes"] = "rbxassetid://136372617578355",
			["braces"] = "rbxassetid://117761094704041",
			["brackets"] = "rbxassetid://74368995728099",
			["brain"] = "rbxassetid://92424107303177",
			["brain-circuit"] = "rbxassetid://70547962410202",
			["brain-cog"] = "rbxassetid://132039205501538",
			["brick-wall"] = "rbxassetid://112878522258821",
			["brick-wall-fire"] = "rbxassetid://92980588705520",
			["brick-wall-shield"] = "rbxassetid://75954432775071",
			["briefcase"] = "rbxassetid://96754188164225",
			["briefcase-business"] = "rbxassetid://129135125207283",
			["briefcase-conveyor-belt"] = "rbxassetid://108665725653714",
			["briefcase-medical"] = "rbxassetid://119917756334087",
			["bring-to-front"] = "rbxassetid://132975903553748",
			["brush"] = "rbxassetid://127035535799640",
			["brush-cleaning"] = "rbxassetid://71728977448805",
			["bubbles"] = "rbxassetid://106183424168227",
			["bug"] = "rbxassetid://83626408925438",
			["bug-off"] = "rbxassetid://88020025049245",
			["bug-play"] = "rbxassetid://80107955888092",
			["building"] = "rbxassetid://110616258983082",
			["building-2"] = "rbxassetid://77873775611951",
			["bus"] = "rbxassetid://133798469717463",
			["bus-front"] = "rbxassetid://89863432456045",
			["cable"] = "rbxassetid://128449944504901",
			["cable-car"] = "rbxassetid://128643682205596",
			["cake"] = "rbxassetid://103131590503275",
			["cake-slice"] = "rbxassetid://136769828413242",
			["calculator"] = "rbxassetid://74915716529646",
			["calendar"] = "rbxassetid://114792700814035",
			["calendar-1"] = "rbxassetid://98458364171044",
			["calendar-arrow-down"] = "rbxassetid://108415736543437",
			["calendar-arrow-up"] = "rbxassetid://70574654109118",
			["calendar-check"] = "rbxassetid://71551019465748",
			["calendar-check-2"] = "rbxassetid://120231170248276",
			["calendar-clock"] = "rbxassetid://119132152594595",
			["calendar-cog"] = "rbxassetid://122402172360287",
			["calendar-days"] = "rbxassetid://99072017568595",
			["calendar-fold"] = "rbxassetid://117368871270394",
			["calendar-heart"] = "rbxassetid://88839008103676",
			["calendar-minus"] = "rbxassetid://137354318924383",
			["calendar-minus-2"] = "rbxassetid://98846170279891",
			["calendar-off"] = "rbxassetid://109726151749217",
			["calendar-plus"] = "rbxassetid://125266115249843",
			["calendar-plus-2"] = "rbxassetid://112264562093883",
			["calendar-range"] = "rbxassetid://103641849247576",
			["calendar-search"] = "rbxassetid://92010083223634",
			["calendar-sync"] = "rbxassetid://78082218499697",
			["calendar-x"] = "rbxassetid://106703374806500",
			["calendar-x-2"] = "rbxassetid://107518051061147",
			["calendars"] = "rbxassetid://130944763042289",
			["camera"] = "rbxassetid://79950339943067",
			["camera-off"] = "rbxassetid://81057636835256",
			["candy"] = "rbxassetid://107812129154678",
			["candy-cane"] = "rbxassetid://71689468772492",
			["candy-off"] = "rbxassetid://110232752314832",
			["cannabis"] = "rbxassetid://98792006538601",
			["cannabis-off"] = "rbxassetid://101938500363812",
			["captions"] = "rbxassetid://104960225031445",
			["captions-off"] = "rbxassetid://105223545364193",
			["car"] = "rbxassetid://121065933462582",
			["car-front"] = "rbxassetid://87380942739063",
			["car-taxi-front"] = "rbxassetid://122455403384057",
			["caravan"] = "rbxassetid://120070979471783",
			["card-sim"] = "rbxassetid://134490550095771",
			["carrot"] = "rbxassetid://119118221444304",
			["case-lower"] = "rbxassetid://129303130603241",
			["case-sensitive"] = "rbxassetid://125410273293056",
			["case-upper"] = "rbxassetid://111633433531325",
			["cassette-tape"] = "rbxassetid://137065788934157",
			["cast"] = "rbxassetid://98202245922071",
			["castle"] = "rbxassetid://119275077187784",
			["cat"] = "rbxassetid://124252153404931",
			["cctv"] = "rbxassetid://99979894766624",
			["cctv-off"] = "rbxassetid://75925370187295",
			["chart-area"] = "rbxassetid://123446436762366",
			["chart-bar"] = "rbxassetid://105389816384108",
			["chart-bar-big"] = "rbxassetid://72336824986044",
			["chart-bar-decreasing"] = "rbxassetid://107217459044963",
			["chart-bar-increasing"] = "rbxassetid://88268905998571",
			["chart-bar-stacked"] = "rbxassetid://98478751113024",
			["chart-candlestick"] = "rbxassetid://125676898615697",
			["chart-column"] = "rbxassetid://97915995538580",
			["chart-column-big"] = "rbxassetid://98598733210787",
			["chart-column-decreasing"] = "rbxassetid://73586137373563",
			["chart-column-increasing"] = "rbxassetid://120421615068601",
			["chart-column-stacked"] = "rbxassetid://86031449675105",
			["chart-gantt"] = "rbxassetid://88811660555940",
			["chart-line"] = "rbxassetid://101833156055618",
			["chart-network"] = "rbxassetid://104027882693561",
			["chart-no-axes-column"] = "rbxassetid://94078751170351",
			["chart-no-axes-column-decreasing"] = "rbxassetid://123371717192542",
			["chart-no-axes-column-increasing"] = "rbxassetid://140383830943049",
			["chart-no-axes-combined"] = "rbxassetid://121424233161912",
			["chart-no-axes-gantt"] = "rbxassetid://131936541106368",
			["chart-pie"] = "rbxassetid://113412261630136",
			["chart-scatter"] = "rbxassetid://108217585014571",
			["chart-spline"] = "rbxassetid://90307460742494",
			["check"] = "rbxassetid://93898873302694",
			["check-check"] = "rbxassetid://95183312173858",
			["check-line"] = "rbxassetid://115122343485290",
			["chef-hat"] = "rbxassetid://121744015002573",
			["cherry"] = "rbxassetid://139519182403183",
			["chess-bishop"] = "rbxassetid://121701705580238",
			["chess-king"] = "rbxassetid://90885687223462",
			["chess-knight"] = "rbxassetid://96467707042169",
			["chess-pawn"] = "rbxassetid://111318574652751",
			["chess-queen"] = "rbxassetid://98304702099749",
			["chess-rook"] = "rbxassetid://76223925830262",
			["chevron-down"] = "rbxassetid://134243273101015",
			["chevron-first"] = "rbxassetid://105243363790238",
			["chevron-last"] = "rbxassetid://89268452603731",
			["chevron-left"] = "rbxassetid://73780377692148",
			["chevron-right"] = "rbxassetid://92473583511724",
			["chevron-up"] = "rbxassetid://122444883127455",
			["chevrons-down"] = "rbxassetid://100524612205956",
			["chevrons-down-up"] = "rbxassetid://139404716013205",
			["chevrons-left"] = "rbxassetid://82617201744347",
			["chevrons-left-right"] = "rbxassetid://87910685945204",
			["chevrons-left-right-ellipsis"] = "rbxassetid://125035817741526",
			["chevrons-right"] = "rbxassetid://139121276490483",
			["chevrons-right-left"] = "rbxassetid://87149546686569",
			["chevrons-up"] = "rbxassetid://100467452364672",
			["chevrons-up-down"] = "rbxassetid://131833120209646",
			["chromium"] = "rbxassetid://128165143739006",
			["church"] = "rbxassetid://113714744350666",
			["cigarette"] = "rbxassetid://137149549886852",
			["cigarette-off"] = "rbxassetid://77797883078452",
			["circle"] = "rbxassetid://130359823580534",
			["circle-alert"] = "rbxassetid://83898160590116",
			["circle-arrow-down"] = "rbxassetid://95901860261344",
			["circle-arrow-left"] = "rbxassetid://102148876968988",
			["circle-arrow-out-down-left"] = "rbxassetid://140598097856694",
			["circle-arrow-out-down-right"] = "rbxassetid://119952801379305",
			["circle-arrow-out-up-left"] = "rbxassetid://132858212688303",
			["circle-arrow-out-up-right"] = "rbxassetid://81783743753173",
			["circle-arrow-right"] = "rbxassetid://70786767999559",
			["circle-arrow-up"] = "rbxassetid://84395128546494",
			["circle-check"] = "rbxassetid://85262178816537",
			["circle-check-big"] = "rbxassetid://93202927221730",
			["circle-chevron-down"] = "rbxassetid://137069490345718",
			["circle-chevron-left"] = "rbxassetid://130250009740827",
			["circle-chevron-right"] = "rbxassetid://125943696958495",
			["circle-chevron-up"] = "rbxassetid://111223574026321",
			["circle-dashed"] = "rbxassetid://126799443883746",
			["circle-divide"] = "rbxassetid://106398997754208",
			["circle-dollar-sign"] = "rbxassetid://91106238890387",
			["circle-dot"] = "rbxassetid://82947033619201",
			["circle-dot-dashed"] = "rbxassetid://111451232827180",
			["circle-ellipsis"] = "rbxassetid://91687150884779",
			["circle-equal"] = "rbxassetid://95133963751438",
			["circle-fading-arrow-up"] = "rbxassetid://104648212910336",
			["circle-fading-plus"] = "rbxassetid://91847890443490",
			["circle-gauge"] = "rbxassetid://108157549473765",
			["circle-minus"] = "rbxassetid://133556159576809",
			["circle-off"] = "rbxassetid://97923456918886",
			["circle-parking"] = "rbxassetid://124034962915196",
			["circle-parking-off"] = "rbxassetid://128369410981252",
			["circle-pause"] = "rbxassetid://139337739700879",
			["circle-percent"] = "rbxassetid://133311912860256",
			["circle-pile"] = "rbxassetid://116353155251541",
			["circle-play"] = "rbxassetid://120408917249739",
			["circle-plus"] = "rbxassetid://113157136350384",
			["circle-pound-sterling"] = "rbxassetid://105476153083828",
			["circle-power"] = "rbxassetid://140676030155098",
			["circle-question-mark"] = "rbxassetid://97516698664325",
			["circle-slash"] = "rbxassetid://125206439913049",
			["circle-slash-2"] = "rbxassetid://136766902186549",
			["circle-small"] = "rbxassetid://73685402843600",
			["circle-star"] = "rbxassetid://120318414957104",
			["circle-stop"] = "rbxassetid://87400503942659",
			["circle-user"] = "rbxassetid://136220511671311",
			["circle-user-round"] = "rbxassetid://95489465399880",
			["circle-x"] = "rbxassetid://76821953846248",
			["circuit-board"] = "rbxassetid://107695264369312",
			["citrus"] = "rbxassetid://139018222976433",
			["clapperboard"] = "rbxassetid://132660667070200",
			["clipboard"] = "rbxassetid://89601995828423",
			["clipboard-check"] = "rbxassetid://92649798577170",
			["clipboard-clock"] = "rbxassetid://123957515687745",
			["clipboard-copy"] = "rbxassetid://125851897718493",
			["clipboard-list"] = "rbxassetid://96460215958908",
			["clipboard-minus"] = "rbxassetid://107968008485671",
			["clipboard-paste"] = "rbxassetid://74382068849983",
			["clipboard-pen"] = "rbxassetid://75290966822953",
			["clipboard-pen-line"] = "rbxassetid://77711589791615",
			["clipboard-plus"] = "rbxassetid://134285318675662",
			["clipboard-type"] = "rbxassetid://89949374318028",
			["clipboard-x"] = "rbxassetid://102222456890103",
			["clock"] = "rbxassetid://121808839832144",
			["clock-1"] = "rbxassetid://129363225422045",
			["clock-10"] = "rbxassetid://104332695855541",
			["clock-11"] = "rbxassetid://119023205186105",
			["clock-12"] = "rbxassetid://117789618723068",
			["clock-2"] = "rbxassetid://134710777209413",
			["clock-3"] = "rbxassetid://136385631189327",
			["clock-4"] = "rbxassetid://121808839832144",
			["clock-5"] = "rbxassetid://85082019959457",
			["clock-6"] = "rbxassetid://71009733505593",
			["clock-7"] = "rbxassetid://103111188546225",
			["clock-8"] = "rbxassetid://110059272125337",
			["clock-9"] = "rbxassetid://77610027126437",
			["clock-alert"] = "rbxassetid://97157344465162",
			["clock-arrow-down"] = "rbxassetid://92349314416042",
			["clock-arrow-up"] = "rbxassetid://111484286332629",
			["clock-check"] = "rbxassetid://85231630218857",
			["clock-fading"] = "rbxassetid://93205297285245",
			["clock-plus"] = "rbxassetid://93367709263150",
			["closed-caption"] = "rbxassetid://99832644030788",
			["cloud"] = "rbxassetid://121226497050352",
			["cloud-alert"] = "rbxassetid://91967273658626",
			["cloud-backup"] = "rbxassetid://111649579696132",
			["cloud-check"] = "rbxassetid://97318598202432",
			["cloud-cog"] = "rbxassetid://96497764065749",
			["cloud-download"] = "rbxassetid://121435581993566",
			["cloud-drizzle"] = "rbxassetid://139525315752605",
			["cloud-fog"] = "rbxassetid://76650233148776",
			["cloud-hail"] = "rbxassetid://72320462748242",
			["cloud-lightning"] = "rbxassetid://133517088924849",
			["cloud-moon"] = "rbxassetid://71938114737914",
			["cloud-moon-rain"] = "rbxassetid://127667837827018",
			["cloud-off"] = "rbxassetid://131907154501444",
			["cloud-rain"] = "rbxassetid://105547081967408",
			["cloud-rain-wind"] = "rbxassetid://107414583736721",
			["cloud-snow"] = "rbxassetid://72307126270226",
			["cloud-sun"] = "rbxassetid://86114208148727",
			["cloud-sun-rain"] = "rbxassetid://99041604425705",
			["cloud-sync"] = "rbxassetid://79393911188593",
			["cloud-upload"] = "rbxassetid://93307473217005",
			["cloudy"] = "rbxassetid://105360479023346",
			["clover"] = "rbxassetid://74925550436750",
			["club"] = "rbxassetid://108490365816628",
			["code"] = "rbxassetid://107380207681249",
			["code-xml"] = "rbxassetid://130150477351734",
			["codepen"] = "rbxassetid://135643965971885",
			["codesandbox"] = "rbxassetid://106911852964823",
			["coffee"] = "rbxassetid://106864403231093",
			["cog"] = "rbxassetid://116544501716299",
			["coins"] = "rbxassetid://116510979641930",
			["columns-2"] = "rbxassetid://113004100221850",
			["columns-3"] = "rbxassetid://115223357399375",
			["columns-3-cog"] = "rbxassetid://121589691981064",
			["columns-4"] = "rbxassetid://130807991968419",
			["combine"] = "rbxassetid://79908476334048",
			["command"] = "rbxassetid://93648221906330",
			["compass"] = "rbxassetid://115123411028382",
			["component"] = "rbxassetid://110027788875080",
			["computer"] = "rbxassetid://77480056459407",
			["concierge-bell"] = "rbxassetid://140384259310436",
			["cone"] = "rbxassetid://97759550688437",
			["construction"] = "rbxassetid://106539489968173",
			["contact"] = "rbxassetid://75868297719012",
			["contact-round"] = "rbxassetid://71907624112229",
			["container"] = "rbxassetid://91507237573499",
			["contrast"] = "rbxassetid://112796643981497",
			["cookie"] = "rbxassetid://73159504540002",
			["cooking-pot"] = "rbxassetid://94959783129799",
			["copy"] = "rbxassetid://78979572434545",
			["copy-check"] = "rbxassetid://91177247988892",
			["copy-minus"] = "rbxassetid://109524509933035",
			["copy-plus"] = "rbxassetid://113618379616952",
			["copy-slash"] = "rbxassetid://93805787810390",
			["copy-x"] = "rbxassetid://106557557978061",
			["copyleft"] = "rbxassetid://78559055698593",
			["copyright"] = "rbxassetid://129433635747111",
			["corner-down-left"] = "rbxassetid://90473561177832",
			["corner-down-right"] = "rbxassetid://86512767702085",
			["corner-left-down"] = "rbxassetid://139876989150630",
			["corner-left-up"] = "rbxassetid://126228268096099",
			["corner-right-down"] = "rbxassetid://89237035551302",
			["corner-right-up"] = "rbxassetid://112851237026705",
			["corner-up-left"] = "rbxassetid://84669279763024",
			["corner-up-right"] = "rbxassetid://115099889693145",
			["cpu"] = "rbxassetid://77549309870247",
			["creative-commons"] = "rbxassetid://90408210735312",
			["credit-card"] = "rbxassetid://99163352872346",
			["croissant"] = "rbxassetid://130710485559420",
			["crop"] = "rbxassetid://116344601101413",
			["cross"] = "rbxassetid://101833377863588",
			["crosshair"] = "rbxassetid://134242818164054",
			["crown"] = "rbxassetid://127843403295538",
			["cuboid"] = "rbxassetid://75618807946111",
			["cup-soda"] = "rbxassetid://121098640829562",
			["currency"] = "rbxassetid://90551250119972",
			["cylinder"] = "rbxassetid://90569677179169",
			["dam"] = "rbxassetid://76874486231393",
			["database"] = "rbxassetid://126791525623846",
			["database-backup"] = "rbxassetid://103403210984699",
			["database-search"] = "rbxassetid://92017137080138",
			["database-zap"] = "rbxassetid://131199921258418",
			["decimals-arrow-left"] = "rbxassetid://120198500638749",
			["decimals-arrow-right"] = "rbxassetid://118263047146797",
			["delete"] = "rbxassetid://126279426372342",
			["dessert"] = "rbxassetid://71508133278830",
			["diameter"] = "rbxassetid://97429051503783",
			["diamond"] = "rbxassetid://105846996304890",
			["diamond-minus"] = "rbxassetid://128989071438290",
			["diamond-percent"] = "rbxassetid://107717860105959",
			["diamond-plus"] = "rbxassetid://134701163723675",
			["dice-1"] = "rbxassetid://112650149591038",
			["dice-2"] = "rbxassetid://112278274566793",
			["dice-3"] = "rbxassetid://118526270626312",
			["dice-4"] = "rbxassetid://113365650364004",
			["dice-5"] = "rbxassetid://72768312430593",
			["dice-6"] = "rbxassetid://85376239182543",
			["dices"] = "rbxassetid://81268120302865",
			["diff"] = "rbxassetid://135052708609715",
			["disc"] = "rbxassetid://101908120120777",
			["disc-2"] = "rbxassetid://91419420404185",
			["disc-3"] = "rbxassetid://135470554736048",
			["disc-album"] = "rbxassetid://74693460404344",
			["divide"] = "rbxassetid://136678191878278",
			["dna"] = "rbxassetid://74007982981741",
			["dna-off"] = "rbxassetid://89612426361540",
			["dock"] = "rbxassetid://121997427160252",
			["dog"] = "rbxassetid://71920105558570",
			["dollar-sign"] = "rbxassetid://127320961224019",
			["donut"] = "rbxassetid://72204922742657",
			["door-closed"] = "rbxassetid://136249099949073",
			["door-closed-locked"] = "rbxassetid://74027613267551",
			["door-open"] = "rbxassetid://91306356501736",
			["dot"] = "rbxassetid://137321056643916",
			["download"] = "rbxassetid://134814648082393",
			["drafting-compass"] = "rbxassetid://99701976182841",
			["drama"] = "rbxassetid://110297795801577",
			["dribbble"] = "rbxassetid://80231809663849",
			["drill"] = "rbxassetid://108644821412796",
			["drone"] = "rbxassetid://117299095794783",
			["droplet"] = "rbxassetid://100597455015098",
			["droplet-off"] = "rbxassetid://119365002225172",
			["droplets"] = "rbxassetid://140111846025180",
			["drum"] = "rbxassetid://136979060344890",
			["drumstick"] = "rbxassetid://104662462521709",
			["dumbbell"] = "rbxassetid://80277236776212",
			["ear"] = "rbxassetid://121894949934209",
			["ear-off"] = "rbxassetid://87421916192807",
			["earth"] = "rbxassetid://76231597751076",
			["earth-lock"] = "rbxassetid://88814147073745",
			["eclipse"] = "rbxassetid://114829622118222",
			["egg"] = "rbxassetid://117851493400222",
			["egg-fried"] = "rbxassetid://90622538210545",
			["egg-off"] = "rbxassetid://92288321309285",
			["ellipse"] = "rbxassetid://71559658267482",
			["ellipsis"] = "rbxassetid://140019550645825",
			["ellipsis-vertical"] = "rbxassetid://117978708573781",
			["equal"] = "rbxassetid://123467780715624",
			["equal-approximately"] = "rbxassetid://105382689698323",
			["equal-not"] = "rbxassetid://76864449458032",
			["eraser"] = "rbxassetid://133957773112410",
			["ethernet-port"] = "rbxassetid://75391715149314",
			["euro"] = "rbxassetid://72229646524456",
			["ev-charger"] = "rbxassetid://97906158859623",
			["expand"] = "rbxassetid://137492887754537",
			["external-link"] = "rbxassetid://129331830773832",
			["eye"] = "rbxassetid://100033680381365",
			["eye-closed"] = "rbxassetid://111063268625789",
			["eye-off"] = "rbxassetid://135928786788378",
			["facebook"] = "rbxassetid://72098528632192",
			["factory"] = "rbxassetid://102170024318039",
			["fan"] = "rbxassetid://78391400440696",
			["fast-forward"] = "rbxassetid://121615540167909",
			["feather"] = "rbxassetid://91872927606406",
			["fence"] = "rbxassetid://123451565578029",
			["ferris-wheel"] = "rbxassetid://79729205796176",
			["figma"] = "rbxassetid://134182122852301",
			["file"] = "rbxassetid://74748492079329",
			["file-archive"] = "rbxassetid://77018106869967",
			["file-axis-3d"] = "rbxassetid://133912328009885",
			["file-badge"] = "rbxassetid://74564895394477",
			["file-box"] = "rbxassetid://119264004071690",
			["file-braces"] = "rbxassetid://95314128621234",
			["file-braces-corner"] = "rbxassetid://77253337986109",
			["file-chart-column"] = "rbxassetid://82048481252560",
			["file-chart-column-increasing"] = "rbxassetid://134449481172067",
			["file-chart-line"] = "rbxassetid://71954360551345",
			["file-chart-pie"] = "rbxassetid://81072193564497",
			["file-check"] = "rbxassetid://82604001452455",
			["file-check-corner"] = "rbxassetid://76295552859171",
			["file-clock"] = "rbxassetid://102325208830990",
			["file-code"] = "rbxassetid://130978036895504",
			["file-code-corner"] = "rbxassetid://78293841184371",
			["file-cog"] = "rbxassetid://101385347151368",
			["file-diff"] = "rbxassetid://96147216772241",
			["file-digit"] = "rbxassetid://89220220354580",
			["file-down"] = "rbxassetid://120650154178290",
			["file-exclamation-point"] = "rbxassetid://102821865889635",
			["file-headphone"] = "rbxassetid://100533735901986",
			["file-heart"] = "rbxassetid://132214916401696",
			["file-image"] = "rbxassetid://123334057511782",
			["file-input"] = "rbxassetid://124728604166044",
			["file-key"] = "rbxassetid://118790255921100",
			["file-lock"] = "rbxassetid://72170228691242",
			["file-minus"] = "rbxassetid://111014798459222",
			["file-minus-corner"] = "rbxassetid://119263271735124",
			["file-music"] = "rbxassetid://134948051536671",
			["file-output"] = "rbxassetid://92146832572911",
			["file-pen"] = "rbxassetid://79556179730240",
			["file-pen-line"] = "rbxassetid://104622936345006",
			["file-play"] = "rbxassetid://89006821567838",
			["file-plus"] = "rbxassetid://78881710800060",
			["file-plus-corner"] = "rbxassetid://76544604043974",
			["file-question-mark"] = "rbxassetid://127617422859576",
			["file-scan"] = "rbxassetid://129480105228213",
			["file-search"] = "rbxassetid://97780235974933",
			["file-search-corner"] = "rbxassetid://90974165234008",
			["file-signal"] = "rbxassetid://122070252538165",
			["file-sliders"] = "rbxassetid://85787771732439",
			["file-spreadsheet"] = "rbxassetid://134501869359270",
			["file-stack"] = "rbxassetid://138929929862605",
			["file-symlink"] = "rbxassetid://91865722036510",
			["file-terminal"] = "rbxassetid://116757454755476",
			["file-text"] = "rbxassetid://90496405707281",
			["file-type"] = "rbxassetid://115272552799361",
			["file-type-corner"] = "rbxassetid://124902230275209",
			["file-up"] = "rbxassetid://131173039312748",
			["file-user"] = "rbxassetid://99552018455009",
			["file-video-camera"] = "rbxassetid://81719056173960",
			["file-volume"] = "rbxassetid://111264764438958",
			["file-x"] = "rbxassetid://107333775515154",
			["file-x-corner"] = "rbxassetid://87554136773609",
			["files"] = "rbxassetid://102806336233202",
			["film"] = "rbxassetid://120978945609706",
			["fingerprint"] = "rbxassetid://112173305232811",
			["fingerprint-pattern"] = "rbxassetid://80934710831288",
			["fire-extinguisher"] = "rbxassetid://111643493006960",
			["fish"] = "rbxassetid://124360663785796",
			["fish-off"] = "rbxassetid://89756724887508",
			["fish-symbol"] = "rbxassetid://118475177681618",
			["fishing-hook"] = "rbxassetid://121038780855899",
			["fishing-rod"] = "rbxassetid://71754848048049",
			["flag"] = "rbxassetid://78183383236196",
			["flag-off"] = "rbxassetid://112944528856799",
			["flag-triangle-left"] = "rbxassetid://88045221285272",
			["flag-triangle-right"] = "rbxassetid://108292480304566",
			["flame"] = "rbxassetid://98218034436456",
			["flame-kindling"] = "rbxassetid://139728976917928",
			["flashlight"] = "rbxassetid://100286985600444",
			["flashlight-off"] = "rbxassetid://79780362871740",
			["flask-conical"] = "rbxassetid://128406680901165",
			["flask-conical-off"] = "rbxassetid://112597970025298",
			["flask-round"] = "rbxassetid://127508287324940",
			["flip-horizontal"] = "rbxassetid://122937530107837",
			["flip-horizontal-2"] = "rbxassetid://103726993598186",
			["flip-vertical"] = "rbxassetid://108003917346888",
			["flip-vertical-2"] = "rbxassetid://103836358956328",
			["flower"] = "rbxassetid://86129438272762",
			["flower-2"] = "rbxassetid://72934574245145",
			["focus"] = "rbxassetid://87493973153317",
			["fold-horizontal"] = "rbxassetid://92835712442240",
			["fold-vertical"] = "rbxassetid://108873727253656",
			["folder"] = "rbxassetid://80846616596607",
			["folder-archive"] = "rbxassetid://97312009460206",
			["folder-check"] = "rbxassetid://128492920904557",
			["folder-clock"] = "rbxassetid://111964836738545",
			["folder-closed"] = "rbxassetid://118286209350843",
			["folder-code"] = "rbxassetid://70624096349370",
			["folder-cog"] = "rbxassetid://85299519462846",
			["folder-dot"] = "rbxassetid://138687772725278",
			["folder-down"] = "rbxassetid://118044108459225",
			["folder-git"] = "rbxassetid://121885778095158",
			["folder-git-2"] = "rbxassetid://101394054141166",
			["folder-heart"] = "rbxassetid://79104747211105",
			["folder-input"] = "rbxassetid://90699920697871",
			["folder-kanban"] = "rbxassetid://78313285104072",
			["folder-key"] = "rbxassetid://85270407596791",
			["folder-lock"] = "rbxassetid://119201572260567",
			["folder-minus"] = "rbxassetid://85648718999010",
			["folder-open"] = "rbxassetid://76018996254888",
			["folder-open-dot"] = "rbxassetid://74741494767354",
			["folder-output"] = "rbxassetid://101532447937612",
			["folder-pen"] = "rbxassetid://112770491173911",
			["folder-plus"] = "rbxassetid://91865663406119",
			["folder-root"] = "rbxassetid://103333751154693",
			["folder-search"] = "rbxassetid://110568075123861",
			["folder-search-2"] = "rbxassetid://71276453442655",
			["folder-symlink"] = "rbxassetid://127485747227189",
			["folder-sync"] = "rbxassetid://91544602659796",
			["folder-tree"] = "rbxassetid://85577554337861",
			["folder-up"] = "rbxassetid://72008269765857",
			["folder-x"] = "rbxassetid://91699618247635",
			["folders"] = "rbxassetid://110351216219061",
			["footprints"] = "rbxassetid://139192589041315",
			["forklift"] = "rbxassetid://72030930983101",
			["form"] = "rbxassetid://72999643971000",
			["forward"] = "rbxassetid://97545944739523",
			["frame"] = "rbxassetid://109080612832751",
			["framer"] = "rbxassetid://108384807262391",
			["frown"] = "rbxassetid://124407301067982",
			["fuel"] = "rbxassetid://106447647274511",
			["fullscreen"] = "rbxassetid://77793665526178",
			["funnel"] = "rbxassetid://108829540827529",
			["funnel-plus"] = "rbxassetid://100780233821928",
			["funnel-x"] = "rbxassetid://70984385812555",
			["gallery-horizontal"] = "rbxassetid://80004001442122",
			["gallery-horizontal-end"] = "rbxassetid://74672430161161",
			["gallery-thumbnails"] = "rbxassetid://136219289862706",
			["gallery-vertical"] = "rbxassetid://119299431466725",
			["gallery-vertical-end"] = "rbxassetid://106461402088317",
			["gamepad"] = "rbxassetid://121607283959010",
			["gamepad-2"] = "rbxassetid://92483947987410",
			["gamepad-directional"] = "rbxassetid://84342305212226",
			["gauge"] = "rbxassetid://110273524101447",
			["gavel"] = "rbxassetid://78952298198456",
			["gem"] = "rbxassetid://112904952151156",
			["georgian-lari"] = "rbxassetid://98084432591687",
			["ghost"] = "rbxassetid://113822048130017",
			["gift"] = "rbxassetid://109855212076373",
			["git-branch"] = "rbxassetid://90490195516649",
			["git-branch-minus"] = "rbxassetid://97385010649411",
			["git-branch-plus"] = "rbxassetid://125944221134316",
			["git-commit-horizontal"] = "rbxassetid://133646041800147",
			["git-commit-vertical"] = "rbxassetid://122098032990350",
			["git-compare"] = "rbxassetid://91945124438792",
			["git-compare-arrows"] = "rbxassetid://84874426520216",
			["git-fork"] = "rbxassetid://89954992404765",
			["git-graph"] = "rbxassetid://86166832019304",
			["git-merge"] = "rbxassetid://131833355158059",
			["git-merge-conflict"] = "rbxassetid://85677801675703",
			["git-pull-request"] = "rbxassetid://138463010991471",
			["git-pull-request-arrow"] = "rbxassetid://94507974577439",
			["git-pull-request-closed"] = "rbxassetid://78070600389091",
			["git-pull-request-create"] = "rbxassetid://105929577383926",
			["git-pull-request-create-arrow"] = "rbxassetid://127422677061091",
			["git-pull-request-draft"] = "rbxassetid://76173459869943",
			["github"] = "rbxassetid://120349554354380",
			["gitlab"] = "rbxassetid://114054627192933",
			["glass-water"] = "rbxassetid://115526102400988",
			["glasses"] = "rbxassetid://87936407455373",
			["globe"] = "rbxassetid://114238209622913",
			["globe-lock"] = "rbxassetid://134065526704402",
			["globe-off"] = "rbxassetid://77775243585824",
			["globe-x"] = "rbxassetid://109268097029296",
			["goal"] = "rbxassetid://120517954878160",
			["gpu"] = "rbxassetid://95577823614219",
			["graduation-cap"] = "rbxassetid://93771896340220",
			["grape"] = "rbxassetid://134760640415561",
			["grid-2x2"] = "rbxassetid://99050491897640",
			["grid-2x2-check"] = "rbxassetid://138468840220821",
			["grid-2x2-plus"] = "rbxassetid://91811610580247",
			["grid-2x2-x"] = "rbxassetid://72407303981388",
			["grid-3x2"] = "rbxassetid://95528684210010",
			["grid-3x3"] = "rbxassetid://70419024781206",
			["grip"] = "rbxassetid://109058783556768",
			["grip-horizontal"] = "rbxassetid://136255899715930",
			["grip-vertical"] = "rbxassetid://137183678565296",
			["group"] = "rbxassetid://107643418926671",
			["guitar"] = "rbxassetid://75915531867926",
			["ham"] = "rbxassetid://74465607934635",
			["hamburger"] = "rbxassetid://93086916815495",
			["hammer"] = "rbxassetid://83545120140895",
			["hand"] = "rbxassetid://130703864968637",
			["hand-coins"] = "rbxassetid://126990543175462",
			["hand-fist"] = "rbxassetid://83341608917591",
			["hand-grab"] = "rbxassetid://88867162163985",
			["hand-heart"] = "rbxassetid://117507367668412",
			["hand-helping"] = "rbxassetid://89897738419446",
			["hand-metal"] = "rbxassetid://113619498548713",
			["hand-platter"] = "rbxassetid://88594727743168",
			["handbag"] = "rbxassetid://135675846264061",
			["handshake"] = "rbxassetid://78442115255814",
			["hard-drive"] = "rbxassetid://88183305858463",
			["hard-drive-download"] = "rbxassetid://73913801230614",
			["hard-drive-upload"] = "rbxassetid://85762133615118",
			["hard-hat"] = "rbxassetid://128050846767382",
			["hash"] = "rbxassetid://82890331678520",
			["hat-glasses"] = "rbxassetid://101165538224815",
			["haze"] = "rbxassetid://108857561768901",
			["hd"] = "rbxassetid://71682790698278",
			["hdmi-port"] = "rbxassetid://103693661037020",
			["heading"] = "rbxassetid://129254312067735",
			["heading-1"] = "rbxassetid://118129315662110",
			["heading-2"] = "rbxassetid://110209069670094",
			["heading-3"] = "rbxassetid://90267885237062",
			["heading-4"] = "rbxassetid://129625620307602",
			["heading-5"] = "rbxassetid://120386663181267",
			["heading-6"] = "rbxassetid://90959079775093",
			["headphone-off"] = "rbxassetid://85038251615641",
			["headphones"] = "rbxassetid://118833729589183",
			["headset"] = "rbxassetid://129269236787694",
			["heart"] = "rbxassetid://116559368303288",
			["heart-crack"] = "rbxassetid://110987638564119",
			["heart-handshake"] = "rbxassetid://111483078692002",
			["heart-minus"] = "rbxassetid://96827380163326",
			["heart-off"] = "rbxassetid://89748414415617",
			["heart-plus"] = "rbxassetid://94877796283249",
			["heart-pulse"] = "rbxassetid://129352925579546",
			["heater"] = "rbxassetid://140478466880916",
			["helicopter"] = "rbxassetid://111557171735930",
			["hexagon"] = "rbxassetid://127592089339199",
			["highlighter"] = "rbxassetid://77411555641113",
			["history"] = "rbxassetid://123980022019922",
			["hop"] = "rbxassetid://82778923997672",
			["hop-off"] = "rbxassetid://103386036934034",
			["hospital"] = "rbxassetid://105868763850707",
			["hotel"] = "rbxassetid://132283390859718",
			["hourglass"] = "rbxassetid://86160434939203",
			["house"] = "rbxassetid://98755624629571",
			["house-heart"] = "rbxassetid://136054771868597",
			["house-plug"] = "rbxassetid://71438263712075",
			["house-plus"] = "rbxassetid://118495165208309",
			["house-wifi"] = "rbxassetid://126495519725698",
			["ice-cream-bowl"] = "rbxassetid://124867218454386",
			["ice-cream-cone"] = "rbxassetid://90751397288639",
			["id-card"] = "rbxassetid://75354294622640",
			["id-card-lanyard"] = "rbxassetid://90761480469224",
			["image"] = "rbxassetid://112751259236831",
			["image-down"] = "rbxassetid://78972295741235",
			["image-minus"] = "rbxassetid://101066016918565",
			["image-off"] = "rbxassetid://81934811700938",
			["image-play"] = "rbxassetid://129501806784210",
			["image-plus"] = "rbxassetid://70391970623917",
			["image-up"] = "rbxassetid://126610009605241",
			["image-upscale"] = "rbxassetid://106963545024679",
			["images"] = "rbxassetid://79350649395557",
			["import"] = "rbxassetid://116545008906029",
			["inbox"] = "rbxassetid://112591360302868",
			["indian-rupee"] = "rbxassetid://113038778381805",
			["infinity"] = "rbxassetid://98083086936965",
			["info"] = "rbxassetid://124560466474914",
			["inspection-panel"] = "rbxassetid://70905313146088",
			["instagram"] = "rbxassetid://119864798614855",
			["italic"] = "rbxassetid://96220378864282",
			["iteration-ccw"] = "rbxassetid://140221832794083",
			["iteration-cw"] = "rbxassetid://95534489554662",
			["japanese-yen"] = "rbxassetid://106362863465813",
			["joystick"] = "rbxassetid://99416790224739",
			["kanban"] = "rbxassetid://125934100055431",
			["kayak"] = "rbxassetid://136107544609389",
			["key"] = "rbxassetid://96510194465420",
			["key-round"] = "rbxassetid://83619031955390",
			["key-square"] = "rbxassetid://94621420033649",
			["keyboard"] = "rbxassetid://121474456068237",
			["keyboard-music"] = "rbxassetid://121058541758636",
			["keyboard-off"] = "rbxassetid://92466375369772",
			["lamp"] = "rbxassetid://110730830653382",
			["lamp-ceiling"] = "rbxassetid://80032758469141",
			["lamp-desk"] = "rbxassetid://85290686983238",
			["lamp-floor"] = "rbxassetid://104585881375892",
			["lamp-wall-down"] = "rbxassetid://91271394132073",
			["lamp-wall-up"] = "rbxassetid://132141464337445",
			["land-plot"] = "rbxassetid://96449039620294",
			["landmark"] = "rbxassetid://76885079756393",
			["languages"] = "rbxassetid://90816903776498",
			["laptop"] = "rbxassetid://111387063244975",
			["laptop-minimal"] = "rbxassetid://136705765566068",
			["laptop-minimal-check"] = "rbxassetid://114352019833865",
			["lasso"] = "rbxassetid://121072936884007",
			["lasso-select"] = "rbxassetid://105609719912753",
			["laugh"] = "rbxassetid://104491311361166",
			["layers"] = "rbxassetid://81973586053257",
			["layers-2"] = "rbxassetid://70536710516357",
			["layers-plus"] = "rbxassetid://77587765623057",
			["layout-dashboard"] = "rbxassetid://139929981863901",
			["layout-grid"] = "rbxassetid://81344910161871",
			["layout-list"] = "rbxassetid://87462136296578",
			["layout-panel-left"] = "rbxassetid://125092469751491",
			["layout-panel-top"] = "rbxassetid://91943941515944",
			["layout-template"] = "rbxassetid://115564446417985",
			["leaf"] = "rbxassetid://119951075637174",
			["leafy-green"] = "rbxassetid://105146290493154",
			["lectern"] = "rbxassetid://106166425183862",
			["lens-concave"] = "rbxassetid://94819631937027",
			["lens-convex"] = "rbxassetid://74736504195474",
			["library"] = "rbxassetid://114334671982047",
			["library-big"] = "rbxassetid://106794530191412",
			["life-buoy"] = "rbxassetid://81168450671956",
			["ligature"] = "rbxassetid://111397873269411",
			["lightbulb"] = "rbxassetid://103871245626488",
			["lightbulb-off"] = "rbxassetid://83795722296178",
			["line-dot-right-horizontal"] = "rbxassetid://104718593155221",
			["line-squiggle"] = "rbxassetid://109555164424447",
			["line-style"] = "rbxassetid://90176717785772",
			["link"] = "rbxassetid://131607023382430",
			["link-2"] = "rbxassetid://86072351557466",
			["link-2-off"] = "rbxassetid://76885956296867",
			["linkedin"] = "rbxassetid://132842789255788",
			["list"] = "rbxassetid://113179976918783",
			["list-check"] = "rbxassetid://72374358471156",
			["list-checks"] = "rbxassetid://99809353635593",
			["list-chevrons-down-up"] = "rbxassetid://137409641500711",
			["list-chevrons-up-down"] = "rbxassetid://81825351389084",
			["list-collapse"] = "rbxassetid://124505247702401",
			["list-end"] = "rbxassetid://77650610048119",
			["list-filter"] = "rbxassetid://103321376129527",
			["list-filter-plus"] = "rbxassetid://96385120752336",
			["list-indent-decrease"] = "rbxassetid://137879979228193",
			["list-indent-increase"] = "rbxassetid://79051053161201",
			["list-minus"] = "rbxassetid://138507965142671",
			["list-music"] = "rbxassetid://126380635781840",
			["list-ordered"] = "rbxassetid://83212528113913",
			["list-plus"] = "rbxassetid://112384738137814",
			["list-restart"] = "rbxassetid://91703153577421",
			["list-start"] = "rbxassetid://84828348299727",
			["list-todo"] = "rbxassetid://132980603752108",
			["list-tree"] = "rbxassetid://97685396239010",
			["list-video"] = "rbxassetid://93648525452489",
			["list-x"] = "rbxassetid://113025303988861",
			["loader"] = "rbxassetid://78408734580845",
			["loader-circle"] = "rbxassetid://116535712789945",
			["loader-pinwheel"] = "rbxassetid://108513357940900",
			["locate"] = "rbxassetid://84467676590391",
			["locate-fixed"] = "rbxassetid://137367361548433",
			["locate-off"] = "rbxassetid://73729216338137",
			["lock"] = "rbxassetid://134724289526879",
			["lock-keyhole"] = "rbxassetid://78672912777756",
			["lock-keyhole-open"] = "rbxassetid://110863509313073",
			["lock-open"] = "rbxassetid://93597915325122",
			["log-in"] = "rbxassetid://103768533135201",
			["log-out"] = "rbxassetid://84895399304975",
			["logs"] = "rbxassetid://89772091251787",
			["lollipop"] = "rbxassetid://84681611583044",
			["luggage"] = "rbxassetid://76619236486400",
			["magnet"] = "rbxassetid://135162361226972",
			["mail"] = "rbxassetid://103945161245599",
			["mail-check"] = "rbxassetid://86921536259917",
			["mail-minus"] = "rbxassetid://81989813236553",
			["mail-open"] = "rbxassetid://122785416858638",
			["mail-plus"] = "rbxassetid://104886401588341",
			["mail-question-mark"] = "rbxassetid://126540170949819",
			["mail-search"] = "rbxassetid://135616173775287",
			["mail-warning"] = "rbxassetid://81495303676089",
			["mail-x"] = "rbxassetid://74607841705644",
			["mailbox"] = "rbxassetid://82765503320335",
			["mails"] = "rbxassetid://90673453450080",
			["map"] = "rbxassetid://95107167260947",
			["map-minus"] = "rbxassetid://129525760577747",
			["map-pin"] = "rbxassetid://84279202219901",
			["map-pin-check"] = "rbxassetid://118110914690154",
			["map-pin-check-inside"] = "rbxassetid://107130529843809",
			["map-pin-house"] = "rbxassetid://80546885029816",
			["map-pin-minus"] = "rbxassetid://74518762643623",
			["map-pin-minus-inside"] = "rbxassetid://79005529692964",
			["map-pin-off"] = "rbxassetid://82474689391020",
			["map-pin-pen"] = "rbxassetid://113515395277504",
			["map-pin-plus"] = "rbxassetid://91875228967029",
			["map-pin-plus-inside"] = "rbxassetid://134639656514430",
			["map-pin-search"] = "rbxassetid://89065012915078",
			["map-pin-x"] = "rbxassetid://101085273547316",
			["map-pin-x-inside"] = "rbxassetid://126235934252379",
			["map-pinned"] = "rbxassetid://103963788475034",
			["map-plus"] = "rbxassetid://129388826743495",
			["mars"] = "rbxassetid://111287112372511",
			["mars-stroke"] = "rbxassetid://131973193186828",
			["martini"] = "rbxassetid://82977695401058",
			["maximize"] = "rbxassetid://76045941763188",
			["maximize-2"] = "rbxassetid://73085922906397",
			["medal"] = "rbxassetid://79016002264450",
			["megaphone"] = "rbxassetid://118759541854879",
			["megaphone-off"] = "rbxassetid://124280774193935",
			["meh"] = "rbxassetid://132197867028557",
			["memory-stick"] = "rbxassetid://93212591343119",
			["menu"] = "rbxassetid://77021539815611",
			["merge"] = "rbxassetid://126201866476775",
			["message-circle"] = "rbxassetid://127255077587058",
			["message-circle-check"] = "rbxassetid://132772297689418",
			["message-circle-code"] = "rbxassetid://112865244991651",
			["message-circle-dashed"] = "rbxassetid://81525157881897",
			["message-circle-heart"] = "rbxassetid://101990756073677",
			["message-circle-more"] = "rbxassetid://92856823884663",
			["message-circle-off"] = "rbxassetid://134955643890328",
			["message-circle-plus"] = "rbxassetid://106562979649273",
			["message-circle-question-mark"] = "rbxassetid://107700302759934",
			["message-circle-reply"] = "rbxassetid://137071749508334",
			["message-circle-warning"] = "rbxassetid://119020096067894",
			["message-circle-x"] = "rbxassetid://126843387725536",
			["message-square"] = "rbxassetid://83881670383280",
			["message-square-check"] = "rbxassetid://125789987055668",
			["message-square-code"] = "rbxassetid://110968863152123",
			["message-square-dashed"] = "rbxassetid://107653455516238",
			["message-square-diff"] = "rbxassetid://75472190472625",
			["message-square-dot"] = "rbxassetid://127806382463916",
			["message-square-heart"] = "rbxassetid://75612811742074",
			["message-square-lock"] = "rbxassetid://81268215619563",
			["message-square-more"] = "rbxassetid://120139782405970",
			["message-square-off"] = "rbxassetid://99961019005789",
			["message-square-plus"] = "rbxassetid://76934450256199",
			["message-square-quote"] = "rbxassetid://116670768629340",
			["message-square-reply"] = "rbxassetid://130985622754637",
			["message-square-share"] = "rbxassetid://131017005324026",
			["message-square-text"] = "rbxassetid://94899503194205",
			["message-square-warning"] = "rbxassetid://138432903962261",
			["message-square-x"] = "rbxassetid://137285463279462",
			["messages-square"] = "rbxassetid://97532166733358",
			["metronome"] = "rbxassetid://101991829345965",
			["mic"] = "rbxassetid://89640799126523",
			["mic-off"] = "rbxassetid://82123034444822",
			["mic-vocal"] = "rbxassetid://99082286164362",
			["microchip"] = "rbxassetid://73937907669903",
			["microscope"] = "rbxassetid://116875530102782",
			["microwave"] = "rbxassetid://108411735353008",
			["milestone"] = "rbxassetid://101618292325920",
			["milk"] = "rbxassetid://96221903896918",
			["milk-off"] = "rbxassetid://72388480962742",
			["minimize"] = "rbxassetid://121304296213645",
			["minimize-2"] = "rbxassetid://116269596042539",
			["minus"] = "rbxassetid://118026365011536",
			["mirror-rectangular"] = "rbxassetid://109046769760336",
			["mirror-round"] = "rbxassetid://121534049429097",
			["monitor"] = "rbxassetid://72664649203050",
			["monitor-check"] = "rbxassetid://86651948439229",
			["monitor-cloud"] = "rbxassetid://85931096038318",
			["monitor-cog"] = "rbxassetid://94345128715799",
			["monitor-dot"] = "rbxassetid://130394010063680",
			["monitor-down"] = "rbxassetid://97466933743423",
			["monitor-off"] = "rbxassetid://74395526657953",
			["monitor-pause"] = "rbxassetid://76002184067562",
			["monitor-play"] = "rbxassetid://133018824306217",
			["monitor-smartphone"] = "rbxassetid://84335680433378",
			["monitor-speaker"] = "rbxassetid://81744810060380",
			["monitor-stop"] = "rbxassetid://98708958984757",
			["monitor-up"] = "rbxassetid://96035360858377",
			["monitor-x"] = "rbxassetid://126265210441423",
			["moon"] = "rbxassetid://83380517901735",
			["moon-star"] = "rbxassetid://82782200506348",
			["motorbike"] = "rbxassetid://94580787368233",
			["mountain"] = "rbxassetid://73269957566415",
			["mountain-snow"] = "rbxassetid://105315495740588",
			["mouse"] = "rbxassetid://73096068864710",
			["mouse-left"] = "rbxassetid://99144293708743",
			["mouse-off"] = "rbxassetid://75267871697595",
			["mouse-pointer"] = "rbxassetid://72322454962935",
			["mouse-pointer-2"] = "rbxassetid://117093892862228",
			["mouse-pointer-2-off"] = "rbxassetid://104701076865632",
			["mouse-pointer-ban"] = "rbxassetid://106849413057133",
			["mouse-pointer-click"] = "rbxassetid://107150227368485",
			["mouse-right"] = "rbxassetid://88331710212594",
			["move"] = "rbxassetid://116138709011735",
			["move-3d"] = "rbxassetid://103365982054003",
			["move-diagonal"] = "rbxassetid://101433481954184",
			["move-diagonal-2"] = "rbxassetid://117298577948096",
			["move-down"] = "rbxassetid://70510115135583",
			["move-down-left"] = "rbxassetid://102819433534567",
			["move-down-right"] = "rbxassetid://101479760041877",
			["move-horizontal"] = "rbxassetid://88513523439149",
			["move-left"] = "rbxassetid://137614740247980",
			["move-right"] = "rbxassetid://132455779472989",
			["move-up"] = "rbxassetid://84505444262658",
			["move-up-left"] = "rbxassetid://139079815540148",
			["move-up-right"] = "rbxassetid://105885140592646",
			["move-vertical"] = "rbxassetid://86234730730899",
			["music"] = "rbxassetid://113343203848535",
			["music-2"] = "rbxassetid://134397426600888",
			["music-3"] = "rbxassetid://94466120066498",
			["music-4"] = "rbxassetid://132459323665838",
			["navigation"] = "rbxassetid://79308213542922",
			["navigation-2"] = "rbxassetid://81889066747907",
			["navigation-2-off"] = "rbxassetid://116569611780763",
			["navigation-off"] = "rbxassetid://87003270290777",
			["network"] = "rbxassetid://127410729922644",
			["newspaper"] = "rbxassetid://123479530460544",
			["nfc"] = "rbxassetid://76822396542242",
			["non-binary"] = "rbxassetid://78442360386235",
			["notebook"] = "rbxassetid://136132108664987",
			["notebook-pen"] = "rbxassetid://140380614761023",
			["notebook-tabs"] = "rbxassetid://127371085570083",
			["notebook-text"] = "rbxassetid://93061585217270",
			["notepad-text"] = "rbxassetid://93404682958966",
			["notepad-text-dashed"] = "rbxassetid://135793446376219",
			["nut"] = "rbxassetid://127146410705656",
			["nut-off"] = "rbxassetid://78795397311573",
			["octagon"] = "rbxassetid://120803515514852",
			["octagon-alert"] = "rbxassetid://140438367956051",
			["octagon-minus"] = "rbxassetid://74720436795421",
			["octagon-pause"] = "rbxassetid://103161463909039",
			["octagon-x"] = "rbxassetid://90498161006311",
			["omega"] = "rbxassetid://70414080018786",
			["option"] = "rbxassetid://100776883894054",
			["orbit"] = "rbxassetid://108926136860562",
			["origami"] = "rbxassetid://136020626667101",
			["package"] = "rbxassetid://97261141732706",
			["package-2"] = "rbxassetid://70394974762575",
			["package-check"] = "rbxassetid://102374216055130",
			["package-minus"] = "rbxassetid://114492858789692",
			["package-open"] = "rbxassetid://132890233237818",
			["package-plus"] = "rbxassetid://129261988138366",
			["package-search"] = "rbxassetid://95465120894145",
			["package-x"] = "rbxassetid://70818501607442",
			["paint-bucket"] = "rbxassetid://124275586663284",
			["paint-roller"] = "rbxassetid://115248074358348",
			["paintbrush"] = "rbxassetid://125572663700289",
			["paintbrush-vertical"] = "rbxassetid://105151296591292",
			["palette"] = "rbxassetid://86350350950064",
			["panda"] = "rbxassetid://132509022802512",
			["panel-bottom"] = "rbxassetid://132127145048511",
			["panel-bottom-close"] = "rbxassetid://74287004071159",
			["panel-bottom-dashed"] = "rbxassetid://131084651621603",
			["panel-bottom-open"] = "rbxassetid://107768659586540",
			["panel-left"] = "rbxassetid://97419752870313",
			["panel-left-close"] = "rbxassetid://126579818823552",
			["panel-left-dashed"] = "rbxassetid://75536606374585",
			["panel-left-open"] = "rbxassetid://111075816195767",
			["panel-left-right-dashed"] = "rbxassetid://110100707973959",
			["panel-right"] = "rbxassetid://116365035443156",
			["panel-right-close"] = "rbxassetid://139528655524132",
			["panel-right-dashed"] = "rbxassetid://94959793877311",
			["panel-right-open"] = "rbxassetid://118114419142794",
			["panel-top"] = "rbxassetid://75838479462875",
			["panel-top-bottom-dashed"] = "rbxassetid://134737235653344",
			["panel-top-close"] = "rbxassetid://83578325777808",
			["panel-top-dashed"] = "rbxassetid://70522913169237",
			["panel-top-open"] = "rbxassetid://137959875507454",
			["panels-left-bottom"] = "rbxassetid://72996856149149",
			["panels-right-bottom"] = "rbxassetid://90659068960726",
			["panels-top-left"] = "rbxassetid://79858853850600",
			["paperclip"] = "rbxassetid://92088291163453",
			["parentheses"] = "rbxassetid://78950955173096",
			["parking-meter"] = "rbxassetid://84652733960568",
			["party-popper"] = "rbxassetid://111626795712193",
			["pause"] = "rbxassetid://74873705394436",
			["paw-print"] = "rbxassetid://112218825427601",
			["pc-case"] = "rbxassetid://122978648019101",
			["pen"] = "rbxassetid://72037878096321",
			["pen-line"] = "rbxassetid://109108135755303",
			["pen-off"] = "rbxassetid://84807123119438",
			["pen-tool"] = "rbxassetid://106145404953445",
			["pencil"] = "rbxassetid://137986121120732",
			["pencil-line"] = "rbxassetid://88392917053533",
			["pencil-off"] = "rbxassetid://103330927652832",
			["pencil-ruler"] = "rbxassetid://110120288284597",
			["pentagon"] = "rbxassetid://79184802179890",
			["percent"] = "rbxassetid://130155041032013",
			["person-standing"] = "rbxassetid://125020872044147",
			["philippine-peso"] = "rbxassetid://91173798254675",
			["phone"] = "rbxassetid://128804946640049",
			["phone-call"] = "rbxassetid://70555587592860",
			["phone-forwarded"] = "rbxassetid://113269614319737",
			["phone-incoming"] = "rbxassetid://82863576359288",
			["phone-missed"] = "rbxassetid://130156165198376",
			["phone-off"] = "rbxassetid://133318623553383",
			["phone-outgoing"] = "rbxassetid://104576478735825",
			["pi"] = "rbxassetid://74936036243146",
			["piano"] = "rbxassetid://85008880789520",
			["pickaxe"] = "rbxassetid://105888023317688",
			["picture-in-picture"] = "rbxassetid://80579597835123",
			["picture-in-picture-2"] = "rbxassetid://112803319544468",
			["piggy-bank"] = "rbxassetid://79498575790721",
			["pilcrow"] = "rbxassetid://139512780392871",
			["pilcrow-left"] = "rbxassetid://103803000849583",
			["pilcrow-right"] = "rbxassetid://104881733911870",
			["pill"] = "rbxassetid://73280534813448",
			["pill-bottle"] = "rbxassetid://118394692404597",
			["pin"] = "rbxassetid://120978111007514",
			["pin-off"] = "rbxassetid://127696372451750",
			["pipette"] = "rbxassetid://133167932934404",
			["pizza"] = "rbxassetid://126964453193501",
			["plane"] = "rbxassetid://126985561580989",
			["plane-landing"] = "rbxassetid://122555692211889",
			["plane-takeoff"] = "rbxassetid://117179478829575",
			["play"] = "rbxassetid://135609604299893",
			["plug"] = "rbxassetid://99782373064495",
			["plug-2"] = "rbxassetid://97912386476366",
			["plug-zap"] = "rbxassetid://74506269884055",
			["plus"] = "rbxassetid://111774323017047",
			["pocket"] = "rbxassetid://136686762542964",
			["pocket-knife"] = "rbxassetid://134075428063965",
			["podcast"] = "rbxassetid://109577075549215",
			["pointer"] = "rbxassetid://92615117311099",
			["pointer-off"] = "rbxassetid://95488389312794",
			["popcorn"] = "rbxassetid://139446511232750",
			["popsicle"] = "rbxassetid://112696318077073",
			["pound-sterling"] = "rbxassetid://127482649469130",
			["power"] = "rbxassetid://96479131758775",
			["power-off"] = "rbxassetid://118768311012214",
			["presentation"] = "rbxassetid://106134583757890",
			["printer"] = "rbxassetid://76080649734247",
			["printer-check"] = "rbxassetid://130273549443689",
			["printer-x"] = "rbxassetid://103002721801548",
			["projector"] = "rbxassetid://103281856385283",
			["proportions"] = "rbxassetid://130046855997237",
			["puzzle"] = "rbxassetid://136837798892463",
			["pyramid"] = "rbxassetid://107811442374127",
			["qr-code"] = "rbxassetid://105329945723350",
			["quote"] = "rbxassetid://103271711590001",
			["rabbit"] = "rbxassetid://98580518804206",
			["radar"] = "rbxassetid://138528222906635",
			["radiation"] = "rbxassetid://104499586848433",
			["radical"] = "rbxassetid://132758286926047",
			["radio"] = "rbxassetid://85611589536956",
			["radio-off"] = "rbxassetid://80359258046586",
			["radio-receiver"] = "rbxassetid://129598303378835",
			["radio-tower"] = "rbxassetid://93958663130054",
			["radius"] = "rbxassetid://89814505307129",
			["rail-symbol"] = "rbxassetid://134295386306962",
			["rainbow"] = "rbxassetid://132488862841895",
			["rat"] = "rbxassetid://127400975953159",
			["ratio"] = "rbxassetid://126369423897295",
			["receipt"] = "rbxassetid://77877895901792",
			["receipt-cent"] = "rbxassetid://91557573925201",
			["receipt-euro"] = "rbxassetid://94015722210295",
			["receipt-indian-rupee"] = "rbxassetid://89718170439990",
			["receipt-japanese-yen"] = "rbxassetid://132472560758851",
			["receipt-pound-sterling"] = "rbxassetid://73934967569625",
			["receipt-russian-ruble"] = "rbxassetid://105164576936853",
			["receipt-swiss-franc"] = "rbxassetid://72503668620116",
			["receipt-text"] = "rbxassetid://138483536013737",
			["receipt-turkish-lira"] = "rbxassetid://91950765836342",
			["rectangle-circle"] = "rbxassetid://100642423153903",
			["rectangle-ellipsis"] = "rbxassetid://112919953980965",
			["rectangle-goggles"] = "rbxassetid://98605436666727",
			["rectangle-horizontal"] = "rbxassetid://90224199814966",
			["rectangle-vertical"] = "rbxassetid://117277050590967",
			["recycle"] = "rbxassetid://140417023381961",
			["redo"] = "rbxassetid://116150342119054",
			["redo-2"] = "rbxassetid://70451039017914",
			["redo-dot"] = "rbxassetid://94252981719732",
			["refresh-ccw"] = "rbxassetid://117913330389477",
			["refresh-ccw-dot"] = "rbxassetid://106702246753270",
			["refresh-cw"] = "rbxassetid://138133190015277",
			["refresh-cw-off"] = "rbxassetid://140179498843054",
			["refrigerator"] = "rbxassetid://102614042652753",
			["regex"] = "rbxassetid://100727200791841",
			["remove-formatting"] = "rbxassetid://112833162022628",
			["repeat"] = "rbxassetid://121886242955173",
			["repeat-1"] = "rbxassetid://130144534857095",
			["repeat-2"] = "rbxassetid://85927537182704",
			["replace"] = "rbxassetid://128404082279430",
			["replace-all"] = "rbxassetid://127862728198635",
			["reply"] = "rbxassetid://109788633497028",
			["reply-all"] = "rbxassetid://71723137343562",
			["rewind"] = "rbxassetid://95205297521988",
			["ribbon"] = "rbxassetid://94265331526851",
			["road"] = "rbxassetid://120251329173530",
			["rocket"] = "rbxassetid://87412317685854",
			["rocking-chair"] = "rbxassetid://110420269495360",
			["roller-coaster"] = "rbxassetid://112426178972099",
			["rose"] = "rbxassetid://126336840238769",
			["rotate-3d"] = "rbxassetid://76300551576392",
			["rotate-ccw"] = "rbxassetid://110116685948665",
			["rotate-ccw-key"] = "rbxassetid://74976035240976",
			["rotate-ccw-square"] = "rbxassetid://90515853170424",
			["rotate-cw"] = "rbxassetid://84183336178654",
			["rotate-cw-square"] = "rbxassetid://77095448159303",
			["route"] = "rbxassetid://89968303228953",
			["route-off"] = "rbxassetid://106350402024079",
			["router"] = "rbxassetid://102130331994471",
			["rows-2"] = "rbxassetid://112556185960101",
			["rows-3"] = "rbxassetid://117215586961375",
			["rows-4"] = "rbxassetid://125646021959055",
			["rss"] = "rbxassetid://131789058984793",
			["ruler"] = "rbxassetid://81432445547423",
			["ruler-dimension-line"] = "rbxassetid://70673861371412",
			["russian-ruble"] = "rbxassetid://126357936542156",
			["sailboat"] = "rbxassetid://87110567187540",
			["salad"] = "rbxassetid://128864507821603",
			["sandwich"] = "rbxassetid://104573187458917",
			["satellite"] = "rbxassetid://134967053164645",
			["satellite-dish"] = "rbxassetid://136742443888305",
			["saudi-riyal"] = "rbxassetid://102282769104635",
			["save"] = "rbxassetid://126116963775616",
			["save-all"] = "rbxassetid://116946975799440",
			["save-off"] = "rbxassetid://87085435778560",
			["scale"] = "rbxassetid://108203682317477",
			["scale-3d"] = "rbxassetid://72414199620352",
			["scaling"] = "rbxassetid://122360365318466",
			["scan"] = "rbxassetid://123104789658180",
			["scan-barcode"] = "rbxassetid://96889457154761",
			["scan-eye"] = "rbxassetid://99244790601968",
			["scan-face"] = "rbxassetid://109959345069668",
			["scan-heart"] = "rbxassetid://106280819776142",
			["scan-line"] = "rbxassetid://126544908146540",
			["scan-qr-code"] = "rbxassetid://105409149549927",
			["scan-search"] = "rbxassetid://80009010551347",
			["scan-text"] = "rbxassetid://73702396787766",
			["school"] = "rbxassetid://76351530290068",
			["scissors"] = "rbxassetid://118665510911274",
			["scissors-line-dashed"] = "rbxassetid://122237447974173",
			["scooter"] = "rbxassetid://100035452787934",
			["screen-share"] = "rbxassetid://85137895705653",
			["screen-share-off"] = "rbxassetid://107677572669805",
			["scroll"] = "rbxassetid://74072101474951",
			["scroll-text"] = "rbxassetid://97321022666868",
			["search"] = "rbxassetid://121018724060431",
			["search-alert"] = "rbxassetid://127597984617505",
			["search-check"] = "rbxassetid://75442076191356",
			["search-code"] = "rbxassetid://117114794592802",
			["search-slash"] = "rbxassetid://96483932261041",
			["search-x"] = "rbxassetid://137319957522951",
			["section"] = "rbxassetid://91732188298948",
			["send"] = "rbxassetid://127751956873796",
			["send-horizontal"] = "rbxassetid://111734392411664",
			["send-to-back"] = "rbxassetid://75340312862253",
			["separator-horizontal"] = "rbxassetid://84864453699927",
			["separator-vertical"] = "rbxassetid://84031801478581",
			["server"] = "rbxassetid://92188766517878",
			["server-cog"] = "rbxassetid://138470287250966",
			["server-crash"] = "rbxassetid://132810618000212",
			["server-off"] = "rbxassetid://114048751507723",
			["settings"] = "rbxassetid://80758916183665",
			["settings-2"] = "rbxassetid://135684703553372",
			["shapes"] = "rbxassetid://129989433311409",
			["share"] = "rbxassetid://87340985053299",
			["share-2"] = "rbxassetid://71210767962065",
			["sheet"] = "rbxassetid://134902122480171",
			["shell"] = "rbxassetid://140212943563599",
			["shelving-unit"] = "rbxassetid://80116568514793",
			["shield"] = "rbxassetid://110987169760162",
			["shield-alert"] = "rbxassetid://114995877719925",
			["shield-ban"] = "rbxassetid://108765041044649",
			["shield-check"] = "rbxassetid://87354736164608",
			["shield-cog"] = "rbxassetid://129235695057857",
			["shield-cog-corner"] = "rbxassetid://111694066132698",
			["shield-ellipsis"] = "rbxassetid://114794739892123",
			["shield-half"] = "rbxassetid://117842634172647",
			["shield-minus"] = "rbxassetid://89965059528921",
			["shield-off"] = "rbxassetid://133426959132690",
			["shield-plus"] = "rbxassetid://100664857995498",
			["shield-question-mark"] = "rbxassetid://135722075265150",
			["shield-user"] = "rbxassetid://124832775645347",
			["shield-x"] = "rbxassetid://73370117343811",
			["ship"] = "rbxassetid://83995100553930",
			["ship-wheel"] = "rbxassetid://130797795829448",
			["shirt"] = "rbxassetid://106579555405966",
			["shopping-bag"] = "rbxassetid://71885477293226",
			["shopping-basket"] = "rbxassetid://138646411956433",
			["shopping-cart"] = "rbxassetid://128420521375441",
			["shovel"] = "rbxassetid://102465000512056",
			["shower-head"] = "rbxassetid://75884944024117",
			["shredder"] = "rbxassetid://122125164414463",
			["shrimp"] = "rbxassetid://102625900815307",
			["shrink"] = "rbxassetid://90953687918880",
			["shrub"] = "rbxassetid://127326280714343",
			["shuffle"] = "rbxassetid://132382786975101",
			["sigma"] = "rbxassetid://126884244870899",
			["signal"] = "rbxassetid://78424889355261",
			["signal-high"] = "rbxassetid://130436670012270",
			["signal-low"] = "rbxassetid://73674683500458",
			["signal-medium"] = "rbxassetid://125003021367019",
			["signal-zero"] = "rbxassetid://130045332414754",
			["signature"] = "rbxassetid://114402748013000",
			["signpost"] = "rbxassetid://106584743791433",
			["signpost-big"] = "rbxassetid://115780185675001",
			["siren"] = "rbxassetid://134210267818039",
			["skip-back"] = "rbxassetid://70466132711334",
			["skip-forward"] = "rbxassetid://124844823753990",
			["skull"] = "rbxassetid://137726256442333",
			["slack"] = "rbxassetid://96089719516736",
			["slash"] = "rbxassetid://117792185664263",
			["slice"] = "rbxassetid://95810504278179",
			["sliders-horizontal"] = "rbxassetid://85538382643347",
			["sliders-vertical"] = "rbxassetid://101190569086853",
			["smartphone"] = "rbxassetid://96623008834511",
			["smartphone-charging"] = "rbxassetid://102837532613995",
			["smartphone-nfc"] = "rbxassetid://82326425754446",
			["smile"] = "rbxassetid://105880397565283",
			["smile-plus"] = "rbxassetid://131981881472144",
			["snail"] = "rbxassetid://70904536548363",
			["snowflake"] = "rbxassetid://101235206534566",
			["soap-dispenser-droplet"] = "rbxassetid://77258480479465",
			["sofa"] = "rbxassetid://114427687218324",
			["solar-panel"] = "rbxassetid://132448188047921",
			["soup"] = "rbxassetid://115092551871618",
			["space"] = "rbxassetid://87072088914178",
			["spade"] = "rbxassetid://131444449466462",
			["sparkle"] = "rbxassetid://111044800239623",
			["sparkles"] = "rbxassetid://138635884129147",
			["speaker"] = "rbxassetid://96227183003618",
			["speech"] = "rbxassetid://87013139446349",
			["spell-check"] = "rbxassetid://91913483031334",
			["spell-check-2"] = "rbxassetid://81556731785534",
			["spline"] = "rbxassetid://129406685807412",
			["spline-pointer"] = "rbxassetid://84842840956804",
			["split"] = "rbxassetid://105112438805988",
			["spool"] = "rbxassetid://124541981347743",
			["sport-shoe"] = "rbxassetid://120495992692630",
			["spotlight"] = "rbxassetid://77571742539344",
			["spray-can"] = "rbxassetid://128372039366326",
			["sprout"] = "rbxassetid://100091687832508",
			["square"] = "rbxassetid://86304921356806",
			["square-activity"] = "rbxassetid://89496630185293",
			["square-arrow-down"] = "rbxassetid://135962519626588",
			["square-arrow-down-left"] = "rbxassetid://108194680296901",
			["square-arrow-down-right"] = "rbxassetid://99403846801050",
			["square-arrow-left"] = "rbxassetid://111671474549238",
			["square-arrow-out-down-left"] = "rbxassetid://125714881756353",
			["square-arrow-out-down-right"] = "rbxassetid://89971003001390",
			["square-arrow-out-up-left"] = "rbxassetid://103759986579087",
			["square-arrow-out-up-right"] = "rbxassetid://91221896066807",
			["square-arrow-right"] = "rbxassetid://113920471701361",
			["square-arrow-right-enter"] = "rbxassetid://138867831495334",
			["square-arrow-right-exit"] = "rbxassetid://133688575845430",
			["square-arrow-up"] = "rbxassetid://106998604646718",
			["square-arrow-up-left"] = "rbxassetid://112424670290693",
			["square-arrow-up-right"] = "rbxassetid://76602291406940",
			["square-asterisk"] = "rbxassetid://89186832353625",
			["square-bottom-dashed-scissors"] = "rbxassetid://79076980104803",
			["square-centerline-dashed-horizontal"] = "rbxassetid://77780104374341",
			["square-centerline-dashed-vertical"] = "rbxassetid://107878435803525",
			["square-chart-gantt"] = "rbxassetid://104034017316411",
			["square-check"] = "rbxassetid://134682053539509",
			["square-check-big"] = "rbxassetid://115320390907184",
			["square-chevron-down"] = "rbxassetid://91032307924592",
			["square-chevron-left"] = "rbxassetid://73143404829510",
			["square-chevron-right"] = "rbxassetid://90612077729930",
			["square-chevron-up"] = "rbxassetid://85565910197337",
			["square-code"] = "rbxassetid://81604576616881",
			["square-dashed"] = "rbxassetid://136905537847606",
			["square-dashed-bottom"] = "rbxassetid://101102319625624",
			["square-dashed-bottom-code"] = "rbxassetid://100354801563230",
			["square-dashed-kanban"] = "rbxassetid://90388067649847",
			["square-dashed-mouse-pointer"] = "rbxassetid://121016142178467",
			["square-dashed-top-solid"] = "rbxassetid://117157577548540",
			["square-divide"] = "rbxassetid://99894657101970",
			["square-dot"] = "rbxassetid://116613421354866",
			["square-equal"] = "rbxassetid://110283363706707",
			["square-function"] = "rbxassetid://86075219551088",
			["square-kanban"] = "rbxassetid://114537101260131",
			["square-library"] = "rbxassetid://73810931222081",
			["square-m"] = "rbxassetid://117662700410577",
			["square-menu"] = "rbxassetid://104067089444415",
			["square-minus"] = "rbxassetid://116764432015770",
			["square-mouse-pointer"] = "rbxassetid://76141850603920",
			["square-parking"] = "rbxassetid://133116656122387",
			["square-parking-off"] = "rbxassetid://100857293535141",
			["square-pause"] = "rbxassetid://86608552787615",
			["square-pen"] = "rbxassetid://120239476110475",
			["square-percent"] = "rbxassetid://87111930314567",
			["square-pi"] = "rbxassetid://75383328781618",
			["square-pilcrow"] = "rbxassetid://131854284699367",
			["square-play"] = "rbxassetid://108186325238481",
			["square-plus"] = "rbxassetid://114713264461873",
			["square-power"] = "rbxassetid://129240437805187",
			["square-radical"] = "rbxassetid://132645931868292",
			["square-round-corner"] = "rbxassetid://104592745113567",
			["square-scissors"] = "rbxassetid://110601255612411",
			["square-sigma"] = "rbxassetid://113231244246816",
			["square-slash"] = "rbxassetid://105477013908757",
			["square-split-horizontal"] = "rbxassetid://76095370148660",
			["square-split-vertical"] = "rbxassetid://88589192032058",
			["square-square"] = "rbxassetid://136555087357875",
			["square-stack"] = "rbxassetid://100463396619394",
			["square-star"] = "rbxassetid://94506958703720",
			["square-stop"] = "rbxassetid://80018708472943",
			["square-terminal"] = "rbxassetid://83969264476798",
			["square-user"] = "rbxassetid://70771214183445",
			["square-user-round"] = "rbxassetid://86484997229302",
			["square-x"] = "rbxassetid://125136183850190",
			["squares-exclude"] = "rbxassetid://102345385822324",
			["squares-intersect"] = "rbxassetid://120869602570119",
			["squares-subtract"] = "rbxassetid://131484650948795",
			["squares-unite"] = "rbxassetid://96673080107843",
			["squircle"] = "rbxassetid://82426632573807",
			["squircle-dashed"] = "rbxassetid://129936702532522",
			["squirrel"] = "rbxassetid://112864252085343",
			["stamp"] = "rbxassetid://92370779813368",
			["star"] = "rbxassetid://136141469398409",
			["star-half"] = "rbxassetid://117449275562979",
			["star-off"] = "rbxassetid://75742832732503",
			["step-back"] = "rbxassetid://108672750005121",
			["step-forward"] = "rbxassetid://126131872136145",
			["stethoscope"] = "rbxassetid://122331031702148",
			["sticker"] = "rbxassetid://79938203791608",
			["sticky-note"] = "rbxassetid://111894074643919",
			["stone"] = "rbxassetid://135161057497830",
			["store"] = "rbxassetid://90338129673705",
			["stretch-horizontal"] = "rbxassetid://87665042192343",
			["stretch-vertical"] = "rbxassetid://95265463417122",
			["strikethrough"] = "rbxassetid://103417324549613",
			["subscript"] = "rbxassetid://74553514785183",
			["sun"] = "rbxassetid://110150589884127",
			["sun-dim"] = "rbxassetid://129141645592715",
			["sun-medium"] = "rbxassetid://130278807964710",
			["sun-moon"] = "rbxassetid://75752898854559",
			["sun-snow"] = "rbxassetid://112791898014579",
			["sunrise"] = "rbxassetid://134705665494098",
			["sunset"] = "rbxassetid://75904872203588",
			["superscript"] = "rbxassetid://96887696590118",
			["swatch-book"] = "rbxassetid://126786244872453",
			["swiss-franc"] = "rbxassetid://113497920041625",
			["switch-camera"] = "rbxassetid://76841154349737",
			["sword"] = "rbxassetid://124448418211665",
			["swords"] = "rbxassetid://81872698913435",
			["syringe"] = "rbxassetid://123891270479254",
			["table"] = "rbxassetid://109109148250737",
			["table-2"] = "rbxassetid://95751552281545",
			["table-cells-merge"] = "rbxassetid://95363715175258",
			["table-cells-split"] = "rbxassetid://114799086088649",
			["table-columns-split"] = "rbxassetid://111011625447949",
			["table-of-contents"] = "rbxassetid://135044763275414",
			["table-properties"] = "rbxassetid://125062886015372",
			["table-rows-split"] = "rbxassetid://96443733673997",
			["tablet"] = "rbxassetid://128403991264386",
			["tablet-smartphone"] = "rbxassetid://133680859813404",
			["tablets"] = "rbxassetid://80835787970735",
			["tag"] = "rbxassetid://129104970103940",
			["tags"] = "rbxassetid://107179263080798",
			["tally-1"] = "rbxassetid://115301298241643",
			["tally-2"] = "rbxassetid://110363186864027",
			["tally-3"] = "rbxassetid://97655344572540",
			["tally-4"] = "rbxassetid://102633494371890",
			["tally-5"] = "rbxassetid://88031817475886",
			["tangent"] = "rbxassetid://123263132981724",
			["target"] = "rbxassetid://87563802520297",
			["telescope"] = "rbxassetid://91755049143647",
			["tent"] = "rbxassetid://109779587826330",
			["tent-tree"] = "rbxassetid://76698322463977",
			["terminal"] = "rbxassetid://106783148545356",
			["test-tube"] = "rbxassetid://98801015650164",
			["test-tube-diagonal"] = "rbxassetid://75662704378840",
			["test-tubes"] = "rbxassetid://92555361447433",
			["text-align-center"] = "rbxassetid://84051028246390",
			["text-align-end"] = "rbxassetid://130041738343555",
			["text-align-justify"] = "rbxassetid://80279880143030",
			["text-align-start"] = "rbxassetid://134489585487649",
			["text-cursor"] = "rbxassetid://115984654447300",
			["text-cursor-input"] = "rbxassetid://107551944047171",
			["text-initial"] = "rbxassetid://129458097472087",
			["text-quote"] = "rbxassetid://139278366448736",
			["text-search"] = "rbxassetid://92345384671606",
			["text-select"] = "rbxassetid://117087320884956",
			["text-wrap"] = "rbxassetid://114804318314018",
			["theater"] = "rbxassetid://108558145549163",
			["thermometer"] = "rbxassetid://106546011492311",
			["thermometer-snowflake"] = "rbxassetid://121876188028425",
			["thermometer-sun"] = "rbxassetid://106693240074310",
			["thumbs-down"] = "rbxassetid://87794009914015",
			["thumbs-up"] = "rbxassetid://111137070767020",
			["ticket"] = "rbxassetid://126527071492145",
			["ticket-check"] = "rbxassetid://105428777212507",
			["ticket-minus"] = "rbxassetid://78966299769328",
			["ticket-percent"] = "rbxassetid://80834774406405",
			["ticket-plus"] = "rbxassetid://110086734392189",
			["ticket-slash"] = "rbxassetid://89045681172265",
			["ticket-x"] = "rbxassetid://88674114109926",
			["tickets"] = "rbxassetid://135268612687833",
			["tickets-plane"] = "rbxassetid://100367018248695",
			["timer"] = "rbxassetid://85473888890506",
			["timer-off"] = "rbxassetid://110916370767271",
			["timer-reset"] = "rbxassetid://110052125369932",
			["toggle-left"] = "rbxassetid://85887872573050",
			["toggle-right"] = "rbxassetid://90411952142550",
			["toilet"] = "rbxassetid://80930782432931",
			["tool-case"] = "rbxassetid://87533537832522",
			["toolbox"] = "rbxassetid://85341033903792",
			["tornado"] = "rbxassetid://88358291515768",
			["torus"] = "rbxassetid://70855707283051",
			["touchpad"] = "rbxassetid://74882354908014",
			["touchpad-off"] = "rbxassetid://78784008075456",
			["towel-rack"] = "rbxassetid://125223915620991",
			["tower-control"] = "rbxassetid://95937619060532",
			["toy-brick"] = "rbxassetid://86293483924633",
			["tractor"] = "rbxassetid://103376704722051",
			["traffic-cone"] = "rbxassetid://74110220470369",
			["train-front"] = "rbxassetid://125237934215370",
			["train-front-tunnel"] = "rbxassetid://105194827005114",
			["train-track"] = "rbxassetid://77451032453723",
			["tram-front"] = "rbxassetid://93315182364998",
			["transgender"] = "rbxassetid://135530817673639",
			["trash"] = "rbxassetid://106723740584310",
			["trash-2"] = "rbxassetid://109843431391323",
			["tree-deciduous"] = "rbxassetid://123124389219004",
			["tree-palm"] = "rbxassetid://103846705893963",
			["tree-pine"] = "rbxassetid://124662547202594",
			["trees"] = "rbxassetid://121203841375919",
			["trello"] = "rbxassetid://130987241149527",
			["trending-down"] = "rbxassetid://139309232226438",
			["trending-up"] = "rbxassetid://81819858538839",
			["trending-up-down"] = "rbxassetid://85083293981691",
			["triangle"] = "rbxassetid://126330486745540",
			["triangle-alert"] = "rbxassetid://125920361880643",
			["triangle-dashed"] = "rbxassetid://124324079103935",
			["triangle-right"] = "rbxassetid://116930791412791",
			["trophy"] = "rbxassetid://131545003268773",
			["truck"] = "rbxassetid://86662707764771",
			["truck-electric"] = "rbxassetid://111873446387359",
			["turkish-lira"] = "rbxassetid://114589876174070",
			["turntable"] = "rbxassetid://129870346487856",
			["turtle"] = "rbxassetid://118295081560334",
			["tv"] = "rbxassetid://135687724791776",
			["tv-minimal"] = "rbxassetid://100382201729427",
			["tv-minimal-play"] = "rbxassetid://99201833426972",
			["twitch"] = "rbxassetid://71383308134888",
			["twitter"] = "rbxassetid://88791703276842",
			["type"] = "rbxassetid://133543553793564",
			["type-outline"] = "rbxassetid://80108627791690",
			["umbrella"] = "rbxassetid://127502210274589",
			["umbrella-off"] = "rbxassetid://72395143739955",
			["underline"] = "rbxassetid://123709229216544",
			["undo"] = "rbxassetid://111258459077271",
			["undo-2"] = "rbxassetid://113885292059932",
			["undo-dot"] = "rbxassetid://132055277744844",
			["unfold-horizontal"] = "rbxassetid://117128358526398",
			["unfold-vertical"] = "rbxassetid://116593025265499",
			["ungroup"] = "rbxassetid://106674800451003",
			["university"] = "rbxassetid://84652528263642",
			["unlink"] = "rbxassetid://139835795227752",
			["unlink-2"] = "rbxassetid://128131898892572",
			["unplug"] = "rbxassetid://90171381619874",
			["upload"] = "rbxassetid://138212042425501",
			["usb"] = "rbxassetid://117230058949613",
			["user"] = "rbxassetid://81589895647169",
			["user-check"] = "rbxassetid://81775205032725",
			["user-cog"] = "rbxassetid://92795491530865",
			["user-key"] = "rbxassetid://105403041782190",
			["user-lock"] = "rbxassetid://78892639693821",
			["user-minus"] = "rbxassetid://126976941957511",
			["user-pen"] = "rbxassetid://87445472574836",
			["user-plus"] = "rbxassetid://118514469915884",
			["user-round"] = "rbxassetid://136485052187963",
			["user-round-check"] = "rbxassetid://118794737621941",
			["user-round-cog"] = "rbxassetid://78239503290053",
			["user-round-key"] = "rbxassetid://124547549008939",
			["user-round-minus"] = "rbxassetid://98944176636447",
			["user-round-pen"] = "rbxassetid://108155244324878",
			["user-round-plus"] = "rbxassetid://113301899567470",
			["user-round-search"] = "rbxassetid://71565774381870",
			["user-round-x"] = "rbxassetid://122367980560930",
			["user-search"] = "rbxassetid://101335649828115",
			["user-star"] = "rbxassetid://98777846316000",
			["user-x"] = "rbxassetid://139748155894754",
			["users"] = "rbxassetid://115398113982385",
			["users-round"] = "rbxassetid://103005444008339",
			["utensils"] = "rbxassetid://139952569804235",
			["utensils-crossed"] = "rbxassetid://109520762270383",
			["utility-pole"] = "rbxassetid://101965541238242",
			["van"] = "rbxassetid://122066377022942",
			["variable"] = "rbxassetid://104743088438151",
			["vault"] = "rbxassetid://108049164599845",
			["vector-square"] = "rbxassetid://86713728565344",
			["vegan"] = "rbxassetid://119489190688082",
			["venetian-mask"] = "rbxassetid://102636443033920",
			["venus"] = "rbxassetid://82891342220859",
			["venus-and-mars"] = "rbxassetid://120227752103771",
			["vibrate"] = "rbxassetid://108330910738733",
			["vibrate-off"] = "rbxassetid://113446447326246",
			["video"] = "rbxassetid://107587444636945",
			["video-off"] = "rbxassetid://132239189859305",
			["videotape"] = "rbxassetid://114816894323398",
			["view"] = "rbxassetid://118717253976805",
			["voicemail"] = "rbxassetid://134313454010227",
			["volleyball"] = "rbxassetid://83889351124153",
			["volume"] = "rbxassetid://103236289817396",
			["volume-1"] = "rbxassetid://98514588731639",
			["volume-2"] = "rbxassetid://89344380902620",
			["volume-off"] = "rbxassetid://103047478058767",
			["volume-x"] = "rbxassetid://139252359189540",
			["vote"] = "rbxassetid://89409762851246",
			["wallet"] = "rbxassetid://132331555762628",
			["wallet-cards"] = "rbxassetid://129728715308337",
			["wallet-minimal"] = "rbxassetid://137800448816116",
			["wallpaper"] = "rbxassetid://74682121235494",
			["wand"] = "rbxassetid://114580617777835",
			["wand-sparkles"] = "rbxassetid://82546429942392",
			["warehouse"] = "rbxassetid://78388887451080",
			["washing-machine"] = "rbxassetid://104194127573858",
			["watch"] = "rbxassetid://130544621618405",
			["waves"] = "rbxassetid://96340135183647",
			["waves-arrow-down"] = "rbxassetid://129215220911792",
			["waves-arrow-up"] = "rbxassetid://102314705716217",
			["waves-ladder"] = "rbxassetid://101808619355514",
			["waypoints"] = "rbxassetid://102450133666017",
			["webcam"] = "rbxassetid://104148487911129",
			["webhook"] = "rbxassetid://112812457747322",
			["webhook-off"] = "rbxassetid://96370548093471",
			["weight"] = "rbxassetid://103860559844854",
			["weight-tilde"] = "rbxassetid://112081212176951",
			["wheat"] = "rbxassetid://85261952080359",
			["wheat-off"] = "rbxassetid://133294844612307",
			["whole-word"] = "rbxassetid://90111083954485",
			["wifi"] = "rbxassetid://104669375183960",
			["wifi-cog"] = "rbxassetid://110500263326209",
			["wifi-high"] = "rbxassetid://81954601342139",
			["wifi-low"] = "rbxassetid://138217335635913",
			["wifi-off"] = "rbxassetid://74113634330106",
			["wifi-pen"] = "rbxassetid://91290205064712",
			["wifi-sync"] = "rbxassetid://84043971055177",
			["wifi-zero"] = "rbxassetid://124286465246123",
			["wind"] = "rbxassetid://114551690399915",
			["wind-arrow-down"] = "rbxassetid://127753987414870",
			["wine"] = "rbxassetid://115743721332829",
			["wine-off"] = "rbxassetid://108294164302317",
			["workflow"] = "rbxassetid://99186544029189",
			["worm"] = "rbxassetid://115752311548091",
			["wrench"] = "rbxassetid://112148279212860",
			["x"] = "rbxassetid://110786993356448",
			["x-line-top"] = "rbxassetid://140592656289509",
			["youtube"] = "rbxassetid://123663668456341",
			["zap"] = "rbxassetid://130551565616516",
			["zap-off"] = "rbxassetid://81385483183652",
			["zodiac-aquarius"] = "rbxassetid://74560047770362",
			["zodiac-aries"] = "rbxassetid://73255859670234",
			["zodiac-cancer"] = "rbxassetid://131985162532947",
			["zodiac-capricorn"] = "rbxassetid://97859568140652",
			["zodiac-gemini"] = "rbxassetid://80997588122992",
			["zodiac-leo"] = "rbxassetid://75509406718106",
			["zodiac-libra"] = "rbxassetid://113222735060218",
			["zodiac-ophiuchus"] = "rbxassetid://129180108892480",
			["zodiac-pisces"] = "rbxassetid://95845819440327",
			["zodiac-sagittarius"] = "rbxassetid://82651026742181",
			["zodiac-scorpio"] = "rbxassetid://113640924054631",
			["zodiac-taurus"] = "rbxassetid://123053219704400",
			["zodiac-virgo"] = "rbxassetid://99462994613661",
			["zoom-in"] = "rbxassetid://127956924984803",
			["zoom-out"] = "rbxassetid://108334162607319",
		}

		local aliases = {
			["alarm-check"] = "alarm-clock-check",
			["alarm-minus"] = "alarm-clock-minus",
			["alarm-plus"] = "alarm-clock-plus",
			["alert-circle"] = "circle-alert",
			["alert-octagon"] = "octagon-alert",
			["alert-triangle"] = "triangle-alert",
			["align-center"] = "text-align-center",
			["align-justify"] = "text-align-justify",
			["align-left"] = "text-align-start",
			["align-right"] = "text-align-end",
			["arrow-down-circle"] = "circle-arrow-down",
			["arrow-left-circle"] = "circle-arrow-left",
			["arrow-right-circle"] = "circle-arrow-right",
			["arrow-up-circle"] = "circle-arrow-up",
			["bar-chart"] = "chart-no-axes-column-increasing",
			["bar-chart-2"] = "chart-no-axes-column",
			["bar-chart-3"] = "chart-column",
			["bar-chart-4"] = "chart-column-increasing",
			["bar-chart-horizontal"] = "chart-bar",
			["box-select"] = "square-dashed",
			["charge"] = "battery-charging",
			["check-circle"] = "circle-check",
			["check-circle-2"] = "circle-check-big",
			["check-square"] = "square-check",
			["circle-slashed"] = "circle-off",
			["clipboard-edit"] = "clipboard-pen",
			["clipboard-signature"] = "clipboard-pen-line",
			["code-2"] = "code-xml",
			["columns"] = "columns-2",
			["connection"] = "wifi",
			["curly-braces"] = "braces",
			["divide-circle"] = "circle-divide",
			["divide-square"] = "square-divide",
			["download-cloud"] = "cloud-download",
			["edit"] = "square-pen",
			["edit-2"] = "pencil",
			["edit-3"] = "pen-line",
			["electricity"] = "zap",
			["electricity-off"] = "zap-off",
			["file-audio"] = "file-music",
			["file-audio-2"] = "file-music",
			["file-badge-2"] = "file-badge",
			["file-bar-chart"] = "file-chart-column-increasing",
			["file-bar-chart-2"] = "file-chart-column",
			["file-check-2"] = "file-check",
			["file-cog-2"] = "file-cog",
			["file-edit"] = "file-pen",
			["file-json"] = "file-braces",
			["file-json-2"] = "file-braces-corner",
			["file-key-2"] = "file-key",
			["file-line-chart"] = "file-chart-line",
			["file-lock-2"] = "file-lock",
			["file-minus-2"] = "file-minus",
			["file-pie-chart"] = "file-chart-pie",
			["file-plus-2"] = "file-plus",
			["file-question"] = "file-question-mark",
			["file-search-2"] = "file-search",
			["file-signature"] = "file-pen-line",
			["file-type-2"] = "file-type",
			["file-video"] = "file-play",
			["file-video-2"] = "file-play",
			["file-volume-2"] = "file-volume",
			["file-warning"] = "file-exclamation-point",
			["file-x-2"] = "file-x",
			["filter"] = "funnel",
			["folder-cog-2"] = "folder-cog",
			["folder-edit"] = "folder-pen",
			["form-input"] = "text-cursor-input",
			["function-square"] = "square-function",
			["git-commit"] = "git-commit-horizontal",
			["glass-2"] = "martini",
			["globe-2"] = "earth",
			["grab"] = "hand",
			["grid"] = "grid-2x2",
			["home"] = "house",
			["ice-cream"] = "ice-cream-cone",
			["indent"] = "list-indent-increase",
			["inspect"] = "square-mouse-pointer",
			["laptop-2"] = "laptop",
			["layout"] = "layout-dashboard",
			["line-chart"] = "chart-line",
			["loader-2"] = "loader-circle",
			["mail-question"] = "mail-question-mark",
			["mic-2"] = "mic",
			["minus-circle"] = "circle-minus",
			["minus-square"] = "square-minus",
			["more-horizontal"] = "ellipsis",
			["more-vertical"] = "ellipsis-vertical",
			["outdent"] = "list-indent-decrease",
			["paintbrush-2"] = "paintbrush-vertical",
			["palmtree"] = "tree-palm",
			["pause-circle"] = "circle-pause",
			["pause-octagon"] = "octagon-pause",
			["pie-chart"] = "chart-pie",
			["play-circle"] = "circle-play",
			["plus-circle"] = "circle-plus",
			["plus-square"] = "square-plus",
			["shield-close"] = "shield-x",
			["sidebar"] = "panel-left",
			["sidebar-close"] = "panel-left-close",
			["sidebar-open"] = "panel-left-open",
			["sliders"] = "sliders-horizontal",
			["sort-asc"] = "arrow-up-narrow-wide",
			["sort-desc"] = "arrow-down-wide-narrow",
			["stop-circle"] = "circle-stop",
			["terminal-square"] = "square-terminal",
			["train"] = "train-front",
			["tv-2"] = "tv",
			["unlock"] = "lock-open",
			["upload-cloud"] = "cloud-upload",
			["verified"] = "badge-check",
			["wand-2"] = "wand-sparkles",
			["wrap-text"] = "text-wrap",
			["x-circle"] = "circle-x",
			["x-octagon"] = "octagon-x",
			["x-square"] = "square-x",
		}

		local legacyFallback = {
			["chrome"] = "rbxassetid://10709797725",
			["gift-card"] = "rbxassetid://10723396225",
			["glass"] = "rbxassetid://10723397788",
			["help-circle"] = "rbxassetid://10723406988",
		}

		local function lookupIcon(name)
			if type(name) ~= "string" or name == "" then
				return nil
			end
			local clean = name:lower():gsub("^lucide%-", "")
			local direct = rawAssets[clean]
			if direct then
				return direct
			end
			local aliased = aliases[clean]
			if aliased then
				return rawAssets[aliased]
			end
			return legacyFallback[clean]
		end

		local assets = setmetatable({}, {
			__index = function(_, key)
				return lookupIcon(key)
			end
		})

		return {
			assets = assets,
			rawAssets = rawAssets,
			aliases = aliases,
			legacyFallback = legacyFallback,
			count = 1715,
			Get = function(_, name)
				return lookupIcon(name)
			end
		}
	end,
	[30] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(30)
		local Flipper = {
			SingleMotor = requireModule(moduleScript.SingleMotor),
			GroupMotor = requireModule(moduleScript.GroupMotor),
			Instant = requireModule(moduleScript.Instant),
			Linear = requireModule(moduleScript.Linear),
			Spring = requireModule(moduleScript.Spring),
			isMotor = requireModule(moduleScript.isMotor)
		}
		return Flipper
	end,
	[31] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(31)
		local cloneRef = cloneref or clonereference or function(instance)
			return instance
		end
		local RunService, Signal, noop, BaseMotor = cloneRef(game:GetService "RunService"), requireModule(moduleScript.Parent.Signal), function()
		end, {}
		BaseMotor.__index = BaseMotor
		function BaseMotor.new()
			return setmetatable({_onStep = Signal.new(), _onStart = Signal.new(), _onComplete = Signal.new()}, BaseMotor)
		end
		function BaseMotor.onStep(motor, handler)
			return motor._onStep:connect(handler)
		end
		function BaseMotor.onStart(motor, handler)
			return motor._onStart:connect(handler)
		end
		function BaseMotor.onComplete(motor, handler)
			return motor._onComplete:connect(handler)
		end
		-- Running motors are stepped in start order from one RenderStepped
		-- connection that exists only while something is animating. A reusable
		-- buffer avoids allocating a cloned table on every frame.
		local runningMotors = {}
		local stepBuffer = {}
		local schedulerConnection = nil
		local function stepRunningMotors(deltaTime)
			local count = #runningMotors
			for index = 1, count do
				stepBuffer[index] = runningMotors[index]
			end
			for index = 1, count do
				local motor = stepBuffer[index]
				stepBuffer[index] = nil
				if motor and motor._running then
					local ok, err = pcall(motor.step, motor, deltaTime)
					if not ok then
						motor:stop()
						task.spawn(error, err, 0)
					end
				end
			end
			if #runningMotors == 0 and schedulerConnection then
				schedulerConnection:Disconnect()
				schedulerConnection = nil
			end
		end
		function BaseMotor.start(motor)
			if not motor._running then
				motor._running = true
				table.insert(runningMotors, motor)
				if not schedulerConnection then
					schedulerConnection = RunService.RenderStepped:Connect(stepRunningMotors)
				end
			end
		end
		function BaseMotor.stop(motor)
			if motor._running then
				motor._running = false
				local index = table.find(runningMotors, motor)
				if index then
					table.remove(runningMotors, index)
				end
			end
		end
		BaseMotor.destroy = BaseMotor.stop
		BaseMotor.step = noop
		BaseMotor.getValue = noop
		BaseMotor.setGoal = noop
		function BaseMotor.__tostring(_motor)
			return "Motor"
		end
		return BaseMotor
	end,
	[33] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(33)
		local BaseMotor, SingleMotor, isMotor = requireModule(moduleScript.Parent.BaseMotor), requireModule(moduleScript.Parent.SingleMotor), requireModule(moduleScript.Parent.isMotor)
		local GroupMotor = setmetatable({}, BaseMotor)
		GroupMotor.__index = GroupMotor
		local toMotor = function(value)
			if isMotor(value) then
				return value
			end
			local valueType = typeof(value)
			if valueType == "number" then
				return SingleMotor.new(value, false)
			elseif valueType == "table" then
				return GroupMotor.new(value, false)
			end
			error(("Unable to convert %q to motor; type %s is unsupported"):format(value, valueType), 2)
		end
		function GroupMotor.new(initialValues, useImplicitConnections)
			assert(initialValues, "Missing argument #1: initialValues")
			assert(typeof(initialValues) == "table", "initialValues must be a table!")
			assert(
				not initialValues.step,
				[[initialValues contains disallowed property "step". Did you mean to put a table of values here?]]
			)
			local motor = setmetatable(BaseMotor.new(), GroupMotor)
			if useImplicitConnections ~= nil then
				motor._useImplicitConnections = useImplicitConnections
			else
				motor._useImplicitConnections = true
			end
			motor._complete = true
			motor._motors = {}
			for key, value in pairs(initialValues) do
				motor._motors[key] = toMotor(value)
			end
			return motor
		end
		function GroupMotor.step(motor, deltaTime)
			if motor._complete then
				return true
			end
			local allComplete = true
			for _, childMotor in pairs(motor._motors) do
				local complete = childMotor:step(deltaTime)
				if not complete then
					allComplete = false
				end
			end
			motor._onStep:fire(motor:getValue())
			if allComplete then
				if motor._useImplicitConnections then
					motor:stop()
				end
				motor._complete = true
				motor._onComplete:fire()
			end
			return allComplete
		end
		function GroupMotor.setGoal(motor, goals)
			assert(
				not goals.step,
				[[goals contains disallowed property "step". Did you mean to put a table of goals here?]]
			)
			motor._complete = false
			motor._onStart:fire()
			for key, goal in pairs(goals) do
				local childMotor = assert(motor._motors[key], ("Unknown motor for key %s"):format(key))
				childMotor:setGoal(goal)
			end
			if motor._useImplicitConnections then
				motor:start()
			end
		end
		function GroupMotor.getValue(motor)
			local values = {}
			for key, childMotor in pairs(motor._motors) do
				values[key] = childMotor:getValue()
			end
			return values
		end
		function GroupMotor.__tostring(_motor)
			return "Motor(Group)"
		end
		return GroupMotor
	end,
	[35] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(35)
		local Instant = {}
		Instant.__index = Instant
		function Instant.new(targetValue)
			return setmetatable({_targetValue = targetValue}, Instant)
		end
		function Instant.step(instant)
			return {complete = true, value = instant._targetValue}
		end
		return Instant
	end,
	[37] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(37)
		local Linear = {}
		Linear.__index = Linear
		function Linear.new(targetValue, options)
			assert(targetValue, "Missing argument #1: targetValue")
			options = options or {}
			return setmetatable({_targetValue = targetValue, _velocity = options.velocity or 1}, Linear)
		end
		function Linear.step(linear, state, dt)
			local position, velocity, goal = state.value, linear._velocity, linear._targetValue
			local delta = dt * velocity
			local complete = delta >= math.abs(goal - position)
			position = position + delta * (goal > position and 1 or -1)
			if complete then
				position = linear._targetValue
				velocity = 0
			end
			return {complete = complete, value = position, velocity = velocity}
		end
		return Linear
	end,
	[39] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(39)
		local Connection = {}
		Connection.__index = Connection
		function Connection.new(signal, handler)
			return setmetatable({signal = signal, connected = true, _handler = handler}, Connection)
		end
		function Connection.disconnect(connection)
			if connection.connected then
				connection.connected = false
				for index, other in pairs(connection.signal._connections) do
					if other == connection then
						table.remove(connection.signal._connections, index)
						return
					end
				end
			end
		end
		local Signal = {}
		Signal.__index = Signal
		function Signal.new()
			return setmetatable({_connections = {}, _threads = {}}, Signal)
		end
		function Signal.fire(signal, ...)
			for _, connection in pairs(signal._connections) do
				connection._handler(...)
			end
			for _, thread in pairs(signal._threads) do
				coroutine.resume(thread, ...)
			end
			signal._threads = {}
		end
		function Signal.connect(signal, handler)
			local connection = Connection.new(signal, handler)
			table.insert(signal._connections, connection)
			return connection
		end
		function Signal.wait(signal)
			table.insert(signal._threads, coroutine.running())
			return coroutine.yield()
		end
		return Signal
	end,
	[41] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(41)
		local BaseMotor = requireModule(moduleScript.Parent.BaseMotor)
		local SingleMotor = setmetatable({}, BaseMotor)
		SingleMotor.__index = SingleMotor
		function SingleMotor.new(initialValue, useImplicitConnections)
			assert(initialValue, "Missing argument #1: initialValue")
			assert(typeof(initialValue) == "number", "initialValue must be a number!")
			local motor = setmetatable(BaseMotor.new(), SingleMotor)
			if useImplicitConnections ~= nil then
				motor._useImplicitConnections = useImplicitConnections
			else
				motor._useImplicitConnections = true
			end
			motor._goal = nil
			motor._state = {complete = true, value = initialValue}
			return motor
		end
		function SingleMotor.step(motor, deltaTime)
			if motor._state.complete then
				return true
			end
			local newState = motor._goal:step(motor._state, deltaTime)
			motor._state = newState
			motor._onStep:fire(newState.value)
			if newState.complete then
				if motor._useImplicitConnections then
					motor:stop()
				end
				motor._onComplete:fire()
			end
			return newState.complete
		end
		function SingleMotor.getValue(motor)
			return motor._state.value
		end
		function SingleMotor.setGoal(motor, goal)
			motor._state.complete = false
			motor._goal = goal
			motor._onStart:fire()
			if motor._useImplicitConnections then
				motor:start()
			end
		end
		function SingleMotor.__tostring(_motor)
			return "Motor(Single)"
		end
		return SingleMotor
	end,
	[43] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(43)
		local VELOCITY_THRESHOLD, POSITION_THRESHOLD, EPS, Spring = 0.001, 0.001, 0.0001, {}
		Spring.__index = Spring
		function Spring.new(targetValue, options)
			assert(targetValue, "Missing argument #1: targetValue")
			options = options or {}
			return setmetatable(
				{_targetValue = targetValue, _frequency = options.frequency or 4, _dampingRatio = options.dampingRatio or 1},
				Spring
			)
		end
		function Spring.step(spring, state, dt)
			local damping, frequency, goal, p0, v0 = spring._dampingRatio, spring._frequency * 2 * math.pi, spring._targetValue, state.value, state.velocity or 0
			local offset, decay, p1, v1 = p0 - goal, (math.exp(-damping * frequency * dt))
			if damping == 1 then
				p1 = (offset * (1 + frequency * dt) + v0 * dt) * decay + goal
				v1 = (v0 * (1 - frequency * dt) - offset * (frequency * frequency * dt)) * decay
			elseif damping < 1 then
				local dampedRoot = math.sqrt(1 - damping * damping)
				local cosTerm, sinTerm, sinOverRoot = math.cos(frequency * dampedRoot * dt), (math.sin(frequency * dampedRoot * dt))
				if dampedRoot > EPS then
					sinOverRoot = sinTerm / dampedRoot
				else
					local angle = dt * frequency
					sinOverRoot = angle + ((angle * angle) * (dampedRoot * dampedRoot) * (dampedRoot * dampedRoot) / 20 - dampedRoot * dampedRoot) * (angle * angle * angle) / 6
				end
				local sinOverFreqRoot
				if frequency * dampedRoot > EPS then
					sinOverFreqRoot = sinTerm / (frequency * dampedRoot)
				else
					local freqRoot = frequency * dampedRoot
					sinOverFreqRoot = dt + ((dt * dt) * (freqRoot * freqRoot) * (freqRoot * freqRoot) / 20 - freqRoot * freqRoot) * (dt * dt * dt) / 6
				end
				p1 = (offset * (cosTerm + damping * sinOverRoot) + v0 * sinOverFreqRoot) * decay + goal
				v1 = (v0 * (cosTerm - sinOverRoot * damping) - offset * (sinOverRoot * frequency)) * decay
			else
				local dampedRoot = math.sqrt(damping * damping - 1)
				local r1, r2 = -frequency * (damping - dampedRoot), -frequency * (damping + dampedRoot)
				local co2 = (v0 - offset * r1) / (2 * frequency * dampedRoot)
				local co1 = offset - co2
				local e1, e2 = co1 * math.exp(r1 * dt), co2 * math.exp(r2 * dt)
				p1 = e1 + e2 + goal
				v1 = e1 * r1 + e2 * r2
			end
			local complete = math.abs(v1) < VELOCITY_THRESHOLD and math.abs(p1 - goal) < POSITION_THRESHOLD
			return {complete = complete, value = complete and goal or p1, velocity = v1}
		end
		return Spring
	end,
	[45] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(45)
		local isMotor = function(value)
			local motorType = tostring(value):match "^Motor%((.+)%)$"
			if motorType then
				return true, motorType
			else
				return false
			end
		end
		return isMotor
	end,
	[47] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(47)
		local Themes = {
			Names = {
				"Acryven",
				"Dark",
				"Darker",
				"Dark V2",
				"Darker V2",
				"Light",
				"Aqua",
				"Amethyst",
				"Rose",
				"Ocean",
				"Forest",
				"Sunset",
				"Midnight",
				"Cherry",
				"Lavender",
				"Gold",
				"Mint",
				"Crimson",
				"Sapphire",
				"Peach",
				"Galaxy",
				"RGB"
			}
		}
		local extraNames = {}
		for _, child in next, moduleScript:GetChildren() do
			local theme = requireModule(child)
			if theme and theme.Name then
				Themes[theme.Name] = theme
				if not table.find(Themes.Names, theme.Name) and not table.find(extraNames, theme.Name) then
					table.insert(extraNames, theme.Name)
				end
			end
		end
		table.sort(extraNames)
		for _, name in next, extraNames do
			table.insert(Themes.Names, name)
		end
		return Themes
	end,
	[48] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(48)
		return {
			Name = "Amethyst",
			Accent = Color3.fromRGB(147, 51, 234),
			AcrylicMain = Color3.fromRGB(15, 10, 20),
			AcrylicBorder = Color3.fromRGB(147, 51, 234),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(100, 40, 160), Color3.fromRGB(50, 20, 80)),
			AcrylicNoise = 0.92,
			TitleBarLine = Color3.fromRGB(147, 51, 234),
			Tab = Color3.fromRGB(200, 150, 255),
			Element = Color3.fromRGB(25, 15, 35),
			ElementBorder = Color3.fromRGB(147, 51, 234),
			InElementBorder = Color3.fromRGB(120, 80, 180),
			ElementTransparency = 0.12,
			ToggleSlider = Color3.fromRGB(200, 150, 255),
			ToggleToggled = Color3.fromRGB(10, 5, 15),
			SliderRail = Color3.fromRGB(200, 150, 255),
			DropdownFrame = Color3.fromRGB(25, 15, 35),
			DropdownHolder = Color3.fromRGB(20, 12, 28),
			DropdownBorder = Color3.fromRGB(147, 51, 234),
			DropdownOption = Color3.fromRGB(200, 150, 255),
			Keybind = Color3.fromRGB(200, 150, 255),
			Input = Color3.fromRGB(200, 150, 255),
			InputFocused = Color3.fromRGB(15, 10, 20),
			InputIndicator = Color3.fromRGB(220, 180, 255),
			Dialog = Color3.fromRGB(20, 12, 28),
			DialogHolder = Color3.fromRGB(15, 10, 20),
			DialogHolderLine = Color3.fromRGB(147, 51, 234),
			DialogButton = Color3.fromRGB(25, 15, 35),
			DialogButtonBorder = Color3.fromRGB(147, 51, 234),
			DialogBorder = Color3.fromRGB(147, 51, 234),
			DialogInput = Color3.fromRGB(30, 20, 40),
			DialogInputLine = Color3.fromRGB(200, 150, 255),
			Text = Color3.fromRGB(255, 255, 255),
			SubText = Color3.fromRGB(200, 180, 220),
			Hover = Color3.fromRGB(200, 150, 255),
			HoverChange = 0.08
		}
	end,
	[49] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(49)
		return {
			Name = "Aqua",
			Accent = Color3.fromRGB(0, 255, 255),
			AcrylicMain = Color3.fromRGB(10, 20, 25),
			AcrylicBorder = Color3.fromRGB(0, 200, 200),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(0, 150, 180), Color3.fromRGB(0, 80, 100)),
			AcrylicNoise = 0.90,
			TitleBarLine = Color3.fromRGB(0, 255, 255),
			Tab = Color3.fromRGB(100, 255, 255),
			Element = Color3.fromRGB(15, 25, 30),
			ElementBorder = Color3.fromRGB(0, 255, 255),
			InElementBorder = Color3.fromRGB(0, 200, 200),
			ElementTransparency = 0.10,
			ToggleSlider = Color3.fromRGB(100, 255, 255),
			ToggleToggled = Color3.fromRGB(5, 10, 12),
			SliderRail = Color3.fromRGB(100, 255, 255),
			DropdownFrame = Color3.fromRGB(15, 25, 30),
			DropdownHolder = Color3.fromRGB(10, 18, 22),
			DropdownBorder = Color3.fromRGB(0, 255, 255),
			DropdownOption = Color3.fromRGB(100, 255, 255),
			Keybind = Color3.fromRGB(100, 255, 255),
			Input = Color3.fromRGB(100, 255, 255),
			InputFocused = Color3.fromRGB(10, 20, 25),
			InputIndicator = Color3.fromRGB(150, 255, 255),
			Dialog = Color3.fromRGB(10, 18, 22),
			DialogHolder = Color3.fromRGB(8, 15, 18),
			DialogHolderLine = Color3.fromRGB(0, 255, 255),
			DialogButton = Color3.fromRGB(15, 25, 30),
			DialogButtonBorder = Color3.fromRGB(0, 255, 255),
			DialogBorder = Color3.fromRGB(0, 255, 255),
			DialogInput = Color3.fromRGB(20, 30, 35),
			DialogInputLine = Color3.fromRGB(100, 255, 255),
			Text = Color3.fromRGB(255, 255, 255),
			SubText = Color3.fromRGB(180, 230, 240),
			Hover = Color3.fromRGB(100, 255, 255),
			HoverChange = 0.08
		}
	end,
	[50] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(50)
		return {
			Name = "Dark V2",
			Accent = Color3.fromRGB(96, 205, 255),
			AcrylicMain = Color3.fromRGB(20, 20, 20),
			AcrylicBorder = Color3.fromRGB(200, 200, 200),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(15, 15, 15)),
			AcrylicNoise = 0.88,
			TitleBarLine = Color3.fromRGB(200, 200, 200),
			Tab = Color3.fromRGB(180, 180, 180),
			Element = Color3.fromRGB(25, 25, 25),
			ElementBorder = Color3.fromRGB(200, 200, 200),
			InElementBorder = Color3.fromRGB(160, 160, 160),
			ElementTransparency = 0.08,
			ToggleSlider = Color3.fromRGB(180, 180, 180),
			ToggleToggled = Color3.fromRGB(10, 10, 10),
			SliderRail = Color3.fromRGB(180, 180, 180),
			DropdownFrame = Color3.fromRGB(25, 25, 25),
			DropdownHolder = Color3.fromRGB(18, 18, 18),
			DropdownBorder = Color3.fromRGB(200, 200, 200),
			DropdownOption = Color3.fromRGB(180, 180, 180),
			Keybind = Color3.fromRGB(180, 180, 180),
			Input = Color3.fromRGB(180, 180, 180),
			InputFocused = Color3.fromRGB(15, 15, 15),
			InputIndicator = Color3.fromRGB(200, 200, 200),
			Dialog = Color3.fromRGB(18, 18, 18),
			DialogHolder = Color3.fromRGB(15, 15, 15),
			DialogHolderLine = Color3.fromRGB(200, 200, 200),
			DialogButton = Color3.fromRGB(25, 25, 25),
			DialogButtonBorder = Color3.fromRGB(200, 200, 200),
			DialogBorder = Color3.fromRGB(200, 200, 200),
			DialogInput = Color3.fromRGB(30, 30, 30),
			DialogInputLine = Color3.fromRGB(180, 180, 180),
			Text = Color3.fromRGB(255, 255, 255),
			SubText = Color3.fromRGB(200, 200, 200),
			Hover = Color3.fromRGB(180, 180, 180),
			HoverChange = 0.10
		}
	end,
	[51] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(51)
		return {
			Name = "Darker V2",
			Accent = Color3.fromRGB(72, 138, 182),
			AcrylicMain = Color3.fromRGB(12, 12, 12),
			AcrylicBorder = Color3.fromRGB(180, 180, 180),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(18, 18, 18), Color3.fromRGB(8, 8, 8)),
			AcrylicNoise = 0.92,
			TitleBarLine = Color3.fromRGB(180, 180, 180),
			Tab = Color3.fromRGB(160, 160, 160),
			Element = Color3.fromRGB(15, 15, 15),
			ElementBorder = Color3.fromRGB(180, 180, 180),
			InElementBorder = Color3.fromRGB(140, 140, 140),
			ElementTransparency = 0.06,
			ToggleSlider = Color3.fromRGB(160, 160, 160),
			ToggleToggled = Color3.fromRGB(5, 5, 5),
			SliderRail = Color3.fromRGB(160, 160, 160),
			DropdownFrame = Color3.fromRGB(15, 15, 15),
			DropdownHolder = Color3.fromRGB(10, 10, 10),
			DropdownBorder = Color3.fromRGB(180, 180, 180),
			DropdownOption = Color3.fromRGB(160, 160, 160),
			Keybind = Color3.fromRGB(160, 160, 160),
			Input = Color3.fromRGB(160, 160, 160),
			InputFocused = Color3.fromRGB(8, 8, 8),
			InputIndicator = Color3.fromRGB(180, 180, 180),
			Dialog = Color3.fromRGB(10, 10, 10),
			DialogHolder = Color3.fromRGB(8, 8, 8),
			DialogHolderLine = Color3.fromRGB(180, 180, 180),
			DialogButton = Color3.fromRGB(15, 15, 15),
			DialogButtonBorder = Color3.fromRGB(180, 180, 180),
			DialogBorder = Color3.fromRGB(180, 180, 180),
			DialogInput = Color3.fromRGB(20, 20, 20),
			DialogInputLine = Color3.fromRGB(160, 160, 160),
			Text = Color3.fromRGB(255, 255, 255),
			SubText = Color3.fromRGB(190, 190, 190),
			Hover = Color3.fromRGB(160, 160, 160),
			HoverChange = 0.09
		}
	end,
	[52] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(52)
		return {
			Name = "Light",
			Accent = Color3.fromRGB(37, 99, 235),
			AcrylicMain = Color3.fromRGB(246, 248, 252),
			AcrylicBorder = Color3.fromRGB(168, 178, 196),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(238, 242, 248)),
			AcrylicNoise = 0.95,
			TitleBarLine = Color3.fromRGB(170, 180, 198),
			Tab = Color3.fromRGB(37, 99, 235),
			Element = Color3.fromRGB(255, 255, 255),
			ElementBorder = Color3.fromRGB(158, 170, 192),
			InElementBorder = Color3.fromRGB(142, 156, 180),
			ElementTransparency = 0.22,
			ToggleSlider = Color3.fromRGB(148, 163, 184),
			ToggleToggled = Color3.fromRGB(255, 255, 255),
			SliderRail = Color3.fromRGB(186, 196, 214),
			DropdownFrame = Color3.fromRGB(255, 255, 255),
			DropdownHolder = Color3.fromRGB(250, 252, 255),
			DropdownBorder = Color3.fromRGB(148, 162, 186),
			DropdownOption = Color3.fromRGB(37, 99, 235),
			Keybind = Color3.fromRGB(238, 242, 248),
			Input = Color3.fromRGB(241, 245, 249),
			InputFocused = Color3.fromRGB(255, 255, 255),
			InputIndicator = Color3.fromRGB(37, 99, 235),
			Dialog = Color3.fromRGB(252, 253, 255),
			DialogHolder = Color3.fromRGB(241, 245, 249),
			DialogHolderLine = Color3.fromRGB(203, 213, 225),
			DialogButton = Color3.fromRGB(255, 255, 255),
			DialogButtonBorder = Color3.fromRGB(148, 162, 186),
			DialogBorder = Color3.fromRGB(142, 156, 180),
			DialogInput = Color3.fromRGB(244, 247, 252),
			DialogInputLine = Color3.fromRGB(37, 99, 235),
			Text = Color3.fromRGB(15, 20, 32),
			SubText = Color3.fromRGB(62, 74, 94),
			Hover = Color3.fromRGB(15, 23, 42),
			HoverChange = 0.08
		}
	end,
	[53] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(53)
		return {
			Name = "Rose",
			Accent = Color3.fromRGB(255, 20, 147),
			AcrylicMain = Color3.fromRGB(18, 10, 15),
			AcrylicBorder = Color3.fromRGB(255, 105, 180),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(200, 50, 120), Color3.fromRGB(120, 30, 70)),
			AcrylicNoise = 0.90,
			TitleBarLine = Color3.fromRGB(255, 105, 180),
			Tab = Color3.fromRGB(255, 120, 160),
			Element = Color3.fromRGB(25, 12, 18),
			ElementBorder = Color3.fromRGB(255, 60, 120),
			InElementBorder = Color3.fromRGB(230, 50, 110),
			ElementTransparency = 0.09,
			ToggleSlider = Color3.fromRGB(255, 120, 160),
			ToggleToggled = Color3.fromRGB(10, 5, 7),
			SliderRail = Color3.fromRGB(255, 120, 160),
			DropdownFrame = Color3.fromRGB(25, 12, 18),
			DropdownHolder = Color3.fromRGB(18, 8, 12),
			DropdownBorder = Color3.fromRGB(255, 60, 120),
			DropdownOption = Color3.fromRGB(255, 120, 160),
			Keybind = Color3.fromRGB(255, 120, 160),
			Input = Color3.fromRGB(255, 120, 160),
			InputFocused = Color3.fromRGB(20, 10, 15),
			InputIndicator = Color3.fromRGB(255, 150, 180),
			Dialog = Color3.fromRGB(18, 8, 12),
			DialogHolder = Color3.fromRGB(15, 7, 10),
			DialogHolderLine = Color3.fromRGB(255, 60, 120),
			DialogButton = Color3.fromRGB(25, 12, 18),
			DialogButtonBorder = Color3.fromRGB(255, 60, 120),
			DialogBorder = Color3.fromRGB(255, 60, 120),
			DialogInput = Color3.fromRGB(30, 15, 22),
			DialogInputLine = Color3.fromRGB(255, 120, 160),
			Text = Color3.fromRGB(255, 255, 255),
			SubText = Color3.fromRGB(255, 200, 220),
			Hover = Color3.fromRGB(255, 120, 160),
			HoverChange = 0.08
		}
	end,
	[54] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(54)
		return {
			Name = "Ocean",
			Accent = Color3.fromRGB(0, 191, 255),
			AcrylicMain = Color3.fromRGB(8, 18, 30),
			AcrylicBorder = Color3.fromRGB(0, 191, 255),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(10, 80, 140), Color3.fromRGB(5, 40, 80)),
			AcrylicNoise = 0.91,
			TitleBarLine = Color3.fromRGB(0, 191, 255),
			Tab = Color3.fromRGB(100, 220, 255),
			Element = Color3.fromRGB(12, 25, 40),
			ElementBorder = Color3.fromRGB(0, 191, 255),
			InElementBorder = Color3.fromRGB(0, 160, 220),
			ElementTransparency = 0.10,
			ToggleSlider = Color3.fromRGB(100, 220, 255),
			ToggleToggled = Color3.fromRGB(5, 12, 20),
			SliderRail = Color3.fromRGB(100, 220, 255),
			DropdownFrame = Color3.fromRGB(12, 25, 40),
			DropdownHolder = Color3.fromRGB(8, 18, 30),
			DropdownBorder = Color3.fromRGB(0, 191, 255),
			DropdownOption = Color3.fromRGB(100, 220, 255),
			Keybind = Color3.fromRGB(100, 220, 255),
			Input = Color3.fromRGB(100, 220, 255),
			InputFocused = Color3.fromRGB(10, 20, 35),
			InputIndicator = Color3.fromRGB(150, 235, 255),
			Dialog = Color3.fromRGB(8, 18, 30),
			DialogHolder = Color3.fromRGB(6, 15, 25),
			DialogHolderLine = Color3.fromRGB(0, 191, 255),
			DialogButton = Color3.fromRGB(12, 25, 40),
			DialogButtonBorder = Color3.fromRGB(0, 191, 255),
			DialogBorder = Color3.fromRGB(0, 191, 255),
			DialogInput = Color3.fromRGB(15, 30, 50),
			DialogInputLine = Color3.fromRGB(100, 220, 255),
			Text = Color3.fromRGB(255, 255, 255),
			SubText = Color3.fromRGB(180, 220, 240),
			Hover = Color3.fromRGB(100, 220, 255),
			HoverChange = 0.08
		}
	end,
	[55] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(55)
		return {
			Name = "Forest",
			Accent = Color3.fromRGB(50, 205, 50),
			AcrylicMain = Color3.fromRGB(10, 18, 12),
			AcrylicBorder = Color3.fromRGB(50, 205, 50),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(30, 100, 40), Color3.fromRGB(15, 50, 20)),
			AcrylicNoise = 0.89,
			TitleBarLine = Color3.fromRGB(50, 205, 50),
			Tab = Color3.fromRGB(120, 230, 120),
			Element = Color3.fromRGB(15, 25, 18),
			ElementBorder = Color3.fromRGB(50, 205, 50),
			InElementBorder = Color3.fromRGB(40, 180, 40),
			ElementTransparency = 0.10,
			ToggleSlider = Color3.fromRGB(120, 230, 120),
			ToggleToggled = Color3.fromRGB(8, 12, 10),
			SliderRail = Color3.fromRGB(120, 230, 120),
			DropdownFrame = Color3.fromRGB(15, 25, 18),
			DropdownHolder = Color3.fromRGB(10, 18, 12),
			DropdownBorder = Color3.fromRGB(50, 205, 50),
			DropdownOption = Color3.fromRGB(120, 230, 120),
			Keybind = Color3.fromRGB(120, 230, 120),
			Input = Color3.fromRGB(120, 230, 120),
			InputFocused = Color3.fromRGB(12, 20, 15),
			InputIndicator = Color3.fromRGB(150, 240, 150),
			Dialog = Color3.fromRGB(10, 18, 12),
			DialogHolder = Color3.fromRGB(8, 15, 10),
			DialogHolderLine = Color3.fromRGB(50, 205, 50),
			DialogButton = Color3.fromRGB(15, 25, 18),
			DialogButtonBorder = Color3.fromRGB(50, 205, 50),
			DialogBorder = Color3.fromRGB(50, 205, 50),
			DialogInput = Color3.fromRGB(20, 30, 22),
			DialogInputLine = Color3.fromRGB(120, 230, 120),
			Text = Color3.fromRGB(255, 255, 255),
			SubText = Color3.fromRGB(200, 240, 200),
			Hover = Color3.fromRGB(120, 230, 120),
			HoverChange = 0.08
		}
	end,
	[56] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(56)
		return {
			Name = "Sunset",
			Accent = Color3.fromRGB(255, 140, 0),
			AcrylicMain = Color3.fromRGB(20, 10, 8),
			AcrylicBorder = Color3.fromRGB(255, 140, 0),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(180, 80, 30), Color3.fromRGB(120, 40, 15)),
			AcrylicNoise = 0.88,
			TitleBarLine = Color3.fromRGB(255, 140, 0),
			Tab = Color3.fromRGB(255, 180, 100),
			Element = Color3.fromRGB(28, 15, 10),
			ElementBorder = Color3.fromRGB(255, 140, 0),
			InElementBorder = Color3.fromRGB(230, 120, 0),
			ElementTransparency = 0.09,
			ToggleSlider = Color3.fromRGB(255, 180, 100),
			ToggleToggled = Color3.fromRGB(12, 6, 4),
			SliderRail = Color3.fromRGB(255, 180, 100),
			DropdownFrame = Color3.fromRGB(28, 15, 10),
			DropdownHolder = Color3.fromRGB(20, 10, 8),
			DropdownBorder = Color3.fromRGB(255, 140, 0),
			DropdownOption = Color3.fromRGB(255, 180, 100),
			Keybind = Color3.fromRGB(255, 180, 100),
			Input = Color3.fromRGB(255, 180, 100),
			InputFocused = Color3.fromRGB(22, 12, 9),
			InputIndicator = Color3.fromRGB(255, 200, 130),
			Dialog = Color3.fromRGB(20, 10, 8),
			DialogHolder = Color3.fromRGB(16, 8, 6),
			DialogHolderLine = Color3.fromRGB(255, 140, 0),
			DialogButton = Color3.fromRGB(28, 15, 10),
			DialogButtonBorder = Color3.fromRGB(255, 140, 0),
			DialogBorder = Color3.fromRGB(255, 140, 0),
			DialogInput = Color3.fromRGB(35, 20, 12),
			DialogInputLine = Color3.fromRGB(255, 180, 100),
			Text = Color3.fromRGB(255, 255, 255),
			SubText = Color3.fromRGB(255, 220, 180),
			Hover = Color3.fromRGB(255, 180, 100),
			HoverChange = 0.10
		}
	end,
	[57] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(57)
		return {
			Name = "Midnight",
			Accent = Color3.fromRGB(180, 200, 255), -- slightly cooler accent for contrast
			AcrylicMain = Color3.fromRGB(0, 0, 0), -- fully black background for maximum contrast
			AcrylicBorder = Color3.fromRGB(245, 245, 255), -- bright border to stand out on black
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(6, 6, 8), Color3.fromRGB(0, 0, 0)),
			AcrylicNoise = 0.96,
			TitleBarLine = Color3.fromRGB(245, 245, 255),
			Tab = Color3.fromRGB(220, 220, 255),
			Element = Color3.fromRGB(3, 3, 6), -- very dark elements
			ElementBorder = Color3.fromRGB(245, 245, 255),
			InElementBorder = Color3.fromRGB(180, 180, 220),
			ElementTransparency = 0.03, -- nearly opaque for stronger contrast
			ToggleSlider = Color3.fromRGB(220, 220, 255),
			ToggleToggled = Color3.fromRGB(0, 0, 0),
			SliderRail = Color3.fromRGB(220, 220, 255),
			DropdownFrame = Color3.fromRGB(3, 3, 6),
			DropdownHolder = Color3.fromRGB(2, 2, 4),
			DropdownBorder = Color3.fromRGB(245, 245, 255),
			DropdownOption = Color3.fromRGB(220, 220, 255),
			Keybind = Color3.fromRGB(220, 220, 255),
			Input = Color3.fromRGB(220, 220, 255),
			InputFocused = Color3.fromRGB(4, 4, 8),
			InputIndicator = Color3.fromRGB(245, 245, 255),
			Dialog = Color3.fromRGB(0, 0, 0),
			DialogHolder = Color3.fromRGB(2, 2, 5),
			DialogHolderLine = Color3.fromRGB(245, 245, 255),
			DialogButton = Color3.fromRGB(3, 3, 6),
			DialogButtonBorder = Color3.fromRGB(245, 245, 255),
			DialogBorder = Color3.fromRGB(245, 245, 255),
			DialogInput = Color3.fromRGB(6, 6, 12),
			DialogInputLine = Color3.fromRGB(220, 220, 255),
			Text = Color3.fromRGB(255, 255, 255),
			SubText = Color3.fromRGB(200, 200, 220),
			Hover = Color3.fromRGB(245, 245, 255),
			HoverChange = 0.14
		}
	end,
	[58] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(58)
		return {
			Name = "Cherry",
			Accent = Color3.fromRGB(255, 0, 102),
			AcrylicMain = Color3.fromRGB(18, 8, 12),
			AcrylicBorder = Color3.fromRGB(255, 60, 120),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(160, 20, 60), Color3.fromRGB(90, 10, 35)),
			AcrylicNoise = 0.89,
			TitleBarLine = Color3.fromRGB(255, 60, 120),
			Tab = Color3.fromRGB(255, 100, 140),
			Element = Color3.fromRGB(25, 12, 18),
			ElementBorder = Color3.fromRGB(255, 60, 120),
			InElementBorder = Color3.fromRGB(230, 40, 90),
			ElementTransparency = 0.09,
			ToggleSlider = Color3.fromRGB(255, 100, 140),
			ToggleToggled = Color3.fromRGB(10, 5, 7),
			SliderRail = Color3.fromRGB(255, 100, 140),
			DropdownFrame = Color3.fromRGB(25, 12, 18),
			DropdownHolder = Color3.fromRGB(18, 8, 12),
			DropdownBorder = Color3.fromRGB(255, 60, 120),
			DropdownOption = Color3.fromRGB(255, 100, 140),
			Keybind = Color3.fromRGB(255, 100, 140),
			Input = Color3.fromRGB(255, 100, 140),
			InputFocused = Color3.fromRGB(20, 10, 15),
			InputIndicator = Color3.fromRGB(255, 140, 170),
			Dialog = Color3.fromRGB(18, 8, 12),
			DialogHolder = Color3.fromRGB(15, 7, 10),
			DialogHolderLine = Color3.fromRGB(255, 60, 120),
			DialogButton = Color3.fromRGB(25, 12, 18),
			DialogButtonBorder = Color3.fromRGB(255, 60, 120),
			DialogBorder = Color3.fromRGB(255, 60, 120),
			DialogInput = Color3.fromRGB(30, 15, 22),
			DialogInputLine = Color3.fromRGB(255, 100, 140),
			Text = Color3.fromRGB(255, 255, 255),
			SubText = Color3.fromRGB(255, 190, 210),
			Hover = Color3.fromRGB(255, 100, 140),
			HoverChange = 0.08
		}
	end,
	[59] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(59)
		return {
			Name = "Lavender",
			Accent = Color3.fromRGB(180, 120, 255),
			AcrylicMain = Color3.fromRGB(15, 12, 22),
			AcrylicBorder = Color3.fromRGB(180, 120, 255),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(100, 70, 160), Color3.fromRGB(50, 35, 90)),
			AcrylicNoise = 0.91,
			TitleBarLine = Color3.fromRGB(180, 120, 255),
			Tab = Color3.fromRGB(200, 160, 255),
			Element = Color3.fromRGB(20, 16, 30),
			ElementBorder = Color3.fromRGB(180, 120, 255),
			InElementBorder = Color3.fromRGB(160, 100, 230),
			ElementTransparency = 0.10,
			ToggleSlider = Color3.fromRGB(200, 160, 255),
			ToggleToggled = Color3.fromRGB(8, 6, 12),
			SliderRail = Color3.fromRGB(200, 160, 255),
			DropdownFrame = Color3.fromRGB(20, 16, 30),
			DropdownHolder = Color3.fromRGB(15, 12, 22),
			DropdownBorder = Color3.fromRGB(180, 120, 255),
			DropdownOption = Color3.fromRGB(200, 160, 255),
			Keybind = Color3.fromRGB(200, 160, 255),
			Input = Color3.fromRGB(200, 160, 255),
			InputFocused = Color3.fromRGB(17, 14, 25),
			InputIndicator = Color3.fromRGB(220, 180, 255),
			Dialog = Color3.fromRGB(15, 12, 22),
			DialogHolder = Color3.fromRGB(12, 10, 18),
			DialogHolderLine = Color3.fromRGB(180, 120, 255),
			DialogButton = Color3.fromRGB(20, 16, 30),
			DialogButtonBorder = Color3.fromRGB(180, 120, 255),
			DialogBorder = Color3.fromRGB(180, 120, 255),
			DialogInput = Color3.fromRGB(25, 20, 38),
			DialogInputLine = Color3.fromRGB(200, 160, 255),
			Text = Color3.fromRGB(255, 255, 255),
			SubText = Color3.fromRGB(220, 200, 250),
			Hover = Color3.fromRGB(200, 160, 255),
			HoverChange = 0.08
		}
	end,
	[60] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(60)
		return {
			Name = "Gold",
			Accent = Color3.fromRGB(255, 215, 0),
			AcrylicMain = Color3.fromRGB(20, 18, 10),
			AcrylicBorder = Color3.fromRGB(255, 215, 0),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(150, 130, 30), Color3.fromRGB(80, 70, 15)),
			AcrylicNoise = 0.87,
			TitleBarLine = Color3.fromRGB(255, 215, 0),
			Tab = Color3.fromRGB(255, 230, 100),
			Element = Color3.fromRGB(28, 25, 15),
			ElementBorder = Color3.fromRGB(255, 215, 0),
			InElementBorder = Color3.fromRGB(230, 190, 0),
			ElementTransparency = 0.09,
			ToggleSlider = Color3.fromRGB(255, 230, 100),
			ToggleToggled = Color3.fromRGB(12, 10, 5),
			SliderRail = Color3.fromRGB(255, 230, 100),
			DropdownFrame = Color3.fromRGB(28, 25, 15),
			DropdownHolder = Color3.fromRGB(20, 18, 10),
			DropdownBorder = Color3.fromRGB(255, 215, 0),
			DropdownOption = Color3.fromRGB(255, 230, 100),
			Keybind = Color3.fromRGB(255, 230, 100),
			Input = Color3.fromRGB(255, 230, 100),
			InputFocused = Color3.fromRGB(23, 20, 12),
			InputIndicator = Color3.fromRGB(255, 240, 150),
			Dialog = Color3.fromRGB(20, 18, 10),
			DialogHolder = Color3.fromRGB(16, 14, 8),
			DialogHolderLine = Color3.fromRGB(255, 215, 0),
			DialogButton = Color3.fromRGB(28, 25, 15),
			DialogButtonBorder = Color3.fromRGB(255, 215, 0),
			DialogBorder = Color3.fromRGB(255, 215, 0),
			DialogInput = Color3.fromRGB(35, 30, 18),
			DialogInputLine = Color3.fromRGB(255, 230, 100),
			Text = Color3.fromRGB(255, 255, 255),
			SubText = Color3.fromRGB(255, 240, 180),
			Hover = Color3.fromRGB(255, 230, 100),
			HoverChange = 0.10
		}
	end,
	[61] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(61)
		return {
			Name = "Mint",
			Accent = Color3.fromRGB(0, 255, 200),
			AcrylicMain = Color3.fromRGB(10, 20, 18),
			AcrylicBorder = Color3.fromRGB(0, 255, 200),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(20, 120, 100), Color3.fromRGB(10, 60, 50)),
			AcrylicNoise = 0.90,
			TitleBarLine = Color3.fromRGB(0, 255, 200),
			Tab = Color3.fromRGB(100, 255, 220),
			Element = Color3.fromRGB(15, 28, 25),
			ElementBorder = Color3.fromRGB(0, 255, 200),
			InElementBorder = Color3.fromRGB(0, 220, 170),
			ElementTransparency = 0.10,
			ToggleSlider = Color3.fromRGB(100, 255, 220),
			ToggleToggled = Color3.fromRGB(5, 12, 10),
			SliderRail = Color3.fromRGB(100, 255, 220),
			DropdownFrame = Color3.fromRGB(15, 28, 25),
			DropdownHolder = Color3.fromRGB(10, 20, 18),
			DropdownBorder = Color3.fromRGB(0, 255, 200),
			DropdownOption = Color3.fromRGB(100, 255, 220),
			Keybind = Color3.fromRGB(100, 255, 220),
			Input = Color3.fromRGB(100, 255, 220),
			InputFocused = Color3.fromRGB(12, 23, 20),
			InputIndicator = Color3.fromRGB(150, 255, 230),
			Dialog = Color3.fromRGB(10, 20, 18),
			DialogHolder = Color3.fromRGB(8, 16, 14),
			DialogHolderLine = Color3.fromRGB(0, 255, 200),
			DialogButton = Color3.fromRGB(15, 28, 25),
			DialogButtonBorder = Color3.fromRGB(0, 255, 200),
			DialogBorder = Color3.fromRGB(0, 255, 200),
			DialogInput = Color3.fromRGB(20, 35, 30),
			DialogInputLine = Color3.fromRGB(100, 255, 220),
			Text = Color3.fromRGB(255, 255, 255),
			SubText = Color3.fromRGB(200, 255, 240),
			Hover = Color3.fromRGB(100, 255, 220),
			HoverChange = 0.08
		}
	end,
	[62] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(62)
		return {
			Name = "Crimson",
			Accent = Color3.fromRGB(255, 0, 60),
			AcrylicMain = Color3.fromRGB(20, 8, 10),
			AcrylicBorder = Color3.fromRGB(255, 50, 80),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(150, 30, 40), Color3.fromRGB(80, 15, 20)),
			AcrylicNoise = 0.88,
			TitleBarLine = Color3.fromRGB(255, 50, 80),
			Tab = Color3.fromRGB(255, 100, 120),
			Element = Color3.fromRGB(28, 12, 15),
			ElementBorder = Color3.fromRGB(255, 50, 80),
			InElementBorder = Color3.fromRGB(230, 40, 70),
			ElementTransparency = 0.09,
			ToggleSlider = Color3.fromRGB(255, 100, 120),
			ToggleToggled = Color3.fromRGB(12, 5, 6),
			SliderRail = Color3.fromRGB(255, 100, 120),
			DropdownFrame = Color3.fromRGB(28, 12, 15),
			DropdownHolder = Color3.fromRGB(20, 8, 10),
			DropdownBorder = Color3.fromRGB(255, 50, 80),
			DropdownOption = Color3.fromRGB(255, 100, 120),
			Keybind = Color3.fromRGB(255, 100, 120),
			Input = Color3.fromRGB(255, 100, 120),
			InputFocused = Color3.fromRGB(23, 10, 12),
			InputIndicator = Color3.fromRGB(255, 130, 150),
			Dialog = Color3.fromRGB(20, 8, 10),
			DialogHolder = Color3.fromRGB(16, 6, 8),
			DialogHolderLine = Color3.fromRGB(255, 50, 80),
			DialogButton = Color3.fromRGB(28, 12, 15),
			DialogButtonBorder = Color3.fromRGB(255, 50, 80),
			DialogBorder = Color3.fromRGB(255, 50, 80),
			DialogInput = Color3.fromRGB(35, 15, 18),
			DialogInputLine = Color3.fromRGB(255, 100, 120),
			Text = Color3.fromRGB(255, 255, 255),
			SubText = Color3.fromRGB(255, 200, 210),
			Hover = Color3.fromRGB(255, 100, 120),
			HoverChange = 0.09
		}
	end,
	[63] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(63)
		return {
			Name = "Sapphire",
			Accent = Color3.fromRGB(0, 120, 255),
			AcrylicMain = Color3.fromRGB(8, 15, 25),
			AcrylicBorder = Color3.fromRGB(60, 160, 255),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(20, 70, 140), Color3.fromRGB(10, 35, 80)),
			AcrylicNoise = 0.92,
			TitleBarLine = Color3.fromRGB(60, 160, 255),
			Tab = Color3.fromRGB(120, 190, 255),
			Element = Color3.fromRGB(12, 22, 35),
			ElementBorder = Color3.fromRGB(60, 160, 255),
			InElementBorder = Color3.fromRGB(50, 140, 230),
			ElementTransparency = 0.10,
			ToggleSlider = Color3.fromRGB(120, 190, 255),
			ToggleToggled = Color3.fromRGB(5, 8, 14),
			SliderRail = Color3.fromRGB(120, 190, 255),
			DropdownFrame = Color3.fromRGB(12, 22, 35),
			DropdownHolder = Color3.fromRGB(8, 15, 25),
			DropdownBorder = Color3.fromRGB(60, 160, 255),
			DropdownOption = Color3.fromRGB(120, 190, 255),
			Keybind = Color3.fromRGB(120, 190, 255),
			Input = Color3.fromRGB(120, 190, 255),
			InputFocused = Color3.fromRGB(10, 18, 30),
			InputIndicator = Color3.fromRGB(150, 210, 255),
			Dialog = Color3.fromRGB(8, 15, 25),
			DialogHolder = Color3.fromRGB(6, 12, 20),
			DialogHolderLine = Color3.fromRGB(60, 160, 255),
			DialogButton = Color3.fromRGB(12, 22, 35),
			DialogButtonBorder = Color3.fromRGB(60, 160, 255),
			DialogBorder = Color3.fromRGB(60, 160, 255),
			DialogInput = Color3.fromRGB(15, 28, 45),
			DialogInputLine = Color3.fromRGB(120, 190, 255),
			Text = Color3.fromRGB(255, 255, 255),
			SubText = Color3.fromRGB(200, 230, 255),
			Hover = Color3.fromRGB(120, 190, 255),
			HoverChange = 0.08
		}
	end,
	[64] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(64)
		return {
			Name = "Peach",
			Accent = Color3.fromRGB(255, 160, 120),
			AcrylicMain = Color3.fromRGB(22, 16, 14),
			AcrylicBorder = Color3.fromRGB(255, 160, 120),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(180, 100, 70), Color3.fromRGB(100, 60, 40)),
			AcrylicNoise = 0.89,
			TitleBarLine = Color3.fromRGB(255, 160, 120),
			Tab = Color3.fromRGB(255, 190, 160),
			Element = Color3.fromRGB(30, 22, 18),
			ElementBorder = Color3.fromRGB(255, 160, 120),
			InElementBorder = Color3.fromRGB(230, 140, 100),
			ElementTransparency = 0.09,
			ToggleSlider = Color3.fromRGB(255, 190, 160),
			ToggleToggled = Color3.fromRGB(12, 8, 7),
			SliderRail = Color3.fromRGB(255, 190, 160),
			DropdownFrame = Color3.fromRGB(30, 22, 18),
			DropdownHolder = Color3.fromRGB(22, 16, 14),
			DropdownBorder = Color3.fromRGB(255, 160, 120),
			DropdownOption = Color3.fromRGB(255, 190, 160),
			Keybind = Color3.fromRGB(255, 190, 160),
			Input = Color3.fromRGB(255, 190, 160),
			InputFocused = Color3.fromRGB(25, 18, 15),
			InputIndicator = Color3.fromRGB(255, 210, 180),
			Dialog = Color3.fromRGB(22, 16, 14),
			DialogHolder = Color3.fromRGB(18, 13, 11),
			DialogHolderLine = Color3.fromRGB(255, 160, 120),
			DialogButton = Color3.fromRGB(30, 22, 18),
			DialogButtonBorder = Color3.fromRGB(255, 160, 120),
			DialogBorder = Color3.fromRGB(255, 160, 120),
			DialogInput = Color3.fromRGB(38, 28, 22),
			DialogInputLine = Color3.fromRGB(255, 190, 160),
			Text = Color3.fromRGB(255, 255, 255),
			SubText = Color3.fromRGB(255, 230, 210),
			Hover = Color3.fromRGB(255, 190, 160),
			HoverChange = 0.09
		}
	end,
	[65] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(65)
		return {
			Name = "Galaxy",
			Accent = Color3.fromRGB(180, 100, 255),
			AcrylicMain = Color3.fromRGB(8, 5, 15),
			AcrylicBorder = Color3.fromRGB(180, 100, 255),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(80, 40, 160), Color3.fromRGB(30, 15, 70)),
			AcrylicNoise = 0.94,
			TitleBarLine = Color3.fromRGB(180, 100, 255),
			Tab = Color3.fromRGB(210, 150, 255),
			Element = Color3.fromRGB(12, 8, 22),
			ElementBorder = Color3.fromRGB(180, 100, 255),
			InElementBorder = Color3.fromRGB(160, 80, 230),
			ElementTransparency = 0.08,
			ToggleSlider = Color3.fromRGB(210, 150, 255),
			ToggleToggled = Color3.fromRGB(4, 3, 8),
			SliderRail = Color3.fromRGB(210, 150, 255),
			DropdownFrame = Color3.fromRGB(12, 8, 22),
			DropdownHolder = Color3.fromRGB(8, 5, 15),
			DropdownBorder = Color3.fromRGB(180, 100, 255),
			DropdownOption = Color3.fromRGB(210, 150, 255),
			Keybind = Color3.fromRGB(210, 150, 255),
			Input = Color3.fromRGB(210, 150, 255),
			InputFocused = Color3.fromRGB(10, 6, 18),
			InputIndicator = Color3.fromRGB(230, 180, 255),
			Dialog = Color3.fromRGB(8, 5, 15),
			DialogHolder = Color3.fromRGB(6, 4, 12),
			DialogHolderLine = Color3.fromRGB(180, 100, 255),
			DialogButton = Color3.fromRGB(12, 8, 22),
			DialogButtonBorder = Color3.fromRGB(180, 100, 255),
			DialogBorder = Color3.fromRGB(180, 100, 255),
			DialogInput = Color3.fromRGB(16, 10, 28),
			DialogInputLine = Color3.fromRGB(210, 150, 255),
			Text = Color3.fromRGB(255, 255, 255),
			SubText = Color3.fromRGB(230, 210, 255),
			Hover = Color3.fromRGB(210, 150, 255),
			HoverChange = 0.08
		}
	end,
	[66] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(66)
		-- RGB Theme with animated rainbow colors flag
		return {
			Name = "RGB",
			Accent = Color3.fromRGB(255, 0, 255), -- will be animated by caller if supported
			AcrylicMain = Color3.fromRGB(12, 12, 12),
			AcrylicBorder = Color3.fromRGB(255, 0, 255),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(20, 20, 20), Color3.fromRGB(10, 10, 10)),
			AcrylicNoise = 0.90,
			TitleBarLine = Color3.fromRGB(255, 0, 255),
			Tab = Color3.fromRGB(255, 255, 255),
			Element = Color3.fromRGB(18, 18, 18),
			ElementBorder = Color3.fromRGB(255, 0, 255),
			InElementBorder = Color3.fromRGB(255, 0, 255),
			ElementTransparency = 0.08,
			ToggleSlider = Color3.fromRGB(255, 255, 255),
			ToggleToggled = Color3.fromRGB(8, 8, 8),
			SliderRail = Color3.fromRGB(255, 255, 255),
			DropdownFrame = Color3.fromRGB(18, 18, 18),
			DropdownHolder = Color3.fromRGB(12, 12, 12),
			DropdownBorder = Color3.fromRGB(255, 0, 255),
			DropdownOption = Color3.fromRGB(255, 255, 255),
			Keybind = Color3.fromRGB(255, 255, 255),
			Input = Color3.fromRGB(255, 255, 255),
			InputFocused = Color3.fromRGB(15, 15, 15),
			InputIndicator = Color3.fromRGB(255, 0, 255),
			Dialog = Color3.fromRGB(12, 12, 12),
			DialogHolder = Color3.fromRGB(10, 10, 10),
			DialogHolderLine = Color3.fromRGB(255, 0, 255),
			DialogButton = Color3.fromRGB(18, 18, 18),
			DialogButtonBorder = Color3.fromRGB(255, 0, 255),
			DialogBorder = Color3.fromRGB(255, 0, 255),
			DialogInput = Color3.fromRGB(22, 22, 22),
			DialogInputLine = Color3.fromRGB(255, 0, 255),
			Text = Color3.fromRGB(255, 255, 255),
			SubText = Color3.fromRGB(220, 220, 220),
			Hover = Color3.fromRGB(255, 255, 255),
			HoverChange = 0.10,
			IsRGB = true
		}
	end,
	[67] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(67)
		return {
			Name = "Dark",
			Accent = Color3.fromRGB(96, 205, 255),
			AcrylicMain = Color3.fromRGB(60, 60, 60),
			AcrylicBorder = Color3.fromRGB(128, 134, 148),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(40, 40, 40), Color3.fromRGB(40, 40, 40)),
			AcrylicNoise = 0.9,
			TitleBarLine = Color3.fromRGB(96, 100, 114),
			Tab = Color3.fromRGB(120, 120, 120),
			Element = Color3.fromRGB(44, 46, 52),
			ElementBorder = Color3.fromRGB(114, 118, 132),
			InElementBorder = Color3.fromRGB(134, 140, 156),
			ElementTransparency = 0.42,
			ToggleSlider = Color3.fromRGB(120, 120, 120),
			ToggleToggled = Color3.fromRGB(0, 0, 0),
			SliderRail = Color3.fromRGB(120, 120, 120),
			DropdownFrame = Color3.fromRGB(160, 160, 160),
			DropdownHolder = Color3.fromRGB(45, 45, 45),
			DropdownBorder = Color3.fromRGB(118, 124, 138),
			DropdownOption = Color3.fromRGB(120, 120, 120),
			Keybind = Color3.fromRGB(120, 120, 120),
			Input = Color3.fromRGB(160, 160, 160),
			InputFocused = Color3.fromRGB(10, 10, 10),
			InputIndicator = Color3.fromRGB(150, 150, 150),
			Dialog = Color3.fromRGB(45, 45, 45),
			DialogHolder = Color3.fromRGB(35, 35, 35),
			DialogHolderLine = Color3.fromRGB(30, 30, 30),
			DialogButton = Color3.fromRGB(45, 45, 45),
			DialogButtonBorder = Color3.fromRGB(116, 122, 136),
			DialogBorder = Color3.fromRGB(118, 124, 138),
			DialogInput = Color3.fromRGB(55, 55, 55),
			DialogInputLine = Color3.fromRGB(160, 160, 160),
			Text = Color3.fromRGB(250, 251, 254),
			SubText = Color3.fromRGB(198, 202, 214),
			Hover = Color3.fromRGB(120, 120, 120),
			HoverChange = 0.07
		}
	end,
	[68] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(68)
		return {
			Name = "Darker",
			Accent = Color3.fromRGB(72, 138, 182),
			AcrylicMain = Color3.fromRGB(30, 30, 30),
			AcrylicBorder = Color3.fromRGB(108, 114, 130),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(25, 25, 25), Color3.fromRGB(15, 15, 15)),
			AcrylicNoise = 0.94,
			TitleBarLine = Color3.fromRGB(82, 88, 102),
			Tab = Color3.fromRGB(100, 100, 100),
			Element = Color3.fromRGB(28, 30, 36),
			ElementBorder = Color3.fromRGB(96, 102, 118),
			InElementBorder = Color3.fromRGB(116, 124, 142),
			ElementTransparency = 0.36,
			ToggleSlider = Color3.fromRGB(108, 114, 130),
			ToggleToggled = Color3.fromRGB(10, 12, 16),
			SliderRail = Color3.fromRGB(76, 82, 98),
			DropdownFrame = Color3.fromRGB(120, 120, 120),
			DropdownHolder = Color3.fromRGB(35, 35, 35),
			DropdownBorder = Color3.fromRGB(102, 108, 124),
			DropdownOption = Color3.fromRGB(110, 124, 150),
			Keybind = Color3.fromRGB(32, 35, 42),
			Input = Color3.fromRGB(32, 35, 42),
			InputFocused = Color3.fromRGB(20, 22, 28),
			InputIndicator = Color3.fromRGB(72, 138, 182),
			Dialog = Color3.fromRGB(35, 35, 35),
			DialogHolder = Color3.fromRGB(25, 25, 25),
			DialogHolderLine = Color3.fromRGB(20, 20, 20),
			DialogButton = Color3.fromRGB(35, 35, 35),
			DialogButtonBorder = Color3.fromRGB(98, 104, 120),
			DialogBorder = Color3.fromRGB(102, 108, 124),
			DialogInput = Color3.fromRGB(45, 45, 45),
			DialogInputLine = Color3.fromRGB(120, 120, 120),
			Text = Color3.fromRGB(248, 250, 254),
			SubText = Color3.fromRGB(194, 200, 214),
			Hover = Color3.fromRGB(120, 132, 156),
			HoverChange = 0.08
		}
	end,
	[69] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(69)
		return {
			Name = "Acryven",
			Accent = Color3.fromRGB(99, 179, 255),
			AcrylicMain = Color3.fromRGB(11, 12, 16),
			AcrylicBorder = Color3.fromRGB(160, 178, 214),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(24, 27, 38), Color3.fromRGB(10, 11, 15)),
			AcrylicNoise = 0.93,
			TitleBarLine = Color3.fromRGB(88, 100, 128),
			Tab = Color3.fromRGB(145, 162, 198),
			Element = Color3.fromRGB(22, 26, 36),
			ElementBorder = Color3.fromRGB(108, 124, 160),
			InElementBorder = Color3.fromRGB(128, 146, 186),
			ElementTransparency = 0.38,
			ToggleSlider = Color3.fromRGB(110, 120, 146),
			ToggleToggled = Color3.fromRGB(10, 12, 18),
			SliderRail = Color3.fromRGB(72, 80, 102),
			DropdownFrame = Color3.fromRGB(26, 29, 40),
			DropdownHolder = Color3.fromRGB(15, 17, 24),
			DropdownBorder = Color3.fromRGB(116, 132, 170),
			DropdownOption = Color3.fromRGB(130, 148, 188),
			Keybind = Color3.fromRGB(28, 32, 44),
			Input = Color3.fromRGB(26, 29, 40),
			InputFocused = Color3.fromRGB(16, 18, 26),
			InputIndicator = Color3.fromRGB(99, 179, 255),
			Dialog = Color3.fromRGB(16, 18, 25),
			DialogHolder = Color3.fromRGB(12, 14, 20),
			DialogHolderLine = Color3.fromRGB(48, 54, 72),
			DialogButton = Color3.fromRGB(26, 30, 42),
			DialogButtonBorder = Color3.fromRGB(112, 128, 166),
			DialogBorder = Color3.fromRGB(120, 138, 176),
			DialogInput = Color3.fromRGB(22, 25, 35),
			DialogInputLine = Color3.fromRGB(99, 179, 255),
			Text = Color3.fromRGB(252, 253, 255),
			SubText = Color3.fromRGB(198, 208, 228),
			Hover = Color3.fromRGB(145, 165, 208),
			HoverChange = 0.08
		}
	end,
	[70] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(70)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local New, Element = Creator.New, {}
		Element.__index = Element
		Element.__type = "ActionRow"

		local DANGER_BG = Color3.fromRGB(220, 38, 38)
		local DANGER_BORDER = Color3.fromRGB(248, 113, 113)
		local WARN_BG = Color3.fromRGB(217, 119, 6)

		function Element.New(parent, idx, config)
			if type(idx) == "table" and config == nil then
				config = idx
				idx = nil
			end
			local Library = parent.Library
			config = type(config) == "table" and config or {}
			local buttons = type(config.Buttons) == "table" and config.Buttons or {}
			local gap = tonumber(config.Gap) or 6
			local height = tonumber(config.Height) or 34

			local ActionRow = {
				Type = "ActionRow",
				Buttons = {}
			}

			ActionRow.Frame = New(
				"Frame",
				{
					Name = "AcryvenActionRow",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, height),
					LayoutOrder = config.LayoutOrder or 7,
					Parent = parent.Container
				}
			)
			ActionRow.Root = ActionRow.Frame

			local count = math.max(1, #buttons)
			local wScale = 1 / count
			local gapDeduction = gap * (count - 1) / count

			for i, spec in ipairs(buttons) do
				local variant = spec.Variant or "Secondary"
				local needConfirm = spec.Confirm == true
				local xOff = math.floor((i - 1) * (gap / count) + 0.5)

				local stroke = New(
					"UIStroke",
					{
						Transparency = 0.36,
						Thickness = 1,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						ThemeTag = {Color = "ElementBorder"}
					}
				)

				local iconAsset = nil
				if type(spec.Icon) == "string" and spec.Icon ~= "" then
					iconAsset = Library:GetIcon(spec.Icon) or (spec.Icon:match("^rbxassetid://") and spec.Icon) or nil
				end

				local innerChildren = {
					New("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 6)
					})
				}
				local iconImg = nil
				if iconAsset then
					iconImg = New("ImageLabel", {
						Name = "Icon",
						Image = iconAsset,
						Size = UDim2.fromOffset(14, 14),
						BackgroundTransparency = 1,
						ThemeTag = {ImageColor3 = "Text"}
					})
					table.insert(innerChildren, iconImg)
				end

				local lbl = New("TextLabel", {
					Name = "Label",
					Text = tostring(spec.Title or ("Action " .. tostring(i))),
					FontFace = Creator.Font(Enum.FontWeight.SemiBold),
					TextSize = 12,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 1,
					ThemeTag = {TextColor3 = "Text"}
				})
				table.insert(innerChildren, lbl)

				local btn = New(
					"TextButton",
					{
						Name = "ActionBtn_" .. tostring(i),
						Text = "",
						AutoButtonColor = false,
						Position = UDim2.new((i - 1) * wScale, xOff, 0, 0),
						Size = UDim2.new(wScale, -math.floor(gapDeduction + 0.5), 1, 0),
						BackgroundTransparency = 0.45,
						Parent = ActionRow.Frame,
						ThemeTag = {BackgroundColor3 = "DialogButton"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, Creator.Radius.Card)}),
						stroke,
						New("Frame", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1}, innerChildren)
					}
				)

				local function applyStyle(mode)
					if mode == "Primary" then
						local acc = Creator.GetThemeProperty("Accent")
						local c = Creator.AutoContrast(acc)
						Creator.OverrideTag(btn, {BackgroundColor3 = "Accent"})
						Creator.OverrideTag(stroke, {Color = "Accent"})
						Creator.OverrideTag(lbl, {})
						btn.BackgroundTransparency = 0.12
						stroke.Transparency = 0.2
						lbl.TextColor3 = c
						if iconImg then
							Creator.OverrideTag(iconImg, {})
							iconImg.ImageColor3 = c
						end
					elseif mode == "Danger" then
						Creator.OverrideTag(btn, {})
						Creator.OverrideTag(stroke, {})
						Creator.OverrideTag(lbl, {})
						btn.BackgroundColor3 = DANGER_BG
						btn.BackgroundTransparency = 0.2
						stroke.Color = DANGER_BORDER
						stroke.Transparency = 0.28
						lbl.TextColor3 = Color3.fromRGB(255, 245, 245)
						if iconImg then
							Creator.OverrideTag(iconImg, {})
							iconImg.ImageColor3 = Color3.fromRGB(255, 245, 245)
						end
					elseif mode == "Ghost" then
						Creator.OverrideTag(btn, {BackgroundColor3 = "Element"})
						Creator.OverrideTag(stroke, {Color = "ElementBorder"})
						Creator.OverrideTag(lbl, {TextColor3 = "SubText"})
						btn.BackgroundTransparency = 0.85
						stroke.Transparency = 0.48
						if iconImg then
							Creator.OverrideTag(iconImg, {ImageColor3 = "SubText"})
						end
					elseif mode == "ConfirmPending" then
						Creator.OverrideTag(btn, {})
						Creator.OverrideTag(stroke, {})
						Creator.OverrideTag(lbl, {})
						btn.BackgroundColor3 = WARN_BG
						btn.BackgroundTransparency = 0.12
						stroke.Color = Color3.fromRGB(251, 191, 36)
						stroke.Transparency = 0.15
						lbl.TextColor3 = Color3.fromRGB(255, 251, 235)
						if iconImg then
							Creator.OverrideTag(iconImg, {})
							iconImg.ImageColor3 = Color3.fromRGB(255, 251, 235)
						end
					else
						Creator.OverrideTag(btn, {BackgroundColor3 = "Element", BackgroundTransparency = "ElementTransparency"})
						Creator.OverrideTag(stroke, {Color = "ElementBorder"})
						Creator.OverrideTag(lbl, {TextColor3 = "Text"})
						stroke.Transparency = 0.36
						if iconImg then
							Creator.OverrideTag(iconImg, {ImageColor3 = "Text"})
						end
					end
				end

				applyStyle(variant)
				if variant == "Primary" then
					Creator.AddSignal(btn:GetPropertyChangedSignal("BackgroundColor3"), function()
						local c = Creator.AutoContrast(btn.BackgroundColor3)
						lbl.TextColor3 = c
						if iconImg then
							iconImg.ImageColor3 = c
						end
					end)
				end

				local restAlpha = function()
					if variant == "Primary" then return 0.12
					elseif variant == "Danger" then return 0.2
					elseif variant == "Ghost" then return 0.85
					else return Creator.GetThemeProperty("ElementTransparency") or 0.38 end
				end

				local pending = false
				local pendingGen = 0
				local origTitle = tostring(spec.Title or ("Action " .. tostring(i)))

				Creator.AddSignal(btn.MouseEnter, function()
					if not pending then
						Creator.SpringValue(btn, "BackgroundTransparency", math.max(0.02, restAlpha() - 0.1), 10, 1)
						Creator.SpringValue(stroke, "Transparency", 0.16, 10, 1)
					end
				end)
				Creator.AddSignal(btn.MouseLeave, function()
					if not pending then
						Creator.SpringValue(btn, "BackgroundTransparency", restAlpha(), 10, 1)
						Creator.SpringValue(stroke, "Transparency", variant == "Primary" and 0.18 or 0.36, 10, 1)
					end
				end)
				Creator.AddSignal(btn.MouseButton1Click, function()
					if needConfirm and not pending then
						pending = true
						pendingGen += 1
						local myGen = pendingGen
						lbl.Text = spec.ConfirmText or "Confirm?"
						applyStyle("ConfirmPending")
						task.delay(3, function()
							if myGen == pendingGen and pending and btn and btn.Parent then
								pending = false
								lbl.Text = origTitle
								applyStyle(variant)
							end
						end)
						return
					end
					if pending then
						pending = false
						pendingGen += 1
						lbl.Text = origTitle
						applyStyle(variant)
					end
					Library:SafeCallback(spec.Callback)
				end)

				table.insert(ActionRow.Buttons, {Frame = btn, Label = lbl})
			end

			function ActionRow.Destroy(_self)
				ActionRow.Frame:Destroy()
				if idx ~= nil then
					Library.Options[idx] = nil
				end
			end

			if idx ~= nil then
				Library.Options[idx] = ActionRow
			end
			return ActionRow
		end
		return Element
	end,
	[71] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(71)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local New, Element = Creator.New, {}
		Element.__index = Element
		Element.__type = "Callout"

		local VARIANTS = {
			Info = {Color = Color3.fromRGB(99, 179, 255), Icon = "info"},
			Success = {Color = Color3.fromRGB(52, 211, 153), Icon = "check-circle-2"},
			Warning = {Color = Color3.fromRGB(251, 191, 36), Icon = "alert-triangle"},
			Danger = {Color = Color3.fromRGB(248, 113, 113), Icon = "alert-circle"}
		}

		function Element.New(parent, idx, config)
			if type(idx) == "table" and config == nil then
				config = idx
				idx = nil
			end
			local Library = parent.Library
			config = type(config) == "table" and config or {}
			local variantName = config.Variant or config.Kind or "Info"
			local spec = VARIANTS[variantName] or VARIANTS.Info
			local accentColor = typeof(config.Color) == "Color3" and config.Color or spec.Color
			local iconAsset = Library:GetIcon(config.Icon or spec.Icon) or Library:GetIcon("info") or ""
			local dismissible = config.Dismissible == true

			local Callout = {
				Type = "Callout",
				Variant = variantName
			}

			local titleLbl = New(
				"TextLabel",
				{
					Name = "Title",
					Text = tostring(config.Title or variantName),
					RichText = true,
					FontFace = Creator.Font(Enum.FontWeight.SemiBold),
					TextSize = 13,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					LayoutOrder = 1,
					LineHeight = 1.12,
					BackgroundTransparency = 1,
					ThemeTag = {TextColor3 = "Text"}
				}
			)

			local contentText = tostring(config.Content or config.Description or "")
			local descLbl = New(
				"TextLabel",
				{
					Name = "Content",
					Text = contentText,
					RichText = true,
					Visible = contentText ~= "",
					FontFace = Creator.Font(Enum.FontWeight.Regular),
					TextSize = 12,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					LayoutOrder = 2,
					LineHeight = 1.15,
					BackgroundTransparency = 1,
					ThemeTag = {TextColor3 = "SubText"}
				}
			)

			local rightPad = dismissible and 34 or 12
			local textCol = New(
				"Frame",
				{
					Name = "TextCol",
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(38, 0),
					Size = UDim2.new(1, -(38 + rightPad), 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				},
				{
					New("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder}),
					New("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)}),
					titleLbl,
					descLbl
				}
			)

			if type(config.Action) == "table" and config.Action.Title then
				local actionBtn = New(
					"TextButton",
					{
						Name = "ActionBtn",
						Text = tostring(config.Action.Title),
						FontFace = Creator.Font(Enum.FontWeight.SemiBold),
						TextSize = 11,
						AutomaticSize = Enum.AutomaticSize.X,
						Size = UDim2.fromOffset(0, 22),
						BackgroundColor3 = accentColor,
						BackgroundTransparency = 0.2,
						TextColor3 = Creator.AutoContrast(accentColor),
						LayoutOrder = 5,
						Parent = textCol
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 6)}),
						New("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})
					}
				)
				Creator.AddSignal(actionBtn.MouseButton1Click, function()
					Library:SafeCallback(config.Action.Callback)
				end)
			end

			local tintOverlay = New(
				"Frame",
				{
					Name = "Tint",
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = accentColor,
					BackgroundTransparency = 0.88,
					ZIndex = 1
				},
				{New("UICorner", {CornerRadius = UDim.new(0, Creator.Radius.Card)})}
			)

			local accentBar = New(
				"Frame",
				{
					Name = "AccentBar",
					Size = UDim2.new(0, 3, 1, -14),
					Position = UDim2.new(0, 5, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundColor3 = accentColor,
					ZIndex = 2
				},
				{New("UICorner", {CornerRadius = UDim.new(1, 0)})}
			)

			local iconImg = New(
				"ImageLabel",
				{
					Name = "Icon",
					Image = iconAsset,
					Size = UDim2.fromOffset(16, 16),
					Position = UDim2.fromOffset(15, 11),
					BackgroundTransparency = 1,
					ImageColor3 = accentColor,
					ZIndex = 2
				}
			)

			local children = {
				New("UICorner", {CornerRadius = UDim.new(0, Creator.Radius.Card)}),
				New("UIStroke", {Color = accentColor, Transparency = 0.34, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}),
				tintOverlay,
				accentBar,
				iconImg,
				textCol
			}

			if dismissible then
				local closeBtn = New(
					"TextButton",
					{
						Name = "Dismiss",
						Text = "",
						Size = UDim2.fromOffset(22, 22),
						Position = UDim2.new(1, -8, 0, 8),
						AnchorPoint = Vector2.new(1, 0),
						BackgroundTransparency = 1,
						ZIndex = 3
					},
					{
						New("ImageLabel", {
							Image = Library:GetIcon("x") or "rbxassetid://10747384394",
							Size = UDim2.fromOffset(12, 12),
							Position = UDim2.fromScale(0.5, 0.5),
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							ImageTransparency = 0.04,
							ThemeTag = {ImageColor3 = "SubText"}
						})
					}
				)
				Creator.AddSignal(closeBtn.MouseButton1Click, function()
					Callout:Dismiss()
				end)
				table.insert(children, closeBtn)
			end

			Callout.Frame = New(
				"Frame",
				{
					Name = "AcryvenCallout",
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					LayoutOrder = config.LayoutOrder or 7,
					Parent = parent.Container,
					ThemeTag = {BackgroundColor3 = "Element", BackgroundTransparency = "ElementTransparency"}
				},
				children
			)
			Callout.Root = Callout.Frame

			function Callout.SetTitle(_self, text)
				titleLbl.Text = tostring(text or "")
			end
			function Callout.SetContent(_self, text)
				local s = tostring(text or "")
				descLbl.Text = s
				descLbl.Visible = s ~= ""
			end
			function Callout.Dismiss(_self)
				if Callout.Frame and Callout.Frame.Parent then
					Callout.Frame.Visible = false
				end
				if type(config.OnDismiss) == "function" then
					Library:SafeCallback(config.OnDismiss)
				end
			end
			function Callout.Destroy(_self)
				Callout.Frame:Destroy()
				if idx ~= nil then
					Library.Options[idx] = nil
				end
			end

			if idx ~= nil then
				Library.Options[idx] = Callout
			end
			return Callout
		end
		return Element
	end,
	[72] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(72)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local New, Element = Creator.New, {}
		Element.__index = Element
		Element.__type = "CodeBlock"

		local LUAU_KEYWORDS = {
			["local"] = true, ["function"] = true, ["return"] = true, ["if"] = true, ["then"] = true,
			["else"] = true, ["elseif"] = true, ["end"] = true, ["for"] = true, ["in"] = true,
			["do"] = true, ["while"] = true, ["repeat"] = true, ["until"] = true, ["and"] = true,
			["or"] = true, ["not"] = true, ["true"] = true, ["false"] = true, ["nil"] = true,
			["break"] = true, ["continue"] = true, ["type"] = true, ["export"] = true
		}

		local PALETTE_DARK = {
			Comment = "#7a869e",
			String = "#34d399",
			Keyword = "#c084fc",
			Call = "#60a5fa",
			Number = "#fbbf24",
			LineNo = "#64748b"
		}
		local PALETTE_LIGHT = {
			Comment = "#64748b",
			String = "#059669",
			Keyword = "#7c3aed",
			Call = "#2563eb",
			Number = "#d97706",
			LineNo = "#94a3b8"
		}

		local function escapeRich(s)
			local escaped = tostring(s):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
			return escaped
		end

		local function isLightSurface(color)
			if typeof(color) ~= "Color3" then
				return false
			end
			return (0.299 * color.R + 0.587 * color.G + 0.114 * color.B) > 0.55
		end

		local function highlightLuauLine(raw, pal)
			local out = {}
			local i, n = 1, #raw
			while i <= n do
				local ch = raw:sub(i, i)
				if ch == "-" and raw:sub(i, i + 1) == "--" then
					table.insert(out, '<font color="' .. pal.Comment .. '">' .. escapeRich(raw:sub(i)) .. "</font>")
					break
				elseif ch == '"' or ch == "'" then
					local q = ch
					local j = i + 1
					while j <= n do
						local c = raw:sub(j, j)
						if c == "\\" then
							j += 2
						elseif c == q then
							j += 1
							break
						else
							j += 1
						end
					end
					table.insert(out, '<font color="' .. pal.String .. '">' .. escapeRich(raw:sub(i, j - 1)) .. "</font>")
					i = j
				elseif ch:match("[%a_]") then
					local j = i + 1
					while j <= n and raw:sub(j, j):match("[%w_]") do
						j += 1
					end
					local word = raw:sub(i, j - 1)
					if LUAU_KEYWORDS[word] then
						table.insert(out, '<font color="' .. pal.Keyword .. '">' .. word .. "</font>")
					elseif raw:sub(j, j) == "(" then
						table.insert(out, '<font color="' .. pal.Call .. '">' .. word .. "</font>")
					else
						table.insert(out, escapeRich(word))
					end
					i = j
				elseif ch:match("%d") then
					local j = i + 1
					while j <= n and raw:sub(j, j):match("[%d%.xXa-fA-F_]") do
						j += 1
					end
					table.insert(out, '<font color="' .. pal.Number .. '">' .. escapeRich(raw:sub(i, j - 1)) .. "</font>")
					i = j
				else
					table.insert(out, escapeRich(ch))
					i += 1
				end
			end
			return table.concat(out)
		end

		local function formatCode(source, highlight, showLineNumbers, lightBg)
			local pal = lightBg and PALETTE_LIGHT or PALETTE_DARK
			local lines = tostring(source or ""):gsub("\r\n", "\n"):split("\n")
			local rendered = {}
			for idx, line in ipairs(lines) do
				local body = highlight and highlightLuauLine(line, pal) or escapeRich(line)
				if showLineNumbers then
					table.insert(rendered, string.format('<font color="%s">%2d</font>  %s', pal.LineNo, idx, body))
				else
					table.insert(rendered, body)
				end
			end
			return table.concat(rendered, "\n"), #lines
		end

		local function copyClipboard(text)
			local fn = setclipboard or toclipboard or (syn and syn.write_clipboard)
			if type(fn) == "function" then
				return pcall(fn, tostring(text))
			end
			return false
		end

		function Element.New(parent, idx, config)
			if type(idx) == "table" and config == nil then
				config = idx
				idx = nil
			end
			local Library = parent.Library
			config = type(config) == "table" and config or {}
			local rawCode = tostring(config.Code or config.Content or "")
			local language = tostring(config.Language or "luau")
			local highlight = config.Highlight ~= false and (language:lower() == "luau" or language:lower() == "lua")
			local lineNumbers = config.LineNumbers ~= false
			local maxHeight = tonumber(config.MaxHeight) or 190

			local CodeBlock = {
				Value = rawCode,
				Type = "CodeBlock"
			}

			local copyAsset = Library:GetIcon("copy") or ""
			local checkAsset = Library:GetIcon("check") or ""
			local copyIcon = New("ImageLabel", {
				Image = copyAsset,
				Size = UDim2.fromOffset(12, 12),
				BackgroundTransparency = 1,
				ThemeTag = {ImageColor3 = "SubText"}
			})
			local copyLbl = New("TextLabel", {
				Text = "Copy",
				I18nSkip = true,
				FontFace = Creator.Font(Enum.FontWeight.Medium),
				TextSize = 10,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 0, 1, 0),
				BackgroundTransparency = 1,
				ThemeTag = {TextColor3 = "SubText"}
			})
			local copyBtn = New(
				"TextButton",
				{
					Name = "CopyBtn",
					Text = "",
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -8, 0.5, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.fromOffset(0, 20),
					BackgroundTransparency = 0.28,
					AutoButtonColor = false,
					ThemeTag = {BackgroundColor3 = "DialogButton"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(0, 5)}),
					New("UIStroke", {Transparency = 0.42, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "InElementBorder"}}),
					New("UIPadding", {PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}),
					New("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 4)
					}),
					copyIcon,
					copyLbl
				}
			)

			local header = New(
				"Frame",
				{
					Name = "Header",
					Size = UDim2.new(1, 0, 0, 28),
					BackgroundTransparency = 0.14,
					ThemeTag = {BackgroundColor3 = "Dialog"}
				},
				{
					New("Frame", {
						Name = "HeaderBorder",
						Size = UDim2.new(1, 0, 0, 1),
						Position = UDim2.new(0, 0, 1, -1),
						BackgroundTransparency = 0.42,
						ThemeTag = {BackgroundColor3 = "ElementBorder"}
					}),
					New("ImageLabel", {
						Image = Library:GetIcon("code-2") or Library:GetIcon("code") or "",
						Size = UDim2.fromOffset(13, 13),
						Position = UDim2.new(0, 10, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						ThemeTag = {ImageColor3 = "Accent"}
					}),
					New("TextLabel", {
						Text = tostring(config.Title or language:upper()),
						FontFace = Creator.Font(Enum.FontWeight.SemiBold),
						TextSize = 11,
						TextXAlignment = Enum.TextXAlignment.Left,
						Position = UDim2.fromOffset(28, 0),
						Size = UDim2.new(1, -110, 1, 0),
						BackgroundTransparency = 1,
						ThemeTag = {TextColor3 = "Text"}
					}),
					copyBtn
				}
			)

			local codeLabel = New(
				"TextLabel",
				{
					Name = "CodeText",
					RichText = true,
					Text = "",
					I18nSkip = true,
					FontRole = "Mono",
					FontFace = Creator.Font(Enum.FontWeight.Regular, Enum.FontStyle.Normal, "Mono"),
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextWrapped = false,
					AutomaticSize = Enum.AutomaticSize.XY,
					Size = UDim2.fromOffset(0, 0),
					BackgroundTransparency = 1,
					ThemeTag = {TextColor3 = "Text"}
				}
			)

			local scroll = New(
				"ScrollingFrame",
				{
					Name = "CodeScroll",
					Position = UDim2.fromOffset(0, 28),
					Size = UDim2.new(1, 0, 0, 80),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarThickness = 3,
					ScrollBarImageTransparency = 0.45,
					AutomaticCanvasSize = Enum.AutomaticSize.XY,
					CanvasSize = UDim2.fromOffset(0, 0),
					ThemeTag = {ScrollBarImageColor3 = "Accent"}
				},
				{
					New("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 10)}),
					codeLabel
				}
			)

			CodeBlock.Frame = New(
				"Frame",
				{
					Name = "AcryvenCodeBlock",
					Size = UDim2.new(1, 0, 0, 108),
					BackgroundTransparency = 0.14,
					ClipsDescendants = true,
					LayoutOrder = config.LayoutOrder or 7,
					Parent = parent.Container,
					ThemeTag = {BackgroundColor3 = "DialogHolder"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(0, Creator.Radius.Card)}),
					New("UIStroke", {Transparency = 0.34, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "ElementBorder"}}),
					header,
					scroll
				}
			)
			CodeBlock.Root = CodeBlock.Frame

			local lastLightMode = nil
			local function renderSyntax(force)
				local lightBg = isLightSurface(CodeBlock.Frame.BackgroundColor3)
				if not force and lightBg == lastLightMode then
					return
				end
				lastLightMode = lightBg
				local rich, lineCount = formatCode(CodeBlock.Value, highlight, lineNumbers, lightBg)
				codeLabel.Text = rich
				local contentH = math.clamp(lineCount * 15 + 20, 44, maxHeight)
				scroll.Size = UDim2.new(1, 0, 0, contentH)
				CodeBlock.Frame.Size = UDim2.new(1, 0, 0, 28 + contentH)
			end

			function CodeBlock.SetCode(_self, code)
				CodeBlock.Value = tostring(code or "")
				renderSyntax(true)
			end

			Creator.AddSignal(CodeBlock.Frame:GetPropertyChangedSignal("BackgroundColor3"), function()
				renderSyntax(false)
			end)

			Creator.AddSignal(copyBtn.MouseButton1Click, function()
				copyClipboard(CodeBlock.Value)
				copyIcon.Image = checkAsset
				copyLbl.Text = "Copied"
				Creator.OverrideTag(copyIcon, {ImageColor3 = "Accent"})
				Creator.OverrideTag(copyLbl, {TextColor3 = "Accent"})
				task.delay(1.1, function()
					if copyBtn and copyBtn.Parent then
						copyIcon.Image = copyAsset
						copyLbl.Text = "Copy"
						Creator.OverrideTag(copyIcon, {ImageColor3 = "SubText"})
						Creator.OverrideTag(copyLbl, {TextColor3 = "SubText"})
					end
				end)
			end)

			function CodeBlock.Destroy(_self)
				CodeBlock.Frame:Destroy()
				if idx ~= nil then
					Library.Options[idx] = nil
				end
			end

			CodeBlock:SetCode(rawCode)
			if idx ~= nil then
				Library.Options[idx] = CodeBlock
			end
			return CodeBlock
		end
		return Element
	end,
	[73] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(73)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local New, Element = Creator.New, {}
		Element.__index = Element
		Element.__type = "Divider"

		function Element.New(parent, idx, config)
			local labelText = ""
			local layoutOrder = 7
			if type(idx) == "string" and config == nil then
				labelText = idx
				idx = nil
			elseif type(idx) == "table" and config == nil then
				config = idx
				idx = nil
				labelText = tostring(config.Title or config.Text or "")
				layoutOrder = config.LayoutOrder or 7
			elseif type(config) == "table" then
				labelText = tostring(config.Title or config.Text or "")
				layoutOrder = config.LayoutOrder or 7
			elseif type(config) == "string" then
				labelText = config
			end

			local Divider = {Type = "Divider"}
			local hasLabel = labelText ~= ""

			if not hasLabel then
				Divider.Frame = New(
					"Frame",
					{
						Name = "AcryvenDivider",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 12),
						LayoutOrder = layoutOrder,
						Parent = parent.Container
					},
					{
						New("Frame", {
							Name = "Line",
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(0, 0, 0.5, 0),
							Size = UDim2.new(1, 0, 0, 1),
							BackgroundTransparency = 0.52,
							ThemeTag = {BackgroundColor3 = "TitleBarLine"}
						})
					}
				)
			else
				local textLbl = New(
					"TextLabel",
					{
						Name = "Label",
						Text = labelText:upper(),
						FontFace = Creator.Font(Enum.FontWeight.SemiBold),
						TextSize = 10,
						AutomaticSize = Enum.AutomaticSize.X,
						Size = UDim2.new(0, 0, 1, 0),
						BackgroundTransparency = 1,
						TextTransparency = 0.04,
						LayoutOrder = 2,
						ThemeTag = {TextColor3 = "SubText"}
					}
				)
				local leftLine = New("Frame", {
					Name = "LeftLine",
					Size = UDim2.new(0, 14, 0, 1),
					BackgroundTransparency = 0.5,
					LayoutOrder = 1,
					ThemeTag = {BackgroundColor3 = "TitleBarLine"}
				})
				local rightLine = New("Frame", {
					Name = "RightLine",
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundTransparency = 0.5,
					LayoutOrder = 3,
					ThemeTag = {BackgroundColor3 = "TitleBarLine"}
				}, {New("UIFlexItem", {FlexMode = Enum.UIFlexMode.Fill})})

				Divider.Frame = New(
					"Frame",
					{
						Name = "AcryvenDivider",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 18),
						LayoutOrder = layoutOrder,
						Parent = parent.Container
					},
					{
						New("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 8)
						}),
						leftLine,
						textLbl,
						rightLine
					}
				)
			end

			Divider.Root = Divider.Frame
			function Divider.Destroy(_self)
				Divider.Frame:Destroy()
			end
			return Divider
		end
		return Element
	end,
	[74] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(74)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local New, Element = Creator.New, {}
		Element.__index = Element
		Element.__type = "LiveConsole"

		local LEVEL_COLORS = {
			INFO = Color3.fromRGB(99, 179, 255),
			OK = Color3.fromRGB(52, 211, 153),
			DROP = Color3.fromRGB(192, 132, 252),
			WARN = Color3.fromRGB(251, 191, 36),
			ERR = Color3.fromRGB(248, 113, 113)
		}

		local function copyClipboard(text)
			local fn = setclipboard or toclipboard or (syn and syn.write_clipboard)
			if type(fn) == "function" then
				return pcall(fn, tostring(text))
			end
			return false
		end

		function Element.New(parent, idx, config)
			if type(idx) == "table" and config == nil then
				config = idx
				idx = nil
			end
			local Library = parent.Library
			config = type(config) == "table" and config or {}
			local height = math.clamp(tonumber(config.Height) or 160, 90, 340)
			local maxLines = math.clamp(tonumber(config.MaxLines) or 80, 10, 250)

			local Console = {
				Type = "LiveConsole",
				Paused = false,
				Lines = {}
			}

			local function makeMiniBtn(iconName, order)
				local img = New("ImageLabel", {
					Name = "Icon",
					Image = Library:GetIcon(iconName) or "",
					Size = UDim2.fromOffset(12, 12),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					ThemeTag = {ImageColor3 = "SubText"}
				})
				local btn = New("TextButton", {
					Text = "",
					Size = UDim2.fromOffset(22, 20),
					BackgroundTransparency = 0.28,
					AutoButtonColor = false,
					LayoutOrder = order,
					ThemeTag = {BackgroundColor3 = "DialogButton"}
				}, {
					New("UICorner", {CornerRadius = UDim.new(0, 5)}),
					New("UIStroke", {Transparency = 0.42, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "InElementBorder"}}),
					img
				})
				return btn, img
			end

			local pauseBtn, pauseIcon = makeMiniBtn("pause", 1)
			local copyBtn, copyIcon = makeMiniBtn("copy", 2)
			local clearBtn = makeMiniBtn("trash-2", 3)

			local controls = New(
				"Frame",
				{
					Name = "Controls",
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -8, 0.5, 0),
					Size = UDim2.fromOffset(76, 20),
					BackgroundTransparency = 1
				},
				{
					New("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 4)
					}),
					pauseBtn,
					copyBtn,
					clearBtn
				}
			)

			local header = New(
				"Frame",
				{
					Name = "Header",
					Size = UDim2.new(1, 0, 0, 28),
					BackgroundTransparency = 0.14,
					ThemeTag = {BackgroundColor3 = "Dialog"}
				},
				{
					New("Frame", {
						Name = "HeaderBorder",
						Size = UDim2.new(1, 0, 0, 1),
						Position = UDim2.new(0, 0, 1, -1),
						BackgroundTransparency = 0.42,
						ThemeTag = {BackgroundColor3 = "ElementBorder"}
					}),
					New("ImageLabel", {
						Image = Library:GetIcon("terminal") or "",
						Size = UDim2.fromOffset(13, 13),
						Position = UDim2.new(0, 10, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						ThemeTag = {ImageColor3 = "Accent"}
					}),
					New("TextLabel", {
						Text = tostring(config.Title or "Live Console"),
						FontFace = Creator.Font(Enum.FontWeight.SemiBold),
						TextSize = 11,
						TextXAlignment = Enum.TextXAlignment.Left,
						Position = UDim2.fromOffset(28, 0),
						Size = UDim2.new(1, -112, 1, 0),
						BackgroundTransparency = 1,
						ThemeTag = {TextColor3 = "Text"}
					}),
					controls
				}
			)

			local listLayout = New("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder})
			local scroll = New(
				"ScrollingFrame",
				{
					Name = "LogScroll",
					Position = UDim2.fromOffset(0, 28),
					Size = UDim2.new(1, 0, 1, -28),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarThickness = 3,
					ScrollBarImageTransparency = 0.45,
					CanvasSize = UDim2.fromOffset(0, 0),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					ThemeTag = {ScrollBarImageColor3 = "Accent"}
				},
				{
					New("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6)}),
					listLayout
				}
			)

			local function syncCanvas()
				if not scroll or not scroll.Parent then
					return
				end
				local scale = Creator.GetEffectiveScale(scroll)
				local contentY = math.ceil(listLayout.AbsoluteContentSize.Y / scale) + 12
				scroll.CanvasSize = UDim2.new(0, 0, 0, contentY)
				if not Console.Paused then
					local viewH = scroll.AbsoluteSize.Y / scale
					scroll.CanvasPosition = Vector2.new(0, math.max(0, contentY - viewH))
				end
			end
			Creator.AddSignal(listLayout:GetPropertyChangedSignal("AbsoluteContentSize"), syncCanvas)
			Creator.RegisterDPIScale(scroll, function()
				task.defer(syncCanvas)
			end)

			Console.Frame = New(
				"Frame",
				{
					Name = "AcryvenLiveConsole",
					Size = UDim2.new(1, 0, 0, height),
					BackgroundTransparency = 0.14,
					ClipsDescendants = true,
					LayoutOrder = config.LayoutOrder or 7,
					Parent = parent.Container,
					ThemeTag = {BackgroundColor3 = "DialogHolder"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(0, Creator.Radius.Card)}),
					New("UIStroke", {Transparency = 0.34, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "ElementBorder"}}),
					header,
					scroll
				}
			)
			Console.Root = Console.Frame

			local rowNodes = {}
			local orderSeq = 0

			function Console.Log(_self, message, level)
				local lvl = tostring(level or "INFO"):upper()
				local lvlColor = LEVEL_COLORS[lvl] or LEVEL_COLORS.INFO
				local ts = os.date("%H:%M:%S")
				local text = tostring(message or "")
				orderSeq += 1

				table.insert(Console.Lines, string.format("[%s] [%s] %s", ts, lvl, text))
				local row = New(
					"Frame",
					{
						Name = "LogRow",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						LayoutOrder = orderSeq,
						Parent = scroll
					},
					{
						New("TextLabel", {
							Name = "Time",
							Text = ts,
							I18nSkip = true,
							FontRole = "Mono",
							FontFace = Creator.Font(Enum.FontWeight.Regular, Enum.FontStyle.Normal, "Mono"),
							TextSize = 11,
							TextXAlignment = Enum.TextXAlignment.Left,
							Size = UDim2.fromOffset(54, 16),
							BackgroundTransparency = 1,
							TextTransparency = 0.3,
							ThemeTag = {TextColor3 = "SubText"}
						}),
						New("Frame", {
							Name = "LevelPill",
							Position = UDim2.fromOffset(56, 1),
							Size = UDim2.fromOffset(38, 14),
							BackgroundColor3 = lvlColor,
							BackgroundTransparency = 0.16
						}, {
							New("UICorner", {CornerRadius = UDim.new(0, 4)}),
							New("TextLabel", {
								Text = lvl:sub(1, 4),
								I18nSkip = true,
								FontFace = Creator.Font(Enum.FontWeight.Bold),
								TextSize = 9,
								Size = UDim2.fromScale(1, 1),
								BackgroundTransparency = 1,
								TextColor3 = Creator.AutoContrast(lvlColor)
							})
						}),
						New("TextLabel", {
							Name = "Msg",
							Text = text,
							I18nSkip = true,
							FontRole = "Mono",
							FontFace = Creator.Font(Enum.FontWeight.Regular, Enum.FontStyle.Normal, "Mono"),
							TextSize = 11,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Top,
							AutomaticSize = Enum.AutomaticSize.Y,
							Position = UDim2.fromOffset(100, 0),
							Size = UDim2.new(1, -104, 0, 16),
							BackgroundTransparency = 1,
							ThemeTag = {TextColor3 = "Text"}
						})
					}
				)
				table.insert(rowNodes, row)
				while #rowNodes > maxLines do
					local old = table.remove(rowNodes, 1)
					table.remove(Console.Lines, 1)
					if old and old.Parent then
						old:Destroy()
					end
				end
			end

			function Console.Clear(_self)
				for _, r in ipairs(rowNodes) do
					if r and r.Parent then
						r:Destroy()
					end
				end
				table.clear(rowNodes)
				table.clear(Console.Lines)
				syncCanvas()
			end

			Creator.AddSignal(pauseBtn.MouseButton1Click, function()
				Console.Paused = not Console.Paused
				pauseIcon.Image = Library:GetIcon(Console.Paused and "play" or "pause") or ""
				Creator.OverrideTag(pauseIcon, {ImageColor3 = Console.Paused and "Accent" or "SubText"})
			end)
			Creator.AddSignal(clearBtn.MouseButton1Click, function()
				Console:Clear()
			end)
			Creator.AddSignal(copyBtn.MouseButton1Click, function()
				copyClipboard(table.concat(Console.Lines, "\n"))
				copyIcon.Image = Library:GetIcon("check") or ""
				Creator.OverrideTag(copyIcon, {ImageColor3 = "Accent"})
				task.delay(1, function()
					if copyIcon and copyIcon.Parent then
						copyIcon.Image = Library:GetIcon("copy") or ""
						Creator.OverrideTag(copyIcon, {ImageColor3 = "SubText"})
					end
				end)
			end)

			function Console.Destroy(_self)
				Console.Frame:Destroy()
				if idx ~= nil then
					Library.Options[idx] = nil
				end
			end

			if type(config.InitialLines) == "table" then
				for _, entry in ipairs(config.InitialLines) do
					if type(entry) == "table" then
						Console:Log(entry.Message or entry[1], entry.Level or entry[2])
					else
						Console:Log(entry, "INFO")
					end
				end
			end
			if idx ~= nil then
				Library.Options[idx] = Console
			end
			return Console
		end
		return Element
	end,
	[75] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(75)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local Players = Creator.GetService("Players")
		local New, Components, Element = Creator.New, Root.Components, {}
		Element.__index = Element
		Element.__type = "PlayerSelector"

		function Element.New(parent, idx, config)
			if type(idx) == "table" and config == nil then
				config = idx
				idx = nil
			end
			local Library = parent.Library
			config = type(config) == "table" and config or {}
			local multi = config.Multi == true
			local excludeLocal = config.ExcludeLocalPlayer == true
			local maxHeight = math.clamp(tonumber(config.MaxHeight) or 148, 72, 260)

			local Selector = {
				Value = multi and {} or nil,
				Multi = multi,
				Callback = config.Callback or function() end,
				Type = "PlayerSelector"
			}

			local card = requireModule(Components.Element)(config.Title or "Select Player", config.Description, parent.Container, false)
			card.TitleLabel.Size = UDim2.new(1, -38, 0, 14)
			card.DescLabel.Size = UDim2.new(1, -38, 0, 14)
			card.LabelHolder.Size = UDim2.new(1, -24, 0, 0)
			Selector.SetTitle = card.SetTitle
			Selector.SetDesc = card.SetDesc
			Selector.SetBadge = card.SetBadge
			Selector.Frame = card.Frame

			local refreshIcon = New("ImageLabel", {
				Image = Library:GetIcon("refresh-cw") or "",
				Size = UDim2.fromOffset(13, 13),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ThemeTag = {ImageColor3 = "SubText"}
			})
			local refreshBtn = New(
				"TextButton",
				{
					Name = "RefreshBtn",
					Text = "",
					Size = UDim2.fromOffset(24, 24),
					Position = UDim2.new(1, -10, 0, 8),
					AnchorPoint = Vector2.new(1, 0),
					BackgroundTransparency = 0.28,
					AutoButtonColor = false,
					ZIndex = 4,
					Parent = card.Frame,
					ThemeTag = {BackgroundColor3 = "DialogButton"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(0, 6)}),
					New("UIStroke", {Transparency = 0.4, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "InElementBorder"}}),
					refreshIcon
				}
			)

			local listLayout = New("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder})
			local listFrame = New(
				"ScrollingFrame",
				{
					Name = "PlayersList",
					Size = UDim2.new(1, 0, 0, 48),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarThickness = 3,
					ScrollBarImageTransparency = 0.45,
					CanvasSize = UDim2.fromOffset(0, 0),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					LayoutOrder = 4,
					Parent = card.LabelHolder,
					ThemeTag = {ScrollBarImageColor3 = "Accent"}
				},
				{
					listLayout,
					New(
						"UIPadding",
						{
							PaddingTop = UDim.new(0, 2),
							PaddingBottom = UDim.new(0, 4),
							PaddingLeft = UDim.new(0, 2),
							PaddingRight = UDim.new(0, 6)
						}
					)
				}
			)
			New("Frame", {Size = UDim2.new(1, 0, 0, 4), BackgroundTransparency = 1, LayoutOrder = 3, Parent = card.LabelHolder})

			local function syncListSize()
				if not listFrame or not listFrame.Parent then
					return
				end
				local scale = Creator.GetEffectiveScale(listFrame)
				local contentY = math.ceil(listLayout.AbsoluteContentSize.Y / scale) + 6
				listFrame.CanvasSize = UDim2.new(0, 0, 0, contentY)
				listFrame.Size = UDim2.new(1, 0, 0, math.clamp(contentY, 48, maxHeight))
			end
			Creator.AddSignal(listLayout:GetPropertyChangedSignal("AbsoluteContentSize"), syncListSize)

			local rows = {}
			local function isSelected(name)
				if multi then
					return Selector.Value[name] == true
				end
				return Selector.Value == name
			end

			local function fireChanged(silent)
				if not silent then
					Library:SafeCallback(Selector.Callback, Selector.Value)
					Library:SafeCallback(Selector.Changed, Selector.Value)
				end
			end

			local function refreshRowVisuals(instant)
				local accentContrast = Creator.AutoContrast(Creator.GetThemeProperty("Accent"))
				local selectedCount = 0
				local useInstant = instant == true or Creator.ReducedMotion
				for name, info in next, rows do
					if info.Stroke and info.CheckBadge then
						local active = isSelected(name)
						if active then
							selectedCount += 1
						end
						Creator.OverrideTag(info.Row, {BackgroundColor3 = active and "Accent" or "DialogButton"})
						Creator.OverrideTag(info.Stroke, {Color = active and "Accent" or "InElementBorder"})
						if info.AvatarStroke then
							Creator.OverrideTag(info.AvatarStroke, {Color = active and "Accent" or "InElementBorder"})
						end
						if useInstant then
							Creator.CancelSpring(info.Row, "BackgroundTransparency")
							Creator.CancelSpring(info.Stroke, "Transparency")
							info.Row.BackgroundTransparency = active and 0.76 or 0.22
							info.Stroke.Transparency = active and 0.14 or 0.34
							if info.Bar then
								Creator.CancelSpring(info.Bar, "BackgroundTransparency")
								Creator.CancelSpring(info.Bar, "BarH")
								info.Bar.BackgroundTransparency = active and 0 or 1
								info.Bar.Size = UDim2.fromOffset(3, active and 22 or 4)
							end
							if info.AvatarStroke then
								Creator.CancelSpring(info.AvatarStroke, "Transparency")
								info.AvatarStroke.Transparency = active and 0.08 or 0.45
							end
							if info.CheckScale then
								Creator.CancelSpring(info.CheckScale, "Scale")
								info.CheckScale.Scale = active and 1 or 0.35
							end
							info.CheckBadge.BackgroundTransparency = active and 0.04 or 1
							info.CheckBadge.Visible = active
							if info.Check then
								info.Check.ImageColor3 = accentContrast
								info.Check.ImageTransparency = active and 0 or 1
							end
						else
							Creator.SpringValue(info.Row, "BackgroundTransparency", active and 0.76 or 0.22, 5.2, 1)
							Creator.SpringValue(info.Stroke, "Transparency", active and 0.14 or 0.34, 5.2, 1)
							if info.AvatarStroke then
								Creator.SpringValue(info.AvatarStroke, "Transparency", active and 0.08 or 0.45, 5.2, 1)
							end
							if info.Bar then
								Creator.SpringValue(info.Bar, "BackgroundTransparency", active and 0 or 1, 5.2, 1)
								Creator.SpringValue(info.Bar, "BarH", active and 22 or 4, 4.8, 0.80, function(h)
									info.Bar.Size = UDim2.fromOffset(3, h)
								end, info.Bar.Size.Y.Offset)
							end
							if active ~= info.WasSelected then
								info.AnimGen = (info.AnimGen or 0) + 1
								local myGen = info.AnimGen
								if active then
									info.CheckBadge.Visible = true
									if info.CheckScale then
										info.CheckScale.Scale = 0.35
										Creator.SpringValue(info.CheckScale, "Scale", 1, 4.5, 0.62)
									end
									Creator.SpringValue(info.CheckBadge, "BackgroundTransparency", 0.04, 5.2, 1)
									if info.Check then
										info.Check.ImageColor3 = accentContrast
										Creator.SpringValue(info.Check, "ImageTransparency", 0, 5.2, 1)
									end
								else
									if info.CheckScale then
										Creator.SpringValue(info.CheckScale, "Scale", 0.35, 5.8, 1)
									end
									Creator.SpringValue(info.CheckBadge, "BackgroundTransparency", 1, 5.8, 1)
									if info.Check then
										Creator.SpringValue(info.Check, "ImageTransparency", 1, 5.8, 1)
									end
									task.delay(0.18, function()
										if myGen == info.AnimGen and not isSelected(name) and info.CheckBadge and info.CheckBadge.Parent then
											info.CheckBadge.Visible = false
										end
									end)
								end
							elseif active and info.Check then
								info.Check.ImageColor3 = accentContrast
							end
						end
						info.WasSelected = active
					end
				end
				card:SetBadge(selectedCount > 0 and (tostring(selectedCount) .. " selected") or nil)
			end

			function Selector.Refresh(_self)
				for _, info in next, rows do
					if info.Row and info.Row.Parent then
						info.Row:Destroy()
					end
				end
				table.clear(rows)
				local localPlr = Players.LocalPlayer
				local players = Players:GetPlayers()
				local shown = 0
				local accentContrast = Creator.AutoContrast(Creator.GetThemeProperty("Accent"))
				for i, plr in ipairs(players) do
					if not (excludeLocal and plr == localPlr) then
						shown += 1
						local uname = plr.Name
						local dname = plr.DisplayName
						local uid = plr.UserId
						local thumb = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(uid) .. "&w=100&h=100"

						local stroke = New("UIStroke", {
							Transparency = 0.34,
							Thickness = 1.2,
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							ThemeTag = {Color = "InElementBorder"}
						})
						local accentBar = New("Frame", {
							Name = "SelBar",
							Size = UDim2.fromOffset(3, 22),
							Position = UDim2.new(0, 5, 0.5, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundTransparency = 1,
							ThemeTag = {BackgroundColor3 = "Accent"}
						}, {New("UICorner", {CornerRadius = UDim.new(1, 0)})})
						local avatarStroke = New("UIStroke", {
							Transparency = 0.45,
							Thickness = 1.4,
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							ThemeTag = {Color = "InElementBorder"}
						})
						local checkIcon = New("ImageLabel", {
							Name = "Check",
							Image = Library:GetIcon("check") or "",
							Size = UDim2.fromOffset(12, 12),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.fromScale(0.5, 0.5),
							BackgroundTransparency = 1,
							ImageColor3 = accentContrast
						})
						local checkScale = New("UIScale", {Scale = 0.35})
						local checkBadge = New("Frame", {
							Name = "CheckBadge",
							Size = UDim2.fromOffset(20, 20),
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -10, 0.5, 0),
							BackgroundTransparency = 1,
							Visible = false,
							ThemeTag = {BackgroundColor3 = "Accent"}
						}, {
							checkScale,
							New("UICorner", {CornerRadius = UDim.new(1, 0)}),
							checkIcon
						})
						local rowScale = New("UIScale", {Scale = 1})
						local row = New(
							"TextButton",
							{
								Name = "Plr_" .. uname,
								Text = "",
								AutoButtonColor = false,
								Size = UDim2.new(1, -2, 0, 42),
								BackgroundTransparency = 0.22,
								LayoutOrder = i,
								Parent = listFrame,
								ThemeTag = {BackgroundColor3 = "DialogButton"}
							},
							{
								rowScale,
								New("UICorner", {CornerRadius = UDim.new(0, 8)}),
								stroke,
								accentBar,
								New("ImageLabel", {
									Name = "Avatar",
									Image = thumb,
									Size = UDim2.fromOffset(28, 28),
									Position = UDim2.new(0, 12, 0.5, 0),
									AnchorPoint = Vector2.new(0, 0.5),
									BackgroundTransparency = 0.8,
									ThemeTag = {BackgroundColor3 = "DialogHolder"}
								}, {
									New("UICorner", {CornerRadius = UDim.new(1, 0)}),
									avatarStroke
								}),
								New("TextLabel", {
									Name = "Display",
									Text = dname .. (plr == localPlr and " (You)" or ""),
									I18nSkip = true,
									FontFace = Creator.Font(Enum.FontWeight.SemiBold),
									TextSize = 13,
									TextXAlignment = Enum.TextXAlignment.Left,
									TextTruncate = Enum.TextTruncate.AtEnd,
									Position = UDim2.fromOffset(48, 5),
									Size = UDim2.new(1, -82, 0, 16),
									BackgroundTransparency = 1,
									ThemeTag = {TextColor3 = "Text"}
								}),
								New("TextLabel", {
									Name = "User",
									Text = "@" .. uname,
									I18nSkip = true,
									FontFace = Creator.Font(Enum.FontWeight.Medium),
									TextSize = 11,
									TextTransparency = 0.04,
									TextXAlignment = Enum.TextXAlignment.Left,
									TextTruncate = Enum.TextTruncate.AtEnd,
									Position = UDim2.fromOffset(48, 22),
									Size = UDim2.new(1, -82, 0, 14),
									BackgroundTransparency = 1,
									ThemeTag = {TextColor3 = "SubText"}
								}),
								checkBadge
							}
						)
						Creator.AddSignal(row.MouseEnter, function()
							if not isSelected(uname) then
								Creator.SpringValue(row, "BackgroundTransparency", 0.1, 5.2, 1)
								Creator.SpringValue(stroke, "Transparency", 0.16, 5.2, 1)
							end
						end)
						Creator.AddSignal(row.MouseLeave, function()
							Creator.SpringValue(rowScale, "Scale", 1, 6.0, 0.85)
							if not isSelected(uname) then
								Creator.SpringValue(row, "BackgroundTransparency", 0.22, 5.2, 1)
								Creator.SpringValue(stroke, "Transparency", 0.34, 5.2, 1)
							end
						end)
						Creator.AddSignal(row.MouseButton1Down, function()
							Creator.SpringValue(rowScale, "Scale", 0.98, 6.5, 0.9)
						end)
						Creator.AddSignal(row.MouseButton1Up, function()
							Creator.SpringValue(rowScale, "Scale", 1, 5.5, 0.8)
						end)
						Creator.AddSignal(row.MouseButton1Click, function()
							if multi then
								Selector.Value[uname] = not Selector.Value[uname]
								if not Selector.Value[uname] then
									Selector.Value[uname] = nil
								end
							else
								Selector.Value = (Selector.Value == uname) and nil or uname
							end
							refreshRowVisuals()
							fireChanged(false)
							Library._TouchElement(Selector)
						end)
						rows[uname] = {Row = row, Stroke = stroke, Bar = accentBar, AvatarStroke = avatarStroke, CheckBadge = checkBadge, CheckScale = checkScale, Check = checkIcon, WasSelected = false, AnimGen = 0}
					end
				end
				if shown == 0 then
					local empty = New("TextLabel", {
						Text = "No other players in server.",
						FontFace = Creator.Font(Enum.FontWeight.Regular),
						TextSize = 11,
						Size = UDim2.new(1, 0, 0, 32),
						BackgroundTransparency = 1,
						ThemeTag = {TextColor3 = "SubText"},
						Parent = listFrame
					})
					rows.__empty = {Row = empty, Stroke = nil, Check = nil}
				end
				refreshRowVisuals(true)
				syncListSize()
			end

			function Selector.SetValue(_self, val, silent)
				if multi then
					Selector.Value = type(val) == "table" and val or {}
				else
					Selector.Value = val
				end
				refreshRowVisuals()
				fireChanged(silent)
			end

			function Selector.GetValue(_self)
				return Selector.Value
			end

			function Selector.OnChanged(_self, cb)
				Selector.Changed = cb
				cb(Selector.Value)
			end

			local addedConn = Creator.AddSignal(Players.PlayerAdded, function()
				if card.Frame and card.Frame.Parent then
					Selector:Refresh()
				end
			end)
			local removingConn = Creator.AddSignal(Players.PlayerRemoving, function()
				task.defer(function()
					if card.Frame and card.Frame.Parent then
						Selector:Refresh()
					end
				end)
			end)

			Creator.AddSignal(refreshBtn.MouseButton1Click, function()
				Selector:Refresh()
			end)

			function Selector.Destroy(_self)
				pcall(function() addedConn:Disconnect() end)
				pcall(function() removingConn:Disconnect() end)
				card:Destroy()
				if idx ~= nil then
					Library.Options[idx] = nil
				end
			end

			Selector:Refresh()
			if idx ~= nil then
				Library.Options[idx] = Selector
			end
			return Selector
		end
		return Element
	end,
	[76] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(76)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local New, Components, Element = Creator.New, Root.Components, {}
		Element.__index = Element
		Element.__type = "ProgressBar"

		function Element.New(parent, idx, config)
			if type(idx) == "table" and config == nil then
				config = idx
				idx = nil
			end
			local Library = parent.Library
			assert(config and config.Title, "ProgressBar - Missing Title.")
			local maxVal = math.max(0.0001, tonumber(config.Max) or 100)
			local initVal = math.clamp(tonumber(config.Value or config.Default) or 0, 0, maxVal)

			local Bar = {
				Value = initVal,
				Max = maxVal,
				ShowPercent = config.ShowPercent ~= false,
				Suffix = type(config.Suffix) == "string" and config.Suffix or "",
				Type = "ProgressBar"
			}

			local card = requireModule(Components.Element)(config.Title, config.Description, parent.Container, false)
			card.TitleLabel.Size = UDim2.new(1, -110, 0, 14)
			card.DescLabel.Size = UDim2.new(1, -110, 0, 14)
			Bar.SetTitle = card.SetTitle
			Bar.SetDesc = card.SetDesc
			Bar.SetBadge = card.SetBadge
			Bar.Frame = card.Frame

			local labelPad = card.LabelHolder:FindFirstChildOfClass("UIPadding")
			if labelPad then
				labelPad.PaddingBottom = UDim.new(0, 26)
			end

			local statusText = New(
				"TextLabel",
				{
					Name = "StatusText",
					Text = "",
					I18nSkip = true,
					FontFace = Creator.Font(Enum.FontWeight.SemiBold),
					TextSize = 11,
					TextXAlignment = Enum.TextXAlignment.Right,
					Size = UDim2.fromOffset(100, 18),
					Position = UDim2.new(1, -12, 0, 10),
					AnchorPoint = Vector2.new(1, 0),
					BackgroundTransparency = 1,
					Parent = card.Frame,
					ThemeTag = {TextColor3 = "SubText"}
				}
			)

			local fillBar = New(
				"Frame",
				{
					Name = "Fill",
					Size = UDim2.fromScale(0, 1),
					BackgroundColor3 = typeof(config.Color) == "Color3" and config.Color or Color3.fromRGB(99, 179, 255),
					ThemeTag = typeof(config.Color) ~= "Color3" and {BackgroundColor3 = "Accent"} or nil
				},
				{New("UICorner", {CornerRadius = UDim.new(1, 0)})}
			)

			New(
				"Frame",
				{
					Name = "Track",
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.new(0, 12, 1, -11),
					Size = UDim2.new(1, -24, 0, 6),
					BackgroundTransparency = 0.72,
					ClipsDescendants = true,
					Parent = card.Frame,
					ThemeTag = {BackgroundColor3 = "SliderRail"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(1, 0)}),
					New("UIStroke", {Transparency = 0.55, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "InElementBorder"}}),
					fillBar
				}
			)

			local curRatio = 0
			local function applyRatio(r)
				curRatio = math.clamp(r, 0, 1)
				fillBar.Size = UDim2.fromScale(curRatio, 1)
			end

			function Bar.SetValue(_self, val, customLabel, instant)
				val = math.clamp(tonumber(val) or 0, 0, Bar.Max)
				Bar.Value = val
				local ratio = Bar.Max > 0 and (val / Bar.Max) or 0
				if customLabel ~= nil then
					statusText.Text = tostring(customLabel)
				elseif Bar.ShowPercent then
					statusText.Text = string.format("%d%%", math.floor(ratio * 100 + 0.5))
				else
					statusText.Text = tostring(val) .. " / " .. tostring(Bar.Max) .. Bar.Suffix
				end
				if instant or Creator.ReducedMotion then
					Creator.CancelSpring(fillBar, "FillRatio")
					applyRatio(ratio)
				else
					Creator.SpringValue(fillBar, "FillRatio", ratio, 7.5, 0.92, applyRatio, curRatio)
				end
			end

			function Bar.SetMax(_self, newMax)
				Bar.Max = math.max(0.0001, tonumber(newMax) or 100)
				Bar:SetValue(Bar.Value)
			end

			function Bar.SetColor(_self, color)
				if typeof(color) == "Color3" then
					Creator.OverrideTag(fillBar, {})
					fillBar.BackgroundColor3 = color
				else
					Creator.OverrideTag(fillBar, {BackgroundColor3 = "Accent"})
				end
			end

			function Bar.Destroy(_self)
				Creator.CancelSpring(fillBar, "FillRatio")
				card:Destroy()
				if idx ~= nil then
					Library.Options[idx] = nil
				end
			end

			Bar:SetValue(initVal, config.Label, true)
			if idx ~= nil then
				Library.Options[idx] = Bar
			end
			return Bar
		end
		return Element
	end,
	[77] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(77)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local New, Components, Element = Creator.New, Root.Components, {}
		Element.__index = Element
		Element.__type = "RangeSlider"

		function Element.New(parent, idx, config)
			if type(idx) == "table" and config == nil then
				config = idx
				idx = nil
			end
			local Library = parent.Library
			assert(config and config.Title, "RangeSlider - Missing Title.")
			local minVal = tonumber(config.Min) or 0
			local maxVal = tonumber(config.Max) or 100
			if maxVal <= minVal then
				maxVal = minVal + 1
			end
			local rounding = tonumber(config.Rounding) or 0
			local minGap = math.max(0, tonumber(config.MinGap) or 0)
			local defLow, defHigh = minVal, maxVal
			if type(config.Default) == "table" then
				defLow = tonumber(config.Default.Min or config.Default[1]) or minVal
				defHigh = tonumber(config.Default.Max or config.Default[2]) or maxVal
			end
			defLow = math.clamp(defLow, minVal, maxVal)
			defHigh = math.clamp(math.max(defHigh, defLow + minGap), minVal, maxVal)

			local RangeSlider = {
				Value = {Min = defLow, Max = defHigh},
				Default = {Min = defLow, Max = defHigh},
				Min = minVal,
				Max = maxVal,
				MinGap = minGap,
				Rounding = rounding,
				Prefix = type(config.Prefix) == "string" and config.Prefix or "",
				Suffix = type(config.Suffix) == "string" and config.Suffix or "",
				Callback = config.Callback or function() end,
				Type = "RangeSlider"
			}

			local sliderFrame = requireModule(Components.Element)(config.Title, config.Description, parent.Container, false)
			sliderFrame.TitleLabel.Size = UDim2.new(1, -130, 0, 14)
			sliderFrame.DescLabel.Size = UDim2.new(1, -130, 0, 14)
			RangeSlider.SetTitle = sliderFrame.SetTitle
			RangeSlider.SetDesc = sliderFrame.SetDesc
			RangeSlider.SetBadge = sliderFrame.SetBadge
			RangeSlider.Frame = sliderFrame.Frame

			-- Extra bottom padding inside LabelHolder so the full-width dual track sits cleanly below title/desc
			local labelPad = sliderFrame.LabelHolder:FindFirstChildOfClass("UIPadding")
			if labelPad then
				labelPad.PaddingBottom = UDim.new(0, 34)
			end

			local valuePill = New(
				"TextLabel",
				{
					Name = "RangeValue",
					FontFace = Creator.Font(Enum.FontWeight.Medium),
					Text = "",
					I18nSkip = true,
					TextSize = 11,
					TextXAlignment = Enum.TextXAlignment.Center,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.fromOffset(0, 22),
					Position = UDim2.new(1, -12, 0, 10),
					AnchorPoint = Vector2.new(1, 0),
					BackgroundTransparency = 0.24,
					Parent = sliderFrame.Frame,
					ThemeTag = {BackgroundColor3 = "DialogHolder", TextColor3 = "Text"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(0, 6)}),
					New("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}),
					New("UIStroke", {Transparency = 0.38, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "InElementBorder"}})
				}
			)

			local function makeThumb(name)
				return New(
					"Frame",
					{
						Name = name,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0, 0, 0.5, 0),
						Size = UDim2.fromOffset(13, 13),
						BackgroundTransparency = 0,
						ZIndex = 4,
						ThemeTag = {BackgroundColor3 = "Text"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(1, 0)}),
						New("UIStroke", {Thickness = 2, Transparency = 0.05, ThemeTag = {Color = "Accent"}})
					}
				)
			end

			local lowThumb = makeThumb("LowThumb")
			local highThumb = makeThumb("HighThumb")

			local rangeFill = New(
				"Frame",
				{
					Name = "RangeFill",
					Size = UDim2.fromScale(0, 1),
					Position = UDim2.fromScale(0, 0),
					ZIndex = 2,
					ThemeTag = {BackgroundColor3 = "Accent"}
				},
				{New("UICorner", {CornerRadius = UDim.new(1, 0)})}
			)

			local railInner = New(
				"Frame",
				{
					Name = "RailInner",
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(6, 0),
					Size = UDim2.new(1, -12, 1, 0),
					ZIndex = 3
				},
				{lowThumb, highThumb}
			)

			local track = New(
				"Frame",
				{
					Name = "RangeTrack",
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.new(0, 12, 1, -13),
					Size = UDim2.new(1, -24, 0, 5),
					BackgroundTransparency = 0.72,
					Parent = sliderFrame.Frame,
					ThemeTag = {BackgroundColor3 = "SliderRail"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(1, 0)}),
					rangeFill,
					railInner
				}
			)

			local hitArea = New(
				"Frame",
				{
					Name = "HitArea",
					BackgroundTransparency = 1,
					Active = true,
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, -6, 0.5, 0),
					Size = UDim2.new(1, 12, 0, 26),
					ZIndex = 5,
					Parent = railInner
				}
			)

			local function formatNum(v)
				return RangeSlider.Prefix .. tostring(v) .. RangeSlider.Suffix
			end

			local function setThumbSize(thumb, px)
				Creator.SpringValue(thumb, "ThumbSize", px, 12, 0.8, function(s)
					thumb.Size = UDim2.fromOffset(s, s)
				end, thumb.Size.X.Offset)
			end

			function RangeSlider.OnChanged(_self, cb)
				RangeSlider.Changed = cb
				cb(RangeSlider.Value.Min, RangeSlider.Value.Max, RangeSlider.Value)
			end

			function RangeSlider.SetValue(self, a, b, silent)
				local nextLow, nextHigh
				if type(a) == "table" then
					nextLow = tonumber(a.Min or a[1]) or self.Value.Min
					nextHigh = tonumber(a.Max or a[2]) or self.Value.Max
					silent = b == true
				else
					nextLow = tonumber(a) or self.Value.Min
					nextHigh = tonumber(b) or self.Value.Max
				end
				nextLow = Library:Round(math.clamp(nextLow, self.Min, self.Max), self.Rounding)
				nextHigh = Library:Round(math.clamp(nextHigh, self.Min, self.Max), self.Rounding)
				if nextLow > nextHigh then
					nextLow, nextHigh = nextHigh, nextLow
				end
				if (nextHigh - nextLow) < self.MinGap then
					nextHigh = math.min(self.Max, Library:Round(nextLow + self.MinGap, self.Rounding))
					if (nextHigh - nextLow) < self.MinGap then
						nextLow = math.max(self.Min, Library:Round(nextHigh - self.MinGap, self.Rounding))
					end
				end
				self.Value = {Min = nextLow, Max = nextHigh}
				local span = self.Max - self.Min
				local rLow = span ~= 0 and ((nextLow - self.Min) / span) or 0
				local rHigh = span ~= 0 and ((nextHigh - self.Min) / span) or 1
				lowThumb.Position = UDim2.new(rLow, 0, 0.5, 0)
				highThumb.Position = UDim2.new(rHigh, 0, 0.5, 0)
				rangeFill.Position = UDim2.fromScale(rLow, 0)
				rangeFill.Size = UDim2.fromScale(math.max(0, rHigh - rLow), 1)
				valuePill.Text = formatNum(nextLow) .. " - " .. formatNum(nextHigh)
				if not silent then
					Library:SafeCallback(self.Callback, nextLow, nextHigh, self.Value)
					Library:SafeCallback(self.Changed, nextLow, nextHigh, self.Value)
				end
			end

			local activeThumb = nil
			local dragRailX, dragRailW = nil, nil
			local function applyDragPos(posX)
				local width = dragRailW or railInner.AbsoluteSize.X
				local railX = dragRailX or railInner.AbsolutePosition.X
				if width <= 0 then
					return
				end
				local ratio = math.clamp((posX - railX) / width, 0, 1)
				local rawVal = RangeSlider.Min + (RangeSlider.Max - RangeSlider.Min) * ratio
				if activeThumb == "low" then
					local maxLow = RangeSlider.Value.Max - RangeSlider.MinGap
					RangeSlider:SetValue(math.min(rawVal, maxLow), RangeSlider.Value.Max)
				else
					local minHigh = RangeSlider.Value.Min + RangeSlider.MinGap
					RangeSlider:SetValue(RangeSlider.Value.Min, math.max(rawVal, minHigh))
				end
			end

			local function beginThumbDrag(which, inputPosX)
				activeThumb = which
				dragRailX = railInner.AbsolutePosition.X
				dragRailW = railInner.AbsoluteSize.X
				setThumbSize(which == "low" and lowThumb or highThumb, 16)
				Library._TouchElement(RangeSlider)
				if inputPosX then
					applyDragPos(inputPosX)
				end
				Creator.BeginDrag(function(mv)
					if activeThumb then
						applyDragPos(mv.Position.X)
					end
				end, function()
					if activeThumb == "low" then
						setThumbSize(lowThumb, 13)
					elseif activeThumb == "high" then
						setThumbSize(highThumb, 13)
					end
					activeThumb = nil
					dragRailX, dragRailW = nil, nil
				end)
			end

			Creator.AddSignal(hitArea.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					local lowDist = math.abs(input.Position.X - (lowThumb.AbsolutePosition.X + lowThumb.AbsoluteSize.X * 0.5))
					local highDist = math.abs(input.Position.X - (highThumb.AbsolutePosition.X + highThumb.AbsoluteSize.X * 0.5))
					local chosen = (lowDist <= highDist) and "low" or "high"
					beginThumbDrag(chosen, input.Position.X)
				end
			end)

			function RangeSlider.Destroy(_self)
				if activeThumb then
					activeThumb = nil
					Creator.EndDrag()
				end
				sliderFrame:Destroy()
				if idx ~= nil then
					Library.Options[idx] = nil
				end
			end

			RangeSlider:SetValue(defLow, defHigh, true)
			if idx ~= nil then
				Library.Options[idx] = RangeSlider
			end
			return RangeSlider
		end
		return Element
	end,
	[78] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(78)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local New, Components, Element = Creator.New, Root.Components, {}
		Element.__index = Element
		Element.__type = "SegmentedControl"

		function Element.New(parent, idx, config)
			if type(idx) == "table" and config == nil then
				config = idx
				idx = nil
			end
			local Library = parent.Library
			assert(config and config.Title, "SegmentedControl - Missing Title.")
			local values = type(config.Values) == "table" and config.Values or {"Option 1", "Option 2"}
			local defaultVal = config.Default
			if type(defaultVal) == "number" then
				defaultVal = values[defaultVal] or values[1]
			elseif defaultVal == nil then
				defaultVal = values[1]
			end

			local Segmented = {
				Value = defaultVal,
				Default = defaultVal,
				Values = values,
				Callback = config.Callback or function() end,
				Type = "SegmentedControl"
			}

			local card = requireModule(Components.Element)(config.Title, config.Description, parent.Container, false)
			Segmented.SetTitle = card.SetTitle
			Segmented.SetDesc = card.SetDesc
			Segmented.SetBadge = card.SetBadge
			Segmented.Frame = card.Frame
			card.LabelHolder.Size = UDim2.new(1, -24, 0, 0)

			local pad = 3
			local pill = New(
				"Frame",
				{
					Name = "ActivePill",
					Size = UDim2.new(0, 0, 1, -pad * 2),
					Position = UDim2.fromOffset(pad, pad),
					BackgroundTransparency = 0.08,
					ZIndex = 2,
					ThemeTag = {BackgroundColor3 = "Accent"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(0, 6)}),
					New(
						"UIGradient",
						{
							Rotation = 90,
							Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
								ColorSequenceKeypoint.new(1, Color3.fromRGB(218, 224, 236))
							})
						}
					)
				}
			)

			local segButtonsHolder = New(
				"Frame",
				{
					Name = "Segments",
					Size = UDim2.new(1, -pad * 2, 1, -pad * 2),
					Position = UDim2.fromOffset(pad, pad),
					BackgroundTransparency = 1,
					ZIndex = 3
				},
				{
					New("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder
					})
				}
			)

			local trackFrame = New(
				"Frame",
				{
					Name = "SegmentTrack",
					Size = UDim2.new(1, 0, 0, 30),
					BackgroundTransparency = 0.24,
					LayoutOrder = 4,
					Parent = card.LabelHolder,
					ThemeTag = {BackgroundColor3 = "DialogHolder"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(0, 8)}),
					New("UIStroke", {Transparency = 0.36, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "InElementBorder"}}),
					pill,
					segButtonsHolder
				}
			)

			-- Small top spacing between description and segmented track
			local spacer = New("Frame", {Name = "Spacer", Size = UDim2.new(1, 0, 0, 4), BackgroundTransparency = 1, LayoutOrder = 3, Parent = card.LabelHolder})

			local buttons = {}
			local selectedIdx = 1
			local curX, curW = pad, 0

			local function setPillBounds(x, w)
				curX, curW = x, w
				pill.Position = UDim2.fromOffset(x, pad)
				pill.Size = UDim2.new(0, math.max(0, w), 1, -pad * 2)
			end

			local function updatePill(instant)
				local n = #buttons
				if n == 0 then
					return
				end
				local scale = Creator.GetEffectiveScale(trackFrame)
				local innerW = math.max(0, trackFrame.AbsoluteSize.X / scale - pad * 2)
				if innerW <= 0 then
					return
				end
				local segW = innerW / n
				local targetX = pad + (selectedIdx - 1) * segW
				if instant or Creator.ReducedMotion or curW <= 0 then
					Creator.CancelSpring(pill, "SegX")
					Creator.CancelSpring(pill, "SegW")
					setPillBounds(targetX, segW)
				else
					Creator.SpringValue(pill, "SegX", targetX, 10, 0.86, function(x)
						setPillBounds(x, curW)
					end, curX)
					Creator.SpringValue(pill, "SegW", segW, 10, 0.86, function(w)
						setPillBounds(curX, w)
					end, curW)
				end
			end

			local function refreshColors()
				local contrast = Creator.AutoContrast(Creator.GetThemeProperty("Accent"))
				for i, btn in ipairs(buttons) do
					if i == selectedIdx then
						Creator.OverrideTag(btn, {})
						btn.TextColor3 = contrast
						btn.TextTransparency = 0
					else
						Creator.OverrideTag(btn, {TextColor3 = "SubText"})
						btn.TextTransparency = 0.04
					end
				end
			end

			Creator.AddSignal(pill:GetPropertyChangedSignal("BackgroundColor3"), function()
				local active = buttons[selectedIdx]
				if active then
					active.TextColor3 = Creator.AutoContrast(pill.BackgroundColor3)
				end
			end)

			local function buildSegments()
				for _, btn in ipairs(buttons) do
					if btn and btn.Parent then
						btn:Destroy()
					end
				end
				table.clear(buttons)
				local n = math.max(1, #Segmented.Values)
				for i, val in ipairs(Segmented.Values) do
					local btn = New(
						"TextButton",
						{
							Name = "Seg_" .. tostring(i),
							Text = tostring(val),
							FontFace = Creator.Font(Enum.FontWeight.SemiBold),
							TextSize = 13,
							TextTruncate = Enum.TextTruncate.AtEnd,
							Size = UDim2.new(1 / n, 0, 1, 0),
							BackgroundTransparency = 1,
							LayoutOrder = i,
							ZIndex = 4,
							Parent = segButtonsHolder,
							ThemeTag = {TextColor3 = "SubText"}
						}
					)
					Creator.AddSignal(btn.MouseEnter, function()
						if i ~= selectedIdx then
							Creator.OverrideTag(btn, {TextColor3 = "Text"})
							btn.TextTransparency = 0
						end
					end)
					Creator.AddSignal(btn.MouseLeave, function()
						if i ~= selectedIdx then
							Creator.OverrideTag(btn, {TextColor3 = "SubText"})
							btn.TextTransparency = 0.04
						end
					end)
					Creator.AddSignal(btn.MouseButton1Click, function()
						Segmented:SetValue(val)
						Library._TouchElement(Segmented)
					end)
					table.insert(buttons, btn)
				end
			end

			function Segmented.SetValue(_self, val, silent)
				local foundIdx = nil
				for i, item in ipairs(Segmented.Values) do
					if item == val then
						foundIdx = i
						break
					end
				end
				if not foundIdx and type(val) == "number" and Segmented.Values[val] ~= nil then
					foundIdx = val
					val = Segmented.Values[val]
				end
				if not foundIdx then
					return
				end
				selectedIdx = foundIdx
				Segmented.Value = val
				refreshColors()
				updatePill(silent == true)
				if not silent then
					Library:SafeCallback(Segmented.Callback, val, foundIdx)
					Library:SafeCallback(Segmented.Changed, val, foundIdx)
				end
			end

			function Segmented.SetValues(_self, newValues)
				Segmented.Values = type(newValues) == "table" and newValues or {}
				buildSegments()
				selectedIdx = 1
				if Segmented.Values[1] ~= nil then
					Segmented:SetValue(Segmented.Values[1], true)
				end
				task.defer(function()
					updatePill(true)
				end)
			end

			function Segmented.OnChanged(_self, cb)
				Segmented.Changed = cb
				cb(Segmented.Value, selectedIdx)
			end

			function Segmented.Destroy(_self)
				card:Destroy()
				if idx ~= nil then
					Library.Options[idx] = nil
				end
			end

			Creator.AddSignal(trackFrame:GetPropertyChangedSignal("AbsoluteSize"), function()
				updatePill(true)
			end)
			Creator.RegisterDPIScale(trackFrame, function()
				task.defer(function()
					updatePill(true)
				end)
			end)

			buildSegments()
			Segmented:SetValue(defaultVal, true)
			task.defer(function()
				updatePill(true)
			end)
			if idx ~= nil then
				Library.Options[idx] = Segmented
			end
			return Segmented
		end
		return Element
	end,
	[79] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(79)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local New, Element = Creator.New, {}
		Element.__index = Element
		Element.__type = "StatGrid"

		local POS_GREEN = Color3.fromRGB(52, 211, 153)
		local NEG_RED = Color3.fromRGB(248, 113, 113)
		local MAX_SPARK_BARS = 14

		function Element.New(parent, idx, config)
			if type(idx) == "table" and config == nil then
				config = idx
				idx = nil
			end
			local Library = parent.Library
			config = type(config) == "table" and config or {}
			local stats = type(config.Stats) == "table" and config.Stats or {}
			local cols = math.clamp(tonumber(config.Columns) or math.min(math.max(#stats, 2), 4), 1, 4)
			local gap = tonumber(config.Gap) or 6
			local cardHeight = tonumber(config.CardHeight) or 78

			local StatGrid = {
				Type = "StatGrid",
				Cards = {}
			}

			local rows = math.max(1, math.ceil(#stats / cols))
			local totalH = rows * cardHeight + math.max(0, rows - 1) * gap

			StatGrid.Frame = New(
				"Frame",
				{
					Name = "AcryvenStatGrid",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, totalH),
					LayoutOrder = config.LayoutOrder or 7,
					Parent = parent.Container
				}
			)
			StatGrid.Root = StatGrid.Frame

			local function renderSparkline(cardData)
				local hist = cardData.History
				local bars = cardData.SparkBars
				if not bars or #bars == 0 then
					return
				end
				local count = #hist
				if count == 0 then
					for _, bar in ipairs(bars) do
						bar.Visible = false
					end
					return
				end
				local minV, maxV = math.huge, -math.huge
				for _, v in ipairs(hist) do
					if v < minV then minV = v end
					if v > maxV then maxV = v end
				end
				local span = maxV - minV
				local visibleBars = math.min(count, #bars)
				local offset = count - visibleBars
				for i = 1, #bars do
					local bar = bars[i]
					if i <= visibleBars then
						local val = hist[offset + i]
						local norm = span > 0.0001 and ((val - minV) / span) or 0.55
						local hScale = math.clamp(0.18 + norm * 0.82, 0.18, 1)
						bar.Visible = true
						bar.Size = UDim2.new(1 / visibleBars, -2, hScale, 0)
						bar.Position = UDim2.new((i - 1) / visibleBars, 1, 1 - hScale, 0)
						bar.BackgroundTransparency = (i == visibleBars) and 0.06 or (0.58 - (i / visibleBars) * 0.34)
					else
						bar.Visible = false
					end
				end
			end

			local function applyDelta(deltaLabel, delta)
				if delta == nil or delta == "" then
					deltaLabel.Visible = false
					return
				end
				local str = tostring(delta)
				deltaLabel.Text = str
				if str:sub(1, 1) == "+" then
					deltaLabel.TextColor3 = POS_GREEN
				elseif str:sub(1, 1) == "-" then
					deltaLabel.TextColor3 = NEG_RED
				else
					deltaLabel.TextColor3 = Creator.GetThemeProperty("SubText")
				end
				deltaLabel.Visible = true
			end

			for i, stat in ipairs(stats) do
				local rowIdx = math.floor((i - 1) / cols)
				local colIdx = (i - 1) % cols
				local wScale = 1 / cols
				local gapDeduction = gap * (cols - 1) / cols
				local xOff = math.floor(colIdx * (gap / cols) + 0.5)
				local yOff = rowIdx * (cardHeight + gap)
				local key = stat.Key or stat.Id or stat.Label or ("Stat" .. tostring(i))
				local customColor = typeof(stat.Color) == "Color3" and stat.Color or nil

				local iconAsset = nil
				if type(stat.Icon) == "string" and stat.Icon ~= "" then
					iconAsset = Library:GetIcon(stat.Icon) or (stat.Icon:match("^rbxassetid://") and stat.Icon) or nil
				end

				local labelLbl = New(
					"TextLabel",
					{
						Name = "StatLabel",
						Text = tostring(stat.Label or key),
						FontFace = Creator.Font(Enum.FontWeight.Medium),
						TextSize = 11,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Size = UDim2.new(1, iconAsset and -28 or -10, 0, 14),
						Position = UDim2.fromOffset(10, 9),
						BackgroundTransparency = 1,
						ThemeTag = {TextColor3 = "SubText"}
					}
				)

				local hasDelta = stat.Delta ~= nil and stat.Delta ~= ""
				local valueLbl = New(
					"TextLabel",
					{
						Name = "StatValue",
						Text = tostring(stat.Value or "0"),
						I18nSkip = true,
						FontFace = Creator.Font(Enum.FontWeight.SemiBold, Enum.FontStyle.Normal, "Display"),
						TextSize = 18,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Size = UDim2.new(1, hasDelta and -68 or -20, 0, 22),
						Position = UDim2.fromOffset(10, 26),
						BackgroundTransparency = 1,
						ThemeTag = {TextColor3 = "Text"}
					}
				)

				local deltaLbl = New(
					"TextLabel",
					{
						Name = "Delta",
						Text = "",
						I18nSkip = true,
						FontFace = Creator.Font(Enum.FontWeight.SemiBold),
						TextSize = 10,
						TextXAlignment = Enum.TextXAlignment.Right,
						Size = UDim2.fromOffset(56, 14),
						Position = UDim2.new(1, -10, 0, 31),
						AnchorPoint = Vector2.new(1, 0),
						BackgroundTransparency = 1,
						Visible = false
					}
				)
				applyDelta(deltaLbl, stat.Delta)

				local sparkFrame = New(
					"Frame",
					{
						Name = "Sparkline",
						Size = UDim2.new(1, -20, 0, 18),
						Position = UDim2.new(0, 10, 1, -25),
						BackgroundTransparency = 1
					}
				)
				local sparkBars = {}
				for b = 1, MAX_SPARK_BARS do
					local bar = New(
						"Frame",
						{
							Name = "B" .. tostring(b),
							Size = UDim2.fromScale(0, 0),
							BackgroundColor3 = customColor or Color3.fromRGB(99, 179, 255),
							Visible = false,
							Parent = sparkFrame,
							ThemeTag = (not customColor) and {BackgroundColor3 = "Accent"} or nil
						},
						{New("UICorner", {CornerRadius = UDim.new(0, 2)})}
					)
					table.insert(sparkBars, bar)
				end

				local cardChildren = {
					New("UICorner", {CornerRadius = UDim.new(0, Creator.Radius.Card)}),
					New("UIStroke", {Transparency = 0.36, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "ElementBorder"}}),
					labelLbl,
					valueLbl,
					deltaLbl,
					sparkFrame
				}
				if iconAsset then
					table.insert(
						cardChildren,
						New("ImageLabel", {
							Name = "Icon",
							Image = iconAsset,
							Size = UDim2.fromOffset(15, 15),
							Position = UDim2.new(1, -10, 0, 9),
							AnchorPoint = Vector2.new(1, 0),
							BackgroundTransparency = 1,
							ImageTransparency = 0.02,
							ImageColor3 = customColor or Color3.fromRGB(99, 179, 255),
							ThemeTag = (not customColor) and {ImageColor3 = "Accent"} or nil
						})
					)
				end

				local cardFrame = New(
					"Frame",
					{
						Name = "StatCard_" .. tostring(key),
						Position = UDim2.new(colIdx * wScale, xOff, 0, yOff),
						Size = UDim2.new(wScale, -math.floor(gapDeduction + 0.5), 0, cardHeight),
						Parent = StatGrid.Frame,
						ThemeTag = {BackgroundColor3 = "Element", BackgroundTransparency = "ElementTransparency"}
					},
					cardChildren
				)

				local history = {}
				if type(stat.History) == "table" then
					for _, v in ipairs(stat.History) do
						local n = tonumber(v)
						if n then
							table.insert(history, n)
						end
					end
				end

				local cardData = {
					Key = key,
					Frame = cardFrame,
					Label = labelLbl,
					ValueLabel = valueLbl,
					DeltaLabel = deltaLbl,
					SparkBars = sparkBars,
					History = history
				}
				renderSparkline(cardData)
				StatGrid.Cards[key] = cardData
			end

			function StatGrid.SetStat(_self, key, value, delta, pushSparkValue)
				local cardData = StatGrid.Cards[key]
				if not cardData then
					return
				end
				if value ~= nil then
					cardData.ValueLabel.Text = tostring(value)
				end
				if delta ~= nil then
					applyDelta(cardData.DeltaLabel, delta)
				end
				if type(pushSparkValue) == "number" then
					table.insert(cardData.History, pushSparkValue)
					while #cardData.History > MAX_SPARK_BARS do
						table.remove(cardData.History, 1)
					end
					renderSparkline(cardData)
				end
			end

			function StatGrid.Destroy(_self)
				StatGrid.Frame:Destroy()
				if idx ~= nil then
					Library.Options[idx] = nil
				end
			end

			if idx ~= nil then
				Library.Options[idx] = StatGrid
			end
			return StatGrid
		end
		return Element
	end,
	[80] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(80)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local New, Components, Element = Creator.New, Root.Components, {}
		Element.__index = Element
		Element.__type = "Stepper"

		function Element.New(parent, idx, config)
			if type(idx) == "table" and config == nil then
				config = idx
				idx = nil
			end
			local Library = parent.Library
			assert(config and config.Title, "Stepper - Missing Title.")
			local minVal = tonumber(config.Min) or 0
			local maxVal = tonumber(config.Max) or 100
			local step = tonumber(config.Step) or 1
			local rounding = tonumber(config.Rounding) or 0
			local defaultVal = tonumber(config.Default) or minVal

			local Stepper = {
				Value = defaultVal,
				Default = defaultVal,
				Min = minVal,
				Max = maxVal,
				Step = step,
				Rounding = rounding,
				Prefix = type(config.Prefix) == "string" and config.Prefix or "",
				Suffix = type(config.Suffix) == "string" and config.Suffix or "",
				Callback = config.Callback or function() end,
				Type = "Stepper"
			}

			local card = requireModule(Components.Element)(config.Title, config.Description, parent.Container, false)
			card.TitleLabel.Size = UDim2.new(1, -120, 0, 14)
			card.DescLabel.Size = UDim2.new(1, -120, 0, 14)
			Stepper.SetTitle = card.SetTitle
			Stepper.SetDesc = card.SetDesc
			Stepper.SetBadge = card.SetBadge
			Stepper.Frame = card.Frame

			local function makeStepBtn(name, iconName, order)
				local img = New(
					"ImageLabel",
					{
						Name = "Icon",
						Image = Library:GetIcon(iconName) or "",
						Size = UDim2.fromOffset(13, 13),
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						ThemeTag = {ImageColor3 = "Text"}
					}
				)
				local btn = New(
					"TextButton",
					{
						Name = name,
						Text = "",
						Size = UDim2.fromOffset(26, 26),
						BackgroundTransparency = 0.24,
						AutoButtonColor = false,
						LayoutOrder = order,
						ThemeTag = {BackgroundColor3 = "DialogButton"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 6)}),
						New("UIStroke", {Transparency = 0.38, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "InElementBorder"}}),
						img
					}
				)
				Creator.AddSignal(btn.MouseEnter, function()
					Creator.SpringValue(btn, "BackgroundTransparency", 0.08, 10, 1)
				end)
				Creator.AddSignal(btn.MouseLeave, function()
					Creator.SpringValue(btn, "BackgroundTransparency", 0.24, 10, 1)
				end)
				return btn, img
			end

			local minusBtn, minusIcon = makeStepBtn("Minus", "minus", 1)
			local plusBtn, plusIcon = makeStepBtn("Plus", "plus", 3)

			local valueBox = New(
				"TextBox",
				{
					Name = "Value",
					FontFace = Creator.Font(Enum.FontWeight.SemiBold),
					Text = tostring(defaultVal),
					I18nSkip = true,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Center,
					ClearTextOnFocus = false,
					Size = UDim2.fromOffset(42, 26),
					BackgroundTransparency = 0.24,
					LayoutOrder = 2,
					ThemeTag = {BackgroundColor3 = "DialogHolder", TextColor3 = "Text"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(0, 6)}),
					New("UIStroke", {Transparency = 0.38, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "InElementBorder"}})
				}
			)

			New(
				"Frame",
				{
					Name = "StepperControl",
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -12, 0.5, 0),
					Size = UDim2.fromOffset(102, 26),
					BackgroundTransparency = 1,
					Parent = card.Frame
				},
				{
					New("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 4)
					}),
					minusBtn,
					valueBox,
					plusBtn
				}
			)

			local function formatVal(v)
				return Stepper.Prefix .. tostring(v) .. Stepper.Suffix
			end

			function Stepper.SetValue(_self, val, silent)
				local num = tonumber(val)
				if not num then
					valueBox.Text = formatVal(Stepper.Value)
					return
				end
				num = Library:Round(math.clamp(num, Stepper.Min, Stepper.Max), Stepper.Rounding)
				Stepper.Value = num
				valueBox.Text = formatVal(num)
				minusIcon.ImageTransparency = (num <= Stepper.Min) and 0.68 or 0.05
				plusIcon.ImageTransparency = (num >= Stepper.Max) and 0.68 or 0.05
				if not silent then
					Library:SafeCallback(Stepper.Callback, num)
					Library:SafeCallback(Stepper.Changed, num)
				end
			end

			function Stepper.OnChanged(_self, cb)
				Stepper.Changed = cb
				cb(Stepper.Value)
			end

			function Stepper.Destroy(_self)
				card:Destroy()
				if idx ~= nil then
					Library.Options[idx] = nil
				end
			end

			Creator.AddSignal(minusBtn.MouseButton1Click, function()
				Stepper:SetValue(Stepper.Value - Stepper.Step)
				Library._TouchElement(Stepper)
			end)
			Creator.AddSignal(plusBtn.MouseButton1Click, function()
				Stepper:SetValue(Stepper.Value + Stepper.Step)
				Library._TouchElement(Stepper)
			end)
			Creator.AddSignal(valueBox.Focused, function()
				valueBox.Text = tostring(Stepper.Value)
			end)
			Creator.AddSignal(valueBox.FocusLost, function()
				local parsed = tonumber(tostring(valueBox.Text):gsub(",", "."):match("[-+]?%d*%.?%d+"))
				if parsed then
					Stepper:SetValue(parsed)
					Library._TouchElement(Stepper)
				else
					valueBox.Text = formatVal(Stepper.Value)
				end
			end)

			Stepper:SetValue(defaultVal, true)
			if idx ~= nil then
				Library.Options[idx] = Stepper
			end
			return Stepper
		end
		return Element
	end,
	[81] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(81)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local New, Components, Element = Creator.New, Root.Components, {}
		Element.__index = Element
		Element.__type = "TagInput"

		local function trim(s)
			return tostring(s or ""):match("^%s*(.-)%s*$") or ""
		end

		function Element.New(parent, idx, config)
			if type(idx) == "table" and config == nil then
				config = idx
				idx = nil
			end
			local Library = parent.Library
			assert(config and config.Title, "TagInput - Missing Title.")

			local TagInput = {
				Value = {},
				Default = {},
				MaxTags = tonumber(config.MaxTags) or 24,
				AllowDuplicates = config.AllowDuplicates == true,
				Callback = config.Callback or function() end,
				Type = "TagInput"
			}

			local card = requireModule(Components.Element)(config.Title, config.Description, parent.Container, false)
			TagInput.SetTitle = card.SetTitle
			TagInput.SetDesc = card.SetDesc
			TagInput.SetBadge = card.SetBadge
			TagInput.Frame = card.Frame

			-- Convert LabelHolder's vertical stack to also hold the TagInput body cleanly so AutomaticSize.Y flows naturally
			local bodyHolder = New(
				"Frame",
				{
					Name = "TagBody",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					LayoutOrder = 4,
					Parent = card.LabelHolder
				},
				{
					New("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}),
					New("UIPadding", {PaddingTop = UDim.new(0, 6)})
				}
			)
			card.LabelHolder.Size = UDim2.new(1, -24, 0, 0)

			-- Chips container with wrapping UIListLayout
			local chipsLayout = New("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 5)
			})
			pcall(function()
				chipsLayout.Wraps = true
			end)

			local chipsWrap = New(
				"Frame",
				{
					Name = "Chips",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					LayoutOrder = 1,
					Visible = false,
					Parent = bodyHolder
				},
				{
					chipsLayout,
					New(
						"UIPadding",
						{
							PaddingTop = UDim.new(0, 2),
							PaddingBottom = UDim.new(0, 2),
							PaddingLeft = UDim.new(0, 2),
							PaddingRight = UDim.new(0, 2)
						}
					)
				}
			)

			-- Input row (TextBox + Add button)
			local inputStroke = New(
				"UIStroke",
				{
					Transparency = 0.38,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					ThemeTag = {Color = "InElementBorder"}
				}
			)
			local textBox = New(
				"TextBox",
				{
					Name = "TagTextBox",
					Size = UDim2.new(1, -34, 0, 28),
					BackgroundTransparency = 0.24,
					Text = "",
					PlaceholderText = config.Placeholder or "Type tag & press Enter...",
					I18nSkip = true,
					FontFace = Creator.Font(Enum.FontWeight.Regular),
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
					ClearTextOnFocus = false,
					ThemeTag = {BackgroundColor3 = "DialogHolder", TextColor3 = "Text", PlaceholderColor3 = "SubText"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(0, 7)}),
					New("UIPadding", {PaddingLeft = UDim.new(0, 9), PaddingRight = UDim.new(0, 9)}),
					inputStroke
				}
			)
			local addBtnScale = New("UIScale", {Scale = 1})
			local addBtn = New(
				"TextButton",
				{
					Name = "AddTagBtn",
					Text = "",
					Size = UDim2.fromOffset(28, 28),
					Position = UDim2.new(1, -28, 0, 0),
					BackgroundTransparency = 0.14,
					AutoButtonColor = false,
					ThemeTag = {BackgroundColor3 = "Accent"}
				},
				{
					addBtnScale,
					New("UICorner", {CornerRadius = UDim.new(0, 7)}),
					New("ImageLabel", {
						Name = "PlusIcon",
						Image = Library:GetIcon("plus") or "rbxassetid://10734924532",
						Size = UDim2.fromOffset(14, 14),
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						ImageColor3 = Creator.AutoContrast(Creator.GetThemeProperty("Accent"))
					})
				}
			)
			local plusIcon = addBtn:FindFirstChild("PlusIcon")
			Creator.AddSignal(addBtn:GetPropertyChangedSignal("BackgroundColor3"), function()
				if plusIcon then
					plusIcon.ImageColor3 = Creator.AutoContrast(addBtn.BackgroundColor3)
				end
			end)

			local inputRow = New(
				"Frame",
				{
					Name = "InputRow",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 28),
					LayoutOrder = 2,
					Parent = bodyHolder
				},
				{textBox, addBtn}
			)

			Creator.AddSignal(textBox.Focused, function()
				Creator.OverrideTag(inputStroke, {Color = "Accent"})
				Creator.SpringValue(inputStroke, "Transparency", 0.14, 10, 1)
			end)
			Creator.AddSignal(textBox.FocusLost, function(enterPressed)
				Creator.OverrideTag(inputStroke, {Color = "InElementBorder"})
				Creator.SpringValue(inputStroke, "Transparency", 0.38, 10, 1)
				if enterPressed then
					local candidate = trim(textBox.Text)
					if candidate ~= "" then
						TagInput:AddTag(candidate)
						textBox.Text = ""
						Library._TouchElement(TagInput)
					end
				end
			end)

			Creator.AddSignal(addBtn.MouseEnter, function()
				Creator.SpringValue(addBtn, "BackgroundTransparency", 0.02, 5.2, 1)
			end)
			Creator.AddSignal(addBtn.MouseLeave, function()
				Creator.SpringValue(addBtn, "BackgroundTransparency", 0.14, 5.2, 1)
				Creator.SpringValue(addBtnScale, "Scale", 1, 5.5, 0.85)
			end)
			Creator.AddSignal(addBtn.MouseButton1Down, function()
				Creator.SpringValue(addBtnScale, "Scale", 0.92, 6.5, 0.9)
			end)
			Creator.AddSignal(addBtn.MouseButton1Up, function()
				Creator.SpringValue(addBtnScale, "Scale", 1, 5.0, 0.72)
			end)

			local chipEntries = {}
			local function fireChanged(silent)
				if not silent then
					local copy = {}
					for i, v in ipairs(TagInput.Value) do
						copy[i] = v
					end
					Library:SafeCallback(TagInput.Callback, copy)
					Library:SafeCallback(TagInput.Changed, copy)
				end
			end

			local function syncChipsWrapVisibility()
				chipsWrap.Visible = (#TagInput.Value > 0 or #chipEntries > 0)
			end

			local function createChip(tag, order, animate)
				local removeIcon = New(
					"ImageLabel",
					{
						Image = Library:GetIcon("x") or "rbxassetid://10747384394",
						Size = UDim2.fromOffset(10, 10),
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						ImageTransparency = 0.08,
						ThemeTag = {ImageColor3 = "SubText"}
					}
				)
				local removeBtn = New(
					"TextButton",
					{
						Name = "Remove",
						Text = "",
						Size = UDim2.fromOffset(16, 16),
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						AutoButtonColor = false
					},
					{
						New("UICorner", {CornerRadius = UDim.new(1, 0)}),
						removeIcon
					}
				)
				local chipScale = New("UIScale", {Scale = (animate and not Creator.ReducedMotion) and 0.55 or 1})
				local chipStroke = New("UIStroke", {
					Transparency = (animate and not Creator.ReducedMotion) and 1 or 0.32,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					ThemeTag = {Color = "Accent"}
				})
				local chipText = New("TextLabel", {
					Name = "Text",
					Text = tag,
					I18nSkip = true,
					FontFace = Creator.Font(Enum.FontWeight.Medium),
					TextSize = 11,
					TextTransparency = (animate and not Creator.ReducedMotion) and 1 or 0,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					ThemeTag = {TextColor3 = "Text"}
				})
				local chip = New(
					"Frame",
					{
						Name = "TagChip",
						AutomaticSize = Enum.AutomaticSize.X,
						Size = UDim2.fromOffset(0, 22),
						BackgroundTransparency = (animate and not Creator.ReducedMotion) and 1 or 0.72,
						LayoutOrder = order,
						Parent = chipsWrap,
						ThemeTag = {BackgroundColor3 = "Accent"}
					},
					{
						chipScale,
						New("UICorner", {CornerRadius = UDim.new(1, 0)}),
						chipStroke,
						New("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 5)}),
						New("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 3)
						}),
						chipText,
						removeBtn
					}
				)
				Creator.AddSignal(removeBtn.MouseEnter, function()
					Creator.SpringValue(removeIcon, "ImageTransparency", 0, 5.5, 1)
					Creator.OverrideTag(removeIcon, {ImageColor3 = "Text"})
					Creator.SpringValue(chipStroke, "Transparency", 0.14, 5.5, 1)
				end)
				Creator.AddSignal(removeBtn.MouseLeave, function()
					Creator.SpringValue(removeIcon, "ImageTransparency", 0.08, 5.5, 1)
					Creator.OverrideTag(removeIcon, {ImageColor3 = "SubText"})
					Creator.SpringValue(chipStroke, "Transparency", 0.32, 5.5, 1)
				end)
				Creator.AddSignal(removeBtn.MouseButton1Down, function()
					Creator.SpringValue(chipScale, "Scale", 0.92, 6.5, 0.85)
				end)
				Creator.AddSignal(removeBtn.MouseButton1Click, function()
					TagInput:RemoveTag(tag)
					Library._TouchElement(TagInput)
				end)
				if animate and not Creator.ReducedMotion then
					-- Luaward silky spring (~240ms visible pop-in)
					Creator.SpringValue(chipScale, "Scale", 1, 4.2, 0.66)
					Creator.SpringValue(chip, "BackgroundTransparency", 0.72, 4.8, 1)
					Creator.SpringValue(chipStroke, "Transparency", 0.32, 4.8, 1)
					Creator.SpringValue(chipText, "TextTransparency", 0, 4.8, 1)
				end
				return {Tag = tag, Frame = chip, Scale = chipScale, Stroke = chipStroke, Text = chipText, RemoveIcon = removeIcon}
			end

			local function rebuildChips(animate)
				for _, ch in ipairs(chipEntries) do
					if ch.Frame and ch.Frame.Parent then
						ch.Frame:Destroy()
					end
				end
				table.clear(chipEntries)
				for order, tag in ipairs(TagInput.Value) do
					table.insert(chipEntries, createChip(tag, order, animate))
				end
				syncChipsWrapVisibility()
			end

			-- Optional quick-add Suggestions row
			if type(config.Suggestions) == "table" and #config.Suggestions > 0 then
				local sugLayout = New("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4)
				})
				pcall(function()
					sugLayout.Wraps = true
				end)
				local sugRow = New(
					"Frame",
					{
						Name = "Suggestions",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						LayoutOrder = 3,
						Parent = bodyHolder
					},
					{
						sugLayout,
						New(
							"UIPadding",
							{
								PaddingTop = UDim.new(0, 2),
								PaddingBottom = UDim.new(0, 2),
								PaddingLeft = UDim.new(0, 2),
								PaddingRight = UDim.new(0, 2)
							}
						)
					}
				)
				for i, sug in ipairs(config.Suggestions) do
					local sugStr = trim(sug)
					if sugStr ~= "" then
						local sugStroke = New("UIStroke", {Transparency = 0.38, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "InElementBorder"}})
						local btn = New(
							"TextButton",
							{
								Name = "Sug_" .. tostring(i),
								Text = "+ " .. sugStr,
								I18nSkip = true,
								FontFace = Creator.Font(Enum.FontWeight.Medium),
								TextSize = 11,
								AutomaticSize = Enum.AutomaticSize.X,
								Size = UDim2.fromOffset(0, 22),
								BackgroundTransparency = 0.24,
								LayoutOrder = i,
								Parent = sugRow,
								ThemeTag = {BackgroundColor3 = "DialogButton", TextColor3 = "SubText"}
							},
							{
								New("UICorner", {CornerRadius = UDim.new(1, 0)}),
								New("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}),
								sugStroke
							}
						)
						Creator.AddSignal(btn.MouseEnter, function()
							Creator.SpringValue(btn, "BackgroundTransparency", 0.08, 12, 1)
							Creator.OverrideTag(sugStroke, {Color = "Accent"})
							Creator.OverrideTag(btn, {BackgroundColor3 = "DialogButton", TextColor3 = "Text"})
						end)
						Creator.AddSignal(btn.MouseLeave, function()
							Creator.SpringValue(btn, "BackgroundTransparency", 0.24, 12, 1)
							Creator.OverrideTag(sugStroke, {Color = "InElementBorder"})
							Creator.OverrideTag(btn, {BackgroundColor3 = "DialogButton", TextColor3 = "SubText"})
						end)
						Creator.AddSignal(btn.MouseButton1Click, function()
							TagInput:AddTag(sugStr)
							Library._TouchElement(TagInput)
						end)
					end
				end
			end

			function TagInput.AddTag(_self, tag, silent)
				tag = trim(tag)
				if tag == "" or #TagInput.Value >= TagInput.MaxTags then
					return false
				end
				if not TagInput.AllowDuplicates then
					for _, existing in ipairs(TagInput.Value) do
						if existing:lower() == tag:lower() then
							return false
						end
					end
				end
				table.insert(TagInput.Value, tag)
				chipsWrap.Visible = true
				table.insert(chipEntries, createChip(tag, #TagInput.Value, not silent))
				fireChanged(silent)
				return true
			end

			function TagInput.RemoveTag(_self, tag, silent)
				for i, existing in ipairs(TagInput.Value) do
					if existing == tag then
						table.remove(TagInput.Value, i)
						local targetIdx = nil
						for ci, entry in ipairs(chipEntries) do
							if entry.Tag == tag then
								targetIdx = ci
								break
							end
						end
						if targetIdx then
							local entry = table.remove(chipEntries, targetIdx)
							if silent or Creator.ReducedMotion then
								if entry.Frame and entry.Frame.Parent then
									entry.Frame:Destroy()
								end
								syncChipsWrapVisibility()
							else
								Creator.SpringValue(entry.Scale, "Scale", 0.42, 5.2, 1)
								Creator.SpringValue(entry.Frame, "BackgroundTransparency", 1, 5.2, 1)
								Creator.SpringValue(entry.Stroke, "Transparency", 1, 5.2, 1)
								Creator.SpringValue(entry.Text, "TextTransparency", 1, 5.2, 1)
								Creator.SpringValue(entry.RemoveIcon, "ImageTransparency", 1, 5.2, 1)
								task.delay(0.20, function()
									if entry.Frame and entry.Frame.Parent then
										entry.Frame:Destroy()
									end
									syncChipsWrapVisibility()
								end)
							end
						else
							rebuildChips(false)
						end
						for idxOrder, rem in ipairs(chipEntries) do
							if rem.Frame then
								rem.Frame.LayoutOrder = idxOrder
							end
						end
						fireChanged(silent)
						return true
					end
				end
				return false
			end

			function TagInput.GetTags(_self)
				local copy = {}
				for i, v in ipairs(TagInput.Value) do
					copy[i] = v
				end
				return copy
			end

			function TagInput.SetValue(_self, list, silent)
				table.clear(TagInput.Value)
				if type(list) == "table" then
					for _, v in ipairs(list) do
						local s = trim(v)
						if s ~= "" and #TagInput.Value < TagInput.MaxTags then
							table.insert(TagInput.Value, s)
						end
					end
				end
				rebuildChips(not silent)
				fireChanged(silent)
			end

			function TagInput.OnChanged(_self, cb)
				TagInput.Changed = cb
				cb(TagInput:GetTags())
			end

			function TagInput.Destroy(_self)
				card:Destroy()
				if idx ~= nil then
					Library.Options[idx] = nil
				end
			end

			Creator.AddSignal(addBtn.MouseButton1Click, function()
				local candidate = trim(textBox.Text)
				if candidate ~= "" then
					TagInput:AddTag(candidate)
					textBox.Text = ""
					Library._TouchElement(TagInput)
				end
			end)

			if type(config.Default) == "table" then
				for _, v in ipairs(config.Default) do
					table.insert(TagInput.Default, trim(v))
				end
				TagInput:SetValue(TagInput.Default, true)
			end
			if idx ~= nil then
				Library.Options[idx] = TagInput
			end
			return TagInput
		end
		return Element
	end,
	[82] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(82)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local UserInputService = Creator.GetService("UserInputService")
		local Lighting = Creator.GetService("Lighting")
		local New = Creator.New

		local protectGui = protectgui or (syn and syn.protect_gui) or function()
		end

		return function(Library)
			local Palette = {
				Opened = false,
				CustomCommands = {}
			}

			local built = false
			local spotlightGui, spotlightBlur, rootOverlay, backdrop, noiseScrim
			local modalHost, modalCanvas, modalScale, modalShadow, modalStroke
			local searchBox, resultsScroll, resultsRows, resultsLayout, emptyLabel
			local selectionPill
			local openConnections = {}
			local transitionId = 0
			local animScale = 1
			local selY = 0
			local currentItems = {}
			local rowFrames = {}
			local selectedIdx = 1

			local function disconnectOpen()
				for i = #openConnections, 1, -1 do
					pcall(function()
						openConnections[i]:Disconnect()
					end)
					openConnections[i] = nil
				end
			end

			local function syncScale()
				if modalScale then
					modalScale.Scale = Creator.DPIScale * animScale
				end
			end

			local function fadeStrokes(toHidden, instant)
				if not modalCanvas then
					return
				end
				for _, desc in ipairs(modalCanvas:GetDescendants()) do
					if desc:IsA("UIStroke") then
						local rest = desc:GetAttribute("AcryvenPalStroke")
						if rest == nil then
							rest = (desc == modalStroke) and 0.26 or desc.Transparency
							desc:SetAttribute("AcryvenPalStroke", rest)
						end
						local target = toHidden and 1 or rest
						if instant then
							Creator.CancelSpring(desc, "Transparency")
							desc.Transparency = target
						else
							Creator.SpringValue(desc, "Transparency", target, toHidden and 13 or 10, 1)
						end
					end
				end
			end

			local function collectItems(query)
				query = tostring(query or ""):gsub("^%s+", ""):gsub("%s+$", ""):lower()
				local items = {}

				local function matches(title, subtitle, category)
					if query == "" then
						return true
					end
					local hay = (tostring(title or "") .. " " .. tostring(subtitle or "") .. " " .. tostring(category or "")):lower()
					return hay:find(query, 1, true) ~= nil
				end

				for _, cmd in ipairs(Palette.CustomCommands) do
					if matches(cmd.Title, cmd.Subtitle, cmd.Category or "Command") then
						table.insert(items, {
							Title = tostring(cmd.Title or "Command"),
							Subtitle = tostring(cmd.Subtitle or ""),
							Category = tostring(cmd.Category or "Command"),
							Icon = cmd.Icon or "command",
							Run = function()
								Library:SafeCallback(cmd.Callback)
							end
						})
					end
				end

				if Library.Workspace and type(Library.Workspace.Tabs) == "table" then
					for _, tab in ipairs(Library.Workspace.Tabs) do
						local title = tostring(tab.Name or "Tab")
						if matches(title, "Jump to tab", "Tab") then
							table.insert(items, {
								Title = title,
								Subtitle = "Switch tab",
								Category = "Tab",
								Icon = "layers",
								Run = function()
									if type(tab.Select) == "function" then
										tab:Select()
									end
								end
							})
						end
					end
				end

				if Library.Workspace and type(Library.Workspace.Entries) == "table" then
					for _, entry in ipairs(Library.Workspace.Entries) do
						if type(entry) == "table" then
							local obj = entry.Object
							local title = tostring(entry.Title or "Control")
							local tabName = tostring(entry.TabTitle or "")
							local kind = tostring(entry.Type or "Control")
							local subtitle = tabName ~= "" and (tabName .. " / " .. kind) or kind
							if obj and obj.Type == "Toggle" then
								subtitle = (tabName ~= "" and (tabName .. " / ") or "") .. (obj.Value and "ON - Press Enter to turn off" or "OFF - Press Enter to turn on")
							end
							if matches(title, subtitle, kind) then
								table.insert(items, {
									Title = title,
									Subtitle = subtitle,
									Category = kind,
									Icon = (kind == "Toggle" and "sliders-horizontal") or (kind == "Button" and "arrow-right") or "sliders",
									Run = function()
										if obj and obj.Type == "Toggle" and type(obj.SetValue) == "function" then
											obj:SetValue(not obj.Value)
											Library._TouchElement(obj)
										end
										if Library.Workspace and type(Library.Workspace.Navigate) == "function" then
											Library.Workspace:Navigate(entry)
										end
									end
								})
							end
						end
					end
				end

				local builtins = {
					{
						Title = "Toggle Sidebar",
						Subtitle = "Collapse or expand navigation rail (Ctrl+B)",
						Category = "Action",
						Icon = "sidebar-close",
						Run = function()
							if Library.Window and type(Library.Window.ToggleSidebar) == "function" then
								Library.Window:ToggleSidebar()
							end
						end
					},
					{
						Title = "Toggle Acrylic Glass",
						Subtitle = Library.Acrylic and "Currently Enabled" or "Currently Disabled",
						Category = "Action",
						Icon = "wand-2",
						Run = function()
							Library:ToggleAcrylic(not Library.Acrylic)
						end
					},
					{
						Title = "Minimize Window",
						Subtitle = "Hide window smoothly",
						Category = "Action",
						Icon = "minimize-2",
						Run = function()
							if Library.Window and type(Library.Window.Minimize) == "function" then
								Library.Window:Minimize()
							end
						end
					}
				}
				for _, b in ipairs(builtins) do
					if matches(b.Title, b.Subtitle, b.Category) then
						table.insert(items, b)
					end
				end

				for _, themeName in ipairs(Library.Themes or {}) do
					local tTitle = "Theme: " .. tostring(themeName)
					local sub = (Library.Theme == themeName) and "Current active theme" or "Switch UI theme with Oklab transition"
					if matches(tTitle, sub, "Theme") then
						table.insert(items, {
							Title = tTitle,
							Subtitle = sub,
							Category = "Theme",
							Icon = "palette",
							Run = function()
								Library:SetTheme(themeName)
							end
						})
					end
				end

				if #items > 28 then
					local trimmed = {}
					for i = 1, 28 do
						trimmed[i] = items[i]
					end
					return trimmed
				end
				return items
			end

			local function updateSelectionVisual(instant)
				if #currentItems == 0 or not selectionPill then
					if selectionPill then
						selectionPill.Visible = false
					end
					return
				end
				selectionPill.Visible = true
				local targetY = (selectedIdx - 1) * 44
				if instant or Creator.ReducedMotion then
					Creator.CancelSpring(selectionPill, "SelY")
					selY = targetY
					selectionPill.Position = UDim2.fromOffset(0, targetY)
				else
					Creator.SpringValue(selectionPill, "SelY", targetY, 12, 0.86, function(y)
						selY = y
						selectionPill.Position = UDim2.fromOffset(0, y)
					end, selY)
				end

				for i, info in ipairs(rowFrames) do
					local active = (i == selectedIdx)
					if info.Icon then
						info.Icon.ImageTransparency = active and 0 or 0.04
					end
					if info.Title then
						info.Title.TextTransparency = active and 0 or 0.02
					end
				end

				if resultsScroll and rowFrames[selectedIdx] then
					local itemTop = (selectedIdx - 1) * 44
					local itemBot = itemTop + 40
					local scale = Creator.GetEffectiveScale(resultsScroll)
					local viewH = resultsScroll.AbsoluteSize.Y / scale
					local curY = resultsScroll.CanvasPosition.Y
					if itemTop < curY then
						resultsScroll.CanvasPosition = Vector2.new(0, itemTop)
					elseif itemBot > curY + viewH then
						resultsScroll.CanvasPosition = Vector2.new(0, math.max(0, itemBot - viewH))
					end
				end
			end

			local function executeSelected()
				local chosen = currentItems[selectedIdx]
				Palette:Close()
				if chosen and type(chosen.Run) == "function" then
					task.defer(chosen.Run)
				end
			end

			local function renderResults(query)
				for _, info in ipairs(rowFrames) do
					if info.Row and info.Row.Parent then
						info.Row:Destroy()
					end
				end
				table.clear(rowFrames)
				currentItems = collectItems(query)
				selectedIdx = 1
				emptyLabel.Visible = (#currentItems == 0)

				for i, item in ipairs(currentItems) do
					local iconAsset = Library:GetIcon(item.Icon or "command") or Library:GetIcon("search") or ""
					local iconImg = New("ImageLabel", {
						Name = "Icon",
						Image = iconAsset,
						Size = UDim2.fromOffset(14, 14),
						Position = UDim2.new(0, 12, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						ImageTransparency = 0.04,
						ZIndex = 125,
						ThemeTag = {ImageColor3 = "Accent"}
					})
					local titleLbl = New("TextLabel", {
						Name = "Title",
						Text = item.Title,
						I18nSkip = true,
						FontFace = Creator.Font(Enum.FontWeight.Medium),
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Position = UDim2.fromOffset(34, 4),
						Size = UDim2.new(1, -112, 0, 16),
						BackgroundTransparency = 1,
						TextTransparency = 0.02,
						ZIndex = 125,
						ThemeTag = {TextColor3 = "Text"}
					})
					local row = New(
						"TextButton",
						{
							Name = "CmdRow_" .. tostring(i),
							Text = "",
							AutoButtonColor = false,
							Size = UDim2.new(1, -6, 0, 40),
							BackgroundTransparency = 1,
							LayoutOrder = i,
							ZIndex = 124,
							Parent = resultsRows
						},
						{
							iconImg,
							titleLbl,
							New("TextLabel", {
								Name = "Subtitle",
								Text = item.Subtitle,
								I18nSkip = true,
								FontFace = Creator.Font(Enum.FontWeight.Regular),
								TextSize = 10,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextTruncate = Enum.TextTruncate.AtEnd,
								Position = UDim2.fromOffset(34, 20),
								Size = UDim2.new(1, -112, 0, 14),
								BackgroundTransparency = 1,
								ZIndex = 125,
								ThemeTag = {TextColor3 = "SubText"}
							}),
							New("Frame", {
								Name = "CatPill",
								AnchorPoint = Vector2.new(1, 0.5),
								Position = UDim2.new(1, -10, 0.5, 0),
								AutomaticSize = Enum.AutomaticSize.X,
								Size = UDim2.fromOffset(0, 18),
								BackgroundTransparency = 0.45,
								ZIndex = 125,
								ThemeTag = {BackgroundColor3 = "DialogButton"}
							}, {
								New("UICorner", {CornerRadius = UDim.new(0, 5)}),
								New("UIStroke", {Transparency = 0.48, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "InElementBorder"}}),
								New("UIPadding", {PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}),
								New("TextLabel", {
									Text = item.Category,
									I18nSkip = true,
									FontFace = Creator.Font(Enum.FontWeight.SemiBold),
									TextSize = 9,
									AutomaticSize = Enum.AutomaticSize.X,
									Size = UDim2.new(0, 0, 1, 0),
									BackgroundTransparency = 1,
									ZIndex = 126,
									ThemeTag = {TextColor3 = "SubText"}
								})
							})
						}
					)
					Creator.AddSignal(row.MouseEnter, function()
						selectedIdx = i
						updateSelectionVisual(false)
					end)
					Creator.AddSignal(row.MouseButton1Click, function()
						selectedIdx = i
						executeSelected()
					end)
					table.insert(rowFrames, {Row = row, Icon = iconImg, Title = titleLbl})
				end

				local totalH = #currentItems * 44 + 6
				resultsScroll.CanvasSize = UDim2.new(0, 0, 0, totalH)
				resultsScroll.CanvasPosition = Vector2.new(0, 0)
				updateSelectionVisual(true)
			end

			local function ensureBuilt()
				if built then
					return
				end
				built = true

				-- Purge any orphaned Spotlight blur/ScreenGui from an earlier session
				for _, child in ipairs(Lighting:GetChildren()) do
					if child.Name == "AcryvenSpotlightBlur" then
						pcall(function() child:Destroy() end)
					end
				end
				local guiParent = (Library.GUI and Library.GUI.Parent) or Creator.GetService("CoreGui")
				for _, child in ipairs(guiParent:GetChildren()) do
					if child.Name == "AcryvenSpotlightGui" then
						pcall(function() child:Destroy() end)
					end
				end

				spotlightBlur = Instance.new("BlurEffect")
				spotlightBlur.Name = "AcryvenSpotlightBlur"
				spotlightBlur.Size = 0
				spotlightBlur.Enabled = false
				spotlightBlur.Parent = Lighting

				spotlightGui = New("ScreenGui", {
					Name = "AcryvenSpotlightGui",
					IgnoreGuiInset = true,
					ResetOnSpawn = false,
					DisplayOrder = 50,
					Enabled = false,
					ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
					Parent = guiParent
				})
				pcall(function()
					spotlightGui.ScreenInsets = Enum.ScreenInsets.None
				end)
				protectGui(spotlightGui)

				noiseScrim = New("ImageLabel", {
					Name = "FrostedNoise",
					Image = "rbxassetid://9968344105",
					ImageTransparency = 1,
					ScaleType = Enum.ScaleType.Tile,
					TileSize = UDim2.fromOffset(128, 128),
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					ZIndex = 120
				})

				backdrop = New(
					"TextButton",
					{
						Name = "Backdrop",
						Text = "",
						AutoButtonColor = false,
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						ZIndex = 120,
						ThemeTag = {BackgroundColor3 = "AcrylicMain"}
					},
					{noiseScrim}
				)
				Creator.AddSignal(backdrop.MouseButton1Click, function()
					Palette:Close()
				end)

				searchBox = New(
					"TextBox",
					{
						Name = "SearchInput",
						Position = UDim2.fromOffset(36, 0),
						Size = UDim2.new(1, -92, 1, 0),
						BackgroundTransparency = 1,
						Text = "",
						PlaceholderText = "Search tabs, toggles, themes, or commands...",
						I18nSkip = true,
						ClearTextOnFocus = false,
						FontFace = Creator.Font(Enum.FontWeight.Medium),
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Left,
						ZIndex = 124,
						ThemeTag = {TextColor3 = "Text", PlaceholderColor3 = "SubText"}
					}
				)

				local headerBar = New(
					"Frame",
					{
						Name = "SearchHeader",
						Size = UDim2.new(1, 0, 0, 44),
						BackgroundTransparency = 1,
						ZIndex = 123
					},
					{
						New("ImageLabel", {
							Image = Library:GetIcon("search") or "",
							Size = UDim2.fromOffset(15, 15),
							Position = UDim2.new(0, 14, 0.5, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundTransparency = 1,
							ZIndex = 124,
							ThemeTag = {ImageColor3 = "Accent"}
						}),
						searchBox,
						New("Frame", {
							Name = "EscHint",
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -12, 0.5, 0),
							Size = UDim2.fromOffset(36, 20),
							BackgroundTransparency = 0.36,
							ZIndex = 124,
							ThemeTag = {BackgroundColor3 = "DialogButton"}
						}, {
							New("UICorner", {CornerRadius = UDim.new(0, 5)}),
							New("UIStroke", {Transparency = 0.42, Thickness = 1, ThemeTag = {Color = "InElementBorder"}}),
							New("TextLabel", {
								Text = "ESC",
								I18nSkip = true,
								FontFace = Creator.Font(Enum.FontWeight.SemiBold),
								TextSize = 9,
								Size = UDim2.fromScale(1, 1),
								BackgroundTransparency = 1,
								ZIndex = 125,
								ThemeTag = {TextColor3 = "SubText"}
							})
						}),
						New("Frame", {
							Name = "HeaderLine",
							Size = UDim2.new(1, 0, 0, 1),
							Position = UDim2.new(0, 0, 1, -1),
							BackgroundTransparency = 0.42,
							ZIndex = 124,
							ThemeTag = {BackgroundColor3 = "ElementBorder"}
						})
					}
				)

				selectionPill = New(
					"Frame",
					{
						Name = "SelectionHighlight",
						Size = UDim2.new(1, -6, 0, 40),
						Position = UDim2.fromOffset(0, 0),
						BackgroundTransparency = 0.8,
						Visible = false,
						ZIndex = 123,
						ThemeTag = {BackgroundColor3 = "Accent"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 7)}),
						New("UIStroke", {Transparency = 0.3, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "Accent"}}),
						New("Frame", {
							Name = "AccentBar",
							Size = UDim2.fromOffset(3, 18),
							Position = UDim2.new(0, 2, 0.5, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							ZIndex = 124,
							ThemeTag = {BackgroundColor3 = "Accent"}
						}, {New("UICorner", {CornerRadius = UDim.new(1, 0)})})
					}
				)

				resultsLayout = New("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder})
				resultsRows = New(
					"Frame",
					{
						Name = "Rows",
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						ZIndex = 124
					},
					{resultsLayout}
				)

				resultsScroll = New(
					"ScrollingFrame",
					{
						Name = "Results",
						Position = UDim2.fromOffset(8, 50),
						Size = UDim2.new(1, -16, 1, -78),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						ScrollBarThickness = 3,
						ScrollBarImageTransparency = 0.45,
						CanvasSize = UDim2.fromOffset(0, 0),
						ScrollingDirection = Enum.ScrollingDirection.Y,
						ZIndex = 123,
						ThemeTag = {ScrollBarImageColor3 = "Accent"}
					},
					{
						New(
							"UIPadding",
							{
								PaddingTop = UDim.new(0, 2),
								PaddingBottom = UDim.new(0, 4),
								PaddingLeft = UDim.new(0, 2),
								PaddingRight = UDim.new(0, 2)
							}
						),
						selectionPill,
						resultsRows
					}
				)

				emptyLabel = New(
					"TextLabel",
					{
						Name = "Empty",
						Text = "No matching tabs, controls, or commands.",
						FontFace = Creator.Font(Enum.FontWeight.Regular),
						TextSize = 12,
						Position = UDim2.fromOffset(0, 74),
						Size = UDim2.new(1, 0, 0, 26),
						BackgroundTransparency = 1,
						Visible = false,
						ZIndex = 124,
						ThemeTag = {TextColor3 = "SubText"}
					}
				)

				local footer = New(
					"Frame",
					{
						Name = "Footer",
						Size = UDim2.new(1, 0, 0, 24),
						Position = UDim2.new(0, 0, 1, -24),
						BackgroundTransparency = 0.35,
						ZIndex = 123,
						ThemeTag = {BackgroundColor3 = "Dialog"}
					},
					{
						New("TextLabel", {
							Text = "Up/Down Navigate   |   Enter Run   |   Esc Close",
							I18nSkip = true,
							FontFace = Creator.Font(Enum.FontWeight.Medium),
							TextSize = 10,
							Position = UDim2.fromOffset(12, 0),
							Size = UDim2.new(1, -24, 1, 0),
							TextXAlignment = Enum.TextXAlignment.Left,
							BackgroundTransparency = 1,
							TextTransparency = 0.15,
							ZIndex = 124,
							ThemeTag = {TextColor3 = "SubText"}
						})
					}
				)

				local topRimSheen = New(
					"Frame",
					{
						Name = "TopRimSheen",
						Size = UDim2.new(1, -24, 0, 1),
						Position = UDim2.fromOffset(12, 0),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 0.72,
						BorderSizePixel = 0,
						ZIndex = 128
					},
					{
						New("UIGradient", {
							Transparency = NumberSequence.new({
								NumberSequenceKeypoint.new(0, 1),
								NumberSequenceKeypoint.new(0.25, 0.2),
								NumberSequenceKeypoint.new(0.5, 0),
								NumberSequenceKeypoint.new(0.75, 0.2),
								NumberSequenceKeypoint.new(1, 1)
							})
						})
					}
				)

				modalStroke = New("UIStroke", {
					Thickness = 1.2,
					Transparency = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					ThemeTag = {Color = "DropdownBorder"}
				})
				local borderFrame = New(
					"Frame",
					{Name = "Border", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 128},
					{New("UICorner", {CornerRadius = UDim.new(0, 12)}), modalStroke}
				)

				modalCanvas = New(
					"CanvasGroup",
					{
						Name = "PaletteCard",
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 0.14,
						GroupTransparency = 1,
						Active = true,
						ZIndex = 122,
						ThemeTag = {BackgroundColor3 = "DropdownHolder"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 12)}),
						borderFrame,
						topRimSheen,
						headerBar,
						resultsScroll,
						emptyLabel,
						footer
					}
				)

				modalShadow = New(
					"ImageLabel",
					{
						Name = "Shadow",
						BackgroundTransparency = 1,
						Image = "rbxassetid://5554236805",
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(23, 23, 277, 277),
						Size = UDim2.new(1, 36, 1, 36),
						Position = UDim2.fromOffset(-18, -14),
						ImageColor3 = Color3.fromRGB(0, 0, 0),
						ImageTransparency = 1,
						ZIndex = 121
					}
				)

				modalScale = New("UIScale", {Scale = Creator.DPIScale})
				Creator.RegisterDPIScale(modalScale, syncScale)

				modalHost = New(
					"Frame",
					{
						Name = "PaletteHost",
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.45, 0),
						Size = UDim2.fromOffset(456, 352),
						BackgroundTransparency = 1,
						ZIndex = 121
					},
					{modalScale, modalShadow, modalCanvas}
				)

				rootOverlay = New(
					"Frame",
					{
						Name = "AcryvenCommandPalette",
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						Visible = true,
						ZIndex = 120,
						Parent = spotlightGui
					},
					{backdrop, modalHost}
				)

				Creator.AddSignal(searchBox:GetPropertyChangedSignal("Text"), function()
					if Palette.Opened then
						renderResults(searchBox.Text)
					end
				end)
				Creator.AddSignal(searchBox.FocusLost, function(enterPressed)
					if Palette.Opened and enterPressed and #currentItems > 0 then
						executeSelected()
					end
				end)
			end

			function Palette.RegisterCommand(_self, cmd)
				if type(cmd) ~= "table" or not cmd.Title then
					return nil
				end
				table.insert(Palette.CustomCommands, cmd)
				return cmd
			end

			function Palette.Open(_self)
				if Palette.Opened then
					return
				end
				if type(Library._CloseDropdowns) == "function" then
					Library._CloseDropdowns()
				end
				ensureBuilt()
				transitionId += 1
				Palette.Opened = true
				Library._OpenDropdowns[Palette] = true
				searchBox.Text = ""
				renderResults("")
				spotlightGui.Enabled = true
				spotlightBlur.Enabled = true

				if Creator.ReducedMotion then
					spotlightBlur.Size = 22
					backdrop.BackgroundTransparency = 0.44
					noiseScrim.ImageTransparency = 0.965
					modalCanvas.GroupTransparency = 0
					modalShadow.ImageTransparency = 0.48
					animScale = 1
					syncScale()
					fadeStrokes(false, true)
				else
					spotlightBlur.Size = 0
					backdrop.BackgroundTransparency = 1
					noiseScrim.ImageTransparency = 1
					modalCanvas.GroupTransparency = 1
					modalShadow.ImageTransparency = 1
					animScale = 0.94
					syncScale()
					fadeStrokes(true, true)
					Creator.SpringValue(spotlightBlur, "Size", 22, 8.5, 1)
					Creator.SpringValue(backdrop, "BackgroundTransparency", 0.44, 9.5, 1)
					Creator.SpringValue(noiseScrim, "ImageTransparency", 0.965, 9.5, 1)
					Creator.SpringValue(modalCanvas, "GroupTransparency", 0, 9.5, 1)
					Creator.SpringValue(modalShadow, "ImageTransparency", 0.48, 9.5, 1)
					Creator.SpringValue(modalScale, "PalScale", 1, 9, 0.86, function(v)
						animScale = v
						syncScale()
					end, animScale)
					fadeStrokes(false, false)
				end

				task.defer(function()
					if Palette.Opened and searchBox and searchBox.Parent then
						searchBox:CaptureFocus()
					end
				end)

				table.insert(openConnections, Creator.AddSignal(UserInputService.InputBegan, function(input)
					if not Palette.Opened or input.UserInputType ~= Enum.UserInputType.Keyboard then
						return
					end
					if input.KeyCode == Enum.KeyCode.Escape then
						Palette:Close()
					elseif input.KeyCode == Enum.KeyCode.Down then
						if #currentItems > 0 then
							selectedIdx = (selectedIdx % #currentItems) + 1
							updateSelectionVisual(false)
						end
					elseif input.KeyCode == Enum.KeyCode.Up then
						if #currentItems > 0 then
							selectedIdx = ((selectedIdx - 2) % #currentItems) + 1
							updateSelectionVisual(false)
						end
					elseif input.KeyCode == Enum.KeyCode.Return and not searchBox:IsFocused() then
						if #currentItems > 0 then
							executeSelected()
						end
					end
				end))
			end

			function Palette.Close(_self)
				if not Palette.Opened then
					return
				end
				transitionId += 1
				local myId = transitionId
				Palette.Opened = false
				Library._OpenDropdowns[Palette] = nil
				disconnectOpen()
				if searchBox and searchBox:IsFocused() then
					searchBox:ReleaseFocus()
				end
				if not built or not spotlightGui then
					return
				end
				if Creator.ReducedMotion then
					Creator.CancelSpring(spotlightBlur, "Size")
					spotlightBlur.Size = 0
					spotlightBlur.Enabled = false
					spotlightGui.Enabled = false
					return
				end
				Creator.SpringValue(spotlightBlur, "Size", 0, 12, 1)
				Creator.SpringValue(backdrop, "BackgroundTransparency", 1, 12, 1)
				Creator.SpringValue(noiseScrim, "ImageTransparency", 1, 12, 1)
				Creator.SpringValue(modalCanvas, "GroupTransparency", 1, 12, 1)
				Creator.SpringValue(modalShadow, "ImageTransparency", 1, 12, 1)
				Creator.SpringValue(modalScale, "PalScale", 0.94, 11, 1, function(v)
					animScale = v
					syncScale()
				end, animScale)
				fadeStrokes(true, false)
				task.delay(0.18, function()
					if myId == transitionId and not Palette.Opened then
						if spotlightBlur and spotlightBlur.Parent then
							spotlightBlur.Enabled = false
						end
						if spotlightGui and spotlightGui.Parent then
							spotlightGui.Enabled = false
						end
					end
				end)
			end

			function Palette.Toggle(_self)
				if Palette.Opened then
					Palette:Close()
				else
					Palette:Open()
				end
			end

			function Palette.Destroy(_self)
				Palette:Close()
				disconnectOpen()
				if spotlightBlur then
					Creator.CancelSpring(spotlightBlur, "Size")
					pcall(function() spotlightBlur:Destroy() end)
					spotlightBlur = nil
				end
				if spotlightGui then
					pcall(function() spotlightGui:Destroy() end)
					spotlightGui = nil
				end
				rootOverlay = nil
				built = false
			end

			return Palette
		end
	end,
	[83] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(83)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local UserInputService = Creator.GetService("UserInputService")
		local Workspace = Creator.GetService("Workspace")
		local New = Creator.New

		local DANGER_RED = Color3.fromRGB(248, 113, 113)

		return function(Library)
			local Menu = {
				Opened = false
			}

			local built = false
			local host, canvas, shadow, borderStroke, listFrame, listLayout, uiScale, hoverPill
			local openConns = {}
			local transitionId = 0
			local animScale = 1
			local hoverY = 5
			local hoverVisible = false

			local function disconnectOpen()
				for i = #openConns, 1, -1 do
					pcall(function() openConns[i]:Disconnect() end)
					openConns[i] = nil
				end
			end

			local function syncScale()
				if uiScale then
					uiScale.Scale = Creator.DPIScale * animScale
				end
			end

			local function setHoverY(y)
				hoverY = y
				if hoverPill then
					hoverPill.Position = UDim2.fromOffset(5, y)
				end
			end

			local function ensureBuilt()
				if built then
					return
				end
				built = true

				listLayout = New("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder})
				listFrame = New(
					"Frame",
					{
						Name = "Items",
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						ZIndex = 924
					},
					{
						New("UIPadding", {PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5), PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5)}),
						listLayout
					}
				)

				hoverPill = New(
					"Frame",
					{
						Name = "MenuHoverPill",
						Size = UDim2.new(1, -10, 0, 28),
						Position = UDim2.fromOffset(5, 5),
						BackgroundTransparency = 1,
						ZIndex = 923,
						ThemeTag = {BackgroundColor3 = "DropdownOption"}
					},
					{New("UICorner", {CornerRadius = UDim.new(0, 6)})}
				)

				Creator.AddSignal(listFrame.MouseLeave, function()
					hoverVisible = false
					Creator.SpringValue(hoverPill, "BackgroundTransparency", 1, 11, 1)
				end)

				borderStroke = New(
					"UIStroke",
					{
						Thickness = 1.1,
						Transparency = 1,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						ThemeTag = {Color = "DropdownBorder"}
					}
				)
				local borderFrame = New(
					"Frame",
					{Name = "Border", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 925},
					{New("UICorner", {CornerRadius = UDim.new(0, 9)}), borderStroke}
				)

				canvas = New(
					"CanvasGroup",
					{
						Name = "ContextCard",
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						GroupTransparency = 1,
						BackgroundTransparency = 0.04,
						Active = true,
						ZIndex = 922,
						ThemeTag = {BackgroundColor3 = "DropdownHolder"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 9)}),
						borderFrame,
						hoverPill,
						listFrame
					}
				)

				shadow = New(
					"ImageLabel",
					{
						Name = "Shadow",
						BackgroundTransparency = 1,
						Image = "rbxassetid://5554236805",
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(23, 23, 277, 277),
						Size = UDim2.new(1, 24, 1, 24),
						Position = UDim2.fromOffset(-12, -10),
						ImageColor3 = Color3.fromRGB(0, 0, 0),
						ImageTransparency = 1,
						ZIndex = 921
					}
				)

				uiScale = New("UIScale", {Scale = Creator.DPIScale})
				Creator.RegisterDPIScale(uiScale, syncScale)

				host = New(
					"Frame",
					{
						Name = "AcryvenContextMenu",
						Size = UDim2.fromOffset(186, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						Visible = false,
						ZIndex = 920,
						Parent = Library.OverlayGUI or Library.GUI
					},
					{uiScale, shadow, canvas}
				)
			end

			function Menu.Open(_self, items, screenPos)
				if type(items) ~= "table" or #items == 0 then
					return
				end
				if type(Library._CloseDropdowns) == "function" then
					Library._CloseDropdowns()
				end
				ensureBuilt()
				disconnectOpen()

				hoverVisible = false
				hoverPill.BackgroundTransparency = 1

				for _, child in ipairs(listFrame:GetChildren()) do
					if child:IsA("GuiObject") then
						child:Destroy()
					end
				end

				for i, item in ipairs(items) do
					if item.Divider == true then
						New("Frame", {
							Name = "Div_" .. tostring(i),
							Size = UDim2.new(1, -8, 0, 1),
							BackgroundTransparency = 0.55,
							LayoutOrder = i,
							ZIndex = 924,
							Parent = listFrame,
							ThemeTag = {BackgroundColor3 = "TitleBarLine"}
						})
					else
						local iconAsset = item.Icon and (Library:GetIcon(item.Icon) or (item.Icon:match("^rbxassetid://") and item.Icon)) or nil
						local isDanger = item.Danger == true
						local children = {
							New("UICorner", {CornerRadius = UDim.new(0, 6)})
						}
						if iconAsset then
							table.insert(children, New("ImageLabel", {
								Image = iconAsset,
								Size = UDim2.fromOffset(13, 13),
								Position = UDim2.new(0, 8, 0.5, 0),
								AnchorPoint = Vector2.new(0, 0.5),
								BackgroundTransparency = 1,
								ImageColor3 = isDanger and DANGER_RED or Color3.fromRGB(220, 224, 234),
								ZIndex = 925,
								ThemeTag = (not isDanger) and {ImageColor3 = "SubText"} or nil
							}))
						end
						table.insert(children, New("TextLabel", {
							Text = tostring(item.Title or "Item"),
							I18nSkip = true,
							FontFace = Creator.Font(Enum.FontWeight.Medium),
							TextSize = 12,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextTruncate = Enum.TextTruncate.AtEnd,
							Position = UDim2.fromOffset(iconAsset and 28 or 10, 0),
							Size = UDim2.new(1, iconAsset and -34 or -16, 1, 0),
							BackgroundTransparency = 1,
							TextColor3 = isDanger and DANGER_RED or Color3.fromRGB(240, 240, 240),
							ZIndex = 925,
							ThemeTag = (not isDanger) and {TextColor3 = "Text"} or nil
						}))
						local btn = New(
							"TextButton",
							{
								Name = "Item_" .. tostring(i),
								Text = "",
								AutoButtonColor = false,
								Size = UDim2.new(1, 0, 0, 28),
								BackgroundTransparency = 1,
								LayoutOrder = i,
								ZIndex = 924,
								Parent = listFrame
							},
							children
						)
						Creator.AddSignal(btn.MouseEnter, function()
							local scale = Creator.GetEffectiveScale(canvas)
							local targetY = (btn.AbsolutePosition.Y - canvas.AbsolutePosition.Y) / scale
							if not hoverVisible then
								hoverVisible = true
								Creator.CancelSpring(hoverPill, "HoverY")
								setHoverY(targetY)
							else
								Creator.SpringValue(hoverPill, "HoverY", targetY, 13, 0.86, setHoverY, hoverY)
							end
							Creator.SpringValue(hoverPill, "BackgroundTransparency", 0.8, 12, 1)
						end)
						Creator.AddSignal(btn.MouseButton1Click, function()
							Menu:Close()
							Library:SafeCallback(item.Callback)
						end)
					end
				end

				transitionId += 1
				Menu.Opened = true
				Library._OpenDropdowns[Menu] = true

				local pos = screenPos or UserInputService:GetMouseLocation()
				local insetY = Creator.GetGuiInsetY()
				local cam = Workspace.CurrentCamera
				local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
				local usableH = math.max(160, vp.Y - insetY)
				local estH = (#items * 30 + 12) * Creator.DPIScale
				local scaledW = 186 * Creator.DPIScale
				local x = math.clamp(pos.X, 8, math.max(8, vp.X - scaledW - 8))
				local y = math.clamp(pos.Y - insetY, 8, math.max(8, usableH - estH - 8))
				host.Position = UDim2.fromOffset(x, y)
				host.Visible = true

				if Creator.ReducedMotion then
					canvas.GroupTransparency = 0
					borderStroke.Transparency = 0.34
					shadow.ImageTransparency = 0.56
					animScale = 1
					syncScale()
				else
					canvas.GroupTransparency = 1
					borderStroke.Transparency = 1
					shadow.ImageTransparency = 1
					animScale = 0.94
					syncScale()
					Creator.SpringValue(canvas, "GroupTransparency", 0, 11, 1)
					Creator.SpringValue(borderStroke, "Transparency", 0.34, 11, 1)
					Creator.SpringValue(shadow, "ImageTransparency", 0.56, 11, 1)
					Creator.SpringValue(uiScale, "CtxScale", 1, 11, 0.86, function(v)
						animScale = v
						syncScale()
					end, animScale)
				end

				table.insert(openConns, Creator.AddSignal(UserInputService.InputBegan, function(input)
					if not Menu.Opened then
						return
					end
					if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Escape then
						Menu:Close()
						return
					end
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then
						local ix, iy = input.Position.X, input.Position.Y
						local p, s = canvas.AbsolutePosition, canvas.AbsoluteSize
						if ix < p.X or ix > p.X + s.X or iy < p.Y or iy > p.Y + s.Y then
							Menu:Close()
						end
					end
				end))
			end

			function Menu.Close(_self)
				if not Menu.Opened then
					return
				end
				transitionId += 1
				local myId = transitionId
				Menu.Opened = false
				hoverVisible = false
				Library._OpenDropdowns[Menu] = nil
				disconnectOpen()
				if not built or not host then
					return
				end
				if Creator.ReducedMotion then
					hoverPill.BackgroundTransparency = 1
					host.Visible = false
					return
				end
				Creator.SpringValue(hoverPill, "BackgroundTransparency", 1, 13, 1)
				Creator.SpringValue(canvas, "GroupTransparency", 1, 13, 1)
				Creator.SpringValue(borderStroke, "Transparency", 1, 14, 1)
				Creator.SpringValue(shadow, "ImageTransparency", 1, 13, 1)
				task.delay(0.15, function()
					if myId == transitionId and not Menu.Opened and host and host.Parent then
						host.Visible = false
					end
				end)
			end

			function Menu.Attach(_self, guiObject, itemsOrBuilder)
				if not guiObject then
					return
				end
				Creator.AddSignal(guiObject.InputBegan, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton2 then
						local items = type(itemsOrBuilder) == "function" and itemsOrBuilder() or itemsOrBuilder
						if type(items) == "table" and #items > 0 then
							Menu:Open(items, UserInputService:GetMouseLocation())
						end
					end
				end)
			end

			function Menu.Destroy(_self)
				Menu:Close()
				disconnectOpen()
				if host and host.Parent then
					host:Destroy()
				end
				host = nil
				built = false
			end

			return Menu
		end
	end,
	[84] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(84)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local New = Creator.New

		local function hookOption(opt, listener)
			if type(opt) ~= "table" then
				return
			end
			if not opt._AcryvenListeners then
				opt._AcryvenListeners = {}
				local origSet = opt.SetValue
				if type(origSet) == "function" then
					opt.SetValue = function(self, ...)
						local res = origSet(self, ...)
						for _, fn in ipairs(opt._AcryvenListeners) do
							pcall(fn, opt.Value)
						end
						return res
					end
				end
				local origSetRGB = opt.SetValueRGB
				if type(origSetRGB) == "function" then
					opt.SetValueRGB = function(self, ...)
						local res = origSetRGB(self, ...)
						for _, fn in ipairs(opt._AcryvenListeners) do
							pcall(fn, opt.Value)
						end
						return res
					end
				end
			end
			table.insert(opt._AcryvenListeners, listener)
		end

		local function evalRule(rule)
			if type(rule) == "function" then
				local ok, res = pcall(rule)
				return ok and (res == true)
			end
			if type(rule) ~= "table" then
				return rule == true
			end
			-- Direct option object (Toggle, Dropdown, etc.)
			if rule.Type ~= nil and rule.Value ~= nil then
				return rule.Value == true
			end
			-- { option, expectedOrPredicate }
			if type(rule[1]) == "table" and rule[1].Type ~= nil then
				local opt, matcher = rule[1], rule[2]
				if type(matcher) == "function" then
					local ok, res = pcall(matcher, opt.Value)
					return ok and (res == true)
				elseif matcher == nil then
					return opt.Value == true
				else
					return opt.Value == matcher
				end
			end
			-- Array of rules (logical AND)
			for _, sub in ipairs(rule) do
				if not evalRule(sub) then
					return false
				end
			end
			return true
		end

		local function attachRuleHooks(rule, refresh)
			if type(rule) ~= "table" then
				return
			end
			if rule.Type ~= nil then
				hookOption(rule, refresh)
				return
			end
			if type(rule[1]) == "table" and rule[1].Type ~= nil then
				hookOption(rule[1], refresh)
				return
			end
			for _, sub in ipairs(rule) do
				attachRuleHooks(sub, refresh)
			end
		end

		return function(parentObj, config)
			config = type(config) == "table" and config or {}
			local Library = requireModule(Root)
			local Box = {
				Type = "DependencyBox",
				Visible = config.Default ~= false,
				ScrollFrame = parentObj.ScrollFrame,
				Tab = parentObj.Tab,
				TabId = parentObj.TabId,
				TabTitle = parentObj.TabTitle
			}

			local layout = New("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})
			Box.Container = New(
				"Frame",
				{
					Name = "Content",
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1
				},
				{
					layout,
					New(
						"UIPadding",
						{
							PaddingTop = UDim.new(0, 2),
							PaddingBottom = UDim.new(0, 2),
							PaddingLeft = UDim.new(0, 2),
							PaddingRight = UDim.new(0, 2)
						}
					)
				}
			)
			Box.Root = New(
				"Frame",
				{
					Name = "DependencyBox",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					ClipsDescendants = not Box.Visible,
					Visible = Box.Visible,
					LayoutOrder = config.LayoutOrder or 7,
					Parent = parentObj.Container
				},
				{Box.Container}
			)
			Box.Frame = Box.Root

			local currentH = 0
			local currentTargetH = 0
			local function applyH(h)
				currentH = h
				Box.Root.Size = UDim2.new(1, 0, 0, math.max(0, h))
				Box.Root.ClipsDescendants = (not Box.Visible) or math.abs(h - currentTargetH) > 0.8
				if not Box.Visible and h <= 0.6 then
					Box.Root.Visible = false
				elseif h > 0.6 then
					Box.Root.Visible = true
				end
			end

			local function getContentHeight()
				if not Box.Root or not Box.Root.Parent then
					return 0
				end
				local scale = Creator.GetEffectiveScale(Box.Container)
				return math.ceil(layout.AbsoluteContentSize.Y / scale) + 4
			end

			local function syncHeight(animate)
				if not Box.Root or not Box.Root.Parent then
					return
				end
				local contentY = getContentHeight()
				Box.Container.Size = UDim2.new(1, 0, 0, contentY)
				local targetH = Box.Visible and contentY or 0
				currentTargetH = targetH
				if Box.Visible then
					Box.Root.Visible = true
				end
				if animate and not Creator.ReducedMotion then
					Box.Root.ClipsDescendants = true
					Creator.SpringValue(Box.Root, "DepHeight", targetH, 8.5, 0.94, applyH, currentH)
				else
					Creator.CancelSpring(Box.Root, "DepHeight")
					applyH(targetH)
					Box.Root.Visible = Box.Visible
				end
			end

			Creator.AddSignal(layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
				syncHeight(false)
			end)
			Creator.RegisterDPIScale(Box.Root, function()
				task.defer(function()
					syncHeight(false)
				end)
			end)

			function Box.SetVisible(_self, visible, instant)
				local nextVis = visible == true
				if nextVis == Box.Visible and not instant then
					return
				end
				Box.Visible = nextVis
				syncHeight(not instant)
			end

			local dependsOn = config.DependsOn
			local condition = config.Condition
			function Box.Refresh(_self, instant)
				local show = true
				if dependsOn ~= nil then
					show = evalRule(dependsOn)
				end
				if show and type(condition) == "function" then
					local ok, res = pcall(condition)
					show = ok and (res == true)
				end
				Box:SetVisible(show, instant)
			end

			function Box.SetupDependencies(_self, deps)
				dependsOn = deps
				attachRuleHooks(dependsOn, function()
					Box:Refresh(false)
				end)
				Box:Refresh(true)
			end

			function Box.Destroy(_self)
				Creator.CancelSpring(Box.Root, "DepHeight")
				Box.Root:Destroy()
			end

			if dependsOn ~= nil then
				attachRuleHooks(dependsOn, function()
					Box:Refresh(false)
				end)
			end

			setmetatable(Box, Library.Elements)
			task.defer(function()
				if dependsOn ~= nil or type(condition) == "function" then
					Box:Refresh(true)
				else
					syncHeight(false)
				end
			end)
			return Box
		end
	end,
	[85] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(85)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local Workspace = Creator.GetService("Workspace")
		local New = Creator.New

		return function(Library, window, opts)
			opts = type(opts) == "table" and opts or {}
			local Pill = {
				Visible = false,
				AlwaysVisible = opts.AlwaysVisible == true,
				StatusText = tostring(opts.Status or "Active"),
				StatusColor = typeof(opts.Color) == "Color3" and opts.Color or Color3.fromRGB(52, 211, 153),
				Destroyed = false
			}

			local statusDot = New(
				"Frame",
				{
					Name = "StatusDot",
					Size = UDim2.fromOffset(8, 8),
					BackgroundColor3 = Pill.StatusColor,
					LayoutOrder = 1
				},
				{New("UICorner", {CornerRadius = UDim.new(1, 0)})}
			)

			local titleLbl = New(
				"TextLabel",
				{
					Name = "Title",
					Text = tostring(opts.Title or (window and window.TitleBar and window.TitleBar.TitleText) or "Acryven"),
					I18nSkip = true,
					FontFace = Creator.Font(Enum.FontWeight.SemiBold),
					TextSize = 12,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					ThemeTag = {TextColor3 = "Text"}
				}
			)

			local sep = New(
				"Frame",
				{
					Name = "Sep",
					Size = UDim2.fromOffset(1, 14),
					BackgroundTransparency = 0.5,
					LayoutOrder = 3,
					ThemeTag = {BackgroundColor3 = "TitleBarLine"}
				}
			)

			local statusLbl = New(
				"TextLabel",
				{
					Name = "Status",
					Text = Pill.StatusText,
					I18nSkip = true,
					FontFace = Creator.Font(Enum.FontWeight.Medium),
					TextSize = 11,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = 4,
					ThemeTag = {TextColor3 = "SubText"}
				}
			)

			local openIcon = New(
				"ImageLabel",
				{
					Name = "OpenIcon",
					Image = Library:GetIcon("maximize-2") or "",
					Size = UDim2.fromOffset(12, 12),
					BackgroundTransparency = 1,
					ImageTransparency = 0.15,
					LayoutOrder = 5,
					ThemeTag = {ImageColor3 = "Accent"}
				}
			)

			local pillStroke = New(
				"UIStroke",
				{
					Thickness = 1.1,
					Transparency = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					ThemeTag = {Color = "DropdownBorder"}
				}
			)
			local borderFrame = New(
				"Frame",
				{Name = "Border", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 114},
				{New("UICorner", {CornerRadius = UDim.new(1, 0)}), pillStroke}
			)

			local contentBtn = New(
				"TextButton",
				{
					Name = "ContentBtn",
					Text = "",
					AutoButtonColor = false,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.fromOffset(0, 34),
					BackgroundTransparency = 1,
					ZIndex = 113
				},
				{
					New("UIPadding", {PaddingLeft = UDim.new(0, 13), PaddingRight = UDim.new(0, 13)}),
					New("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 8)
					}),
					statusDot,
					titleLbl,
					sep,
					statusLbl,
					openIcon
				}
			)

			local pillCanvas = New(
				"CanvasGroup",
				{
					Name = "PillCanvas",
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.fromOffset(0, 34),
					GroupTransparency = 1,
					BackgroundTransparency = 0.08,
					ZIndex = 112,
					ThemeTag = {BackgroundColor3 = "DropdownHolder"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(1, 0)}),
					borderFrame,
					contentBtn
				}
			)

			local pillShadow = New(
				"ImageLabel",
				{
					Name = "Shadow",
					BackgroundTransparency = 1,
					Image = "rbxassetid://5554236805",
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(23, 23, 277, 277),
					Size = UDim2.new(1, 22, 1, 22),
					Position = UDim2.fromOffset(-11, -9),
					ImageColor3 = Color3.fromRGB(0, 0, 0),
					ImageTransparency = 1,
					ZIndex = 111
				}
			)

			local animScale = 1
			local pillScale = New("UIScale", {Scale = Creator.DPIScale})
			local function syncScale()
				pillScale.Scale = Creator.DPIScale * animScale
			end
			Creator.RegisterDPIScale(pillScale, syncScale)

			local host = New(
				"Frame",
				{
					Name = "AcryvenFloatingPill",
					AnchorPoint = Vector2.new(0.5, 0),
					Position = UDim2.new(0.5, 0, 0, 12),
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.fromOffset(0, 34),
					BackgroundTransparency = 1,
					Visible = false,
					ZIndex = 110,
					Parent = Library.GUI
				},
				{pillScale, pillShadow, pillCanvas}
			)
			Pill.Root = host

			-- Drag vs Click handling
			local dragged = false
			Creator.AddSignal(contentBtn.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragged = false
					local startMouse = input.Position
					local startAbsX = host.AbsolutePosition.X
					local startAbsY = host.AbsolutePosition.Y
					Creator.BeginDrag(function(mv)
						local delta = mv.Position - startMouse
						if delta.Magnitude > 6 then
							dragged = true
							local cam = Workspace.CurrentCamera
							local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
							local insetY = Creator.GetGuiInsetY()
							local w = host.AbsoluteSize.X
							local h = host.AbsoluteSize.Y
							local nx = math.clamp(startAbsX + delta.X, 8, math.max(8, vp.X - w - 8))
							local ny = math.clamp(startAbsY + delta.Y, 8, math.max(8, vp.Y - insetY - h - 8))
							host.AnchorPoint = Vector2.new(0, 0)
							host.Position = UDim2.fromOffset(nx, ny)
						end
					end, function()
						-- End drag
					end)
				end
			end)

			Creator.AddSignal(contentBtn.MouseButton1Click, function()
				if dragged then
					dragged = false
					return
				end
				if window and type(window.Minimize) == "function" then
					window:Minimize()
				end
			end)

			Creator.AddSignal(contentBtn.MouseEnter, function()
				if Pill.Visible then
					Creator.SpringValue(pillStroke, "Transparency", 0.16, 10, 1)
				end
			end)
			Creator.AddSignal(contentBtn.MouseLeave, function()
				if Pill.Visible then
					Creator.SpringValue(pillStroke, "Transparency", 0.36, 10, 1)
				end
			end)

			local transitionId = 0
			function Pill.SetVisible(_self, show, instant)
				if Pill.Destroyed then
					return
				end
				show = show == true
				if show == Pill.Visible and not instant then
					return
				end
				Pill.Visible = show
				transitionId += 1
				local myId = transitionId

				if show then
					host.Visible = true
					if instant or Creator.ReducedMotion then
						pillCanvas.GroupTransparency = 0
						pillStroke.Transparency = 0.36
						pillShadow.ImageTransparency = 0.58
						animScale = 1
						syncScale()
					else
						pillCanvas.GroupTransparency = 1
						pillStroke.Transparency = 1
						pillShadow.ImageTransparency = 1
						animScale = 0.88
						syncScale()
						Creator.SpringValue(pillCanvas, "GroupTransparency", 0, 8.5, 1)
						Creator.SpringValue(pillStroke, "Transparency", 0.36, 8.5, 1)
						Creator.SpringValue(pillShadow, "ImageTransparency", 0.58, 8.5, 1)
						Creator.SpringValue(pillScale, "PillScale", 1, 7.5, 0.82, function(v)
							animScale = v
							syncScale()
						end, animScale)
					end
				else
					if instant or Creator.ReducedMotion then
						host.Visible = false
					else
						Creator.SpringValue(pillCanvas, "GroupTransparency", 1, 11, 1)
						Creator.SpringValue(pillStroke, "Transparency", 1, 12, 1)
						Creator.SpringValue(pillShadow, "ImageTransparency", 1, 11, 1)
						Creator.SpringValue(pillScale, "PillScale", 0.88, 10, 1, function(v)
							animScale = v
							syncScale()
						end, animScale)
						task.delay(0.18, function()
							if myId == transitionId and not Pill.Visible and host and host.Parent then
								host.Visible = false
							end
						end)
					end
				end
			end

			function Pill.SetStatus(_self, text, color)
				if text ~= nil then
					Pill.StatusText = tostring(text)
					statusLbl.Text = Pill.StatusText
					sep.Visible = Pill.StatusText ~= ""
					statusLbl.Visible = Pill.StatusText ~= ""
				end
				if typeof(color) == "Color3" then
					Pill.StatusColor = color
					statusDot.BackgroundColor3 = color
				end
			end

			function Pill.SetTitle(_self, text)
				titleLbl.Text = tostring(text or "")
			end

			function Pill.Destroy(_self)
				if Pill.Destroyed then
					return
				end
				Pill.Destroyed = true
				if host and host.Parent then
					host:Destroy()
				end
				if Library.FloatingPill == Pill then
					Library.FloatingPill = nil
				end
			end

			if Pill.AlwaysVisible or (window and window.Minimized) then
				Pill:SetVisible(true, true)
			end

			return Pill
		end
	end,
	[86] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(86)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local RunService = Creator.GetService("RunService")
		local Stats = Creator.GetService("Stats")
		local Workspace = Creator.GetService("Workspace")
		local New = Creator.New

		local HUD = {}

		local function makeDraggable(handle, target)
			Creator.AddSignal(handle.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					local startPos = input.Position
					local startAbsX = target.AbsolutePosition.X
					local startAbsY = target.AbsolutePosition.Y
					Creator.BeginDrag(function(mv)
						local delta = mv.Position - startPos
						local cam = Workspace.CurrentCamera
						local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
						local insetY = Creator.GetGuiInsetY()
						local w, h = target.AbsoluteSize.X, target.AbsoluteSize.Y
						local nx = math.clamp(startAbsX + delta.X, 6, math.max(6, vp.X - w - 6))
						local ny = math.clamp(startAbsY + delta.Y, 6, math.max(6, vp.Y - insetY - h - 6))
						target.AnchorPoint = Vector2.new(0, 0)
						target.Position = UDim2.fromOffset(nx, ny)
					end, function() end)
				end
			end)
		end

		function HUD.CreateWatermark(Library, opts)
			opts = type(opts) == "table" and opts or {}
			local Watermark = {
				Visible = opts.Visible ~= false,
				ShowFPS = opts.ShowFPS ~= false,
				ShowPing = opts.ShowPing ~= false,
				Title = tostring(opts.Title or "Acryven"),
				CustomText = opts.Text and tostring(opts.Text) or nil,
				Destroyed = false
			}

			local accentBar = New(
				"Frame",
				{
					Name = "AccentBar",
					Size = UDim2.new(1, 0, 0, 2),
					Position = UDim2.fromOffset(0, 0),
					ThemeTag = {BackgroundColor3 = "Accent"}
				}
			)

			local textLbl = New(
				"TextLabel",
				{
					Name = "WatermarkText",
					RichText = true,
					Text = Watermark.Title,
					I18nSkip = true,
					FontFace = Creator.Font(Enum.FontWeight.Medium),
					TextSize = 11,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 1,
					ThemeTag = {TextColor3 = "Text"}
				}
			)

			local wmScale = New("UIScale", {Scale = Creator.DPIScale})
			Creator.RegisterDPIScale(wmScale)

			local card = New(
				"Frame",
				{
					Name = "AcryvenWatermark",
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.fromOffset(0, 28),
					Position = opts.Position or UDim2.fromOffset(14, 14),
					BackgroundTransparency = 0.14,
					ClipsDescendants = true,
					Visible = Watermark.Visible,
					Active = true,
					ZIndex = 105,
					Parent = Library.GUI,
					ThemeTag = {BackgroundColor3 = "DropdownHolder"}
				},
				{
					wmScale,
					New("UICorner", {CornerRadius = UDim.new(0, 8)}),
					New("UIStroke", {Transparency = 0.32, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "DropdownBorder"}}),
					accentBar,
					New("Frame", {
						AutomaticSize = Enum.AutomaticSize.X,
						Size = UDim2.fromOffset(0, 28),
						BackgroundTransparency = 1
					}, {
						New("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 2)}),
						textLbl
					})
				}
			)
			Watermark.Root = card
			makeDraggable(card, card)

			local frameCount = 0
			local elapsed = 0
			local fps = 60

			local function getPingMs()
				local ok, ms = pcall(function()
					local net = Stats and Stats:FindFirstChild("Network")
					local item = net and net:FindFirstChild("ServerStatsItem")
					local dataPing = item and item:FindFirstChild("Data Ping")
					return dataPing and math.floor(dataPing:GetValue() + 0.5) or nil
				end)
				return ok and ms or nil
			end

			local function updateLabel()
				if Watermark.CustomText then
					textLbl.Text = Watermark.CustomText
					return
				end
				local parts = {"<b>" .. Watermark.Title .. "</b>"}
				if Watermark.ShowFPS then
					table.insert(parts, tostring(fps) .. " fps")
				end
				if Watermark.ShowPing then
					local ping = getPingMs()
					if ping then
						table.insert(parts, tostring(ping) .. " ms")
					end
				end
				textLbl.Text = table.concat(parts, "  |  ")
			end

			local conn = RunService.RenderStepped:Connect(function(dt)
				if Watermark.Destroyed or not Watermark.Visible then
					return
				end
				frameCount += 1
				elapsed += dt
				if elapsed >= 0.75 then
					fps = math.max(1, math.floor((frameCount / elapsed) + 0.5))
					frameCount = 0
					elapsed = 0
					updateLabel()
				end
			end)
			table.insert(Creator.Signals, conn)

			function Watermark.SetText(_self, text)
				Watermark.CustomText = text and tostring(text) or nil
				updateLabel()
			end
			function Watermark.SetVisible(_self, vis)
				Watermark.Visible = vis == true
				card.Visible = Watermark.Visible
				if Watermark.Visible then
					updateLabel()
				end
			end
			function Watermark.Destroy(_self)
				if Watermark.Destroyed then
					return
				end
				Watermark.Destroyed = true
				pcall(function() conn:Disconnect() end)
				if card and card.Parent then
					card:Destroy()
				end
			end

			updateLabel()
			return Watermark
		end

		function HUD.CreateKeybindList(Library, opts)
			opts = type(opts) == "table" and opts or {}
			local KbList = {
				Visible = opts.Visible ~= false,
				HideWhenEmpty = opts.HideWhenEmpty == true,
				Destroyed = false
			}

			local header = New(
				"Frame",
				{
					Name = "Header",
					Size = UDim2.new(1, 0, 0, 26),
					BackgroundTransparency = 0.55,
					ZIndex = 106,
					ThemeTag = {BackgroundColor3 = "DialogHolder"}
				},
				{
					New("Frame", {
						Size = UDim2.new(1, 0, 0, 2),
						ThemeTag = {BackgroundColor3 = "Accent"}
					}),
					New("ImageLabel", {
						Image = Library:GetIcon("keyboard") or "",
						Size = UDim2.fromOffset(12, 12),
						Position = UDim2.new(0, 9, 0.5, 1),
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						ZIndex = 107,
						ThemeTag = {ImageColor3 = "Accent"}
					}),
					New("TextLabel", {
						Text = tostring(opts.Title or "Keybinds"),
						FontFace = Creator.Font(Enum.FontWeight.SemiBold),
						TextSize = 11,
						TextXAlignment = Enum.TextXAlignment.Left,
						Position = UDim2.fromOffset(26, 1),
						Size = UDim2.new(1, -34, 1, 0),
						BackgroundTransparency = 1,
						ZIndex = 107,
						ThemeTag = {TextColor3 = "Text"}
					})
				}
			)

			local bodyLayout = New("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder})
			local body = New(
				"Frame",
				{
					Name = "Rows",
					Position = UDim2.fromOffset(0, 26),
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					ZIndex = 106
				},
				{
					New("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 7)}),
					bodyLayout
				}
			)

			local kbScale = New("UIScale", {Scale = Creator.DPIScale})
			Creator.RegisterDPIScale(kbScale)

			local card = New(
				"Frame",
				{
					Name = "AcryvenKeybindList",
					Size = UDim2.fromOffset(204, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					Position = opts.Position or UDim2.fromOffset(14, 52),
					BackgroundTransparency = 0.14,
					ClipsDescendants = true,
					Visible = KbList.Visible,
					Active = true,
					ZIndex = 105,
					Parent = Library.GUI,
					ThemeTag = {BackgroundColor3 = "DropdownHolder"}
				},
				{
					kbScale,
					New("UICorner", {CornerRadius = UDim.new(0, 9)}),
					New("UIStroke", {Transparency = 0.32, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "DropdownBorder"}}),
					header,
					body
				}
			)
			KbList.Root = card
			makeDraggable(header, card)

			function KbList.Refresh(_self)
				if KbList.Destroyed or not card or not card.Parent then
					return
				end
				for _, child in ipairs(body:GetChildren()) do
					if child:IsA("GuiObject") then
						child:Destroy()
					end
				end
				local list = Library._TrackedKeybinds or {}
				local shown = 0
				for i, kb in ipairs(list) do
					if type(kb) == "table" and kb.Value and kb.Value ~= "None" then
						shown += 1
						local active = false
						if type(kb.GetState) == "function" then
							local ok, st = pcall(kb.GetState, kb)
							active = ok and (st == true)
						end
						New(
							"Frame",
							{
								Name = "KbRow_" .. tostring(i),
								Size = UDim2.new(1, 0, 0, 20),
								BackgroundTransparency = 1,
								LayoutOrder = i,
								ZIndex = 107,
								Parent = body
							},
							{
								New("Frame", {
									Size = UDim2.fromOffset(6, 6),
									Position = UDim2.new(0, 0, 0.5, 0),
									AnchorPoint = Vector2.new(0, 0.5),
									BackgroundColor3 = active and Color3.fromRGB(52, 211, 153) or Color3.fromRGB(120, 128, 146),
									ZIndex = 108
								}, {New("UICorner", {CornerRadius = UDim.new(1, 0)})}),
								New("TextLabel", {
									Text = tostring(kb.Title or "Keybind"),
									I18nSkip = true,
									FontFace = Creator.Font(Enum.FontWeight.Medium),
									TextSize = 11,
									TextXAlignment = Enum.TextXAlignment.Left,
									TextTruncate = Enum.TextTruncate.AtEnd,
									Position = UDim2.fromOffset(12, 0),
									Size = UDim2.new(1, -76, 1, 0),
									BackgroundTransparency = 1,
									ZIndex = 108,
									ThemeTag = {TextColor3 = active and "Text" or "SubText"}
								}),
								New("TextLabel", {
									Text = "[" .. tostring(kb.Value) .. "]",
									I18nSkip = true,
									FontFace = Creator.Font(Enum.FontWeight.SemiBold),
									TextSize = 10,
									TextXAlignment = Enum.TextXAlignment.Right,
									Position = UDim2.new(1, -60, 0, 0),
									Size = UDim2.fromOffset(60, 20),
									BackgroundTransparency = 1,
									ZIndex = 108,
									ThemeTag = {TextColor3 = active and "Accent" or "SubText"}
								})
							}
						)
					end
				end
				if shown == 0 then
					if KbList.HideWhenEmpty then
						card.Visible = false
						return
					end
					New("TextLabel", {
						Text = "No active keybinds",
						FontFace = Creator.Font(Enum.FontWeight.Regular),
						TextSize = 11,
						Size = UDim2.new(1, 0, 0, 18),
						BackgroundTransparency = 1,
						ZIndex = 107,
						Parent = body,
						ThemeTag = {TextColor3 = "SubText"}
					})
				end
				card.Visible = KbList.Visible
			end

			function KbList.SetVisible(_self, vis)
				KbList.Visible = vis == true
				if KbList.Visible then
					KbList:Refresh()
				else
					card.Visible = false
				end
			end

			function KbList.Destroy(_self)
				if KbList.Destroyed then
					return
				end
				KbList.Destroyed = true
				if Library._KeybindLists then
					local idx = table.find(Library._KeybindLists, KbList)
					if idx then
						table.remove(Library._KeybindLists, idx)
					end
				end
				if card and card.Parent then
					card:Destroy()
				end
			end

			Library._KeybindLists = Library._KeybindLists or {}
			table.insert(Library._KeybindLists, KbList)
			KbList:Refresh()
			return KbList
		end

		return HUD
	end,
	[87] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(87)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local New = Creator.New

		return function(parentObj, config)
			if type(config) == "number" then
				config = {Columns = config}
			else
				config = type(config) == "table" and config or {}
			end
			local Library = requireModule(Root)
			local gap = tonumber(config.Gap) or 6
			local colCount = tonumber(config.Columns)

			local Row = {
				Type = "Row",
				ScrollFrame = parentObj.ScrollFrame,
				Tab = parentObj.Tab,
				TabId = parentObj.TabId,
				TabTitle = parentObj.TabTitle
			}

			Row.Root = New(
				"Frame",
				{
					Name = "AcryvenRow",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					LayoutOrder = config.LayoutOrder or 7,
					Parent = parentObj.Container
				}
			)
			Row.Frame = Row.Root

			if colCount and colCount >= 2 then
				-- Multi-column vertical grid mode (2-Column / 3-Column Tab Layout)
				colCount = math.clamp(math.floor(colCount), 2, 4)
				local weights = type(config.Weights) == "table" and config.Weights or nil
				local totalWeight = 0
				for i = 1, colCount do
					totalWeight += (weights and tonumber(weights[i]) or 1)
				end
				if totalWeight <= 0 then
					totalWeight = colCount
				end

				Row.Columns = {}
				local colLayouts = {}
				local function syncColumnHeights()
					if not Row.Root or not Row.Root.Parent then
						return
					end
					local scale = Creator.GetEffectiveScale(Row.Root)
					local maxH = 0
					for idx, lay in ipairs(colLayouts) do
						local h = math.ceil(lay.AbsoluteContentSize.Y / scale)
						Row.Columns[idx].Container.Size = UDim2.new(Row.Columns[idx]._WidthScale, Row.Columns[idx]._WidthOffset, 0, h)
						if h > maxH then
							maxH = h
						end
					end
					Row.Root.Size = UDim2.new(1, 0, 0, maxH)
				end

				local accumScale = 0
				for i = 1, colCount do
					local w = (weights and tonumber(weights[i]) or 1) / totalWeight
					local gapShare = gap * (colCount - 1) / colCount
					local xOff = math.floor((i - 1) * (gap / colCount) + 0.5)
					local colLayout = New("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})
					local colFrame = New(
						"Frame",
						{
							Name = "Column_" .. tostring(i),
							BackgroundTransparency = 1,
							Position = UDim2.new(accumScale, xOff, 0, 0),
							Size = UDim2.new(w, -math.floor(gapShare + 0.5), 0, 0),
							Parent = Row.Root
						},
						{colLayout}
					)
					accumScale += w
					table.insert(colLayouts, colLayout)

					local colObj = {
						Type = "Column",
						Index = i,
						Container = colFrame,
						Root = colFrame,
						ScrollFrame = parentObj.ScrollFrame,
						Tab = parentObj.Tab,
						TabId = parentObj.TabId,
						TabTitle = parentObj.TabTitle,
						_WidthScale = w,
						_WidthOffset = -math.floor(gapShare + 0.5)
					}
					function colObj.AddSection(_self, sectionTitle, sectionOpts)
						local Section, sectionComponent =
							{Type = "Section"},
							requireModule(Root.Components.Section)(sectionTitle, colFrame, sectionOpts)
						Section.Container = sectionComponent.Container
						Section.Root = sectionComponent.Root
						Section.SetVisible = function(selfOrVisible, visible)
							return sectionComponent.SetVisible(type(selfOrVisible) == "boolean" and selfOrVisible or visible)
						end
						Section.SetCollapsed = function(selfOrVal, val, instant)
							if type(selfOrVal) == "boolean" then
								return sectionComponent.SetCollapsed(selfOrVal, val)
							end
							return sectionComponent.SetCollapsed(val, instant)
						end
						Section.Toggle = function(_s, instant)
							return sectionComponent.Toggle(instant)
						end
						Section.SetBadge = function(_s, text, color)
							return sectionComponent.SetBadge(text, color)
						end
						Section.ScrollFrame = parentObj.ScrollFrame
						Section.Tab = parentObj.Tab
						Section.TabId = parentObj.TabId
						Section.TabTitle = parentObj.TabTitle
						setmetatable(Section, Library.Elements)
						return Section
					end
					setmetatable(colObj, Library.Elements)
					Row.Columns[i] = colObj

					Creator.AddSignal(colLayout:GetPropertyChangedSignal("AbsoluteContentSize"), syncColumnHeights)
				end

				Row.Left = Row.Columns[1]
				Row.Right = Row.Columns[2]
				Row.Container = Row.Columns[1].Container
				Creator.RegisterDPIScale(Row.Root, function()
					task.defer(syncColumnHeights)
				end)
				task.defer(syncColumnHeights)
			else
				-- Direct HStack mode: children added directly to Row lay out evenly side-by-side
				Row.Container = Row.Root
				local function reflowChildren()
					if not Row.Root or not Row.Root.Parent then
						return
					end
					local items = {}
					for _, child in ipairs(Row.Root:GetChildren()) do
						if child:IsA("GuiObject") and child.Visible then
							table.insert(items, child)
						end
					end
					table.sort(items, function(a, b)
						return a.LayoutOrder < b.LayoutOrder
					end)
					local count = #items
					if count == 0 then
						Row.Root.Size = UDim2.new(1, 0, 0, 0)
						return
					end
					local scale = Creator.GetEffectiveScale(Row.Root)
					local wScale = 1 / count
					local gapDeduction = gap * (count - 1) / count
					local maxH = 0
					for idx, item in ipairs(items) do
						item.Position = UDim2.new((idx - 1) * wScale, math.floor((idx - 1) * (gap / count) + 0.5), 0, 0)
						item.Size = UDim2.new(wScale, -math.floor(gapDeduction + 0.5), item.Size.Y.Scale, item.Size.Y.Offset)
						local h = math.ceil(item.AbsoluteSize.Y / scale)
						if h > maxH then
							maxH = h
						end
					end
					Row.Root.Size = UDim2.new(1, 0, 0, math.max(36, maxH))
				end

				local orderSeq = 0
				Creator.AddSignal(Row.Root.ChildAdded, function(child)
					if child:IsA("GuiObject") then
						orderSeq += 1
						child.LayoutOrder = orderSeq
						Creator.AddSignal(child:GetPropertyChangedSignal("AbsoluteSize"), function()
							task.defer(reflowChildren)
						end)
						Creator.AddSignal(child:GetPropertyChangedSignal("Visible"), function()
							task.defer(reflowChildren)
						end)
						task.defer(reflowChildren)
					end
				end)
				Creator.AddSignal(Row.Root.ChildRemoved, function()
					task.defer(reflowChildren)
				end)
				Creator.RegisterDPIScale(Row.Root, function()
					task.defer(reflowChildren)
				end)
			end

			function Row.Destroy(_self)
				Row.Root:Destroy()
			end

			setmetatable(Row, Library.Elements)
			return Row
		end
	end,
	[88] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(88)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local New = Creator.New

		return function(parentObj, config)
			config = type(config) == "table" and config or {}
			local Library = requireModule(Root)

			local SubTabs = {
				Type = "SubTabs",
				Tabs = {},
				SelectedIndex = 0,
				Selected = nil,
				Callback = config.Callback
			}

			local barHeight = 34
			local barPadding = 3

			local indicatorPill = New(
				"Frame",
				{
					Name = "Indicator",
					Size = UDim2.new(0, 0, 1, -barPadding * 2),
					Position = UDim2.fromOffset(barPadding, barPadding),
					BackgroundTransparency = 0.08,
					ZIndex = 2,
					ThemeTag = {BackgroundColor3 = "Accent"}
				},
				{New("UICorner", {CornerRadius = UDim.new(0, 7)})}
			)

			local buttonsRow = New(
				"Frame",
				{
					Name = "Buttons",
					Size = UDim2.new(1, -barPadding * 2, 1, -barPadding * 2),
					Position = UDim2.fromOffset(barPadding, barPadding),
					BackgroundTransparency = 1,
					ZIndex = 3
				},
				{
					New(
						"UIListLayout",
						{
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder
						}
					)
				}
			)

			local barFrame = New(
				"Frame",
				{
					Name = "SubTabBar",
					Size = UDim2.new(1, 0, 0, barHeight),
					BackgroundTransparency = 0.22,
					ThemeTag = {BackgroundColor3 = "DialogHolder"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(0, 9)}),
					New(
						"UIStroke",
						{
							Transparency = 0.34,
							Thickness = 1,
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							ThemeTag = {Color = "ElementBorder"}
						}
					),
					indicatorPill,
					buttonsRow
				}
			)

			local pagesHolder = New(
				"Frame",
				{
					Name = "PagesHolder",
					Position = UDim2.fromOffset(0, barHeight + 8),
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1,
					ClipsDescendants = false
				}
			)

			SubTabs.Root = New(
				"Frame",
				{
					Name = "AcryvenSubTabs",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, barHeight + 8),
					LayoutOrder = config.LayoutOrder or 7,
					Parent = parentObj.Container
				},
				{barFrame, pagesHolder}
			)
			SubTabs.Frame = SubTabs.Root

			local pillX, pillW = barPadding, 0
			local function setIndicatorBounds(x, w)
				pillX, pillW = x, w
				indicatorPill.Position = UDim2.fromOffset(x, barPadding)
				indicatorPill.Size = UDim2.new(0, math.max(0, w), 1, -barPadding * 2)
			end

			local function syncActiveHeight()
				if not SubTabs.Root or not SubTabs.Root.Parent then
					return
				end
				local active = SubTabs.Tabs[SubTabs.SelectedIndex]
				if not active or not active._Layout then
					pagesHolder.Size = UDim2.new(1, 0, 0, 0)
					SubTabs.Root.Size = UDim2.new(1, 0, 0, barHeight + 4)
					return
				end
				local scale = Creator.GetEffectiveScale(active.Container)
				local h = math.ceil(active._Layout.AbsoluteContentSize.Y / scale) + 6
				active.Container.Size = UDim2.new(1, 0, 0, h)
				pagesHolder.Size = UDim2.new(1, 0, 0, h)
				SubTabs.Root.Size = UDim2.new(1, 0, 0, barHeight + 8 + h)
			end

			local function updateIndicator(instant)
				local count = #SubTabs.Tabs
				if count == 0 or SubTabs.SelectedIndex < 1 then
					return
				end
				local scale = Creator.GetEffectiveScale(barFrame)
				local innerW = math.max(0, barFrame.AbsoluteSize.X / scale - barPadding * 2)
				if innerW <= 0 then
					return
				end
				local segW = innerW / count
				local targetX = barPadding + (SubTabs.SelectedIndex - 1) * segW
				if instant or Creator.ReducedMotion or pillW <= 0 then
					Creator.CancelSpring(indicatorPill, "PillX")
					Creator.CancelSpring(indicatorPill, "PillW")
					setIndicatorBounds(targetX, segW)
				else
					Creator.SpringValue(indicatorPill, "PillX", targetX, 9.5, 0.86, function(x)
						setIndicatorBounds(x, pillW)
					end, pillX)
					Creator.SpringValue(indicatorPill, "PillW", segW, 9.5, 0.86, function(w)
						setIndicatorBounds(pillX, w)
					end, pillW)
				end
			end

			local function refreshTabButtonStyles()
				local count = #SubTabs.Tabs
				if count == 0 then
					return
				end
				local accentContrast = Creator.AutoContrast(Creator.GetThemeProperty("Accent"))
				for idx, item in ipairs(SubTabs.Tabs) do
					item._Button.Size = UDim2.new(1 / count, 0, 1, 0)
					local isActive = (idx == SubTabs.SelectedIndex)
					if isActive then
						Creator.OverrideTag(item._Label, {})
						item._Label.TextColor3 = accentContrast
						Creator.SpringValue(item._Label, "TextTransparency", 0, 10, 1)
						if item._Icon then
							Creator.OverrideTag(item._Icon, {})
							item._Icon.ImageColor3 = accentContrast
							Creator.SpringValue(item._Icon, "ImageTransparency", 0, 10, 1)
						end
					else
						Creator.OverrideTag(item._Label, {TextColor3 = "SubText"})
						Creator.SpringValue(item._Label, "TextTransparency", 0, 10, 1)
						if item._Icon then
							Creator.OverrideTag(item._Icon, {ImageColor3 = "SubText"})
							Creator.SpringValue(item._Icon, "ImageTransparency", 0.02, 10, 1)
						end
					end
				end
			end

			-- Re-compute active contrast color when theme changes
			Creator.AddSignal(indicatorPill:GetPropertyChangedSignal("BackgroundColor3"), function()
				if SubTabs.SelectedIndex >= 1 then
					local active = SubTabs.Tabs[SubTabs.SelectedIndex]
					if active then
						local c = Creator.AutoContrast(indicatorPill.BackgroundColor3)
						active._Label.TextColor3 = c
						if active._Icon then
							active._Icon.ImageColor3 = c
						end
					end
				end
			end)

			Creator.AddSignal(barFrame:GetPropertyChangedSignal("AbsoluteSize"), function()
				updateIndicator(true)
			end)
			Creator.RegisterDPIScale(SubTabs.Root, function()
				task.defer(function()
					updateIndicator(true)
					syncActiveHeight()
				end)
			end)

			function SubTabs.Select(_self, target, instant)
				local targetIndex = nil
				if type(target) == "number" then
					targetIndex = target
				elseif type(target) == "string" then
					for idx, item in ipairs(SubTabs.Tabs) do
						if item.Title == target then
							targetIndex = idx
							break
						end
					end
				elseif type(target) == "table" and type(target.Index) == "number" then
					targetIndex = target.Index
				end
				if not targetIndex or not SubTabs.Tabs[targetIndex] then
					return
				end
				if targetIndex == SubTabs.SelectedIndex and not instant then
					return
				end
				SubTabs.SelectedIndex = targetIndex
				SubTabs.Selected = SubTabs.Tabs[targetIndex]

				for idx, item in ipairs(SubTabs.Tabs) do
					local active = (idx == targetIndex)
					item.Selected = active
					item.Container.Visible = active
					if active then
						if instant or Creator.ReducedMotion then
							Creator.CancelSpring(item.Container, "GlideY")
							item.Container.Position = UDim2.fromOffset(0, 0)
						else
							item.Container.Position = UDim2.fromOffset(0, 7)
							Creator.SpringValue(item.Container, "GlideY", 0, 9, 0.9, function(y)
								item.Container.Position = UDim2.fromOffset(0, y)
							end, 7)
						end
					end
				end

				refreshTabButtonStyles()
				updateIndicator(instant)
				syncActiveHeight()
				if type(SubTabs.Callback) == "function" and not instant then
					Library:SafeCallback(SubTabs.Callback, SubTabs.Selected.Title, targetIndex)
				end
			end

			function SubTabs.AddTab(_self, tabSpec, iconArg)
				local spec = type(tabSpec) == "table" and tabSpec or {Title = tostring(tabSpec or "Tab"), Icon = iconArg}
				local index = #SubTabs.Tabs + 1
				local iconAsset = nil
				if type(spec.Icon) == "string" and spec.Icon ~= "" then
					local resolved = Library:GetIcon(spec.Icon)
					if resolved then
						iconAsset = resolved
					elseif spec.Icon:match("^rbxassetid://") or spec.Icon:match("^rbxasset://") then
						iconAsset = spec.Icon
					end
				end

				local innerChildren = {
					New(
						"UIListLayout",
						{
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							Padding = UDim.new(0, 5)
						}
					)
				}
				local iconImg = nil
				if iconAsset then
					iconImg = New(
						"ImageLabel",
						{
							Name = "Icon",
							Image = iconAsset,
							Size = UDim2.fromOffset(15, 15),
							BackgroundTransparency = 1,
							ImageTransparency = 0.02,
							ZIndex = 4,
							ThemeTag = {ImageColor3 = "SubText"}
						}
					)
					table.insert(innerChildren, iconImg)
				end
				local label = New(
					"TextLabel",
					{
						Name = "Label",
						Text = tostring(spec.Title or ("Tab " .. tostring(index))),
						FontFace = Creator.Font(Enum.FontWeight.SemiBold),
						TextSize = 13,
						AutomaticSize = Enum.AutomaticSize.X,
						Size = UDim2.new(0, 0, 1, 0),
						BackgroundTransparency = 1,
						TextTransparency = 0,
						ZIndex = 4,
						ThemeTag = {TextColor3 = "SubText"}
					}
				)
				table.insert(innerChildren, label)

				local btn = New(
					"TextButton",
					{
						Name = "SubTab_" .. tostring(index),
						Text = "",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						LayoutOrder = index,
						ZIndex = 4,
						Parent = buttonsRow
					},
					innerChildren
				)

				local pageLayout = New("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})
				local pageFrame = New(
					"Frame",
					{
						Name = "SubTabPage_" .. tostring(index),
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 1,
						Visible = false,
						Parent = pagesHolder
					},
					{
						pageLayout,
						New(
							"UIPadding",
							{
								PaddingTop = UDim.new(0, 2),
								PaddingBottom = UDim.new(0, 4),
								PaddingLeft = UDim.new(0, 2),
								PaddingRight = UDim.new(0, 2)
							}
						)
					}
				)

				local pageObj = {
					Type = "SubTabPage",
					Title = tostring(spec.Title or ("Tab " .. tostring(index))),
					Index = index,
					Selected = false,
					Container = pageFrame,
					Root = pageFrame,
					ScrollFrame = parentObj.ScrollFrame,
					Tab = parentObj.Tab,
					TabId = parentObj.TabId,
					TabTitle = parentObj.TabTitle,
					_Button = btn,
					_Label = label,
					_Icon = iconImg,
					_Layout = pageLayout
				}

				function pageObj.AddSection(_s, sectionTitle, sectionOpts)
					local Section, sectionComponent =
						{Type = "Section"},
						requireModule(Root.Components.Section)(sectionTitle, pageFrame, sectionOpts)
					Section.Container = sectionComponent.Container
					Section.Root = sectionComponent.Root
					Section.SetVisible = function(selfOrVisible, visible)
						return sectionComponent.SetVisible(type(selfOrVisible) == "boolean" and selfOrVisible or visible)
					end
					Section.SetCollapsed = function(selfOrVal, val, instant)
						if type(selfOrVal) == "boolean" then
							return sectionComponent.SetCollapsed(selfOrVal, val)
						end
						return sectionComponent.SetCollapsed(val, instant)
					end
					Section.Toggle = function(_sec, instant)
						return sectionComponent.Toggle(instant)
					end
					Section.SetBadge = function(_sec, text, color)
						return sectionComponent.SetBadge(text, color)
					end
					Section.ScrollFrame = parentObj.ScrollFrame
					Section.Tab = parentObj.Tab
					Section.TabId = parentObj.TabId
					Section.TabTitle = parentObj.TabTitle
					setmetatable(Section, Library.Elements)
					return Section
				end

				function pageObj.Select(_s, instant)
					SubTabs:Select(index, instant)
				end

				setmetatable(pageObj, Library.Elements)
				table.insert(SubTabs.Tabs, pageObj)

				Creator.AddSignal(pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
					if SubTabs.SelectedIndex == index then
						syncActiveHeight()
					end
				end)
				Creator.AddSignal(btn.MouseButton1Click, function()
					SubTabs:Select(index, false)
				end)

				refreshTabButtonStyles()
				if #SubTabs.Tabs == 1 then
					SubTabs:Select(1, true)
				else
					updateIndicator(true)
				end
				return pageObj
			end

			function SubTabs.GetTab(_self, key)
				if type(key) == "number" then
					return SubTabs.Tabs[key]
				end
				for _, item in ipairs(SubTabs.Tabs) do
					if item.Title == key then
						return item
					end
				end
				return nil
			end

			function SubTabs.Destroy(_self)
				SubTabs.Root:Destroy()
			end

			if type(config.Tabs) == "table" then
				for _, spec in ipairs(config.Tabs) do
					SubTabs:AddTab(spec)
				end
			end
			if config.Default ~= nil then
				SubTabs:Select(config.Default, true)
			end

			task.defer(function()
				updateIndicator(true)
				syncActiveHeight()
			end)

			return SubTabs
		end
	end,
	[89] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(89)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local Workspace = Creator.GetService("Workspace")
		local New = Creator.New

		return function(Library)
			local Tooltip = {}
			local built = false
			local host, canvas, borderStroke, label, uiScale
			local activeTarget = nil
			local hoverGen = 0

			local function ensureBuilt()
				if built then
					return
				end
				built = true

				label = New(
					"TextLabel",
					{
						Name = "Text",
						Text = "",
						I18nSkip = true,
						FontFace = Creator.Font(Enum.FontWeight.Medium),
						TextSize = 11,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.XY,
						Size = UDim2.fromOffset(0, 0),
						BackgroundTransparency = 1,
						ZIndex = 903,
						ThemeTag = {TextColor3 = "Text"}
					},
					{New("UISizeConstraint", {MaxSize = Vector2.new(240, 120)})}
				)

				borderStroke = New(
					"UIStroke",
					{
						Thickness = 1,
						Transparency = 1,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						ThemeTag = {Color = "DropdownBorder"}
					}
				)
				local borderFrame = New(
					"Frame",
					{Name = "Border", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 904},
					{New("UICorner", {CornerRadius = UDim.new(0, 7)}), borderStroke}
				)

				canvas = New(
					"CanvasGroup",
					{
						Name = "TooltipCard",
						AutomaticSize = Enum.AutomaticSize.XY,
						Size = UDim2.fromOffset(0, 0),
						GroupTransparency = 1,
						BackgroundTransparency = 0.06,
						ZIndex = 902,
						ThemeTag = {BackgroundColor3 = "DropdownHolder"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 7)}),
						borderFrame,
						New("Frame", {
							Name = "Pad",
							AutomaticSize = Enum.AutomaticSize.XY,
							Size = UDim2.fromOffset(0, 0),
							BackgroundTransparency = 1,
							ZIndex = 902
						}, {
							New("UIPadding", {PaddingLeft = UDim.new(0, 9), PaddingRight = UDim.new(0, 9), PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6)}),
							label
						})
					}
				)

				uiScale = New("UIScale", {Scale = Creator.DPIScale})
				Creator.RegisterDPIScale(uiScale)

				host = New(
					"Frame",
					{
						Name = "AcryvenTooltip",
						AutomaticSize = Enum.AutomaticSize.XY,
						Size = UDim2.fromOffset(0, 0),
						BackgroundTransparency = 1,
						Visible = false,
						ZIndex = 900,
						Parent = Library.OverlayGUI or Library.GUI
					},
					{uiScale, canvas}
				)
			end

			local function positionNear(target)
				if not host or not target or not target.Parent then
					return
				end
				local cam = Workspace.CurrentCamera
				local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
				local insetY = Creator.GetGuiInsetY()
				local usableH = math.max(160, vp.Y - insetY)
				local tPos = target.AbsolutePosition
				local tSz = target.AbsoluteSize
				local tipW = math.max(60, host.AbsoluteSize.X)
				local tipH = math.max(24, host.AbsoluteSize.Y)

				local x = tPos.X + (tSz.X - tipW) * 0.5
				x = math.clamp(x, 8, math.max(8, vp.X - tipW - 8))
				local y = tPos.Y - tipH - 8
				if y < 8 then
					y = tPos.Y + tSz.Y + 8
				end
				y = math.clamp(y, 8, math.max(8, usableH - tipH - 8))
				host.Position = UDim2.fromOffset(x, y)
			end

			function Tooltip.Hide(_self)
				hoverGen += 1
				local myGen = hoverGen
				activeTarget = nil
				if not built or not host or not host.Visible then
					return
				end
				if Creator.ReducedMotion then
					host.Visible = false
					return
				end
				Creator.SpringValue(canvas, "GroupTransparency", 1, 14, 1)
				Creator.SpringValue(borderStroke, "Transparency", 1, 15, 1)
				task.delay(0.14, function()
					if myGen == hoverGen and activeTarget == nil and host and host.Parent then
						host.Visible = false
					end
				end)
			end

			function Tooltip.Show(_self, target, text)
				if not target or not target.Parent or text == nil or tostring(text) == "" then
					return
				end
				ensureBuilt()
				activeTarget = target
				label.Text = tostring(text)
				host.Visible = true
				task.defer(function()
					if activeTarget ~= target or not host or not host.Parent then
						return
					end
					positionNear(target)
					if Creator.ReducedMotion then
						canvas.GroupTransparency = 0
						borderStroke.Transparency = 0.4
					else
						canvas.GroupTransparency = 1
						borderStroke.Transparency = 1
						Creator.SpringValue(canvas, "GroupTransparency", 0, 11, 1)
						Creator.SpringValue(borderStroke, "Transparency", 0.4, 11, 1)
					end
				end)
			end

			function Tooltip.Attach(_self, guiObject, textOrGetter, delaySeconds)
				if not guiObject then
					return
				end
				local delaySec = tonumber(delaySeconds) or 0.34
				Creator.AddSignal(guiObject.MouseEnter, function()
					hoverGen += 1
					local myGen = hoverGen
					task.delay(delaySec, function()
						if myGen ~= hoverGen or not guiObject or not guiObject.Parent then
							return
						end
						local msg = type(textOrGetter) == "function" and textOrGetter() or textOrGetter
						if msg and tostring(msg) ~= "" then
							Tooltip:Show(guiObject, msg)
						end
					end)
				end)
				Creator.AddSignal(guiObject.MouseLeave, function()
					if activeTarget == guiObject then
						Tooltip:Hide()
					else
						hoverGen += 1
					end
				end)
				Creator.AddSignal(guiObject.InputBegan, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
						Tooltip:Hide()
					end
				end)
			end

			function Tooltip.Destroy(_self)
				activeTarget = nil
				if host and host.Parent then
					host:Destroy()
				end
				host = nil
				built = false
			end

			return Tooltip
		end
	end,
	[90] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(90)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)

		local RunService = Creator.GetService("RunService")
		local New = Creator.New

		local Element = {}
		Element.__index = Element
		Element.__type = "Skeleton"

		function Element.New(parent, idx, config)
			if type(idx) == "table" and config == nil then
				config = idx
				idx = nil
			end
			config = type(config) == "table" and config or {}
			local preset = config.Preset or "Card"
			local lines = math.clamp(tonumber(config.Lines) or 3, 1, 8)
			local animated = config.Animated ~= false
			local isLoading = config.Loading ~= false
			local destroyed = false
			local shimmerPhase = 0
			local renderConn = nil
			local boneGradients = {}

			local contentLayout = New("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder})
			local contentFrame = New(
				"Frame",
				{
					Name = "SkeletonContent",
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1
				},
				{contentLayout}
			)

			local rootFrame = New(
				"Frame",
				{
					Name = "SkeletonCard",
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 0.08,
					Visible = isLoading,
					LayoutOrder = config.LayoutOrder or 7,
					Parent = parent.Container,
					ThemeTag = {BackgroundColor3 = "Element"}
				},
				{
					New("UICorner", {CornerRadius = UDim.new(0, 8)}),
					New(
						"UIStroke",
						{
							Thickness = 1,
							Transparency = 0.25,
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							ThemeTag = {Color = "ElementBorder"}
						}
					),
					New(
						"UIPadding",
						{
							PaddingTop = UDim.new(0, 12),
							PaddingBottom = UDim.new(0, 12),
							PaddingLeft = UDim.new(0, 12),
							PaddingRight = UDim.new(0, 12)
						}
					),
					contentFrame
				}
			)

			local function addBone(targetParent, sizeUDim2, radius, layoutOrder)
				local grad = New(
					"UIGradient",
					{
						Rotation = 12,
						Offset = Vector2.new(-1, 0),
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.fromRGB(215, 220, 232)),
							ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
							ColorSequenceKeypoint.new(1, Color3.fromRGB(215, 220, 232))
						}),
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0.35),
							NumberSequenceKeypoint.new(0.5, 0.05),
							NumberSequenceKeypoint.new(1, 0.35)
						})
					}
				)
				local bone = New(
					"Frame",
					{
						Name = "Bone",
						Size = sizeUDim2,
						BackgroundTransparency = 0.14,
						BorderSizePixel = 0,
						LayoutOrder = layoutOrder or 1,
						Parent = targetParent,
						ThemeTag = {BackgroundColor3 = "DialogButton"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, radius or 6)}),
						grad
					}
				)
				table.insert(boneGradients, grad)
				return bone
			end

			if preset == "Profile" then
				local topRow = New(
					"Frame",
					{
						Name = "ProfileRow",
						Size = UDim2.new(1, 0, 0, 44),
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Parent = contentFrame
					}
				)
				addBone(topRow, UDim2.fromOffset(42, 42), 999, 1)
				local infoCol = New(
					"Frame",
					{
						Name = "ProfileInfo",
						Position = UDim2.fromOffset(54, 2),
						Size = UDim2.new(1, -54, 0, 40),
						BackgroundTransparency = 1,
						Parent = topRow
					},
					{New("UIListLayout", {Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder})}
				)
				addBone(infoCol, UDim2.new(0.48, 0, 0, 14), 6, 1)
				addBone(infoCol, UDim2.new(0.72, 0, 0, 11), 5, 2)
				addBone(contentFrame, UDim2.new(0.92, 0, 0, 10), 5, 2)
			elseif preset == "Stats" then
				local gridRow = New(
					"Frame",
					{
						Name = "StatsRow",
						Size = UDim2.new(1, 0, 0, 56),
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Parent = contentFrame
					}
				)
				for i = 1, 3 do
					local statBox = New(
						"Frame",
						{
							Name = "StatCell" .. tostring(i),
							Position = UDim2.new((i - 1) / 3, (i - 1) * 3, 0, 0),
							Size = UDim2.new(1 / 3, -6, 1, 0),
							BackgroundTransparency = 0.45,
							Parent = gridRow,
							ThemeTag = {BackgroundColor3 = "Dialog"}
						},
						{
							New("UICorner", {CornerRadius = UDim.new(0, 7)}),
							New("UIPadding", {PaddingTop = UDim.new(0, 9), PaddingBottom = UDim.new(0, 9), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}),
							New("UIListLayout", {Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder})
						}
					)
					addBone(statBox, UDim2.new(0.56, 0, 0, 10), 5, 1)
					addBone(statBox, UDim2.new(0.84, 0, 0, 18), 6, 2)
				end
			elseif preset == "List" then
				for i = 1, lines do
					local row = New(
						"Frame",
						{
							Name = "ListRow" .. tostring(i),
							Size = UDim2.new(1, 0, 0, 26),
							BackgroundTransparency = 1,
							LayoutOrder = i,
							Parent = contentFrame
						}
					)
					addBone(row, UDim2.fromOffset(24, 24), 6, 1)
					local bar = addBone(row, UDim2.new(i % 2 == 0 and 0.56 or 0.72, -34, 0, 12), 5, 2)
					bar.Position = UDim2.fromOffset(34, 6)
					local badge = addBone(row, UDim2.fromOffset(48, 18), 999, 3)
					badge.AnchorPoint = Vector2.new(1, 0.5)
					badge.Position = UDim2.new(1, 0, 0.5, 0)
				end
			elseif preset == "Text" then
				local widths = {0.96, 0.84, 0.66, 0.9, 0.74, 0.58, 0.88, 0.62}
				for i = 1, lines do
					addBone(contentFrame, UDim2.new(widths[((i - 1) % #widths) + 1], 0, 0, 11), 5, i)
				end
			elseif preset == "Custom" and type(config.BuildContent) == "function" then
				pcall(config.BuildContent, contentFrame, addBone)
			else
				-- Card preset
				addBone(contentFrame, UDim2.new(0.46, 0, 0, 15), 6, 1)
				addBone(contentFrame, UDim2.new(0.88, 0, 0, 11), 5, 2)
				addBone(contentFrame, UDim2.new(0.7, 0, 0, 11), 5, 3)
				local actionStrip = New(
					"Frame",
					{
						Name = "ActionStrip",
						Size = UDim2.new(1, 0, 0, 24),
						BackgroundTransparency = 1,
						LayoutOrder = 4,
						Parent = contentFrame
					},
					{
						New("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder})
					}
				)
				addBone(actionStrip, UDim2.fromOffset(72, 22), 999, 1)
				addBone(actionStrip, UDim2.fromOffset(58, 22), 999, 2)
			end

			local function stopLoop()
				if renderConn then
					renderConn:Disconnect()
					renderConn = nil
				end
			end

			local function startLoop()
				if renderConn or destroyed or not isLoading or not animated then
					return
				end
				renderConn = RunService.RenderStepped:Connect(function(dt)
					if destroyed or not isLoading or not rootFrame.Parent then
						stopLoop()
						return
					end
					if not rootFrame.Visible then
						return
					end
					if Creator.ReducedMotion then
						for _, grad in ipairs(boneGradients) do
							grad.Offset = Vector2.new(0, 0)
						end
						return
					end
					shimmerPhase = (shimmerPhase + math.min(dt, 0.05) * 0.95) % 1
					local offsetX = -1.1 + shimmerPhase * 2.2
					for _, grad in ipairs(boneGradients) do
						grad.Offset = Vector2.new(offsetX, 0)
					end
				end)
			end

			if isLoading and animated then
				startLoop()
			end

			local SkeletonObj = {
				Type = "Skeleton",
				Loading = isLoading,
				Frame = rootFrame,
				Content = contentFrame
			}

			function SkeletonObj:SetLoading(state)
				if destroyed then
					return
				end
				isLoading = state ~= false
				SkeletonObj.Loading = isLoading
				rootFrame.Visible = isLoading
				if isLoading and animated then
					startLoop()
				else
					stopLoop()
				end
			end

			function SkeletonObj:Finish(callback)
				SkeletonObj:SetLoading(false)
				if type(callback) == "function" then
					pcall(callback)
				end
				return SkeletonObj
			end

			function SkeletonObj:Destroy()
				destroyed = true
				stopLoop()
				if rootFrame then
					rootFrame:Destroy()
				end
			end

			Creator.AddSignal(rootFrame.Destroying, function()
				destroyed = true
				stopLoop()
			end)

			return SkeletonObj
		end

		return Element
	end,
	[91] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(91)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local Icons = requireModule(Root.Icons)
		local Components = Root.Components

		local RunService = Creator.GetService("RunService")
		local New = Creator.New

		local Element = {}
		Element.__index = Element
		Element.__type = "Spinner"

		local SIZE_MAP = {
			Small = 14,
			Medium = 18,
			Large = 26
		}

		local function resolveSize(sz)
			if type(sz) == "number" then
				return math.clamp(math.floor(sz), 10, 64)
			end
			return SIZE_MAP[sz] or 18
		end

		local function resolveIcon(library, name, fallbackKey)
			if library and type(library.GetIcon) == "function" then
				local got = library:GetIcon(name)
				if got then
					return got
				end
			end
			return Icons.assets[fallbackKey] or ""
		end

		local function createIndicator(parentGui, opts)
			opts = type(opts) == "table" and opts or {}
			local variant = opts.Variant or "Ring"
			local size = resolveSize(opts.Size)
			local speed = tonumber(opts.Speed) or 1
			local active = opts.Active ~= false
			local customColor = opts.Color
			local destroyed = false
			local elapsed = 0
			local renderConn = nil

			local width = size
			local height = size
			if variant == "Dots" then
				width = math.max(30, math.floor(size * 2.15))
				height = math.max(12, size)
			elseif variant == "Bar" then
				width = math.max(76, math.floor(size * 4.2))
				height = math.max(7, math.floor(size * 0.38))
			end

			local rootProps = {
				Name = "AcryvenSpinner",
				Size = UDim2.fromOffset(width, height),
				BackgroundTransparency = variant == "Bar" and 0.14 or 1,
				Visible = active,
				ClipsDescendants = variant == "Bar",
				Parent = parentGui
			}
			if opts.AnchorPoint then
				rootProps.AnchorPoint = opts.AnchorPoint
			end
			if opts.Position then
				rootProps.Position = opts.Position
			end
			if opts.LayoutOrder then
				rootProps.LayoutOrder = opts.LayoutOrder
			end
			if opts.ZIndex then
				rootProps.ZIndex = opts.ZIndex
			end
			if variant == "Bar" then
				rootProps.ThemeTag = {BackgroundColor3 = "DialogHolder"}
			end

			local rootChildren = {}
			if variant == "Bar" then
				table.insert(rootChildren, New("UICorner", {CornerRadius = UDim.new(1, 0)}))
				table.insert(
					rootChildren,
					New(
						"UIStroke",
						{
							Thickness = 1,
							Transparency = 0.35,
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							ThemeTag = {Color = "InElementBorder"}
						}
					)
				)
			end

			local ringRotator = nil
			local ringStroke = nil
			local dots = {}
			local barFill = nil

			if variant == "Ring" then
				local trackThickness = math.max(2.2, size * 0.15)
				local track = New(
					"Frame",
					{
						Name = "Track",
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						ZIndex = opts.ZIndex
					},
					{
						New("UICorner", {CornerRadius = UDim.new(1, 0)}),
						New(
							"UIStroke",
							{
								Thickness = trackThickness,
								Transparency = 0.52,
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								ThemeTag = {Color = "ElementBorder"}
							}
						)
					}
				)

				ringStroke = New(
					"UIStroke",
					{
						Thickness = trackThickness,
						Transparency = 0,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = customColor or Color3.fromRGB(96, 165, 250),
						ThemeTag = not customColor and {Color = "Accent"} or nil
					},
					{
						New(
							"UIGradient",
							{
								Transparency = NumberSequence.new({
									NumberSequenceKeypoint.new(0, 0),
									NumberSequenceKeypoint.new(0.42, 0.15),
									NumberSequenceKeypoint.new(0.72, 0.88),
									NumberSequenceKeypoint.new(1, 1)
								})
							}
						)
					}
				)

				ringRotator = New(
					"Frame",
					{
						Name = "Arc",
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						ZIndex = (opts.ZIndex or 1) + 1
					},
					{
						New("UICorner", {CornerRadius = UDim.new(1, 0)}),
						ringStroke
					}
				)

				table.insert(rootChildren, track)
				table.insert(rootChildren, ringRotator)
			elseif variant == "Dots" then
				local dotDiam = math.max(4, math.floor(size * 0.28))
				local positions = {0.2, 0.5, 0.8}
				for i = 1, 3 do
					local dot = New(
						"Frame",
						{
							Name = "Dot" .. tostring(i),
							Size = UDim2.fromOffset(dotDiam, dotDiam),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(positions[i], 0, 0.5, 0),
							BackgroundTransparency = 0.15,
							ZIndex = opts.ZIndex,
							BackgroundColor3 = customColor or Color3.fromRGB(96, 165, 250),
							ThemeTag = not customColor and {BackgroundColor3 = "Accent"} or nil
						},
						{New("UICorner", {CornerRadius = UDim.new(1, 0)})}
					)
					table.insert(dots, dot)
					table.insert(rootChildren, dot)
				end
			elseif variant == "Bar" then
				barFill = New(
					"Frame",
					{
						Name = "BarFill",
						Size = UDim2.fromScale(0.46, 1),
						Position = UDim2.fromScale(0.04, 0),
						BackgroundTransparency = 0,
						ZIndex = (opts.ZIndex or 1) + 1,
						BackgroundColor3 = customColor or Color3.fromRGB(96, 165, 250),
						ThemeTag = not customColor and {BackgroundColor3 = "Accent"} or nil
					},
					{New("UICorner", {CornerRadius = UDim.new(1, 0)})}
				)
				table.insert(rootChildren, barFill)
			end

			local rootFrame = New("Frame", rootProps, rootChildren)

			local function stopLoop()
				if renderConn then
					renderConn:Disconnect()
					renderConn = nil
				end
			end

			local function startLoop()
				if renderConn or destroyed or not active then
					return
				end
				renderConn = RunService.RenderStepped:Connect(function(dt)
					if destroyed or not active or not rootFrame.Parent then
						stopLoop()
						return
					end
					if not rootFrame.Visible then
						return
					end
					local stepDt = math.min(dt, 0.05) * speed
					elapsed = elapsed + stepDt

					if Creator.ReducedMotion then
						if variant == "Ring" and ringRotator then
							ringRotator.Rotation = (elapsed * 90) % 360
						elseif variant == "Bar" and barFill then
							barFill.Position = UDim2.fromScale(0.29, 0)
						end
						return
					end

					if variant == "Ring" and ringRotator then
						ringRotator.Rotation = (ringRotator.Rotation + stepDt * 340) % 360
					elseif variant == "Dots" then
						local basePositions = {0.2, 0.5, 0.8}
						for i, dot in ipairs(dots) do
							local phase = elapsed * 5.2 - (i - 1) * 1.15
							local wave = math.sin(phase)
							local lift = math.max(0, wave) * math.max(2, size * 0.22)
							dot.Position = UDim2.new(basePositions[i], 0, 0.5, -lift)
							dot.BackgroundTransparency = 0.12 + (1 - (wave * 0.5 + 0.5)) * 0.52
						end
					elseif variant == "Bar" and barFill then
						local wave = 0.5 - 0.5 * math.cos(elapsed * 3.8)
						barFill.Position = UDim2.fromScale(0.04 + wave * 0.50, 0)
					end
				end)
			end

			if active then
				startLoop()
			end

			local Indicator = {
				Root = rootFrame,
				Variant = variant
			}

			function Indicator:SetActive(state)
				if destroyed then
					return
				end
				active = state ~= false
				rootFrame.Visible = active
				if active then
					startLoop()
				else
					stopLoop()
				end
			end

			function Indicator:SetColor(color)
				customColor = color
				if ringStroke then
					if color then
						Creator.OverrideTag(ringStroke, {})
						ringStroke.Color = color
					else
						Creator.OverrideTag(ringStroke, {Color = "Accent"})
					end
				end
				for _, dot in ipairs(dots) do
					if color then
						Creator.OverrideTag(dot, {})
						dot.BackgroundColor3 = color
					else
						Creator.OverrideTag(dot, {BackgroundColor3 = "Accent"})
					end
				end
				if barFill then
					if color then
						Creator.OverrideTag(barFill, {})
						barFill.BackgroundColor3 = color
					else
						Creator.OverrideTag(barFill, {BackgroundColor3 = "Accent"})
					end
				end
			end

			function Indicator:Destroy()
				destroyed = true
				stopLoop()
				if rootFrame then
					rootFrame:Destroy()
				end
			end

			return Indicator
		end

		Element.CreateIndicator = createIndicator

		function Element.New(parent, idx, config)
			if type(idx) == "table" and config == nil then
				config = idx
				idx = nil
			end
			config = type(config) == "table" and config or {}
			local variant = config.Variant or "Ring"
			local active = config.Active ~= false

			local card = requireModule(Components.Element)(config.Title or "Loading", config.Description, parent.Container, false)
			local indicator = createIndicator(card.Frame, {
				Variant = variant,
				Size = config.Size or 18,
				Speed = config.Speed or 1,
				Color = config.Color,
				Active = active,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -14, 0.5, 0)
			})

			local rightPad = variant == "Bar" and math.max(76, indicator.Root.Size.X.Offset + 24) or math.max(48, indicator.Root.Size.X.Offset + 26)
			card.TitleLabel.Size = UDim2.new(1, -rightPad, 0, 14)
			card.DescLabel.Size = UDim2.new(1, -rightPad, 0, 14)

			local stateIcon = New(
				"ImageLabel",
				{
					Name = "StateIcon",
					Size = UDim2.fromOffset(18, 18),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -14, 0.5, 0),
					BackgroundTransparency = 1,
					Visible = false,
					Parent = card.Frame
				}
			)

			local SpinnerObj = {
				Type = "Spinner",
				Value = active,
				State = active and "Loading" or "Idle",
				Frame = card.Frame,
				Indicator = indicator
			}

			function SpinnerObj:SetTitle(title)
				card:SetTitle(title)
			end

			function SpinnerObj:SetDesc(desc)
				card:SetDesc(desc)
			end

			function SpinnerObj:SetBadge(...)
				return card:SetBadge(...)
			end

			function SpinnerObj:SetActive(state)
				local on = state ~= false
				SpinnerObj.Value = on
				SpinnerObj.State = on and "Loading" or "Idle"
				stateIcon.Visible = false
				indicator:SetActive(on)
			end

			function SpinnerObj:SetLabel(title, desc)
				if title ~= nil then
					card:SetTitle(tostring(title))
				end
				if desc ~= nil then
					card:SetDesc(tostring(desc))
				end
			end

			function SpinnerObj:SetState(state, title, desc)
				if title ~= nil then
					card:SetTitle(tostring(title))
				end
				if desc ~= nil then
					card:SetDesc(tostring(desc))
				end
				SpinnerObj.State = state or "Loading"
				if SpinnerObj.State == "Loading" then
					stateIcon.Visible = false
					SpinnerObj.Value = true
					indicator:SetActive(true)
				elseif SpinnerObj.State == "Success" then
					SpinnerObj.Value = false
					indicator:SetActive(false)
					stateIcon.Image = resolveIcon(parent.Library, "check-circle-2", "lucide-check-circle-2")
					stateIcon.ImageColor3 = Color3.fromRGB(52, 211, 153)
					stateIcon.Visible = true
				elseif SpinnerObj.State == "Error" then
					SpinnerObj.Value = false
					indicator:SetActive(false)
					stateIcon.Image = resolveIcon(parent.Library, "alert-circle", "lucide-alert-circle")
					stateIcon.ImageColor3 = Color3.fromRGB(248, 113, 113)
					stateIcon.Visible = true
				else
					SpinnerObj.Value = false
					indicator:SetActive(false)
					stateIcon.Visible = false
				end
			end

			function SpinnerObj:Destroy()
				indicator:Destroy()
				if card.Destroy then
					card:Destroy()
				end
			end

			Creator.AddSignal(card.Frame.Destroying, function()
				indicator:Destroy()
			end)

			return SpinnerObj
		end

		return Element
	end,
	[92] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(92)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local Themes = requireModule(Root.Themes)

		local UserInputService = Creator.GetService("UserInputService")
		local Players = Creator.GetService("Players")
		local Workspace = Creator.GetService("Workspace")
		local New = Creator.New

		local DANGER_RED = Color3.fromRGB(248, 113, 113)
		local DANGER_BG = Color3.fromRGB(220, 38, 38)

		local LANGUAGES = {
			{Code = "en", Label = "English", Short = "EN"},
			{Code = "th", Label = "Thai", Short = "TH"},
			{Code = "vi", Label = "Vietnamese", Short = "VI"},
			{Code = "es", Label = "Spanish", Short = "ES"}
		}

		local FONT_PRESETS = {
			{Id = "default", Label = "Inter", Short = "UI"},
			{Id = "builder-sans", Label = "Builder Sans", Short = "BS"},
			{Id = "gotham", Label = "Gotham", Short = "GT"}
		}

		return function(Library)
			local Menu = {
				Opened = false,
				Destroyed = false
			}

			local built = false
			local popupWrapper, popupCard, popupShadow, popupScale, popupDpiScale
			local headerNameLbl, eyeIconBtn, eyeIconImg
			local hoverLayer, hoverPill, hoverPillStroke, rowsInner, rowsList
			local dynamicItems = {}
			local openConns = {}
			local animGen = 0
			local cardYOffset = 0
			local hoverY, hoverVisible, hoverLeaveGen = 0, false, 0

			-- Submenu state (Luaward ProfileMenu Dropdown.SubmenuTrigger equivalent)
			local submenuWrapper, submenuCard, submenuShadow, submenuScale, submenuDpiScale
			local submenuScroll, submenuLayout, submenuHoverLayer, submenuHoverPill, submenuHoverStroke
			local submenuOpened = false
			local submenuKind = nil
			local submenuAnimGen = 0
			local submenuCloseGen = 0
			local submenuXOffset = 0
			local submenuOpenedLeft = false
			local submenuHoverY, submenuHoverVisible, submenuHoverLeaveGen = 0, false, 0
			local submenuRows = {}

			local MENU_WIDTH = 246
			local SUBMENU_WIDTH = 200
			local ROW_H = 30
			local DIV_H = 9
			local ROW_GAP = 2
			local HEADER_H = 36

			local function disconnectInputConns()
				for _, c in ipairs(openConns) do
					pcall(function()
						c:Disconnect()
					end)
				end
				table.clear(openConns)
			end

			local function notifyWindowOpenState(isOpen)
				if Library.Window and type(Library.Window.SetProfileMenuOpen) == "function" then
					pcall(Library.Window.SetProfileMenuOpen, isOpen)
				end
			end

			local function getFontShortName()
				local id = Library.Fonts and Library.Fonts.CurrentProfile or "default"
				if id == "builder-sans" then return "Builder" end
				if id == "gotham" then return "Gotham" end
				return "Inter"
			end

			local function getLangShortName()
				local code = tostring(Library.CurrentLanguage or "en"):lower()
				for _, lang in ipairs(LANGUAGES) do
					if lang.Code == code then
						return lang.Short
					end
				end
				return code:upper()
			end

			local function syncHeaderAndBadges()
				if not built then
					return
				end
				local plr = Players.LocalPlayer
				local priv = type(Library.GetPrivacyMode) == "function" and Library:GetPrivacyMode() or {Hidden = false}
				if headerNameLbl then
					if priv.Hidden then
						headerNameLbl.Text = "Privacy Mode Active"
					else
						headerNameLbl.Text = "@" .. (plr and plr.Name or "player")
					end
				end
				if eyeIconImg then
					eyeIconImg.Image = Library:GetIcon(priv.Hidden and "eye" or "eye-off") or ""
					Creator.OverrideTag(eyeIconImg, {ImageColor3 = priv.Hidden and "Accent" or "SubText"})
				end
				if dynamicItems.PrivacyBadge then
					dynamicItems.PrivacyBadge.Text = priv.Hidden and "ON" or "OFF"
					Creator.OverrideTag(dynamicItems.PrivacyBadgePill, {BackgroundColor3 = priv.Hidden and "Accent" or "DialogButton"})
					dynamicItems.PrivacyBadge.TextColor3 = priv.Hidden and Creator.AutoContrast(Creator.GetThemeProperty("Accent")) or Creator.GetThemeProperty("SubText")
				end
				if dynamicItems.ThemeRight then
					dynamicItems.ThemeRight.Text = tostring(Library.Theme or "Acryven")
				end
				if dynamicItems.FontRight then
					dynamicItems.FontRight.Text = getFontShortName()
				end
				if dynamicItems.LangRight then
					dynamicItems.LangRight.Text = getLangShortName()
				end
				if dynamicItems.SidebarIcon then
					local collapsed = Library.Window and Library.Window.SidebarCollapsed == true
					dynamicItems.SidebarIcon.Image = Library:GetIcon(collapsed and "panel-left-open" or "panel-left-close") or ""
				end
			end

			local function setCardYOffset(y)
				cardYOffset = y
				if popupCard then
					popupCard.Position = UDim2.new(0, 0, 1, y)
				end
			end

			local function setSubmenuXOffset(x)
				submenuXOffset = x
				if submenuCard then
					submenuCard.Position = UDim2.new(submenuOpenedLeft and 1 or 0, x, 0, 0)
				end
			end

			local function closeSubmenu(instant)
				if not submenuOpened or not submenuWrapper then
					return
				end
				submenuAnimGen += 1
				local myGen = submenuAnimGen
				submenuOpened = false
				submenuKind = nil
				submenuHoverVisible = false
				if submenuHoverPill then
					Creator.SpringValue(submenuHoverPill, "BackgroundTransparency", 1, 6.2, 1)
				end
				if submenuHoverStroke then
					Creator.SpringValue(submenuHoverStroke, "Transparency", 1, 6.2, 1)
				end
				if instant or Creator.ReducedMotion then
					submenuWrapper.Visible = false
					return
				end
				Creator.SpringValue(submenuScale, "Scale", 0.95, 6.4, 1)
				Creator.SpringValue(submenuShadow, "ImageTransparency", 1, 6.8, 1)
				Creator.SpringValue(submenuCard, "SubX", submenuOpenedLeft and 5 or -5, 6.4, 1, setSubmenuXOffset, submenuXOffset)
				task.delay(0.13, function()
					if myGen == submenuAnimGen and not submenuOpened and submenuWrapper and submenuWrapper.Parent then
						submenuWrapper.Visible = false
					end
				end)
			end

			local function scheduleSubmenuClose()
				submenuCloseGen += 1
				local myGen = submenuCloseGen
				task.delay(0.18, function()
					if myGen == submenuCloseGen then
						closeSubmenu(false)
					end
				end)
			end

			local function cancelSubmenuClose()
				submenuCloseGen += 1
			end

			local function ensureSubmenuBuilt()
				if submenuWrapper then
					return
				end
				submenuDpiScale = New("UIScale", {Scale = Creator.DPIScale})
				submenuScale = New("UIScale", {Scale = 1})
				submenuShadow = New("ImageLabel", {
					Name = "SubShadow",
					BackgroundTransparency = 1,
					Image = "rbxassetid://5554236805",
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(23, 23, 277, 277),
					Size = UDim2.new(1, 24, 1, 24),
					Position = UDim2.fromOffset(-12, -10),
					ImageColor3 = Color3.fromRGB(0, 0, 0),
					ImageTransparency = 1,
					ZIndex = 121
				})
				submenuHoverStroke = New("UIStroke", {
					Transparency = 1,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					ThemeTag = {Color = "InElementBorder"}
				})
				submenuHoverPill = New("Frame", {
					Name = "SubHoverPill",
					Size = UDim2.new(1, -12, 0, 28),
					Position = UDim2.fromOffset(6, 0),
					BackgroundTransparency = 1,
					ZIndex = 123,
					ThemeTag = {BackgroundColor3 = "DropdownOption"}
				}, {New("UICorner", {CornerRadius = UDim.new(0, 7)}), submenuHoverStroke})

				submenuHoverLayer = New("Frame", {
					Name = "SubHoverLayer",
					Size = UDim2.new(1, 0, 1, -10),
					Position = UDim2.fromOffset(0, 5),
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					ZIndex = 123
				}, {submenuHoverPill})

				submenuLayout = New("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder})
				submenuScroll = New("ScrollingFrame", {
					Name = "SubScroll",
					Position = UDim2.fromOffset(0, 5),
					Size = UDim2.new(1, 0, 1, -10),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarThickness = 3,
					ScrollBarImageTransparency = 0.45,
					CanvasSize = UDim2.fromOffset(0, 0),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					ZIndex = 124,
					ThemeTag = {ScrollBarImageColor3 = "Accent"}
				}, {
					submenuLayout,
					New("UIPadding", {PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingTop = UDim.new(0, 1), PaddingBottom = UDim.new(0, 1)})
				})

				submenuCard = New("Frame", {
					Name = "SubmenuCard",
					AnchorPoint = Vector2.new(0, 0),
					Position = UDim2.fromScale(0, 0),
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 0.02,
					Active = true,
					ClipsDescendants = true,
					ZIndex = 122,
					ThemeTag = {BackgroundColor3 = "DropdownHolder"}
				}, {
					submenuScale,
					New("UICorner", {CornerRadius = UDim.new(0, 10)}),
					New("UIStroke", {Thickness = 1.1, Transparency = 0.18, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "DropdownBorder"}}),
					submenuHoverLayer,
					submenuScroll
				})

				submenuWrapper = New("Frame", {
					Name = "AcryvenProfileSubmenu",
					Size = UDim2.fromOffset(SUBMENU_WIDTH, 120),
					BackgroundTransparency = 1,
					Visible = false,
					ZIndex = 121,
					Parent = Library.OverlayGUI or Library.GUI
				}, {submenuDpiScale, submenuShadow, submenuCard})

				Creator.AddSignal(submenuCard.MouseEnter, function()
					cancelSubmenuClose()
				end)
				Creator.AddSignal(submenuCard.MouseLeave, function()
					submenuHoverLeaveGen += 1
					local myGen = submenuHoverLeaveGen
					task.delay(0.03, function()
						if myGen == submenuHoverLeaveGen then
							submenuHoverVisible = false
							Creator.SpringValue(submenuHoverPill, "BackgroundTransparency", 1, 5.5, 1)
							Creator.SpringValue(submenuHoverStroke, "Transparency", 1, 5.5, 1)
						end
					end)
					scheduleSubmenuClose()
				end)
				Creator.RegisterDPIScale(submenuDpiScale, function(s)
					submenuDpiScale.Scale = s
					if submenuOpened then
						closeSubmenu(true)
					end
				end)
			end

			local function openSubmenu(kind, triggerBtn)
				if Menu.Destroyed or not Menu.Opened then
					return
				end
				ensureSubmenuBuilt()
				cancelSubmenuClose()
				if submenuOpened and submenuKind == kind then
					return
				end
				submenuKind = kind

				for _, child in ipairs(submenuScroll:GetChildren()) do
					if child:IsA("GuiObject") then
						child:Destroy()
					end
				end
				table.clear(submenuRows)

				local items = {}
				if kind == "theme" then
					for _, themeName in ipairs(Library.Themes or {}) do
						local tData = Themes[themeName]
						local accentCol = (type(tData) == "table" and typeof(tData.Accent) == "Color3") and tData.Accent or nil
						table.insert(items, {
							Id = themeName,
							Label = tostring(themeName),
							Swatch = accentCol,
							Selected = (Library.Theme == themeName),
							OnPick = function()
								Library:SetTheme(themeName)
								syncHeaderAndBadges()
								if Library.SettingsModal and Library.SettingsModal.Opened then
									Library.SettingsModal:SyncValues()
								end
							end
						})
					end
				elseif kind == "font" then
					local curFont = Library.Fonts and Library.Fonts.CurrentProfile or "default"
					for _, f in ipairs(FONT_PRESETS) do
						table.insert(items, {
							Id = f.Id,
							Label = f.Label,
							Hint = f.Short,
							Selected = (curFont == f.Id),
							OnPick = function()
								if type(Library.SetFont) == "function" then
									Library:SetFont(f.Id)
								end
								syncHeaderAndBadges()
								if Library.SettingsModal and Library.SettingsModal.Opened then
									Library.SettingsModal:SyncValues()
								end
							end
						})
					end
				elseif kind == "language" then
					local curLang = tostring(Library.CurrentLanguage or "en"):lower()
					for _, lang in ipairs(LANGUAGES) do
						table.insert(items, {
							Id = lang.Code,
							Label = lang.Label,
							Hint = lang.Short,
							Selected = (curLang == lang.Code),
							OnPick = function()
								Library.CurrentLanguage = lang.Code
								if Library.I18n and type(Library.I18n.SetLanguage) == "function" then
									Library.I18n:SetLanguage(lang.Code)
								end
								syncHeaderAndBadges()
								if Library.SettingsModal and Library.SettingsModal.Opened then
									Library.SettingsModal:SyncValues()
								end
							end
						})
					end
				end

				local checkIconAsset = Library:GetIcon("check") or ""
				local function refreshSubSelection(pickedId)
					for _, r in ipairs(submenuRows) do
						local sel = (r.Id == pickedId)
						if sel ~= r.Selected then
							r.Selected = sel
							r.Label.FontFace = Creator.Font(sel and Enum.FontWeight.SemiBold or Enum.FontWeight.Medium)
							if sel then
								r.Check.Visible = true
								r.CheckScale.Scale = 0.4
								Creator.SpringValue(r.CheckScale, "Scale", 1, 4.6, 0.62)
								Creator.SpringValue(r.Check, "ImageTransparency", 0, 5.2, 1)
							else
								Creator.SpringValue(r.CheckScale, "Scale", 0.4, 5.8, 1)
								Creator.SpringValue(r.Check, "ImageTransparency", 1, 5.8, 1)
								local chk = r.Check
								task.delay(0.16, function()
									if not r.Selected and chk and chk.Parent then
										chk.Visible = false
									end
								end)
							end
						end
					end
				end

				for i, item in ipairs(items) do
					local checkScale = New("UIScale", {Scale = item.Selected and 1 or 0.4})
					local checkImg = New("ImageLabel", {
						Name = "Check",
						Image = checkIconAsset,
						Size = UDim2.fromOffset(13, 13),
						Position = UDim2.new(0, 7, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						ImageTransparency = item.Selected and 0 or 1,
						Visible = item.Selected,
						ZIndex = 126,
						ThemeTag = {ImageColor3 = "Accent"}
					}, {checkScale})

					local textLeft = 26
					local rowKids = {New("UICorner", {CornerRadius = UDim.new(0, 7)}), checkImg}
					if item.Swatch then
						table.insert(rowKids, New("Frame", {
							Name = "Swatch",
							Size = UDim2.fromOffset(9, 9),
							Position = UDim2.new(0, 26, 0.5, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundColor3 = item.Swatch,
							ZIndex = 126
						}, {New("UICorner", {CornerRadius = UDim.new(1, 0)})}))
						textLeft = 41
					end

					local lbl = New("TextLabel", {
						Name = "Label",
						Text = item.Label,
						I18nSkip = true,
						FontFace = Creator.Font(item.Selected and Enum.FontWeight.SemiBold or Enum.FontWeight.Medium),
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Position = UDim2.new(0, textLeft, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						Size = UDim2.new(1, -(textLeft + (item.Hint and 34 or 10)), 0, 18),
						BackgroundTransparency = 1,
						ZIndex = 126,
						ThemeTag = {TextColor3 = "Text"}
					})
					table.insert(rowKids, lbl)

					if item.Hint then
						table.insert(rowKids, New("TextLabel", {
							Name = "Hint",
							Text = item.Hint,
							I18nSkip = true,
							FontFace = Creator.Font(Enum.FontWeight.Medium),
							TextSize = 10,
							TextXAlignment = Enum.TextXAlignment.Right,
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -8, 0.5, 0),
							Size = UDim2.fromOffset(26, 16),
							BackgroundTransparency = 1,
							ZIndex = 126,
							ThemeTag = {TextColor3 = "SubText"}
						}))
					end

					local rScale = New("UIScale", {Scale = 1})
					table.insert(rowKids, rScale)

					local btn = New("TextButton", {
						Name = "Sub_" .. tostring(i),
						Text = "",
						AutoButtonColor = false,
						Size = UDim2.new(1, 0, 0, 28),
						BackgroundTransparency = 1,
						LayoutOrder = i,
						ZIndex = 125,
						Parent = submenuScroll
					}, rowKids)

					Creator.AddSignal(btn.MouseEnter, function()
						cancelSubmenuClose()
						submenuHoverLeaveGen += 1
						local scale = Creator.GetEffectiveScale(submenuScroll)
						local targetY = (btn.AbsolutePosition.Y - submenuScroll.AbsolutePosition.Y) / scale
						if not submenuHoverVisible then
							submenuHoverVisible = true
							Creator.CancelSpring(submenuHoverPill, "SubHoverY")
							submenuHoverY = targetY
							submenuHoverPill.Position = UDim2.fromOffset(6, targetY)
						else
							Creator.SpringValue(submenuHoverPill, "SubHoverY", targetY, 5.2, 0.88, function(y)
								submenuHoverY = y
								submenuHoverPill.Position = UDim2.fromOffset(6, y)
							end, submenuHoverY)
						end
						Creator.SpringValue(submenuHoverPill, "BackgroundTransparency", 0.74, 5.5, 1)
						Creator.SpringValue(submenuHoverStroke, "Transparency", 0.52, 5.5, 1)
					end)
					Creator.AddSignal(btn.MouseLeave, function()
						Creator.SpringValue(rScale, "Scale", 1, 6.0, 0.85)
					end)
					Creator.AddSignal(btn.MouseButton1Down, function()
						Creator.SpringValue(rScale, "Scale", 0.98, 6.5, 0.9)
					end)
					Creator.AddSignal(btn.MouseButton1Up, function()
						Creator.SpringValue(rScale, "Scale", 1, 5.5, 0.8)
					end)
					Creator.AddSignal(btn.MouseButton1Click, function()
						refreshSubSelection(item.Id)
						if type(item.OnPick) == "function" then
							item.OnPick()
						end
					end)

					table.insert(submenuRows, {Id = item.Id, Selected = item.Selected, Check = checkImg, CheckScale = checkScale, Label = lbl})
				end

				-- Deterministic submenu height & positioning beside trigger row
				local contentH = (#items * 28) + (math.max(0, #items - 1) * 2) + 4
				local panelH = math.clamp(contentH + 10, 46, 268)
				submenuScroll.CanvasSize = UDim2.fromOffset(0, contentH)
				submenuScroll.CanvasPosition = Vector2.new(0, 0)
				submenuWrapper.Size = UDim2.fromOffset(SUBMENU_WIDTH, panelH)

				local cam = Workspace.CurrentCamera
				local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
				local insetY = Creator.GetGuiInsetY()
				local usableW = vp.X
				local usableH = math.max(200, vp.Y - insetY)
				local dpi = math.max(0.01, Creator.DPIScale or 1)
				local scaledSubW = SUBMENU_WIDTH * dpi
				local scaledSubH = panelH * dpi

				local cardPos = popupCard.AbsolutePosition
				local cardSz = popupCard.AbsoluteSize
				local rowY = (triggerBtn and triggerBtn.Parent) and triggerBtn.AbsolutePosition.Y or cardPos.Y

				local rightX = cardPos.X + cardSz.X + 6
				local leftX = cardPos.X - scaledSubW - 6
				local targetX
				if rightX + scaledSubW <= usableW - 10 or leftX < 10 then
					submenuOpenedLeft = false
					targetX = math.clamp(rightX, 10, math.max(10, usableW - scaledSubW - 10))
				else
					submenuOpenedLeft = true
					targetX = math.clamp(leftX, 10, math.max(10, usableW - scaledSubW - 10))
				end
				local targetY = math.clamp(rowY - 6, 10, math.max(10, usableH - scaledSubH - 10))
				submenuWrapper.Position = UDim2.fromOffset(targetX, targetY)
				submenuCard.AnchorPoint = Vector2.new(submenuOpenedLeft and 1 or 0, 0)

				submenuAnimGen += 1
				submenuOpened = true
				submenuWrapper.Visible = true
				submenuHoverVisible = false
				submenuHoverPill.BackgroundTransparency = 1
				submenuHoverStroke.Transparency = 1

				if Creator.ReducedMotion then
					submenuScale.Scale = 1
					submenuShadow.ImageTransparency = 0.52
					setSubmenuXOffset(0)
				else
					local startX = submenuOpenedLeft and 6 or -6
					submenuScale.Scale = 0.94
					submenuShadow.ImageTransparency = 1
					setSubmenuXOffset(startX)
					Creator.SpringValue(submenuScale, "Scale", 1, 5.2, 0.86)
					Creator.SpringValue(submenuShadow, "ImageTransparency", 0.52, 5.5, 1)
					Creator.SpringValue(submenuCard, "SubX", 0, 5.2, 0.88, setSubmenuXOffset, startX)
				end
			end

			local function positionAboveAnchor(anchorGui)
				if not popupWrapper then
					return
				end
				local cam = Workspace.CurrentCamera
				local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
				local insetY = Creator.GetGuiInsetY()
				local scale = math.max(0.01, Creator.DPIScale or 1)
				local usableW = vp.X
				local usableH = math.max(200, vp.Y - insetY)

				local menuW = MENU_WIDTH * scale
				local menuH = popupWrapper.Size.Y.Offset * scale
				local targetX = 16
				local targetBotY = usableH - 16

				if anchorGui and typeof(anchorGui) == "Instance" and anchorGui.Parent then
					local aPos = anchorGui.AbsolutePosition
					local aSz = anchorGui.AbsoluteSize
					targetX = aPos.X
					targetBotY = aPos.Y - 8
					if targetBotY - menuH < 10 then
						targetX = aPos.X + aSz.X + 8
						targetBotY = math.min(usableH - 10, aPos.Y + aSz.Y)
					end
				end

				local clampedX = math.clamp(targetX, 10, math.max(10, usableW - menuW - 10))
				local clampedBotY = math.clamp(targetBotY, menuH + 10, math.max(menuH + 10, usableH - 10))
				popupWrapper.Position = UDim2.fromOffset(clampedX, clampedBotY)
			end

			local function ensureBuilt()
				if built or Menu.Destroyed then
					return
				end
				built = true

				popupDpiScale = New("UIScale", {Scale = Creator.DPIScale})
				popupScale = New("UIScale", {Scale = 1})

				popupShadow = New(
					"ImageLabel",
					{
						Name = "Shadow",
						BackgroundTransparency = 1,
						Image = "rbxassetid://5554236805",
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(23, 23, 277, 277),
						Size = UDim2.new(1, 28, 1, 28),
						Position = UDim2.fromOffset(-14, -10),
						ImageColor3 = Color3.fromRGB(0, 0, 0),
						ImageTransparency = 1,
						ZIndex = 114
					}
				)

				headerNameLbl = New("TextLabel", {
					Name = "AccountName",
					Text = "@player",
					I18nSkip = true,
					FontFace = Creator.Font(Enum.FontWeight.Medium),
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Position = UDim2.fromOffset(12, 0),
					Size = UDim2.new(1, -46, 1, 0),
					BackgroundTransparency = 1,
					ZIndex = 116,
					ThemeTag = {TextColor3 = "SubText"}
				})

				eyeIconImg = New("ImageLabel", {
					Name = "EyeIcon",
					Image = Library:GetIcon("eye-off") or "",
					Size = UDim2.fromOffset(14, 14),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					BackgroundTransparency = 1,
					ZIndex = 117,
					ThemeTag = {ImageColor3 = "SubText"}
				})
				eyeIconBtn = New(
					"TextButton",
					{
						Name = "QuickPrivacyToggle",
						Text = "",
						AutoButtonColor = false,
						Size = UDim2.fromOffset(26, 26),
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -8, 0.5, 0),
						BackgroundTransparency = 0.72,
						ZIndex = 116,
						ThemeTag = {BackgroundColor3 = "DialogButton"}
					},
					{New("UICorner", {CornerRadius = UDim.new(0, 7)}), eyeIconImg}
				)
				Creator.AddSignal(eyeIconBtn.MouseEnter, function()
					Creator.SpringValue(eyeIconBtn, "BackgroundTransparency", 0.32, 5.2, 1)
				end)
				Creator.AddSignal(eyeIconBtn.MouseLeave, function()
					Creator.SpringValue(eyeIconBtn, "BackgroundTransparency", 0.72, 5.2, 1)
				end)
				Creator.AddSignal(eyeIconBtn.MouseButton1Click, function()
					if type(Library.SetPrivacyMode) == "function" then
						local cur = Library:GetPrivacyMode()
						Library:SetPrivacyMode(not cur.Hidden, cur.Alias, cur.HideAvatar)
						syncHeaderAndBadges()
					end
				end)

				local headerBar = New(
					"Frame",
					{Name = "Header", Size = UDim2.new(1, 0, 0, HEADER_H), BackgroundTransparency = 1, ZIndex = 116},
					{
						headerNameLbl,
						eyeIconBtn,
						New("Frame", {
							Name = "Sep",
							Size = UDim2.new(1, -12, 0, 1),
							Position = UDim2.new(0, 6, 1, -1),
							BackgroundTransparency = 0.55,
							ZIndex = 116,
							ThemeTag = {BackgroundColor3 = "TitleBarLine"}
						})
					}
				)

				-- Keep hoverPill in its OWN layer (separate from rowsInner's UIListLayout!)
				-- so UIListLayout never hijacks hoverPill's Position or shifts rows downward.
				hoverPillStroke = New("UIStroke", {Transparency = 1, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "InElementBorder"}})
				hoverPill = New(
					"Frame",
					{
						Name = "MenuHoverPill",
						Size = UDim2.new(1, 0, 0, ROW_H),
						Position = UDim2.fromOffset(0, 0),
						BackgroundTransparency = 1,
						ZIndex = 116,
						ThemeTag = {BackgroundColor3 = "DropdownOption"}
					},
					{New("UICorner", {CornerRadius = UDim.new(0, 7)}), hoverPillStroke}
				)
				hoverLayer = New("Frame", {
					Name = "HoverLayer",
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					ZIndex = 116
				}, {hoverPill})

				rowsList = New("UIListLayout", {Padding = UDim.new(0, ROW_GAP), SortOrder = Enum.SortOrder.LayoutOrder})
				rowsInner = New("Frame", {
					Name = "RowsInner",
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					ZIndex = 117
				}, {rowsList})

				local rowsViewport = New(
					"Frame",
					{
						Name = "RowsViewport",
						Position = UDim2.fromOffset(6, HEADER_H + 5),
						Size = UDim2.new(1, -12, 1, -(HEADER_H + 11)),
						BackgroundTransparency = 1,
						ZIndex = 116
					},
					{hoverLayer, rowsInner}
				)

				local rowOrder = 0
				local itemCount = 0
				local divCount = 0

				local function addDivider()
					rowOrder += 1
					divCount += 1
					New(
						"Frame",
						{
							Name = "Div_" .. tostring(rowOrder),
							Size = UDim2.new(1, 0, 0, DIV_H),
							BackgroundTransparency = 1,
							LayoutOrder = rowOrder,
							ZIndex = 117,
							Parent = rowsInner
						},
						{
							New("Frame", {
								Size = UDim2.new(1, -8, 0, 1),
								Position = UDim2.new(0, 4, 0.5, 0),
								BackgroundTransparency = 0.55,
								ZIndex = 117,
								ThemeTag = {BackgroundColor3 = "TitleBarLine"}
							})
						}
					)
				end

				local function addMenuItem(spec)
					rowOrder += 1
					itemCount += 1
					local isDanger = spec.Danger == true
					local iconImg = New("ImageLabel", {
						Name = "Icon",
						Image = Library:GetIcon(spec.Icon) or "",
						Size = UDim2.fromOffset(15, 15),
						Position = UDim2.new(0, 8, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						ImageColor3 = isDanger and DANGER_RED or Color3.new(1, 1, 1),
						ZIndex = 118,
						ThemeTag = (not isDanger) and {ImageColor3 = "SubText"} or nil
					})
					local label = New("TextLabel", {
						Name = "Title",
						Text = spec.Title,
						FontFace = Creator.Font(Enum.FontWeight.Medium),
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Position = UDim2.new(0, 30, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						Size = UDim2.new(1, -94, 0, 18),
						BackgroundTransparency = 1,
						TextColor3 = isDanger and DANGER_RED or Color3.new(1, 1, 1),
						ZIndex = 118,
						ThemeTag = (not isDanger) and {TextColor3 = "Text"} or nil
					})

					local rowScale = New("UIScale", {Scale = 1})
					local rowChildren = {rowScale, New("UICorner", {CornerRadius = UDim.new(0, 7)}), iconImg, label}
					if spec.Hint then
						table.insert(rowChildren, New("TextLabel", {
							Name = "Hint",
							Text = spec.Hint,
							I18nSkip = true,
							FontFace = Creator.Font(Enum.FontWeight.Medium),
							TextSize = 10,
							TextXAlignment = Enum.TextXAlignment.Right,
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -8, 0.5, 0),
							Size = UDim2.fromOffset(48, 16),
							BackgroundTransparency = 1,
							ZIndex = 118,
							ThemeTag = {TextColor3 = "SubText"}
						}))
					elseif spec.RightTag then
						local chev = New("ImageLabel", {
							Image = Library:GetIcon("chevron-right") or "",
							Size = UDim2.fromOffset(13, 13),
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -6, 0.5, 0),
							BackgroundTransparency = 1,
							ZIndex = 118,
							ThemeTag = {ImageColor3 = "SubText"}
						})
						local valLbl = New("TextLabel", {
							Name = "RightVal",
							Text = "",
							I18nSkip = true,
							FontFace = Creator.Font(Enum.FontWeight.Medium),
							TextSize = 11,
							TextXAlignment = Enum.TextXAlignment.Right,
							TextTruncate = Enum.TextTruncate.AtEnd,
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -21, 0.5, 0),
							Size = UDim2.fromOffset(72, 16),
							BackgroundTransparency = 1,
							ZIndex = 118,
							ThemeTag = {TextColor3 = "SubText"}
						})
						dynamicItems[spec.RightTag] = valLbl
						table.insert(rowChildren, valLbl)
						table.insert(rowChildren, chev)
					elseif spec.BadgeTag then
						local bLbl = New("TextLabel", {
							Text = "OFF",
							I18nSkip = true,
							FontFace = Creator.Font(Enum.FontWeight.Bold),
							TextSize = 9,
							AutomaticSize = Enum.AutomaticSize.X,
							Size = UDim2.new(0, 0, 1, 0),
							BackgroundTransparency = 1,
							ZIndex = 119
						})
						local bPill = New("Frame", {
							AutomaticSize = Enum.AutomaticSize.X,
							Size = UDim2.fromOffset(0, 17),
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -8, 0.5, 0),
							BackgroundTransparency = 0.14,
							ZIndex = 118,
							ThemeTag = {BackgroundColor3 = "DialogButton"}
						}, {
							New("UICorner", {CornerRadius = UDim.new(1, 0)}),
							New("UIPadding", {PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}),
							bLbl
						})
						dynamicItems[spec.BadgeTag] = bLbl
						dynamicItems[spec.BadgeTag .. "Pill"] = bPill
						table.insert(rowChildren, bPill)
					end

					local btn = New(
						"TextButton",
						{
							Name = "MenuItem_" .. tostring(rowOrder),
							Text = "",
							AutoButtonColor = false,
							Size = UDim2.new(1, 0, 0, ROW_H),
							BackgroundTransparency = 1,
							LayoutOrder = rowOrder,
							ZIndex = 117,
							Parent = rowsInner
						},
						rowChildren
					)
					if spec.IconTag then
						dynamicItems[spec.IconTag] = iconImg
					end

					Creator.AddSignal(btn.MouseEnter, function()
						hoverLeaveGen += 1
						local scale = Creator.GetEffectiveScale(rowsInner)
						local targetY = (btn.AbsolutePosition.Y - rowsInner.AbsolutePosition.Y) / scale
						if isDanger then
							Creator.OverrideTag(hoverPill, {})
							hoverPill.BackgroundColor3 = DANGER_BG
							Creator.OverrideTag(hoverPillStroke, {})
							hoverPillStroke.Color = DANGER_RED
						else
							Creator.OverrideTag(hoverPill, {BackgroundColor3 = "DropdownOption"})
							Creator.OverrideTag(hoverPillStroke, {Color = "InElementBorder"})
						end
						if not hoverVisible then
							hoverVisible = true
							Creator.CancelSpring(hoverPill, "HoverY")
							hoverY = targetY
							hoverPill.Position = UDim2.fromOffset(0, targetY)
						else
							Creator.SpringValue(hoverPill, "HoverY", targetY, 5.2, 0.88, function(y)
								hoverY = y
								hoverPill.Position = UDim2.fromOffset(0, y)
							end, hoverY)
						end
						Creator.SpringValue(hoverPill, "BackgroundTransparency", isDanger and 0.78 or 0.74, 5.5, 1)
						Creator.SpringValue(hoverPillStroke, "Transparency", 0.50, 5.5, 1)
						if spec.Submenu then
							openSubmenu(spec.Submenu, btn)
						else
							scheduleSubmenuClose()
						end
					end)
					Creator.AddSignal(btn.MouseLeave, function()
						Creator.SpringValue(rowScale, "Scale", 1, 6.0, 0.85)
						hoverLeaveGen += 1
						local myGen = hoverLeaveGen
						task.delay(0.03, function()
							if myGen == hoverLeaveGen then
								hoverVisible = false
								Creator.SpringValue(hoverPill, "BackgroundTransparency", 1, 5.5, 1)
								Creator.SpringValue(hoverPillStroke, "Transparency", 1, 5.5, 1)
							end
						end)
					end)
					Creator.AddSignal(btn.MouseButton1Down, function()
						Creator.SpringValue(rowScale, "Scale", 0.98, 6.5, 0.9)
					end)
					Creator.AddSignal(btn.MouseButton1Up, function()
						Creator.SpringValue(rowScale, "Scale", 1, 5.5, 0.8)
					end)
					Creator.AddSignal(btn.MouseButton1Click, function()
						if spec.Submenu then
							openSubmenu(spec.Submenu, btn)
							return
						end
						if spec.KeepOpen then
							if type(spec.Callback) == "function" then
								spec.Callback()
							end
							syncHeaderAndBadges()
						else
							Menu:Close()
							if type(spec.Callback) == "function" then
								task.defer(spec.Callback)
							end
						end
					end)
				end

				addMenuItem({Title = "Settings", Icon = "settings", Hint = "Ctrl+,", Callback = function()
					if type(Library.OpenSettings) == "function" then Library:OpenSettings("General") end
				end})
				addMenuItem({Title = "Hide Name", Icon = "eye-off", BadgeTag = "PrivacyBadge", KeepOpen = true, Callback = function()
					if type(Library.SetPrivacyMode) == "function" then
						local cur = Library:GetPrivacyMode()
						Library:SetPrivacyMode(not cur.Hidden, cur.Alias, cur.HideAvatar)
					end
				end})
				addMenuItem({Title = "Language", Icon = "globe", RightTag = "LangRight", Submenu = "language"})
				addMenuItem({Title = "Theme", Icon = "palette", RightTag = "ThemeRight", Submenu = "theme"})
				addMenuItem({Title = "Font", Icon = "type", RightTag = "FontRight", Submenu = "font"})
				addDivider()
				addMenuItem({Title = "Command Palette", Icon = "search", Hint = "Ctrl+K", Callback = function()
					Library:OpenCommandPalette()
				end})
				addMenuItem({Title = "Toggle Sidebar", Icon = "panel-left-close", IconTag = "SidebarIcon", Hint = "Ctrl+B", Callback = function()
					if Library.Window then Library.Window:ToggleSidebar() end
				end})
				addMenuItem({Title = "Minimize Window", Icon = "minimize-2", Callback = function()
					if Library.Window then Library.Window:Minimize() end
				end})
				addDivider()
				addMenuItem({Title = "Unload Interface", Icon = "log-out", Danger = true, Callback = function()
					if Library.Window then
						Library.Window:Dialog({
							Title = "Unload Interface",
							Content = "Are you sure you want to unload Acryven?",
							Buttons = {
								{Title = "Yes", Callback = function() Library:Destroy() end},
								{Title = "No"}
							}
						})
					else
						Library:Destroy()
					end
				end})

				-- Deterministic exact height (never reads 0 from unparented UIListLayout!)
				local totalRows = itemCount + divCount
				local exactRowsH = (itemCount * ROW_H) + (divCount * DIV_H) + (math.max(0, totalRows - 1) * ROW_GAP)
				local totalH = HEADER_H + 5 + exactRowsH + 7

				popupCard = New(
					"Frame",
					{
						Name = "MenuCard",
						AnchorPoint = Vector2.new(0, 1),
						Position = UDim2.fromScale(0, 1),
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 0.02,
						Active = true,
						ClipsDescendants = true,
						ZIndex = 115,
						ThemeTag = {BackgroundColor3 = "DropdownHolder"}
					},
					{
						popupScale,
						New("UICorner", {CornerRadius = UDim.new(0, 11)}),
						New("UIStroke", {Thickness = 1.1, Transparency = 0.18, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "DropdownBorder"}}),
						headerBar,
						rowsViewport
					}
				)

				popupWrapper = New(
					"Frame",
					{
						Name = "AcryvenProfileMenu",
						AnchorPoint = Vector2.new(0, 1),
						Size = UDim2.fromOffset(MENU_WIDTH, totalH),
						BackgroundTransparency = 1,
						Visible = false,
						ZIndex = 114,
						Parent = Library.OverlayGUI or Library.GUI
					},
					{popupDpiScale, popupShadow, popupCard}
				)

				Creator.RegisterDPIScale(popupDpiScale, function(s)
					popupDpiScale.Scale = s
					if Menu.Opened then
						positionAboveAnchor(Menu._LastAnchor)
						closeSubmenu(true)
					end
				end)
			end

			function Menu:Open(anchorGui)
				if Menu.Destroyed or Library.Unloaded then
					return
				end
				ensureBuilt()
				Menu._LastAnchor = anchorGui
				if type(Library._CloseDropdowns) == "function" then
					Library._CloseDropdowns()
				end
				syncHeaderAndBadges()
				positionAboveAnchor(anchorGui)
				animGen += 1
				Menu.Opened = true
				popupWrapper.Visible = true
				notifyWindowOpenState(true)
				hoverVisible = false
				hoverPill.BackgroundTransparency = 1
				hoverPillStroke.Transparency = 1
				closeSubmenu(true)

				if Creator.ReducedMotion then
					popupScale.Scale = 1
					popupShadow.ImageTransparency = 0.52
					setCardYOffset(0)
				else
					-- Luaward HeroUI Popover top-start entrance: scale 0.93->1 + slide-in-from-bottom (+6->0)
					popupScale.Scale = 0.93
					popupShadow.ImageTransparency = 1
					setCardYOffset(6)
					Creator.SpringValue(popupScale, "Scale", 1, 5.0, 0.86)
					Creator.SpringValue(popupShadow, "ImageTransparency", 0.52, 5.4, 1)
					Creator.SpringValue(popupCard, "CardY", 0, 5.0, 0.88, setCardYOffset, 6)
				end

				disconnectInputConns()
				table.insert(openConns, UserInputService.InputBegan:Connect(function(input)
					if not Menu.Opened then
						return
					end
					if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Escape then
						Menu:Close()
						return
					end
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						local p = input.Position
						local cardPos, cardSz = popupCard.AbsolutePosition, popupCard.AbsoluteSize
						local inMenu = p.X >= cardPos.X and p.X <= cardPos.X + cardSz.X and p.Y >= cardPos.Y and p.Y <= cardPos.Y + cardSz.Y
						local inSub = false
						if submenuOpened and submenuCard and submenuCard.Parent then
							local sPos, sSz = submenuCard.AbsolutePosition, submenuCard.AbsoluteSize
							inSub = p.X >= sPos.X and p.X <= sPos.X + sSz.X and p.Y >= sPos.Y and p.Y <= sPos.Y + sSz.Y
						end
						local inAnchor = false
						if anchorGui and typeof(anchorGui) == "Instance" and anchorGui.Parent then
							local aPos, aSz = anchorGui.AbsolutePosition, anchorGui.AbsoluteSize
							inAnchor = p.X >= aPos.X and p.X <= aPos.X + aSz.X and p.Y >= aPos.Y and p.Y <= aPos.Y + aSz.Y
						end
						if not inMenu and not inSub and not inAnchor then
							Menu:Close()
						end
					end
				end))
			end

			function Menu:Close()
				if not Menu.Opened or not built then
					return
				end
				animGen += 1
				local myGen = animGen
				Menu.Opened = false
				notifyWindowOpenState(false)
				disconnectInputConns()
				closeSubmenu(false)
				if Creator.ReducedMotion then
					popupWrapper.Visible = false
				else
					Creator.SpringValue(popupScale, "Scale", 0.95, 6.4, 1)
					Creator.SpringValue(popupShadow, "ImageTransparency", 1, 6.8, 1)
					Creator.SpringValue(popupCard, "CardY", 4, 6.4, 1, setCardYOffset, cardYOffset)
					task.delay(0.14, function()
						if myGen == animGen and not Menu.Opened and popupWrapper and popupWrapper.Parent then
							popupWrapper.Visible = false
						end
					end)
				end
			end

			function Menu:Toggle(anchorGui)
				if Menu.Opened then
					Menu:Close()
				else
					Menu:Open(anchorGui)
				end
			end

			function Menu:Refresh()
				syncHeaderAndBadges()
			end

			function Menu:Destroy()
				Menu.Destroyed = true
				Menu.Opened = false
				notifyWindowOpenState(false)
				disconnectInputConns()
				if submenuWrapper then
					pcall(function()
						submenuWrapper:Destroy()
					end)
					submenuWrapper = nil
				end
				if popupWrapper then
					pcall(function()
						popupWrapper:Destroy()
					end)
					popupWrapper = nil
				end
			end

			return Menu
		end
	end,
	[93] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(93)
		local Root = moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)

		local UserInputService = Creator.GetService("UserInputService")
		local Lighting = Creator.GetService("Lighting")
		local Workspace = Creator.GetService("Workspace")
		local New = Creator.New

		local protectGui = protectgui or (syn and syn.protect_gui) or function() end

		local DANGER_RED = Color3.fromRGB(248, 113, 113)
		local DANGER_BG = Color3.fromRGB(220, 38, 38)

		local NAV_GROUPS = {
			{
				Label = "PREFERENCES",
				Items = {
					{
						Id = "General",
						Title = "General",
						Subtitle = "Language, typography, motion, and UI scaling",
						Icon = "settings",
						Keywords = "general language font typography inter gotham builder scale dpi motion reduced"
					},
					{
						Id = "Appearance",
						Title = "Appearance",
						Subtitle = "Themes, glass surface, and 3D acrylic blur",
						Icon = "palette",
						Keywords = "appearance theme color acrylic blur glass transparency dark light oklab"
					},
					{
						Id = "Layout & HUD",
						Title = "Layout & HUD",
						Subtitle = "Sidebar rail, notifications, floating pill, and overlays",
						Icon = "sliders-horizontal",
						Keywords = "layout hud sidebar rail notification toast corner pill watermark keybind"
					},
					{
						Id = "Privacy",
						Title = "Privacy",
						Subtitle = "Streamer mode, username masking, and avatar protection",
						Icon = "shield",
						Keywords = "privacy streamer hide name username avatar alias anonymous mask"
					}
				}
			},
			{
				Label = "SYSTEM",
				Items = {
					{
						Id = "Controls",
						Title = "Controls",
						Subtitle = "Window toggle keybind and keyboard shortcuts",
						Icon = "keyboard",
						Keywords = "controls keybind toggle minimize shortcut hotkey ctrl"
					},
					{
						Id = "Config",
						Title = "Config",
						Subtitle = "Interface settings storage and default reset",
						Icon = "folder",
						Keywords = "config interface manager save load profile export reset defaults"
					},
					{
						Id = "Unload",
						Title = "Unload",
						Subtitle = "Cleanly close and remove Acryven from this session",
						Icon = "log-out",
						Keywords = "unload destroy exit close quit remove danger",
						Danger = true
					}
				}
			}
		}

		local TAB_ALIASES = {
			["General"] = "General",
			["Appearance"] = "Appearance",
			["Layout & HUD"] = "Layout & HUD",
			["Privacy"] = "Privacy",
			["Privacy & Controls"] = "Privacy",
			["Controls"] = "Controls",
			["Config"] = "Config",
			["Language & Config"] = "Config",
			["Unload"] = "Unload"
		}

		return function(Library)
			local Modal = {
				Opened = false,
				Destroyed = false,
				ActiveTab = "General",
				RootGui = nil,
				ModalCard = nil,
				ConfigContainer = nil
			}

			local built = false
			local building = false
			local syncing = false
			Modal._Syncing = false
			local backdrop, modalWrapper, modalCard, modalShadow, modalScale, modalDpiScale
			local settingsBlur = nil
			local navScroll, navInner, navListLayout, navEmptyLabel
			local activePill, activeBar, hoverPill, hoverPillStroke
			local searchBox, searchClearBtn, searchStroke
			local pagesParent
			local navItems = {}
			local navGroupHeaders = {}
			local pageHolders = {}
			local controlRefs = {}
			Modal._Controls = controlRefs
			local animGen = 0
			local cardYOffset = 0
			local activeIndicatorY = 0
			local activeIndicatorInit = false
			local hoverY, hoverVisible, hoverLeaveGen = 0, false, 0

			local function resolveTabId(name)
				if type(name) ~= "string" then
					return nil
				end
				return TAB_ALIASES[name] or (pageHolders[name] and name) or nil
			end

			local function getFontLabel(profileId)
				if profileId == "builder-sans" then
					return "Builder Sans"
				elseif profileId == "gotham" then
					return "Gotham"
				end
				return "Inter"
			end

			local function getLanguageDisplay(code)
				local map = {en = "English", th = "Thai", vi = "Vietnamese", es = "Spanish"}
				return map[tostring(code or "en"):lower()] or "English"
			end

			local function ensureBlurEffect()
				if Modal.Destroyed then
					return nil
				end
				if settingsBlur and settingsBlur.Parent then
					return settingsBlur
				end
				local existing = Lighting:FindFirstChild("AcryvenSettingsBlur")
				if existing and existing:IsA("BlurEffect") then
					settingsBlur = existing
					return settingsBlur
				end
				settingsBlur = New(
					"BlurEffect",
					{
						Name = "AcryvenSettingsBlur",
						Size = 0,
						Enabled = false,
						Parent = Lighting
					}
				)
				return settingsBlur
			end

			local function setCardYOffset(y)
				cardYOffset = y
				if modalCard then
					modalCard.Position = UDim2.new(0.5, 0, 0.5, y)
				end
			end

			local function setActiveIndicatorY(y)
				activeIndicatorY = y
				if activePill then
					activePill.Position = UDim2.fromOffset(0, y)
				end
				if activeBar then
					activeBar.Position = UDim2.fromOffset(0, y + 9)
				end
			end

			local function positionActiveIndicator(instant)
				local nav = navItems[Modal.ActiveTab]
				if not nav or not nav.Button or not nav.Button.Visible or not navInner then
					if activePill then activePill.Visible = false end
					if activeBar then activeBar.Visible = false end
					return
				end
				local scale = Creator.GetEffectiveScale(navInner)
				local targetY = (nav.Button.AbsolutePosition.Y - navInner.AbsolutePosition.Y) / scale
				-- Fallback if AbsolutePosition has not laid out yet (e.g., while hidden)
				if nav.Button.AbsoluteSize.Y <= 0 and nav.FallbackY then
					targetY = nav.FallbackY
				end
				activePill.Visible = true
				activeBar.Visible = true
				if nav.Danger then
					Creator.OverrideTag(activeBar, {})
					activeBar.BackgroundColor3 = DANGER_RED
				else
					Creator.OverrideTag(activeBar, {BackgroundColor3 = "Accent"})
				end
				if instant or not activeIndicatorInit or Creator.ReducedMotion then
					activeIndicatorInit = true
					Creator.CancelSpring(activePill, "ActiveY")
					setActiveIndicatorY(targetY)
				else
					-- Luaward exact sidebar/split-modal traveling indicator spring (stiffness 380, damping 30, mass 0.8 => f=3.5, d=0.86)
					Creator.SpringValue(activePill, "ActiveY", targetY, 3.8, 0.86, setActiveIndicatorY, activeIndicatorY)
				end
			end

			local function syncTabVisuals(instant)
				for id, nav in pairs(navItems) do
					local active = (id == Modal.ActiveTab)
					if nav.Danger then
						Creator.OverrideTag(nav.Label, {})
						Creator.OverrideTag(nav.Icon, {})
						nav.Label.TextColor3 = DANGER_RED
						nav.Icon.ImageColor3 = DANGER_RED
						nav.Label.FontFace = Creator.Font(active and Enum.FontWeight.SemiBold or Enum.FontWeight.Medium)
					elseif active then
						Creator.OverrideTag(nav.Label, {TextColor3 = "Text"})
						Creator.OverrideTag(nav.Icon, {ImageColor3 = "Accent"})
						nav.Label.FontFace = Creator.Font(Enum.FontWeight.SemiBold)
					else
						Creator.OverrideTag(nav.Label, {TextColor3 = "SubText"})
						Creator.OverrideTag(nav.Icon, {ImageColor3 = "SubText"})
						nav.Label.FontFace = Creator.Font(Enum.FontWeight.Medium)
					end
				end

				for id, page in pairs(pageHolders) do
					local isTarget = (id == Modal.ActiveTab)
					local wasVisible = page.Scroll.Visible
					page.Scroll.Visible = isTarget
					if isTarget then
						if type(page.SyncCanvas) == "function" then
							task.defer(page.SyncCanvas)
						end
						if not instant and not wasVisible and not Creator.ReducedMotion and page.Holder then
							-- Luaward content rise transition (--lw-dur-rise: 320ms, subtle +10px -> 0)
							page.Holder.Position = UDim2.fromOffset(0, 10)
							Creator.SpringValue(page.Holder, "RiseY", 0, 4.2, 0.90, function(y)
								page.Holder.Position = UDim2.fromOffset(0, y)
							end, 10)
						elseif page.Holder then
							Creator.CancelSpring(page.Holder, "RiseY")
							page.Holder.Position = UDim2.fromOffset(0, 0)
						end
					end
				end

				positionActiveIndicator(instant)
			end

			local function applyNavSearch(query)
				query = tostring(query or ""):gsub("^%s+", ""):gsub("%s+$", ""):lower()
				if searchClearBtn then
					searchClearBtn.Visible = query ~= ""
				end
				local totalShown = 0
				for _, gInfo in ipairs(navGroupHeaders) do
					local groupShown = 0
					for _, itemId in ipairs(gInfo.ItemIds) do
						local nav = navItems[itemId]
						if nav then
							local match = (query == "") or (nav.SearchHaystack:find(query, 1, true) ~= nil)
							nav.Button.Visible = match
							if match then
								groupShown += 1
								totalShown += 1
							end
						end
					end
					gInfo.Header.Visible = (groupShown > 0)
				end
				if navEmptyLabel then
					navEmptyLabel.Visible = (totalShown == 0)
				end
				task.defer(function()
					positionActiveIndicator(true)
					if navScroll and navListLayout then
						local scale = Creator.GetEffectiveScale(navScroll)
						navScroll.CanvasSize = UDim2.new(0, 0, 0, math.ceil(navListLayout.AbsoluteContentSize.Y / scale) + 12)
					end
				end)
			end

			local function makePageContainer(scrollFrame, title, subtitle, isInternal)
				local layout = New("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder})
				local holder = New(
					"Frame",
					{
						Name = "PageContent",
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1
					},
					{layout}
				)
				holder.Parent = scrollFrame

				-- Luaward-style page heading inside the right pane (crisp 17px title + muted subtitle + hairline)
				local pageHeader = New(
					"Frame",
					{
						Name = "PageHeader",
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Parent = holder
					},
					{
						New("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder}),
						New("UIPadding", {PaddingBottom = UDim.new(0, 10)}),
						New("TextLabel", {
							Name = "Title",
							Text = title,
							FontFace = Creator.Font(Enum.FontWeight.Bold, Enum.FontStyle.Normal, "Display"),
							TextSize = 17,
							LineHeight = 1.15,
							TextXAlignment = Enum.TextXAlignment.Left,
							AutomaticSize = Enum.AutomaticSize.Y,
							Size = UDim2.new(1, 0, 0, 0),
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							ThemeTag = {TextColor3 = "Text"}
						}),
						New("TextLabel", {
							Name = "Subtitle",
							Text = subtitle or "",
							Visible = (subtitle ~= nil and subtitle ~= ""),
							FontFace = Creator.Font(Enum.FontWeight.Medium),
							TextSize = 12,
							LineHeight = 1.15,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
							AutomaticSize = Enum.AutomaticSize.Y,
							Size = UDim2.new(1, 0, 0, 0),
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							ThemeTag = {TextColor3 = "SubText"}
						}),
						New("Frame", {
							Name = "Divider",
							Size = UDim2.new(1, 0, 0, 1),
							BackgroundTransparency = 0.58,
							LayoutOrder = 3,
							ThemeTag = {BackgroundColor3 = "TitleBarLine"}
						})
					}
				)
				local _ = pageHeader

				local function syncCanvas()
					if not scrollFrame or not scrollFrame.Parent then
						return
					end
					local scale = Creator.GetEffectiveScale(scrollFrame)
					scrollFrame.CanvasSize = UDim2.new(0, 0, 0, math.ceil(layout.AbsoluteContentSize.Y / scale) + 24)
				end
				Creator.AddSignal(layout:GetPropertyChangedSignal("AbsoluteContentSize"), syncCanvas)
				Creator.RegisterDPIScale(scrollFrame, function()
					task.defer(syncCanvas)
				end)

				local nextSectionOrder = 10
				local pageObj = {
					Container = holder,
					ScrollFrame = scrollFrame,
					Type = "ScrollingFrame",
					Library = Library,
					_Internal = isInternal == true
				}
				function pageObj.AddSection(_s, sectionTitle, sectionOpts)
					nextSectionOrder += 1
					local opts
					if type(sectionTitle) == "table" then
						opts = {}
						for k, v in next, sectionTitle do opts[k] = v end
					else
						opts = type(sectionOpts) == "table" and {} or {}
						if type(sectionOpts) == "table" then
							for k, v in next, sectionOpts do opts[k] = v end
						end
						opts.Title = tostring(sectionTitle or "")
					end
					opts.LayoutOrder = opts.LayoutOrder or nextSectionOrder
					local Section, sectionComponent =
						{Type = "Section", _Internal = pageObj._Internal},
						requireModule(Root.Components.Section)(opts, holder)
					Section.Container = sectionComponent.Container
					Section.Root = sectionComponent.Root
					Section.SetVisible = function(selfOrVisible, visible)
						return sectionComponent.SetVisible(type(selfOrVisible) == "boolean" and selfOrVisible or visible)
					end
					Section.SetCollapsed = function(selfOrVal, val, instant)
						if type(selfOrVal) == "boolean" then
							return sectionComponent.SetCollapsed(selfOrVal, val)
						end
						return sectionComponent.SetCollapsed(val, instant)
					end
					Section.Toggle = function(_sec, instant)
						return sectionComponent.Toggle(instant)
					end
					Section.SetBadge = function(_sec, text, color)
						return sectionComponent.SetBadge(text, color)
					end
					Section.SetTitle = function(_sec, newTitle)
						return sectionComponent.SetTitle(newTitle)
					end
					Section.ScrollFrame = scrollFrame
					if Library.Elements then
						setmetatable(Section, Library.Elements)
					end
					return Section
				end
				if Library.Elements then
					setmetatable(pageObj, Library.Elements)
				end
				return pageObj, holder, syncCanvas
			end

			local function populateControls()
				syncing = true
				Modal._Syncing = true
				-- 1) General (Language, Font, DPI Scale, Reduced Motion)
				local pGen = pageHolders["General"].Api
				local secGenLang = pGen:AddSection({Title = "Language & Typography", Icon = "globe"})
				controlRefs.LangDropdown = secGenLang:AddDropdown("SettingsModalLanguage", {
					Title = "Interface Language",
					Description = "Translate Acryven labels and prompts",
					Values = {"English", "Thai", "Vietnamese", "Spanish"},
					Default = getLanguageDisplay(Library.CurrentLanguage),
					Callback = function(choice)
						if syncing then return end
						local codeMap = {English = "en", Thai = "th", Vietnamese = "vi", Spanish = "es"}
						local code = codeMap[choice] or "en"
						Library.CurrentLanguage = code
						if Library.I18n and type(Library.I18n.SetLanguage) == "function" then
							Library.I18n:SetLanguage(code)
						end
						if Library.ProfileMenu then
							Library.ProfileMenu:Refresh()
						end
					end
				})
				local currentProfileId = Library.Fonts and Library.Fonts.CurrentProfile or "default"
				controlRefs.FontPreset = secGenLang:AddSegmentedControl("SettingsModalFont", {
					Title = "UI Font Preset",
					Description = "Live UI typography switch (Code & Console stay RobotoMono)",
					Values = {"Inter", "Builder Sans", "Gotham"},
					Default = getFontLabel(currentProfileId),
					Callback = function(label)
						if syncing then return end
						local map = {["Inter"] = "default", ["Builder Sans"] = "builder-sans", ["Gotham"] = "gotham"}
						if type(Library.SetFont) == "function" then
							Library:SetFont(map[label] or "default")
						end
						if Library.ProfileMenu then
							Library.ProfileMenu:Refresh()
						end
					end
				})

				local secGenMotion = pGen:AddSection({Title = "Display & Motion", Icon = "sparkles"})
				controlRefs.DpiSlider = secGenMotion:AddSlider("SettingsModalDPI", {
					Title = "UI DPI Scale",
					Description = "Adjusts Window, Popovers, Modals, and HUD sizing",
					Min = 0.8,
					Max = 1.35,
					Default = Library.DPIScale or 1.0,
					Rounding = 2,
					Suffix = "x",
					Callback = function(v)
						if syncing then return end
						Library:SetDPIScale(v)
					end
				})
				controlRefs.ReducedMotion = secGenMotion:AddToggle("SettingsModalMotion", {
					Title = "Reduced Motion",
					Description = "Use instant transitions instead of spring animations",
					Default = Library.ReducedMotion == true,
					Callback = function(v)
						if syncing then return end
						Library:SetReducedMotion(v)
					end
				})

				-- 2) Appearance (Theme, Acrylic, Transparency)
				local pApp = pageHolders["Appearance"].Api
				local secTheme = pApp:AddSection({Title = "Color Theme", Icon = "palette"})
				controlRefs.ThemeDropdown = secTheme:AddDropdown("SettingsModalTheme", {
					Title = "Active Theme",
					Description = "Smooth Oklab perceptual interpolation across 22 themes",
					Values = Library.Themes,
					Default = Library.Theme,
					Callback = function(th)
						if syncing then return end
						if th and th ~= Library.Theme then
							Library:SetTheme(th)
							if Library.ProfileMenu then
								Library.ProfileMenu:Refresh()
							end
						end
					end
				})

				local secSurface = pApp:AddSection({Title = "Glass & Surface", Icon = "layers"})
				controlRefs.AcrylicToggle = secSurface:AddToggle("SettingsModalAcrylic", {
					Title = "3D Acrylic Blur",
					Description = "Depth-of-field backdrop frosted glass effect",
					Default = Library.Acrylic == true,
					Callback = function(v)
						if syncing then return end
						if Library.UseAcrylic then
							Library:ToggleAcrylic(v)
						end
					end
				})
				controlRefs.TransparencyToggle = secSurface:AddToggle("SettingsModalTransparency", {
					Title = "Surface Transparency",
					Description = "Semi-translucent window surface",
					Default = Library.Transparency ~= false,
					Callback = function(v)
						if syncing then return end
						Library.Transparency = v == true
						Library:ToggleTransparency(v)
					end
				})

				-- 3) Layout & HUD
				local pLayout = pageHolders["Layout & HUD"].Api
				local secLayout = pLayout:AddSection({Title = "Sidebar & Alerts", Icon = "panel-left"})
				controlRefs.SidebarCollapsed = secLayout:AddToggle("SettingsModalSidebar", {
					Title = "Collapse Sidebar (Icon Rail)",
					Description = "Compact icon-only navigation rail (Ctrl+B)",
					Default = Library.Window and Library.Window.SidebarCollapsed == true or false,
					Callback = function(v)
						if syncing then return end
						if Library.Window and Library.Window.SidebarCollapsed ~= (v == true) then
							Library.Window:SetSidebarCollapsed(v == true)
						end
					end
				})
				controlRefs.NotifySide = secLayout:AddDropdown("SettingsModalNotifySide", {
					Title = "Notification Corner",
					Description = "Where toast alerts appear on screen",
					Values = {"BottomRight", "BottomLeft", "TopRight", "TopLeft"},
					Default = Library.NotifySide or "BottomRight",
					Callback = function(corner)
						if syncing then return end
						if corner then
							Library:SetNotifySide(corner)
						end
					end
				})

				local secHud = pLayout:AddSection({Title = "HUD Overlays", Icon = "activity"})
				controlRefs.AlwaysPill = secHud:AddToggle("SettingsModalAlwaysPill", {
					Title = "Pin Floating Pill Always",
					Description = "Keep floating pill visible even while window is open",
					Default = Library.FloatingPill and Library.FloatingPill.AlwaysVisible == true or false,
					Callback = function(v)
						if syncing then return end
						if Library.FloatingPill then
							Library.FloatingPill.AlwaysVisible = v == true
							Library.FloatingPill:SetVisible((v == true) or (Library.Window and Library.Window.Minimized))
						end
					end
				})
				controlRefs.ShowHuds = secHud:AddToggle("SettingsModalShowHUDs", {
					Title = "Show Active HUD Widgets",
					Description = "Toggle Watermark and Active Keybinds overlay",
					Default = true,
					Callback = function(v)
						if syncing then return end
						for _, hud in ipairs(Library._ActiveHUDs or {}) do
							if hud and type(hud.SetVisible) == "function" then
								hud:SetVisible(v == true)
							end
						end
					end
				})

				-- 4) Privacy
				local pPriv = pageHolders["Privacy"].Api
				local secPrivacy = pPriv:AddSection({Title = "Streamer Mode", Icon = "eye-off"})
				local privState = type(Library.GetPrivacyMode) == "function" and Library:GetPrivacyMode() or {Hidden = false, Alias = "Anonymous", HideAvatar = false}
				controlRefs.HideName = secPrivacy:AddToggle("SettingsModalHideName", {
					Title = "Hide Player Name",
					Description = "Mask your Roblox name and username on the sidebar profile card",
					Default = privState.Hidden == true,
					Callback = function(v)
						if syncing then return end
						if type(Library.SetPrivacyMode) == "function" then
							local cur = Library:GetPrivacyMode()
							if cur.Hidden ~= (v == true) then
								Library:SetPrivacyMode(v == true, cur.Alias, cur.HideAvatar)
							end
						end
					end
				})
				controlRefs.HideAvatar = secPrivacy:AddToggle("SettingsModalHideAvatar", {
					Title = "Hide Player Avatar",
					Description = "Replace avatar picture with a privacy shield icon",
					Default = privState.HideAvatar == true,
					Callback = function(v)
						if syncing then return end
						if type(Library.SetPrivacyMode) == "function" then
							local cur = Library:GetPrivacyMode()
							if cur.HideAvatar ~= (v == true) then
								Library:SetPrivacyMode(cur.Hidden, cur.Alias, v == true)
							end
						end
					end
				})
				controlRefs.PrivacyAlias = secPrivacy:AddInput("SettingsModalAlias", {
					Title = "Display Alias",
					Description = "Shown on the sidebar profile card while Hide Player Name is active",
					Default = privState.Alias or "Anonymous",
					Placeholder = "Anonymous",
					Finished = true,
					Callback = function(txt)
						if syncing then return end
						if type(Library.SetPrivacyMode) == "function" then
							local cur = Library:GetPrivacyMode()
							local clean = tostring(txt or ""):gsub("^%s+", ""):gsub("%s+$", "")
							local nextAlias = clean ~= "" and clean or "Anonymous"
							if cur.Alias ~= nextAlias then
								Library:SetPrivacyMode(cur.Hidden, nextAlias, cur.HideAvatar)
							end
						end
					end
				})

				-- 5) Controls
				local pCtrl = pageHolders["Controls"].Api
				local secControls = pCtrl:AddSection({Title = "Window Controls", Icon = "keyboard"})
				local minKeyName = typeof(Library.MinimizeKey) == "EnumItem" and Library.MinimizeKey.Name or tostring(Library.MinimizeKey or "LeftControl")
				controlRefs.MinKeybind = secControls:AddKeybind("SettingsModalMinKey", {
					Title = "Toggle Window Keybind",
					Description = "Shortcut to minimize or restore the main window",
					Default = minKeyName,
					Mode = "Toggle"
				})
				controlRefs.MinKeybind:OnChanged(function(val)
					local chosen = val or (controlRefs.MinKeybind and controlRefs.MinKeybind.Value)
					if chosen ~= nil and chosen ~= "" then
						Library.MinimizeKey = chosen
					end
				end)
				secControls:AddParagraph({
					Title = "Built-in Shortcuts",
					Content = "Ctrl+, : Open or close Settings\nCtrl+K : Open Command Palette (Spotlight)\nCtrl+B : Collapse or expand Sidebar rail\nEsc : Close active Modal or Popover"
				})

				-- 6) Config (InterfaceManager attaches here via Modal:GetConfigContainer())
				local pCfg = pageHolders["Config"].Api
				local secReset = pCfg:AddSection({Title = "Quick Actions", Icon = "refresh-cw"})
				secReset:AddButton({
					Title = "Reset UI Defaults",
					Description = "Restore Acryven theme, Inter font, 1.0x DPI, and default HUD settings",
					Callback = function()
						Library:SetTheme("Acryven")
						if type(Library.SetFont) == "function" then Library:SetFont("default") end
						Library:SetDPIScale(1.0)
						Library:SetReducedMotion(false)
						Library:SetNotifySide("BottomRight")
						if type(Library.SetPrivacyMode) == "function" then Library:SetPrivacyMode(false, "Anonymous", false) end
						Modal:SyncValues()
						Library:Notify({Title = "Settings", Content = "Restored default UI settings.", Duration = 3})
					end
				})
				-- Public container so InterfaceManager:AttachToSettingsModal() adds sections cleanly
				Modal.ConfigContainer = pageHolders["Config"].PublicApi

				-- 7) Unload (Danger section matching Luaward Settings delete section)
				local pUnload = pageHolders["Unload"].Api
				local secDanger = pUnload:AddSection({Title = "Session Cleanup", Icon = "alert-triangle"})
				secDanger:AddCallout({
					Title = "Unload Acryven Interface",
					Description = "Removes all windows, HUDs, overlays, blur effects, and active input connections for this session.",
					Variant = "Danger",
					Dismissible = false
				})
				secDanger:AddActionRow("SettingsModalUnloadRow", {
					Buttons = {
						{
							Title = "Unload Interface Now",
							Icon = "log-out",
							Variant = "Danger",
							Confirm = true,
							ConfirmText = "Click again to confirm Unload",
							Callback = function()
								Modal:Close()
								Library:Destroy()
							end
						}
					}
				})
				syncing = false
				Modal._Syncing = false
			end

			local function updateModalBounds()
				if not modalWrapper then
					return
				end
				local cam = Workspace.CurrentCamera
				local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
				local s = math.max(0.5, Creator.DPIScale or 1)
				local maxW = math.max(420, math.floor((vp.X - 36) / s))
				local maxH = math.max(320, math.floor((vp.Y - 56) / s))
				modalWrapper.Size = UDim2.fromOffset(math.min(720, maxW), math.min(470, maxH))
			end

			local function ensureBuilt()
				if built or building or Modal.Destroyed then
					return
				end
				building = true

				local guiParent = (Library.GUI and Library.GUI.Parent) or Creator.GetService("CoreGui")
				local settingsGui = New(
					"ScreenGui",
					{
						Name = "AcryvenSettingsGui",
						IgnoreGuiInset = true,
						DisplayOrder = 160,
						ResetOnSpawn = false,
						Enabled = false,
						ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
						Parent = guiParent
					}
				)
				pcall(function()
					settingsGui.ScreenInsets = Enum.ScreenInsets.None
				end)
				protectGui(settingsGui)
				Modal.RootGui = settingsGui

				backdrop = New(
					"TextButton",
					{
						Name = "Backdrop",
						Size = UDim2.fromScale(1, 1),
						BackgroundColor3 = Color3.fromRGB(4, 6, 12),
						BackgroundTransparency = 1,
						AutoButtonColor = false,
						Text = "",
						ZIndex = 1,
						Parent = settingsGui
					}
				)

				modalDpiScale = New("UIScale", {Scale = Creator.DPIScale})
				modalScale = New("UIScale", {Scale = 1})

				modalShadow = New(
					"ImageLabel",
					{
						Name = "Shadow",
						BackgroundTransparency = 1,
						Image = "rbxassetid://5554236805",
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(23, 23, 277, 277),
						Size = UDim2.new(1, 44, 1, 44),
						Position = UDim2.fromOffset(-22, -18),
						ImageColor3 = Color3.fromRGB(0, 0, 0),
						ImageTransparency = 1,
						ZIndex = 2
					}
				)

				-- ============================================================
				-- Full-width Top Header Bar (Luaward SplitModal pattern)
				-- ============================================================
				local closeIcon = New("ImageLabel", {
					Image = Library:GetIcon("x") or "",
					Size = UDim2.fromOffset(15, 15),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					BackgroundTransparency = 1,
					ThemeTag = {ImageColor3 = "SubText"}
				})
				local closeScale = New("UIScale", {Scale = 1})
				local closeBtn = New(
					"TextButton",
					{
						Name = "CloseModalBtn",
						Text = "",
						AutoButtonColor = false,
						Size = UDim2.fromOffset(30, 30),
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -12, 0.5, 0),
						BackgroundTransparency = 1,
						ZIndex = 6,
						ThemeTag = {BackgroundColor3 = "Tab"}
					},
					{
						closeScale,
						New("UICorner", {CornerRadius = UDim.new(0, 8)}),
						closeIcon
					}
				)
				Creator.AddSignal(closeBtn.MouseEnter, function()
					Creator.SpringValue(closeBtn, "BackgroundTransparency", 0.80, 5.2, 1)
					Creator.OverrideTag(closeIcon, {ImageColor3 = "Text"})
				end)
				Creator.AddSignal(closeBtn.MouseLeave, function()
					Creator.SpringValue(closeBtn, "BackgroundTransparency", 1, 5.2, 1)
					Creator.SpringValue(closeScale, "Scale", 1, 6.0, 0.85)
					Creator.OverrideTag(closeIcon, {ImageColor3 = "SubText"})
				end)
				Creator.AddSignal(closeBtn.MouseButton1Down, function()
					Creator.SpringValue(closeScale, "Scale", 0.93, 6.5, 0.9)
				end)
				Creator.AddSignal(closeBtn.MouseButton1Up, function()
					Creator.SpringValue(closeScale, "Scale", 1, 5.5, 0.8)
				end)
				Creator.AddSignal(closeBtn.MouseButton1Click, function()
					Modal:Close()
				end)

				local topHeaderBar = New(
					"Frame",
					{
						Name = "TopHeaderBar",
						Size = UDim2.new(1, 0, 0, 48),
						BackgroundTransparency = 1,
						ZIndex = 5
					},
					{
						New("Frame", {
							Name = "LeftTitleGroup",
							Position = UDim2.fromOffset(18, 0),
							Size = UDim2.new(1, -66, 1, 0),
							BackgroundTransparency = 1
						}, {
							New("UIListLayout", {
								FillDirection = Enum.FillDirection.Horizontal,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(0, 8)
							}),
							New("ImageLabel", {
								Name = "SettingsIcon",
								Image = Library:GetIcon("settings") or "",
								Size = UDim2.fromOffset(16, 16),
								LayoutOrder = 1,
								BackgroundTransparency = 1,
								ThemeTag = {ImageColor3 = "Accent"}
							}),
							New("TextLabel", {
								Name = "ModalTitle",
								Text = "Settings",
								FontFace = Creator.Font(Enum.FontWeight.Bold, Enum.FontStyle.Normal, "Display"),
								TextSize = 15,
								TextXAlignment = Enum.TextXAlignment.Left,
								AutomaticSize = Enum.AutomaticSize.X,
								Size = UDim2.new(0, 0, 0, 20),
								LayoutOrder = 2,
								BackgroundTransparency = 1,
								ThemeTag = {TextColor3 = "Text"}
							}),
							New("Frame", {
								Name = "KbdBadge",
								AutomaticSize = Enum.AutomaticSize.X,
								Size = UDim2.fromOffset(0, 20),
								LayoutOrder = 3,
								BackgroundTransparency = 0.52,
								ThemeTag = {BackgroundColor3 = "DialogButton"}
							}, {
								New("UICorner", {CornerRadius = UDim.new(0, 6)}),
								New("UIStroke", {Transparency = 0.48, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "InElementBorder"}}),
								New("UIPadding", {PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 7)}),
								New("TextLabel", {
									Text = "Ctrl+,",
									I18nSkip = true,
									FontFace = Creator.Font(Enum.FontWeight.Medium),
									TextSize = 10,
									AutomaticSize = Enum.AutomaticSize.X,
									Size = UDim2.new(0, 0, 1, 0),
									BackgroundTransparency = 1,
									ThemeTag = {TextColor3 = "SubText"}
								})
							})
						}),
						closeBtn,
						New("Frame", {
							Name = "BottomHairline",
							Size = UDim2.new(1, 0, 0, 1),
							Position = UDim2.new(0, 0, 1, -1),
							BackgroundTransparency = 0.55,
							ThemeTag = {BackgroundColor3 = "TitleBarLine"}
						})
					}
				)

				-- ============================================================
				-- Left Navigation Rail (204px: SearchField + Grouped Tabs + Traveling Indicator)
				-- ============================================================
				searchStroke = New("UIStroke", {
					Transparency = 0.42,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					ThemeTag = {Color = "InElementBorder"}
				})
				searchClearBtn = New("TextButton", {
					Name = "ClearSearch",
					Text = "",
					AutoButtonColor = false,
					Size = UDim2.fromOffset(20, 20),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -6, 0.5, 0),
					BackgroundTransparency = 1,
					Visible = false,
					ZIndex = 6
				}, {
					New("ImageLabel", {
						Image = Library:GetIcon("x") or "",
						Size = UDim2.fromOffset(12, 12),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						BackgroundTransparency = 1,
						ThemeTag = {ImageColor3 = "SubText"}
					})
				})
				searchBox = New("TextBox", {
					Name = "SettingsSearch",
					Text = "",
					PlaceholderText = "Search settings...",
					I18nSkip = true,
					ClearTextOnFocus = false,
					FontFace = Creator.Font(Enum.FontWeight.Medium),
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
					Position = UDim2.fromOffset(28, 0),
					Size = UDim2.new(1, -54, 1, 0),
					BackgroundTransparency = 1,
					ZIndex = 6,
					ThemeTag = {TextColor3 = "Text", PlaceholderColor3 = "SubText"}
				})
				local searchWrap = New("Frame", {
					Name = "SearchField",
					Position = UDim2.fromOffset(12, 12),
					Size = UDim2.new(1, -24, 0, 32),
					BackgroundTransparency = 0.28,
					ZIndex = 5,
					ThemeTag = {BackgroundColor3 = "DialogHolder"}
				}, {
					New("UICorner", {CornerRadius = UDim.new(0, 9)}),
					searchStroke,
					New("ImageLabel", {
						Image = Library:GetIcon("search") or "",
						Size = UDim2.fromOffset(14, 14),
						Position = UDim2.new(0, 9, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						ZIndex = 6,
						ThemeTag = {ImageColor3 = "SubText"}
					}),
					searchBox,
					searchClearBtn
				})
				Creator.AddSignal(searchBox.Focused, function()
					Creator.OverrideTag(searchStroke, {Color = "Accent"})
					Creator.SpringValue(searchStroke, "Transparency", 0.14, 5.2, 1)
				end)
				Creator.AddSignal(searchBox.FocusLost, function()
					Creator.OverrideTag(searchStroke, {Color = "InElementBorder"})
					Creator.SpringValue(searchStroke, "Transparency", 0.42, 5.2, 1)
				end)
				Creator.AddSignal(searchBox:GetPropertyChangedSignal("Text"), function()
					applyNavSearch(searchBox.Text)
				end)
				Creator.AddSignal(searchClearBtn.MouseButton1Click, function()
					searchBox.Text = ""
					applyNavSearch("")
				end)

				-- Active + Hover Indicators in their own non-layout layer (exact Luaward SplitModal pattern!)
				hoverPillStroke = New("UIStroke", {Transparency = 1, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "InElementBorder"}})
				hoverPill = New("Frame", {
					Name = "NavHoverPill",
					Size = UDim2.new(1, 0, 0, 34),
					Position = UDim2.fromOffset(0, 0),
					BackgroundTransparency = 1,
					ZIndex = 5,
					ThemeTag = {BackgroundColor3 = "Tab"}
				}, {New("UICorner", {CornerRadius = UDim.new(0, 9)}), hoverPillStroke})

				activePill = New("Frame", {
					Name = "NavActivePill",
					Size = UDim2.new(1, 0, 0, 34),
					Position = UDim2.fromOffset(0, 0),
					BackgroundTransparency = 0.80,
					Visible = false,
					ZIndex = 5,
					ThemeTag = {BackgroundColor3 = "Tab"}
				}, {
					New("UICorner", {CornerRadius = UDim.new(0, 9)}),
					New("UIStroke", {Transparency = 0.56, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "InElementBorder"}})
				})
				activeBar = New("Frame", {
					Name = "NavActiveBar",
					Size = UDim2.fromOffset(3, 16),
					Position = UDim2.fromOffset(0, 9),
					BackgroundTransparency = 0,
					Visible = false,
					ZIndex = 7,
					ThemeTag = {BackgroundColor3 = "Accent"}
				}, {New("UICorner", {CornerRadius = UDim.new(1, 0)})})

				navListLayout = New("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder})
				navInner = New("Frame", {
					Name = "NavItems",
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					ZIndex = 6
				}, {navListLayout})

				navEmptyLabel = New("TextLabel", {
					Name = "NavEmpty",
					Text = "No matching settings",
					FontFace = Creator.Font(Enum.FontWeight.Medium),
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
					Position = UDim2.fromOffset(8, 10),
					Size = UDim2.new(1, -16, 0, 22),
					BackgroundTransparency = 1,
					Visible = false,
					ZIndex = 6,
					ThemeTag = {TextColor3 = "SubText"}
				})

				navScroll = New("ScrollingFrame", {
					Name = "NavScroll",
					Position = UDim2.fromOffset(12, 52),
					Size = UDim2.new(1, -24, 1, -64),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarThickness = 3,
					ScrollBarImageTransparency = 0.55,
					CanvasSize = UDim2.fromScale(0, 0),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					ZIndex = 5,
					ThemeTag = {ScrollBarImageColor3 = "Accent"}
				}, {
					hoverPill,
					activePill,
					activeBar,
					navInner,
					navEmptyLabel
				})

				Creator.AddSignal(navScroll.MouseLeave, function()
					hoverLeaveGen += 1
					hoverVisible = false
					Creator.SpringValue(hoverPill, "BackgroundTransparency", 1, 5.5, 1)
					Creator.SpringValue(hoverPillStroke, "Transparency", 1, 5.5, 1)
				end)

				local leftRail = New(
					"Frame",
					{
						Name = "LeftRail",
						Size = UDim2.new(0, 204, 1, 0),
						BackgroundTransparency = 1,
						ZIndex = 4
					},
					{
						New("Frame", {
							Name = "RightHairline",
							Size = UDim2.new(0, 1, 1, 0),
							Position = UDim2.new(1, -1, 0, 0),
							BackgroundTransparency = 0.55,
							ZIndex = 5,
							ThemeTag = {BackgroundColor3 = "TitleBarLine"}
						}),
						searchWrap,
						navScroll
					}
				)

				-- ============================================================
				-- Right Content Area & Pages
				-- ============================================================
				pagesParent = New(
					"Frame",
					{
						Name = "PagesArea",
						Position = UDim2.fromOffset(204, 0),
						Size = UDim2.new(1, -204, 1, 0),
						BackgroundTransparency = 1,
						ClipsDescendants = true,
						ZIndex = 4
					}
				)

				local layoutOrd = 0
				local runningFallbackY = 0
				for gIdx, grp in ipairs(NAV_GROUPS) do
					layoutOrd += 1
					local topGap = gIdx > 1 and 12 or 4
					local hdrH = 22 + topGap
					local hdr = New("Frame", {
						Name = "Grp_" .. grp.Label,
						Size = UDim2.new(1, 0, 0, hdrH),
						BackgroundTransparency = 1,
						LayoutOrder = layoutOrd,
						ZIndex = 6,
						Parent = navInner
					}, {
						New("TextLabel", {
							Text = grp.Label,
							FontFace = Creator.Font(Enum.FontWeight.SemiBold),
							TextSize = 10,
							TextXAlignment = Enum.TextXAlignment.Left,
							Position = UDim2.fromOffset(10, topGap),
							Size = UDim2.new(1, -14, 0, 18),
							BackgroundTransparency = 1,
							TextTransparency = 0.22,
							ZIndex = 6,
							ThemeTag = {TextColor3 = "SubText"}
						})
					})
					runningFallbackY += hdrH + 3
					local groupItemIds = {}

					for _, spec in ipairs(grp.Items) do
						layoutOrd += 1
						table.insert(groupItemIds, spec.Id)
						local isDanger = spec.Danger == true
						local icon = New("ImageLabel", {
							Name = "Icon",
							Image = Library:GetIcon(spec.Icon) or "",
							Size = UDim2.fromOffset(16, 16),
							Position = UDim2.new(0, 12, 0.5, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundTransparency = 1,
							ImageColor3 = isDanger and DANGER_RED or Color3.new(1, 1, 1),
							ZIndex = 7,
							ThemeTag = (not isDanger) and {ImageColor3 = "SubText"} or nil
						})
						local label = New("TextLabel", {
							Name = "Label",
							Text = spec.Title,
							FontFace = Creator.Font(Enum.FontWeight.Medium),
							TextSize = 13,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextTruncate = Enum.TextTruncate.AtEnd,
							Position = UDim2.new(0, 36, 0.5, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							Size = UDim2.new(1, -44, 0, 18),
							BackgroundTransparency = 1,
							TextColor3 = isDanger and DANGER_RED or Color3.new(1, 1, 1),
							ZIndex = 7,
							ThemeTag = (not isDanger) and {TextColor3 = "SubText"} or nil
						})
						local btn = New("TextButton", {
							Name = "Nav_" .. spec.Id,
							Text = "",
							AutoButtonColor = false,
							Size = UDim2.new(1, 0, 0, 34),
							BackgroundTransparency = 1,
							LayoutOrder = layoutOrd,
							ZIndex = 6,
							Parent = navInner
						}, {New("UICorner", {CornerRadius = UDim.new(0, 9)}), icon, label})

						Creator.AddSignal(btn.MouseEnter, function()
							hoverLeaveGen += 1
							if Modal.ActiveTab == spec.Id then
								hoverVisible = false
								Creator.SpringValue(hoverPill, "BackgroundTransparency", 1, 5.5, 1)
								Creator.SpringValue(hoverPillStroke, "Transparency", 1, 5.5, 1)
								return
							end
							local scale = Creator.GetEffectiveScale(navInner)
							local targetY = (btn.AbsolutePosition.Y - navInner.AbsolutePosition.Y) / scale
							if isDanger then
								Creator.OverrideTag(hoverPill, {})
								hoverPill.BackgroundColor3 = DANGER_BG
								Creator.OverrideTag(hoverPillStroke, {})
								hoverPillStroke.Color = DANGER_RED
							else
								Creator.OverrideTag(hoverPill, {BackgroundColor3 = "Tab"})
								Creator.OverrideTag(hoverPillStroke, {Color = "InElementBorder"})
							end
							if not hoverVisible then
								hoverVisible = true
								Creator.CancelSpring(hoverPill, "NavHoverY")
								hoverY = targetY
								hoverPill.Position = UDim2.fromOffset(0, targetY)
							else
								Creator.SpringValue(hoverPill, "NavHoverY", targetY, 5.2, 0.88, function(y)
									hoverY = y
									hoverPill.Position = UDim2.fromOffset(0, y)
								end, hoverY)
							end
							Creator.SpringValue(hoverPill, "BackgroundTransparency", isDanger and 0.82 or 0.88, 5.2, 1)
							Creator.SpringValue(hoverPillStroke, "Transparency", 0.64, 5.2, 1)
						end)
						Creator.AddSignal(btn.MouseLeave, function()
							hoverLeaveGen += 1
							local myGen = hoverLeaveGen
							task.delay(0.03, function()
								if myGen == hoverLeaveGen then
									hoverVisible = false
									Creator.SpringValue(hoverPill, "BackgroundTransparency", 1, 5.5, 1)
									Creator.SpringValue(hoverPillStroke, "Transparency", 1, 5.5, 1)
								end
							end)
						end)
						Creator.AddSignal(btn.MouseButton1Click, function()
							Modal:SelectTab(spec.Id)
						end)

						navItems[spec.Id] = {
							Button = btn,
							Icon = icon,
							Label = label,
							Danger = isDanger,
							FallbackY = runningFallbackY,
							SearchHaystack = (spec.Title .. " " .. (spec.Subtitle or "") .. " " .. (spec.Keywords or "")):lower()
						}
						runningFallbackY += 34 + 3

						-- Create corresponding scrollable right page
						local scroll = New(
							"ScrollingFrame",
							{
								Name = "Page_" .. spec.Id,
								Size = UDim2.fromScale(1, 1),
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								ScrollBarThickness = 4,
								ScrollBarImageTransparency = 0.42,
								CanvasSize = UDim2.fromScale(0, 0),
								ScrollingDirection = Enum.ScrollingDirection.Y,
								Visible = (spec.Id == Modal.ActiveTab),
								Parent = pagesParent,
								ThemeTag = {ScrollBarImageColor3 = "Accent"}
							},
							{
								New("UIPadding", {PaddingTop = UDim.new(0, 18), PaddingBottom = UDim.new(0, 22), PaddingLeft = UDim.new(0, 22), PaddingRight = UDim.new(0, 22)})
							}
						)
						local pageApi, pageHolder, syncCanvas = makePageContainer(scroll, spec.Title, spec.Subtitle, true)
						local publicApi = nil
						if spec.Id == "Config" then
							-- Non-internal facade for InterfaceManager:AttachToSettingsModal()
							publicApi = {
								Container = pageHolder,
								ScrollFrame = scroll,
								Type = "ScrollingFrame",
								Library = Library,
								_Internal = false,
								AddSection = function(_s, sTitle, sOpts)
									local sec = pageApi:AddSection(sTitle, sOpts)
									sec._Internal = false
									return sec
								end
							}
							if Library.Elements then
								setmetatable(publicApi, Library.Elements)
							end
						end
						pageHolders[spec.Id] = {Scroll = scroll, Api = pageApi, PublicApi = publicApi, Holder = pageHolder, SyncCanvas = syncCanvas}
					end

					table.insert(navGroupHeaders, {Header = hdr, ItemIds = groupItemIds})
				end

				local bodyArea = New(
					"Frame",
					{
						Name = "BodyArea",
						Position = UDim2.fromOffset(0, 48),
						Size = UDim2.new(1, 0, 1, -48),
						BackgroundTransparency = 1,
						ZIndex = 4
					},
					{leftRail, pagesParent}
				)

				modalCard = New(
					"Frame",
					{
						Name = "SettingsModalCard",
						Size = UDim2.fromScale(1, 1),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						BackgroundTransparency = 0.02,
						Active = true,
						ClipsDescendants = true,
						ZIndex = 3,
						ThemeTag = {BackgroundColor3 = "Dialog"}
					},
					{
						modalScale,
						New("UICorner", {CornerRadius = UDim.new(0, 14)}),
						New("UIStroke", {Thickness = 1.1, Transparency = 0.20, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = {Color = "DialogBorder"}}),
						topHeaderBar,
						bodyArea
					}
				)
				Modal.ModalCard = modalCard

				modalWrapper = New(
					"Frame",
					{
						Name = "SettingsWrapper",
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromOffset(720, 470),
						BackgroundTransparency = 1,
						ZIndex = 2,
						Parent = settingsGui
					},
					{modalDpiScale, modalShadow, modalCard}
				)

				Creator.AddSignal(backdrop.MouseButton1Click, function()
					Modal:Close()
				end)
				Creator.RegisterDPIScale(modalDpiScale, function(s)
					modalDpiScale.Scale = s
					updateModalBounds()
					if Modal.Opened then
						task.defer(function()
							positionActiveIndicator(true)
						end)
					end
				end)

				populateControls()
				syncTabVisuals(true)
				updateModalBounds()
				built = true
				building = false
			end

			function Modal:GetConfigContainer()
				if Modal.Destroyed then
					return nil
				end
				ensureBuilt()
				return Modal.ConfigContainer
			end

			function Modal:SyncValues()
				if syncing or not built or Modal.Destroyed then
					return
				end
				syncing = true
				Modal._Syncing = true
				pcall(function()
					if controlRefs.ThemeDropdown and controlRefs.ThemeDropdown.Value ~= Library.Theme then
						controlRefs.ThemeDropdown:SetValue(Library.Theme, true)
					end
					if controlRefs.FontPreset and Library.Fonts then
						local targetFont = getFontLabel(Library.Fonts.CurrentProfile)
						if controlRefs.FontPreset.Value ~= targetFont then
							controlRefs.FontPreset:SetValue(targetFont, true)
						end
					end
					if controlRefs.AcrylicToggle and controlRefs.AcrylicToggle.Value ~= (Library.Acrylic == true) then
						controlRefs.AcrylicToggle:SetValue(Library.Acrylic == true, true, true)
					end
					if controlRefs.TransparencyToggle and controlRefs.TransparencyToggle.Value ~= (Library.Transparency ~= false) then
						controlRefs.TransparencyToggle:SetValue(Library.Transparency ~= false, true, true)
					end
					if controlRefs.DpiSlider and controlRefs.DpiSlider.Value ~= (Library.DPIScale or 1.0) then
						controlRefs.DpiSlider:SetValue(Library.DPIScale or 1.0, true)
					end
					if controlRefs.ReducedMotion and controlRefs.ReducedMotion.Value ~= (Library.ReducedMotion == true) then
						controlRefs.ReducedMotion:SetValue(Library.ReducedMotion == true, true, true)
					end
					if controlRefs.SidebarCollapsed and Library.Window then
						local targetCol = Library.Window.SidebarCollapsed == true
						if controlRefs.SidebarCollapsed.Value ~= targetCol then
							controlRefs.SidebarCollapsed:SetValue(targetCol, true, true)
						end
					end
					if controlRefs.NotifySide and controlRefs.NotifySide.Value ~= (Library.NotifySide or "BottomRight") then
						controlRefs.NotifySide:SetValue(Library.NotifySide or "BottomRight", true)
					end
					if controlRefs.AlwaysPill and Library.FloatingPill then
						local targetPill = Library.FloatingPill.AlwaysVisible == true
						if controlRefs.AlwaysPill.Value ~= targetPill then
							controlRefs.AlwaysPill:SetValue(targetPill, true, true)
						end
					end
					if type(Library.GetPrivacyMode) == "function" then
						local p = Library:GetPrivacyMode()
						if controlRefs.HideName and controlRefs.HideName.Value ~= (p.Hidden == true) then
							controlRefs.HideName:SetValue(p.Hidden == true, true, true)
						end
						if controlRefs.HideAvatar and controlRefs.HideAvatar.Value ~= (p.HideAvatar == true) then
							controlRefs.HideAvatar:SetValue(p.HideAvatar == true, true, true)
						end
						local targetAlias = p.Alias or "Anonymous"
						if controlRefs.PrivacyAlias and controlRefs.PrivacyAlias.Value ~= targetAlias then
							controlRefs.PrivacyAlias:SetValue(targetAlias, true)
						end
					end
					if controlRefs.LangDropdown then
						local targetLang = getLanguageDisplay(Library.CurrentLanguage)
						if controlRefs.LangDropdown.Value ~= targetLang then
							controlRefs.LangDropdown:SetValue(targetLang, true)
						end
					end
				end)
				syncing = false
				Modal._Syncing = false
			end

			function Modal:SelectTab(tabName)
				if Modal.Destroyed then
					return
				end
				ensureBuilt()
				local resolved = resolveTabId(tabName)
				if resolved and pageHolders[resolved] then
					if type(Library._CloseDropdowns) == "function" then
						Library._CloseDropdowns()
					end
					Modal.ActiveTab = resolved
					syncTabVisuals(false)
				end
			end

			function Modal:Open(tabName)
				if Modal.Destroyed or Library.Unloaded then
					return
				end
				ensureBuilt()
				if type(Library._CloseDropdowns) == "function" then
					Library._CloseDropdowns()
				end
				if searchBox and searchBox.Text ~= "" then
					searchBox.Text = ""
					applyNavSearch("")
				end
				local resolved = resolveTabId(tabName)
				if resolved and pageHolders[resolved] then
					Modal.ActiveTab = resolved
				end
				Modal:SyncValues()
				updateModalBounds()

				animGen += 1
				Modal.Opened = true
				Modal.RootGui.Enabled = true
				syncTabVisuals(true)
				task.defer(function()
					if Modal.Opened then
						positionActiveIndicator(true)
					end
				end)
				local blur = ensureBlurEffect()

				if Creator.ReducedMotion then
					backdrop.BackgroundTransparency = 0.46
					modalShadow.ImageTransparency = 0.44
					modalScale.Scale = 1
					setCardYOffset(0)
					if blur then
						blur.Enabled = true
						blur.Size = 10
					end
				else
					-- Luaward SplitModal / HeroUI Modal entrance (--lw-dur-dialog-in: 280ms)
					modalScale.Scale = 0.95
					backdrop.BackgroundTransparency = 1
					modalShadow.ImageTransparency = 1
					setCardYOffset(12)
					Creator.SpringValue(modalScale, "Scale", 1, 3.8, 0.88)
					Creator.SpringValue(modalCard, "CardY", 0, 3.8, 0.90, setCardYOffset, 12)
					Creator.SpringValue(backdrop, "BackgroundTransparency", 0.46, 4.4, 1)
					Creator.SpringValue(modalShadow, "ImageTransparency", 0.44, 4.4, 1)
					if blur then
						blur.Enabled = true
						Creator.SpringValue(blur, "Size", 10, 4.4, 1)
					end
				end
			end

			function Modal:Close()
				if not Modal.Opened or not built then
					return
				end
				if type(Library._CloseDropdowns) == "function" then
					Library._CloseDropdowns()
				end
				animGen += 1
				local myGen = animGen
				Modal.Opened = false
				local blur = settingsBlur
				if Creator.ReducedMotion then
					Modal.RootGui.Enabled = false
					if blur then
						blur.Size = 0
						blur.Enabled = false
					end
				else
					-- Faster exit per Luaward tokens.css (--lw-dur-dialog-out: 200ms)
					Creator.SpringValue(modalScale, "Scale", 0.96, 5.4, 1)
					Creator.SpringValue(modalCard, "CardY", 8, 5.4, 1, setCardYOffset, cardYOffset)
					Creator.SpringValue(backdrop, "BackgroundTransparency", 1, 5.8, 1)
					Creator.SpringValue(modalShadow, "ImageTransparency", 1, 5.8, 1)
					if blur then
						Creator.SpringValue(blur, "Size", 0, 5.8, 1)
					end
					task.delay(0.18, function()
						if myGen == animGen and not Modal.Opened then
							if Modal.RootGui then
								Modal.RootGui.Enabled = false
							end
							if blur and blur.Parent then
								blur.Size = 0
								blur.Enabled = false
							end
						end
					end)
				end
			end

			function Modal:Toggle(tabName)
				if Modal.Opened then
					Modal:Close()
				else
					Modal:Open(tabName)
				end
			end

			Creator.AddSignal(UserInputService.InputBegan, function(input, gameProcessed)
				if Modal.Destroyed or Library.Unloaded then
					return
				end
				if input.UserInputType ~= Enum.UserInputType.Keyboard then
					return
				end
				if Modal.Opened and input.KeyCode == Enum.KeyCode.Escape then
					Modal:Close()
					return
				end
				if gameProcessed or UserInputService:GetFocusedTextBox() then
					return
				end
				if input.KeyCode == Enum.KeyCode.Comma and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
					Modal:Toggle()
				end
			end)

			function Modal:Destroy()
				Modal.Destroyed = true
				Modal.Opened = false
				if settingsBlur then
					pcall(function()
						settingsBlur:Destroy()
					end)
					settingsBlur = nil
				end
				if Modal.RootGui then
					pcall(function()
						Modal.RootGui:Destroy()
					end)
					Modal.RootGui = nil
				end
			end

			return Modal
		end
	end
}
do
	local task, setmetatable, error, newproxy, getmetatable, next, table, unpack, coroutine, scriptGlobal, luaType, nativeRequire, pcall, nativeGetfenv, nativeSetfenv, rawget =
		task,
	setmetatable,
	error,
	newproxy,
	getmetatable,
	next,
	table,
	unpack,
	coroutine,
	script,
	type,
	require,
	pcall,
	getfenv,
	setfenv,
	rawget
	local tableInsert, tableRemove, freeze, defer, runtimeVersion, instanceById, moduleFunctionOf, moduleResults, scriptsToRun, sharedTable, childrenOf = table.insert, table.remove, table.freeze or function(value)
		return value
	end, task and task.defer or function(callback, ...)
		local thread = coroutine.create(callback)
		coroutine.resume(thread, ...)
		return thread
	end, "0.0.0-venv", {}, {}, {}, {}, {}, {}
	local virtualMethods, boundMethods = {
		GetChildren = function(instance)
			local children, result = childrenOf[instance], {}
			for child in next, children do
				tableInsert(result, child)
			end
			return result
		end,
		FindFirstChild = function(instance, name)
			if not name then
				error("Argument 1 missing or nil", 2)
			end
			for child in next, childrenOf[instance] do
				if child.Name == name then
					return child
				end
			end
			return
		end,
		GetFullName = function(instance)
			local fullName, parent = instance.Name, instance.Parent
			while parent do
				fullName = parent.Name .. "." .. fullName
				parent = parent.Parent
			end
			return "VirtualEnv." .. fullName
		end
	},
	{}
	for methodName, method in next, virtualMethods do
		boundMethods[methodName] = function(instance, ...)
			if not childrenOf[instance] then
				error("Expected ':' not '.' calling member function " .. methodName, 1)
			end
			return method(instance, ...)
		end
	end
	local createVirtualInstance = function(className, instanceName, parentInstance)
		local children, invalidMember, readOnly, proxy, stringValue = setmetatable({}, {__mode = "k"}), function(member)
			error(member .. " is not a valid (virtual) member of " .. className .. " \"" .. instanceName .. "\"", 1)
		end, function(property)
			error("Unable to assign (virtual) property " .. property .. ". Property is read only", 1)
		end, (newproxy(true))
		local metatable = getmetatable(proxy)
		metatable.__index = function(_, key)
			if key == "ClassName" then
				return className
			elseif key == "Name" then
				return instanceName
			elseif key == "Parent" then
				return parentInstance
			elseif className == "StringValue" and key == "Value" then
				return stringValue
			else
				local method = boundMethods[key]
				if method then
					return method
				end
			end
			for child in next, children do
				if child.Name == key then
					return child
				end
			end
			invalidMember(key)
		end
		metatable.__newindex = function(_, key, value)
			if key == "ClassName" then
				readOnly(key)
			elseif key == "Name" then
				instanceName = value
			elseif key == "Parent" then
				if value == proxy then
					return
				end
				if parentInstance ~= nil then
					childrenOf[parentInstance][proxy] = nil
				end
				parentInstance = value
				if value ~= nil then
					childrenOf[value][proxy] = true
				end
			elseif className == "StringValue" and key == "Value" then
				stringValue = value
			else
				invalidMember(key)
			end
		end
		metatable.__tostring = function()
			return instanceName
		end
		childrenOf[proxy] = children
		if parentInstance ~= nil then
			childrenOf[parentInstance][proxy] = true
		end
		return proxy
	end
	local function buildTree(entry, parent)
		local id, className, properties, childEntries = entry[1], entry[2], entry[3], entry[4]
		local name = tableRemove(properties, 1)
		local instance = createVirtualInstance(className, name, parent)
		instanceById[id] = instance
		if properties then
			for property, propertyValue in next, properties do
				instance[property] = propertyValue
			end
		end
		if childEntries then
			for _, childEntry in next, childEntries do
				buildTree(childEntry, instance)
			end
		end
		return instance
	end
	local roots = {}
	for _, entry in next, moduleTree do
		tableInsert(roots, buildTree(entry))
	end
	for id, moduleFunction in next, moduleFunctions do
		local instance = instanceById[id]
		moduleFunctionOf[instance] = moduleFunction
		local className = instance.ClassName
		if className == "LocalScript" or className == "Script" then
			tableInsert(scriptsToRun, instance)
		end
	end
	local loadModule = function(instance)
		local className, cached = instance.ClassName, moduleResults[instance]
		if cached and className == "ModuleScript" then
			return unpack(cached)
		end
		local moduleFunction = moduleFunctionOf[instance]
		if not moduleFunction then
			return
		end
		if className == "LocalScript" or className == "Script" then
			moduleFunction()
			return
		else
			local results = {moduleFunction()}
			moduleResults[instance] = results
			return unpack(results)
		end
	end
	function moduleContext(id)
		local instance = instanceById[id]
		local moduleFunction = moduleFunctionOf[instance]
		if not moduleFunction then
			return
		end
		local envReady, maui, moduleScript, requireModule, globalEnv, moduleEnv, buildEnvironment =
			false,
		freeze {
			Version = runtimeVersion,
			Script = scriptGlobal,
			Shared = sharedTable,
			GetScript = function()
				return scriptGlobal
			end,
			GetShared = function()
				return sharedTable
			end
		},
		instance,
		function(target, ...)
			if childrenOf[target] and target.ClassName == "ModuleScript" and moduleFunctionOf[target] then
				return loadModule(target)
			end
			return nativeRequire(target, ...)
		end
		local virtualGetfenv, virtualSetfenv = function(level, ...)
			if not envReady then
				buildEnvironment()
			end
			if luaType(level) == "number" and level >= 0 then
				if level == 0 then
					return moduleEnv
				else
					level = level + 1
					local ok, env = pcall(nativeGetfenv, level)
					if ok and env == globalEnv then
						return moduleEnv
					end
				end
			end
			return nativeGetfenv(level, ...)
		end, function(level, newEnv, ...)
			if not envReady then
				buildEnvironment()
			end
			if luaType(level) == "number" and level >= 0 then
				if level == 0 then
					return nativeSetfenv(moduleEnv, newEnv)
				else
					level = level + 1
					local ok, env = pcall(nativeGetfenv, level)
					if ok and env == globalEnv then
						return nativeSetfenv(moduleEnv, newEnv)
					end
				end
			end
			return nativeSetfenv(level, newEnv, ...)
		end
		function buildEnvironment()
			globalEnv = nativeGetfenv(0)
			local injected = {maui = maui, script = moduleScript, require = requireModule, getfenv = virtualGetfenv, setfenv = virtualSetfenv}
			moduleEnv =
				setmetatable(
					{},
					{
						__index = function(_, key)
							local raw = rawget(moduleEnv, key)
							if raw ~= nil then
								return raw
							end
							local injectedValue = injected[key]
							if injectedValue ~= nil then
								return injectedValue
							end
							return globalEnv[key]
						end
					}
				)
			nativeSetfenv(moduleFunction, moduleEnv)
			envReady = true
		end
		return maui, moduleScript, requireModule, virtualGetfenv, virtualSetfenv
	end
	for _, scriptInstance in next, scriptsToRun do
		defer(loadModule, scriptInstance)
	end
	do
		local mainModule
		for _, root in next, roots do
			if root.ClassName == "ModuleScript" and root.Name == "MainModule" then
				mainModule = root
				break
			end
		end
		if mainModule then
			return loadModule(mainModule)
		end
	end
end
