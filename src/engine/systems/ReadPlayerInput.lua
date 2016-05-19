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
      GameController.move(dt, entity, moveComp)
    end

    local selfCastKey = Settings.controls.actions.SELF_CAST
    if Input.__keysPressed[Settings.controls.actions.SELF_CAST] then
      GameController.selfCast(dt, entity, spellCaster)
      Input:keypressHandled(selfCastKey)
    end
    local castKey = Settings.controls.actions.CAST
    if Input.__keysPressed[castKey] then
      GameController.cast(dt, spellCaster)
      Input:keypressHandled(castKey)
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
      GameController.cast(dt, spellCaster)
    end

    -- Mouse 3 is currently hardcoded as self cast (have also arbitrarily used an options object with castType=1 to indicate self cast. This will and probably should change)
    -- We will also need to give the spell caster access to some sort of callback API to the ECS / collision world so that it can do its work
    if Input.__mousePressed[3] then
      GameController.selfCast(dt, spellCaster)
    end
  end
end

function ReadPlayerInput:requires()
  return {"Player", "SpellCaster", "Moveable"}
end
