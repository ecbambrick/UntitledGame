--[[----------------------------------------------------------------------------
--]]----------------------------------------------------------------------------

local newTimer = require "lib.timer"
local queue, cooldown = {}, newTimer(0.2)

local keysDown, tableContains

----------------------------------------------------------------- MAIN FUNCTION

--[[
Check for system-level input commands such as quitting the game
--]]
secs:UpdateSystem("systeminput", function(dt)
	
	if #queue > 0 and cooldown:update(dt) then
		table.remove(queue, 1)
	end

	-- quit the game
	if keysDown("lalt", "f4") or keysDown("escape") then
		love.event.quit()
	end
	
	-- toggle debug mode
	if keysDown("0") then
		debugger.active = not debugger.active
	end
	
	-- toggle debug hitbox display
	if keysDown("1") then
		debugger.showHitboxes = not debugger.showHitboxes
	end
	
	-- toggle debug spatial map display
	if keysDown("2") then
		debugger.showSpatialmaps = not debugger.showSpatialmaps
	end
	
	-- toggle debug solid tile display
	if keysDown("3") then
		debugger.showSolidTiles = not debugger.showSolidTiles
	end
	
end)

-------------------------------------------------------------- HELPER FUNCTIONS

function keysDown(...)
	local tempQueue = {}	
	for i,key in ipairs({...}) do
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

function tableContains(t, v)
	for i in pairs(t) do
		if t[i] == v then return true end
	end
	return false
end