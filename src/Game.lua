require 'src.utils.camera'
require 'src.Menu'

Game = {}
Game.mainMenu = true
Game.drawAABBs = false
Game.logWorldLoadDebug = false
Game.drawOrigin = false

function Game:init(world)
  love.mouse.setVisible(false)

  World:load(world)
  camera:setBounds(0, 0, World.width, World.height)
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
  Hud:update(dt)
end

function Game:draw()
  love.graphics.setBlendMode("alpha")
  love.graphics.setColor(255, 255, 255)

  World.lightWorld:setTranslation(-camera.x, -camera.y, camera.scaleX)
  camera:set()
  World.lightWorld:draw(function()
      World:draw()
    end)

  local x, y = camera:mousePosition()
  love.graphics.draw(cursor, x, y, 0, 0.3)
  camera:unset()

  Hud.draw()
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
