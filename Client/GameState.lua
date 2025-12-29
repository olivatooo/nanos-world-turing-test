-- Game State Enum (must match server)
GameStage = {
	WaitingForPlayers = 1,
	PreparingMatch = 2,
	Running = 3,
	EndGame = 4,
}

local previousStage = nil

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

function ShowGameStagePage()
	Console.Log("Showing Game Stage:" .. GetStageName(GameState.Stage))
	if GameState.Stage == GameStage.WaitingForPlayers then
		WebUI:CallEvent("showHowToPlayByStage", GameState.Stage)
	elseif GameState.Stage == GameStage.PreparingMatch then
		WebUI:CallEvent("showHowToPlayByStage", GameState.Stage)
	elseif GameState.Stage == GameStage.Running then
		WebUI:CallEvent("showPage", "gameUI")
	elseif GameState.Stage == GameStage.EndGame then
		WebUI:CallEvent("showPage", "endScreen")
	end
end

function GameState(game_state)
	GameState = game_state
	if previousStage == nil then
		ShowGameStagePage()
	end
	if previousStage ~= nil and game_state.Stage ~= previousStage then
		ShowGameStagePage()
	end
	previousStage = game_state.Stage

	UpdateScoreboard()
	local character = Client.GetLocalPlayer():GetControlledCharacter()
	if game_state.Stage == GameStage.Running then
		if character then
			WebUI:CallEvent("setHealth", character:GetHealth(), 100)
			if character:GetTeam() == 1 then
				WebUI:CallEvent("setTheme", "red")
			end
			if character:GetTeam() == 2 then
				WebUI:CallEvent("setTheme", "blue")
			end
		end
	end

	-- Update timer
	WebUI:CallEvent("setTimer", game_state.Time)

	-- Update objectives progress
	WebUI:CallEvent(
		"updateObjectivesProgress",
		game_state.AmountOfTotalFakers,
		game_state.AmountOfFakersKilled,
		game_state.AmountOfTotalProps,
		game_state.AmountOfPropsDelivered
	)
end

Events.SubscribeRemote("GameState", GameState)

function EndGame(winnerTeam, roundScoreboard)
	Console.Log("EndGame received - Winner: " .. winnerTeam)

	-- Get local player's character and team
	local player = Client.GetLocalPlayer()
	local character = player:GetControlledCharacter()
	local myTeam = "blue" -- Default to Faker

	if character then
		local team = character:GetTeam()
		if team == 1 then -- HunterTeam
			myTeam = "red"
		elseif team == 2 then -- FakerTeam
			myTeam = "blue"
		end
	end

	-- Get player stats (total scores)
	local totalScore = player:GetValue("Score") or 0
	local kills = player:GetValue("Kills") or 0
	local deliveries = player:GetValue("Deliveries") or 0
	local skillsUsed = player:GetValue("SkillsUsed") or 0

	-- Determine number of objectives based on team
	local numberOfObjectives = 0
	if myTeam == "blue" then
		-- Fakers: show props delivered
		numberOfObjectives = deliveries
	else
		-- Hunters: show fakers killed
		numberOfObjectives = kills
	end

	-- Convert roundScoreboard table to JSON for WebUI
	local roundScoreboardJSON = "[]"
	if roundScoreboard and #roundScoreboard > 0 then
		roundScoreboardJSON = JSON.stringify(roundScoreboard)
	end

	WebUI:CallEvent("showEndPage", winnerTeam, myTeam, numberOfObjectives, totalScore, skillsUsed, roundScoreboardJSON)
	PlayMusic(winnerTeam)
end

Events.SubscribeRemote("EndGame", EndGame)

function UpdateScoreboard()
	local scoreboard = {}
	for _, player in pairs(Player.GetPairs()) do
		table.insert(scoreboard, {
			name = player:GetName(),
			score = player:GetValue("Score") or 0,
			kills = player:GetValue("Kills") or 0,
			deaths = player:GetValue("Deaths") or 0,
			deliveries = player:GetValue("Deliveries") or 0,
			ping = player:GetPing(),
			avatar = player:GetAccountIconURL(),
		})
	end
	WebUI:CallEvent("updateScoreboard", JSON.stringify(scoreboard))
end

function SetTheme(theme)
	WebUI:CallEvent("setTheme", theme)
	WebUI:CallEvent("showHowToPlayByStage", GameState.Stage)
end

Events.SubscribeRemote("SetTheme", SetTheme)
