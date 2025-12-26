function Sabotage()
	local hot_dog = GetHotDogAtTrace()
	if hot_dog then
		Events.CallRemote("Sabotage", hot_dog)
	end
end
