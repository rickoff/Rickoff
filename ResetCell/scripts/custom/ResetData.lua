--[[
ResetData by Rickoff
tes3mp 0.7.0
script version 0.1
---------------------------
DESCRIPTION :
ResetData cell visited
---------------------------
INSTALLATION:
Save the file as ResetData.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
ResetData = require("custom.ResetData")
---------------------------
CONFIG :
config.preservePlace used to conserve items dropped by players
config.preserveNpc used to conserve npc in the cell
config.preserveCreature used to conserve creature in the cell
config.resetTimerCell used to reset cell visited if config.resetCell = true
add cells you don't want to reset in BlackCellList like this: local BlackCellList = {"-3, -2", "Balmora, temple"}
]]

local ResetData = {}
config.preservePlace = false
config.preserveNpc = false
config.preserveCreature = false
config.resetCell = true
config.resetTimerCell = 3600*6
 
local NpcData = {}
local CreaData = {}
local Statdata = {}
local NpcList = jsonInterface.load("custom/CellDataBase/CellDataBaseNpc.json")
local CreaList = jsonInterface.load("custom/CellDataBase/CellDataBaseCrea.json")
local StaticList = jsonInterface.load("custom/CellDataBase/CellDataBaseStat.json")
local BlackCellList = {}
local CellVisit = {}

local TimerStartResetCell = tes3mp.CreateTimer("StartReset", time.seconds(config.resetTimerCell))

for index, item in pairs(NpcList) do
	table.insert(NpcData, string.lower(item))
end

for index, item in pairs(CreaList) do
	table.insert(CreaData, string.lower(item))
end

for index, item in pairs(StaticList) do
	table.insert(Statdata, string.lower(item))
end

function StartReset()
	ResetData.Reset()
end

ResetData.TimerStart = function(eventStatus)
	if config.resetCell == true then
		tes3mp.StartTimer(TimerStartResetCell)
		tes3mp.LogAppend(enumerations.log.INFO, "....START TIMER RESET CELL....")
	end
end

ResetData.Reset = function()
	for pid, player in pairs(Players) do
		tes3mp.MessageBox(pid, -1, color.Red.. "* WAIT FOR RESET WORLD *")	
	end	
	for index, cell in pairs(CellVisit) do 
		local celldes = LoadedCells[cell]
		local useTemporaryLoad = false	
		if celldes == nil then
			logicHandler.LoadCell(cell)
			useTemporaryLoad = true	
		end
		for key, x in pairs(LoadedCells[cell].data.packets) do
			for x, uniqueIndex in pairs(LoadedCells[cell].data.packets[key]) do	
				if config.preservePlace == true then
					if tableHelper.containsValue(LoadedCells[cell].data.packets.place, uniqueIndex) and not tableHelper.containsValue(LoadedCells[cell].data.packets.spawn, uniqueIndex) then
					else
						tableHelper.removeValue(LoadedCells[cell].data.objectData, uniqueIndex)
						tableHelper.removeValue(LoadedCells[cell].data.packets, uniqueIndex)
						if tableHelper.getCount(Players) > 0 then						
							logicHandler.DeleteObjectForEveryone(cell, uniqueIndex)
						end
					end
				else
					tableHelper.removeValue(LoadedCells[cell].data.objectData, uniqueIndex)
					tableHelper.removeValue(LoadedCells[cell].data.packets, uniqueIndex)
					if tableHelper.getCount(Players) > 0 then
						logicHandler.DeleteObjectForEveryone(cell, uniqueIndex)	
					end
				end
			end
		end	
		local cellData = jsonInterface.load("custom/CellDataBase/"..cell..".json")		
		if cellData then
			for index, y in pairs(cellData[1].objects) do
				if not cellData[1].objects[index]["doorDest"] then
					local uniqueIndex = index .. "-" .. 0				
					local refId = cellData[1].objects[index]["refId"]
					if not tableHelper.containsValue(Statdata, string.lower(refId), true) then
						local packetType
						local checkCreate
						if tableHelper.containsValue(NpcData, string.lower(refId), true) then
							packetType = "spawn"
							if config.preserveNpc == true then
								checkCreate = true
							else
								checkCreate = false
							end
						elseif tableHelper.containsValue(CreaData, string.lower(refId), true) then
							packetType = "spawn"
							if config.preserveCrea == true then
								checkCreate = true
							else
								checkCreate = false
							end						
						else
							packetType = "place"
							checkCreate = true
						end					
						tableHelper.removeValue(LoadedCells[cell].data.objectData, uniqueIndex)
						tableHelper.removeValue(LoadedCells[cell].data.packets, uniqueIndex)
						if checkCreate == true then
							local scale = cellData[1].objects[index]["scale"] or 1
							local location = { posX = tonumber(cellData[1].objects[index]["pos"]["XPos"]), posY = tonumber(cellData[1].objects[index]["pos"]["YPos"]), posZ = tonumber(cellData[1].objects[index]["pos"]["ZPos"]), rotX = tonumber(cellData[1].objects[index]["pos"]["XRot"]), rotY = tonumber(cellData[1].objects[index]["pos"]["YRot"]), rotZ = tonumber(cellData[1].objects[index]["pos"]["ZRot"])}										
							local newIndex = ResetData.CreateObjectAtLocation(cell, location, refId, packetType, scale)
							for pid, player in pairs(Players) do
								LoadedCells[cell]:RequestContainers(pid, {newIndex})
							end
						end
						if tableHelper.getCount(Players) > 0 then
							logicHandler.DeleteObjectForEveryone(cell, uniqueIndex)
						end
					end
				end
			end
			LoadedCells[cell]:QuicksaveToDrive()
		end	
		if useTemporaryLoad == true then
			logicHandler.UnloadCell(cell)
		end	
		CellVisit[index] = nil
	end 
	for pid, player in pairs(Players) do
		tes3mp.MessageBox(pid, -1, color.Red.. "* RESET WORLD DONE *")	
	end	 
	if config.resetCell == true then
		tes3mp.RestartTimer(TimerStartResetCell, time.seconds(config.resetTimerCell))
	end
