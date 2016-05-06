local resources = {}

function resources:init()
  resources.icon = love.graphics.newImage("resources/spritesheets/basick.png")
  resources.wafer = love.graphics.newImage("resources/spritesheets/wafer.png")

  resources.UI = {}
  resources.UI.textbox = love.graphics.newImage("resources/ui/textbox.png")

  resources.images = {
    elements = {
      RGB = {
        WATER     = { 30, 30, 255 },
        FIRE      = { 255, 128, 51 },
        SHIELD    = { 255, 255, 0 },
        COLD      = { 220, 220, 255 },
        LIGHTNING = { 255, 20, 147 },
        DARK      = { 128, 0, 0 },
        LIGHT     = { 0, 255, 0 },
        EARTH     = { 90, 90, 90 }
      }
    },
    ward = {}
  }

  resources.images.ward.innerAlpha = love.graphics.newImage("resources/images/wards/inner_alpha.png")
  resources.images.ward.outerAlpha = love.graphics.newImage("resources/images/wards/outer_alpha.png")
  resources.images.ward.inner = {}
  resources.images.ward.outer = {}
  resources.images.ward.scale = 0.5
  resources.images.ward.width = resources.images.ward.innerAlpha:getWidth() * resources.images.ward.scale
  resources.images.ward.offset = resources.images.ward.width / 2

  for element, v in pairs(Game.elements) do
    -- Cache image in both string an integer keys for convenience
    resources.images.elements[element] = love.graphics.newImage("resources/images/elements/" .. string.lower(element) .. ".png")
    resources.images.elements[v] = resources.images.elements[element]

    local w, h =
      resources.images.ward.width,
      resources.images.ward.width
    local innerCanvas = love.graphics.newCanvas(w, h)
    innerCanvas:renderTo(function()
      love.graphics.setBlendMode("alpha")
      love.graphics.setColor(255, 255, 255)
      love.graphics.draw(resources.images.ward.innerAlpha, 0, 0, 0, resources.images.ward.scale)
      love.graphics.setBlendMode("multiply")
      love.graphics.setColor(resources.images.elements.RGB[element])
      love.graphics.rectangle("fill", 0, 0, w, h)
    end)
    resources.images.ward.inner[element] = innerCanvas
    resources.images.ward.inner[v] = resources.images.ward.inner[element]

    local outerCanvas = love.graphics.newCanvas(w, h)
    outerCanvas:renderTo(function()
      love.graphics.setBlendMode("alpha")
      love.graphics.setColor(255, 255, 255)
      love.graphics.draw(resources.images.ward.outerAlpha, 0, 0, 0, resources.images.ward.scale)
      love.graphics.setBlendMode("multiply")
      love.graphics.setColor(resources.images.elements.RGB[element])
      love.graphics.rectangle("fill", 0, 0, w, h)
    end)
    love.graphics.setBlendMode("alpha")

    resources.images.ward.outer[element] = outerCanvas
    resources.images.ward.outer[v] = resources.images.ward.outer[element]
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

return resources
