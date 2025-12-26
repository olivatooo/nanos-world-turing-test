Events.SubscribeRemote("Blindfold", function(player, character)
	local mesh = StaticMesh(
		character:GetLocation() + Vector(0, 0, 100),
		Rotator(),
		"nanos-world::SM_Emoji_15",
		CollisionType.NoCollision
	)
	mesh:AttachTo(character)
	mesh:SetRelativeLocation(Vector(0, 0, 120))
	mesh:SetScale(Vector(0.5, 0.5, 0.5))
	local t = Timer.SetInterval(function(_mesh)
		_mesh:SetRelativeRotation(Rotator(0, _mesh:GetRelativeRotation().Yaw + 1, 0))
	end, 5, mesh)
	local disappear = Timer.SetTimeout(function(_mesh, _timer)
		_mesh:Destroy()
		Timer.ClearInterval(_timer)
	end, 10000, mesh, t)
	Timer.Bind(t, character)
	local player = character:GetPlayer()
	if player == nil then
		return
	end
	Events.CallRemote("Blindfold", player)
end)
