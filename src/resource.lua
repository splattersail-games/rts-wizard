resources = {}

function resources:init()
  resources.icon = love.graphics.newImage("resources/spritesheets/pixeli.png")
  resources.wafer = love.graphics.newImage("resources/spritesheets/wafer.png")

  resources.UI = {}
  resources.UI.textbox = love.graphics.newImage("resources/ui/textbox.png")

  resources.items = {}
  resources.items.pickaxe = love.graphics.newImage("resources/items/pickaxe.png")
end
