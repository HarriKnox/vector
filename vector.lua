local vector = {}
local vector_meta = {}
vector_meta.__index = vector_meta
local common = require('common')


vector.new = function(parx, pary, parz, paru)
	if type(parx) == 'number' and type(parx) == 'number' and type(parx) == 'number' and common.istype(paru, {'unit', 'nil'}) then
		return setmetatable({x = parx, y = pary, z = parz, units = paru}, vector_meta)
	end
	common.typeerror('creation', parx, pary, parz, 'vector')
end

common.setcallmeta(vector)
common.registertype(vector_meta, 'vector')

vector.clone = function(vect)
	if type(vect) == 'vector' then
		local x = vect:getx()
		local y = vect:gety()
		local z = vect:getz()
		return vector.new(x, y, z)
	end
	common.typeerror('cloning', vect, 'vector')
end

vector.add = function(first, second)
	if type(first) == 'vector' and type(second) == 'vector' then
		local x = first:getx() + second:getx()
		local y = first:gety() + second:gety()
		local z = first:getz() + second:getz()
		return vector.new(x, y, z)
	end
	common.typeerror('addition', first, second, 'vector')
end

vector.subtract = function(first, second)
	if type(first) == 'vector' and type(second) == 'vector' then
		local x = first:getx() - second:getx()
		local y = first:gety() - second:gety()
		local z = first:getz() - second:getz()
		return vector.new(x, y, z)
	end
	common.typeerror('subtraction', first, second, 'vector')
end

vector.multiply = function(first, second)
	if type(first) == 'vector' and type(second) == 'number' then
		local x = first:getx() * second
		local y = first:gety() * second
		local z = first:getz() * second
		return vector.new(x, y, z)
	end
	if type(second) == 'vector' and type(first) == 'number' then
		local x = second:getx() * first
		local y = second:gety() * first
		local z = second:getz() * first
		return vector.new(x, y, z)
	end
	common.typeerror('multiplication', first, second, 'vector')
end

vector.divide = function(first, second)
	if type(first) == 'vector' and type(second) == 'number' then
		local x = first:getx() / second
		local y = first:gety() / second
		local z = first:getz() / second
		return vector.new(x, y, z)
	end
	common.typeerror('division', first, second, 'vector')
end

vector.intdivide = function(first, second)
	if type(first) == 'vector' and type(second) == 'number' then
		local vect = vector.divide(first, second)
		vect:setx(math.floor(vect:getx()))
		vect:sety(math.floor(vect:gety()))
		vect:setz(math.floor(vect:getz()))
		return vect
	end
	common.typeerror('division', first, second, 'vector')
end

vector.negate = function(vect)
	if type(vect) == 'vector' then
		local x = vect:getx()
		local y = vect:gety()
		local z = vect:getz()
		return vector.new(-x, -y, -z)
	end
	common.typeerror('negation', vect, 'vector')
end

vector.equals = function(first, second)
	if type(first) == 'vector' and type(second) == 'vector' then
		local x = first:getx() == second:getx()
		local y = first:gety() == second:gety()
		local z = first:getz() == second:getz()
		return x and y and z
	end
	common.typeerror('equation', first, second, 'vector')
end

vector.magnitude = function(vect)
	if type(vect) == 'vector' then
		local x = vect:getx() ^ 2
		local y = vect:gety() ^ 2
		local z = vect:getz() ^ 2
		return math.sqrt(x + y + z)
	end
	common.typeerror('magnitude', vect, 'vector')
end

vector.normalize = function(vect)
	if type(vect) == 'vector' then
		local mag = vector.magnitude(vect)
		local x = vect:getx() / mag
		local y = vect:gety() / mag
		local z = vect:getz() / mag
		return vector.new(x, y, z)
	end
	common.typeerror('normalize', vect, 'vector')
end

vector.dotproduct = function(first, second)
	if type(first) == 'vector' and type(second) == 'vector' then
		local x = first:getx() * second:getx()
		local y = first:gety() * second:gety()
		local z = first:getz() * second:getz()
		return x + y + z
	end
	common.typeerror('dot-product', first, second, 'vector')
end

vector.crossproduct = function(first, second)
	if type(first) == 'vector' and type(second) == 'vector' then
		local x = (first:gety() * second:getz()) - (first:getz() * second:gety())
		local y = (first:getz() * second:getx()) - (first:getx() * second:getz())
		local z = (first:gety() * second:getx()) - (first:getx() * second:gety())
		return vector.new(x, y, z)
	end
	common.typeerror('cross-product', first, second, 'vector')
end

vector.azimuth = function(vect)
	if type(vect) == 'vector' then
		local arctan
		if math.atan == math.atan2 or math.atan2 == nil then
			arctan = math.atan
		else
			arctan = math.atan2
		end
		return arctan(vect:gety(), vect:getx())
	end
	common.typeerror('azimuth', vect, 'vector')
end

vector.altitude = function(vect)
	if type(vect) == 'vector' then
		local arctan
		if math.atan == math.atan2 or math.atan2 == nil then
			arctan = math.atan
		else
			arctan = math.atan2
		end
		local x = vect:getx() ^ 2
		local y = vect:gety() ^ 2
		return arctan(vect:getz(), math.sqrt(x + y))
	end
	common.typeerror('altitude', vect, 'vector')
end


common.getmethods(vector, vector_meta)

vector_meta.__add = vector.add
vector_meta.__sub = vector.subtract
vector_meta.__mul = vector.multiply
vector_meta.__div = vector.divide
vector_meta.__unm = vector.negate
vector_meta.__idiv = vector.intdivide
vector_meta.__eq = vector.equals
vector_meta.__len = vector.magnitude

vector_meta.__mod = common.notsupported('vectors', 'modulo')
vector_meta.__pow = common.notsupported('vectors', 'powers')
vector_meta.__concat = common.notsupported('vectors', 'concatination')
vector_meta.__lt = common.notsupported('vectors', 'less-than')
vector_meta.__le = common.notsupported('vectors', 'less-than-or-equal-to')
vector_meta.__band = common.notsupported('vectors', 'bitwise')
vector_meta.__bor = vector_meta.__band
vector_meta.__bxor = vector_meta.__band
vector_meta.__bnot = vector_meta.__band
vector_meta.__shl = vector_meta.__band
vector_meta.__shr = vector_meta.__band

vector_meta.__tostring = function(this)
	return string.format("vector: (%g, %g, %g)", this:getx(), this:gety(), this:getz())
end

vector_meta.getx = function(this) return this.x end
vector_meta.gety = function(this) return this.y end
vector_meta.getz = function(this) return this.z end
vector_meta.getunits = function(this) return this.units end

vector_meta.setx = function(this, num) this.x = num end
vector_meta.sety = function(this, num) this.y = num end
vector_meta.setz = function(this, num) this.z = num end
vector_meta.setunits = function(this, unt) this.units = unt end

return vector