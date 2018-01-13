-- this is time logic for all scripts


defineProperty("total_time", globalPropertyf("sim/time/total_flight_time_sec")) -- flight sim time
defineProperty("sim_run_time", globalPropertyf("sim/time/total_running_time_sec")) -- sim time

local time_begin = get(sim_run_time) -- time at flight beginning
local time_last = get(sim_run_time)  -- time for previous frame

function update()
	
	if get(total_time)<1 then 
		time_begin = get(sim_run_time) -- time at flight beginning	
		time_last = get(sim_run_time)  -- time for previous frame
		sim.frameNumber = 0
	end
	
	local time_now = get(sim_run_time)
	local passed = math.abs(time_now - time_begin)
	local diff = math.abs(time_now - time_last)
			
	sim.flightTime = passed
	sim.frameTime = diff
	sim.frameNumber = sim.frameNumber + 1

	time_last = time_now

end


