--[[
	Loads MainUI.lua / InterfaceManager.lua into a fresh fake world.

	Sources are compiled once per process and loaded per world with a custom
	environment, so each test starts from a clean library state.
]]

local fs = require("@lune/fs")
local luau = require("@lune/luau")
local process = require("@lune/process")

local Engine = require("./fake_roblox")

local Boot = {}

local root = process.cwd:gsub("/$", "")
local sourcePaths = {
	MainUI = root .. "/MainUI.lua",
	InterfaceManager = root .. "/InterfaceManager.lua",
}

local bytecodeCache = {}

local function bytecode(name: string): string
	local cached = bytecodeCache[name]
	if cached then
		return cached
	end
	local path = sourcePaths[name]
	local source = fs.readFile(path)
	local compiled = luau.compile(source, { optimizationLevel = 1, debugLevel = 1 })
	bytecodeCache[name] = compiled
	return compiled
end

function Boot.setSource(name: string, path: string)
	sourcePaths[name] = path
	bytecodeCache[name] = nil
end

function Boot.sourcePath(name: string): string
	return sourcePaths[name]
end

local function load(name: string, world)
	local chunk = luau.load(bytecode(name), {
		debugName = name .. ".lua",
		environment = world.env,
		injectGlobals = true,
	})
	return chunk()
end

--[[
	Options are passed to Engine.new. Additional keys:
	  genv: table merged into getgenv() before loading (e.g. ATGSplash)
]]
function Boot.new(options: { [string]: any }?)
	options = options or {}
	local world = Engine.new(options)
	if options.genv then
		for key, value in options.genv do
			world.genv[key] = value
		end
	end
	world.env.require = function(target)
		error("require is not available in the fake engine: " .. tostring(target), 2)
	end
	local context = { world = world }
	context.Library = load("MainUI", world)
	function context.loadInterfaceManager()
		if not context.InterfaceManager then
			context.InterfaceManager = load("InterfaceManager", world)
		end
		return context.InterfaceManager
	end
	return context
end

return Boot
