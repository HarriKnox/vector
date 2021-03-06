local particle = {}
local particle_meta = {}
particle_meta.__index = particle_meta
local common = require('common')


particle.new = function(parc, parm, parp)
	if type(parc) == 'quantity' and type(parm) == 'quantity' and common.istype(parp, {'quantity', 'vector'}) then
		local units = require('units')
		if parc.units == units.coulomb and parm.units == units.kilogram and parp.units == units.meter then
			return setmetatable({charge = parc, mass = parm, position = parp}, particle_meta)
		end
		common.uniterror('creation', parc.units, parm.units, parp.units, 'particle')
	end
	common.typeerror('creation', parc, parm, parp, 'particle')
end

common.setcallmeta(particle)
common.registertype(particle_meta, 'particle')

particle.clone = function(part)
	if type(part) == 'particle' then
		local charge = part.charge
		local mass = part.mass
		local position = part.position
		return particle.new(charge, mass, position)
	end
	common.typeerror('cloning', part, 'particle')
end

particle.equals = function(first, second)
	if common.alloftype(first, second, {'particle'}) then
		local charge = first.charge == second.charge
		local mass = first.mass == second.mass
		local position = first.position == second.position
		return charge and mass and position
	end
	return false
end

particle.tostring = function(part, comp)
	return string.format("(%s) (%s) (%s)", part.mass:tostring(), part.charge:tostring(), part.position:tostring(comp))
end

particle.forcebetween = function(first, second)
	if type(first) == 'particle' and type(second) == 'particle' then
		local ke = require('constants').electrostatic
		local r = first.position - second.position
		if r == 0 or type(r) == 'vector' and #r == 0 then error("zero-length vector") end
		local direction
		if type(r) == 'vector' then
			direction = r:normalize()
			direction.units = require('units').empty
		else
			direction = r.value >= 0 and 1 or -1
		end
		return ke * first.charge * second.charge * direction / (r ^ 2)
	end
	common.typeerror('force-between', first, second, 'particle')
end

particle.electricfield = function(part, loc)
	if type(part) == 'particle' and common.istype(loc, {'vector', 'quantity'}) and loc.units == require('units').meter then
		if type(part.position) == 'vector' or type(loc) == type(part.position) then
			local ke = require('constants').electrostatic
			local r
			if type(loc) ~= type(part.position) then
				r = loc
			else
				r = loc - part.position
			end
			local direction
			if type(r) == 'vector' then
				direction = r:normalize()
				direction.units = require('units').empty
			else
				direction = r.value >= 0 and 1 or -1
			end
			return ke * part.charge * direction / (r ^ 2)
		end
		common.typeerror('distance', particle.position, loc, 'particle')
	end
	common.typeerror('electric-field', part, loc, 'particle')
end


common.getmethods(particle, particle_meta)

particle_meta.__eq = particle.equals
particle_meta.__tostring = particle.tostring

particle_meta.__add = common.notsupported('particles', 'addition')
particle_meta.__sub = common.notsupported('particles', 'subtraction')
particle_meta.__mul = common.notsupported('particles', 'multiplication')
particle_meta.__div = common.notsupported('particles', 'division')
particle_meta.__unm = common.notsupported('particles', 'unary-minus')
particle_meta.__idiv = common.notsupported('particles', 'int-divide')
particle_meta.__len = common.notsupported('particles', 'length')
particle_meta.__mod = common.notsupported('particles', 'modulo')
particle_meta.__pow = common.notsupported('particles', 'powers')
particle_meta.__concat = common.notsupported('particles', 'concatination')
particle_meta.__lt = common.notsupported('particles', 'less-than')
particle_meta.__le = common.notsupported('particles', 'less-than-or-equal-to')
particle_meta.__band = common.notsupported('particles', 'bitwise')
particle_meta.__bor = particle_meta.__band
particle_meta.__bxor = particle_meta.__band
particle_meta.__bnot = particle_meta.__band
particle_meta.__shl = particle_meta.__band
particle_meta.__shr = particle_meta.__band


return particle
