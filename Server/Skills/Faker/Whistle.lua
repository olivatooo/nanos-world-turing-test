Events.SubscribeRemote("Whistle", function(player)
	local character = player:GetControlledCharacter()
	if character == nil then
		return
	end
	Events.BroadcastRemote("PlayTauntAt", character:GetLocation(), math.random(1, 14))
end)
