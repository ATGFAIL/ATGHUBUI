# Tests

## Headless (no Roblox needed)

Requires [Lune](https://github.com/lune-org/lune) 0.10 (`cargo install lune --locked`).
Run from the repository root:

```sh
lune run tests/run.luau                 # every spec
lune run tests/run.luau -- dropdown     # specs whose file name contains "dropdown"
UPDATE_SNAPSHOTS=1 lune run tests/run.luau   # rewrite snapshots after an intended change
```

- `harness/fake_roblox.luau` is a small, strict stand-in for the Roblox engine and
  executor API (instances, signals, services, input, file system, `request`).
  Property names and types are validated against Lune's reflection database, so a
  bad write fails here as it would in Roblox. Layout (`Absolute*`) is approximate.
- `harness/kitchen_sink.luau` builds a window that uses every element and records
  every callback.
- `specs/01_characterization` and `specs/02_exercise` snapshot what the library does
  (including known bugs). A refactor must leave these snapshots unchanged.
- `specs/03_perf` counts property writes, live connections and destroyed instances
  that stay referenced (leaks). These counts do not depend on machine speed.
- `snapshots/` holds the recorded output. Review diffs of these files like code.

## In game (run in your executor)

- `ingame/smoke.lua` prints PASS / FAIL / SKIP for each known bug plus a manual checklist.
- `ingame/bench.lua` measures build time, heap, per-call cost and frame times.
- `ingame/playground.lua` opens a window with every element, long lists, notification
  buttons, a theme picker and InterfaceManager settings, for the manual checklist.

Each script loads `MainUI.lua` from `CONFIG.Url` (or `CONFIG.LocalFile` inside the
executor workspace folder). Instead of editing the file, set `getgenv().ATGTest` first;
any `CONFIG` key can be overridden:

```lua
getgenv().ATGTest = {
    Url = "https://raw.githubusercontent.com/ATGFAIL/ATGHUBUI/main/MainUI.lua",
    Label = "baseline",
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/ATGFAIL/ATGHUBUI/claude/visible-files-wq5mqr/tests/ingame/smoke.lua"))()
```

smoke and bench copy their report to the clipboard; paste it somewhere before the next
run overwrites it. To check the splash screen, set `getgenv().ATGSplash = true` before
running the playground.

## Lint

`tools/selene/check.sh` runs selene with a hand-written std (the Roblox std cannot be
generated offline) and fails only on findings that are not in `baseline.txt`.
