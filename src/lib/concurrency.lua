--------------------------------------------------------------------------------
-- The Concurrency class contains functions to put to sleep and wake up
-- coroutines and maintains a list of currently sleeping coroutines.
--------------------------------------------------------------------------------

-- Static, module functions.
local Concurrency = {}

-- Non-static, instance functions.
local functions = {}

--------------------------------------------------------------------------------
-- Runs the given function with the given arguments as a coroutine.
-- @param func		The function to run as a coroutine.
-- @param ... 		The parameters to pass to the function.
-- @return			The state and result of the coroutine.
--------------------------------------------------------------------------------
function Concurrency.runFunction(func, ...)
	local co = coroutine.create(func)
	local state, result = coroutine.resume(co, ...)
	
	assert(state, tostring(result))
	
	return state, result
end

--------------------------------------------------------------------------------
-- Construct a new instance of the Concurrency class.
--------------------------------------------------------------------------------
function Concurrency.new()
	local self = {}
	
	-- The amount of time that has passed since the object was initialized.
	self._elapsedTime = 0
	
	-- The table of sleeping threads.
	self._sleepingThreads = {}
	
	return setmetatable(self, { 
		__index = functions,
		__newindex = function(t, k, v)
			error("The key, \"" .. k .. "\", does not exist in the table.")
		end,
	})
end

--------------------------------------------------------------------------------
-- Sleep for the given number of seconds and then set the given key of the 
-- given table to the given value.
-- @param t 		The table to modify.
-- @param k 		the key of the table to set.
-- @param v 		The value to set the key to.
-- @param seconds 	The number of seconds to wait before setting the value.
--------------------------------------------------------------------------------
function functions:_sleepSet(t, k, v, seconds)
	self:sleep(seconds)
	t[k] = v
end

--------------------------------------------------------------------------------
-- Wake up any sleeping coroutines that are finished sleeping. This function
-- should be called once per game loop iteration.
-- @param dt 		The delta time of the game loop.
--------------------------------------------------------------------------------
function functions:update(dt)
	assert(dt > 0, "The value of dt must be greater than zero.")
	
	self._elapsedTime = self._elapsedTime + dt
	for co, waitedTime in pairs(self._sleepingThreads) do
		if waitedTime < self._elapsedTime then
			self._sleepingThreads[co] = nil
			coroutine.resume(co)
		end
	end
end

--------------------------------------------------------------------------------
-- Sets the the given key of the given table to the given value after the given
-- number of seconds pass.
-- @param t			The table to modify.
-- @param k			the key of the table to set.
-- @param v 		The value to set the key to.
-- @param seconds 	The number of seconds to wait before setting the value.
--------------------------------------------------------------------------------
function functions:setValue(t, key, value, seconds)    
	Concurrency.runFunction(self._sleepSet, self, t, key, value, seconds)
end

--------------------------------------------------------------------------------
-- Yield the current coroutine until the given number of seconds pass.
-- @param seconds 	The number of seconds to wait before waking the coroutine.
--------------------------------------------------------------------------------
function functions:sleep(seconds)
	local co = coroutine.running()

	assert(seconds > 0, "The value of seconds must be greater than zero.") 
	assert(co ~= nil, "The current thread is not a coroutine.")
	
	self._sleepingThreads[co] = self._elapsedTime + seconds
	coroutine.yield()
end

--------------------------------------------------------------------------------
-- Return.
--------------------------------------------------------------------------------
return setmetatable(Concurrency, { __call = Concurrency.new })
