function EMP(location, size)
	local sphere_trigger = Trigger(location, Rotator(), Vector(size), TriggerType.Sphere, true, Color(1, 0, 0))
	sphere_trigger:Subscribe("BeginOverlap", function(trigger, actor_triggering)
		if actor_triggering:IsA(Character) then
			Timer.SetTimeout(function(_actor_triggering)
				_actor_triggering:SetRagdollMode(true)
			end, math.random(150, 500), actor_triggering)
		end
	end)
end

function EMPChargingAnimation(location, emp_size, duration)
	-- Starting from the largest (emp_size) and getting smaller with time
	for i = 10, 1, -1 do
		Timer.SetTimeout(function()
			local initial_projectile = StaticMesh(location, Rotator(), "nanos-world::SM_Sphere", CollisionType.NoCollision)
			initial_projectile:SetMaterial("nanos-world::M_Wireframe")
			initial_projectile:SetMaterialColorParameter("Tint", Color.RandomPalette(false))
			initial_projectile:SetMaterialColorParameter("Emissive", Color.RandomPalette(false))

			-- Rotate the projectile over the specified duration
			initial_projectile:RotateTo(Rotator(math.random(-180, 180), math.random(-180, 180), math.random(-180, 180)),
				duration, 10)

			-- Scale from biggest to smallest, starting with the full size and scaling down
			initial_projectile:SetScale(Vector(emp_size / i, emp_size / i, emp_size / i))

			-- Set lifespan (optional, you can adjust this based on your needs)
			initial_projectile:SetLifeSpan(2)
		end, (duration / 10) * (i - 1)) -- Increase delay with each iteration based on duration
	end
end

Events.SubscribeRemote("EMP", function(player, origin, location)
	local initial_projectile = StaticMesh(origin, Rotator(), "nanos-world::SM_Sphere", CollisionType.NoCollision)
	initial_projectile:SetMaterial("nanos-world::M_Wireframe")
	initial_projectile:SetMaterialColorParameter("Tint", Color(0, 10, 0))
	initial_projectile:SetMaterialColorParameter("Emissive", Color(0, 10, 0))
	initial_projectile:TranslateTo(location, 1, 1)
	initial_projectile:RotateTo(Rotator(math.random(-180, 180), math.random(-180, 180), math.random(-180, 180)), 1, 10)
	local max_time = 5000
	local charge_time = max_time - 1700
	local explosion_time = max_time - 2328
	local tick = 100
	local emp_size = 1000
	local triggered_animation = false
	local triggered_explosion = false
	Events.BroadcastRemote("PlaySFXAt", location, "emp.ogg")
	Timer.SetInterval(function(_initial_projectile)
		max_time = max_time - tick
		if max_time < charge_time and not triggered_animation then
			triggered_animation = true
			_initial_projectile:Destroy()
			EMPChargingAnimation(location, emp_size / 100, explosion_time - charge_time)
		end
		if max_time < explosion_time and not triggered_explosion then
			triggered_explosion = true
		end
		if max_time <= 0 then
			return false
		end
	end, tick, initial_projectile)
end)
