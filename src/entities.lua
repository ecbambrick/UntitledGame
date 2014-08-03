local newSpatialMap = require("lib.spatialmap")
local newAnimation  = require("lib.animation")
local newTimer      = require("lib.timer")

return function(secs)

------------------------------------------------------------------ FUNDAMENTALS

--[[
targets the position component of another entity and takes a set of
x,y coordinates as boundary limits to the camera's movement
--]]
Camera = function(secs, target, x1, y1, x2, y2)
    return secs:Entity({ 
		pos = {},
		camera = {
            target = target,
            x1 = x1 or 0,
            y1 = y1 or 0,
            x2 = x2 or WINDOW_WIDTH,
            y2 = y2 or WINDOW_HEIGHT,
        }
    })
end

--[[
the map for an area
room is the name of the map room the game is currently focused on
load determines whether or not to load the map on the next frame
--]]
Stage = function(secs, filePath, room, load)
    return secs:Entity({
        stage = { 
            path = filePath, 
            room = room or "1", 
            loadStage = load or false
        }
    })
end

--[[
a spatial hash map for organizing physical entities
--]]
SpatialMap = function(secs, size)
    return secs:Entity({
        spatialhash = {
            map = newSpatialMap(size)
        }
    })
end

------------------------------------------------------------------ GAME OBJECTS

--[[
travels forward until colliding with an enemy or going offscreen
--]]
factory = {}
factory.knife = function(x, y, dx)
	x = x or 0
	y = y or 0
	dx = dx or 1
	
    return secs:Entity({
        isSubweapon = {},
        pos = { 
            x = x, 
            y = y, 
            dx = dx,
            width = 16,
            height = 12
        },
        sprite = { 
            image = knife
        },
        vel = { 
            x = dx * 250, 
            maxX = 500
        },
        hitboxes = {{    
            type = "attack", 
            width = 16, 
            height = 12, 
            offsetX = 0, 
            offsetY = -2
        }}
    })
end

--[[
the player
--]]
Player = function(secs, x, y)
    return secs:Entity({
        pos = { 
            x = x, 
            y = y,
            width = 16,
            height = 32
        },
        subweapon = { 
            current = "knife"
        },
        attackState = { 
            timer = newTimer(0.45)
        },
        mortalState = { 
            recovery = newTimer(0.8)
        },
        playerState = {
            dashing = newTimer(0.1)
        },
        animation = { 
            current = "idle",
            list = {
                idle       = newAnimation(frameData2, 0,    true,  32),
                ready      = newAnimation(frameData2, 0,    true,  21),
                duck       = newAnimation(frameData2, 0,    true,  2),
                jump       = newAnimation(frameData2, 0.07, false, 3),
                readyWalk  = newAnimation(frameData2, 0,    true,  21),
                walk       = newAnimation(frameData2, 0.09, true,  4,5,6,4,7,8,9),
                -- walk       = newAnimation(frameData2, 0.09, true,  8,9,4,5,6,4,7),
                subweapon  = newAnimation(frameData2, 0.05, false, 17,18,18,19,18,17,20,21),
                attack     = newAnimation(frameData2, 0.05, false, 10,11,11,12,13,14,15,16),
                jumpAttack = newAnimation(frameData2, 0.05, false, 21,10,11,11,12,13,14,15,16),
                duckAttack = newAnimation(frameData2, 0.05, false, 21,10,11,11,12,13,14,15,16),
                -- jumpAttack = newAnimation(frameData2, 0.05, false, 22,23,23,24,25,26,27,28),
            }
        },
        playerInput = { 
            queue = {}, 
            commands = {
                jump = "z", 
                attack = "x", 
                up = "up",
                left = "left", 
                right = "right", 
                duck = "down",
                dashLeft = "a",
                dashRight = "s",
            }
        },
        physicsState = {
			hasFriction = true,
		},
        vel = {
			maxX = 95
		},
        hitboxes = {}
    })
end

--[[
generic enemy, this needs to be renamed oce more enemies are added
--]]
factory.enemy = function(x,y)
    return secs:Entity({
        pos = { 
            x = x, 
            y = y,
            width = 16,
            height = 32
        },
        mortalState = { 
            health = 3, 
            recovery = newTimer(0.11)
        },
        enemyState = { 
            passiveDistance = math.random(48,80)
        },
        animation = {
            current = "idle",
            list = {
                idle   = newAnimation(frameData3, 0,    true,  1),
                walk   = newAnimation(frameData3, 0.1,  true,  1,2,3,4),
                attack = newAnimation(frameData3, 0.05, false, 5,6,7,8,8,8,8,9,10),
            }
        },
        physicsState = {},
        hitboxes = {},
        vel = {}
    })
end

factory.enemy2 = function(x,y)
    return secs:Entity({
        pos = { 
            x = x, 
            y = y,
            width = 16,
            height = 32
        },
        mortalState = { 
            health = 3, 
            recovery = newTimer(0.11)
        },
        animation = {
            current = "idle",
            list = {
                idle   = newAnimation(frameData4, 0,    true,  1),
            }
        },
        enemyState = { 
            state = "stationary"
        },
        hitboxes = {},
        vel = {}
    })
end

--[[
item???
--]]
Item = function(x, y, value)
    return secs:Entity({
        pos = { 
            x = x, 
            y = y,
            width = 16,
            height = 32
        },
		sprite = {
			image = sword
		},
		item = {
			value = value
		},
        hitboxes = {{    
            type = "active", 
            width = 16, 
            height = 16, 
            offsetX = 0, 
            offsetY = 0
        }}
	})
end

end