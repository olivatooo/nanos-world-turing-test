-- Track if EMP overlay is active
local empActive = false

-- Subscribe to remote EMP event from server
Events.SubscribeRemote("EMP", function()
	empActive = true
	WebUI:CallEvent("EMP", 5)
	
	-- Auto-disable after 5 seconds
	Timer.SetTimeout(function()
		empActive = false
	end, 5000)
end)

-- Register E key for EMP interaction
Input.Register("EMPInteract", "E")

-- Handle key press to hide EMP screen
Input.Bind("EMPInteract", InputEvent.Pressed, function()
	if empActive then
		empActive = false
		WebUI:CallEvent("HideEMP")
	end
end)

-- Function to trigger EMP skill
function EMP()
	local location = GetTraceLocation()
	if location == nil then
		return
	end
	local character = Client.GetLocalPlayer():GetControlledCharacter()
	if character == nil then
		return
	end
	Events.CallRemote("EMP", character:GetLocation(), location)
end
