--------------------------------------------------------------------------------------------------------------------------------------
--- SIZE ---------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
size = {600, 600}

--------------------------------------------------------------------------------------------------------------------------------------
--- SASL shaders test ------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

creature = loadImage("morda.png")
sasl.gl.setTextureWrapping(creature, TEXTURE_CLAMP)
creatureWidth, creatureHeight = sasl.gl.getTextureSize(creature)

dotted = loadImage("dotted.png")
sasl.gl.setTextureWrapping(dotted, TEXTURE_REPEAT)

testShaderProgram = sasl.gl.createShaderProgram()
loadShader(testShaderProgram, "shaders/dotted.vert", SHADER_TYPE_VERTEX)
loadShader(testShaderProgram, "shaders/dotted.frag", SHADER_TYPE_FRAGMENT)
sasl.gl.linkShaderProgram(testShaderProgram)

testShaderParameter = 0.0

testUniformTable1 = {0.0, 0.3, 1.0, 1.0, 0.1, 1.0, 2.0, 12.33, 0.0, 0.0, 1.0, 0.33, 1.0, 5.3, 1.0, 0.33}
testUniformTable2 = {1.0, 12.33, 1.0, 0.0, 0.0, 1.0, 0.33, 1.0, 1.0}

function draw()
	sasl.gl.useShaderProgram(testShaderProgram)
		sasl.gl.setShaderUniform(testShaderProgram, "testParameter", TYPE_FLOAT, testShaderParameter)
		sasl.gl.setShaderUniform(testShaderProgram, "testTextureWidth", TYPE_FLOAT, 16)
		sasl.gl.setShaderUniform(testShaderProgram, "testTextureHeight", TYPE_FLOAT, 16)
		sasl.gl.setShaderUniform(testShaderProgram, "testTexture", TYPE_SAMPLER, dotted, 0)
		
		sasl.gl.setShaderUniform(testShaderProgram, "testArray1", TYPE_FLOAT_ARRAY, testUniformTable1)
		sasl.gl.setShaderUniform(testShaderProgram, "testArray2", TYPE_FLOAT_ARRAY, testUniformTable2)
		
		sasl.gl.drawRectangle(0, 0, 250, 250, 1, 0, 0, 1)
		sasl.gl.drawRectangle(350, 350, 250, 250, 1, 0, 0, 1)
	sasl.gl.stopShaderProgram(testShaderProgram)
	
	sasl.gl.drawRectangle(250, 250, 100, 100, 0, 0, 1, 0.5)
	sasl.gl.drawTexturePart(creature, 0, 0, 100, 100, 0, 0, 1024, 1024, 1, 1, 1, 1)
end

function update()
	testShaderParameter = testShaderParameter + 0.05
end

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
