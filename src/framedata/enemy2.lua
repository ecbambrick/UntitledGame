------------------------------------------------------- INITIALIZE SPRITE SHEET

local spriteSheet  = love.graphics.newImage("assets/enemies.gif")
local spriteWidth  = spriteSheet:getWidth()
local spriteHeight = spriteSheet:getHeight()
                     spriteSheet:setFilter("nearest", "nearest")

---------------------------------------------------------------- SET FRAME DATA

local function newSprite(x, y, w, h, ox, oy)
	return { quad = love.graphics.newQuad(x, y, w, h, spriteWidth, spriteHeight), offsetX = ox, offsetY = oy}
end
local function newHitbox(class, w, h, ox, oy)
	return { type = class, width = w, height = h, offsetX = ox, offsetY = oy}
end

return {
	image = spriteSheet,
	
	-- idle (1)
	{	sprite = newSprite(16*8, 32*0,		16, 32,		0,  0),
		hitboxes = { newHitbox("active",	16, 32, 	0,  0)}
	},
	
}
