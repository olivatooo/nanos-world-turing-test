Input.Register("Scoreboard", "Tab")
Input.Register("Shop", "X")

function SetInputEnabled(enable_input)
	Input.SetInputEnabled(enable_input)
	Input.SetMouseEnabled(not enable_input)
end

Events.SubscribeRemote("SetInputEnabled", SetInputEnabled)
