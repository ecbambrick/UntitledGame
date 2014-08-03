concurrency	= require('lib.concurrency')()
secs			= require('lib.secs')()
debugger		= require('lib.debugger')()

--------------------------------------------------------------------------------
-- Load game.
--------------------------------------------------------------------------------
function love.load()
	
    -- Initialize graphical settings.
    love.graphics.setBackgroundColor(0,0,0,255)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")
	
    -- Keep all assets global for the time being. I'll fix this later.
    knife		= love.graphics.newImage("assets/subweapons.gif")
    explosion	= love.graphics.newImage("assets/explosion.gif")
    sword		= love.graphics.newImage("assets/items.gif")
    frameData2	= require("framedata.protagonist")
    frameData3	= require("framedata.enemy1")
    frameData4	= require("framedata.enemy2")
	
	-- Entities, components, and systems
	require("components")(secs)
	require("entities")(secs)
	require("systems.tiledmap")(secs)
	require("systems.systeminput")
	require("systems.playerinput")
	require("systems.playerstate")
	require("systems.ai")
	require("systems.animation")
	require("systems.camera")
	require("systems.physics")
	require("systems.collision")
	require("systems.rendering")
	require("systems.debug")
	
    -- Initialize game objects.	
    local player = Player(secs, 24*16, 19*16)
                   Camera(secs, player.pos)
				   SpatialMap(secs, 32)
				   Stage(secs, "assets/area1.tmx", "room3", true)
end

--------------------------------------------------------------------------------
-- Update game.
--------------------------------------------------------------------------------
function love.update(dt)

    -- Prevent going under 20 fps (a large dt can mess with some calculations).
    if dt > 1/10 then dt = 1/10 end
    
    -- Slow down or speed up the game while tab is held down for debugging.
    if love.keyboard.isDown("tab") then
        if love.keyboard.isDown("lshift") then
            dt = 0.0001
        else
            dt = 1/30
        end
    end
    
    -- update game
    concurrency:update(dt)
    secs:update(dt)
end

--------------------------------------------------------------------------------
-- Draw game.
--------------------------------------------------------------------------------
function love.draw()
    secs:draw()
end
