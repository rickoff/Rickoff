require "custom.struct" -- Requires https://github.com/iryont/lua-struct

espParser = {}

espParser.scriptName = "espParser"
espParser.initialConfig = require("custom.espParser.initialConfig")
espParser.config = DataManager.loadConfiguration(
    espParser.scriptName,
    espParser.initialConfig.values,
    espParser.initialConfig.keyOrder
)
espParser.loaded = false
espParser.cached = {} --store cached records from files
--TODO have a merged one that carry over changes depending on the loadorder

--Stream class
espParser.Stream = {}
espParser.Stream.__index = espParser.Stream
function espParser.Stream:create(data)
	local newobj = {}
	setmetatable(newobj, espParser.Stream)
	newobj.data = data
	newobj.pointer = 1
	return newobj
end
function espParser.Stream:len()
	return string.len(self.data)
end
function espParser.Stream:read(amount)
	local temp = string.sub(self.data, self.pointer, self.pointer+amount-1)
	self.pointer = self.pointer + amount
	return temp
end
function espParser.Stream:sub(start, send)
	local temp = string.sub(self.data, start, send)
	return temp
end

--Record class
espParser.Record = {}
espParser.Record.__index = espParser.Record
function espParser.Record:create(stream)
	local newobj = {}
	setmetatable(newobj, espParser.Record)
	newobj.name = stream:read(4) 
	newobj.size = struct.unpack( "i", stream:read(4) )
	newobj.header1 = struct.unpack( "i", stream:read(4) )
	newobj.flags = struct.unpack( "i", stream:read(4) )
	newobj.data = stream:read(newobj.size)
	newobj.subRecords = {}

	--get subrecords
	local st = espParser.Stream:create(newobj.data)
	while st.pointer < st:len() do
		table.insert(newobj.subRecords, espParser.SubRecord:create(st) )
	end

	return newobj
end
function espParser.Record:getSubRecordsByName(name)
	local out = {}
	for _, subrecord in pairs(self.subRecords) do
		if subrecord.name == name then
			table.insert(out, subrecord)
		end
	end
	return out
end

--SubRecord class
espParser.SubRecord = {}
espParser.SubRecord.__index = espParser.SubRecord
function espParser.SubRecord:create(stream)
	local newobj = {}
	setmetatable(newobj, espParser.SubRecord)
	newobj.name = stream:read(4)
	newobj.size = struct.unpack( "i", stream:read(4) )
	newobj.data = stream:read(newobj.size)
	return newobj
end

--Global Functions


espParser.getRecords = function(filename) --returns a array of records from the specified esp/esm file

	if espParser.cached[filename] then
		tes3mp.LogMessage(enumerations.log.INFO, "[espParser] Loaded: " .. filename .. " from cache")
		return espParser.cached[filename]
	end

	local fullPath = tes3mp.GetDataPath() .. "/" .. espParser.config.espPath .. filename
	fullPath = fullPath:gsub("\\", "/")
	local f = io.open(fullPath, "rb")

	if f == nil then return false end --could not open the file
	
	local mainStream = espParser.Stream:create(f:read("*a")) --read all

	local output = {}
	while mainStream.pointer < mainStream:len() do
		local r = espParser.Record:create(mainStream)
		table.insert(output, r)
	end

	if espParser.config.cache then
		espParser.cached[filename] = output
	end
	tes3mp.LogMessage(enumerations.log.INFO, "[espParser] Loaded: " .. filename)
	return output
end

espParser.getRecordsByName = function(filename, recordName) --returns a array of records from the specified esp/esm file
	local records = espParser.getRecords(filename)
	local output = {}

	for i,record in pairs(records) do
		if record.name == recordName then
			table.insert(output, record)
		end
	end
	return output
end

espParser.getSubRecordsByName = function(filename, recordName, subrecordName)
	local records = espParser.getRecords(filename, recordName)
	local output = {}
	for _,record in pairs(records) do
		for _,subrecord in pairs(record.subRecords) do
			table.insert(output, subrecord)
		end
	end
	return output
end

--dont call this bro
espParser.getAllRecords = function()
	local files
    if espParser.config.requiredDataFiles then
        files = jsonInterface.load("requiredDataFiles.json")
    else
        files = espParser.config.files
    end
	local output = {}
    for i = 1, #files do
		for file, _ in pairs(files[i]) do
			output[file] = espParser.getRecords(file)
        end
	end
	return output
end

espParser.getAllRecordsByName = function(recordName)
	local files
    if espParser.config.requiredDataFiles then
        files = jsonInterface.load("requiredDataFiles.json")
    else
        files = espParser.config.files
    end

	local output = {}
	for fileName, file in pairs(files) do
		output[fileName] = {}
		local records = espParser.getRecords(file)
		for _,record in pairs(records) do
			if record.name == recordName then
				table.insert(output[fileName], record)
			end
		end
	end
	return output
