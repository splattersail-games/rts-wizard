--[[
Model a spell
Allow push pushing of an element on to the spell
]]
Spell = class("Spell")
local MAX_ELEMENTS = 3

-- Just pasted this shallowcopy inline from stackoverflow because YOLO
function shallowcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in pairs(orig) do
      copy[orig_key] = orig_value
    end
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

function Spell:initialize()
  self.elements = Queue.new()
  self.currentElementCount = 0
end

function Spell:push(element)

  --[[
  Iterate through elements in reverse so that we can dequeue any element that conflicts with the element being pushed
  Dequeue elements by cloning the elements collection, destroying the first conflicting element, and then recreating the collection
  ]]
  local elementsCopy = shallowcopy(self.elements)
  local iter = elementsCopy.last
  local dequeuedAnElement = false
  while iter >= 0 do
    local elementInQueue = elementsCopy[iter]
    for el1, el2 in pairs(ELEMENT_CONFLICT_MAP) do
      local conflict = (element == el1 and elementInQueue == el2) or (elementInQueue == el1 and element == el2)
      if conflict then
        elementsCopy[iter] = nil
        dequeuedAnElement = true
        break
      end
    end

    if dequeuedAnElement then
      break
    end
    iter = iter - 1
  end

  if dequeuedAnElement then
    self.elements = Queue.new()
    local i = elementsCopy.first
    while i <= elementsCopy.last do
      if elementsCopy[i] then
        Queue.push(self.elements, elementsCopy[i])
      end
      i = i + 1
    end
    self.currentElementCount = self.elements.last + 1
    return
  end

  if self.currentElementCount < MAX_ELEMENTS then
    Queue.push(self.elements, element)
    self.currentElementCount = self.currentElementCount + 1
  end
end

function Spell:getElementCounts()
  local elementCounts = {}
  for _, el in pairs(Game.elements) do
    elementCounts[el] = 0
  end

  local elementsCopy = shallowcopy(self.elements)
  local i = nil
  for i = elementsCopy.first, elementsCopy.last do
    local el = elementsCopy[i]
    elementCounts[el] = elementCounts[el] + 1
  end
  return elementCounts
end
