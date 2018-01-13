size = {300, 400}
-- set(clip, true)

-- font = loadFont('font.fnt')

-- local earthBg = loadImage("Image.png", 0, 0, 256, 256)
local morda = loadImage("morda.png")

x = globalPropertyd("sim/flightmodel/position/local_x")
y = globalPropertyd("sim/flightmodel/position/local_y")
z = globalPropertyd("sim/flightmodel/position/local_z")

local socket = require("socket")
local mime   = require("mime")
print("Hello from " .. socket._VERSION .. " and " .. mime._VERSION .. "!")

function draw()
-- print("asd")
	-- drawText(font, "", 0,0,1,1,1,1)
	drawRectangle(0,0,20,20,1,0,0,1)	
    -- drawRotatedTexture(earthBg, 45, 50,50, 350, 350);
	-- drawLine(100,100,200,200,0,1,1,1)
	
	-- drawText(font, 0,0,"This is a test 0234", 1,1,1,1)

	drawTexture(morda, 400, 0, 800, 600,1,1,1,1)
	
	-- drawTriangle(0,0, 200,200, 0,200, 0,1,0,1)
	-- drawTriangle(0,0,   0,200,   200,200, 0,1,0,1)
	
	
end

local count = 0

function update() 
	
end

function draw3D()

end

components = {
	clickable {
		position =  {0,0,20,20},
		onMouseDown = function() print("clicked!"); end	
	}
}
