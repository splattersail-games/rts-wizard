--[[
Draws a living entity's current health
If the entity has a name, display's it above the health
]]
DrawLivingEntity = class("DrawLivingEntity", System)

local healthBarWidth = 50
local border = 2
local healthBarHeight = 5

function DrawLivingEntity:initialize()
  System.initialize(self)
  self.group = 'camera_overlay'
end

function DrawLivingEntity:draw()
  --[[
  Get the current blend mode so that we can give it back after we are done.
  Then draw all the various components of a living entity:
  - A title
  - A healthbar
  ]]
  local previousBlendMode = love.graphics.getBlendMode()
  love.graphics.setBlendMode('alpha')

  for id, entity in pairs(self.targets) do
    local positionComponent = entity:get("Position")
    local livingCompotent = entity:get("Living")

    if entity.name and positionComponent.x and positionComponent.y then
      local text = Game.resources.textCache.currentWorld[entity.name]
      local posX = positionComponent.x - (text:getWidth() / 2)
      local posY = positionComponent.y - 70
      love.graphics.setColor(0, 255, 0, 255)
      love.graphics.draw(
        text,
        posX,
        posY
      )

      -- Draw a cheeky wee health bar. Arbitrary at this stage
      local healthPortionLeft = (livingCompotent.life / livingCompotent.maxLife)

      posX = positionComponent.x - (healthBarWidth / 2)
      posY = posY + 20
      love.graphics.setColor(0, 0, 0, 255)
      love.graphics.rectangle('fill', posX - border, posY - border, healthBarWidth + (2 * border), healthBarHeight + (2 * border))
      love.graphics.setColor(0, 255, 0, 255)
      love.graphics.rectangle('fill', posX, posY, healthBarWidth * healthPortionLeft, healthBarHeight)
      love.graphics.setColor(255, 255, 255)
    end
  end
  love.graphics.setBlendMode(previousBlendMode)
end

function DrawLivingEntity:requires()
  return {"Living", "Position"}
end
