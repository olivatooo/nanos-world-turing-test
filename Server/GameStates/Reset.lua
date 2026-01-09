function ResetGameState()
	GameState = {
		Time = Config.GameStateTimes.Reset,
		Started = false,
		Stage = GameStage.WaitingForPlayers,
		AmountOfFakersKilled = 0,
		AmountOfTotalFakers = 0,
		AmountOfPropsDelivered = 0,
		AmountOfTotalProps = 0,
		AmountOfTotalHunters = 0,
		AmountOfTotalHuntersKilled = 0,
		Winner = 0,
		CurrentRound = 0,
		MaxRounds = Config.Rounds.MaxRounds,
	}
	previousStage = nil
end

ResetGameState()
