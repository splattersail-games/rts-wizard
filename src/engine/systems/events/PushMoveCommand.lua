-- Will convert this to an event handler on the Player entity
PushMoveCommand = class("PushMoveCommand", System)

function PushMoveCommand:fireEvent(evt)
  if evt ~= nil and evt.x and evt.y then
    for id, gameObj in pairs(self.targets) do
      local moveableComponent = Moveable(evt.x, evt.y, 130)
      gameObj:set(moveableComponent)
    end
  end
end

function PushMoveCommand:requires()
  return {"Player", "Position", "Moveable"}
end