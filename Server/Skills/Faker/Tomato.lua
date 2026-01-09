function Tomato(player)
	local character = player:GetControlledCharacter()
	if character == nil then
		return
	end
	local control_rotation = character:GetControlRotation() + Rotator(10, 0, 0)
	local forward_vector = control_rotation:GetForwardVector()
	local spawn_location = character:GetLocation() + Vector(0, 0, 50) + forward_vector * 200

	local prop = Prop(spawn_location, Rotator.Random(true), "nanos-world::SM_Tomato")
	prop:SetValue("IsFake", true, true)
	prop:SetScale(Vector(3, 3, 3))
	prop:SetLifeSpan(10)
	prop:AddImpulse(forward_vector * 1000, true)
	prop:Subscribe("Hit", function(self, impact_force, normal_impulse, impact_location, velocity)
		Particle(
			impact_location,
			Rotator(0, 0, 0),
			"nanos-world::PS_Blood_Impact",
			true, -- Auto Destroy?
			true -- Auto Activate?
		)
		Console.Log(normal_impulse)
		Events.BroadcastRemote("TomatoDecal", impact_location, normal_impulse)
		local trigger = Trigger(self:GetLocation(), Rotator(), Vector(300), nil, false, Color(1, 0, 0))
		trigger:SetOverlapOnlyClasses({ "Character" })
		trigger:Subscribe("BeginOverlap", function(t, other)
			local hit = other:GetPlayer()
			if hit then
				Events.CallRemote("Tomato", hit)
				Events.BroadcastRemote("PlaySFXAt", t:GetLocation(), "squish.ogg")
			end
		end)
		trigger:SetLifeSpan(1)
		self:Destroy()
	end)
end

Events.SubscribeRemote("Tomato", Tomato)
