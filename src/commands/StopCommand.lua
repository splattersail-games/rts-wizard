
require 'src.commands.Command'
vector = require 'src.utils.vector'

StopCommand = class('StopCommand', Command)

function StopCommand:initialize(dt)
	self = Command.initialize(self, dt)
end

function StopCommand:update(dt)
	Command.update(self, dt)
end

function StopCommand:draw(x, y)
	love.graphics.print("S", x, y)
end

function StopCommand:doCommand(gameObj)
	return true
end