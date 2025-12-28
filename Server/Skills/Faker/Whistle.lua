Events.SubscribeRemote("Whistle", function(player)
	local character = player:GetControlledCharacter()
	if character == nil then
		return
	end
end)
