--[[
Draws a ward
]]
DrawWard = class("DrawWard", System)

function DrawWard:initialize()
  System.initialize(self)
  self.scale = 0.35
  self.innerWard = Game.resources.images.ward.inner
  self.outerWard = Game.resources.images.ward.outer
  self.imageWidth = self.innerWard:getWidth() * self.scale -- Assume they're both the same size and perfect square
  self.group = 'world'
end

function DrawWard:draw()
  --[[
  Get the current blend mode so that we can give it back after we are done.
  Then draw a spell caster's queued elements.
  ]]
  local previousBlendMode = love.graphics.getBlendMode()
  love.graphics.setBlendMode('add')

  for id, entity in pairs(self.targets) do

    -- Get the ward and position components
    local drawable = entity:get("Drawable")
    local positionComp = entity:get("Position")
    local wardComp = entity:get("Ward")
    local x, y = positionComp.x, positionComp.y
    local el1, el2 = wardComp[0], wardComp[1]

    local imageWidthScaled = (drawable.image:getWidth() * drawable.sx)
    local imageHeightScaled = (drawable.image:getHeight() * drawable.sy)

    love.graphics.draw(self.innerWard, x - (imageWidthScaled / 2), y - (imageHeightScaled / 4), 0, self.scale)
    love.graphics.draw(self.outerWard, x - (imageWidthScaled / 2), y - (imageHeightScaled / 4), 0, self.scale)
  end

  love.graphics.setBlendMode(previousBlendMode)
end

function DrawWard:requires()
  return {"Ward", "Position", "Drawable"}
end
