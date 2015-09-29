require 'src.units.square'

GameObjects = {}
GameObjects.size = 0

function GameObjects:update(dt)
	for gameObj = 0, (self.size-1) do
		GameObjects[gameObj]:update(dt)
	end
end

function GameObjects:draw()
	love.graphics.setBlendMode('alpha')
	for gameObj = 0, (self.size-1) do
		self[gameObj]:draw()
	end
end

function GameObjects:addSquare(x, y, width, height, mode, colorTable)
	toAdd = Square:new(x, y, width, height, mode, colorTable)
	self[self.size] = (toAdd)
	self.size = self.size + 1
end

function GameObjects:getObjectPosition(objId)
	return GameObjects[objId].x, GameObjects[objId].y
end