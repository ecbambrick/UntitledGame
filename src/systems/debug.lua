--[[----------------------------------------------------------------------------
--]]----------------------------------------------------------------------------

local renderHitboxes, withinView

---------------------------------------------------------- MAIN UPDATE FUNCTION

--[[
asdasdsad
--]]
secs.rendersystem("debug", 200, function()
	if DEBUG_MODE.active then
	
		-- set camera
		local camera = secs.query("cameras")[1]
		love.graphics.push()
		love.graphics.scale(WINDOW_SCALE)
		if camera then
			love.graphics.translate(-camera.pos.x, -camera.pos.y)
		end
		
		-- draw tile map solids (clean this one up)
		if DEBUG_MODE.showSolidTiles then
			for i,e in ipairs(secs.query("stages")) do
				local map = e.stage.map
				if map then
					local solids = map("solid")
					if solids then
						solids.visible = true
						solids:draw()
					end
				end
			end
		end
		
		-- draw hitboxes
		if DEBUG_MODE.showHitboxes then
			for i,e in ipairs(secs.query("collidable")) do
				renderHitboxes(e)
			end
		end
		
		-- draw spatial map
		if DEBUG_MODE.showSpatialmaps then
			for i,e in ipairs(secs.query("spatialMaps")) do
				e.spatialhash.map:draw()
			end
		end
		
		-- unset camera
		love.graphics.pop()
		
		-- draw framerate info and debug log
		local dt = DEBUG_MODE.dt
		local msg = DEBUG_MODE.message
		love.graphics.print("dt:   "..dt, 10, 10)
		love.graphics.print("fps:  "..math.floor(1/dt), 10, 25)
		love.graphics.print(msg, 10, 40)
	
	end
end)

--[[
draw each of the current animation's current frame's hitboxes to the screen
--]]
function renderHitboxes(e)
	local ex,ey,edx,edy = e.pos.x, e.pos.y, e.pos.dx, e.pos.dy
	for i,h in ipairs(e.hitboxes) do
	
		-- get position and hitbox type
		local offsetX, offsetY = h.offsetX*2, h.offsetY*2
		local width, height, htype = h.width, h.height, h.type
		local x, y = ex + h.offsetX, ey + h.offsetY
		
		-- calculate offseted position if flipped
		if edx < 0 then x = x - offsetX - width  + e.pos.width  end
		if edy < 0 then y = y - offsetY - height + e.pos.height end
		
		-- different color depending on hitbox type
		if htype == "active"  then love.graphics.setColor(0,255,0,100)   end
		if htype == "attack"  then love.graphics.setColor(255,0,0,100)   end
		if htype == "passive" then love.graphics.setColor(255,255,0,100) end
		
		love.graphics.rectangle("fill", x, y, width, height)
		love.graphics.setColor(255,255,255,255)
		
	end
end
