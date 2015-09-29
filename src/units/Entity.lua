local class = require 'src.libs.middleclass'

Entity = class('Entity')

function Entity:initialize(x, y, box)
	self.origin = vector(x, y) -- origin stored as vector
	self.boundingBox = box
end

function Entity:getX()
	return self.origin.x
end

function Entity:getY()
	return self.origin.y
end

function Entity:refreshBoundingBox(dt)
	local x = self:getX()
	local y = self:getY()
	self.boundingBox = BoundingBox:new(
		x - (self.boundingBox.width / 2), 
		y - (self.boundingBox.height / 2),
		x + (self.boundingBox.width / 2),
		y + (self.boundingBox.height / 2)
	)
end

function Entity:canCastShadows()
	return false
end

function Entity:getPoints()
	return self.boundingBox:vertices()
end

function Entity:update(dt)
	self:refreshBoundingBox(dt)
end

function Entity:draw()
end