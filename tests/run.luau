--[[
	Test runner. Usage from the repository root:
	  lune run tests/run.luau                  run every spec
	  lune run tests/run.luau -- dropdown       run specs whose file name contains "dropdown"
	Environment:
	  UPDATE_SNAPSHOTS=1                        rewrite snapshot files instead of comparing
]]

local fs = require("@lune/fs")
local process = require("@lune/process")
local task = require("@lune/task")

local filters = {}
for _, argument in process.args do
	if argument ~= "--" then
		table.insert(filters, argument:lower())
	end
end

local TEST_TIMEOUT = 60

local results = { passed = 0, failed = 0, failures = {} }

local function describeValue(value: any): string
	if type(value) == "string" then
		return string.format("%q", value)
	end
	return tostring(value)
end

local function newContext(fileName: string)
	local t = { tests = {} }

	function t.test(name: string, fn: () -> ())
		table.insert(t.tests, { name = name, fn = fn })
	end

	function t.equal(actual: any, expected: any, message: string?)
		if actual ~= expected then
			error(
				string.format(
					"%sexpected %s, got %s",
					message and (message .. ": ") or "",
					describeValue(expected),
					describeValue(actual)
				),
				2
			)
		end
	end

	function t.notEqual(actual: any, unexpected: any, message: string?)
		if actual == unexpected then
			error(string.format("%sdid not expect %s", message and (message .. ": ") or "", describeValue(actual)), 2)
		end
	end

	function t.truthy(value: any, message: string?)
		if not value then
			error((message or "expected a truthy value") .. " (got " .. describeValue(value) .. ")", 2)
		end
	end

	function t.falsy(value: any, message: string?)
		if value then
			error((message or "expected a falsy value") .. " (got " .. describeValue(value) .. ")", 2)
		end
	end

	function t.near(actual: number, expected: number, epsilon: number?, message: string?)
		if type(actual) ~= "number" or math.abs(actual - expected) > (epsilon or 1e-6) then
			error(
				string.format(
					"%sexpected ~%s, got %s",
					message and (message .. ": ") or "",
					tostring(expected),
					describeValue(actual)
				),
				2
			)
		end
	end

	function t.errors(fn: () -> (), pattern: string?, message: string?)
		local ok, err = pcall(fn)
		if ok then
			error((message or "expected an error") .. " but the call succeeded", 2)
		end
		if pattern and not tostring(err):find(pattern) then
			error(string.format("error %q does not match %q", tostring(err), pattern), 2)
		end
	end

	function t.noErrors(fn: () -> (), message: string?)
		local ok, err = pcall(fn)
		if not ok then
			error((message or "unexpected error") .. ": " .. tostring(err), 2)
		end
	end

	-- Snapshot comparison. Snapshots live in tests/snapshots/<name>.txt.
	function t.snapshot(name: string, text: string)
		local path = "tests/snapshots/" .. name .. ".txt"
		if process.env.UPDATE_SNAPSHOTS == "1" or not fs.isFile(path) then
			fs.writeFile(path, text .. "\n")
			return
		end
		local expected = fs.readFile(path)
		if expected ~= text .. "\n" then
			local expectedLines = expected:split("\n")
			local actualLines = (text .. "\n"):split("\n")
			for index = 1, math.max(#expectedLines, #actualLines) do
				if expectedLines[index] ~= actualLines[index] then
					fs.writeFile(path .. ".actual", text .. "\n")
					error(
						string.format(
							"snapshot %s differs at line %d\n  expected: %s\n  actual:   %s\n  (full output written to %s.actual)",
							name,
							index,
							tostring(expectedLines[index]),
							tostring(actualLines[index]),
							path
						),
						2
					)
				end
			end
		end
	end

	t.fileName = fileName
	return t
end

local function runTest(fileName: string, test)
	local done = false
	local ok, err
	task.spawn(function()
		ok, err = xpcall(test.fn, function(message)
			return debug.traceback(tostring(message), 2)
		end)
		done = true
	end)
	local started = os.clock()
	while not done do
		if os.clock() - started > TEST_TIMEOUT then
			ok, err = false, "timed out after " .. TEST_TIMEOUT .. "s"
			break
		end
		task.wait(0.01)
	end
	if ok then
		results.passed += 1
		print("  ok    " .. test.name)
	else
		results.failed += 1
		print("  FAIL  " .. test.name)
		print("        " .. tostring(err):gsub("\n", "\n        "))
		table.insert(results.failures, fileName .. " :: " .. test.name)
	end
end

local specFiles = {}
for _, entry in fs.readDir("tests/specs") do
	if entry:match("%.spec%.luau$") then
		local include = #filters == 0
		for _, filter in filters do
			if entry:lower():find(filter, 1, true) then
				include = true
			end
		end
		if include then
			table.insert(specFiles, entry)
		end
	end
end
table.sort(specFiles)

for _, fileName in specFiles do
	print(fileName)
	local register = require("./specs/" .. fileName:gsub("%.luau$", ""))
	local t = newContext(fileName)
	register(t)
	for _, test in t.tests do
		runTest(fileName, test)
	end
end

print(string.format("\n%d passed, %d failed", results.passed, results.failed))
if results.failed > 0 then
	for _, failure in results.failures do
		print("  - " .. failure)
	end
	process.exit(1)
end
process.exit(0)
