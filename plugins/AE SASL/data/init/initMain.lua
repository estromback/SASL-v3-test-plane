---------------------------------------------------------------------------------------------------------------------------
-- SETUP PATHS FOR ADDITIONAL PACKAGES AND 3-RD PARTY LIBRARIES -----------------------------------
---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

package.path = package.path .. ';' .. getProjectPath() .. '/3rd-modules/?.lua'
package.path = package.path .. ';' .. getProjectPath() .. '/Custom Module/?.lua'

if (getOS() == "Windows") then
	package.cpath = package.cpath .. ';' .. getProjectPath() .. '/3rd-Modules/?.dll'
	package.cpath = package.cpath .. ';' .. getProjectPath() .. '/Custom Module/?.dll'
else 
	package.cpath = package.cpath .. ';' .. getProjectPath() .. '/3rd-Modules/?.so'
	package.cpath = package.cpath .. ';' .. getProjectPath() .. '/Custom Module/?.so'
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- COMPONENTS -------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Create basic component
function createComponent(name, parent)
    local data = { 
        components = { },
        componentsByName = { },
        size = { 100, 100 },
        position = createProperty { 0, 0, 100, 100 },
		fbo = createProperty(false),
		renderTarget = -1,
		fpsLimit = createProperty(-1),
		frames = 0,
		noRenderSignal = createProperty(false),
        clip = createProperty(false),
		clipSize = createProperty { 0, 0, 0, 0 },
        draw = function (comp) drawAll(comp.components); end,
		drawObjects = function (comp) drawAllObjects(comp.components); end,
		draw3D = function (comp) drawAll3D(comp.components); end,
        update = function (comp) updateAll(comp.components); end,
        name = name,
        visible = createProperty(true),
        movable = createProperty(false),
        resizable = createProperty(false),
        focused = createProperty(false),
        savePosition = createProperty(false),
        resizeProportional = createProperty(true),
        onMouseUp = defaultOnMouseUp,
        onMouseDown = defaultOnMouseDown,
        onMouseClick = defaultOnMouseClick,
        onMouseMove = defaultOnMouseMove,
		onMouseWheel = defaultOnMouseWheel,
        onKeyDown = defaultOnKeyDown,
        onKeyUp = defaultOnKeyUp,
	logInfo = function(...) logInfo('"' .. name .. '"', ...); end,
	logError = function(...) logError('"' .. name .. '"', ...); end,
	logDebug = function(...) logDebug('"' .. name .. '"', ...); end,
	logWarning = function(...) logWarning('"' .. name .. '"', ...); end,
	print = function(...) print('"' .. name .. '"', ...); end,
    }
    data._C = data
    if parent then
        data._P = parent
    end
    addComponentFunc(data)
    return data
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Try to find key in local table first.
-- Look in global table if key doesn't exists in local table.
-- Try to load component from file if it doesn't exists in global table
function compIndex(table, key)
    local comp = table
    while nil ~= comp do
        local v = rawget(comp, key)
        if nil ~= v then 
            return v 
        else
            comp = rawget(comp, '_P')
        end
    end

    v = _G[key]
    if nil == v then
        return loadComponent(key)
    else
        return v
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Create component function
function addComponentFunc(component)
    component.component = function(name, tbl)
        if not tbl then -- anonymous subcomponent
            tbl = name
            name = nil
        end
        table.insert(component.components, tbl)
        if name then
            component.componentsByName[name] = tbl
        end
        return tbl
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Add properties to component
function setupComponent(component, args)
    mergeTables(component, argumentsToProperties(args))
    setmetatable(component, { __index = compIndex })
    
    component.defineProperty = function(name, dflt)
        if not rawget(component, name) then
            component[name] = createProperty(dflt)
        end
    end

    component.include = function(name)
        include(component, name)
    end

    addComponentFunc(component)
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Components stack on creation 
local creatingComponents = { }

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Call it before creation of components
function startComponentsCreation(parent)
    table.insert(creatingComponents, parent)
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Call it after creation of components
function finishComponentsCreation()
    table.remove(creatingComponents)
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Load component from file and create constructor
function loadComponent(name, fileName)
    logInfo("loading", name)

    if not fileName then
        fileName = name .. ".lua"
    end

    local f, subdir = openFile(fileName)
    if not f then
        logError("can't load component", name)
        return nil
    end

    local constr = function(args)
        local parent = creatingComponents[#creatingComponents]
        if subdir then
            addSearchPath(subdir)
        end
        local t = createComponent(name, parent)
        t.componentFileName = fileName

        -- Ugly hack to solve popups parent problem
        if ('panel' == name) and (nil == parent) then
            popups._P = t
        end

        setupComponent(t, args)
        startComponentsCreation(t)
        setfenv(f, t)
        f()
        finishComponentsCreation()
		
		if get(t.fpsLimit) ~= -1 then
			set(t.fbo, true)
		end
		
		if toboolean(get(t.fbo)) then
			t.renderTarget = getNewRenderTargetID(t.size[1], t.size[2])
		end
		
        if subdir then
            popSearchPath()
        end
        return t
    end

    _G[name] = constr

    return constr
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Load script inside component environment
function include(component, name)
    logInfo("including", name)

    local f, subdir = openFile(name)
    if not f then
        logError("can't include script", name)
    else
        if subdir then
            addSearchPath(subdir)
        end
            
        setfenv(f, component)
        f()

        if subdir then
            popSearchPath()
        end
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Add component to popup layer
function popup(name, tbl)
    return popups.component(name, tbl)
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- COMPONENTS HANDLERS FOR SIMULATOR EVENTS ------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Run handler of component
function runComponentHandler(component, name, mx, my, button, x, y, value)
    local handler = rawget(component, name)
    if handler then
        return handler(component, mx, my, button, x, y, value)
    else
        return false
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Traverse components and finds best handler with specified name
function runHandler(component, name, x, y, button, path, value)
    local position = get(component.position)
    local size = component.size
    if (not (position and size)) then
        return false
    end
    local mx = (x - position[1]) * size[1] / position[3]
    local my = (y - position[2]) * size[2] / position[4]
    for i = #component.components, 1, -1 do
        local v = component.components[i]
        if toboolean(get(v.visible)) and isInRect(get(v.position), mx, my) then
            local res = runHandler(v, name, mx, my, button, path, value)
            if res then
                if path then
                    table.insert(path, component)
                end
                return true
            end
        end
    end
    local res = runComponentHandler(component, name, mx, my, button, x, y, value)
    if res then
        if path then
            table.insert(path, component)
        end
    end
    return res
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Returns path to component under mouse
function getFocusedPath(component, x, y, path)
    table.insert(path, component)
    local position = get(component.position)
    local size = component.size
    if (not (position and size)) then
        return
    end
    local mx = (x - position[1]) * size[1] / position[3]
    local my = (y - position[2]) * size[2] / position[4]
    for i = #component.components, 1, -1 do
        local v = component.components[i]
        if toboolean(get(v.visible)) and isInRect(get(v.position), mx, my) then
            getFocusedPath(v, mx, my, path)
        end
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Returns path to component under mouse
function getTopFocusedPath(layer, x, y)
    local path = { }
    if (1 == layer) or (3 == layer) then
        getFocusedPath(popups, x, y, path)
        if 1 < #path then
            return path
        end
        path = { }
    end
    if (2 == layer) or (3 == layer) then
        getFocusedPath(panel, x, y, path)
    end
    return path
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Run handler of pressed component
function runPressedHandler(path, name, x, y, button, value)
    local mx = x
    local my = y
    local px = x
    local py = y
    for i = #path, 1, -1 do
        local c = path[i]
        px = mx
        py = my
        local position = get(c.position)
        local size = get(c.size)
        mx = (mx - position[1]) * c.size[1] / position[3]
        my = (my - position[2]) * c.size[2] / position[4]
    end
    return runComponentHandler(path[1], name, mx, my, button, px, py, value)
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Traverse components and finds best handler with specified name
function runTopHandler(layer, name, x, y, button, value)
    local path = { }
    if (1 == layer) or (3 == layer) then
        local res = runHandler(popups, name, x, y, button, path, value)
        if res then
            return true, path
        end
    end
    if (2 == layer) or (3 == layer) then
        return runHandler(panel, name, x, y, button, path, value), path
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Returns value of cursor property for specified layer
function getTopCursorShape(layer, x, y)
    if (1 == layer) or (3 == layer) then
        local cursor = getCursorShape(popups, x, y)
        if cursor then
            return cursor
        end
    end
    if (2 == layer) or (3 == layer) then
        return getCursorShape(panel, x, y)
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Returns value of cursor property
function getCursorShape(component, x, y)
    local position = get(component.position)
    local size = component.size
    if (not (position and size)) then
        return nil
    end
    local mx = (x - position[1]) * size[1] / position[3]
    local my = (y - position[2]) * size[2] / position[4]
    for i = #component.components, 1, -1 do
        local v = component.components[i]
        if toboolean(get(v.visible)) and isInRect(get(v.position), mx, my) then
            local res = getCursorShape(v, mx, my)
            if res then
                return res
            end
        end
    end
    return rawget(component, "cursor")
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Set shape of cursor
function setCursor(x, y, shape, layer)
    if (2 ~= layer) then
        cursor.x = x
        cursor.y = y
    end
    cursor.shape = get(shape)
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Draw cursor shape
function drawCursor()		
    if cursor.shape and cursor.shape.shape then
        drawTexture(cursor.shape.shape, 
                cursor.shape.x + cursor.x, cursor.y - cursor.shape.y,
                cursor.shape.width, cursor.shape.height,
                1, 1, 1, 1)
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Pressed button number
local pressedButton = 0

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Path to component after mouse press
local pressedComponentPath = nil

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Update pressed component path
function setPressedPath(path)
    pressedComponentPath = path
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Path to focused component
local focusedComponentPath = nil

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Update focused component path
function setFocusedPath(path)
    if path and (0 == #path) then
        path = nil
    end
    if focusedComponentPath then
        for _, c in pairs(focusedComponentPath) do
            set(c.focused, false)
        end
    end
    focusedComponentPath = path
    if focusedComponentPath then
        for _, c in ipairs(focusedComponentPath) do
            set(c.focused, true)
        end
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Traverse visible focused components and call specified function
function traverseFocused(char, key, func)
    if focusedComponentPath then
        local maxVisible = 0
        for i = 1, #focusedComponentPath, 1 do
            local c = focusedComponentPath[i]
            if toboolean(get(c.visible)) then
                maxVisible = i
            else
                break;
            end
        end
        for i = maxVisible, 1, -1 do
            local c = focusedComponentPath[i]
            local res = c[func](c, char, key)
            if res then
                return true
            end
        end
    end
    return false
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- SIMULATOR MOUSE CALLBACKS HANDLERS ---------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Called when mouse button was pressed
function onMouseDown(x, y, button, layer)
    setFocusedPath(getTopFocusedPath(layer, x, y))
    pressedButton = button
    local handled, path = runTopHandler(layer, "onMouseDown", x, y, button, 0)
    if handled then
        setPressedPath(path)
        if (1 == layer) or (3 == layer) then
            local comp = path[1]
            for i, v in pairs(popups.components) do
                if v == comp then
                    table.remove(popups.components, i)
                    table.insert(popups.components, comp)
                    setPressedPath(nil)
                    return handled
                end
            end
        end
    end
	return handled
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Called when mouse button was released
function onMouseUp(x, y, button, layer)
    if pressedComponentPath then
        local res = runPressedHandler(pressedComponentPath, "onMouseUp", 
                x, y, button, 0)
        pressedButton = 0
        setPressedPath(nil)
        return res
    else
        return runTopHandler(layer, "onMouseUp", x, y, button, 0)
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Called when mouse click event was processed
function onMouseClick(x, y, button, layer)
    if pressedComponentPath then
        setCursor(x, y, cursor.shape, layer)
        return runPressedHandler(pressedComponentPath, "onMouseClick", 
                x, y, button, 0)
    else
        pressedButton = button
        local handled, path = runTopHandler(layer, "onMouseClick", x, y, button, 0)
        if handled then
            setPressedPath(path)
        end
        return handled
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Called when mouse wheel event was processed
function onMouseWheel(x, y, wheelClicks, layer)
	 if pressedComponentPath then
        local res = runPressedHandler(pressedComponentPath, "onMouseWheel", 
                x, y, 4, wheelClicks)
        return res
    else
        return runTopHandler(layer, "onMouseWheel", x, y, 4, wheelClicks)
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Called when mouse motion event was processed
function onMouseMove(x, y, layer)
    local cursorArrow = false
    if pressedComponentPath then
        cursorArrow = true
    else
        if ((1 == layer) or (3 == layer)) and 0 < #popups.components then
            local size = popups.size
            local position = get(popups.position)
            local mx = (x - position[1]) * size[1] / position[3]
            local my = (y - position[2]) * size[2] / position[4]
            for i = #popups.components, 1, -1 do
                local v = popups.components[i]
                if toboolean(get(v.visible)) and 
                        isInRect(get(v.position), mx, my) 
                then
                    cursorArrow = true
                    break
                end
            end
        end
    end
    if pressedComponentPath then
        setCursor(x, y, cursor.shape, layer)
        local res = runPressedHandler(pressedComponentPath, "onMouseMove", 
                x, y, pressedButton, 0)
    else
        local cursor = getTopCursorShape(layer, x, y)
        setCursor(x, y, cursor, layer)
        local res = runTopHandler(layer, "onMouseMove", x, y, pressedButton, 0)
    end
    return cursorArrow
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- SIMULATOR KEY CALLBACKS HANDLERS -------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Called when button pressed
function onKeyDown(char, key)
    return traverseFocused(char, key, 'onKeyDown')
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Called when button released
function onKeyUp(char, key)
    return traverseFocused(char, key, 'onKeyUp')
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------
-- GLOBAL DATA -------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- List of paths to search module components
searchPath = { ".", "" }

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- List of paths to search module resources (images, fonts, shaders, sounds, objects)
searchResourcesPath = { ".", "" }

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Add path to search path
function addSearchPath(path)
    table.insert(searchPath, 1, path)
    table.insert(searchResourcesPath, 1, path)
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Remove search path
function popSearchPath()
    table.remove(searchPath, 1)
    table.remove(searchResourcesPath, 1)
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Add path to images search path
function addSearchResourcesPath(path)
    table.insert(searchResourcesPath, 1, path)
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Saved panelsPositions
panelsPositions = nil

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Cursor texture and position
cursor = {
    x = 0,
    y = 0,
    shape = nil
}

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- MAIN ENTITIES AND FUNCTIONS TO INTERACT WITH THEM ---------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Main panel
panel = createComponent("panel")

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Popups layer
popups = createComponent("popups", panel)

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Resizes panel
function resizePanel(width, height)
    set(panel.position, { 0, 0, width, height })
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Resizes popups 
function resizePopup(width, height)
    set(popups.position, { 0, 0, width, height })
    popups.size[1] = width
    popups.size[2] = height
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Move panel to top of screen
function movePanelToTop(panel)
    for i, v in pairs(popups.components) do
        if v == panel then
            table.remove(popups.components, i)
            table.insert(popups.components, panel)
            return
        end
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- MODULE LOADER ---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Loads module from main module file
function loadModule(fileName, panelWidth, panelHeight, popupWidth, popupHeight)
    popups = createComponent("popups")
    popups.position = createProperty { 0, 0, popupWidth, popupHeight }
    popups.size = { popupWidth, popupHeight }

    panelsPositions = loadTableFromFile(moduleDirectory .. '/panels.txt', 'positions')

    local c = loadComponent("panel", fileName)
    if not c then
        logError("Error loading panel", fileName)
        return nil
    end
    panel = c({position = { 0, 0, panelWidth, panelHeight}})

    return panel
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- COMMON CALLERS --------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Call callback function
function callCallback(name, component)
    local handler = rawget(component, name)
    if handler then
        handler()
    end
    for i = #component.components, 1, -1 do
        callCallback(name, component.components[i])
    end
end

-- Call callback for both panel and popups
function callCallbackForAll(name)
    callCallback(name, popups)
    callCallback(name, panel)
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- COMMON SIMULATOR CALLBACK HANDLERS --------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Called whenever the user's plane is positioned at a new airport
function onAirportLoaded()
    callCallbackForAll("onAirportLoaded")
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Called whenever new scenery is loaded
function onSceneryLoaded()
    callCallbackForAll("onSceneryLoaded")
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Called whenever the user adjusts the number of X-Plane aircraft models
function onAirplaneCountChanged()
    callCallbackForAll("onAirplaneCountChanged")
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Called whenever user plane is crashed. Returns 1 if SASL system is need to be reloaded, 0 otherwise
function onPlaneCrash()
	local planeCrashHandler = rawget(panel, 'onPlaneCrash')
	needReload = 1
    if planeCrashHandler then
		needReload = planeCrashHandler()
    end
	if needReload == 0 then
		for i = #panel.components, 1, -1 do
			callCallback('onPlaneCrash', panel.components[i])
		end
		callCallback('onPlaneCrash', popups)
	end
	return needReload
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Called when module about to unload
function doneModules()
    callCallbackForAll("onModuleDone")
    savePopupsPositions()
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------