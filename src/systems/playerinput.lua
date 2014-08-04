local PlayerInputSystem = {}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function PlayerInputSystem:update(dt)
	local secs = self.secs
	local isDown = love.keyboard.isDown

	for e in pairs(secs:query("playerInput playerState")) do
	
		-- shorthand
		local queue = e.playerInput.queue
		local commands = e.playerInput.commands
		
		-- save certain inputs from last frame
		local attackHold = queue.attackDown
		local alreadyAttacked = queue.attack or queue.attackDown
		local jumpedLastFrame = queue.jump or queue.holdingJump
		
		-- clear previous input
		for i in pairs(queue) do queue[i] = nil end
		
		-- moving
		if isDown(commands.right) then queue.right = true end
		if isDown(commands.left)  then queue.left  = true end
		if isDown(commands.duck)  then queue.duck  = true end
		
		-- dashing
		if isDown(commands.dashLeft)      then queue.dashLeft  = true
		elseif isDown(commands.dashRight) then queue.dashRight = true end
		
		-- jumping
		if isDown(commands.jump) then
			if isDown(commands.duck) then queue.drop = true end
			if not jumpedLastFrame then queue.jump = true
			else queue.holdingJump = true end
		elseif jumpedLastFrame then
			queue.jumpRelease = true
		end
		
		-- attacking
		if isDown(commands.attack) then
			if isDown(commands.up) then
				queue.subweapon = true
			elseif not attackHold then
				queue.attack = true
			end
			queue.attackDown = true
		elseif attackHold then
			queue.attackDown = false
			queue.attack = true
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
return function(secs)
	local self = {}
	
	--
	self.secs = secs
	
	return setmetatable(self, { __index = PlayerInputSystem })
end