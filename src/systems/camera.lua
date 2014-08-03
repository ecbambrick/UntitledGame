--[[----------------------------------------------------------------------------
--]]----------------------------------------------------------------------------

-- local ...

---------------------------------------------------------- MAIN UPDATE FUNCTION

--[[
asdasdsad
--]]
secs:UpdateSystem("camera", function(dt)
	for e in pairs(secs:query("camera")) do
		local target = e.camera.target
		if target then
			e.pos.x = target.x - e.camera.width/2
			e.pos.y = target.y - e.camera.height/2
		end
		if e.pos.x < e.camera.x1 then e.pos.x = e.camera.x1 end
		if e.pos.y < e.camera.y1 then e.pos.y = e.camera.y1 end
		if e.pos.x > e.camera.x2 - e.camera.width then e.pos.x = e.camera.x2 - e.camera.width end
		if e.pos.y > e.camera.y2 - e.camera.height then e.pos.y = e.camera.y2 - e.camera.height end
	end
end)
