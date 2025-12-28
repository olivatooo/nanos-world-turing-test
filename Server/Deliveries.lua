PropsToDeliver = {
	{ "polygon-city::SM_Prop_LargeSign_Soda_01", Vector(1, 1, 1) },
	{ "polygon-city::SM_Prop_LargeSign_Taco_01", Vector(1, 1, 1) },
	{ "polygon-city::SM_Prop_LargeSign_Popcorn_01", Vector(1, 1, 1) },
	{ "polygon-city::SM_Prop_LargeSign_Pizza_01", Vector(1, 1, 1) },
	{ "polygon-city::SM_Prop_LargeSign_Lollypop_01", Vector(1, 1, 1) },
	{ "polygon-city::SM_Prop_LargeSign_Beer_01", Vector(1, 1, 1) },
	{ "polygon-city::SM_Prop_LargeSign_Burger_01", Vector(1, 1, 1) },
	{ "polygon-city::SM_Prop_LargeSign_Noodles_01", Vector(1, 1, 1) },
	{ "polygon-city::SM_Prop_LargeSign_Donut_01", Vector(1, 1, 1) },
}

PropPossibleSpawnPoints = {
	Vector(-4338.7169248295, 1894.1418299846, 248.36549122112),
	Vector(-5303.8096636911, 1813.2612526055, 181.62530021642),
	Vector(-7551.6480800093, 1848.038429956, 117.1317913247),
	Vector(-7982.10979193, 1845.562275897, 129.48303858956),
	Vector(-8499.0155491522, 491.24442742829, 0.0),
	Vector(-8505.8620312731, 2112.3582904114, 0.0),
	Vector(-7249.5622630203, 790.50784575788, -3.3382510757323),
	Vector(-6595.1849857169, 4574.1160280101, 100.55290266741),
	Vector(-5746.9524742767, 4586.5163518598, 118.06060854197),
	Vector(-4688.1111085934, 4590.3797202595, 100.46012353434),
	Vector(-2598.4152015768, 4459.8586982823, 247.90868086644),
	Vector(-3812.3399431245, 5208.7149408766, 11.768457742275),
	Vector(-6711.176028627, 5149.9029834089, 11.515569541354),
	Vector(-7369.9154778208, 3256.0191113665, 1.707604793874),
	Vector(-7255.56139891, 2754.145791023, -5.399062218897),
	Vector(-5716.8765897801, 637.68567999188, 0.72288093911507),
	Vector(-5693.9628368432, 1666.682004537, 1.5421996597389),
	Vector(-4755.1207492837, 1850.8996657626, 100.83477521036),
	Vector(-2222.0968089261, 2138.3144500505, 0.44877773451313),
	Vector(-1373.3445950544, 3190.1711007533, 0.87250018364276),
	Vector(-1798.4383424001, 4890.673288582, 150.51678021197),
	Vector(-2239.2128199811, 4879.2469677866, 150.43233427379),
	Vector(-2262.2540477801, 4258.9878446295, -5.2345123793537),
	Vector(-2950.0451181296, 3964.4277578318, 0.0),
	Vector(-2249.8703694006, 5749.5444150326, 150.00001116865),
	Vector(-3264.9847969998, 6549.9873100923, 0.0),
	Vector(-2609.5969020447, 6751.2396530299, -149.99993202149),
	Vector(-4254.8517171026, 5753.8079358735, 3.2787017263534),
	Vector(-6167.421262156, 5742.4614731464, 0.74261056625318),
}

-- Track used spawn points to avoid respawning at same locations
local usedSpawnIndices = {}

