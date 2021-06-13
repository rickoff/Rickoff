--[[
ResetData by Rickoff
tes3mp 0.7.0
script version 0.3
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
config.preservePlace = true
config.preserveNpc = true
config.preserveCreature = true
config.resetCell = true
config.messageBox = false
config.resetTimerCell = 10
 
local NpcData = {}
local CreaData = {}
local Statdata = {}
local DoorData = {}
local NpcList = jsonInterface.load("custom/CellDataBase/CellDataBaseNpc.json")
local CreaList = jsonInterface.load("custom/CellDataBase/CellDataBaseCrea.json")
local StaticList = jsonInterface.load("custom/CellDataBase/CellDataBaseStat.json")
local ActList = jsonInterface.load("custom/CellDataBase/CellDataBaseAct.json")
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

function CleanData(cell, cellDescription, index)
	cell.data.objectData[index] = nil
	tableHelper.cleanNils(cell.data.objectData)	
	if tableHelper.getCount(Players) > 0 then		
		logicHandler.DeleteObjectForEveryone(cellDescription, index)
	end							
end

ResetData.TimerStart = function(eventStatus)
	if config.resetCell == true then
		tes3mp.StartTimer(TimerStartResetCell)
		tes3mp.LogAppend(enumerations.log.INFO, "....START TIMER RESET CELL....")
	end
end

ResetData.Reset = function()
	if config.messageBox == true then
		for pid, player in pairs(Players) do
			tes3mp.MessageBox(pid, -1, color.Red.."*--------------------*\nWAIT FOR RESET WORLD\n*--------------------*")	
		end	
	end
	local celldes
	for index, cell in pairs(CellVisit) do 
		local tableIndex = {}
		local celldes = LoadedCells[cell]
		local useTemporaryLoad = false	
		if celldes == nil then
			logicHandler.LoadCell(cell)
			useTemporaryLoad = true
			celldes = LoadedCells[cell]
		end
		local cellNameJson = cell
		local cellData = jsonInterface.load("custom/CellDataBase/"..cellNameJson..".json")	
		if cellData then			
			for key, x in pairs(celldes.data.packets) do
				for x, uniqueIndex in pairs(celldes.data.packets[key]) do			
					if config.preservePlace == true and tableHelper.containsValue(celldes.data.packets.place, uniqueIndex) 
						and not tableHelper.containsValue(LoadedCells[cell].data.packets.spawn, uniqueIndex)
						and not tableHelper.containsValue(LoadedCells[cell].data.packets.container, uniqueIndex) then
					else
						if celldes.data.objectData[uniqueIndex] then
							local refId = celldes.data.objectData[uniqueIndex].refId	
							if refId then
								if not tableHelper.containsValue(DoorData, string.lower(refId)) then
									CleanData(celldes, cell, uniqueIndex)
								end
							end
						end
					end
				end
			end	
			for index, y in pairs(cellData[1].objects) do
				if not cellData[1].objects[index]["doorDest"] then
					local uniqueIndex = index .. "-" .. 0				
					local refId = cellData[1].objects[index]["refId"]
					if not tableHelper.containsValue(Statdata, string.lower(refId), true) and not tableHelper.containsValue(DoorData, string.lower(refId), true) and not tableHelper.containsValue(ActList, string.lower(refId), true) then			
						local packetType
						local checkCreate
						CleanData(celldes, cell, uniqueIndex)						
						if tableHelper.containsValue(NpcData, string.lower(refId), true) then
							packetType = "spawn"
							if config.preserveNpc == true then
								checkCreate = true
							else
								checkCreate = false
							end
						elseif tableHelper.containsValue(CreaData, string.lower(refId), true) then
							packetType = "spawn"
							if config.preserveCreature == true then
								checkCreate = true
							else
								checkCreate = false
							end						
						else
							packetType = "place"
							checkCreate = true
						end						
						if checkCreate == true then
							local scale = cellData[1].objects[index]["scale"] or 1
							local location = { posX = tonumber(cellData[1].objects[index]["pos"]["XPos"]), posY = tonumber(cellData[1].objects[index]["pos"]["YPos"]), posZ = tonumber(cellData[1].objects[index]["pos"]["ZPos"]), rotX = tonumber(cellData[1].objects[index]["pos"]["XRot"]), rotY = tonumber(cellData[1].objects[index]["pos"]["YRot"]), rotZ = tonumber(cellData[1].objects[index]["pos"]["ZRot"])}										
							local newIndex = ResetData.CreateObjectAtLocation(cell, location, refId, packetType, scale)
							table.insert(tableIndex, newIndex)
						end
					end
				end
			end		
		else
			tes3mp.LogMessage(enumerations.log.ERROR, "WARNING : THE CELL "..cell.." NOT RESET CHECK CELL DATA BASE")
		end
		celldes:QuicksaveToDrive()
		for pid, player in pairs(Players) do
			celldes:RequestContainers(pid, tableIndex)
		end
		if useTemporaryLoad == true then
			logicHandler.UnloadCell(cell)
		end	
	end 
	CellVisit = {}
	for pid, player in pairs(Players) do
		local NewCell = tes3mp.GetCell(pid)
		local cellNameJson = NewCell		
		if cellNameJson and not tableHelper.containsValue(CellVisit, cellNameJson, true) then table.insert(CellVisit, cellNameJson) end
		if config.messageBox == true then		
			tes3mp.MessageBox(pid, -1, color.Red.. "*--------------------*\nRESET WORLD DONE\n*--------------------*")	
		end
	end	 
	if config.resetCell == true then
		tes3mp.RestartTimer(TimerStartResetCell, time.seconds(config.resetTimerCell))
	end
end

ResetData.CreateObjectAtLocation = function(cellDescription, location, refId, packetType, scale)
    local mpNum = WorldInstance:GetCurrentMpNum() + 1
    local uniqueIndex =  0 .. "-" .. mpNum
    if logicHandler.IsGeneratedRecord(refId) then
        local recordStore = logicHandler.GetRecordStoreByRecordId(refId)
        if recordStore ~= nil then
            LoadedCells[cellDescription]:AddLinkToRecord(recordStore.storeType, refId, uniqueIndex)
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
		local cellNameJson = cell
		if not tableHelper.containsValue(BlackCellList, cellNameJson, true) then
			if not tableHelper.containsValue(CellVisit, cellNameJson, true) then
				table.insert(CellVisit, cellNameJson)
			end	
		end
	end
end	

ResetData.OnCellLoad = function(eventStatus, pid, cell)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local cellLoaded = LoadedCells[cell]
		local useTemporaryLoad = false	
		if cellLoaded == nil then
			logicHandler.LoadCell(cell)
			useTemporaryLoad = true
			cellLoaded = LoadedCells[cell]
		end	
		local cellName = cell
		local cellData = jsonInterface.load("custom/CellDataBase/"..cellName..".json")		
		if cellData then
			for index, y in pairs(cellData[1].objects) do
				if not cellData[1].objects[index]["doorDest"] then
					local uniqueIndex = index .. "-" .. 0				
					local refId = cellData[1].objects[index]["refId"]
					if config.preserveNpc == false then
						if tableHelper.containsValue(NpcData, string.lower(refId), true) then
							CleanData(cellLoaded, cell, uniqueIndex)
						end					
					end
					if config.preserveCreature == false then
						if tableHelper.containsValue(CreaData, string.lower(refId), true) then
							CleanData(cellLoaded, cell, uniqueIndex)				
						end	
					end
					for x, uniqueIndex in pairs(cellLoaded.data.packets["actorList"]) do
						if cellLoaded.data.objectData[uniqueIndex] then
							if config.preserveNpc == false then
								if tableHelper.containsValue(NpcData, string.lower(cellLoaded.data.objectData[uniqueIndex].refId), true) then
									CleanData(cellLoaded, cell, uniqueIndex)
								end
							end
							if config.preserveCreature == false then
								if tableHelper.containsValue(CreaData, string.lower(cellLoaded.data.objectData[uniqueIndex].refId), true) then
									CleanData(cellLoaded, cell, uniqueIndex)					
								end	
							end							
						end
					end						
				end
			end
			cellLoaded:QuicksaveToDrive()
		end	
		if useTemporaryLoad == true then
			logicHandler.UnloadCell(cell)
		end			
	end
end

customCommandHooks.registerCommand("resetall", ResetData.Reset)
customEventHooks.registerHandler("OnPlayerCellChange", ResetData.OnPlayerCellChange)
customEventHooks.registerValidator("OnCellLoad", ResetData.OnCellLoad)
customEventHooks.registerHandler("OnServerInit", ResetData.TimerStart)

return ResetData
