local previousStage = nil

Package.Require("Reset.lua")
Package.Require("Transition.lua")
Package.Require("Running.lua")
Package.Require("EndGame.lua")
Package.Require("PreparingForMatch.lua")
Package.Require("WaitingForPlayers.lua")

function GetStageName(stage)
	if stage == GameStage.WaitingForPlayers then
		return "Waiting For Players"
	elseif stage == GameStage.PreparingMatch then
		return "Preparing Match"
	elseif stage == GameStage.Running then
		return "Running"
	elseif stage == GameStage.EndGame then
		return "End Game"
	else
		return "Unknown"
	end
end

MinPlayers = 2
Timer.SetInterval(function()
	local playerCount = #Player.GetAll()
	if playerCount == 0 then
		return true
	end

	if playerCount >= MinPlayers then
		GameState.Time = GameState.Time - 1
	end

	if GameState.Stage == GameStage.WaitingForPlayers then
		if GameState.Time <= 0 then
			TransitionToStage(GameStage.PreparingMatch)
		end
	elseif GameState.Stage == GameStage.PreparingMatch then
		if GameState.Time <= 0 then
			TransitionToStage(GameStage.Running)
		end
	elseif GameState.Stage == GameStage.Running then
		if GameState.Time <= 0 then
			TransitionToStage(GameStage.EndGame)
		end
	elseif GameState.Stage == GameStage.EndGame then
		if GameState.Time <= 0 then
			TransitionToStage(GameStage.WaitingForPlayers)
		end
	end
	Events.BroadcastRemote("GameState", GameState)
end, 1000)

Package.Require("Commands/Transition.lua")
