--[[----------------------------------------------------------------------------
--]]----------------------------------------------------------------------------

local AdvancedTiledLoader = require("lib.AdvTiledLoader.loader")

local loadTiledMap, loadTiles, loadEntities
local unloadTiledMap, unloadTiles, unloadEntities

---------------------------------------------------------- MAIN UPDATE FUNCTION

--[[
Load and unload tiled maps with AdvancedTiledLoader
--]]
secs.updatesystem("tiledmap", 50, function(dt)
	for i,e in ipairs(secs.query("stages")) do
		if e.stage.unload and e.stage.map then unloadTiledMap(e.stage) end
		if e.stage.loadStage and not e.stage.map then loadTiledMap(e.stage) end
	end
end)

---------------------------------------------------------- TILED MAP MANAGEMENT

-- load tiled map file and entities
function loadTiledMap(stage)

	-- load map
    stage.loadStage = false
    stage.map = AdvancedTiledLoader.load(stage.path)
    stage.map.drawObjects = false
	
	-- set up camera
	local camera = secs.query("cameras")[1]
	if camera then
		camera.camera.x2 = stage.map.width * stage.map.tileWidth
		camera.camera.y2 = stage.map.height * stage.map.tileHeight
	end
	
	-- load entities
    loadEntities(stage)
end

-- unload tiled map and destroy map entities
function unloadTiledMap(stage)
	stage.unload = false
	stage.map = nil
	unloadEntities(stage)
end

------------------------------------------------------------- ENTITY MANAGEMENT

-- create an entity for each entity-layer object in the map
function loadEntities(stage)
end

-- destroy each entity created by the map
function unloadEntities(stage)
end
