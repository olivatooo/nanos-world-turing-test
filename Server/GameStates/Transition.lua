function TransitionToStage(newStage)
	if GameState.Stage ~= newStage then
		previousStage = GameState.Stage
		GameState.Stage = newStage
		print("[Server] Game State Transition: " .. GetStageName(previousStage) .. " -> " .. GetStageName(newStage))

		if newStage == GameStage.WaitingForPlayers then
			GameState.Time = Config.GameStateTimes.WaitingForPlayers
			WaitingForPlayers()
		elseif newStage == GameStage.PreparingMatch then
			GameState.Time = Config.GameStateTimes.PreparingMatch
			PreparingForMatch()
		elseif newStage == GameStage.Running then
			GameState.Time = Config.GameStateTimes.Running
			GameState.AmountOfTotalFakers = 0
			GameState.AmountOfTotalProps = 0
			GameState.AmountOfTotalHunters = 0
			GameState.AmountOfFakersKilled = 0
			GameState.AmountOfTotalHuntersKilled = 0
			GameState.AmountOfPropsDelivered = 0
			for _, v in pairs(Character.GetAll()) do
				if v:GetTeam() == FakerTeam then
					GameState.AmountOfTotalFakers = GameState.AmountOfTotalFakers + 1
					GameState.AmountOfTotalProps = GameState.AmountOfTotalProps + Config.Spawns.PropsPerFaker
				elseif v:GetTeam() == HunterTeam then
					GameState.AmountOfTotalHunters = GameState.AmountOfTotalHunters + 1
				end
			end
			GameState.AmountOfTotalProps = GameState.AmountOfTotalProps + GameState.AmountOfTotalFakers
			Running()
		elseif newStage == GameStage.EndGame then
			GameState.Time = Config.GameStateTimes.EndGame
			EndGame()
		end
		Events.BroadcastRemote("GameState", GameState)
	end
end
