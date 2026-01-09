function RandomFloat(min, max)
	return min + math.random() * (max - min)
end

function GetRandomVector(mannequin)
	-- Get random prop spawn point
	local location
	location = mannequin:GetLocation() + Vector(math.random(-5000, 5000), math.random(-5000, 5000), math.random(100))

	return {
		x = location.X,
		y = location.Y,
		z = location.Z,
	}
end

-- Server-side score tracking to avoid SetValue/GetValue timing issues
local serverPlayerScores = {}
local serverPlayerKills = {}
local serverPlayerDeaths = {}
local serverPlayerDeliveries = {}

-- Initialize player stats when they join or when round starts
function InitializePlayerStats(player)
	if not player then
		return
	end
	local playerId = player:GetID()
	-- Initialize from player values if they exist, otherwise start at 0
	serverPlayerScores[playerId] = player:GetValue("Score") or 0
	serverPlayerKills[playerId] = player:GetValue("Kills") or 0
	serverPlayerDeaths[playerId] = player:GetValue("Deaths") or 0
	serverPlayerDeliveries[playerId] = player:GetValue("Deliveries") or 0
	-- Sync to player values
	player:SetValue("Score", serverPlayerScores[playerId], true)
	player:SetValue("Kills", serverPlayerKills[playerId], true)
	player:SetValue("Deaths", serverPlayerDeaths[playerId], true)
	player:SetValue("Deliveries", serverPlayerDeliveries[playerId], true)
end

-- Get player score from server-side cache (always up-to-date)
function GetPlayerScore(player)
	if not player then
		return 0
	end
	local playerId = player:GetID()
	return serverPlayerScores[playerId] or 0
end

-- Get player kills from server-side cache
function GetPlayerKills(player)
	if not player then
		return 0
	end
	local playerId = player:GetID()
	return serverPlayerKills[playerId] or 0
end

-- Get player deaths from server-side cache
function GetPlayerDeaths(player)
	if not player then
		return 0
	end
	local playerId = player:GetID()
	return serverPlayerDeaths[playerId] or 0
end

-- Get player deliveries from server-side cache
function GetPlayerDeliveries(player)
	if not player then
		return 0
	end
	local playerId = player:GetID()
	return serverPlayerDeliveries[playerId] or 0
end

-- Player stat functions
function AddPlayerScore(player, amount)
	if not player then
		return
	end
	amount = amount or 1000
	local playerId = player:GetID()
	-- Update server-side cache first (source of truth)
	serverPlayerScores[playerId] = (serverPlayerScores[playerId] or 0) + amount
	-- Then sync to player value
	player:SetValue("Score", serverPlayerScores[playerId], true)
end

function AddPlayerKills(player, amount)
	if not player then
		return
	end
	amount = amount or 1
	local playerId = player:GetID()
	-- Update server-side cache first (source of truth)
	serverPlayerKills[playerId] = (serverPlayerKills[playerId] or 0) + amount
	-- Then sync to player value
	player:SetValue("Kills", serverPlayerKills[playerId], true)
end

function AddPlayerDeaths(player, amount)
	if not player then
		return
	end
	amount = amount or 1
	local playerId = player:GetID()
	-- Update server-side cache first (source of truth)
	serverPlayerDeaths[playerId] = (serverPlayerDeaths[playerId] or 0) + amount
	-- Then sync to player value
	player:SetValue("Deaths", serverPlayerDeaths[playerId], true)
end

function AddPlayerDeliveries(player, amount)
	if not player then
		return
	end
	amount = amount or 1
	local playerId = player:GetID()
	-- Update server-side cache first (source of truth)
	serverPlayerDeliveries[playerId] = (serverPlayerDeliveries[playerId] or 0) + amount
	-- Then sync to player value
	player:SetValue("Deliveries", serverPlayerDeliveries[playerId], true)
end
