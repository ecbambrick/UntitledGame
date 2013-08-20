--[[----------------------------------------------------------------------------
--]]----------------------------------------------------------------------------

local resolveCollision, updateHitboxCoordinates
local flashRed, killEnemy

---------------------------------------------------------- MAIN UPDATE FUNCTION

--[[
asdasdsad
--]]
secs.updatesystem("collision", 400, function(dt)

	local space = secs.query("spatialMaps")[1].spatialhash.map
	local collidableEntities = secs.query("collidable")
	
	-- update spatial map and hitboxes
	space:clear()
	for i,e in ipairs(collidableEntities) do
		for j,h in ipairs(e.hitboxes) do
			updateHitboxCoordinates(e, h)
			space:insert(h, e, h.x1, h.y1, h.x2, h.y2)
		end
	end
	
	-- check for collisions
	for i,a in ipairs(collidableEntities) do
		for j,h1 in ipairs(a.hitboxes) do
			for h2,b in pairs(space:getNearby(h1.x1, h1.y1, h1.x2, h1.y2)) do	
				if a ~= b
				and h1.x1 < h2.x2 and h1.x2 > h2.x1 
				and h1.y1 < h2.y2 and h1.y2 > h2.y1 then
					resolveCollision(a, b, h1.type, h2.type)
				end
			end
		end
	end
	
	-- update hitboxes
	for i,e in ipairs(collidableEntities) do
		for j,h in ipairs(e.hitboxes) do
			updateHitboxCoordinates(e, h)
		end
	end
	
end)

-------------------------------------------------------------- HELPER FUNCTIONS

function updateHitboxCoordinates(e, hitbox)
	if e.pos.dx >= 0 then
		hitbox.x1 = e.pos.x + hitbox.offsetX
	else
		hitbox.x1 = e.pos.x - hitbox.offsetX - hitbox.width + hitbox.centerX*2
	end
	if e.pos.dy >= 0 then
		hitbox.y1 = e.pos.y + hitbox.offsetY
	else
		hitbox.y1 = e.pos.y - hitbox.offsetY - hitbox.height + hitbox.centerY*2
	end
	hitbox.x2 = hitbox.x1 + hitbox.width
	hitbox.y2 = hitbox.y1 + hitbox.height
end

--------------------------------------------------- RESOLUTION HELPER FUNCTIONS

function flashRed(e)
	local c = coroutine.create(function(e)
		if not e.color then
			secs.attach(e, "color", { rgb = { 255, 0, 0, 255 } })
		end
		for i = 1,3 do
			e.color.rgb = { 255, 0, 0, 255 }
			wait(0.1)
			e.color.rgb = { 255, 255, 255, 0 }
			wait(0.1)
		end
		e.color.rgb = { 255, 255, 255, 255 }
	end)
	coroutine.resume(c, e)
end

function killEnemy(e)
	flashRed(e)
	if e.mortalState then
		e.mortalState.invincible = true
		e.mortalState.recovery:reset()
		e.mortalState.health = e.mortalState.health - 1
		if e.mortalState.health <= 0 then
			runCoroutine(function(e)
				e.pos.y = e.pos.y + 4
				secs.detach(e, "animation", "enemyState", "color", "vel", "hitboxes")
				secs.attach(e, "sprite", { image = explosion })
				wait(0.5)
				secs.delete(e)
			end, e)
		end
	end
end

---------------------------------------------------------- COLLISION RESOLUTION

function resolveCollision(a, b, aType, bType)

	if a.playerState and b.enemyState and aType == "attack"
	and b.mortalState and not b.mortalState.invincible then
		killEnemy(b)
	end
	
	if a.enemyState and b.playerState and bType ~= "attack"
	and b.mortalState and not b.mortalState.invincible then
		flashRed(b)
		b.vel.y = -150
		b.vel.x = -500*b.pos.dx
		b.mortalState.invincible = true
		b.mortalState.recovery:reset()
	end
	
	if a.isSubweapon and b.enemyState then
		secs.delete(a)
		killEnemy(b)
	end

end