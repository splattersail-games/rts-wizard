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
      x, y = camera:scalePoint(x, y)
      moveComp = Moveable(x, y, 130)
      entity:set(moveComp)
    end

    -- Read element casts
    for element, key in pairs(Settings.controls.elements) do
      if Input.__keysPressed[key] then
        spellCaster.spell:push(Game.elements[element])
        Input:keypressHandled(key)
      end
    end

    -- Mouse 2 is currently hardcoded as spell cast
    if Input.__mousePressed[2] then
      local x, y = love.mouse.getX(), love.mouse.getY()
      x, y = camera:scalePoint(x, y)
      Game.caster.cast(spellCaster.spell, x, y, { castType = 0 })
    end

    -- Mouse 3 is currently hardcoded as self cast (have also arbitrarily used an options object with castType=1 to indicate self cast. This will and probably should change)
    -- We will also need to give the spell caster access to some sort of callback API to the ECS / collision world so that it can do its work
    if Input.__mousePressed[3] then

      -- Just gonna hard code warding logic here for POC
      local hasShield = false
      for i, el in pairs(spellCaster:getSpellElements()) do
        hasShield = hasShield or (el == Game.elements.SHIELD)
        if hasShield then
        end
      end

      if hasShield then
        local wardComp = Ward() -- Nuke the old ward
        local elCount = 0
        for index, el in pairs(spellCaster:getSpellElements()) do
          if el ~= Game.elements.SHIELD then
            wardComp[elCount] = el
            elCount = elCount + 1
          end
        end
        entity:set(wardComp)
      end
      Game.caster.cast(spellCaster.spell, x, y, { castType = 1 })
    end
  end
end

function ReadPlayerInput:requires()
  return {"Player", "SpellCaster", "Moveable"}
end
