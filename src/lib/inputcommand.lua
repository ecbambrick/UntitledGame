local Timer         = require('lib.timer')
local InputCommand  = {}

--------------------------------------------------------------------------------
-- Returns whether or not all of the inputs for the command are held down.
-- @param inputs    The list of inputs to check against.
-- @return          True if all inputs are active this frame; otherwise, false.
--------------------------------------------------------------------------------
local function allKeysDown(inputs)
    for _, key in ipairs(inputs) do
        if not love.keyboard.isDown(key) then
            return false
        end
    end
    
    return true
end

--------------------------------------------------------------------------------
-- Returns whether or not the command has been activated twice in a row.
-- @return True if the command was double-pressed; otherwise, false.
--------------------------------------------------------------------------------
function InputCommand:doublePressed()
    return self._doublePressed
end
--------------------------------------------------------------------------------
-- Returns whether or not the command is currently active.
-- @return True if the command is currently active; otherwise, false.
--------------------------------------------------------------------------------
function InputCommand:isDown() 
    return self._downThisFrame
end

--------------------------------------------------------------------------------
-- Returns whether or not the command just became active.
-- @return True if the command activated this frame; otherwise, false.
--------------------------------------------------------------------------------
function InputCommand:pressed()
    return not self._downLastFrame and self._downThisFrame
end

--------------------------------------------------------------------------------
-- Returns whether or not the command just became inactive.
-- @return True if the command stopped this frame; otherwise, false.
--------------------------------------------------------------------------------
function InputCommand:released()
    return self._downLastFrame and not self._downThisFrame
end

--------------------------------------------------------------------------------
-- Cancels the current check for whether the command was double-pressed.
--------------------------------------------------------------------------------
function InputCommand:cancelDoublePress()
    -- Since double-press events can only occur if the elapsed time is less
    -- than _timeLimit, setting the timer to _timeLimit will cancel checks for 
    -- double-press events.
    self._timer:reset(self._timeLimit)
end

--------------------------------------------------------------------------------
-- Check for user input and changes the input state of the command.
--------------------------------------------------------------------------------
function InputCommand:update(dt)

    -- Reset key-down state.
    self._downLastFrame = self._downThisFrame
    self._downThisFrame = false
    self._doublePressed = false
    
    -- Check if the inputs are active.
    if allKeysDown(self._inputs) then
        self._downThisFrame = true
    end
    
    -- Check for a double-press event.
    if self:pressed() then
        if self._timer:elapsed() < self._timeLimit then
            self._doublePressed = true
        end
        self._timer:reset()
    end
    
    -- Update the timer.
    self._timer:update(dt)
end

--------------------------------------------------------------------------------
-- Constructs a new instance of the input command.
-- @return a new instance of the input command.
--------------------------------------------------------------------------------
return function(...)
    local self = {}
    
    -- Whether or not the input(s) have been double pressed.
    self._doublePressed = false
    
    -- Whether or not the input(s) are active this frame.
    self._downThisFrame = false
    
    -- Whether or not the input(s) were active last frame.
    self._downLastFrame = false
    
    -- The list of keyboard inputs to check against.
    self._inputs = { ... }
    
    -- The timespan for two successive inputs to count as a double-press.
    self._timeLimit = 0.2
    
    -- The timer for checking for double-press inputs.
    self._timer = Timer(self._timeLimit)
    self._timer:reset(self._timeLimit)
    
    return setmetatable(self, { __index = InputCommand })
end