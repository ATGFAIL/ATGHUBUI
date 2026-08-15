do
    local a = game:GetService("TweenService")
    local b = game:GetService("ContentProvider")
    local c = game:GetService("CoreGui")
    local d = game:GetService("Lighting")
    local e = game:GetService("RunService")
    local f = game:GetService("Players")
    local g = f.LocalPlayer
    local h = workspace.CurrentCamera
    local i = "rbxassetid://90989180960460"
    local j = true
    local k = "ATG HUB"
    local l = Enum.Font.GothamBold
    local m = 0.35
    local n = 0.8
    local o = 0.35
    local p = 0.82
    local q = 1.12
    local r = 0.6
    local t = 0.9
    local u = 8
    local v = true
    if c:FindFirstChild("CoreSplash") then
        c.CoreSplash:Destroy()
    end
    pcall(
        function()
            b:PreloadAsync({i})
        end
    )
    local function w(x, y, z, A, B)
        local C = TweenInfo.new(z, A or Enum.EasingStyle.Sine, B or Enum.EasingDirection.Out)
        local D = a:Create(x, C, y)
        D:Play()
        return D
    end
    local E = Instance.new("ScreenGui")
    E.Name = "CoreSplash"
    E.IgnoreGuiInset = true
    E.ResetOnSpawn = false
    E.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    E.DisplayOrder = 999999999
    E.Parent = c
    local function F()
        return h and h.ViewportSize or Vector2.new(1280, 720)
    end
    local function G()
        local H = F()
        local I = math.min(H.X, H.Y)
        local J = I / 1080
        local K = math.clamp(r * J, 0.18, 0.72)
        return {imageScale = K, textSize = math.clamp(26 * J, 14, 56)}
    end
    local L = Instance.new("Frame")
    L.Name = "Overlay"
    L.Size = UDim2.fromScale(1, 1)
    L.Position = UDim2.fromScale(0, 0)
    L.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
    L.BackgroundTransparency = 1
    L.BorderSizePixel = 0
    L.ZIndex = 99999999
    L.Parent = E
    local function M(B)
        local N = Instance.new("Frame")
        N.Size = UDim2.fromScale(1, 0.18)
        if B == "top" then
            N.AnchorPoint = Vector2.new(0, 0)
            N.Position = UDim2.fromScale(0, 0)
        elseif B == "bottom" then
            N.AnchorPoint = Vector2.new(0, 1)
            N.Position = UDim2.fromScale(0, 1)
        end
        N.BackgroundTransparency = 1
        N.ZIndex = 99999998
        N.Parent = E
        local O = Instance.new("UIGradient", N)
        O.Transparency = NumberSequence.new {NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 1)}
        return N
    end
    local P = M("top")
    local Q = M("bottom")
    local R
    do
        R = d:FindFirstChild("CoreSplashBlur") or Instance.new("BlurEffect")
        R.Name = "CoreSplashBlur"
        R.Parent = d
        R.Size = 0
        R.Enabled = true
    end
    local S = Instance.new("Frame")
    S.Name = "Center"
    S.AnchorPoint = Vector2.new(0.5, 0.5)
    S.Position = UDim2.fromScale(0.5, 0.5)
    S.Size = UDim2.fromOffset(0, 0)
    S.BackgroundTransparency = 1
    S.ZIndex = 99999999
    S.Parent = E
    local T = Instance.new("ImageLabel")
    T.Name = "Logo"
    T.AnchorPoint = Vector2.new(0.5, 0.5)
    T.Position = UDim2.fromScale(0.5, 0.5)
    T.Size = UDim2.fromScale(0.4, 0.4)
    T.BackgroundTransparency = 1
    T.Image = i
    T.ImageTransparency = 1
    T.ScaleType = Enum.ScaleType.Fit
    T.ZIndex = 99999999
    T.Parent = S
    local U = Instance.new("ImageLabel")
    U.Name = "Rim"
    U.AnchorPoint = Vector2.new(0.5, 0.5)
    U.Position = UDim2.fromScale(0.5, 0.5)
    U.Size = UDim2.fromScale(1, 1)
    U.BackgroundTransparency = 1
    U.Image = i
    U.ImageTransparency = 0.985
    U.ScaleType = Enum.ScaleType.Fit
    U.ZIndex = 99999999
    U.Parent = T
    local V = Instance.new("TextLabel")
    V.Name = "TextShadow"
    V.AnchorPoint = Vector2.new(0.5, 0)
    V.Position = UDim2.new(0.5, 1, 0, 16)
    V.Size = UDim2.new(0.9, 0, 0, 30)
    V.BackgroundTransparency = 1
    V.ZIndex = 99999999
    V.Text = j and k or ""
    V.TextColor3 = Color3.fromRGB(10, 10, 10)
    V.TextTransparency = 0.35
    V.Font = l
    V.TextSize = 18
    V.Parent = S
    local W = Instance.new("TextLabel")
    W.Name = "Text"
    W.AnchorPoint = Vector2.new(0.5, 0)
    W.Position = V.Position
    W.Size = V.Size
    W.BackgroundTransparency = 1
    W.ZIndex = 99999999
    W.Text = j and k or ""
    W.TextColor3 = Color3.fromRGB(255, 255, 255)
    W.TextStrokeTransparency = 0.7
    W.Font = l
    W.TextSize = 18
    W.Parent = S
    local function X()
        local Y = G()
        local Z = Y.imageScale
        T.Size = UDim2.fromScale(Z, Z)
        U.Size = UDim2.fromScale(1, 1)
        local H = F()
        S.Size = UDim2.fromOffset(math.max(400, H.X * Z * 0.95), math.max(300, H.Y * Z * 0.8))
        W.TextSize = Y.textSize
        V.TextSize = Y.textSize
        local _ = T.AbsoluteSize.Y
        local a0 = math.clamp(_ / 2 + Y.textSize * 0.9 + 18, 48, 420)
        W.Position = UDim2.new(0.5, 0, 0.5, a0)
        V.Position = UDim2.new(0.5, 2, 0.5, a0 + 2)
    end
    local a1 = Instance.new("Frame")
    a1.Name = "Shimmer"
    a1.AnchorPoint = Vector2.new(0.5, 0.5)
    a1.Position = UDim2.fromScale(0.5, 0.5)
    a1.Size = UDim2.fromScale(0.95, 0.95)
    a1.BackgroundTransparency = 1
    a1.ZIndex = 99999999
    a1.Parent = T
    local a2 = Instance.new("ImageLabel")
    a2.Size = UDim2.fromScale(1.6, 0.35)
    a2.AnchorPoint = Vector2.new(0.5, 0.5)
    a2.Position = UDim2.fromScale(0.5, 0.5)
    a2.BackgroundTransparency = 1
    a2.ImageTransparency = 1
    a2.Image = i
    a2.ScaleType = Enum.ScaleType.Slice
    a2.SliceCenter = Rect.new(8, 8, 8, 8)
    a2.ZIndex = 99999999
    a2.Parent = a1
    X()
    local ae
    ae =
        h:GetPropertyChangedSignal("ViewportSize"):Connect(
        function()
            X()
        end
    )
    task.spawn(
        function()
            w(L, {BackgroundTransparency = 0.45}, 0.35, Enum.EasingStyle.Quad)
            w(R, {Size = u}, 0.45, Enum.EasingStyle.Quad)
            local Y = G()
            T.Size = UDim2.fromScale(Y.imageScale * p, Y.imageScale * p)
            w(T, {ImageTransparency = 0}, m, Enum.EasingStyle.Sine)
            w(T, {Size = UDim2.fromScale(Y.imageScale * 1.02, Y.imageScale * 1.02)}, m, Enum.EasingStyle.Quart)
            task.spawn(
                function()
                    while T.Parent and T.ImageTransparency == 0 do
                        a2.Rotation = (math.random() - 0.5) * 30
                        a2.ImageTransparency = 0.85
                        w(a2, {ImageTransparency = 1}, 0.7, Enum.EasingStyle.Sine)
                        task.wait(0.12 + math.random() * 0.3)
                    end
                end
            )
            task.wait(m * 0.9)
            local ai =
                w(
                T,
                {Size = UDim2.fromScale(Y.imageScale * 1.06, Y.imageScale * 1.06)},
                0.9,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.InOut
            )
            ai.Completed:Connect(
                function()
                    if T and T.Parent then
                        w(
                            T,
                            {Size = UDim2.fromScale(Y.imageScale * 1.02, Y.imageScale * 1.02)},
                            0.9,
                            Enum.EasingStyle.Quad,
                            Enum.EasingDirection.InOut
                        )
                    end
                end
            )
            task.wait(m + n)
            w(L, {BackgroundTransparency = 1}, o, Enum.EasingStyle.Quad)
            w(R, {Size = 0}, o, Enum.EasingStyle.Quad)
            w(
                T,
                {ImageTransparency = 1, Size = UDim2.fromScale(Y.imageScale * q, Y.imageScale * q)},
                o,
                Enum.EasingStyle.Quad
            )
            w(W, {TextTransparency = 1}, o * 0.9, Enum.EasingStyle.Quad)
            w(V, {TextTransparency = 1}, o * 0.9, Enum.EasingStyle.Quad)
            task.wait(o + 0.05)
            if v then
                if ae then
                    ae:Disconnect()
                end
                pcall(
                    function()
                        E:Destroy()
                        if R and R.Parent then
                            R:Destroy()
                        end
                    end
                )
            else
                E.Parent = E.Parent
            end
        end
    )
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

    local function isTextObject(object)
        local ok, result = pcall(function()
            return object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")
        end)
        return ok and result
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

        local host = (url:match("^https://([^/%?#:]+)") or ""):lower()
        if host == "" or host == "localhost" or host:match("^127%.") or host:match("^10%.")
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
        MachineRequestLimit = 80,
        MachineRequests = 0,
        RobloxCache = {},
        RobloxCacheOrder = {},
        RobloxPending = {},
        RobloxTranslators = {},
        RobloxTranslatorPending = {},
        CurrentLocale = "en",
        SourceLocale = "en",
        Mode = "auto",
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
        if changed then
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
        for index = #self.PackOrder, 1, -1 do
            local pack = self.Packs[self.PackOrder[index]]
            if pack and (normalizeLocale(pack.Locale) == requested or localeBase(pack.Locale) == requestedBase) then
                local translated = pack.Translations[entry.Key] or pack.Translations[entry.OriginalText]
                if type(translated) == "string" and translated ~= "" then
                    return translated, pack
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
            -- installed (for example th-TH, ja-JP, id-ID).
            if normalized:match("^[a-z][a-z][a-z]?(-[a-z0-9]+)*$") then
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
        -- that is no longer current.
        self.MachineRequests = 0
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
            mode = "auto"
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
        FontManager:ApplyAll()
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
            Skip = options.Skip == true
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
            FontRole = properties.FontRole
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

    function I18n:DrainMachineQueue()
        while self.MachineActive < self.MachineMaxConcurrent and #self.MachineQueue > 0 do
            local job = table.remove(self.MachineQueue, 1)
            self.MachineActive = self.MachineActive + 1
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

    function I18n:TryMachine(entry, revision, callback)
        local endpoint = TranslationSystem.API_URL
        if type(Capabilities.Request) ~= "function" or type(endpoint) ~= "string" or endpoint == "" then
            callback(nil)
            return
        end

        local cacheKey = self.SourceLocale .. "|" .. self.CurrentLocale .. "|" .. entry.OriginalText
        if self.MachineCache[cacheKey] then
            callback(self.MachineCache[cacheKey])
            return
        end

        local waiting = self.MachinePending[cacheKey]
        if waiting then
            table.insert(waiting, callback)
            return
        end
        if self.MachineRequests >= self.MachineRequestLimit then
            callback(nil)
            return
        end

        self.MachineRequests = self.MachineRequests + 1
        self.MachinePending[cacheKey] = {callback}
        table.insert(self.MachineQueue, {
            Key = cacheKey,
            Text = entry.OriginalText,
            SourceLocale = self.SourceLocale,
            TargetLocale = self.CurrentLocale,
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
            setEntryText(entry, manual, revision)
            return
        end

        setEntryText(entry, source, revision)
        if self.Mode == "community" then
            return
        end

        local tryMachine = self.Mode == "machine" or self.Mode == "auto"
        local tryRoblox = self.Mode == "roblox" or self.Mode == "auto"
        local function afterRoblox(translated)
            if revision ~= self.Revision then
                return
            end
            if translated then
                setEntryText(entry, translated, revision)
            elseif tryMachine then
                self:TryMachine(entry, revision, function(machineTranslated)
                    if machineTranslated then
                        setEntryText(entry, machineTranslated, revision)
                    end
                end)
            end
        end

        if tryRoblox then
            self:TryRoblox(entry, revision, afterRoblox)
        elseif tryMachine then
            self:TryMachine(entry, revision, function(machineTranslated)
                if machineTranslated then
                    setEntryText(entry, machineTranslated, revision)
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
        local manual = self:GetManualTranslation(entry, targetLocale)
        if manual then
            if callback then
                callback(manual)
            end
            return manual
        end

        local endpoint = TranslationSystem.API_URL
        local cacheKey = self.SourceLocale .. "|" .. targetLocale .. "|" .. sourceText
        if self.MachineCache[cacheKey] then
            if callback then
                callback(self.MachineCache[cacheKey])
            end
            return self.MachineCache[cacheKey]
        end
        if type(Capabilities.Request) ~= "function" or type(endpoint) ~= "string" or endpoint == "" then
            if callback then
                callback(sourceText)
            end
            return sourceText
        end

        task.spawn(function()
            local translated
            local body = jsonEncode({
                q = sourceText,
                source = self.SourceLocale,
                target = targetLocale
            })
            if body then
                local ok, response = pcall(Capabilities.Request, {
                    Url = endpoint:gsub("/$", "") .. "/translate",
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
                if decoded and type(decoded.translatedText) == "string" and decoded.translatedText ~= "" then
                    translated = decoded.translatedText
                    cacheTranslation(self, "MachineCache", "MachineCacheOrder", cacheKey, translated)
                end
            end
            if callback then
                callback(translated or sourceText)
            end
        end)
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
            end)
            pcall(function()
                originalTextSize = textObject.TextSize
            end)
            pcall(function()
                originalLineHeight = textObject.LineHeight
            end)
            pcall(function()
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

local a, b = {
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
							{46, "ModuleScript", {"isMotor.spec"}},
							{39, "ModuleScript", {"Signal"}},
							{40, "ModuleScript", {"Signal.spec"}},
							{45, "ModuleScript", {"isMotor"}},
							{36, "ModuleScript", {"Instant.spec"}},
							{44, "ModuleScript", {"Spring.spec"}},
							{42, "ModuleScript", {"SingleMotor.spec"}},
							{38, "ModuleScript", {"Linear.spec"}},
							{31, "ModuleScript", {"BaseMotor"}},
							{43, "ModuleScript", {"Spring"}},
							{35, "ModuleScript", {"Instant"}},
							{37, "ModuleScript", {"Linear"}},
							{41, "ModuleScript", {"SingleMotor"}},
							{34, "ModuleScript", {"GroupMotor.spec"}},
							{32, "ModuleScript", {"BaseMotor.spec"}}
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
local aa = {
	function()
		local c, d, e, f, g = b(1)
		local h, i, j, k, l, m =
			game:GetService "Lighting",
		game:GetService "RunService",
		game:GetService "Players".LocalPlayer,
		game:GetService "UserInputService",
		game:GetService "TweenService",
		game:GetService "Workspace".CurrentCamera
		local n, o = j:GetMouse(), d
		local p, q, r, s = e(o.Creator), e(o.Elements), e(o.Acrylic), o.Components
		local t, u, v = e(s.Notification), p.New, protectgui or (syn and syn.protect_gui) or function()
		end
		local w = u("ScreenGui", {Parent = i:IsStudio() and j.PlayerGui or game:GetService "CoreGui"})
		v(w)
		t:Init(w)
		local x = {
			Version = "1.6.0",
			OpenFrames = {},
			Options = {},
			Themes = e(o.Themes).Names,
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
			GUI = w,
			-- Compatibility facade plus the modern customization APIs.
			Translation = TranslationSystem,
			I18n = CustomizationSystem.I18n,
			Fonts = CustomizationSystem.Fonts,
			RemoteAssets = CustomizationSystem.RemoteAssets,
			Capabilities = CustomizationSystem.Capabilities,
			Customization = CustomizationSystem,
			CurrentLanguage = "en"
		}
		function x.SafeCallback(y, z, ...)
			if not z then
				return
			end
			local A, B = pcall(z, ...)
			if not A then
				local C, D = B:find ":%d+: "
				if not D then
					return x:Notify {Title = "Interface", Content = "Callback error", SubContent = B, Duration = 5}
				end
				return x:Notify {
					Title = "Interface",
					Content = "Callback error",
					SubContent = B:sub(D + 1),
					Duration = 5
				}
			end
		end
		function x.Round(y, z, A)
			if A == 0 then
				return math.floor(z)
			end
			z = tostring(z)
			return z:find "%." and tonumber(z:sub(1, z:find "%." + A)) or z
		end
		local y = e(o.Icons).assets
		function x.GetIcon(z, A)
			if A ~= nil and y["lucide-" .. A] then
				return y["lucide-" .. A]
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
			Library = x,
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
		x.Workspace = Workspace

		local function workspaceSafeSegment(A, B)
			A = tostring(A or B or "shared")
			A = A:gsub("[^%w%-%._]", "_"):gsub("_+", "_"):sub(1, 80)
			if A == "" or A == "." or A == ".." then
				return B or "shared"
			end
			return A
		end
		local function workspaceTrim(A)
			return type(A) == "string" and (A:match("^%s*(.-)%s*$") or "") or ""
		end
		local function workspaceIndex(A, B)
			for C, D in ipairs(A or {}) do
				if D == B then
					return C
				end
				end
			return nil
		end
		local function workspacePush(A, B, C)
			local D = workspaceIndex(A, B)
			if D then
				table.remove(A, D)
			end
			table.insert(A, 1, B)
			while #A > (C or 12) do
				table.remove(A)
			end
		end
		local function workspaceCopy(A)
			if type(A) ~= "table" then
				return A
			end
			local B = {}
			for C, D in pairs(A) do
				B[C] = workspaceCopy(D)
			end
			return B
		end
		local function workspaceEncodeValue(A)
			local B = typeof(A)
			if B == "Color3" then
				return {__atg = "Color3", R = A.R, G = A.G, B = A.B}
			end
			if B == "EnumItem" then
				local C, D, E = pcall(function()
					return A.EnumType.Name, A.Name
				end)
				if C then
					return {__atg = "Enum", Type = D, Name = E}
				end
				return tostring(A)
			end
			if type(A) == "table" then
				local C = {}
				for D, E in pairs(A) do
					C[D] = workspaceEncodeValue(E)
				end
				return C
			end
			if type(A) == "string" or type(A) == "number" or type(A) == "boolean" then
				return A
			end
			return nil
		end
		local function workspaceDecodeValue(A)
			if type(A) ~= "table" then
				return A
			end
			if A.__atg == "Color3" then
				return Color3.new(tonumber(A.R) or 1, tonumber(A.G) or 1, tonumber(A.B) or 1)
			end
			if A.__atg == "Enum" and type(A.Type) == "string" and type(A.Name) == "string" then
				local B = Enum[A.Type]
				return B and B[A.Name] or A.Name
			end
			local B = {}
			for C, D in pairs(A) do
				if C ~= "__atg" then
					B[C] = workspaceDecodeValue(D)
				end
			end
			return B
		end

		function Workspace:Connect(A, B)
			local C = A:Connect(B)
			table.insert(self.Connections, C)
			return C
		end
		-- Connections owned by a transient search/profile row are released when
		-- that row is destroyed.  Do not retain them in the workspace registry.
		function Workspace:Bind(A, B)
			return A:Connect(B)
		end
		function Workspace:GetStorage()
			local A = x.Customization and x.Customization.Storage
			return type(A) == "table" and A or nil
		end
		function Workspace:GetPath()
			local A = self:GetStorage()
			local B = A and A.Root or "FluentSettings"
			return tostring(B) .. "/productivity/" .. workspaceSafeSegment(self.Scope, "shared") .. "/workspace.json"
		end
		function Workspace:SaveSoon()
			self.SaveRevision = (self.SaveRevision or 0) + 1
			local revision = self.SaveRevision
			if self.SaveScheduled then
				return
			end
			self.SaveScheduled = true
			local A = self.Scope
			local B = self.State
			task.delay(0.35, function()
				self.SaveScheduled = false
				if revision ~= self.SaveRevision then
					self:SaveSoon()
					return
				end
				if self.Scope ~= A or self.State ~= B then
					return
				end
				local C = self:GetStorage()
				if not C or type(C.CanUseFiles) ~= "function" or not C:CanUseFiles() then
					return
				end
				local D, E = pcall(WorkspaceHttpService.JSONEncode, WorkspaceHttpService, self.State)
				if D then
					pcall(C.Write, C, self:GetPath(), E)
				end
			end)
		end
		function Workspace:Load()
			local A = self:GetStorage()
			if not A or type(A.CanUseFiles) ~= "function" or not A:CanUseFiles() then
				return false
			end
			local B, C = A:Read(self:GetPath())
			if type(B) ~= "string" then
				return false, C
			end
			local D, E = pcall(WorkspaceHttpService.JSONDecode, WorkspaceHttpService, B)
			if not D or type(E) ~= "table" then
				return false, "Workspace file is not valid JSON."
			end
			local F = self.State
			for G, H in pairs(F) do
				if type(E[G]) == type(H) then
					F[G] = E[G]
				end
			end
			if type(F.SmartConfirm) ~= "boolean" then
				F.SmartConfirm = true
			end
			-- Focus is intentionally session-only.  Restoring it at startup can
			-- make every tab except the first one look as if it vanished.
			F.FocusMode = false
			return true
		end
		function Workspace:Configure(A)
			A = type(A) == "table" and A or {}
			local B = workspaceSafeSegment(A.ScriptId or (x.I18n and x.I18n.Scope) or self.Scope, "shared")
			if B ~= self.Scope then
				self.Scope = B
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
		function Workspace:IsFavorite(A)
			return workspaceIndex(self.State.Favorites, A) ~= nil
		end
		function Workspace:ToggleFavorite(A)
			if type(A) ~= "string" then
				return
			end
			local B = workspaceIndex(self.State.Favorites, A)
			if B then
				table.remove(self.State.Favorites, B)
			else
				workspacePush(self.State.Favorites, A, 24)
			end
			self:SaveSoon()
			self:RefreshSurface()
		end
		function Workspace:TouchEntry(A)
			local B = type(A) == "table" and A.Id or A
			if type(B) == "string" then
				workspacePush(self.State.Recent, B, 12)
				self:SaveSoon()
			end
		end
		function Workspace:TouchTab(A)
			if type(A) ~= "table" then
				return
			end
			self:TouchEntry(A.Id)
			self:ApplyModes()
		end
		function Workspace:RegisterTab(A, B)
			if type(A) ~= "table" or not A.Frame or self.TabById[A.Id] then
				return A
			end
			A.OriginalName = A.OriginalName or A.Name
			A.OriginalLabelText = A.Label and A.Label.Text or A.Name
			self.TabById[A.Id] = A
			table.insert(self.Tabs, A)
			self:Connect(A.Frame.InputBegan, function(C)
				if self.ArrangeMode and (C.UserInputType == Enum.UserInputType.MouseButton1 or C.UserInputType == Enum.UserInputType.Touch) then
					self.Drag = {Tab = A, Start = C.Position, Input = C, Moved = false}
				end
			end)
			self:ApplyTabOrder()
			self:ApplyModes()
			return A
		end
		function Workspace:RegisterElement(A, B, C, D, E)
			if type(A) ~= "table" then
				return nil
			end
			C = type(C) == "table" and C or {}
			local F = type(E) == "string" and E or C.Id or C.Title or D or "element"
			local G = "option:" .. workspaceSafeSegment(F, "element")
			if self.EntryById[G] then
				G = G .. "-" .. tostring(#self.Entries + 1)
			end
			local H = {
				Id = G,
				Title = tostring(C.Title or A.Title or F),
				Description = tostring(C.Description or ""),
				Type = tostring(D or A.Type or "Control"),
				Object = A,
				Frame = A.Frame or A.Root,
				Tab = B and B.Tab or nil,
				TabTitle = B and B.TabTitle or ""
			}
			self.EntryById[H.Id] = H
			table.insert(self.Entries, H)
			if type(A.SetValue) == "function" and not A._ATGWorkspaceValueWrapped then
				A._ATGWorkspaceValueWrapped = true
				local I = A.SetValue
				A.SetValue = function(J, ...)
					local K = {I(J, ...)}
					self:TouchEntry(H)
					return unpack(K)
				end
			end
			return H
		end
		function Workspace:ApplyTabOrder()
			if #self.Tabs == 0 then
				return
			end
			local A, B = {}, {}
			for _, C in ipairs(self.State.TabOrder or {}) do
				local D = self.TabById[C]
				if D then
					table.insert(A, D)
					B[D.Id] = true
				end
			end
			for _, C in ipairs(self.Tabs) do
				if not B[C.Id] then
					table.insert(A, C)
				end
			end
			self.State.TabOrder = {}
			for C, D in ipairs(A) do
				D.Frame.LayoutOrder = C * 10
				table.insert(self.State.TabOrder, D.Id)
			end
		end
		function Workspace:MoveTabTo(A, B)
			local C = {}
			for _, D in ipairs(self.Tabs) do
				table.insert(C, D)
			end
			table.sort(C, function(D, E)
				return D.Frame.LayoutOrder < E.Frame.LayoutOrder
			end)
			local D = workspaceIndex(C, A)
			local E = workspaceIndex(C, B)
			if not D or not E or D == E then
				return
			end
			table.remove(C, D)
			table.insert(C, E, A)
			self.State.TabOrder = {}
			for F, G in ipairs(C) do
				G.Frame.LayoutOrder = F * 10
				table.insert(self.State.TabOrder, G.Id)
			end
			self:SaveSoon()
		end
		function Workspace:MoveDraggingTab(A)
			if not self.Drag or not self.Drag.Tab then
				return
			end
			local B, C = self.Drag.Tab, nil
			for _, D in ipairs(self.Tabs) do
				if D ~= B and D.Frame.Visible and A < D.Frame.AbsolutePosition.Y + D.Frame.AbsoluteSize.Y * 0.5 then
					C = D
					break
				end
			end
			if not C then
				for D = #self.Tabs, 1, -1 do
					if self.Tabs[D] ~= B and self.Tabs[D].Frame.Visible then
						C = self.Tabs[D]
						break
					end
				end
			end
			if C then
				self:MoveTabTo(B, C)
			end
		end
		function Workspace:ApplyModes()
			local A = self.State.CompactMode == true
			local B = self.State.FocusMode == true
			for _, C in ipairs(self.Tabs) do
				if C.Frame then
					C.Frame.Visible = not B or C.Selected
				end
				if C.Label then
					if A and C.IconObject and C.IconObject.Image ~= "" then
						C.Label.Visible = false
					elseif A then
						C.Label.Visible = true
						C.Label.Text = tostring(C.OriginalLabelText or C.Name):sub(1, 1)
						C.Label.Position = UDim2.new(0, 0, 0.5, 0)
						C.Label.Size = UDim2.new(1, 0, 1, 0)
						C.Label.TextXAlignment = Enum.TextXAlignment.Center
					else
						C.Label.Visible = true
						C.Label.Text = C.OriginalLabelText or C.Name
						C.Label.Position = C.IconObject and C.IconObject.Image ~= "" and UDim2.new(0, 30, 0.5, 0) or UDim2.new(0, 12, 0.5, 0)
						C.Label.Size = UDim2.new(1, -12, 1, 0)
						C.Label.TextXAlignment = Enum.TextXAlignment.Left
					end
				end
				if A and C.IconObject and C.IconObject.Image ~= "" then
					C.IconObject.Position = UDim2.new(0.5, -8, 0.5, 0)
				elseif C.IconObject then
					C.IconObject.Position = UDim2.new(0, 8, 0.5, 0)
				end
			end
		end
		function Workspace:SetCompact(A)
			A = A == true
			self.State.CompactMode = A
			if self.Window and type(self.Window.SetTabWidth) == "function" then
				self.Window:SetTabWidth(A and 54 or self.OriginalTabWidth)
			end
			if self.Sidebar then
				self.Sidebar.Size = UDim2.new(0, A and 54 or self.OriginalTabWidth, 0, A and 0 or 26)
				self.SidebarSearch.Visible = not A
			end
			if self.Window and self.Window.TabArea then
				self.Window.TabArea.Position = UDim2.new(0, 12, 0, A and 54 or 88)
				self.Window.TabArea.Size = UDim2.new(0, A and 54 or self.OriginalTabWidth, 1, A and -66 or -100)
			end
			if self.Panel then
				self.Panel.Size = UDim2.new(0, A and 230 or self.OriginalTabWidth, 0, 260)
			end
			self:ApplyModes()
			self:SaveSoon()
		end
		function Workspace:UpdateSearchHint()
			if self.SidebarSearch then
				self.SidebarSearch.PlaceholderText = self.State.FocusMode and "Focus mode on  •  Ctrl+K to exit" or "Search...  Ctrl+K"
			end
		end
		function Workspace:SetFocus(A)
			A = A == true
			if A then
				local B = false
				for _, C in ipairs(self.Tabs) do
					B = B or C.Selected
				end
				if not B and self.Tabs[1] and type(self.Tabs[1].Select) == "function" then
					self.Tabs[1]:Select()
				end
			end
			self.State.FocusMode = A
			self:ApplyModes()
			self:UpdateSearchHint()
			self:SaveSoon()
		end
		function Workspace:SetArrangeMode(A)
			self.ArrangeMode = A == true
			for _, B in ipairs(self.Tabs) do
				if B.Frame then
					B.Frame.Active = self.ArrangeMode
					B.Frame.BackgroundTransparency = self.ArrangeMode and 0.94 or (B.Selected and 0.89 or 1)
				end
			end
			if x.Window then
				x:Notify {
					Title = "Tabs",
					Content = self.ArrangeMode and "Drag tabs to rearrange. Click Arrange again when done." or "Tab order saved.",
					Duration = 3
				}
			end
		end
		function Workspace:Navigate(A)
			if type(A) ~= "table" then
				return
			end
			if A.Tab and type(A.Tab.Select) == "function" then
				A.Tab:Select()
			end
			self:TouchEntry(A)
			if A.Frame and A.Tab and A.Tab.ScrollFrame then
				task.delay(0.18, function()
					if not A.Frame.Parent or not A.Tab.ScrollFrame.Parent then
						return
					end
					local B = A.Tab.ScrollFrame
					local C = math.max(0, A.Frame.AbsolutePosition.Y - B.AbsolutePosition.Y + B.CanvasPosition.Y - 12)
					B.CanvasPosition = Vector2.new(0, C)
					local D = Instance.new("UIStroke")
					D.Name = "ATGWorkspaceHighlight"
					D.Color = Color3.fromRGB(255, 82, 96)
					D.Thickness = 1.5
					D.Transparency = 1
					D.Parent = A.Frame
					l:Create(D, TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Transparency = 0.1}):Play()
					task.delay(0.85, function()
						if D.Parent then
							local E = l:Create(D, TweenInfo.new(0.22), {Transparency = 1})
							E:Play()
							E.Completed:Connect(function()
								if D.Parent then D:Destroy() end
							end)
						end
					end)
				end)
			end
		end
		function Workspace:FindEntries(A)
			A = workspaceTrim(A):lower()
			local B = {}
			if A == "" then
				for _, C in ipairs(self.State.Recent) do
					local D = self.EntryById[C] or self.TabById[C]
					if D then
						if D.Type == "Tab" then
							table.insert(B, {Id = D.Id, Title = D.Name, Description = "Tab", Type = "Tab", Tab = D})
						else
							table.insert(B, D)
						end
					end
				end
				return B
			end
			for _, C in ipairs(self.Entries) do
				-- Controls created by older scripts do not always provide every
				-- display field. Search is optional UI, so normalize missing data
				-- instead of letting it interrupt the main UI creation flow.
				if type(C) == "table" then
					local D = (tostring(C.Title or "") .. " " .. tostring(C.Description or "") .. " " .. tostring(C.TabTitle or "") .. " " .. tostring(C.Type or "")):lower()
					if D:find(A, 1, true) then
						table.insert(B, C)
					end
				end
			end
			for _, C in ipairs(self.Tabs) do
				local D = type(C) == "table" and tostring(C.Name or "") or ""
				if D:lower():find(A, 1, true) then
					table.insert(B, {Id = C.Id, Title = D, Description = "Tab", Type = "Tab", Tab = C})
				end
			end
			return B
		end
		function Workspace:RecordNotification(A)
			if type(A) ~= "table" then
				return
			end
			table.insert(self.Notifications, 1, {
				Title = tostring(A.Title or "Notification"),
				Content = tostring(A.Content or A.SubContent or ""),
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
			local A = {}
			for B, C in pairs(x.Options) do
				if type(C) == "table" and C.Type and C.Value ~= nil then
					A[B] = {
						Type = C.Type,
						Value = workspaceEncodeValue(C.Value),
						Transparency = C.Transparency
					}
				end
			end
			return A
		end
		function Workspace:SaveProfile(A)
			A = workspaceTrim(A):sub(1, 36)
			if A == "" then
				return false, "Enter a profile name first."
			end
			self.State.Profiles[A] = self:CaptureProfile()
			workspacePush(self.State.RecentProfiles, A, 5)
			self:SaveSoon()
			return true
		end
		function Workspace:ApplyProfile(A)
			local B = self.State.Profiles[A]
			if type(B) ~= "table" then
				return false, "Profile was not found."
			end
			for C, D in pairs(B) do
				local E = x.Options[C]
				if type(E) == "table" then
					local F = workspaceDecodeValue(D.Value)
					pcall(function()
						if D.Type == "Colorpicker" and type(E.SetValueRGB) == "function" and typeof(F) == "Color3" then
							E:SetValueRGB(F, D.Transparency)
						elseif type(E.SetValue) == "function" then
							E:SetValue(F)
						end
					end)
				end
			end
			workspacePush(self.State.RecentProfiles, A, 5)
			self:SaveSoon()
			return true
		end
		function Workspace:Confirm(A, B, ...)
			local C, D = { ... }, select("#", ...)
			if self.State.SmartConfirm == false or not self.Window or type(self.Window.Dialog) ~= "function" then
				return x:SafeCallback(B, unpack(C, 1, D))
			end
			local E = type(A) == "table" and A or {}
			self.Window:Dialog {
				Title = tostring(E.Title or "Please confirm"),
				Content = tostring(E.Content or (type(A) == "string" and A or "This action cannot be undone.")),
				Buttons = {
					{Title = tostring(E.ConfirmText or "Continue"), Callback = function() x:SafeCallback(B, unpack(C, 1, D)) end},
					{Title = tostring(E.CancelText or "Cancel")}
				}
			}
		end
		function Workspace:Text(A, B, C, D)
			D = D or {}
			local E = D.ZIndex or ((A and A.ZIndex or 0) + 1)
			return u("TextLabel", {
				Name = D.Name or "ATGWorkspaceText",
				Parent = A,
				BackgroundTransparency = 1,
				Text = tostring(B or ""),
				I18nSkip = true,
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", D.Weight or Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				TextColor3 = D.Color or Color3.fromRGB(239, 239, 244),
				TextTransparency = D.Transparency or 0,
				TextSize = C or 12,
				TextXAlignment = D.Align or Enum.TextXAlignment.Left,
				TextYAlignment = D.VerticalAlign or Enum.TextYAlignment.Center,
				TextTruncate = D.Truncate or Enum.TextTruncate.AtEnd,
				TextWrapped = D.Wrapped == true,
				Size = D.Size or UDim2.fromScale(1, 1),
				Position = D.Position or UDim2.fromScale(0, 0),
				ZIndex = E
			})
		end
		function Workspace:Button(A, B, C, D, E)
			local F = E and E.ZIndex or ((A and A.ZIndex or 0) + 1)
			local G = u("TextButton", {
				Name = "ATGWorkspaceButton",
				Parent = A,
				Size = E and E.Size or UDim2.new(1, 0, 0, E and E.Height or 34),
				Position = E and E.Position or UDim2.new(),
				BackgroundColor3 = E and E.Background or Color3.fromRGB(31, 31, 39),
				BackgroundTransparency = E and E.BackgroundTransparency or 0.08,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Text = "",
				ZIndex = F
			})
			u("UICorner", {CornerRadius = UDim.new(0, 7), Parent = G})
			u("UIStroke", {
				Color = E and E.StrokeColor or Color3.fromRGB(89, 89, 105),
				Transparency = E and E.StrokeTransparency or 0.62,
				Thickness = 1,
				Parent = G
			})
			if C then
				u("ImageLabel", {
					Name = "Icon",
					Parent = G,
					BackgroundTransparency = 1,
					Image = x.GetIcon(C) or C,
					ImageColor3 = E and E.IconColor or Color3.fromRGB(215, 215, 222),
					Size = UDim2.fromOffset(14, 14),
					Position = UDim2.new(0, 9, 0.5, -7),
					ZIndex = F + 1
				})
			end
			self:Text(G, B, E and E.TextSize or 12, {
				Name = "Title",
				Weight = E and E.Weight or Enum.FontWeight.Medium,
				Size = UDim2.new(1, C and -34 or -16, 1, 0),
				Position = UDim2.new(0, C and 30 or 8, 0, 0),
				ZIndex = F + 1
			})
			self:Bind(G.MouseEnter, function()
				l:Create(G, TweenInfo.new(0.14, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
			end)
			self:Bind(G.MouseLeave, function()
				l:Create(G, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = E and E.BackgroundTransparency or 0.08}):Play()
			end)
			self:Bind(G.MouseButton1Click, function()
				x:SafeCallback(D)
			end)
			return G
		end
		function Workspace:SquareButton(A, B, C)
			local D = (A and A.ZIndex or 0) + 1
			local E = u("ImageButton", {
				Name = "ATGWorkspaceAction",
				Parent = A,
				Size = UDim2.fromOffset(22, 22),
				BackgroundColor3 = Color3.fromRGB(31, 31, 39),
				BackgroundTransparency = 0.14,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Image = x.GetIcon(B) or B,
				ImageColor3 = Color3.fromRGB(219, 219, 226), ZIndex = D
			})
			u("UICorner", {CornerRadius = UDim.new(0, 6), Parent = E})
			u("UIStroke", {Color = Color3.fromRGB(90, 90, 104), Transparency = 0.75, Parent = E})
			self:Bind(E.MouseEnter, function()
				l:Create(E, TweenInfo.new(0.14, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
					BackgroundTransparency = 0,
					ImageColor3 = Color3.fromRGB(255, 99, 113)
				}):Play()
			end)
			self:Bind(E.MouseLeave, function()
				l:Create(E, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
					BackgroundTransparency = 0.14,
					ImageColor3 = Color3.fromRGB(219, 219, 226)
				}):Play()
			end)
			self:Bind(E.MouseButton1Click, function()
				x:SafeCallback(C)
			end)
			return E
		end
		function Workspace:ClearList(A)
			for _, B in ipairs(A:GetChildren()) do
				B:Destroy()
			end
			local B = u("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = A})
			B:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if A.Parent then
					A.CanvasSize = UDim2.new(0, 0, 0, B.AbsoluteContentSize.Y + 4)
				end
			end)
			return B
		end
		function Workspace:ShowPanel(A)
			if not self.Panel then
				return
			end
			if not A then
				local B = l:Create(self.Panel, TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
					GroupTransparency = 1,
					Position = UDim2.fromOffset(12, 78)
				})
				B:Play()
				B.Completed:Connect(function()
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
			l:Create(self.Panel, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				GroupTransparency = 0,
				Position = UDim2.fromOffset(12, 82)
			}):Play()
		end
		function Workspace:BeginPanel(A, B)
			if not self.Panel then
				return nil
			end
			local C = self.PanelKind ~= A or not self.Panel.Visible
			self.PanelKind = A
			self.PanelTitle.Text = B
			if C then self:ShowPanel(true) end
			self:ClearList(self.PanelContent)
			return self.PanelContent
		end
		function Workspace:RenderEntries(A, B, C)
			B = type(B) == "table" and B or {}
			if #B == 0 then
				self:Text(A, C or "Nothing here yet.", 12, {
					Color = Color3.fromRGB(154, 154, 168),
					Wrapped = true,
					Size = UDim2.new(1, 0, 0, 38)
				})
				return
			end
			for _, D in ipairs(B) do
				if type(D) == "table" then
					local E0 = tostring(D.Title or D.Name or "Untitled")
					local F0 = type(D.TabTitle) == "string" and D.TabTitle or ""
					local G0 = type(D.Description) == "string" and D.Description or ""
					local H0 = type(D.Type) == "string" and D.Type or "Control"
					local I0 = (F0 ~= "" and F0 .. "  /  " or "") .. (G0 ~= "" and G0 or H0)
					local E = self:Button(A, E0, nil, function()
						self:Navigate(D)
						self:ShowPanel(false)
					end, {Height = 42})
				local F = E:FindFirstChild("Title")
				if F then
					F.Size = UDim2.new(1, -42, 0, 18)
					F.Position = UDim2.fromOffset(8, 3)
				end
				local H = E.ZIndex
				self:Text(E, I0, 10, {
					Color = Color3.fromRGB(151, 151, 165),
					Size = UDim2.new(1, -42, 0, 16),
					Position = UDim2.fromOffset(8, 21),
					ZIndex = H + 1
				})
				local G = u("ImageButton", {
					Name = "Favorite",
					Parent = E,
					Size = UDim2.fromOffset(26, 26),
					Position = UDim2.new(1, -31, 0.5, -13),
					BackgroundTransparency = 1,
					AutoButtonColor = false,
					Image = x.GetIcon("star"),
					ImageColor3 = self:IsFavorite(D.Id) and Color3.fromRGB(255, 198, 82) or Color3.fromRGB(150, 150, 165),
					ZIndex = H + 2
				})
				self:Bind(G.MouseButton1Click, function()
					if D.Id then self:ToggleFavorite(D.Id) end
					if self.PanelKind == "favorites" then self:RenderFavorites() else self:RenderSearch(self.SearchQuery or "") end
				end)
				end
			end
		end
		function Workspace:RenderSearch(A)
			A = type(A) == "string" and A or ""
			self.SearchQuery = A
			local B = self:BeginPanel("search", workspaceTrim(A) == "" and "Recent" or "Search results")
			if B then
				self:RenderEntries(B, self:FindEntries(A), workspaceTrim(A) == "" and "Use Ctrl+K to search controls and tabs." or "No matching control.")
			end
		end
		function Workspace:RenderFavorites()
			local A, B = self:BeginPanel("favorites", "Favorites"), {}
			for _, C in ipairs(self.State.Favorites) do
				local D = self.EntryById[C] or self.TabById[C]
				if D then
					if D.Type == "Tab" then
						table.insert(B, {Id = D.Id, Title = D.Name, Description = "Tab", Type = "Tab", Tab = D})
					else
						table.insert(B, D)
					end
				end
			end
			if A then self:RenderEntries(A, B, "Search a control, then use the star to pin it here.") end
		end
		function Workspace:RenderRecent()
			local A = self:BeginPanel("recent", "Recent")
			if A then self:RenderEntries(A, self:FindEntries(""), "Your recent controls appear here.") end
		end
		function Workspace:RenderHistory()
			local A = self:BeginPanel("history", "Notification history")
			if not A then return end
			if #self.Notifications == 0 then
				self:Text(A, "New notifications are saved here for this session.", 12, {
					Color = Color3.fromRGB(154, 154, 168), Wrapped = true, Size = UDim2.new(1, 0, 0, 38)
				})
				return
			end
			for _, B in ipairs(self.Notifications) do
				local C = self:Button(A, B.Title, "history", function() end, {Height = 41})
				local D = C:FindFirstChild("Title")
				if D then D.Size = UDim2.new(1, -38, 0, 18); D.Position = UDim2.fromOffset(30, 3) end
				self:Text(C, B.Content, 10, {
					Color = Color3.fromRGB(151, 151, 165), Size = UDim2.new(1, -38, 0, 16), Position = UDim2.fromOffset(30, 21), ZIndex = C.ZIndex + 1
				})
			end
		end
		function Workspace:RenderProfiles()
			local A = self:BeginPanel("profiles", "Profiles")
			if not A then return end
			local storage = self:GetStorage()
			if not storage or type(storage.CanUseFiles) ~= "function" or not storage:CanUseFiles() then
				self:Text(A, "Session only - this executor cannot save files.", 10, {
					Color = Color3.fromRGB(187, 150, 103), Size = UDim2.new(1, 0, 0, 17)
				})
			end
			local B = u("TextBox", {
				Name = "ProfileName", Parent = A, Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Color3.fromRGB(23, 23, 30),
				BackgroundTransparency = 0.04, BorderSizePixel = 0, ClearTextOnFocus = false, Text = self.ProfileDraft or "", PlaceholderText = "Profile name",
				PlaceholderColor3 = Color3.fromRGB(133, 133, 149), TextColor3 = Color3.fromRGB(239, 239, 244), TextSize = 12,
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal), TextXAlignment = Enum.TextXAlignment.Left, I18nSkip = true, ZIndex = A.ZIndex + 1
			})
			u("UICorner", {CornerRadius = UDim.new(0, 7), Parent = B})
			u("UIPadding", {PaddingLeft = UDim.new(0, 9), PaddingRight = UDim.new(0, 9), Parent = B})
			u("UIStroke", {Color = Color3.fromRGB(89, 89, 105), Transparency = 0.62, Parent = B})
			self:Bind(B.FocusLost, function() self.ProfileDraft = B.Text end)
			self:Button(A, "Save current settings", "bookmark-plus", function()
				self.ProfileDraft = B.Text
				local C, D = self:SaveProfile(B.Text)
				if C then
					x:Notify {Title = "Profiles", Content = "Profile saved.", Duration = 2}
					self:RenderProfiles()
				else
					x:Notify {Title = "Profiles", Content = D, Duration = 3}
				end
			end)
			local C = {}
			for _, D in ipairs(self.State.RecentProfiles) do
				if self.State.Profiles[D] then table.insert(C, D) end
			end
			if #C > 0 then
				self:Text(A, "Recent profiles", 10, {
					Color = Color3.fromRGB(151, 151, 165), Weight = Enum.FontWeight.SemiBold, Size = UDim2.new(1, 0, 0, 18)
				})
				for _, D in ipairs(C) do
					self:Button(A, D, "history", function()
						local E, F = self:ApplyProfile(D)
						x:Notify {Title = "Profiles", Content = E and ("Applied " .. D) or F, Duration = 2}
						self:ShowPanel(false)
					end)
				end
			end
			local D = {}
			for E in pairs(self.State.Profiles) do table.insert(D, E) end
			table.sort(D)
			for _, E in ipairs(D) do
				local F = self:Button(A, E, "bookmark", function()
					local G, H = self:ApplyProfile(E)
					x:Notify {Title = "Profiles", Content = G and ("Applied " .. E) or H, Duration = 2}
					self:ShowPanel(false)
				end)
				local G = u("ImageButton", {
					Parent = F, Size = UDim2.fromOffset(24, 24), Position = UDim2.new(1, -29, 0.5, -12), BackgroundTransparency = 1,
					Image = x.GetIcon("x"), ImageColor3 = Color3.fromRGB(190, 130, 138), AutoButtonColor = false, ZIndex = F.ZIndex + 2
				})
				self:Bind(G.MouseButton1Click, function()
					self:Confirm({Title = "Delete profile", Content = "Remove " .. E .. "?", ConfirmText = "Delete"}, function()
						self.State.Profiles[E] = nil
						self:SaveSoon()
						self:RenderProfiles()
					end)
				end)
			end
		end
		function Workspace:RenderWorkspaceMenu()
			local A = self:BeginPanel("workspace", "Workspace")
			if not A then return end
			self:Button(A, "Compact sidebar: " .. (self.State.CompactMode and "On" or "Off"), "layout", function()
				self:SetCompact(not self.State.CompactMode)
				self:RenderWorkspaceMenu()
			end)
			self:Button(A, "Focus current tab: " .. (self.State.FocusMode and "On" or "Off"), "focus", function()
				self:SetFocus(not self.State.FocusMode)
				self:RenderWorkspaceMenu()
			end)
			self:Button(A, (self.ArrangeMode and "Done arranging tabs" or "Arrange tabs (Beta)"), "grip-vertical", function()
				self:SetArrangeMode(not self.ArrangeMode)
				self:ShowPanel(false)
			end)
			self:Button(A, "Smart confirmations: " .. (self.State.SmartConfirm == false and "Off" or "On"), "shield-check", function()
				self.State.SmartConfirm = not self.State.SmartConfirm
				self:SaveSoon()
				self:RenderWorkspaceMenu()
			end)
			self:Button(A, "Recent controls", "history", function() self:RenderRecent() end)
		end
		function Workspace:RefreshSurface()
			if self.PanelKind == "search" then self:RenderSearch(self.SearchQuery or "")
			elseif self.PanelKind == "favorites" then self:RenderFavorites()
			elseif self.PanelKind == "history" then self:RenderHistory()
			elseif self.PanelKind == "profiles" then self:RenderProfiles()
			elseif self.PanelKind == "workspace" then self:RenderWorkspaceMenu() end
			if self.Palette and self.Palette.Visible then self:RenderPalette(self.PaletteInput.Text) end
		end
		function Workspace:CreatePanel()
			local A = self.Window
			self.Panel = u("CanvasGroup", {
				Name = "ATGWorkspacePanel", Parent = A.Root, Size = UDim2.new(0, self.OriginalTabWidth, 0, 260),
				Position = UDim2.fromOffset(12, 82), BackgroundColor3 = Color3.fromRGB(20, 20, 27),
				BackgroundTransparency = 0.02, BorderSizePixel = 0, Visible = false, GroupTransparency = 1, ZIndex = 35
			})
			u("UICorner", {CornerRadius = UDim.new(0, 9), Parent = self.Panel})
			u("UIStroke", {Color = Color3.fromRGB(124, 52, 62), Transparency = 0.35, Parent = self.Panel})
			self.PanelTitle = self:Text(self.Panel, "Workspace", 13, {
				Weight = Enum.FontWeight.SemiBold, Size = UDim2.new(1, -38, 0, 34), Position = UDim2.fromOffset(10, 0), ZIndex = 36
			})
			local B = u("ImageButton", {
				Name = "Close", Parent = self.Panel, Size = UDim2.fromOffset(22, 22), Position = UDim2.new(1, -27, 0, 6),
				BackgroundTransparency = 1, Image = x.GetIcon("x"), ImageColor3 = Color3.fromRGB(178, 178, 191), AutoButtonColor = false, ZIndex = 37
			})
			self:Connect(B.MouseButton1Click, function() self:ShowPanel(false) end)
			self.PanelContent = u("ScrollingFrame", {
				Name = "Content", Parent = self.Panel, Size = UDim2.new(1, -16, 1, -46), Position = UDim2.fromOffset(8, 38),
				BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(), ScrollBarThickness = 3,
				ScrollBarImageColor3 = Color3.fromRGB(255, 93, 107), ScrollBarImageTransparency = 0.42, ZIndex = 36
			})
		end
		function Workspace:CreateChrome()
			local A = self.Window
			self.Sidebar = u("Frame", {
				Name = "ATGWorkspaceSidebar", Parent = A.Root, Size = UDim2.new(0, self.OriginalTabWidth, 0, 26),
				Position = UDim2.fromOffset(12, 52), BackgroundTransparency = 1, ZIndex = 20
			})
			self.SidebarSearch = u("TextBox", {
				Name = "Search", Parent = self.Sidebar, Size = UDim2.new(1, 0, 0, 26), Position = UDim2.fromOffset(0, 0),
				BackgroundColor3 = Color3.fromRGB(27, 27, 34), BackgroundTransparency = 0.1, BorderSizePixel = 0, ClearTextOnFocus = false,
				Text = "", PlaceholderText = "Search...  Ctrl+K", PlaceholderColor3 = Color3.fromRGB(142, 142, 157), TextColor3 = Color3.fromRGB(240, 240, 244),
				TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal), I18nSkip = true, ZIndex = 21
			})
			u("UICorner", {CornerRadius = UDim.new(0, 7), Parent = self.SidebarSearch})
			u("UIStroke", {Color = Color3.fromRGB(115, 55, 64), Transparency = 0.45, Parent = self.SidebarSearch})
			u("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = self.SidebarSearch})
			self:UpdateSearchHint()
			self:Connect(self.SidebarSearch:GetPropertyChangedSignal("Text"), function()
				local B = self.SidebarSearch.Text
				if workspaceTrim(B) == "" then
					if self.PanelKind == "search" then self:ShowPanel(false) end
				else
					-- Search is an optional enhancement: never let a malformed
					-- third-party control interrupt the script creating its tabs.
					local C, D = pcall(function() self:RenderSearch(B) end)
					if not C then warn("[ATG Workspace] Search error: " .. tostring(D)) end
				end
			end)
			A.TabArea.Position = UDim2.new(0, 12, 0, 88)
			A.TabArea.Size = UDim2.new(0, self.OriginalTabWidth, 1, -100)
			self:CreatePanel()
		end
		function Workspace:RenderPalette(A)
			if not self.PaletteContent then return end
			self:ClearList(self.PaletteContent)
			A = A or ""
			local B = workspaceTrim(A):lower()
			local C = {
				{Title = "Open Favorites", Icon = "star", Match = "favorites favorite star", Action = function() self:ClosePalette(); self:RenderFavorites() end},
				{Title = "Open Profiles", Icon = "bookmark", Match = "profiles profile config", Action = function() self:ClosePalette(); self:RenderProfiles() end},
				{Title = "Notification history", Icon = "history", Match = "history notifications activity", Action = function() self:ClosePalette(); self:RenderHistory() end},
				{Title = "Toggle compact sidebar", Icon = "layout-dashboard", Match = "compact sidebar layout", Action = function() self:SetCompact(not self.State.CompactMode); self:ClosePalette() end},
				{Title = "Toggle focus mode", Icon = "focus", Match = "focus mode", Action = function() self:SetFocus(not self.State.FocusMode); self:ClosePalette() end},
				{Title = self.ArrangeMode and "Finish arranging tabs" or "Arrange tabs (Beta)", Icon = "grip-vertical", Match = "arrange reorder tabs", Action = function() self:SetArrangeMode(not self.ArrangeMode); self:ClosePalette() end}
			}
			for _, D in ipairs(C) do
				if B == "" or D.Title:lower():find(B, 1, true) or D.Match:find(B, 1, true) then
					self:Button(self.PaletteContent, D.Title, D.Icon, D.Action, {Height = 34, ZIndex = 94})
				end
			end
			local D = self:FindEntries(A)
			if #D > 0 then
				self:Text(self.PaletteContent, B == "" and "Recent" or "Results", 10, {
					Color = Color3.fromRGB(150, 150, 164), Weight = Enum.FontWeight.SemiBold, Size = UDim2.new(1, 0, 0, 20), ZIndex = 94
				})
				self:RenderEntries(self.PaletteContent, D, "")
			end
		end
		function Workspace:CreatePalette()
			local A = self.Window.Root
			self.Palette = u("CanvasGroup", {
				Name = "ATGCommandPalette", Parent = A, Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0),
				BackgroundTransparency = 0.36, BorderSizePixel = 0, Visible = false, GroupTransparency = 1, ZIndex = 90
			})
			local B = u("Frame", {
				Name = "Modal", Parent = self.Palette, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 420, 0, 330), Position = UDim2.new(0.5, 0, 0.46, 0),
				BackgroundColor3 = Color3.fromRGB(21, 21, 28), BackgroundTransparency = 0.02, BorderSizePixel = 0, ZIndex = 91
			})
			u("UISizeConstraint", {MinSize = Vector2.new(300, 230), MaxSize = Vector2.new(520, 420), Parent = B})
			u("UICorner", {CornerRadius = UDim.new(0, 10), Parent = B})
			u("UIStroke", {Color = Color3.fromRGB(180, 63, 79), Transparency = 0.25, Thickness = 1, Parent = B})
			self:Text(B, "Quick search", 15, {Weight = Enum.FontWeight.SemiBold, Size = UDim2.new(1, -80, 0, 36), Position = UDim2.fromOffset(14, 4), ZIndex = 92})
			self:Text(B, "Ctrl+K", 10, {Color = Color3.fromRGB(165, 165, 180), Align = Enum.TextXAlignment.Right, Size = UDim2.new(0, 54, 0, 36), Position = UDim2.new(1, -70, 0, 4), ZIndex = 92})
			local C = u("ImageButton", {
				Parent = B, Size = UDim2.fromOffset(20, 20), Position = UDim2.new(1, -28, 0, 12), BackgroundTransparency = 1, Image = x.GetIcon("x"),
				ImageColor3 = Color3.fromRGB(180, 180, 194), AutoButtonColor = false, ZIndex = 93
			})
			self:Connect(C.MouseButton1Click, function() self:ClosePalette() end)
			self.PaletteInput = u("TextBox", {
				Name = "Query", Parent = B, Size = UDim2.new(1, -28, 0, 34), Position = UDim2.fromOffset(14, 42), BackgroundColor3 = Color3.fromRGB(28, 28, 36),
				BackgroundTransparency = 0.03, BorderSizePixel = 0, ClearTextOnFocus = false, Text = "", PlaceholderText = "Search controls, tabs, or commands...",
				PlaceholderColor3 = Color3.fromRGB(143, 143, 158), TextColor3 = Color3.fromRGB(244, 244, 248), TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal), I18nSkip = true, ZIndex = 93
			})
			u("UICorner", {CornerRadius = UDim.new(0, 7), Parent = self.PaletteInput})
			u("UIStroke", {Color = Color3.fromRGB(125, 60, 70), Transparency = 0.4, Parent = self.PaletteInput})
			u("UIPadding", {PaddingLeft = UDim.new(0, 9), PaddingRight = UDim.new(0, 9), Parent = self.PaletteInput})
			self.PaletteContent = u("ScrollingFrame", {
				Name = "Results", Parent = B, Size = UDim2.new(1, -28, 1, -94), Position = UDim2.fromOffset(14, 84), BackgroundTransparency = 1,
				BorderSizePixel = 0, CanvasSize = UDim2.new(), ScrollBarThickness = 3, ScrollBarImageColor3 = Color3.fromRGB(255, 93, 107), ScrollBarImageTransparency = 0.44, ZIndex = 93
			})
			self:Connect(self.PaletteInput:GetPropertyChangedSignal("Text"), function() self:RenderPalette(self.PaletteInput.Text) end)
		end
		function Workspace:OpenPalette()
			if not self.Palette then return end
			self:ShowPanel(false)
			self.Palette.Visible = true
			self.Palette.GroupTransparency = 1
			local A = self.Palette:FindFirstChild("Modal")
			if A then A.Position = UDim2.new(0.5, 0, 0.44, 0) end
			l:Create(self.Palette, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
			if A then l:Create(A, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.46, 0)}):Play() end
			self.PaletteInput.Text = ""
			self:RenderPalette("")
			task.defer(function() if self.PaletteInput and self.PaletteInput.Parent then self.PaletteInput:CaptureFocus() end end)
		end
		function Workspace:ClosePalette()
			if not self.Palette or not self.Palette.Visible then return end
			local A = l:Create(self.Palette, TweenInfo.new(0.14, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {GroupTransparency = 1})
			A:Play()
			A.Completed:Connect(function()
				if self.Palette and self.Palette.GroupTransparency >= 0.99 then self.Palette.Visible = false end
			end)
		end
		function Workspace:Attach(A)
			if self.Window then return self end
			self.Window = A
			self.OriginalTabWidth = tonumber(A.TabWidth) or 180
			self:Load()
			self:CreateChrome()
			self:CreatePalette()
			self:SetCompact(self.State.CompactMode)
			self:SetFocus(self.State.FocusMode)
			self:Connect(k.InputBegan, function(B, C)
				if B.UserInputType ~= Enum.UserInputType.Keyboard then return end
				if B.KeyCode == Enum.KeyCode.Escape and self.Palette and self.Palette.Visible then self:ClosePalette(); return end
				if not C and B.KeyCode == Enum.KeyCode.K and not k:GetFocusedTextBox() and
					(k:IsKeyDown(Enum.KeyCode.LeftControl) or k:IsKeyDown(Enum.KeyCode.RightControl)) then
					self:OpenPalette()
				end
			end)
			self:Connect(k.InputChanged, function(B)
				if not self.Drag or not (B.UserInputType == Enum.UserInputType.MouseMovement or B.UserInputType == Enum.UserInputType.Touch) then return end
				local C = B.Position - self.Drag.Start
				if C.Magnitude > 6 then
					self.Drag.Moved = true
					self:MoveDraggingTab(B.Position.Y)
				end
			end)
			self:Connect(k.InputEnded, function(B)
				if self.Drag and (B.UserInputType == Enum.UserInputType.MouseButton1 or B.UserInputType == Enum.UserInputType.Touch) then
					if self.Drag.Moved and self.Drag.Tab then self.Drag.Tab.SuppressClick = true end
					self.Drag = nil
				end
			end)
			return self
		end
		function Workspace:Destroy()
			for _, A in ipairs(self.Connections) do pcall(function() A:Disconnect() end) end
			self.Connections = {}
			self.Window = nil
			self.Tabs, self.TabById, self.Entries, self.EntryById = {}, {}, {}, {}
			self.Sidebar, self.SidebarSearch, self.SidebarToolbar, self.ToolbarLayout = nil, nil, nil, nil
			self.Panel, self.PanelContent, self.PanelTitle, self.Palette, self.PaletteInput, self.PaletteContent = nil, nil, nil, nil, nil, nil
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
		local function mergeFloatingToggleConfig(A, B)
			local C = {}
			for D, E in pairs(A or {}) do
				if type(E) == "table" then
					C[D] = mergeFloatingToggleConfig(E, type(B) == "table" and B[D] or nil)
				elseif type(B) == "table" and B[D] ~= nil then
					C[D] = B[D]
				else
					C[D] = E
				end
			end
			if type(B) == "table" then
				for D, E in pairs(B) do
					if C[D] == nil then
						C[D] = E
					end
				end
			end
			return C
		end
		local function getFloatingToggleConfig(A)
			local B
			if type(getgenv) == "function" then
				local C, D = pcall(getgenv)
				if C and type(D) == "table" and type(D.ATGButtonUI) == "table" then
					B = D.ATGButtonUI
				end
			end
			local C = mergeFloatingToggleConfig(mergeFloatingToggleConfig(FloatingToggleDefaults, B), A)
			local function keyCodeOrDefault(D, E)
				if typeof(D) == "EnumItem" then
					return D
				end
				if type(D) == "string" and Enum.KeyCode[D] then
					return Enum.KeyCode[D]
				end
				return E
			end
			C.Keybind.Key = keyCodeOrDefault(C.Keybind.Key, FloatingToggleDefaults.Keybind.Key)
			C.Keybind.Modifier = keyCodeOrDefault(C.Keybind.Modifier, FloatingToggleDefaults.Keybind.Modifier)
			return C
		end
		local function floatingToggleSize(A)
			local B = k.TouchEnabled and A.ButtonSize.Min or A.ButtonSize.Max
			return UDim2.fromOffset(tonumber(B) or 42, tonumber(B) or 42)
		end
		local function floatingTogglePosition(A)
			local B, C, D
			if A.Position.Horizontal == "right" then
				B, C, D = 1, -(tonumber(A.Position.OffsetX) or 140), 1
			elseif A.Position.Horizontal == "center" then
				B, C, D = 0.5, 0, 0.5
			else
				B, C, D = 0, tonumber(A.Position.OffsetX) or 140, 0
			end
			local E, F, G
			if A.Position.Vertical == "bottom" then
				E, F, G = 1, -(tonumber(A.Position.OffsetY) or 140), 1
			elseif A.Position.Vertical == "center" then
				E, F, G = 0.5, 0, 0.5
			else
				E, F, G = 0, tonumber(A.Position.OffsetY) or 140, 0
			end
			return UDim2.new(B, C, E, F), Vector2.new(D, G)
		end
		local LegacyFloatingToggleNames = {
			FluentToggleGui = true,
			ATGToggleGui = true,
			ATGFloatingToggleGui = true
		}
		local function isLegacyFloatingToggle(A)
			local B = false
			pcall(function()
				B = A and A:IsA("ScreenGui") and A ~= w and LegacyFloatingToggleNames[A.Name] == true
			end)
			return B
		end
		local function getLegacyFloatingToggleParents()
			local A = {}
			pcall(function()
				table.insert(A, game:GetService("CoreGui"))
			end)
			pcall(function()
				local B = game:GetService("Players").LocalPlayer
				local C = B and B:FindFirstChildOfClass("PlayerGui")
				if C then
					table.insert(A, C)
				end
			end)
			return A
		end
		local function hasLegacyFloatingToggle()
			for _, A in ipairs(getLegacyFloatingToggleParents()) do
				for B in pairs(LegacyFloatingToggleNames) do
					local C = A:FindFirstChild(B)
					if isLegacyFloatingToggle(C) then
						return true
					end
				end
			end
			return false
		end
		function x.CreateFloatingToggle(A, B)
			if x.FloatingToggle then
				x.FloatingToggle:Destroy()
			end
			local C = getFloatingToggleConfig(B)
			local D = C.Enabled ~= false and
				(C.ForceShowButton or not k.KeyboardEnabled or (k.TouchEnabled and not k.KeyboardEnabled) or
					(k.GamepadEnabled and not k.KeyboardEnabled))
			if not D then
				return nil
			end
			if C.RespectExistingToggle ~= false and hasLegacyFloatingToggle() then
				return nil
			end

			local E = Instance.new("ImageButton")
			E.Name = "ATGFloatingToggleButton"
			E.Size = floatingToggleSize(C)
			E.Position, E.AnchorPoint = floatingTogglePosition(C)
			E.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			E.BackgroundTransparency = 0
			E.BorderSizePixel = 0
			E.Image = tostring(C.ImageId or "")
			E.Active = true
			E.AutoButtonColor = true
			E.ZIndex = 1000
			E.Parent = w
			local F = Instance.new("UICorner")
			F.CornerRadius = UDim.new(0, 8)
			F.Parent = E
			local G = Instance.new("UIStroke")
			G.Name = "ATGFloatingToggleStroke"
			G.Thickness = tonumber(C.Stroke.BaseThickness) or 1
			G.Transparency = tonumber(C.Stroke.BaseTransparency) or 0.05
			G.LineJoinMode = Enum.LineJoinMode.Round
			G.ZIndex = 1000
			G.Parent = E

			local dragStateConnection
			local H = {
				Button = E,
				Stroke = G,
				Config = C,
				Connections = {},
				Destroyed = false
			}
			local function I(J)
				table.insert(H.Connections, J)
				return J
			end
			local function J()
				if not E.Parent then
					return
				end
				local K = game:GetService("Workspace").CurrentCamera
				local L = K and K.ViewportSize or Vector2.new(1280, 720)
				local M, N = E.AbsoluteSize.X, E.AbsoluteSize.Y
				if M <= 0 or N <= 0 then
					return
				end
				local O = math.clamp(E.AbsolutePosition.X, 0, math.max(0, L.X - M))
				local P = math.clamp(E.AbsolutePosition.Y, 0, math.max(0, L.Y - N))
				if math.abs(O - E.AbsolutePosition.X) > 0.5 or math.abs(P - E.AbsolutePosition.Y) > 0.5 then
					E.AnchorPoint = Vector2.new(0, 0)
					E.Position = UDim2.fromOffset(O, P)
				end
			end
			function H.Toggle()
				if x.Window and type(x.Window.Minimize) == "function" then
					x.Window:Minimize()
				elseif x.Window and x.Window.Root then
					x.Window.Root.Visible = not x.Window.Root.Visible
				end
			end
			function H.Destroy()
				if H.Destroyed then
					return
				end
				H.Destroyed = true
				if dragStateConnection then
					pcall(function()
						dragStateConnection:Disconnect()
					end)
					dragStateConnection = nil
				end
				for _, K in ipairs(H.Connections) do
					pcall(function()
						K:Disconnect()
					end)
				end
				H.Connections = {}
				if E then
					pcall(function()
						E:Destroy()
					end)
				end
				if x.FloatingToggle == H then
					x.FloatingToggle = nil
				end
			end
			x.FloatingToggle = H
			if C.RespectExistingToggle ~= false then
				for _, K in ipairs(getLegacyFloatingToggleParents()) do
					I(
						K.ChildAdded:Connect(function(L)
							if isLegacyFloatingToggle(L) and not H.Destroyed then
								H:Destroy()
							end
						end)
					)
				end
			end

			local K, L, M, N = false, nil, nil, nil
			I(
				E.InputBegan:Connect(function(O)
					if O.UserInputType == Enum.UserInputType.MouseButton1 or O.UserInputType == Enum.UserInputType.Touch then
						if dragStateConnection then
							pcall(function()
								dragStateConnection:Disconnect()
							end)
							dragStateConnection = nil
						end
						K = true
						L = O.Position
						M = E.Position
						N = false
						dragStateConnection = O.Changed:Connect(function()
							if O.UserInputState == Enum.UserInputState.End then
								K = false
								J()
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
			I(
				k.InputChanged:Connect(function(O)
					if K and (O.UserInputType == Enum.UserInputType.MouseMovement or O.UserInputType == Enum.UserInputType.Touch) and L and M then
						local P = O.Position - L
						if P.Magnitude > 6 then
							N = true
						end
						E.Position = UDim2.new(M.X.Scale, M.X.Offset + P.X, M.Y.Scale, M.Y.Offset + P.Y)
					end
				end)
			)
			I(
				E.Activated:Connect(function()
					if N then
						N = false
						return
					end
					H.Toggle()
				end)
			)
			local O = 0
			I(
				i.RenderStepped:Connect(function(P)
					O = O + P
					if O < 0.05 or not G.Parent then
						return
					end
					O = 0
					local Q = os.clock()
					local R = (Q * (tonumber(C.Stroke.HueSpeed) or 0.09)) % 1
					local S = (math.sin(Q * (tonumber(C.Stroke.PulseSpeed) or 1) * math.pi * 2) + 1) / 2
					G.Color = Color3.fromHSV(R, tonumber(C.Stroke.Saturation) or 0.95, tonumber(C.Stroke.Value) or 1)
					G.Thickness = (tonumber(C.Stroke.BaseThickness) or 1) + S * (tonumber(C.Stroke.PulseThickness) or 1.5)
					G.Transparency =
						(tonumber(C.Stroke.BaseTransparency) or 0.05) + S * (tonumber(C.Stroke.PulseTransparency) or 0.12)
				end)
			)
			local P = game:GetService("Workspace").CurrentCamera
			if P then
				I(
					P:GetPropertyChangedSignal("ViewportSize"):Connect(function()
						E.Size = floatingToggleSize(C)
						J()
					end)
				)
			end
			if C.Keybind.Enabled ~= false and k.KeyboardEnabled then
				local modifierAlreadyToggledWindow = false
				local function modifierMatchesWindowMinimizeKey()
					local activeKey = x.MinimizeKey
					if type(x.MinimizeKeybind) == "table" and x.MinimizeKeybind.Type == "Keybind" then
						activeKey = x.MinimizeKeybind.Value
					end
					if activeKey == C.Keybind.Modifier then
						return true
					end
					local modifierName
					pcall(function()
						modifierName = C.Keybind.Modifier.Name
					end)
					return type(activeKey) == "string" and activeKey == modifierName
				end
				I(
					k.InputBegan:Connect(function(Q, R)
						if not R and Q.UserInputType == Enum.UserInputType.Keyboard then
							if Q.KeyCode == C.Keybind.Modifier then
								-- Fluent's legacy default minimize bind is LeftControl.
								-- It has already toggled the window before Ctrl+M arrives,
								-- so suppress the second toggle from this handler.
								modifierAlreadyToggledWindow = modifierMatchesWindowMinimizeKey() and not k:GetFocusedTextBox()
							elseif Q.KeyCode == C.Keybind.Key and not k:GetFocusedTextBox() and
								k:IsKeyDown(C.Keybind.Modifier) then
								if not modifierAlreadyToggledWindow then
									H.Toggle()
								end
							end
						end
					end)
				)
				I(
					k.InputEnded:Connect(function(Q)
						if Q.UserInputType == Enum.UserInputType.Keyboard and Q.KeyCode == C.Keybind.Modifier then
							modifierAlreadyToggledWindow = false
						end
					end)
				)
			end
			task.defer(J)
			return H
		end
		function x.SetFloatingToggleConfig(A, B)
			if B == false then
				if x.FloatingToggle then
					x.FloatingToggle:Destroy()
				end
				return nil
			end
			return x:CreateFloatingToggle(B)
		end
		local z = {}
		z.__index = z
		z.__namecall = function(A, B, ...)
			return z[B](...)
		end
		for A, B in ipairs(q) do
			z["Add" .. B.__type] = function(C, D, E)
				B.Container = C.Container
				B.Type = C.Type
				B.ScrollFrame = C.ScrollFrame
				B.Library = x
				local F = type(E) == "table" and E or (type(D) == "table" and D or nil)
				-- Smart confirmation can be explicit (Confirm = true/string/table),
				-- or inferred only for obvious destructive labels. Scripts may use
				-- SmartConfirm = false to opt a button out.
				local H = F and F.Confirm
				if B.__type == "Button" and F and H == nil and F.SmartConfirm ~= false then
					local I = tostring(F.Title or ""):lower()
					if I:find("delete", 1, true) or I:find("remove", 1, true) or I:find("reset", 1, true) or
						I:find("clear", 1, true) or I:find("wipe", 1, true) or I:find("shutdown", 1, true) or
						I:find("rejoin", 1, true) or I:find("leave", 1, true) then
						H = {Title = "Please confirm", Content = "Continue with " .. tostring(F.Title) .. "?"}
					end
				end
				if B.__type == "Button" and F and H and type(F.Callback) == "function" and not F._ATGConfirmWrapped then
					F._ATGConfirmWrapped = true
					local G = F.Callback
					F.Callback = function(...)
						return x.Workspace:Confirm(H, G, ...)
					end
				end
				local G = B:New(D, E)
				if x.Workspace then
					x.Workspace:RegisterElement(G, C, F, B.__type, type(D) == "string" and D or nil)
				end
				return G
			end
		end
		x.Elements = z
		function x.CreateWindow(C, D)
			assert(D.Title, "Window - Missing Title")
			if x.Window then
				print "You cannot create more than one window."
				return
			end
			-- Optional and additive: old CreateWindow calls continue to work.
			-- InterfaceManager normally configures this later, but accepting it
			-- here gives standalone scripts an early, flicker-free setup path.
			if type(D.I18n) == "table" or type(D.Customization) == "table" then
				local F = D.I18n or D.Customization
				CustomizationSystem:Configure {
					Folder = F.Folder,
					ScriptId = F.ScriptId,
					SourceLocale = F.SourceLocale,
					Locale = F.Locale,
					Mode = F.Mode,
					Enabled = F.Enabled,
					EnableRemoteAssets = F.EnableRemoteAssets,
					FontProfile = F.FontProfile,
					FontTuning = F.FontTuning
				}
			end
			x.CurrentLanguage = CustomizationSystem.I18n.CurrentLocale
			x.MinimizeKey = D.MinimizeKey
			x.UseAcrylic = D.Acrylic
			if D.Acrylic then
				r.init()
			end
			local E =
				e(s.Window) {Parent = w, Size = D.Size, Title = D.Title, SubTitle = D.SubTitle, TabWidth = D.TabWidth}
			E.Library = x
			x.Window = E
			if x.Workspace then
				x.Workspace:Configure {ScriptId = CustomizationSystem.I18n.Scope}
				x.Workspace:Attach(E)
			end
			x:SetTheme(D.Theme)
			if D.FloatingToggle ~= false then
				local F = type(D.FloatingToggle) == "table" and D.FloatingToggle or nil
				-- Give legacy scripts that append FluentToggleGui after CreateWindow
				-- one scheduler turn to register it before we add our own button.
				task.defer(function()
					task.wait(0.25)
					if not x.Unloaded and x.Window == E and not x.FloatingToggle then
						x:CreateFloatingToggle(F)
					end
				end)
			end
			return E
		end
		function x.SetTheme(C, D)
			if x.Window and table.find(x.Themes, D) then
				x.Theme = D
				p.UpdateTheme()
			end
		end
		function x.Destroy(C)
			if x.Window then
				x.Unloaded = true
				-- Invalidates and detaches any in-flight/queued translation work.
				CustomizationSystem.I18n:CancelPending()
				CustomizationSystem.I18n:ClearRegistry()
				CustomizationSystem.Fonts:ClearRegistry()
				if x.Workspace then
					x.Workspace:Destroy()
				end
				if x.FloatingToggle then
					x.FloatingToggle:Destroy()
				end
				if x.UseAcrylic then
					x.Window.AcrylicPaint.Model:Destroy()
				end
				p.Disconnect()
				x.GUI:Destroy()
			end
		end
		function x.ToggleAcrylic(C, D)
			if x.Window then
				if x.UseAcrylic then
					x.Acrylic = D
					x.Window.AcrylicPaint.Model.Transparency = D and 0.98 or 1
					if D then
						r.Enable()
					else
						r.Disable()
					end
				end
			end
		end
		function x.ToggleTransparency(C, D)
			if x.Window then
				x.Window.AcrylicPaint.Frame.Background.BackgroundTransparency = D and 0.35 or 0
			end
		end
		function x.Notify(C, D)
			if x.Workspace then
				x.Workspace:RecordNotification(D)
			end
			return t:New(D)
		end
		if getgenv then
			getgenv().Fluent = x
		end
		return x
	end,
	function()
		local c, d, e, f, g = b(2)
		local h = {AcrylicBlur = e(d.AcrylicBlur), CreateAcrylic = e(d.CreateAcrylic), AcrylicPaint = e(d.AcrylicPaint)}
		function h.init()
			local i = Instance.new "DepthOfFieldEffect"
			i.FarIntensity = 0
			i.InFocusRadius = 0.1
			i.NearIntensity = 1
			local j = {}
			function h.Enable()
				for k, l in pairs(j) do
					l.Enabled = false
				end
				i.Parent = game:GetService "Lighting"
			end
			function h.Disable()
				for k, l in pairs(j) do
					l.Enabled = l.enabled
				end
				i.Parent = nil
			end
			local k = function()
				local k = function(k)
					if k:IsA "DepthOfFieldEffect" then
						j[k] = {enabled = k.Enabled}
					end
				end
				for l, m in pairs(game:GetService "Lighting":GetChildren()) do
					k(m)
				end
				if game:GetService "Workspace".CurrentCamera then
					for n, o in pairs(game:GetService "Workspace".CurrentCamera:GetChildren()) do
						k(o)
					end
				end
			end
			k()
			h.Enable()
		end
		return h
	end,
	function()
		local c, d, e, f, g = b(3)
		local h, i, j, k = e(d.Parent.Parent.Creator), e(d.Parent.CreateAcrylic), unpack(e(d.Parent.Utils))
		local l = function(l)
			local m = {}
			l = l or 0.001
			local n, o = {topLeft = Vector2.new(), topRight = Vector2.new(), bottomRight = Vector2.new()}, i()
			o.Parent = workspace
			local p, q = function(p, q)
				n.topLeft = q
				n.topRight = q + Vector2.new(p.X, 0)
				n.bottomRight = q + p
			end, function()
				local p = game:GetService "Workspace".CurrentCamera
				if p then
					p = p.CFrame
				end
				local q = p
				if not q then
					q = CFrame.new()
				end
				local r, s, t, u = q, n.topLeft, n.topRight, n.bottomRight
				local v, w, x = j(s, l), j(t, l), j(u, l)
				local y, z = (w - v).Magnitude, (w - x).Magnitude
				o.CFrame = CFrame.fromMatrix((v + x) / 2, r.XVector, r.YVector, r.ZVector)
				o.Mesh.Scale = Vector3.new(y, z, 0)
			end
			local r, s = function(r)
				local s = k()
				local t, u = r.AbsoluteSize - Vector2.new(s, s), r.AbsolutePosition + Vector2.new(s / 2, s / 2)
				p(t, u)
				task.spawn(q)
			end, function()
				local r = game:GetService "Workspace".CurrentCamera
				if not r then
					return
				end
				table.insert(m, r:GetPropertyChangedSignal "CFrame":Connect(q))
				table.insert(m, r:GetPropertyChangedSignal "ViewportSize":Connect(q))
				table.insert(m, r:GetPropertyChangedSignal "FieldOfView":Connect(q))
				task.spawn(q)
			end
			o.Destroying:Connect(
				function()
					for t, u in m do
						pcall(
							function()
								u:Disconnect()
							end
						)
					end
				end
			)
			s()
			return r, o
		end
		return function(m)
			local n, o, p = {}, l(m)
			local q = h.New("Frame", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)})
			h.AddSignal(
				q:GetPropertyChangedSignal "AbsolutePosition",
				function()
					o(q)
				end
			)
			h.AddSignal(
				q:GetPropertyChangedSignal "AbsoluteSize",
				function()
					o(q)
				end
			)
			n.AddParent = function(r)
				h.AddSignal(
					r:GetPropertyChangedSignal "Visible",
					function()
						n.SetVisibility(r.Visible)
					end
				)
			end
			n.SetVisibility = function(r)
				p.Transparency = r and 0.98 or 1
			end
			n.Frame = q
			n.Model = p
			return n
		end
	end,
	function()
		local c, d, e, f, g = b(4)
		local h, i = e(d.Parent.Parent.Creator), e(d.Parent.AcrylicBlur)
		local j = h.New
		return function(k)
			local l = {}
			l.Frame =
				j(
					"Frame",
					{
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 0.9,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BorderSizePixel = 0
					},
					{
						j(
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
						j("UICorner", {CornerRadius = UDim.new(0, 8)}),
						j(
							"Frame",
							{
								BackgroundTransparency = 0.45,
								Size = UDim2.fromScale(1, 1),
								Name = "Background",
								ThemeTag = {BackgroundColor3 = "AcrylicMain"}
							},
							{j("UICorner", {CornerRadius = UDim.new(0, 8)})}
						),
						j(
							"Frame",
							{
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 0.4,
								Size = UDim2.fromScale(1, 1)
							},
							{
								j("UICorner", {CornerRadius = UDim.new(0, 8)}),
								j("UIGradient", {Rotation = 90, ThemeTag = {Color = "AcrylicGradient"}})
							}
						),
						j(
							"ImageLabel",
							{
								Image = "rbxassetid://9968344105",
								ImageTransparency = 0.98,
								ScaleType = Enum.ScaleType.Tile,
								TileSize = UDim2.new(0, 128, 0, 128),
								Size = UDim2.fromScale(1, 1),
								BackgroundTransparency = 1
							},
							{j("UICorner", {CornerRadius = UDim.new(0, 8)})}
						),
						j(
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
							{j("UICorner", {CornerRadius = UDim.new(0, 8)})}
						),
						j(
							"Frame",
							{BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 2},
							{
								j("UICorner", {CornerRadius = UDim.new(0, 8)}),
								j("UIStroke", {Transparency = 0.5, Thickness = 1, ThemeTag = {Color = "AcrylicBorder"}})
							}
						)
					}
				)
			local m
			if e(d.Parent.Parent).UseAcrylic then
				m = i()
				m.Frame.Parent = l.Frame
				l.Model = m.Model
				l.AddParent = m.AddParent
				l.SetVisibility = m.SetVisibility
			end
			return l
		end
	end,
	function()
		local c, d, e, f, g = b(5)
		local h = d.Parent.Parent
		local i = e(h.Creator)
		local j = function()
			local j =
				i.New(
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
					{i.New("SpecialMesh", {MeshType = Enum.MeshType.Brick, Offset = Vector3.new(0, 0, -1E-6)})}
				)
			return j
		end
		return j
	end,
	function()
		local c, d, e, f, g = b(6)
		local h, i = function(h, i, j, k, l)
			return (h - i) * (l - k) / (j - i) + k
		end, function(h, i)
			local j = game:GetService "Workspace".CurrentCamera:ScreenPointToRay(h.X, h.Y)
			return j.Origin + j.Direction * i
		end
		local j = function()
			local j = game:GetService "Workspace".CurrentCamera.ViewportSize.Y
			return h(j, 0, 2560, 8, 56)
		end
		return {i, j}
	end,
	[8] = function()
		local c, d, e, f, g = b(8)
		return {
			Close = "rbxassetid://9886659671",
			Min = "rbxassetid://9886659276",
			Max = "rbxassetid://9886659406",
			Restore = "rbxassetid://9886659001"
		}
	end,
	[9] = function()
		local c, d, e, f, g = b(9)
		local h = d.Parent.Parent
		local i, j = e(h.Packages.Flipper), e(h.Creator)
		local k, l = j.New, i.Spring.new
		return function(m, n, o)
			o = o or false
			local p = {}
			p.Title =
				k(
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
			p.HoverFrame =
				k(
					"Frame",
					{Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ThemeTag = {BackgroundColor3 = "Hover"}},
					{k("UICorner", {CornerRadius = UDim.new(0, 8)})}
				)
			p.Frame =
				k(
					"TextButton",
					{Size = UDim2.new(0, 0, 0, 32), Parent = n, ThemeTag = {BackgroundColor3 = "DialogButton"}},
					{
						k("UICorner", {CornerRadius = UDim.new(0, 4)}),
						k(
							"UIStroke",
							{
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								Transparency = 0.65,
								ThemeTag = {Color = "DialogButtonBorder"}
							}
						),
						p.HoverFrame,
						p.Title
					}
				)
			local q, r = j.SpringMotor(1, p.HoverFrame, "BackgroundTransparency", o)
			j.AddSignal(
				p.Frame.MouseEnter,
				function()
					r(0.97)
				end
			)
			j.AddSignal(
				p.Frame.MouseLeave,
				function()
					r(1)
				end
			)
			j.AddSignal(
				p.Frame.MouseButton1Down,
				function()
					r(1)
				end
			)
			j.AddSignal(
				p.Frame.MouseButton1Up,
				function()
					r(0.97)
				end
			)
			return p
		end
	end,
	[10] = function()
		local c, d, e, f, g = b(10)
		local h, i, j, k =
			game:GetService "UserInputService",
		game:GetService "Players".LocalPlayer:GetMouse(),
		game:GetService "Workspace".CurrentCamera,
		d.Parent.Parent
		local l, m = e(k.Packages.Flipper), e(k.Creator)
		local n, o, p, q = l.Spring.new, l.Instant.new, m.New, {Window = nil}
		function q.Init(r, s)
			q.Window = s
			return q
		end
		function q.Create(r)
			local s = {Buttons = 0}
			s.TintFrame =
				p(
					"TextButton",
					{
						Text = "",
						Size = UDim2.fromScale(1, 1),
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						BackgroundTransparency = 1,
						Parent = q.Window.Root
					},
					{p("UICorner", {CornerRadius = UDim.new(0, 8)})}
				)
			local t, u = m.SpringMotor(1, s.TintFrame, "BackgroundTransparency", true)
			s.ButtonHolder =
				p(
					"Frame",
					{
						Size = UDim2.new(1, -40, 1, -40),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						BackgroundTransparency = 1
					},
					{
						p(
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
			s.ButtonHolderFrame =
				p(
					"Frame",
					{
						Size = UDim2.new(1, 0, 0, 70),
						Position = UDim2.new(0, 0, 1, -70),
						ThemeTag = {BackgroundColor3 = "DialogHolder"}
					},
					{
						p("Frame", {Size = UDim2.new(1, 0, 0, 1), ThemeTag = {BackgroundColor3 = "DialogHolderLine"}}),
						s.ButtonHolder
					}
				)
			s.Title =
				p(
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
			s.Scale = p("UIScale", {Scale = 1})
			local v, w = m.SpringMotor(1.1, s.Scale, "Scale")
			s.Root =
				p(
					"CanvasGroup",
					{
						Size = UDim2.fromOffset(300, 165),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						GroupTransparency = 1,
						Parent = s.TintFrame,
						ThemeTag = {BackgroundColor3 = "Dialog"}
					},
					{
						p("UICorner", {CornerRadius = UDim.new(0, 8)}),
						p("UIStroke", {Transparency = 0.5, ThemeTag = {Color = "DialogBorder"}}),
						s.Scale,
						s.Title,
						s.ButtonHolderFrame
					}
				)
			local x, y = m.SpringMotor(1, s.Root, "GroupTransparency")
			function s.Open(z)
				e(k).DialogOpen = true
				s.Scale.Scale = 1.1
				u(0.75)
				y(0)
				w(1)
			end
			function s.Close(z)
				e(k).DialogOpen = false
				u(1)
				y(1)
				w(1.1)
				s.Root.UIStroke:Destroy()
				task.wait(0.15)
				s.TintFrame:Destroy()
			end
			function s.Button(z, A, B)
				s.Buttons = s.Buttons + 1
				A = A or "Button"
				B = B or function()
				end
				local C = e(k.Components.Button)("", s.ButtonHolder, true)
				C.Title.Text = A
				for D, E in next, s.ButtonHolder:GetChildren() do
					if E:IsA "TextButton" then
						E.Size = UDim2.new(1 / s.Buttons, -(((s.Buttons - 1) * 10) / s.Buttons), 0, 32)
					end
				end
				m.AddSignal(
					C.Frame.MouseButton1Click,
					function()
						e(k):SafeCallback(B)
						pcall(
							function()
								s:Close()
							end
						)
					end
				)
				return C
			end
			return s
		end
		return q
	end,
	[11] = function()
		local c, d, e, f, g = b(11)
		local h = d.Parent.Parent
		local i, j = e(h.Packages.Flipper), e(h.Creator)
		local k, l = j.New, i.Spring.new
		return function(m, n, o, p)
			local q = {}
			q.TitleLabel =
				k(
					"TextLabel",
					{
						FontFace = Font.new(
							"rbxasset://fonts/families/GothamSSm.json",
							Enum.FontWeight.Medium,
							Enum.FontStyle.Normal
						),
						Text = m,
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
			q.DescLabel =
				k(
					"TextLabel",
					{
						FontFace = Font.new "rbxasset://fonts/families/GothamSSm.json",
						Text = n,
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
			q.LabelHolder =
				k(
					"Frame",
					{
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						Position = UDim2.fromOffset(10, 0),
						Size = UDim2.new(1, -28, 0, 0)
					},
					{
						k(
							"UIListLayout",
							{SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center}
						),
						k("UIPadding", {PaddingBottom = UDim.new(0, 13), PaddingTop = UDim.new(0, 13)}),
						q.TitleLabel,
						q.DescLabel
					}
				)
			q.Border =
				k(
					"UIStroke",
					{
						Transparency = 0.5,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = Color3.fromRGB(0, 0, 0),
						ThemeTag = {Color = "ElementBorder"}
					}
				)
			q.Frame =
				k(
					"TextButton",
					{
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 0.89,
						BackgroundColor3 = Color3.fromRGB(130, 130, 130),
						Parent = o,
						AutomaticSize = Enum.AutomaticSize.Y,
						Text = "",
						LayoutOrder = 7,
						ThemeTag = {BackgroundColor3 = "Element", BackgroundTransparency = "ElementTransparency"}
					},
					{k("UICorner", {CornerRadius = UDim.new(0, 4)}), q.Border, q.LabelHolder}
				)
			function q.SetTitle(r, s)
				q.TitleLabel.Text = s
				-- Register with Translation System
				TranslationSystem:Register(q.TitleLabel, s, "Text")
			end
			function q.SetDesc(r, s)
				if s == nil then
					s = ""
				end
				if s == "" then
					q.DescLabel.Visible = false
				else
					q.DescLabel.Visible = true
				end
				q.DescLabel.Text = s
				-- Register with Translation System
				if s ~= "" then
					TranslationSystem:Register(q.DescLabel, s, "Text")
				end
			end
			function q.Destroy(r)
				q.Frame:Destroy()
			end
			q:SetTitle(m)
			q:SetDesc(n)
			if p then
				local r, s, t =
					h.Themes,
				j.SpringMotor(
					j.GetThemeProperty "ElementTransparency",
					q.Frame,
					"BackgroundTransparency",
					false,
					true
				)
				j.AddSignal(
					q.Frame.MouseEnter,
					function()
						t(j.GetThemeProperty "ElementTransparency" - j.GetThemeProperty "HoverChange")
					end
				)
				j.AddSignal(
					q.Frame.MouseLeave,
					function()
						t(j.GetThemeProperty "ElementTransparency")
					end
				)
				j.AddSignal(
					q.Frame.MouseButton1Down,
					function()
						t(j.GetThemeProperty "ElementTransparency" + j.GetThemeProperty "HoverChange")
					end
				)
				j.AddSignal(
					q.Frame.MouseButton1Up,
					function()
						t(j.GetThemeProperty "ElementTransparency" - j.GetThemeProperty "HoverChange")
					end
				)
			end
			return q
		end
	end,
	[12] = function()
		local c, d, e, f, g = b(12)
		local h = d.Parent.Parent
		local i, j, k = e(h.Packages.Flipper), e(h.Creator), e(h.Acrylic)
		local l, m, n, o = i.Spring.new, i.Instant.new, j.New, {}

		function o.Init(p, q)
			-- Responsive width: smaller on mobile
			local viewportSize = workspace.CurrentCamera.ViewportSize
			local isMobile = viewportSize.X < 600
			local notifWidth = isMobile and 280 or 340
			local sideMargin = isMobile and 10 or 30

			o.Holder =
				n(
					"Frame",
					{
						Position = UDim2.new(1, -sideMargin, 1, -sideMargin),
						Size = UDim2.new(0, notifWidth, 1, -sideMargin),
						AnchorPoint = Vector2.new(1, 1),
						BackgroundTransparency = 1,
						Parent = q
					},
					{
						n(
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
		end

		function o.New(p, q)
			q.Title = q.Title or "Notification"
			q.Content = q.Content or "Content"
			q.SubContent = q.SubContent or ""
			q.Duration = q.Duration or nil
			q.Buttons = q.Buttons or {}

			-- Store originals for translation
			local originalTitle = q.Title
			local originalContent = q.Content
			local originalSubContent = q.SubContent

			local r = {Closed = false}
			r.AcrylicPaint = k.AcrylicPaint()

			-- Icon & color mapping
			local s = "rbxassetid://10723415903"
			local t = Color3.fromRGB(76, 194, 255)

			if q.Title:lower():find("success") or q.Title:lower():find("complete") then
				s = "rbxassetid://10709790387"
				t = Color3.fromRGB(50, 205, 50)
			elseif q.Title:lower():find("error") or q.Title:lower():find("fail") then
				s = "rbxassetid://10734933655"
				t = Color3.fromRGB(255, 60, 80)
			elseif q.Title:lower():find("warn") then
				s = "rbxassetid://10709753149"
				t = Color3.fromRGB(255, 180, 0)
			end

			r.IconFrame =
				n(
					"Frame",
					{
						Size = UDim2.fromOffset(40, 40),
						Position = UDim2.fromOffset(10, 10),
						BackgroundColor3 = t,
						BackgroundTransparency = 0.88,
						BorderSizePixel = 0
					},
					{
						n("UICorner", {CornerRadius = UDim.new(0, 10)}),
						n(
							"UIStroke",
							{
								Color = t,
								Transparency = 0.7,
								Thickness = 1
							}
						),
						n(
							"ImageLabel",
							{
								Size = UDim2.fromOffset(22, 22),
								Position = UDim2.fromScale(0.5, 0.5),
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundTransparency = 1,
								Image = s,
								ImageColor3 = t
							}
						)
					}
				)

			r.Title =
				n(
					"TextLabel",
					{
						Position = UDim2.new(0, 58, 0, 12),
						Text = q.Title,
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
			-- Register Title for translation
			TranslationSystem:Register(r.Title, originalTitle, "Text")

			r.ContentLabel =
				n(
					"TextLabel",
					{
						FontFace = Font.new(
							"rbxasset://fonts/families/GothamSSm.json",
							Enum.FontWeight.Regular,
							Enum.FontStyle.Normal
						),
						Text = q.Content,
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
			TranslationSystem:Register(r.ContentLabel, originalContent, "Text")

			r.SubContentLabel =
				n(
					"TextLabel",
					{
						FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
						Text = q.SubContent,
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
				TranslationSystem:Register(r.SubContentLabel, originalSubContent, "Text")
			end

			r.LabelHolder =
				n(
					"Frame",
					{
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						Position = UDim2.fromOffset(58, 32),
						Size = UDim2.new(1, -68, 0, 0)
					},
					{
						n(
							"UIListLayout",
							{
								SortOrder = Enum.SortOrder.LayoutOrder,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								Padding = UDim.new(0, 3)
							}
						),
						r.ContentLabel,
						r.SubContentLabel
					}
				)

			-- Buttons container (dynamic)
			r.ButtonHolder =
				n(
					"Frame",
					{
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 58, 1, -40),
						Size = UDim2.new(1, -68, 0, 0)
					},
					{
						n(
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
			if #q.Buttons > 0 then
				for _, btnData in ipairs(q.Buttons) do
					local text = btnData.Text or "Button"
					local color = btnData.Color or Color3.fromRGB(100, 100, 255)
					-- estimate width (simple): clamp by text length - smaller for mobile
					local estWidth = math.clamp(#tostring(text) * 7 + 20, 64, 140)

					local btnStroke = n(
						"UIStroke",
						{
							Color = color,
							Transparency = 0.5,
							Thickness = 1,
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border
						}
					)

					local btn =
						n(
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
								n("UICorner", {CornerRadius = UDim.new(0, 8)}),
								btnStroke
							}
						)

					-- hover spring with smoother animation
					local _, btnSet = j.SpringMotor(0.05, btn, "BackgroundTransparency")
					local _, btnStrokeSet = j.SpringMotor(0.5, btnStroke, "Transparency")

					j.AddSignal(
						btn.MouseEnter,
						function()
							btnSet(0)
							btnStrokeSet(0.2)
						end
					)
					j.AddSignal(
						btn.MouseLeave,
						function()
							btnSet(0.05)
							btnStrokeSet(0.5)
						end
					)

					-- click behaviour
					j.AddSignal(
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
								r:Close()
							end
						end
					)

					-- parent into holder
					btn.Parent = r.ButtonHolder
				end
			end

			r.ProgressBar =
				n(
					"Frame",
					{
						Size = UDim2.new(1, 0, 0, 4),
						Position = UDim2.new(0, 0, 1, -4),
						BackgroundColor3 = t,
						BackgroundTransparency = 0.5,
						BorderSizePixel = 0
					},
					{
						n("UICorner", {CornerRadius = UDim.new(1, 0)}),
						n(
							"UIGradient",
							{
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, t),
									ColorSequenceKeypoint.new(1, Color3.fromRGB(
										math.min(t.R * 255 * 1.2, 255),
										math.min(t.G * 255 * 1.2, 255),
										math.min(t.B * 255 * 1.2, 255)
										))
								})
							}
						)
					}
				)

			r.CloseButton =
				n(
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
						n("UICorner", {CornerRadius = UDim.new(1, 0)}),
						n(
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

			r.Shadow =
				n(
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
			r.Root =
				n(
					"Frame",
					{BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.fromScale(1, 0)},
					{
						r.Shadow,
						r.AcrylicPaint.Frame,
						r.IconFrame,
						r.Title,
						r.CloseButton,
						r.LabelHolder,
						r.ButtonHolder,
						r.ProgressBar
					}
				)

			if q.Content == "" then
				r.ContentLabel.Visible = false
			end
			if q.SubContent == "" then
				r.SubContentLabel.Visible = false
			end

			r.Holder =
				n("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 100), Parent = o.Holder}, {r.Root})

			local u = i.GroupMotor.new({Scale = 1, Offset = 80, Rotation = 8, Opacity = 0})
			u:onStep(
				function(v)
					r.Root.Position = UDim2.new(v.Scale, v.Offset, 0, 0)
					r.Root.Rotation = v.Rotation
					r.Root.BackgroundTransparency = v.Opacity
					if r.AcrylicPaint and r.AcrylicPaint.Frame then
						r.AcrylicPaint.Frame.BackgroundTransparency = v.Opacity
					end
				end
			)

			j.AddSignal(
				r.CloseButton.MouseButton1Click,
				function()
					r:Close()
				end
			)

			local w, x = j.SpringMotor(0.92, r.CloseButton, "BackgroundTransparency")
			j.AddSignal(
				r.CloseButton.MouseEnter,
				function()
					x(0.8)
				end
			)
			j.AddSignal(
				r.CloseButton.MouseLeave,
				function()
					x(0.92)
				end
			)

			function r.Open(y)
				local z = r.LabelHolder.AbsoluteSize.Y
				local extraForButtons = (#q.Buttons > 0) and 36 or 0
				r.Holder.Size = UDim2.new(1, 0, 0, math.max(60, 50 + z + extraForButtons))

				-- Improved slide-in animation with fade
				u:setGoal(
					{
						Scale = l(0, {frequency = 6, dampingRatio = 0.75}),
						Offset = l(0, {frequency = 6, dampingRatio = 0.75}),
						Rotation = l(0, {frequency = 7, dampingRatio = 0.85}),
						Opacity = l(1, {frequency = 8, dampingRatio = 0.9})
					}
				)

				-- Icon bounce animation - smoother and smaller
				r.IconFrame.Size = UDim2.fromOffset(0, 0)
				local A = game:GetService("TweenService")
				local B = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
				task.wait(0.15)
				A:Create(r.IconFrame, B, {Size = UDim2.fromOffset(40, 40)}):Play()

				-- Subtle glow effect on icon
				task.spawn(function()
					task.wait(0.2)
					local iconFrame = r.IconFrame
					A:Create(iconFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundTransparency = 0.75}):Play()
				end)
			end

			function r.Close(y)
				if not r.Closed then
					r.Closed = true
					task.spawn(
						function()
							-- Improved slide-out with fade and rotation
							u:setGoal(
								{
									Scale = l(1, {frequency = 7, dampingRatio = 0.8}),
									Offset = l(100, {frequency = 7, dampingRatio = 0.8}),
									Rotation = l(-8, {frequency = 8, dampingRatio = 0.85}),
									Opacity = l(0, {frequency = 6, dampingRatio = 1})
								}
							)

							-- Icon shrink animation
							local A = game:GetService("TweenService")
							A:Create(r.IconFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
								{Size = UDim2.fromOffset(0, 0)}):Play()

							task.wait(0.6)
							if e(h).UseAcrylic then
								if r.AcrylicPaint and r.AcrylicPaint.Model then
									r.AcrylicPaint.Model:Destroy()
								end
							end
							if r.Holder and r.Holder.Destroy then
								r.Holder:Destroy()
							end
						end
					)
				end
			end

			r:Open()

			if q.Duration then
				r.ProgressBar.Size = UDim2.new(1, 0, 0, 4)
				local A = game:GetService("TweenService")
				local B = TweenInfo.new(q.Duration, Enum.EasingStyle.Linear)
				A:Create(r.ProgressBar, B, {Size = UDim2.new(0, 0, 0, 4)}):Play()
				task.delay(
					q.Duration,
					function()
						r:Close()
					end
				)
			end

			return r
		end

		return o
	end,
	[13] = function()
		local c, d, e, f, g = b(13)
		local h = d.Parent.Parent
		local i = e(h.Creator)
		local j = i.New
		return function(k, l)
			local m = {}
			m.Visible = true
			m.Layout = j("UIListLayout", {Padding = UDim.new(0, 5)})
			m.Container =
				j(
					"Frame",
					{Size = UDim2.new(1, 0, 0, 26), Position = UDim2.fromOffset(0, 24), BackgroundTransparency = 1},
					{m.Layout}
				)
			m.Root =
				j(
					"Frame",
					{BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 26), LayoutOrder = 7, Parent = l},
					{
						j(
							"TextLabel",
							{
								RichText = true,
								Text = k,
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
						m.Container
					}
				)
			i.AddSignal(
				m.Layout:GetPropertyChangedSignal "AbsoluteContentSize",
				function()
					m.Container.Size = UDim2.new(1, 0, 0, m.Layout.AbsoluteContentSize.Y)
					if m.Visible then
						m.Root.Size = UDim2.new(1, 0, 0, m.Layout.AbsoluteContentSize.Y + 25)
					end
				end
			)
			m.SetVisible = function(n)
				m.Visible = n == true
				m.Root.Visible = m.Visible
				m.Root.Size = UDim2.new(1, 0, 0, m.Visible and (m.Layout.AbsoluteContentSize.Y + 25) or 0)
			end
			return m
		end
	end,
	[14] = function()
		local c, d, e, f, g = b(14)
		local h = d.Parent.Parent
		local i, j = e(h.Packages.Flipper), e(h.Creator)
		local k, l, m, n, o =
			j.New,
		i.Spring.new,
		i.Instant.new,
		h.Components,
		{Window = nil, Tabs = {}, Containers = {}, SelectedTab = 0, TabCount = 0}
		function o.Init(p, q)
			o.Window = q
			return o
		end
		function o.GetCurrentTabPos(p)
			local q, r = o.Window.TabHolder.AbsolutePosition.Y, o.Tabs[o.SelectedTab].Frame.AbsolutePosition.Y
			return r - q
		end
		function o.New(p, q, r, s)
			local t, u = e(h), o.Window
			local v = t.Elements
			o.TabCount = o.TabCount + 1
			local w, x = o.TabCount, {Selected = false, Name = q, Type = "Tab", Index = o.TabCount}
			x.Id = "tab-" .. tostring(w) .. "-" .. tostring(q)
			if t:GetIcon(r) then
				r = t:GetIcon(r)
			end
			if r == "" or nil then
				r = nil
			end
			x.Frame =
				k(
					"TextButton",
					{
						Size = UDim2.new(1, 0, 0, 34),
						Name = "ATGTab_" .. tostring(w),
						LayoutOrder = w,
						BackgroundTransparency = 1,
						Parent = s,
						ThemeTag = {BackgroundColor3 = "Tab"}
					},
					{
						k("UICorner", {CornerRadius = UDim.new(0, 6)}),
						k(
							"TextLabel",
							{
								Name = "TabLabel",
								AnchorPoint = Vector2.new(0, 0.5),
								Position = r and UDim2.new(0, 30, 0.5, 0) or UDim2.new(0, 12, 0.5, 0),
								Text = q,
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
						k(
							"ImageLabel",
							{
								Name = "TabIcon",
								AnchorPoint = Vector2.new(0, 0.5),
								Size = UDim2.fromOffset(16, 16),
								Position = UDim2.new(0, 8, 0.5, 0),
								BackgroundTransparency = 1,
								Image = r and r or nil,
								ThemeTag = {ImageColor3 = "Text"}
							}
						)
					}
				)
			x.Label = x.Frame:FindFirstChild("TabLabel")
			x.IconObject = x.Frame:FindFirstChild("TabIcon")
			local y = k("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder})
			x.ContainerFrame =
				k(
					"ScrollingFrame",
					{
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						Parent = u.ContainerHolder,
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
						y,
						k(
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
			j.AddSignal(
				y:GetPropertyChangedSignal "AbsoluteContentSize",
				function()
					x.ContainerFrame.CanvasSize = UDim2.new(0, 0, 0, y.AbsoluteContentSize.Y + 2)
				end
			)
			x.Motor, x.SetTransparency = j.SpringMotor(1, x.Frame, "BackgroundTransparency")
			j.AddSignal(
				x.Frame.MouseEnter,
				function()
					x.SetTransparency(x.Selected and 0.85 or 0.89)
				end
			)
			j.AddSignal(
				x.Frame.MouseLeave,
				function()
					x.SetTransparency(x.Selected and 0.89 or 1)
				end
			)
			j.AddSignal(
				x.Frame.MouseButton1Down,
				function()
					x.SetTransparency(0.92)
				end
			)
			j.AddSignal(
				x.Frame.MouseButton1Up,
				function()
					x.SetTransparency(x.Selected and 0.85 or 0.89)
				end
			)
			j.AddSignal(
				x.Frame.MouseButton1Click,
				function()
					if x.SuppressClick then
						x.SuppressClick = false
						return
					end
					o:SelectTab(w)
				end
			)
			o.Containers[w] = x.ContainerFrame
			o.Tabs[w] = x
			x.Container = x.ContainerFrame
			x.ScrollFrame = x.Container
			x.Select = function()
				o:SelectTab(w)
			end
			local function decorateSectionTitle(z)
				if type(z) ~= "string" then
					return z
				end
				local A = z:match("^%s*(.-)%s*$") or z
				-- Keep an icon supplied by a script; this makes the behavior
				-- additive and avoids `[ icon ] [ icon ] Title`.
				if A == "" or A:match("^%[.-%]") then
					return z
				end
				local B = A:lower()
				local C = "⚙️"
				if B:find("save", 1, true) or B:find("config", 1, true) then
					C = "💾"
				elseif B:find("language", 1, true) or B:find("translation", 1, true) then
					C = "🌐"
				elseif B:find("font", 1, true) or B:find("typography", 1, true) then
					C = "🔤"
				elseif B:find("interface", 1, true) or B:find("theme", 1, true) or B:find("appearance", 1, true) then
					C = "🎨"
				elseif B:find("player", 1, true) then
					C = "👥"
				elseif B:find("teleport", 1, true) or B:find("travel", 1, true) then
					C = "🧭"
				elseif B:find("combat", 1, true) or B:find("farm", 1, true) then
					C = "⚡"
				end
				return "[ " .. C .. " ] " .. A
			end
			function x.AddSection(z, A)
				local B, C = {Type = "Section"}, e(n.Section)(decorateSectionTitle(A), x.Container)
				B.Container = C.Container
				-- Expose the section frame as an optional, backwards-compatible
				-- handle. Addons can use LayoutOrder/Visible without depending on
				-- private descendants of the tab.
				B.Root = C.Root
				B.SetVisible = function(D, E)
					return C.SetVisible(type(D) == "boolean" and D or E)
				end
				B.ScrollFrame = x.Container
				B.Tab = x
				B.TabId = x.Id
				B.TabTitle = x.Name
				setmetatable(B, v)
				return B
			end
			setmetatable(x, v)
			return x
		end
		function o.SelectTab(p, q)
			local r = o.Window
			o.SelectedTab = q
			for s, t in next, o.Tabs do
				t.SetTransparency(1)
				t.Selected = false
			end
			o.Tabs[q].SetTransparency(0.89)
			o.Tabs[q].Selected = true
			local w = e(h)
			if w.Workspace and type(w.Workspace.TouchTab) == "function" then
				w.Workspace:TouchTab(o.Tabs[q])
			end
			r.TabDisplay.Text = o.Tabs[q].Name
			TranslationSystem:Register(r.TabDisplay, o.Tabs[q].Name, "Text")
			r.SelectorPosMotor:setGoal(l(o:GetCurrentTabPos(), {frequency = 6}))
			task.spawn(
				function()
					r.ContainerPosMotor:setGoal(l(110, {frequency = 10}))
					r.ContainerBackMotor:setGoal(l(1, {frequency = 10}))
					task.wait(0.15)
					for u, v in next, o.Containers do
						v.Visible = false
					end
					o.Containers[q].Visible = true
					r.ContainerPosMotor:setGoal(l(94, {frequency = 5}))
					r.ContainerBackMotor:setGoal(l(0, {frequency = 8}))
				end
			)
		end
		return o
	end,
	[15] = function()
		local c, d, e, f, g = b(15)
		local TextService, i = game:GetService("TextService"), d.Parent.Parent
		local j, k = e(i.Packages.Flipper), e(i.Creator)
		local New = k.New
		local TweenService = game:GetService("TweenService")

		return function(parent, n)
			n = n or false
			local o = {}

			-- Input (TextBox) - font size 16 to match CSS
			o.Input =
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
			o.Container =
				New(
					"Frame",
					{
						BackgroundTransparency = 1,
						ClipsDescendants = true,
						Position = UDim2.new(0, 8, 0, 0),
						Size = UDim2.new(1, -16, 1, 0),
						ZIndex = 1
					},
					{o.Input}
				)

			-- Main frame stroke & corner radius (we'll reuse corner radius for the lines)
			local frameCornerRadius = UDim.new(0, 8) -- same corner radius as main box

			local frameStroke = New(
				"UIStroke",
				{
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Thickness = 1.2,
					Transparency = n and 0.5 or 0.65,
					ThemeTag = {Color = n and "InElementBorder" or "DialogButtonBorder"},
					ZIndex = 1
				}
			)

			-- store original stroke color so we can revert
			local originalStrokeColor = frameStroke.Color

			-- Main frame
			o.Frame =
				New(
					"Frame",
					{
						Size = UDim2.new(0, 0, 0, 36),
						BackgroundTransparency = n and 0.92 or 0,
						Parent = parent,
						ThemeTag = {BackgroundColor3 = n and "Input" or "DialogInput"},
						ZIndex = 0
					},
					{
						New("UICorner", {CornerRadius = frameCornerRadius}),
						frameStroke,
						o.Container
					}
				)

			-- Base line (จาง ๆ) — now inset and with UICorner soปลายโค้งตามกล่องหลัก
			local inset = 3 -- same inset we use for highlight, so ends line up
			o.BaseLine =
				New(
					"Frame",
					{
						Size = UDim2.new(1, -2 * inset, 0, 2), -- full width minus inset each side
						Position = UDim2.new(0, inset, 1, -2),
						AnchorPoint = Vector2.new(0, 0),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255), -- white
						BackgroundTransparency = 0.85, -- default: very faint
						ZIndex = 1
					},
					{
						New("UICorner", {CornerRadius = frameCornerRadius}) -- ทำให้ปลายโค้งตามกล่องหลัก
					}
				)
			o.BaseLine.Parent = o.Frame

			-- Highlight / underline (ไฮไลต์สีน้ำเงิน) - starts width 0, also rounded
			o.Highlight =
				New(
					"Frame",
					{
						Size = UDim2.new(0, 0, 0, 2), -- start at width 0
						Position = UDim2.new(0, inset, 1, -2), -- same inset as baseline
						AnchorPoint = Vector2.new(0, 0),
						BackgroundColor3 = Color3.fromRGB(0, 123, 255), -- #007bff
						BackgroundTransparency = 0,
						ZIndex = 2
					},
					{
						New("UICorner", {CornerRadius = frameCornerRadius}) -- ปลายโค้ง
					}
				)
			o.Highlight.Parent = o.Frame

			-- Floating label (input-label)
			o.Label =
				New(
					"TextLabel",
					{
						Text = "",
						Font = Enum.Font.Gotham,
						TextSize = 16,
						TextColor3 = Color3.fromRGB(204, 204, 204),
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
			o.Label.Parent = o.Frame

			-- Helper tweens to match CSS transitions: duration 0.3, easing "ease" -> use Sine Out
			local TWEEN_TIME = 0.3
			local EASING = Enum.EasingStyle.Sine
			local DIR = Enum.EasingDirection.Out

			-- Functions to animate label and highlight exactly like CSS rules
			local function floatLabel(instant)
				instant = instant or false
				local targetPos = UDim2.new(0, 12, 0, -20) -- top: -20px
				local targetSize = 12
				local color = Color3.fromRGB(0, 123, 255) -- #007bff
				if instant then
					o.Label.Position = targetPos
					o.Label.TextSize = targetSize
					o.Label.TextColor3 = color
					o.Label.TextTransparency = 0
				else
					TweenService:Create(o.Label, TweenInfo.new(TWEEN_TIME, EASING, DIR), {
						Position = targetPos,
						TextTransparency = 0
					}):Play()
					TweenService:Create(o.Label, TweenInfo.new(TWEEN_TIME, EASING, DIR), {TextSize = targetSize, TextColor3 = color}):Play()
				end
			end

			local function sinkLabel(instant)
				instant = instant or false
				local originPos = UDim2.new(0, 12, 0, 0) -- top: 0
				local originSize = 16
				local originColor = Color3.fromRGB(204, 204, 204)
				if instant then
					o.Label.Position = originPos
					o.Label.TextSize = originSize
					o.Label.TextColor3 = originColor
					o.Label.TextTransparency = 1
				else
					TweenService:Create(o.Label, TweenInfo.new(TWEEN_TIME, EASING, DIR), {
						Position = originPos,
						TextTransparency = 1
					}):Play()
					TweenService:Create(o.Label, TweenInfo.new(TWEEN_TIME, EASING, DIR), {TextSize = originSize, TextColor3 = originColor}):Play()
				end
			end

			local function expandHighlight(instant)
				instant = instant or false
				-- ขยายให้เต็มความกว้าง minus inset เพื่อให้มุมโค้งยังเห็นผลทั้งสองด้าน
				local target = UDim2.new(1, -2 * inset, 0, 2)
				local targetPos = UDim2.new(0, inset, 1, -2)
				if instant then
					o.Highlight.Size = target
					o.Highlight.Position = targetPos
				else
					TweenService:Create(o.Highlight, TweenInfo.new(TWEEN_TIME, EASING, DIR), {Size = target, Position = targetPos}):Play()
				end
			end

			local function collapseHighlight(instant)
				instant = instant or false
				local target = UDim2.new(0, 0, 0, 2)
				local pos = UDim2.new(0, inset, 1, -2)
				if instant then
					o.Highlight.Size = target
					o.Highlight.Position = pos
				else
					TweenService:Create(o.Highlight, TweenInfo.new(TWEEN_TIME, EASING, DIR), {Size = target, Position = pos}):Play()
				end
			end

			-- Animate baseline "เข้มขึ้น" เมื่อโฟกัส/พิมพ์: ลด transparency (มากขึ้น) และเปลี่ยนโทนสีเล็กน้อย
			local function emphasizeBaseLine(instant)
				instant = instant or false
				if instant then
					o.BaseLine.BackgroundTransparency = 0.6
					o.BaseLine.BackgroundColor3 = Color3.fromRGB(240, 240, 240) -- เล็กน้อยเข้มขึ้น
				else
					TweenService:Create(o.BaseLine, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.6, BackgroundColor3 = Color3.fromRGB(240, 240, 240)}):Play()
				end
			end

			local function deEmphasizeBaseLine(instant)
				instant = instant or false
				if instant then
					o.BaseLine.BackgroundTransparency = 0.85
					o.BaseLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				else
					TweenService:Create(o.BaseLine, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.85, BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
				end
			end

			-- Keep the caret visible without moving the whole TextBox off-screen.
			-- The old calculation ran before AbsoluteSize/TextBounds had settled,
			-- which could leave a focused input at a negative X offset until blur.
			local function setInputOffset(offset)
				if o.Input.Position.X.Offset ~= offset or o.Input.Position.Y.Offset ~= 0 then
					o.Input.Position = UDim2.fromOffset(offset, 0)
				end
			end

			local function getCursorWidth(beforeCursor, textWidth)
				if #beforeCursor == 0 then
					return 0
				end

				local inputFont = o.Input.Font
				if inputFont ~= Enum.Font.Unknown then
					local measured, textSize = pcall(function()
						return TextService:GetTextSize(
							beforeCursor,
							o.Input.TextSize,
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
				local fullText = o.Input.Text
				if textWidth > 0 and #fullText > 0 then
					return textWidth * math.clamp(#beforeCursor / #fullText, 0, 1)
				end
				return 0
			end

			local function adjustInputPosition()
				local pad = 2
				local width = o.Container.AbsoluteSize.X
				if width <= 2 * pad then
					-- Layout has not resolved yet. Leave the input in a safe position;
					-- AbsoluteSize will trigger a second pass once it is visible.
					setInputOffset(pad)
					return
				end

				local textWidth = math.max(0, o.Input.TextBounds.X)
				if not o.Input:IsFocused() or textWidth <= width - 2 * pad then
					setInputOffset(pad)
					return
				end

				local cursorPosition = o.Input.CursorPosition
				if not cursorPosition or cursorPosition < 1 then
					return
				end

				local beforeCursor = string.sub(o.Input.Text, 1, cursorPosition - 1)
				local cursorWidth = getCursorWidth(beforeCursor, textWidth)
				local targetOffset = o.Input.Position.X.Offset
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
			k.AddSignal(o.Input:GetPropertyChangedSignal("Text"), adjustInputPosition)
			k.AddSignal(o.Input:GetPropertyChangedSignal("CursorPosition"), adjustInputPosition)
			k.AddSignal(o.Container:GetPropertyChangedSignal("AbsoluteSize"), adjustInputPosition)
			pcall(function()
				k.AddSignal(o.Input:GetPropertyChangedSignal("TextBounds"), adjustInputPosition)
			end)

			-- Focus behavior: match CSS :focus rules (0.3s transitions), plus our extra emphasis
			k.AddSignal(o.Input.Focused, function()
				adjustInputPosition()
				floatLabel(false)
				expandHighlight(false)

				-- Emphasize baseline
				emphasizeBaseLine(false)

				-- Stroke animation: make it darker/visible
				TweenService:Create(frameStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Transparency = 0.2,
					Thickness = 1.6,
					Color = Color3.fromRGB(40, 120, 215) -- subtle darker blue-ish stroke on focus
				}):Play()

				TweenService:Create(o.Frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = n and 0.88 or 0}):Play()
				k.OverrideTag(o.Frame, {BackgroundColor3 = n and "InputFocused" or "DialogHolder"})
				k.OverrideTag(o.Highlight, {BackgroundColor3 = "Accent"})
			end)

			k.AddSignal(o.Input.FocusLost, function()
				adjustInputPosition()
				local hasText = o.Input.Text and #o.Input.Text > 0
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
					Transparency = n and 0.5 or 0.65,
					Thickness = 1.2,
					Color = originalStrokeColor
				}):Play()

				TweenService:Create(o.Frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = n and 0.92 or 0}):Play()
				k.OverrideTag(o.Frame, {BackgroundColor3 = n and "Input" or "DialogInput"})
				k.OverrideTag(o.Highlight, {BackgroundColor3 = n and "InputIndicator" or "DialogInputLine"})
			end)

			-- Text change: emphasize baseline while typing
			k.AddSignal(o.Input:GetPropertyChangedSignal("Text"), function()
				if o.Input.Text and #o.Input.Text > 0 then
					-- if user types and the field is focused we keep baseline emphasized
					if o.Input:IsFocused() then
						emphasizeBaseLine(false)
					else
						-- if not focused but has text keep label floated
						floatLabel(false)
					end
				else
					if not o.Input:IsFocused() then
						deEmphasizeBaseLine(false)
					end
				end
			end)

			-- initial state: follow CSS initial
			if o.Input.Text and #o.Input.Text > 0 then
				floatLabel(true)
				collapseHighlight(true)
				deEmphasizeBaseLine(true)
			else
				sinkLabel(true)
				collapseHighlight(true)
				deEmphasizeBaseLine(true)
			end

			return o
		end
	end,

	[16] = function()
		local c, d, e, f, g = b(16)
		local h, i = d.Parent.Parent, e(d.Parent.Assets)
		local j, k = e(h.Creator), e(h.Packages.Flipper)
		local l, m = j.New, j.AddSignal
		return function(n)
			local o, p, q =
				{},
			e(h),
			function(o, p, q, r)
				local s = {
					Callback = r or function()
					end
				}
				s.Frame =
					l(
						"TextButton",
						{
							Size = UDim2.new(0, 34, 1, -8),
							AnchorPoint = Vector2.new(1, 0),
							BackgroundTransparency = 1,
							Parent = q,
							Position = p,
							Text = "",
							ThemeTag = {BackgroundColor3 = "Text"}
						},
						{
							l("UICorner", {CornerRadius = UDim.new(0, 7)}),
							l(
								"ImageLabel",
								{
									Image = o,
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
				local t, u = j.SpringMotor(1, s.Frame, "BackgroundTransparency")
				m(
					s.Frame.MouseEnter,
					function()
						u(0.94)
					end
				)
				m(
					s.Frame.MouseLeave,
					function()
						u(1, true)
					end
				)
				m(
					s.Frame.MouseButton1Down,
					function()
						u(0.96)
					end
				)
				m(
					s.Frame.MouseButton1Up,
					function()
						u(0.94)
					end
				)
				m(s.Frame.MouseButton1Click, s.Callback)
				s.SetCallback = function(v)
					s.Callback = v
				end
				return s
			end
			o.Frame =
				l(
					"Frame",
					{Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, Parent = n.Parent},
					{
						l(
							"Frame",
							-- ขยับซ้ายเล็กน้อย: Position 16 -> 8, ลด margin ขวาให้สมดุล
							{Size = UDim2.new(1, -8, 1, 0), Position = UDim2.new(0, 8, 0, 0), BackgroundTransparency = 1},
							{
								-- UIListLayout: แนวนอนและจัดกึ่งกลางแนวตั้ง
								l(
									"UIListLayout",
									{
										Padding = UDim.new(0, 6),
										FillDirection = Enum.FillDirection.Horizontal,
										SortOrder = Enum.SortOrder.LayoutOrder,
										VerticalAlignment = Enum.VerticalAlignment.Center
									}
								),
								-- ไอคอนขนาดใหญ่ขึ้นและจัดด้วย layout
								l(
									"ImageLabel",
									{
										Name = "WindowIcon",
										Image = n.Icon or "rbxassetid://90989180960460",
										Size = UDim2.fromOffset(32, 32), -- ขยายเป็น 32x32
										BackgroundTransparency = 1,
										LayoutOrder = 1,
										ScaleType = Enum.ScaleType.Fit,
										ThemeTag = {ImageColor3 = "Text"}
									}
								),
								-- Title (ขนาดฟอนต์เพิ่มเล็กน้อย)
								l(
									"TextLabel",
									{
										RichText = true,
										Text = n.Title or "",
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
								l(
									"TextLabel",
									{
										RichText = true,
										Text = n.SubTitle or "",
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
						l(
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

			-- Close: now does a full cleanup + destroy related UI
			o.CloseButton =
				q(
					i.Close,
					UDim2.new(1, -4, 0, 4),
					o.Frame,
					function()
						p.Window:Dialog {
							Title = "Close",
							Content = "Are you sure you want to unload the interface?",
							Buttons = {
								{
									Title = "Yes",
									Callback = function()
										-- 1) Destroy the primary window/object (p)
										pcall(
											function()
												if p and type(p.Destroy) == "function" then
													p:Destroy()
												end
											end
										)

										-- 2) Try to destroy global Window if present
										pcall(
											function()
												if Window and type(Window.Destroy) == "function" then
													Window:Destroy()
												end
											end
										)
										pcall(
											function()
												Window = nil
											end
										)

										-- 3) Remove any toggle UI or helper GUIs we created (search CoreGui and PlayerGui)
										local function destroyMarked(parent)
											for _, gui in ipairs(parent:GetChildren()) do
												if gui:IsA("ScreenGui") then
													local name = (gui.Name or ""):lower()
													if
														name:find("fluent") or name:find("atg") or name:find("fluenttoggle") or
														name:find("fluenttogglegui")
													then
														pcall(
															function()
																gui:Destroy()
															end
														)
													end
												end
											end
										end
										pcall(
											function()
												destroyMarked(game:GetService("CoreGui"))
											end
										)
										pcall(
											function()
												destroyMarked(playerGui)
											end
										)

										-- 4) Clear getgenv config / flags that might keep loops running
										if getgenv then
											pcall(
												function()
													getgenv().ATGButtonUI = nil
												end
											)
											pcall(
												function()
													getgenv().FluentToggleGui = nil
												end
											)
											pcall(
												function()
													getgenv().ATGButtonUI_Running = false
												end
											)
										end

										-- 5) Try to force-garbage collect some global resources (best-effort)
										pcall(
											function()
												collectgarbage("collect")
											end
										)
									end
								},
								{Title = "No"}
							}
						}
					end
				)

			o.MaxButton =
				q(
					i.Max,
					UDim2.new(1, -40, 0, 4),
					o.Frame,
					function()
						n.Window.Maximize(not n.Window.Maximized)
					end
				)
			o.MinButton =
				q(
					i.Min,
					UDim2.new(1, -80, 0, 4),
					o.Frame,
					function()
						p.Window:Minimize()
					end
				)
			return o
		end
	end,
	[17] = function()
		local c, d, e, f, g = b(17)
		local h, i, j, k =
			game:GetService "UserInputService",
		game:GetService "Players".LocalPlayer:GetMouse(),
		game:GetService "Workspace".CurrentCamera,
		d.Parent.Parent
		local l, m, n, o, p = e(k.Packages.Flipper), e(k.Creator), e(k.Acrylic), e(d.Parent.Assets), d.Parent
		local q, r, s = l.Spring.new, l.Instant.new, m.New
		return function(t)
			local u, v, w, x, y, z =
				e(k),
			{
				Minimized = false,
				Maximized = false,
				Size = t.Size,
				CurrentPos = 0,
				Position = UDim2.fromOffset(
					j.ViewportSize.X / 2 - t.Size.X.Offset / 2,
					j.ViewportSize.Y / 2 - t.Size.Y.Offset / 2
				)
			},
			false
			local A, B = false
			local C = false
			v.AcrylicPaint = n.AcrylicPaint()
			local D, E =
				s(
					"Frame",
					{
						Size = UDim2.fromOffset(4, 0),
						BackgroundColor3 = Color3.fromRGB(76, 194, 255),
						Position = UDim2.fromOffset(0, 17),
						AnchorPoint = Vector2.new(0, 0.5),
						ThemeTag = {BackgroundColor3 = "Accent"}
					},
					{s("UICorner", {CornerRadius = UDim.new(0, 2)})}
				),
			s(
				"Frame",
				{Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, Position = UDim2.new(1, -20, 1, -20)}
			)
			v.TabHolder =
				s(
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
					{s("UIListLayout", {Padding = UDim.new(0, 4)})}
				)
			local F =
				s(
					"Frame",
					{
						Size = UDim2.new(0, t.TabWidth, 1, -66),
						Position = UDim2.new(0, 12, 0, 54),
						BackgroundTransparency = 1,
						ClipsDescendants = true
					},
					{v.TabHolder, D}
				)
			v.TabArea = F
			v.TabWidth = t.TabWidth
			v.TabDisplay =
				s(
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
						Position = UDim2.fromOffset(t.TabWidth + 26, 56),
						BackgroundTransparency = 1,
						ThemeTag = {TextColor3 = "Text"}
					}
				)
			v.ContainerHolder =
				s(
					"CanvasGroup",
					{
						Size = UDim2.new(1, -t.TabWidth - 32, 1, -102),
						Position = UDim2.fromOffset(t.TabWidth + 26, 90),
						BackgroundTransparency = 1
					}
				)
			v.Root =
				s(
					"Frame",
					{BackgroundTransparency = 1, Size = v.Size, Position = v.Position, Parent = t.Parent},
					{v.AcrylicPaint.Frame, v.TabDisplay, v.ContainerHolder, F, E}
				)
			v.TitleBar = e(d.Parent.TitleBar) {Title = t.Title, SubTitle = t.SubTitle, Parent = v.Root, Window = v}
			if e(k).UseAcrylic then
				v.AcrylicPaint.AddParent(v.Root)
			end
			local G, H =
				l.GroupMotor.new {X = v.Size.X.Offset, Y = v.Size.Y.Offset},
			l.GroupMotor.new {X = v.Position.X.Offset, Y = v.Position.Y.Offset}
			v.SelectorPosMotor = l.SingleMotor.new(17)
			v.SelectorSizeMotor = l.SingleMotor.new(0)
			v.ContainerBackMotor = l.SingleMotor.new(0)
			v.ContainerPosMotor = l.SingleMotor.new(94)
			G:onStep(
				function(I)
					v.Root.Size = UDim2.new(0, I.X, 0, I.Y)
				end
			)
			H:onStep(
				function(I)
					v.Root.Position = UDim2.new(0, I.X, 0, I.Y)
				end
			)
			local I, J = 0, 0
			v.SelectorPosMotor:onStep(
				function(K)
					D.Position = UDim2.new(0, 0, 0, K + 17)
					local L = tick()
					local M = L - J
					if I ~= nil then
						v.SelectorSizeMotor:setGoal(q((math.abs(K - I) / (M * 60)) + 16))
						I = K
					end
					J = L
				end
			)
			v.SelectorSizeMotor:onStep(
				function(K)
					D.Size = UDim2.new(0, 4, 0, K)
				end
			)
			v.ContainerBackMotor:onStep(
				function(K)
					v.ContainerHolder.GroupTransparency = K
				end
			)
			v.ContainerPosMotor:onStep(
				function(K)
					v.ContainerHolder.Position = UDim2.fromOffset(t.TabWidth + 26, K)
				end
			)
			-- Public, additive layout hook used by the workspace toolbar.  Keeping
			-- this inside Window means compact mode does not fight the existing
			-- Flipper position motor when a tab is selected.
			function v.SetTabWidth(M, N)
				N = math.clamp(tonumber(N) or t.TabWidth, 52, 320)
				t.TabWidth = N
				v.TabWidth = N
				F.Size = UDim2.new(0, N, 1, F.Size.Y.Offset)
				v.TabDisplay.Position = UDim2.fromOffset(N + 26, 56)
				v.ContainerHolder.Size = UDim2.new(1, -N - 32, 1, -102)
				v.ContainerHolder.Position = UDim2.fromOffset(N + 26, v.ContainerPosMotor:getValue())
			end
			local K, L
			v.Maximize = function(M, N, O)
				v.Maximized = M
				v.TitleBar.MaxButton.Frame.Icon.Image = M and o.Restore or o.Max
				if M then
					K = v.Size.X.Offset
					L = v.Size.Y.Offset
				end
				local P, Q = M and j.ViewportSize.X or K, M and j.ViewportSize.Y or L
				G:setGoal {
					X = l[O and "Instant" or "Spring"].new(P, {frequency = 6}),
					Y = l[O and "Instant" or "Spring"].new(Q, {frequency = 6})
				}
				v.Size = UDim2.fromOffset(P, Q)
				if not N then
					H:setGoal {
						X = q(M and 0 or v.Position.X.Offset, {frequency = 6}),
						Y = q(M and 0 or v.Position.Y.Offset, {frequency = 6})
					}
				end
			end
			m.AddSignal(
				v.TitleBar.Frame.InputBegan,
				function(M)
					if M.UserInputType == Enum.UserInputType.MouseButton1 or M.UserInputType == Enum.UserInputType.Touch then
						w = true
						y = M.Position
						z = v.Root.Position
						if v.Maximized then
							z =
								UDim2.fromOffset(
									i.X - (i.X * ((K - 100) / v.Root.AbsoluteSize.X)),
									i.Y - (i.Y * (L / v.Root.AbsoluteSize.Y))
								)
						end
						M.Changed:Connect(
							function()
								if M.UserInputState == Enum.UserInputState.End then
									w = false
								end
							end
						)
					end
				end
			)
			m.AddSignal(
				v.TitleBar.Frame.InputChanged,
				function(M)
					if
						M.UserInputType == Enum.UserInputType.MouseMovement or
						M.UserInputType == Enum.UserInputType.Touch
					then
						x = M
					end
				end
			)
			m.AddSignal(
				E.InputBegan,
				function(M)
					if M.UserInputType == Enum.UserInputType.MouseButton1 or M.UserInputType == Enum.UserInputType.Touch then
						A = true
						B = M.Position
					end
				end
			)
			m.AddSignal(
				h.InputChanged,
				function(M)
					if M == x and w then
						local N = M.Position - y
						v.Position = UDim2.fromOffset(z.X.Offset + N.X, z.Y.Offset + N.Y)
						H:setGoal {X = r(v.Position.X.Offset), Y = r(v.Position.Y.Offset)}
						if v.Maximized then
							v.Maximize(false, true, true)
						end
					end
					if
						(M.UserInputType == Enum.UserInputType.MouseMovement or
							M.UserInputType == Enum.UserInputType.Touch) and
						A
					then
						local N, O = M.Position - B, v.Size
						local P = Vector3.new(O.X.Offset, O.Y.Offset, 0) + Vector3.new(1, 1, 0) * N
						local Q = Vector2.new(math.clamp(P.X, 470, 2048), math.clamp(P.Y, 380, 2048))
						G:setGoal {X = l.Instant.new(Q.X), Y = l.Instant.new(Q.Y)}
					end
				end
			)
			m.AddSignal(
				h.InputEnded,
				function(M)
					if A == true or M.UserInputType == Enum.UserInputType.Touch then
						A = false
						v.Size = UDim2.fromOffset(G:getValue().X, G:getValue().Y)
					end
				end
			)
			m.AddSignal(
				v.TabHolder.UIListLayout:GetPropertyChangedSignal "AbsoluteContentSize",
				function()
					v.TabHolder.CanvasSize = UDim2.new(0, 0, 0, v.TabHolder.UIListLayout.AbsoluteContentSize.Y)
				end
			)
			m.AddSignal(
				h.InputBegan,
				function(M)
					local function toggleMinimize()
						-- Ctrl is Fluent's legacy default.  Give Ctrl+K one short
						-- chord window so command search does not minimize first.
						if M.KeyCode == Enum.KeyCode.LeftControl or M.KeyCode == Enum.KeyCode.RightControl then
							task.delay(0.16, function()
								if h:IsKeyDown(M.KeyCode) and not h:IsKeyDown(Enum.KeyCode.K) and not h:GetFocusedTextBox() then
									v:Minimize()
								end
							end)
						else
							v:Minimize()
						end
					end
					if
						type(u.MinimizeKeybind) == "table" and u.MinimizeKeybind.Type == "Keybind" and
						not h:GetFocusedTextBox()
					then
						if M.KeyCode.Name == u.MinimizeKeybind.Value then
							toggleMinimize()
						end
					elseif M.KeyCode == u.MinimizeKey and not h:GetFocusedTextBox() then
						toggleMinimize()
					end
				end
			)
			function v.Minimize(M)
				v.Minimized = not v.Minimized
				v.Root.Visible = not v.Minimized
				if not C then
					C = true
					local N = u.MinimizeKeybind and u.MinimizeKeybind.Value or u.MinimizeKey.Name
					u:Notify {Title = "Interface", Content = "Press " .. N .. " to toggle the inteface.", Duration = 6}
				end
			end
			function v.Destroy(M)
				if e(k).UseAcrylic then
					v.AcrylicPaint.Model:Destroy()
				end
				v.Root:Destroy()
			end
			local M = e(p.Dialog):Init(v)
			function v.Dialog(N, O)
				local P = M:Create()
				P.Title.Text = O.Title
				TranslationSystem:Register(P.Title, O.Title, "Text")
				local Q =
					s(
						"TextLabel",
						{
							FontFace = Font.new "rbxasset://fonts/families/GothamSSm.json",
							Text = O.Content,
							TextColor3 = Color3.fromRGB(240, 240, 240),
							TextSize = 14,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Top,
							Size = UDim2.new(1, -40, 1, 0),
							Position = UDim2.fromOffset(20, 60),
							BackgroundTransparency = 1,
							Parent = P.Root,
							ClipsDescendants = false,
							ThemeTag = {TextColor3 = "Text"}
						}
					)
				s(
					"UISizeConstraint",
					{MinSize = Vector2.new(300, 165), MaxSize = Vector2.new(620, math.huge), Parent = P.Root}
				)
				P.Root.Size = UDim2.fromOffset(Q.TextBounds.X + 40, 165)
				if Q.TextBounds.X + 40 > v.Size.X.Offset - 120 then
					P.Root.Size = UDim2.fromOffset(v.Size.X.Offset - 120, 165)
					Q.TextWrapped = true
					P.Root.Size = UDim2.fromOffset(v.Size.X.Offset - 120, Q.TextBounds.Y + 150)
				end
				for R, S in next, O.Buttons do
					P:Button(S.Title, S.Callback)
				end
				P:Open()
			end
			local N = e(p.Tab):Init(v)
			function v.AddTab(O, P)
				local Q = N:New(P.Title, P.Icon, v.TabHolder)
				if v.Library and v.Library.Workspace and type(v.Library.Workspace.RegisterTab) == "function" then
					v.Library.Workspace:RegisterTab(Q, P)
				end
				return Q
			end
			function v.SelectTab(O, P)
				if type(P) == "table" and type(P.Index) == "number" then
					N:SelectTab(P.Index)
				elseif type(P) == "number" then
					N:SelectTab(P)
				else
					N:SelectTab(1)
				end
			end
			m.AddSignal(
				v.TabHolder:GetPropertyChangedSignal "CanvasPosition",
				function()
					I = N:GetCurrentTabPos() + 16
					J = 0
					v.SelectorPosMotor:setGoal(r(N:GetCurrentTabPos()))
				end
			)
			return v
		end
	end,
	[18] = function()
		local c, d, e, f, g = b(18)
		local h = d.Parent
		local i, j, k =
			e(h.Themes),
		e(h.Packages.Flipper),
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
		local l = function(l, m)
			if m.ThemeTag then
				k.AddThemeObject(l, m.ThemeTag)
			end
		end
		function k.AddSignal(m, n)
			table.insert(k.Signals, m:Connect(n))
		end
		function k.Disconnect()
			for m = #k.Signals, 1, -1 do
				local n = table.remove(k.Signals, m)
				n:Disconnect()
			end
		end
		function k.GetThemeProperty(m)
			if i[e(h).Theme][m] then
				return i[e(h).Theme][m]
			end
			return i.Dark[m]
		end
		function k.UpdateTheme()
			for m, n in next, k.Registry do
				for o, p in next, n.Properties do
					m[o] = k.GetThemeProperty(p)
				end
			end
			for o, p in next, k.TransparencyMotors do
				p:setGoal(j.Instant.new(k.GetThemeProperty "ElementTransparency"))
			end
		end
		function k.AddThemeObject(m, n)
			local o = #k.Registry + 1
			local p = {Object = m, Properties = n, Idx = o}
			k.Registry[m] = p
			for q, r in next, n do
				m[q] = k.GetThemeProperty(r)
			end
			return m
		end
		function k.OverrideTag(m, n)
			if k.Registry[m] then
				k.Registry[m].Properties = n
			else
				k.AddThemeObject(m, n)
			end
			k.UpdateTheme()
		end
		function k.New(m, n, o)
			local p = Instance.new(m)
			for q, r in next, k.DefaultProperties[m] or {} do
				p[q] = r
			end
			for s, t in next, n or {} do
				-- These are creation metadata for the customization layer, not
				-- Roblox Instance properties.
				if s ~= "ThemeTag" and s ~= "I18nKey" and s ~= "I18nContext" and s ~= "I18nSkip"
					and s ~= "FontRole" then
					p[s] = t
				end
			end
			for u, v in next, o or {} do
				v.Parent = p
			end
			l(p, n)
			-- Registers only once at creation, then updates only on a real
			-- language/font change. This avoids expensive descendant scans.
			CustomizationSystem.I18n:AutoRegister(p, n)
			return p
		end
		function k.SpringMotor(m, n, o, p, s)
			p = p or false
			s = s or false
			local t = j.SingleMotor.new(m)
			t:onStep(
				function(u)
					n[o] = u
				end
			)
			if s then
				table.insert(k.TransparencyMotors, t)
			end
			local u = function(u, v)
				v = v or false
				if not p then
					if not v then
						if o == "BackgroundTransparency" and e(h).DialogOpen then
							return
						end
					end
				end
				t:setGoal(j.Spring.new(u, {frequency = 8}))
			end
			return t, u
		end
		return k
	end,
	[19] = function()
		local c, d, e, f, g = b(19)
		local h = {}
		for i, j in next, d:GetChildren() do
			table.insert(h, e(j))
		end
		return h
	end,
	[20] = function()
		local c, d, e, f, g = b(20)
		local h = d.Parent.Parent
		local i = e(h.Creator)
		local j, k, l = i.New, h.Components, {}
		l.__index = l
		l.__type = "Button"
		function l.New(m, n)
			assert(n.Title, "Button - Missing Title")
			n.Callback = n.Callback or function()
			end
			local o = e(k.Element)(n.Title, n.Description, m.Container, true)
			local p =
				j(
					"ImageLabel",
					{
						Image = "rbxassetid://10709791437",
						Size = UDim2.fromOffset(16, 16),
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -10, 0.5, 0),
						BackgroundTransparency = 1,
						Parent = o.Frame,
						ThemeTag = {ImageColor3 = "Text"}
					}
				)
			i.AddSignal(
				o.Frame.MouseButton1Click,
				function()
					m.Library:SafeCallback(n.Callback)
				end
			)
			return o
		end
		return l
	end,
	[21] = function()
		local c, d, e, f, g = b(21)
		local h, i, j, k =
			game:GetService "UserInputService",
		game:GetService "TouchInputService",
		game:GetService "RunService",
		game:GetService "Players"
		local l, m = j.RenderStepped, k.LocalPlayer
		local n, o = m:GetMouse(), d.Parent.Parent
		local p = e(o.Creator)
		local s, t, u = p.New, o.Components, {}
		u.__index = u
		u.__type = "Colorpicker"
		function u.New(v, w, x)
			local y = v.Library
			assert(x.Title, "Colorpicker - Missing Title")
			assert(x.Default, "AddColorPicker: Missing default value.")
			local z = {
				Value = x.Default,
				Transparency = x.Transparency or 0,
				Type = "Colorpicker",
				Title = type(x.Title) == "string" and x.Title or "Colorpicker",
				Callback = x.Callback or function(z)
				end
			}
			function z.SetHSVFromRGB(A, B)
				local C, D, E = Color3.toHSV(B)
				z.Hue = C
				z.Sat = D
				z.Vib = E
			end
			z:SetHSVFromRGB(z.Value)
			local A = e(t.Element)(x.Title, x.Description, v.Container, true)
			z.SetTitle = A.SetTitle
			z.SetDesc = A.SetDesc
			z.Frame = A.Frame
			local B =
				s(
					"Frame",
					{Size = UDim2.fromScale(1, 1), BackgroundColor3 = z.Value, Parent = A.Frame},
					{s("UICorner", {CornerRadius = UDim.new(0, 4)})}
				)
			local aa, ab =
				s(
					"ImageLabel",
					{
						Size = UDim2.fromOffset(26, 26),
						Position = UDim2.new(1, -10, 0.5, 0),
						AnchorPoint = Vector2.new(1, 0.5),
						Parent = A.Frame,
						Image = "http://www.roblox.com/asset/?id=14204231522",
						ImageTransparency = 0.45,
						ScaleType = Enum.ScaleType.Tile,
						TileSize = UDim2.fromOffset(40, 40)
					},
					{s("UICorner", {CornerRadius = UDim.new(0, 4)}), B}
				),
			function()
				local C = e(t.Dialog):Create()
				C.Title.Text = z.Title
				C.Root.Size = UDim2.fromOffset(430, 330)
				local D, E, F, G, H, I =
					z.Hue,
				z.Sat,
				z.Vib,
				z.Transparency,
				function()
					local D = e(t.Textbox)()
					D.Frame.Parent = C.Root
					D.Frame.Size = UDim2.new(0, 90, 0, 32)
					return D
				end,
				function(D, E)
					return s(
						"TextLabel",
						{
							FontFace = Font.new(
								"rbxasset://fonts/families/GothamSSm.json",
								Enum.FontWeight.Medium,
								Enum.FontStyle.Normal
							),
							Text = D,
							TextColor3 = Color3.fromRGB(240, 240, 240),
							TextSize = 13,
							TextXAlignment = Enum.TextXAlignment.Left,
							Size = UDim2.new(1, 0, 0, 32),
							Position = E,
							BackgroundTransparency = 1,
							Parent = C.Root,
							ThemeTag = {TextColor3 = "Text"}
						}
					)
				end
				local J, K =
					function()
						local J = Color3.fromHSV(D, E, F)
						return {R = math.floor(J.r * 255), G = math.floor(J.g * 255), B = math.floor(J.b * 255)}
					end,
				s(
					"ImageLabel",
					{
						Size = UDim2.new(0, 18, 0, 18),
						ScaleType = Enum.ScaleType.Fit,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Image = "http://www.roblox.com/asset/?id=4805639000"
					}
				)
				local L, M =
					s(
						"ImageLabel",
						{
							Size = UDim2.fromOffset(180, 160),
							Position = UDim2.fromOffset(20, 55),
							Image = "rbxassetid://4155801252",
							BackgroundColor3 = z.Value,
							BackgroundTransparency = 0,
							Parent = C.Root
						},
						{s("UICorner", {CornerRadius = UDim.new(0, 4)}), K}
					),
				s(
					"Frame",
					{
						BackgroundColor3 = z.Value,
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = z.Transparency
					},
					{s("UICorner", {CornerRadius = UDim.new(0, 4)})}
				)
				local N, O =
					s(
						"ImageLabel",
						{
							Image = "http://www.roblox.com/asset/?id=14204231522",
							ImageTransparency = 0.45,
							ScaleType = Enum.ScaleType.Tile,
							TileSize = UDim2.fromOffset(40, 40),
							BackgroundTransparency = 1,
							Position = UDim2.fromOffset(112, 220),
							Size = UDim2.fromOffset(88, 24),
							Parent = C.Root
						},
						{
							s("UICorner", {CornerRadius = UDim.new(0, 4)}),
							s("UIStroke", {Thickness = 2, Transparency = 0.75}),
							M
						}
					),
				s(
					"Frame",
					{BackgroundColor3 = z.Value, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0},
					{s("UICorner", {CornerRadius = UDim.new(0, 4)})}
				)
				local P, Q =
					s(
						"ImageLabel",
						{
							Image = "http://www.roblox.com/asset/?id=14204231522",
							ImageTransparency = 0.45,
							ScaleType = Enum.ScaleType.Tile,
							TileSize = UDim2.fromOffset(40, 40),
							BackgroundTransparency = 1,
							Position = UDim2.fromOffset(20, 220),
							Size = UDim2.fromOffset(88, 24),
							Parent = C.Root
						},
						{
							s("UICorner", {CornerRadius = UDim.new(0, 4)}),
							s("UIStroke", {Thickness = 2, Transparency = 0.75}),
							O
						}
					),
				{}
				for R = 0, 1, 0.1 do
					table.insert(Q, ColorSequenceKeypoint.new(R, Color3.fromHSV(R, 1, 1)))
				end
				local R, S =
					s("UIGradient", {Color = ColorSequence.new(Q), Rotation = 90}),
				s(
					"Frame",
					{
						Size = UDim2.new(1, 0, 1, -10),
						Position = UDim2.fromOffset(0, 5),
						BackgroundTransparency = 1
					}
				)
				local T, U, V =
					s(
						"ImageLabel",
						{
							Size = UDim2.fromOffset(14, 14),
							Image = "http://www.roblox.com/asset/?id=12266946128",
							Parent = S,
							ThemeTag = {ImageColor3 = "DialogInput"}
						}
					),
				s(
					"Frame",
					{Size = UDim2.fromOffset(12, 190), Position = UDim2.fromOffset(210, 55), Parent = C.Root},
					{s("UICorner", {CornerRadius = UDim.new(1, 0)}), R, S}
				),
				H()
				V.Frame.Position = UDim2.fromOffset(x.Transparency and 260 or 240, 55)
				I("Hex", UDim2.fromOffset(x.Transparency and 360 or 340, 55))
				local W = H()
				W.Frame.Position = UDim2.fromOffset(x.Transparency and 260 or 240, 95)
				I("Red", UDim2.fromOffset(x.Transparency and 360 or 340, 95))
				local X = H()
				X.Frame.Position = UDim2.fromOffset(x.Transparency and 260 or 240, 135)
				I("Green", UDim2.fromOffset(x.Transparency and 360 or 340, 135))
				local Y = H()
				Y.Frame.Position = UDim2.fromOffset(x.Transparency and 260 or 240, 175)
				I("Blue", UDim2.fromOffset(x.Transparency and 360 or 340, 175))
				local Z
				if x.Transparency then
					Z = H()
					Z.Frame.Position = UDim2.fromOffset(260, 215)
					I("Alpha", UDim2.fromOffset(360, 215))
				end
				local _, aa, ab
				if x.Transparency then
					local ac =
						s(
							"Frame",
							{
								Size = UDim2.new(1, 0, 1, -10),
								Position = UDim2.fromOffset(0, 5),
								BackgroundTransparency = 1
							}
						)
					aa =
						s(
							"ImageLabel",
							{
								Size = UDim2.fromOffset(14, 14),
								Image = "http://www.roblox.com/asset/?id=12266946128",
								Parent = ac,
								ThemeTag = {ImageColor3 = "DialogInput"}
							}
						)
					ab =
						s(
							"Frame",
							{Size = UDim2.fromScale(1, 1)},
							{
								s(
									"UIGradient",
									{
										Transparency = NumberSequence.new {
											NumberSequenceKeypoint.new(0, 0),
											NumberSequenceKeypoint.new(1, 1)
										},
										Rotation = 270
									}
								),
								s("UICorner", {CornerRadius = UDim.new(1, 0)})
							}
						)
					_ =
						s(
							"Frame",
							{
								Size = UDim2.fromOffset(12, 190),
								Position = UDim2.fromOffset(230, 55),
								Parent = C.Root,
								BackgroundTransparency = 1
							},
							{
								s("UICorner", {CornerRadius = UDim.new(1, 0)}),
								s(
									"ImageLabel",
									{
										Image = "http://www.roblox.com/asset/?id=14204231522",
										ImageTransparency = 0.45,
										ScaleType = Enum.ScaleType.Tile,
										TileSize = UDim2.fromOffset(40, 40),
										BackgroundTransparency = 1,
										Size = UDim2.fromScale(1, 1),
										Parent = C.Root
									},
									{s("UICorner", {CornerRadius = UDim.new(1, 0)})}
								),
								ab,
								ac
							}
						)
				end
				local ac = function()
					L.BackgroundColor3 = Color3.fromHSV(D, 1, 1)
					T.Position = UDim2.new(0, -1, D, -6)
					K.Position = UDim2.new(E, 0, 1 - F, 0)
					O.BackgroundColor3 = Color3.fromHSV(D, E, F)
					V.Input.Text = "#" .. Color3.fromHSV(D, E, F):ToHex()
					W.Input.Text = J().R
					X.Input.Text = J().G
					Y.Input.Text = J().B
					if x.Transparency then
						ab.BackgroundColor3 = Color3.fromHSV(D, E, F)
						O.BackgroundTransparency = G
						aa.Position = UDim2.new(0, -1, 1 - G, -6)
						Z.Input.Text = e(o):Round((1 - G) * 100, 0) .. "%"
					end
				end
				p.AddSignal(
					V.Input.FocusLost,
					function(ad)
						if ad then
							local ae, af = pcall(Color3.fromHex, V.Input.Text)
							if ae and typeof(af) == "Color3" then
								D, E, F = Color3.toHSV(af)
							end
						end
						ac()
					end
				)
				p.AddSignal(
					W.Input.FocusLost,
					function(ad)
						if ad then
							local ae = J()
							local af, ag = pcall(Color3.fromRGB, W.Input.Text, ae.G, ae.B)
							if af and typeof(ag) == "Color3" then
								if tonumber(W.Input.Text) <= 255 then
									D, E, F = Color3.toHSV(ag)
								end
							end
						end
						ac()
					end
				)
				p.AddSignal(
					X.Input.FocusLost,
					function(ad)
						if ad then
							local ae = J()
							local af, ag = pcall(Color3.fromRGB, ae.R, X.Input.Text, ae.B)
							if af and typeof(ag) == "Color3" then
								if tonumber(X.Input.Text) <= 255 then
									D, E, F = Color3.toHSV(ag)
								end
							end
						end
						ac()
					end
				)
				p.AddSignal(
					Y.Input.FocusLost,
					function(ad)
						if ad then
							local ae = J()
							local af, ag = pcall(Color3.fromRGB, ae.R, ae.G, Y.Input.Text)
							if af and typeof(ag) == "Color3" then
								if tonumber(Y.Input.Text) <= 255 then
									D, E, F = Color3.toHSV(ag)
								end
							end
						end
						ac()
					end
				)
				if x.Transparency then
					p.AddSignal(
						Z.Input.FocusLost,
						function(ad)
							if ad then
								pcall(
									function()
										local ae = tonumber(Z.Input.Text)
										if ae >= 0 and ae <= 100 then
											G = 1 - ae * 0.01
										end
									end
								)
							end
							ac()
						end
					)
				end
				p.AddSignal(
					L.InputBegan,
					function(ad)
						if
							ad.UserInputType == Enum.UserInputType.MouseButton1 or
							ad.UserInputType == Enum.UserInputType.Touch
						then
							while h:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
								local ae = L.AbsolutePosition.X
								local af = ae + L.AbsoluteSize.X
								local ag, ah = math.clamp(n.X, ae, af), L.AbsolutePosition.Y
								local ai = ah + L.AbsoluteSize.Y
								local aj = math.clamp(n.Y, ah, ai)
								E = (ag - ae) / (af - ae)
								F = 1 - ((aj - ah) / (ai - ah))
								ac()
								l:Wait()
							end
						end
					end
				)
				p.AddSignal(
					U.InputBegan,
					function(ad)
						if
							ad.UserInputType == Enum.UserInputType.MouseButton1 or
							ad.UserInputType == Enum.UserInputType.Touch
						then
							while h:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
								local ae = U.AbsolutePosition.Y
								local af = ae + U.AbsoluteSize.Y
								local ag = math.clamp(n.Y, ae, af)
								D = ((ag - ae) / (af - ae))
								ac()
								l:Wait()
							end
						end
					end
				)
				if x.Transparency then
					p.AddSignal(
						_.InputBegan,
						function(ad)
							if ad.UserInputType == Enum.UserInputType.MouseButton1 then
								while h:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
									local ae = _.AbsolutePosition.Y
									local af = ae + _.AbsoluteSize.Y
									local ag = math.clamp(n.Y, ae, af)
									G = 1 - ((ag - ae) / (af - ae))
									ac()
									l:Wait()
								end
							end
						end
					)
				end
				ac()
				C:Button(
					"Done",
					function()
						z:SetValue({D, E, F}, G)
					end
				)
				C:Button "Cancel"
				C:Open()
			end
			function z.Display(ac)
				z.Value = Color3.fromHSV(z.Hue, z.Sat, z.Vib)
				B.BackgroundColor3 = z.Value
				B.BackgroundTransparency = z.Transparency
				u.Library:SafeCallback(z.Callback, z.Value)
				u.Library:SafeCallback(z.Changed, z.Value)
			end
			function z.SetValue(ac, ad, ae)
				local af = Color3.fromHSV(ad[1], ad[2], ad[3])
				z.Transparency = ae or 0
				z:SetHSVFromRGB(af)
				z:Display()
			end
			function z.SetValueRGB(ac, ad, ae)
				z.Transparency = ae or 0
				z:SetHSVFromRGB(ad)
				z:Display()
			end
			function z.OnChanged(ac, ad)
				z.Changed = ad
				ad(z.Value)
			end
			function z.Destroy(ac)
				A:Destroy()
				y.Options[w] = nil
			end
			p.AddSignal(
				A.Frame.MouseButton1Click,
				function()
					ab()
				end
			)
			z:Display()
			y.Options[w] = z
			return z
		end
		return u
	end,
	[22] = function()
		local aa, ab, ac, ad, ae = b(22)
		local af, ag, ah, ai, aj =
			game:GetService "TweenService",
		game:GetService "UserInputService",
		game:GetService "Players".LocalPlayer:GetMouse(),
		game:GetService "Workspace".CurrentCamera,
		ab.Parent.Parent
		local c, d = ac(aj.Creator), ac(aj.Packages.Flipper)
		local e, f, g = c.New, aj.Components, {}
		g.__index = g
		g.__type = "Dropdown"
		function g.New(h, i, j)
			local k, l, m =
				h.Library,
			{
				Values = j.Values,
				Value = j.Default,
				Multi = j.Multi,
				Buttons = {},
				Opened = false,
				Type = "Dropdown",
				SearchText = "",
				Callback = j.Callback or function()
				end
			},
			ac(f.Element)(j.Title, j.Description, h.Container, false)
			m.DescLabel.Size = UDim2.new(1, -170, 0, 14)
			l.SetTitle = m.SetTitle
			l.SetDesc = m.SetDesc
			l.Frame = m.Frame
			local n, o =
				e(
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
			e(
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
			local p =
				e(
					"TextButton",
					{
						Size = UDim2.fromOffset(160, 34),
						Position = UDim2.new(1, -10, 0.5, 0),
						AnchorPoint = Vector2.new(1, 0.5),
						BackgroundTransparency = 0.9,
						ClipsDescendants = true,
						Parent = m.Frame,
						ThemeTag = {BackgroundColor3 = "DropdownFrame"}
					},
					{
						e("UICorner", {CornerRadius = UDim.new(0, 8)}),
						e(
							"UIStroke",
							{
								Transparency = 0.5,
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								ThemeTag = {Color = "InElementBorder"}
							}
						),
						o,
						n
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
				n.TextTruncate = Enum.TextTruncate.AtEnd
				n.Size = selectedLabelDefaultSize
				n.Position = selectedLabelDefaultPosition
			end
			local function startSelectedLabelScroll()
				local visibleWidth = math.max(p.AbsoluteSize.X - 30, 0)
				local textWidth = getTextWidth(n, n.Text) + 8
				if textWidth <= visibleWidth then
					return
				end
				stopSelectedLabelScroll()
				n.TextTruncate = Enum.TextTruncate.None
				n.Size = UDim2.fromOffset(textWidth, 14)
				local travel = textWidth - visibleWidth
				selectedLabelScrollTween =
					af:Create(
						n,
						TweenInfo.new(math.clamp(travel / 35, 1.2, 5), Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0.25),
						{Position = UDim2.new(0, 8 - travel, 0.5, 0)}
					)
				selectedLabelScrollTween:Play()
			end

			-- Search Box
			local searchBoxStroke = e(
				"UIStroke",
				{
					Transparency = 0.5,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					ThemeTag = {Color = "InElementBorder"}
				}
			)

			local searchBox =
				e(
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
						e("UICorner", {CornerRadius = UDim.new(0, 8)}),
						e("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}),
						searchBoxStroke
					}
				)

			-- Clear Button (X)
			local clearButton =
				e(
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
						e("UICorner", {CornerRadius = UDim.new(0, 8)}),
						e(
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

			if j.Multi then
				selectAllButton =
					e(
						"TextButton",
						{
							Size = UDim2.new(1, -10, 0, 28),
							Position = UDim2.fromOffset(5, 44),
							BackgroundTransparency = 0.9,
							Text = "✅ Select All",
							TextColor3 = Color3.fromRGB(76, 194, 255),
							TextSize = 13,
							FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
							ThemeTag = {BackgroundColor3 = "DialogButton"}
						},
						{
							e("UICorner", {CornerRadius = UDim.new(0, 8)}),
							e(
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

			local s = e("UIListLayout", {Padding = UDim.new(0, 4)})
			local scrollYPos = j.Multi and 77 or 44
			local scrollYSize = j.Multi and -82 or -49

			local t =
				e(
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
					{s}
				)

			local uChildren = {
				searchBox,
				clearButton,
				t,
				e("UICorner", {CornerRadius = UDim.new(0, 7)}),
				e(
					"UIStroke",
					{
						Thickness = 1.5,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						ThemeTag = {Color = "DropdownBorder"}
					}
				),
				e(
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

			if j.Multi then
				table.insert(uChildren, selectAllButton)
			end

			local u =
				e(
					"Frame",
					{Size = UDim2.fromScale(1, 0.5), ThemeTag = {BackgroundColor3 = "DropdownHolder"}},
					uChildren
				)

			local v =
				e(
					"Frame",
					{
						BackgroundTransparency = 1,
						Size = UDim2.fromOffset(170, 250),
						Parent = h.Library.GUI,
						Visible = false
					},
					{u, e("UISizeConstraint", {MinSize = Vector2.new(170, 0), MaxSize = Vector2.new(250, 320)})}
				)
			table.insert(k.OpenFrames, v)

			-- Position dropdown with smart positioning
			local w = function()
				local mainFrame = p.AbsolutePosition
				local mainSize = p.AbsoluteSize
				local dropdownWidth = 170
				local viewportSize = ai.ViewportSize

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
				local maxY = viewportSize.Y - v.AbsoluteSize.Y - 10
				if yPos > maxY then
					yPos = maxY
				end
				if yPos < 10 then
					yPos = 10
				end

				v.Position = UDim2.fromOffset(xPos, yPos)
			end

			local x = 170
			local y = function()
				local maxHeight = 280
				local contentHeight = s.AbsoluteContentSize.Y + (j.Multi and 87 or 54)
				local finalHeight = math.min(contentHeight, maxHeight)
				v.Size = UDim2.fromOffset(x, finalHeight)
			end

			local z = function()
				t.CanvasSize = UDim2.fromOffset(0, s.AbsoluteContentSize.Y)
			end
			local searchDebounce = nil
			local dropdownBuilt = false
			local virtualScrollDebounce = nil
			local virtualRowHeight = 38
			local virtualThreshold = 10
			local virtualBuffer = 4
			local virtualEnabled = false
			local function rebuildDropdown()
				l:BuildDropdownList()
				dropdownBuilt = true
			end

			w()
			y()
			c.AddSignal(p:GetPropertyChangedSignal "AbsolutePosition", w)

			-- Arrow rotation animation
			local arrowRotation = d.SingleMotor.new(0)
			arrowRotation:onStep(function(rot)
				o.Rotation = rot
			end)

			-- Toggle dropdown on click
			c.AddSignal(
				p.MouseEnter,
				function()
					startSelectedLabelScroll()
				end
			)

			c.AddSignal(
				p.MouseLeave,
				function()
					stopSelectedLabelScroll()
				end
			)

			c.AddSignal(
				p.MouseButton1Click,
				function()
					if l.Opened then
						l:Close()
					else
						l:Open()
					end
				end
			)

			c.AddSignal(
				ag.InputBegan,
				function(A)
					if A.UserInputType == Enum.UserInputType.MouseButton1 or A.UserInputType == Enum.UserInputType.Touch then
						if l.Opened then
							local B, C = u.AbsolutePosition, u.AbsoluteSize
							local pB, pC = p.AbsolutePosition, p.AbsoluteSize

							-- Check if click is outside dropdown and outside button
							local outsideDropdown = ah.X < B.X or ah.X > B.X + C.X or ah.Y < B.Y or ah.Y > B.Y + C.Y
							local outsideButton = ah.X < pB.X or ah.X > pB.X + pC.X or ah.Y < pB.Y or ah.Y > pB.Y + pC.Y

							if outsideDropdown and outsideButton then
								l:Close()
							end
						end
					end
				end
			)

			-- Search box focus animation
			c.AddSignal(
				searchBox.Focused,
				function()
					af:Create(searchBoxStroke, TweenInfo.new(0.2), {Transparency = 0.2}):Play()
				end
			)

			c.AddSignal(
				searchBox.FocusLost,
				function()
					af:Create(searchBoxStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
				end
			)

			-- Search functionality with debounce for better performance
			c.AddSignal(
				searchBox:GetPropertyChangedSignal("Text"),
				function()
					if searchDebounce then
						searchDebounce:Disconnect()
					end

					searchDebounce = game:GetService("RunService").Heartbeat:Connect(function()
						if searchDebounce then
							searchDebounce:Disconnect()
							searchDebounce = nil
						end

						l.SearchText = searchBox.Text:lower()
						t.CanvasPosition = Vector2.new(0, 0)
						dropdownBuilt = false
						if l.Opened then
							rebuildDropdown()
						end
					end)
				end
			)

			c.AddSignal(
				t:GetPropertyChangedSignal("CanvasPosition"),
				function()
					if not virtualEnabled or not l.Opened or not dropdownBuilt then
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

			-- Clear button functionality with hover effects
			local _, clearBgTransparency = c.SpringMotor(0.9, clearButton, "BackgroundTransparency")

			c.AddSignal(
				clearButton.MouseEnter,
				function()
					clearBgTransparency(0.8)
					-- Scale up slightly on hover
					af:Create(
						clearButton,
						TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Size = UDim2.fromOffset(38, 38)}
					):Play()
				end
			)

			c.AddSignal(
				clearButton.MouseLeave,
				function()
					clearBgTransparency(0.9)
					-- Scale back to normal
					af:Create(
						clearButton,
						TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Size = UDim2.fromOffset(34, 34)}
					):Play()
				end
			)

			c.AddSignal(
				clearButton.MouseButton1Click,
				function()
					-- Bounce animation on click
					local bounceSequence = af:Create(
						clearButton,
						TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Size = UDim2.fromOffset(30, 30)}
					)
					bounceSequence:Play()
					bounceSequence.Completed:Connect(function()
						af:Create(
							clearButton,
							TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{Size = UDim2.fromOffset(34, 34)}
						):Play()
					end)

					if j.Multi then
						l.Value = {}
					else
						l.Value = nil
					end

					-- Update buttons without rebuilding
					for button, buttonData in pairs(l.Buttons) do
						buttonData:UpdateButton()
					end

					l:Display()
					k:SafeCallback(l.Callback, l.Value)
					k:SafeCallback(l.Changed, l.Value)
				end
			)

			-- Select All button functionality with hover effect
			if j.Multi and selectAllButton then
				local _, selectAllTransparency = c.SpringMotor(0.9, selectAllButton, "BackgroundTransparency")

				c.AddSignal(
					selectAllButton.MouseEnter,
					function()
						selectAllTransparency(0.85)
					end
				)

				c.AddSignal(
					selectAllButton.MouseLeave,
					function()
						selectAllTransparency(0.9)
					end
				)

				c.AddSignal(
					selectAllButton.MouseButton1Click,
					function()
						-- Get all visible values (filtered by search)
						for _, value in pairs(l.Values) do
							if l.SearchText == "" or value:lower():find(l.SearchText, 1, true) then
								l.Value[value] = true
							end
						end

						-- Update buttons without rebuilding
						for button, buttonData in pairs(l.Buttons) do
							buttonData:UpdateButton()
						end

						l:Display()
						k:SafeCallback(l.Callback, l.Value)
						k:SafeCallback(l.Changed, l.Value)
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
				af:Create(
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
					af:Create(
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
				local hideTween = af:Create(
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
					af:Create(
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

			local A = h.ScrollFrame
			function l.Open(B)
				if l.Opened then
					return
				end
				l.Opened = true
				A.ScrollingEnabled = false
				v.Visible = true
				searchBox.Text = ""
				l.SearchText = ""
				t.CanvasPosition = Vector2.new(0, 0)
				if not dropdownBuilt then
					rebuildDropdown()
				end
				w()
				y()

				-- Arrow rotation animation
				arrowRotation:setGoal(d.Spring.new(180, {frequency = 4, dampingRatio = 0.8}))

				-- Open animation with Back easing
				u.Size = UDim2.fromScale(1, 0.3)
				af:Create(
					u,
					TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
					{Size = UDim2.fromScale(1, 1)}
				):Play()
			end

			function l.Close(B)
				if not l.Opened then
					return
				end
				l.Opened = false
				A.ScrollingEnabled = true

				-- Arrow rotation animation
				arrowRotation:setGoal(d.Spring.new(0, {frequency = 4, dampingRatio = 0.8}))

				local closeTween =
					af:Create(
						u,
						TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In),
						{Size = UDim2.fromScale(1, 0.3)}
					)
				closeTween:Play()
				closeTween.Completed:Connect(
					function()
						v.Visible = false
					end
				)
			end

			function l.Display(B)
				local C, D = l.Values, ""
				local hasSelection = false
				if j.Multi then
					for E, F in next, C do
						if l.Value[F] then
							-- Remove color code for display
							local _, cleanText = parseColorCode(F)
							D = D .. cleanText .. ", "
							hasSelection = true
						end
					end
					D = D:sub(1, #D - 2)
				else
					-- Remove color code for display
					local displayText = l.Value or ""
					if displayText ~= "" then
						local _, cleanText = parseColorCode(displayText)
						displayText = cleanText
					end
					D = displayText
					hasSelection = l.Value ~= nil and l.Value ~= ""
				end
				stopSelectedLabelScroll()
				n.Text = (D == "" and "--" or D)

				-- Animate clear button visibility
				if hasSelection then
					showClearButton()
				else
					hideClearButton()
				end
			end
			function l.GetActiveValues(B)
				if j.Multi then
					local C = {}
					for D, E in next, l.Value do
						table.insert(C, D)
					end
					return C
				else
					return l.Value and 1 or 0
				end
			end
			function l.BuildDropdownList(B)
				local C, D = l.Values, {}
				for E, F in next, t:GetChildren() do
					if not F:IsA "UIListLayout" then
						F:Destroy()
					end
				end
				l.Buttons = {}
				local renderItems = {}
				for _, value in next, C do
					local customColor, cleanText = parseColorCode(value)
					local searchTarget = cleanText:lower()
					if l.SearchText == "" or searchTarget:find(l.SearchText, 1, true) then
						table.insert(renderItems, {Value = value, CustomColor = customColor, CleanText = cleanText})
					end
				end

				local totalItems = #renderItems
				local useVirtual = virtualEnabled and totalItems > virtualThreshold
				local startIndex, endIndex = 1, totalItems
				if useVirtual then
					startIndex = math.max(1, math.floor(t.CanvasPosition.Y / virtualRowHeight) + 1 - virtualBuffer)
					startIndex = math.min(startIndex, math.max(totalItems, 1))
					local visibleCount = math.ceil(math.max(t.AbsoluteSize.Y, 1) / virtualRowHeight) + (virtualBuffer * 2)
					endIndex = math.min(totalItems, startIndex + visibleCount)
					local topHeight = (startIndex - 1) * virtualRowHeight
					if topHeight > 0 then
						e("Frame", {Size = UDim2.new(1, -10, 0, topHeight), BackgroundTransparency = 1, Parent = t})
					end
				end

				local G = 0
				for H = startIndex, endIndex do
					local item = renderItems[H]
					if item then
						local I = item.Value
						local customColor, cleanText = item.CustomColor, item.CleanText
						local J = {}
						G = G + 1

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

						local K, L =
							e(
								"Frame",
								{
									Size = UDim2.fromOffset(5, 14),
									BackgroundColor3 = Color3.fromRGB(76, 194, 255),
									Position = UDim2.fromOffset(-1, 17),
									AnchorPoint = Vector2.new(0, 0.5),
									ThemeTag = {BackgroundColor3 = "Accent"}
								},
								{
									e("UICorner", {CornerRadius = UDim.new(0, 2)}),
									e(
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
						e(
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
							e(
								"Frame",
								{
									Size = UDim2.new(1, -24, 1, 0),
									Position = UDim2.fromOffset(12, 0),
									BackgroundTransparency = 1,
									ClipsDescendants = true
								},
								{L}
							)
						local M, N =
							(e(
								"TextButton",
								{
									Size = UDim2.new(1, -10, 0, 34),
									BackgroundColor3 = bgColor,
									BackgroundTransparency = bgTransparency,
									ClipsDescendants = true,
									ZIndex = 23,
									Text = "",
									Parent = t,
									ThemeTag = customColor and {} or {BackgroundColor3 = "DropdownOption"}
								},
								{
									K,
									labelClip,
									e("UICorner", {CornerRadius = UDim.new(0, 6)}),
									e(
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
						if j.Multi then
							N = l.Value[I]
						else
							N = l.Value == I
						end

						-- ปรับค่า transparency ตามว่ามีสีกำหนดหรือไม่
						local defaultTransparency = customColor and bgTransparency or 1
						local hoverTransparency = customColor and math.max(bgTransparency - 0.2, 0.3) or 0.89
						local selectedTransparency = customColor and math.max(bgTransparency - 0.3, 0.2) or 0.89

						local O, P = c.SpringMotor(defaultTransparency, M, "BackgroundTransparency")
						local Q, R = c.SpringMotor(1, K, "BackgroundTransparency")
						local labelDefaultPosition = UDim2.fromOffset(0, 0)
						local labelDefaultSize = UDim2.fromScale(1, 1)
						local labelScrollTween = nil
						local function stopLabelScroll()
							if labelScrollTween then
								labelScrollTween:Cancel()
								labelScrollTween = nil
							end
							L.TextTruncate = Enum.TextTruncate.AtEnd
							L.Size = labelDefaultSize
							L.Position = labelDefaultPosition
						end
						local function startLabelScroll()
							local visibleWidth = math.max(labelClip.AbsoluteSize.X, 0)
							local textWidth = getTextWidth(L, cleanText) + 6
							if textWidth <= visibleWidth then
								return
							end
							stopLabelScroll()
							L.TextTruncate = Enum.TextTruncate.None
							L.Size = UDim2.fromOffset(textWidth, M.AbsoluteSize.Y)
							local travel = textWidth - visibleWidth
							labelScrollTween =
								af:Create(
									L,
									TweenInfo.new(math.clamp(travel / 35, 1.2, 5), Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0.25),
									{Position = UDim2.fromOffset(-travel, 0)}
								)
							labelScrollTween:Play()
						end
						local S = d.SingleMotor.new(6)
						S:onStep(
							function(T)
								K.Size = UDim2.new(0, 5, 0, T)
							end
						)
						c.AddSignal(
							M.MouseEnter,
							function()
								P(N and selectedTransparency or hoverTransparency)
								startLabelScroll()
							end
						)
						c.AddSignal(
							M.MouseLeave,
							function()
								P(N and selectedTransparency or defaultTransparency)
								stopLabelScroll()
							end
						)
						c.AddSignal(
							M.MouseButton1Down,
							function()
								P(customColor and 0.3 or 0.92)
							end
						)
						c.AddSignal(
							M.MouseButton1Up,
							function()
								P(N and selectedTransparency or hoverTransparency)
							end
						)
						function J.UpdateButton(T)
							if j.Multi then
								N = l.Value[I]
								if N then
									P(selectedTransparency)
								end
							else
								N = l.Value == I
								P(N and selectedTransparency or defaultTransparency)
							end
							S:setGoal(d.Spring.new(N and 16 or 6, {frequency = 6, dampingRatio = 0.8}))
							R(N and 0 or 1)
						end
						L.InputBegan:Connect(
							function(T)
								if
									T.UserInputType == Enum.UserInputType.MouseButton1 or
									T.UserInputType == Enum.UserInputType.Touch
								then
									local U = not N
									if l:GetActiveValues() == 1 and not U and not j.AllowNull then
									else
										if j.Multi then
											N = U
											l.Value[I] = N and true or nil
										else
											N = U
											l.Value = N and I or nil
											for V, W in next, D do
												W:UpdateButton()
											end
										end
										J:UpdateButton()
										l:Display()
										k:SafeCallback(l.Callback, l.Value)
										k:SafeCallback(l.Changed, l.Value)
									end
								end
							end
						)
						J:UpdateButton()
						D[M] = J
						l.Buttons[M] = J
					end
				end
				if useVirtual then
					local bottomHeight = (totalItems - endIndex) * virtualRowHeight
					if bottomHeight > 0 then
						e("Frame", {Size = UDim2.new(1, -10, 0, bottomHeight), BackgroundTransparency = 1, Parent = t})
					end
				end
				l:Display()
				z()
				y()
			end
			function l.SetValues(B, C)
				if C then
					l.Values = C
				end
				t.CanvasPosition = Vector2.new(0, 0)
				dropdownBuilt = false
				if l.Opened then
					rebuildDropdown()
				end
				l:Display()
			end
			function l.OnChanged(B, C)
				l.Changed = C
				C(l.Value)
			end
			function l.SetValue(B, C)
				if l.Multi then
					local D = {}
					if type(C) == "table" then
						for E, F in next, C do
							if F and table.find(l.Values, E) then
								D[E] = true
							end
						end
					end
					l.Value = D
				else
					if not C then
						l.Value = nil
					elseif table.find(l.Values, C) then
						l.Value = C
					end
				end
				dropdownBuilt = false
				if l.Opened then
					rebuildDropdown()
				end
				l:Display()
				k:SafeCallback(l.Callback, l.Value)
				k:SafeCallback(l.Changed, l.Value)
			end
			function l.Destroy(B)
				m:Destroy()
				k.Options[i] = nil
			end
			l:Display()
			local B = {}
			if type(j.Default) == "string" then
				local C = table.find(l.Values, j.Default)
				if C then
					table.insert(B, C)
				end
			elseif type(j.Default) == "table" then
				for C, D in next, j.Default do
					local E = table.find(l.Values, D)
					if E then
						table.insert(B, E)
					end
				end
			elseif type(j.Default) == "number" and l.Values[j.Default] ~= nil then
				table.insert(B, j.Default)
			end
			if next(B) then
				for C = 1, #B do
					local D = B[C]
					if j.Multi then
						l.Value[l.Values[D]] = true
					else
						l.Value = l.Values[D]
					end
					if not j.Multi then
						break
					end
				end
				l:Display()
			end
			k.Options[i] = l
			return l
		end
		return g
	end,
	[23] = function()
		local aa, ab, ac, ad, ae = b(23)
		local af = ab.Parent.Parent
		local ag = ac(af.Creator)
		local ah, ai, aj, c = ag.New, ag.AddSignal, af.Components, {}
		c.__index = c
		c.__type = "Input"
		function c.New(d, e, f)
			local g = d.Library
			assert(f.Title, "Input - Missing Title")
			f.Callback = f.Callback or function()
			end
			local h, i =
				{
					Value = f.Default or "",
					Numeric = f.Numeric or false,
					Finished = f.Finished or false,
					Callback = f.Callback or function(h)
					end,
					Type = "Input"
				},
			ac(aj.Element)(f.Title, f.Description, d.Container, false)
			h.SetTitle = i.SetTitle
			h.SetDesc = i.SetDesc
			h.Frame = i.Frame
			local j = ac(aj.Textbox)(i.Frame, true)
			j.Frame.Position = UDim2.new(1, -10, 0.5, 0)
			j.Frame.AnchorPoint = Vector2.new(1, 0.5)
			j.Frame.Size = UDim2.fromOffset(160, 30)
			j.Input.Text = f.Default or ""
			j.Input.PlaceholderText = f.Placeholder or ""
			local k = j.Input
			function h.SetValue(l, m)
				if f.MaxLength and #m > f.MaxLength then
					m = m:sub(1, f.MaxLength)
				end
				if h.Numeric then
					if (not tonumber(m)) and m:len() > 0 then
						m = h.Value
					end
				end
				h.Value = m
				k.Text = m
				g:SafeCallback(h.Callback, h.Value)
				g:SafeCallback(h.Changed, h.Value)
			end
			if h.Finished then
				ai(
					k.FocusLost,
					function()
						-- Finished inputs should commit when focus leaves for any reason.
						-- Roblox only sets this event argument for Enter, so requiring it
						-- made clicks/taps outside the field silently discard the value.
						h:SetValue(k.Text)
					end
				)
			else
				ai(
					k:GetPropertyChangedSignal "Text",
					function()
						h:SetValue(k.Text)
					end
				)
			end
			function h.OnChanged(l, m)
				h.Changed = m
				m(h.Value)
			end
			function h.Destroy(l)
				i:Destroy()
				g.Options[e] = nil
			end
			g.Options[e] = h
			return h
		end
		return c
	end,
	[24] = function()
		local aa, ab, ac, ad, ae = b(24)
		local af, ag = game:GetService "UserInputService", ab.Parent.Parent
		local ah = ac(ag.Creator)
		local ai, aj, c = ah.New, ag.Components, {}
		c.__index = c
		c.__type = "Keybind"
		function c.New(d, e, f)
			local g = d.Library
			assert(f.Title, "KeyBind - Missing Title")
			assert(f.Default, "KeyBind - Missing default value.")
			local h, i, j =
				{
					Value = f.Default,
					Toggled = false,
					Mode = f.Mode or "Toggle",
					Type = "Keybind",
					Callback = f.Callback or function(h)
					end,
					ChangedCallback = f.ChangedCallback or function(h)
					end
				},
			false,
			ac(aj.Element)(f.Title, f.Description, d.Container, true)
			h.SetTitle = j.SetTitle
			h.SetDesc = j.SetDesc
			h.Frame = j.Frame
			local k =
				ai(
					"TextLabel",
					{
						FontFace = Font.new(
							"rbxasset://fonts/families/GothamSSm.json",
							Enum.FontWeight.Regular,
							Enum.FontStyle.Normal
						),
						Text = f.Default,
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
			local l =
				ai(
					"TextButton",
					{
						Size = UDim2.fromOffset(0, 30),
						Position = UDim2.new(1, -10, 0.5, 0),
						AnchorPoint = Vector2.new(1, 0.5),
						BackgroundTransparency = 0.9,
						Parent = j.Frame,
						AutomaticSize = Enum.AutomaticSize.X,
						ThemeTag = {BackgroundColor3 = "Keybind"}
					},
					{
						ai("UICorner", {CornerRadius = UDim.new(0, 5)}),
						ai("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}),
						ai(
							"UIStroke",
							{
								Transparency = 0.5,
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								ThemeTag = {Color = "InElementBorder"}
							}
						),
						k
					}
				)
			function h.GetState(m)
				if af:GetFocusedTextBox() and h.Mode ~= "Always" then
					return false
				end
				if h.Mode == "Always" then
					return true
				elseif h.Mode == "Hold" then
					if h.Value == "None" then
						return false
					end
					local n = h.Value
					if n == "MouseLeft" or n == "MouseRight" then
						return n == "MouseLeft" and af:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or
							n == "MouseRight" and af:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
					else
						return af:IsKeyDown(Enum.KeyCode[h.Value])
					end
				else
					return h.Toggled
				end
			end
			function h.SetValue(m, n, o)
				n = n or h.Key
				o = o or h.Mode
				k.Text = n
				h.Value = n
				h.Mode = o
			end
			function h.OnClick(m, n)
				h.Clicked = n
			end
			function h.OnChanged(m, n)
				h.Changed = n
				n(h.Value)
			end
			function h.DoClick(m)
				g:SafeCallback(h.Callback, h.Toggled)
				g:SafeCallback(h.Clicked, h.Toggled)
			end
			function h.Destroy(m)
				j:Destroy()
				g.Options[e] = nil
			end
			ah.AddSignal(
				l.InputBegan,
				function(m)
					if m.UserInputType == Enum.UserInputType.MouseButton1 or m.UserInputType == Enum.UserInputType.Touch then
						i = true
						k.Text = "..."
						wait(0.2)
						local n
						n =
							af.InputBegan:Connect(
								function(o)
									local p
									if o.UserInputType == Enum.UserInputType.Keyboard then
										p = o.KeyCode.Name
									elseif o.UserInputType == Enum.UserInputType.MouseButton1 then
										p = "MouseLeft"
									elseif o.UserInputType == Enum.UserInputType.MouseButton2 then
										p = "MouseRight"
									end
									local s
									s =
									af.InputEnded:Connect(
										function(t)
											if
												t.KeyCode.Name == p or
												p == "MouseLeft" and t.UserInputType == Enum.UserInputType.MouseButton1 or
												p == "MouseRight" and t.UserInputType == Enum.UserInputType.MouseButton2
											then
												i = false
												k.Text = p
												h.Value = p
												g:SafeCallback(h.ChangedCallback, t.KeyCode or t.UserInputType)
												g:SafeCallback(h.Changed, t.KeyCode or t.UserInputType)
												n:Disconnect()
												s:Disconnect()
											end
										end
									)
								end
							)
					end
				end
			)
			ah.AddSignal(
				af.InputBegan,
				function(m)
					if not i and not af:GetFocusedTextBox() then
						if h.Mode == "Toggle" then
							local n = h.Value
							if n == "MouseLeft" or n == "MouseRight" then
								if
									n == "MouseLeft" and m.UserInputType == Enum.UserInputType.MouseButton1 or
									n == "MouseRight" and m.UserInputType == Enum.UserInputType.MouseButton2
								then
									h.Toggled = not h.Toggled
									h:DoClick()
								end
							elseif m.UserInputType == Enum.UserInputType.Keyboard then
								if m.KeyCode.Name == n then
									h.Toggled = not h.Toggled
									h:DoClick()
								end
							end
						end
					end
				end
			)
			g.Options[e] = h
			return h
		end
		return c
	end,
	[25] = function()
		local aa, ab, ac, ad, ae = b(25)
		local af = ab.Parent.Parent
		local ag, ah, ai, aj = af.Components, ac(af.Packages.Flipper), ac(af.Creator), {}
		aj.__index = aj
		aj.__type = "Paragraph"
		function aj.New(c, d)
			assert(d.Title, "Paragraph - Missing Title")
			d.Content = d.Content or ""
			local e = ac(ag.Element)(d.Title, d.Content, aj.Container, false)
			e.Frame.BackgroundTransparency = 0.92
			e.Border.Transparency = 0.6
			return e
		end
		return aj
	end,
	[26] = function()
		local aa, ab, ac, ad, ae = b(26)
		local af, ag = game:GetService "UserInputService", ab.Parent.Parent
		local ah = ac(ag.Creator)
		local ai, aj, c = ah.New, ag.Components, {}
		c.__index = c
		c.__type = "Slider"
		function c.New(d, e, f)
			local g = d.Library
			assert(f.Title, "Slider - Missing Title.")
			assert(f.Default, "Slider - Missing default value.")
			assert(f.Min, "Slider - Missing minimum value.")
			assert(f.Max, "Slider - Missing maximum value.")
			assert(f.Rounding, "Slider - Missing rounding value.")
			local h, i, j =
				{
					Value = nil,
					Min = f.Min,
					Max = f.Max,
					Rounding = f.Rounding,
					Callback = f.Callback or function(h)
					end,
					Type = "Slider"
				},
			false,
			ac(aj.Element)(f.Title, f.Description, d.Container, false)
			j.DescLabel.Size = UDim2.new(1, -170, 0, 14)
			h.SetTitle = j.SetTitle
			h.SetDesc = j.SetDesc
			h.Frame = j.Frame
			local k =
				ai(
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
			local l, m, n =
				ai(
					"Frame",
					{BackgroundTransparency = 1, Position = UDim2.fromOffset(7, 0), Size = UDim2.new(1, -14, 1, 0)},
					{k}
				),
			ai(
				"Frame",
				{Size = UDim2.new(0, 0, 1, 0), ThemeTag = {BackgroundColor3 = "Accent"}},
				{ai("UICorner", {CornerRadius = UDim.new(1, 0)})}
			),
			ai(
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

			local o =
				ai(
					"Frame",
					{
						Size = UDim2.new(1, 0, 0, 4),
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -10, 0.5, 0),
						BackgroundTransparency = 0.4,
						Parent = j.Frame,
						ThemeTag = {BackgroundColor3 = "SliderRail"}
					},
					{
						ai("UICorner", {CornerRadius = UDim.new(1, 0)}),
						ai("UISizeConstraint", {MaxSize = Vector2.new(150, math.huge)}),
						n,
						m,
						l
					}
				)

			-- ถ้ามีการพิมพ์อยู่ หยุดการ drag ไว้
			local editingNumber = false

			-- ถ้าคลิกที่ไอคอน จะเริ่ม drag (เหมือนเดิม)
			ah.AddSignal(
				k.InputBegan,
				function(p)
					if p.UserInputType == Enum.UserInputType.MouseButton1 or p.UserInputType == Enum.UserInputType.Touch then
						i = true
					end
				end
			)
			ah.AddSignal(
				k.InputEnded,
				function(p)
					if p.UserInputType == Enum.UserInputType.MouseButton1 or p.UserInputType == Enum.UserInputType.Touch then
						i = false
					end
				end
			)

			-- ขณะพิมพ์ หยุดตอบสนองการลาก
			n.Focused:Connect(
				function()
					editingNumber = true
					-- ป้องกันค่า i (drag) ขณะพิมพ์
					i = false
				end
			)

			n.FocusLost:Connect(
				function(enterPressed)
					editingNumber = false
					-- ถ้ากด Enter หรือคลิกออก ให้อ่านค่าและอัปเดต slider
					local text = n.Text
					-- support comma เป็นจุดทศนิยมด้วย (เช่น "1,5")
					text = tostring(text):gsub(",", ".")
					local num = tonumber(text)
					if num then
						local newVal = g:Round(math.clamp(num, h.Min, h.Max), h.Rounding)
						h:SetValue(newVal)
					else
						-- revert to current value
						if h.Value ~= nil then
							n.Text = tostring(h.Value)
						else
							n.Text = tostring(f.Default)
						end
					end
				end
			)

			ah.AddSignal(
				af.InputChanged,
				function(p)
					if editingNumber then
						return
					end
					if
						i and
						(p.UserInputType == Enum.UserInputType.MouseMovement or
							p.UserInputType == Enum.UserInputType.Touch)
					then
						local s = math.clamp((p.Position.X - l.AbsolutePosition.X) / l.AbsoluteSize.X, 0, 1)
						h:SetValue(h.Min + ((h.Max - h.Min) * s))
					end
				end
			)
			function h.OnChanged(p, s)
				h.Changed = s
				s(h.Value)
			end
			function h.SetValue(p, s)
				p.Value = g:Round(math.clamp(s, h.Min, h.Max), h.Rounding)
				k.Position = UDim2.new((p.Value - h.Min) / (h.Max - h.Min), -7, 0.5, 0)
				m.Size = UDim2.fromScale((p.Value - h.Min) / (h.Max - h.Min), 1)
				-- อัปเดตข้อความใน TextBox ให้ตรงค่า
				n.Text = tostring(p.Value)
				g:SafeCallback(h.Callback, p.Value)
				g:SafeCallback(h.Changed, p.Value)
			end
			function h.Destroy(p)
				j:Destroy()
				g.Options[e] = nil
			end
			h:SetValue(f.Default)
			g.Options[e] = h
			return h
		end
		return c
	end,
	[27] = function()
		local aa, ab, ac, ad, ae = b(27)
		local af, ag = game:GetService "TweenService", ab.Parent.Parent
		local ah = ac(ag.Creator)
		local ai, aj, c = ah.New, ag.Components, {}
		c.__index = c
		c.__type = "Toggle"
		function c.New(d, e, f)
			local g = d.Library
			assert(f.Title, "Toggle - Missing Title")
			local h, i =
				{
					Value = f.Default or false,
					Callback = f.Callback or function(h)
					end,
					Type = "Toggle"
				},
			ac(aj.Element)(f.Title, f.Description, d.Container, true)
			i.DescLabel.Size = UDim2.new(1, -54, 0, 14)
			h.SetTitle = i.SetTitle
			h.SetDesc = i.SetDesc
			h.Frame = i.Frame
			local j, k =
				ai(
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
			ai("UIStroke", {Transparency = 0.5, ThemeTag = {Color = "ToggleSlider"}})
			local l =
				ai(
					"Frame",
					{
						Size = UDim2.fromOffset(36, 18),
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -10, 0.5, 0),
						Parent = i.Frame,
						BackgroundTransparency = 1,
						ThemeTag = {BackgroundColor3 = "Accent"}
					},
					{ai("UICorner", {CornerRadius = UDim.new(0, 9)}), k, j}
				)
			function h.OnChanged(m, n)
				h.Changed = n
				n(h.Value)
			end
			function h.SetValue(m, n)
				n = not (not n)
				h.Value = n
				ah.OverrideTag(k, {Color = h.Value and "Accent" or "ToggleSlider"})
				ah.OverrideTag(j, {ImageColor3 = h.Value and "ToggleToggled" or "ToggleSlider"})
				af:Create(
					j,
					TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
					{Position = UDim2.new(0, h.Value and 19 or 2, 0.5, 0)}
				):Play()
				af:Create(
					l,
					TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
					{BackgroundTransparency = h.Value and 0 or 1}
				):Play()
				j.ImageTransparency = h.Value and 0 or 0.5
				g:SafeCallback(h.Callback, h.Value)
				g:SafeCallback(h.Changed, h.Value)
			end
			function h.Destroy(m)
				i:Destroy()
				g.Options[e] = nil
			end
			ah.AddSignal(
				i.Frame.MouseButton1Click,
				function()
					h:SetValue(not h.Value)
				end
			)
			h:SetValue(h.Value)
			g.Options[e] = h
			return h
		end
		return c
	end,
	[28] = function()
		local aa, ab, ac, ad, ae = b(28)
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
		local aa, ab, ac, ad, ae = b(30)
		local af = {
			SingleMotor = ac(ab.SingleMotor),
			GroupMotor = ac(ab.GroupMotor),
			Instant = ac(ab.Instant),
			Linear = ac(ab.Linear),
			Spring = ac(ab.Spring),
			isMotor = ac(ab.isMotor)
		}
		return af
	end,
	[31] = function()
		local aa, ab, ac, ad, ae = b(31)
		local af, ag, ah, ai = game:GetService "RunService", ac(ab.Parent.Signal), function()
		end, {}
		ai.__index = ai
		function ai.new()
			return setmetatable({_onStep = ag.new(), _onStart = ag.new(), _onComplete = ag.new()}, ai)
		end
		function ai.onStep(aj, c)
			return aj._onStep:connect(c)
		end
		function ai.onStart(aj, c)
			return aj._onStart:connect(c)
		end
		function ai.onComplete(aj, c)
			return aj._onComplete:connect(c)
		end
		function ai.start(aj)
			if not aj._connection then
				aj._connection =
					af.RenderStepped:Connect(
						function(c)
							aj:step(c)
						end
					)
			end
		end
		function ai.stop(aj)
			if aj._connection then
				aj._connection:Disconnect()
				aj._connection = nil
			end
		end
		ai.destroy = ai.stop
		ai.step = ah
		ai.getValue = ah
		ai.setGoal = ah
		function ai.__tostring(aj)
			return "Motor"
		end
		return ai
	end,
	[32] = function()
		local aa, ab, ac, ad, ae = b(32)
		return function()
			local af, ag = game:GetService "RunService", ac(ab.Parent.BaseMotor)
			describe(
				"connection management",
				function()
					local ah = ag.new()
					it(
						"should hook up connections on :start()",
						function()
							ah:start()
							expect(typeof(ah._connection)).to.equal "RBXScriptConnection"
						end
					)
					it(
						"should remove connections on :stop() or :destroy()",
						function()
							ah:stop()
							expect(ah._connection).to.equal(nil)
						end
					)
				end
			)
			it(
				"should call :step() with deltaTime",
				function()
					local ah, ai = (ag.new())
					function ah.step(aj, ...)
						ai = {...}
						ah:stop()
					end
					ah:start()
					local aj = af.RenderStepped:Wait()
					af.RenderStepped:Wait()
					expect(ai).to.be.ok()
					expect(ai[1]).to.equal(aj)
				end
			)
		end
	end,
	[33] = function()
		local aa, ab, ac, ad, ae = b(33)
		local af, ag, ah = ac(ab.Parent.BaseMotor), ac(ab.Parent.SingleMotor), ac(ab.Parent.isMotor)
		local ai = setmetatable({}, af)
		ai.__index = ai
		local aj = function(aj)
			if ah(aj) then
				return aj
			end
			local c = typeof(aj)
			if c == "number" then
				return ag.new(aj, false)
			elseif c == "table" then
				return ai.new(aj, false)
			end
			error(("Unable to convert %q to motor; type %s is unsupported"):format(aj, c), 2)
		end
		function ai.new(c, d)
			assert(c, "Missing argument #1: initialValues")
			assert(typeof(c) == "table", "initialValues must be a table!")
			assert(
				not c.step,
				[[initialValues contains disallowed property "step". Did you mean to put a table of values here?]]
			)
			local e = setmetatable(af.new(), ai)
			if d ~= nil then
				e._useImplicitConnections = d
			else
				e._useImplicitConnections = true
			end
			e._complete = true
			e._motors = {}
			for f, g in pairs(c) do
				e._motors[f] = aj(g)
			end
			return e
		end
		function ai.step(c, d)
			if c._complete then
				return true
			end
			local e = true
			for f, g in pairs(c._motors) do
				local h = g:step(d)
				if not h then
					e = false
				end
			end
			c._onStep:fire(c:getValue())
			if e then
				if c._useImplicitConnections then
					c:stop()
				end
				c._complete = true
				c._onComplete:fire()
			end
			return e
		end
		function ai.setGoal(c, d)
			assert(
				not d.step,
				[[goals contains disallowed property "step". Did you mean to put a table of goals here?]]
			)
			c._complete = false
			c._onStart:fire()
			for e, f in pairs(d) do
				local g = assert(c._motors[e], ("Unknown motor for key %s"):format(e))
				g:setGoal(f)
			end
			if c._useImplicitConnections then
				c:start()
			end
		end
		function ai.getValue(c)
			local d = {}
			for e, f in pairs(c._motors) do
				d[e] = f:getValue()
			end
			return d
		end
		function ai.__tostring(c)
			return "Motor(Group)"
		end
		return ai
	end,
	[34] = function()
		local aa, ab, ac, ad, ae = b(34)
		return function()
			local af, ag, ah = ac(ab.Parent.GroupMotor), ac(ab.Parent.Instant), ac(ab.Parent.Spring)
			it(
				"should complete when all child motors are complete",
				function()
					local ai = af.new({A = 1, B = 2}, false)
					expect(ai._complete).to.equal(true)
					ai:setGoal {A = ag.new(3), B = ah.new(4, {frequency = 7.5, dampingRatio = 1})}
					expect(ai._complete).to.equal(false)
					ai:step(1.6666666666666665E-2)
					expect(ai._complete).to.equal(false)
					for aj = 1, 30 do
						ai:step(1.6666666666666665E-2)
					end
					expect(ai._complete).to.equal(true)
				end
			)
			it(
				"should start when the goal is set",
				function()
					local ai, aj = af.new({A = 0}, false), false
					ai:onStart(
						function()
							aj = not aj
						end
					)
					ai:setGoal {A = ag.new(1)}
					expect(aj).to.equal(true)
					ai:setGoal {A = ag.new(1)}
					expect(aj).to.equal(false)
				end
			)
			it(
				"should properly return all values",
				function()
					local ai = af.new({A = 1, B = 2}, false)
					local aj = ai:getValue()
					expect(aj.A).to.equal(1)
					expect(aj.B).to.equal(2)
				end
			)
			it(
				"should error when a goal is given to GroupMotor.new",
				function()
					local ai =
						pcall(
							function()
								af.new(ag.new(0))
							end
						)
					expect(ai).to.equal(false)
				end
			)
			it(
				[[should error when a single goal is provided to GroupMotor:step]],
				function()
					local ai =
						pcall(
							function()
								af.new {a = 1}:setGoal(ag.new(0))
							end
						)
					expect(ai).to.equal(false)
				end
			)
		end
	end,
	[35] = function()
		local aa, ab, ac, ad, ae = b(35)
		local af = {}
		af.__index = af
		function af.new(ag)
			return setmetatable({_targetValue = ag}, af)
		end
		function af.step(ag)
			return {complete = true, value = ag._targetValue}
		end
		return af
	end,
	[36] = function()
		local aa, ab, ac, ad, ae = b(36)
		return function()
			local af = ac(ab.Parent.Instant)
			it(
				"should return a completed state with the provided value",
				function()
					local ag = af.new(1.23)
					local ah = ag:step(0.1, {value = 0, complete = false})
					expect(ah.complete).to.equal(true)
					expect(ah.value).to.equal(1.23)
				end
			)
		end
	end,
	[37] = function()
		local aa, ab, ac, ad, ae = b(37)
		local af = {}
		af.__index = af
		function af.new(ag, ah)
			assert(ag, "Missing argument #1: targetValue")
			ah = ah or {}
			return setmetatable({_targetValue = ag, _velocity = ah.velocity or 1}, af)
		end
		function af.step(ag, ah, ai)
			local aj, c, d = ah.value, ag._velocity, ag._targetValue
			local e = ai * c
			local f = e >= math.abs(d - aj)
			aj = aj + e * (d > aj and 1 or -1)
			if f then
				aj = ag._targetValue
				c = 0
			end
			return {complete = f, value = aj, velocity = c}
		end
		return af
	end,
	[38] = function()
		local aa, ab, ac, ad, ae = b(38)
		return function()
			local af, ag = ac(ab.Parent.SingleMotor), ac(ab.Parent.Linear)
			describe(
				"completed state",
				function()
					local ah, ai = af.new(0, false), ag.new(1, {velocity = 1})
					ah:setGoal(ai)
					for aj = 1, 60 do
						ah:step(1.6666666666666665E-2)
					end
					it(
						"should complete",
						function()
							expect(ah._state.complete).to.equal(true)
						end
					)
					it(
						"should be exactly the goal value when completed",
						function()
							expect(ah._state.value).to.equal(1)
						end
					)
				end
			)
			describe(
				"uncompleted state",
				function()
					local ah, ai = af.new(0, false), ag.new(1, {velocity = 1})
					ah:setGoal(ai)
					for aj = 1, 59 do
						ah:step(1.6666666666666665E-2)
					end
					it(
						"should be uncomplete",
						function()
							expect(ah._state.complete).to.equal(false)
						end
					)
				end
			)
			describe(
				"negative velocity",
				function()
					local ah, ai = af.new(1, false), ag.new(0, {velocity = 1})
					ah:setGoal(ai)
					for aj = 1, 60 do
						ah:step(1.6666666666666665E-2)
					end
					it(
						"should complete",
						function()
							expect(ah._state.complete).to.equal(true)
						end
					)
					it(
						"should be exactly the goal value when completed",
						function()
							expect(ah._state.value).to.equal(0)
						end
					)
				end
			)
		end
	end,
	[39] = function()
		local aa, ab, ac, ad, ae = b(39)
		local af = {}
		af.__index = af
		function af.new(ag, ah)
			return setmetatable({signal = ag, connected = true, _handler = ah}, af)
		end
		function af.disconnect(ag)
			if ag.connected then
				ag.connected = false
				for ah, ai in pairs(ag.signal._connections) do
					if ai == ag then
						table.remove(ag.signal._connections, ah)
						return
					end
				end
			end
		end
		local ag = {}
		ag.__index = ag
		function ag.new()
			return setmetatable({_connections = {}, _threads = {}}, ag)
		end
		function ag.fire(ah, ...)
			for ai, aj in pairs(ah._connections) do
				aj._handler(...)
			end
			for c, d in pairs(ah._threads) do
				coroutine.resume(d, ...)
			end
			ah._threads = {}
		end
		function ag.connect(ah, aj)
			local c = af.new(ah, aj)
			table.insert(ah._connections, c)
			return c
		end
		function ag.wait(ah)
			table.insert(ah._threads, coroutine.running())
			return coroutine.yield()
		end
		return ag
	end,
	[40] = function()
		local aa, ab, ac, ad, ae = b(40)
		return function()
			local af = ac(ab.Parent.Signal)
			it(
				"should invoke all connections, instantly",
				function()
					local ag, ah, aj = (af.new())
					ag:connect(
						function(c)
							ah = c
						end
					)
					ag:connect(
						function(c)
							aj = c
						end
					)
					ag:fire "hello"
					expect(ah).to.equal "hello"
					expect(aj).to.equal "hello"
				end
			)
			it(
				"should return values when :wait() is called",
				function()
					local ag = af.new()
					spawn(
						function()
							ag:fire(123, "hello")
						end
					)
					local ah, aj = ag:wait()
					expect(ah).to.equal(123)
					expect(aj).to.equal "hello"
				end
			)
			it(
				"should properly handle disconnections",
				function()
					local ag, ah = af.new(), false
					local aj =
						ag:connect(
							function()
								ah = true
							end
						)
					aj:disconnect()
					ag:fire()
					expect(ah).to.equal(false)
				end
			)
		end
	end,
	[41] = function()
		local aa, ab, ac, ad, ae = b(41)
		local af = ac(ab.Parent.BaseMotor)
		local ag = setmetatable({}, af)
		ag.__index = ag
		function ag.new(ah, aj)
			assert(ah, "Missing argument #1: initialValue")
			assert(typeof(ah) == "number", "initialValue must be a number!")
			local c = setmetatable(af.new(), ag)
			if aj ~= nil then
				c._useImplicitConnections = aj
			else
				c._useImplicitConnections = true
			end
			c._goal = nil
			c._state = {complete = true, value = ah}
			return c
		end
		function ag.step(ah, aj)
			if ah._state.complete then
				return true
			end
			local c = ah._goal:step(ah._state, aj)
			ah._state = c
			ah._onStep:fire(c.value)
			if c.complete then
				if ah._useImplicitConnections then
					ah:stop()
				end
				ah._onComplete:fire()
			end
			return c.complete
		end
		function ag.getValue(ah)
			return ah._state.value
		end
		function ag.setGoal(ah, aj)
			ah._state.complete = false
			ah._goal = aj
			ah._onStart:fire()
			if ah._useImplicitConnections then
				ah:start()
			end
		end
		function ag.__tostring(ah)
			return "Motor(Single)"
		end
		return ag
	end,
	[42] = function()
		local aa, ab, ac, ad, ae = b(42)
		return function()
			local af, ag = ac(ab.Parent.SingleMotor), ac(ab.Parent.Instant)
			it(
				"should assign new state on step",
				function()
					local ah = af.new(0, false)
					ah:setGoal(ag.new(5))
					ah:step(1.6666666666666665E-2)
					expect(ah._state.complete).to.equal(true)
					expect(ah._state.value).to.equal(5)
				end
			)
			it(
				[[should invoke onComplete listeners when the goal is completed]],
				function()
					local ah, aj = af.new(0, false), false
					ah:onComplete(
						function()
							aj = true
						end
					)
					ah:setGoal(ag.new(5))
					ah:step(1.6666666666666665E-2)
					expect(aj).to.equal(true)
				end
			)
			it(
				"should start when the goal is set",
				function()
					local ah, aj = af.new(0, false), false
					ah:onStart(
						function()
							aj = not aj
						end
					)
					ah:setGoal(ag.new(5))
					expect(aj).to.equal(true)
					ah:setGoal(ag.new(5))
					expect(aj).to.equal(false)
				end
			)
		end
	end,
	[43] = function()
		local aa, ab, ac, ad, ae = b(43)
		local af, ag, ah, aj = 0.001, 0.001, 0.0001, {}
		aj.__index = aj
		function aj.new(c, d)
			assert(c, "Missing argument #1: targetValue")
			d = d or {}
			return setmetatable(
				{_targetValue = c, _frequency = d.frequency or 4, _dampingRatio = d.dampingRatio or 1},
				aj
			)
		end
		function aj.step(c, d, e)
			local f, g, h, i, j = c._dampingRatio, c._frequency * 2 * math.pi, c._targetValue, d.value, d.velocity or 0
			local k, l, m, n = i - h, (math.exp(-f * g * e))
			if f == 1 then
				m = (k * (1 + g * e) + j * e) * l + h
				n = (j * (1 - g * e) - k * (g * g * e)) * l
			elseif f < 1 then
				local o = math.sqrt(1 - f * f)
				local p, s, t = math.cos(g * o * e), (math.sin(g * o * e))
				if o > ah then
					t = s / o
				else
					local u = e * g
					t = u + ((u * u) * (o * o) * (o * o) / 20 - o * o) * (u * u * u) / 6
				end
				local u
				if g * o > ah then
					u = s / (g * o)
				else
					local v = g * o
					u = e + ((e * e) * (v * v) * (v * v) / 20 - v * v) * (e * e * e) / 6
				end
				m = (k * (p + f * t) + j * u) * l + h
				n = (j * (p - t * f) - k * (t * g)) * l
			else
				local o = math.sqrt(f * f - 1)
				local p, s = -g * (f - o), -g * (f + o)
				local t = (j - k * p) / (2 * g * o)
				local u = k - t
				local v, w = u * math.exp(p * e), t * math.exp(s * e)
				m = v + w + h
				n = v * p + w * s
			end
			local o = math.abs(n) < af and math.abs(m - h) < ag
			return {complete = o, value = o and h or m, velocity = n}
		end
		return aj
	end,
	[44] = function()
		local aa, ab, ac, ad, ae = b(44)
		return function()
			local af, ag = ac(ab.Parent.SingleMotor), ac(ab.Parent.Spring)
			describe(
				"completed state",
				function()
					local ah, aj = af.new(0, false), ag.new(1, {frequency = 2, dampingRatio = 0.75})
					ah:setGoal(aj)
					for c = 1, 100 do
						ah:step(1.6666666666666665E-2)
					end
					it(
						"should complete",
						function()
							expect(ah._state.complete).to.equal(true)
						end
					)
					it(
						"should be exactly the goal value when completed",
						function()
							expect(ah._state.value).to.equal(1)
						end
					)
				end
			)
			it(
				"should inherit velocity",
				function()
					local ah = af.new(0, false)
					ah._state = {complete = false, value = 0, velocity = -5}
					local aj = ag.new(1, {frequency = 2, dampingRatio = 1})
					ah:setGoal(aj)
					ah:step(1.6666666666666665E-2)
					expect(ah._state.velocity < 0).to.equal(true)
				end
			)
		end
	end,
	[45] = function()
		local aa, ab, ac, ad, ae = b(45)
		local af = function(af)
			local ag = tostring(af):match "^Motor%((.+)%)$"
			if ag then
				return true, ag
			else
				return false
			end
		end
		return af
	end,
	[46] = function()
		local aa, ab, ac, ad, ae = b(46)
		return function()
			local af, ag, ah = ac(ab.Parent.isMotor), ac(ab.Parent.SingleMotor), ac(ab.Parent.GroupMotor)
			local aj, c = ag.new(0), ah.new {}
			it(
				"should properly detect motors",
				function()
					expect(af(aj)).to.equal(true)
					expect(af(c)).to.equal(true)
				end
			)
			it(
				"shouldn't detect things that aren't motors",
				function()
					expect(af {}).to.equal(false)
				end
			)
			it(
				"should return the proper motor type",
				function()
					local d, e = af(aj)
					local f, g = af(c)
					expect(e).to.equal "Single"
					expect(g).to.equal "Group"
				end
			)
		end
	end,
	[47] = function()
		local aa, ab, ac, ad, ae = b(47)
		local af = {
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
		for ag, ah in next, ab:GetChildren() do
			local aj = ac(ah)
			af[aj.Name] = aj
		end
		return af
	end,
	[48] = function()
		local aa, ab, ac, ad, ae = b(48)
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
		local aa, ab, ac, ad, ae = b(49)
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
		local aa, ab, ac, ad, ae = b(50)
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
		local aa, ab, ac, ad, ae = b(51)
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
		local aa, ab, ac, ad, ae = b(52)
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
		local aa, ab, ac, ad, ae = b(53)
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
		local aa, ab, ac, ad, ae = b(54)
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
		local aa, ab, ac, ad, ae = b(55)
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
		local aa, ab, ac, ad, ae = b(56)
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
		local aa, ab, ac, ad, ae = b(57)
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
		local aa, ab, ac, ad, ae = b(58)
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
		local aa, ab, ac, ad, ae = b(59)
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
		local aa, ab, ac, ad, ae = b(60)
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
		local aa, ab, ac, ad, ae = b(61)
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
		local aa, ab, ac, ad, ae = b(62)
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
		local aa, ab, ac, ad, ae = b(63)
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
		local aa, ab, ac, ad, ae = b(64)
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
		local aa, ab, ac, ad, ae = b(65)
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
		local aa, ab, ac, ad, ae = b(66)
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
		local aa, ab, ac, ad, ae = b(67)
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
		local aa, ab, ac, ad, ae = b(68)
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
	local ab, ac, ad, ae, af, ag, ah, aj, c, e, f, g, h, i, j, k =
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
	local l, m, n, o, p, s, t, u, v, w, x = ah.insert, ah.remove, ah.freeze or function(l)
		return l
	end, ab and ab.defer or function(l, ...)
		local m = c.create(l)
		c.resume(m, ...)
		return m
	end, "0.0.0-venv", {}, {}, {}, {}, {}, {}
	local y, z = {
		GetChildren = function(y)
			local z, A = x[y], {}
			for B in ag, z do
				l(A, B)
			end
			return A
		end,
		FindFirstChild = function(y, z)
			if not z then
				ad("Argument 1 missing or nil", 2)
			end
			for A in ag, x[y] do
				if A.Name == z then
					return A
				end
			end
			return
		end,
		GetFullName = function(y)
			local z, A = y.Name, y.Parent
			while A do
				z = A.Name .. "." .. z
				A = A.Parent
			end
			return "VirtualEnv." .. z
		end
	},
	{}
	for A, B in ag, y do
		z[A] = function(C, ...)
			if not x[C] then
				ad("Expected ':' not '.' calling member function " .. A, 1)
			end
			return B(C, ...)
		end
	end
	local C = function(C, D, E)
		local F, G, H, I, J = ac({}, {__mode = "k"}), function(F)
			ad(F .. " is not a valid (virtual) member of " .. C .. " \"" .. D .. "\"", 1)
		end, function(F)
			ad("Unable to assign (virtual) property " .. F .. ". Property is read only", 1)
		end, (ae(true))
		local K = af(I)
		K.__index = function(L, M)
			if M == "ClassName" then
				return C
			elseif M == "Name" then
				return D
			elseif M == "Parent" then
				return E
			elseif C == "StringValue" and M == "Value" then
				return J
			else
				local N = z[M]
				if N then
					return N
				end
			end
			for N in ag, F do
				if N.Name == M then
					return N
				end
			end
			G(M)
		end
		K.__newindex = function(L, M, N)
			if M == "ClassName" then
				H(M)
			elseif M == "Name" then
				D = N
			elseif M == "Parent" then
				if N == I then
					return
				end
				if E ~= nil then
					x[E][I] = nil
				end
				E = N
				if N ~= nil then
					x[N][I] = true
				end
			elseif C == "StringValue" and M == "Value" then
				J = N
			else
				G(M)
			end
		end
		K.__tostring = function()
			return D
		end
		x[I] = F
		if E ~= nil then
			x[E][I] = true
		end
		return I
	end
	local function D(E, F)
		local G, H, I, J = E[1], E[2], E[3], E[4]
		local K = m(I, 1)
		local L = C(H, K, F)
		s[G] = L
		if I then
			for M, N in ag, I do
				L[M] = N
			end
		end
		if J then
			for M, N in ag, J do
				D(N, L)
			end
		end
		return L
	end
	local E = {}
	for F, G in ag, a do
		l(E, D(G))
	end
	for H, I in ag, aa do
		local J = s[H]
		t[J] = I
		local K = J.ClassName
		if K == "LocalScript" or K == "Script" then
			l(v, J)
		end
	end
	local J = function(J)
		local K, L = J.ClassName, u[J]
		if L and K == "ModuleScript" then
			return aj(L)
		end
		local M = t[J]
		if not M then
			return
		end
		if K == "LocalScript" or K == "Script" then
			M()
			return
		else
			local N = {M()}
			u[J] = N
			return aj(N)
		end
	end
	function b(K)
		local L = s[K]
		local M = t[L]
		if not M then
			return
		end
		local N, O, P, Q, R, S, T =
			false,
		n {
			Version = p,
			Script = e,
			Shared = w,
			GetScript = function()
				return e
			end,
			GetShared = function()
				return w
			end
		},
		L,
		function(N, ...)
			if x[N] and N.ClassName == "ModuleScript" and t[N] then
				return J(N)
			end
			return g(N, ...)
		end
		local U, V = function(U, ...)
			if not N then
				T()
			end
			if f(U) == "number" and U >= 0 then
				if U == 0 then
					return S
				else
					U = U + 1
					local V, W = h(i, U)
					if V and W == R then
						return S
					end
				end
			end
			return i(U, ...)
		end, function(U, V, ...)
			if not N then
				T()
			end
			if f(U) == "number" and U >= 0 then
				if U == 0 then
					return j(S, V)
				else
					U = U + 1
					local W, X = h(i, U)
					if W and X == R then
						return j(S, V)
					end
				end
			end
			return j(U, V, ...)
		end
		function T()
			R = i(0)
			local W = {maui = O, script = P, require = Q, getfenv = U, setfenv = V}
			S =
				ac(
					{},
					{
						__index = function(X, Y)
							local Z = k(S, Y)
							if Z ~= nil then
								return Z
							end
							local _ = W[Y]
							if _ ~= nil then
								return _
							end
							return R[Y]
						end
					}
				)
			j(M, S)
			N = true
		end
		return O, P, Q, U, V
	end
	for K, L in ag, v do
		o(J, L)
	end
	do
		local M
		for N, O in ag, E do
			if O.ClassName == "ModuleScript" and O.Name == "MainModule" then
				M = O
				break
			end
		end
		if M then
			return J(M)
		end
	end
end