-- Function to spawn a single prop at a given location
function SpawnSingleProp(location)
	local prop_selection = PropsToDeliver[math.random(#PropsToDeliver)]
	local prop = Prop(location + Vector(0, 0, 65), Rotator(), prop_selection[1], CollisionType.IgnoreOnlyPawn, false)
	prop:SetScale(Vector(0.25, 0.25, 0.25))
	prop:SetGrabMode(GrabMode.Enabled)
	prop:Subscribe("Interact", function(self, character)
		self:SetGravityEnabled(true)
		local player = character:GetPlayer()
		if player then
			self:SetValue("LastPlayerThatTouchedThis", player)
		end
	end)

	local my_particle = Particle(
		prop:GetLocation(),
		Rotator(0, 0, 0),
		"nanos-world::P_HangingParticulates",
		false, -- Auto Destroy?
		true -- Auto Activate?
	)
	my_particle:SetScale(Vector(0.2, 0.2, 0.2))
	my_particle:AttachTo(prop)
	my_particle:SetParameterColor("Color", Color.RandomPalette())

	my_particle = Particle(
		prop:GetLocation(),
		Rotator(0, 0, 0),
		"nanos-world::P_HangingParticulates",
		false, -- Auto Destroy?
		true -- Auto Activate?
	)
	my_particle:SetScale(Vector(0.2, 0.2, 0.2))
	my_particle:AttachTo(prop)
	my_particle:SetParameterColor("Color", Color.RandomPalette())

	local wooshLogged = false
	local resetLogged = true
	Timer.SetInterval(function(_prop)
		if not _prop:IsValid() then
			return false
		end

		local velocity = _prop:GetVelocity()

		-- Check if velocity is zero (reset flag)
		if velocity:IsNearlyZero(1) then
			if wooshLogged and not resetLogged then
				resetLogged = true
				wooshLogged = false
				_prop:SetGravityEnabled(false)
				_prop:TranslateTo(_prop:GetLocation() + Vector(0, 0, 65), 1.0, 2.0)
			end
			-- Check if going up (positive Z) and haven't logged yet
		else
			resetLogged = false
			if
				(velocity.Z > 100 or velocity.X > 100 or velocity.Y > 100)
				and _prop:GetHandler() == nil
				and not wooshLogged
			then
				Events.BroadcastRemote("WOOSH", _prop:GetLocation())
				wooshLogged = true
			end
		end

		if _prop:GetHandler() then
			return
		end
		_prop:SetRotation(Rotator(0, prop:GetRotation().Yaw + 1, 0))
	end, 25, prop)

	return prop
end

-- Function to spawn additional props during gameplay
function SpawnAdditionalProps(count)
	count = count or 1

	-- Get available spawn points (not yet used)
	local availableSpawns = {}
	for i = 1, #PropPossibleSpawnPoints do
		if not usedSpawnIndices[i] then
			table.insert(availableSpawns, { index = i, location = PropPossibleSpawnPoints[i] })
		end
	end

	if #availableSpawns == 0 then
		-- All spawn points used, reset and use all
		usedSpawnIndices = {}
		for i = 1, #PropPossibleSpawnPoints do
			table.insert(availableSpawns, { index = i, location = PropPossibleSpawnPoints[i] })
		end
	end

	-- Shuffle available spawns
	for i = #availableSpawns, 2, -1 do
		local j = math.random(i)
		availableSpawns[i], availableSpawns[j] = availableSpawns[j], availableSpawns[i]
	end

	-- Spawn up to count or available spawns
	local spawnCount = math.min(count, #availableSpawns)
	for i = 1, spawnCount do
		local spawnData = availableSpawns[i]
		SpawnSingleProp(spawnData.location)
		usedSpawnIndices[spawnData.index] = true
	end
end

function SpawnProps()
	-- Count number of hunters
	local numHunters = 0
	for _, character in pairs(Character.GetAll()) do
		if character:GetTeam() == HunterTeam then
			numHunters = numHunters + 1
		end
	end

	-- Calculate desired spawn count: hunters * 3
	local desiredCount = numHunters * 3
	local availableSpawns = #PropPossibleSpawnPoints
	local spawnCount = math.min(desiredCount, availableSpawns)

	-- Shuffle spawn points
	local shuffledSpawns = {}
	for i = 1, #PropPossibleSpawnPoints do
		shuffledSpawns[i] = PropPossibleSpawnPoints[i]
	end
	for i = #shuffledSpawns, 2, -1 do
		local j = math.random(i)
		shuffledSpawns[i], shuffledSpawns[j] = shuffledSpawns[j], shuffledSpawns[i]
	end

	-- Spawn up to the calculated count
	for i = 1, spawnCount do
		local v = shuffledSpawns[i]
		SpawnSingleProp(v)
		-- Mark this spawn point as used
		for j = 1, #PropPossibleSpawnPoints do
			if PropPossibleSpawnPoints[j] == v then
				usedSpawnIndices[j] = true
				break
			end
		end
	end
end
