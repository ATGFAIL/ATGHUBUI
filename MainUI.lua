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
        local titleFont = Enum.Font.GothamBold
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
        titleShadow.Font = titleFont
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
        title.Font = titleFont
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

local TranslationSystem = {}
do
    local HttpService = game:GetService("HttpService")

    -- Configuration
    TranslationSystem.API_URL = "https://translate.atgofficial.net"
    TranslationSystem.Cache = {} -- Cache: {["en_th_Hello"] = "สวัสดี"}
    TranslationSystem.Registry = {} -- Registry: {[TextObject] = {OriginalText, Property}}
    TranslationSystem.CurrentLanguage = "en" -- Current UI language
    TranslationSystem.SourceLanguage = "en" -- Original language
    TranslationSystem.Enabled = true -- Translation enabled/disabled
    TranslationSystem.AvailableLanguages = {
        {code = "en", name = "English", flag = "🇬🇧"},
        {code = "th", name = "ไทย", flag = "🇹🇭"},
        {code = "vi", name = "Tiếng Việt", flag = "🇻🇳"},
        {code = "es", name = "Español", flag = "🇪🇸"}
    }

    -- Generate cache key
    local function getCacheKey(source, target, text)
        return source .. "_" .. target .. "_" .. text
    end

    -- Check if text contains emoji (protect from corruption)
    local function hasEmoji(text)
        -- Common emoji Unicode ranges
        for i = 1, #text do
            local byte = string.byte(text, i)
            -- Emoji ranges: UTF-8 4-byte sequences (emojis)
            if byte >= 240 then
                return true
            end
        end
        return false
    end

    -- Translate text using Gemini API (Async, one-by-one with instant display)
    function TranslationSystem:TranslateText(text, targetLang, callback)
        if not self.Enabled or not text or text == "" then
            if callback then callback(text) end
            return text
        end

        -- Skip if target is same as source
        if targetLang == self.SourceLanguage then
            if callback then callback(text) end
            return text
        end

        -- Skip if text contains emoji (prevent corruption)
        if hasEmoji(text) then
            if callback then callback(text) end
            return text
        end

        -- Check cache first
        local cacheKey = getCacheKey(self.SourceLanguage, targetLang, text)
        if self.Cache[cacheKey] then
            if callback then callback(self.Cache[cacheKey]) end
            return self.Cache[cacheKey]
        end

        -- Async individual API call (instant display when done)
        task.spawn(function()
            local success, result = pcall(function()
                local requestBody = HttpService:JSONEncode({
                    q = text,
                    source = self.SourceLanguage,
                    target = targetLang
                })

                local response = request({
                    Url = self.API_URL .. "/translate",
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = requestBody
                })

                if not response or not response.Success then
                    error("Request failed")
                end

                local data = HttpService:JSONDecode(response.Body)
                return data.translatedText or text
            end)

            if success and result then
                -- Cache the translation
                self.Cache[cacheKey] = result

                -- Update UI immediately (instant display!)
                if callback then
                    callback(result)
                end
            else
                -- Fallback to original text
                if callback then
                    callback(text)
                end
            end
        end)

        return text -- Return original immediately (will update async)
    end

    -- Register text element for auto-translation
    function TranslationSystem:Register(textObject, originalText, propertyName)
        if not textObject or not originalText then
            return
        end

        propertyName = propertyName or "Text"

        self.Registry[textObject] = {
            OriginalText = originalText,
            Property = propertyName
        }

        -- Debug: Show registration
        -- print(string.format("[TranslationSystem] Registered: '%s'", originalText:sub(1, 30)))

        -- Translate immediately if not English
        if self.CurrentLanguage ~= self.SourceLanguage then
            self:UpdateText(textObject)
        end

        return textObject
    end

    -- Update single text element (Async)
    function TranslationSystem:UpdateText(textObject)
        local registry = self.Registry[textObject]
        if not registry then
            return
        end

        self:TranslateText(registry.OriginalText, self.CurrentLanguage, function(translated)
            if textObject and textObject.Parent then
                textObject[registry.Property] = translated
            end
        end)
    end

    -- Update all registered text elements (Async)
    function TranslationSystem:UpdateAllText()
        for textObject, registry in pairs(self.Registry) do
            if textObject and textObject.Parent then
                self:UpdateText(textObject)
            else
                self.Registry[textObject] = nil
            end
        end
    end

    -- Set language and update UI
    function TranslationSystem:SetLanguage(langCode)
        if langCode == self.CurrentLanguage then
            return
        end

        self.CurrentLanguage = langCode
        self:UpdateAllText()
    end

    -- Get language dropdown options
    function TranslationSystem:GetLanguageOptions()
        local options = {}
        for _, lang in ipairs(self.AvailableLanguages) do
            table.insert(options, lang.flag .. " " .. lang.name)
        end
        return options
    end

    -- Get language code from dropdown value (index or string)
    function TranslationSystem:GetLanguageCode(value)
        -- If value is a number (index), use it directly
        if type(value) == "number" then
            if self.AvailableLanguages[value] then
                return self.AvailableLanguages[value].code
            end
        end

        -- If value is a string (language name with flag), find matching language
        if type(value) == "string" then
            for _, lang in ipairs(self.AvailableLanguages) do
                local displayName = lang.flag .. " " .. lang.name
                if displayName == value then
                    return lang.code
                end
            end
        end

        return "en"
    end

    -- Get current language index
    function TranslationSystem:GetLanguageIndex()
        for i, lang in ipairs(self.AvailableLanguages) do
            if lang.code == self.CurrentLanguage then
                return i
            end
        end
        return 1
    end
