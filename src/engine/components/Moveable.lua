Moveable = Component.create("Moveable")

function Moveable:initialize(tx, ty, speed)
    self.tx = tx
    self.ty = ty
    self.speed = speed
end