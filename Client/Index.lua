Package.Require("Debug.lua")
Package.Require("Utils.lua")

WebUI = WebUI(
	"Awesome UI", -- Name
	"file://UI/Index.html", -- Path relative to this package (Client/)
	WidgetVisibility.Visible -- Is Visible on Screen
)

WebUI:SpawnSound(Vector(), true, 1)

Package.Require("Input.lua")
Package.Require("SFX.lua")
Package.Require("Binds/Scoreboard.lua")
Package.Require("GameState.lua")
Package.Require("Skills/Skills.lua")
