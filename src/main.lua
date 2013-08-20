--[[----------------------------------------------------------------------------
--]]----------------------------------------------------------------------------

function love.load()

------------------------------------------------------------ GRAPHICAL SETTINGS

    love.graphics.setBackgroundColor(0,0,0,255)
    love.graphics.setDefaultImageFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")

--------------------------------------------------------- LIBRARIES AND GLOBALS

	-- utility libraries
   require "lib.math"
   require "lib.coroutines"
   
	-- window dimensions
	WINDOW_SCALE = 2
	WINDOW_WIDTH = love.graphics.getWidth() / WINDOW_SCALE
	WINDOW_HEIGHT = love.graphics.getHeight() / WINDOW_SCALE
	
	-- debug info
	DEBUG_MODE = {
		dt = 0,
		message = "",
		active = false,
		showHitboxes = true,
		showSpatialmaps = true,
		showSolidTiles = true,
	}

	-- need to clean the following up (some kind of asset module?)
	frameData2 = require("framedata.protagonist")
	frameData3 = require("framedata.enemy1")
	knife = love.graphics.newImage("assets/subweapons.gif")
	explosion = love.graphics.newImage("assets/explosion.gif")
	
	-- may not need the following (it's pretty terrible anyways)
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

---------------------------------------------------------------------- ECS DATA

	secs  = require "lib.secs"
			require "components"
			require "entityTypes"
			require "entities"
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

----------------------------------------------------------- INITIALIZE ENTITIES

	local player = secs.entity.player(16*38, 16*19-2)
	secs.entity.spatialmap(32)
	secs.entity.stage("assets/area1.tmx", "room2", true)
	secs.entity.camera(player.pos)
	
end -- end of love.load()

------------------------------------------------------------- DRAW/UPDATE LOOPS

function love.update(dt)
	-- update dt and reset debug message
	DEBUG_MODE.dt = dt
	DEBUG_MODE.message = ""
	
	-- prevent going under 20 fps (a huge dt can mess with some calculations)
	if dt > 1/20 then dt = 1/20 end
	
	-- slow down the game while tab is held down
	if love.keyboard.isDown("tab") then dt = dt / 30 end
	
	-- update game
	wakeUpWaitingThreads(dt)
	secs.update(dt)
end

function love.draw()
	secs.draw()
end
