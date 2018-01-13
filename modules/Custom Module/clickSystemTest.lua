--------------------------------------------------------------------------------------------------------------------------------------
--- SIZE ----------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
size = {500, 500}

--------------------------------------------------------------------------------------------------------------------------------------
--- SASL test mouse interaction --------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

testEventsCounter = 0
testRectSizeParameter = 100.0

testFont = loadBitmapFont("fonts/testfont.fnt")
testTextMessage = ""

propTestMode = createGlobalPropertyi("sasltest/clicksystem/mode", 0)
propTestShowCursor = createGlobalPropertyi("sasltest/clicksystem/show_cursor", 0)
propTestCursorScale = createGlobalPropertyf("sasltest/clicksystem/cursor_scale", 1.0)
propTestDoubleClickInterval = createGlobalPropertyf("sasltest/clicksystem/dc_interval", 0.25)

propTestLeftClickDown = createGlobalPropertyi("sasltest/clicksystem/left_click_down", 0)
propTestLeftClickUp = createGlobalPropertyi("sasltest/clicksystem/left_click_up", 0)
propTestLeftClickHold = createGlobalPropertyi("sasltest/clicksystem/left_click_hold", 0)
propTestLeftDoubleClick = createGlobalPropertyi("sasltest/clicksystem/left_dclick", 0)

propTestRightClickDown = createGlobalPropertyi("sasltest/clicksystem/right_click_down", 0)
propTestRightClickUp = createGlobalPropertyi("sasltest/clicksystem/right_click_up", 0)
propTestRightClickHold = createGlobalPropertyi("sasltest/clicksystem/right_click_hold", 0)
propTestRightDoubleClick = createGlobalPropertyi("sasltest/clicksystem/right_dclick", 0)

propTestMiddleClickDown = createGlobalPropertyi("sasltest/clicksystem/middle_click_down", 0)
propTestMiddleClickUp = createGlobalPropertyi("sasltest/clicksystem/middle_click_up", 0)
propTestMiddleClickHold = createGlobalPropertyi("sasltest/clicksystem/middle_click_hold", 0)
propTestMiddleDoubleClick = createGlobalPropertyi("sasltest/clicksystem/middle_dclick", 0)

propTestWheelClicks = createGlobalPropertyi("sasltest/clicksystem/wheel_clicks", 0)

propTestDragDirection = createGlobalPropertyi("sasltest/clicksystem/drag_direction", 0)
propTestDragValue = createGlobalPropertyi("sasltest/clicksystem/drag_value", 0)

propTestCursorOnInterface = createGlobalPropertyi("sasltest/clicksystem/cursor_on_interface", 0)

propTestMousePosX = createGlobalPropertyi("sasltest/clicksystem/pos_x", 0)
propTestMousePosY = createGlobalPropertyi("sasltest/clicksystem/pos_y", 0)

setAuxiliaryClickSystem(true)

function draw()
	drawRectangle(0, 0, 500, 500, 0.4, 0.4, 0.4, 1)
	drawRectangle(400, 400, 100, 100, 0, 1, 0, 1)
	drawRectangle(400, 0, 100, 100, 0, 0, 1, 1)
	drawRectangle(0, 400, 100, 100, 1, 0, 0, 1)
	
	drawRectangle(250 - testRectSizeParameter / 2, 250 - testRectSizeParameter / 2, testRectSizeParameter, testRectSizeParameter, 1, 0, 1, 0.5)
	drawRectangle(200, 200, 100, 100, 1, 0, 1, 1)
	
	drawBitmapText(testFont, 10, 40, tostring(testEventsCounter), 1, 1, 1, 1)
	drawBitmapText(testFont, 10, 10, testTextMessage, 1, 1, 1, 1)
end

