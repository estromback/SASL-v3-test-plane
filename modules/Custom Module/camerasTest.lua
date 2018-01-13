--------------------------------------------------------------------------------------------------------------------------------------
--- SASL cameras interaction test -----------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

planeX = globalPropertyf("sim/flightmodel/position/local_x")
planeY = globalPropertyf("sim/flightmodel/position/local_y")
planeZ = globalPropertyf("sim/flightmodel/position/local_z")

testCameraHeading = 0.0
testCameraPitch = 0.0
testCameraDistance = 200.0
testCameraAdvance = 0.2

function testCameraController()
	testCameraHeading = (testCameraHeading + 0.1) % 360
	
	if testCameraDistance > 400.0 or testCameraDistance < 45.0 then
		testCameraAdvance = -testCameraAdvance
	end
	testCameraDistance = testCameraDistance + testCameraAdvance
	
	dx = -testCameraDistance * math.sin(testCameraHeading * 3.1415 / 180.0)
	dz = testCameraDistance * math.cos(testCameraHeading * 3.1415 / 180.0)
	dy = testCameraDistance / 5
	
	x = get(planeX) + dx
	y = get(planeY) + dy
	z = get(planeZ) + dz
	
	setCamera(x, y, z, testCameraPitch, testCameraHeading, -30.0, 1.0)
end

testControllerID = registerCameraController(testCameraController)

testViewOutsideCommand = findCommand("sim/view/chase")
testCameraCommandStart = createCommand("1-sim/sasltest/enableTestCamera", "Enable SASL test camera")
testCameraCommandEnd = createCommand("1-sim/sasltest/disableTestCamera", "Disable SASL test camera")

function cameraCommandStartCallback(isBefore)
	commandOnce(testViewOutsideCommand)
	startCameraControl(testControllerID, CAMERA_CONTROLLED_UNTIL_VIEW_CHANGE)
end
function cameraCommandStopCallback(isBefore)
	stopCameraControl()
end

registerCommandHandler(testCameraCommandStart, 0, cameraCommandStartCallback)
registerCommandHandler(testCameraCommandEnd, 0, cameraCommandStopCallback)

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

function onModuleDone()
	unregisterCameraController(testControllerID)

	unregisterCommandHandler(testCameraCommandStart, 0)
	unregisterCommandHandler(testCameraCommandEnd, 0)
end

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------