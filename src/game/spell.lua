--[[
Model a spell
Allow push pushing of an element on to the spell
]]
Spell = class("Spell")
local MAX_ELEMENTS = 3

function Spell:initialize()
  self.elements = Queue.new()
  self.currentElementCount = 0
end

function Spell:push(element)

  --[[
  Future state - do a check here for whether the element pressed should dequeue an existing element
  ]]

  if self.currentElementCount < 3 then
    Queue.push(self.elements, element)
    self.currentElementCount = self.currentElementCount + 1
  end
end