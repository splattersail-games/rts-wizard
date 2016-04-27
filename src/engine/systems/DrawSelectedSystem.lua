DrawSelectedSystem = class("DrawSelectedSystem", System)

function DrawSelectedSystem:draw()
  love.graphics.setColor(255,255,255)
  love.graphics.setLineWidth(1)
  for index, entity in pairs(self.targets) do
    local drawableData = entity:get("Drawable")
    local positionData = entity:get("Position")
    local playerControlled = entity:get("PlayerControlled")
    if (drawableData and positionData and playerControlled) then

      if (playerControlled.selected) then
        love.graphics.circle(
          "line",
          positionData.x,
          positionData.y,
          drawableData.image:getWidth() / 3
        )
      end
    end
  end
end

function DrawSelectedSystem:requires()
  return {"PlayerControlled", "Position", "Drawable"}
end
