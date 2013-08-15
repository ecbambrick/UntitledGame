--[[----------------------------------------------------------------------------
--]]----------------------------------------------------------------------------

DEBUG_MODE = {
	active = false,
	showHitboxes = true,
	showSpatialmaps = true,
	showSolidTiles = true,
}
WINDOW_SCALE = 2
WINDOW_WIDTH = love.graphics.getWidth() / WINDOW_SCALE
WINDOW_HEIGHT = love.graphics.getHeight() / WINDOW_SCALE

function love.load()

--------------------------------------------------------------------- LIBRARIES

	-- utility libraries
	secs 	 			= require "lib.secs"
	newTimer			= require "lib.timer"
	newAnimation		= require "lib.animation"
	newSpatialMap		= require "lib.spatialmap"
						  require "lib.math"
						  require "lib.coroutines"

------------------------------------------------ GLOBAL JUNK I NEED TO CLEAN UP

	love.graphics.setBackgroundColor(0,0,0,255)
    love.graphics.setDefaultImageFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")
	
	frameData2 = require("framedata.protagonist")
	frameData3 = require("framedata.enemy1")
	knife = love.graphics.newImage("assets/subweapons.gif")
	explosion = love.graphics.newImage("assets/explosion.gif")
	
	-- set table[key] to a value after a certain amount of time
	runCoroutine = function(func, ...)
		local ro = coroutine.create(func)
		local state, result = coroutine.resume(ro, unpack(arg))
		if not state then error( tostring(result), 2 ) end
		return state, result
	end
	function setAfter(t, k, v, count)
		wait(count)
		if t then t[k] = v end
	end
	setLater = function(t, k, v, count)
		runCoroutine(setAfter, t, k, v, count)
	end
	
-------------------------------------------------------------------- COMPONENTS

	-- fundamentals
	secs.component("pos",            { x = 0, y = 0, z = 0, dx = 1, dy = 1 })
	secs.component("vel",            { x = 0, y = 0, maxX = 100, maxY = 500, defaultMaxX = 100, defaultMaxY = 265 })
	secs.component("sprite",         { image = false })
	secs.component("debug",          { id = "", msg = "" })
	secs.component("stage",			 { map = false, path = "", load = false })
	secs.component("color",			 { rgb = false })
	secs.component("camera",		 { target = false, x1 = 0, y1 = 0, x2 = WINDOW_WIDTH, y2 = WINDOW_HEIGHT })
	
	-- collision detection
	secs.component("animation",      { current = false, list = false })
	secs.component("spatialhash",	 { })
	secs.component("hitboxes",       { })
	
	-- input
	secs.component("playerInput",    { queue = false, commands = false })
	
	-- states
	secs.component("playerState",    { ducking = false, subweaponing = false, jumping = false, attacking = false, walking = false, dashing = false })
	secs.component("attackState",    { active = false, finished = false, timer = false, type = "attack" })
	secs.component("physicsState",   { onGround = false, hasGravity = true, hasFriction = true })
	secs.component("enemyState",     { behaviour = "attack", state = "idle", passiveDistance = 64 })
	secs.component("mortalState", 	 { health = 3, dead = false, invincible = false, recovery = false })
	
	-- gameplay specific
	secs.component("sinusoidal",     { x = false, y = false, frequency = 1, amplitude = 100, time = 0 })
	secs.component("subweapon",      { current = "knife", ready = true, recovery = 0.4, stock = 5 })
	secs.component("isSubweapon",    { type = "knife" })
	
------------------------------------------------------------------ ENTITY TYPES

	-- input
	secs.type("controllablePlayers", "playerInput")
	secs.type("controllableMenus",   "menuInput")
	
	-- single stuff
	secs.type("cameras", "camera", "pos")
	
	-- ingame objects
	secs.type("players", "playerInput", "animation", "pos", "vel", "attackState", "playerState")
	secs.type("stages", "stage")
	secs.type("enemies", "pos", "enemyState")
	secs.type("subweapons", "pos", "isSubweapon")
	
	-- physics, collision and animation
	secs.type("spatialMaps", "spatialhash")
	secs.type("physical",    "pos", "vel")
	secs.type("collidable",  "hitboxes", "pos")
	secs.type("animated",    "animation", "pos")
	secs.type("sprites",     "sprite", "pos")

