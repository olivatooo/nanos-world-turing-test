local ret = Assets.GetMaps("polygon-city")

for i, v in pairs(ret) do
	print(v.key)
end

-- Registers the binding_name 'SpawnMenu' with default key 'Q'
-- This will add 'SpawnMenu' to user KeyBinding Settings automatically
Input.Register("SpawnMenu", "Q")

-- Subscribes for Pressing the key

function Spawnshit()
	ret = Assets.GetStaticMeshes("polygon-city")
	for i, v in pairs(ret) do
		Events.CallRemote(
			"spawn-shit",
			v.key,
			Vector(math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000))
		)
	end
end

Input.Bind("SpawnMenu", InputEvent.Pressed, Spawnshit)
