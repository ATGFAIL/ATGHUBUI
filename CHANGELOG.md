# Changelog

## ATG 2.0.0 (`Library.ATGVersion`)

`Library.Version` stays `"1.6.0"` (the Fluent version) for scripts that check it.

### Behavior changes for existing scripts

Defaults now match Fluent. Each extra is one `CreateWindow` option away.

| What | Before | Now | To get the old behavior |
|---|---|---|---|
| Splash screen | Shown on every load | Off | `getgenv().ATGSplash = true` before loading, `CreateWindow{Splash = true}`, or `Library:ShowSplash()` |
| Sidebar search box, its panel and Ctrl+K | Always added; tabs moved down 34 px | Off; tabs at Fluent's position | `CreateWindow{Search = true}` |
| Confirmation guessed from button titles ("Delete", "Reset"...) | On; matched words inside words ("Clearance") | Off; whole words only | `CreateWindow{SmartConfirm = true}`. `Confirm = ...` on a button always asks |
| Translation mode | `auto`: interface text was sent to translate.atgofficial.net | `community`: language packs only | Choose Auto or Machine in InterfaceManager (asks for consent first), or pass `Mode` yourself |
| Saved InterfaceManager settings with mode `auto` | | Migrated once to `community`; `machine` is kept | Choose it again |
| Minimize key Ctrl/Shift/Alt | Minimized on key down (Ctrl: after 0.16 s) | Minimizes on release, only if no other key or click happened while held | Pick a key that is not Ctrl/Shift/Alt (e.g. Insert or End) to minimize on key down |
| `CreateWindow` without `MinimizeKey` | Key was nil (Minimize could error) | LeftControl | Pass another key; a key name string such as `"RightShift"` also works |
| `Library:Round` / Slider values | Returned a truncated string, e.g. `"2.34"` | Returns a number rounded half up: `Rounding = 0` turns 5.7 into 6 | |
| Dropdown selection | On press | On release; a touch that scrolled the list selects nothing | |
| Dropdown clear button on single-choice lists | Always shown; set the value to nil | Shown only with `AllowNull = true` | `AllowNull = true` |
| Close button | Deleted every ScreenGui whose name contained "fluent" or "atg" (other hubs, some games' GUIs) | Unloads this library only; old ATG floating toggles are removed by exact name | |
| Second `CreateWindow` | Printed a message and returned nil | Warns and returns the existing window | |
| `CreateWindow` after `Destroy` | | Warns and returns nil | Load the library again |
| Workspace "Recent" | Filled by every `SetValue`, including config loads | Only controls the user changed | |
| Fixed colors (Workspace, input underline and label, "Select All") | Dark red / blue on every theme | Follow the theme | |

### New

- `Library.OnUnload:Connect(fn)`: runs once, first thing in `Library:Destroy()`.
- `Library.ATGVersion`, `Library:ShowSplash()`.
- `CreateWindow` options: `Search`, `SmartConfirm`, `Splash`.
- The RGB theme cycles its accent and border colors (about 10 times a second, paused while minimized).
- Machine translations are cached on disk per script and language (at most 2,000 entries), so later sessions need no requests.
- Tapping a slider's bar sets the value; windows larger than the screen are shrunk to fit, and dragging keeps the title bar on screen.
- Language packs now translate dialog buttons and search placeholders.

### Fixes

- Dropdown `Multi`: no Default no longer errors; `Default` and `SetValue` accept `{"A"}` or `{A = true}`; the Default table is not modified; values survive a JSON save; "Select All" matches the filtered list (color codes, numbers).
- `Library:Notify` and `Dialog:Close` no longer yield.
- `Library:Destroy` runs once, removes the Acrylic DepthOfFieldEffect, and is what the Close button calls.
- Keybind: `SetValue(nil)` keeps the key; touch or gamepad input while picking cancels instead of getting stuck; two keys pressed together no longer both bind.
- Unknown enum or key names in saved profiles or `ATGButtonUI` config no longer throw.
- `SafeCallback` reports errors that are not strings.
- Open dropdowns close when the window is minimized or the tab changes.
- Notifications recompute their width when the screen rotates.
- `GetLanguageCode` accepts locale codes like `th-TH` without an installed pack (it fell back to English), and an exact-locale pack wins over a base-language pack.
- Memory: destroyed elements are released from the theme registry, the signal list and hover motors (rebuilding a 40-item dropdown 20 times used to keep 560 destroyed instances alive).

### Privacy and safety

- Runtime text (notifications, and `SetTitle`/`SetDesc` after an element is built) is never sent for machine translation.
- Machine translation has a per-language quota for the whole session (`I18n.MachineRequestLimit`, default 200) and at most 4 requests per second.
- Translations shown in RichText labels are escaped.
- Remote pack/font URLs with credentials, IPv6 literals or local/numeric hosts are refused (a basic guard; a public name that resolves to a private address is not caught).

### Performance

Measured with the headless counters in `tests/specs/03_perf.spec.luau` (independent of machine speed):

| Scenario | Before | Now |
|---|---|---|
| Property writes to build 100 toggles | 95,300 | 10,900 |
| Property writes for one toggle click (100 toggles) | 1,641 | 5 |
| Peak RenderStepped connections while animating | 101 | 1 |
| Writes when moving a window with 30 closed dropdowns | 30 | 0 |
| Requests while building a UI in Thai (default mode) | 24 | 0 |

- `Creator.OverrideTag` re-themes one object instead of all of them (this also stopped toggle clicks from resetting other elements' hover state).
- Animations share one RenderStepped connection.
- Closed dropdowns do no work; the floating button animates on Heartbeat only while shown.
- Language switches re-apply fonts only when a custom font profile or text tuning is active.
- Flipper's unused test modules were removed from the bundle (368 lines).

### Not changed

- How the GUI is parented and protected.
- Acrylic (apart from removing its DepthOfFieldEffect on Destroy).
- Workspace element IDs and saved file formats (settings gain `MachineTranslationConsent` and `SettingsVersion`).
