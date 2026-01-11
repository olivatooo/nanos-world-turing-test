function SetCharacterHitBehaviour(character)
	character:Subscribe("TakeDamage", function(self, damage, bone, type, from_direction, instigator, causer)
		Timer.SetTimeout(function(_character)
			if math.random() > 0.5 then
				local location = GetRandomVector(_character)
				_character:MoveTo(Vector(location.x, location.y, location.z), 10)
			end
			if math.random() > 0.5 then
				local location = GetRandomVector(_character)
				_character:LookAt(Vector(location.x, location.y, location.z))
			end
			if math.random() > 0.8 then
				_character:PlayAnimation(GetRandomAnimation(), AnimationSlotType.UpperBody)
			end
			if math.random() > 0.5 then
				_character:Jump()
			end
			if math.random() > 0.5 then
				_character:SetGaitMode(math.random(1, 2))
			end
			if math.random() > 0.5 then
				_character:SetStanceMode(math.random(1, 2))
			end
		end, math.random(250, 1000), character)
	end)
end

function SetCharacterBehaviour(character)
	SetCharacterHitBehaviour(character)
	local my_timer = Timer.SetInterval(function(manny)
		if manny:IsValid() == false then
			return false
		end
		if math.random() > 0.5 and manny:GetMovingTo() == Vector(0, 0, 0) then
			local location = GetRandomVector(manny)
			manny:MoveTo(Vector(location.x, location.y, location.z), math.random(10, 400))
		end
		if math.random() > 0.5 then
			local location = GetRandomVector(manny)
			manny:LookAt(Vector(location.x, location.y, location.z))
		end
		if math.random() > 0.90 then
			manny:Jump()
		end
		if math.random() > 0.5 then
			manny:SetStanceMode(math.random(1, 2))
		end
		if math.random() > 0.95 then
			manny:SetGaitMode(math.random(1, 2))
		end
		if math.random() > 0.99 then
			manny:SetRagdollMode(true)
		end
		if math.random() > 0.80 then
			manny:SetRagdollMode(false)
		end
		if math.random() > 0.9 then
			Taunt(manny)
		end
		if math.random() > 0.99 then
			local to_follow = Character.GetAll()[math.random(#Character.GetAll())]
			manny:Follow(to_follow)
		end
	end, math.random(3000, 10000), character)
	character:SetValue("my_timer", my_timer)
end

function StartBots()
	for _, bot in pairs(Character.GetAll()) do
		if bot:GetTeam() == BotTeam then
			SetCharacterBehaviour(bot)
		end
	end
end
