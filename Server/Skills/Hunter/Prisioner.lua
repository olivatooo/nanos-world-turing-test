Events.SubscribeRemote("Prisoner", function(player, location)
	location = location + Vector(100, -100, -100)
	StaticMesh(location, Rotator(), "nanos-world::SM_ConstructionFence"):SetLifeSpan(10)
	StaticMesh(location + Vector(0, 200, 200), Rotator(90, 90, 0), "nanos-world::SM_ConstructionFence"):SetLifeSpan(10)
	StaticMesh(location + Vector(-300, 200, 200), Rotator(90, 90, 0), "nanos-world::SM_ConstructionFence"):SetLifeSpan(
		10
	)
	StaticMesh(location + Vector(0, 200, 0), Rotator(), "nanos-world::SM_ConstructionFence"):SetLifeSpan(10)
	StaticMesh(location, Rotator(0, 0, 90), "nanos-world::SM_ConstructionFence"):SetLifeSpan(10)
	StaticMesh(location + Vector(0, 0, 200), Rotator(0, 0, 90), "nanos-world::SM_ConstructionFence"):SetLifeSpan(10)
end)
