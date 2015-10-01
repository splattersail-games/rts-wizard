local class = require 'src.libs.middleclass'
Light = class('Light', MoveableEntity)

function Light:initialize(x, y, light, bbSize)
	MoveableEntity.initialize(
		self, 
		x, 
		y, 
		BoundingBox:new(
			x - (bbSize / 2), 
			y - (bbSize / 2),
			x + (bbSize / 2),
			y + (bbSize / 2)
		)
	)
	self.light = light
end

function Light:setIntensity(val)
	if val > 1.0 then 
		val = 1.0
	end
	if val < 0.0 then
		val = 0.0
	end
	self.light:setGlowStrength(val)
end

function Light:setDrawShadows(val)
	self.drawShadows = val
end

-- does this object obstruct light? for fuck's sake, no
function Light:canCastShadows()
	return false
end

function Light:update(dt)
	MoveableEntity.update(self, dt)
end

function Light:draw()
	-- Do nothing
	MoveableEntity.draw(self)
end