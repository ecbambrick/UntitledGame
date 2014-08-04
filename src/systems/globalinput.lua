local newTimer = require "lib.timer"
local GlobalInputSystem = {}
local keysDown, tableContains

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function GlobalInputSystem:update(dt)
	local queue = self.queue
	local cooldown = self.cooldown
	local debugger = self.debugger
	
	if #queue > 0 and cooldown:update(dt) then
		table.remove(queue, 1)
	end

	-- quit the game
	if self:keysDown("lalt", "f4") or self:keysDown("escape") then
		love.event.quit()
	end
	
	-- toggle debug mode
	if self:keysDown("0") then
		debugger.active = not debugger.active
	end
	
	-- toggle debug hitbox display
	if self:keysDown("1") then
		debugger.showHitboxes = not debugger.showHitboxes
	end
	
	-- toggle debug spatial map display
	if self:keysDown("2") then
		debugger.showSpatialmaps = not debugger.showSpatialmaps
	end
	
	-- toggle debug solid tile display
	if self:keysDown("3") then
		debugger.showSolidTiles = not debugger.showSolidTiles
	end
	
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function GlobalInputSystem:keysDown(...)
	local queue = self.queue
	local tempQueue = {}	
	for _, key in ipairs({...}) do
		if love.keyboard.isDown(key) and not tableContains(queue, key) then
			table.insert(tempQueue, key)
		else
			return false
		end
	end
	for i,v in ipairs(tempQueue) do
		table.insert(queue, v)
	end
	return true
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function tableContains(t, v)
	for i in pairs(t) do
		if t[i] == v then return true end
	end
	return false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
return function(secs, debugger)
	local self = {}
	
	-- 
	self.queue = {}
	
	-- 
	self.cooldown = newTimer(0.2)
	
	--
	self.debugger = debugger
	
	--
	self.secs = secs

	return setmetatable(self, { __index = GlobalInputSystem })
end