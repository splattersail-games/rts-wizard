--[[
This system is used in conjunction with the Position and ParentPositionOffset components
It allows entities to be "attached" to parent entities
]]
ParentPositionOffsetSystem = class("ParentPositionOffsetSystem", System)

function ParentPositionOffsetSystem:update(dt)
  for index, entity in pairs(self.targets) do
    local positionComponent = entity:get("Position")
    local offsetComponent = entity:get("ParentPositionOffset")

    if offsetComponent.ox and offsetComponent.oy then
      local parentEntity = entity:getParent()
      -- Refer to the parent's position component.
      -- Assume it's there, life is too short
      local parentPos = parentEntity:get("Position")

      local px, py = parentPos.x, parentPos.y
      px = px + offsetComponent.ox
      py = py + offsetComponent.oy

      -- Make updates to this entity's position
      positionComponent.x = px
      positionComponent.y = py

      -- Hardcode a wee shim for now to update light world light position if necessary
      local lightComponent = entity:get("Light")
      if lightComponent then
        lightComponent.theLight.x = px
        lightComponent.theLight.y = py
      end
    end
  end
end

function ParentPositionOffsetSystem:requires()
  return {"Position", "ParentPositionOffset"}
end
