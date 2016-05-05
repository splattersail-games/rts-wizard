--[[
Draws a ward
]]
DrawWard = class("DrawWard", System)

function DrawWard:initialize()
  System.initialize(self)
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

    love.graphics.setBlendMode("add")
    if el1 then
      love.graphics.draw(Game.resources.images.ward.inner[el1], x - (Game.resources.images.ward.offset), y - (imageHeightScaled / 3), 0)
    end

    if el2 then
      love.graphics.draw(Game.resources.images.ward.outer[el2], x - (Game.resources.images.ward.offset), y - (imageHeightScaled / 3), 0)
    end
    love.graphics.setBlendMode("alpha")
  end

  love.graphics.setBlendMode(previousBlendMode)
end

function DrawWard:requires()
  return {"Ward", "Position", "Drawable"}
end
