---------------------------------------------------------------------------------------------------------------------------
-- PROPERTIES ---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Returns true if argument is property
function isProperty(value)
    return ("table" == type(value)) and (1 == value.__property)
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Returns value of property
-- Traverse recursive properties
function get(property, doNotCall, offset, numValues)
    if isProperty(property) then
        if property.get then
            return property:get(doNotCall, offset, numValues)
        else
            if isProperty(property.value) then
                return get(property.value, doNotCall, offset, numValues)
            else
                return property.value
            end
        end
    else
        if (not doNotCall) and ("function" == type(property)) then
            return property()
        else
            return property
        end
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Set value of property
function set(property, value, offset, numValues)
    if property.set then
        property:set(value, offset, numValues)
    else
        if isProperty(property.value) then
            set(property.value, value, offset, numValues)
        else
            property.value = value
        end
    end
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Convert values from table to properties
function argumentsToProperties(arguments)
    local res = {}
    for k, v in pairs(arguments) do
        if "function" == type(v) then
            res[k] = v
        else
            if isProperty(v) then
                res[k] = v
            else
                res[k] = createProperty(v)
            end
        end
    end
    return res
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Create new property table
function createProperty(value)
    if isProperty(value) then
        return value
    end

    local prop = { __property = 1 }
    if "function" == type(value) then
        prop.get = value
    else
        prop.value = value
    end
    return prop
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- PROPERTIES CREATORS -------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Returns simulator double property
function globalPropertyd(name, suppressWarns)
	if suppressWarns == nil then suppressWarns = false end
    
	local types = fetchDataRef(name)	
	local get, set
	local ref = findDataRef(name, types[1])		
	
	if types[1] == TYPE_FLOAT or types[1] == TYPE_DOUBLE or types[1] == TYPE_INT then 
		get = function(doNotCall) return getDataRef(ref); end
		set = function(self, value) setDataRef(ref, value); end	
	elseif types[1] == TYPE_STRING then 
		get = function(doNotCall) return 0 end
		set = function(self, value) setDataRef(ref, tostring(value)); end		
		if not suppressWarns then
			logWarning('"'..name..'": '.."Casting "..propTypeToString(types[1]).." to "..propTypeToString(TYPE_DOUBLE))
		end
	else
		get = function(doNotCall) return 0; end
		logWarning('"'..name..'": '.."Can't cast "..propTypeToString(types[1]).." to "..propTypeToString(TYPE_DOUBLE))
	end	
	
    return {
        __property = 1;
		name = name;
        get = get;        
        set = set;
		free = function() freeDataRef(ref); end;
    }
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Create new double property and set default value
function createGlobalPropertyd(name, default, isNotPublished, isShared)
	if isNotPublished == nil then isNotPublished = false end
	if isShared == nil then isShared = false end

	local ref = createDataRef(name, TYPE_DOUBLE, isNotPublished, isShared)		
	if default ~= nil then setDataRef(ref, default) else setDataRef(ref, 0) end
	return {
        __property = 1;
		name = name;
        get = function(doNotCall) return getDataRef(ref); end;        
        set = function(self, value) setDataRef(ref, value); end;
		free = function() freeDataRef(ref); end;		
    }
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Create new functional double property
function createFunctionalPropertyd(name, getter, setter, isNotPublished)
	if isNotPublished == nil then isNotPublished = false end

	local ref = createFunctionalDataRef(name, TYPE_DOUBLE, getter, setter, isNotPublished)		
	return {
        __property = 1;
		name = name;
        get = function(doNotCall) return getDataRef(ref); end;        
        set = function(self, value) setDataRef(ref, value); end;
		free = function() freeDataRef(ref); end;		
    }
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Returns simulator float property
function globalPropertyf(name, suppressWarns)
	if suppressWarns == nil then suppressWarns = false end

    local types = fetchDataRef(name)	
	local get, set
	local ref = findDataRef(name, types[1])		
	
	if types[1] == TYPE_FLOAT or types[1] == TYPE_DOUBLE or types[1] == TYPE_INT then 
		get = function(doNotCall) return getDataRef(ref); end
		set = function(self, value) setDataRef(ref, value); end	
	elseif types[1] == TYPE_STRING then 
		get = function(doNotCall) return 0 end
		set = function(self, value) setDataRef(ref, tostring(value)); end
		if not suppressWarns then		
			logWarning('"'..name..'": '.."Casting "..propTypeToString(types[1]).." to "..propTypeToString(TYPE_FLOAT))
		end
	else
		get = function(doNotCall) return 0; end
		logWarning('"'..name..'": '.."Can't cast "..propTypeToString(types[1]).." to "..propTypeToString(TYPE_FLOAT))
	end	
	
    return {
        __property = 1;
		name = name;
        get = get;        
        set = set;
		free = function() freeDataRef(ref); end;		
    }
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Create new float property and set default value
function createGlobalPropertyf(name, default, isNotPublished, isShared)
	if isNotPublished == nil then isNotPublished = false end
	if isShared == nil then isShared = false end
	
    local ref = createDataRef(name, TYPE_FLOAT, isNotPublished, isShared)		
	if default ~= nil then setDataRef(ref, default) else setDataRef(ref, 0) end
	return {
        __property = 1;
		name = name;
        get = function(doNotCall) return getDataRef(ref); end;        
        set = function(self, value) setDataRef(ref, value); end;
		free = function() freeDataRef(ref); end;		
    }
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Create new functional float property
function createFunctionalPropertyf(name, getter, setter, isNotPublished)
	if isNotPublished == nil then isNotPublished = false end
	
    local ref = createFunctionalDataRef(name, TYPE_FLOAT, getter, setter, isNotPublished)		
	return {
        __property = 1;
		name = name;
        get = function(doNotCall) return getDataRef(ref); end;        
        set = function(self, value) setDataRef(ref, value); end;
		free = function() freeDataRef(ref); end;		
    }
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Returns simulator int property
function globalPropertyi(name, suppressWarns)
	if suppressWarns == nil then suppressWarns = false end

    local types = fetchDataRef(name)	
	local get, set
	local ref = findDataRef(name, types[1])		
	
	if types[1] == TYPE_INT then 
		get = function(doNotCall) return getDataRef(ref); end
		set = function(self, value) setDataRef(ref, value); end
	elseif types[1] == TYPE_FLOAT or types[1] == TYPE_DOUBLE then 
		get = function(doNotCall) return math.floor(getDataRef(ref)); end      
		set = function(self, value) setDataRef(ref, math.floor(value)); end
		if not suppressWarns then	
			logWarning('"'..name..'": '.."Casting "..propTypeToString(types[1]).." to "..propTypeToString(TYPE_INT))
		end
	elseif types[1] == TYPE_STRING then 
		get = function(doNotCall) return 0 end
		set = function(self, value) setDataRef(ref, tostring(value)); end
		if not suppressWarns then	
			logWarning('"'..name..'": '.."Casting "..propTypeToString(types[1]).." to "..propTypeToString(TYPE_INT))
		end
	else
		get = function(doNotCall) return 0; end      
		logWarning('"'..name..'": '.."Can't cast "..propTypeToString(types[1]).." to "..propTypeToString(TYPE_INT))
	end	
	
    return {
        __property = 1;
		name = name;
        get = get;        
        set = set;
		free = function() freeDataRef(ref); end;
    }
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Create new int property and set default value
function createGlobalPropertyi(name, default, isNotPublished, isShared)	
	if isNotPublished == nil then isNotPublished = false end
	if isShared == nil then isShared = false end
	
    local ref = createDataRef(name, TYPE_INT, isNotPublished, isShared)		
	if default ~= nil then setDataRef(ref, default) else setDataRef(ref, 0) end
	return {
        __property = 1;
		name = name;
        get = function(doNotCall) return getDataRef(ref); end;        
        set = function(self, value) setDataRef(ref, value); end;
		free = function() freeDataRef(ref); end;
    }
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Create new functional int property
function createFunctionalPropertyi(name, getter, setter, isNotPublished)	
	if isNotPublished == nil then isNotPublished = false end
	
    local ref = createFunctionalDataRef(name, TYPE_INT, getter, setter, isNotPublished)		
	return {
        __property = 1;
		name = name;
        get = function(doNotCall) return getDataRef(ref); end;        
        set = function(self, value) setDataRef(ref, value); end;
		free = function() freeDataRef(ref); end;
    }
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Returns simulator string property
function globalPropertys(name, suppressWarns)
	if suppressWarns == nil then suppressWarns = false end

    local types = fetchDataRef(name)	
	local get, set
	local ref = findDataRef(name, types[1])		
	
	if types[1] == TYPE_STRING then 
		get = function(doNotCall) return getDataRef(ref); end
		set = function(self, value) setDataRef(ref, value); end
	elseif types[1] == TYPE_FLOAT or types[1] == TYPE_INT or types[1] == TYPE_DOUBLE then 
		get = function(doNotCall) return tostring(getDataRef(ref)); end      
		set = function(self, value) setDataRef(ref, 0); end
		if not suppressWarns then	
			logWarning('"'..name..'": '.."Casting "..propTypeToString(types[1]).." to " ..propTypeToString(TYPE_STRING))
		end
	else
		get = function(doNotCall) return 0; end		
		logWarning('"'..name..'": '.."Can't cast "..propTypeToString(types[1]).." to "..propTypeToString(TYPE_STRING))
	end	
	
    return {
        __property = 1;
		name = name;
        get = get;        
        set = set;
		size = function() getDataRefSize(ref); end;
		free = function() freeDataRef(ref); end;
    }
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Create new string property and set default value
function createGlobalPropertys(name, default, isNotPublished, isShared)
	if isNotPublished == nil then isNotPublished = false end
	if isShared == nil then isShared = false end

    local ref = createDataRef(name, TYPE_STRING, isNotPublished, isShared)		
	if default ~= nil then setDataRef(ref, default) else setDataRef(ref, '') end
	return {
        __property = 1;
		name = name;
        get = function(doNotCall) return getDataRef(ref); end;        
        set = function(self, value) setDataRef(ref, value); end;
		size = function() getDataRefSize(ref); end;
		free = function() freeDataRef(ref); end;
    }
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Create new functional string property
function createFunctionalPropertys(name, getter, setter, isNotPublished)
	if isNotPublished == nil then isNotPublished = false end

    local ref = createFunctionalDataRef(name, TYPE_STRING, getter, setter, isNotPublished)		
	return {
        __property = 1;
		name = name;
        get = function(doNotCall) return getDataRef(ref); end;        
        set = function(self, value) setDataRef(ref, value); end;
		size = function() getDataRefSize(ref); end;
		free = function() freeDataRef(ref); end;
    }
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Returns simulator int array property
function globalPropertyia(name, suppressWarns)
	if suppressWarns == nil then suppressWarns = false end

    local types = fetchDataRef(name)	
	local get, set
	local ref = findDataRef(name, types[1])		
	
	if types[1] == TYPE_INT_ARRAY then 
		get = function(doNotCall, offset, numValues)
			if offset == nil and numValues == nil then
				return getDataRef(ref)
			else 
				return getDataRef(ref, offset, numValues)
			end
		end
		set = function(self, value, offset, numValues) 
			if offset == nil and numValues == nil then
				setDataRef(ref, value)
			else 
				setDataRef(ref, value, offset, numValues)
			end
		end
	elseif types[1] == TYPE_FLOAT_ARRAY then 
		get = function(doNotCall, offset, numValues) 
			if offset == nil and numValues == nil then
				return math.tablefloor(getDataRef(ref)) 
			else
				return math.tablefloor(getDataRef(ref, offset, numValues)) 
			end
		end      
		set = function(self, value, offset, numValues)
			if offset == nil and numValues == nil then
				setDataRef(ref, math.tablefloor(value))
			else
				setDataRef(ref, math.tablefloor(value), offset, numValues)
			end
		end	
		if not suppressWarns then	
			logWarning('"'..name..'": '.."Casting "..propTypeToString(types[1]).." to "..propTypeToString(TYPE_INT_ARRAY))
		end
	else
		get = function(doNotCall) return 0; end      
		logWarning('"'..name..'": '.."Can't cast "..propTypeToString(types[1]).." to "..propTypeToString(TYPE_INT_ARRAY))
	end	
	
    return {
        __property = 1;
		name = name;
        get = get;        
        set = set;
		size = function() getDataRefSize(ref); end;
	    free = function() freeDataRef(ref); end;		
    }
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Create new int array property
function createGlobalPropertyia(name, default, isNotPublished, isShared)
	if isNotPublished == nil then isNotPublished = false end
	if isShared == nil then isShared = false end
	
    local ref = createDataRef(name, TYPE_INT_ARRAY, isNotPublished, isShared)		
	if default ~= nil then setDataRef(ref, default) end
	
	return {
        __property = 1;
		name = name;
        get = function(doNotCall, offset, numValues) 
			if offset == nil and numValues == nil then
				return getDataRef(ref) 
			else 
				return getDataRef(ref, offset, numValues) 
			end
		end;        
        set = function(self, value, offset, numValues)
			if offset == nil and numValues == nil then
				setDataRef(ref, value)
			else 
				setDataRef(ref, value, offset, numValues)
			end
		end;
		size = function() getDataRefSize(ref); end;
		free = function() freeDataRef(ref); end;
    }
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Create new functional int array property
function createFunctionalPropertyia(name, getter, setter, isNotPublished)
	if isNotPublished == nil then isNotPublished = false end
	
    local ref = createFunctionalDataRef(name, TYPE_INT_ARRAY, getter, setter, isNotPublished)		
	return {
        __property = 1;
		name = name;
        get = function(doNotCall, offset, numValues) 
			if offset == nil and numValues == nil then
				return getDataRef(ref) 
			else 
				return getDataRef(ref, offset, numValues) 
			end
		end;        
        set = function(self, value, offset, numValues)
			if offset == nil and numValues == nil then
				setDataRef(ref, value)
			else 
				setDataRef(ref, value, offset, numValues)
			end
		end;
		size = function() getDataRefSize(ref); end;
		free = function() freeDataRef(ref); end;
    }
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Returns simulator float array property
function globalPropertyfa(name, suppressWarns)
    local types = fetchDataRef(name)	
	local get, set
	local ref = findDataRef(name, types[1])		
	
	if types[1] == TYPE_FLOAT_ARRAY or  types[1] == TYPE_INT_ARRAY then 
		get = function(doNotCall, offset, numValues)
			if offset == nil and numValues == nil then
				return getDataRef(ref) 
			else
				return getDataRef(ref, offset, numValues) 
			end
		end
		set = function(self, value, offset, numValues) 
			if offset == nil and numValues == nil then 
				setDataRef(ref, value)
			else
				setDataRef(ref, value, offset, numValues)
			end
		end	
	else
		get = function(doNotCall) return 0; end	
		logWarning('"'..name..'": '.."Can't cast "..propTypeToString(types[1]).." to "..propTypeToString(TYPE_FLOAT_ARRAY))
	end	
	
    return {
        __property = 1;
		name = name;
		size = size;
        get = get;        
        set = set;
		size = function() getDataRefSize(ref); end;
		free = function() freeDataRef(ref); end;
    }
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Create new float array property
function createGlobalPropertyfa(name, default, isNotPublished, isShared)
	if isNotPublished == nil then isNotPublished = false end
	if isShared == nil then isShared = false end
	
    local ref = createDataRef(name, TYPE_FLOAT_ARRAY, isNotPublished, isShared)		
	if default ~= nil then setDataRef(ref, default) end
	return {
        __property = 1;
		name = name;
        get = function(doNotCall, offset, numValues) 
			if offset == nil and numValues == nil then
				return getDataRef(ref) 
			else 
				return getDataRef(ref, offset, numValues) 
			end
		end;        
        set = function(self, value, offset, numValues)
			if offset == nil and numValues == nil then
				setDataRef(ref, value)
			else
				setDataRef(ref, value, offset, numValues)
			end
		end;
		size = function() getDataRefSize(ref); end;
		free = function() freeDataRef(ref); end;
    }
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Create new functional float array property
function createFunctionalPropertyfa(name, getter, setter, isNotPublished)
	if isNotPublished == nil then isNotPublished = false end
	
    local ref = createFunctionalDataRef(name, TYPE_FLOAT_ARRAY, getter, setter, isNotPublished)		
	return {
        __property = 1;
		name = name;
        get = function(doNotCall, offset, numValues) 
			if offset == nil and numValues == nil then
				return getDataRef(ref) 
			else 
				return getDataRef(ref, offset, numValues) 
			end
		end;        
        set = function(self, value, offset, numValues)
			if offset == nil and numValues == nil then
				setDataRef(ref, value)
			else
				setDataRef(ref, value, offset, numValues)
			end
		end;
		size = function() getDataRefSize(ref); end;
		free = function() freeDataRef(ref); end;
    }
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Properties types-to-string converter
function propTypeToString(propType)
	local str = 'none'
	if propType == TYPE_INT then str = 'integer'
	elseif propType == TYPE_FLOAT then str = 'float'
	elseif propType == TYPE_DOUBLE then str = 'double'
	elseif propType == TYPE_STRING then str = 'string'
	elseif propType == TYPE_INT_ARRAY then str = 'integer array'
	elseif propType == TYPE_FLOAT_ARRAY then str = 'float array'
	end
	return str
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------