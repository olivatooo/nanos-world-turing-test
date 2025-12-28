Events.SubscribeRemote("Taunt", function(player)
	local character = player:GetControlledCharacter()
	if character == nil then
		return
	end
	Taunt(character)
end)

function Taunt(character)
	character:PlayAnimation(GetRandomAnimation(), AnimationSlotType.UpperBody)
	Events.BroadcastRemote("PlayTauntAt", character:GetLocation(), math.random(1, 14))
end
