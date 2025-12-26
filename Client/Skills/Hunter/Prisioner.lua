function Prisioner()
	local character = GetCharacterAtTrace()
	if character then
		Events.CallRemote("Prisoner", character:GetLocation())
	end
end
