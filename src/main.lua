local Concurrency		= require('lib.concurrency')
local Secs				= require('lib.secs')
local Debugger			= require('lib.debugger')
local components		= require('components')
local Entities			= require('entities')
local TiledMapSystem	= require('systems.tiledmap')
local GlobalInputSystem	= require("systems.globalinput")
local RenderSystem		= require('systems.rendering')
local PlayerInputSystem	= require("systems.playerinput")
local PlayerStateSystem = require("systems.playerstate")
local CameraSystem		= require("systems.camera")
local AnimationSystem	= require("systems.animation")
local PhysicsSystem		= require("systems.physics")
local AiSystem			= require("systems.ai")
local CollisionSystem	= require("systems.collision")
local DebugSystem		= require("systems.debug")

local concurrency		= Concurrency()
local secs				= Secs()
local debugger			= Debugger()
local factory			= Entities(secs)

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
	
	-- Initialize components.
	for name, data in pairs(components) do
		secs:Component(name, data)
	end
	
	-- Initialize update systems.
	secs:System("tiledmap",		TiledMapSystem(secs, factory))
	secs:System("globalinput",	GlobalInputSystem(secs, debugger))
	secs:System("playerinput",	PlayerInputSystem(secs))
	secs:System("playerstate",	PlayerStateSystem(secs, factory, concurrency))
	secs:System("ai",			AiSystem(secs, concurrency))
	secs:System("animation",	AnimationSystem(secs))
	secs:System("camera",		CameraSystem(secs))
	secs:System("physics",		PhysicsSystem(secs))
	secs:System("collision",	CollisionSystem(secs, concurrency))
	
	-- Initialize render systems.
	secs:System("rendering",	RenderSystem(secs))
	secs:System("debug",		DebugSystem(secs, debugger))
	
    -- Initialize game objects.	
    local player = factory:Player(32*16, 19*16)
                   factory:Camera(player.pos)
				   factory:SpatialMap(32)
				   factory:Stage("assets/area1.tmx", true)
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
            dt = dt / 5
        else
            dt = dt * 5
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
