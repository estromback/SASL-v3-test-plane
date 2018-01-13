--------------------------------------------------------------------------------------------------------------------------------------
--- SIZE ----------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
size = { 2048, 2048 }

--------------------------------------------------------------------------------------------------------------------------------------
--- SASL test popups --------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

---[[
shaderTestPanel = subpanel {
    position = { 50, 650, 600, 600 };
    noBackground = false;
    noClose = true;
    movable = true;
    clickable = true;
	visible = true;
    noResize = false;
    components = {
		shadersTest {
			position = { 0 , 0 , 600, 600 },
			clip = true
		};
    };
}
--]]

---[[
gridLayoutTestPanel = subpanel {
    position = { 650, 50, 600, 600 };
    noBackground = false;
    noClose = true;
    movable = true;
    clickable = true;
	visible = true;
    noResize = false;
    components = {
		gridLayoutTest {
			position = { 0, 0, 600, 600 },
			clip = true
		};
    };
}
--]]

--[[
clickSystemTestPanel = subpanel {
    position = { 300, 300, 500, 500 };
    noBackground = false;
    noClose = true;
    movable = true;
    clickable = true;
	visible = true;
    noResize = false;
    components = {
		clickSystemTest {
			position = { 0, 0, 500, 500 },
			clip = true
		};
    };
}
--]]
---[[
primitivesTestPanel = subpanel {
    position = { 100, 100, 400, 400 };
    noBackground = false;
    noClose = true;
    movable = true;
    clickable = true;
	visible = true;
    noResize = false;
    components = {
		primitivesTest {
			position = { 0, 0, 400, 400 },
			clip = true
		};
    };
}

--]]
--[[
fontsSystemTestPanel = subpanel {
    position = { 300, 300, 500, 500 };
    noBackground = false;
    noClose = true;
    movable = true;
    clickable = true;
	visible = true;
    noResize = false;
    components = {
		fontsSystemTest {
			position = { 0 , 0 , 500, 500 },
			clip = true
		};
    };
}
--]]
----------------------------------------------------------------------------------------------------------------------------------------------
-- LuaUnit SASL specific stuff -------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
---[[
luaunit = require("luaunit")
unitTestsSequenceDone = false
--]]
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
---[[
sim = {
	frameTime = 0,
	frameNumber = 0,
	flightTime = 0,
}
--]]
globalTimers = {}
---[[
function newTimer(t)
	local timer = {}
	timer.timer = {value = t, status = 1}
	timer.idx = #globalTimers+1
	timer.default = t
	globalTimers[timer.idx] = timer.timer
	
	timer.time = function() return timer.timer.value end
	timer.reset = function(t) 
					if not t then t = timer.default end
					timer.timer.value = t 
				  end	
	timer.pause = function() timer.timer.status = 0 end
	timer.resume = function() timer.timer.status = 1 end
	isDone = function() return timer.timer.value == 0 end
	
	return timer
end

function deleteTimer(timer)
	globalTimers[timer.idx] = {}
	timer = nil
	return
end

function getTimer(timer)
	return timer.time()
end

function resetTimer(timer, t)
	timer.reset(t)
end

function pauseTimer(timer)
	timer.pause()
end

function resumeTimer(timer)
	timer.resume()
end
--]]

---[[
function update()
	for i, t in pairs(globalTimers) do		
		if t.status == 1 then
			if t.value>0 then 		
				globalTimers[i].value = globalTimers[i].value - sim.frameTime
			elseif t.value<0 then 
				globalTimers[i].value = 0 
			end
		end
	end
	
	updateAll(components)
	
--------------------------------------------------------------------------------------------------------------------------------------------
-- Tests Sequence -----------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------

	if unitTestsSequenceDone == false then
		luaunit.LuaUnit.run()
		unitTestsSequenceDone = true
	end
	
--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
end
--]]
components = {
	time_logic{},
	datarefTest{},
	camerasTest{},
	menusTest{},
	messageWindowsTest{},
	soundTest{}
}

--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------