Events.Subscribe("IncreaseAmountOfFakersKilled", function()
	GameState.AmountOfFakersKilled = GameState.AmountOfFakersKilled + 1
	if GameState.AmountOfFakersKilled == GameState.AmountOfTotalFakers then
		TriggerEndGame()
	end
	Events.BroadcastRemote("GameState", GameState)
end)

Events.Subscribe("IncreaseAmountOfHuntersKilled", function()
	GameState.AmountOfTotalHuntersKilled = GameState.AmountOfTotalHuntersKilled + 1
	if GameState.AmountOfTotalHuntersKilled == GameState.AmountOfTotalHunters then
		TriggerEndGame()
	end
	Events.BroadcastRemote("GameState", GameState)
end)

Events.Subscribe("IncreaseAmountOfPropsDelivered", function()
	GameState.AmountOfPropsDelivered = GameState.AmountOfPropsDelivered + 1
	GameState.Time = GameState.Time + 5
	if GameState.AmountOfPropsDelivered == GameState.AmountOfTotalProps then
		TriggerEndGame()
	end
	Events.BroadcastRemote("GameState", GameState)
end)

Character.Subscribe("TakeDamage", function(self, damage, bone, type, from_direction, instigator, causer)
	if instigator == nil then
		return
	end
	local achievement = instigator:GetValue("Achievement") or Achievement
	achievement.Damage = achievement.Damage + damage
	instigator:SetValue("Achievement", achievement, true)
end)

Character.Subscribe(
	"Death",
	function(self, last_damage_taken, last_bone_damaged, damage_type_reason, hit_from_direction, instigator, causer)
		if self == nil then
			return
		end
		if self:GetTeam() == 0 then
			local character = instigator:GetControlledCharacter()
			character:ApplyDamage(25)
		end
		if self:GetTeam() == 1 then
			self:GetPlayer():UnPossess()
			Events.Call("IncreaseAmountOfHuntersKilled")
			local player = self:GetPlayer()
			if player then
				AddPlayerDeaths(player)
			end
		end
		if self:GetTeam() == 2 then
			self:GetPlayer():UnPossess()
			local player = self:GetPlayer()
			if player then
				AddPlayerDeaths(player)
			end
			if instigator then
				AddPlayerKills(instigator)
				AddPlayerScore(instigator, 3500)
			end
			Events.Call("IncreaseAmountOfFakersKilled")
		end
	end
)

-- Track elapsed seconds for periodic prop spawning (based on real time, not game time)
local elapsedSeconds = 0

function Running()
	Events.BroadcastRemote("SetInputEnabled", true)
	StartBots()

	-- Reset elapsed time for new game
	elapsedSeconds = 0

	-- Set up timer to spawn props every 15 seconds of game time
	Timer.SetInterval(function()
		if GameState.Stage ~= GameStage.Running then
			return false -- Stop timer if not in Running stage
		end

		-- Increment elapsed seconds (this tracks real game time, not GameState.Time)
		elapsedSeconds = elapsedSeconds + 1

		-- Spawn props every 15 seconds
		if elapsedSeconds % 15 == 0 then
			-- Count number of hunters to determine spawn count
			local numHunters = 0
			for _, character in pairs(Character.GetAll()) do
				if character:GetTeam() == HunterTeam then
					numHunters = numHunters + 1
				end
			end

			-- Spawn additional props (hunters * 1 per 15 seconds)
			if numHunters > 0 then
				SpawnAdditionalProps(numHunters)
			end
		end
	end, 1000) -- Check every second
end