end

ResetData.CreateObjectAtLocation = function(cellDescription, location, refId, packetType, scale)

    local mpNum = WorldInstance:GetCurrentMpNum() + 1
    local uniqueIndex =  0 .. "-" .. mpNum

    -- Is this a generated record? If so, add a link to it in the cell it
    -- has been placed in
    if logicHandler.IsGeneratedRecord(refId) then
        local recordStore = logicHandler.GetRecordStoreByRecordId(refId)

        if recordStore ~= nil then
            LoadedCells[cellDescription]:AddLinkToRecord(recordStore.storeType, refId, uniqueIndex)

            -- Do any of the visitors to this cell lack the generated record?
            -- If so, send it to them
            for _, visitorPid in pairs(LoadedCells[cellDescription].visitors) do
                recordStore:LoadGeneratedRecords(visitorPid, recordStore.data.generatedRecords, { refId })
            end
        else
            tes3mp.LogMessage(enumerations.log.ERROR, "Attempt at creating object based on non-existent generated record")
            return
        end
    end
	
    local mpNum = WorldInstance:GetCurrentMpNum() + 1
    local uniqueIndex =  0 .. "-" .. mpNum
	
    WorldInstance:SetCurrentMpNum(mpNum)
    tes3mp.SetCurrentMpNum(mpNum)
	
    local useTemporaryLoad = false
	
    if LoadedCells[cellDescription] == nil then
        logicHandler.LoadCell(cellDescription)
        useTemporaryLoad = true
    end	
	
    LoadedCells[cellDescription]:InitializeObjectData(uniqueIndex, refId)
    LoadedCells[cellDescription].data.objectData[uniqueIndex].location = location

    if packetType == "place" then
        table.insert(LoadedCells[cellDescription].data.packets.place, uniqueIndex)
    elseif packetType == "spawn" then
        table.insert(LoadedCells[cellDescription].data.packets.spawn, uniqueIndex)
        table.insert(LoadedCells[cellDescription].data.packets.actorList, uniqueIndex)
    end

    LoadedCells[cellDescription]:QuicksaveToDrive()

    if useTemporaryLoad then
        logicHandler.UnloadCell(cellDescription)
    end	

    if tableHelper.getCount(Players) > 0 then

        local pid = tableHelper.getAnyValue(Players).pid
        tes3mp.ClearObjectList()
        tes3mp.SetObjectListPid(pid)
        tes3mp.SetObjectListCell(cellDescription)
        tes3mp.SetObjectRefId(refId)
        tes3mp.SetObjectRefNum(0)
        tes3mp.SetObjectMpNum(mpNum)
        tes3mp.SetObjectCharge(-1)
        tes3mp.SetObjectEnchantmentCharge(-1)
		tes3mp.SetObjectScale(scale)
        tes3mp.SetObjectPosition(location.posX, location.posY, location.posZ)
        tes3mp.SetObjectRotation(location.rotX, location.rotY, location.rotZ)
        tes3mp.AddObject()

        if packetType == "place" then
            tes3mp.SendObjectPlace(true)
			tes3mp.SendObjectScale(true)			
        elseif packetType == "spawn" then
            tes3mp.SendObjectSpawn(true)
			tes3mp.SendObjectScale(true)			
        end
    end
	return uniqueIndex
