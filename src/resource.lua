resources = {}
local elements = require 'src.game.elements'

function resources:init()
  resources.icon = love.graphics.newImage("resources/spritesheets/basick.png")
  resources.wafer = love.graphics.newImage("resources/spritesheets/wafer.png")

  resources.UI = {}
  resources.UI.textbox = love.graphics.newImage("resources/ui/textbox.png")

  resources.images = {
    elements = {}
  }
  for element, _ in pairs(elements) do
    resources.images.elements[element] = love.graphics.newImage("resources/spritesheets/elements/" .. string.lower(element) .. ".png")
  end

  resources.items = {}
  resources.items.pickaxe = love.graphics.newImage("resources/items/pickaxe.png")

  -- Declare fonts used by the game
  resources.fonts = {}
  resources.fonts.default = {
    title = love.graphics.newFont("resources/ui/fonts/Timeless.ttf", 18),
    medium = love.graphics.newFont("resources/ui/fonts/GeosansLight.ttf", 16),
    size14 = love.graphics.newFont(14)
  }

  -- Text Resource cache
  resources.textCache = {
    -- World level cache that we can nuke when we're done with a map
    currentWorld = {}
  }
end
