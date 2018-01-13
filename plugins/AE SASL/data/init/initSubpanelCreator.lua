---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- SUBPANEL CREATOR -----------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Create popup movable resizable subpanel hidden by default
function subpanel(tbl)
    local name = tbl.name
    if nil == name then
        name = 'subpanel'
    end
    local c = createComponent(name, popups)
    set(c.position, tbl.position)
    set(c.clip, tbl.clip)
	set(c.clipSize, tbl.clipSize)
    set(c.fbo, tbl.fbo)
    c.size = { tbl.position[3], tbl.position[4] }
    c.onMouseClick = function (comp, x, y, button, parentX, parentY)
        defaultOnMouseClick(comp, x, y, button, parentX, parentY)
        return true
    end
    c.onMouseDown = function (comp, x, y, button, parentX, parentY)
        defaultOnMouseDown(comp, x, y, button, parentX, parentY)
        return true
    end
    c.onMouseMove = function (comp, x, y, button, parentX, parentY)
        defaultOnMouseMove(comp, x, y, button, parentX, parentY)
        return true
    end
	
	if tbl.visible then
		set(c.visible, tbl.visible)
	else
		set(c.visible, false)
	end
	
    set(c.movable, true)
    if get(tbl.noMove) then
        set(c.movable, false)
    end
    if get(tbl.savePosition) then
        set(c.savePosition, true);
    end
    c.cursor = { x = 0, y = 0, width = 0, height = 0, shape = loadImage("none.png") }
    c.components = tbl.components

    startComponentsCreation(tbl)
    if not get(tbl.noBackground) then
        if not rectangle then
            rectangle = loadComponent('rectangle')
        end
    
        table.insert(c.components, 1,
            rectangle { position = { 0, 0, c.size[1], c.size[2] } } )
    end

    if not get(tbl.noClose) then
        local pos = get(c.position)
        local btnWidth = c.size[1] / pos[3] * 16
        local btnHeight = c.size[2] / pos[4] * 16

        if not button then
            button = loadComponent('button')
        end

        c.component('closeButton', button { 
            position = { c.size[1] - btnWidth, c.size[2] - btnHeight, 
                btnWidth, btnHeight };
            image = loadImage('close.png');
            onMouseClick = function()
                set(c.visible, false)
                return true
            end;
        })
    end

    if not get(tbl.noResize) then
        set(c.resizable, true)
        local pos = get(c.position)
        c.resizeWidth = c.size[1] / pos[3] * 10
        c.resizeHeight = c.size[2] / pos[4] * 10
        
        if not rectangle then
            rectangle = loadComponent('rectangle')
        end
        
        c.resizeRect = { c.size[1] - c.resizeWidth, 0, 
                c.resizeWidth, c.resizeHeight };

        c.component('resizeButton', rectangle { 
            position = c.resizeRect;
            color = { 0.10, 0.10, 0.10, 1.0 };
        });
        
        if not clickable then
            clickable = loadComponent('clickable')
        end

        c.component('resizeClickable', clickable {
            position = c.resizeRect;
            cursor = { 
                x = 8, 
                y = 26, 
                width = 16, 
                height = 16, 
                shape = loadImage("clickable.png")
            }
        });
    end
    finishComponentsCreation()

    if get(tbl.command) then
        -- Register panel popup command
        local command = createCommand(get(tbl.command), get(tbl.description))

        -- Show or hide panel on command received
        function commandHandler(phase)
            if 0 == phase then
                set(c.visible, not toboolean(get(c.visible)))
                if toboolean(get(c.visible)) then
                    movePanelToTop(c)
                end
            end
            return 0
        end

        -- Register created command handler
        registerCommandHandler(command, 0, commandHandler)
    end
    
    if panelsPositions and get(c.savePosition) and ('subpanel' ~= name) then
        local pos = panelsPositions[name]
        if pos then
            set(c.position, pos)
        end
    end

    popup(c)

    return c
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Save positions of popup components
function savePopupsPositions()
    local positions = { }
    for _k, c in pairs(popups.components) do
        if get(c.savePosition) and ('subpanel' ~= get(c.name)) then
            positions[get(c.name)] = get(c.position)
        end
    end

    if not #positions then
        return
    end

    local fileName = panelDir .. '/panels.txt'
    local f = io.open(fileName, 'w+')
    if nil ~= f then
        saveTableToFile(f, positions, 'positions')
        f:close()
    else
        logWarning("Can't open file '" .. fileName .. "' for writing")
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------