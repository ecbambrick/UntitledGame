local advancedTiledLoader = require("lib.AdvTiledLoader.loader")
local utility = require("lib.utility")
local TiledMapSystem, deleteEntities, loadEntities, loadRooms, loadStage, roomAt

--------------------------------------------------------------------------------
-- mention how it only bothers with the first 
--------------------------------------------------------------------------------
function TiledMapSystem(ecs)
	ecs:UpdateSystem("tiledmap", function(dt)
		local camera = ecs:queryFirst("camera").camera
		local stage = ecs:queryFirst("stage").stage
		local playerPosition = ecs:queryFirst("playerInput playerState").pos
		
		if not stage.map then
			loadStage(stage)
		end
		
		local currentRoom = roomAt(stage, playerPosition)
		
		if stage.room ~= currentRoom then
			stage.room = currentRoom
			deleteEntities(ecs, stage)
			loadRoom(ecs, stage)
		end
	end)
end

--------------------------------------------------------------------------------
-- Load all entities in the given room of the given stage.
-- @param roomName	The name of the room.
-- @param stage		The stage.
--------------------------------------------------------------------------------
function loadEntities(ecs, room, stage)
	for _, object in ipairs(stage.map("entities").objects) do
		if utility.math.within(object, room) then
			local entityType = object.properties.value
			local e
		
			-- Load enemy entity.
			if object.type == "enemy" then
				e = factory[entityType](object.x, object.y+1)
			end
			
			-- Load item entity.
			if object.type == "item" then
				e = Item(object.x, object.y+1, entityType)
			end
			
			ecs:attach(e, { roomEntity = {} })
		end
	end
end

--------------------------------------------------------------------------------
-- asdasd
--------------------------------------------------------------------------------
function loadRoom(ecs, stage)
	local rooms = stage.map("rooms").objects
	local camera = ecs:queryFirst("camera pos").camera
	local room = utility.table.find(rooms, function(a)
		return a.name == stage.room 
	end)

	-- Update the camera position.
	camera.x1 = room.x
	camera.y1 = room.y
	camera.x2 = room.x + room.width
	camera.y2 = room.y + room.height

	loadEntities(ecs, room, stage)
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
			return room.name
		end
	end
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

return TiledMapSystem