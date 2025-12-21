Events.SubscribeRemote("spawn-shit", function(player, sm, position)
	position = position or Vector(0, 0, 0)
	StaticMesh(position, Rotator(), "polygon-city::" .. sm)
end)
