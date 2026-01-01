GameState = {}
Achievement = { Damage = 0, Kills = 0, Jumps = 0, Throws = 0, Deliveries = 0 }

-- Game State Enum
GameStage = {
	WaitingForPlayers = 1,
	PreparingMatch = 2,
	Running = 3,
	EndGame = 4,
}

-- ============================================================================
-- GAME CONFIGURATION
-- ============================================================================
-- All game configuration values are centralized here for easy modification

-- Team IDs
Config = {}
Config.Teams = {
	Bot = 0,
	Hunter = 1,
	Faker = 2,
}

-- Player Configuration
Config.Players = {
	MinPlayers = 2,
	-- Hunter ratio: 1 hunter for every 3 fakers
	-- Formula: numHunters = ceil(playerCount / 4)
	HunterRatio = 1 / 3, -- Used for reference, actual calculation uses ceil(playerCount / 4)
}

-- Game State Time Limits (in seconds)
Config.GameStateTimes = {
	WaitingForPlayers = 20,
	PreparingMatch = 10,
	Running = 200,
	EndGame = 10,
	Reset = 5,
}

-- Bot Configuration
Config.Bots = {
	PerPlayer = 8,
	MaxBots = 80,
	SpawnOffset = 300, -- Distance between bot spawns
}

-- Spawn Configuration
Config.Spawns = {
	-- Props
	PropsPerHunter = 3, -- Initial props spawned per hunter
	PropsPerHunterPeriodic = 1, -- Props spawned per hunter every interval
	PropsPerFaker = 1, -- Props each faker starts with
	PropSpawnInterval = 15, -- Seconds between periodic prop spawns
	-- Hot Dog Stands
	HotDogStandsPerHunter = 2,
	-- Visual
	PropScale = 0.25,
	HotDogStandScale = 0.8,
	HotDogStandTriggerSize = 200,
	PropResetHeight = 65, -- Height offset for prop reset
	PropRotationTimer = 25, -- Milliseconds between prop rotation updates
}

-- Scoring
Config.Scoring = {
	KillFaker = 3500,
	DeliverProp = 1000,
	TimeBonusPerProp = 5, -- Seconds added to game time per prop delivered
}

-- Damage Configuration
Config.Damage = {
	FakerPunch = 6,
	BotDeathToHunter = 25, -- Damage applied to hunter when killing a bot
	HunterPropInteraction = 10, -- Damage to hunter when interacting with prop
}

-- Hunter Weapon Configuration
Config.HunterWeapon = {
	SightFOVMultiplier = 0.35,
}
