--[[----------------------------------------------------------------------------
--]]----------------------------------------------------------------------------

local AdvancedTiledLoader = require("lib.AdvTiledLoader.loader")

local loadTiledMap, loadTiles, loadEntities, loadRoom, getRoom
local unloadTiledMap, unloadTiles, unloadEntities

---------------------------------------------------------- MAIN UPDATE FUNCTION

--[[
Load and unload tiled maps with AdvancedTiledLoader
--]]
secs.updatesystem("tiledmap", 50, function(dt)

	local e = secs.query("stages")[1]
	local player = secs.query("players")[1]
	
	-- check if room needs to be updated
	if e.stage.map then
		updateRoom(e.stage, player)
	end

	-- load/unload stage
	if e.stage.unload and e.stage.map then
		unloadTiledMap(e.stage)
	end
	if e.stage.loadStage and not e.stage.map then
		loadTiledMap(e.stage)
	end
	if e.stage.loadRoom and e.stage.map then
		unloadEntities(e.stage)
		loadRoom(e.stage)
	end
end)

---------------------------------------------------------- TILED MAP MANAGEMENT

function updateRoom(stage, player)
	local currentRoom, rooms = stage.room, stage.map("rooms").objects
	for i,room in ipairs(rooms) do
		if  player.pos.x + player.pos.width/2 < room.x + room.width 
		and player.pos.x + player.pos.width/2 > room.x
		and player.pos.y + player.pos.height < room.y + room.height 
		and player.pos.y + player.pos.height > room.y then
			stage.room = room.name
			if stage.room ~= currentRoom then
				stage.loadRoom = true
			end
		end
	end
end

-- load tiled map file and entities
function loadTiledMap(stage)
	-- load map
    stage.loadStage = false
	stage.loadRoom = true
    stage.map = AdvancedTiledLoader.load(stage.path)
    stage.map.drawObjects = false
end

function loadRoom(stage)

	-- get room
	local rooms, room = stage.map("rooms").objects, nil
	for i = 1, #rooms do
		if rooms[i].name == stage.room then
			room = rooms[i]
		end
	end
	
	-- set up camera
	local camera = secs.query("cameras")[1]
	if camera then
		camera.camera.x1 = room.x
		camera.camera.y1 = room.y
		camera.camera.x2 = room.x + room.width
		camera.camera.y2 = room.y + room.height
	end
	
	stage.loadRoom = false
	loadEntities(room, stage)
	
end

-- unload tiled map and destroy map entities
function unloadTiledMap(stage)
	stage.unload = false
	stage.map = nil
	unloadEntities(stage)
end

------------------------------------------------------------- ENTITY MANAGEMENT

-- create an entity for each entity-layer object in the map
function loadEntities(room, stage)
	for i,entity in ipairs(stage.map("entities").objects) do
		if entity.properties.room == room.name then
			if entity.type == "enemy" then
				local e = secs.entity.enemy(entity.x, entity.y+1)
				secs.attach(e, "roomEntity")
			end
		end
	end
end

-- destroy each entity created by the map
function unloadEntities(stage)
	for i,e in ipairs(secs.query("roomEntities")) do
		secs.delete(e)
	end
end
