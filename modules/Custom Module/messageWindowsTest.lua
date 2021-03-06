--------------------------------------------------------------------------------------------------------------------------------------------------------------
--- SASL message windows test --------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------

function testYesCallback()
	print("Yes -- button pressed")
end

function testNoCallback()
	print("No -- button pressed")
end

function testOKCallback()
	print("OK -- button pressed")
end

function emptyCallback()
end

---------------------------------------------------------------------

flag = true

testMessageText1 = "Some message text: first, second and third words. Let's hope this will work somehow."
testMessageText2 = "Some message text"

function update()
	if (flag == true) then
		sasl.messageWindow(600, 600, 300, 200, "Test Message", testMessageText1, 1, "OK", testOKCallback)
		sasl.messageWindow(1000, 600, 400, 250, "Test Message", testMessageText1, 3, 
		"YES", testYesCallback, 
		"NO", testNoCallback, 
		"Will think later...", emptyCallback)
		
		flag = false
	end
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------

function onModuleDone()
	
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------