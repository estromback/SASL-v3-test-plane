---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- MODULES IMAGES LOADER ----------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Special trace logger for resource loading errors
function logResourceErrorStacktrace(...)
	logError(...)
	local currentLevel = 3
	while true do
        local errorInfo = debug.getinfo(currentLevel, "Sl")
        if not errorInfo or errorInfo.what == "C" then break end
        logError(string.format("Resource loading stack trace [%s]:%d", errorInfo.short_src, errorInfo.currentline))
        currentLevel = currentLevel + 1
     end
end

-- Load texture image.
-- Loads image and sets texture coords.  It can be called in forms of:
-- loadImage(fileName) -- sets texture coords to entire texture
-- loadImage(fileName, width, height) -- sets texture coords to show 
--    center part of image.  width and height sets size of image part
-- loadImage(fileName, x, y, width, height) - loads specified part of image
function loadImage(fileName, x, y, width, height)    
	local f = findFile(fileName)
	if f == 0 then 
		logResourceErrorStacktrace("Can't find texture", fileName)
		return nil
	end

	local s
	if height ~= nil then s = getGLTexture(f, x, y, width, height)
	elseif y ~= nil then s = getGLTexture(f, x, y)
	else s = getGLTexture(f) end	
	
	if not s then
        logResourceErrorStacktrace("Can't load texture", fileName)
    end
    return s
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- MODULES FONTS LOADERS ----------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Load bitmap font
function loadBitmapFont(fileName)
	return loadFontImpl(fileName, getGLBitmapFont)
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Load font
function loadFont(fileName)
    return loadFontImpl(fileName, getGLFont)
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Load font common implementation
function loadFontImpl(fileName, loadingFunction)
    local f = findFile(fileName)
	if f == 0 then 
		logResourceErrorStacktrace("Can't find font", fileName)
		return nil
	end

    local font = loadingFunction(f)
    if not font then
        logResourceErrorStacktrace("Can't load font", fileName)
    end
    return font
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- MODULES SOUNDS LOADERS -------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Load sample from file
function loadSample(fileName, needToCreateTimer)
	if needToCreateTimer == nil then needToCreateTimer = false end
    for _, v in ipairs(searchResourcesPath) do
        local f = v .. '/' .. fileName
        if isFileExists(f) then
            return loadSampleFromFile(f, needToCreateTimer)
        end
    end

    if not isFileExists(fileName) then
        logResourceErrorStacktrace("Can't find sound", fileName)
        return nil
    end

    local s = loadSampleFromFile(fileName, needToCreateTimer)
    if 0 == s then
        logResourceErrorStacktrace("Can't load sound", fileName)
    end
    return s
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Load reversed sample from file
function loadSampleReversed(fileName, needToCreateTimer)
	if needToCreateTimer == nil then needToCreateTimer = false end
    for _, v in ipairs(searchResourcesPath) do
        local f = v .. '/' .. fileName
        if isFileExists(f) then
            return loadSampleFromFileReversed(f, needToCreateTimer)
        end
    end

    if not isFileExists(fileName) then
        logResourceErrorStacktrace("Can't find sound", fileName)
        return nil
    end

    local s = loadSampleFromFileReversed(fileName, needToCreateTimer)
    if 0 == s then
        logResourceErrorStacktrace("Can't load sound", fileName)
    end
    return s
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- MODULES OBJECTS LOADER ---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Load object from file
-- Find file using the same rules as for textures
function loadObject(fileName)
    for _, v in ipairs(searchResourcesPath) do
        local f = v .. '/' .. fileName
        if isFileExists(f) then
            return loadObjectFromFile(f)
        end
    end

    if not isFileExists(fileName) then
        logResourceErrorStacktrace("Can't find object", fileName)
        return nil
    end

    local o = loadObjectFromFile(fileName)
    if 0 == o then
        logResourceErrorStacktrace("Can't load object", fileName)
    end
    return o
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- MODULES SHADERS LOADER --------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Load shader source from file
function loadShader(shaderID, fileName, shType)
	for _, v in ipairs(searchResourcesPath) do
        local f = v .. '/' .. fileName
        if isFileExists(f) then
            return addShader(shaderID, f, shType)
        end
    end
	
	if not isFileExists(fileName) then
        logResourceErrorStacktrace("Can't find shader source", fileName)
		return nil
	else
		addShader(shaderID, fileName, shType)
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------