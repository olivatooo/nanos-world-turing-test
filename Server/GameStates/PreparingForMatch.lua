function PreparingForMatch()
	Console.Log("Preparing For Match")
	StartGame()
	Events.BroadcastRemote("SetInputEnabled", false)
end
