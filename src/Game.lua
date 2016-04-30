require 'src.utils.camera'
require 'src.Menu'

Game = {}
Game.mainMenu = true
Game.drawAABBs = false
Game.drawOrigin = true

function Game:init(world)
  love.mouse.setVisible(false)

  World:load(world)
  camera:setBounds(0, 0, World.width, World.height)
  -- if Entities.camerasByName["start"] ~= nil then
  -- local lookX, lookY = Entities.camerasByName["start"]:getLookAt()
  -- print ("Setting camera to default start of " .. lookX .. ", " .. lookY)
  -- camera:lookAt(Entities.camerasByName["start"]:getLookAt())
  -- end

  Hud:init()

  love.update = Game.update
  love.draw = Game.draw
  love.keypressed = Input.keypressed
  love.keyreleased = Input.keyreleased
  love.mousepressed = Input.mousepressed
  love.mousereleased = Input.mousereleased
end

function Game:unload()
  Game.mainMenu = true
  World:unload()
end

function Game.update(dt)
  World:update(dt)
  GameController:update(dt)
  --Entities:update(dt)
  --Game:resolveCollisions(dt)
  Hud:update(dt)
end

function Game:draw()
  love.graphics.setBlendMode("alpha")
  love.graphics.setColor(255, 255, 255)

  World.lightWorld:setTranslation(-camera.x, -camera.y, camera.scaleX)
  camera:set()
  World.lightWorld:draw(function()
      World:draw()
      --Entities:draw()
    end)

  local x, y = camera:mousePosition()
  love.graphics.draw(cursor, x, y, 0, 0.3)
  camera:unset()

  Hud.draw()
end

function Game:centerOnSelected()
  -- Get the current "primary" selection
  local primarySelectedId = Game.selection:getPrimarySelected()
  local newCameraPosX, newCameraPosY = Entities:getObjectPosition(primarySelectedId)
  camera:lookAt(newCameraPosX, newCameraPosY)
end

--
-- Checks if we've selected anything
-- If we have, adds it to the set of selected objects
--
function Game:checkForSelect(pointX, pointY)
  -- for id, gameObj in pairs(Entities.PlayerControlled) do

  -- if gameObj.tryToSelect ~= nil and (pointX ~= nil and pointY ~= nil) then
  -- if gameObj:tryToSelect(pointX, pointY) then
  -- if not love.keyboard.isDown( "lshift" ) then
  -- Game:deselectObjects()
  -- end
  -- if love.keyboard.isDown( "lctrl" ) then
  -- Game:selectAllOfType(gameObj.class)
  -- end
  -- Game.selection:add(id)
  -- break
  -- end
  -- end
  -- end
end

function Game:selectAllOfType(c)
  -- for id, gameObj in pairs(Entities.PlayerControlled) do
  -- if gameObj:isInstanceOf(c) then
  -- Game.selection:add(id)
  -- end
  -- end
end

function Game:recallControlGroup(ctrlGroup)
  return Game.selection:recallControlGroup(ctrlGroup)
end

function Game:createControlGroup(ctrlGrp)
  Game.selection:createControlGroup(ctrlGrp)
end

function Game:addToControlGroup(ctrlGrp)
  Game.selection:addToControlGroup(ctrlGrp)
end

--
-- Checks if there are objects to select within the selection box.
-- If there are, adds all of them to the set of selected objects
--
function Game:checkForSelectInBox()

  -- local selectionBox = Hud.selectionBox.rectangle

end

function Game:fireEvent(evt)
  World.eventManager:fireEvent(evt)
end

function Game:setFocus(state)
  if state then
    mX, mY = love.mouse.getPosition()
    if mX >= 0 and mY >= 0 and mX <= love.graphics.getWidth() and mY <= love.graphics.getHeight() then
      love.mouse.setGrabbed(true)
    end
  end
  self.focus = state
end

function Game:checkForCameraScroll(scrollArea, scrollSpeed)
  if self.focus then
    camera:scroll(scrollArea, scrollSpeed)
  end
end

function Game:deselectObjects()
  Game.selection:deselect(Entities)
end

function Game:isSelected(id)
  return Game.selection.selected[id]
end

function Game:clearCommandQueue()

  -- for id, gameObj in pairs(Entities.PlayerControlled) do
  -- if Game.selection.selected[id] then
  -- gameObj:clearCommandQueue()
  -- end
  -- end
end

function Game:moveCommand(x, y)

  -- for id, gameObj in pairs(Entities.PlayerControlled) do
  -- if Game.selection.selected[id] then
  -- gameObj:addCommandToQueue(MoveCommand:new(x, y))
  -- end
  -- end
end

function Game:stopCommand()

  -- for id, gameObj in pairs(Entities.PlayerControlled) do
  -- if Game.selection.selected[id] then
  -- gameObj:addCommandToQueue(StopCommand:new())
  -- end
  -- end
end
