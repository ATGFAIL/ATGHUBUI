--[[
    ATG InterfaceManager (Acryven v3.0 Ready)

    The legacy Fluent-facing API remains intact:
      SetFolder, SetLibrary, BuildFolderTree, SaveSettings, LoadSettings,
      BuildInterfaceSection, AttachToSettingsModal, ResetSettings,
      GetSetting, SetSetting.

    When running on Acryven v3.0 (Library.SettingsModal present), calling
    InterfaceManager:BuildInterfaceSection(Tabs.Settings, options) routes all
    UI preferences into the Settings Modal automatically, syncs every v3.0
    preference (DPI Scale, Reduced Motion, Sidebar Rail, Notification Corner,
    Floating Pill, Active HUDs, Streamer Privacy, Theme, Acrylic, Transparency,
    Floating Button, Keybind, Language, Font, Font Tuning), and builds its
    customization panels using Acryven v3.0 Components & Elements (Card
    Sections, DependencyBox, SubTabs, StatGrid, SegmentedControl, Stepper,
    ActionRow with inline Confirm, Callout, Divider, Tooltips, CommandPalette)
    with full fallback compatibility for older MainUI versions.

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

        -- Acryven v3.0 UI & Layout Preferences
        DPIScale = 1.0,
        ReducedMotion = false,
        SidebarCollapsed = false,
        NotifySide = "BottomRight",
        AlwaysShowPill = false,
        ShowHUDs = true,
        HidePlayerName = false,
        HidePlayerAvatar = false,
        PrivacyAlias = "Anonymous",

        Language = "en",
        TranslationEnabled = true,
        TranslationMode = "auto",
        LanguagePackUrl = "",
        LanguagePack = "",
        TemplateLocale = "",

        FontProfile = "default",
        FontUrl = "",
        FontTarget = "Both",
        -- Optional per-script typography overrides. Keeping these scoped
        -- means each game can use a readable size without changing another.
        FontTuningEnabled = false,
        FontSizeScale = 100,
        FontWeight = "Auto",
        FontStyle = "Auto",
        FontLineHeight = 100,
        FontStroke = 0,
        -- Technical import/update controls stay collapsed for normal users.
        AdvancedTools = false
    }

    local DEFAULT_CONFIGURATION = {
        ScriptId = "shared",
        SourceLocale = "en",
        EnableRemoteAssets = true
    }

    -- Appearance, Layout, HUD, and Streamer Privacy are intentionally shared,
    -- while translation/font choices are saved per script scope.
    local GLOBAL_SETTING_KEYS = {
        "Theme",
        "Acrylic",
        "Transparency",
        "MenuKeybind",
        "FloatingToggle",
        "DPIScale",
        "ReducedMotion",
        "SidebarCollapsed",
        "NotifySide",
        "AlwaysShowPill",
        "ShowHUDs",
        "HidePlayerName",
        "HidePlayerAvatar",
        "PrivacyAlias"
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
        "FontTarget",
        "FontTuningEnabled",
        "FontSizeScale",
        "FontWeight",
        "FontStyle",
        "FontLineHeight",
        "FontStroke",
        "AdvancedTools"
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

    local FONT_WEIGHT_VALUES = {
        ["Auto"] = true,
        ["Thin"] = true,
        ["ExtraLight"] = true,
        ["Light"] = true,
        ["Regular"] = true,
        ["Medium"] = true,
        ["SemiBold"] = true,
        ["Bold"] = true,
        ["ExtraBold"] = true,
        ["Heavy"] = true
    }

    local FONT_STYLE_VALUES = {
        ["Auto"] = true,
        ["Normal"] = true,
        ["Italic"] = true
    }

    local NOTIFY_SIDE_VALUES = {
        ["BottomRight"] = true,
        ["BottomLeft"] = true,
        ["TopRight"] = true,
        ["TopLeft"] = true
    }

    local COLOR_OK = Color3.fromRGB(52, 211, 153)
    local COLOR_WARN = Color3.fromRGB(251, 191, 36)
    local COLOR_ERR = Color3.fromRGB(248, 113, 113)
    local COLOR_INFO = Color3.fromRGB(99, 179, 255)

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

    local function safeNotify(library, title, content, subContent, icon)
        if not library or type(library.Notify) ~= "function" then
            return
        end
        pcall(function()
            library:Notify({
                Title = title,
                Content = content,
                SubContent = subContent or "",
                Icon = icon,
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

    local function clampInteger(value, fallback, minimum, maximum)
        if type(value) ~= "number" then
            return fallback
        end
        return math.floor(math.clamp(value, minimum, maximum) + 0.5)
    end

    local function clampNumber(value, fallback, minimum, maximum, decimals)
        if type(value) ~= "number" or value ~= value then
            return fallback
        end
        local clamped = math.clamp(value, minimum, maximum)
        local factor = 10 ^ (decimals or 2)
        return math.floor(clamped * factor + 0.5) / factor
    end

    local function sanitizeAlias(value)
        local clean = tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
        if #clean > 32 then
            clean = clean:sub(1, 32)
        end
        return clean ~= "" and clean or "Anonymous"
    end

    local function keyNameOf(value, fallback)
        if typeof(value) == "EnumItem" then
            return value.Name
        end
        if type(value) == "string" and value ~= "" then
            return value
        end
        return fallback or "LeftControl"
    end

    local function fontTuningFromSettings(settings)
        return {
            Enabled = settings.FontTuningEnabled == true,
            SizeScale = settings.FontSizeScale,
            Weight = settings.FontWeight,
            Style = settings.FontStyle,
            LineHeight = settings.FontLineHeight,
            Stroke = settings.FontStroke
        }
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

    local function seedDefaultsFromLibrary(settings, library)
        if type(library) ~= "table" then
            return
        end
        if type(library.Theme) == "string" and library.Theme ~= "" then
            settings.Theme = library.Theme
        end
        if type(library.Acrylic) == "boolean" then
            settings.Acrylic = library.Acrylic
        end
        if type(library.Transparency) == "boolean" then
            settings.Transparency = library.Transparency
        end
        if library.MinimizeKey ~= nil then
            settings.MenuKeybind = keyNameOf(library.MinimizeKey, settings.MenuKeybind)
        end
        if type(library.DPIScale) == "number" then
            settings.DPIScale = clampNumber(library.DPIScale, 1.0, 0.8, 1.35, 2)
        end
        if type(library.ReducedMotion) == "boolean" then
            settings.ReducedMotion = library.ReducedMotion
        end
        if type(library.NotifySide) == "string" and NOTIFY_SIDE_VALUES[library.NotifySide] then
            settings.NotifySide = library.NotifySide
        end
        if type(library.Window) == "table" and type(library.Window.SidebarCollapsed) == "boolean" then
            settings.SidebarCollapsed = library.Window.SidebarCollapsed
        end
        if type(library.FloatingPill) == "table" and type(library.FloatingPill.AlwaysVisible) == "boolean" then
            settings.AlwaysShowPill = library.FloatingPill.AlwaysVisible
        end
        if library._HUDsVisible ~= nil then
            settings.ShowHUDs = library._HUDsVisible ~= false
        end
        if type(library.GetPrivacyMode) == "function" then
            local ok, priv = pcall(library.GetPrivacyMode, library)
            if ok and type(priv) == "table" then
                settings.HidePlayerName = priv.Hidden == true
                settings.HidePlayerAvatar = priv.HideAvatar == true
                settings.PrivacyAlias = sanitizeAlias(priv.Alias)
            end
        end
    end

    local function normalizeSettings(settings)
        local validModes = {
            auto = true,
            community = true,
            roblox = true,
            machine = true,
            source = true
        }
        if not validModes[settings.TranslationMode] then
            settings.TranslationMode = DEFAULT_SETTINGS.TranslationMode
        end
        local oldFontTargets = {
            ["Both (Latin + Thai)"] = "Both",
            ["English / Latin only"] = "Latin",
            ["Thai only"] = "Thai"
        }
        settings.FontTarget = oldFontTargets[settings.FontTarget] or settings.FontTarget
        if not FONT_TARGET_VALUES[settings.FontTarget] then
            settings.FontTarget = DEFAULT_SETTINGS.FontTarget
        end
        if type(settings.FontTuningEnabled) ~= "boolean" then
            settings.FontTuningEnabled = DEFAULT_SETTINGS.FontTuningEnabled
        end
        settings.FontSizeScale = clampInteger(settings.FontSizeScale, DEFAULT_SETTINGS.FontSizeScale, 70, 160)
        if not FONT_WEIGHT_VALUES[settings.FontWeight] then
            settings.FontWeight = DEFAULT_SETTINGS.FontWeight
        end
        if not FONT_STYLE_VALUES[settings.FontStyle] then
            settings.FontStyle = DEFAULT_SETTINGS.FontStyle
        end
        settings.FontLineHeight = clampInteger(settings.FontLineHeight, DEFAULT_SETTINGS.FontLineHeight, 80, 160)
        settings.FontStroke = clampInteger(settings.FontStroke, DEFAULT_SETTINGS.FontStroke, 0, 100)
        if type(settings.AdvancedTools) ~= "boolean" then
            settings.AdvancedTools = DEFAULT_SETTINGS.AdvancedTools
        end

        settings.DPIScale = clampNumber(settings.DPIScale, DEFAULT_SETTINGS.DPIScale, 0.8, 1.35, 2)
        settings.ReducedMotion = settings.ReducedMotion == true
        settings.SidebarCollapsed = settings.SidebarCollapsed == true
        if not NOTIFY_SIDE_VALUES[settings.NotifySide] then
            settings.NotifySide = DEFAULT_SETTINGS.NotifySide
        end
        settings.AlwaysShowPill = settings.AlwaysShowPill == true
        if type(settings.ShowHUDs) ~= "boolean" then
            settings.ShowHUDs = DEFAULT_SETTINGS.ShowHUDs
        end
        settings.HidePlayerName = settings.HidePlayerName == true
        settings.HidePlayerAvatar = settings.HidePlayerAvatar == true
        settings.PrivacyAlias = sanitizeAlias(settings.PrivacyAlias)
        settings.MenuKeybind = keyNameOf(settings.MenuKeybind, DEFAULT_SETTINGS.MenuKeybind)
    end

    local function applyCoreSettings(library, settings)
        if type(library) ~= "table" then
            return
        end
        if type(library.SetTheme) == "function" and settings.Theme then
            pcall(function()
                library:SetTheme(settings.Theme, true)
            end)
        end
        if library.UseAcrylic and type(library.ToggleAcrylic) == "function" then
            pcall(function()
                library:ToggleAcrylic(settings.Acrylic == true)
            end)
        end
        if type(library.ToggleTransparency) == "function" then
            library.Transparency = settings.Transparency == true
            pcall(function()
                library:ToggleTransparency(settings.Transparency == true)
            end)
        end
        if settings.MenuKeybind ~= nil and settings.MenuKeybind ~= "" then
            library.MinimizeKey = settings.MenuKeybind
        end
        if type(library.SetDPIScale) == "function" and type(settings.DPIScale) == "number" then
            pcall(library.SetDPIScale, library, settings.DPIScale)
        end
        if type(library.SetReducedMotion) == "function" then
            pcall(library.SetReducedMotion, library, settings.ReducedMotion == true)
        end
        if type(library.SetNotifySide) == "function" and NOTIFY_SIDE_VALUES[settings.NotifySide] then
            pcall(library.SetNotifySide, library, settings.NotifySide)
        end
        if type(library.Window) == "table" and type(library.Window.SetSidebarCollapsed) == "function" then
            if library.Window.SidebarCollapsed ~= (settings.SidebarCollapsed == true) then
                pcall(library.Window.SetSidebarCollapsed, library.Window, settings.SidebarCollapsed == true, true)
            end
        end
        if type(library.FloatingPill) == "table" then
            library.FloatingPill.AlwaysVisible = settings.AlwaysShowPill == true
            if type(library.FloatingPill.SetVisible) == "function" then
                pcall(
                    library.FloatingPill.SetVisible,
                    library.FloatingPill,
                    (settings.AlwaysShowPill == true) or (library.Window and library.Window.Minimized == true)
                )
            end
        end
        library._HUDsVisible = settings.ShowHUDs ~= false
        if type(library._ActiveHUDs) == "table" then
            for _, hud in ipairs(library._ActiveHUDs) do
                if hud and type(hud.SetVisible) == "function" then
                    pcall(hud.SetVisible, hud, settings.ShowHUDs ~= false)
                end
            end
        end
        if type(library.SetPrivacyMode) == "function" then
            pcall(
                library.SetPrivacyMode,
                library,
                settings.HidePlayerName == true,
                sanitizeAlias(settings.PrivacyAlias),
                settings.HidePlayerAvatar == true
            )
        end
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
        seedDefaultsFromLibrary(self.Settings, self.Library)
        self._HasSavedGlobal = false
        if not hasFileSystem() then
            normalizeSettings(self.Settings)
            return false, "This executor does not expose a file system."
        end

        -- Read the legacy all-in-one file first. It doubles as a painless
        -- migration path for users upgrading from the older manager.
        local decoded, readError = readSettings(self.Folder .. "/options.json")
        if readError then
            normalizeSettings(self.Settings)
            return false, readError
        end
        if decoded then
            self._HasSavedGlobal = true
            copySettingKeys(self.Settings, decoded, GLOBAL_SETTING_KEYS)
            copySettingKeys(self.Settings, decoded, SCOPED_SETTING_KEYS)
        end

        local scope = sanitizeSegment(self.Configuration.ScriptId, "shared")
        local scoped, scopedError = readSettings(self.Folder .. "/i18n/" .. scope .. "/interface.json")
        if scopedError then
            normalizeSettings(self.Settings)
            return false, scopedError
        end
        if scoped then
            copySettingKeys(self.Settings, scoped, SCOPED_SETTING_KEYS)
        end

        normalizeSettings(self.Settings)
        return true
    end

    function InterfaceManager:GetSetting(key)
        return self.Settings[key]
    end

    function InterfaceManager:SetSetting(key, value, persist)
        if DEFAULT_SETTINGS[key] == nil then
            return false, "Unknown setting key: " .. tostring(key)
        end
        self.Settings[key] = value
        normalizeSettings(self.Settings)
        if self.Library then
            applyCoreSettings(self.Library, self.Settings)
            if type(self._SyncUI) == "function" then
                pcall(self._SyncUI, false)
            end
        end
        if persist ~= false then
            return self:SaveSettings()
        end
        return true
    end

    function InterfaceManager:ResetSettings()
        copyDefaults(self.Settings, DEFAULT_SETTINGS)
        if self.Library and self.Library.Brand == "Acryven" and type(self.Library.Themes) == "table" and table.find(self.Library.Themes, "Acryven") then
            self.Settings.Theme = "Acryven"
        end
        normalizeSettings(self.Settings)
        if self.Library then
            applyCoreSettings(self.Library, self.Settings)
            self:ApplyCustomizationSettings()
            if type(self._SyncUI) == "function" then
                pcall(self._SyncUI, true)
            end
        end
        self:SaveSettings()
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
            FontProfile = settings.FontProfile,
            FontTuning = fontTuningFromSettings(settings)
        })

        library.CurrentLanguage = customization.I18n.CurrentLocale
        -- Productivity data is scoped the same way as language/font packs.
        -- This is optional so an older MainUI never breaks this manager.
        if type(library.Workspace) == "table" and type(library.Workspace.Configure) == "function" then
            pcall(library.Workspace.Configure, library.Workspace, {
                ScriptId = self.Configuration.ScriptId
            })
        end
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
        local opts = type(options) == "table" and options or {}
        self:Configure(opts)
        self:BuildFolderTree()
        self:LoadSettings()

        local library = self.Library
        local settings = self.Settings
        local settingsModal = type(library.SettingsModal) == "table" and library.SettingsModal or nil
        local hasModalPages = settingsModal ~= nil
            and type(settingsModal.GetPageContainer) == "function"
            and not settingsModal.Destroyed
        local forceTab = opts.UseTab == true or opts.InModal == false
        local useModal = hasModalPages and not forceTab

        if not useModal and not tab and settingsModal and type(settingsModal.GetConfigContainer) == "function" then
            tab = settingsModal:GetConfigContainer()
        end
        if not useModal then
            assert(tab, "BuildInterfaceSection requires a Settings tab or SettingsModal")
        end

        applyCoreSettings(library, settings)
        local customizationApplied, customizationError = self:ApplyCustomizationSettings()
        if not customizationApplied then
            safeNotify(library, "Customization", "Some saved customization could not be applied", customizationError)
        end

        local generalTarget = tab
        local configTarget = tab
        local syncingUi = false
        local activeFontDropdownRef = nil
        local languageDropdown = nil
        local fontTuningToggleRef = nil
        local advancedToolsToggleRef = nil
        local translationToggleRef = nil
        local fontWeightDropdownRef = nil
        local fontStyleControlRef = nil
        local fontSizeSliderRef = nil
        local fontLineSliderRef = nil
        local fontStrokeControlRef = nil
        local fontTargetControlRef = nil
        local modeDropdownRef = nil
        local installedPackDropdownRef = nil
        local localizationSectionRef = nil
        local storageStatGridRef = nil

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

        local function syncModalUi(refreshLanguages)
            if not useModal or not settingsModal or settingsModal.Destroyed then
                return
            end
            if refreshLanguages and type(settingsModal.RefreshLanguageOptions) == "function" then
                pcall(settingsModal.RefreshLanguageOptions, settingsModal)
            end
            if type(settingsModal.SyncValues) == "function" then
                pcall(settingsModal.SyncValues, settingsModal)
            end
            if library.ProfileMenu and type(library.ProfileMenu.Refresh) == "function" then
                pcall(library.ProfileMenu.Refresh, library.ProfileMenu)
            end
        end

        local function updateSectionBadges(assets)
            if localizationSectionRef and type(localizationSectionRef.SetBadge) == "function" then
                if settings.FontTuningEnabled then
                    localizationSectionRef:SetBadge("TUNED")
                else
                    localizationSectionRef:SetBadge(nil)
                end
            end
            if storageStatGridRef and type(storageStatGridRef.SetStat) == "function" then
                local packCount = 0
                if assets and type(assets.GetLanguagePacks) == "function" then
                    local ok, list = pcall(assets.GetLanguagePacks, assets)
                    if ok and type(list) == "table" then
                        packCount = #list
                    end
                end
                storageStatGridRef:SetStat("Packs", tostring(packCount))
                storageStatGridRef:SetStat("Scope", tostring((self.Configuration and self.Configuration.ScriptId) or "shared"))
            end
        end

        local function openModalPage(pageName)
            if type(library.OpenSettings) == "function" then
                library:OpenSettings(pageName or "General")
            elseif settingsModal and type(settingsModal.Open) == "function" then
                settingsModal:Open(pageName or "General")
            end
        end

        local function scheduleLegacyTabLauncher()
            if not useModal or not tab or tab == generalTarget or tab == configTarget or opts.ShowTabLauncher == false or not tab.Container then
                return
            end
            if tab._InterfaceSettingsLauncherScheduled then
                return
            end
            tab._InterfaceSettingsLauncherScheduled = true
            local legacyTab = tab
            local forceLauncher = opts.ShowTabLauncher == true
            task.defer(function()
                if library.Unloaded or not legacyTab.Container or not legacyTab.Container.Parent then
                    return
                end
                local hasOther = false
                for _, child in ipairs(legacyTab.Container:GetChildren()) do
                    if child:IsA("GuiObject") then
                        hasOther = true
                        break
                    end
                end
                if hasOther and not forceLauncher then
                    return
                end

                local launcherRoot = nil
                if type(legacyTab.AddCallout) == "function" then
                    local callout = legacyTab:AddCallout({
                        Title = "UI Settings Moved to Modal",
                        Content = "Theme, DPI scale, Streamer Privacy, languages, fonts, and shortcuts now live in Settings (Ctrl+,).",
                        Variant = "Info",
                        Icon = "sliders-horizontal",
                        Dismissible = false,
                        Action = {
                            Title = "Open UI Settings (Ctrl+,)",
                            Callback = function()
                                openModalPage("General")
                            end
                        }
                    })
                    launcherRoot = callout and (callout.Root or callout.Frame)
                else
                    local launcher = legacyTab:AddSection("Interface Settings")
                    launcher:AddButton({
                        Title = "Open UI Settings",
                        Description = "Theme, language, fonts, transparency, and shortcuts now live in Settings (Ctrl+,).",
                        Callback = function()
                            openModalPage("General")
                        end
                    })
                    launcherRoot = launcher and launcher.Root
                end

                if not forceLauncher and launcherRoot then
                    local conn
                    conn = legacyTab.Container.ChildAdded:Connect(function(child)
                        if child ~= launcherRoot and child:IsA("GuiObject") then
                            if launcherRoot and launcherRoot.Parent then
                                launcherRoot:Destroy()
                            end
                            if conn then
                                conn:Disconnect()
                                conn = nil
                            end
                        end
                    end)
                end
            end)
        end

        if useModal then
            generalTarget = settingsModal:GetPageContainer("General")
            configTarget = settingsModal:GetPageContainer("Config")

            if settingsModal._Controls and settingsModal._Controls.MinKeybind then
                library.MinimizeKeybind = settingsModal._Controls.MinKeybind
            end

            library._InterfaceSettingListener = function(key, value)
                if key == "Theme" and type(value) == "string" and value ~= "" then
                    settings.Theme = value
                    self:SaveSettings()
                elseif key == "Acrylic" then
                    settings.Acrylic = value == true
                    self:SaveSettings()
                elseif key == "Transparency" then
                    settings.Transparency = value == true
                    self:SaveSettings()
                elseif key == "FloatingToggle" then
                    settings.FloatingToggle = value == true
                    self:SaveSettings()
                elseif key == "MenuKeybind" and value ~= nil and tostring(value) ~= "" then
                    settings.MenuKeybind = keyNameOf(value, settings.MenuKeybind)
                    self:SaveSettings()
                elseif key == "DPIScale" and type(value) == "number" then
                    settings.DPIScale = clampNumber(value, 1.0, 0.8, 1.35, 2)
                    saveSoon()
                elseif key == "ReducedMotion" then
                    settings.ReducedMotion = value == true
                    self:SaveSettings()
                elseif key == "SidebarCollapsed" then
                    settings.SidebarCollapsed = value == true
                    self:SaveSettings()
                elseif key == "NotifySide" and type(value) == "string" and NOTIFY_SIDE_VALUES[value] then
                    settings.NotifySide = value
                    self:SaveSettings()
                elseif key == "AlwaysShowPill" then
                    settings.AlwaysShowPill = value == true
                    self:SaveSettings()
                elseif key == "ShowHUDs" then
                    settings.ShowHUDs = value == true
                    self:SaveSettings()
                elseif key == "HidePlayerName" then
                    settings.HidePlayerName = value == true
                    self:SaveSettings()
                elseif key == "HidePlayerAvatar" then
                    settings.HidePlayerAvatar = value == true
                    self:SaveSettings()
                elseif key == "PrivacyAlias" and type(value) == "string" then
                    settings.PrivacyAlias = sanitizeAlias(value)
                    self:SaveSettings()
                elseif key == "Language" and type(value) == "string" and value ~= "" then
                    settings.Language = value
                    self:SaveSettings()
                elseif key == "FontProfile" and type(value) == "string" and value ~= "" then
                    settings.FontProfile = value
                    if activeFontDropdownRef and type(activeFontDropdownRef.SetValue) == "function" then
                        local cust = getCustomization(library)
                        if cust and cust.Fonts then
                            syncingUi = true
                            pcall(function()
                                activeFontDropdownRef:SetValue(profileDisplay(cust.Fonts, value), true)
                            end)
                            syncingUi = false
                        end
                    end
                    self:SaveSettings()
                end
            end

            syncModalUi(true)

            if self._RegisteredPaletteLibrary ~= library and type(library.RegisterCommand) == "function" then
                self._RegisteredPaletteLibrary = library
                pcall(library.RegisterCommand, library, {
                    Title = "Save Interface Settings",
                    Subtitle = "Write current Acryven UI preferences to disk",
                    Category = "Interface",
                    Icon = "save",
                    Callback = function()
                        self:SaveSettings()
                        safeNotify(library, "Interface", "Saved interface settings", tostring(self.Folder), "save")
                    end
                })
                pcall(library.RegisterCommand, library, {
                    Title = "Reload Interface Settings",
                    Subtitle = "Reload saved theme, DPI scale, privacy, and language",
                    Category = "Interface",
                    Icon = "refresh-cw",
                    Callback = function()
                        self:LoadSettings()
                        settings = self.Settings
                        applyCoreSettings(library, settings)
                        self:ApplyCustomizationSettings()
                        if type(self._SyncUI) == "function" then
                            pcall(self._SyncUI, true)
                        end
                        safeNotify(library, "Interface", "Reloaded saved settings", nil, "refresh-cw")
                    end
                })
                pcall(library.RegisterCommand, library, {
                    Title = "Open Interface Storage",
                    Subtitle = "Jump to Settings -> Config & storage status",
                    Category = "Interface",
                    Icon = "hard-drive",
                    Callback = function()
                        openModalPage("Config")
                    end
                })
            end

            if self._MountedModalLibrary == library then
                scheduleLegacyTabLauncher()
                return
            end
            self._MountedModalLibrary = library
        else
            local section = tab:AddSection("Interface")
            local theme = section:AddDropdown("InterfaceTheme", {
                Title = "Theme",
                Description = "Choose a look.",
                Values = library.Themes,
                Default = settings.Theme,
                Callback = function(value)
                    if syncingUi then return end
                    library:SetTheme(value)
                    settings.Theme = value
                    self:SaveSettings()
                end
            })
            pcall(function()
                theme:SetValue(settings.Theme)
            end)

            local menuKeybind = section:AddKeybind("MenuKeybind", {
                Title = "Minimize Bind",
                Description = "Key to hide the window",
                Default = settings.MenuKeybind
            })
            menuKeybind:OnChanged(function()
                if syncingUi then return end
                settings.MenuKeybind = keyNameOf(menuKeybind.Value, settings.MenuKeybind)
                self:SaveSettings()
            end)
            library.MinimizeKeybind = menuKeybind

            if library.UseAcrylic then
                section:AddToggle("AcrylicToggle", {
                    Title = "Acrylic",
                    Description = "Blur background.",
                    Default = settings.Acrylic,
                    Callback = function(value)
                        if syncingUi then return end
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
                    if syncingUi then return end
                    library:ToggleTransparency(value)
                    settings.Transparency = value
                    self:SaveSettings()
                end
            })

            if type(library.SetFloatingToggleConfig) == "function" then
                section:AddToggle("InterfaceFloatingToggle", {
                    Title = "Floating button",
                    Description = "Draggable show/hide button",
                    Default = settings.FloatingToggle,
                    Callback = function(value)
                        if syncingUi then return end
                        settings.FloatingToggle = value
                        library:SetFloatingToggleConfig(value and {} or false)
                        self:SaveSettings()
                    end
                })
            end
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
            local fallbackSec = generalTarget:AddSection("Customization")
            if type(fallbackSec.AddCallout) == "function" then
                fallbackSec:AddCallout({
                    Title = "Customization core unavailable",
                    Content = "Update MainUI to use language and font tools.",
                    Variant = "Warning",
                    Dismissible = false
                })
            else
                fallbackSec:AddParagraph({
                    Title = "Customization core unavailable",
                    Content = "Update MainUI to use language and font tools."
                })
            end
            scheduleLegacyTabLauncher()
            return
        end

        local i18n = customization.I18n
        local fonts = customization.Fonts
        local assets = customization.RemoteAssets
        local capabilities = customization.Capabilities or {}

        local localization = generalTarget:AddSection(
            useModal and {
                Title = "Font & Translation",
                Icon = "languages",
                Style = "Card",
                Collapsible = true,
                Badge = settings.FontTuningEnabled and "TUNED" or nil
            } or "Language & Font"
        )
        localizationSectionRef = localization

        if not useModal then
            languageDropdown = localization:AddDropdown("InterfaceLanguage", {
                Title = "UI language",
                Description = "Choose your language.",
                Values = i18n:GetLanguageOptions(),
                Default = getLanguageValue(i18n, settings.Language),
                Callback = function(value)
                    if syncingUi then return end
                    settings.Language = i18n:GetLanguageCode(value)
                    i18n:SetLanguage(settings.Language)
                    library.CurrentLanguage = settings.Language
                    self:SaveSettings()
                end
            })
            pcall(function()
                languageDropdown:SetValue(getLanguageValue(i18n, settings.Language))
            end)
        end

        local fontProfileDropdown
        local function refreshFontProfiles()
            local values = fonts:GetProfileOptions()
            if #values == 0 then
                values = {"Script default [default]"}
            end
            syncingUi = true
            fontProfileDropdown:SetValues(values)
            fontProfileDropdown:SetValue(profileDisplay(fonts, settings.FontProfile) or values[1])
            syncingUi = false
        end

        fontProfileDropdown = localization:AddDropdown("InterfaceFontProfile", {
            Title = "Active font",
            Description = "Choose a built-in or installed font profile.",
            Tooltip = "Applies across UI headings and labels while keeping code blocks monospace.",
            Values = fonts:GetProfileOptions(),
            Default = profileDisplay(fonts, settings.FontProfile),
            Callback = function(value)
                if syncingUi then
                    return
                end
                local profileId = fonts:GetProfileId(value)
                local applied, applyError = fonts:ApplyProfile(profileId)
                if not applied then
                    safeNotify(library, "Font", "This font is unavailable in this executor", applyError)
                    return
                end
                settings.FontProfile = profileId
                syncModalUi(false)
                self:SaveSettings()
            end
        })
        activeFontDropdownRef = fontProfileDropdown
        pcall(refreshFontProfiles)

        local fontTuningSupported = type(fonts.GetTextStyleConfig) == "function"
            and type(fonts.SetTextStyleConfig) == "function"
        local fontTuningUiReady = false
        local fontTuningRevision = 0
        local fontAppearanceSection = nil
        local fontAppearanceDepBox = nil

        local function setFontAppearanceVisible(visible)
            if fontAppearanceDepBox and type(fontAppearanceDepBox.SetVisible) == "function" then
                fontAppearanceDepBox:SetVisible(visible == true, false)
            elseif fontAppearanceSection and type(fontAppearanceSection.SetVisible) == "function" then
                fontAppearanceSection:SetVisible(visible == true)
            elseif fontAppearanceSection and fontAppearanceSection.Root then
                fontAppearanceSection.Root.Visible = visible == true
            end
        end

        local function applyFontTuning()
            local called, applied, applyError = pcall(function()
                return fonts:SetTextStyleConfig(fontTuningFromSettings(settings))
            end)
            if not called or applied == false then
                safeNotify(
                    library,
                    "Font appearance",
                    "Could not apply settings",
                    tostring(called and applyError or applied or "Unknown error")
                )
                return false
            end
            return true
        end

        local function requestFontTuningUpdate(immediate)
            if not fontTuningUiReady or syncingUi then
                return
            end
            fontTuningRevision = fontTuningRevision + 1
            local revision = fontTuningRevision
            if immediate then
                applyFontTuning()
            else
                task.delay(0.15, function()
                    if revision == fontTuningRevision then
                        applyFontTuning()
                    end
                end)
            end
            saveSoon()
        end

        translationToggleRef = localization:AddToggle("InterfaceTranslationEnabled", {
            Title = "Translation",
            Description = "Show translated text across UI labels.",
            Tooltip = "Turn off to view original source strings without uninstalling packs.",
            Default = settings.TranslationEnabled,
            Callback = function(value)
                if syncingUi then return end
                settings.TranslationEnabled = value
                i18n:SetEnabled(value)
                self:SaveSettings()
            end
        })

        if fontTuningSupported then
            fontTuningToggleRef = localization:AddToggle("InterfaceFontTuningEnabled", {
                Title = "Advanced font settings",
                Description = "Fine-tune weight, style, text size, line spacing, and outline.",
                Tooltip = "Saved per script scope so each game stays readable.",
                Default = settings.FontTuningEnabled,
                Callback = function(value)
                    if syncingUi then return end
                    settings.FontTuningEnabled = value
                    setFontAppearanceVisible(value)
                    updateSectionBadges(assets)
                    requestFontTuningUpdate(true)
                end
            })

            local fontTuningContainer
            if type(localization.AddDependencyBox) == "function" then
                fontAppearanceDepBox = localization:AddDependencyBox({
                    DependsOn = fontTuningToggleRef,
                    Default = settings.FontTuningEnabled == true
                })
                fontTuningContainer = fontAppearanceDepBox
                if type(fontTuningContainer.AddDivider) == "function" then
                    fontTuningContainer:AddDivider("Font Appearance")
                end
            else
                fontAppearanceSection = generalTarget:AddSection("Font appearance")
                fontTuningContainer = fontAppearanceSection
            end

            fontWeightDropdownRef = fontTuningContainer:AddDropdown("InterfaceFontWeight", {
                Title = "Weight",
                Description = "How bold the text is.",
                Values = {"Auto", "Thin", "ExtraLight", "Light", "Regular", "Medium", "SemiBold", "Bold", "ExtraBold", "Heavy"},
                Default = settings.FontWeight,
                Callback = function(value)
                    if syncingUi then return end
                    settings.FontWeight = value
                    requestFontTuningUpdate(true)
                end
            })

            if type(fontTuningContainer.AddSegmentedControl) == "function" then
                fontStyleControlRef = fontTuningContainer:AddSegmentedControl("InterfaceFontStyle", {
                    Title = "Style",
                    Description = "Keep normal or switch to italic.",
                    Values = {"Auto", "Normal", "Italic"},
                    Default = settings.FontStyle,
                    Callback = function(value)
                        if syncingUi then return end
                        settings.FontStyle = value
                        requestFontTuningUpdate(true)
                    end
                })
            else
                fontStyleControlRef = fontTuningContainer:AddDropdown("InterfaceFontStyle", {
                    Title = "Style",
                    Description = "Keep normal or use italic.",
                    Values = {"Auto", "Normal", "Italic"},
                    Default = settings.FontStyle,
                    Callback = function(value)
                        if syncingUi then return end
                        settings.FontStyle = value
                        requestFontTuningUpdate(true)
                    end
                })
            end

            fontSizeSliderRef = fontTuningContainer:AddSlider("InterfaceFontSizeScale", {
                Title = "Text size",
                Description = "100% = normal.",
                Default = settings.FontSizeScale,
                Min = 70,
                Max = 160,
                Rounding = 0,
                Suffix = "%",
                Callback = function(value)
                    if syncingUi then return end
                    settings.FontSizeScale = value
                    requestFontTuningUpdate(false)
                end
            })

            fontLineSliderRef = fontTuningContainer:AddSlider("InterfaceFontLineHeight", {
                Title = "Line spacing",
                Description = "100% = normal.",
                Default = settings.FontLineHeight,
                Min = 80,
                Max = 160,
                Rounding = 0,
                Suffix = "%",
                Callback = function(value)
                    if syncingUi then return end
                    settings.FontLineHeight = value
                    requestFontTuningUpdate(false)
                end
            })

            if type(fontTuningContainer.AddStepper) == "function" then
                fontStrokeControlRef = fontTuningContainer:AddStepper("InterfaceFontStroke", {
                    Title = "Text outline",
                    Description = "0% = script default.",
                    Min = 0,
                    Max = 100,
                    Step = 5,
                    Default = settings.FontStroke,
                    Rounding = 0,
                    Suffix = "%",
                    Callback = function(value)
                        if syncingUi then return end
                        settings.FontStroke = value
                        requestFontTuningUpdate(true)
                    end
                })
            else
                fontStrokeControlRef = fontTuningContainer:AddSlider("InterfaceFontStroke", {
                    Title = "Outline",
                    Description = "0% = script default.",
                    Default = settings.FontStroke,
                    Min = 0,
                    Max = 100,
                    Rounding = 0,
                    Suffix = "%",
                    Callback = function(value)
                        if syncingUi then return end
                        settings.FontStroke = value
                        requestFontTuningUpdate(false)
                    end
                })
            end

            fontTuningUiReady = true
            if fontAppearanceSection then
                setFontAppearanceVisible(settings.FontTuningEnabled)
            end
        else
            localization:AddParagraph({
                Title = "Advanced font settings",
                Content = "Update MainUI to use font appearance controls."
            })
        end

        local advancedSections = {}
        local advancedDepBox = nil
        local function setAdvancedVisible(visible)
            if advancedDepBox and type(advancedDepBox.SetVisible) == "function" then
                advancedDepBox:SetVisible(visible == true, false)
            end
            for _, advancedSection in ipairs(advancedSections) do
                if type(advancedSection.SetVisible) == "function" then
                    advancedSection:SetVisible(visible == true)
                elseif advancedSection.Root then
                    advancedSection.Root.Visible = visible == true
                end
            end
        end

        advancedToolsToggleRef = localization:AddToggle("InterfaceAdvancedTools", {
            Title = "Advanced tools",
            Description = "Language JSON packs and custom font installer.",
            Tooltip = "Reveal Language Packs & Font Installer tabs.",
            Default = settings.AdvancedTools,
            Callback = function(value)
                if syncingUi then return end
                settings.AdvancedTools = value
                setAdvancedVisible(value)
                self:SaveSettings()
            end
        })

        local languageToolsContainer
        local fontToolsContainer
        local useModernToolsLayout = type(localization.AddDependencyBox) == "function"
            and type(localization.AddSubTabs) == "function"

        if useModernToolsLayout then
            advancedDepBox = localization:AddDependencyBox({
                DependsOn = advancedToolsToggleRef,
                Default = settings.AdvancedTools == true
            })
            if type(advancedDepBox.AddDivider) == "function" then
                advancedDepBox:AddDivider("Import & Pack Tools")
            end
            local toolTabs = advancedDepBox:AddSubTabs({
                Tabs = {
                    { Title = "Language Packs", Icon = "globe" },
                    { Title = "Font Installer", Icon = "type" }
                },
                Default = 1
            })
            languageToolsContainer = toolTabs:GetTab("Language Packs")
            fontToolsContainer = toolTabs:GetTab("Font Installer")
        else
            local languageTools = generalTarget:AddSection("Language tools")
            table.insert(advancedSections, languageTools)
            languageToolsContainer = languageTools

            local typography = generalTarget:AddSection("Font tools")
            table.insert(advancedSections, typography)
            fontToolsContainer = typography
            setAdvancedVisible(settings.AdvancedTools)
        end

        if type(languageToolsContainer.AddStatGrid) == "function" then
            local fsOk = capabilities.FileSystem == true
            local webOk = (capabilities.RemoteFetch and assets.Enabled) == true
            local fontOk = capabilities.CustomFonts == true
            languageToolsContainer:AddStatGrid("InterfaceCapabilitiesGrid", {
                Columns = 3,
                CardHeight = 60,
                Stats = {
                    {
                        Key = "FS",
                        Label = "File System",
                        Value = fsOk and "OK" or "Off",
                        Icon = "hard-drive",
                        Color = fsOk and COLOR_OK or COLOR_ERR
                    },
                    {
                        Key = "Web",
                        Label = "Web Fetch",
                        Value = webOk and "OK" or "Off",
                        Icon = "globe",
                        Color = webOk and COLOR_OK or COLOR_WARN
                    },
                    {
                        Key = "Fonts",
                        Label = "Custom Fonts",
                        Value = fontOk and "OK" or "Off",
                        Icon = "type",
                        Color = fontOk and COLOR_OK or COLOR_WARN
                    }
                }
            })
        else
            local capabilityText = string.format(
                "Save: %s | Web: %s | Fonts: %s",
                capabilities.FileSystem and "OK" or "No",
                (capabilities.RemoteFetch and assets.Enabled) and "OK" or "No",
                capabilities.CustomFonts and "OK" or "No"
            )
            languageToolsContainer:AddParagraph({
                Title = "Status",
                Content = capabilityText
            })
        end

        local modeValues = {}
        for display in pairs(MODE_VALUES) do
            table.insert(modeValues, display)
        end
        table.sort(modeValues)
        modeDropdownRef = languageToolsContainer:AddDropdown("InterfaceTranslationMode", {
            Title = "Translate by",
            Description = "Pick a translation source.",
            Values = modeValues,
            Default = modeDisplay(settings.TranslationMode),
            Callback = function(value)
                if syncingUi then return end
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
            modeDropdownRef:SetValue(modeDisplay(settings.TranslationMode))
        end)

        local installedPackValues = {}
        local function refreshLanguagePacks(dropdown)
            installedPackValues = {}
            for _, pack in ipairs(assets:GetLanguagePacks()) do
                table.insert(installedPackValues, packDisplay(pack))
            end
            if #installedPackValues == 0 then
                installedPackValues = {"No installed language packs"}
            end
            if dropdown then
                syncingUi = true
                dropdown:SetValues(installedPackValues)
                local wanted
                for _, value in ipairs(installedPackValues) do
                    if packIdFromDisplay(value) == settings.LanguagePack then
                        wanted = value
                        break
                    end
                end
                dropdown:SetValue(wanted or installedPackValues[1])
                syncingUi = false
            end
            updateSectionBadges(assets)
        end

        installedPackDropdownRef = languageToolsContainer:AddDropdown("InterfaceInstalledLanguagePack", {
            Title = "Saved pack",
            Description = "Choose an installed language pack.",
            Values = {"No installed language packs"},
            Default = "No installed language packs",
            Callback = function(value)
                if syncingUi then return end
                local id = packIdFromDisplay(value)
                if id ~= "" then
                    settings.LanguagePack = id
                    self:SaveSettings()
                end
            end
        })
        refreshLanguagePacks(installedPackDropdownRef)

        languageToolsContainer:AddInput("InterfaceLanguagePackUrl", {
            Title = "Language JSON",
            Description = "Paste a link or file path.",
            Default = settings.LanguagePackUrl,
            Placeholder = "GitHub raw URL or local file path",
            Finished = false,
            Callback = function(value)
                if syncingUi then return end
                settings.LanguagePackUrl = value
                saveSoon()
            end
        })

        languageToolsContainer:AddInput("InterfaceTemplateLocale", {
            Title = "Target code",
            Description = "Optional, e.g. ja-JP.",
            Default = settings.TemplateLocale,
            Placeholder = "th-TH",
            Finished = false,
            MaxLength = 24,
            Callback = function(value)
                if syncingUi then return end
                settings.TemplateLocale = value
                saveSoon()
            end
        })

        local function doInstallJson()
            local pack, importError = assets:ImportLanguage(settings.LanguagePackUrl)
            if not pack then
                safeNotify(library, "Language pack", "Install failed", importError)
                return
            end
            settings.LanguagePack = pack.Id
            settings.Language = pack.Locale
            library.CurrentLanguage = pack.Locale
            i18n:SetLanguage(pack.Locale)
            if languageDropdown then
                syncingUi = true
                languageDropdown:SetValues(i18n:GetLanguageOptions())
                languageDropdown:SetValue(getLanguageValue(i18n, pack.Locale))
                syncingUi = false
            end
            syncModalUi(true)
            refreshLanguagePacks(installedPackDropdownRef)
            self:SaveSettings()
            safeNotify(library, "Language pack", "Installed " .. pack.Name, "Locale: " .. pack.Locale, "check-circle-2")
        end

        local function doExportJson()
            local targetLocale = settings.TemplateLocale:match("^%s*(.-)%s*$")
            if targetLocale == "" then
                targetLocale = settings.Language
            end
            local export, exportError = assets:ExportDefaultLanguagePack(targetLocale)
            if not export then
                safeNotify(library, "Language template", "Export failed", exportError)
                return
            end
            local delivery = {}
            if export.Copied then
                table.insert(delivery, "Copied to clipboard.")
            end
            if export.Path then
                table.insert(delivery, "Saved: " .. export.Path)
            elseif export.SaveError then
                table.insert(delivery, "File save failed: " .. tostring(export.SaveError))
            end
            safeNotify(
                library,
                "Language template",
                export.Copied and "Copied" or "Template exported",
                #delivery > 0 and table.concat(delivery, "\n")
                    or "Generated, but this executor cannot save files or copy to clipboard.",
                "copy"
            )
        end

        local function doUpdatePack()
            local pack, updateError = assets:UpdateLanguage(settings.LanguagePack)
            if not pack then
                safeNotify(library, "Language pack", "Update failed", updateError)
                return
            end
            syncModalUi(true)
            refreshLanguagePacks(installedPackDropdownRef)
            safeNotify(library, "Language pack", "Updated " .. pack.Name, "Version: " .. pack.Version, "refresh-cw")
        end

        local function doRemovePack()
            local removed, removeError = assets:RemoveLanguage(settings.LanguagePack)
            if not removed then
                safeNotify(library, "Language pack", "Remove failed", removeError)
                return
            end
            settings.LanguagePack = ""
            syncModalUi(true)
            refreshLanguagePacks(installedPackDropdownRef)
            self:SaveSettings()
            safeNotify(library, "Language pack", "Removed", nil, "trash-2")
        end

        if type(languageToolsContainer.AddActionRow) == "function" then
            languageToolsContainer:AddActionRow("InterfaceLangActionsPrimary", {
                Buttons = {
                    { Title = "Install JSON", Icon = "download", Variant = "Primary", Callback = doInstallJson },
                    { Title = "Export Template", Icon = "copy", Variant = "Secondary", Callback = doExportJson }
                }
            })
            languageToolsContainer:AddActionRow("InterfaceLangActionsManage", {
                Buttons = {
                    { Title = "Update Pack", Icon = "refresh-cw", Variant = "Secondary", Callback = doUpdatePack },
                    { Title = "Remove Pack", Icon = "trash-2", Variant = "Danger", Confirm = true, ConfirmText = "Confirm Remove", Callback = doRemovePack }
                }
            })
        else
            languageToolsContainer:AddButton({ Title = "Install JSON", Description = "Install the JSON above.", Callback = doInstallJson })
            languageToolsContainer:AddButton({ Title = "Export JSON", Description = "Copy a blank template.", Callback = doExportJson })
            languageToolsContainer:AddButton({ Title = "Update pack", Description = "Download it again.", Callback = doUpdatePack })
            languageToolsContainer:AddButton({ Title = "Remove pack", Description = "Delete this pack.", Callback = doRemovePack })
        end

        -- Font Installer controls
        if type(fontToolsContainer.AddCallout) == "function" then
            fontToolsContainer:AddCallout({
                Title = "Supported Font Sources",
                Content = "Paste a Roblox Font Asset ID, Google Fonts link, or local .ttf file path.",
                Variant = "Info",
                Icon = "info",
                Dismissible = false
            })
        else
            fontToolsContainer:AddParagraph({
                Title = "Font help",
                Content = "Use ID, Google Fonts, or a font file."
            })
        end

        if type(fontToolsContainer.AddSegmentedControl) == "function" then
            fontTargetControlRef = fontToolsContainer:AddSegmentedControl("InterfaceFontTarget", {
                Title = "Apply font to",
                Description = "Choose which scripts to override.",
                Values = {"Both", "Latin", "Thai"},
                Default = settings.FontTarget,
                Callback = function(value)
                    if syncingUi then return end
                    settings.FontTarget = value
                    self:SaveSettings()
                end
            })
        else
            fontTargetControlRef = fontToolsContainer:AddDropdown("InterfaceFontTarget", {
                Title = "Apply font to",
                Description = "Choose the text to change.",
                Values = {"Both", "Latin", "Thai"},
                Default = settings.FontTarget,
                Callback = function(value)
                    if syncingUi then return end
                    settings.FontTarget = value
                    self:SaveSettings()
                end
            })
        end

        fontToolsContainer:AddInput("InterfaceFontUrl", {
            Title = "Font link / ID",
            Description = "Paste an ID, link, or file.",
            Default = settings.FontUrl,
            Placeholder = "Google Fonts link, Asset ID, or .ttf file",
            Finished = false,
            Callback = function(value)
                if syncingUi then return end
                settings.FontUrl = value
                saveSoon()
            end
        })

        local function doInstallFont()
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
            syncModalUi(false)
            self:SaveSettings()
            safeNotify(library, "Font", "Installed " .. profile.Name, "Applied to the current UI.", "check-circle-2")
        end

        local function doDefaultFont()
            settings.FontProfile = "default"
            fonts:ApplyProfile("default")
            refreshFontProfiles()
            syncModalUi(false)
            self:SaveSettings()
            safeNotify(library, "Font", "Script default font restored", nil, "rotate-ccw")
        end

        local function doRemoveFont()
            local removed, removeError = assets:RemoveFont(settings.FontProfile)
            if not removed then
                safeNotify(library, "Font", "Remove failed", removeError)
                return
            end
            settings.FontProfile = "default"
            refreshFontProfiles()
            syncModalUi(false)
            self:SaveSettings()
            safeNotify(library, "Font", "Profile removed", nil, "trash-2")
        end

        if type(fontToolsContainer.AddActionRow) == "function" then
            fontToolsContainer:AddActionRow("InterfaceFontActions", {
                Buttons = {
                    { Title = "Install", Icon = "download", Variant = "Primary", Callback = doInstallFont },
                    { Title = "Default", Icon = "rotate-ccw", Variant = "Secondary", Callback = doDefaultFont },
                    { Title = "Remove", Icon = "trash-2", Variant = "Danger", Confirm = true, ConfirmText = "Confirm", Callback = doRemoveFont }
                }
            })
        else
            fontToolsContainer:AddButton({ Title = "Install font", Description = "Install and use this font.", Callback = doInstallFont })
            fontToolsContainer:AddButton({ Title = "Default font", Description = "Use the script font.", Callback = doDefaultFont })
            fontToolsContainer:AddButton({ Title = "Remove font", Description = "Remove this profile.", Callback = doRemoveFont })
        end

        if not useModernToolsLayout then
            setAdvancedVisible(settings.AdvancedTools)
        end

        -- Sync helper used by Reload / ResetSettings / SetSetting
        local function syncAllControls(refreshLangs)
            settings = self.Settings
            syncingUi = true
            pcall(function()
                if translationToggleRef and type(translationToggleRef.SetValue) == "function" then
                    translationToggleRef:SetValue(settings.TranslationEnabled == true, true, true)
                end
                if fontTuningToggleRef and type(fontTuningToggleRef.SetValue) == "function" then
                    fontTuningToggleRef:SetValue(settings.FontTuningEnabled == true, true, true)
                end
                if advancedToolsToggleRef and type(advancedToolsToggleRef.SetValue) == "function" then
                    advancedToolsToggleRef:SetValue(settings.AdvancedTools == true, true, true)
                end
                if fontWeightDropdownRef and type(fontWeightDropdownRef.SetValue) == "function" then
                    fontWeightDropdownRef:SetValue(settings.FontWeight, true)
                end
                if fontStyleControlRef and type(fontStyleControlRef.SetValue) == "function" then
                    fontStyleControlRef:SetValue(settings.FontStyle, true)
                end
                if fontSizeSliderRef and type(fontSizeSliderRef.SetValue) == "function" then
                    fontSizeSliderRef:SetValue(settings.FontSizeScale, true)
                end
                if fontLineSliderRef and type(fontLineSliderRef.SetValue) == "function" then
                    fontLineSliderRef:SetValue(settings.FontLineHeight, true)
                end
                if fontStrokeControlRef and type(fontStrokeControlRef.SetValue) == "function" then
                    fontStrokeControlRef:SetValue(settings.FontStroke, true)
                end
                if fontTargetControlRef and type(fontTargetControlRef.SetValue) == "function" then
                    fontTargetControlRef:SetValue(settings.FontTarget, true)
                end
                if modeDropdownRef and type(modeDropdownRef.SetValue) == "function" then
                    modeDropdownRef:SetValue(modeDisplay(settings.TranslationMode), true)
                end
                if languageDropdown and type(languageDropdown.SetValue) == "function" then
                    languageDropdown:SetValue(getLanguageValue(i18n, settings.Language), true)
                end
            end)
            syncingUi = false
            pcall(refreshFontProfiles)
            refreshLanguagePacks(installedPackDropdownRef)
            setFontAppearanceVisible(settings.FontTuningEnabled)
            setAdvancedVisible(settings.AdvancedTools)
            updateSectionBadges(assets)
            syncModalUi(refreshLangs)
        end
        self._SyncUI = syncAllControls

        if useModal and configTarget then
            local storageSection = configTarget:AddSection({
                Title = "Interface Storage",
                Icon = "hard-drive",
                Style = "Card",
                Badge = capabilities.FileSystem and "SYNCED" or "MEMORY"
            })
            local scopeLabel = tostring((self.Configuration and self.Configuration.ScriptId) or "shared")
            local initialPacks = 0
            pcall(function()
                initialPacks = #assets:GetLanguagePacks()
            end)

            if type(storageSection.AddStatGrid) == "function" then
                storageStatGridRef = storageSection:AddStatGrid("InterfaceStorageStats", {
                    Columns = 3,
                    CardHeight = 60,
                    Stats = {
                        {
                            Key = "Storage",
                            Label = "Disk Save",
                            Value = capabilities.FileSystem and "Ready" or "Memory",
                            Icon = "hard-drive",
                            Color = capabilities.FileSystem and COLOR_OK or COLOR_WARN
                        },
                        {
                            Key = "Scope",
                            Label = "Script Scope",
                            Value = scopeLabel,
                            Icon = "layers",
                            Color = COLOR_INFO
                        },
                        {
                            Key = "Packs",
                            Label = "Lang Packs",
                            Value = tostring(initialPacks),
                            Icon = "globe",
                            Color = COLOR_INFO
                        }
                    }
                })
            end

            storageSection:AddParagraph({
                Title = "Folder Path",
                Content = string.format("%s/options.json  |  i18n/%s/interface.json", tostring(self.Folder or "FluentSettings"), scopeLabel)
            })

            local function doSave()
                local ok, err = self:SaveSettings()
                if ok then
                    safeNotify(library, "Interface", "Saved interface settings", tostring(self.Folder or "FluentSettings"), "save")
                else
                    safeNotify(library, "Interface", "Save failed", tostring(err or "Unknown error"))
                end
            end

            local function doReload()
                self:LoadSettings()
                settings = self.Settings
                applyCoreSettings(library, settings)
                self:ApplyCustomizationSettings()
                syncAllControls(true)
                safeNotify(library, "Interface", "Reloaded saved settings", nil, "refresh-cw")
            end

            local function doResetAll()
                self:ResetSettings()
                safeNotify(library, "Interface", "Restored all interface defaults", nil, "rotate-ccw")
            end

            if type(storageSection.AddActionRow) == "function" then
                storageSection:AddActionRow("InterfaceStorageActions", {
                    Buttons = {
                        { Title = "Save", Icon = "save", Variant = "Primary", Callback = doSave },
                        { Title = "Reload", Icon = "refresh-cw", Variant = "Secondary", Callback = doReload },
                        { Title = "Reset All", Icon = "rotate-ccw", Variant = "Danger", Confirm = true, ConfirmText = "Confirm Reset", Callback = doResetAll }
                    }
                })
            else
                storageSection:AddButton({ Title = "Save Interface Settings", Description = "Write current preferences to disk.", Callback = doSave })
                storageSection:AddButton({ Title = "Reload Saved Settings", Description = "Reload saved preferences from disk.", Callback = doReload })
            end
        end

        -- Public convenience for callers that need to refresh the selector
        -- after installing a pack programmatically.
        self.RefreshLanguagePacks = function()
            refreshLanguagePacks(installedPackDropdownRef)
        end

        updateSectionBadges(assets)
        scheduleLegacyTabLauncher()
    end

    function InterfaceManager:AttachToSettingsModal(options)
        assert(self.Library, "Must set InterfaceManager.Library")
        local opts = {}
        if type(options) == "table" then
            for k, v in pairs(options) do
                opts[k] = v
            end
        end
        opts.InModal = true
        opts.UseTab = false
        return self:BuildInterfaceSection(nil, opts)
    end
end

return InterfaceManager
