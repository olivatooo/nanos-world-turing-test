function SpawnSwarm(center)
	for i = 1, 5 do
		local mannequin = SpawnCharacter(center + Vector(math.random(-200, 200), math.random(-200, 200), 100))
		mannequin:SetAIAvoidanceSettings(false)
		mannequin:SetCollision(CollisionType.IgnoreOnlyPawn)
		SetCharacterAppeareance(mannequin)
		SetCharacterBehaviour(mannequin)
		local location = GetRandomVector()
		mannequin:MoveTo(Vector(location.x, location.y, location.z), 10)
		mannequin:SetStanceMode(math.random(1, 2))
		mannequin:SetGaitMode(math.random(0, 2))
		Timer.SetTimeout(function(_mannequin)
			local p = Particle(
				center,
				Rotator(0, 0, 0),
				"nanos-world::P_Smoke",
				false, -- Auto Destroy?
				true -- Auto Activate?
			)
			p:SetScale(Vector(2, 2, 2))
			p:SetLifeSpan(1)
			_mannequin:Destroy()
			Events.BroadcastRemote("PlayNanosSFXAt", p:GetLocation(), "A_Balloon_Pop")
		end, 10000, mannequin)
	end

	local p = Particle(
		center,
		Rotator(0, 0, 0),
		"nanos-world::P_Explosion_Dirt",
		false, -- Auto Destroy?
		true -- Auto Activate?
	)
	p:SetScale(Vector(3, 3, 3))
	p:SetLifeSpan(3)
	Events.BroadcastRemote("PlayNanosSFXAt", p:GetLocation(), "A_Explosion_Large")
end

Events.SubscribeRemote("Clones", function(player)
	local character = player:GetControlledCharacter()
	if character == nil then
		return
	end
	SpawnSwarm(character:GetLocation())
end)
