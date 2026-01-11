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

PropPossibleSpawnPoints = Server.GetMapConfig().prop_spawn_points

-- Track used spawn points to avoid respawning at same locations
local usedSpawnIndices = {}

-- Function to spawn a single prop at a given location
function SpawnSingleProp(location)
	local prop_selection = PropsToDeliver[math.random(#PropsToDeliver)]
	local prop = Prop(location + Vector(0, 0, 2000), Rotator(), prop_selection[1], CollisionType.IgnoreOnlyPawn, false)
	prop:TranslateTo(location, 10, 2)
	prop:SetScale(Vector(Config.Spawns.PropScale, Config.Spawns.PropScale, Config.Spawns.PropScale))
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
				_prop:TranslateTo(_prop:GetLocation() + Vector(0, 0, Config.Spawns.PropResetHeight), 1.0, 2.0)
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
	end, Config.Spawns.PropRotationTimer, prop)

	return prop
end

-- Function to spawn additional props during gameplay
function SpawnAdditionalProps(count)
	count = count or 1

	-- Get available spawn points (not yet used)
	local availableSpawns = {}
	for i = 1, #PropPossibleSpawnPoints do
		if not usedSpawnIndices[i] then
			table.insert(availableSpawns, { index = i, location = PropPossibleSpawnPoints[i].location })
		end
	end

	if #availableSpawns == 0 then
		-- All spawn points used, reset and use all
		usedSpawnIndices = {}
		for i = 1, #PropPossibleSpawnPoints do
			table.insert(availableSpawns, { index = i, location = PropPossibleSpawnPoints[i].location })
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

	-- Calculate desired spawn count: hunters * configured amount
	local desiredCount = numHunters * Config.Spawns.PropsPerHunter
	local availableSpawns = #PropPossibleSpawnPoints
	local spawnCount = math.min(desiredCount, availableSpawns)

	-- Get available spawn points (not yet used)
	local availableSpawnsList = {}
	for i = 1, #PropPossibleSpawnPoints do
		if not usedSpawnIndices[i] then
			table.insert(availableSpawnsList, { index = i, location = PropPossibleSpawnPoints[i].location })
		end
	end

	if #availableSpawnsList == 0 then
		-- All spawn points used, reset and use all
		usedSpawnIndices = {}
		for i = 1, #PropPossibleSpawnPoints do
			table.insert(availableSpawnsList, { index = i, location = PropPossibleSpawnPoints[i].location })
		end
	end

	-- Shuffle available spawns
	for i = #availableSpawnsList, 2, -1 do
		local j = math.random(i)
		availableSpawnsList[i], availableSpawnsList[j] = availableSpawnsList[j], availableSpawnsList[i]
	end

	-- Spawn up to the calculated count
	local actualSpawnCount = math.min(spawnCount, #availableSpawnsList)
	for i = 1, actualSpawnCount do
		local spawnData = availableSpawnsList[i]
		SpawnSingleProp(spawnData.location)
		usedSpawnIndices[spawnData.index] = true
	end
end
