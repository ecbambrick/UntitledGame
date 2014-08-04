local advancedTiledLoader = require("lib.AdvTiledLoader.loader")
local utility = require("lib.utility")
local TiledMapSystem, deleteEntities, loadEntities, loadRooms, loadStage, roomAt

--------------------------------------------------------------------------------
-- The tiled map system manages the following: 
--  * Loading tiled maps.
--  * Determining the active map room.
--  * Loading entities for the current room.
--------------------------------------------------------------------------------
function TiledMapSystem(ecs)
	ecs:UpdateSystem("tiledmap", function(dt)
		for stage in pairs(ecs:query("stage")) do
			local stage = stage.stage
			local currentRoom

			if not stage.map then
				loadStage(stage)
			end
			
			for player in pairs(ecs:query("playerInput pos")) do
				currentRoom = roomAt(stage, player.pos)
			end
			
			if stage.room ~= currentRoom then
				loadRoom(ecs, e, currentRoom, stage)
				
				for camera in pairs(ecs:query("camera pos")) do
					updateCameraBounds(currentRoom, camera.camera)
				end
			end
		end
	end)
end

--------------------------------------------------------------------------------
-- Delete all entities that belong to the current room.
-- @param ecs		The entity component system.
--------------------------------------------------------------------------------
function deleteEntities(ecs)
	for entity in pairs(ecs:query("roomEntity")) do
		ecs:delete(entity)
	end
end

--------------------------------------------------------------------------------
-- Load all entities in the given room of the given stage.
-- @param roomName	The name of the room.
-- @param stage		The stage.
--------------------------------------------------------------------------------
function loadEntities(ecs, e, room, stage)
	for _, object in ipairs(stage.map("entities").objects) do
		if utility.math.within(object, room) then
			local entityType = object.properties.value
			local entity
		
			-- Load enemy entity.
			if object.type == "enemy" then
				entity = factory[entityType](factory, object.x, object.y+1)
			end
			
			-- Load item entity.
			if object.type == "item" then
				entity = factory:Item(object.x, object.y+1, entityType)
			end
			
			ecs:attach(entity, { roomEntity = {} })
		end
	end
end

--------------------------------------------------------------------------------
-- Delets all existing room entities and loads the entities for the given room.
-- @param ecs		The entity component system.
-- @param room		
-- @param stage		
--------------------------------------------------------------------------------
function loadRoom(ecs, e, room, stage)
	stage.room = room
	deleteEntities(ecs, stage)
	loadEntities(ecs, e, room, stage)
end

--------------------------------------------------------------------------------
-- Loads the given stage through the Advanced Tiled Loader library.
-- @param stage		The stage.
--------------------------------------------------------------------------------
function loadStage(stage)
    stage.map = advancedTiledLoader.load(stage.path)
    stage.map.drawObjects = false
end

--------------------------------------------------------------------------------
-- Returns the room at the given position for the given stage.
-- @param stage				The stage.
-- @param position			The position in the stage.
-- @return					The name of the room or nil if no room is found.
--------------------------------------------------------------------------------
function roomAt(stage, position)
	local rooms = stage.map("rooms").objects
	for _, room in ipairs(rooms) do
		if utility.math.within(position, room) then
			return room
		end
	end
end

--------------------------------------------------------------------------------
-- Updates the camera bounds to the size and position of the room.
-- @param room		The room.
-- @param camera	The camera.
--------------------------------------------------------------------------------
function updateCameraBounds(room, camera)
	camera.x1 = room.x
	camera.y1 = room.y
	camera.x2 = room.x + room.width
	camera.y2 = room.y + room.height
end

--------------------------------------------------------------------------------
return TiledMapSystem