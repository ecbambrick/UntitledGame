--[[----------------------------------------------------------------------------

https://github.com/vrld/HardonCollider/blob/master/spatialhash.lua
http://www.gamedev.net/page/resources/_/technical/game-programming/spatial-hashing-r2697
http://conkerjo.wordpress.com/2009/06/13/spatial-hashing-implementation-for-fast-2d-collisions/

update for weak table junk

--]]----------------------------------------------------------------------------

local tablesize = function(t)
	local size = 0
	for i in pairs(t) do
		size = size + 1
	end
	return size
end

--------------------------------------------------------------------------------

return function(cellSize, callback)
	return {
	
		-- properties
		cellSize = cellSize or 100,
		getItem = callback or getItem,
		cells = {},

------------------------------------------------------------------------- INPUT

		--[[
		remove all items from the map
		--]]
		clear = function(self)
			self.cells = {}
		end,
		
		--[[
		return the range of cells that the given coordinates would overlap
		--]]
		getCellRange = function(self, x1, y1, x2, y2)
			return math.floor(x1 / self.cellSize),
				   math.floor(y1 / self.cellSize),
				   math.floor(x2 / self.cellSize),
				   math.floor(y2 / self.cellSize)
		end,
		
		--[[
		insert an item into a cell
		--]]
		insertIntoCell = function(self, x, y, object, data)
			local cells = self.cells
			if not cells[x] then
				cells[x] = {}
			end
			if not cells[x][y] then
				cells[x][y] = setmetatable({}, {__mode = "kv"})
			end
			self.cells[x][y][object] = data
		end,
		
		--[[
		get the coordinates and place the object in each cell that it overlaps
		--]]
		insert = function(self, object, data, x1, y1, x2, y2)
			cx1,cy1,cx2,cy2 = self:getCellRange(x1, y1, x2, y2)
			for x = cx1, cx2 do
				for y = cy1, cy2 do
					self:insertIntoCell(x, y, object, data)
				end
			end
		end,
		
		--[[
		remove all instances of an object from each cell
		--]]
		remove = function(self, object)
			local cells = self.cells
			for x in pairs(cells) do
				for y in pairs(cells[x]) do
					cells[x][y][object] = nil
				end
			end
		end,
		
		--[[
		update cells for a hitbox based on new coordinates
		--]]
		update = function(self, object, x1, y1, x2, y2, ox1, oy1, ox2, oy2)
			self:remove(object)
			self:insert(object, x1, y1, x2, y2)
		end,

		--[[
		returns all objects that overlap the same cells as the given coordinates
		--]]
		getNearby = function(self, x1, y1, x2, y2)
			local x1, y1, x2, y2 = self:getCellRange(x1, y1, x2, y2)
			local cells = self.cells
			local nearbyObjects = {}
			for x = x1, x2 do
				for y = y1, y2 do
					if cells[x] and cells[x][y] then
						for object, data in pairs(cells[x][y]) do
							nearbyObjects[object] = data
						end
					end
				end
			end
			return nearbyObjects
		end,
		
		--[[
		draw each cell as a rectangle with its size printed in the center
		--]]
		draw = function(self)
			local cells, size = self.cells, self.cellSize
			love.graphics.setColor(255,255,255,255)
			for i,row in pairs(cells) do
				for j,column in pairs(row) do
					local x, y = i*self.cellSize, j*size
					love.graphics.rectangle('line', x, y, size, size)
					love.graphics.print(tablesize(column), x + size/2-3, y + size/2-7)
				end
			end
			love.graphics.setColor(255,255,255,255)
		end
	}
end
