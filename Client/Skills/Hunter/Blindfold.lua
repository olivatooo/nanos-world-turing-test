Events.SubscribeRemote("Blindfold", function()
	WebUI:CallEvent("Blindfold", 10)
end)

function Blindfold()
	local character = GetCharacterAtTrace()
	if character then
		Events.CallRemote("Blindfold", character)
	end
end
