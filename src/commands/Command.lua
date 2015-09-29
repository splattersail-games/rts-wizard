local class = require 'src.libs.middleclass'

Command = class('Command')


function Command:initialize(dt)
	self.startTime = dt
end

-- returns true when finished
function Command:update(dt)
	self.multiplier = dt
end

function Command:draw()
end

function Command:doCommand(gameObj)

end

