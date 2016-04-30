--[[
This component is intended to be used in conjunction with a position component
It declares an offset from a parent entity's position.
If the child entity should be "phsyically" attached in anyway to its parent, use this component
]]
ParentPositionOffset = Component.create("ParentPositionOffset")

function ParentPositionOffset:initialize(ox, oy)
  self.ox, self.oy = ox, oy
end