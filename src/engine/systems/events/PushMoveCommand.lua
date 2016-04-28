-- Selection box released
PushMoveCommand = class("PushMoveCommand", System)

function PushMoveCommand:fireEvent(evt)
  if evt ~= nil and evt.x and evt.y then
    for id, gameObj in pairs(self.targets) do
      local moveableComponent = Moveable(evt.x, evt.y, 50)
      if (gameObj:get("PlayerControlled").selected) then
        gameObj:set(moveableComponent)
      end
    end
  end
end

function PushMoveCommand:requires()
  return {"PlayerControlled", "Position", "Moveable"}
end