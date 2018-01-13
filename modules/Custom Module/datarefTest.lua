--------------------------------------------------------------------------------------------------------------
-- Stuff for testing -----------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

IDatarefID = "sim/aircraft/engine/acf_num_engines"
FDatarefID = "sim/aircraft/engine/acf_throtmax_FWD"
SDatarefID = "sim/aircraft/view/acf_tailnum"
IADatarefID = "sim/aircraft/panel/acf_ins_type"
FADatarefID = "sim/aircraft/panel/acf_ins_size"
IADatarefIDS = "sim/aircraft/prop/acf_num_blades"
FDDatarefID = "sim/flightmodel/position/local_x"
NDatarefID = "sim/notdefined/testdataref"

IDatarefIDCustom = "1-sim/test/integer"
DDatarefIDCustom = "1-sim/test/double" 
FDatarefIDCustom = "1-sim/test/float"
SDatarefIDCustom = "1-sim/test/string"
IADatarefIDCustom = "1-sim/test/int_array"
FADatarefIDCustom = "1-sim/test/float_array"

IDatarefIDCustomFunc = "1-sim/test/integer_func"
DDatarefIDCustomFunc = "1-sim/test/double_func" 
FDatarefIDCustomFunc = "1-sim/test/float_func"
SDatarefIDCustomFunc = "1-sim/test/string_func"
IADatarefIDCustomFunc = "1-sim/test/int_array_func"
FADatarefIDCustomFunc = "1-sim/test/float_array_func"

floatingEpsilon = 0.00001

--------------------------------------------------------------------------------------------------------------
-- Datarefs C API ------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

TestFetchDataref = {}
	function TestFetchDataref:testTypesExisting() 
		local dataTypeI = fetchDataRef(IDatarefID)
		luaunit.assertIsTable(dataTypeI)
		luaunit.assertEquals(dataTypeI[1], TYPE_INT)
		
		local dataTypeF = fetchDataRef(FDatarefID)
		luaunit.assertIsTable(dataTypeF)
		luaunit.assertEquals(dataTypeF[1], TYPE_FLOAT)
		
		local dataTypeS = fetchDataRef(SDatarefID)
		luaunit.assertIsTable(dataTypeS)
		luaunit.assertEquals(dataTypeS[1], TYPE_STRING)
		
		local dataTypeIA = fetchDataRef(IADatarefID)
		luaunit.assertIsTable(dataTypeIA)
		luaunit.assertEquals(dataTypeIA[1], TYPE_INT_ARRAY)
		
		local dataTypeFA = fetchDataRef(FADatarefID)
		luaunit.assertIsTable(dataTypeFA)
		luaunit.assertEquals(dataTypeFA[1], TYPE_FLOAT_ARRAY)	
	end
	
	function TestFetchDataref:testTypesNonExisting() 
		local dataType = fetchDataRef(NDatarefID)
		luaunit.assertNil(dataType)
	end
	
TestFindDataref = {}
	function TestFindDataref:testFindExisting()
		local datarefID = findDataRef(IDatarefID, TYPE_INT)
		luaunit.assertIsNumber(datarefID)
		
		datarefID = findDataRef(IDatarefID, TYPE_FLOAT)
		luaunit.assertNil(datarefID)
		
		datarefID = findDataRef(FDDatarefID, TYPE_FLOAT)
		luaunit.assertIsNumber(datarefID)
		
		datarefID = findDataRef(FDDatarefID, TYPE_DOUBLE)
		luaunit.assertIsNumber(datarefID)
	end
	
	function TestFindDataref:testFindNonExisting()
		local datarefID = findDataRef(NDatarefID, TYPE_STRING)
		luaunit.assertNil(datarefID)
	end
	
