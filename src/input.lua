
require 'src.utils/camera'
Input = {
	__mouse1Pressed,
	__mouse2Pressed,
	__mouse1Released,
	__mouse2Released,
	__keysPressed = {},
	__keysReleased = {}
}

-------------- Love callbacks
function Input.mousepressed(x, y, button)
	x, y = camera:scalePoint(x, y)
	Input.__lastMouseClickPoint = { x = x, y = y }
	if button == 1 then
		Input.__mouse1Pressed = true
	elseif button == 2 then
	    Input.__mouse2Pressed = true
	end
end

function Input.mousereleased(x, y, button)
	x, y = camera:scalePoint(x, y)
	Input.__lastMouseReleasePoint = { x = x, y = y }
	if button == 1 then
		Input.__mouse1Released = true
	elseif button == 2 then
		Input.__mouse2Released = true
	end
end

function Input.keypressed( key, unicode )
	print(key .. " pressed")
	Input.__keysPressed[key] = true
end

function Input.keyreleased( key, unicode )
	print(key .. " released")
   	Input.__keysReleased[key] = true
end

-------------- Functions to do stuff. These are called from controller and passed stuff
function Input:mouse1Pressed(x, y)
	Hud:startSelectionBox(x, y)
	Game:checkForSelect(x, y)

	Input.__mouse1Pressed = false
end

function Input:mouse1Released(x, y)
	Hud:endSelectionBox(x, y)

	if Hud.selectionBox.rectangle then
		local x1, y1, x2, y2 =
			Hud.selectionBox.rectangle.x1,
			Hud.selectionBox.rectangle.y1,
			Hud.selectionBox.rectangle.x2,
			Hud.selectionBox.rectangle.y2

		if x1 and y1 and x2 and y2 then
			x1, y1 = camera:scalePoint(x1, y1)
			x2, y2 = camera:scalePoint(x2, y2)
			local rectangle = BoundingBox(
				x1, y1,
				x2, y2
			)
			print("Firing selection box event")
			Game:fireEvent(SelectionBoxReleased(
				rectangle
			))
		end
	end

	Input.__mouse1Released = false
end

function Input:mouse2Pressed(x, y)
	Game:moveCommand(x, y)

	Input.__mouse2Pressed = false
end

function Input:mouse2Released(x, y)

	Input.__mouse2Released = true
end

function Input:keypressHandled( key )
	Input.__keysPressed[key] = false
end

function Input:keyreleaseHandled( key )
   	Input.__keysReleased[key] = false
end



