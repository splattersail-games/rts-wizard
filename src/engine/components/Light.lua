Light = Component.create("Light")

function Light:initialize(rgb, radius, intensity)
	self.colour = { r = 0, g = 0, b = 0 }
	self.colour = rgb
	self.radius = radius
	self.intensity = intensity
end