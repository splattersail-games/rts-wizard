--[[
Elements used in the game
]]
local elements = {
  WATER = 0,
  FIRE = 1,
  SHIELD = 2,
  COLD = 3,
  LIGHTNING = 4,
  DARK = 5,
  LIGHT = 6,
  EARTH = 7
}
ELEMENT_CONFLICT_MAP = {}
ELEMENT_CONFLICT_MAP[elements.WATER] = elements.LIGHTNING
ELEMENT_CONFLICT_MAP[elements.LIGHTNING] = elements.EARTH
ELEMENT_CONFLICT_MAP[elements.SHIELD] = elements.SHIELD
ELEMENT_CONFLICT_MAP[elements.DARK] = elements.LIGHT
ELEMENT_CONFLICT_MAP[elements.FIRE] = elements.COLD

-- Lock down the element values so code can't mess with them, (in lieu of constants)
setmetatable(elements, {
  __newindex = function(t, k, v)
    assert(not readonly_vars[k], 'Element values are final and should not be modififed at run time')
    rawset(t, k, v)
  end
})

return elements