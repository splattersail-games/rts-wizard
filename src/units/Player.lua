-- Player
-- Modes: fill, line
local class = require 'src.libs.middleclass'
require 'src.utils.geometry'
require 'src.utils.BoundingBox'
require 'src.units.BaseUnit'
require 'src.units.Light'
Player = class('Player', BaseUnit)

function Player:initialize(x, y, width, height, mode, colorTable)
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
	self.image = love.graphics.newImage( "resources/spritesheets/wizardi.png" )
	local normalMap = love.graphics.newImage( "resources/spritesheets/wizardi_normal.png" )	
	self.lightImage = World.lightWorld:newImage(self.image, 0, 0)
	self.lightImage:setScale(0.5)
	self.lightImage:setNormalMap(normalMap)
	self.lightImage:setShadowType("image")
	self.mode = mode
	self.colorTable = colorTable
	self.light = {}
end

function Player:update(dt)
	BaseUnit.update(self, dt)
	self.light:setPosition(self:getX(), self:getY())
	self.lightImage:setPosition(self:getX(), self:getY())
end

function Player:addLight(radius, colour)
	self.light = World.lightWorld:newLight(x, y, colour.r, colour.g, colour.b, radius)
	self.light:setGlowStrength(0.4)
end

function Player:draw()
	BaseUnit.draw(self)
	if not self.colorTable.a then self.colorTable.a = 255 end
	love.graphics.setColor(self.colorTable.r, self.colorTable.g, self.colorTable.b, self.colorTable.a)
	love.graphics.draw(self.image, self:getX(), self:getY(), 0,
		0.5, -- scale
		0.5,
		(2 * self.width),
		(2 *self.height)
	)
end