function update()
	local paramValue 
	paramValue = getCSClickDown(MB_LEFT); set(propTestLeftClickDown, paramValue)
	paramValue = getCSClickUp(MB_LEFT); set(propTestLeftClickUp, paramValue)
	paramValue = getCSClickHold(MB_LEFT); set(propTestLeftClickHold, paramValue)
	paramValue = getCSDoubleClick(MB_LEFT); set(propTestLeftDoubleClick, paramValue)
	
	paramValue = getCSClickDown(MB_RIGHT); set(propTestRightClickDown, paramValue)
	paramValue = getCSClickUp(MB_RIGHT); set(propTestRightClickUp, paramValue)
	paramValue = getCSClickHold(MB_RIGHT); set(propTestRightClickHold, paramValue)
	paramValue = getCSDoubleClick(MB_RIGHT); set(propTestRightDoubleClick, paramValue)
	
	paramValue = getCSClickDown(MB_MIDDLE); set(propTestMiddleClickDown, paramValue)
	paramValue = getCSClickUp(MB_MIDDLE); set(propTestMiddleClickUp, paramValue)
	paramValue = getCSClickHold(MB_MIDDLE); set(propTestMiddleClickHold, paramValue)
	paramValue = getCSDoubleClick(MB_MIDDLE); set(propTestMiddleDoubleClick, paramValue)
	
	paramValue = getCSWheelClicks(); set(propTestWheelClicks, paramValue)
	paramValue = getCSDragDirection(); set(propTestDragDirection, paramValue)
	paramValue = getCSDragValue(); set(propTestDragValue, paramValue)
	paramValue = getCSCursorOnInterface(); set(propTestCursorOnInterface, paramValue)
	paramValue = getCSMouseXPos(); set(propTestMousePosX, paramValue)
	paramValue = getCSMouseYPos(); set(propTestMousePosY, paramValue)
	
	paramValue = get(propTestMode); setCSMode(paramValue)
	paramValue = get(propTestShowCursor); setCSShowCursor(paramValue)
	paramValue = get(propTestCursorScale); setCSCursorScale(paramValue)
	paramValue = get(propTestDoubleClickInterval); setCSDClickInterval(paramValue)
end

components = {
	clickable {
		position =  {400, 400, 100, 100},
		onMouseDown = function(component, mx, my, button, x, y, value)
			if button == MB_LEFT then
				testTextMessage = "Left click on green patch"
			end
			if button == MB_RIGHT then
				testTextMessage = "Right click on green patch"
			end
			if button == MB_MIDDLE then
				testTextMessage = "Middle click on green patch"
			end
			testEventsCounter = testEventsCounter + 1
		end;
	},
	
	clickable {
		position =  {400, 0, 100, 100},
		onMouseDown = function(component, mx, my, button, x, y, value)
			if button == MB_LEFT then
				testTextMessage = "Left click on blue patch"
			end
			if button == MB_RIGHT then
				testTextMessage = "Right click on blue patch"
			end
			if button == MB_MIDDLE then
				testTextMessage = "Middle click on blue patch"
			end
			testEventsCounter = testEventsCounter + 1
		end;
	},
	
	clickable {
		position =  {0, 400, 100, 100},
		onMouseDown = function(component, mx, my, button, x, y, value)
			if button == MB_LEFT then
				testTextMessage = "Left click on red patch"
			end
			if button == MB_RIGHT then
				testTextMessage = "Right click on red patch"
			end
			if button == MB_MIDDLE then
				testTextMessage = "Middle click on red patch"
			end
			testEventsCounter = testEventsCounter + 1
		end;
	},
	
	clickable {
		position =  {200, 200, 100, 100},
		onMouseWheel = function(component, mx, my, button, x, y, value) 
			testTextMessage = "Wheel rotated on center patch"
			testRectSizeParameter = testRectSizeParameter + 5 * value
			if testRectSizeParameter < 100 then
				testRectSizeParameter = 100
			end
			testEventsCounter = testEventsCounter + 1
			return 0;
		end;
	}
}

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
