--[[
DataBaseScript by Rickoff
tes3mp 0.7.0
script version 0.2
---------------------------
DESCRIPTION :
Create a database for resetscript
---------------------------
INSTALLATION:
Save the file as DataBaseScript.lua inside your server/scripts/custom folder.
Edits to customScripts.lua
DataBaseScript = require("custom.DataBaseScript")
]]

local config = {}
config.files = {"Morrowind.esm","Tribunal.esm","Bloodmoon.esm"}

local DataBaseCellContent = {}
local DataBaseNpc = {}
local DataBaseCreature = {}
local DataBaseStatic = {}
local DataBaseScript = {}
local DataBaseAct = {}
local DataBaseDoor = {}

DataBaseScript.CreateJsonDataBase = function(eventStatus)
	for x, file in pairs(config.files) do
		local records = (espParser.getRecordsByName(file, "CELL"))

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
									cell.objects[currentIndex][ dType[3] ][ ddType[2] ] = struct.unpack( ddType[1], stream:read(4) )
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
			jsonCellName = Normalize.stripChars(cell.name)			
			DataBaseCellContent[jsonCellName] = {}
			table.insert(DataBaseCellContent[jsonCellName], cell)
			tes3mp.LogMessage(enumerations.log.ERROR, jsonCellName)
			file = io.open("logDataBase.txt", 'w')
			file:write(cell.name, '\n')
			file:close()
			jsonInterface.save("custom/CellDataBase/"..jsonCellName..".json", DataBaseCellContent[jsonCellName])	
		end
	end
	
	for x, file in pairs(config.files) do
		local records = (espParser.getRecordsByName(file, "NPC_"))
		for _, record in pairs(records) do
			for _, subrecord in pairs(record.subRecords) do	
				if subrecord.name == "NAME" then
					table.insert(DataBaseNpc, struct.unpack( "s", subrecord.data ))	
				end
			end
		end
	end
	if not jsonInterface.load("custom/CellDataBase/CellDataBaseNpc.json") then
		jsonInterface.save("custom/CellDataBase/CellDataBaseNpc.json", DataBaseNpc)	
	end	
	
	for x, file in pairs(config.files) do
		local records = (espParser.getRecordsByName(file, "CREA"))
		for _, record in pairs(records) do
			for _, subrecord in pairs(record.subRecords) do	
				if subrecord.name == "NAME" then
					table.insert(DataBaseCreature, struct.unpack( "s", subrecord.data ))	
				end
			end
		end
	end
	if not jsonInterface.load("custom/CellDataBase/CellDataBaseCrea.json") then
		jsonInterface.save("custom/CellDataBase/CellDataBaseCrea.json", DataBaseCreature)	
	end	
	
	for x, file in pairs(config.files) do
		local records = (espParser.getRecordsByName(file, "STAT"))
		for _, record in pairs(records) do
			for _, subrecord in pairs(record.subRecords) do	
				if subrecord.name == "NAME" then
					table.insert(DataBaseStatic, struct.unpack( "s", subrecord.data ))	
				end
			end
		end
	end
	if not jsonInterface.load("custom/CellDataBase/CellDataBaseStat.json") then
		jsonInterface.save("custom/CellDataBase/CellDataBaseStat.json", DataBaseStatic)	
	end

	for x, file in pairs(config.files) do
		local records = (espParser.getRecordsByName(file, "DOOR"))
		for _, record in pairs(records) do
			for _, subrecord in pairs(record.subRecords) do	
				if subrecord.name == "NAME" then
					table.insert(DataBaseDoor, struct.unpack( "s", subrecord.data ))	
				end
			end
		end
	end
	if not jsonInterface.load("custom/CellDataBase/CellDataBaseDoor.json") then
		jsonInterface.save("custom/CellDataBase/CellDataBaseDoor.json", DataBaseDoor)	
	end	
	
	for x, file in pairs(config.files) do
		local records = (espParser.getRecordsByName(file, "ACTI"))
		for _, record in pairs(records) do
			for _, subrecord in pairs(record.subRecords) do	
				if subrecord.name == "NAME" then
					table.insert(DataBaseAct, struct.unpack( "s", subrecord.data ))	
				end
			end
		end
	end
	if not jsonInterface.load("custom/CellDataBase/CellDataBaseAct.json") then
		jsonInterface.save("custom/CellDataBase/CellDataBaseAct.json", DataBaseAct)	
	end	
end

customEventHooks.registerHandler("OnServerPostInit", DataBaseScript.CreateJsonDataBase)

return DataBaseScript