end
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
    local HttpService = game:GetService("HttpService")
    local localizationOk, LocalizationService = pcall(function()
        return game:GetService("LocalizationService")
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
        Name = "Script default",
        UseOriginal = true,
        BuiltIn = true
    }
    FontManager.ProfileOrder[1] = "default"

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
    local function forDisplay(entry, translated)
        local source = entry.OriginalText
        if type(translated) ~= "string" or source:find("<", 1, true) or source:find("&[%w#]+;") then
            return translated
        end
        local richText = false
        pcall(function()
            richText = entry.Object.RichText == true
        end)
        if not richText then
            return translated
        end
        return (translated:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
    end

    local function setEntryText(entry, text, expectedRevision)
        if expectedRevision and expectedRevision ~= I18n.Revision then
            return
        end
        if not entry or not entry.Object then
            return
        end
        local changed = false
        pcall(function()
            if entry.Object[entry.Property] ~= text then
                entry.Object[entry.Property] = text
                changed = true
            end
        end)
        if changed and FontManager:NeedsApply() then
            local fontEntry = FontManager.Registry[entry.Object]
            if fontEntry then
                FontManager:ApplyObject(fontEntry)
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
            if ok and type(environment) == "table" and type(environment.Fluent) == "table" then
                environment.Fluent.CurrentLanguage = locale
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
            Object = textObject,
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
        self:ApplyEntry(entry)
        return textObject
    end

    function I18n:AutoRegister(textObject, properties)
        if not isTextObject(textObject) then
            return
        end
        properties = properties or {}
        if properties.I18nSkip or type(properties.Text) ~= "string" or properties.Text == "" then
            FontManager:Track(textObject, properties.FontRole)
            return
        end
        self:Register(textObject, properties.Text, "Text", {
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

    function I18n:TryRoblox(entry, revision, callback)
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
                        return translator:Translate(entry.Object, entry.OriginalText)
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

    function I18n:ApplyEntry(entry)
        if not entry or entry.Skip then
            return
        end

        local revision = self.Revision
        local source = entry.OriginalText
        if not self.Enabled or TranslationSystem.Enabled == false or self.Mode == "source"
            or localeBase(self.CurrentLocale) == localeBase(self.SourceLocale) then
            setEntryText(entry, source, revision)
            return
        end

        local manual = self:GetManualTranslation(entry, self.CurrentLocale)
        if manual then
            setEntryText(entry, forDisplay(entry, manual), revision)
            return
        end

        setEntryText(entry, source, revision)
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
                setEntryText(entry, forDisplay(entry, translated), revision)
            elseif tryMachine then
                self:TryMachine(entry, revision, function(machineTranslated)
                    if machineTranslated then
                        setEntryText(entry, forDisplay(entry, machineTranslated), revision)
                    end
                end)
            end
        end

        if tryRoblox then
            self:TryRoblox(entry, revision, afterRoblox)
        elseif tryMachine then
            self:TryMachine(entry, revision, function(machineTranslated)
                if machineTranslated then
                    setEntryText(entry, forDisplay(entry, machineTranslated), revision)
                end
            end)
        end
    end

    function I18n:UpdateText(textObject)
        local entry = self.Registry[textObject]
        if entry then
            self:ApplyEntry(entry)
        end
    end

    function I18n:UpdateAllText()
        for textObject, entry in pairs(self.Registry) do
            if textObject and textObject.Parent then
                self:ApplyEntry(entry)
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
                generatedBy = "ATG Fluent"
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

        local defaultProfile = self.Profiles.default
        self.Profiles = {default = defaultProfile}
        self.ProfileOrder = {"default"}
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
                profile.Id = sanitizeSegment(profile.Id, "font")
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
            local originalFace, originalTextSize, originalLineHeight, originalStrokeTransparency
            pcall(function()
                originalFace = textObject.FontFace
                originalTextSize = textObject.TextSize
                originalLineHeight = textObject.LineHeight
                originalStrokeTransparency = textObject.TextStrokeTransparency
            end)
            entry = {
                Object = textObject,
                OriginalFace = originalFace,
                OriginalTextSize = originalTextSize,
                OriginalLineHeight = originalLineHeight,
                OriginalStrokeTransparency = originalStrokeTransparency,
                Role = role
            }
            self.Registry[textObject] = entry
            -- Weak keys alone are not enough because the value also refers to
            -- the instance. Explicit cleanup keeps virtualized dropdown rows
            -- and notifications from accumulating during long sessions.
            pcall(function()
                entry.Cleanup = textObject.Destroying:Connect(function()
                    self.Registry[textObject] = nil
                    I18n.Registry[textObject] = nil
                end)
            end)
        elseif role then
            entry.Role = role
        end
        -- A new object already has its script FontFace. Avoid assigning that
        -- same value again unless a custom profile is active.
        if self.CurrentProfile ~= "default" then
            self:ApplyObject(entry)
        elseif self.TextStyleConfig and self.TextStyleConfig.Enabled then
            self:ApplyObject(entry)
        end
    end

    function FontManager:ApplyTextStyle(entry)
        if not entry or not entry.Object then
            return
        end
        local textObject = entry.Object
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

    function FontManager:ApplyObject(entry)
        if not entry or not entry.Object then
            return false
        end
        local profile = self.Profiles[self.CurrentProfile] or self.Profiles.default
        local displayedText = ""
        pcall(function()
            displayedText = entry.Object.Text
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
            self:ApplyTextStyle(entry)
            return false, entry.LastError
        end
        if face then
            pcall(function()
                entry.Object.FontFace = face
            end)
            self:ApplyTextStyle(entry)
            return true
        elseif profile and profile.UseOriginal and entry.OriginalFace then
            pcall(function()
                entry.Object.FontFace = entry.OriginalFace
            end)
            self:ApplyTextStyle(entry)
            return true
        elseif faceError then
            entry.LastError = faceError
            self:ApplyTextStyle(entry)
            return false, faceError
        end
        self:ApplyTextStyle(entry)
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
                self:ApplyObject(entry)
            else
                if entry.Cleanup then
                    pcall(function()
                        entry.Cleanup:Disconnect()
                    end)
                end
                self.Registry[textObject] = nil
            end
        end
    end

    function FontManager:ClearRegistry()
        for textObject, entry in pairs(self.Registry) do
            if entry.Cleanup then
                pcall(function()
                    entry.Cleanup:Disconnect()
                end)
            end
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
        if profileId == "default" then
            return false, "The default font profile cannot be removed."
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
					{68, "ModuleScript", {"Darker"}}
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
					{24, "ModuleScript", {"Keybind"}}
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
					{11, "ModuleScript", {"Element"}}
				}
			}
		}
	}
}
local moduleFunctions = {
	function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(1)
		local Lighting, RunService, localPlayer, UserInputService, TweenService, camera =
			game:GetService "Lighting",
		game:GetService "RunService",
		game:GetService "Players".LocalPlayer,
		game:GetService "UserInputService",
		game:GetService "TweenService",
		game:GetService "Workspace".CurrentCamera
		local mouse, libraryRoot = localPlayer:GetMouse(), moduleScript
		local Creator, elementModules, Acrylic, Components = requireModule(libraryRoot.Creator), requireModule(libraryRoot.Elements), requireModule(libraryRoot.Acrylic), libraryRoot.Components
		local Notification, New, protectGui = requireModule(Components.Notification), Creator.New, protectgui or (syn and syn.protect_gui) or function()
		end
		local gui = New("ScreenGui", {Parent = RunService:IsStudio() and localPlayer.PlayerGui or game:GetService "CoreGui"})
		protectGui(gui)
		Notification:Init(gui)
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
			Version = "1.6.0",
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
			-- Compatibility facade plus the modern customization APIs.
			Translation = TranslationSystem,
			I18n = CustomizationSystem.I18n,
			Fonts = CustomizationSystem.Fonts,
			RemoteAssets = CustomizationSystem.RemoteAssets,
			Capabilities = CustomizationSystem.Capabilities,
			Customization = CustomizationSystem,
			CurrentLanguage = "en"
		}
		-- Dropdowns currently open; closed on minimize, tab change and unload.
		Library._OpenDropdowns = {}
		function Library._CloseDropdowns()
			for dropdown in pairs(Library._OpenDropdowns) do
				pcall(dropdown.Close, dropdown)
			end
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
		function Library.SafeCallback(_, callback, ...)
			if not callback then
				return
			end
			local ok, err = pcall(callback, ...)
			if not ok then
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
		function Library.GetIcon(_, name)
			if name ~= nil and iconAssets["lucide-" .. name] then
				return iconAssets["lucide-" .. name]
			end
			return nil
		end
		--[[
			Workspace is deliberately independent from InterfaceManager.  Old scripts
			get the productivity surface automatically, while InterfaceManager only
			provides persistence scope/customization settings.  It owns no script
			callbacks and never scans CoreGui, so it remains inexpensive in long
			sessions and safe on executors without a file system.
		]]
		local WorkspaceHttpService = game:GetService("HttpService")
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
			self:ApplyTabOrder()
			self:ApplyModes()
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
			local compact = self.State.CompactMode == true
			local focus = self.State.FocusMode == true
			for _, tab in ipairs(self.Tabs) do
				if tab.Frame then
					if self.SearchActive then
						tab.Frame.Visible = self.SearchMatchedTabs and self.SearchMatchedTabs[tab.Id] == true
					else
						tab.Frame.Visible = not focus or tab.Selected
					end
				end
				if tab.Label then
					if compact and tab.IconObject and tab.IconObject.Image ~= "" then
						tab.Label.Visible = false
					elseif compact then
						tab._ATGCompactLabel = true
						tab.Label.Visible = true
						tab.Label.Text = tostring(tab.OriginalLabelText or tab.Name):sub(1, 1)
						tab.Label.Position = UDim2.new(0, 0, 0.5, 0)
						tab.Label.Size = UDim2.new(1, 0, 1, 0)
						tab.Label.TextXAlignment = Enum.TextXAlignment.Center
					else
						tab.Label.Visible = true
						if tab._ATGCompactLabel then
							tab._ATGCompactLabel = nil
							tab.Label.Text = tab.OriginalLabelText or tab.Name
							pcall(function() TranslationSystem:UpdateText(tab.Label) end)
						end
						tab.Label.Position = tab.IconObject and tab.IconObject.Image ~= "" and UDim2.new(0, 30, 0.5, 0) or UDim2.new(0, 12, 0.5, 0)
						tab.Label.Size = UDim2.new(1, -12, 1, 0)
						tab.Label.TextXAlignment = Enum.TextXAlignment.Left
					end
				end
				if compact and tab.IconObject and tab.IconObject.Image ~= "" then
					tab.IconObject.Position = UDim2.new(0.5, -8, 0.5, 0)
				elseif tab.IconObject then
					tab.IconObject.Position = UDim2.new(0, 8, 0.5, 0)
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
			if self.Window and type(self.Window.SetTabWidth) == "function" then
				self.Window:SetTabWidth(enabled and 54 or self.OriginalTabWidth)
			end
			if self.Sidebar then
				self.Sidebar.Size = UDim2.new(0, enabled and 54 or self.OriginalTabWidth, 0, enabled and 0 or 26)
				self.SidebarSearch.Visible = not enabled
			end
			if self.Window and self.Window.TabArea then
				-- Tabs start at Fluent's 54px, or below the search box when shown.
				local top = self.Sidebar and 88 or 54
				self.Window.TabArea.Position = UDim2.new(0, 12, 0, enabled and 54 or top)
				self.Window.TabArea.Size = UDim2.new(0, enabled and 54 or self.OriginalTabWidth, 1, enabled and -66 or -(top + 12))
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
					local canvasY = math.max(0, entry.Frame.AbsolutePosition.Y - scrollFrame.AbsolutePosition.Y + scrollFrame.CanvasPosition.Y - 12)
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
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", options.Weight or Enum.FontWeight.Regular, Enum.FontStyle.Normal),
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
		function Workspace:AddSearchControlCard(entry, order)
			-- Kept private for old callers, but intentionally never mounts cards.
			if false then
			local title, description = self:GetEntryDisplayText(entry)
			if title == "" then title = tostring(entry.Title or entry.Type or "Control") end
			local tabTitle = self:GetTabDisplayTitle(entry.Tab)
			local entryType = tostring(entry.Type or "Control")
			local icons = {
				Toggle = "toggle-left", Button = "mouse-pointer-click", Input = "text-cursor-input", Dropdown = "chevron-down",
				Slider = "sliders-horizontal", Keybind = "keyboard", Paragraph = "align-left", Colorpicker = "palette"
			}
			local card = self:Button(self.SearchSurface, title, icons[entryType] or "search", function()
				if self.SidebarSearch then self.SidebarSearch.Text = "" end
				self:Navigate(entry)
			end, {
				Height = 48, ZIndex = 101, BackgroundTransparency = 0.05, StrokeTransparency = 0.62
			})
			card.LayoutOrder = order
			local titleLabel = card:FindFirstChild("Title")
			if titleLabel then
				titleLabel.Size = UDim2.new(1, -42, 0, 19)
				titleLabel.Position = UDim2.fromOffset(30, 3)
			end
			self:Text(card, description ~= "" and description or (tabTitle ~= "" and tabTitle or entryType), 10, {
				Name = "Description", Color = "SubText", Size = UDim2.new(1, -42, 0, 16),
				Position = UDim2.fromOffset(30, 21), ZIndex = 102
			})
			self:Text(card, (tabTitle ~= "" and tabTitle .. "  •  " or "") .. entryType, 9, {
				Name = "Type", Color = "Accent", Size = UDim2.new(1, -42, 0, 13),
				Position = UDim2.fromOffset(30, 34), ZIndex = 102
			})
			table.insert(self.SearchCards, card)
			end
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
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal), TextXAlignment = Enum.TextXAlignment.Left, I18nSkip = true, ZIndex = content.ZIndex + 1
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
			if self.Palette and self.Palette.Visible then self:RenderPalette(self.PaletteInput.Text) end
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
				Position = UDim2.fromOffset(12, 52), BackgroundTransparency = 1, ZIndex = 20
			})
			self.SidebarSearch = New("TextBox", {
				Name = "Search", Parent = self.Sidebar, Size = UDim2.new(1, 0, 0, 26), Position = UDim2.fromOffset(0, 0),
				BackgroundTransparency = 0.1, BorderSizePixel = 0, ClearTextOnFocus = false,
				Text = "", PlaceholderText = "Search...  Ctrl+K",
				ThemeTag = {BackgroundColor3 = "DialogInput", TextColor3 = "Text", PlaceholderColor3 = "SubText"},
				TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal), I18nSkip = true, ZIndex = 21
			})
			New("UICorner", {CornerRadius = UDim.new(0, 7), Parent = self.SidebarSearch})
			New("UIStroke", {Transparency = 0.45, Parent = self.SidebarSearch, ThemeTag = {Color = "Accent"}})
			New("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = self.SidebarSearch})
			self:UpdateSearchHint()
			self:Connect(self.SidebarSearch:GetPropertyChangedSignal("Text"), function()
				local text = self.SidebarSearch.Text
				self:QueueSidebarSearch(text)
			end)
			window.TabArea.Position = UDim2.new(0, 12, 0, 88)
			window.TabArea.Size = UDim2.new(0, self.OriginalTabWidth, 1, -100)
			self:CreatePanel()
		end
		function Workspace:RenderPalette(query)
			if not self.PaletteContent then return end
			self:ClearList(self.PaletteContent)
			query = query or ""
			local normalized = workspaceTrim(query):lower()
			local commands = {
				{Title = "Open Favorites", Icon = "star", Match = "favorites favorite star", Action = function() self:ClosePalette(); self:RenderFavorites() end},
				{Title = "Open Profiles", Icon = "bookmark", Match = "profiles profile config", Action = function() self:ClosePalette(); self:RenderProfiles() end},
				{Title = "Notification history", Icon = "history", Match = "history notifications activity", Action = function() self:ClosePalette(); self:RenderHistory() end},
				{Title = "Toggle compact sidebar", Icon = "layout-dashboard", Match = "compact sidebar layout", Action = function() self:SetCompact(not self.State.CompactMode); self:ClosePalette() end},
				{Title = "Toggle focus mode", Icon = "focus", Match = "focus mode", Action = function() self:SetFocus(not self.State.FocusMode); self:ClosePalette() end}
			}
			for _, command in ipairs(commands) do
				if normalized == "" or command.Title:lower():find(normalized, 1, true) or command.Match:find(normalized, 1, true) then
					self:Button(self.PaletteContent, command.Title, command.Icon, command.Action, {Height = 34, ZIndex = 94})
				end
			end
			local found = self:FindEntries(query)
			if #found > 0 then
				self:Text(self.PaletteContent, normalized == "" and "Recent" or "Results", 10, {
					Color = "SubText", Weight = Enum.FontWeight.SemiBold, Size = UDim2.new(1, 0, 0, 20), ZIndex = 94
				})
				self:RenderEntries(self.PaletteContent, found, "")
			end
		end
		function Workspace:CreatePalette()
			-- Retained as a harmless compatibility method. Search lives in the
			-- sidebar so it can keep showing the original controls.
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
		function Workspace:ClosePalette()
			if not self.Palette or not self.Palette.Visible then return end
			local hide = TweenService:Create(self.Palette, TweenInfo.new(0.14, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {GroupTransparency = 1})
			hide:Play()
			hide.Completed:Connect(function()
				if self.Palette and self.Palette.GroupTransparency >= 0.99 then self.Palette.Visible = false end
			end)
		end
		function Workspace:Attach(window)
			if self.Window then return self end
			self.Window = window
			self.OriginalTabWidth = tonumber(window.TabWidth) or 180
			self:Load()
			-- Tabs and elements are always registered for the API; the search
			-- box, its panel and Ctrl+K are opt-in with CreateWindow{Search = true}.
			self.SearchEnabled = Library.SearchEnabled == true
			if self.SearchEnabled then
				self:CreateChrome()
			end
			self:SetCompact(self.State.CompactMode)
			self:SetFocus(self.State.FocusMode)
			self:Connect(UserInputService.InputBegan, function(input, gameProcessed)
				if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
				if input.KeyCode == Enum.KeyCode.Escape and self.Palette and self.Palette.Visible then self:ClosePalette(); return end
				if self.SearchEnabled and not gameProcessed and input.KeyCode == Enum.KeyCode.K and not UserInputService:GetFocusedTextBox() and
					(UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
					self:OpenPalette()
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
			self.Sidebar, self.SidebarSearch, self.SidebarToolbar, self.ToolbarLayout = nil, nil, nil, nil
			self.Panel, self.PanelContent, self.PanelTitle, self.Palette, self.PaletteInput, self.PaletteContent = nil, nil, nil, nil, nil, nil
			self.SearchSurface, self.SearchSurfaceLayout, self.SearchCards, self.SearchMatchedTabs = nil, nil, nil, nil
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
		local Elements = {}
		Elements.__index = Elements
		Elements.__namecall = function(_, methodName, ...)
			return Elements[methodName](...)
		end
		for _, elementModule in ipairs(elementModules) do
			Elements["Add" .. elementModule.__type] = function(parent, key, config)
				elementModule.Container = parent.Container
				elementModule.Type = parent.Type
				elementModule.ScrollFrame = parent.ScrollFrame
				elementModule.Library = Library
				local options = type(config) == "table" and config or (type(key) == "table" and key or nil)
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
				if Library.Workspace then
					Library.Workspace:RegisterElement(element, parent, options, elementModule.__type, type(key) == "string" and key or nil)
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
			if config.Splash == true then
				showSplash()
			end
			Library.UseAcrylic = config.Acrylic
			if config.Acrylic then
				Acrylic.init()
			end
			local window =
				requireModule(Components.Window) {Parent = gui, Size = config.Size, Title = config.Title, SubTitle = config.SubTitle, TabWidth = config.TabWidth}
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
			Library:SetTheme(config.Theme)
			if config.FloatingToggle ~= false then
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
		function Library.SetTheme(_, themeName)
			if Library.Window and table.find(Library.Themes, themeName) then
				Library.Theme = themeName
				Creator.UpdateTheme()
			end
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
			removeLegacyFloatingToggles()
			Library._CloseDropdowns()
			if Library.UseAcrylic then
				-- Acrylic.Disable only exists after Acrylic.init; it removes the
				-- DepthOfFieldEffect the blur added to Lighting.
				if type(Acrylic.Disable) == "function" then
					pcall(Acrylic.Disable)
				end
				Library.Window.AcrylicPaint.Model:Destroy()
			end
			Creator.Disconnect()
			Creator.StopRainbow()
			Library.GUI:Destroy()
		end
		function Library.ToggleAcrylic(_, enabled)
			if Library.Window then
				if Library.UseAcrylic then
					Library.Acrylic = enabled
					Library.Window.AcrylicPaint.Model.Transparency = enabled and 0.98 or 1
					if enabled then
						Acrylic.Enable()
					else
						Acrylic.Disable()
					end
				end
			end
		end
		function Library.ToggleTransparency(_, enabled)
			if Library.Window then
				Library.Window.AcrylicPaint.Frame.Background.BackgroundTransparency = enabled and 0.35 or 0
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
		end
		return Library
	end,
	function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(2)
		local Acrylic = {AcrylicBlur = requireModule(moduleScript.AcrylicBlur), CreateAcrylic = requireModule(moduleScript.CreateAcrylic), AcrylicPaint = requireModule(moduleScript.AcrylicPaint)}
		function Acrylic.init()
			local baseEffect = Instance.new "DepthOfFieldEffect"
			baseEffect.FarIntensity = 0
			baseEffect.InFocusRadius = 0.1
			baseEffect.NearIntensity = 1
			local depthOfFieldDefaults = {}
			function Acrylic.Enable()
				for _, effect in pairs(depthOfFieldDefaults) do
					effect.Enabled = false
				end
				baseEffect.Parent = game:GetService "Lighting"
			end
			function Acrylic.Disable()
				for _, effect in pairs(depthOfFieldDefaults) do
					effect.Enabled = effect.enabled
				end
				baseEffect.Parent = nil
			end
			local registerDefaults = function()
				local register = function(object)
					if object:IsA "DepthOfFieldEffect" then
						depthOfFieldDefaults[object] = {enabled = object.Enabled}
					end
				end
				for _, child in pairs(game:GetService "Lighting":GetChildren()) do
					register(child)
				end
				if game:GetService "Workspace".CurrentCamera then
					for _, child in pairs(game:GetService "Workspace".CurrentCamera:GetChildren()) do
						register(child)
					end
				end
			end
			registerDefaults()
			Acrylic.Enable()
		end
		return Acrylic
	end,
	function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(3)
		local Creator, createAcrylic, viewportPointToWorld, getOffset = requireModule(moduleScript.Parent.Parent.Creator), requireModule(moduleScript.Parent.CreateAcrylic), unpack(requireModule(moduleScript.Parent.Utils))
		local createAcrylicBlur = function(distance)
			local cleanups = {}
			distance = distance or 0.001
			local positions, model = {topLeft = Vector2.new(), topRight = Vector2.new(), bottomRight = Vector2.new()}, createAcrylic()
			model.Parent = workspace
			local updatePositions, render = function(size, position)
				positions.topLeft = position
				positions.topRight = position + Vector2.new(size.X, 0)
				positions.bottomRight = position + size
			end, function()
				local cameraCFrame = game:GetService "Workspace".CurrentCamera
				if cameraCFrame then
					cameraCFrame = cameraCFrame.CFrame
				end
				local resolvedCFrame = cameraCFrame
				if not resolvedCFrame then
					resolvedCFrame = CFrame.new()
				end
				local viewCFrame, topLeft, topRight, bottomRight = resolvedCFrame, positions.topLeft, positions.topRight, positions.bottomRight
				local topLeft3D, topRight3D, bottomRight3D = viewportPointToWorld(topLeft, distance), viewportPointToWorld(topRight, distance), viewportPointToWorld(bottomRight, distance)
				local width, height = (topRight3D - topLeft3D).Magnitude, (topRight3D - bottomRight3D).Magnitude
				model.CFrame = CFrame.fromMatrix((topLeft3D + bottomRight3D) / 2, viewCFrame.XVector, viewCFrame.YVector, viewCFrame.ZVector)
				model.Mesh.Scale = Vector3.new(width, height, 0)
			end
			local onChange, renderOnChange = function(frame)
				local offset = getOffset()
				local size, position = frame.AbsoluteSize - Vector2.new(offset, offset), frame.AbsolutePosition + Vector2.new(offset / 2, offset / 2)
				updatePositions(size, position)
				task.spawn(render)
			end, function()
				local camera = game:GetService "Workspace".CurrentCamera
				if not camera then
					return
				end
				table.insert(cleanups, camera:GetPropertyChangedSignal "CFrame":Connect(render))
				table.insert(cleanups, camera:GetPropertyChangedSignal "ViewportSize":Connect(render))
				table.insert(cleanups, camera:GetPropertyChangedSignal "FieldOfView":Connect(render))
				task.spawn(render)
			end
			model.Destroying:Connect(
				function()
					for _, connection in cleanups do
						pcall(
							function()
								connection:Disconnect()
							end
						)
					end
				end
			)
			renderOnChange()
			return onChange, model
		end
		return function(distance)
			local Blur, onChange, model = {}, createAcrylicBlur(distance)
			local frame = Creator.New("Frame", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)})
			Creator.AddSignal(
				frame:GetPropertyChangedSignal "AbsolutePosition",
				function()
					onChange(frame)
				end
			)
			Creator.AddSignal(
				frame:GetPropertyChangedSignal "AbsoluteSize",
				function()
					onChange(frame)
				end
			)
			Blur.AddParent = function(parentFrame)
				Creator.AddSignal(
					parentFrame:GetPropertyChangedSignal "Visible",
					function()
						Blur.SetVisibility(parentFrame.Visible)
					end
				)
			end
			Blur.SetVisibility = function(visible)
				model.Transparency = visible and 0.98 or 1
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
		return function(_props)
			local Paint = {}
			Paint.Frame =
				New(
					"Frame",
					{
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 0.9,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BorderSizePixel = 0
					},
					{
						New(
							"ImageLabel",
							{
								Image = "rbxassetid://8992230677",
								ScaleType = "Slice",
								SliceCenter = Rect.new(Vector2.new(99, 99), Vector2.new(99, 99)),
								AnchorPoint = Vector2.new(0.5, 0.5),
								Size = UDim2.new(1, 120, 1, 116),
								Position = UDim2.new(0.5, 0, 0.5, 0),
								BackgroundTransparency = 1,
								ImageColor3 = Color3.fromRGB(0, 0, 0),
								ImageTransparency = 0.7
							}
						),
						New("UICorner", {CornerRadius = UDim.new(0, 8)}),
						New(
							"Frame",
							{
								BackgroundTransparency = 0.45,
								Size = UDim2.fromScale(1, 1),
								Name = "Background",
								ThemeTag = {BackgroundColor3 = "AcrylicMain"}
							},
							{New("UICorner", {CornerRadius = UDim.new(0, 8)})}
						),
						New(
							"Frame",
							{
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 0.4,
								Size = UDim2.fromScale(1, 1)
							},
							{
								New("UICorner", {CornerRadius = UDim.new(0, 8)}),
								New("UIGradient", {Rotation = 90, ThemeTag = {Color = "AcrylicGradient"}})
							}
						),
						New(
							"ImageLabel",
							{
								Image = "rbxassetid://9968344105",
								ImageTransparency = 0.98,
								ScaleType = Enum.ScaleType.Tile,
								TileSize = UDim2.new(0, 128, 0, 128),
								Size = UDim2.fromScale(1, 1),
								BackgroundTransparency = 1
							},
							{New("UICorner", {CornerRadius = UDim.new(0, 8)})}
						),
						New(
							"ImageLabel",
							{
								Image = "rbxassetid://9968344227",
								ImageTransparency = 0.9,
								ScaleType = Enum.ScaleType.Tile,
								TileSize = UDim2.new(0, 128, 0, 128),
								Size = UDim2.fromScale(1, 1),
								BackgroundTransparency = 1,
								ThemeTag = {ImageTransparency = "AcrylicNoise"}
							},
							{New("UICorner", {CornerRadius = UDim.new(0, 8)})}
						),
						New(
							"Frame",
							{BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 2},
							{
								New("UICorner", {CornerRadius = UDim.new(0, 8)}),
								New("UIStroke", {Transparency = 0.5, Thickness = 1, ThemeTag = {Color = "AcrylicBorder"}})
							}
						)
					}
				)
			local blur
			if requireModule(moduleScript.Parent.Parent).UseAcrylic then
				blur = AcrylicBlur()
				blur.Frame.Parent = Paint.Frame
				Paint.Model = blur.Model
				Paint.AddParent = blur.AddParent
				Paint.SetVisibility = blur.SetVisibility
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
						Name = "Body",
						Color = Color3.new(0, 0, 0),
						Material = Enum.Material.Glass,
						Size = Vector3.new(1, 1, 0),
						Anchored = true,
						CanCollide = false,
						Locked = true,
						CastShadow = false,
						Transparency = 0.98
					},
					{Creator.New("SpecialMesh", {MeshType = Enum.MeshType.Brick, Offset = Vector3.new(0, 0, -1E-6)})}
				)
			return part
		end
		return createAcrylic
	end,
	function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(6)
		local map, viewportPointToWorld = function(value, inMin, inMax, outMin, outMax)
			return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
		end, function(location, distance)
			local ray = game:GetService "Workspace".CurrentCamera:ScreenPointToRay(location.X, location.Y)
			return ray.Origin + ray.Direction * distance
		end
		local getOffset = function()
			local viewportHeight = game:GetService "Workspace".CurrentCamera.ViewportSize.Y
			return map(viewportHeight, 0, 2560, 8, 56)
		end
		return {viewportPointToWorld, getOffset}
	end,
	[8] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(8)
		return {
			Close = "rbxassetid://9886659671",
			Min = "rbxassetid://9886659276",
			Max = "rbxassetid://9886659406",
			Restore = "rbxassetid://9886659001"
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
						FontFace = Font.new "rbxasset://fonts/families/GothamSSm.json",
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
						New("UICorner", {CornerRadius = UDim.new(0, 4)}),
						New(
							"UIStroke",
							{
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								Transparency = 0.65,
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
		local UserInputService, mouse, camera, Root =
			game:GetService "UserInputService",
		game:GetService "Players".LocalPlayer:GetMouse(),
		game:GetService "Workspace".CurrentCamera,
		moduleScript.Parent.Parent
		local Flipper, Creator = requireModule(Root.Packages.Flipper), requireModule(Root.Creator)
		local Spring, Instant, New, Dialog = Flipper.Spring.new, Flipper.Instant.new, Creator.New, {Window = nil}
		function Dialog.Init(_self, window)
			Dialog.Window = window
			return Dialog
		end
		function Dialog.Create(_self)
			local NewDialog = {Buttons = 0}
			NewDialog.TintFrame =
				New(
					"TextButton",
					{
						Text = "",
						Size = UDim2.fromScale(1, 1),
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						BackgroundTransparency = 1,
						Parent = Dialog.Window.Root
					},
					{New("UICorner", {CornerRadius = UDim.new(0, 8)})}
				)
			local tintMotor, setTintTransparency = Creator.SpringMotor(1, NewDialog.TintFrame, "BackgroundTransparency", true)
			NewDialog.ButtonHolder =
				New(
					"Frame",
					{
						Size = UDim2.new(1, -40, 1, -40),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						BackgroundTransparency = 1
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
						ThemeTag = {BackgroundColor3 = "DialogHolder"}
					},
					{
						New("Frame", {Size = UDim2.new(1, 0, 0, 1), ThemeTag = {BackgroundColor3 = "DialogHolderLine"}}),
						NewDialog.ButtonHolder
					}
				)
			NewDialog.Title =
				New(
					"TextLabel",
					{
						FontFace = Font.new(
							"rbxasset://fonts/families/GothamSSm.json",
							Enum.FontWeight.SemiBold,
							Enum.FontStyle.Normal
						),
						Text = "Dialog",
						TextColor3 = Color3.fromRGB(240, 240, 240),
						TextSize = 22,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(1, 0, 0, 22),
						Position = UDim2.fromOffset(20, 25),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						ThemeTag = {TextColor3 = "Text"}
					}
				)
			NewDialog.Scale = New("UIScale", {Scale = 1})
			local scaleMotor, setScale = Creator.SpringMotor(1.1, NewDialog.Scale, "Scale")
			NewDialog.Root =
				New(
					"CanvasGroup",
					{
						Size = UDim2.fromOffset(300, 165),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						GroupTransparency = 1,
						Parent = NewDialog.TintFrame,
						ThemeTag = {BackgroundColor3 = "Dialog"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 8)}),
						New("UIStroke", {Transparency = 0.5, ThemeTag = {Color = "DialogBorder"}}),
						NewDialog.Scale,
						NewDialog.Title,
						NewDialog.ButtonHolderFrame
					}
				)
			local rootMotor, setRootTransparency = Creator.SpringMotor(1, NewDialog.Root, "GroupTransparency")
			function NewDialog.Open(_self)
				requireModule(Root).DialogOpen = true
				NewDialog.Scale.Scale = 1.1
				setTintTransparency(0.75)
				setRootTransparency(0)
				setScale(1)
			end
			function NewDialog.Close(_self)
				requireModule(Root).DialogOpen = false
				setTintTransparency(1)
				setRootTransparency(1)
				setScale(1.1)
				NewDialog.Root.UIStroke:Destroy()
				task.delay(0.15, function()
					NewDialog.TintFrame:Destroy()
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
						FontFace = Font.new(
							"rbxasset://fonts/families/GothamSSm.json",
							Enum.FontWeight.Medium,
							Enum.FontStyle.Normal
						),
						Text = title,
						TextColor3 = Color3.fromRGB(240, 240, 240),
						TextSize = 13,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 14),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						ThemeTag = {TextColor3 = "Text"}
					}
				)
			Element.DescLabel =
				New(
					"TextLabel",
					{
						FontFace = Font.new "rbxasset://fonts/families/GothamSSm.json",
						Text = desc,
						TextColor3 = Color3.fromRGB(200, 200, 200),
						TextSize = 12,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 14),
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
						Position = UDim2.fromOffset(10, 0),
						Size = UDim2.new(1, -28, 0, 0)
					},
					{
						New(
							"UIListLayout",
							{SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center}
						),
						New("UIPadding", {PaddingBottom = UDim.new(0, 13), PaddingTop = UDim.new(0, 13)}),
						Element.TitleLabel,
						Element.DescLabel
					}
				)
			Element.Border =
				New(
					"UIStroke",
					{
						Transparency = 0.5,
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
					{New("UICorner", {CornerRadius = UDim.new(0, 4)}), Element.Border, Element.LabelHolder}
				)
			-- Text set after the element is built is runtime text (status, counters,
			-- player names), so it is registered as dynamic.
			local built = false
			function Element.SetTitle(_self, text)
				Element.TitleLabel.Text = text
				-- Register with Translation System
				TranslationSystem:Register(Element.TitleLabel, text, "Text", {Dynamic = built})
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
				-- Register with Translation System
				if text ~= "" then
					TranslationSystem:Register(Element.DescLabel, text, "Text", {Dynamic = built})
				end
			end
			function Element.Destroy(_self)
				Element.Frame:Destroy()
			end
			Element:SetTitle(title)
			Element:SetDesc(desc)
			built = true
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
					end
				)
				Creator.AddSignal(
					Element.Frame.MouseLeave,
					function()
						setTransparency(Creator.GetThemeProperty "ElementTransparency")
					end
				)
				Creator.AddSignal(
					Element.Frame.MouseButton1Down,
					function()
						setTransparency(Creator.GetThemeProperty "ElementTransparency" + Creator.GetThemeProperty "HoverChange")
					end
				)
				Creator.AddSignal(
					Element.Frame.MouseButton1Up,
					function()
						setTransparency(Creator.GetThemeProperty "ElementTransparency" - Creator.GetThemeProperty "HoverChange")
					end
				)
			end
			return Element
		end
	end,
	[12] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(12)
		local Root = moduleScript.Parent.Parent
		local Flipper, Creator, Acrylic = requireModule(Root.Packages.Flipper), requireModule(Root.Creator), requireModule(Root.Acrylic)
		local Spring, Instant, New, Notification = Flipper.Spring.new, Flipper.Instant.new, Creator.New, {}

		function Notification.Init(_self, gui)
			-- Responsive width: smaller on mobile, recomputed when the screen
			-- rotates or the window is resized.
			local camera = workspace.CurrentCamera
			local function layout()
				local isMobile = camera.ViewportSize.X < 600
				local sideMargin = isMobile and 10 or 30
				return UDim2.new(1, -sideMargin, 1, -sideMargin), UDim2.new(0, isMobile and 280 or 340, 1, -sideMargin)
			end
			local position, size = layout()

			Notification.Holder =
				New(
					"Frame",
					{
						Position = position,
						Size = size,
						AnchorPoint = Vector2.new(1, 1),
						BackgroundTransparency = 1,
						Parent = gui
					},
					{
						New(
							"UIListLayout",
							{
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								SortOrder = Enum.SortOrder.LayoutOrder,
								VerticalAlignment = Enum.VerticalAlignment.Bottom,
								Padding = UDim.new(0, 8)
							}
						)
					}
				)
			Creator.AddSignal(camera:GetPropertyChangedSignal("ViewportSize"), function()
				Notification.Holder.Position, Notification.Holder.Size = layout()
			end)
		end

		function Notification.New(_self, config)
			config.Title = config.Title or "Notification"
			config.Content = config.Content or "Content"
			config.SubContent = config.SubContent or ""
			config.Duration = config.Duration or nil
			config.Buttons = config.Buttons or {}

			-- Store originals for translation
			local originalTitle = config.Title
			local originalContent = config.Content
			local originalSubContent = config.SubContent

			local NewNotification = {Closed = false}
			NewNotification.AcrylicPaint = Acrylic.AcrylicPaint()

			-- Icon & color mapping
			local icon = "rbxassetid://10723415903"
			local accentColor = Color3.fromRGB(76, 194, 255)

			if config.Title:lower():find("success") or config.Title:lower():find("complete") then
				icon = "rbxassetid://10709790387"
				accentColor = Color3.fromRGB(50, 205, 50)
			elseif config.Title:lower():find("error") or config.Title:lower():find("fail") then
				icon = "rbxassetid://10734933655"
				accentColor = Color3.fromRGB(255, 60, 80)
			elseif config.Title:lower():find("warn") then
				icon = "rbxassetid://10709753149"
				accentColor = Color3.fromRGB(255, 180, 0)
			end

			NewNotification.IconFrame =
				New(
					"Frame",
					{
						Size = UDim2.fromOffset(40, 40),
						Position = UDim2.fromOffset(10, 10),
						BackgroundColor3 = accentColor,
						BackgroundTransparency = 0.88,
						BorderSizePixel = 0
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 10)}),
						New(
							"UIStroke",
							{
								Color = accentColor,
								Transparency = 0.7,
								Thickness = 1
							}
						),
						New(
							"ImageLabel",
							{
								Size = UDim2.fromOffset(22, 22),
								Position = UDim2.fromScale(0.5, 0.5),
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundTransparency = 1,
								Image = icon,
								ImageColor3 = accentColor
							}
						)
					}
				)

			NewNotification.Title =
				New(
					"TextLabel",
					{
						Position = UDim2.new(0, 58, 0, 12),
						Text = config.Title,
						I18nDynamic = true,
						RichText = true,
						TextTransparency = 0,
						FontFace = Font.new(
							"rbxasset://fonts/families/GothamSSm.json",
							Enum.FontWeight.Bold,
							Enum.FontStyle.Normal
						),
						TextSize = 14,
						TextXAlignment = "Left",
						TextYAlignment = "Center",
						Size = UDim2.new(1, -98, 0, 16),
						TextWrapped = true,
						BackgroundTransparency = 1,
						ThemeTag = {TextColor3 = "Text"}
					}
				)
			-- Register Title for translation (notification text is dynamic)
			TranslationSystem:Register(NewNotification.Title, originalTitle, "Text", {Dynamic = true})

			NewNotification.ContentLabel =
				New(
					"TextLabel",
					{
						FontFace = Font.new(
							"rbxasset://fonts/families/GothamSSm.json",
							Enum.FontWeight.Regular,
							Enum.FontStyle.Normal
						),
						Text = config.Content,
						I18nDynamic = true,
						TextColor3 = Color3.fromRGB(240, 240, 240),
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 12),
						BackgroundTransparency = 1,
						TextWrapped = true,
						ThemeTag = {TextColor3 = "Text"}
					}
				)
			-- Register Content for translation
			TranslationSystem:Register(NewNotification.ContentLabel, originalContent, "Text", {Dynamic = true})

			NewNotification.SubContentLabel =
				New(
					"TextLabel",
					{
						FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
						Text = config.SubContent,
						I18nDynamic = true,
						TextColor3 = Color3.fromRGB(200, 200, 200),
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 12),
						BackgroundTransparency = 1,
						TextWrapped = true,
						ThemeTag = {TextColor3 = "SubText"}
					}
				)
			-- Register SubContent for translation
			if originalSubContent ~= "" then
				TranslationSystem:Register(NewNotification.SubContentLabel, originalSubContent, "Text", {Dynamic = true})
			end

			NewNotification.LabelHolder =
				New(
					"Frame",
					{
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						Position = UDim2.fromOffset(58, 32),
						Size = UDim2.new(1, -68, 0, 0)
					},
					{
						New(
							"UIListLayout",
							{
								SortOrder = Enum.SortOrder.LayoutOrder,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								Padding = UDim.new(0, 3)
							}
						),
						NewNotification.ContentLabel,
						NewNotification.SubContentLabel
					}
				)

			-- Buttons container (dynamic)
			NewNotification.ButtonHolder =
				New(
					"Frame",
					{
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 58, 1, -40),
						Size = UDim2.new(1, -68, 0, 0)
					},
					{
						New(
							"UIListLayout",
							{
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(0, 5),
								HorizontalAlignment = Enum.HorizontalAlignment.Right,
								FillDirection = Enum.FillDirection.Horizontal
							}
						)
					}
				)

			-- Create each dynamic button
			if #config.Buttons > 0 then
				for _, btnData in ipairs(config.Buttons) do
					local text = btnData.Text or "Button"
					local color = btnData.Color or Color3.fromRGB(100, 100, 255)
					-- estimate width (simple): clamp by text length - smaller for mobile
					local estWidth = math.clamp(#tostring(text) * 7 + 20, 64, 140)

					local btnStroke = New(
						"UIStroke",
						{
							Color = color,
							Transparency = 0.5,
							Thickness = 1,
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border
						}
					)

					local btn =
						New(
							"TextButton",
							{
								Text = text,
								FontFace = Font.new(
									"rbxasset://fonts/families/GothamSSm.json",
									Enum.FontWeight.SemiBold,
									Enum.FontStyle.Normal
								),
								TextSize = 13,
								TextColor3 = Color3.fromRGB(255, 255, 255),
								Size = UDim2.fromOffset(estWidth, 26),
								BackgroundColor3 = color,
								BackgroundTransparency = 0.05,
								BorderSizePixel = 0,
								AutoButtonColor = false
							},
							{
								New("UICorner", {CornerRadius = UDim.new(0, 8)}),
								btnStroke
							}
						)

					-- hover spring with smoother animation
					local _, btnSet = Creator.SpringMotor(0.05, btn, "BackgroundTransparency")
					local _, btnStrokeSet = Creator.SpringMotor(0.5, btnStroke, "Transparency")

					Creator.AddSignal(
						btn.MouseEnter,
						function()
							btnSet(0)
							btnStrokeSet(0.2)
						end
					)
					Creator.AddSignal(
						btn.MouseLeave,
						function()
							btnSet(0.05)
							btnStrokeSet(0.5)
						end
					)

					-- click behaviour
					Creator.AddSignal(
						btn.MouseButton1Click,
						function()
							-- safe call to callback
							if type(btnData.Callback) == "function" then
								local ok, err = pcall(btnData.Callback)
								if not ok then
									warn("Notification button callback error:", err)
								end
							end
							-- default close unless btnData.KeepOpen == true
							if not btnData.KeepOpen then
								NewNotification:Close()
							end
						end
					)

					-- parent into holder
					btn.Parent = NewNotification.ButtonHolder
				end
			end

			NewNotification.ProgressBar =
				New(
					"Frame",
					{
						Size = UDim2.new(1, 0, 0, 4),
						Position = UDim2.new(0, 0, 1, -4),
						BackgroundColor3 = accentColor,
						BackgroundTransparency = 0.5,
						BorderSizePixel = 0
					},
					{
						New("UICorner", {CornerRadius = UDim.new(1, 0)}),
						New(
							"UIGradient",
							{
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, accentColor),
									ColorSequenceKeypoint.new(1, Color3.fromRGB(
										math.min(accentColor.R * 255 * 1.2, 255),
										math.min(accentColor.G * 255 * 1.2, 255),
										math.min(accentColor.B * 255 * 1.2, 255)
										))
								})
							}
						)
					}
				)

			NewNotification.CloseButton =
				New(
					"TextButton",
					{
						Text = "",
						Position = UDim2.new(1, -12, 0, 12),
						Size = UDim2.fromOffset(20, 20),
						AnchorPoint = Vector2.new(1, 0),
						BackgroundTransparency = 0.92,
						ThemeTag = {BackgroundColor3 = "Element"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(1, 0)}),
						New(
							"ImageLabel",
							{
								Image = "rbxassetid://10747384394",
								Size = UDim2.fromOffset(12, 12),
								Position = UDim2.fromScale(0.5, 0.5),
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundTransparency = 1,
								ThemeTag = {ImageColor3 = "SubText"}
							}
						)
					}
				)

			NewNotification.Shadow =
				New(
					"ImageLabel",
					{
						Size = UDim2.new(1, 40, 1, 40),
						Position = UDim2.fromOffset(-20, -20),
						BackgroundTransparency = 1,
						Image = "rbxassetid://5554236805",
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(23, 23, 277, 277),
						ImageTransparency = 0.82,
						ImageColor3 = Color3.fromRGB(0, 0, 0),
						ZIndex = 0
					}
				)

			-- Include ButtonHolder in Root children so it renders
			NewNotification.Root =
				New(
					"Frame",
					{BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.fromScale(1, 0)},
					{
						NewNotification.Shadow,
						NewNotification.AcrylicPaint.Frame,
						NewNotification.IconFrame,
						NewNotification.Title,
						NewNotification.CloseButton,
						NewNotification.LabelHolder,
						NewNotification.ButtonHolder,
						NewNotification.ProgressBar
					}
				)

			if config.Content == "" then
				NewNotification.ContentLabel.Visible = false
			end
			if config.SubContent == "" then
				NewNotification.SubContentLabel.Visible = false
			end

			NewNotification.Holder =
				New("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 100), Parent = Notification.Holder}, {NewNotification.Root})

			local motor = Flipper.GroupMotor.new({Scale = 1, Offset = 80, Rotation = 8, Opacity = 0})
			motor:onStep(
				function(values)
					NewNotification.Root.Position = UDim2.new(values.Scale, values.Offset, 0, 0)
					NewNotification.Root.Rotation = values.Rotation
					NewNotification.Root.BackgroundTransparency = values.Opacity
					if NewNotification.AcrylicPaint and NewNotification.AcrylicPaint.Frame then
						NewNotification.AcrylicPaint.Frame.BackgroundTransparency = values.Opacity
					end
				end
			)

			Creator.AddSignal(
				NewNotification.CloseButton.MouseButton1Click,
				function()
					NewNotification:Close()
				end
			)

			local closeMotor, setCloseTransparency = Creator.SpringMotor(0.92, NewNotification.CloseButton, "BackgroundTransparency")
			Creator.AddSignal(
				NewNotification.CloseButton.MouseEnter,
				function()
					setCloseTransparency(0.8)
				end
			)
			Creator.AddSignal(
				NewNotification.CloseButton.MouseLeave,
				function()
					setCloseTransparency(0.92)
				end
			)

			function NewNotification.Open(_self)
				local labelHeight = NewNotification.LabelHolder.AbsoluteSize.Y
				local extraForButtons = (#config.Buttons > 0) and 36 or 0
				NewNotification.Holder.Size = UDim2.new(1, 0, 0, math.max(60, 50 + labelHeight + extraForButtons))

				-- Improved slide-in animation with fade
				motor:setGoal(
					{
						Scale = Spring(0, {frequency = 6, dampingRatio = 0.75}),
						Offset = Spring(0, {frequency = 6, dampingRatio = 0.75}),
						Rotation = Spring(0, {frequency = 7, dampingRatio = 0.85}),
						Opacity = Spring(1, {frequency = 8, dampingRatio = 0.9})
					}
				)

				-- Icon bounce animation - smoother and smaller
				NewNotification.IconFrame.Size = UDim2.fromOffset(0, 0)
				-- Runs on its own thread so Notify returns without yielding.
				local TweenService = game:GetService("TweenService")
				local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
				task.delay(0.15, function()
					TweenService:Create(NewNotification.IconFrame, tweenInfo, {Size = UDim2.fromOffset(40, 40)}):Play()

					-- Subtle glow effect on icon
					task.wait(0.2)
					local iconFrame = NewNotification.IconFrame
					TweenService:Create(iconFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundTransparency = 0.75}):Play()
				end)
			end

			function NewNotification.Close(_self)
				if not NewNotification.Closed then
					NewNotification.Closed = true
					task.spawn(
						function()
							-- Improved slide-out with fade and rotation
							motor:setGoal(
								{
									Scale = Spring(1, {frequency = 7, dampingRatio = 0.8}),
									Offset = Spring(100, {frequency = 7, dampingRatio = 0.8}),
									Rotation = Spring(-8, {frequency = 8, dampingRatio = 0.85}),
									Opacity = Spring(0, {frequency = 6, dampingRatio = 1})
								}
							)

							-- Icon shrink animation
							local TweenService = game:GetService("TweenService")
							TweenService:Create(NewNotification.IconFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
								{Size = UDim2.fromOffset(0, 0)}):Play()

							task.wait(0.6)
							if requireModule(Root).UseAcrylic then
								if NewNotification.AcrylicPaint and NewNotification.AcrylicPaint.Model then
									NewNotification.AcrylicPaint.Model:Destroy()
								end
							end
							if NewNotification.Holder and NewNotification.Holder.Destroy then
								NewNotification.Holder:Destroy()
							end
						end
					)
				end
			end

			NewNotification:Open()

			if config.Duration then
				NewNotification.ProgressBar.Size = UDim2.new(1, 0, 0, 4)
				local TweenService = game:GetService("TweenService")
				local tweenInfo = TweenInfo.new(config.Duration, Enum.EasingStyle.Linear)
				TweenService:Create(NewNotification.ProgressBar, tweenInfo, {Size = UDim2.new(0, 0, 0, 4)}):Play()
				task.delay(
					config.Duration,
					function()
						NewNotification:Close()
					end
				)
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
		return function(title, parent)
			local Section = {}
			Section.Visible = true
			Section.Layout = New("UIListLayout", {Padding = UDim.new(0, 5)})
			Section.Container =
				New(
					"Frame",
					{Size = UDim2.new(1, 0, 0, 26), Position = UDim2.fromOffset(0, 24), BackgroundTransparency = 1},
					{Section.Layout}
				)
			Section.Root =
				New(
					"Frame",
					{BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 26), LayoutOrder = 7, Parent = parent},
					{
						New(
							"TextLabel",
							{
								RichText = true,
								Text = title,
								TextTransparency = 0,
								FontFace = Font.new(
									"rbxassetid://12187365364",
									Enum.FontWeight.SemiBold,
									Enum.FontStyle.Normal
								),
								TextSize = 18,
								TextXAlignment = "Left",
								TextYAlignment = "Center",
								Size = UDim2.new(1, -16, 0, 18),
								Position = UDim2.fromOffset(0, 2),
								ThemeTag = {TextColor3 = "Text"}
							}
						),
						Section.Container
					}
				)
			Creator.AddSignal(
				Section.Layout:GetPropertyChangedSignal "AbsoluteContentSize",
				function()
					Section.Container.Size = UDim2.new(1, 0, 0, Section.Layout.AbsoluteContentSize.Y)
					if Section.Visible then
						Section.Root.Size = UDim2.new(1, 0, 0, Section.Layout.AbsoluteContentSize.Y + 25)
					end
				end
			)
			Section.SetVisible = function(visible)
				Section.Visible = visible == true
				Section.Root.Visible = Section.Visible
				Section.Root.Size = UDim2.new(1, 0, 0, Section.Visible and (Section.Layout.AbsoluteContentSize.Y + 25) or 0)
			end
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
			local tabHolderY, tabY = TabModule.Window.TabHolder.AbsolutePosition.Y, TabModule.Tabs[TabModule.SelectedTab].Frame.AbsolutePosition.Y
			return tabY - tabHolderY
		end
		function TabModule.New(_self, title, icon, parent)
			local Library, window = requireModule(Root), TabModule.Window
			local elements = Library.Elements
			TabModule.TabCount = TabModule.TabCount + 1
			local tabIndex, Tab = TabModule.TabCount, {Selected = false, Name = title, Type = "Tab", Index = TabModule.TabCount}
			Tab.Id = "tab-" .. tostring(tabIndex) .. "-" .. tostring(title)
			if Library:GetIcon(icon) then
				icon = Library:GetIcon(icon)
			end
			if icon == "" or nil then
				icon = nil
			end
			Tab.Frame =
				New(
					"TextButton",
					{
						Size = UDim2.new(1, 0, 0, 34),
						Name = "ATGTab_" .. tostring(tabIndex),
						LayoutOrder = tabIndex,
						BackgroundTransparency = 1,
						Parent = parent,
						ThemeTag = {BackgroundColor3 = "Tab"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 6)}),
						New(
							"TextLabel",
							{
								Name = "TabLabel",
								AnchorPoint = Vector2.new(0, 0.5),
								Position = icon and UDim2.new(0, 30, 0.5, 0) or UDim2.new(0, 12, 0.5, 0),
								Text = title,
								RichText = true,
								TextColor3 = Color3.fromRGB(255, 255, 255),
								TextTransparency = 0,
								FontFace = Font.new(
									"rbxasset://fonts/families/GothamSSm.json",
									Enum.FontWeight.Regular,
									Enum.FontStyle.Normal
								),
								TextSize = 12,
								TextXAlignment = "Left",
								TextYAlignment = "Center",
								Size = UDim2.new(1, -12, 1, 0),
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
								Position = UDim2.new(0, 8, 0.5, 0),
								BackgroundTransparency = 1,
								Image = icon and icon or nil,
								ThemeTag = {ImageColor3 = "Text"}
							}
						)
					}
				)
			Tab.Label = Tab.Frame:FindFirstChild("TabLabel")
			Tab.IconObject = Tab.Frame:FindFirstChild("TabIcon")
			-- Translate the sidebar label as well as the large selected-tab title,
			-- allowing navigation search to match the language users actually see.
			if Tab.Label then
				TranslationSystem:Register(Tab.Label, title, "Text")
			end
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
								PaddingLeft = UDim.new(0, 1),
								PaddingTop = UDim.new(0, 1),
								PaddingBottom = UDim.new(0, 1)
							}
						)
					}
				)
			Creator.AddSignal(
				listLayout:GetPropertyChangedSignal "AbsoluteContentSize",
				function()
					Tab.ContainerFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 2)
				end
			)
			Tab.Motor, Tab.SetTransparency = Creator.SpringMotor(1, Tab.Frame, "BackgroundTransparency")
			Creator.AddSignal(
				Tab.Frame.MouseEnter,
				function()
					Tab.SetTransparency(Tab.Selected and 0.85 or 0.89)
				end
			)
			Creator.AddSignal(
				Tab.Frame.MouseLeave,
				function()
					Tab.SetTransparency(Tab.Selected and 0.89 or 1)
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
			function Tab.AddSection(_self, sectionTitle)
				local Section, sectionComponent = {Type = "Section"}, requireModule(Components.Section)(decorateSectionTitle(sectionTitle), Tab.Container)
				Section.Container = sectionComponent.Container
				-- Expose the section frame as an optional, backwards-compatible
				-- handle. Addons can use LayoutOrder/Visible without depending on
				-- private descendants of the tab.
				Section.Root = sectionComponent.Root
				Section.SetVisible = function(selfOrVisible, visible)
					return sectionComponent.SetVisible(type(selfOrVisible) == "boolean" and selfOrVisible or visible)
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
			local window = TabModule.Window
			local library = requireModule(Root)
			if type(library._CloseDropdowns) == "function" then
				library._CloseDropdowns()
			end
			TabModule.SelectedTab = tabIndex
			for _, tab in next, TabModule.Tabs do
				tab.SetTransparency(1)
				tab.Selected = false
			end
			TabModule.Tabs[tabIndex].SetTransparency(0.89)
			TabModule.Tabs[tabIndex].Selected = true
			local Library = requireModule(Root)
			if Library.Workspace and type(Library.Workspace.TouchTab) == "function" then
				Library.Workspace:TouchTab(TabModule.Tabs[tabIndex])
			end
			window.TabDisplay.Text = TabModule.Tabs[tabIndex].Name
			TranslationSystem:Register(window.TabDisplay, TabModule.Tabs[tabIndex].Name, "Text")
			window.SelectorPosMotor:setGoal(Spring(TabModule:GetCurrentTabPos(), {frequency = 6}))
			task.spawn(
				function()
					window.ContainerPosMotor:setGoal(Spring(110, {frequency = 10}))
					window.ContainerBackMotor:setGoal(Spring(1, {frequency = 10}))
					task.wait(0.15)
					for _, container in next, TabModule.Containers do
						container.Visible = false
					end
					TabModule.Containers[tabIndex].Visible = true
					window.ContainerPosMotor:setGoal(Spring(94, {frequency = 5}))
					window.ContainerBackMotor:setGoal(Spring(0, {frequency = 8}))
				end
			)
		end
		return TabModule
	end,
	[15] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(15)
		local TextService, Root = game:GetService("TextService"), moduleScript.Parent.Parent
		local Flipper, Creator = requireModule(Root.Packages.Flipper), requireModule(Root.Creator)
		local New = Creator.New
		local TweenService = game:GetService("TweenService")

		return function(parent, acrylic)
			acrylic = acrylic or false
			local Textbox = {}

			-- Input (TextBox) - font size 16 to match CSS
			Textbox.Input =
				New(
					"TextBox",
					{
						FontFace = Font.new(
							"rbxasset://fonts/families/GothamSSm.json",
							Enum.FontWeight.Medium,
							Enum.FontStyle.Normal
						),
						TextColor3 = Color3.fromRGB(0, 0, 0),
						TextTransparency = 0,
						TextSize = 16,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 1),
						Position = UDim2.fromOffset(12, 0),
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
					Transparency = acrylic and 0.5 or 0.65,
					ThemeTag = {Color = acrylic and "InElementBorder" or "DialogButtonBorder"},
					ZIndex = 1
				}
			)

			-- store original stroke color so we can revert
			local originalStrokeColor = frameStroke.Color

			-- Main frame
			Textbox.Frame =
				New(
					"Frame",
					{
						Size = UDim2.new(0, 0, 0, 36),
						BackgroundTransparency = acrylic and 0.92 or 0,
						Parent = parent,
						ThemeTag = {BackgroundColor3 = acrylic and "Input" or "DialogInput"},
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
						Font = Enum.Font.Gotham,
						TextSize = 16,
						TextColor3 = Creator.GetThemeProperty("SubText"),
						TextTransparency = 1, -- เริ่มโปร่งตาม CSS
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -24, 0, 18),
						Position = UDim2.new(0, 12, 0, 0),
						AnchorPoint = Vector2.new(0, 0),
						ZIndex = 3,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center
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

			task.spawn(adjustInputPosition)
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
					Transparency = 0.2,
					Thickness = 1.6,
					Color = Creator.GetThemeProperty("Accent")
				}):Play()

				TweenService:Create(Textbox.Frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = acrylic and 0.88 or 0}):Play()
				Creator.OverrideTag(Textbox.Frame, {BackgroundColor3 = acrylic and "InputFocused" or "DialogHolder"})
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

				-- Stroke return: revert color/transparency/thickness back
				TweenService:Create(frameStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Transparency = acrylic and 0.5 or 0.65,
					Thickness = 1.2,
					Color = originalStrokeColor
				}):Play()

				TweenService:Create(Textbox.Frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = acrylic and 0.92 or 0}):Play()
				Creator.OverrideTag(Textbox.Frame, {BackgroundColor3 = acrylic and "Input" or "DialogInput"})
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
		local Creator, Flipper = requireModule(Root.Creator), requireModule(Root.Packages.Flipper)
		local New, AddSignal = Creator.New, Creator.AddSignal
		return function(config)
			local TitleBar, Library, BarButton =
				{},
			requireModule(Root),
			function(icon, position, parent, callback)
				local Button = {
					Callback = callback or function()
					end
				}
				Button.Frame =
					New(
						"TextButton",
						{
							Size = UDim2.new(0, 34, 1, -8),
							AnchorPoint = Vector2.new(1, 0),
							BackgroundTransparency = 1,
							Parent = parent,
							Position = position,
							Text = "",
							ThemeTag = {BackgroundColor3 = "Text"}
						},
						{
							New("UICorner", {CornerRadius = UDim.new(0, 7)}),
							New(
								"ImageLabel",
								{
									Image = icon,
									Size = UDim2.fromOffset(16, 16),
									Position = UDim2.fromScale(0.5, 0.5),
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundTransparency = 1,
									Name = "Icon",
									ThemeTag = {ImageColor3 = "Text"}
								}
							)
						}
					)
				local motor, setTransparency = Creator.SpringMotor(1, Button.Frame, "BackgroundTransparency")
				AddSignal(
					Button.Frame.MouseEnter,
					function()
						setTransparency(0.94)
					end
				)
				AddSignal(
					Button.Frame.MouseLeave,
					function()
						setTransparency(1, true)
					end
				)
				AddSignal(
					Button.Frame.MouseButton1Down,
					function()
						setTransparency(0.96)
					end
				)
				AddSignal(
					Button.Frame.MouseButton1Up,
					function()
						setTransparency(0.94)
					end
				)
				AddSignal(Button.Frame.MouseButton1Click, Button.Callback)
				Button.SetCallback = function(callback)
					Button.Callback = callback
				end
				return Button
			end
			TitleBar.Frame =
				New(
					"Frame",
					{Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, Parent = config.Parent},
					{
						New(
							"Frame",
							-- ขยับซ้ายเล็กน้อย: Position 16 -> 8, ลด margin ขวาให้สมดุล
							{Size = UDim2.new(1, -8, 1, 0), Position = UDim2.new(0, 8, 0, 0), BackgroundTransparency = 1},
							{
								-- UIListLayout: แนวนอนและจัดกึ่งกลางแนวตั้ง
								New(
									"UIListLayout",
									{
										Padding = UDim.new(0, 6),
										FillDirection = Enum.FillDirection.Horizontal,
										SortOrder = Enum.SortOrder.LayoutOrder,
										VerticalAlignment = Enum.VerticalAlignment.Center
									}
								),
								-- ไอคอนขนาดใหญ่ขึ้นและจัดด้วย layout
								New(
									"ImageLabel",
									{
										Name = "WindowIcon",
										Image = config.Icon or "rbxassetid://90989180960460",
										Size = UDim2.fromOffset(32, 32), -- ขยายเป็น 32x32
										BackgroundTransparency = 1,
										LayoutOrder = 1,
										ScaleType = Enum.ScaleType.Fit,
										ThemeTag = {ImageColor3 = "Text"}
									}
								),
								-- Title (ขนาดฟอนต์เพิ่มเล็กน้อย)
								New(
									"TextLabel",
									{
										RichText = true,
										Text = config.Title or "",
										FontFace = Font.new(
											"rbxasset://fonts/families/GothamSSm.json",
											Enum.FontWeight.Regular,
											Enum.FontStyle.Normal
										),
										TextSize = 14,
										TextXAlignment = "Left",
										TextYAlignment = "Center",
										AutomaticSize = Enum.AutomaticSize.X,
										BackgroundTransparency = 1,
										LayoutOrder = 2,
										ThemeTag = {TextColor3 = "Text"}
									}
								),
								-- SubTitle (ถ้ามี)
								New(
									"TextLabel",
									{
										RichText = true,
										Text = config.SubTitle or "",
										TextTransparency = 0.4,
										FontFace = Font.new(
											"rbxasset://fonts/families/GothamSSm.json",
											Enum.FontWeight.Regular,
											Enum.FontStyle.Normal
										),
										TextSize = 13,
										TextXAlignment = "Left",
										TextYAlignment = "Center",
										AutomaticSize = Enum.AutomaticSize.X,
										BackgroundTransparency = 1,
										LayoutOrder = 3,
										ThemeTag = {TextColor3 = "Text"}
									}
								)
							}
						),
						New(
							"Frame",
							{
								BackgroundTransparency = 0.5,
								Size = UDim2.new(1, 0, 0, 1),
								Position = UDim2.new(0, 0, 1, 0),
								ThemeTag = {BackgroundColor3 = "TitleBarLine"}
							}
						)
					}
				)

			-- Close: asks, then unloads the interface.
			TitleBar.CloseButton =
				BarButton(
					Assets.Close,
					UDim2.new(1, -4, 0, 4),
					TitleBar.Frame,
					function()
						Library.Window:Dialog {
							Title = "Close",
							Content = "Are you sure you want to unload the interface?",
							Buttons = {
								{
									Title = "Yes",
									Callback = function()
										-- Library:Destroy does all cleanup, the same as a
										-- script calling Fluent:Destroy().
										Library:Destroy()
									end
								},
								{Title = "No"}
							}
						}
					end
				)

			TitleBar.MaxButton =
				BarButton(
					Assets.Max,
					UDim2.new(1, -40, 0, 4),
					TitleBar.Frame,
					function()
						config.Window.Maximize(not config.Window.Maximized)
					end
				)
			TitleBar.MinButton =
				BarButton(
					Assets.Min,
					UDim2.new(1, -80, 0, 4),
					TitleBar.Frame,
					function()
						Library.Window:Minimize()
					end
				)
			return TitleBar
		end
	end,
	[17] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(17)
		local UserInputService, mouse, camera, Root =
			game:GetService "UserInputService",
		game:GetService "Players".LocalPlayer:GetMouse(),
		game:GetService "Workspace".CurrentCamera,
		moduleScript.Parent.Parent
		local Flipper, Creator, Acrylic, Assets, Components = requireModule(Root.Packages.Flipper), requireModule(Root.Creator), requireModule(Root.Acrylic), requireModule(moduleScript.Parent.Assets), moduleScript.Parent
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
			Window.AcrylicPaint = Acrylic.AcrylicPaint()
			local selector, resizeStartFrame =
				New(
					"Frame",
					{
						Size = UDim2.fromOffset(4, 0),
						BackgroundColor3 = Color3.fromRGB(76, 194, 255),
						Position = UDim2.fromOffset(0, 17),
						AnchorPoint = Vector2.new(0, 0.5),
						ThemeTag = {BackgroundColor3 = "Accent"}
					},
					{New("UICorner", {CornerRadius = UDim.new(0, 2)})}
				),
			New(
				"Frame",
				{Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, Position = UDim2.new(1, -20, 1, -20)}
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
					{New("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder})}
				)
			local tabFrame =
				New(
					"Frame",
					{
						Size = UDim2.new(0, config.TabWidth, 1, -66),
						Position = UDim2.new(0, 12, 0, 54),
						BackgroundTransparency = 1,
						ClipsDescendants = true
					},
					{Window.TabHolder, selector}
				)
			Window.TabArea = tabFrame
			-- Expose the existing selector only as an optional visual handle.
			-- Workspace search can hide it while the tab rail shows live matches.
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
						FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
						TextSize = 28,
						TextXAlignment = "Left",
						TextYAlignment = "Center",
						Size = UDim2.new(1, -16, 0, 28),
						Position = UDim2.fromOffset(config.TabWidth + 26, 56),
						BackgroundTransparency = 1,
						ThemeTag = {TextColor3 = "Text"}
					}
				)
			Window.ContainerHolder =
				New(
					"CanvasGroup",
					{
						Size = UDim2.new(1, -config.TabWidth - 32, 1, -102),
						Position = UDim2.fromOffset(config.TabWidth + 26, 90),
						BackgroundTransparency = 1
					}
				)
			Window.Root =
				New(
					"Frame",
					{BackgroundTransparency = 1, Size = Window.Size, Position = Window.Position, Parent = config.Parent},
					{Window.AcrylicPaint.Frame, Window.TabDisplay, Window.ContainerHolder, tabFrame, resizeStartFrame}
				)
			Window.TitleBar = requireModule(moduleScript.Parent.TitleBar) {Title = config.Title, SubTitle = config.SubTitle, Parent = Window.Root, Window = Window}
			if requireModule(Root).UseAcrylic then
				Window.AcrylicPaint.AddParent(Window.Root)
			end
			local sizeMotor, posMotor =
				Flipper.GroupMotor.new {X = Window.Size.X.Offset, Y = Window.Size.Y.Offset},
			Flipper.GroupMotor.new {X = Window.Position.X.Offset, Y = Window.Position.Y.Offset}
			Window.SelectorPosMotor = Flipper.SingleMotor.new(17)
			Window.SelectorSizeMotor = Flipper.SingleMotor.new(0)
			Window.ContainerBackMotor = Flipper.SingleMotor.new(0)
			Window.ContainerPosMotor = Flipper.SingleMotor.new(94)
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
			local lastValue, lastTime = 0, 0
			Window.SelectorPosMotor:onStep(
				function(value)
					selector.Position = UDim2.new(0, 0, 0, value + 17)
					local now = os.clock()
					local deltaTime = now - lastTime
					if lastValue ~= nil then
						Window.SelectorSizeMotor:setGoal(Spring((math.abs(value - lastValue) / (deltaTime * 60)) + 16))
						lastValue = value
					end
					lastTime = now
				end
			)
			Window.SelectorSizeMotor:onStep(
				function(value)
					selector.Size = UDim2.new(0, 4, 0, value)
				end
			)
			Window.ContainerBackMotor:onStep(
				function(value)
					Window.ContainerHolder.GroupTransparency = value
				end
			)
			Window.ContainerPosMotor:onStep(
				function(value)
					Window.ContainerHolder.Position = UDim2.fromOffset(config.TabWidth + 26, value)
				end
			)
			-- Public, additive layout hook used by the workspace toolbar.  Keeping
			-- this inside Window means compact mode does not fight the existing
			-- Flipper position motor when a tab is selected.
			function Window.SetTabWidth(_self, width)
				width = math.clamp(tonumber(width) or config.TabWidth, 52, 320)
				config.TabWidth = width
				Window.TabWidth = width
				tabFrame.Size = UDim2.new(0, width, 1, tabFrame.Size.Y.Offset)
				Window.TabDisplay.Position = UDim2.fromOffset(width + 26, 56)
				Window.ContainerHolder.Size = UDim2.new(1, -width - 32, 1, -102)
				Window.ContainerHolder.Position = UDim2.fromOffset(width + 26, Window.ContainerPosMotor:getValue())
			end
			local oldSizeX, oldSizeY
			Window.Maximize = function(maximized, noPos, instant)
				Window.Maximized = maximized
				Window.TitleBar.MaxButton.Frame.Icon.Image = maximized and Assets.Restore or Assets.Max
				if maximized then
					oldSizeX = Window.Size.X.Offset
					oldSizeY = Window.Size.Y.Offset
				end
				local sizeX, sizeY = maximized and camera.ViewportSize.X or oldSizeX, maximized and camera.ViewportSize.Y or oldSizeY
				sizeMotor:setGoal {
					X = Flipper[instant and "Instant" or "Spring"].new(sizeX, {frequency = 6}),
					Y = Flipper[instant and "Instant" or "Spring"].new(sizeY, {frequency = 6})
				}
				Window.Size = UDim2.fromOffset(sizeX, sizeY)
				if not noPos then
					posMotor:setGoal {
						X = Spring(maximized and 0 or Window.Position.X.Offset, {frequency = 6}),
						Y = Spring(maximized and 0 or Window.Position.Y.Offset, {frequency = 6})
					}
				end
			end
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
						local screen = camera.ViewportSize
						local width = Window.Size.X.Offset
						local x = math.clamp(startPos.X.Offset + delta.X, VISIBLE_TITLE - width, math.max(VISIBLE_TITLE - width, screen.X - VISIBLE_TITLE))
						local y = math.clamp(startPos.Y.Offset + delta.Y, 0, math.max(0, screen.Y - VISIBLE_TITLE))
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
						local delta, startSize = input.Position - resizePos, Window.Size
						local targetSize = Vector3.new(startSize.X.Offset, startSize.Y.Offset, 0) + Vector3.new(1, 1, 0) * delta
						-- The minimum size shrinks on screens smaller than it.
						local screen = camera.ViewportSize
						local minimumX = math.max(200, math.min(470, screen.X - SCREEN_MARGIN * 2))
						local minimumY = math.max(160, math.min(380, screen.Y - SCREEN_MARGIN * 2))
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
				function()
					Window.TabHolder.CanvasSize = UDim2.new(0, 0, 0, Window.TabHolder.UIListLayout.AbsoluteContentSize.Y)
				end
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
			function Window.Minimize(_self)
				Window.Minimized = not Window.Minimized
				if Window.Minimized and type(Library._CloseDropdowns) == "function" then
					Library._CloseDropdowns()
				end
				Window.Root.Visible = not Window.Minimized
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
				if requireModule(Root).UseAcrylic then
					Window.AcrylicPaint.Model:Destroy()
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
							FontFace = Font.new "rbxasset://fonts/families/GothamSSm.json",
							Text = dialogConfig.Content,
							TextColor3 = Color3.fromRGB(240, 240, 240),
							TextSize = 14,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Top,
							Size = UDim2.new(1, -40, 1, 0),
							Position = UDim2.fromOffset(20, 60),
							BackgroundTransparency = 1,
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
			local TabModule = requireModule(Components.Tab):Init(Window)
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
			Creator.AddSignal(
				Window.TabHolder:GetPropertyChangedSignal "CanvasPosition",
				function()
					lastValue = TabModule:GetCurrentTabPos() + 16
					lastTime = 0
					Window.SelectorPosMotor:setGoal(Instant(TabModule:GetCurrentTabPos()))
				end
			)
			return Window
		end
	end,
	[18] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(18)
		local Root = moduleScript.Parent
		local Themes, Flipper, Creator =
			requireModule(Root.Themes),
		requireModule(Root.Packages.Flipper),
		{
			Registry = {},
			Signals = {},
			TransparencyMotors = {},
			DefaultProperties = {
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
					Font = Enum.Font.SourceSans,
					Text = "",
					TextColor3 = Color3.new(0, 0, 0),
					BackgroundTransparency = 1,
					TextSize = 14
				},
				TextButton = {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderColor3 = Color3.new(0, 0, 0),
					AutoButtonColor = false,
					Font = Enum.Font.SourceSans,
					Text = "",
					TextColor3 = Color3.new(0, 0, 0),
					TextSize = 14
				},
				TextBox = {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderColor3 = Color3.new(0, 0, 0),
					ClearTextOnFocus = false,
					Font = Enum.Font.SourceSans,
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
		}
		local applyCustomProps = function(object, props)
			if props.ThemeTag then
				Creator.AddThemeObject(object, props.ThemeTag)
			end
		end
		-- Connections to destroyed instances are already disconnected; drop them
		-- whenever the list has doubled so it stays proportional to live ones.
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
		function Creator.Disconnect()
			for index = #Creator.Signals, 1, -1 do
				local connection = table.remove(Creator.Signals, index)
				connection:Disconnect()
			end
		end
		-- RGB theme: while it is active, these keys (the accent and border
		-- colors) cycle through the rainbow about ten times a second.
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
		-- Objects with at least one property bound to a rainbow key.
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
				local data = Creator.Registry[object]
				if data then
					for property, themeKey in next, data.Properties do
						if RAINBOW_KEYS[themeKey] then
							object[property] = rainbowColor
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
			rainbowConnection = game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
				elapsed = elapsed + deltaTime
				if elapsed < 0.1 then
					return
				end
				elapsed = 0
				local library = requireModule(Root)
				if library.Window and library.Window.Minimized then
					return
				end
				stepRainbow()
			end)
		end
		Creator.StopRainbow = stopRainbow
		function Creator.GetThemeProperty(property)
			if rainbowColor and RAINBOW_KEYS[property] then
				return rainbowColor
			end
			if Themes[requireModule(Root).Theme][property] then
				return Themes[requireModule(Root).Theme][property]
			end
			return Themes.Dark[property]
		end
		function Creator.UpdateTheme()
			local theme = Themes[requireModule(Root).Theme]
			if theme and theme.IsRGB then
				startRainbow()
			else
				stopRainbow()
			end
			for object, data in next, Creator.Registry do
				for property, themeKey in next, data.Properties do
					object[property] = Creator.GetThemeProperty(themeKey)
				end
			end
			for _, motor in next, Creator.TransparencyMotors do
				motor:setGoal(Flipper.Instant.new(Creator.GetThemeProperty "ElementTransparency"))
			end
		end
		function Creator.AddThemeObject(object, properties)
			local idx = #Creator.Registry + 1
			local data = {Object = object, Properties = properties, Idx = idx}
			if Creator.Registry[object] == nil then
				-- Forget destroyed objects so the registry does not keep them alive.
				object.Destroying:Connect(function()
					Creator.Registry[object] = nil
					rainbowTargets[object] = nil
				end)
			end
			Creator.Registry[object] = data
			rainbowTargets[object] = usesRainbowKey(properties) or nil
			for property, themeKey in next, properties do
				object[property] = Creator.GetThemeProperty(themeKey)
			end
			return object
		end
		-- Re-tags one object and applies only its properties. Re-theming every
		-- object here made each toggle click cost O(elements) and reset the
		-- hover state of every other element.
		function Creator.OverrideTag(object, properties)
			local data = Creator.Registry[object]
			if data then
				data.Properties = properties
				rainbowTargets[object] = usesRainbowKey(properties) or nil
				for property, themeKey in next, properties do
					object[property] = Creator.GetThemeProperty(themeKey)
				end
			else
				Creator.AddThemeObject(object, properties)
			end
		end
		function Creator.New(className, properties, children)
			local object = Instance.new(className)
			for name, value in next, Creator.DefaultProperties[className] or {} do
				object[name] = value
			end
			for name, value in next, properties or {} do
				-- These are creation metadata for the customization layer, not
				-- Roblox Instance properties.
				if name ~= "ThemeTag" and name ~= "I18nKey" and name ~= "I18nContext" and name ~= "I18nSkip"
					and name ~= "I18nDynamic" and name ~= "FontRole" then
					object[name] = value
				end
			end
			for _, child in next, children or {} do
				child.Parent = object
			end
			applyCustomProps(object, properties)
			-- Registers only once at creation, then updates only on a real
			-- language/font change. This avoids expensive descendant scans.
			CustomizationSystem.I18n:AutoRegister(object, properties)
			return object
		end
		function Creator.SpringMotor(initial, instance, property, ignoreDialogCheck, resetOnThemeChange)
			ignoreDialogCheck = ignoreDialogCheck or false
			resetOnThemeChange = resetOnThemeChange or false
			local motor = Flipper.SingleMotor.new(initial)
			motor:onStep(
				function(value)
					instance[property] = value
				end
			)
			if resetOnThemeChange then
				table.insert(Creator.TransparencyMotors, motor)
				instance.Destroying:Connect(function()
					local index = table.find(Creator.TransparencyMotors, motor)
					if index then
						table.remove(Creator.TransparencyMotors, index)
					end
				end)
			end
			local setValue = function(value, ignore)
				ignore = ignore or false
				if not ignoreDialogCheck then
					if not ignore then
						if property == "BackgroundTransparency" and requireModule(Root).DialogOpen then
							return
						end
					end
				end
				motor:setGoal(Flipper.Spring.new(value, {frequency = 8}))
			end
			return motor, setValue
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
		function Element.New(parent, config)
			assert(config.Title, "Button - Missing Title")
			config.Callback = config.Callback or function()
			end
			local buttonFrame = requireModule(Components.Element)(config.Title, config.Description, parent.Container, true)
			local icon =
				New(
					"ImageLabel",
					{
						Image = "rbxassetid://10709791437",
						Size = UDim2.fromOffset(16, 16),
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -10, 0.5, 0),
						BackgroundTransparency = 1,
						Parent = buttonFrame.Frame,
						ThemeTag = {ImageColor3 = "Text"}
					}
				)
			Creator.AddSignal(
				buttonFrame.Frame.MouseButton1Click,
				function()
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
		local UserInputService, TouchInputService, RunService, Players =
			game:GetService "UserInputService",
		game:GetService "TouchInputService",
		game:GetService "RunService",
		game:GetService "Players"
		local RenderStepped, LocalPlayer = RunService.RenderStepped, Players.LocalPlayer
		local mouse, Root = LocalPlayer:GetMouse(), moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local New, Components, Element = Creator.New, Root.Components, {}
		Element.__index = Element
		Element.__type = "Colorpicker"
		function Element.New(parent, idx, config)
			local Library = parent.Library
			assert(config.Title, "Colorpicker - Missing Title")
			assert(config.Default, "AddColorPicker: Missing default value.")
			local Colorpicker = {
				Value = config.Default,
				Transparency = config.Transparency or 0,
				Type = "Colorpicker",
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
			local colorpickerFrame = requireModule(Components.Element)(config.Title, config.Description, parent.Container, true)
			Colorpicker.SetTitle = colorpickerFrame.SetTitle
			Colorpicker.SetDesc = colorpickerFrame.SetDesc
			Colorpicker.Frame = colorpickerFrame.Frame
			local displayFrame =
				New(
					"Frame",
					{Size = UDim2.fromScale(1, 1), BackgroundColor3 = Colorpicker.Value, Parent = colorpickerFrame.Frame},
					{New("UICorner", {CornerRadius = UDim.new(0, 4)})}
				)
			local displayFrameHolder, createColorDialog =
				New(
					"ImageLabel",
					{
						Size = UDim2.fromOffset(26, 26),
						Position = UDim2.new(1, -10, 0.5, 0),
						AnchorPoint = Vector2.new(1, 0.5),
						Parent = colorpickerFrame.Frame,
						Image = "http://www.roblox.com/asset/?id=14204231522",
						ImageTransparency = 0.45,
						ScaleType = Enum.ScaleType.Tile,
						TileSize = UDim2.fromOffset(40, 40)
					},
					{New("UICorner", {CornerRadius = UDim.new(0, 4)}), displayFrame}
				),
			function()
				local dialog = requireModule(Components.Dialog):Create()
				dialog.Title.Text = Colorpicker.Title
				dialog.Root.Size = UDim2.fromOffset(430, 330)
				local hue, sat, vib, transparency, createInput, createInputLabel =
					Colorpicker.Hue,
				Colorpicker.Sat,
				Colorpicker.Vib,
				Colorpicker.Transparency,
				function()
					local box = requireModule(Components.Textbox)()
					box.Frame.Parent = dialog.Root
					box.Frame.Size = UDim2.new(0, 90, 0, 32)
					return box
				end,
				function(text, position)
					return New(
						"TextLabel",
						{
							FontFace = Font.new(
								"rbxasset://fonts/families/GothamSSm.json",
								Enum.FontWeight.Medium,
								Enum.FontStyle.Normal
							),
							Text = text,
							TextColor3 = Color3.fromRGB(240, 240, 240),
							TextSize = 13,
							TextXAlignment = Enum.TextXAlignment.Left,
							Size = UDim2.new(1, 0, 0, 32),
							Position = position,
							BackgroundTransparency = 1,
							Parent = dialog.Root,
							ThemeTag = {TextColor3 = "Text"}
						}
					)
				end
				local getRGB, satCursor =
					function()
						local color = Color3.fromHSV(hue, sat, vib)
						return {R = math.floor(color.r * 255), G = math.floor(color.g * 255), B = math.floor(color.b * 255)}
					end,
				New(
					"ImageLabel",
					{
						Size = UDim2.new(0, 18, 0, 18),
						ScaleType = Enum.ScaleType.Fit,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Image = "http://www.roblox.com/asset/?id=4805639000"
					}
				)
				local satVibMap, oldColorFrame =
					New(
						"ImageLabel",
						{
							Size = UDim2.fromOffset(180, 160),
							Position = UDim2.fromOffset(20, 55),
							Image = "rbxassetid://4155801252",
							BackgroundColor3 = Colorpicker.Value,
							BackgroundTransparency = 0,
							Parent = dialog.Root
						},
						{New("UICorner", {CornerRadius = UDim.new(0, 4)}), satCursor}
					),
				New(
					"Frame",
					{
						BackgroundColor3 = Colorpicker.Value,
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = Colorpicker.Transparency
					},
					{New("UICorner", {CornerRadius = UDim.new(0, 4)})}
				)
				local oldColorFrameChecker, dialogDisplayFrame =
					New(
						"ImageLabel",
						{
							Image = "http://www.roblox.com/asset/?id=14204231522",
							ImageTransparency = 0.45,
							ScaleType = Enum.ScaleType.Tile,
							TileSize = UDim2.fromOffset(40, 40),
							BackgroundTransparency = 1,
							Position = UDim2.fromOffset(112, 220),
							Size = UDim2.fromOffset(88, 24),
							Parent = dialog.Root
						},
						{
							New("UICorner", {CornerRadius = UDim.new(0, 4)}),
							New("UIStroke", {Thickness = 2, Transparency = 0.75}),
							oldColorFrame
						}
					),
				New(
					"Frame",
					{BackgroundColor3 = Colorpicker.Value, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0},
					{New("UICorner", {CornerRadius = UDim.new(0, 4)})}
				)
				local dialogDisplayFrameChecker, sequenceTable =
					New(
						"ImageLabel",
						{
							Image = "http://www.roblox.com/asset/?id=14204231522",
							ImageTransparency = 0.45,
							ScaleType = Enum.ScaleType.Tile,
							TileSize = UDim2.fromOffset(40, 40),
							BackgroundTransparency = 1,
							Position = UDim2.fromOffset(20, 220),
							Size = UDim2.fromOffset(88, 24),
							Parent = dialog.Root
						},
						{
							New("UICorner", {CornerRadius = UDim.new(0, 4)}),
							New("UIStroke", {Thickness = 2, Transparency = 0.75}),
							dialogDisplayFrame
						}
					),
				{}
				for step = 0, 1, 0.1 do
					table.insert(sequenceTable, ColorSequenceKeypoint.new(step, Color3.fromHSV(step, 1, 1)))
				end
				local hueSliderGradient, hueDragHolder =
					New("UIGradient", {Color = ColorSequence.new(sequenceTable), Rotation = 90}),
				New(
					"Frame",
					{
						Size = UDim2.new(1, 0, 1, -10),
						Position = UDim2.fromOffset(0, 5),
						BackgroundTransparency = 1
					}
				)
				local hueDrag, hueSlider, hexInput =
					New(
						"ImageLabel",
						{
							Size = UDim2.fromOffset(14, 14),
							Image = "http://www.roblox.com/asset/?id=12266946128",
							Parent = hueDragHolder,
							ThemeTag = {ImageColor3 = "DialogInput"}
						}
					),
				New(
					"Frame",
					{Size = UDim2.fromOffset(12, 190), Position = UDim2.fromOffset(210, 55), Parent = dialog.Root},
					{New("UICorner", {CornerRadius = UDim.new(1, 0)}), hueSliderGradient, hueDragHolder}
				),
				createInput()
				hexInput.Frame.Position = UDim2.fromOffset(config.Transparency and 260 or 240, 55)
				createInputLabel("Hex", UDim2.fromOffset(config.Transparency and 360 or 340, 55))
				local redInput = createInput()
				redInput.Frame.Position = UDim2.fromOffset(config.Transparency and 260 or 240, 95)
				createInputLabel("Red", UDim2.fromOffset(config.Transparency and 360 or 340, 95))
				local greenInput = createInput()
				greenInput.Frame.Position = UDim2.fromOffset(config.Transparency and 260 or 240, 135)
				createInputLabel("Green", UDim2.fromOffset(config.Transparency and 360 or 340, 135))
				local blueInput = createInput()
				blueInput.Frame.Position = UDim2.fromOffset(config.Transparency and 260 or 240, 175)
				createInputLabel("Blue", UDim2.fromOffset(config.Transparency and 360 or 340, 175))
				local alphaInput
				if config.Transparency then
					alphaInput = createInput()
					alphaInput.Frame.Position = UDim2.fromOffset(260, 215)
					createInputLabel("Alpha", UDim2.fromOffset(360, 215))
				end
				local transparencySlider, transparencyDrag, transparencyColor
				if config.Transparency then
					local transparencyDragHolder =
						New(
							"Frame",
							{
								Size = UDim2.new(1, 0, 1, -10),
								Position = UDim2.fromOffset(0, 5),
								BackgroundTransparency = 1
							}
						)
					transparencyDrag =
						New(
							"ImageLabel",
							{
								Size = UDim2.fromOffset(14, 14),
								Image = "http://www.roblox.com/asset/?id=12266946128",
								Parent = transparencyDragHolder,
								ThemeTag = {ImageColor3 = "DialogInput"}
							}
						)
					transparencyColor =
						New(
							"Frame",
							{Size = UDim2.fromScale(1, 1)},
							{
								New(
									"UIGradient",
									{
										Transparency = NumberSequence.new {
											NumberSequenceKeypoint.new(0, 0),
											NumberSequenceKeypoint.new(1, 1)
										},
										Rotation = 270
									}
								),
								New("UICorner", {CornerRadius = UDim.new(1, 0)})
							}
						)
					transparencySlider =
						New(
							"Frame",
							{
								Size = UDim2.fromOffset(12, 190),
								Position = UDim2.fromOffset(230, 55),
								Parent = dialog.Root,
								BackgroundTransparency = 1
							},
							{
								New("UICorner", {CornerRadius = UDim.new(1, 0)}),
								New(
									"ImageLabel",
									{
										Image = "http://www.roblox.com/asset/?id=14204231522",
										ImageTransparency = 0.45,
										ScaleType = Enum.ScaleType.Tile,
										TileSize = UDim2.fromOffset(40, 40),
										BackgroundTransparency = 1,
										Size = UDim2.fromScale(1, 1),
										Parent = dialog.Root
									},
									{New("UICorner", {CornerRadius = UDim.new(1, 0)})}
								),
								transparencyColor,
								transparencyDragHolder
							}
						)
				end
				local display = function()
					satVibMap.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
					hueDrag.Position = UDim2.new(0, -1, hue, -6)
					satCursor.Position = UDim2.new(sat, 0, 1 - vib, 0)
					dialogDisplayFrame.BackgroundColor3 = Color3.fromHSV(hue, sat, vib)
					hexInput.Input.Text = "#" .. Color3.fromHSV(hue, sat, vib):ToHex()
					redInput.Input.Text = getRGB().R
					greenInput.Input.Text = getRGB().G
					blueInput.Input.Text = getRGB().B
					if config.Transparency then
						transparencyColor.BackgroundColor3 = Color3.fromHSV(hue, sat, vib)
						dialogDisplayFrame.BackgroundTransparency = transparency
						transparencyDrag.Position = UDim2.new(0, -1, 1 - transparency, -6)
						alphaInput.Input.Text = requireModule(Root):Round((1 - transparency) * 100, 0) .. "%"
					end
				end
				Creator.AddSignal(
					hexInput.Input.FocusLost,
					function(enter)
						if enter then
							local ok, result = pcall(Color3.fromHex, hexInput.Input.Text)
							if ok and typeof(result) == "Color3" then
								hue, sat, vib = Color3.toHSV(result)
							end
						end
						display()
					end
				)
				Creator.AddSignal(
					redInput.Input.FocusLost,
					function(enter)
						if enter then
							local rgb = getRGB()
							local ok, result = pcall(Color3.fromRGB, redInput.Input.Text, rgb.G, rgb.B)
							if ok and typeof(result) == "Color3" then
								if tonumber(redInput.Input.Text) <= 255 then
									hue, sat, vib = Color3.toHSV(result)
								end
							end
						end
						display()
					end
				)
				Creator.AddSignal(
					greenInput.Input.FocusLost,
					function(enter)
						if enter then
							local rgb = getRGB()
							local ok, result = pcall(Color3.fromRGB, rgb.R, greenInput.Input.Text, rgb.B)
							if ok and typeof(result) == "Color3" then
								if tonumber(greenInput.Input.Text) <= 255 then
									hue, sat, vib = Color3.toHSV(result)
								end
							end
						end
						display()
					end
				)
				Creator.AddSignal(
					blueInput.Input.FocusLost,
					function(enter)
						if enter then
							local rgb = getRGB()
							local ok, result = pcall(Color3.fromRGB, rgb.R, rgb.G, blueInput.Input.Text)
							if ok and typeof(result) == "Color3" then
								if tonumber(blueInput.Input.Text) <= 255 then
									hue, sat, vib = Color3.toHSV(result)
								end
							end
						end
						display()
					end
				)
				if config.Transparency then
					Creator.AddSignal(
						alphaInput.Input.FocusLost,
						function(enter)
							if enter then
								pcall(
									function()
										local alpha = tonumber(alphaInput.Input.Text)
										if alpha >= 0 and alpha <= 100 then
											transparency = 1 - alpha * 0.01
										end
									end
								)
							end
							display()
						end
					)
				end
				Creator.AddSignal(
					satVibMap.InputBegan,
					function(input)
						if
							input.UserInputType == Enum.UserInputType.MouseButton1 or
							input.UserInputType == Enum.UserInputType.Touch
						then
							while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
								local minX = satVibMap.AbsolutePosition.X
								local maxX = minX + satVibMap.AbsoluteSize.X
								local mouseX, minY = math.clamp(mouse.X, minX, maxX), satVibMap.AbsolutePosition.Y
								local maxY = minY + satVibMap.AbsoluteSize.Y
								local mouseY = math.clamp(mouse.Y, minY, maxY)
								sat = (mouseX - minX) / (maxX - minX)
								vib = 1 - ((mouseY - minY) / (maxY - minY))
								display()
								RenderStepped:Wait()
							end
						end
					end
				)
				Creator.AddSignal(
					hueSlider.InputBegan,
					function(input)
						if
							input.UserInputType == Enum.UserInputType.MouseButton1 or
							input.UserInputType == Enum.UserInputType.Touch
						then
							while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
								local minY = hueSlider.AbsolutePosition.Y
								local maxY = minY + hueSlider.AbsoluteSize.Y
								local mouseY = math.clamp(mouse.Y, minY, maxY)
								hue = ((mouseY - minY) / (maxY - minY))
								display()
								RenderStepped:Wait()
							end
						end
					end
				)
				if config.Transparency then
					Creator.AddSignal(
						transparencySlider.InputBegan,
						function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
									local minY = transparencySlider.AbsolutePosition.Y
									local maxY = minY + transparencySlider.AbsoluteSize.Y
									local mouseY = math.clamp(mouse.Y, minY, maxY)
									transparency = 1 - ((mouseY - minY) / (maxY - minY))
									display()
									RenderStepped:Wait()
								end
							end
						end
					)
				end
				display()
				dialog:Button(
					"Done",
					function()
						Colorpicker:SetValue({hue, sat, vib}, transparency)
						Library._TouchElement(Colorpicker)
					end
				)
				dialog:Button "Cancel"
				dialog:Open()
			end
			function Colorpicker.Display(_self)
				Colorpicker.Value = Color3.fromHSV(Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib)
				displayFrame.BackgroundColor3 = Colorpicker.Value
				displayFrame.BackgroundTransparency = Colorpicker.Transparency
				Element.Library:SafeCallback(Colorpicker.Callback, Colorpicker.Value)
				Element.Library:SafeCallback(Colorpicker.Changed, Colorpicker.Value)
			end
			function Colorpicker.SetValue(_self, hsv, transparency)
				local color = Color3.fromHSV(hsv[1], hsv[2], hsv[3])
				Colorpicker.Transparency = transparency or 0
				Colorpicker:SetHSVFromRGB(color)
				Colorpicker:Display()
			end
			function Colorpicker.SetValueRGB(_self, color, transparency)
				Colorpicker.Transparency = transparency or 0
				Colorpicker:SetHSVFromRGB(color)
				Colorpicker:Display()
			end
			function Colorpicker.OnChanged(_self, callback)
				Colorpicker.Changed = callback
				callback(Colorpicker.Value)
			end
			function Colorpicker.Destroy(_self)
				colorpickerFrame:Destroy()
				Library.Options[idx] = nil
			end
			Creator.AddSignal(
				colorpickerFrame.Frame.MouseButton1Click,
				function()
					createColorDialog()
				end
			)
			Colorpicker:Display()
			Library.Options[idx] = Colorpicker
			return Colorpicker
		end
		return Element
	end,
	[22] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(22)
		local TweenService, UserInputService, mouse, camera, Root =
			game:GetService "TweenService",
		game:GetService "UserInputService",
		game:GetService "Players".LocalPlayer:GetMouse(),
		game:GetService "Workspace".CurrentCamera,
		moduleScript.Parent.Parent
		local Creator, Flipper = requireModule(Root.Creator), requireModule(Root.Packages.Flipper)
		local New, Components, Element = Creator.New, Root.Components, {}
		Element.__index = Element
		Element.__type = "Dropdown"
		function Element.New(parent, idx, config)
			local Library, Dropdown, dropdownFrame =
				parent.Library,
			{
				Values = config.Values,
				Value = (config.Multi and {}) or config.Default,
				Multi = config.Multi,
				Buttons = {},
				Opened = false,
				Type = "Dropdown",
				SearchText = "",
				Callback = config.Callback or function()
				end
			},
			requireModule(Components.Element)(config.Title, config.Description, parent.Container, false)
			dropdownFrame.DescLabel.Size = UDim2.new(1, -170, 0, 14)
			Dropdown.SetTitle = dropdownFrame.SetTitle
			Dropdown.SetDesc = dropdownFrame.SetDesc
			Dropdown.Frame = dropdownFrame.Frame
			local dropdownDisplay, dropdownIcon =
				New(
					"TextLabel",
					{
						FontFace = Font.new(
							"rbxasset://fonts/families/GothamSSm.json",
							Enum.FontWeight.Regular,
							Enum.FontStyle.Normal
						),
						Text = "Value",
						I18nSkip = true,
						TextColor3 = Color3.fromRGB(240, 240, 240),
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(1, -30, 0, 14),
						Position = UDim2.new(0, 8, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						TextTruncate = Enum.TextTruncate.AtEnd,
						ThemeTag = {TextColor3 = "Text"}
					}
				),
			New(
				"ImageLabel",
				{
					Image = "rbxassetid://10709790948",
					Size = UDim2.fromOffset(16, 16),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -8, 0.5, 0),
					BackgroundTransparency = 1,
					ThemeTag = {ImageColor3 = "SubText"}
				}
			)
			local dropdownInner =
				New(
					"TextButton",
					{
						Size = UDim2.fromOffset(160, 34),
						Position = UDim2.new(1, -10, 0.5, 0),
						AnchorPoint = Vector2.new(1, 0.5),
						BackgroundTransparency = 0.9,
						ClipsDescendants = true,
						Parent = dropdownFrame.Frame,
						ThemeTag = {BackgroundColor3 = "DropdownFrame"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 8)}),
						New(
							"UIStroke",
							{
								Transparency = 0.5,
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								ThemeTag = {Color = "InElementBorder"}
							}
						),
						dropdownIcon,
						dropdownDisplay
					}
				)
			local textService = game:GetService("TextService")
			local function getTextWidth(label, text)
				local ok, size =
					pcall(
						function()
							return textService:GetTextSize(
								text or label.Text,
								label.TextSize,
								Enum.Font.Gotham,
								Vector2.new(10000, math.max(label.AbsoluteSize.Y, 34))
							)
						end
					)
				return ok and size.X or label.TextBounds.X
			end
			local selectedLabelDefaultPosition = UDim2.new(0, 8, 0.5, 0)
			local selectedLabelDefaultSize = UDim2.new(1, -30, 0, 14)
			local selectedLabelScrollTween = nil
			local function stopSelectedLabelScroll()
				if selectedLabelScrollTween then
					selectedLabelScrollTween:Cancel()
					selectedLabelScrollTween = nil
				end
				dropdownDisplay.TextTruncate = Enum.TextTruncate.AtEnd
				dropdownDisplay.Size = selectedLabelDefaultSize
				dropdownDisplay.Position = selectedLabelDefaultPosition
			end
			local function startSelectedLabelScroll()
				local visibleWidth = math.max(dropdownInner.AbsoluteSize.X - 30, 0)
				local textWidth = getTextWidth(dropdownDisplay, dropdownDisplay.Text) + 8
				if textWidth <= visibleWidth then
					return
				end
				stopSelectedLabelScroll()
				dropdownDisplay.TextTruncate = Enum.TextTruncate.None
				dropdownDisplay.Size = UDim2.fromOffset(textWidth, 14)
				local travel = textWidth - visibleWidth
				selectedLabelScrollTween =
					TweenService:Create(
						dropdownDisplay,
						TweenInfo.new(math.clamp(travel / 35, 1.2, 5), Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0.25),
						{Position = UDim2.new(0, 8 - travel, 0.5, 0)}
					)
				selectedLabelScrollTween:Play()
			end

			-- Search Box
			local searchBoxStroke = New(
				"UIStroke",
				{
					Transparency = 0.5,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					ThemeTag = {Color = "InElementBorder"}
				}
			)

			local searchBox =
				New(
					"TextBox",
					{
						Size = UDim2.new(1, -50, 0, 34),
						Position = UDim2.fromOffset(5, 5),
						BackgroundTransparency = 0.9,
						PlaceholderText = "🔍 Search...",
						Text = "",
						TextColor3 = Color3.fromRGB(240, 240, 240),
						PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Left,
						FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
						ThemeTag = {BackgroundColor3 = "Input", TextColor3 = "Text"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 8)}),
						New("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}),
						searchBoxStroke
					}
				)
			TranslationSystem:Register(searchBox, "🔍 Search...", "PlaceholderText")

			-- Clear Button (X)
			local clearButton =
				New(
					"TextButton",
					{
						Size = UDim2.fromOffset(0, 0),
						Position = UDim2.new(1, -22, 0, 22),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Text = "❌",
						TextColor3 = Color3.fromRGB(255, 80, 80),
						TextSize = 16,
						TextTransparency = 1,
						Visible = false,
						ThemeTag = {BackgroundColor3 = "DialogButton"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 8)}),
						New(
							"UIStroke",
							{
								Transparency = 1,
								Color = Color3.fromRGB(255, 80, 80),
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border
							}
						)
					}
				)

			-- Select All Button (เฉพาะ Multi-select)
			local selectAllButton = nil

			if config.Multi then
				selectAllButton =
					New(
						"TextButton",
						{
							Size = UDim2.new(1, -10, 0, 28),
							Position = UDim2.fromOffset(5, 44),
							BackgroundTransparency = 0.9,
							Text = "✅ Select All",
							TextSize = 13,
							FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
							ThemeTag = {BackgroundColor3 = "DialogButton", TextColor3 = "Accent"}
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
							)
						}
					)
			end

			local dropdownListLayout = New("UIListLayout", {Padding = UDim.new(0, 4)})
			local scrollYPos = config.Multi and 77 or 44
			local scrollYSize = config.Multi and -82 or -49

			local dropdownScrollFrame =
				New(
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
						CanvasSize = UDim2.fromScale(0, 0),
						ThemeTag = {ScrollBarImageColor3 = "Accent"}
					},
					{dropdownListLayout}
				)

			local uChildren = {
				searchBox,
				clearButton,
				dropdownScrollFrame,
				New("UICorner", {CornerRadius = UDim.new(0, 7)}),
				New(
					"UIStroke",
					{
						Thickness = 1.5,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						ThemeTag = {Color = "DropdownBorder"}
					}
				),
				New(
					"ImageLabel",
					{
						BackgroundTransparency = 1,
						Image = "http://www.roblox.com/asset/?id=5554236805",
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(23, 23, 277, 277),
						Size = UDim2.fromScale(1, 1) + UDim2.fromOffset(30, 30),
						Position = UDim2.fromOffset(-15, -15),
						ImageColor3 = Color3.fromRGB(0, 0, 0),
						ImageTransparency = 0.1
					}
				)
			}

			if config.Multi then
				table.insert(uChildren, selectAllButton)
			end

			local dropdownHolderFrame =
				New(
					"Frame",
					{Size = UDim2.fromScale(1, 0.5), ThemeTag = {BackgroundColor3 = "DropdownHolder"}},
					uChildren
				)

			local dropdownHolderCanvas =
				New(
					"Frame",
					{
						BackgroundTransparency = 1,
						Size = UDim2.fromOffset(170, 250),
						Parent = parent.Library.GUI,
						Visible = false
					},
					{dropdownHolderFrame, New("UISizeConstraint", {MinSize = Vector2.new(170, 0), MaxSize = Vector2.new(250, 320)})}
				)
			table.insert(Library.OpenFrames, dropdownHolderCanvas)

			-- Position dropdown with smart positioning
			local recalculateListPosition = function()
				local mainFrame = dropdownInner.AbsolutePosition
				local mainSize = dropdownInner.AbsoluteSize
				local dropdownWidth = 170
				local viewportSize = camera.ViewportSize

				-- Try right side first
				local xPos = mainFrame.X + mainSize.X + 10

				-- If goes off screen on right, try left side
				if xPos + dropdownWidth > viewportSize.X then
					xPos = mainFrame.X - dropdownWidth - 10
				end

				-- If still off screen on left, clamp to screen
				if xPos < 0 then
					xPos = math.min(mainFrame.X + mainSize.X + 10, viewportSize.X - dropdownWidth - 10)
					xPos = math.max(xPos, 10)
				end

				local yPos = mainFrame.Y - 5

				-- Make sure Y position is within screen
				local maxY = viewportSize.Y - dropdownHolderCanvas.AbsoluteSize.Y - 10
				if yPos > maxY then
					yPos = maxY
				end
				if yPos < 10 then
					yPos = 10
				end

				dropdownHolderCanvas.Position = UDim2.fromOffset(xPos, yPos)
			end

			local listSizeX = 170
			local recalculateListSize = function()
				local maxHeight = 280
				local contentHeight = dropdownListLayout.AbsoluteContentSize.Y + (config.Multi and 87 or 54)
				local finalHeight = math.min(contentHeight, maxHeight)
				dropdownHolderCanvas.Size = UDim2.fromOffset(listSizeX, finalHeight)
			end

			local recalculateCanvasSize = function()
				dropdownScrollFrame.CanvasSize = UDim2.fromOffset(0, dropdownListLayout.AbsoluteContentSize.Y)
			end
			local searchRevision = 0
			local dropdownBuilt = false
			local virtualScrollDebounce = nil
			local virtualRowHeight = 38
			local virtualThreshold = 10
			local virtualBuffer = 4
			local virtualEnabled = false
			local function rebuildDropdown()
				Dropdown:BuildDropdownList()
				dropdownBuilt = true
			end

			recalculateListPosition()
			recalculateListSize()

			-- Follow the button and close on outside clicks only while open, so
			-- closed dropdowns cost nothing when the window moves or on input.
			local openConnections = {}
			local function closeOnOutsideInput(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					if Dropdown.Opened then
						local holderPos, holderSize = dropdownHolderFrame.AbsolutePosition, dropdownHolderFrame.AbsoluteSize
						local innerPos, innerSize = dropdownInner.AbsolutePosition, dropdownInner.AbsoluteSize

						-- Check if click is outside dropdown and outside button
						local outsideDropdown = mouse.X < holderPos.X or mouse.X > holderPos.X + holderSize.X or mouse.Y < holderPos.Y or mouse.Y > holderPos.Y + holderSize.Y
						local outsideButton = mouse.X < innerPos.X or mouse.X > innerPos.X + innerSize.X or mouse.Y < innerPos.Y or mouse.Y > innerPos.Y + innerSize.Y

						if outsideDropdown and outsideButton then
							Dropdown:Close()
						end
					end
				end
			end
			local function connectWhileOpen()
				table.insert(openConnections, Creator.AddSignal(dropdownInner:GetPropertyChangedSignal "AbsolutePosition", recalculateListPosition))
				table.insert(openConnections, Creator.AddSignal(UserInputService.InputBegan, closeOnOutsideInput))
			end
			local function disconnectWhileOpen()
				for index = #openConnections, 1, -1 do
					openConnections[index]:Disconnect()
					openConnections[index] = nil
				end
			end

			-- Arrow rotation animation
			local arrowRotation = Flipper.SingleMotor.new(0)
			arrowRotation:onStep(function(rot)
				dropdownIcon.Rotation = rot
			end)

			-- Toggle dropdown on click
			Creator.AddSignal(
				dropdownInner.MouseEnter,
				function()
					startSelectedLabelScroll()
				end
			)

			Creator.AddSignal(
				dropdownInner.MouseLeave,
				function()
					stopSelectedLabelScroll()
				end
			)

			Creator.AddSignal(
				dropdownInner.MouseButton1Click,
				function()
					if Dropdown.Opened then
						Dropdown:Close()
					else
						Dropdown:Open()
					end
				end
			)

			-- Search box focus animation
			Creator.AddSignal(
				searchBox.Focused,
				function()
					TweenService:Create(searchBoxStroke, TweenInfo.new(0.2), {Transparency = 0.2}):Play()
				end
			)

			Creator.AddSignal(
				searchBox.FocusLost,
				function()
					TweenService:Create(searchBoxStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
				end
			)

			-- Search: several text changes in one frame rebuild the list once.
			Creator.AddSignal(
				searchBox:GetPropertyChangedSignal("Text"),
				function()
					searchRevision = searchRevision + 1
					local revision = searchRevision
					task.defer(function()
						if revision ~= searchRevision then
							return
						end
						Dropdown.SearchText = searchBox.Text:lower()
						dropdownScrollFrame.CanvasPosition = Vector2.new(0, 0)
						dropdownBuilt = false
						if Dropdown.Opened then
							rebuildDropdown()
						end
					end)
				end
			)

			Creator.AddSignal(
				dropdownScrollFrame:GetPropertyChangedSignal("CanvasPosition"),
				function()
					if not virtualEnabled or not Dropdown.Opened or not dropdownBuilt then
						return
					end
					if virtualScrollDebounce then
						virtualScrollDebounce:Disconnect()
					end
					virtualScrollDebounce = game:GetService("RunService").Heartbeat:Connect(function()
						if virtualScrollDebounce then
							virtualScrollDebounce:Disconnect()
							virtualScrollDebounce = nil
						end
						rebuildDropdown()
					end)
				end
			)

			-- Parse color code from text
			local function parseColorCode(text)
				-- ตรวจสอบว่า text เป็น string หรือไม่
				if type(text) ~= "string" then
					return nil, tostring(text)
				end

				local colorPattern = "^%[COLOR:(%d+),(%d+),(%d+)%](.+)$"
				local r, g, b, cleanText = text:match(colorPattern)
				if r and g and b and cleanText then
					return Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b)), cleanText
				end
				return nil, text
			end

			-- Multi values arrive as a list {"A", "B"} or as a set {A = true}
			-- (SaveManager). Returns a set of the entries that are in Values.
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

			-- A single-choice dropdown can only become empty with AllowNull.
			local canClear = config.Multi or config.AllowNull

			-- Clear button functionality with hover effects
			local _, clearBgTransparency = Creator.SpringMotor(0.9, clearButton, "BackgroundTransparency")

			Creator.AddSignal(
				clearButton.MouseEnter,
				function()
					clearBgTransparency(0.8)
					-- Scale up slightly on hover
					TweenService:Create(
						clearButton,
						TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Size = UDim2.fromOffset(38, 38)}
					):Play()
				end
			)

			Creator.AddSignal(
				clearButton.MouseLeave,
				function()
					clearBgTransparency(0.9)
					-- Scale back to normal
					TweenService:Create(
						clearButton,
						TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Size = UDim2.fromOffset(34, 34)}
					):Play()
				end
			)

			Creator.AddSignal(
				clearButton.MouseButton1Click,
				function()
					if not canClear then
						return
					end
					-- Bounce animation on click
					local bounceSequence = TweenService:Create(
						clearButton,
						TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Size = UDim2.fromOffset(30, 30)}
					)
					bounceSequence:Play()
					bounceSequence.Completed:Connect(function()
						TweenService:Create(
							clearButton,
							TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{Size = UDim2.fromOffset(34, 34)}
						):Play()
					end)

					if config.Multi then
						Dropdown.Value = {}
					else
						Dropdown.Value = nil
					end

					-- Update buttons without rebuilding
					for button, buttonData in pairs(Dropdown.Buttons) do
						buttonData:UpdateButton()
					end

					Dropdown:Display()
					Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
					Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
					Library._TouchElement(Dropdown)
				end
			)

			-- Select All button functionality with hover effect
			if config.Multi and selectAllButton then
				local _, selectAllTransparency = Creator.SpringMotor(0.9, selectAllButton, "BackgroundTransparency")

				Creator.AddSignal(
					selectAllButton.MouseEnter,
					function()
						selectAllTransparency(0.85)
					end
				)

				Creator.AddSignal(
					selectAllButton.MouseLeave,
					function()
						selectAllTransparency(0.9)
					end
				)

				Creator.AddSignal(
					selectAllButton.MouseButton1Click,
					function()
						-- Get all visible values (filtered by search)
						for _, value in pairs(Dropdown.Values) do
							local _, cleanText = parseColorCode(value)
							if Dropdown.SearchText == "" or cleanText:lower():find(Dropdown.SearchText, 1, true) then
								Dropdown.Value[value] = true
							end
						end

						-- Update buttons without rebuilding
						for button, buttonData in pairs(Dropdown.Buttons) do
							buttonData:UpdateButton()
						end

						Dropdown:Display()
						Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
						Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
						Library._TouchElement(Dropdown)
					end
				)
			end

			local searchDelay = 0.15 -- 150ms delay

			-- Drag-select state for multi-select
			local isDragging = false
			local dragStartValue = false

			-- Clear button animation helper
			local clearButtonStroke = clearButton:FindFirstChildOfClass("UIStroke")
			local isClearButtonVisible = false

			local function showClearButton()
				if isClearButtonVisible then return end
				isClearButtonVisible = true
				clearButton.Visible = true

				-- Animate size, transparency, and rotation
				TweenService:Create(
					clearButton,
					TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
					{
						Size = UDim2.fromOffset(34, 34),
						BackgroundTransparency = 0.9,
						TextTransparency = 0,
						Rotation = 0
					}
				):Play()

				if clearButtonStroke then
					TweenService:Create(
						clearButtonStroke,
						TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Transparency = 0.5}
					):Play()
				end
			end

			local function hideClearButton()
				if not isClearButtonVisible then return end
				isClearButtonVisible = false

				-- Animate out with rotation
				local hideTween = TweenService:Create(
					clearButton,
					TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In),
					{
						Size = UDim2.fromOffset(0, 0),
						BackgroundTransparency = 1,
						TextTransparency = 1,
						Rotation = 90
					}
				)

				if clearButtonStroke then
					TweenService:Create(
						clearButtonStroke,
						TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{Transparency = 1}
					):Play()
				end

				hideTween:Play()
				hideTween.Completed:Connect(function()
					clearButton.Visible = false
					clearButton.Rotation = -90
				end)
			end


			local scrollFrame = parent.ScrollFrame
			function Dropdown.Open(_self)
				if Dropdown.Opened then
					return
				end
				Dropdown.Opened = true
				Library._OpenDropdowns[Dropdown] = true
				connectWhileOpen()
				scrollFrame.ScrollingEnabled = false
				dropdownHolderCanvas.Visible = true
				searchBox.Text = ""
				Dropdown.SearchText = ""
				dropdownScrollFrame.CanvasPosition = Vector2.new(0, 0)
				if not dropdownBuilt then
					rebuildDropdown()
				end
				recalculateListPosition()
				recalculateListSize()

				-- Arrow rotation animation
				arrowRotation:setGoal(Flipper.Spring.new(180, {frequency = 4, dampingRatio = 0.8}))

				-- Open animation with Back easing
				dropdownHolderFrame.Size = UDim2.fromScale(1, 0.3)
				TweenService:Create(
					dropdownHolderFrame,
					TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
					{Size = UDim2.fromScale(1, 1)}
				):Play()
			end

			function Dropdown.Close(_self)
				if not Dropdown.Opened then
					return
				end
				Dropdown.Opened = false
				Library._OpenDropdowns[Dropdown] = nil
				disconnectWhileOpen()
				scrollFrame.ScrollingEnabled = true

				-- Arrow rotation animation
				arrowRotation:setGoal(Flipper.Spring.new(0, {frequency = 4, dampingRatio = 0.8}))

				local closeTween =
					TweenService:Create(
						dropdownHolderFrame,
						TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In),
						{Size = UDim2.fromScale(1, 0.3)}
					)
				closeTween:Play()
				closeTween.Completed:Connect(
					function()
						dropdownHolderCanvas.Visible = false
					end
				)
			end

			function Dropdown.Display(_self)
				local values, text = Dropdown.Values, ""
				local hasSelection = false
				if config.Multi then
					for _, value in next, values do
						if Dropdown.Value[value] then
							-- Remove color code for display
							local _, cleanText = parseColorCode(value)
							text = text .. cleanText .. ", "
							hasSelection = true
						end
					end
					text = text:sub(1, #text - 2)
				else
					-- Remove color code for display
					local displayText = Dropdown.Value or ""
					if displayText ~= "" then
						local _, cleanText = parseColorCode(displayText)
						displayText = cleanText
					end
					text = displayText
					hasSelection = Dropdown.Value ~= nil and Dropdown.Value ~= ""
				end
				stopSelectedLabelScroll()
				dropdownDisplay.Text = (text == "" and "--" or text)

				-- Animate clear button visibility
				if hasSelection and canClear then
					showClearButton()
				else
					hideClearButton()
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
				local values, buttons = Dropdown.Values, {}
				for _, child in next, dropdownScrollFrame:GetChildren() do
					if not child:IsA "UIListLayout" then
						child:Destroy()
					end
				end
				Dropdown.Buttons = {}
				local renderItems = {}
				for _, value in next, values do
					local customColor, cleanText = parseColorCode(value)
					local searchTarget = cleanText:lower()
					if Dropdown.SearchText == "" or searchTarget:find(Dropdown.SearchText, 1, true) then
						table.insert(renderItems, {Value = value, CustomColor = customColor, CleanText = cleanText})
					end
				end

				local totalItems = #renderItems
				local useVirtual = virtualEnabled and totalItems > virtualThreshold
				local startIndex, endIndex = 1, totalItems
				if useVirtual then
					startIndex = math.max(1, math.floor(dropdownScrollFrame.CanvasPosition.Y / virtualRowHeight) + 1 - virtualBuffer)
					startIndex = math.min(startIndex, math.max(totalItems, 1))
					local visibleCount = math.ceil(math.max(dropdownScrollFrame.AbsoluteSize.Y, 1) / virtualRowHeight) + (virtualBuffer * 2)
					endIndex = math.min(totalItems, startIndex + visibleCount)
					local topHeight = (startIndex - 1) * virtualRowHeight
					if topHeight > 0 then
						New("Frame", {Size = UDim2.new(1, -10, 0, topHeight), BackgroundTransparency = 1, Parent = dropdownScrollFrame})
					end
				end

				local rowCount = 0
				for index = startIndex, endIndex do
					local item = renderItems[index]
					if item then
						local value = item.Value
						local customColor, cleanText = item.CustomColor, item.CleanText
						local row = {}
						rowCount = rowCount + 1

						-- Use custom color for background if provided
						local bgColor = Color3.fromRGB(255, 255, 255)
						local bgTransparency = 1

						if customColor then
							-- ใช้สี 60% ของสีต้นฉบับ เพื่อให้เห็นสีชัดเจนขึ้น
							local r, g, b = customColor.R * 255, customColor.G * 255, customColor.B * 255
							bgColor = Color3.fromRGB(
								math.floor(r * 0.6 + 15),
								math.floor(g * 0.6 + 15),
								math.floor(b * 0.6 + 15)
							)
							bgTransparency = 0.65  -- โปร่งใส 65% (ลดลงจาก 85% เพื่อให้เห็นสีชัดขึ้น)
						end

						local buttonSelector, buttonLabel =
							New(
								"Frame",
								{
									Size = UDim2.fromOffset(5, 14),
									BackgroundColor3 = Color3.fromRGB(76, 194, 255),
									Position = UDim2.fromOffset(-1, 17),
									AnchorPoint = Vector2.new(0, 0.5),
									ThemeTag = {BackgroundColor3 = "Accent"}
								},
								{
									New("UICorner", {CornerRadius = UDim.new(0, 2)}),
									New(
										"UIGradient",
										{
											Color = ColorSequence.new({
												ColorSequenceKeypoint.new(0, Color3.fromRGB(76, 194, 255)),
												ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 210, 255))
											}),
											Rotation = 90
										}
									)
								}
							),
						New(
							"TextLabel",
							{
								FontFace = Font.new(
									"rbxasset://fonts/families/GothamSSm.json",
									Enum.FontWeight.Medium,
									Enum.FontStyle.Normal
								),
								Text = cleanText,
								-- Dropdown values are often game logic keys
								-- (for example "Instant" / "Tween").  Keep their
								-- runtime values stable instead of translating them.
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
								TextStrokeTransparency = 0.8,
								TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
								ThemeTag = {TextColor3 = "Text"}
							}
						)
						local labelClip =
							New(
								"Frame",
								{
									Size = UDim2.new(1, -24, 1, 0),
									Position = UDim2.fromOffset(12, 0),
									BackgroundTransparency = 1,
									ClipsDescendants = true
								},
								{buttonLabel}
							)
						local button, selected =
							(New(
								"TextButton",
								{
									Size = UDim2.new(1, -10, 0, 34),
									BackgroundColor3 = bgColor,
									BackgroundTransparency = bgTransparency,
									ClipsDescendants = true,
									ZIndex = 23,
									Text = "",
									Parent = dropdownScrollFrame,
									ThemeTag = customColor and {} or {BackgroundColor3 = "DropdownOption"}
								},
								{
									buttonSelector,
									labelClip,
									New("UICorner", {CornerRadius = UDim.new(0, 6)}),
									New(
										"UIStroke",
										{
											Thickness = 1.2,
											Transparency = 0.7,
											ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
											ThemeTag = {Color = "InElementBorder"}
										}
									)
								}
								))
						if config.Multi then
							selected = Dropdown.Value[value]
						else
							selected = Dropdown.Value == value
						end

						-- ปรับค่า transparency ตามว่ามีสีกำหนดหรือไม่
						local defaultTransparency = customColor and bgTransparency or 1
						local hoverTransparency = customColor and math.max(bgTransparency - 0.2, 0.3) or 0.89
						local selectedTransparency = customColor and math.max(bgTransparency - 0.3, 0.2) or 0.89

						local backMotor, setBackTransparency = Creator.SpringMotor(defaultTransparency, button, "BackgroundTransparency")
						local selMotor, setSelTransparency = Creator.SpringMotor(1, buttonSelector, "BackgroundTransparency")
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
							local visibleWidth = math.max(labelClip.AbsoluteSize.X, 0)
							local textWidth = getTextWidth(buttonLabel, cleanText) + 6
							if textWidth <= visibleWidth then
								return
							end
							stopLabelScroll()
							buttonLabel.TextTruncate = Enum.TextTruncate.None
							buttonLabel.Size = UDim2.fromOffset(textWidth, button.AbsoluteSize.Y)
							local travel = textWidth - visibleWidth
							labelScrollTween =
								TweenService:Create(
									buttonLabel,
									TweenInfo.new(math.clamp(travel / 35, 1.2, 5), Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0.25),
									{Position = UDim2.fromOffset(-travel, 0)}
								)
							labelScrollTween:Play()
						end
						local selectorSizeMotor = Flipper.SingleMotor.new(6)
						selectorSizeMotor:onStep(
							function(size)
								buttonSelector.Size = UDim2.new(0, 5, 0, size)
							end
						)
						Creator.AddSignal(
							button.MouseEnter,
							function()
								setBackTransparency(selected and selectedTransparency or hoverTransparency)
								startLabelScroll()
							end
						)
						Creator.AddSignal(
							button.MouseLeave,
							function()
								setBackTransparency(selected and selectedTransparency or defaultTransparency)
								stopLabelScroll()
							end
						)
						Creator.AddSignal(
							button.MouseButton1Down,
							function()
								setBackTransparency(customColor and 0.3 or 0.92)
							end
						)
						Creator.AddSignal(
							button.MouseButton1Up,
							function()
								setBackTransparency(selected and selectedTransparency or hoverTransparency)
							end
						)
						function row.UpdateButton(_self)
							if config.Multi then
								selected = Dropdown.Value[value]
								if selected then
									setBackTransparency(selectedTransparency)
								end
							else
								selected = Dropdown.Value == value
								setBackTransparency(selected and selectedTransparency or defaultTransparency)
							end
							selectorSizeMotor:setGoal(Flipper.Spring.new(selected and 16 or 6, {frequency = 6, dampingRatio = 0.8}))
							setSelTransparency(selected and 0 or 1)
						end
						-- Select on Activated (release), not on press, so a finger that
						-- starts a scroll on a row does not pick it. Activated still
						-- fires after a scroll, so it is ignored when the list moved
						-- between press and release. The press is recorded from the
						-- row and from its label, whichever receives it.
						local canvasAtPress = nil
						local function recordPress(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
								canvasAtPress = dropdownScrollFrame.CanvasPosition
							end
						end
						button.InputBegan:Connect(recordPress)
						buttonLabel.InputBegan:Connect(recordPress)
						button.Activated:Connect(
							function()
								local pressedAt = canvasAtPress
								canvasAtPress = nil
								local scrolled = pressedAt ~= nil and (dropdownScrollFrame.CanvasPosition - pressedAt).Magnitude > 4
								if not scrolled then
									local newSelected = not selected
									if Dropdown:GetActiveValues() == 1 and not newSelected and not config.AllowNull then
									else
										if config.Multi then
											selected = newSelected
											Dropdown.Value[value] = selected and true or nil
										else
											selected = newSelected
											Dropdown.Value = selected and value or nil
											for _, otherRow in next, buttons do
												otherRow:UpdateButton()
											end
										end
										row:UpdateButton()
										Dropdown:Display()
										Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
										Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
										Library._TouchElement(Dropdown)
									end
								end
							end
						)
						row:UpdateButton()
						buttons[button] = row
						Dropdown.Buttons[button] = row
					end
				end
				if useVirtual then
					local bottomHeight = (totalItems - endIndex) * virtualRowHeight
					if bottomHeight > 0 then
						New("Frame", {Size = UDim2.new(1, -10, 0, bottomHeight), BackgroundTransparency = 1, Parent = dropdownScrollFrame})
					end
				end
				Dropdown:Display()
				recalculateCanvasSize()
				recalculateListSize()
			end
			function Dropdown.SetValues(_self, values)
				if values then
					Dropdown.Values = values
				end
				dropdownScrollFrame.CanvasPosition = Vector2.new(0, 0)
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
			function Dropdown.SetValue(_self, value)
				if Dropdown.Multi then
					Dropdown.Value = toSelectionSet(value)
				else
					if not value then
						Dropdown.Value = nil
					elseif table.find(Dropdown.Values, value) then
						Dropdown.Value = value
					end
				end
				dropdownBuilt = false
				if Dropdown.Opened then
					rebuildDropdown()
				end
				Dropdown:Display()
				Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
				Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
			end
			function Dropdown.Destroy(_self)
				dropdownFrame:Destroy()
				Library.Options[idx] = nil
			end
			Dropdown:Display()
			local defaultIndexes = {}
			if type(config.Default) == "string" then
				local index = table.find(Dropdown.Values, config.Default)
				if index then
					table.insert(defaultIndexes, index)
				end
			elseif type(config.Default) == "table" then
				for key, defaultValue in next, config.Default do
					-- Accept both {"A", "B"} and {A = true}.
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
				Dropdown:Display()
			end
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
			function Input.SetValue(_self, text)
				if config.MaxLength and #text > config.MaxLength then
					text = text:sub(1, config.MaxLength)
				end
				if Input.Numeric then
					if (not tonumber(text)) and text:len() > 0 then
						text = Input.Value
					end
				end
				Input.Value = text
				inputBox.Text = text
				Library:SafeCallback(Input.Callback, Input.Value)
				Library:SafeCallback(Input.Changed, Input.Value)
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
		local UserInputService, Root = game:GetService "UserInputService", moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
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
			Keybind.SetTitle = keybindFrame.SetTitle
			Keybind.SetDesc = keybindFrame.SetDesc
			Keybind.Frame = keybindFrame.Frame
			local keybindDisplayLabel =
				New(
					"TextLabel",
					{
						FontFace = Font.new(
							"rbxasset://fonts/families/GothamSSm.json",
							Enum.FontWeight.Regular,
							Enum.FontStyle.Normal
						),
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
						BackgroundTransparency = 0.9,
						Parent = keybindFrame.Frame,
						AutomaticSize = Enum.AutomaticSize.X,
						ThemeTag = {BackgroundColor3 = "Keybind"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(0, 5)}),
						New("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}),
						New(
							"UIStroke",
							{
								Transparency = 0.5,
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
			end
			function Keybind.Destroy(_self)
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
						-- The first key or mouse button pressed is picked when it is
						-- released. Touch and gamepad input cannot be bound, so they
						-- cancel picking and keep the current key.
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
			Creator.AddSignal(
				UserInputService.InputBegan,
				function(input)
					if not picking and not UserInputService:GetFocusedTextBox() then
						if Keybind.Mode == "Toggle" then
							local key = Keybind.Value
							if key == "MouseLeft" or key == "MouseRight" then
								if
									key == "MouseLeft" and input.UserInputType == Enum.UserInputType.MouseButton1 or
									key == "MouseRight" and input.UserInputType == Enum.UserInputType.MouseButton2
								then
									Keybind.Toggled = not Keybind.Toggled
									Keybind:DoClick()
								end
							elseif input.UserInputType == Enum.UserInputType.Keyboard then
								if input.KeyCode.Name == key then
									Keybind.Toggled = not Keybind.Toggled
									Keybind:DoClick()
								end
							end
						end
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
		local Components, Flipper, Creator, Paragraph = Root.Components, requireModule(Root.Packages.Flipper), requireModule(Root.Creator), {}
		Paragraph.__index = Paragraph
		Paragraph.__type = "Paragraph"
		function Paragraph.New(_self, config)
			assert(config.Title, "Paragraph - Missing Title")
			config.Content = config.Content or ""
			local paragraph = requireModule(Components.Element)(config.Title, config.Content, Paragraph.Container, false)
			paragraph.Frame.BackgroundTransparency = 0.92
			paragraph.Border.Transparency = 0.6
			return paragraph
		end
		return Paragraph
	end,
	[26] = function()
		local _maui, moduleScript, requireModule, _getfenv, _setfenv = moduleContext(26)
		local UserInputService, Root = game:GetService "UserInputService", moduleScript.Parent.Parent
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
					Callback = config.Callback or function(_value)
					end,
					Type = "Slider"
				},
			false,
			requireModule(Components.Element)(config.Title, config.Description, parent.Container, false)
			sliderFrame.DescLabel.Size = UDim2.new(1, -170, 0, 14)
			Slider.SetTitle = sliderFrame.SetTitle
			Slider.SetDesc = sliderFrame.SetDesc
			Slider.Frame = sliderFrame.Frame
			local sliderDot =
				New(
					"ImageLabel",
					{
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, -7, 0.5, 0),
						Size = UDim2.fromOffset(14, 14),
						Image = "http://www.roblox.com/asset/?id=12266946128",
						ThemeTag = {ImageColor3 = "Accent"}
					}
				)

			-- แก้ตรงนี้: เปลี่ยนจาก TextLabel -> TextBox เพื่อให้พิมพ์ค่าได้
			local sliderRail, sliderFill, sliderDisplay =
				New(
					"Frame",
					{BackgroundTransparency = 1, Position = UDim2.fromOffset(7, 0), Size = UDim2.new(1, -14, 1, 0)},
					{sliderDot}
				),
			New(
				"Frame",
				{Size = UDim2.new(0, 0, 1, 0), ThemeTag = {BackgroundColor3 = "Accent"}},
				{New("UICorner", {CornerRadius = UDim.new(1, 0)})}
			),
			New(
				"TextBox",
				{
					FontFace = Font.new "rbxasset://fonts/families/GothamSSm.json",
					Text = "Value",
					I18nSkip = true,
					TextSize = 12,
					ClearTextOnFocus = false,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Right,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 100, 0, 14),
					-- ปรับตำแหน่งให้เลื่อนไปทางซ้ายเล็กน้อย
					Position = UDim2.new(0, -12, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5),
					ThemeTag = {TextColor3 = "SubText"},
					-- Allow numbers input; keyboard will show on mobile
					ClearTextOnFocus = false,
					TextEditable = true
				}
			)

			local sliderInner =
				New(
					"Frame",
					{
						Size = UDim2.new(1, 0, 0, 4),
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -10, 0.5, 0),
						BackgroundTransparency = 0.4,
						Parent = sliderFrame.Frame,
						ThemeTag = {BackgroundColor3 = "SliderRail"}
					},
					{
						New("UICorner", {CornerRadius = UDim.new(1, 0)}),
						New("UISizeConstraint", {MaxSize = Vector2.new(150, math.huge)}),
						sliderDisplay,
						sliderFill,
						sliderRail
					}
				)

			-- ถ้ามีการพิมพ์อยู่ หยุดการ drag ไว้
			local editingNumber = false

			-- ถ้าคลิกที่ไอคอน จะเริ่ม drag (เหมือนเดิม)
			Creator.AddSignal(
				sliderDot.InputBegan,
				function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						Library._TouchElement(Slider)
					end
				end
			)
			Creator.AddSignal(
				sliderDot.InputEnded,
				function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
					end
				end
			)
			-- Pressing anywhere on the rail sets the value and starts a drag. The
			-- rail is 4 px tall, so an invisible 24 px area catches the press.
			local railHitArea = New("Frame", {
				Name = "HitArea",
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.fromScale(0, 0.5),
				Size = UDim2.new(1, 0, 0, 24),
				Parent = sliderRail
			})
			Creator.AddSignal(
				railHitArea.InputBegan,
				function(input)
					if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
						and not editingNumber and sliderRail.AbsoluteSize.X > 0 then
						dragging = true
						local ratio = math.clamp((input.Position.X - sliderRail.AbsolutePosition.X) / sliderRail.AbsoluteSize.X, 0, 1)
						Slider:SetValue(Slider.Min + ((Slider.Max - Slider.Min) * ratio))
						Library._TouchElement(Slider)
					end
				end
			)
			-- A drag that started on the rail ends wherever the pointer is lifted.
			Creator.AddSignal(
				UserInputService.InputEnded,
				function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
					end
				end
			)

			-- ขณะพิมพ์ หยุดตอบสนองการลาก
			sliderDisplay.Focused:Connect(
				function()
					editingNumber = true
					-- ป้องกันค่า i (drag) ขณะพิมพ์
					dragging = false
				end
			)

			sliderDisplay.FocusLost:Connect(
				function(enterPressed)
					editingNumber = false
					-- ถ้ากด Enter หรือคลิกออก ให้อ่านค่าและอัปเดต slider
					local text = sliderDisplay.Text
					-- support comma เป็นจุดทศนิยมด้วย (เช่น "1,5")
					text = tostring(text):gsub(",", ".")
					local num = tonumber(text)
					if num then
						local newVal = Library:Round(math.clamp(num, Slider.Min, Slider.Max), Slider.Rounding)
						Slider:SetValue(newVal)
						Library._TouchElement(Slider)
					else
						-- revert to current value
						if Slider.Value ~= nil then
							sliderDisplay.Text = tostring(Slider.Value)
						else
							sliderDisplay.Text = tostring(config.Default)
						end
					end
				end
			)

			Creator.AddSignal(
				UserInputService.InputChanged,
				function(input)
					if editingNumber then
						return
					end
					if
						dragging and
						(input.UserInputType == Enum.UserInputType.MouseMovement or
							input.UserInputType == Enum.UserInputType.Touch)
					then
						local ratio = math.clamp((input.Position.X - sliderRail.AbsolutePosition.X) / sliderRail.AbsoluteSize.X, 0, 1)
						Slider:SetValue(Slider.Min + ((Slider.Max - Slider.Min) * ratio))
					end
				end
			)
			function Slider.OnChanged(_self, callback)
				Slider.Changed = callback
				callback(Slider.Value)
			end
			function Slider.SetValue(target, value)
				target.Value = Library:Round(math.clamp(value, Slider.Min, Slider.Max), Slider.Rounding)
				sliderDot.Position = UDim2.new((target.Value - Slider.Min) / (Slider.Max - Slider.Min), -7, 0.5, 0)
				sliderFill.Size = UDim2.fromScale((target.Value - Slider.Min) / (Slider.Max - Slider.Min), 1)
				-- อัปเดตข้อความใน TextBox ให้ตรงค่า
				sliderDisplay.Text = tostring(target.Value)
				Library:SafeCallback(Slider.Callback, target.Value)
				Library:SafeCallback(Slider.Changed, target.Value)
			end
			function Slider.Destroy(_self)
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
		local TweenService, Root = game:GetService "TweenService", moduleScript.Parent.Parent
		local Creator = requireModule(Root.Creator)
		local New, Components, Element = Creator.New, Root.Components, {}
		Element.__index = Element
		Element.__type = "Toggle"
		function Element.New(parent, idx, config)
			local Library = parent.Library
			assert(config.Title, "Toggle - Missing Title")
			local Toggle, toggleFrame =
				{
					Value = config.Default or false,
					Callback = config.Callback or function(_value)
					end,
					Type = "Toggle"
				},
			requireModule(Components.Element)(config.Title, config.Description, parent.Container, true)
			toggleFrame.DescLabel.Size = UDim2.new(1, -54, 0, 14)
			Toggle.SetTitle = toggleFrame.SetTitle
			Toggle.SetDesc = toggleFrame.SetDesc
			Toggle.Frame = toggleFrame.Frame
			local toggleCircle, toggleBorder =
				New(
					"ImageLabel",
					{
						AnchorPoint = Vector2.new(0, 0.5),
						Size = UDim2.fromOffset(14, 14),
						Position = UDim2.new(0, 2, 0.5, 0),
						Image = "http://www.roblox.com/asset/?id=12266946128",
						ImageTransparency = 0.5,
						ThemeTag = {ImageColor3 = "ToggleSlider"}
					}
				),
			New("UIStroke", {Transparency = 0.5, ThemeTag = {Color = "ToggleSlider"}})
			local toggleSlider =
				New(
					"Frame",
					{
						Size = UDim2.fromOffset(36, 18),
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -10, 0.5, 0),
						Parent = toggleFrame.Frame,
						BackgroundTransparency = 1,
						ThemeTag = {BackgroundColor3 = "Accent"}
					},
					{New("UICorner", {CornerRadius = UDim.new(0, 9)}), toggleBorder, toggleCircle}
				)
			function Toggle.OnChanged(_self, callback)
				Toggle.Changed = callback
				callback(Toggle.Value)
			end
			function Toggle.SetValue(_self, value)
				value = not (not value)
				Toggle.Value = value
				Creator.OverrideTag(toggleBorder, {Color = Toggle.Value and "Accent" or "ToggleSlider"})
				Creator.OverrideTag(toggleCircle, {ImageColor3 = Toggle.Value and "ToggleToggled" or "ToggleSlider"})
				TweenService:Create(
					toggleCircle,
					TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
					{Position = UDim2.new(0, Toggle.Value and 19 or 2, 0.5, 0)}
				):Play()
				TweenService:Create(
					toggleSlider,
					TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
					{BackgroundTransparency = Toggle.Value and 0 or 1}
				):Play()
				toggleCircle.ImageTransparency = Toggle.Value and 0 or 0.5
				Library:SafeCallback(Toggle.Callback, Toggle.Value)
				Library:SafeCallback(Toggle.Changed, Toggle.Value)
			end
			function Toggle.Destroy(_self)
				toggleFrame:Destroy()
				Library.Options[idx] = nil
			end
			Creator.AddSignal(
				toggleFrame.Frame.MouseButton1Click,
				function()
					Toggle:SetValue(not Toggle.Value)
					Library._TouchElement(Toggle)
				end
			)
			Toggle:SetValue(Toggle.Value)
			Library.Options[idx] = Toggle
			return Toggle
		end
		return Element
	end,
	[28] = function()
		local _maui, _moduleScript, _requireModule, _getfenv, _setfenv = moduleContext(28)
		return {
			assets = {
				["lucide-accessibility"] = "rbxassetid://10709751939",
				["lucide-activity"] = "rbxassetid://10709752035",
				["lucide-air-vent"] = "rbxassetid://10709752131",
				["lucide-airplay"] = "rbxassetid://10709752254",
				["lucide-alarm-check"] = "rbxassetid://10709752405",
				["lucide-alarm-clock"] = "rbxassetid://10709752630",
				["lucide-alarm-clock-off"] = "rbxassetid://10709752508",
				["lucide-alarm-minus"] = "rbxassetid://10709752732",
				["lucide-alarm-plus"] = "rbxassetid://10709752825",
				["lucide-album"] = "rbxassetid://10709752906",
				["lucide-alert-circle"] = "rbxassetid://10709752996",
				["lucide-alert-octagon"] = "rbxassetid://10709753064",
				["lucide-alert-triangle"] = "rbxassetid://10709753149",
				["lucide-align-center"] = "rbxassetid://10709753570",
				["lucide-align-center-horizontal"] = "rbxassetid://10709753272",
				["lucide-align-center-vertical"] = "rbxassetid://10709753421",
				["lucide-align-end-horizontal"] = "rbxassetid://10709753692",
				["lucide-align-end-vertical"] = "rbxassetid://10709753808",
				["lucide-align-horizontal-distribute-center"] = "rbxassetid://10747779791",
				["lucide-align-horizontal-distribute-end"] = "rbxassetid://10747784534",
				["lucide-align-horizontal-distribute-start"] = "rbxassetid://10709754118",
				["lucide-align-horizontal-justify-center"] = "rbxassetid://10709754204",
				["lucide-align-horizontal-justify-end"] = "rbxassetid://10709754317",
				["lucide-align-horizontal-justify-start"] = "rbxassetid://10709754436",
				["lucide-align-horizontal-space-around"] = "rbxassetid://10709754590",
				["lucide-align-horizontal-space-between"] = "rbxassetid://10709754749",
				["lucide-align-justify"] = "rbxassetid://10709759610",
				["lucide-align-left"] = "rbxassetid://10709759764",
				["lucide-align-right"] = "rbxassetid://10709759895",
				["lucide-align-start-horizontal"] = "rbxassetid://10709760051",
				["lucide-align-start-vertical"] = "rbxassetid://10709760244",
				["lucide-align-vertical-distribute-center"] = "rbxassetid://10709760351",
				["lucide-align-vertical-distribute-end"] = "rbxassetid://10709760434",
				["lucide-align-vertical-distribute-start"] = "rbxassetid://10709760612",
				["lucide-align-vertical-justify-center"] = "rbxassetid://10709760814",
				["lucide-align-vertical-justify-end"] = "rbxassetid://10709761003",
				["lucide-align-vertical-justify-start"] = "rbxassetid://10709761176",
				["lucide-align-vertical-space-around"] = "rbxassetid://10709761324",
				["lucide-align-vertical-space-between"] = "rbxassetid://10709761434",
				["lucide-anchor"] = "rbxassetid://10709761530",
				["lucide-angry"] = "rbxassetid://10709761629",
				["lucide-annoyed"] = "rbxassetid://10709761722",
				["lucide-aperture"] = "rbxassetid://10709761813",
				["lucide-apple"] = "rbxassetid://10709761889",
				["lucide-archive"] = "rbxassetid://10709762233",
				["lucide-archive-restore"] = "rbxassetid://10709762058",
				["lucide-armchair"] = "rbxassetid://10709762327",
				["lucide-arrow-big-down"] = "rbxassetid://10747796644",
				["lucide-arrow-big-left"] = "rbxassetid://10709762574",
				["lucide-arrow-big-right"] = "rbxassetid://10709762727",
				["lucide-arrow-big-up"] = "rbxassetid://10709762879",
				["lucide-arrow-down"] = "rbxassetid://10709767827",
				["lucide-arrow-down-circle"] = "rbxassetid://10709763034",
				["lucide-arrow-down-left"] = "rbxassetid://10709767656",
				["lucide-arrow-down-right"] = "rbxassetid://10709767750",
				["lucide-arrow-left"] = "rbxassetid://10709768114",
				["lucide-arrow-left-circle"] = "rbxassetid://10709767936",
				["lucide-arrow-left-right"] = "rbxassetid://10709768019",
				["lucide-arrow-right"] = "rbxassetid://10709768347",
				["lucide-arrow-right-circle"] = "rbxassetid://10709768226",
				["lucide-arrow-up"] = "rbxassetid://10709768939",
				["lucide-arrow-up-circle"] = "rbxassetid://10709768432",
				["lucide-arrow-up-down"] = "rbxassetid://10709768538",
				["lucide-arrow-up-left"] = "rbxassetid://10709768661",
				["lucide-arrow-up-right"] = "rbxassetid://10709768787",
				["lucide-asterisk"] = "rbxassetid://10709769095",
				["lucide-at-sign"] = "rbxassetid://10709769286",
				["lucide-award"] = "rbxassetid://10709769406",
				["lucide-axe"] = "rbxassetid://10709769508",
				["lucide-axis-3d"] = "rbxassetid://10709769598",
				["lucide-baby"] = "rbxassetid://10709769732",
				["lucide-backpack"] = "rbxassetid://10709769841",
				["lucide-baggage-claim"] = "rbxassetid://10709769935",
				["lucide-banana"] = "rbxassetid://10709770005",
				["lucide-banknote"] = "rbxassetid://10709770178",
				["lucide-bar-chart"] = "rbxassetid://10709773755",
				["lucide-bar-chart-2"] = "rbxassetid://10709770317",
				["lucide-bar-chart-3"] = "rbxassetid://10709770431",
				["lucide-bar-chart-4"] = "rbxassetid://10709770560",
				["lucide-bar-chart-horizontal"] = "rbxassetid://10709773669",
				["lucide-barcode"] = "rbxassetid://10747360675",
				["lucide-baseline"] = "rbxassetid://10709773863",
				["lucide-bath"] = "rbxassetid://10709773963",
				["lucide-battery"] = "rbxassetid://10709774640",
				["lucide-battery-charging"] = "rbxassetid://10709774068",
				["lucide-battery-full"] = "rbxassetid://10709774206",
				["lucide-battery-low"] = "rbxassetid://10709774370",
				["lucide-battery-medium"] = "rbxassetid://10709774513",
				["lucide-beaker"] = "rbxassetid://10709774756",
				["lucide-bed"] = "rbxassetid://10709775036",
				["lucide-bed-double"] = "rbxassetid://10709774864",
				["lucide-bed-single"] = "rbxassetid://10709774968",
				["lucide-beer"] = "rbxassetid://10709775167",
				["lucide-bell"] = "rbxassetid://10709775704",
				["lucide-bell-minus"] = "rbxassetid://10709775241",
				["lucide-bell-off"] = "rbxassetid://10709775320",
				["lucide-bell-plus"] = "rbxassetid://10709775448",
				["lucide-bell-ring"] = "rbxassetid://10709775560",
				["lucide-bike"] = "rbxassetid://10709775894",
				["lucide-binary"] = "rbxassetid://10709776050",
				["lucide-bitcoin"] = "rbxassetid://10709776126",
				["lucide-bluetooth"] = "rbxassetid://10709776655",
				["lucide-bluetooth-connected"] = "rbxassetid://10709776240",
				["lucide-bluetooth-off"] = "rbxassetid://10709776344",
				["lucide-bluetooth-searching"] = "rbxassetid://10709776501",
				["lucide-bold"] = "rbxassetid://10747813908",
				["lucide-bomb"] = "rbxassetid://10709781460",
				["lucide-bone"] = "rbxassetid://10709781605",
				["lucide-book"] = "rbxassetid://10709781824",
				["lucide-book-open"] = "rbxassetid://10709781717",
				["lucide-bookmark"] = "rbxassetid://10709782154",
				["lucide-bookmark-minus"] = "rbxassetid://10709781919",
				["lucide-bookmark-plus"] = "rbxassetid://10709782044",
				["lucide-bot"] = "rbxassetid://10709782230",
				["lucide-box"] = "rbxassetid://10709782497",
				["lucide-box-select"] = "rbxassetid://10709782342",
				["lucide-boxes"] = "rbxassetid://10709782582",
				["lucide-briefcase"] = "rbxassetid://10709782662",
				["lucide-brush"] = "rbxassetid://10709782758",
				["lucide-bug"] = "rbxassetid://10709782845",
				["lucide-building"] = "rbxassetid://10709783051",
				["lucide-building-2"] = "rbxassetid://10709782939",
				["lucide-bus"] = "rbxassetid://10709783137",
				["lucide-cake"] = "rbxassetid://10709783217",
				["lucide-calculator"] = "rbxassetid://10709783311",
				["lucide-calendar"] = "rbxassetid://10709789505",
				["lucide-calendar-check"] = "rbxassetid://10709783474",
				["lucide-calendar-check-2"] = "rbxassetid://10709783392",
				["lucide-calendar-clock"] = "rbxassetid://10709783577",
				["lucide-calendar-days"] = "rbxassetid://10709783673",
				["lucide-calendar-heart"] = "rbxassetid://10709783835",
				["lucide-calendar-minus"] = "rbxassetid://10709783959",
				["lucide-calendar-off"] = "rbxassetid://10709788784",
				["lucide-calendar-plus"] = "rbxassetid://10709788937",
				["lucide-calendar-range"] = "rbxassetid://10709789053",
				["lucide-calendar-search"] = "rbxassetid://10709789200",
				["lucide-calendar-x"] = "rbxassetid://10709789407",
				["lucide-calendar-x-2"] = "rbxassetid://10709789329",
				["lucide-camera"] = "rbxassetid://10709789686",
				["lucide-camera-off"] = "rbxassetid://10747822677",
				["lucide-car"] = "rbxassetid://10709789810",
				["lucide-carrot"] = "rbxassetid://10709789960",
				["lucide-cast"] = "rbxassetid://10709790097",
				["lucide-charge"] = "rbxassetid://10709790202",
				["lucide-check"] = "rbxassetid://10709790644",
				["lucide-check-circle"] = "rbxassetid://10709790387",
				["lucide-check-circle-2"] = "rbxassetid://10709790298",
				["lucide-check-square"] = "rbxassetid://10709790537",
				["lucide-chef-hat"] = "rbxassetid://10709790757",
				["lucide-cherry"] = "rbxassetid://10709790875",
				["lucide-chevron-down"] = "rbxassetid://10709790948",
				["lucide-chevron-first"] = "rbxassetid://10709791015",
				["lucide-chevron-last"] = "rbxassetid://10709791130",
				["lucide-chevron-left"] = "rbxassetid://10709791281",
				["lucide-chevron-right"] = "rbxassetid://10709791437",
				["lucide-chevron-up"] = "rbxassetid://10709791523",
				["lucide-chevrons-down"] = "rbxassetid://10709796864",
				["lucide-chevrons-down-up"] = "rbxassetid://10709791632",
				["lucide-chevrons-left"] = "rbxassetid://10709797151",
				["lucide-chevrons-left-right"] = "rbxassetid://10709797006",
				["lucide-chevrons-right"] = "rbxassetid://10709797382",
				["lucide-chevrons-right-left"] = "rbxassetid://10709797274",
				["lucide-chevrons-up"] = "rbxassetid://10709797622",
				["lucide-chevrons-up-down"] = "rbxassetid://10709797508",
				["lucide-chrome"] = "rbxassetid://10709797725",
				["lucide-circle"] = "rbxassetid://10709798174",
				["lucide-circle-dot"] = "rbxassetid://10709797837",
				["lucide-circle-ellipsis"] = "rbxassetid://10709797985",
				["lucide-circle-slashed"] = "rbxassetid://10709798100",
				["lucide-citrus"] = "rbxassetid://10709798276",
				["lucide-clapperboard"] = "rbxassetid://10709798350",
				["lucide-clipboard"] = "rbxassetid://10709799288",
				["lucide-clipboard-check"] = "rbxassetid://10709798443",
				["lucide-clipboard-copy"] = "rbxassetid://10709798574",
				["lucide-clipboard-edit"] = "rbxassetid://10709798682",
				["lucide-clipboard-list"] = "rbxassetid://10709798792",
				["lucide-clipboard-signature"] = "rbxassetid://10709798890",
				["lucide-clipboard-type"] = "rbxassetid://10709798999",
				["lucide-clipboard-x"] = "rbxassetid://10709799124",
				["lucide-clock"] = "rbxassetid://10709805144",
				["lucide-clock-1"] = "rbxassetid://10709799535",
				["lucide-clock-10"] = "rbxassetid://10709799718",
				["lucide-clock-11"] = "rbxassetid://10709799818",
				["lucide-clock-12"] = "rbxassetid://10709799962",
				["lucide-clock-2"] = "rbxassetid://10709803876",
				["lucide-clock-3"] = "rbxassetid://10709803989",
				["lucide-clock-4"] = "rbxassetid://10709804164",
				["lucide-clock-5"] = "rbxassetid://10709804291",
				["lucide-clock-6"] = "rbxassetid://10709804435",
				["lucide-clock-7"] = "rbxassetid://10709804599",
				["lucide-clock-8"] = "rbxassetid://10709804784",
				["lucide-clock-9"] = "rbxassetid://10709804996",
				["lucide-cloud"] = "rbxassetid://10709806740",
				["lucide-cloud-cog"] = "rbxassetid://10709805262",
				["lucide-cloud-drizzle"] = "rbxassetid://10709805371",
				["lucide-cloud-fog"] = "rbxassetid://10709805477",
				["lucide-cloud-hail"] = "rbxassetid://10709805596",
				["lucide-cloud-lightning"] = "rbxassetid://10709805727",
				["lucide-cloud-moon"] = "rbxassetid://10709805942",
				["lucide-cloud-moon-rain"] = "rbxassetid://10709805838",
				["lucide-cloud-off"] = "rbxassetid://10709806060",
				["lucide-cloud-rain"] = "rbxassetid://10709806277",
				["lucide-cloud-rain-wind"] = "rbxassetid://10709806166",
				["lucide-cloud-snow"] = "rbxassetid://10709806374",
				["lucide-cloud-sun"] = "rbxassetid://10709806631",
				["lucide-cloud-sun-rain"] = "rbxassetid://10709806475",
				["lucide-cloudy"] = "rbxassetid://10709806859",
				["lucide-clover"] = "rbxassetid://10709806995",
				["lucide-code"] = "rbxassetid://10709810463",
				["lucide-code-2"] = "rbxassetid://10709807111",
				["lucide-codepen"] = "rbxassetid://10709810534",
				["lucide-codesandbox"] = "rbxassetid://10709810676",
				["lucide-coffee"] = "rbxassetid://10709810814",
				["lucide-cog"] = "rbxassetid://10709810948",
				["lucide-coins"] = "rbxassetid://10709811110",
				["lucide-columns"] = "rbxassetid://10709811261",
				["lucide-command"] = "rbxassetid://10709811365",
				["lucide-compass"] = "rbxassetid://10709811445",
				["lucide-component"] = "rbxassetid://10709811595",
				["lucide-concierge-bell"] = "rbxassetid://10709811706",
				["lucide-connection"] = "rbxassetid://10747361219",
				["lucide-contact"] = "rbxassetid://10709811834",
				["lucide-contrast"] = "rbxassetid://10709811939",
				["lucide-cookie"] = "rbxassetid://10709812067",
				["lucide-copy"] = "rbxassetid://10709812159",
				["lucide-copyleft"] = "rbxassetid://10709812251",
				["lucide-copyright"] = "rbxassetid://10709812311",
				["lucide-corner-down-left"] = "rbxassetid://10709812396",
				["lucide-corner-down-right"] = "rbxassetid://10709812485",
				["lucide-corner-left-down"] = "rbxassetid://10709812632",
				["lucide-corner-left-up"] = "rbxassetid://10709812784",
				["lucide-corner-right-down"] = "rbxassetid://10709812939",
				["lucide-corner-right-up"] = "rbxassetid://10709813094",
				["lucide-corner-up-left"] = "rbxassetid://10709813185",
				["lucide-corner-up-right"] = "rbxassetid://10709813281",
				["lucide-cpu"] = "rbxassetid://10709813383",
				["lucide-croissant"] = "rbxassetid://10709818125",
				["lucide-crop"] = "rbxassetid://10709818245",
				["lucide-cross"] = "rbxassetid://10709818399",
				["lucide-crosshair"] = "rbxassetid://10709818534",
				["lucide-crown"] = "rbxassetid://10709818626",
				["lucide-cup-soda"] = "rbxassetid://10709818763",
				["lucide-curly-braces"] = "rbxassetid://10709818847",
				["lucide-currency"] = "rbxassetid://10709818931",
				["lucide-database"] = "rbxassetid://10709818996",
				["lucide-delete"] = "rbxassetid://10709819059",
				["lucide-diamond"] = "rbxassetid://10709819149",
				["lucide-dice-1"] = "rbxassetid://10709819266",
				["lucide-dice-2"] = "rbxassetid://10709819361",
				["lucide-dice-3"] = "rbxassetid://10709819508",
				["lucide-dice-4"] = "rbxassetid://10709819670",
				["lucide-dice-5"] = "rbxassetid://10709819801",
				["lucide-dice-6"] = "rbxassetid://10709819896",
				["lucide-dices"] = "rbxassetid://10723343321",
				["lucide-diff"] = "rbxassetid://10723343416",
				["lucide-disc"] = "rbxassetid://10723343537",
				["lucide-divide"] = "rbxassetid://10723343805",
				["lucide-divide-circle"] = "rbxassetid://10723343636",
				["lucide-divide-square"] = "rbxassetid://10723343737",
				["lucide-dollar-sign"] = "rbxassetid://10723343958",
				["lucide-download"] = "rbxassetid://10723344270",
				["lucide-download-cloud"] = "rbxassetid://10723344088",
				["lucide-droplet"] = "rbxassetid://10723344432",
				["lucide-droplets"] = "rbxassetid://10734883356",
				["lucide-drumstick"] = "rbxassetid://10723344737",
				["lucide-edit"] = "rbxassetid://10734883598",
				["lucide-edit-2"] = "rbxassetid://10723344885",
				["lucide-edit-3"] = "rbxassetid://10723345088",
				["lucide-egg"] = "rbxassetid://10723345518",
				["lucide-egg-fried"] = "rbxassetid://10723345347",
				["lucide-electricity"] = "rbxassetid://10723345749",
				["lucide-electricity-off"] = "rbxassetid://10723345643",
				["lucide-equal"] = "rbxassetid://10723345990",
				["lucide-equal-not"] = "rbxassetid://10723345866",
				["lucide-eraser"] = "rbxassetid://10723346158",
				["lucide-euro"] = "rbxassetid://10723346372",
				["lucide-expand"] = "rbxassetid://10723346553",
				["lucide-external-link"] = "rbxassetid://10723346684",
				["lucide-eye"] = "rbxassetid://10723346959",
				["lucide-eye-off"] = "rbxassetid://10723346871",
				["lucide-factory"] = "rbxassetid://10723347051",
				["lucide-fan"] = "rbxassetid://10723354359",
				["lucide-fast-forward"] = "rbxassetid://10723354521",
				["lucide-feather"] = "rbxassetid://10723354671",
				["lucide-figma"] = "rbxassetid://10723354801",
				["lucide-file"] = "rbxassetid://10723374641",
				["lucide-file-archive"] = "rbxassetid://10723354921",
				["lucide-file-audio"] = "rbxassetid://10723355148",
				["lucide-file-audio-2"] = "rbxassetid://10723355026",
				["lucide-file-axis-3d"] = "rbxassetid://10723355272",
				["lucide-file-badge"] = "rbxassetid://10723355622",
				["lucide-file-badge-2"] = "rbxassetid://10723355451",
				["lucide-file-bar-chart"] = "rbxassetid://10723355887",
				["lucide-file-bar-chart-2"] = "rbxassetid://10723355746",
				["lucide-file-box"] = "rbxassetid://10723355989",
				["lucide-file-check"] = "rbxassetid://10723356210",
				["lucide-file-check-2"] = "rbxassetid://10723356100",
				["lucide-file-clock"] = "rbxassetid://10723356329",
				["lucide-file-code"] = "rbxassetid://10723356507",
				["lucide-file-cog"] = "rbxassetid://10723356830",
				["lucide-file-cog-2"] = "rbxassetid://10723356676",
				["lucide-file-diff"] = "rbxassetid://10723357039",
				["lucide-file-digit"] = "rbxassetid://10723357151",
				["lucide-file-down"] = "rbxassetid://10723357322",
				["lucide-file-edit"] = "rbxassetid://10723357495",
				["lucide-file-heart"] = "rbxassetid://10723357637",
				["lucide-file-image"] = "rbxassetid://10723357790",
				["lucide-file-input"] = "rbxassetid://10723357933",
				["lucide-file-json"] = "rbxassetid://10723364435",
				["lucide-file-json-2"] = "rbxassetid://10723364361",
				["lucide-file-key"] = "rbxassetid://10723364605",
				["lucide-file-key-2"] = "rbxassetid://10723364515",
				["lucide-file-line-chart"] = "rbxassetid://10723364725",
				["lucide-file-lock"] = "rbxassetid://10723364957",
				["lucide-file-lock-2"] = "rbxassetid://10723364861",
				["lucide-file-minus"] = "rbxassetid://10723365254",
				["lucide-file-minus-2"] = "rbxassetid://10723365086",
				["lucide-file-output"] = "rbxassetid://10723365457",
				["lucide-file-pie-chart"] = "rbxassetid://10723365598",
				["lucide-file-plus"] = "rbxassetid://10723365877",
				["lucide-file-plus-2"] = "rbxassetid://10723365766",
				["lucide-file-question"] = "rbxassetid://10723365987",
				["lucide-file-scan"] = "rbxassetid://10723366167",
				["lucide-file-search"] = "rbxassetid://10723366550",
				["lucide-file-search-2"] = "rbxassetid://10723366340",
				["lucide-file-signature"] = "rbxassetid://10723366741",
				["lucide-file-spreadsheet"] = "rbxassetid://10723366962",
				["lucide-file-symlink"] = "rbxassetid://10723367098",
				["lucide-file-terminal"] = "rbxassetid://10723367244",
				["lucide-file-text"] = "rbxassetid://10723367380",
				["lucide-file-type"] = "rbxassetid://10723367606",
				["lucide-file-type-2"] = "rbxassetid://10723367509",
				["lucide-file-up"] = "rbxassetid://10723367734",
				["lucide-file-video"] = "rbxassetid://10723373884",
				["lucide-file-video-2"] = "rbxassetid://10723367834",
				["lucide-file-volume"] = "rbxassetid://10723374172",
				["lucide-file-volume-2"] = "rbxassetid://10723374030",
				["lucide-file-warning"] = "rbxassetid://10723374276",
				["lucide-file-x"] = "rbxassetid://10723374544",
				["lucide-file-x-2"] = "rbxassetid://10723374378",
				["lucide-files"] = "rbxassetid://10723374759",
				["lucide-film"] = "rbxassetid://10723374981",
				["lucide-filter"] = "rbxassetid://10723375128",
				["lucide-fingerprint"] = "rbxassetid://10723375250",
				["lucide-flag"] = "rbxassetid://10723375890",
				["lucide-flag-off"] = "rbxassetid://10723375443",
				["lucide-flag-triangle-left"] = "rbxassetid://10723375608",
				["lucide-flag-triangle-right"] = "rbxassetid://10723375727",
				["lucide-flame"] = "rbxassetid://10723376114",
				["lucide-flashlight"] = "rbxassetid://10723376471",
				["lucide-flashlight-off"] = "rbxassetid://10723376365",
				["lucide-flask-conical"] = "rbxassetid://10734883986",
				["lucide-flask-round"] = "rbxassetid://10723376614",
				["lucide-flip-horizontal"] = "rbxassetid://10723376884",
				["lucide-flip-horizontal-2"] = "rbxassetid://10723376745",
				["lucide-flip-vertical"] = "rbxassetid://10723377138",
				["lucide-flip-vertical-2"] = "rbxassetid://10723377026",
				["lucide-flower"] = "rbxassetid://10747830374",
				["lucide-flower-2"] = "rbxassetid://10723377305",
				["lucide-focus"] = "rbxassetid://10723377537",
				["lucide-folder"] = "rbxassetid://10723387563",
				["lucide-folder-archive"] = "rbxassetid://10723384478",
				["lucide-folder-check"] = "rbxassetid://10723384605",
				["lucide-folder-clock"] = "rbxassetid://10723384731",
				["lucide-folder-closed"] = "rbxassetid://10723384893",
				["lucide-folder-cog"] = "rbxassetid://10723385213",
				["lucide-folder-cog-2"] = "rbxassetid://10723385036",
				["lucide-folder-down"] = "rbxassetid://10723385338",
				["lucide-folder-edit"] = "rbxassetid://10723385445",
				["lucide-folder-heart"] = "rbxassetid://10723385545",
				["lucide-folder-input"] = "rbxassetid://10723385721",
				["lucide-folder-key"] = "rbxassetid://10723385848",
				["lucide-folder-lock"] = "rbxassetid://10723386005",
				["lucide-folder-minus"] = "rbxassetid://10723386127",
				["lucide-folder-open"] = "rbxassetid://10723386277",
				["lucide-folder-output"] = "rbxassetid://10723386386",
				["lucide-folder-plus"] = "rbxassetid://10723386531",
				["lucide-folder-search"] = "rbxassetid://10723386787",
				["lucide-folder-search-2"] = "rbxassetid://10723386674",
				["lucide-folder-symlink"] = "rbxassetid://10723386930",
				["lucide-folder-tree"] = "rbxassetid://10723387085",
				["lucide-folder-up"] = "rbxassetid://10723387265",
				["lucide-folder-x"] = "rbxassetid://10723387448",
				["lucide-folders"] = "rbxassetid://10723387721",
				["lucide-form-input"] = "rbxassetid://10723387841",
				["lucide-forward"] = "rbxassetid://10723388016",
				["lucide-frame"] = "rbxassetid://10723394389",
				["lucide-framer"] = "rbxassetid://10723394565",
				["lucide-frown"] = "rbxassetid://10723394681",
				["lucide-fuel"] = "rbxassetid://10723394846",
				["lucide-function-square"] = "rbxassetid://10723395041",
				["lucide-gamepad"] = "rbxassetid://10723395457",
				["lucide-gamepad-2"] = "rbxassetid://10723395215",
				["lucide-gauge"] = "rbxassetid://10723395708",
				["lucide-gavel"] = "rbxassetid://10723395896",
				["lucide-gem"] = "rbxassetid://10723396000",
				["lucide-ghost"] = "rbxassetid://10723396107",
				["lucide-gift"] = "rbxassetid://10723396402",
				["lucide-gift-card"] = "rbxassetid://10723396225",
				["lucide-git-branch"] = "rbxassetid://10723396676",
				["lucide-git-branch-plus"] = "rbxassetid://10723396542",
				["lucide-git-commit"] = "rbxassetid://10723396812",
				["lucide-git-compare"] = "rbxassetid://10723396954",
				["lucide-git-fork"] = "rbxassetid://10723397049",
				["lucide-git-merge"] = "rbxassetid://10723397165",
				["lucide-git-pull-request"] = "rbxassetid://10723397431",
				["lucide-git-pull-request-closed"] = "rbxassetid://10723397268",
				["lucide-git-pull-request-draft"] = "rbxassetid://10734884302",
				["lucide-glass"] = "rbxassetid://10723397788",
				["lucide-glass-2"] = "rbxassetid://10723397529",
				["lucide-glass-water"] = "rbxassetid://10723397678",
				["lucide-glasses"] = "rbxassetid://10723397895",
				["lucide-globe"] = "rbxassetid://10723404337",
				["lucide-globe-2"] = "rbxassetid://10723398002",
				["lucide-grab"] = "rbxassetid://10723404472",
				["lucide-graduation-cap"] = "rbxassetid://10723404691",
				["lucide-grape"] = "rbxassetid://10723404822",
				["lucide-grid"] = "rbxassetid://10723404936",
				["lucide-grip-horizontal"] = "rbxassetid://10723405089",
				["lucide-grip-vertical"] = "rbxassetid://10723405236",
				["lucide-hammer"] = "rbxassetid://10723405360",
				["lucide-hand"] = "rbxassetid://10723405649",
				["lucide-hand-metal"] = "rbxassetid://10723405508",
				["lucide-hard-drive"] = "rbxassetid://10723405749",
				["lucide-hard-hat"] = "rbxassetid://10723405859",
				["lucide-hash"] = "rbxassetid://10723405975",
				["lucide-haze"] = "rbxassetid://10723406078",
				["lucide-headphones"] = "rbxassetid://10723406165",
				["lucide-heart"] = "rbxassetid://10723406885",
				["lucide-heart-crack"] = "rbxassetid://10723406299",
				["lucide-heart-handshake"] = "rbxassetid://10723406480",
				["lucide-heart-off"] = "rbxassetid://10723406662",
				["lucide-heart-pulse"] = "rbxassetid://10723406795",
				["lucide-help-circle"] = "rbxassetid://10723406988",
				["lucide-hexagon"] = "rbxassetid://10723407092",
				["lucide-highlighter"] = "rbxassetid://10723407192",
				["lucide-history"] = "rbxassetid://10723407335",
				["lucide-home"] = "rbxassetid://10723407389",
				["lucide-hourglass"] = "rbxassetid://10723407498",
				["lucide-ice-cream"] = "rbxassetid://10723414308",
				["lucide-image"] = "rbxassetid://10723415040",
				["lucide-image-minus"] = "rbxassetid://10723414487",
				["lucide-image-off"] = "rbxassetid://10723414677",
				["lucide-image-plus"] = "rbxassetid://10723414827",
				["lucide-import"] = "rbxassetid://10723415205",
				["lucide-inbox"] = "rbxassetid://10723415335",
				["lucide-indent"] = "rbxassetid://10723415494",
				["lucide-indian-rupee"] = "rbxassetid://10723415642",
				["lucide-infinity"] = "rbxassetid://10723415766",
				["lucide-info"] = "rbxassetid://10723415903",
				["lucide-inspect"] = "rbxassetid://10723416057",
				["lucide-italic"] = "rbxassetid://10723416195",
				["lucide-japanese-yen"] = "rbxassetid://10723416363",
				["lucide-joystick"] = "rbxassetid://10723416527",
				["lucide-key"] = "rbxassetid://10723416652",
				["lucide-keyboard"] = "rbxassetid://10723416765",
				["lucide-lamp"] = "rbxassetid://10723417513",
				["lucide-lamp-ceiling"] = "rbxassetid://10723416922",
				["lucide-lamp-desk"] = "rbxassetid://10723417016",
				["lucide-lamp-floor"] = "rbxassetid://10723417131",
				["lucide-lamp-wall-down"] = "rbxassetid://10723417240",
				["lucide-lamp-wall-up"] = "rbxassetid://10723417356",
				["lucide-landmark"] = "rbxassetid://10723417608",
				["lucide-languages"] = "rbxassetid://10723417703",
				["lucide-laptop"] = "rbxassetid://10723423881",
				["lucide-laptop-2"] = "rbxassetid://10723417797",
				["lucide-lasso"] = "rbxassetid://10723424235",
				["lucide-lasso-select"] = "rbxassetid://10723424058",
				["lucide-laugh"] = "rbxassetid://10723424372",
				["lucide-layers"] = "rbxassetid://10723424505",
				["lucide-layout"] = "rbxassetid://10723425376",
				["lucide-layout-dashboard"] = "rbxassetid://10723424646",
				["lucide-layout-grid"] = "rbxassetid://10723424838",
				["lucide-layout-list"] = "rbxassetid://10723424963",
				["lucide-layout-template"] = "rbxassetid://10723425187",
				["lucide-leaf"] = "rbxassetid://10723425539",
				["lucide-library"] = "rbxassetid://10723425615",
				["lucide-life-buoy"] = "rbxassetid://10723425685",
				["lucide-lightbulb"] = "rbxassetid://10723425852",
				["lucide-lightbulb-off"] = "rbxassetid://10723425762",
				["lucide-line-chart"] = "rbxassetid://10723426393",
				["lucide-link"] = "rbxassetid://10723426722",
				["lucide-link-2"] = "rbxassetid://10723426595",
				["lucide-link-2-off"] = "rbxassetid://10723426513",
				["lucide-list"] = "rbxassetid://10723433811",
				["lucide-list-checks"] = "rbxassetid://10734884548",
				["lucide-list-end"] = "rbxassetid://10723426886",
				["lucide-list-minus"] = "rbxassetid://10723426986",
				["lucide-list-music"] = "rbxassetid://10723427081",
				["lucide-list-ordered"] = "rbxassetid://10723427199",
				["lucide-list-plus"] = "rbxassetid://10723427334",
				["lucide-list-start"] = "rbxassetid://10723427494",
				["lucide-list-video"] = "rbxassetid://10723427619",
				["lucide-list-x"] = "rbxassetid://10723433655",
				["lucide-loader"] = "rbxassetid://10723434070",
				["lucide-loader-2"] = "rbxassetid://10723433935",
				["lucide-locate"] = "rbxassetid://10723434557",
				["lucide-locate-fixed"] = "rbxassetid://10723434236",
				["lucide-locate-off"] = "rbxassetid://10723434379",
				["lucide-lock"] = "rbxassetid://10723434711",
				["lucide-log-in"] = "rbxassetid://10723434830",
				["lucide-log-out"] = "rbxassetid://10723434906",
				["lucide-luggage"] = "rbxassetid://10723434993",
				["lucide-magnet"] = "rbxassetid://10723435069",
				["lucide-mail"] = "rbxassetid://10734885430",
				["lucide-mail-check"] = "rbxassetid://10723435182",
				["lucide-mail-minus"] = "rbxassetid://10723435261",
				["lucide-mail-open"] = "rbxassetid://10723435342",
				["lucide-mail-plus"] = "rbxassetid://10723435443",
				["lucide-mail-question"] = "rbxassetid://10723435515",
				["lucide-mail-search"] = "rbxassetid://10734884739",
				["lucide-mail-warning"] = "rbxassetid://10734885015",
				["lucide-mail-x"] = "rbxassetid://10734885247",
				["lucide-mails"] = "rbxassetid://10734885614",
				["lucide-map"] = "rbxassetid://10734886202",
				["lucide-map-pin"] = "rbxassetid://10734886004",
				["lucide-map-pin-off"] = "rbxassetid://10734885803",
				["lucide-maximize"] = "rbxassetid://10734886735",
				["lucide-maximize-2"] = "rbxassetid://10734886496",
				["lucide-medal"] = "rbxassetid://10734887072",
				["lucide-megaphone"] = "rbxassetid://10734887454",
				["lucide-megaphone-off"] = "rbxassetid://10734887311",
				["lucide-meh"] = "rbxassetid://10734887603",
				["lucide-menu"] = "rbxassetid://10734887784",
				["lucide-message-circle"] = "rbxassetid://10734888000",
				["lucide-message-square"] = "rbxassetid://10734888228",
				["lucide-mic"] = "rbxassetid://10734888864",
				["lucide-mic-2"] = "rbxassetid://10734888430",
				["lucide-mic-off"] = "rbxassetid://10734888646",
				["lucide-microscope"] = "rbxassetid://10734889106",
				["lucide-microwave"] = "rbxassetid://10734895076",
				["lucide-milestone"] = "rbxassetid://10734895310",
				["lucide-minimize"] = "rbxassetid://10734895698",
				["lucide-minimize-2"] = "rbxassetid://10734895530",
				["lucide-minus"] = "rbxassetid://10734896206",
				["lucide-minus-circle"] = "rbxassetid://10734895856",
				["lucide-minus-square"] = "rbxassetid://10734896029",
				["lucide-monitor"] = "rbxassetid://10734896881",
				["lucide-monitor-off"] = "rbxassetid://10734896360",
				["lucide-monitor-speaker"] = "rbxassetid://10734896512",
				["lucide-moon"] = "rbxassetid://10734897102",
				["lucide-more-horizontal"] = "rbxassetid://10734897250",
				["lucide-more-vertical"] = "rbxassetid://10734897387",
				["lucide-mountain"] = "rbxassetid://10734897956",
				["lucide-mountain-snow"] = "rbxassetid://10734897665",
				["lucide-mouse"] = "rbxassetid://10734898592",
				["lucide-mouse-pointer"] = "rbxassetid://10734898476",
				["lucide-mouse-pointer-2"] = "rbxassetid://10734898194",
				["lucide-mouse-pointer-click"] = "rbxassetid://10734898355",
				["lucide-move"] = "rbxassetid://10734900011",
				["lucide-move-3d"] = "rbxassetid://10734898756",
				["lucide-move-diagonal"] = "rbxassetid://10734899164",
				["lucide-move-diagonal-2"] = "rbxassetid://10734898934",
				["lucide-move-horizontal"] = "rbxassetid://10734899414",
				["lucide-move-vertical"] = "rbxassetid://10734899821",
				["lucide-music"] = "rbxassetid://10734905958",
				["lucide-music-2"] = "rbxassetid://10734900215",
				["lucide-music-3"] = "rbxassetid://10734905665",
				["lucide-music-4"] = "rbxassetid://10734905823",
				["lucide-navigation"] = "rbxassetid://10734906744",
				["lucide-navigation-2"] = "rbxassetid://10734906332",
				["lucide-navigation-2-off"] = "rbxassetid://10734906144",
				["lucide-navigation-off"] = "rbxassetid://10734906580",
				["lucide-network"] = "rbxassetid://10734906975",
				["lucide-newspaper"] = "rbxassetid://10734907168",
				["lucide-octagon"] = "rbxassetid://10734907361",
				["lucide-option"] = "rbxassetid://10734907649",
				["lucide-outdent"] = "rbxassetid://10734907933",
				["lucide-package"] = "rbxassetid://10734909540",
				["lucide-package-2"] = "rbxassetid://10734908151",
				["lucide-package-check"] = "rbxassetid://10734908384",
				["lucide-package-minus"] = "rbxassetid://10734908626",
				["lucide-package-open"] = "rbxassetid://10734908793",
				["lucide-package-plus"] = "rbxassetid://10734909016",
				["lucide-package-search"] = "rbxassetid://10734909196",
				["lucide-package-x"] = "rbxassetid://10734909375",
				["lucide-paint-bucket"] = "rbxassetid://10734909847",
				["lucide-paintbrush"] = "rbxassetid://10734910187",
				["lucide-paintbrush-2"] = "rbxassetid://10734910030",
				["lucide-palette"] = "rbxassetid://10734910430",
				["lucide-palmtree"] = "rbxassetid://10734910680",
				["lucide-paperclip"] = "rbxassetid://10734910927",
				["lucide-party-popper"] = "rbxassetid://10734918735",
				["lucide-pause"] = "rbxassetid://10734919336",
				["lucide-pause-circle"] = "rbxassetid://10735024209",
				["lucide-pause-octagon"] = "rbxassetid://10734919143",
				["lucide-pen-tool"] = "rbxassetid://10734919503",
				["lucide-pencil"] = "rbxassetid://10734919691",
				["lucide-percent"] = "rbxassetid://10734919919",
				["lucide-person-standing"] = "rbxassetid://10734920149",
				["lucide-phone"] = "rbxassetid://10734921524",
				["lucide-phone-call"] = "rbxassetid://10734920305",
				["lucide-phone-forwarded"] = "rbxassetid://10734920508",
				["lucide-phone-incoming"] = "rbxassetid://10734920694",
				["lucide-phone-missed"] = "rbxassetid://10734920845",
				["lucide-phone-off"] = "rbxassetid://10734921077",
				["lucide-phone-outgoing"] = "rbxassetid://10734921288",
				["lucide-pie-chart"] = "rbxassetid://10734921727",
				["lucide-piggy-bank"] = "rbxassetid://10734921935",
				["lucide-pin"] = "rbxassetid://10734922324",
				["lucide-pin-off"] = "rbxassetid://10734922180",
				["lucide-pipette"] = "rbxassetid://10734922497",
				["lucide-pizza"] = "rbxassetid://10734922774",
				["lucide-plane"] = "rbxassetid://10734922971",
				["lucide-play"] = "rbxassetid://10734923549",
				["lucide-play-circle"] = "rbxassetid://10734923214",
				["lucide-plus"] = "rbxassetid://10734924532",
				["lucide-plus-circle"] = "rbxassetid://10734923868",
				["lucide-plus-square"] = "rbxassetid://10734924219",
				["lucide-podcast"] = "rbxassetid://10734929553",
				["lucide-pointer"] = "rbxassetid://10734929723",
				["lucide-pound-sterling"] = "rbxassetid://10734929981",
				["lucide-power"] = "rbxassetid://10734930466",
				["lucide-power-off"] = "rbxassetid://10734930257",
				["lucide-printer"] = "rbxassetid://10734930632",
				["lucide-puzzle"] = "rbxassetid://10734930886",
				["lucide-quote"] = "rbxassetid://10734931234",
				["lucide-radio"] = "rbxassetid://10734931596",
				["lucide-radio-receiver"] = "rbxassetid://10734931402",
				["lucide-rectangle-horizontal"] = "rbxassetid://10734931777",
				["lucide-rectangle-vertical"] = "rbxassetid://10734932081",
				["lucide-recycle"] = "rbxassetid://10734932295",
				["lucide-redo"] = "rbxassetid://10734932822",
				["lucide-redo-2"] = "rbxassetid://10734932586",
				["lucide-refresh-ccw"] = "rbxassetid://10734933056",
				["lucide-refresh-cw"] = "rbxassetid://10734933222",
				["lucide-refrigerator"] = "rbxassetid://10734933465",
				["lucide-regex"] = "rbxassetid://10734933655",
				["lucide-repeat"] = "rbxassetid://10734933966",
				["lucide-repeat-1"] = "rbxassetid://10734933826",
				["lucide-reply"] = "rbxassetid://10734934252",
				["lucide-reply-all"] = "rbxassetid://10734934132",
				["lucide-rewind"] = "rbxassetid://10734934347",
				["lucide-rocket"] = "rbxassetid://10734934585",
				["lucide-rocking-chair"] = "rbxassetid://10734939942",
				["lucide-rotate-3d"] = "rbxassetid://10734940107",
				["lucide-rotate-ccw"] = "rbxassetid://10734940376",
				["lucide-rotate-cw"] = "rbxassetid://10734940654",
				["lucide-rss"] = "rbxassetid://10734940825",
				["lucide-ruler"] = "rbxassetid://10734941018",
				["lucide-russian-ruble"] = "rbxassetid://10734941199",
				["lucide-sailboat"] = "rbxassetid://10734941354",
				["lucide-save"] = "rbxassetid://10734941499",
				["lucide-scale"] = "rbxassetid://10734941912",
				["lucide-scale-3d"] = "rbxassetid://10734941739",
				["lucide-scaling"] = "rbxassetid://10734942072",
				["lucide-scan"] = "rbxassetid://10734942565",
				["lucide-scan-face"] = "rbxassetid://10734942198",
				["lucide-scan-line"] = "rbxassetid://10734942351",
				["lucide-scissors"] = "rbxassetid://10734942778",
				["lucide-screen-share"] = "rbxassetid://10734943193",
				["lucide-screen-share-off"] = "rbxassetid://10734942967",
				["lucide-scroll"] = "rbxassetid://10734943448",
				["lucide-search"] = "rbxassetid://10734943674",
				["lucide-send"] = "rbxassetid://10734943902",
				["lucide-separator-horizontal"] = "rbxassetid://10734944115",
				["lucide-separator-vertical"] = "rbxassetid://10734944326",
				["lucide-server"] = "rbxassetid://10734949856",
				["lucide-server-cog"] = "rbxassetid://10734944444",
				["lucide-server-crash"] = "rbxassetid://10734944554",
				["lucide-server-off"] = "rbxassetid://10734944668",
				["lucide-settings"] = "rbxassetid://10734950309",
				["lucide-settings-2"] = "rbxassetid://10734950020",
				["lucide-share"] = "rbxassetid://10734950813",
				["lucide-share-2"] = "rbxassetid://10734950553",
				["lucide-sheet"] = "rbxassetid://10734951038",
				["lucide-shield"] = "rbxassetid://10734951847",
				["lucide-shield-alert"] = "rbxassetid://10734951173",
				["lucide-shield-check"] = "rbxassetid://10734951367",
				["lucide-shield-close"] = "rbxassetid://10734951535",
				["lucide-shield-off"] = "rbxassetid://10734951684",
				["lucide-shirt"] = "rbxassetid://10734952036",
				["lucide-shopping-bag"] = "rbxassetid://10734952273",
				["lucide-shopping-cart"] = "rbxassetid://10734952479",
				["lucide-shovel"] = "rbxassetid://10734952773",
				["lucide-shower-head"] = "rbxassetid://10734952942",
				["lucide-shrink"] = "rbxassetid://10734953073",
				["lucide-shrub"] = "rbxassetid://10734953241",
				["lucide-shuffle"] = "rbxassetid://10734953451",
				["lucide-sidebar"] = "rbxassetid://10734954301",
				["lucide-sidebar-close"] = "rbxassetid://10734953715",
				["lucide-sidebar-open"] = "rbxassetid://10734954000",
				["lucide-sigma"] = "rbxassetid://10734954538",
				["lucide-signal"] = "rbxassetid://10734961133",
				["lucide-signal-high"] = "rbxassetid://10734954807",
				["lucide-signal-low"] = "rbxassetid://10734955080",
				["lucide-signal-medium"] = "rbxassetid://10734955336",
				["lucide-signal-zero"] = "rbxassetid://10734960878",
				["lucide-siren"] = "rbxassetid://10734961284",
				["lucide-skip-back"] = "rbxassetid://10734961526",
				["lucide-skip-forward"] = "rbxassetid://10734961809",
				["lucide-skull"] = "rbxassetid://10734962068",
				["lucide-slack"] = "rbxassetid://10734962339",
				["lucide-slash"] = "rbxassetid://10734962600",
				["lucide-slice"] = "rbxassetid://10734963024",
				["lucide-sliders"] = "rbxassetid://10734963400",
				["lucide-sliders-horizontal"] = "rbxassetid://10734963191",
				["lucide-smartphone"] = "rbxassetid://10734963940",
				["lucide-smartphone-charging"] = "rbxassetid://10734963671",
				["lucide-smile"] = "rbxassetid://10734964441",
				["lucide-smile-plus"] = "rbxassetid://10734964188",
				["lucide-snowflake"] = "rbxassetid://10734964600",
				["lucide-sofa"] = "rbxassetid://10734964852",
				["lucide-sort-asc"] = "rbxassetid://10734965115",
				["lucide-sort-desc"] = "rbxassetid://10734965287",
				["lucide-speaker"] = "rbxassetid://10734965419",
				["lucide-sprout"] = "rbxassetid://10734965572",
				["lucide-square"] = "rbxassetid://10734965702",
				["lucide-star"] = "rbxassetid://10734966248",
				["lucide-star-half"] = "rbxassetid://10734965897",
				["lucide-star-off"] = "rbxassetid://10734966097",
				["lucide-stethoscope"] = "rbxassetid://10734966384",
				["lucide-sticker"] = "rbxassetid://10734972234",
				["lucide-sticky-note"] = "rbxassetid://10734972463",
				["lucide-stop-circle"] = "rbxassetid://10734972621",
				["lucide-stretch-horizontal"] = "rbxassetid://10734972862",
				["lucide-stretch-vertical"] = "rbxassetid://10734973130",
				["lucide-strikethrough"] = "rbxassetid://10734973290",
				["lucide-subscript"] = "rbxassetid://10734973457",
				["lucide-sun"] = "rbxassetid://10734974297",
				["lucide-sun-dim"] = "rbxassetid://10734973645",
				["lucide-sun-medium"] = "rbxassetid://10734973778",
				["lucide-sun-moon"] = "rbxassetid://10734973999",
				["lucide-sun-snow"] = "rbxassetid://10734974130",
				["lucide-sunrise"] = "rbxassetid://10734974522",
				["lucide-sunset"] = "rbxassetid://10734974689",
				["lucide-superscript"] = "rbxassetid://10734974850",
				["lucide-swiss-franc"] = "rbxassetid://10734975024",
				["lucide-switch-camera"] = "rbxassetid://10734975214",
				["lucide-sword"] = "rbxassetid://10734975486",
				["lucide-swords"] = "rbxassetid://10734975692",
				["lucide-syringe"] = "rbxassetid://10734975932",
				["lucide-table"] = "rbxassetid://10734976230",
				["lucide-table-2"] = "rbxassetid://10734976097",
				["lucide-tablet"] = "rbxassetid://10734976394",
				["lucide-tag"] = "rbxassetid://10734976528",
				["lucide-tags"] = "rbxassetid://10734976739",
				["lucide-target"] = "rbxassetid://10734977012",
				["lucide-tent"] = "rbxassetid://10734981750",
				["lucide-terminal"] = "rbxassetid://10734982144",
				["lucide-terminal-square"] = "rbxassetid://10734981995",
				["lucide-text-cursor"] = "rbxassetid://10734982395",
				["lucide-text-cursor-input"] = "rbxassetid://10734982297",
				["lucide-thermometer"] = "rbxassetid://10734983134",
				["lucide-thermometer-snowflake"] = "rbxassetid://10734982571",
				["lucide-thermometer-sun"] = "rbxassetid://10734982771",
				["lucide-thumbs-down"] = "rbxassetid://10734983359",
				["lucide-thumbs-up"] = "rbxassetid://10734983629",
				["lucide-ticket"] = "rbxassetid://10734983868",
				["lucide-timer"] = "rbxassetid://10734984606",
				["lucide-timer-off"] = "rbxassetid://10734984138",
				["lucide-timer-reset"] = "rbxassetid://10734984355",
				["lucide-toggle-left"] = "rbxassetid://10734984834",
				["lucide-toggle-right"] = "rbxassetid://10734985040",
				["lucide-tornado"] = "rbxassetid://10734985247",
				["lucide-toy-brick"] = "rbxassetid://10747361919",
				["lucide-train"] = "rbxassetid://10747362105",
				["lucide-trash"] = "rbxassetid://10747362393",
				["lucide-trash-2"] = "rbxassetid://10747362241",
				["lucide-tree-deciduous"] = "rbxassetid://10747362534",
				["lucide-tree-pine"] = "rbxassetid://10747362748",
				["lucide-trees"] = "rbxassetid://10747363016",
				["lucide-trending-down"] = "rbxassetid://10747363205",
				["lucide-trending-up"] = "rbxassetid://10747363465",
				["lucide-triangle"] = "rbxassetid://10747363621",
				["lucide-trophy"] = "rbxassetid://10747363809",
				["lucide-truck"] = "rbxassetid://10747364031",
				["lucide-tv"] = "rbxassetid://10747364593",
				["lucide-tv-2"] = "rbxassetid://10747364302",
				["lucide-type"] = "rbxassetid://10747364761",
				["lucide-umbrella"] = "rbxassetid://10747364971",
				["lucide-underline"] = "rbxassetid://10747365191",
				["lucide-undo"] = "rbxassetid://10747365484",
				["lucide-undo-2"] = "rbxassetid://10747365359",
				["lucide-unlink"] = "rbxassetid://10747365771",
				["lucide-unlink-2"] = "rbxassetid://10747397871",
				["lucide-unlock"] = "rbxassetid://10747366027",
				["lucide-upload"] = "rbxassetid://10747366434",
				["lucide-upload-cloud"] = "rbxassetid://10747366266",
				["lucide-usb"] = "rbxassetid://10747366606",
				["lucide-user"] = "rbxassetid://10747373176",
				["lucide-user-check"] = "rbxassetid://10747371901",
				["lucide-user-cog"] = "rbxassetid://10747372167",
				["lucide-user-minus"] = "rbxassetid://10747372346",
				["lucide-user-plus"] = "rbxassetid://10747372702",
				["lucide-user-x"] = "rbxassetid://10747372992",
				["lucide-users"] = "rbxassetid://10747373426",
				["lucide-utensils"] = "rbxassetid://10747373821",
				["lucide-utensils-crossed"] = "rbxassetid://10747373629",
				["lucide-venetian-mask"] = "rbxassetid://10747374003",
				["lucide-verified"] = "rbxassetid://10747374131",
				["lucide-vibrate"] = "rbxassetid://10747374489",
				["lucide-vibrate-off"] = "rbxassetid://10747374269",
				["lucide-video"] = "rbxassetid://10747374938",
				["lucide-video-off"] = "rbxassetid://10747374721",
				["lucide-view"] = "rbxassetid://10747375132",
				["lucide-voicemail"] = "rbxassetid://10747375281",
				["lucide-volume"] = "rbxassetid://10747376008",
				["lucide-volume-1"] = "rbxassetid://10747375450",
				["lucide-volume-2"] = "rbxassetid://10747375679",
				["lucide-volume-x"] = "rbxassetid://10747375880",
				["lucide-wallet"] = "rbxassetid://10747376205",
				["lucide-wand"] = "rbxassetid://10747376565",
				["lucide-wand-2"] = "rbxassetid://10747376349",
				["lucide-watch"] = "rbxassetid://10747376722",
				["lucide-waves"] = "rbxassetid://10747376931",
				["lucide-webcam"] = "rbxassetid://10747381992",
				["lucide-wifi"] = "rbxassetid://10747382504",
				["lucide-wifi-off"] = "rbxassetid://10747382268",
				["lucide-wind"] = "rbxassetid://10747382750",
				["lucide-wrap-text"] = "rbxassetid://10747383065",
				["lucide-wrench"] = "rbxassetid://10747383470",
				["lucide-x"] = "rbxassetid://10747384394",
				["lucide-x-circle"] = "rbxassetid://10747383819",
				["lucide-x-octagon"] = "rbxassetid://10747384037",
				["lucide-x-square"] = "rbxassetid://10747384217",
				["lucide-zoom-in"] = "rbxassetid://10747384552",
				["lucide-zoom-out"] = "rbxassetid://10747384679",
				["lucide-castle"] = "rbxassetid://89680811679779",
				["lucide-dog"] = "rbxassetid://128027287498958",
				["lucide-fish"] = "rbxassetid://131247469041952"
			}
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
		local RunService, Signal, noop, BaseMotor = game:GetService "RunService", requireModule(moduleScript.Parent.Signal), function()
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
		-- Running motors are stepped, in start order, from one RenderStepped
		-- connection that exists only while something is animating. A motor
		-- whose step errors is stopped so it cannot block the others.
		local runningMotors = {}
		local schedulerConnection = nil
		local function stepRunningMotors(deltaTime)
			for _, motor in ipairs(table.clone(runningMotors)) do
				if motor._running then
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
		for _, child in next, moduleScript:GetChildren() do
			local theme = requireModule(child)
			Themes[theme.Name] = theme
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
			Accent = Color3.fromRGB(0, 103, 192),
			AcrylicMain = Color3.fromRGB(245, 245, 245),
			AcrylicBorder = Color3.fromRGB(80, 80, 80),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(240, 240, 240)),
			AcrylicNoise = 0.94,
			TitleBarLine = Color3.fromRGB(100, 100, 100),
			Tab = Color3.fromRGB(60, 60, 60),
			Element = Color3.fromRGB(255, 255, 255),
			ElementBorder = Color3.fromRGB(100, 100, 100),
			InElementBorder = Color3.fromRGB(130, 130, 130),
			ElementTransparency = 0.50,
			ToggleSlider = Color3.fromRGB(60, 60, 60),
			ToggleToggled = Color3.fromRGB(240, 240, 240),
			SliderRail = Color3.fromRGB(60, 60, 60),
			DropdownFrame = Color3.fromRGB(255, 255, 255),
			DropdownHolder = Color3.fromRGB(248, 248, 248),
			DropdownBorder = Color3.fromRGB(100, 100, 100),
			DropdownOption = Color3.fromRGB(60, 60, 60),
			Keybind = Color3.fromRGB(60, 60, 60),
			Input = Color3.fromRGB(60, 60, 60),
			InputFocused = Color3.fromRGB(80, 80, 80),
			InputIndicator = Color3.fromRGB(40, 40, 40),
			Dialog = Color3.fromRGB(255, 255, 255),
			DialogHolder = Color3.fromRGB(248, 248, 248),
			DialogHolderLine = Color3.fromRGB(100, 100, 100),
			DialogButton = Color3.fromRGB(255, 255, 255),
			DialogButtonBorder = Color3.fromRGB(100, 100, 100),
			DialogBorder = Color3.fromRGB(80, 80, 80),
			DialogInput = Color3.fromRGB(252, 252, 252),
			DialogInputLine = Color3.fromRGB(100, 100, 100),
			Text = Color3.fromRGB(10, 10, 10),
			SubText = Color3.fromRGB(60, 60, 60),
			Hover = Color3.fromRGB(40, 40, 40),
			HoverChange = 0.18
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
			AcrylicBorder = Color3.fromRGB(90, 90, 90),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(40, 40, 40), Color3.fromRGB(40, 40, 40)),
			AcrylicNoise = 0.9,
			TitleBarLine = Color3.fromRGB(75, 75, 75),
			Tab = Color3.fromRGB(120, 120, 120),
			Element = Color3.fromRGB(120, 120, 120),
			ElementBorder = Color3.fromRGB(35, 35, 35),
			InElementBorder = Color3.fromRGB(90, 90, 90),
			ElementTransparency = 0.87,
			ToggleSlider = Color3.fromRGB(120, 120, 120),
			ToggleToggled = Color3.fromRGB(0, 0, 0),
			SliderRail = Color3.fromRGB(120, 120, 120),
			DropdownFrame = Color3.fromRGB(160, 160, 160),
			DropdownHolder = Color3.fromRGB(45, 45, 45),
			DropdownBorder = Color3.fromRGB(35, 35, 35),
			DropdownOption = Color3.fromRGB(120, 120, 120),
			Keybind = Color3.fromRGB(120, 120, 120),
			Input = Color3.fromRGB(160, 160, 160),
			InputFocused = Color3.fromRGB(10, 10, 10),
			InputIndicator = Color3.fromRGB(150, 150, 150),
			Dialog = Color3.fromRGB(45, 45, 45),
			DialogHolder = Color3.fromRGB(35, 35, 35),
			DialogHolderLine = Color3.fromRGB(30, 30, 30),
			DialogButton = Color3.fromRGB(45, 45, 45),
			DialogButtonBorder = Color3.fromRGB(80, 80, 80),
			DialogBorder = Color3.fromRGB(70, 70, 70),
			DialogInput = Color3.fromRGB(55, 55, 55),
			DialogInputLine = Color3.fromRGB(160, 160, 160),
			Text = Color3.fromRGB(240, 240, 240),
			SubText = Color3.fromRGB(170, 170, 170),
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
			AcrylicBorder = Color3.fromRGB(60, 60, 60),
			AcrylicGradient = ColorSequence.new(Color3.fromRGB(25, 25, 25), Color3.fromRGB(15, 15, 15)),
			AcrylicNoise = 0.94,
			TitleBarLine = Color3.fromRGB(65, 65, 65),
			Tab = Color3.fromRGB(100, 100, 100),
			Element = Color3.fromRGB(70, 70, 70),
			ElementBorder = Color3.fromRGB(25, 25, 25),
			InElementBorder = Color3.fromRGB(55, 55, 55),
			ElementTransparency = 0.82,
			DropdownFrame = Color3.fromRGB(120, 120, 120),
			DropdownHolder = Color3.fromRGB(35, 35, 35),
			DropdownBorder = Color3.fromRGB(25, 25, 25),
			Dialog = Color3.fromRGB(35, 35, 35),
			DialogHolder = Color3.fromRGB(25, 25, 25),
			DialogHolderLine = Color3.fromRGB(20, 20, 20),
			DialogButton = Color3.fromRGB(35, 35, 35),
			DialogButtonBorder = Color3.fromRGB(55, 55, 55),
			DialogBorder = Color3.fromRGB(50, 50, 50),
			DialogInput = Color3.fromRGB(45, 45, 45),
			DialogInputLine = Color3.fromRGB(120, 120, 120)
		}
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
