Events.SubscribeRemote("ReloadPackages", function()
	Console.Log("Reloading Packages")
	for k, v in pairs(Server.GetPackages(true)) do
		Console.Log("Reloading Package: " .. v.name)
		Chat.BroadcastMessage("Reloading Package: " .. v.name)
		Server.ReloadPackage(v.name)
	end
end)

-- L_X = 250
-- L_Y = 250
-- Events.SubscribeRemote("spawn-shit", function(player, sm, position)
-- 	position = Vector(L_X, L_Y, 2000)
-- 	L_X = L_X + 250
-- 	StaticMesh(position, Rotator(), "polygon-city::" .. sm)
-- end)
