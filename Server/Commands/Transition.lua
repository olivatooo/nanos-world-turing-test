-- Helper function to parse stage name or number to GameStage enum
local function ParseStage(stageInput)
	if stageInput == nil then
		return nil
	end

	-- Convert to string and lowercase for comparison
	local stageStr = tostring(stageInput):lower()

	-- Try numeric input first
	local stageNum = tonumber(stageStr)
	if stageNum then
		if stageNum >= 1 and stageNum <= 4 then
			return stageNum
		end
	end

	-- Try string matches (case-insensitive)
	if stageStr == "waitingforplayers" or stageStr == "waiting for players" or stageStr == "waiting" then
		return GameStage.WaitingForPlayers
	elseif stageStr == "preparingmatch" or stageStr == "preparing match" or stageStr == "preparing" then
		return GameStage.PreparingMatch
	elseif stageStr == "running" then
		return GameStage.Running
	elseif stageStr == "endgame" or stageStr == "end game" or stageStr == "end" then
		return GameStage.EndGame
	end

	return nil
end

Console.RegisterCommand("transition", function(from, to)
	local targetStage = ParseStage(to)

	if targetStage == nil then
		print("[Server] Invalid target stage: " .. tostring(to))
		print("[Server] Valid stages: WaitingForPlayers (1), PreparingMatch (2), Running (3), EndGame (4)")
		return
	end

	-- Optional validation of 'from' parameter if provided
	if from ~= nil and from ~= "" then
		local fromStage = ParseStage(from)
		if fromStage == nil then
			print("[Server] Warning: Invalid 'from' stage: " .. tostring(from) .. ". Ignoring.")
		elseif GameState.Stage ~= fromStage then
			print(
				"[Server] Warning: Current stage is "
					.. GetStageName(GameState.Stage)
					.. ", not "
					.. GetStageName(fromStage)
					.. ". Proceeding anyway."
			)
		end
	end

	-- Perform the transition
	TransitionToStage(targetStage)
	print("[Server] Transitioned to: " .. GetStageName(targetStage))
end, "transition from one gamemode state to another", { "from", "to" })
