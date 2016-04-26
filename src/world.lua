-- The game world
local LightWorld = require "lib"
local bump = require 'src.libs.bump'

--require 'src.Entities'
JSON = require 'src.libs.JSON'
World = {}
World.engine = nil

function World:load(level)
    print("Initializing world\n..................\n.................")

    -- create light world
    self.lightWorld = LightWorld({
        ambient = {0, 0, 0},  --the general ambient light in the environment
        refractionStrength = 16.0,
        reflectionVisibility = 0.75
    })

    self.engine = Engine()
    self.eventManager = EventManager()

    local selectionSystem = SelectUnits()
    self.engine:addSystem(selectionSystem, "logic")
    self.engine:stopSystem(selectionSystem) -- Call this only when the event fires

    self.eventManager:addListener("SelectionBoxReleased", selectionSystem, selectionSystem.fireEvent)

    self.engine:addSystem(DrawSelectedSystem())
    self.engine:addSystem(DrawImageSystem())
    print("Systems: " .. #self.engine.systems["all"])
    -- create collisions world
    self.bump = bump.newWorld(128)

    self:loadWorld(level)
    --self.gridIncrement = 5
end

function World:unload()
    --Entities:unload()
end

function World:loadWorld(worldFile)
    local worldObj = JSON:decode(worldFile)
    if worldObj.properties.name ~= nil then
        print ("Loaded " .. worldObj.properties.name .. " v" .. worldObj.version)
    end
    self.gridScale = worldObj.tilewidth
    self.gridWidth = worldObj.width
    self.gridHeight = worldObj.height
    self.width = worldObj.tilewidth * worldObj.width
    self.height = worldObj.tileheight * worldObj.height

    World.layers = worldObj.layers

    for _, layer in pairs(World.layers) do

        if layer.visible then 
            print("Loading " .. layer.name)
            if layer.type == "imagelayer" and layer.visible then
                print ("Caching image: " .. layer.name)
                layer.loveImage = love.graphics.newImage( layer.properties.path )
                --World.lightWorld:newImage(layer.loveImage, 0, 0)
            elseif layer.type == "objectgroup" and layer.visible then
                World:loadEntities(layer.objects)
            end
        end
    end
end

function World:loadEntities(entities)
    for _, entity in pairs(entities) do
        print ("Adding a " .. entity.type)
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
            self.engine:addEntity(toAdd)
            self.lightWorld:newRectangle(
                x,
                y,
                entity.width, 
                entity.height
            )
            --self:addWall(x, y, entity.width, entity.height)
        elseif entity.type == "light" then
            print ("Reading a light " .. entity.properties.r)
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
            local toAdd = Entity()
            local x, y = entity.x, entity.y
            local w, h = entity.width, entity.height
            toAdd:add(Position(x, y))
            toAdd:add(Collidable(
                BoundingBox:new(
                    x - (w / 2), 
                    y - (h / 2),
                    x + (w / 2),
                    y + (h / 2)
                )
            ))

            local playerImage = love.graphics.newImage( "resources/spritesheets/pixeli.png" ) 
            toAdd:add(Drawable(
                playerImage,
                0,
                1.0, -- scale
                1.0,
                playerImage:getWidth() / 2, -- offset
                playerImage:getHeight() / 2
            ))
            toAdd:add(PlayerControlled())
            toAdd.name = 'Player'

            local color = {r = 220, g = 120, b = 120} 
            toAdd:add(Light(
                color, 
                300, 
                0.4
            ))
            local light = World.lightWorld:newLight(x, y, color.r, color.g, color.b, 300)
            light:setGlowStrength(0.4)

            self.engine:addEntity(toAdd)
        elseif entity.type == "camera_location" then
            local toAdd = Entity()
            local x, y = entity.x, entity.y
            toAdd:add(Position(x, y))
            toAdd:add(IsCamera())
            self.engine:addEntity(toAdd)
        end
    end
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
    love.graphics.rectangle("fill", 0, 0, self.width, self.height)
    for _, layer in pairs(World.layers) do
        if layer.type == "imagelayer" and layer.loveImage ~= nil then
            love.graphics.draw(layer.loveImage, layer.x, layer.y)
        end
    end

    World.engine:draw()

    -- if Game.drawAABBs then
    --  local items, len = World.bump:getItems()
    --  for _, item in pairs(items) do
    --      local x, y, w, h = World.bump:getRect(item)
    --      love.graphics.setColor(255, 255, 255)
    --      love.graphics.rectangle('fill', x, y, w, h)
    --  end
    -- end

    -- love.graphics.setLineWidth(0.5)
    -- for row = 0, self.gridHeight do
    --  local offset = row*self.gridScale
    --  love.graphics.line(0, offset, self.width, offset)
    -- end

    -- for col = 0, self.gridWidth do
    --  local offset = col*self.gridScale
    --  love.graphics.line(offset, 0, offset, self.height)
    -- end
    love.graphics.setColor({ 255, 255, 255})
end