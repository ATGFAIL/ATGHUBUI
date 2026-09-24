local Boot = require("../harness/boot")

return function(t)
	t.test("MainUI loads and returns the library", function()
		local context = Boot.new()
		local Library = context.Library
		t.equal(type(Library), "table")
		t.equal(Library.Version, "1.6.0")
		t.truthy(Library.GUI, "library GUI exists")
		t.equal(context.world.genv.Fluent, Library, "getgenv().Fluent is set")
	end)

	t.test("CreateWindow builds a window", function()
		local context = Boot.new()
		local env = context.world.env
		local window = context.Library:CreateWindow({
			Title = "Test",
			SubTitle = "harness",
			TabWidth = 160,
			Size = env.UDim2.fromOffset(580, 460),
			Theme = "Dark",
			MinimizeKey = env.Enum.KeyCode.LeftControl,
		})
		t.truthy(window, "window returned")
		local tab = window:AddTab({ Title = "Main", Icon = "home" })
		t.truthy(tab, "tab returned")
	end)
end