end


espParser.getAllSubRecordsByName = function(recordName, subrecordName)
	local files = espParser.getAllRecordsByName(recordName)
	local output = {}
	for fileName, file in pairs(files) do
		output[fileName] = {}
		for _,record in pairs(file) do
			for _,subrecord in pairs(record.subRecords) do
				table.insert(output[fileName], subrecord)
			end
		end
	end
	return output
end

espParser.clearCache = function()
    espParser.cached = {}
    tes3mp.LogMessage(enumerations.log.INFO, "[espParser] Cleared Cache!")
end

-- Event hooks
customEventHooks.registerHandler("OnServerPostInit", function()
	tes3mp.LogMessage(enumerations.log.INFO, "[espParser] Loaded")
    if espParser.config.preload then
		espParser.getAllRecords()
		tes3mp.LogMessage(enumerations.log.INFO, "[espParser] Preloaded all files!")
    end
end)

-----NOT USED RN
--[[
local structTypes = {
    b = 1, --signed char
    B = 1, --unsigned char
    h = 2, --unsigned short
    H = 2, --unsigned short
    i = 4, --signed int
    I = 4, --unsigned int
    l = 8, --signed long
    L = 8, --unsigned long
    f = 4, --float
    d = 8, --double
    s = -1, --zero-terminated string
    cn = -1 --sequence of exactly n chars corresponding to a single Lua string
}
espParser.getValue = function(data, type, position, length)
    local size = structTypes[type]
    if size == nil then
        return nil
    end
    if size ~= -1 then
        return struct.unpack( type, string.sub(data, position, position + size - 1) )
    elseif length ~= nil then
        return struct.unpack( type, string.sub(data, position, position + length - 1) )
    else
        return struct.unpack( type, string.sub(data, position) )
    end
end
espParser.subrecordParseHelper = function(obj, dataTypes, subrecord)
	if dataTypes[subrecord.name] ~= nil then
		if type(dataTypes[subrecord.name][1]) == "table" then
			local stream = espParser.Stream:create( subrecord.data )
			for _, ty in pairs(dataTypes[subrecord.name][1]) do
				if dataTypes[subrecord.name][2] == nil then --assign directly to the object
					obj[ ty[2] ] = struct.unpack( ty[1], stream:read(4) )
				else --put the values in a table
					if obj[ dataTypes[subrecord.name][2] ] == nil then
						obj[ dataTypes[subrecord.name][2] ] = {}
					end
					obj[ dataTypes[subrecord.name][2] ][ ty[2] ] = struct.unpack( ty[1], stream:read(4) )
				end
			end
		else
			obj[ dataTypes[subrecord.name][2] ] = struct.unpack( dataTypes[subrecord.name][1], subrecord.data )
		end
	end
	return obj
end
espParser.parseCells = function(filename) --filename already loaded in espParser.rawFiles
	local records = espParser.getRecords(filename, "CELL")
	if espParser.files[filename] == nil then
		espParser.files[filename] = {}
	end
	espParser.files[filename].cells = {}
	--lenghts of data types
	local lenTable = {
		i = 4,
		f = 4,
	}
	local dataTypes = {
		Unique = {
			{"NAME", "s", "name"}, --cell description
			{"DATA", {
				{"i", "flags"},
				{"i", "gridX"},
				{"i", "gridY"}
			}},
			{"INTV", "i", "water"}, --water height stored in a int (didn't know about this one until I checked the openmw source, no idea why theres 2 of them)
			{"WHGT", "f", "water"}, --water height stored in a float
			{"AMBI", {
				{"i", "ambientColor"},
				{"i", "sunlightColor"},
				{"i", "fogColor"},
				{"f", "fogDensity"}
			}},
			{"RGNN", "s", "region"}, --the region name like "Azura's Coast" used for weather and stuff
			{"NAM5", "i", "mapColor"},
			{"NAM0", "i", "refNumCounter"} --when you add a new object to the cell in the editor it gets this refNum then this variable is incremented 
		},
		Multi = {
			{"NAME", "s", "refId"},
			{"XSCL", "f", "scale"},
			{"DELE", "i", "deleted"}, --rip my boi
			{"DNAM", "s", "destCell"}, --the name of the cell the door takes you too
			{"FLTV", "i", "lockLevel"}, --door lock level
			{"KNAM", "s", "key"}, --key refId
			{"TNAM", "s", "trap"}, --trap spell refId
			{"UNAM", "B", "referenceBlocked"},
			{"ANAM", "s", "owner"}, --the npc owner or the item
			{"BNAM", "s", "globalVariable"}, -- Global variable for use in scripts?
			{"INTV", "i", "charge"}, --current charge?
			{"NAM9", "i", "goldValue"}, --https://github.com/OpenMW/openmw/blob/dcd381049c3b7f9779c91b2f6b0f1142aff44c4a/components/esm/cellref.cpp#L163
			{"XSOL", "s", "soul"},
			{"CNAM", "s", "faction"}, --faction who owns the item
			{"INDX", "i", "factionRank"}, --what rank you need to be in the faction to pick it up without stealing?
			{"XCHG", "i", "enchantmentCharge"}, --max charge?
			{"DODT", {
				{"f", "XPos"},
				{"f", "YPos"},
				{"f", "ZPos"},
				{"f", "XRot"},
				{"f", "YRot"},
				{"f", "ZRot"}
			}, "doorDest"}, --the position the door takes you too
			{"DATA", {
				{"f", "XPos"},
				{"f", "YPos"},
				{"f", "ZPos"},
				{"f", "XRot"},
				{"f", "YRot"},
				{"f", "ZRot"}
			}, "pos"} --the position of the object
		}
	}
	for _, record in pairs(records) do
		local cell = {}
		
		for _, dType in pairs(dataTypes.Unique) do
			local tempData = record:getSubRecordsByName(dType[1])[1]
			if tempData ~= nil then
				if type(dType[2]) == "table" then
					local stream = espParser.Stream:create( tempData.data )
					for _, ddType in pairs(dType[2]) do
						cell[ ddType[2] ] = struct.unpack( ddType[1], stream:read(4) )
					end
				else
					cell[ dType[3] ] = struct.unpack( dType[2], tempData.data )
				end
			end
		end
		if cell.region ~= nil or cell.name == "" then --its a external cell
			cell.isExterior = true
			cell.name = cell.gridX .. ", " .. cell.gridY
		else --its a internal cell
			cell.isExterior = false
		end
		cell.objects = {}
		local currentIndex = nil
		for _, subrecord in pairs(record.subRecords) do
			if subrecord.name == "FRMR" then
				currentIndex = struct.unpack( "i", subrecord.data )
				cell.objects[currentIndex] = {}
				cell.objects[currentIndex].refNum = currentIndex
				cell.objects[currentIndex].scale = 1 --just a default
			end
			for _, dType in pairs(dataTypes.Multi) do
				if subrecord.name == dType[1] and currentIndex ~= nil then --if its a subrecord in dataTypes.Multi
					if type(dType[2]) == "table" then --there are several values in this data
						local stream = espParser.Stream:create( subrecord.data )
						for _, ddType in pairs(dType[2]) do --go thrue every value that we want out of this data
							if dType[3] ~= nil then --store the values in a table
								if cell.objects[currentIndex][ dType[3] ] == nil then
									cell.objects[currentIndex][ dType[3] ] = {}
								end
								cell.objects[currentIndex][ dType[3] ][ ddType[2] ] = struct.unpack( ddType[1], stream:read( lenTable[ ddType[1] ] ) )
							else --store the values directly in the cell
								cell.objects[currentIndex][ ddType[2] ] = struct.unpack( ddType[1], lenTable[ ddType[1] ] )
							end
						end
					else -- theres only one value in the data
						cell.objects[currentIndex][ dType[3] ] = struct.unpack( dType[2], subrecord.data )
					end
				end
			end
		end
		espParser.files[filename].cells[cell.name] = cell
	end
end
espParser.parseStatics = function(filename)
	local records = espParser.getRecords(filename, "STAT")
	if espParser.files[filename] == nil then
		espParser.files[filename] = {}
	end
	espParser.files[filename].statics = {}
	for _, record in pairs(records) do
		local refId = struct.unpack( "s", record:getSubRecordsByName("NAME")[1].data )
		local model = struct.unpack( "s", record:getSubRecordsByName("MODL")[1].data )
		espParser.files[filename].statics[refId] = {}
		espParser.files[filename].statics[refId].refId = refId
		espParser.files[filename].statics[refId].model = model
	end
end
espParser.parseMiscs = function(filename)
	local records = espParser.getRecords(filename, "MISC")
	if espParser.files[filename] == nil then
		espParser.files[filename] = {}
	end
	espParser.files[filename].miscs = {}
	local dataTypes = {
		NAME = {"s", "refId"},
		MODL = {"s", "model"},
		FNAM = {"s", "name"},
		MCDT = {
			{
				{"f", "weight"},
				{"i", "value"},
				{"i", "unknown"}
			}
		},
		SCRI = {"s", "script"},
		ITEX = {"s", "icon"},
		DELE = {"i", "deleted"}
	}
	for _, record in pairs(records) do
		local refId = struct.unpack( "s", record:getSubRecordsByName("NAME")[1].data )
		espParser.files[filename].miscs[refId] = {}
		for _, subrecord in pairs(record.subRecords) do
			espParser.files[filename].miscs[refId] = espParser.subrecordParseHelper(espParser.files[filename].miscs[refId], dataTypes, subrecord)
		end
	end
end
]]--