------------------------------------------------------- INITIALIZE SPRITE SHEET

local newQuad     = love.graphics.newQuad

local spriteSheet = love.graphics.newImage("assets/enemies.gif")
local w           = spriteSheet:getWidth()
local h           = spriteSheet:getHeight()
                    spriteSheet:setFilter("nearest", "nearest")

---------------------------------------------------------------- SET FRAME DATA

return {
	image = spriteSheet,
	
	-- idle (1)
	{	sprite = { quad = newQuad(16*0, 0, 16, 32, w, h), 		offsetX = 0, offsetY = 0, centerX = 8, centerY = 16 },
		hitboxes = {{ type = "active", width = 10, height = 25, offsetX = 3, offsetY = 6, centerX = 8, centerY = 16 }}
	},
	
	-- walking (1,2,3,4)
	{	sprite = { quad = newQuad(16*1, 32*0, 16, 32, w, h), 	offsetX = 0, offsetY = 0, centerX = 8, centerY = 16 },
		hitboxes = {{ type = "active", width = 10, height = 25, offsetX = 3, offsetY = 6, centerX = 8, centerY = 16 }}
	},
	{	sprite = { quad = newQuad(16*2, 32*0, 16, 32, w, h), 	offsetX = 0, offsetY = 0, centerX = 8, centerY = 16 },
		hitboxes = {{ type = "active", width = 10, height = 25, offsetX = 3, offsetY = 6, centerX = 8, centerY = 16 }}
	},
	{	sprite = { quad = newQuad(16*3, 32*0, 16, 32, w, h), 	offsetX = 0, offsetY = 0, centerX = 8, centerY = 16 },
		hitboxes = {{ type = "active", width = 10, height = 25, offsetX = 3, offsetY = 6, centerX = 8, centerY = 16 }}
	},
	
	-- attacking (5,6,7,8)
	{	sprite = { quad = newQuad(16*0, 32*1, 32, 32, w, h), 	offsetX = 0, offsetY = 0, centerX = 8, centerY = 16 },
		hitboxes = {{ type = "active", width = 10, height = 25, offsetX = 3, offsetY = 6, centerX = 8, centerY = 16 }}
	},
	{	sprite = { quad = newQuad(16*2, 32*1, 32, 32, w, h), 	offsetX = 0, offsetY = 0, centerX = 8, centerY = 16 },
		hitboxes = {{ type = "active", width = 10, height = 25, offsetX = 3, offsetY = 6, centerX = 8, centerY = 16 }}
	},
	{	sprite = { quad = newQuad(16*4, 32*1, 32, 32, w, h), 	offsetX = 0, offsetY = 0, centerX = 8, centerY = 16 },
		hitboxes = {{ type = "active", width = 10, height = 25, offsetX = 3, offsetY = 6, centerX = 8, centerY = 16 }}
	},
	{	sprite = { quad = newQuad(16*6, 32*1, 32, 32, w, h), 	offsetX = 0, offsetY = 0, centerX = 8, centerY = 16 },
		hitboxes = {{ type = "active", width = 10, height = 25, offsetX = 3, offsetY = 6, centerX = 8, centerY = 16 }}
	},
	{	sprite = { quad = newQuad(16*4, 32*0, 32, 32, w, h), 	offsetX = 0, offsetY = 0, centerX = 8, centerY = 16 },
		hitboxes = {{ type = "active", width = 10, height = 25, offsetX = 3, offsetY = 6, centerX = 8, centerY = 16 }}
	},
	{	sprite = { quad = newQuad(16*6, 32*0, 32, 32, w, h), 	offsetX = 0,  offsetY = 0, centerX = 8, centerY = 16 },
		hitboxes = {{ type = "active", width = 10, height = 25, offsetX = 3,  offsetY = 6, centerX = 8, centerY = 16 },
		            { type = "attack", width = 20, height = 7,  offsetX = 11, offsetY = 8, centerX = 8, centerY = 16 }}
	},
}
