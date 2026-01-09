-- Teams are now defined in Shared/Index.lua as Config.Teams
math.randomseed(os.time())
MAP_CONFIG = Server.GetMapConfig()
BotTeam = Config.Teams.Bot
HunterTeam = Config.Teams.Hunter
FakerTeam = Config.Teams.Faker

-- Rotation tracking: stores player IDs who have been hunters
local hunterRotation = {}

Package.Require("Debug.lua")
Package.Require("Skins.lua")
Package.Require("Utils.lua")
Package.Require("Bot.lua")
Package.Require("HotDogStand.lua")
Package.Require("GameStates/GameState.lua")
Package.Require("Deliveries.lua")
Package.Require("Skills/Skills.lua")

function SpawnCharacter(location)
	local mannequin
	if math.random() > 0.5 then
		mannequin =
				Character(Vector(location.X, location.Y, 200), Rotator(0, math.random(360), 0), "nanos-world::SK_Mannequin")
	else
		mannequin = Character(
			Vector(location.X, location.Y, 200),
			Rotator(0, math.random(360), 0),
			"nanos-world::SK_Mannequin_Female"
		)
	end
	mannequin:SetTeam(BotTeam)
	return mannequin
end

BotPossibleSpawnPoints = Server.GetMapSpawnPoints()

-- Shuffled bot spawn points and tracking
local shuffledBotSpawnPoints = {}
local currentBotSpawnPointIndex = 0

-- Function to shuffle bot spawn points
local function ShuffleBotSpawnPoints()
	-- Reset the shuffled array
	shuffledBotSpawnPoints = {}

	-- Copy spawn points to shuffled array
	if BotPossibleSpawnPoints then
		for i = 1, #BotPossibleSpawnPoints do
			shuffledBotSpawnPoints[i] = BotPossibleSpawnPoints[i]
		end

		-- Fisher-Yates shuffle algorithm
		for i = #shuffledBotSpawnPoints, 2, -1 do
			local j = math.random(i)
			shuffledBotSpawnPoints[i], shuffledBotSpawnPoints[j] = shuffledBotSpawnPoints[j], shuffledBotSpawnPoints[i]
		end
	end

	-- Reset index
	currentBotSpawnPointIndex = 0
end

-- Initialize shuffled bot spawn points
ShuffleBotSpawnPoints()

function SpawnBots(amount_x, amount_y)
	for i = 1, amount_x do
		for j = 1, amount_y do
			-- Check if we need to reshuffle (all spawn points used)
			if currentBotSpawnPointIndex >= #shuffledBotSpawnPoints then
				ShuffleBotSpawnPoints()
			end

			-- Get the next spawn point from shuffled list for this mannequin
			local location
			if #shuffledBotSpawnPoints > 0 then
				currentBotSpawnPointIndex = currentBotSpawnPointIndex + 1
				local spawnPoint = shuffledBotSpawnPoints[currentBotSpawnPointIndex]
				location = spawnPoint.location
			else
				-- Fallback to default location if no spawn points configured
				location = Vector(-6000, 2115, 100)
			end

			local mannequin = SpawnCharacter(location)
			mannequin:SetAIAvoidanceSettings(true, 10)
			mannequin:SetCollision(CollisionType.IgnoreOnlyPawn)
			SetCharacterAppeareance(mannequin)
		end
	end
end

