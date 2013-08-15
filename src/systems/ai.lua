--[[----------------------------------------------------------------------------
--]]----------------------------------------------------------------------------

local defaultAI

---------------------------------------------------------- MAIN UPDATE FUNCTION

--[[
asdasdsad
--]]
secs.updatesystem("ai", 250, function(dt)

	-- get player
	local player = secs.query("players")[1]

	-- get stage dimensions
	local stage = secs.query("stages")[1]
	if stage then stage = stage.stage.map end
	local stageWidth = stage.width * stage.tileWidth or WINDOW_WIDTH
	local stageHeight = stage.height * stage.tileHeight or WINDOW_HEIGHT
	
	-- enemy ai
	for i,e in ipairs(secs.query("enemies")) do
		if e.sinusoidal then
			e.sinusoidal.time = e.sinusoidal.time + dt
			e.pos.y = math.cos(e.sinusoidal.time * e.sinusoidal.frequency * math.pi) * e.sinusoidal.amplitude + 128
		end
		if e.enemyState.behaviour == "attack" and player ~= nil then
			defaultAI(e, player, dt)
		end
	end
	
	-- subweapon ai
	for i,e in ipairs(secs.query("subweapons")) do
		if e.pos.x < -16 or e.pos.x > stageWidth then secs.delete(e) end
	end
	
end)

--------------------------------------------------------------------------------

function defaultAI(e, player, dt)

	local previousAnimation = e.animation.current
	local distance = math.abs(e.pos.x - player.pos.x)
	local passiveDistance = e.enemyState.passiveDistance
	
	if e.enemyState.state ~= "attack" and e.enemyState.state ~= "attacking" then
		e.pos.dx = ( e.pos.x - player.pos.x >= 0 ) and -1 or 1
	end
	
	-- idle state
	if e.enemyState.state == "idle" then
		if distance < WINDOW_WIDTH/2 then e.enemyState.state = "aggressive" end
	end
	
	-- passive state
	if e.enemyState.state == "passive" then
		if distance <= passiveDistance+1 and distance >= passiveDistance-1 then
			e.vel.x = 0
		elseif distance < passiveDistance then
			e.vel.x = -50*e.pos.dx
		else
			e.vel.x = 50*e.pos.dx
		end
	end
	
	-- aggressive state
	if e.enemyState.state == "aggressive" then
		if distance > WINDOW_WIDTH/2 then e.enemyState.state = "idle"
		elseif distance < 24 then e.enemyState.state = "attack" end
		e.vel.x = 50*e.pos.dx
	end
	
	-- attack state
	if e.enemyState.state == "attack" then
		local animation = e.animation.list[e.animation.current]
		if math.random(1,2) == 1 then
			e.enemyState.passiveDistance = 0
		else
			e.enemyState.passiveDistance = math.random(48,128)
		end
		e.vel.x = 0
		e.enemyState.state = "attacking"
		runCoroutine(function(distance, state)
			wait(0.6)
			state.state = "passive"
			wait(math.random(1,7)/10)
			state.state = "idle"
		end, distance, e.enemyState)
	end
	
		if e.mortalState.invincible then
			if e.mortalState.recovery:update(dt) then
				e.mortalState.invincible = false
			end
		end

end