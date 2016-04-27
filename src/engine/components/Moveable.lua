Moveable = Component.create("Moveable")

function Moveable:initialize(tx, ty, speed)
    self.targetX = tx
    self.targetY = ty
    self.speed = speed
end