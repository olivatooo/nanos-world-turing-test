function AddHeadMarker(character, team)
	local cone = StaticMesh(Vector(), Rotator(-90, 90, 90), "nanos-world::SM_Cone", CollisionType.NoCollision)
	cone:SetScale(Vector(0.2, 0.2, 0.2))
	cone:AttachTo(character)
	cone:SetRelativeLocation(Vector(0, 0, 125))
	cone:SetRelativeRotation(Rotator(0, 90, 180))
	cone:SetMaterial("nanos-world::M_Default_Translucent_Lit_Depth")
	if team == FakerTeam then
		cone:SetMaterialColorParameter("Tint", Color(0, 0, 1))
		cone:SetMaterialColorParameter("Emissive", Color(0, 0, 10))
	end
	if team == HunterTeam then
		cone:SetMaterialColorParameter("Tint", Color(1, 0, 0))
		cone:SetMaterialColorParameter("Emissive", Color(10, 0, 0))
	end
end

Player.Subscribe("Possess", function(self, character)
	if self ~= Client.GetLocalPlayer() then
		return
	end
	for k, v in pairs(Character.GetAll()) do
		if v:GetTeam() == character:GetTeam() then
			AddHeadMarker(v, character:GetTeam())
		end
	end
end)
