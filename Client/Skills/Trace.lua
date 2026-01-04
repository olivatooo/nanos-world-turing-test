function GetCharacterAtTrace()
	local local_player = Client.GetLocalPlayer()
	local camera_rotation = local_player:GetCameraRotation()
	local start_location = local_player:GetCameraLocation()
	local direction = camera_rotation:GetForwardVector()
	local end_location = start_location + direction * 20000
	local collision_trace = CollisionChannel.Pawn
	local trace_mode = TraceMode.ReturnEntity
	local trace_result = Trace.LineSingle(
		start_location,
		end_location,
		collision_trace,
		trace_mode,
		{ Client.GetLocalPlayer():GetControlledCharacter() }
	)
	if trace_result.Success then
		if trace_result.Entity then
			print("Trace entity: " .. trace_result.Entity:GetClass():GetName())
			return trace_result.Entity
		else
			NegativeSound()
		end
	else
		NegativeSound()
	end
end

function GetHotDogAtTrace()
	local local_player = Client.GetLocalPlayer()
	local camera_rotation = local_player:GetCameraRotation()
	local start_location = local_player:GetCameraLocation()
	local direction = camera_rotation:GetForwardVector()
	local end_location = start_location + direction * 20000
	local collision_trace = CollisionChannel.WorldStatic
	local trace_mode = TraceMode.ReturnEntity
	local trace_result = Trace.LineSingle(
		start_location,
		end_location,
		collision_trace,
		trace_mode,
		{ Client.GetLocalPlayer():GetControlledCharacter() }
	)
	if trace_result.Success then
		if trace_result.Entity then
			print("Trace entity: " .. trace_result.Entity:GetClass():GetName())
			return trace_result.Entity
		else
			NegativeSound()
		end
	else
		NegativeSound()
	end
end

function NegativeSound()
	Sound(
		Vector(),                   -- Location (if a 3D sound)
		"nanos-world::A_VR_Negative", -- Asset Path
		true,                       -- Is 2D Sound
		true,                       -- Auto Destroy (if to destroy after finished playing)
		SoundType.SFX,
		1,                          -- Volume
		2                           -- Pitch
	)
end

function GetTraceLocation()
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
	local collision_trace = CollisionChannel.WorldStatic | CollisionChannel.WorldDynamic | CollisionChannel.PhysicsBody |
			CollisionChannel.Vehicle

	-- Define the parameters for the trace
	-- TraceMode.TraceOnlyVisibility means we only want to trace against objects that are visible
	-- TraceMode.DrawDebug means we want to draw debug lines for the trace for visualization
	-- TraceMode.TraceComplex means we want to trace against complex collision shapes
	-- TraceMode.ReturnEntity means we want to return the entity that was hit by the trace
	local trace_mode = TraceMode.TraceOnlyVisibility | TraceMode.DrawDebug | TraceMode.TraceComplex |
			TraceMode.ReturnEntity

	-- Do the trace
	local trace_result = Trace.LineSingle(start_location, end_location, collision_trace, trace_mode)

	-- If the trace was successful
	if (trace_result.Success) then
		return trace_result.Location
	else
		Console.Log("Failed to trace")
	end
end
