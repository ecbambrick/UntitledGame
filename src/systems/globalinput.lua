local utility           = require "lib.utility"
local Timer             = require "lib.timer"
local GlobalInputSystem = {}

--------------------------------------------------------------------------------
-- The global input system manages top-level input commands such as exiting the
-- game or interacting with the debugger.
--------------------------------------------------------------------------------
function GlobalInputSystem:update(dt)
    local queue = self.queue
    local cooldown = self.cooldown
    local debugger = self.debugger
    
    -- Clear the input queue.
    if queue.active and cooldown:update(dt) then
        utility.table.clear(queue)
    end
    
    -- Toggle debug mode.
    if self:keysDown("0") then
        debugger.active = not debugger.active
    end
    
    if debugger.active then
    
        -- Toggle the debug hitbox display.
        if self:keysDown("1") then
            debugger.showHitboxes = not debugger.showHitboxes
        end
        
        -- Toggle the debug spatial map display.
        if self:keysDown("2") then
            debugger.showSpatialmaps = not debugger.showSpatialmaps
        end
        
        -- Toggle the debug solid tile display.
        if self:keysDown("3") then
            debugger.showSolidTiles = not debugger.showSolidTiles
        end
        
    end
    
    -- Quit the game.
    if (love.keyboard.isDown("lalt") and love.keyboard.isDown("f4"))
    or love.keyboard.isDown("escape")
    then
        love.event.quit()
    end
    
    -- Slow down or speed up the game while tab is held down for debugging.
    if love.keyboard.isDown("tab") then
        if love.keyboard.isDown("lshift") then
            dt = dt / 5
        else
            dt = dt * 5
        end
    end
    
end

--------------------------------------------------------------------------------
-- Checks if the given list of keys are all down and not already in the queue.
--------------------------------------------------------------------------------
function GlobalInputSystem:keysDown(...)
    local queue = self.queue
    local tempQueue = {}    
    
    -- If the key is down and not already in the queue, add it to the queue and
    -- set the queue to active. The cooldown timer will only update when the
    -- queue is active.
    for _, key in ipairs({...}) do
        if love.keyboard.isDown(key) and not queue[key] then
            tempQueue[key] = true
            tempQueue.active = true
        else
            return false
        end
    end
    
    utility.table.copy(tempQueue, queue)
    
    return true
end

--------------------------------------------------------------------------------
-- Constructs a new instance of the global input system.
-- @return A new instance of the global input system.
--------------------------------------------------------------------------------
return function(secs, debugger)
    local self = {}
    
    -- The list of queued key-presses. This is used to keep track of which keys
	-- have been pressed recently to prevent the same key from firing too
	-- rapidly.
    self.queue = {}
    
    -- The cooldown between keystrokes. When the timer runs out, the queue is
	-- emptied.
    self.cooldown = Timer(0.2)
    
    -- The debugger.
    self.debugger = debugger
    
    -- The entity component system.
    self.secs = secs

    return setmetatable(self, { __index = GlobalInputSystem })
end