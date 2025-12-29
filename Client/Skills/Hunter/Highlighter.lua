-- Sets the Global desired Highlight color
local highlight_color = Color(10, 2.5, 0)
Client.SetHighlightColor(highlight_color, 0, HighlightMode.Always)

Events.SubscribeRemote("Highlight", function(character)
	if character == nil then
		Console.Log("Character is nil can't highlight")
		return
	end
	character:SetHighlightEnabled(true, 0)
	local timer = Timer.SetTimeout(function(_char)
		_char:SetHighlightEnabled(false, 0)
	end, 5000, character)
	Timer.Bind(timer, character)
end)

function Highlight()
	local character = GetCharacterAtTrace()
	if character then
		Events.CallRemote("Highlight", character)
	end
end
