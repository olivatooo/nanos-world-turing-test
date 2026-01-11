Input.Register("DebugGetLocation", "X")

Input.Bind("DebugGetLocation", InputEvent.Released, function()
	return GetLocation()
end)

function Spawnshit()
	for i, v in pairs(ret) do
		Events.CallRemote(
			"spawn-shit",
			v.key,
			Vector(math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000))
		)
	end
end

Input.Subscribe("KeyDown", function(key_name)
	if key_name == "9" then
		Console.Log("Reloading Packages")
		Events.CallRemote("ReloadPackages")
	end
	if key_name == "P" then
		Console.Log("Reloading Packages")
		Events.CallRemote("ReloadPackages")
	end
	if key_name == "K" then
		Console.Log("Spawning shit")
		Spawnshit()
	end
end)

function GetLocation()
	-- Gets the local player
	local local_player = Client.GetLocalPlayer()

	-- Gets the camera rotation and location
	local camera_rotation = local_player:GetCameraRotation()
	local start_location = local_player:GetCameraLocation()

	-- Calculates the direction vector based on the camera rotation
	local direction = camera_rotation:GetForwardVector()

	-- Calculates the end location of the trace
	-- (start location + 20000 units in the direction of the camera)
	local end_location = start_location + direction * 20000

	-- Filter everything we want to trace (e.g. WorldStatic, WorldDynamic, PhysicsBody, Vehicle)
	local collision_trace = CollisionChannel.Pawn

	-- Define the parameters for the trace
	-- TraceMode.TraceOnlyVisibility means we only want to trace against objects that are visible
	-- TraceMode.DrawDebug means we want to draw debug lines for the trace for visualization
	-- TraceMode.TraceComplex means we want to trace against complex collision shapes
	-- TraceMode.ReturnEntity means we want to return the entity that was hit by the trace
	local trace_mode = TraceMode.DrawDebug | TraceMode.ReturnEntity

	-- Do the trace
	local trace_result = Trace.LineSingle(
		start_location,
		end_location,
		collision_trace,
		trace_mode,
		{ Client.GetLocalPlayer():GetControlledCharacter() }
	)

	-- If the trace was successful
	if trace_result.Success then
		if trace_result.Entity then
			Console.Log(
				"Trace Success! Entity: "
				.. trace_result.Entity:GetClass():GetName()
				.. ". Location: "
				.. tostring(GetTruncatedVector(trace_result.Location))
			)

			Chat.AddMessage(
				"Trace Success! Entity: "
				.. trace_result.Entity:GetClass():GetName()
				.. ". Location: "
				.. tostring(GetTruncatedVector(trace_result.Location))
			)
		else
			Console.Log("PropSpawn: ", tostring(GetTruncatedVector(trace_result.Location)))
			Chat.AddMessage("Trace Success! Location: " .. tostring(GetTruncatedVector(trace_result.Location)))
		end
	else
		-- If the trace was not successful, print a message
		Console.Log("Failed to trace")
	end
end

function GetTruncatedVector(vector)
	Console.Log(vector)
	return Vector(math.floor(vector.X), math.floor(vector.Y), math.floor(vector.Z))
end
