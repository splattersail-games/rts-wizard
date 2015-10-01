require 'src.entities.Entity'
require 'src.entities.MoveableEntity'
require 'src.entities.Light'
require 'src.entities.Wall'
require 'src.entities.CameraLocation'

require 'src.entities.units.BaseUnit'
require 'src.entities.units.Player'

Entities = {}
Entities.size = 0

-- Key value pairs using the same ID
Entities.GameObjects = {} 
Entities.Lights = {}
Entities.Enemies = {}
Entities.Player = nil
Entities.PlayerControlled = {}
Entities.toAdd = {}
Entities.camerasByName = {}

function Entities:unload()
    Entities.size = 0

    -- Key value pairs using the same ID
    Entities.GameObjects = {} 
    Entities.Lights = {}
    Entities.Enemies = {}
    Entities.Player = nil
    Entities.PlayerControlled = {}
    Entities.toAdd = {}
    Entities.camerasByName = {}
end

function Entities:loadAll(entities)
	--World:nRandomLights(20)
	for _, entity in pairs(entities) do
		print ("Adding a " .. entity.type)
		if entity.type == "wall" then
            local x, y = 
                entity.x + (entity.width / 2), 
                entity.y + (entity.height / 2)
			self:addWall(x, y, entity.width, entity.height)
		elseif entity.type == "light" then
            print ("Reading a light " .. entity.properties.r)
			local color = { 
				r = tonumber(entity.properties.r), 
				g = tonumber(entity.properties.g),
				b = tonumber(entity.properties.b)
			}
			self:addLight(entity.x, entity.y, tonumber(entity.properties.radius), color, tonumber(entity.properties.intensity))
		elseif entity.type == "player" then
			print (" Player color: " .. entity.properties.r .. " " .. entity.properties.g .. " " .. entity.properties.b)
			local color = { 
				r = tonumber(entity.properties.r),
				g = tonumber(entity.properties.g),
				b = tonumber(entity.properties.b)
			}
			print (
				"Adding the player at [" .. entity.x .. ", " .. entity.y .. "] " ..
				"\n---- Width: " .. entity.width .. "\n---- Height: " .. entity.height ..
				"\n---- RGB: (" .. color.r .. ", " .. color.g .. ", " .. color.b .. ")\n"
			)
			self:addPlayer(entity.x, entity.y, entity.width, entity.height, 'fill', color)
		elseif entity.type == "camera_location" then
            self:addCamera(entity)
        end
	end
end

function Entities:update(dt)
    self.isUpdating = true

    for e = 0, (Entities.size-1) do
        self[e]:update(dt)
    end

    self.isUpdating = false
end

function Entities:draw()
	--love.graphics.setBlendMode('alpha')
	for e = 0, (Entities.size-1) do
		self[e]:draw()
	end
end

function Entities.isColliding(ent1, ent2)
    radius = ent1.collisionRadius + ent2.collisionRadius
    return ent1.origin:dist(ent2.origin) < (radius)
end

function Entities:add(entity) 
    if not self.isUpdating then
        self:addEntity(entity)
    else
        table.insert(self.toAdd, entity)
    end
end

-- Intended to be private
function Entities:addEntity(entity)
    local id = self.size
    entity.id = id
    self[id] = entity
    if entity:isInstanceOf(Player) then
    	self.Player = entity
        self.PlayerControlled[id] = entity
    elseif entity:isInstanceOf(Light) then
        self.Lights[id] = entity
	elseif entity:isInstanceOf(BaseEnemy) then
    	self.Enemies[id] = entity
    else
    	self.GameObjects[id] = entity
    end

    if entity:isInstanceOf(CameraLocation) then
        self.camerasByName[entity.name] = entity
    end

    assert(entity.boundingBox.width ~= nil and entity.boundingBox.height ~= nil, 'Entity had blank bounding box. Do you think this is a fucking game?')
    
    local x, y, w, h = entity:getCollisionInfo()
    World.bump:add(entity, x, y, w, h)

    self.size = self.size + 1 
end

function Entities:addWall(x, y, width, height)
	local toAdd = Wall:new(x, y, width, height)
    World.lightWorld:newRectangle(x, y, width, height)
	Entities:add(toAdd)
end

function Entities:addSquare(x, y, width, height, mode, colorTable)
	local toAdd = Square:new(x, y, width, height, mode, colorTable)
    World.lightWorld:newRectangle(x, y, width, height)
	toAdd:addLight(700, { r = 220,  g = 220,  b = 220})
	Entities:add(toAdd)
end

function Entities:addPlayer(x, y, width, height, mode, colorTable)
    local toAdd = Player:new(x, y, width, height, mode, colorTable)
	toAdd:addLight(300, {r = 220, g = 120, b = 120})
	Entities:add(toAdd)
end

function Entities:addCamera(entity)
    local toAdd = CameraLocation:new(entity.x, entity.y, entity.name)
    Entities:add(toAdd)
end

function Entities:getObjectPosition(objId)
	return self[objId]:getX(), self[objId]:getY()
end

function Entities:addLight(x, y, radius, colour, intensity)
    print (colour.r .. " " .. colour.g .. " " .. colour.b)
    light = World.lightWorld:newLight(x, y, colour.r, colour.g, colour.b, radius)
	if intensity ~= nil then 
		light:setGlowStrength(intensity)
	end
end