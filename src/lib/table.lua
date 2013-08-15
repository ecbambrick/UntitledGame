table.contains = function(t, v)
	for i in pairs(t)
		if t[i] == v then return true end
	end
	return false
end