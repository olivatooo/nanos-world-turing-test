Input.Bind("Scoreboard", InputEvent.Pressed, function()
	WebUI:CallEvent("showPage", "scorePage")
	Input.SetMouseEnabled(true)
end)

Input.Bind("Scoreboard", InputEvent.Released, function()
	ShowGameStagePage()
	Input.SetMouseEnabled(false)
end)
