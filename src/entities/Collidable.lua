
Collidable = class('Collidable', MoveableEntity)

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

function Entity:AABBToOrigin(x, y)
	return x + (self.boundingBox.width / 2), y + (self.boundingBox.height / 2)
end

function Entity:scaleCoordsToAABB(x, y)
	return x - (self.boundingBox.width / 2), y - (self.boundingBox.height / 2)
end

function Entity:getCollisionInfo()
	return self.boundingBox.x1, self.boundingBox.y1, self.boundingBox.width, self.boundingBox.height
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
	if Game.drawOrigin then
		love.graphics.setColor(0, 255, 0)
		love.graphics.circle('fill', self.origin.x, self.origin.y, 20)
	end

	if Game.drawAABBs then
		love.graphics.setColor(0,0,0)
		love.graphics.setLineWidth(5)
		love.graphics.rectangle('line', self.boundingBox.x1, self.boundingBox.y1, self.boundingBox.width, self.boundingBox.height)
	end
end