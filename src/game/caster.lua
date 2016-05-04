--[[
Takes a spell and works out what to do with it!
]]
local caster = {}
caster.cast = function(spell, x, y, options)
  -- Do the spell casting stuff

  -- Aight. We're done here. Reset the elements on the spell.
  spell:initialize()
end
return caster