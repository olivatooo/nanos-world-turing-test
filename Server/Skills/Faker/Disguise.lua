Events.SubscribeRemote("Disguise", function(player)
	local character = player:GetControlledCharacter()
	if character == nil then
		return
	end
	SetCharacterAppeareance(character)
end)
