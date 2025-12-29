function EndGame()
	-- Determine winner based on game conditions
	-- Priority order:
	-- 1. All props delivered → Fakers win (blue)
	-- 2. All fakers killed → Hunter wins (red)
	-- 3. All hunters killed → Fakers win (blue)
	-- 4. Timer runs out → Hunter wins (red) - default

	local winnerTeam = "red" -- Default to Hunter (red) for timeout

	-- Check if all props are delivered (Fakers win) - highest priority
	if GameState.AmountOfPropsDelivered >= GameState.AmountOfTotalProps and GameState.AmountOfTotalProps > 0 then
		winnerTeam = "blue" -- Fakers win
	elseif GameState.AmountOfFakersKilled >= GameState.AmountOfTotalFakers and GameState.AmountOfTotalFakers > 0 then
		-- Check if all fakers are killed (Hunter wins)
		winnerTeam = "red" -- Hunter wins
	elseif
		GameState.AmountOfTotalHuntersKilled >= GameState.AmountOfTotalHunters
		and GameState.AmountOfTotalHunters > 0
	then
		-- Check if all hunters are killed (Fakers win)
		winnerTeam = "blue" -- Fakers win
	end

	-- Broadcast winner to all clients
	-- Each client will determine their own team and stats
	Events.BroadcastRemote("EndGame", winnerTeam)

	Timer.SetTimeout(Clear, 1000)
end

function TriggerEndGame()
	if GameState.Stage == GameStage.Running then
		TransitionToStage(GameStage.EndGame)
		-- EndGame() is called in TransitionToStage
	end
end
