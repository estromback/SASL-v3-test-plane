beep = loadSample('sounds/beep.wav', 1)
beep2 = loadSample('sounds/beep2.wav')
sample = loadSample('sounds/radio.wav')
stereobeep = loadSample('sounds/stereobeep.wav')
stereo = loadSample('sounds/stereo.wav')
sampleRev = loadSampleReversed('sounds/radio.wav', true)

viewOutside = findCommand('sim/view/chase')
viewInside = findCommand('sim/view/forward_with_panel')
commandOnce(viewInside)
view = globalPropertyi("sim/graphics/view/view_is_external")

testNumber = 10
testLength = {3, 12, 5, 2, 2, 10, 20, 10}
z=0
setMasterGain(1000)

t = newTimer(0)

counter = 0

function update()	
	if testNumber <= #testLength and getTimer(t) == 0 then
		
		testNumber = testNumber + 1
		resetTimer(t, testLength[testNumber])
		logInfo('Beginning test '..testNumber)
	end	
	
	if sim.frameTime == 0 then 
		setMasterGain(0)
	else
		setMasterGain(1000)
	end
	
	if testNumber <= #testLength then
		-- print(testNumber.." "..getTimer(t))
	end
	
	if testNumber == 1 then		
		setSampleGain(beep, 1000)
		setSamplePitch(beep, 1000)
		if not isSamplePlaying(beep) then
			playSample(beep, false)
		end
		
		if getTimer(t) < 1 then
			setSamplePitch(beep, 500)			
		elseif getTimer(t) < 2 then
			setSampleGain(beep, 500)					
		end
		
	elseif testNumber == 2 then
		if not isSamplePlaying(sampleRev) then
			playSample(sampleRev, false)
		end
		
		if getTimer(t) < 6 and getTimer(t) > 5.9  then
			rewindSample(sampleRev)
			setTimer('t', 5.8)
		elseif getTimer(t) < 3 then
			stopSample(sampleRev)
		end
		
	elseif testNumber == 3 then
		if not isSamplePlaying(sampleRev) then
			playSample(sampleRev, false)
		end
	
		if getSamplePlayingRemaining(sampleRev)<8 then
			stopSample(sampleRev)
		end
	elseif testNumber == 4 then		
		setSampleGain(beep, 1000)
		setSamplePitch(beep, 1000)
		setMasterGain(200)
		if not isSamplePlaying(beep) then
			playSample(beep, false)
		end
	elseif testNumber == 5 then				
		commandOnce(viewOutside)
		
		setMasterGain(1000)
		if not isSamplePlaying(beep) then
			playSample(beep, false)
		end	
		
		if getTimer(t) < 1 then
			setSampleEnv(beep, 1)
		end
	elseif testNumber == 6 then				
		if get(view)==0 then 
			commandOnce(viewOutside)
		end
		setSampleRelative(beep, 0)	
		if getTimer(t)>8 then	z=0
		elseif getTimer(t)>6 then	z=40
		elseif getTimer(t)>4 then	z=60
		elseif getTimer(t)>2 then	z=80
		elseif getTimer(t)>0 then	z=100
		end
		
		setSamplePosition(beep, 0,0, -z)
		if isSamplePlaying(beep) == false then
			playSample(beep, false)
		end
	elseif testNumber == 7 then			
		if get(view)==0 then 
			commandOnce(viewOutside)
		end
		setSampleRelative(beep, 0)	
		setSamplePosition(beep, 0,0,0)
		setSampleRolloff(beep, 0.1)
		setSampleMaxDistance(beep, 1000)
		
		setSampleDirection(beep, 0,0,-1)
		setSampleCone(beep, 0, 30, 60)
		
		if isSamplePlaying(beep) == false then
			playSample(beep, false)
		end
	elseif testNumber == 8 then		
		local sample = stereo
		setSampleGain(sample, 400)
		if get(view)==0 then 
			commandOnce(viewOutside)
		end
		setSampleRelative(sample, 0)	
		setSamplePosition(sample, 0,0,0)
		setSampleRolloff(sample, 0.1)
		setSampleMaxDistance(sample, 1000)
		
		setSampleDirection(sample, 0,0,-1)
		setSampleCone(sample, 0, 30, 60)
		
		if isSamplePlaying(sample) == false then
			playSample(sample, false)
		end
	end
	
--	if isSamplePlaying(beep) == false then
--		playSample(beep, false)
--	end

	if counter < 100 then
		counter = counter + 1
	end
	
	if counter == 100 or counter == 101 then
		if isSamplePlaying(beep) == false then
			if counter == 100 then
				playSample(beep, false)
				appendSample(beep, beep2)
			elseif counter == 101 then
				playSample(beep, false)
			end
			counter = counter + 1
		end
	end

	
	
	
	
	
end


