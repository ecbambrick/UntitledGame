math.absmin = function(a,b)
    if math.abs(a) < math.abs(b) then return a
    else                               return b end
end

math.absmax = function(a,b)
    if math.abs(a) > math.abs(b) then return a
    else                               return b end
end

math.round = function(number, factor)
    if not factor then factor = 1 end
    return (math.floor((number + 0.5) / factor) * factor)
end

math.sign = function(val)
    if     val >  0 then return  1
    elseif val == 0 then return  0
    else                 return -1
    end
end

math.clamp = function(val, minimum, maximum)
    if not maximum then
        maximum = minimum
        minimum = -minimum
    end
    if     val < minimum then return minimum
    elseif val > maximum then return maximum
    else                      return val
    end
end

math.within = function(val, min, max)
    if val >= min and val <= max then return true
    else return false end
end

math.between = function(val, min, max)
    if val > min and val < max then return true
    else return false end
end

math.round = function(x)
    return math.floor(x + 0.5)
end
