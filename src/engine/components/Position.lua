Position = Component.create("Position", { "x", "y" }, { x = 0, y = 0 })

function Position:initialize(x, y)
    self.x = x
    self.y = y
end