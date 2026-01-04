Events.SubscribeRemote("Taunt", function(player)
	local character = player:GetControlledCharacter()
	if character == nil then
		return
	end
	Taunt(character)
end)

function Taunt(character)
	character:PlayAnimation(GetRandomAnimation(), AnimationSlotType.UpperBody)
	Events.BroadcastRemote("PlayTauntAt", character, math.random(1, 13))
end
