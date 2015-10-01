local class = require 'src.libs.middleclass'
CameraLocation = class('CameraLocation', MoveableEntity)

function CameraLocation:initialize(x, y, name)
	MoveableEntity.initialize(
		self,
		x,
		y,
		BoundingBox:new(
			x - 16,
			y - 16,
			x + 16,
			y + 16
		)
	)
	self.name = name
end

function CameraLocation:getLookAt()
	return self:getX(), self:getY()
end