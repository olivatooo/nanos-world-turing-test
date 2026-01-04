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

	-- Collect per-round scores for each player
	Console.Log("=== Round Scores ===")
	local roundScoreboard = {}
	local players = Player.GetAll()
	for _, player in pairs(players) do
		local playerId = player:GetID()
		local playerName = player:GetName()
		local currentScore = player:GetValue("Score") or 0
		local roundStartScore = roundStartScores and roundStartScores[playerId] or 0
		local roundScore = currentScore - roundStartScore

		if #Player.GetAll() >= 4 then
			Events.BroadcastRemote("SubmitScoreToSteamLeaderboard", roundScore)
		end

		table.insert(roundScoreboard, {
			name = playerName,
			score = roundScore,
			kills = player:GetValue("Kills") or 0,
			deaths = player:GetValue("Deaths") or 0,
			deliveries = player:GetValue("Deliveries") or 0,
			avatar = player:GetAccountIconURL(),
		})

		Console.Log(string.format("%s: %d points", playerName, roundScore))
	end
	Console.Log("===================")

	-- Sort round scoreboard by score (descending)
	table.sort(roundScoreboard, function(a, b)
		return a.score > b.score
	end)

	-- Broadcast winner and round scoreboard to all clients
	-- Each client will determine their own team and stats
	Events.BroadcastRemote("EndGame", winnerTeam, roundScoreboard)

	Timer.SetTimeout(Clear, 2500)
end

function TriggerEndGame()
	if GameState.Stage == GameStage.Running then
		TransitionToStage(GameStage.EndGame)
		-- EndGame() is called in TransitionToStage
	end
end
