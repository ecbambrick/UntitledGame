local Timer = {}

--------------------------------------------------------------------------------
-- Returns the amount of time elapsed since the last time the timer was reset.
-- @return The amount of time elapsed.
--------------------------------------------------------------------------------
function Timer:elapsed()
    return self._count
end

--------------------------------------------------------------------------------
-- Resets the timer's elapsed time to the given amount, or 0 if no given amount.
-- @param count The amount of time to set the count to.
--------------------------------------------------------------------------------
function Timer:reset(count)
    self._count = count or 0
end

--------------------------------------------------------------------------------
-- Updates the timer's count.
-- @param dt    The amount of time passed since the last update.
-- @return      True if the threshold has been exceeded; otherwise, false.
--------------------------------------------------------------------------------
function Timer:update(dt)
    self._count = self._count + dt
    return self._count > self._threshold
end

--------------------------------------------------------------------------------
-- Constructs a new instance of the timer.
-- @return a new instance of the timer.
--------------------------------------------------------------------------------
return function(threshold)
    local self = {}
    
    -- The amount of time elapsed since the last reset.
    self._count = 0
    
    -- The amount of time the timer counts up to to activate.
    self._threshold = threshold
    
    return setmetatable(self, { __index = Timer })
end
