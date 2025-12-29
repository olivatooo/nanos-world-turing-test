HotDogStandPossibleSpawnPoints = {
	Vector(-2460, 1890, 0),
	Vector(-7871, 4127, 0),
	Vector(-7298, 5830, 0),
	Vector(-5317, 5900, 0),
	Vector(-3282, 5707, 0),
	Vector(-2259, 6599, 150),
	Vector(-2590, 4900, -150),
	Vector(-1533, 4146, 0),
	Vector(-5785, 4882, 10),
	Vector(-4198, 2833, 0),
	Vector(-6095, 2789, 0),
	Vector(-7774, 2177, -665),
	Vector(-6364, 780, 0),
	Vector(-4100, 4277, 10),
}

function SpawnHotDogStand(location, rotation)
	local hotdog_stand =
		StaticMesh(location, Rotator(0, math.random(-45, 45), 0), "polygon-city::SM_Prop_HotdogStand_01")
	hotdog_stand:SetValue("HotDogStand", true, true)
	hotdog_stand:SetScale(
		Vector(Config.Spawns.HotDogStandScale, Config.Spawns.HotDogStandScale, Config.Spawns.HotDogStandScale)
	)
	local trigger =
		Trigger(Vector(), Rotator(), Vector(Config.Spawns.HotDogStandTriggerSize), nil, false, Color(1, 0, 0))
	trigger:SetOverlapOnlyClasses({ "Prop" })
	trigger:AttachTo(hotdog_stand)
	trigger:SetRelativeLocation(Vector(0, 0, 100))
	trigger:Subscribe("BeginOverlap", function(self, other)
		if other:GetValue("IsFake") then
			return
		end
		for i, v in pairs(other:GetAttachedEntities()) do
			v:SetLifeSpan(3)
		end
		Events.Call("IncreaseAmountOfPropsDelivered")
		Events.BroadcastRemote("PlaySFXAt", self:GetLocation(), "Objectives/objective.ogg")
		local player = other:GetValue("LastPlayerThatTouchedThis")
		if player then
			AddPlayerScore(player, Config.Scoring.DeliverProp)
			AddPlayerDeliveries(player, 1)
		end
		other:Destroy()
	end)
end

function SpawnHotDogStands()
	-- Count number of hunters
	local numHunters = 0
	for _, character in pairs(Character.GetAll()) do
		if character:GetTeam() == HunterTeam then
			numHunters = numHunters + 1
		end
	end

	-- Calculate desired spawn count: hunters * configured amount
	local desiredCount = numHunters * Config.Spawns.HotDogStandsPerHunter
	local availableSpawns = #HotDogStandPossibleSpawnPoints
	local spawnCount = math.min(desiredCount, availableSpawns)

	-- Shuffle spawn points
	local shuffledSpawns = {}
	for i = 1, #HotDogStandPossibleSpawnPoints do
		shuffledSpawns[i] = HotDogStandPossibleSpawnPoints[i]
	end
	for i = #shuffledSpawns, 2, -1 do
		local j = math.random(i)
		shuffledSpawns[i], shuffledSpawns[j] = shuffledSpawns[j], shuffledSpawns[i]
	end

	-- Spawn up to the calculated count
	for i = 1, spawnCount do
		SpawnHotDogStand(shuffledSpawns[i], Rotator())
	end
end
