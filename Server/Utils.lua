function RandomFloat(min, max)
	return min + math.random() * (max - min)
end

function GetRandomVector()
	return {
		x = RandomFloat(-10000.326414, -1047.000000),
		y = RandomFloat(-800.686977, 6949.999361),
		z = RandomFloat(-150, 150),
	}
end

function GetRandomSpawnPoint()
	return {
		x = RandomFloat(-8316.326414, -1047.000000),
		y = RandomFloat(500.686977, 6949.999361),
		z = RandomFloat(-150, 150),
	}
end

-- Player stat functions
function AddPlayerScore(player, amount)
	if not player then
		return
	end
	amount = amount or 1000
	local player_score = player:GetValue("Score") or 0
	player:SetValue("Score", player_score + amount, true)
end

function AddPlayerKills(player, amount)
	if not player then
		return
	end
	amount = amount or 1
	local player_kills = player:GetValue("Kills") or 0
	player:SetValue("Kills", player_kills + amount, true)
end

function AddPlayerDeaths(player, amount)
	if not player then
		return
	end
	amount = amount or 1
	local player_deaths = player:GetValue("Deaths") or 0
	player:SetValue("Deaths", player_deaths + amount, true)
end

function AddPlayerDeliveries(player, amount)
	if not player then
		return
	end
	amount = amount or 1
	local player_deliveries = player:GetValue("Deliveries") or 0
	player:SetValue("Deliveries", player_deliveries + amount, true)
end
