-- Selection box released
SelectUnits = class("SelectUnits", System)

function SelectUnits:fireEvent(evt)
  local initialDeselect = true

  if evt ~= nil and evt.rectangle then
    for id, gameObj in pairs(self.targets) do
      local collidableData = gameObj:get("Collidable")

      if (collidableData) then
        if collidableData.AABB:objectWithinSquare(evt.rectangle) then
          if not love.keyboard.isDown( "lshift" ) and initialDeselect then
            --Game:deselectObjects()
            initialDeselect = false
          end
          local selection = gameObj:get("PlayerControlled")
          selection.selected = true
        end
      end
    end
  end
end

function SelectUnits:requires()
  return {"PlayerControlled", "Position", "Collidable"}
end