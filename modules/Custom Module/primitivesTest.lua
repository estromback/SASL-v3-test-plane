size = {400, 400}

planeLocalX = globalPropertyd("sim/flightmodel/position/local_x")
planeLocalY = globalPropertyd("sim/flightmodel/position/local_y")
planeLocalZ = globalPropertyd("sim/flightmodel/position/local_z")

mach = globalPropertyf("sim/flightmodel/misc/machno")
airspeed = globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
airspeed_acc = globalPropertyf("sim/cockpit2/gauges/indicators/airspeed_acceleration_kts_sec_pilot")

function draw()
	sasl.gl.drawBezierLineQ(0, 0, 0, 100, 100, 100, 15, 1, 0, 0, 1)
	sasl.gl.drawBezierLineQAdaptive(100, 0, 100, 100, 200, 100, 1, 0, 0, 1)
	sasl.gl.drawBezierLineC(100, 100, 175, 110, 150, 200, 200, 200, 20, 1, 0, 0, 1)
	sasl.gl.drawBezierLineCAdaptive(200, 100, 275, 110, 250, 200, 300, 200, 1, 0, 0, 1)
	sasl.gl.drawLine(200, 200, 400, 200, 1, 0, 0, 1)
	sasl.gl.drawCircle(195, 235, 25, false, 1, 0, 0, 1)
	sasl.gl.drawTriangle(350, 210, 350, 250, 400, 210, 1, 0, 0, 1)
	sasl.gl.drawRectangle(230, 210, 50, 50, 1, 0, 0, 1)
	sasl.gl.drawCircle(315, 235, 25, true, 1, 0, 0, 1)
	
	sasl.gl.setLineWidth(3.0)
	sasl.gl.drawFrame(170, 270, 50, 50, 1, 0, 0, 1)
	sasl.gl.setLineWidth(1.0)
	
	sasl.gl.drawArc(240, 295, 70, 80, 0.0, 120.0, 1, 0, 0, 1)
	
	sasl.gl.setLinePattern({5.0, -3.0})
	sasl.gl.drawLinePattern(300, 0, 300, 200, false, 1, 0, 0, 1)
	sasl.gl.setLinePattern({10.0, -5.5, 5.5, -2.0})
	sasl.gl.drawLinePattern(310, 0, 330, 200, false, 1, 0, 0, 1)
	
	sasl.gl.setLinePattern({12.0, -12.0})
	sasl.gl.drawLinePattern(100, 250, 100, 300, true, 1, 0, 0, 1)
	sasl.gl.drawLinePattern(100, 300, 150, 300, true, 1, 0, 0, 1)
	sasl.gl.drawLinePattern(150, 300, 150, 250, true, 1, 0, 0, 1)
	sasl.gl.drawLinePattern(150, 250, 100, 250, false, 1, 0, 0, 1)
end

function update()
	
end

function draw3D()
--	planeX = get(planeLocalX)
--	planeY = get(planeLocalY)
--	planeZ = get(planeLocalZ)
	
--	sasl.gl.drawCircle3D(planeX, planeY, planeZ, 10, 0, 45, false, 0, 0, 1, 1)
--	sasl.gl.drawCircle3D(planeX, planeY, planeZ, 10, 0, -45, false, 0, 0, 1, 1)
--	sasl.gl.drawCircle3D(planeX, planeY, planeZ, 3, 90, 0, true, 0, 0, 1, 1)
	
--	sasl.gl.drawLine3D(planeX, planeY, planeZ, planeX + 10, planeY, planeZ, 1, 0, 1, 1)
--	sasl.gl.drawLine3D(planeX, planeY, planeZ, planeX, planeY + 10, planeZ, 1, 0, 1, 1)
--	sasl.gl.drawLine3D(planeX, planeY, planeZ, planeX, planeY, planeZ + 10, 1, 0, 1, 1)
	
--	sasl.gl.drawAngle3D(planeX, planeY, planeZ, 30, 15, 0, 0, 10, 1, 0, 1, 1)
--	sasl.gl.drawAngle3D(planeX, planeY, planeZ, 30, 15, -30, 0, 10, 1, 0, 1, 1)
	
--	sasl.gl.drawStandingCone3D(planeX, planeY, planeZ + 10, 3, 4, 1, 0, 0, 1)
end

components = {
	
}