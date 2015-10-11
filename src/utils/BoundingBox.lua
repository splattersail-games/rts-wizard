

BoundingBox = class('BoundingBox')

function BoundingBox:initialize(x1, y1, x2, y2)
	self.x1 = x1
	self.y1 = y1
	self.x2 = x2
	self.y2 = y2

	self.width = math.abs(x2 - x1)
	self.height = math.abs(y2 - y1)
end

function BoundingBox:pointWithinSquare(pointX, pointY)
	if pointX > self.x1 and pointX < self.x2 then
		if pointY > self.y1 and pointY < self.y2 then
			return true
		end
	end
	return false
end

function BoundingBox:vertices()
	return self.x1, self.y1, self.x2, self.y1, self.x2, self.y2, self.x1, self.y2
end

function BoundingBox:objectWithinSquare(rect)
	if rect:pointWithinSquare(self.x1, self.y1) then
		return true
	end

	if rect:pointWithinSquare(self.x2, self.y1) then
		return true
	end

	if rect:pointWithinSquare(self.x1, self.y2) then
		return true
	end

	if rect:pointWithinSquare(self.x2, self.y2) then
		return true
	end

	return false
end
