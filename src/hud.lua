local elements = require 'src.game.elements'
Hud = {}
Hud.size = 0

Hud.textConsole = {}
Hud.textConsole.visible = false
Hud.textConsole.textPadding = 12
Hud.textConsole.fontSize = 14
Hud.textConsole.text = {}
Hud.textConsole.title = "A voice in the darkness. . . "

local gWidth, gHeight
local borderWidth
local panelSpacing
local elementSize
local elementsContainerWidth
local elementsContainerHeight
local elementsViewX
local elementsViewY

function Hud:init()
  gWidth, gHeight = love.graphics.getWidth(), love.graphics.getHeight()
  borderWidth = 10
  panelSpacing = 5
  elementScale = 0.7
  elementSize = resources.images.elements['WATER']:getWidth() * elementScale
  elementsContainerWidth = (elementSize * 8) + (panelSpacing * 11)
  elementsContainerHeight = (elementSize * 2) + (panelSpacing * 2)
  elementsViewX = math.floor((gWidth - elementsContainerWidth) / 2)
  elementsViewY = gHeight - math.floor(elementsContainerHeight) - borderWidth

  Hud.textConsole.font = love.graphics.newFont("resources/ui/fonts/GeosansLight.ttf", Hud.textConsole.fontSize)
  Hud.textConsole.titleFont = love.graphics.newFont("resources/ui/fonts/Timeless.ttf", 18)

  Hud.textConsole.text[0] = "Welcome to the dungeon"
  Hud.textConsole.text[1] = ". . . "
  Hud.textConsole.text[2] = "Now, fuck off!"
end


function Hud:update(dt)
end

-- draws a box for each control group at the bottom of the screen
function Hud:drawElements()

  local startX, startY = elementsViewX, elementsViewY
  love.graphics.setColor(40, 50, 40)
  love.graphics.rectangle('fill', startX, startY, elementsContainerWidth, elementsContainerHeight)
  love.graphics.setColor(255, 255, 255)
  panelX = startX + panelSpacing
  panelY = startY + panelSpacing
  love.graphics.draw(resources.images.elements['WATER'], panelX, panelY, 0, elementScale, elementScale)

  panelX = panelX + (elementSize + panelSpacing)
  love.graphics.draw(resources.images.elements['LIGHT'], panelX, panelY, 0, elementScale, elementScale)

  panelX = panelX + (elementSize + panelSpacing)
  love.graphics.draw(resources.images.elements['SHIELD'], panelX, panelY, 0, elementScale, elementScale)

  panelX = panelX + (elementSize + panelSpacing)
  love.graphics.draw(resources.images.elements['COLD'], panelX, panelY, 0, elementScale, elementScale)

  -- Shimmy this row down underneath the preceding 4
  panelX = startX + panelSpacing + (elementSize / 2)
  panelY = startY + (elementSize + panelSpacing)
  love.graphics.draw(resources.images.elements['LIGHTNING'], panelX, panelY, 0, elementScale, elementScale)

  panelX = panelX + (elementSize + panelSpacing)
  love.graphics.draw(resources.images.elements['DARK'], panelX, panelY, 0, elementScale, elementScale)

  panelX = panelX + (elementSize + panelSpacing)
  love.graphics.draw(resources.images.elements['EARTH'], panelX, panelY, 0, elementScale, elementScale)

  panelX = panelX + (elementSize + panelSpacing)
  love.graphics.draw(resources.images.elements['FIRE'], panelX, panelY, 0, elementScale, elementScale)
end

function Hud:drawHudBorder()
  love.graphics.setColor(32, 32, 32, 128)
  love.graphics.setLineWidth(borderWidth)

  local posX, posY = borderWidth/2, borderWidth/2
  love.graphics.rectangle('line', posX, posY, gWidth-borderWidth, gHeight-borderWidth)
end

function Hud:draw()
  love.graphics.setBlendMode('alpha')

  if Hud.textConsole.visible then
    love.graphics.setColor(0, 0, 0, 192)
    local w = resources.UI.textbox:getWidth()
    local h = resources.UI.textbox:getHeight()

    local x = (love.graphics.getWidth() * 0.2) - w / 2
    local y = (love.graphics.getHeight() * 0.8) - h / 2
    posX, posY = x, y

    love.graphics.rectangle('fill', posX, posY, w, h)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(resources.UI.textbox, posX, posY)

    local padding = Hud.textConsole.textPadding
    love.graphics.setColor(255, 255, 255, 191)

    love.graphics.setFont(Hud.textConsole.titleFont)
    love.graphics.print(Hud.textConsole.title, posX + padding, posY + padding)

    love.graphics.setFont(Hud.textConsole.font)

    for i = 0, #Hud.textConsole.text do
      love.graphics.print(Hud.textConsole.text[i], posX + padding, posY + padding + 40 + (i * Hud.textConsole.fontSize))
    end
  end

  Hud:drawElements()
  Hud:drawHudBorder()

end
