Events.SubscribeRemote("Taunt", function(player)
	local character = player:GetControlledCharacter()
	if character == nil then
		return
	end
	character:PlayAnimation(GetRandomAnimation(), AnimationSlotType.UpperBody)
end)
