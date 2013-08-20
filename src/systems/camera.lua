--[[----------------------------------------------------------------------------
--]]----------------------------------------------------------------------------

-- local ...

---------------------------------------------------------- MAIN UPDATE FUNCTION

--[[
asdasdsad
--]]
secs.updatesystem("camera", 500, function(dt)
	for i,e in ipairs(secs.query("cameras")) do
		local target = e.camera.target
		if target then
			e.pos.x = target.x - WINDOW_WIDTH/2
			e.pos.y = target.y - WINDOW_HEIGHT/2
		end
		if e.pos.x < e.camera.x1 then e.pos.x = e.camera.x1 end
		if e.pos.y < e.camera.y1 then e.pos.y = e.camera.y1 end
		if e.pos.x > e.camera.x2 - WINDOW_WIDTH then e.pos.x = e.camera.x2 - WINDOW_WIDTH end
		if e.pos.y > e.camera.y2 - WINDOW_HEIGHT then e.pos.y = e.camera.y2 - WINDOW_HEIGHT end
	end
end)
