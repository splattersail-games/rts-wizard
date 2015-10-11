-- The game world
local LightWorld = require "lib"
local bump = require 'src.libs.bump'

require 'src.Entities'
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

    -- create collisions world
    self.bump = bump.newWorld(128)

	self:loadWorld(level)
	--self.gridIncrement = 5
end

function World:unload()
	Entities:unload()
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
				Entities:loadAll(layer.objects)
			end
		end
	end
end

function World:update(dt)
	World.lightWorld:update(dt)
	-- self.gridScale = self.gridScale + (dt* self.gridIncrement)
	-- if self.gridScale >= 32 then
	-- 	self.gridIncrement = self.gridIncrement * -1
	-- end
	-- self.gridSquareWidth = self.width/self.gridScale
	-- self.gridSquareHeight = self.height/self.gridScale
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

	-- if Game.drawAABBs then
	-- 	local items, len = World.bump:getItems()
	-- 	for _, item in pairs(items) do
	-- 		local x, y, w, h = World.bump:getRect(item)
	-- 		love.graphics.setColor(255, 255, 255)
	-- 		love.graphics.rectangle('fill', x, y, w, h)
	-- 	end
	-- end

	-- love.graphics.setLineWidth(0.5)
	-- for row = 0, self.gridHeight do
	-- 	local offset = row*self.gridScale
	-- 	love.graphics.line(0, offset, self.width, offset)
	-- end

	-- for col = 0, self.gridWidth do
	-- 	local offset = col*self.gridScale
	-- 	love.graphics.line(offset, 0, offset, self.height)
	-- end
	love.graphics.setColor({ 255, 255, 255})
end