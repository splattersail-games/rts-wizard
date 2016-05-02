--[[
This component acts as a container for an entity who can cast spells
]]
SpellCaster = Component.create("SpellCaster")

function SpellCaster:initialize()
  self.spell = Spell()
end