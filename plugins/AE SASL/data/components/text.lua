-- draw text

-- no default font
defineProperty("font")

-- no default text
defineProperty("text")

function draw(self) 
    drawBitmapText(get(font), 0, 0, get(text)) 
end