-------------------------------------------------------------- ENTITY FACTORIES
	
	secs.factory("camera", function(target, x1, y1, x2, y2)
		return secs.entity(
			{ "camera", { target = target }},
			{ "pos" }
		)
	end)
	
	secs.factory("knife", function(x, y, dx)
		if not x and not y then error("knife entity requires x and y") end
		return secs.entity(
			{ "isSubweapon" },
			{ "pos", { x = x, y = y, dx = dx or 1 }},
			{ "sprite", { image = knife }},
			{ "vel", { x = dx * 250, maxX = 500 }},
			{ "hitboxes", {{ type = "attack", width = 16, height = 12, offsetX = 0, offsetY = -2, centerX = 10, centerY = 6 }}}
		)
	end)
	
	secs.factory("axe", function(x, y, dx)
		if not x and not y then error("axe entity requires x and y") end
		return secs.entity(
			{ "isSubweapon" },
			{ "pos", { x = x, y = y, dx = dx or 1 }},
			{ "sprite", { image = knife }},
			{ "vel", { x = dx * 100, y = -500, maxX = 200 }},
			{ "physicsState", { hasFriction = false }},
			{ "hitboxes", {{ type = "attack", width = 20, height = 12, offsetX = 2, offsetY = -2, centerX = 10, centerY = 6 }}}
		)
	end)
	
	secs.factory("stage", function(filePath, load)
		return secs.entity(
			{"stage", { path = filePath, load = load or false }}
		)
	end)
	
	secs.factory("spatialmap", function(size)
		return secs.entity(
			{ "spatialhash", { map = newSpatialMap(size) }}
		)
	end)
	
	secs.factory("enemy", function(x,y)
		return secs.entity(
			{ "pos", { x = x, y = y } },
			{ "animation", { current = "idle", list = {
				idle   = newAnimation(frameData3, 0,   true,  1),
				walk   = newAnimation(frameData3, 0.1, true,  1,2,3,4),
				attack = newAnimation(frameData3, 0.05, false, 5,6,7,8,8,8,8,9,10),
			}}},
			{ "mortalState", { health = 3, recovery = newTimer(0.1) } },
			{ "enemyState",  { passiveDistance = math.random(48,80) } },
			{ "physicsState" },
			{ "hitboxes" },
			{ "vel" }
		)
	end)
	
	secs.factory("player", function(x, y)
		return secs.entity(
			{ "debug", { id = "player" }},
			{ "pos", { x = x, y = y }},
			{ "subweapon", { current = "knife" }},
			{ "attackState", { timer = newTimer(0.45) }},
			{ "mortalState", { recovery = newTimer(0.8) } },
			{ "animation", { current = "idle", list = {
				idle       = newAnimation(frameData2, 0,    true,  1),
				ready      = newAnimation(frameData2, 0,    true,  21),
				duck       = newAnimation(frameData2, 0,    true,  2),
				jump       = newAnimation(frameData2, 0.07, false, 3),
				readyWalk  = newAnimation(frameData2, 0,    true,  21),
				walk       = newAnimation(frameData2, 0.09, true,  4,5,6,4,7,8,9),
				subweapon  = newAnimation(frameData2, 0.05, false, 17,18,18,19,18,17,20,21),
				attack     = newAnimation(frameData2, 0.05, false, 10,11,11,12,13,14,15,16),
				jumpAttack = newAnimation(frameData2, 0.05, false, 21,10,11,11,12,13,14,15,16),
				duckAttack = newAnimation(frameData2, 0.05, false, 21,10,11,11,12,13,14,15,16),
				-- jumpAttack = newAnimation(frameData2, 0.05, false, 22,23,23,24,25,26,27,28),
			}}},
			{ "playerInput", { queue = {}, commands = {
				jump = "z", 
				attack = "x", 
				up = "up",
				left = "left", 
				right = "right", 
				duck = "down",
				dashLeft = "a",
				dashRight = "s",
			}}},
			{ "physicsState" },
			{ "hitboxes" },
			{ "playerState", {
				dashing = newTimer(0.1)
			}},
			{ "vel" }
		)
	end)

---------------------------------------------------------------------- ENTITIES

	DEBUG_MODE.active = false
	secs.entity.spatialmap(32)
	secs.entity.stage("assets/area1 (3,3).tmx", true)
	local player = secs.entity.player(16*4, 16*9-2)
	secs.entity.enemy(16*18, 16*9-2)
	secs.entity.enemy(16*19, 16*9-2)
	secs.entity.enemy(16*24, 16*9-2)
	secs.entity.enemy(16*30, 16*9-2)
	secs.entity.camera(player.pos)
	
	secs.entity(
		{ "pos", { x = 16*8, y = 16*9 }},
		{ "animation", { current = "idle", list = { idle = newAnimation(frameData2, 0, false, 32) }}}
	)
	secs.entity(
		{ "pos", { x = 16*6, y = 16*9 }},
		{ "animation", { current = "idle", list = { idle = newAnimation(frameData2, 0, false, 31) }}}
	)

----------------------------------------------------------------------- SYSTEMS

	require "systems.tiledmap"
	require "systems.systeminput"
	require "systems.playerinput"
	require "systems.playerstate"
	require "systems.ai"
	require "systems.animation"
	require "systems.camera"
	require "systems.physics"
	require "systems.collision"
	require "systems.rendering"
	require "systems.debug"

end

------------------------------------------------------------------- DRAW/UPDATE

DT, DBG = 0, 0
function love.update(dt)
	DT, DBG = dt, ""
	if dt > 1/20 then dt = 1/20 end
	if love.keyboard.isDown("tab") then
		dt = dt / 30
	end
	wakeUpWaitingThreads(dt)
	secs.update(dt)
end

function love.draw()
	secs.draw()
end