function SpawnPlayers()
	local allCharacters = Character.GetAll()
	local players = Player.GetAll()
	local playerCount = #players

	if playerCount == 0 then
		return
	end

	-- Calculate number of hunters based on ratio (1 hunter for every 3 fakers)
	-- Formula: numHunters = ceil(playerCount / 4) to ensure 1 hunter per 3 fakers
	-- Examples: 6 players = 2 hunters + 4 fakers, 7 players = 2 hunters + 5 fakers,
	--           8 players = 2 hunters + 6 fakers, 10 players = 3 hunters + 7 fakers
	local numHunters = math.max(1, math.ceil(playerCount / 4))
	local numFakers = playerCount - numHunters

	-- Get list of current player IDs
	local playerList = {}
	for _, player in pairs(players) do
		table.insert(playerList, player)
	end

	-- Check if we need to reset rotation (everyone has been a hunter)
	local allPlayersBeenHunters = true
	for _, player in pairs(playerList) do
		local playerId = player:GetID()
		if not hunterRotation[playerId] then
			allPlayersBeenHunters = false
			break
		end
	end

	-- Reset rotation if everyone has been a hunter
	if allPlayersBeenHunters then
		hunterRotation = {}
	end

	-- Select hunters randomly from players who haven't been hunters yet
	local availableForHunter = {}
	for _, player in pairs(playerList) do
		local playerId = player:GetID()
		if not hunterRotation[playerId] then
			table.insert(availableForHunter, player)
		end
	end

	-- If we don't have enough players who haven't been hunters, use all players
	if #availableForHunter < numHunters then
		availableForHunter = {}
		for _, player in pairs(playerList) do
			table.insert(availableForHunter, player)
		end
	end

	-- Shuffle available players for random selection
	for i = #availableForHunter, 2, -1 do
		local j = math.random(i)
		availableForHunter[i], availableForHunter[j] = availableForHunter[j], availableForHunter[i]
	end

	-- Select hunters
	local selectedHunters = {}
	for i = 1, math.min(numHunters, #availableForHunter) do
		local hunter = availableForHunter[i]
		selectedHunters[hunter:GetID()] = true
		hunterRotation[hunter:GetID()] = true
	end

	-- Shuffle characters array for random assignment
	local shuffledCharacters = {}
	for i = 1, #allCharacters do
		shuffledCharacters[i] = allCharacters[i]
	end
	for i = #shuffledCharacters, 2, -1 do
		local j = math.random(i)
		shuffledCharacters[i], shuffledCharacters[j] = shuffledCharacters[j], shuffledCharacters[i]
	end

	-- Assign characters to players
	local characterIndex = 1
	for _, player in pairs(playerList) do
		local playerId = player:GetID()
		if selectedHunters[playerId] then
			Console.Log("Player " .. player:GetName() .. " assigned as HUNTER")
			player:SetValue("Team", "red", true) -- Store team as player value
			Events.CallRemote("SetTheme", player, "red")
			SpawnHunter(player)
		elseif characterIndex <= #shuffledCharacters then
			local character = shuffledCharacters[characterIndex]
			Console.Log("Player " .. player:GetName() .. " assigned as FAKER")
			player:SetValue("Team", "blue", true) -- Store team as player value
			Events.CallRemote("SetTheme", player, "blue")
			character:SetTeam(FakerTeam)
			character:SetPunchDamage(Config.Damage.FakerPunch)
			character:SetCameraMode(CameraMode.TPSOnly)
			character:Subscribe("Interact", function(self, object)
				if object:IsA(Weapon) then
					return false
				end
			end)
			player:Possess(character)
			characterIndex = characterIndex + 1
		end
	end
end

function PlayOST()
	Events.BroadcastRemote("PlayOST", math.random(1, 10))
end

function StartGame()
	-- Calculate bot count based on configuration
	local players = Player.GetAll()
	local playerCount = #players
	local totalBots = math.min(playerCount * Config.Bots.PerPlayer, Config.Bots.MaxBots)

	-- Calculate grid dimensions (X and Y) for roughly square layout
	local amount_x = math.ceil(math.sqrt(totalBots))
	local amount_y = math.ceil(totalBots / amount_x)

	SpawnBots(amount_x, amount_y)
	SpawnPlayers()
	SpawnHotDogStands()
	SpawnProps()
	PlayOST()
end

SkeletalCharacters = {
	"nanos-world::SK_Adventure_01_Full_02",
	"nanos-world::SK_Adventure_02_Full_01",
	"nanos-world::SK_Adventure_02_Full_02",
	"nanos-world::SK_Adventure_02_Full_03",
	"nanos-world::SK_Adventure_03_Full_01",
	"nanos-world::SK_Adventure_03_Full_02",
	"nanos-world::SK_Adventure_04_Full_01",
	"nanos-world::SK_Adventure_04_Full_02",
	"nanos-world::SK_Adventure_05_Full_02",
}

HunterPossibleSpawnPoints = Server.GetMapConfig().hunter_spawn_points

-- Shuffled spawn points and tracking
local shuffledHunterSpawnPoints = {}
local currentSpawnPointIndex = 0

-- Function to shuffle spawn points
local function ShuffleHunterSpawnPoints()
	-- Reset the shuffled array
	shuffledHunterSpawnPoints = {}

	-- Copy spawn points to shuffled array
	if HunterPossibleSpawnPoints then
		for i = 1, #HunterPossibleSpawnPoints do
			shuffledHunterSpawnPoints[i] = HunterPossibleSpawnPoints[i]
		end

		-- Fisher-Yates shuffle algorithm
		for i = #shuffledHunterSpawnPoints, 2, -1 do
			local j = math.random(i)
			shuffledHunterSpawnPoints[i], shuffledHunterSpawnPoints[j] =
					shuffledHunterSpawnPoints[j], shuffledHunterSpawnPoints[i]
		end
	end

	-- Reset index
	currentSpawnPointIndex = 0
end

-- Initialize shuffled spawn points
ShuffleHunterSpawnPoints()

function SpawnHunter(player)
	-- Check if we need to reshuffle (all spawn points used)
	if currentSpawnPointIndex >= #shuffledHunterSpawnPoints then
		ShuffleHunterSpawnPoints()
	end

	-- Get the next spawn point from shuffled list
	local location
	if #shuffledHunterSpawnPoints > 0 then
		currentSpawnPointIndex = currentSpawnPointIndex + 1
		local spawnPoint = shuffledHunterSpawnPoints[currentSpawnPointIndex]
		location = spawnPoint.location
	else
		-- Fallback to random location if no spawn points configured
		location = Vector(RandomFloat(-5810, -5200), RandomFloat(2500, 3000), 100)
	end
	local character = Character(location, Rotator(0, 0, 0), SkeletalCharacters[math.random(#SkeletalCharacters)])
	character:SetCameraMode(CameraMode.FPSOnly)
	local weapon = AK47(Vector(), Rotator())
	weapon:AddStaticMeshAttached("sight", "nanos-world::SM_T4_Sight", "", Vector(23, -0, 12))
	weapon.SightFOVMultiplier = Config.HunterWeapon.SightFOVMultiplier
	weapon:SetSightTransform(Vector(0, 0, -2), Rotator(0, 0, 0))
	character:PickUp(weapon)
	character:SetTeam(HunterTeam)
	character:Subscribe("Interact", function(self, object)
		if object:IsA(Prop) then
			character:ApplyDamage(Config.Damage.HunterPropInteraction)
			return false
		end
	end)
	character:SetCanDrop(false)
	character:SetCanGrabProps(false)
	player:Possess(character)
end
