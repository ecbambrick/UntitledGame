local advancedTiledLoader   = require("lib.AdvTiledLoader.loader")
local utility               = require("lib.utility")
local TiledMapSystem        = {}

--------------------------------------------------------------------------------
-- The tiled map system manages the following: 
--  * Loading tiled maps.
--  * Determining the active map room.
--  * Loading and unloading entities for the current room.
--------------------------------------------------------------------------------
function TiledMapSystem:update(dt)
    local ecs       = self.ecs
    local factory   = self.factory
    local stages    = ecs:query("stage")
    local player    = ecs:queryFirst("playerInput pos")
    local camera    = ecs:queryFirst("camera pos")

    for stage in pairs(stages) do
        local stage = stage.stage
        local currentRoom

        if not stage.map then
            self.loadStage(stage)
        end
        
        currentRoom = self.roomAt(stage, player.pos)
        
        if currentRoom and stage.room ~= currentRoom then
            stage.room = currentRoom
            self:deleteRoomEntities()
            self:loadRoomEntities(currentRoom, stage)
            
            self.setCameraBounds(currentRoom, camera.camera)
        end
    end
end

--------------------------------------------------------------------------------
-- Delete all entities that belong to the current room.
--------------------------------------------------------------------------------
function TiledMapSystem:deleteRoomEntities()
    local ecs = self.ecs

    for entity in pairs(ecs:query("roomEntity")) do
        ecs:delete(entity)
    end
end

--------------------------------------------------------------------------------
-- Load all entities in the given room of the given stage.
-- @param roomName  The name of the room.
-- @param stage     The stage.
--------------------------------------------------------------------------------
function TiledMapSystem:loadRoomEntities(room, stage)
    local ecs = self.ecs
    local factory = self.factory

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
-- Loads the given stage through the Advanced Tiled Loader library.
-- @param stage The stage.
--------------------------------------------------------------------------------
function TiledMapSystem.loadStage(stage)
    stage.map = advancedTiledLoader.load(stage.path)
    stage.map.drawObjects = false
end

--------------------------------------------------------------------------------
-- Returns the room at the given position for the given stage.
-- @param stage     The stage.
-- @param position  The position in the stage.
-- @return          The name of the room or nil if no room is found.
--------------------------------------------------------------------------------
function TiledMapSystem.roomAt(stage, position)
    local point = utility.math.getCenter(position)
    local rooms = stage.map("rooms").objects
	
    for _, room in ipairs(rooms) do
        if utility.math.within(point, room) then
            return room
        end
    end
    
    return nil
end

--------------------------------------------------------------------------------
-- Updates the camera bounds to the size and position of the room.
-- @param room      The room.
-- @param camera    The camera.
--------------------------------------------------------------------------------
function TiledMapSystem.setCameraBounds(room, camera)
    camera.x1 = room.x
    camera.y1 = room.y
    camera.x2 = room.x + room.width
    camera.y2 = room.y + room.height
end

--------------------------------------------------------------------------------
-- Constructs a new instance of the tiled map system.
-- @return A new instance of the tiled map system.
--------------------------------------------------------------------------------
return function(ecs, factory)
    local self = {}
    
    -- Entity component system.
    self.ecs = ecs
    
    -- Entity factory methods.
    self.factory = factory
    
    return setmetatable(self, { __index = TiledMapSystem })
end