function Teleport()
	local character = GetCharacterAtTrace()
	if character then
		Events.CallRemote("Teleport", character)
	end
end
