
resources = {}

function resources:init()
	resources.UI = {}
	resources.UI.textbox = love.graphics.newImage("resources/ui/textbox.png")

	resources.items = {}
	resources.items.pickaxe = love.graphics.newImage("resources/items/pickaxe.png")
end