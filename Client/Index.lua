Package.Require("Debug.lua")
Package.Require("Utils.lua")
-- Client.SetDebugEnabled(false)
Sky.Spawn()
Sky.SetTimeOfDay(11, 0)
Sky.SetSunLightIntensity(10)

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

-- Steam Scoreboard
Steam.FindLeaderboard("turing-test")
Client.SetEscapeMenuLeaderboard(true, "turing-test", "Turing Test Top Players")

Events.SubscribeRemote("SubmitScoreToSteamLeaderboard", function(score)
	if score == 0 then
		return
	end
	Steam.IncrementLeaderboardScore("turing-test", score)
end)
