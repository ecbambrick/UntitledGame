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
	local x1, x2 = math.floor(hitbox.x1/w), math.ceil(hitbox.x2/w)-1
	local y1, y2 = math.ceil(hitbox.y2/h), math.floor((hitbox.y2+e.vel.y*dt)/h)
	for y = y1, y2 do
		for x = x1, x2 do
			-- prevent movement into solid and one-way tiles
			local tile1 = solidLayer(x,y)
			local tile2 = solidLayer(math.ceil(hitbox.x2/w)-1, y)
			if tile1 then
				resolveCollisionOneWay(e, tile1, tile2)
				e.pos.y = y*h - hitbox.offsetY - hitbox.height
				e.vel.y = 0
				return
			end
		end
	end
end

function resolveCollisionUp(e, hitbox, map, dt)
	local w, h, solidLayer = map.tileWidth, map.tileHeight, map("solid")
	local x1, x2 = math.floor(hitbox.x1/w), math.ceil(hitbox.x2/w)-1
	local y1, y2 = math.floor(hitbox.y1/h)-1, math.ceil((hitbox.y1+e.vel.y*dt)/h)-1
	for y = y1, y2, -1 do
		for x = x1, x2 do
			-- prevent movement into solid tiles
			local tile = solidLayer(x,y)
			if tile and tile.properties.type == "solid" then
				e.pos.y = (y+1)*h - hitbox.offsetY
				e.vel.y = 0
				return
			end
		end
	end
end

function resolveCollisionLeft(e, hitbox, map, dt)
	local w, h, solidLayer = map.tileWidth, map.tileHeight, map("solid")
	local x1, x2 = math.floor(hitbox.x1/w), math.floor((hitbox.x1+e.vel.x*dt)/w)
	local y1, y2 = math.floor(hitbox.y1/h), math.ceil(hitbox.y2/h)-1
	for x = x1, x2, -1 do
		for y = y1, y2 do
			-- prevent movement into solid tiles
			local tile = solidLayer(x,y)
			if tile and tile.properties.type == "solid" then
				e.pos.x = (x+1)*w - hitbox.offsetX
				e.vel.x = 0
				return
			end
		end
	end
end

function resolveCollisionRight(e, hitbox, map, dt)
	local w, h, solidLayer = map.tileWidth, map.tileHeight, map("solid")
	local x1, x2 = math.floor(hitbox.x2/w), math.floor((hitbox.x2+e.vel.x*dt)/w) 
	local y1, y2 = math.floor(hitbox.y1/h), math.ceil(hitbox.y2/h)-1
	for x = x1, x2 do
		for y = y1, y2 do
			-- prevent movement into solid tiles
			local tile = solidLayer(x,y)
			if tile and tile.properties.type == "solid" then
				e.pos.x = x*w - hitbox.offsetX - hitbox.width
				e.vel.x = 0
				return
			end
		end
	end
end

function resolveCollisionOneWay(e, tile1, tile2)
	if e.physicsState then
		e.physicsState.onGround = true
		if tile1.properties.type == "oneway"
		and ( not tile2 or tile2.properties.type == "oneway" ) then
			e.physicsState.onOneway = true
		end
	end
end

------------------------------------------------------------- HITBOX MANAGEMENT

function updateHitboxCoordinates(e, hitbox)
	if e.pos.dx >= 0 then
		hitbox.x1 = e.pos.x + hitbox.offsetX
	else
		hitbox.x1 = e.pos.x - hitbox.offsetX - hitbox.width + e.pos.width
	end
	if e.pos.dy >= 0 then
		hitbox.y1 = e.pos.y + hitbox.offsetY
	else
		hitbox.y1 = e.pos.y - hitbox.offsetY - hitbox.height + e.pos.height
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
