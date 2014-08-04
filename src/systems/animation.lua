local AnimationSystem = {}
local updateFrame, resetAnimation, updatePlayerAnimation, updateHitboxes
local updateEnemyAnimation

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function AnimationSystem:update(dt)
	local secs = self.secs

	for e in pairs(secs:query("playerState")) do
		updatePlayerAnimation(e)
	end
	for e in pairs(secs:query("enemyState")) do
		updateEnemyAnimation(e)
	end
	for e in pairs(secs:query("animation pos")) do
		updateFrame(e, dt)
		updateHitboxes(e, dt)
	end
end

-------------------------------------------------------------- ANIMATION UPDATE

--[[
update animation's current frame once the animation's delay has been exceeded
--]]
function updateFrame(e, dt)
	local animation = e.animation.list[e.animation.current]
	if animation.timer:update(dt) then
		if animation.loop then
			animation.currentFrame = animation.currentFrame % #animation + 1
		else
			animation.currentFrame = animation.currentFrame >= #animation 
				and animation.currentFrame 
				or animation.currentFrame + 1
		end
	end
end

--[[
update the hitboxes that the "hitboxes" component points to
--]]
function updateHitboxes(e)
	if e.hitboxes then
		e.hitboxes = e.animation.list[e.animation.current]:hitboxes()
	end
end

--[[
reset an animation to its first frame
--]]
function resetAnimation(e)
	local animation = e.animation.list[e.animation.current]
	animation.timer:reset()
	animation.currentFrame = 1
end

--------------------------------------------------------------- ANIMATION STATE

--[[
update animation of players based on their state
--]]
function updatePlayerAnimation(e)
	local movingUp = e.vel.y < 0
	local previousAnimation = e.animation.current
	local ducking = e.playerState.ducking
	local readying = e.playerInput.queue.attackDown
	local jumping = e.playerState.jumping
	local walking = e.playerState.walking
	local attacking = e.playerState.attacking
	local subweaponing = e.playerState.subweaponing
	local idle = e.playerState.idle
	
	-- update animation type
	if jumping then e.animation.current = "jump"
	elseif ducking then e.animation.current = "duck"
	elseif readying and not ducking then e.animation.current = "ready"
	else e.animation.current = "idle" end

	if not jumping and readying then e.animation.current = "readyWalk"
	elseif walking and not jumping then e.animation.current = "walk" end
	if attacking then e.animation.current = e.attackState.type end
	if subweaponing then e.animation.current = "subweapon" end
	
	-- reset animation frame if animation type was updated
	if previousAnimation ~= e.animation.current then resetAnimation(e) end
end

--[[
update animation of players based on their state
--]]
function updateEnemyAnimation(e)
	local state = e.enemyState.state
	local previousAnimation = e.animation.current
	
	-- update animation type
	if     state == "idle"       then e.animation.current = "idle"
	elseif state == "attacking"  then e.animation.current = "attack"
	elseif state == "attack"     then e.animation.current = "attack"
	elseif e.vel.x == 0          then e.animation.current = "idle"
	elseif state == "passive"    then e.animation.current = "walk"
	elseif state == "aggressive" then e.animation.current = "walk" end
	
	-- reset animation frame if animation type was updated
	if previousAnimation ~= e.animation.current then resetAnimation(e) end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
return function(secs)
	local self = {}
	
	--
	self.secs = secs
	
	return setmetatable(self, { __index = AnimationSystem })
end