TestDatarefIO = {}
	function TestDatarefIO:setup()
		Idataref = findDataRef(IDatarefID, TYPE_INT)
		Fdataref = findDataRef(FDatarefID, TYPE_FLOAT)
		Sdataref = findDataRef(SDatarefID, TYPE_STRING)
		IAdataref = findDataRef(IADatarefID, TYPE_INT_ARRAY)
		FAdataref = findDataRef(FADatarefID, TYPE_FLOAT_ARRAY)
		IAdatarefS = findDataRef(IADatarefIDS, TYPE_FLOAT_ARRAY)
	end
	function TestDatarefIO:teardown()
	
	end
	
	function TestDatarefIO:testSizes()
		local value = getDataRefSize(Idataref)
		luaunit.assertEquals(value, 1)
		
		value = getDataRefSize(Fdataref)
		luaunit.assertEquals(value, 1)
		
		value = getDataRefSize(Sdataref)
		luaunit.assertEquals(value, 40)
		
		value = getDataRefSize(IAdataref)
		luaunit.assertEquals(value, 200)
		
		value = getDataRefSize(FAdataref)
		luaunit.assertEquals(value, 200)
		
		value = getDataRefSize(IAdatarefS)
		luaunit.assertEquals(value, 8)
	end
	
	function TestDatarefIO:testGetters()
		local value = getDataRef(Idataref)
		luaunit.assertIsNumber(value)
		luaunit.assertEquals(value, 2)
		
		value = getDataRef(Fdataref)
		luaunit.assertIsNumber(value)
		luaunit.assertAlmostEquals(value, 1.13, floatingEpsilon)
		
		value = getDataRef(Sdataref)
		luaunit.assertIsString(value)
		luaunit.assertStrContains(value, 'P868IW')
		
		value = getDataRef(IAdataref)
		luaunit.assertIsTable(value)
		luaunit.assertEquals(#value, 200)
		luaunit.assertEquals(value[1], 889)
		luaunit.assertEquals(value[2], 252)
		luaunit.assertEquals(value[3], 274)
		luaunit.assertEquals(value[4], 291)
		luaunit.assertEquals(value[5], 290)
		
		value = getDataRef(FAdataref)
		luaunit.assertIsTable(value)
		luaunit.assertEquals(#value, 200)
		luaunit.assertAlmostEquals(value[1], 1.0, floatingEpsilon)
		luaunit.assertAlmostEquals(value[2], 0.98, floatingEpsilon)
		luaunit.assertAlmostEquals(value[3], 1.0, floatingEpsilon)
		luaunit.assertAlmostEquals(value[4], 1.33, floatingEpsilon)
		luaunit.assertAlmostEquals(value[5], 1.25, floatingEpsilon)
	end
	
	function TestDatarefIO:testSetters()
		local value
		
		setDataRef(Idataref, 4)
		value = getDataRef(Idataref)
		luaunit.assertEquals(value, 4)
		setDataRef(Idataref, 2)
		
		setDataRef(Fdataref, 1.26)
		value = getDataRef(Fdataref)
		luaunit.assertAlmostEquals(value, 1.26, floatingEpsilon)
		setDataRef(Fdataref, 1.13)
		
		setDataRef(Sdataref, 'TN123')
		value = getDataRef(Sdataref)
		luaunit.assertStrContains(value, 'TN123')
		setDataRef(Sdataref, 'P868IW')
		
		value = getDataRef(IAdataref)
		value[1] = 734
		value[2] = 219
		value[5] = 111
		setDataRef(IAdataref, value)
		value = getDataRef(IAdataref)
		luaunit.assertEquals(value[1], 734)
		luaunit.assertEquals(value[2], 219)
		luaunit.assertEquals(value[3], 274)
		luaunit.assertEquals(value[4], 291)
		luaunit.assertEquals(value[5], 111)
		value[1] = 889
		value[2] = 252
		value[5] = 290
		setDataRef(IAdataref, value)
		
		value = getDataRef(FAdataref)
		value[2] = 1.345
		value[3] = 1.1
		value[4] = 2.35
		setDataRef(FAdataref, value)
		value = getDataRef(FAdataref)
		luaunit.assertAlmostEquals(value[1], 1.0, floatingEpsilon)
		luaunit.assertAlmostEquals(value[2], 1.345, floatingEpsilon)
		luaunit.assertAlmostEquals(value[3], 1.1, floatingEpsilon)
		luaunit.assertAlmostEquals(value[4], 2.35, floatingEpsilon)
		luaunit.assertAlmostEquals(value[5], 1.25, floatingEpsilon)
		value[2] = 0.98
		value[3] = 1.0
		value[4] = 1.33
		setDataRef(FAdataref, value)
	end
	
	function TestDatarefIO:testPartialIO()
		local value
	
		value = getDataRef(IAdataref, 2, 3)
		luaunit.assertIsTable(value)
		luaunit.assertIsNumber(value[3])
		luaunit.assertNil(value[4])
		luaunit.assertEquals(#value, 3)
		luaunit.assertEquals(value[1], 252)
		luaunit.assertEquals(value[2], 274)
		luaunit.assertEquals(value[3], 291)
		value[1] = 211
		value[2] = 665
		value[3] = 103
		setDataRef(IAdataref, value, 1, 2)
		value = getDataRef(IAdataref)
		luaunit.assertEquals(value[1], 211)
		luaunit.assertEquals(value[2], 665)
		luaunit.assertEquals(value[3], 274)
		luaunit.assertEquals(value[4], 291)
		luaunit.assertEquals(value[5], 290)
		value[1] = 889
		value[2] = 252
		setDataRef(IAdataref, value)
		
		value = getDataRef(FAdataref, 3, 2)
		luaunit.assertIsTable(value)
		luaunit.assertEquals(#value, 2)
		luaunit.assertIsNumber(value[2])
		luaunit.assertNil(value[3])
		luaunit.assertAlmostEquals(value[1], 1.0, floatingEpsilon)
		luaunit.assertAlmostEquals(value[2], 1.33, floatingEpsilon)
		value[1] = 3.11
		value[2] = -0.89
		setDataRef(FAdataref, value, 2, 2)
		value = getDataRef(FAdataref)
		luaunit.assertAlmostEquals(value[1], 1.0, floatingEpsilon)
		luaunit.assertAlmostEquals(value[2], 3.11, floatingEpsilon)
		luaunit.assertAlmostEquals(value[3], -0.89, floatingEpsilon)
		luaunit.assertAlmostEquals(value[4], 1.33, floatingEpsilon)
		luaunit.assertAlmostEquals(value[5], 1.25, floatingEpsilon)
		value[2] = 0.98
		value[3] = 1.0
		setDataRef(FAdataref, value)
	end
	
	function TestDatarefIO:testRangeExceed()
		local value
	
		value = getDataRef(IAdataref, 211, 5)
		luaunit.assertNil(value)
		
		value = getDataRef(IAdataref, 1, 3)
		luaunit.assertIsTable(value)
		luaunit.assertEquals(#value, 3)
		luaunit.assertEquals(value[1], 889)
		luaunit.assertEquals(value[2], 252)
		luaunit.assertEquals(value[3], 274) 
		
		value = getDataRef(IAdataref, -11, -2)
		luaunit.assertNil(value)
		
		value = getDataRef(IAdatarefS, 7, 4)
		luaunit.assertIsTable(value)
		luaunit.assertEquals(#value, 2)
		luaunit.assertAlmostEquals(value[1], 2, floatingEpsilon)
		luaunit.assertAlmostEquals(value[2], 2, floatingEpsilon)
	end
	
	function TestDatarefIO:testBasicTypeCasts()
		local value
		
		setDataRef(Idataref, 8.9)
		value = getDataRef(Idataref)
		luaunit.assertEquals(value, 8)
		setDataRef(Idataref, 2)
		
		setDataRef(Fdataref, 3)
		value = getDataRef(Fdataref)
		luaunit.assertAlmostEquals(value, 3.0, floatingEpsilon)
		setDataRef(Fdataref, 1.13)
		
		value = getDataRef(IAdataref)
		value[1] = 234.8
		value[2] = 7.5
		value[5] = -123.2
		setDataRef(IAdataref, value)
		value = getDataRef(IAdataref)
		luaunit.assertEquals(value[1], 234)
		luaunit.assertEquals(value[2], 7)
		luaunit.assertEquals(value[3], 274)
		luaunit.assertEquals(value[4], 291)
		luaunit.assertEquals(value[5], -123)
		value[1] = 889
		value[2] = 252
		value[5] = 290
		setDataRef(IAdataref, value)
	end
	
TestCustomDatarefIO = {}
	function TestCustomDatarefIO:setup()
		IdatarefC = createDataRef(IDatarefIDCustom, TYPE_INT, false, false)
		FdatarefC = createDataRef(FDatarefIDCustom, TYPE_FLOAT, false, false)
		DdatarefC = createDataRef(DDatarefIDCustom, TYPE_DOUBLE, false, false)
		SdatarefC = createDataRef(SDatarefIDCustom, TYPE_STRING, false, false)
		IAdatarefC = createDataRef(IADatarefIDCustom, TYPE_INT_ARRAY, false, false)
		FAdatarefC = createDataRef(FADatarefIDCustom, TYPE_FLOAT_ARRAY, false, false)
	end
	
	function TestCustomDatarefIO:teardown() 
		freeDataRef(IdatarefC)
		freeDataRef(FdatarefC)
		freeDataRef(DdatarefC)
		freeDataRef(SdatarefC)
		freeDataRef(IAdatarefC)
		freeDataRef(FAdatarefC)
	end
	
	function TestCustomDatarefIO:testInitial()
		local value
		
		value = getDataRef(IdatarefC)
		luaunit.assertIsNumber(value)
		luaunit.assertEquals(value, 0)
		
		value = getDataRef(FdatarefC)
		luaunit.assertIsNumber(value)
		luaunit.assertAlmostEquals(value, 0.0, floatingEpsilon)
		
		value = getDataRef(DdatarefC)
		luaunit.assertIsNumber(value)
		luaunit.assertAlmostEquals(value, 0.0, floatingEpsilon)
		
		value = getDataRef(SdatarefC)
		luaunit.assertIsString(value)
		luaunit.assertEquals(value, '')
		
		value = getDataRef(IAdatarefC)
		luaunit.assertIsTable(value)
		luaunit.assertEquals(#value, 1)
		luaunit.assertEquals(value[1], 0)
		
		value = getDataRef(FAdatarefC)
		luaunit.assertIsTable(value)
		luaunit.assertEquals(#value, 1)
		luaunit.assertAlmostEquals(value[1], 0.0, floatingEpsilon)
	end
	
	function TestCustomDatarefIO:testIO()
		local value
		
		setDataRef(IdatarefC, 4)
		value = getDataRef(IdatarefC)
		luaunit.assertIsNumber(value)
		luaunit.assertEquals(value, 4)
		
		setDataRef(FdatarefC, -156.58)
		value = getDataRef(FdatarefC)
		luaunit.assertIsNumber(value)
		luaunit.assertAlmostEquals(value, -156.58, floatingEpsilon)
		
		setDataRef(DdatarefC, 12.13)
		value = getDataRef(DdatarefC)
		luaunit.assertIsNumber(value)
		luaunit.assertAlmostEquals(value, 12.13, floatingEpsilon)
		
		setDataRef(SdatarefC, 'cad78ert2/')
		value = getDataRef(SdatarefC)
		luaunit.assertIsString(value)
		luaunit.assertEquals(value, 'cad78ert2/')
		
		iatable = {12, -3, 14, 26}
		setDataRef(IAdatarefC, iatable)
		value = getDataRef(IAdatarefC)
		luaunit.assertIsTable(value)
		luaunit.assertEquals(#value, 4)
		luaunit.assertEquals(value[1], 12)
		luaunit.assertEquals(value[2], -3)
		luaunit.assertEquals(value[3], 14)
		luaunit.assertEquals(value[4], 26)
		
		fatable = {0.357, -2.34, 36.12}
		setDataRef(FAdatarefC, fatable)
		value = getDataRef(FAdatarefC)
		luaunit.assertIsTable(value)
		luaunit.assertEquals(#value, 3)
		luaunit.assertAlmostEquals(value[1], 0.357, floatingEpsilon)
		luaunit.assertAlmostEquals(value[2], -2.34, floatingEpsilon)
		luaunit.assertAlmostEquals(value[3], 36.12, floatingEpsilon)
	end
	
	function TestCustomDatarefIO:testPartialIO()
		local value
	
		iatable = {52, -13, 456, 455}
		setDataRef(IAdatarefC, iatable)
		value = getDataRef(IAdatarefC, 2, 2)
		luaunit.assertIsTable(value)
		luaunit.assertEquals(#value, 2)
		luaunit.assertEquals(value[1], -13)
		luaunit.assertEquals(value[2], 456)
		
		value = getDataRef(IAdatarefC, 2, 9)
		luaunit.assertEquals(#value, 3)
		luaunit.assertEquals(value[3], 455)
		
		value = getDataRef(IAdatarefC, 6, 0)
		luaunit.assertNil(value)
		
		value = getDataRef(IAdatarefC, -11, -5)
		luaunit.assertNil(value)
		
		fatable = {12.56, -2.01}
		setDataRef(FAdatarefC, fatable)
		value = getDataRef(FAdatarefC, 1, 1)
		luaunit.assertIsTable(value)
		luaunit.assertEquals(#value, 1)
		luaunit.assertAlmostEquals(value[1], 12.56, floatingEpsilon)
		
		value = getDataRef(FAdatarefC, 2, 1)
		luaunit.assertEquals(#value, 1)
		luaunit.assertAlmostEquals(value[1], -2.01, floatingEpsilon)
		
		value = getDataRef(FAdatarefC, 3, 3)
		luaunit.assertNil(value)
		
		value = getDataRef(FAdatarefC, -1, 0)
		luaunit.assertNil(value)
	end
	
	function TestCustomDatarefIO:testBasicTypeCasts()
		local value
		
		setDataRef(IdatarefC, 6.7)
		value = getDataRef(IdatarefC)
		luaunit.assertEquals(value, 6)
		
		fatable = {11.3, -3.08, 14.4, 25.4}
		setDataRef(IAdatarefC, fatable)
		value = getDataRef(IAdatarefC)
		luaunit.assertEquals(value[1], 11)
		luaunit.assertEquals(value[2], -3)
		luaunit.assertEquals(value[3], 14)
		luaunit.assertEquals(value[4], 25)
	end
	
--------------------------------------------------------------------------------------------------------------
-- Properties Lua API --------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

TestGlobalProperty = {}
	function TestGlobalProperty:testGetPropertyI()
		local prop = globalPropertyi(IDatarefID, true)
		local value = get(prop)
		luaunit.assertIsNumber(value)
		luaunit.assertEquals(value, 2)
		
		prop = globalPropertyi(FDatarefID, true)
		value = get(prop)
		luaunit.assertIsNumber(value)
		luaunit.assertEquals(value, 1)
		
		prop = globalPropertyi(SDatarefID, true)
		value = get(prop)
		luaunit.assertIsNumber(value)
		luaunit.assertEquals(value, 0)
		
		prop = globalPropertyi(IADatarefID, true)
		value = get(prop)
		luaunit.assertIsNumber(value)
		luaunit.assertEquals(value, 0)
	end
	
	function TestGlobalProperty:testGetPropertyF()
		local prop = globalPropertyf(IDatarefID, true)
		local value = get(prop)
		luaunit.assertIsNumber(value)
		luaunit.assertAlmostEquals(value, 2.0, floatingEpsilon)
		
		prop = globalPropertyf(FDatarefID, true)
		value = get(prop)
		luaunit.assertIsNumber(value)
		luaunit.assertAlmostEquals(value, 1.13, floatingEpsilon)
		
		prop = globalPropertyf(SDatarefID, true)
		value = get(prop)
		luaunit.assertIsNumber(value)
		luaunit.assertAlmostEquals(value, 0.0, floatingEpsilon)
		
		prop = globalPropertyf(FADatarefID, true)
		value = get(prop)
		luaunit.assertIsNumber(value)
		luaunit.assertAlmostEquals(value, 0.0, floatingEpsilon)
	end
	
	function TestGlobalProperty:testGetPropertyS()
		local prop = globalPropertys(IDatarefID, true)
		local value = get(prop)
		luaunit.assertIsString(value)
		luaunit.assertEquals(value, '2')
		
		prop = globalPropertys(FDatarefID, true)
		local propF = globalPropertyf(FDatarefID)
		value = get(prop)
		luaunit.assertIsString(value)
		luaunit.assertEquals(value, tostring(get(propF)))
		
		prop = globalPropertys(SDatarefID, true)
		value = get(prop)
		luaunit.assertIsString(value)
		luaunit.assertStrContains(value, 'P868IW')
		
		prop = globalPropertys(FADatarefID, true)
		value = get(prop)
		luaunit.assertIsNumber(value)
		luaunit.assertAlmostEquals(value, 0.0, floatingEpsilon)
	end
	
	function TestGlobalProperty:testGetPropertyIA()
		local prop = globalPropertyia(IDatarefID, true)
		local value = get(prop)
		luaunit.assertIsNumber(value)
		luaunit.assertAlmostEquals(value, 0.0, floatingEpsilon)
		
		prop = globalPropertyia(SDatarefID, true)
		value = get(prop)
		luaunit.assertIsNumber(value)
		luaunit.assertAlmostEquals(value, 0.0, floatingEpsilon)
		
		prop = globalPropertyia(IADatarefID, true)
		value = get(prop)
		luaunit.assertIsTable(value)
		luaunit.assertEquals(#value, 200)
		luaunit.assertEquals(value[1], 889)
		luaunit.assertEquals(value[2], 252)
		luaunit.assertEquals(value[3], 274)
		luaunit.assertEquals(value[4], 291)
		luaunit.assertEquals(value[5], 290)
		
		prop = globalPropertyia(FADatarefID, true)
		value = get(prop)
		luaunit.assertIsTable(value)
		luaunit.assertEquals(#value, 200)
		luaunit.assertEquals(value[1], 1)
		luaunit.assertEquals(value[2], 0)
		luaunit.assertEquals(value[3], 1)
		luaunit.assertEquals(value[4], 1)
		luaunit.assertEquals(value[5], 1)
	end
	
	function TestGlobalProperty:testGetPropertyFA()
		local prop = globalPropertyfa(IDatarefID, true)
		local value = get(prop)
		luaunit.assertIsNumber(value)
		luaunit.assertAlmostEquals(value, 0.0, floatingEpsilon)
		
		prop = globalPropertyfa(SDatarefID, true)
		value = get(prop)
		luaunit.assertIsNumber(value)
		luaunit.assertAlmostEquals(value, 0.0, floatingEpsilon)
		
		prop = globalPropertyfa(IADatarefID, true)
		value = get(prop)
		luaunit.assertIsTable(value)
		luaunit.assertEquals(#value, 200)
		luaunit.assertEquals(value[1], 889.0, floatingEpsilon)
		luaunit.assertEquals(value[2], 252.0, floatingEpsilon)
		luaunit.assertEquals(value[3], 274.0, floatingEpsilon)
		luaunit.assertEquals(value[4], 291.0, floatingEpsilon)
		luaunit.assertEquals(value[5], 290.0, floatingEpsilon)
		
		prop = globalPropertyfa(FADatarefID, true)
		value = get(prop)
		luaunit.assertIsTable(value)
		luaunit.assertEquals(#value, 200)
		luaunit.assertAlmostEquals(value[1], 1.0, floatingEpsilon)
		luaunit.assertAlmostEquals(value[2], 0.98, floatingEpsilon)
		luaunit.assertAlmostEquals(value[3], 1.0, floatingEpsilon)
		luaunit.assertAlmostEquals(value[4], 1.33, floatingEpsilon)
		luaunit.assertAlmostEquals(value[5], 1.25, floatingEpsilon)
	end
	
	function TestGlobalProperty:testSetPropertyI()
		local prop = globalPropertyi(IDatarefID, true)
		set(prop, 18)
		local value = get(prop)
		luaunit.assertIsNumber(value)
		luaunit.assertEquals(value, 18)
		set(prop, 2)
		
		prop = globalPropertyi(FDatarefID, true)
		set(prop, 2.18)
		value = get(prop)
		luaunit.assertIsNumber(value)
		luaunit.assertEquals(value, 2)
		prop = globalPropertyf(FDatarefID, true)
		set(prop, 1.13)
		
		prop = globalPropertyi(SDatarefID, true)
		set(prop, 426)
		value = get(prop)
		luaunit.assertIsNumber(value)
		luaunit.assertEquals(value, 0)
		prop = globalPropertys(SDatarefID, true)
		value = get(prop)
		luaunit.assertIsString(value)
		luaunit.assertStrContains(value, '426')
		set(prop, 'P868IW')
	end
	
	function TestGlobalProperty:testSetPropertyF()
		local prop = globalPropertyf(IDatarefID, true)
		set(prop, 9.2)
		local value = get(prop)
		luaunit.assertIsNumber(value)
		luaunit.assertAlmostEquals(value, 9.0, floatingEpsilon)
		set(prop, 2)
		
		prop = globalPropertyf(FDatarefID, true)
		set(prop, -3.14)
		value = get(prop)
		luaunit.assertIsNumber(value)
		luaunit.assertAlmostEquals(value, -3.14, floatingEpsilon)
		set(prop, 1.13)
		
		prop = globalPropertyf(SDatarefID, true)
		set(prop, -34.56)
		value = get(prop)
		luaunit.assertIsNumber(value)
		luaunit.assertEquals(value, 0)
		local propS = globalPropertys(SDatarefID, true)
		value = get(propS)
		luaunit.assertIsString(value)
		luaunit.assertStrContains(value, tostring(-34.56))
		set(prop, 'P868IW')
	end
	
	function TestGlobalProperty:testSetPropertyS()
		local prop = globalPropertys(IDatarefID, true)
		set(prop, -78)
		local value = get(prop)
		luaunit.assertIsString(value)
		luaunit.assertStrContains(value, '0')
		local propI = globalPropertyi(IDatarefID, true)
		set(propI, 2)
		
		prop = globalPropertys(FDatarefID, true)
		set(prop, 9.982)
		value = get(prop)
		luaunit.assertIsString(value)
		luaunit.assertStrContains(value, '0')
		local propF = globalPropertyf(FDatarefID, true)
		set(propF, 1.13)
		
		prop = globalPropertys(SDatarefID, true)
		set(prop, 'rtgd789')
		value = get(prop)
		luaunit.assertIsString(value)
		luaunit.assertStrContains(value, 'rtgd789')
		set(prop, 'P868IW')
	end
	
	function TestGlobalProperty:testSetPropertyIA()
		local prop = globalPropertyia(IADatarefID, true)
		local value = get(prop)
		value[1] = 235
		value[3] = 1114
		value[5] = 1114
		set(prop, value)
		value = get(prop)
		luaunit.assertIsTable(value)
		luaunit.assertEquals(#value, 200)
		luaunit.assertEquals(value[1], 235)
		luaunit.assertEquals(value[2], 252)
		luaunit.assertEquals(value[3], 1114)
		luaunit.assertEquals(value[4], 291)
		luaunit.assertEquals(value[5], 1114)
		value[1] = 889
		value[3] = 274
		value[5] = 290
		set(prop, value)
		
		prop = globalPropertyia(FADatarefID, true)
		local propFA = globalPropertyfa(FADatarefID, true)
		local valueFA = get(propFA)
		value = get(prop)
		value[1] = 345.665
		value[2] = 12.34
		value[4] = 13.132
		set(prop, value)
		value = get(prop)
		luaunit.assertIsTable(value)
		luaunit.assertEquals(#value, 200)
		luaunit.assertEquals(value[1], 345)
		luaunit.assertEquals(value[2], 12)
		luaunit.assertEquals(value[3], 1)
		luaunit.assertEquals(value[4], 13)
		luaunit.assertEquals(value[5], 1)
		set(propFA, valueFA)
	end
	
	function TestGlobalProperty:testSetPropertyFA()
		local prop = globalPropertyfa(FADatarefID, true)
		local value = get(prop)
		value[1] = 23.56
		value[2] = 1.12
		value[3] = 1.1
		set(prop, value)
		value = get(prop)
		luaunit.assertIsTable(value)
		luaunit.assertEquals(#value, 200)
		luaunit.assertAlmostEquals(value[1], 23.56, floatingEpsilon)
		luaunit.assertAlmostEquals(value[2], 1.12, floatingEpsilon)
		luaunit.assertAlmostEquals(value[3], 1.1, floatingEpsilon)
		luaunit.assertAlmostEquals(value[4], 1.33, floatingEpsilon)
		luaunit.assertAlmostEquals(value[5], 1.25, floatingEpsilon)
		value[1] = 1.0
		value[2] = 0.98
		value[3] = 1.0
		set(prop, value)
	end 
	
	function TestGlobalProperty:testPartialIO()
		local prop = globalPropertyia(IADatarefID, true)
		local value = get(prop, 2, 3)
		luaunit.assertIsTable(value)
		luaunit.assertEquals(#value, 3)
		luaunit.assertEquals(value[1], 252)
		luaunit.assertEquals(value[2], 274)
		luaunit.assertEquals(value[3], 291)
		
		value = {268, 299, 31}
		set(prop, value, 1, 2)
		value = get(prop, 1, 5)
		luaunit.assertIsTable(value)
		luaunit.assertEquals(#value, 5)
		luaunit.assertEquals(value[1], 268)
		luaunit.assertEquals(value[2], 299)
		luaunit.assertEquals(value[3], 274)
		luaunit.assertEquals(value[4], 291)
		luaunit.assertEquals(value[5], 290)
		value[1] = 889
		value[2] = 252
		set(prop, value, 1, 2)
		
		value = get(prop, 0, 0)
		luaunit.assertNil(value)
		
		set(prop, 276, 3)
		value = get(prop, 3)
		luaunit.assertEquals(value, 275)
		
		value = get(prop, 211, 5)
		luaunit.assertNil(value)
	end
	
TestCustomProperty = {}
	function TestCustomProperty:setup()
		Icustom = createGlobalPropertyi(IDatarefIDCustom, 22)
		Fcustom = createGlobalPropertyf(FDatarefIDCustom, 987.456)
		Dcustom = createGlobalPropertyd(DDatarefIDCustom, 1.12345)
		Scustom = createGlobalPropertys(SDatarefIDCustom, 'test')
		IAcustom = createGlobalPropertyia(IADatarefIDCustom, {4,4,4,5.5})
		FAcustom = createGlobalPropertyfa(FADatarefIDCustom, {1.1,2.2,3.3,5.5})
	end
	
	function TestCustomProperty:teardown() 
		Icustom.free()
		Fcustom.free()
		Dcustom.free()
		Scustom.free()
		IAcustom.free()
		FAcustom.free()
	end
	
	function TestCustomProperty:testCreate()
		local value = get(Icustom)
		luaunit.assertEquals(value, 22)
		
		value = get(Fcustom)
		luaunit.assertAlmostEquals(value, 987.456, floatingEpsilon)
		
		value = get(Dcustom)
		luaunit.assertAlmostEquals(value, 1.12345, floatingEpsilon)
		
		value = get(Scustom)
		luaunit.assertEquals(value, 'test')
		
		value = get(IAcustom)
		luaunit.assertEquals(#value, 4)
		luaunit.assertEquals(value[1], 4)
		luaunit.assertEquals(value[2], 4)
		luaunit.assertEquals(value[3], 4)
		luaunit.assertEquals(value[4], 5)
		
		value = get(FAcustom)
		luaunit.assertEquals(#value, 4)
		luaunit.assertAlmostEquals(value[1], 1.1, floatingEpsilon)
		luaunit.assertAlmostEquals(value[2], 2.2, floatingEpsilon)
		luaunit.assertAlmostEquals(value[3], 3.3, floatingEpsilon)
		luaunit.assertAlmostEquals(value[4], 5.5, floatingEpsilon)
	end
	
	function TestCustomProperty:testGeneral()
		local iaProp = globalPropertyia(IADatarefID, true)
		temp = {get(IAcustom), get(iaProp) }
		result = 0	
		for i = 1, math.min(#temp[1], #temp[2]) do
			result = result + temp[1][i] * temp[2][i]
		end
		
		luaunit.assertEquals(result, 7115)
		
		local faProp = globalPropertyfa(FADatarefID, true)
		temp = {get(FAcustom), get(faProp) }
		result = 0
		for i = 1, math.min(#temp[1], #temp[2]) do
			result = result + temp[1][i] * temp[2][i]
		end
		
		luaunit.assertAlmostEquals(result, 13.871, floatingEpsilon)
	end
	
--------------------------------------------------------------------------------------------------------------
-- Export to global namespace ---------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

_G["TestFetchDataref"] = TestFetchDataref
_G["TestFindDataref"] = TestFindDataref
_G["TestDatarefIO"] = TestDatarefIO
_G["TestCustomDatarefIO"] = TestCustomDatarefIO
_G["TestGlobalProperty"] = TestGlobalProperty
_G["TestCustomProperty"] = TestCustomProperty

--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
