Drawable = Component.create(
    "Drawable",
    { "image", "r", "sx", "sy", "ox" },
    { r = 0, sx = 1, sy = 1, ox = 0, oy = 0 }
)

function Drawable:initialize(image, r, sx, sy, ox, oy)
    self.image = image           -- Image
    self.r = r                   -- Rotation
    if sx then self.sx = sx  end -- Scale X
    if sy then self.sy = sy  end -- Scale Y
    if ox then self.ox = ox  end -- Offset X
    if oy then self.oy = oy  end -- Offset Y
end