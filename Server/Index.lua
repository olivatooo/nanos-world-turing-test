BotTeam = 0
HunterTeam = 1
FakerTeam = 2

-- Hunter to Faker ratio constant (1 hunter for every 3 fakers)
HUNTER_TO_FAKER_RATIO = 1 / 3

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

function SpawnBots(location, amount_x, amount_y)
	local offset = 300
	for i = 1, amount_x do
		for j = 1, amount_y do
			local mannequin = SpawnCharacter(location + Vector(i * offset, j * offset, 0))
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
	-- Formula: numHunters = playerCount / (1 + 3) = playerCount / 4
	-- But ensure at least 1 hunter if we have players
	local numHunters = math.max(1, math.floor(playerCount / (1 + 3)))
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
			Events.CallRemote("SetTheme", player, "red")
			SpawnHunter(player)
		elseif characterIndex <= #shuffledCharacters then
			local character = shuffledCharacters[characterIndex]
			Console.Log("Player " .. player:GetName() .. " assigned as FAKER")
			Events.CallRemote("SetTheme", player, "blue")
			character:SetTeam(FakerTeam)
			character:SetPunchDamage(5)
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
	-- Calculate bot count: 8 bots per player, maximum of 80 bots
	local players = Player.GetAll()
	local playerCount = #players
	local botsPerPlayer = 8
	local maxBots = 80
	local totalBots = math.min(playerCount * botsPerPlayer, maxBots)

	-- Calculate grid dimensions (X and Y) for roughly square layout
	local amount_x = math.ceil(math.sqrt(totalBots))
	local amount_y = math.ceil(totalBots / amount_x)

	SpawnBots(Vector(-6000, 2115, 100), amount_x, amount_y)
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

function SpawnHunter(player)
	local location = Vector(RandomFloat(-5810, -5200), RandomFloat(2500, 3000), 100)
	local character = Character(location, Rotator(0, 0, 0), SkeletalCharacters[math.random(#SkeletalCharacters)])
	character:SetCameraMode(CameraMode.FPSOnly)
	local weapon = AK47(Vector(), Rotator())
	weapon:AddStaticMeshAttached("sight", "nanos-world::SM_T4_Sight", "", Vector(23, -0, 12))
	weapon.SightFOVMultiplier = 0.35
	weapon:SetSightTransform(Vector(0, 0, -2), Rotator(0, 0, 0))
	character:PickUp(weapon)
	character:SetTeam(HunterTeam)
	character:Subscribe("Interact", function(self, object)
		if object:IsA(Prop) then
			character:ApplyDamage(10)
			return false
		end
	end)
	character:SetCanDrop(false)
	character:SetCanGrabProps(false)
	player:Possess(character)
end
