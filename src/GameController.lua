require 'src.input'

GameController = {}
GameController.lastKeyboardInput = 0 -- time of last successful keyboard action, for example adding to control group
GameController.currTime = 0
GameController.keyPresses = {
	
} -- map from key to last time it was pressed
GameController.lastControlGroupRecall = {
	controlGroup = -1,
	time = -1,
	centered = false
}

GameController.keyToAction = {
	s = function(dt) Game:StopCommand() end
}

function GameController:update(dt)

	--- set currTime
	GameController.currTime = love.timer.getTime()
	if (GameController.lastControlGroupRecall.centered) then
		Game:centerOnSelected()
	end
	GameController:keyHeldLogic(dt)
	GameController:mouseEvents(dt)
	GameController:keyboardEvents(dt)
	GameController:checkForCameraScroll(dt)
end

function GameController:mouseEvents(dt)
	if Input.__mouse1Pressed then
		Input:mouse1Pressed(Input.__lastMouseClickPoint.x, Input.__lastMouseClickPoint.y)
	end

	if Input.__mouse1Released then
		Input:mouse1Released(Input.__lastMouseReleasePoint.x, Input.__lastMouseReleasePoint.y)
	end

	if Input.__mouse2Pressed then
		Input:mouse2Pressed(Input.__lastMouseClickPoint.x, Input.__lastMouseClickPoint.y)
	end

	if Input.__mouse2Released then
		Input:mouse2Released(Input.__lastMouseReleasePoint.x, Input.__lastMouseReleasePoint.y)
	end

	if love.mouse.isDown( "r" ) then
		local x, y = camera:scalePoint(love.mouse.getX(), love.mouse.getY())
		Game:moveCommand(x, y)
	end
end

function GameController:keyHeldLogic(dt)
	for num = 0, 9 do
		if GameController.lastControlGroupRecall.centered then
			Game:centerOnSelected()
		end
	end
end

function GameController:keyboardEvents(dt)

	for num = 0, 9 do
		if Input.__keysReleased[tostring(num)] then
			if GameController.lastControlGroupRecall.controlGroup == num then
				if GameController.lastControlGroupRecall.centered then
					GameController.lastControlGroupRecall.centered = false
				end
			end
			Input:keyreleaseHandled(tostring(num))
		end
	end

	local timeSinceKeyboardAction = (GameController.currTime - GameController.lastKeyboardInput) * 1000

	-- for key, pressed in pairs(Input.__keysPressed) do
	-- 	if pressed then
	-- 		GameController.keyToAction[key](dt)
	-- 		Input:keypressHandled(key)
	-- 	end
	-- end

	if timeSinceKeyboardAction > (200) then
		if love.keyboard.isDown( "lctrl" ) or love.keyboard.isDown( "lshift" ) then
			GameController.checkForModifierAction(dt)
		end

	    GameController:checkForNormalAction(dt)
	end
end

function GameController:checkForNormalAction(dt)

	if not love.keyboard.isDown( "lshift" ) then
		GameController:checkForControlGroupRecall(dt)
	end
	if love.keyboard.isDown( "return" ) then
		Hud.textConsole.visible = not Hud.textConsole.visible
		GameController.lastKeyboardInput = love.timer.getTime()
	end

	GameController:checkForStopCommand(dt)
end

function GameController:checkForStopCommand(dt)
	if love.keyboard.isDown( "s" ) then
		Game:stopCommand()
	end
end

function GameController:checkForCameraScroll(dt)
	scrollArea = 75
	scrollSpeed = 1000
	mPosX, mPosY = Game:checkForCameraScroll(scrollArea, scrollSpeed * dt)
end

function GameController:checkForControlGroupRecall(dt)
	for ctrlGroup = 0, 9 do
		if love.keyboard.isDown( tostring(ctrlGroup) ) then
			GameController.currTime = love.timer.getTime()
			recalled = Game:recallControlGroup(ctrlGroup)

			if recalled then
				print("recalled")
				if GameController.lastControlGroupRecall.controlGroup ~= -1 then
					if GameController.lastControlGroupRecall.controlGroup == ctrlGroup and not GameController.lastControlGroupRecall.centered then				
						val = (GameController.currTime - GameController.lastControlGroupRecall.time) * 1000 * (dt * 1000)
						if (val > (100 * (dt * 1000)) and (val < (250 * dt * 1000))) then
							Game:centerOnSelected()
							GameController.lastControlGroupRecall.centered = true
						end
					end
				end

				GameController.lastKeyboardInput = GameController.currTime
				GameController.lastControlGroupRecall.controlGroup = ctrlGroup
				GameController.lastControlGroupRecall.time = GameController.currTime
			end
		end
	end

	return sentAction
end

function GameController:checkForModifierAction(dt)
	local ctrlIsPressed = love.keyboard.isDown( 'lctrl' )
	local shiftIsPressed = love.keyboard.isDown( 'lshift' )
	GameController:checkForControlGroup(dt, ctrlIsPressed, shiftIsPressed)
	GameController:checkForScreenCenter(dt, ctrlIsPressed)
end

function GameController:checkForScreenCenter(dt, ctrlPressed)
	local fIsPressed = love.keyboard.isDown( 'f' )
	if fIsPressed then
		Game:centerOnSelected()
	end
end

function GameController:checkForControlGroup(dt, ctrlPressed, shiftPressed)
	for ctrlGroup = 0, 9 do
		if love.keyboard.isDown( tostring(ctrlGroup) ) then
			if ctrlPressed then
				Game:createControlGroup(ctrlGroup)
			elseif shiftPressed then
			    Game:addToControlGroup(ctrlGroup)
			end
			GameController.lastKeyboardInput = love.timer.getTime()
		end
	end
end