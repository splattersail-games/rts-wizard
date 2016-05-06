--[[
This component acts as a container for an entity who can cast spells
]]
SpellCaster = Component.create("SpellCaster")

function SpellCaster:initialize()
  self.spell = Spell()
end

function SpellCaster:getSpellElements()
  local elements = {}
  local i = 0
  for i = 0, 2 do
    if self.spell.elements[i] then elements[i] = self.spell.elements[i] end
  end

  return elements
end