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
		Vector(), -- Location (if a 3D sound)
		"nanos-world::A_VR_Negative", -- Asset Path
		true, -- Is 2D Sound
		true, -- Auto Destroy (if to destroy after finished playing)
		SoundType.SFX,
		1, -- Volume
		2 -- Pitch
	)
end
