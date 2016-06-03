--[[
This file doesn't serve much of a purpose and is left over from this project's origins as a more traditional RTS game
Will likely completely remove this file at some point and migrate anything that is actually useful elsewhere
]]

require 'src.input'

GameController = {}
GameController.lastKeyboardInput = 0 -- time of last successful keyboard action, for example adding to control group
GameController.currTime = 0
GameController.keyPresses = {

} -- map from key to last time it was pressed
GameController.lastControlGroupRecall = {
  controlGroup = -1,
  time = -1,
  centered = false
}

GameController.keyToAction = {
  s = function(dt) Game:StopCommand() end
}

--[[
  Half arsed data oriented methods for handling user input
]]

function GameController.selfCast(dt, entity, spellCaster)
  local elementCounts = spellCaster.spell:getElementCounts()
  local hasShield = elementCounts[Game.elements.SHIELD] > 0
  if hasShield then
    local wardComp = Ward() -- Nuke the old ward
    local elCount = 0

    for _, el in pairs(Game.elements) do
      if el ~= Game.elements.SHIELD then
        -- Add the non shield elements to the ward

        local elementStrength = elementCounts[el]
        if elementCounts[el] > 0 then

          local strength = nil
          for strength = 1, elementCounts[el] do
            wardComp[elCount] = el
            elCount = elCount + 1
          end
        end

      end
    end

    entity:set(wardComp)
  end
  spellCaster.spell:initialize()
end

function GameController.cast(dt, spellCaster)
  local elementCounts = spellCaster.spell:getElementCounts()
  local x, y = love.mouse.getX(), love.mouse.getY()
  x, y = camera:scalePoint(x, y)

  -- Just some derpin' bools to make the alg below more readable
  local hasShield = elementCounts[Game.elements.SHIELD] > 0
  local hasEarth = elementCounts[Game.elements.EARTH] > 0
  local hasIce = elementCounts[Game.elements.WATER] > 0 and
                  elementCounts[Game.elements.COLD] > 0
  local hasLifeOrDeath = elementCounts[Game.elements.LIFE] > 0 or
                          elementCounts[Game.elements.DEATH] > 0
  local hasLightning = elementCounts[Game.elements.LIGHTNING] > 0
  local hasSpray = elementCounts[Game.elements.WATER] > 0 or
                    elementCounts[Game.elements.COLD] > 0 or
                    elementCounts[Game.elements.FIRE] > 0

  -- Ice and earth are basically the same thing as far as spell forms are concerned
  -- This is a useful heuristic for working out the spell form of the spell
  local hasASolid = hasEarth or hasIce

  if hasASolid then

    if hasShield then
      -- this is a wall
    else
      -- this is a projectile
    end

  elseif hasLifeOrDeath then

    if hasShield then
      -- this is a mine
    else
      -- this is a beam
    end

  elseif hasShield and (hasLightning or hasSpray) then
    -- this is a storm
  elseif hasShield then
    -- this is a single shield element
  elseif hasLightning then
    -- this is lightning
  else
    -- this is a basic spray
  end

  spellCaster.spell:initialize()
end

function GameController.move(dt, entity, moveComp)
  local x, y = love.mouse.getX(), love.mouse.getY()
  x, y = camera:scalePoint(x, y)
  moveComp = Moveable(x, y, 130)
  entity:set(moveComp)
end













--[[
  Legacy bullshit code below
]]

function GameController:update(dt)

  --- set currTime
  GameController.currTime = love.timer.getTime()
  if (GameController.lastControlGroupRecall.centered) then
    Game:centerOnSelected()
  end
  GameController:keyHeldLogic(dt)
  GameController:mouseEvents(dt)
  GameController:keyboardEvents(dt)
  GameController:checkForCameraScroll(dt)
end

function GameController:mouseEvents(dt)
  local m
  for m = 1, 3 do
    if Input.__mousePressed[m] then
      Input:mousepressHandled(m, Input.__lastMouseClickPoint.x, Input.__lastMouseClickPoint.y)
    end

    if Input.__mouseReleased[m] then
      Input:mousereleaseHandled(m, Input.__lastMouseReleasePoint.x, Input.__lastMouseReleasePoint.y)
    end
  end
end

function GameController:keyHeldLogic(dt)
  for num = 0, 9 do
    if GameController.lastControlGroupRecall.centered then
    end
  end
end

function GameController:keyboardEvents(dt)
  for num = 0, 9 do
    if Input.__keysReleased[tostring(num)] then
      Input:keyreleaseHandled(tostring(num))
    end
  end

  local timeSinceKeyboardAction = (GameController.currTime - GameController.lastKeyboardInput) * 1000

  -- for key, pressed in pairs(Input.__keysPressed) do
  -- if pressed then
  -- GameController.keyToAction[key](dt)
  -- Input:keypressHandled(key)
  -- end
  -- end
end

function GameController:checkForNormalAction(dt)

  if not love.keyboard.isDown( "lshift" ) then
    GameController:checkForControlGroupRecall(dt)
  end
  if love.keyboard.isDown( "return" ) then
    Hud.textConsole.visible = not Hud.textConsole.visible
    GameController.lastKeyboardInput = love.timer.getTime()
  end

  GameController:checkForStopCommand(dt)
end

function GameController:checkForStopCommand(dt)
  if love.keyboard.isDown( "s" ) then
    --Game:stopCommand()
  end
end

function GameController:checkForCameraScroll(dt)
  scrollArea = 75
  scrollSpeed = 1000
  mPosX, mPosY = Game:checkForCameraScroll(scrollArea, scrollSpeed * dt)
end

function GameController:checkForControlGroupRecall(dt)
  for ctrlGroup = 0, 9 do
    if love.keyboard.isDown( tostring(ctrlGroup) ) then
      GameController.currTime = love.timer.getTime()
      recalled = Game:recallControlGroup(ctrlGroup)

      if recalled then
        print("recalled")
        if GameController.lastControlGroupRecall.controlGroup ~= -1 then
          if GameController.lastControlGroupRecall.controlGroup == ctrlGroup and not GameController.lastControlGroupRecall.centered then
            val = (GameController.currTime - GameController.lastControlGroupRecall.time) * 1000 * (dt * 1000)
            if (val > (100 * (dt * 1000)) and (val < (250 * dt * 1000))) then
              Game:centerOnSelected()
              GameController.lastControlGroupRecall.centered = true
            end
          end
        end

        GameController.lastKeyboardInput = GameController.currTime
        GameController.lastControlGroupRecall.controlGroup = ctrlGroup
        GameController.lastControlGroupRecall.time = GameController.currTime
      end
    end
  end

  return sentAction
end

function GameController:checkForModifierAction(dt)
  local ctrlIsPressed = love.keyboard.isDown( 'lctrl' )
  local shiftIsPressed = love.keyboard.isDown( 'lshift' )
  GameController:checkForControlGroup(dt, ctrlIsPressed, shiftIsPressed)
  GameController:checkForScreenCenter(dt, ctrlIsPressed)
end

function GameController:checkForScreenCenter(dt, ctrlPressed)
  local fIsPressed = love.keyboard.isDown( 'f' )
  if fIsPressed then
    Game:centerOnSelected()
  end
end

function GameController:checkForControlGroup(dt, ctrlPressed, shiftPressed)
  for ctrlGroup = 0, 9 do
    if love.keyboard.isDown( tostring(ctrlGroup) ) then
      if ctrlPressed then
        Game:createControlGroup(ctrlGroup)
      elseif shiftPressed then
        Game:addToControlGroup(ctrlGroup)
      end
      GameController.lastKeyboardInput = love.timer.getTime()
    end
  end
end
