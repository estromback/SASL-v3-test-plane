--------------------------------------------------------------------------------------------------------------------------------------------------------------
--- SASL menus interaction test --------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------

function testPlaneMenuItem1Callback()
	print("Test Plane Menu Item #1 Selected")
end

function testPlaneMenuItem2Callback()
	print("Test Plane Menu Item #2 Selected")
end

---------------------------------------------------------------------

function testPlaneSubMenuItem1Callback()
	print("Test Plane Sub Menu Item #1 Selected")
end

function testPlaneSubMenuItem2Callback()
	print("Test Plane Sub Menu Item #2 Selected")
end

---------------------------------------------------------------------

testPlaneMenuID = sasl.appendMenuItem(PLUGINS_MENU_ID, "Test Plane")
testPlaneMainMenu = sasl.createMenu("Test Plane", PLUGINS_MENU_ID, testPlaneMenuID)

testPlaneMenuItem1 = sasl.appendMenuItem(testPlaneMainMenu, "Test Plane Menu Item #1", testPlaneMenuItem1Callback)
testPlaneMenuItem2 = sasl.appendMenuItem(testPlaneMainMenu, "Test Plane Menu Item #2", testPlaneMenuItem2Callback)
sasl.appendMenuSeparator(testPlaneMainMenu)
testPlaneMenuItem3 = sasl.appendMenuItem(testPlaneMainMenu, "Test Plane Menu Item #3")

testPlaneSubMenu = sasl.createMenu("Test Plane Menu Item #3", testPlaneMainMenu, testPlaneMenuItem3)
testPlaneSubMenuItem1 = sasl.appendMenuItem(testPlaneSubMenu, "Test Plane Sub Menu Item #1", testPlaneSubMenuItem1Callback)
testPlaneSubMenuItem2 = sasl.appendMenuItem(testPlaneSubMenu, "Test Plane Sub Menu Item #2", testPlaneSubMenuItem2Callback)

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------

function onModuleDone()
	sasl.clearAllMenuItems(testPlaneSubMenu)
	sasl.clearAllMenuItems(testPlaneMainMenu)
	
	sasl.destroyMenu(testPlaneSubMenu)
	sasl.destroyMenu(testPlaneMainMenu)
	
	sasl.removeMenuItem(PLUGINS_MENU_ID, testPlaneMenuID)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------