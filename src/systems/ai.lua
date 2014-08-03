--[[----------------------------------------------------------------------------
--]]----------------------------------------------------------------------------

local Concurrency = require("../lib.concurrency")
local defaultAI

---------------------------------------------------------- MAIN UPDATE FUNCTION

--[[
asdasdsad
--]]
secs:UpdateSystem("ai", function(dt)

	-- get player and camera
	local player = secs:queryFirst("pos playerInput playerState")
	local camera = secs:queryFirst("camera pos")
	local stage = secs:queryFirst("stage")

	-- get stage dimensions
	if stage then stage = stage.stage.map end
	local stageWidth = stage.width * stage.tileWidth or camera.camera.width
	local stageHeight = stage.height * stage.tileHeight or camera.camera.height
	
	-- enemy ai
	for e in pairs(secs:query("pos enemyState")) do
		if e.sinusoidal then
			e.sinusoidal.time = e.sinusoidal.time + dt
			e.pos.y = math.cos(e.sinusoidal.time * e.sinusoidal.frequency * math.pi) * e.sinusoidal.amplitude + 128
		end
		if e.enemyState.behaviour == "attack" and player ~= nil then
			defaultAI(e, player, camera, dt)
		end
	end
	
	-- subweapon ai
	for e in pairs(secs:query("pos isSubweapon")) do
		if e.pos.x < -16 or e.pos.x > stageWidth then secs:delete(e) end
	end
	
end)

--------------------------------------------------------------------------------

function defaultAI(e, player, camera, dt)

	local speed = 50
	local onCamera = e.pos.x < camera.pos.x + camera.camera.width and e.pos.x + e.pos.width > camera.pos.x
	local distance = math.abs(e.pos.x - player.pos.x)
	local passiveDistance = e.enemyState.passiveDistance
	
	if e.enemyState.state ~= "attack" and e.enemyState.state ~= "attacking" then
		e.pos.dx = ( e.pos.x - player.pos.x >= 0 ) and -1 or 1
	end
	
	-- idle state
	if e.enemyState.state == "idle" then
		if onCamera then e.enemyState.state = "aggressive" end
	end
	
	-- passive state
	if e.enemyState.state == "passive" then
		if distance <= passiveDistance+1 and distance >= passiveDistance-1 then
			e.vel.x = 0
		elseif distance < passiveDistance then
			e.vel.x = -speed*e.pos.dx
		else
			e.vel.x = speed*e.pos.dx
		end
	end
	
	-- aggressive state
	if e.enemyState.state == "aggressive" then
		-- if not onCamera then e.enemyState.state = "idle"
		if distance < 26 then e.enemyState.state = "attack" end
		e.vel.x = speed*e.pos.dx
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
		Concurrency.runFunction(function(distance, state)
			concurrency:sleep(0.6)
			state.state = "passive"
			concurrency:sleep(math.random(1,7)/10)
			state.state = "idle"
		end, distance, e.enemyState)
	end
	
		if e.mortalState.invincible then
			if e.mortalState.recovery:update(dt) then
				e.mortalState.invincible = false
			end
		end

end