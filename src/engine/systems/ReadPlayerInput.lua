--[[
Read the players inputs.
For now, directly modify the player entity's components based on input values
]]
ReadPlayerInput = class("ReadPlayerInput", System)

function ReadPlayerInput:update(dt)
  for index, entity in pairs(self.targets) do
    local moveComp = entity:get("Moveable")
    local position = entity:get("Position")
    local spellCaster = entity:get("SpellCaster")

    -- Mouse 1 is currently hardcoded as move command
    if love.mouse.isDown(1) then
      local x, y = love.mouse.getX(), love.mouse.getY()
      camera:scalePoint(x, y)
      moveComp = Moveable(x, y, 130)
      entity:set(moveComp)
    end

    -- Read element casts
    for element, key in pairs(Settings.controls.elements) do
      if love.keyboard.isDown(key) then
        spellCaster.spell:push(elements[element])
      end
    end

    -- Mouse 2 is currently hardcoded as spell cast
    if love.mouse.isDown(2) then
      local x, y = love.mouse.getX(), love.mouse.getY()
      camera:scalePoint(x, y)
      caster.cast(spellCaster.spell)
    end
  end
end

function ReadPlayerInput:requires()
  return {"Player", "SpellCaster", "Moveable"}
end
