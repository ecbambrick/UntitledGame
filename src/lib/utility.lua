local utility = { math = {}, table = {} }

--------------------------------------------------------------------------------
-- Returns true if the first object is located within the boundaries of the
-- second object.
-- @param a     The first object, which has x and y members.
-- @param b     The seond object, which has x, y, width, and height members.
-- @return      True if the first object intersects with the second object;
--              otherwise, false.
--------------------------------------------------------------------------------
function utility.math.within(a, b)
    return a.x <  b.x + b.width
       and a.x >= b.x
       and a.y >= b.y
       and a.y <  b.y + b.height    
end

--------------------------------------------------------------------------------
-- Returns the center point of the given object.
-- @param object    The object, which has x, y, width, and height members.
-- @return          The x and y coordinates of the center of the object.
--------------------------------------------------------------------------------
function utility.math.getCenter(object)
    return {
        x = object.x + object.width / 2,
        y = object.y + object.height / 2,
    }
end

--------------------------------------------------------------------------------
-- Returns true if the given value exists in the given table; otherwise, false.
-- @param t             The table.
-- @param value         The value to check for.
-- @return              True if the value exists in the table; otherwise, false.
--------------------------------------------------------------------------------
function utility.table.contains(t, value)
    for i, v in pairs(t) do
        if v == value then
            return true
        end
    end
    
    return false
end

--------------------------------------------------------------------------------
-- Returns the value of the table element that satisfies the given expression.
-- The expression function must return true or false.
-- @param t             The table.
-- @param expression    The expression function to check against.
-- @return              The first element that satifies the expression, or nil 
--                      if no element is found.
--------------------------------------------------------------------------------
function utility.table.find(t, expression)
    for i, v in pairs(t) do
        if expression(t[i]) then
            return v
        end
    end
    
    return nil
end

return utility