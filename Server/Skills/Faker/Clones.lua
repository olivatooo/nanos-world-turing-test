function SpawnSwarm(center)
	for i = 1, 5 do
		local mannequin = SpawnCharacter(center + Vector(math.random(-200, 200), math.random(-200, 200), 100))
		mannequin:SetAIAvoidanceSettings(false)
		mannequin:SetCollision(CollisionType.IgnoreOnlyPawn)
		SetCharacterAppeareance(mannequin)
		SetCharacterBehaviour(mannequin)
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
