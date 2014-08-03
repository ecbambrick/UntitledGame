--[[----------------------------------------------------------------------------
--]]----------------------------------------------------------------------------

local renderHitboxes, withinView

---------------------------------------------------------- MAIN UPDATE FUNCTION

--[[
asdasdsad
--]]
secs:RenderSystem("debug", function()
	if not debugger.active then return end

	-- set camera
	local camera = secs:queryFirst("camera")
	love.graphics.push()
	love.graphics.scale(DEFAULT_WINDOW_SCALE, DEFAULT_WINDOW_SCALE)
	if camera then
		love.graphics.translate(-camera.pos.x, -camera.pos.y)
	end
	
	-- draw tile map solids (clean this one up)
	if debugger.showSolidTiles then
		for e in pairs(secs:query("stage")) do
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
	if debugger.showHitboxes then
		for e in pairs(secs:query("hitboxes pos")) do
			renderHitboxes(e)
		end
	end
	
	-- draw spatial map
	if debugger.showSpatialmaps then
		for e in pairs(secs:query("spatialhash")) do
			e.spatialhash.map:draw()
		end
	end
	
	-- unset camera
	love.graphics.pop()
	
	-- draw framerate info and debug log
	local dt = debugger.dt
	local numEntities = 0
	
	for e in pairs(secs:query()) do
		numEntities = numEntities + 1
	end
	
	-- love.graphics.print("dt:   "..dt, 10, 10)
	-- love.graphics.print("fps:  "..math.floor(1/dt), 10, 25)
	-- love.graphics.print("#e:   "..numEntities, 10, 40)
	-- for i,e in ipairs(debugger.messages) do
		-- love.graphics.print(message, 10, 40 + i*15)
	-- end
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
