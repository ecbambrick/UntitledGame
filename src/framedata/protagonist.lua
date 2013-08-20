------------------------------------------------------- INITIALIZE SPRITE SHEET

local spriteSheet  = love.graphics.newImage("assets/protagonist.gif")
local spriteWidth  = spriteSheet:getWidth()
local spriteHeight = spriteSheet:getHeight()
                     spriteSheet:setFilter("nearest", "nearest")

---------------------------------------------------------------- SET FRAME DATA

local function newSprite(x, y, w, h, ox, oy, cx, cy)
	return { quad = love.graphics.newQuad(x, y, w, h, spriteWidth, spriteHeight), offsetX = ox, offsetY = oy}
end
local function newHitbox(class, w, h, ox, oy, cx, cy)
	return { type = class, width = w, height = h, offsetX = ox, offsetY = oy}
end

return {
	image = spriteSheet,
	
	-- idle (1)
	{	sprite = newSprite(16*0, 32*0,		16, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	-- duck (2)
	{	sprite = newSprite(16*0, 32*1,		16, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  20, 	4,  12)}
	},
	-- jump (3)
	{	sprite = newSprite(16*1, 32*1,		16, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	
	-- run (4 - 9)
	{	sprite = newSprite(16*1, 32*0,		16, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*2, 32*0,		16, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*3, 32*0,		16, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*4, 32*0,		16, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*5, 32*0,		32, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*7, 32*0,		16, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	
	-- attack (10 - 16)
	{	sprite = newSprite(16*0, 32*2,		48, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*3, 32*2,		48, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4),
					 newHitbox("attack",	35,  4, 	12, 6)}
	},
	{	sprite = newSprite(16*6, 32*2,		32, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*8, 32*2,		32, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*10, 32*2,		32, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*12, 32*2,		16, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*13, 32*2,		16, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	
	-- subweapon (17 - 21)
	{	sprite = newSprite(16*0, 32*3,		32, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*2, 32*3,		32, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*4, 32*3,		32, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*6, 32*3,		16, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*7, 32*3,		16, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	
	-- jump attack (22 - 28)
	{	sprite = newSprite(16*0, 32*4,		48, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4),
					 newHitbox("attack",	32,  4, 	12, 6)}
	},
	{	sprite = newSprite(16*3, 32*4,		48, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4),
					 newHitbox("attack",	35,  4, 	12, 6)}
	},
	{	sprite = newSprite(16*6, 32*4,		32, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*8, 32*4,		32, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*10, 32*4,		32, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*12, 32*4,		16, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*13, 32*4,		16, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	
	-- test (29, 28)
	{	sprite = newSprite(16*8, 32*0,		16, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*9, 32*0,		16, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*10, 32*0,		16, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
	{	sprite = newSprite(16*11, 32*0,		16, 32,		0,  0),
		hitboxes = { newHitbox("active",	8,  28, 	4,  4)}
	},
}