Moveable = Component.create("Moveable")

function Moveable:initialize(ox, oy, tx, ty, speed)
    self.targetX = tx
    self.targetY = ty
    self.originX = ox
    self.originY = oy
    self.speed = speed
end