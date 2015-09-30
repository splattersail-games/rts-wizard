local class = require 'src.libs.middleclass'
require 'src.commands.Command'
require 'src.utils.geometry'
vector = require 'src.utils.vector'

MoveCommand = class('MoveCommand', Command)

function MoveCommand:initialize(pointX, pointY, dt)
	self.x = pointX
	self.y = pointY
	self = Command.initialize(self, dt)
end

function MoveCommand:update(dt)
	Command.update(self, dt)
end

function MoveCommand:draw(unitX, unitY)
	-- dotted line here
	--lineStipple(self.x, self.y, unitX, unitY, 3, 3)

	-- normal line
	local mode = love.graphics.getBlendMode()
	love.graphics.setColor({112, 112, 112, 128})
	love.graphics.setBlendMode("additive")
	love.graphics.line(self.x, self.y, unitX, unitY)
	love.graphics.setBlendMode(mode)
end

-- New Code.. HMMMM
-- Perhaps we won't do it this way. Accurate move command is best move command?
-- function MoveCommand:doCommand(baseUnit)
-- 	local destPoint = vector(self.x, self.y)
-- 	local objPoint = vector(baseUnit:getX(), baseUnit:getY())
-- 	local distance = objPoint:dist(destPoint)

-- 	if distance < 1.0 then
-- 		baseUnit:setTargetSpeed(0)
-- 		return true
-- 	end


-- 	local dv = destPoint - objPoint
-- 	dv:normalize_inplace()

-- 	local constant = (self.multiplier * baseUnit.moveSpeed)
-- 	local distanceToMove = distance < constant and distance or constant

-- 	baseUnit:setMoveDirection(dv)	
-- 	baseUnit:setTargetSpeed(distanceToMove)
-- 	print(distanceToMove)

-- 	-- baseUnit.x = newPos.x
-- 	-- baseUnit.y = newPos.y

-- 	return false
-- end

--Old code
function MoveCommand:doCommand(gameObj)
	local destPoint = vector(self.x, self.y)
	local objPoint = vector(gameObj:getX(), gameObj:getY())
	local distance = objPoint:dist(destPoint)

	local dv = destPoint - objPoint
	dv:normalize_inplace()

	local constant = (self.multiplier * gameObj.moveSpeed)
	local distanceToMove = distance < constant and distance or constant
	local newPos = objPoint + (distanceToMove * dv)

	local goalX, goalY = gameObj:scaleCoordsToAABB(newPos.x, newPos.y)
	local actualX, actualY, cols, len = World.bump:move(gameObj, goalX, goalY)
	gameObj.origin.x, gameObj.origin.y = gameObj:AABBToOrigin(actualX, actualY)

	return newPos == destPoint
end