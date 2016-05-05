require 'src.utils/camera'
Input = {
  __mousePressed = {},
  __mouseReleased = {},
  __keysPressed = {},
  __keysReleased = {},
  __lastMouseClickPoint = {},
  __lastMouseClickPoint = {}
}

-------------- Love callbacks
function Input.mousepressed(x, y, button)
  x, y = camera:scalePoint(x, y)
  Input.__lastMouseClickPoint = { x = x, y = y }
  Input.__mousePressed[button] = true
end

function Input.mousereleased(x, y, button)
  if x and y then
    x, y = camera:scalePoint(x, y)
    Input.__lastMouseReleasePoint = { x = x, y = y }
  end
  Input.__mouseReleased[button] = true
end

function Input.keypressed( key, unicode )
  Input.__keysPressed[key] = true
end

function Input.keyreleased( key, unicode )
  Input.__keysReleased[key] = true
end

function Input:mousepressHandled(button, x, y)
  Input.__mousePressed[button] = false
end

function Input:mousereleaseHandled(button, x, y)
  Input.__mouseReleased[button] = false
end

function Input:keypressHandled( key )
  Input.__keysPressed[key] = false
end

function Input:keyreleaseHandled( key )
  Input.__keysReleased[key] = false
end

