--[[
Draws a living entity's current health
If the entity has a name, display's it above the health
]]
DrawLivingEntity = class("DrawLivingEntity", System)

function DrawLivingEntity:draw()
  for id, entity in pairs(self.targets) do
    local positionComponent = entity:get("Position")

    if entity.name and positionComponent.x and positionComponent.y then
      local text = resources.textCache.currentWorld[entity.name]
      love.graphics.setColor(0, 255, 0)
      love.graphics.draw(
        text,
        positionComponent.x - (text:getWidth() / 2),
        positionComponent.y - 50
      )
      love.graphics.setColor(255, 255, 255)
    end
  end
end

function DrawLivingEntity:requires()
  return {"Player", "Position"}
end
