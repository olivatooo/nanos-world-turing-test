function RandomFloat(min, max)
	return min + math.random() * (max - min)
end

function GetRandomVector(mannequin)
	if mannequin == nil then
		return Vector()
	end
	local location = mannequin:GetLocation()
	location = location + Vector(math.random(-1000, 1000), math.random(-1000, 1000), math.random(-200, 200))
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
