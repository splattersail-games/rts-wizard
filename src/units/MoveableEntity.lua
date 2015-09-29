local class = require 'src.libs.middleclass'
vector = require 'src.utils.vector'
require 'src.units.Entity'

MoveableEntity = class('MoveableEntity', Entity)

function MoveableEntity:initialize(x, y, box)
	Entity.initialize(self, x, y, box)
	self.targetVelocity = vector(0, 0) -- target velocity with x and y components

	-- Config type fields, acceleration and inertia
	self.acceleration = 0.25
	self.inertia = vector(1.0, 1.0)

	self.velocity = vector(0, 0)	   -- velocity of object
	self.newVelocity = vector(0, 0)    -- new velocity calculated

	-- These components are used to figure out where to go and how fast
	self.targetSpeed = 60 -- The ultimate speed we want
	self.actualSpeed = 0 -- How fast we're actually going
	self.moveDirection = vector(0.0, 0.0) -- The direction we want to go
end

function MoveableEntity:setTargetSpeed(s)
	self.targetSpeed = s
end

function MoveableEntity:setMoveDirection(d)
	self.moveDirection = d
end

function MoveableEntity:canCastShadows()
	return true
end

function MoveableEntity:update(dt)

	-- blackhole code
	-- local dv = vector(2048, 2048) - self.origin
	-- dv:normalize_inplace()
	-- local distance = self.origin:dist(vector(2048, 2048))
	-- if distance < 500 then 
	-- 	self.moveDirection = dv--vector(0.5,0.5) -- The direction we want to go
	-- 	self.targetSpeed = (3.0 + (distance / 500.0) * -3.0)
	-- 	self:calculateMotion(dt)
	-- 	self:move(dt)
	-- end
	self:calculateMotion(dt)
	self:move(dt)
	Entity.update(self, dt)
end

function MoveableEntity:calculateMotion(dt)
	self.targetVelocity = self.targetSpeed * self.moveDirection

	if self.actualSpeed < self.targetSpeed then
		self.actualSpeed = (self.actualSpeed + self.acceleration)
	else 
		if self.actualSpeed > self.targetSpeed then
			self.actualSpeed = (self.actualSpeed - self.acceleration)
		end
	end

	self.newVelocity = self.actualSpeed * self.moveDirection
		
	-- INERTIA
	if self.velocity.x < self.newVelocity.x then
		self.velocity.x = self.velocity.x + self.inertia.x
		if self.velocity.x > self.targetVelocity.x then
			self.velocity.x = self.targetVelocity.x
		end
	end

	if self.velocity.x > self.newVelocity.x then
		self.velocity.x = self.velocity.x - self.inertia.x
		if self.velocity.x < self.targetVelocity.x then
			self.velocity.x = self.targetVelocity.x
		end
	end

	if self.velocity.y < self.newVelocity.y then
		self.velocity.y = self.velocity.y + self.inertia.y
		if self.velocity.y > self.targetVelocity.y then
			self.velocity.y = self.targetVelocity.y
		end
	end

	if self.velocity.y > self.newVelocity.y then
		self.velocity.y = self.velocity.y - self.inertia.y
		if self.velocity.y < self.targetVelocity.y then
			self.velocity.y = self.targetVelocity.y
		end
	end

end

function MoveableEntity:move(dt)
	self.origin.x = self.origin.x + self.velocity.x
	self.origin.y = self.origin.y + self.velocity.y
end

function MoveableEntity:draw()
	Entity.draw(self)
end
