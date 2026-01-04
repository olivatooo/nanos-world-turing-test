Shirts = {
	"nanos-world::SK_Shirt",
	"nanos-world::SK_Underwear",
}

Pants = {
	"nanos-world::SK_Pants",
}

Shoes = {
	"nanos-world::SK_Shoes_01",
	"nanos-world::SK_Shoes_02",
}

Ties = {
	"nanos-world::SK_Tie",
}

Full = {
	"nanos-world::SK_CasualSet",
}

Beard = {
	"nanos-world::SM_Beard_Extra",
	"nanos-world::SM_Beard_Middle",
	"nanos-world::SM_Beard_Mustache_01",
	"nanos-world::SM_Beard_Mustache_02",
	"nanos-world::SM_Beard_Side",
}

Hair = {
	"nanos-world::SM_Hair_Long",
	"nanos-world::SM_Hair_Short",
	"nanos-world::SM_Hair_Kwang",
}

Animation = {
	"nanos-world::A_Mannequin_Body_Stretch_01",
	"nanos-world::A_Mannequin_Taunt_Flex_01",
	"nanos-world::A_Mannequin_Taunt_ThumbsUp_01",
	"nanos-world::A_Mannequin_Taunt_HandOnHips",
	"nanos-world::A_Mannequin_Taunt_Sweat",
	"nanos-world::A_Mannequin_Taunt_ThumbsDown",
	"nanos-world::A_Mannequin_Taunt_Heart",
	"nanos-world::A_Mannequin_Fart",
	"nanos-world::A_Mannequin_Playing_Guitar",
	"nanos-world::A_Mannequin_Triumph",
	"nanos-world::A_Mannequin_Brush_Of_Dust",
	"nanos-world::A_Mannequin_Deep_Breath_Sad",
	"nanos-world::A_Mannequin_Hold_Baby",
	"nanos-world::A_Mannequin_Stinky",
	"nanos-world::A_Mannequin_No",
	"nanos-world::A_Mannequin_Playing_Guitar",
	"nanos-world::A_Mannequin_Salute",
	"nanos-world::A_Mannequin_Shout",
	"nanos-world::A_Mannequin_Show_Bicep",
	"nanos-world::A_Mannequin_Showing_Goods_01",
	"nanos-world::A_Mannequin_Showing_Goods_02",
	"nanos-world::A_Mannequin_Sit_Bench",
	"nanos-world::A_Mannequin_Smith_Working",
	"nanos-world::A_Mannequin_Sneeze",
	"nanos-world::A_Mannequin_Stinky",
	"nanos-world::A_Mannequin_Take_Drink",
	"nanos-world::A_Mannequin_Take_From_Floor",
	"nanos-world::A_Mannequin_Take_From_Table",
	"nanos-world::A_Mannequin_Talking_01",
	"nanos-world::A_Mannequin_Talking_02",
	"nanos-world::A_Mannequin_Talking_03",
	"nanos-world::A_Mannequin_Thinking",
	"nanos-world::A_Mannequin_Throw_01",
	"nanos-world::A_Mannequin_Throw_02",
	"nanos-world::A_Mannequin_Triumph",
	"nanos-world::A_Mannequin_Washing_Window",
	"nanos-world::A_Mannequin_Watching_Somewhere",
	"nanos-world::A_Mannequin_Wave_01",
	"nanos-world::A_Mannequin_Wave_02",
	"nanos-world::A_Mannequin_Wave_03",
}

function GetRandomAnimation()
	return Animation[math.random(#Animation)]
end

function SetCharacterAddBeard(character)
	if math.random() > 0.5 then
		return
	end
	for i = 1, #Beard do
		if math.random() > 0.5 then
			character:AddStaticMeshAttached("beard", Beard[math.random(#Beard)], "beard")
		end
	end
end

function SetCharacterAddHair(character)
	if math.random() > 0.5 then
		return
	end
end

Hats = Assets.GetStaticMeshes("polygon-hats")
function AddHatToCharacter(character)
	character:AddStaticMeshAttached(
		"head",
		"polygon-hats::" .. Hats[math.random(#Hats)].key,
		"head",
		Vector(5, 0, 0),
		Rotator(-90, 0, 0)
	)
end

function SetCharacterAppeareance(character)
	-- SetCharacterAddBeard(character)
	-- SetCharacterAddHair(character)
	AddHatToCharacter(character)
	character:SetMaterialColorParameter("Tint", Color.RandomPalette(false))
	-- if math.random() > 0.5 then
	-- 	character:AddSkeletalMeshAttached("shirt", Shirts[math.random(#Shirts)])
	-- end
	-- if math.random() > 0.5 then
	-- 	character:AddSkeletalMeshAttached("pants", Pants[math.random(#Pants)])
	-- end
	-- if math.random() > 0.5 then
	-- 	character:AddSkeletalMeshAttached("shoes", Shoes[math.random(#Shoes)])
	-- end
	-- if math.random() > 0.5 then
	-- 	character:AddSkeletalMeshAttached("tie", Ties[math.random(#Ties)])
	-- end
	-- if math.random() > 0.8 then
	-- 	character:AddSkeletalMeshAttached("full", Full[math.random(#Full)])
	-- end
end
