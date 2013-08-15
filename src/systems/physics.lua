--[[----------------------------------------------------------------------------
--]]----------------------------------------------------------------------------

-- helper functions
local applyFriction, applyGravity, updatePositionX, updatePositionY
local preventHorizontalCollisions, preventVerticalCollisions
local resolveCollisionLeft, resolveCollisionRight
local resolveCollisionDown, resolveCollisionUp

-- physics properties
local gravity, frict = 700, 600

---------------------------------------------------------- MAIN UPDATE FUNCTION

secs.updatesystem("physics", 300, function(dt)
	
	-- load current map
	local map = secs.query("stages")[1].stage.map
	
	-- update hitboxes
	for i,e in ipairs(secs.query("collidable")) do
		for j,h in ipairs(e.hitboxes) do
			updateHitboxCoordinates(e, h)
		end
	end
	
	-- apply physical forces and prevent solid tile collisions
	for i,e in ipairs(secs.query("physical")) do
		
		-- x direction
		applyFriction(e, dt)
		preventHorizontalCollisions(e, map, dt)
		updatePositionX(e, dt)
		
		-- y direction
		applyGravity(e, dt)
		preventVerticalCollisions(e, map, dt)
		updatePositionY(e, dt)
		
	end
	
end)

--------------------------------------------------------------- PHYSICAL FORCES 

function applyFriction(e, dt)
	if e.physicsState and e.physicsState.hasFriction then
		local originalSign = math.sign(e.vel.x)
		e.vel.x = e.vel.x - frict * math.sign(e.vel.x) * dt
		if math.sign(e.vel.x) ~= originalSign then
			e.vel.x = 0
		end
	end
end
	
function applyGravity(e, dt)
	if e.physicsState and e.physicsState.hasGravity then
		e.physicsState.onGround = false
		e.physicsState.onOneway = false
		e.vel.y = e.vel.y + gravity * dt
	end
end

---------------------------------------------------------------------- POSITION

function updatePositionX(e, dt)
    e.vel.x = math.clamp(e.vel.x, e.vel.maxX)
    e.pos.x = e.pos.x + e.vel.x * dt
end

function updatePositionY(e, dt)
    e.vel.y = math.clamp(e.vel.y, e.vel.maxY)
    e.pos.y = e.pos.y + e.vel.y * dt
end

----------------------------------------------------------- COLLISION DETECTION

function preventVerticalCollisions(e, map, dt)
	local hitbox = getPushbox(e)
	if hitbox then
		if e.vel.y < 0 then resolveCollisionUp(e, hitbox, map, dt)    end
		if e.vel.y > 0 then resolveCollisionDown(e, hitbox, map, dt)  end
	end
end

function preventHorizontalCollisions(e, map, dt)
	local hitbox = getPushbox(e)
	if hitbox then
		if e.vel.x < 0 then resolveCollisionLeft(e, hitbox, map, dt)  end
		if e.vel.x > 0 then resolveCollisionRight(e, hitbox, map, dt) end
	end
end

function resolveCollisionDown(e, hitbox, map, dt)
	local w, h, solidLayer = map.tileWidth, map.tileHeight, map("solid")
	for x = math.floor(hitbox.x1/w), math.ceil(hitbox.x2/w)-1 do
		for y = math.ceil(hitbox.y2/h), math.floor((hitbox.y2+e.vel.y*dt)/h) do
			local tile = solidLayer(x,y)
			if tile then
				e.pos.y = y*h - hitbox.offsetY - hitbox.height
				e.vel.y = 0
				if e.physicsState then
					e.physicsState.onGround = true
					if tile.properties.type == "oneway" then
						e.physicsState.onOneway = true
					end
				end
			end
		end
	end
end

function resolveCollisionUp(e, hitbox, map, dt)
	local w, h, solidLayer = map.tileWidth, map.tileHeight, map("solid")
	for x = math.floor(hitbox.x1/w), math.ceil(hitbox.x2/w)-1 do
		for y = math.floor(hitbox.y1/h)-1, math.floor((hitbox.y1+e.vel.y*dt)/h), -1 do
			local tile = solidLayer(x,y)
			if tile and tile.properties.type ~= "oneway" then
				e.pos.y = (y+1)*h - hitbox.offsetY
				e.vel.y = 0
			end
		end
	end
end

function resolveCollisionLeft(e, hitbox, map, dt)
	local w, h, solidLayer = map.tileWidth, map.tileHeight, map("solid")
	for x = math.floor((hitbox.x1+e.vel.x*dt)/w), math.ceil(hitbox.x1/w)-1, -1 do
		for y = math.floor(hitbox.y1/h), math.ceil(hitbox.y2/h)-1 do
			local tile = solidLayer(x,y)
			if tile and tile.properties.type ~= "oneway" then
				e.pos.x = (x+1)*w - hitbox.offsetX
				e.vel.x = 0
			end
		end
	end
end

function resolveCollisionRight(e, hitbox, map, dt)
	local w, h, solidLayer = map.tileWidth, map.tileHeight, map("solid")
	for x = math.ceil(hitbox.x2/w), math.floor((hitbox.x2+e.vel.x*dt)/w) do
		for y = math.floor(hitbox.y1/h), math.ceil(hitbox.y2/h)-1 do
			local tile = solidLayer(x,y)
			if tile and tile.properties.type ~= "oneway" then
				e.pos.x = x*w - hitbox.offsetX - hitbox.width
				e.vel.x = 0
			end
		end
	end
end

------------------------------------------------------------- HITBOX MANAGEMENT

function updateHitboxCoordinates(e, hitbox)
	if e.pos.dx >= 0 then
		hitbox.x1 = e.pos.x + hitbox.offsetX
	else
		hitbox.x1 = e.pos.x - hitbox.offsetX - hitbox.width  + hitbox.centerX*2
	end
	if e.pos.dy >= 0 then
		hitbox.y1 = e.pos.y + hitbox.offsetY
	else
		hitbox.y1 = e.pos.y - hitbox.offsetY - hitbox.height + hitbox.centerY*2
	end
	hitbox.x2 = hitbox.x1 + hitbox.width
	hitbox.y2 = hitbox.y1 + hitbox.height
end

function getPushbox(e)
	if e.hitboxes then
		for i,hitbox in ipairs(e.hitboxes) do
			if hitbox.type == "active" or hitbox.type == "passive" then
				return hitbox
			end
		end
	end
end
