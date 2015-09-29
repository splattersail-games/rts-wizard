-- Wall
-- Modes: fill, line
local class = require 'src.libs.middleclass'
require 'src.utils.geometry'
require 'src.utils.BoundingBox'
require 'src.units.BaseUnit'
require 'src.units.Light'
Wall = class('Wall', Entity)

function Wall:initialize(x, y, width, height)
	BaseUnit.initialize(
		self, 
		x, 
		y, 
		BoundingBox:new(
			x - (width / 2), 
			y - (height / 2),
			x + (width / 2),
			y + (height / 2)
		)
	)
end

function Wall:canCastShadows()
	return true
end

function Wall:update(dt)
	Entity.update(self, dt)
end

function Wall:draw()
	BaseUnit.draw(self)
end