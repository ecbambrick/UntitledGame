--[[----------------------------------------------------------------------------
--]]----------------------------------------------------------------------------

local renderAnimation, renderHitboxes, renderHitbox, renderSprite, renderStage
local withinView

---------------------------------------------------------- MAIN UPDATE FUNCTION

--[[
asdasdsad
--]]
secs.rendersystem("render", 100, function()

	-- set camera
	local camera = secs.query("cameras")[1]
	love.graphics.push()
	love.graphics.scale(WINDOW_SCALE)
	if camera then
		love.graphics.translate(-camera.pos.x, -camera.pos.y)
	end
	
	-- draw each type of entity
	for i,e in ipairs(secs.query("stages"))   do renderStageBackground(e, camera) end
	for i,e in ipairs(secs.query("sprites"))  do renderSprite(e)          end
	for i,e in ipairs(secs.query("animated")) do renderAnimation(e)       end
	for i,e in ipairs(secs.query("stages"))   do renderStageForeground(e, camera) end
	
	-- unset camera
	love.graphics.pop()
	
end)

-------------------------------------------------------------- HELPER FUNCTIONS

--[[
draw a sprite
--]]
function renderStageBackground(e, camera)
	local map = e.stage.map
    if map then
		if camera then
			map:setDrawRange(camera.pos.x, camera.pos.y, WINDOW_WIDTH, WINDOW_HEIGHT)
		end
		map:_updateTileRange()
		for i,layer in ipairs(map.layerOrder) do
			if layer.name ~= "solid" and layer.name ~= "foreground" then
				layer:draw()
			end
		end
    end
end

--[[
draw a sprite
--]]
function renderStageForeground(e, camera)
	local map = e.stage.map
    if map then
		if camera then
			map:setDrawRange(camera.pos.x, camera.pos.y, WINDOW_WIDTH, WINDOW_HEIGHT)
		end
        map("foreground"):draw()
    end
end

--[[
draw a sprite
--]]
function renderSprite(e)

	-- get position
	local x, y, dx, dy = e.pos.x, e.pos.y, e.pos.dx, e.pos.dy
	local w, h = e.sprite.image:getWidth(), e.sprite.image:getHeight()
	local color = e.color and e.color.rgb or { 255, 255, 255, 255 }
	
	-- calculate offseted position if flipped
	if dx < 0 then x = x + w end
	if dy < 0 then y = y + h end
	
	
	-- draw if onscreen
	if withinView(x,y,w,h) then
		love.graphics.setColor(color)
		love.graphics.draw(e.sprite.image, x, y, 0, dx, dy)
		love.graphics.setColor(255,255,255,255)
	end
	
end

--[[
draw the current animation's current frame's sprite to the screen
--]]
function renderAnimation(e)
	
	-- get position and sprite data
	local animation = e.animation.list[e.animation.current]
	local sprite = animation:sprite()
	local x, y = e.pos.x + sprite.offsetX, e.pos.y + sprite.offsetY
	local dx, dy = e.pos.dx, e.pos.dy
	local color = e.color and e.color.rgb or { 255, 255, 255, 255 }
	
	-- calculate offseted position if flipped
	if dx < 0 then x = x - sprite.offsetX*2 + e.pos.width  end
	if dy < 0 then y = y - sprite.offsetY*2 + e.pos.height end
	
	-- draw if onscreen
	if withinView(x,y,0,0) then
		love.graphics.setColor(color)
		love.graphics.drawq(animation.image, sprite.quad, x, y, 0, dx, dy)
		love.graphics.setColor(255,255,255,255)
	end
	
end

--[[
asdasdasdasd
--]]
function withinView(x,y,w,h)
	return true
	-- local camera = secs.query("players")[1]
	-- local camX, camY = camera.pos.x, camera.pos.y
	-- if  x + w > camX - WINDOW_WIDTH/2 and x - w < camX + WINDOW_WIDTH/2 
	-- and y + h > camY - WINDOW_HEIGHT/2 and y - h < camY + WINDOW_HEIGHT/2 then
		-- return true
	-- else
		-- return false
	-- end
end
