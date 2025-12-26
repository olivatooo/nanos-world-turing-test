function ResetGameState()
	GameState = {
		Time = 1,
		Started = false,
		Stage = GameStage.WaitingForPlayers,
		AmountOfFakersKilled = 0,
		AmountOfTotalFakers = 0,
		AmountOfPropsDelivered = 0,
		AmountOfTotalProps = 0,
		AmountOfTotalHunters = 0,
		AmountOfTotalHuntersKilled = 0,
		Winner = 0,
	}
	previousStage = nil
end

ResetGameState()

function Clear()
	for _, v in pairs(Character.GetAll()) do
		v:Destroy()
	end
	for _, v in pairs(Particle.GetAll()) do
		v:Destroy()
	end
	for _, v in pairs(Prop.GetAll()) do
		v:Destroy()
	end
	for _, v in pairs(StaticMesh.GetAll()) do
		v:Destroy()
	end
	for _, v in pairs(Weapon.GetAll()) do
		v:Destroy()
	end
end
