--[[
Draws a living entity's current health
If the entity has a name, display's it above the health
]]
DrawLivingEntity = class("DrawLivingEntity", System)

function DrawLivingEntity:draw()
  for id, entity in pairs(self.targets) do
    local positionComponent = entity:get("Position")

    if entity.name and positionComponent.x and positionComponent.y then
      love.graphics.print(
        entity.name,
        positionComponent.x - 28, -- Hardcoded position for now as POC
        positionComponent.y - 50
      )
    end
  end
end

function DrawLivingEntity:requires()
  return {"Player", "Position"}
end
