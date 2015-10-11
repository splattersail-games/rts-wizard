-- Player
-- Modes: fill, line

Player = class('Player', BaseUnit)

function Player:initialize(x, y, width, height)
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
	self.width = width
	self.height = height
	self.image = love.graphics.newImage( "resources/spritesheets/pixeli.png" )	
	self.light = {}
end

function Player:update(dt)
	BaseUnit.update(self, dt)
	self.light:setPosition(self:getX(), self:getY())
end

function Player:addLight(radius, colour)
	self.light = World.lightWorld:newLight(x, y, colour.r, colour.g, colour.b, radius)
	self.light.z = 1
	self.light:setGlowStrength(0.4)
end

function Player:draw()
	BaseUnit.draw(self)
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.image, self:getX(), self:getY(), 0,
		1.0, -- scale
		1.0,
		(self.image:getWidth() / 2),
		(self.image:getHeight() / 2)
	)
end