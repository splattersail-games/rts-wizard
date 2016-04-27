local vector = require 'src.utils.vector'
Shader = {}

-- the color and intensity of each pixel is affected by it's distance from the
-- light, it's color and magnitude
-- Copy of old
local pixelcode = [[
	extern number lightRadius;
	extern number lightIntensity;
	extern vec2 lightPos;
	extern vec3 lightColor;

	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
	{
		number distance = length(lightPos - screen_coords.xy);
		number intensity = 1.0 - min(distance, lightRadius) / lightRadius;
		return vec4(intensity, intensity, intensity, intensity * lightIntensity) * vec4(lightColor, 1.0);
	}
]]

-- the color and intensity of each pixel is affected by it's distance from the
-- light, it's color and magnitude
-- local pixelcode = [[
-- 	#define M_PI 3.1415926535897932384626433832795
-- 	extern number lightRadius;
-- 	extern vec2 lightPos;
-- 	extern vec3 lightColor;

-- 	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
-- 	{
-- 		number distance = length(lightPos - screen_coords.xy);
-- 		number intensity = 1.0 - min(distance, lightRadius) / lightRadius;
-- 		return color * vec4(lightColor, 1.0) * vec4(intensity, intensity, intensity, intensity) * 2 * M_PI / (distance * distance);
-- 	}
-- ]]

local shader = love.graphics.newShader(pixelcode)
function Shader:drawLights(shadowCasters, lights, worldWidth, worldHeight)
	-- additive blending is used so that the effect all lights are blended together
	local lg, lp = love.graphics, love.physics
	lg.setBlendMode('additive')

	-- The below didn't work, commented out to keep the train of thought
	-- Fog of war
	-- lg.setStencil(function()
	-- 	for b = 0, shadowCasters.size-1 do
	-- 		love.graphics.circle( "fill", shadowCasters[b]:getX(), shadowCasters[b]:getY(), 700, 100 )
	-- 	end
	-- end)

	for k, light in pairs(lights) do
		lg.setColorMask(false, false, false, false)
		lg.setInvertedStencil(function()
			for id = 0, shadowCasters.size-1 do
				local shadowCaster = shadowCasters[id]
				id = id + 1

				if shadowCaster:canCastShadows() then
					--local vertices = { block.b:getWorldPoints(block.s:getPoints()) }
					local vertices = { shadowCaster:getPoints() }

					for i = 1, #vertices, 2 do
						if light.drawShadows then

							local cv = vector(vertices[i], vertices[i + 1])
							local nv
							if i + 2 > #vertices then
								nv = vector(vertices[1], vertices[2])
							else
							    nv = vector(vertices[i + 2], vertices[i + 3])
							end

							local edge = nv - cv
							local lightToVertex = vector(cv.x - light:getX(), cv.y - light:getY())
							local edgeNormal = vector(edge.y, -edge.x)

							if edgeNormal * lightToVertex > 0 then

								local shadow

								shadow = lightToVertex
								local p1 = cv + (shadow * 100)

								shadow = vector(nv.x - light:getX(), nv.y - light:getY())
								local p2 = nv + (shadow * 100)

								lg.polygon('fill', cv.x, cv.y, p1.x, p1.y, p2.x, p2.y, nv.x, nv.y)
							end
						end
					end
				end
			end
		end)
		lg.setColorMask(true, true, true, true)

		lg.setShader(shader)
		local lx, ly = camera:scalePointToCamera(light:getX(), light:getY())
		-- draw the light
		shader:send('lightRadius', light.radius)
		shader:send('lightPos', { lx, lg.getHeight() - ly })
		shader:send('lightColor', light.colour)
		shader:send('lightIntensity', light.intensity)

		-- draw a rectangle over the entire screen (or light area only) for the
		-- shader to run
		lg.setColor(255, 255, 255, 255)
		lg.rectangle('fill', 0, 0, worldWidth, worldHeight)

		-- remove the shader
		lg.setShader()
	end -- for every light
	lg.setShader()

	-- geometry

	lg.setInvertedStencil()
	-- set the blend mode to multiplicative to multiply future drawing by the
	-- accumulated light mask
	lg.setBlendMode('multiplicative')
end