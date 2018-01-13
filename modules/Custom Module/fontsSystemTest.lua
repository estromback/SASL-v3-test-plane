--------------------------------------------------------------------------------------------------------------------------------------
--- SIZE ----------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
size = {500, 500}

--------------------------------------------------------------------------------------------------------------------------------------
--- SASL test fonts ----------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

testBitmapFont = loadBitmapFont("fonts/testfont.fnt")

testRobotoBlackFont = loadFont("fonts/testRoboto-Black.ttf")
testRobotoBoldFont = loadFont("fonts/testRoboto-Bold.ttf")

testQuicksandReqularFont = loadFont("fonts/testQuicksand-Regular.otf")
testQuicksandBoldItalicFont = loadFont("fonts/testQuicksand-BoldItalic.otf")

testOpenSansSemiboldFont = loadFont("fonts/testOpenSans-Semibold.ttf")
testOpenSansExtraBoldFont = loadFont("fonts/testOpenSans-ExtraBold.ttf")

testPacificoFont = loadFont("fonts/testPacifico-Regular.ttf")
testGoodDogFont = loadFont("fonts/testGoodDog-Regular.otf")
testAlexBrushFont = loadFont("fonts/testAlexBrush-Regular.ttf")

sasl.gl.setFontOutlineColor(testGoodDogFont, 0.0, 0.0, 1.0, 1.0)
sasl.gl.setFontOutlineColor(testPacificoFont, 0.0, 0.0, 1.0, 1.0)
sasl.gl.setFontOutlineColor(testAlexBrushFont, 0.0, 0.0, 1.0, 1.0)

sasl.gl.setFontOutlineThickness(testGoodDogFont, 1)
sasl.gl.setFontOutlineThickness(testPacificoFont, 1)
sasl.gl.setFontOutlineThickness(testAlexBrushFont, 1)

function draw()
	sasl.gl.drawRectangle(0, 0, 500, 500, 0.2, 0.2, 0.2, 1.0)
	sasl.gl.drawRectangle(0, 0, 500, 6, 0.3, 0.3, 0.3, 1.0)
	sasl.gl.drawRectangle(0, 0, 6, 500, 0.3, 0.3, 0.3, 1.0)
	
	sasl.gl.drawRectangle(0, 494, 500, 6, 0.5, 0.5, 0.5, 1.0)
	sasl.gl.drawRectangle(494, 0, 6, 500, 0.5, 0.5, 0.5, 1.0)
	sasl.gl.drawTriangle(0, 500, 6, 494, 0, 494, 0.3, 0.3, 0.3, 1.0)
	
	sasl.gl.drawText(testQuicksandReqularFont, 6, 470, "Quicksand Regular 30", 30, false, false, TEXT_ALIGN_LEFT, 1, 0, 0, 1)
	sasl.gl.drawText(testQuicksandReqularFont, 6, 450, "Quicksand Regular Bolded 20", 20, true, false, TEXT_ALIGN_LEFT, 1, 0, 0, 1)
	sasl.gl.drawText(testQuicksandReqularFont, 6, 425, "Quicksand Regular Italic 25", 25, false, true, TEXT_ALIGN_LEFT, 1, 0, 0, 1)
	sasl.gl.drawText(testQuicksandReqularFont, 6, 395, "Quicksand Regular Bolded Italic 25", 25, true , true, TEXT_ALIGN_LEFT, 1, 0, 0, 1)
	
	sasl.gl.drawText(testRobotoBlackFont, 6, 365, "Roboto Regular 30", 30, false, false, TEXT_ALIGN_LEFT, 1, 0, 0, 1)
	sasl.gl.drawText(testRobotoBoldFont, 6, 335, "Roboto Bold 30", 30, true, false, TEXT_ALIGN_LEFT, 1, 0, 0, 1)
	
	sasl.gl.drawText(testOpenSansSemiboldFont, 494, 300, "OpenSans Semibold 20 R Aligned", 20, false, false, TEXT_ALIGN_RIGHT, 1, 0, 0, 1)
	sasl.gl.drawText(testOpenSansExtraBoldFont, 494, 275, "OpenSans ExtraBold 15 R Aligned", 15, true, false, TEXT_ALIGN_RIGHT, 1, 0, 0, 1)
	
	sasl.gl.drawText(testPacificoFont, 250, 250, "Pacifico Regular 25 С Aligned", 25, false, false, TEXT_ALIGN_CENTER, 1, 0, 0, 1)
	sasl.gl.drawText(testGoodDogFont, 250, 220, "GoodDog Regular 30 C Aligned", 30, true, false, TEXT_ALIGN_CENTER, 1, 0, 0, 1)
	sasl.gl.drawText(testAlexBrushFont, 250, 185, "AlexBrush Reqular 35 C Aligned", 35, false, false, TEXT_ALIGN_CENTER, 1, 0, 0, 1)
	
	sasl.gl.drawText(testQuicksandReqularFont, 6, 150, "Quicksand with first endline \nsecond endline \nand last line", 25, false, false, TEXT_ALIGN_LEFT, 1, 0, 0, 1)
	
	sasl.gl.drawBitmapText(testBitmapFont, 6, 60, "Bitmap test font", 1, 0, 0, 1)
end

function update()

end

function onModuleDone()
	sasl.gl.unloadBitmapFont(testBitmapFont)
	sasl.gl.unloadFont(testRobotoBlackFont)
	sasl.gl.unloadFont(testRobotoBoldFont)
	sasl.gl.unloadFont(testQuicksandReqularFont)
	sasl.gl.unloadFont(testQuicksandBoldItalicFont)
	sasl.gl.unloadFont(testOpenSansSemiboldFont)
	sasl.gl.unloadFont(testOpenSansExtraBoldFont)
	sasl.gl.unloadFont(testPacificoFont)
	sasl.gl.unloadFont(testGoodDogFont)
	sasl.gl.unloadFont(testAlexBrushFont)
end

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
