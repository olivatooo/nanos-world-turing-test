function RandomFloat(min, max)
	return min + math.random() * (max - min)
end

function GetRandomVector(mannequin)
	-- Get random prop spawn point
	local location
	if PropPossibleSpawnPoints and #PropPossibleSpawnPoints > 0 then
		-- Select random spawn point from prop spawn points
		local randomSpawnPoint = PropPossibleSpawnPoints[math.random(#PropPossibleSpawnPoints)]
		location = randomSpawnPoint.location
		-- Add random offset from -250 to 250 to each axis
		location = location + Vector(RandomFloat(-250, 250), RandomFloat(-250, 250), RandomFloat(-250, 250))
	else
		Console.Log("No prop spawn points available")
		-- Fallback if no prop spawn points available
		location = Vector(math.random(-10000, 10000), math.random(-10000, 10000), math.random(-2000, 2000))
	end

	return {
		x = location.X,
		y = location.Y,
		z = location.Z,
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
