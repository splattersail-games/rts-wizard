camera = {}
camera.x = 0
camera.y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0

function camera:set()
	love.graphics.push()
	love.graphics.rotate(-self.rotation)
	love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
	love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
	love.graphics.pop()
end

function camera:move(dx, dy)
	self:setX(self.x + (dx or 0))
	self:setY(self.y + (dy or 0))
end

function camera:rotate(dr)
	self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
	sx = sx or 1
	self.scaleX = self.scaleX * sx
	self.scaleY = self.scaleY * (sy or sx)
end

function camera:setX(x)
	if self._bounds then
		local min, max = self._bounds.x1, self._bounds.x2
		self.x = x < min and min or 
			((x + love.graphics.getWidth()) > max and (max - love.graphics.getWidth()) or x)
	else
		self.x = x
	end
end
 
function camera:setY(y)
	if self._bounds then
		local min, max = self._bounds.y1, self._bounds.y2
		self.y = y < min and min or 
			(y + love.graphics.getHeight() > max and (max - love.graphics.getHeight()) or y)
	else
		self.y = y
	end
end
 
function camera:setPosition(x, y)
  if x then self:setX(x) end
  if y then self:setY(y) end
end

function camera:lookAt(x, y)
	camera:setPosition(x, y)
	self.x = self.x - (love.graphics.getWidth()/2)
	self.y = self.y - (love.graphics.getHeight()/2)
end

function camera:getBounds()
  return unpack(self._bounds)
end

function camera:setBounds(x1, y1, x2, y2)
	self._bounds = { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
end

function camera:setScale(sx, sy)
	self.scaleX = sx or self.scaleX
	self.scaleY = sy or self.scaleY
end

function camera:scroll(scrollArea, scrollSpeed)
	mPosX, mPosY = love.mouse.getPosition()

	if (mPosX < scrollArea) then 
		local portion = math.abs((mPosX - scrollArea) / scrollArea)
		self:move(-1 * scrollSpeed * portion, 0 * scrollSpeed * portion) 
	end

	if (mPosX >= love.graphics.getWidth() - scrollArea) then 
		local portion = math.abs((mPosX - (love.graphics.getWidth() - scrollArea)) / scrollArea)
		self:move(1 * scrollSpeed * portion, 0 * scrollSpeed * portion) 
	end
	
	if (mPosY < scrollArea) then 
		local portion = math.abs((mPosY - scrollArea) / scrollArea)
		self:move(0 * scrollSpeed * portion, -1 * scrollSpeed * portion) 
	end

	if (mPosY >= love.graphics.getHeight() - scrollArea) then 
		local portion = math.abs((mPosY - (love.graphics.getHeight() - scrollArea)) / scrollArea)
		self:move(0 * scrollSpeed * portion, 1 * scrollSpeed * portion) 
	end
end

function camera:mousePosition()
	return love.mouse.getX() * self.scaleX + self.x, love.mouse.getY() * self.scaleY + self.y
end

function camera:scalePoint(x, y)
	return x * self.scaleX + self.x, y * self.scaleY + self.y
end

function camera:scalePointToCamera(x, y)
	return x * self.scaleX - self.x, y * self.scaleY - self.y
end

function camera:getLightTranslation()
    local tx,ty = love.graphics.getWidth()/(2*self.scaleX), love.graphics.getHeight()/(2*self.scaleY)
    tx = tx-self.x
    ty = ty-self.y
    return -tx,-ty
end