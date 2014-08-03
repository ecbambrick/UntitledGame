local Utility = { math = {}, table = {} }

--------------------------------------------------------------------------------
-- Returns true if the first paramet is located within the boundaries of the
-- second parameter.
-- @param a		The first parameter, which has x and y members.
-- @param b		The seond parameter, which has x, y, width, and height members.
--------------------------------------------------------------------------------
function Utility.math.within(a, b)
	return a.x <  b.x + b.width
	   and a.x >= b.x
	   and a.y >= b.y
	   and a.y <  b.y + b.height	
end

--------------------------------------------------------------------------------
-- Returns the value of the table element that satisfies the given expression.
-- The expression function must return true or false.
-- @param t				The table.
-- @param expression	The expression function to check against.
--------------------------------------------------------------------------------
function Utility.table.find(t, expression)
	for i,v in pairs(t) do
		if expression(t[i]) then
			return v
		end
	end
	
	return nil
end

return Utility