local class = require 'src.libs.middleclass'
require 'src.utils.queue'
require 'src.units.MoveableEntity'

BaseUnit = class('BaseUnit', MoveableEntity)

function BaseUnit:initialize(x, y, box)
	MoveableEntity.initialize(
		self,
		x,
		y,
		box
	)
	self.commandQueue = Queue.new()
	self.moveSpeed = 120 -- Default movement speed
end

function BaseUnit:setTargetMovespeed(newSpeed)
	self.moveSpeed = newSpeed
end

function BaseUnit:update(dt)
	MoveableEntity.update(self, dt)
	
	if Queue.empty( self.commandQueue ) then
		return
	end
	
	self.commandQueue[self.commandQueue.first]:update(dt)

	if self.commandQueue[self.commandQueue.first]:doCommand(self) then
		Queue.pop( self.commandQueue )
	end
end

function BaseUnit:draw()
	MoveableEntity.draw(self)

	-- Draw selected box
	if Game:isSelected(self.id) then
		love.graphics.setLineWidth(2)
		love.graphics.setColor(255, 255, 255, 192)
		love.graphics.circle('line', self:getX(), self:getY(), self.boundingBox.width / 3)
	end

	BaseUnit.drawCommands(self)
end

function BaseUnit:drawCommands()
	if Queue.empty( self.commandQueue ) or self.commandQueue.last == 0  then
		return
	end

	local cmdQ = self.commandQueue[self.commandQueue.first]
	love.graphics.setColor(0, 102, 204, 64)
	love.graphics.setLineStyle('smooth')
	love.graphics.setLineWidth(1)

	local x = self:getX()
	local y = self:getY()
	while cmdQ do
		cmdQ:draw(x, y)
		if not (cmdQ.next == nil) then
			x = cmdQ.x or x
			y = cmdQ.y or y
		end
		cmdQ = cmdQ.next

	end

end

function BaseUnit:tryToSelect(x, y)
	return self.boundingBox:pointWithinSquare(x, y)
end

function BaseUnit:tryToDragSelect(rect)
	return self.boundingBox:objectWithinSquare(rect)
end

function BaseUnit:clearCommandQueue()
	self.commandQueue = Queue.new()
end

function BaseUnit:addCommandToQueue(cmd)
	if not love.keyboard.isDown( "lshift" ) then
		self:clearCommandQueue()
	end

	Queue.push( self.commandQueue, cmd )
end