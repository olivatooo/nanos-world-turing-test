Package.Require("Trace.lua")

Package.Require("Hunter/Highlighter.lua")
Package.Require("Hunter/Prisioner.lua")
Package.Require("Hunter/Sabotage.lua")
Package.Require("Hunter/Blindfold.lua")

Package.Require("Faker/Taunt.lua")
Package.Require("Faker/Whistle.lua")
Package.Require("Faker/Disguise.lua")
Package.Require("Faker/Clones.lua")
-- Team to theme color mapping
local TeamThemes = {
	[1] = "red",
	[2] = "blue",
}

-- Skill key names
local SkillKeys = {
	"One",
	"Two",
	"Three",
	"Four",
}

-- Register all skill inputs
for i, key in ipairs(SkillKeys) do
	Input.Register("Skill " .. i, key)
end

-- Helper function to activate skill
local function activateSkill(skillNumber)
	local character = Client.GetLocalPlayer():GetControlledCharacter()
	if character == nil then
		return
	end

	local team = character:GetTeam()
	if team == 0 then
		return
	end

	local theme = TeamThemes[team]
	if theme then
		WebUI:CallEvent("activateSkillByTheme", theme, skillNumber)
	end
end

-- Bind all skill inputs
for i = 1, #SkillKeys do
	Input.Bind("Skill " .. i, InputEvent.Released, function()
		activateSkill(i)
	end)
end

-- Skills dispatch table: theme -> index -> function
local Skills = {
	blue = { -- Faker
		[1] = Whistle,
		[2] = Taunt,
		[3] = Disguise,
		[4] = Clones,
	},
	red = { -- Hunter
		[1] = Highlight,
		[2] = Prisioner,
		[3] = Blindfold,
		[4] = Sabotage,
	},
}

WebUI:Subscribe("Skill", function(theme, index)
	local themeSkills = Skills[theme]
	if themeSkills == nil then
		print("Invalid theme: " .. tostring(theme))
		return
	end

	local skillFunc = themeSkills[index]
	if skillFunc == nil then
		print("Invalid skill index: " .. tostring(index) .. " for theme: " .. tostring(theme))
		return
	end

	skillFunc()
end)
