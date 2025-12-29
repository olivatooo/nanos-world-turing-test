function SpawnFakeProp(location)
	local prop_selection = PropsToDeliver[math.random(#PropsToDeliver)]
	local prop = Prop(location, Rotator(), prop_selection[1], CollisionType.IgnoreOnlyPawn, false)
	prop:SetLifeSpan(40)
	prop:SetScale(Vector(Config.Spawns.PropScale, Config.Spawns.PropScale, Config.Spawns.PropScale))
	prop:SetGrabMode(GrabMode.Enabled)
	Events.BroadcastRemote("PlayNanosSFXAt", prop:GetLocation(), "A_Teleport_Committed")
	local p = Particle(
		location,
		Rotator(0, 0, 0),
		"nanos-world::P_Smoke",
		false, -- Auto Destroy?
		true -- Auto Activate?
	)
	p:SetScale(Vector(4, 4, 4))
	p:SetLifeSpan(1)
	p:SetParameterColor("Color", Color.RED)
	prop:SetValue("IsFake", true, true)
	prop:Subscribe("Interact", function(self, character)
		Events.BroadcastRemote("Highlight", character)
		Events.BroadcastRemote("PlayNanosSFXAt", self:GetLocation(), "A_Wilhelm_Scream")
		local p = Particle(
			self:GetLocation(),
			Rotator(0, 0, 0),
			"nanos-world::P_Smoke",
			false, -- Auto Destroy?
			true -- Auto Activate?
		)
		p:SetParameterColor("Color", Color.RED)
		p:SetScale(Vector(2, 2, 2))
		p:SetLifeSpan(1)
		for i, v in pairs(self:GetAttachedEntities()) do
			v:Destroy()
		end
		self:Destroy()
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
	my_particle:SetParameterColor("Color", Color.RED)

	my_particle = Particle(
		prop:GetLocation(),
		Rotator(0, 0, 0),
		"nanos-world::P_HangingParticulates",
		false, -- Auto Destroy?
		true -- Auto Activate?
	)
	my_particle:SetScale(Vector(0.2, 0.2, 0.2))
	my_particle:AttachTo(prop)
	my_particle:SetParameterColor("Color", Color.RED)

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

function FakeProp(player, character)
	SpawnFakeProp(character:GetLocation())
end

Events.SubscribeRemote("FakeProp", FakeProp)
