--[[
Draws a spell caster's queued elements
A spellcaster should have a position, otherwise we don't know where to put the icons
]]
DrawQueuedElementIcons = class("DrawQueuedElementIcons", System)

function DrawQueuedElementIcons:initialize()
  System.initialize(self)
  self.group = 'camera_overlay'
  self.elementScale = 0.4
  self.elementSize = resources.images.elements["WATER"]:getWidth() * self.elementScale
  self.elementPadding = 2
  self.elementRowWidth = (self.elementPadding * 4) + (self.elementSize * 3)
end

function DrawQueuedElementIcons:draw()
  --[[
  Get the current blend mode so that we can give it back after we are done.
  Then draw a spell caster's queued elements.
  ]]
  local previousBlendMode = love.graphics.getBlendMode()
  love.graphics.setBlendMode('alpha')

  for id, entity in pairs(self.targets) do
    local positionComponent = entity:get("Position")
    local spellCasterComponent = entity:get("SpellCaster")

    if positionComponent.x and positionComponent.y then
      local posX = positionComponent.x
      local posY = positionComponent.y + 50
      -- [padding][el][padding][el][padding][el][padding]

      posX = posX - (self.elementRowWidth / 2) + self.elementPadding

      local els = spellCasterComponent.spell.elements
      local index = els.first
      local element = els[index]
      while element do
        love.graphics.draw(resources.images.elements[element], posX, posY, 0, self.elementScale, self.elementScale)
        posX = posX + self.elementSize + self.elementPadding

        index = index + 1
        element = els[index]
      end
    end
  end
  love.graphics.setBlendMode(previousBlendMode)
end

function DrawQueuedElementIcons:requires()
  return {"SpellCaster", "Position"}
end
