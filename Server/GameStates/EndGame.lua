function EndGame()
	-- Increment round when transitioning from EndGame to WaitingForPlayers (round ended)			
	GameState.CurrentRound = (GameState.CurrentRound or 0) + 1
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
		Console.Log(string.format("Winner: Fakers (blue) - Props delivered: %d/%d", GameState.AmountOfPropsDelivered, GameState.AmountOfTotalProps))
	elseif GameState.AmountOfFakersKilled >= GameState.AmountOfTotalFakers and GameState.AmountOfTotalFakers > 0 then
		-- Check if all fakers are killed (Hunter wins)
		winnerTeam = "red" -- Hunter wins
		Console.Log(string.format("Winner: Hunters (red) - Fakers killed: %d/%d", GameState.AmountOfFakersKilled, GameState.AmountOfTotalFakers))
	elseif
			GameState.AmountOfTotalHuntersKilled >= GameState.AmountOfTotalHunters
			and GameState.AmountOfTotalHunters > 0
	then
		-- Check if all hunters are killed (Fakers win)
		winnerTeam = "blue" -- Fakers win
		Console.Log(string.format("Winner: Fakers (blue) - Hunters killed: %d/%d", GameState.AmountOfTotalHuntersKilled, GameState.AmountOfTotalHunters))
	else
		Console.Log(string.format("Winner: Hunters (red) - Timeout (Props: %d/%d, Fakers killed: %d/%d, Hunters killed: %d/%d)", 
			GameState.AmountOfPropsDelivered, GameState.AmountOfTotalProps,
			GameState.AmountOfFakersKilled, GameState.AmountOfTotalFakers,
			GameState.AmountOfTotalHuntersKilled, GameState.AmountOfTotalHunters))
	end

	-- Collect per-round scores for each player
	-- Use server-side score cache (GetPlayerScore) instead of GetValue to avoid timing issues
	Console.Log("=== Round Scores ===")
	local roundScoreboard = {}
	local players = Player.GetAll()
	for _, player in pairs(players) do
		local playerId = player:GetID()
		local playerName = player:GetName()
		local currentScore = GetPlayerScore(player)
		local roundStartScore = roundStartScores and roundStartScores[playerId] or 0
		local roundScore = currentScore - roundStartScore

		if #Player.GetAll() >= 4 then
			Events.CallRemote("SubmitScoreToSteamLeaderboard", player, roundScore)
		end

		table.insert(roundScoreboard, {
			name = playerName,
			score = roundScore,
			kills = GetPlayerKills(player),
			deaths = GetPlayerDeaths(player),
			deliveries = GetPlayerDeliveries(player),
			avatar = player:GetAccountIconURL(),
		})

		Console.Log(string.format("%s: %d points (current: %d, start: %d)", playerName, roundScore, currentScore, roundStartScore))
	end
	Console.Log("===================")

	-- Sort round scoreboard by score (descending)
	table.sort(roundScoreboard, function(a, b)
		return a.score > b.score
	end)

	-- Check if this is the final round
	local isFinalRound = GameState.CurrentRound >= GameState.MaxRounds

	-- Broadcast winner and round scoreboard to all clients
	-- Each client will determine their own team and stats
	Events.BroadcastRemote("EndGame", winnerTeam, roundScoreboard, isFinalRound)

	Timer.SetTimeout(Clear, 2500)
end

function TriggerEndGame()
	if GameState.Stage == GameStage.Running then
		TransitionToStage(GameStage.EndGame)
		-- EndGame() is called in TransitionToStage
	end
end
