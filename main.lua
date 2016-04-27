-- Main --
class = require 'src.libs.middleclass'
require 'engine-import'

-- Main game
require 'src.Game'
require 'src.Menu'
require 'src.input'

-- stuff that needs updating and drawing
require 'src.world'
require 'src.resource'
require 'src.commands.MoveCommand'
require 'src.commands.StopCommand'
require 'src.commands.Command'
require 'src.GameController'
--srequire 'src.Entities'
require 'src.hud'

-- Run at game start --
function love.load()
  print("Loading Game. . . ")
  love.mouse.setVisible(false)
  love.graphics.setBackgroundColor(0, 0, 0, 255)
  love.graphics.setColor(0, 0, 0)
  cursor = love.graphics.newImage("resources/cursor.png")
  resources:init()
  success = love.window.setIcon( resources.icon:getData() )

  Menu.load()
end

-- Draw what we updated in love.update() --
function love.draw()
  -- love.graphics.reset()
  -- love.graphics.draw(resources.myImage, 100, 100)

  love.graphics.setBlendMode("alpha")
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY(), 0, 0.3)

end

function love.textinput(text)
end

-- Game Quit --
function love.quit()
  print("Game Quit")
end

-- Called when the game gains or loses focus.
-- True if gained, false otherwise.
function love.focus(bool)
  Game:setFocus(bool)
end
