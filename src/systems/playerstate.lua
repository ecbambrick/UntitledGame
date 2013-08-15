--[[----------------------------------------------------------------------------
--]]----------------------------------------------------------------------------

-- local ...

---------------------------------------------------------- MAIN UPDATE FUNCTION

--[[
asdasdsad
--]]
secs.updatesystem("playerState", 200, function(dt)
	for i,e in ipairs(secs.query("players")) do
		local onGround = e.physicsState.onGround
		local ducking = e.playerState.ducking
		local jumping = e.playerState.jumping
		local walking = e.playerState.walking
		local attacking = e.playerState.attacking
		local anyAttacking = e.playerState.attacking or e.playerState.subweaponing
		local attackActive = e.attackState.active
		local dashing = e.playerState.dashing
		local idle = e.playerState.idle
		local attack = e.attackState
		local input = e.playerInput.queue
		
		if e.physicsState.onGround then
			e.playerState.jumping = false
		else
			e.playerState.jumping = true
		end
		
		-- duck
		if not anyAttacking and not jumping and input.duck then
			e.playerState.walking = false
			e.playerState.ducking = true
		end
		
		-- stop ducking
		if not input.duck then
			e.playerState.ducking = false
		end
		
		-- jump
		if ( input.jump or input.newJump ) and (jumping or not anyAttacking)
		and onGround then
			-- runCoroutine(function(e)
				-- local entity = secs.entity(
					-- { "pos", { x = e.pos.x, y = e.pos.y + 18 }},
					-- { "sprite", { image = explosion }}
				-- )
				-- wait(0.2)
				-- secs.delete(entity)
			-- end, e)
			if e.physicsState.onOneway and ducking then
				e.pos.y = e.pos.y + 1
			elseif not ducking then
				e.playerState.jumping = true
				e.vel.y = -265
			end
		end
		
		-- stop jumping higher
		if input.jumpRelease and e.vel.y < -50 then
			e.vel.y = -30
		end
		
		-- move left and right
		if ( jumping or not anyAttacking ) and not ducking
		and (input.left or input.right) then
			if not jumping then e.playerState.walking = true end
			if input.left  then e.vel.x = e.vel.x - 1000 * dt end
			if input.right then e.vel.x = e.vel.x + 1000 * dt end
		end
		
		-- stop walking when you come to a stop
		if e.vel.x == 0 then
			e.playerState.walking = false
		end
		
		-- attack
		if input.attack and not anyAttacking then
			e.playerState.attacking = true
			if ducking then
				attack.type = "duckAttack"
			elseif jumping then
				attack.type = "jumpAttack"
			else
				attack.type = "attack"
			end
			attacking = true
			anyAttacking = true
		end
		
		-- change directions
		if not anyAttacking 
		and not holdingAttack 
		and not e.playerInput.queue.attackDown then
			if input.left then e.pos.dx = -1
			elseif input.right then e.pos.dx = 1 end
		end
		
		-- landing
		if anyAttacking and onGround and attack.type == "jumpAttack" then
			attack.finished = true
		end
		
		-- subweapon
		if not attacking and input.subweapon and e.subweapon.ready then
			secs.entity[e.subweapon.current](e.pos.x + e.pos.dx * 10, e.pos.y + 4, e.pos.dx)
			e.playerState.subweaponing = true
			e.subweapon.ready = false
			setLater(e.subweapon, "ready", true, e.subweapon.recovery)
			setLater(e.playerState, "subweaponing", false, e.subweapon.recovery)
		end
		
		-- stop attacking if necessary
		if ( attacking and attack.timer:update(dt) )
		or attack.finished then
			e.playerState.attacking = false
			attack.finished = false
			-- e.subweapon.ready = true
			-- e.playerState.subweaponing = false
			attack.timer:reset()
		end
		
		-- deal with invincibility
		if e.mortalState.invincible then
			if e.mortalState.recovery:update(dt) then
				e.mortalState.invincible = false
			end
		end
		
	end
end)
