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
-- Lock down the element values so code can't mess with them, (in lieu of constants)
setmetatable(elements, {
  __newindex = function(t, k, v)
    assert(not readonly_vars[k], 'Element values are final and should not be modififed at run time')
    rawset(t, k, v)
  end
})

return elements