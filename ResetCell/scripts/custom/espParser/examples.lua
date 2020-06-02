

local doInfo = function(text)
	tes3mp.LogMessage(enumerations.log.INFO, "[espParserTest] " .. tostring(text)) 
end

doInfo("Start")


espParser.getRecords("Morrowind.esm")
espParser.getRecords("Morrowind.esm")
espParser.getRecords("Morrowind.esm")
espParser.clearCache()
espParser.getRecords("Morrowind.esm")
espParser.getRecords("Morrowind.esm")


--for x,_ in pairs(espParser.getAllRecordsByName("GLOB")) do
--	doInfo(x)
--end



--[[
for _, misc in pairs(espParser.files["Tribunal.esm"].miscs) do
	for n,m in pairs(misc) do
		doInfo("    " .. n .. ": " .. tostring(m))
	end
end


require "custom.struct"

local outTable = {}

for _,record in pairs(espParser.getAllRecords("ALCH")) do
    local name = ""
    local refId = ""
    for _, subrecord in pairs(record.subRecords) do
        if subrecord.name == "NAME" do
            refId = struct.unpack("s", subrecord.data)
        elseif subrecord.name == "FNAM" do
            name = struct.unpack("s", subrecord.data)
            outTable[refId] = name
            tes3mp.LogMessage(enumerations.log.INFO, refId .. " = " .. name)
        end
    end
end
]]--


--[[
for fileName, file in pairs(espParser.files) do
	for refId, static in pairs(file.statics) do
		doInfo(static.refId .. ": " .. static.model)
	end
end
]]

-- new cells
--[[
for _, file in pairs(espParser.files) do
	for cellName, cell in pairs(file.cells) do
		doInfo(cellName)
		--for _, obj in pairs(cell.objects) do
		--	doInfo(obj.pos.XPos)
		--end
	end
end
]]

--[[

for _, cell in pairs(espParser.files["Tribunal.esm"].cells) do
	doInfo(cell.name)
	for key, obj in pairs(cell.objects) do
		doInfo(obj.pos.XPos)
		--for n,m in pairs(obj) do
		--	doInfo("    " .. n .. ": " .. tostring(m))
		--end
		--doInfo("")
		--doInfo(key .. ": " .. obj.refId .. " " .. obj.scale)
		--doInfo("    " .. obj.pos.XPos)
	end
	break
	--doInfo(cell.id)
	--for i, obj in pairs(cell.objects) do
	--	doInfo("    " .. tostring(i) .. ": " .. obj.refId)
	--end
end

]]

-- figure out spell ids
--[[
for _,record in pairs(espParser.getAllRecords("MGEF")) do --go thru all magic effect records
	
	local spellId
	for _, subrecord in pairs(record.subRecords) do --go thru all subrecords
		if subrecord.name == "INDX" then
			spellId = struct.unpack( "H", subrecord.data ) --pick up the spell id
		end
	
		if subrecord.name == "DESC" then 
			if string.match(subrecord.data, "ummon") then --contains (S)ummon
				print(spellId, subrecord.data)
			end
		end
	end
end
]]


--get all Misc ids
--[[
for _,subrecord in pairs(espParser.getAllSubRecords("MISC", "NAME")) do
	doInfo(subrecord.data)
end
]]

--get all Book ids function
--[[
local getBookIds = function()
	local out = {}
	for _,subrecord in pairs(espParser.getAllSubRecords("BOOK", "NAME")) do
		table.insert(out, subrecord.data)
	end
	return out
end
]]

--get all Creatures ids function
--[[
local getNPCIds = function()
	local out = {}
	for _,subrecord in pairs(espParser.getAllSubRecords("CREA", "NAME")) do
		table.insert(out, subrecord.data)
	end
	for _,subrecord in pairs(espParser.getAllSubRecords("NPC_", "NAME")) do
		table.insert(out, subrecord.data)
	end
	return out
end
]]


--all LongBladeOneHand Weapons
--[[
require "custom.struct" --we're gonna need struct for this
for _,record in pairs(espParser.getAllRecords("WEAP")) do --go thru all weapon records
	
	local weaponName
	for _, subrecord in pairs(record.subRecords) do --go thru all subrecords
		if subrecord.name == "NAME" then
			weaponName = subrecord.data --pick up the name so we can print it later
		end
	
		if subrecord.name == "WPDT" then --weapon data subrecord
			local weaponType = struct.unpack( "H", string.sub(subrecord.data, 9, 9+2) ) -- 9 cus we want to skip two 4 byte values and the value we're grabing is a short (2 bytes) see https://en.uesp.net/morrow/tech/mw_esm.txt
			if weaponType == 1 then --if the weapontype is "1 = LongBladeOneHand"
				--print(subrecord.name)
				--print(weaponType)
				--print(weaponName .. ": " .. tostring(weaponType))
			end
		end
	end
end
]]

--Get all misc item ids
--[[
for filename, records in pairs(espParser.rawFiles) do
	doInfo("Found file " .. filename)
	for _,record in pairs(records) do
		if record.name == "MISC" then
			for _, subrecord in pairs(record.subRecords) do
				if subrecord.name == "NAME" then
					doInfo(subrecord.data)
				end
			end
		end
	end
end
]]

--[[
local out = {}
for filename,records in pairs(espParser.rawFiles) do
	out[filename] = {}
	for _, record in pairs(records) do
		if record.name == "CREA" or record.name == "NPC_" then
			for _, subrecord in pairs(record.subRecords) do
				if subrecord.name == "NAME" then
					table.insert(out[filename], subrecord.data)
				end
			end
		end
	end
end

for _, id in pairs(out["Morrowind.esm"]) do
	print(id)
end
]]

--[[
{
	"Morrowind.esm": ["creature_id", "npc_id"],
	"Tribunal.esm": [""]
}
]]--


doInfo("End")

