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
local cgSquareSize
local cgContainerWidth
local cgContainerHeight
local controlGroupViewX
local controlGroupViewY

function Hud:init()
  gWidth, gHeight = love.graphics.getWidth(), love.graphics.getHeight()
  borderWidth = 10
  panelSpacing = 5
  cgSquareSize = 32
  cgContainerWidth = (cgSquareSize * 10) + (panelSpacing * 11)
  cgContainerHeight = cgSquareSize + (0.25 * cgSquareSize)
  controlGroupViewX = math.floor((gWidth - cgContainerWidth) / 2)
  controlGroupViewY = gHeight - math.floor(cgContainerHeight) - borderWidth

  Hud.textConsole.font = love.graphics.newFont("resources/ui/fonts/GeosansLight.ttf", Hud.textConsole.fontSize)
  Hud.textConsole.titleFont = love.graphics.newFont("resources/ui/fonts/Timeless.ttf", 18)

  Hud.textConsole.text[0] = "Welcome to the dungeon"
  Hud.textConsole.text[1] = ". . . "
  Hud.textConsole.text[2] = "Now, fuck off!"
end


function Hud:update(dt)
end

-- draws a box for each control group at the bottom of the screen
function Hud:drawControlGroupView()

  local startX, startY = controlGroupViewX, controlGroupViewY
  love.graphics.setColor(32, 32, 32, 100)
  love.graphics.rectangle('fill', startX, startY, cgContainerWidth, cgContainerHeight)

  for cGroup = 0, 9 do
    panelX = startX + panelSpacing + (cGroup * (panelSpacing + cgSquareSize))
    panelY = startY + panelSpacing

    love.graphics.setColor(20, 20, 20, 255)
    love.graphics.rectangle('line', panelX, panelY, cgSquareSize, cgSquareSize)

    if cGroup == 0 then
      love.graphics.setColor(255, 255, 255)
      love.graphics.rectangle('fill', panelX, panelY, cgSquareSize, cgSquareSize)
      love.graphics.setColor(255, 255, 255)
      love.graphics.setBlendMode("alpha")
      love.graphics.draw(resources.items.pickaxe, panelX, panelY, 0, 2, 2)
    else
      love.graphics.setColor(255, 255, 255, 32)
      love.graphics.rectangle('fill', panelX, panelY, cgSquareSize, cgSquareSize)
      love.graphics.setColor(20, 20, 20, 255)
    end
    cGroup = cGroup + 1
    if cGroup == 10 then cGroup = 0 end
    love.graphics.print(tostring(cGroup), panelX + 2, panelY + 2)

    love.graphics.setColor(20, 20, 20, 192)
  end
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

  Hud:drawControlGroupView()
  Hud:drawHudBorder()

end
