Events.SubscribeRemote("Teleport", function(player, character)
	if character == nil then
		return
	end
	local my_character = player:GetControlledCharacter()
	if my_character == nil then
		return
	end
	player:UnPossess()
	local beam_particle = Particle(
		my_character:GetLocation(),
		Rotator(0, 0, 0),
		"nanos-world::P_Beam",
		false, -- Auto Destroy?
		true -- Auto Activate?
	)
	beam_particle = Particle(Vector(), Rotator(), "nanos-world::P_Beam", false, false)
	beam_particle:AttachTo(my_character, AttachmentRule.SnapToTarget)
	beam_particle:SetParameterColor("BeamColor", Color(0, 0, 10, 1))
	beam_particle:SetParameterFloat("BeamWidth", 10)
	beam_particle:SetParameterFloat("JitterAmount", 1)
	beam_particle:SetParameterVector("BeamEnd", character:GetLocation())
	beam_particle:SetLifeSpan(3)
	player:Possess(character, 3, 1)
end)
