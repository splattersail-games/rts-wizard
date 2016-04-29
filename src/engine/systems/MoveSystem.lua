MoveSystem = class("MoveSystem", System)

local function AABBToOrigin(boundingBox, x, y)
  return x + (boundingBox.width / 2), y + (boundingBox.height / 2)
end

local function scaleCoordsToAABB(boundingBox, x, y)
  return x - (boundingBox.width / 2), y - (boundingBox.height / 2)
end

function MoveSystem:update(dt)
  for index, entity in pairs(self.targets) do
    local moveComp = entity:get("Moveable")
    local position = entity:get("Position")
    local bounding = entity:get("Collidable")
    local light = entity:get("Light")

    if moveComp and position and position.x and position.y and moveComp.tx and moveComp.ty and moveComp.speed then
      local destPoint = vector(moveComp.tx, moveComp.ty)
      local objPoint = vector(position.x, position.y)
      local distance = objPoint:dist(destPoint)

      local dv = destPoint - objPoint
      dv:normalize_inplace()

      local constant = (dt * moveComp.speed)
      local distanceToMove = distance < constant and distance or constant
      local newPos = objPoint + (distanceToMove * dv)

      local goalX, goalY = newPos.x, newPos.y
      if bounding then
        goalX, goalY = scaleCoordsToAABB(bounding.AABB, newPos.x, newPos.y)

        local actualX, actualY, cols, len = World.bump:move(entity, goalX, goalY)
        position.x, position.y = AABBToOrigin(bounding.AABB, actualX, actualY)
        if (light) then
          light.x, light.y = position.x, position.y
        end
      else
        position.x, position.y = goalX, goalY
      end
    end
  end
end

function MoveSystem:requires()
  return {"Moveable", "Position"}
end
