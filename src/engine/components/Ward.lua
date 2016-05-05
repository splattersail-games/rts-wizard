--[[
This component represents an entity's ward.
Wards are composed of up to two elements.
Each element in a ward blocks 50% of that elements damage type, as well as blocking any status effects associated with that element.

There are a few exceptional cases:
LIFE element:
In addition to the general rule:
Applies a healing aura to the entity, which periodically modifies the life property of its Living component by a certain amount per life element
This healing aura is the only exception to the blocking of healing sources to the entity

WATER element:
A single water element blocks 50% ice damage, as well as 50% steam damage
]]
Ward = Component.create("Ward")

function Ward:initialize()
  self[0] = nil
  self[1] = nil
  self.size = 0
end