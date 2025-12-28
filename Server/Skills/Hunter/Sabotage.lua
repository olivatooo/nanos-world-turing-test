Events.SubscribeRemote("Sabotage", function(player, static_mesh)
	static_mesh:SetMaterial("nanos-world::M_Wireframe")
	static_mesh:GetAttachedEntities()[1]:SetRelativeLocation(Vector(0, 0, -1000))
	local t = Timer.SetTimeout(function(_static_mesh)
		static_mesh:ResetMaterial()
		static_mesh:GetAttachedEntities()[1]:SetRelativeLocation(Vector(0, 0, 0))
	end, 10000, static_mesh)
	Timer.Bind(t, static_mesh)
	local p = Particle(
		static_mesh:GetLocation(),
		Rotator(0, 0, 0),
		"nanos-world::P_Explosion_Dirt",
		false, -- Auto Destroy?
		true -- Auto Activate?
	)
	p:SetScale(Vector(3, 3, 3))
	p:SetLifeSpan(3)
	Events.BroadcastRemote("PlayNanosSFXAt", p:GetLocation(), "A_BigHammer_Land")
end)
