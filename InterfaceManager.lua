--[[
    ATG InterfaceManager

    The legacy Fluent-facing API remains intact:
      SetFolder, SetLibrary, BuildFolderTree, SaveSettings, LoadSettings,
      BuildInterfaceSection.

    The optional second argument of BuildInterfaceSection lets a script choose
    an isolated i18n scope without requiring changes to its UI code:

      InterfaceManager:BuildInterfaceSection(Tabs.Settings, {
          ScriptId = "atg.magic-loot",
          SourceLocale = "en"
      })
]]
local HttpService = game:GetService("HttpService")

local InterfaceManager = {}
do
    local DEFAULT_SETTINGS = {
        Theme = "Dark",
        Acrylic = true,
        Transparency = true,
        MenuKeybind = "LeftControl",
        FloatingToggle = true,

        Language = "en",
        TranslationEnabled = true,
        TranslationMode = "auto",
        LanguagePackUrl = "",
        LanguagePack = "",
        TemplateLocale = "",

        FontProfile = "default",
        FontUrl = "",
        FontTarget = "Both"
    }

    local DEFAULT_CONFIGURATION = {
        ScriptId = "shared",
        SourceLocale = "en",
        EnableRemoteAssets = true
    }

    -- Appearance is intentionally shared, while translation/font choices are
    -- saved per script scope.  This keeps a Thai Magic Loot pack from being
    -- selected by an unrelated script which has a different set of packs.
    local GLOBAL_SETTING_KEYS = {
        "Theme",
        "Acrylic",
        "Transparency",
        "MenuKeybind",
        "FloatingToggle"
    }

    local SCOPED_SETTING_KEYS = {
        "Language",
        "TranslationEnabled",
        "TranslationMode",
        "LanguagePackUrl",
        "LanguagePack",
        "TemplateLocale",
        "FontProfile",
        "FontUrl",
        "FontTarget"
    }

    local MODE_VALUES = {
        ["Auto"] = "auto",
        ["JSON pack"] = "community",
        ["Roblox"] = "roblox",
        ["Machine"] = "machine",
        ["Original"] = "source"
    }

    local FONT_TARGET_VALUES = {
        ["Both"] = "both",
        ["Latin"] = "latin",
        ["Thai"] = "thai"
    }

    InterfaceManager.Folder = "FluentSettings"
    InterfaceManager.Settings = {}
    InterfaceManager.Configuration = {}

    local function copyDefaults(target, defaults)
        for key, value in pairs(defaults) do
            target[key] = value
        end
    end

    local function copySettingKeys(target, source, keys)
        for _, key in ipairs(keys) do
            local defaultValue = DEFAULT_SETTINGS[key]
            if type(source[key]) == type(defaultValue) then
                target[key] = source[key]
            end
        end
    end

    local function collectSettingKeys(source, keys)
        local result = {}
        for _, key in ipairs(keys) do
            result[key] = source[key]
        end
        return result
    end

    copyDefaults(InterfaceManager.Settings, DEFAULT_SETTINGS)
    copyDefaults(InterfaceManager.Configuration, DEFAULT_CONFIGURATION)

    local function executorFunction(name)
        local direct = {
            readfile = readfile,
            writefile = writefile,
            isfile = isfile,
            isfolder = isfolder,
            makefolder = makefolder
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

    local function sanitizeSegment(value, fallback)
        value = tostring(value or fallback or "shared")
        value = value:gsub("[^%w%-%._]", "_")
        if value == "" or value == "." or value == ".." then
            return fallback or "shared"
        end
        return value
    end

    local function sanitizeFolder(value)
        local parts = {}
        value = tostring(value or ""):gsub("\\", "/")
        for part in string.gmatch(value, "[^/]+") do
            table.insert(parts, sanitizeSegment(part, "folder"))
        end
        return #parts > 0 and table.concat(parts, "/") or "FluentSettings"
    end

    local function hasFileSystem()
        return type(executorFunction("readfile")) == "function"
            and type(executorFunction("writefile")) == "function"
            and type(executorFunction("isfile")) == "function"
            and type(executorFunction("isfolder")) == "function"
            and type(executorFunction("makefolder")) == "function"
    end

    local function safeNotify(library, title, content, subContent)
        if not library or type(library.Notify) ~= "function" then
            return
        end
        pcall(function()
            library:Notify({
                Title = title,
                Content = content,
                SubContent = subContent or "",
                Duration = 5
            })
        end)
    end

    local function modeDisplay(mode)
        for display, value in pairs(MODE_VALUES) do
            if value == mode then
                return display
            end
        end
        return "Auto"
    end

    local function getCustomization(library)
        if type(library) ~= "table" then
            return nil
        end
        return library.Customization
    end

    local function getLanguageValue(i18n, locale)
        if not i18n or type(i18n.GetLanguageOptions) ~= "function" then
            return nil
        end
        for _, value in ipairs(i18n:GetLanguageOptions()) do
            if i18n:GetLanguageCode(value) == i18n:GetLanguageCode(locale) then
                return value
            end
        end
        local options = i18n:GetLanguageOptions()
        return options[1]
    end

    local function packDisplay(pack)
        return string.format("%s - %s [%s]", pack.Name or pack.Id, pack.Locale or "?", pack.Id)
    end

    local function packIdFromDisplay(value)
        return type(value) == "string" and value:match("%[([^%[%]]+)%]$") or ""
    end

    local function profileDisplay(fonts, profileId)
        if not fonts or type(fonts.GetProfileOptions) ~= "function" then
            return nil
        end
        for _, value in ipairs(fonts:GetProfileOptions()) do
            if fonts:GetProfileId(value) == fonts:GetProfileId(profileId) then
                return value
            end
        end
        local options = fonts:GetProfileOptions()
        return options[1]
    end

    local function writeSettings(path, settings)
        local writeFile = executorFunction("writefile")
        local readFile = executorFunction("readfile")
        local isFile = executorFunction("isfile")
        if type(writeFile) ~= "function" then
            return false, "This executor does not expose writefile."
        end

        local encodedOk, encoded = pcall(HttpService.JSONEncode, HttpService, settings)
        if not encodedOk then
            return false, tostring(encoded)
        end

        -- Preserve a small recoverable backup before overwriting the settings.
        if type(readFile) == "function" and type(isFile) == "function" then
            local exists, fileExists = pcall(isFile, path)
            if exists and fileExists then
                local readOk, previous = pcall(readFile, path)
                if readOk and type(previous) == "string" then
                    pcall(writeFile, path .. ".bak", previous)
                end
            end
        end

        local ok, err = pcall(writeFile, path, encoded)
        return ok, ok and nil or tostring(err)
    end

    local function readSettings(path)
        local isFile = executorFunction("isfile")
        local readFile = executorFunction("readfile")
        if type(isFile) ~= "function" or type(readFile) ~= "function" then
            return nil, "This executor does not expose readfile/isfile."
        end

        local exists, fileExists = pcall(isFile, path)
        if not exists then
            return nil, tostring(fileExists)
        end
        if not fileExists then
            return nil
        end

        local readOk, raw = pcall(readFile, path)
        if not readOk then
            return nil, tostring(raw)
        end
        local decodeOk, decoded = pcall(HttpService.JSONDecode, HttpService, raw)
        if not decodeOk or type(decoded) ~= "table" then
            return nil, path .. " is not valid JSON."
        end
        return decoded
    end

    function InterfaceManager:SetFolder(folder)
        self.Folder = sanitizeFolder(folder)
        self:BuildFolderTree()
        return self
    end

    function InterfaceManager:SetLibrary(library)
        self.Library = library
        return self
    end

    function InterfaceManager:Configure(options)
        options = options or {}
        local allowed = {
            ScriptId = "string",
            SourceLocale = "string",
            EnableRemoteAssets = "boolean"
        }
        for key, expectedType in pairs(allowed) do
            if type(options[key]) == expectedType then
                self.Configuration[key] = options[key]
            end
        end
        self.Configuration.ScriptId = sanitizeSegment(self.Configuration.ScriptId, "shared")
        return self
    end

    function InterfaceManager:BuildFolderTree()
        if not hasFileSystem() then
            return false, "This executor does not expose a file system."
        end

        local isFolder = executorFunction("isfolder")
        local makeFolder = executorFunction("makefolder")
        local paths = {}
        local current = ""
        for part in string.gmatch(self.Folder, "[^/]+") do
            current = current == "" and part or current .. "/" .. part
            table.insert(paths, current)
        end
        table.insert(paths, self.Folder .. "/settings")
        table.insert(paths, self.Folder .. "/i18n")
        table.insert(paths, self.Folder .. "/i18n/" .. sanitizeSegment(self.Configuration.ScriptId, "shared"))
        table.insert(paths, self.Folder .. "/fonts")

        for _, path in ipairs(paths) do
            local exists, isDirectory = pcall(isFolder, path)
            if not exists or not isDirectory then
                local created, createError = pcall(makeFolder, path)
                if not created then
                    return false, tostring(createError)
                end
            end
        end
        return true
    end

    function InterfaceManager:SaveSettings()
        local built, buildError = self:BuildFolderTree()
        if not built then
            return false, buildError
        end
        local globalOk, globalError = writeSettings(
            self.Folder .. "/options.json",
            collectSettingKeys(self.Settings, GLOBAL_SETTING_KEYS)
        )
        if not globalOk then
            return false, globalError
        end

        local scope = sanitizeSegment(self.Configuration.ScriptId, "shared")
        local scopedOk, scopedError = writeSettings(
            self.Folder .. "/i18n/" .. scope .. "/interface.json",
            collectSettingKeys(self.Settings, SCOPED_SETTING_KEYS)
        )
        return scopedOk, scopedError
    end

    function InterfaceManager:LoadSettings()
        copyDefaults(self.Settings, DEFAULT_SETTINGS)
        if not hasFileSystem() then
            return false, "This executor does not expose a file system."
        end

        -- Read the legacy all-in-one file first.  It doubles as a painless
        -- migration path for users upgrading from the older manager.
        local decoded, readError = readSettings(self.Folder .. "/options.json")
        if readError then
            return false, readError
        end
        if decoded then
            copySettingKeys(self.Settings, decoded, GLOBAL_SETTING_KEYS)
            copySettingKeys(self.Settings, decoded, SCOPED_SETTING_KEYS)
        end

        local scope = sanitizeSegment(self.Configuration.ScriptId, "shared")
        local scoped, scopedError = readSettings(self.Folder .. "/i18n/" .. scope .. "/interface.json")
        if scopedError then
            return false, scopedError
        end
        if scoped then
            copySettingKeys(self.Settings, scoped, SCOPED_SETTING_KEYS)
        end

        local validModes = {
            auto = true,
            community = true,
            roblox = true,
            machine = true,
            source = true
        }
        if not validModes[self.Settings.TranslationMode] then
            self.Settings.TranslationMode = DEFAULT_SETTINGS.TranslationMode
        end
        local oldFontTargets = {
            ["Both (Latin + Thai)"] = "Both",
            ["English / Latin only"] = "Latin",
            ["Thai only"] = "Thai"
        }
        self.Settings.FontTarget = oldFontTargets[self.Settings.FontTarget] or self.Settings.FontTarget
        if not FONT_TARGET_VALUES[self.Settings.FontTarget] then
            self.Settings.FontTarget = DEFAULT_SETTINGS.FontTarget
        end
        return true
    end

    function InterfaceManager:ApplyCustomizationSettings()
        local library = self.Library
        local customization = getCustomization(library)
        if not customization or type(customization.Configure) ~= "function" then
            return false, "This MainUI version does not include the ATG customization core."
        end

        local settings = self.Settings
        customization:Configure({
            Folder = self.Folder,
            ScriptId = self.Configuration.ScriptId,
            SourceLocale = self.Configuration.SourceLocale,
            Locale = settings.Language,
            Mode = settings.TranslationMode,
            Enabled = settings.TranslationEnabled,
            EnableRemoteAssets = self.Configuration.EnableRemoteAssets,
            FontProfile = settings.FontProfile
        })

        library.CurrentLanguage = customization.I18n.CurrentLocale
        if type(library.SetFloatingToggleConfig) == "function" then
            library:SetFloatingToggleConfig(settings.FloatingToggle and {} or false)
        end
        if customization.LastError then
            return false, customization.LastError
        end
        return true
    end

    function InterfaceManager:BuildInterfaceSection(tab, options)
        assert(self.Library, "Must set InterfaceManager.Library")
        assert(tab, "BuildInterfaceSection requires a Settings tab")
        self:Configure(options)
        self:BuildFolderTree()
        self:LoadSettings()

        local library = self.Library
        local settings = self.Settings
        local customizationApplied, customizationError = self:ApplyCustomizationSettings()
        if not customizationApplied then
            safeNotify(library, "Customization", "Some saved customization could not be applied", customizationError)
        end

        local section = tab:AddSection("Interface")
        local theme = section:AddDropdown("InterfaceTheme", {
            Title = "Theme",
            Description = "Choose a look.",
            Values = library.Themes,
            Default = settings.Theme,
            Callback = function(value)
                library:SetTheme(value)
                settings.Theme = value
                self:SaveSettings()
            end
        })
        pcall(function()
            theme:SetValue(settings.Theme)
        end)

        if library.UseAcrylic then
            section:AddToggle("AcrylicToggle", {
                Title = "Acrylic",
                Description = "Blur background.",
                Default = settings.Acrylic,
                Callback = function(value)
                    library:ToggleAcrylic(value)
                    settings.Acrylic = value
                    self:SaveSettings()
                end
            })
        end

        section:AddToggle("TransparentToggle", {
            Title = "Transparency",
            Description = "See-through background.",
            Default = settings.Transparency,
            Callback = function(value)
                library:ToggleTransparency(value)
                settings.Transparency = value
                self:SaveSettings()
            end
        })

        local menuKeybind = section:AddKeybind("MenuKeybind", {
            Title = "Minimize Bind",
            Default = settings.MenuKeybind
        })
        menuKeybind:OnChanged(function()
            settings.MenuKeybind = menuKeybind.Value
            self:SaveSettings()
        end)
        library.MinimizeKeybind = menuKeybind

        if type(library.SetFloatingToggleConfig) == "function" then
            section:AddToggle("InterfaceFloatingToggle", {
                Title = "Floating button",
                Description = "Drag it. Ctrl + M toggles UI.",
                Default = settings.FloatingToggle,
                Callback = function(value)
                    settings.FloatingToggle = value
                    library:SetFloatingToggleConfig(value and {} or false)
                    self:SaveSettings()
                end
            })
        end

        local customization = getCustomization(library)
        local customizationReady = type(customization) == "table"
            and type(customization.I18n) == "table"
            and type(customization.I18n.GetLanguageOptions) == "function"
            and type(customization.I18n.GetLanguageCode) == "function"
            and type(customization.I18n.SetLanguage) == "function"
            and type(customization.I18n.SetMode) == "function"
            and type(customization.I18n.SetEnabled) == "function"
            and type(customization.Fonts) == "table"
            and type(customization.Fonts.GetProfileOptions) == "function"
            and type(customization.Fonts.GetProfileId) == "function"
            and type(customization.Fonts.ApplyProfile) == "function"
            and type(customization.RemoteAssets) == "table"
            and type(customization.RemoteAssets.ImportLanguage) == "function"
            and type(customization.RemoteAssets.ImportFont) == "function"
        if not customizationReady then
            tab:AddSection("Customization"):AddParagraph({
                Title = "Customization core unavailable",
                Content = "Update MainUI to use language and font tools."
            })
            return
        end

        local i18n = customization.I18n
        local fonts = customization.Fonts
        local assets = customization.RemoteAssets
        local capabilities = customization.Capabilities or {}
        local delayedSaveRevision = 0
        local function saveSoon()
            delayedSaveRevision = delayedSaveRevision + 1
            local revision = delayedSaveRevision
            task.delay(0.35, function()
                if revision == delayedSaveRevision then
                    self:SaveSettings()
                end
            end)
        end

        local localization = tab:AddSection("Language")
        local languageDropdown = localization:AddDropdown("InterfaceLanguage", {
            Title = "UI language",
            Description = "Choose your language.",
            Values = i18n:GetLanguageOptions(),
            Default = getLanguageValue(i18n, settings.Language),
            Callback = function(value)
                settings.Language = i18n:GetLanguageCode(value)
                i18n:SetLanguage(settings.Language)
                library.CurrentLanguage = settings.Language
                self:SaveSettings()
            end
        })
        pcall(function()
            languageDropdown:SetValue(getLanguageValue(i18n, settings.Language))
        end)

        local modeValues = {}
        for display in pairs(MODE_VALUES) do
            table.insert(modeValues, display)
        end
        table.sort(modeValues)
        local modeDropdown = localization:AddDropdown("InterfaceTranslationMode", {
            Title = "Translate by",
            Description = "Pick a source.",
            Values = modeValues,
            Default = modeDisplay(settings.TranslationMode),
            Callback = function(value)
                settings.TranslationMode = MODE_VALUES[value] or "auto"
                if settings.TranslationMode == "machine" and not capabilities.MachineTranslation then
                    safeNotify(library, "Machine translation", "Unsupported executor", "Original text will be used.")
                elseif settings.TranslationMode == "roblox" and not capabilities.RobloxTranslation then
                    safeNotify(library, "Roblox translation", "Unavailable here", "Original text will be used.")
                end
                i18n:SetMode(settings.TranslationMode)
                self:SaveSettings()
            end
        })
        pcall(function()
            modeDropdown:SetValue(modeDisplay(settings.TranslationMode))
        end)

        localization:AddToggle("InterfaceTranslationEnabled", {
            Title = "Translation",
            Description = "Show translated text.",
            Default = settings.TranslationEnabled,
            Callback = function(value)
                settings.TranslationEnabled = value
                i18n:SetEnabled(value)
                self:SaveSettings()
            end
        })

        local capabilityText = string.format(
            "Save: %s | Web: %s | Fonts: %s",
            capabilities.FileSystem and "OK" or "No",
            (capabilities.RemoteFetch and assets.Enabled) and "OK" or "No",
            capabilities.CustomFonts and "OK" or "No"
        )
        localization:AddParagraph({
            Title = "Status",
            Content = capabilityText
        })

        localization:AddInput("InterfaceLanguagePackUrl", {
            Title = "Language JSON",
            Description = "Paste a link or file path.",
            Default = settings.LanguagePackUrl,
            Placeholder = "GitHub raw URL or local file path",
            Finished = false,
            Callback = function(value)
                settings.LanguagePackUrl = value
                saveSoon()
            end
        })

        localization:AddInput("InterfaceTemplateLocale", {
            Title = "Target code",
            Description = "Optional, e.g. ja-JP.",
            Default = settings.TemplateLocale,
            Placeholder = "th-TH",
            Finished = false,
            MaxLength = 24,
            Callback = function(value)
                settings.TemplateLocale = value
                saveSoon()
            end
        })

        local installedPackValues = {}
        local installedPackDropdown
        local function refreshLanguagePacks(dropdown)
            installedPackValues = {}
            for _, pack in ipairs(assets:GetLanguagePacks()) do
                table.insert(installedPackValues, packDisplay(pack))
            end
            if #installedPackValues == 0 then
                installedPackValues = {"No installed language packs"}
            end
            if dropdown then
                dropdown:SetValues(installedPackValues)
                local wanted
                for _, value in ipairs(installedPackValues) do
                    if packIdFromDisplay(value) == settings.LanguagePack then
                        wanted = value
                        break
                    end
                end
                dropdown:SetValue(wanted or installedPackValues[1])
            end
        end

        localization:AddButton({
            Title = "Install JSON",
            Description = "Install the JSON above.",
            Callback = function()
                local pack, importError = assets:ImportLanguage(settings.LanguagePackUrl)
                if not pack then
                    safeNotify(library, "Language pack", "Install failed", importError)
                    return
                end
                settings.LanguagePack = pack.Id
                settings.Language = pack.Locale
                i18n:SetLanguage(pack.Locale)
                languageDropdown:SetValues(i18n:GetLanguageOptions())
                languageDropdown:SetValue(getLanguageValue(i18n, pack.Locale))
                refreshLanguagePacks(installedPackDropdown)
                self:SaveSettings()
                safeNotify(library, "Language pack", "Installed " .. pack.Name, "Locale: " .. pack.Locale)
            end
        })

        localization:AddButton({
            Title = "Export JSON",
            Description = "Save a blank template.",
            Callback = function()
                local targetLocale = settings.TemplateLocale:match("^%s*(.-)%s*$")
                if targetLocale == "" then
                    targetLocale = settings.Language
                end
                local export, exportError = assets:ExportDefaultLanguagePack(targetLocale)
                if not export then
                    safeNotify(library, "Language template", "Export failed", exportError)
                    return
                end
                safeNotify(
                    library,
                    "Language template",
                    "Template exported",
                    export.Path
                        or (export.Copied and "Copied to clipboard.")
                        or "Generated, but this executor cannot save files or copy to clipboard."
                )
            end
        })

        installedPackDropdown = localization:AddDropdown("InterfaceInstalledLanguagePack", {
            Title = "Saved pack",
            Description = "Choose a pack.",
            Values = {"No installed language packs"},
            Default = "No installed language packs",
            Callback = function(value)
                local id = packIdFromDisplay(value)
                if id ~= "" then
                    settings.LanguagePack = id
                    self:SaveSettings()
                end
            end
        })
        refreshLanguagePacks(installedPackDropdown)

        localization:AddButton({
            Title = "Update pack",
            Description = "Download it again.",
            Callback = function()
                local pack, updateError = assets:UpdateLanguage(settings.LanguagePack)
                if not pack then
                    safeNotify(library, "Language pack", "Update failed", updateError)
                    return
                end
                refreshLanguagePacks(installedPackDropdown)
                safeNotify(library, "Language pack", "Updated " .. pack.Name, "Version: " .. pack.Version)
            end
        })

        localization:AddButton({
            Title = "Remove pack",
            Description = "Delete this pack.",
            Callback = function()
                local removed, removeError = assets:RemoveLanguage(settings.LanguagePack)
                if not removed then
                    safeNotify(library, "Language pack", "Remove failed", removeError)
                    return
                end
                settings.LanguagePack = ""
                refreshLanguagePacks(installedPackDropdown)
                self:SaveSettings()
                safeNotify(library, "Language pack", "Removed")
            end
        })

        local typography = tab:AddSection("Fonts")
        typography:AddParagraph({
            Title = "Font help",
            Content = "Use ID, Google Fonts, or a font file."
        })

        local fontProfileDropdown
        local function refreshFontProfiles()
            local values = fonts:GetProfileOptions()
            if #values == 0 then
                values = {"Script default [default]"}
            end
            fontProfileDropdown:SetValues(values)
            fontProfileDropdown:SetValue(profileDisplay(fonts, settings.FontProfile) or values[1])
        end

        fontProfileDropdown = typography:AddDropdown("InterfaceFontProfile", {
            Title = "Active font",
            Description = "Thai uses Thai; other text uses Latin.",
            Values = fonts:GetProfileOptions(),
            Default = profileDisplay(fonts, settings.FontProfile),
            Callback = function(value)
                local profileId = fonts:GetProfileId(value)
                local applied, applyError = fonts:ApplyProfile(profileId)
                if not applied then
                    safeNotify(library, "Font", "This font is unavailable in this executor", applyError)
                    return
                end
                settings.FontProfile = profileId
                self:SaveSettings()
            end
        })
        pcall(refreshFontProfiles)

        typography:AddDropdown("InterfaceFontTarget", {
            Title = "Apply font to",
            Description = "Choose the text to change.",
            Values = {"Both", "Latin", "Thai"},
            Default = settings.FontTarget,
            Callback = function(value)
                settings.FontTarget = value
                self:SaveSettings()
            end
        })

        typography:AddInput("InterfaceFontUrl", {
            Title = "Font link / ID",
            Description = "Paste an ID, link, or file.",
            Default = settings.FontUrl,
            Placeholder = "Google Fonts link, Asset ID, or .ttf file",
            Finished = false,
            Callback = function(value)
                settings.FontUrl = value
                saveSoon()
            end
        })

        typography:AddButton({
            Title = "Install font",
            Description = "Install and use this font.",
            Callback = function()
                local profile, installError = assets:ImportFont(settings.FontUrl, {
                    Target = FONT_TARGET_VALUES[settings.FontTarget] or "both",
                    MergeProfile = settings.FontProfile ~= "default" and settings.FontProfile or nil
                })
                if not profile then
                    safeNotify(library, "Font", "Install failed", installError)
                    return
                end
                settings.FontProfile = profile.Id
                refreshFontProfiles()
                self:SaveSettings()
                safeNotify(library, "Font", "Installed " .. profile.Name, "Applied to the current UI.")
            end
        })

        typography:AddButton({
            Title = "Default font",
            Description = "Use the script font.",
            Callback = function()
                settings.FontProfile = "default"
                fonts:ApplyProfile("default")
                refreshFontProfiles()
                self:SaveSettings()
                safeNotify(library, "Font", "Script default font restored")
            end
        })

        typography:AddButton({
            Title = "Remove font",
            Description = "Remove this profile.",
            Callback = function()
                local removed, removeError = assets:RemoveFont(settings.FontProfile)
                if not removed then
                    safeNotify(library, "Font", "Remove failed", removeError)
                    return
                end
                settings.FontProfile = "default"
                refreshFontProfiles()
                self:SaveSettings()
                safeNotify(library, "Font", "Profile removed")
            end
        })

        -- Public convenience for callers that need to refresh the selector
        -- after installing a pack programmatically.
        self.RefreshLanguagePacks = function()
            refreshLanguagePacks(installedPackDropdown)
        end
    end
end

return InterfaceManager
