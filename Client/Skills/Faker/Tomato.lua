Events.SubscribeRemote("Tomato", function()
	WebUI:CallEvent("Tomato")
end)

function Tomato()
	Events.CallRemote("Tomato")
end

function TomatoDecal(location, normal_impulse)
	local my_decal = Decal(
		location,                                           -- location
		Rotator(),                                          -- rotation
		"nanos-world::MI_Blood_Decal_0" .. math.random(1, 9), -- material
		Vector(10, 256, 256),                               -- size
		10,                                                 -- lifespan
		0.01                                                -- fade screen size
	)
end

Events.SubscribeRemote("TomatoDecal", TomatoDecal)
