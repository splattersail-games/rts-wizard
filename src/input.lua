
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
	if button == 'l' then
		Input.__mouse1Pressed = true
	elseif button == 'r' then
	    Input.__mouse2Pressed = true
	end

	loveframes.mousepressed(x, y, button)
end

function Input.mousereleased(x, y, button)
	x, y = camera:scalePoint(x, y)
	Input.__lastMouseReleasePoint = { x = x, y = y }
	if button == 'l' then
		Input.__mouse1Released = true
	elseif button == 'r' then
		Input.__mouse2Released = true
	end

	loveframes.mousereleased(x, y, button)
end

function Input.keypressed( key, unicode )
	print(key .. " pressed")
	Input.__keysPressed[key] = true

	loveframes.keypressed(key, unicode)
end

function Input.keyreleased( key, unicode )
	print(key .. " released")
   	Input.__keysReleased[key] = true

   	loveframes.keyreleased(key)
end

-------------- Functions to do stuff. These are called from controller and passed stuff
function Input:mouse1Pressed(x, y)
	Hud:startSelectionBox(x, y)
	Game:checkForSelect(x, y)

	Input.__mouse1Pressed = false
end

function Input:mouse1Released(x, y)
	Hud:endSelectionBox(x, y)
	Game:checkForSelectInBox()

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



