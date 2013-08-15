local newTimer = require "lib.timer"
local attachFrames

--[[
create an instance of a subset of frames from frame data
--]]
local function newAnimation(frameData, delay, loop, ...)
	local animation = {
		image = frameData.image,
		timer = newTimer(delay),
		delay = delay,
		loop = loop,
		currentFrame = 1,
		sprite = function(self) return self[self.currentFrame].sprite end,
		hitboxes = function(self) return self[self.currentFrame].hitboxes end,
	}
	attachFrames(animation, frameData, arg)
	return animation
end

--[[
generate a list of sprites and hitboxes from frame data for a frameSet
--]]
function attachFrames(animation, frameData, frames)
	for i,v in ipairs(frames) do
		local newHitboxes = {}
		local frame = frameData[v]
		local sprite = frame.sprite
		local hitboxes = frame.hitboxes
		for j,hitbox in ipairs(hitboxes) do
			local newHitbox = {}
			for k,value in pairs(hitbox) do
				newHitbox[k] = value
			end
			table.insert(newHitboxes, newHitbox)
		end
		table.insert(animation, { sprite = sprite, hitboxes = newHitboxes })
	end
end

--------------------------------------------------------------------------------

return newAnimation