end

ResetData.OnPlayerCellChange = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local cell = tes3mp.GetCell(pid)
		if not tableHelper.containsValue(BlackCellList, cell, true) then
			if not tableHelper.containsValue(CellVisit, cell, true) then
				table.insert(CellVisit, cell)
			end	
		end
	end
end	

ResetData.OnCellLoad = function(eventStatus, pid, cell)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
		local cellData = jsonInterface.load("custom/CellDataBase/"..cell..".json")		
		if cellData then
			for index, y in pairs(cellData[1].objects) do
				if not cellData[1].objects[index]["doorDest"] then
					local uniqueIndex = index .. "-" .. 0				
					local refId = cellData[1].objects[index]["refId"]
					if config.preserveNpc == false then
						if tableHelper.containsValue(NpcData, string.lower(refId), true) then
							tableHelper.removeValue(LoadedCells[cell].data.objectData, uniqueIndex)
							tableHelper.removeValue(LoadedCells[cell].data.packets, uniqueIndex)
							if tableHelper.getCount(Players) > 0 then
								logicHandler.DeleteObjectForEveryone(cell, uniqueIndex)
							end	
						end					
					end
					if config.preserveCrea == false then
						if tableHelper.containsValue(CreaData, string.lower(refId), true) then
							tableHelper.removeValue(LoadedCells[cell].data.objectData, uniqueIndex)
							tableHelper.removeValue(LoadedCells[cell].data.packets, uniqueIndex)
							if tableHelper.getCount(Players) > 0 then
								logicHandler.DeleteObjectForEveryone(cell, uniqueIndex)
							end						
						end	
					end
					for x, uniqueIndex in pairs(LoadedCells[cell].data.packets["actorList"]) do
						if LoadedCells[cell].data.objectData[uniqueIndex] then
							if config.preserveNpc == false then
								if tableHelper.containsValue(NpcData, string.lower(LoadedCells[cell].data.objectData[uniqueIndex].refId), true) then
									tableHelper.removeValue(LoadedCells[cell].data.objectData, uniqueIndex)
									tableHelper.removeValue(LoadedCells[cell].data.packets, uniqueIndex)
									if tableHelper.getCount(Players) > 0 then						
										logicHandler.DeleteObjectForEveryone(cell, uniqueIndex)
									end
								end
							end
							if config.preserveCrea == false then
								if tableHelper.containsValue(CreaData, string.lower(LoadedCells[cell].data.objectData[uniqueIndex].refId), true) then
									tableHelper.removeValue(LoadedCells[cell].data.objectData, uniqueIndex)
									tableHelper.removeValue(LoadedCells[cell].data.packets, uniqueIndex)
									if tableHelper.getCount(Players) > 0 then
										logicHandler.DeleteObjectForEveryone(cell, uniqueIndex)
									end						
								end	
							end							
						end
					end						
				end
			end
			LoadedCells[cell]:QuicksaveToDrive()
		end		
	end
end

customCommandHooks.registerCommand("resetall", ResetData.Reset)
customEventHooks.registerHandler("OnPlayerCellChange", ResetData.OnPlayerCellChange)
customEventHooks.registerHandler("OnCellLoad", ResetData.OnCellLoad)
customEventHooks.registerHandler("OnServerInit", ResetData.TimerStart)

return ResetData
