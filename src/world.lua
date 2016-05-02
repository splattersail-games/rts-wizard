-- The game world
local LightWorld = require "lib/light_world/lib"
local bump = require 'lib.bump'
require 'src.utils.BoundingBox'

JSON = require 'lib.JSON'
World = {}

-- Entity Component System
World.engine = nil

-- Lighting
World.lightWorld = nil

-- Collisions
World.bump = nil

--[[
  Load a level
]]
function World:load(level)
  LOG.setScope("Loading World", LOG.logLevel.DEBUG) -- Print logs greater or equal to debug severity

  LOG.debug("Initializing world")
  LOG.debug("Initialising lightworld")
  -- Initialise light world
  self.lightWorld = LightWorld({
      ambient = {30, 30, 30}, --the general ambient light in the environment
      refractionStrength = 16.0,
      reflectionVisibility = 0.75
    })

  -- Initialise ECS
  LOG.setScope("Initialising ECS", LOG.logLevel.DEBUG)
  LOG.debug("Starting. . . ")
  self.engine = Engine()
  self.eventManager = EventManager()

  -- Initialise Systems
  local moveAction = PushMoveCommand()
  self.engine:addSystem(moveAction, "logic")
  self.engine:stopSystem(moveAction)
  self.eventManager:addListener("MousePressed", moveAction, moveAction.fireEvent)

  local moveSystem = MoveSystem()
  self.engine:addSystem(moveSystem, "update")
  self.engine:addSystem(ParentPositionOffsetSystem(), "update")

  -- Add Draw Systems
  self.engine:addSystem(DrawImageSystem(), "draw")
  self.engine:addSystem(DrawLivingEntity(), "draw")
  LOG.debug("Done.")
  LOG.debug("Systems: " .. #self.engine.systems["all"])
  LOG.debug("Update Systems: " .. #self.engine.systems["update"])
  LOG.endScope()

  LOG.debug("Initialising bump world")
  -- Initialise collisions world
  self.bump = bump.newWorld(128)

  LOG.debug("Loading a map")
  -- Load up a map
  self:loadWorld(level)
  LOG.endScope()
end

--[[
  Unload a level
]]
function World:unload()
  --Entities:unload()
end

function World:loadWorld(worldFile)
  local worldObj = JSON:decode(worldFile)
  if worldObj.properties.name ~= nil then
    LOG.debug("Loaded " .. worldObj.properties.name .. " v" .. worldObj.version)
  end
  self.gridScale = worldObj.tilewidth
  self.gridWidth = worldObj.width
  self.gridHeight = worldObj.height
  self.width = worldObj.tilewidth * worldObj.width
  self.height = worldObj.tileheight * worldObj.height

  World.layers = worldObj.layers

  for _, layer in pairs(World.layers) do

    if layer.visible then
      LOG.debug("Loading " .. layer.name)
      if layer.type == "imagelayer" and layer.visible then
        LOG.debug("Caching image: " .. layer.name)
        layer.loveImage = love.graphics.newImage( layer.properties.path )
      elseif layer.type == "objectgroup" and layer.visible then
        World:loadEntities(layer.objects)
      end
    end
  end
end

function World:loadEntities(entities)
  LOG.setScope("Read Entities", LOG.logLevel.DEBUG)
  for _, entity in pairs(entities) do
    if entity.type == "wall" then
      local w, h = entity.width, entity.height
      local x, y =
      entity.x + (w / 2),
      entity.y + (h / 2)

      local toAdd = Entity()
      toAdd:add(Position(x, y))
      toAdd:add(Collidable(BoundingBox:new(
            x - (w / 2),
            y - (h / 2),
            x + (w / 2),
            y + (h / 2)
      )))
      self.bump:add(toAdd, entity.x, entity.y, w, h)
      self.engine:addEntity(toAdd)
      self.lightWorld:newRectangle(
        x,
        y,
        entity.width,
        entity.height
      )
      --self:addWall(x, y, entity.width, entity.height)
    elseif entity.type == "light" then
      LOG.debug("Reading a light " .. entity.properties.r)
      local color = {
        r = tonumber(entity.properties.r),
        g = tonumber(entity.properties.g),
        b = tonumber(entity.properties.b)
      }
      local toAdd = Entity()
      toAdd:add(Position(entity.x, entity.y))
      toAdd:add(Light(
          color,
          tonumber(entity.properties.radius),
          tonumber(entity.properties.intensity)
      ))
      self.engine:addEntity(toAdd)

      light = self.lightWorld:newLight(
        entity.x, entity.y, color.r, color.g, color.b, toAdd:get("Light").radius)
      if toAdd:get("Light").intensity ~= nil then
        light:setGlowStrength(toAdd:get("Light").intensity)
      end

    elseif entity.type == "player" then
      --self:addPlayer(entity.x, entity.y, entity.width, entity.height)
      local player = Entity()
      player.name = "Tattersail"
      local text = love.graphics.newText(resources.fonts.default.medium, player.name)
      resources.textCache.currentWorld[player.name] = text
      local x, y = entity.x, entity.y
      local w, h = entity.width, entity.height
      local pos = Position(x, y)
      player:add(pos)

      local collisionsComponent = Collidable(
        BoundingBox:new(
          x - (w / 2),
          y - (h / 2),
          x + (w / 2),
          y + (h / 2)
        )
      )
      player:add(collisionsComponent)
      local b = collisionsComponent.AABB
      self.bump:add(player, b.x1, b.y1, b.width, b.height)

      local playerImage = love.graphics.newImage( "resources/spritesheets/basick.png" )
      player:add(Drawable(
          playerImage,
          0,
          0.7, -- scale
          0.7,
          playerImage:getWidth() / 2, -- offset
          playerImage:getHeight() / 2
      ))
      player:add(Moveable(
          nil, nil, nil
      ))
      player:add(Player())

      -- Create a light, and attach it to the player
      local color = {r = 90, g = 90, b = 90}
      local theLight = World.lightWorld:newLight(pos.x, pos.y, color.r, color.g, color.b, 300)
      theLight:setGlowStrength(0.4)
      local lightComponent = Light(theLight)
      local attachmentComponent = ParentPositionOffset(0, 0)
      local positionComponent = Position(pos.x, pos.y)
      local lightEntity = Entity()
      lightEntity:add(lightComponent)
      lightEntity:add(attachmentComponent)
      lightEntity:add(positionComponent)
      lightEntity:setParent(player)
      self.engine:addEntity(player)
      self.engine:addEntity(lightEntity)
    elseif entity.type == "camera_location" then
      local toAdd = Entity()
      local x, y = entity.x, entity.y
      toAdd:add(Position(x, y))
      toAdd:add(IsCamera())
      self.engine:addEntity(toAdd)
    end
  end
  LOG.endScope()
end

function World:update(dt)
  World.engine:update(dt)
  World.lightWorld:update(dt)
end

function World:nRandomLights(n)
  for i = 1, n do
    Entities:addLight(
      love.math.random(0, self.width), love.math.random(0, self.height),
      love.math.random(300, 500),
      {
        r = (love.math.random() * 255),
        g = (love.math.random() * 255),
        b = (love.math.random() * 255)
      },
      love.math.random()
    )
  end
end

function World:draw()
  love.graphics.setColor(255, 255, 255)

  -- Migrate to system
  love.graphics.rectangle("fill", 0, 0, self.width, self.height)
  for _, layer in pairs(World.layers) do
    if layer.type == "imagelayer" and layer.loveImage ~= nil then
      love.graphics.draw(layer.loveImage, layer.x, layer.y)
    end
  end

  -- Migrate to system
  if Game.drawAABBs then
    local items, len = World.bump:getItems()
    for _, item in pairs(items) do
      local x, y, w, h = World.bump:getRect(item)
      love.graphics.setColor(255, 255, 255)
      love.graphics.rectangle('fill', x, y, w, h)
    end
  end

  World.engine:draw({ group = 'world' })

  love.graphics.setColor(255, 255, 255)
end
