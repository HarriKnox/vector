local vector = {}
local vector_meta = {}

vector.isvector = function(vect)
	return getmetatable(vect) == vector_meta
end

vector.new = function(parx, pary, parz)
	local vect = {x = parx, y = pary, z = parz}
	setmetatable(vect, vector_meta)
	vector_meta.__index = vector_meta
	return vect
end

vector.add = function(first, second)
	if vector.isvector(first) and vector.isvector(second) then
		local x = first:getx() + second:getx()
		local y = first:gety() + second:gety()
		local z = first:getz() + second:getz()
		return vector.new(x, y, z)
	end
	error("incompatible types for vector addition: " .. type(first) .. " and " .. type(second), 2)
end

vector.subtract = function(first, second)
	if vector.isvector(first) and vector.isvector(second) then
		local x = first:getx() - second:getx()
		local y = first:gety() - second:gety()
		local z = first:getz() - second:getz()
		return vector.new(x, y, z)
	end
	error("incompatible types for vector subtraction: " .. type(first) .. " and " .. type(second), 2)
end

vector.multiply = function(first, second)
	if vector.isvector(first) and type(second) == "number" then
		local x = first:getx() * second
		local y = first:gety() * second
		local z = first:getz() * second
		return vector.new(x, y, z)
	end
	if vector.isvector(second) and type(first) == "number" then
		local x = second:getx() * first
		local y = second:gety() * first
		local z = second:getz() * first
		return vector.new(x, y, z)
	end
	error("incompatible types for vector multiplication: " .. type(first) .. " and " .. type(second), 2)
end

vector.divide = function(first, second)
	if vector.isvector(first) and type(second) == "number" then
		local x = first:getx() / second
		local y = first:gety() / second
		local z = first:getz() / second
		return vector.new(x, y, z)
	end
	error("incompatible types for vector division: " .. type(first) .. " and " .. type(second), 2)
end

return vector