--[[
DragonDoor by Rickoff
tes3mp 0.7.0
script version 0.9
---------------------------
DESCRIPTION :
creatures and npc follow players through doors
---------------------------
INSTALLATION:
Save the file as DragonDoor.lua inside your server/scripts/custom folder.
Save the file as EcarlateNpc.json inside your server/data/custom folder.
Save the file as EcarlateCreaIa.json inside your server/data/custom folder.
Save the file as EcarlateDoor.json inside your server/data/custom folder.
Edits to customScripts.lua
DragonDoor = require("custom.DragonDoor")
]]

tableHelper = require("tableHelper")
jsonInterface = require("jsonInterface")

local DoorData = {}
local DoorList = jsonInterface.load("custom/EcarlateDoor.json")
for index, item in pairs(DoorList) do
	table.insert(DoorData, {REFID = string.lower(item.Refid)})
end

local NpcData = {}
local NpcList = jsonInterface.load("custom/EcarlateNpc.json")
local CreaList = jsonInterface.load("custom/EcarlateCreaIa.json")
for index, item in pairs(NpcList) do
	if item.figth > 80 then
		table.insert(NpcData, {REFID = string.lower(item.refid)})
	end
end

for index, item in pairs(CreaList) do
	if item.figth > 60 then
		table.insert(NpcData, {REFID = string.lower(item.refid)})
	end
end

local cfg = {}
cfg.rad = 1000

local doorTab = { player = {} }
local creaTab = { player = {} }
local indexTab = { player = {} }
local cellTab = { player = {} }

local DragonDoor = {}

DragonDoor.OnPlayerConnect = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
		doorTab.player[pid] = {}
		cellTab.player[pid] = {}
		creaTab.player[pid] = {}
		indexTab.player[pid] = {}
	end
end

DragonDoor.OnObjectActivate = function(eventStatus, pid, cellDescription, objects)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
		local ObjectRefid			
		for _, object in pairs(objects) do
			ObjectRefid = object.refId
		end	
		if ObjectRefid ~= nil then	
			if tableHelper.containsValue(DoorData, string.lower(ObjectRefid), true) then	
				doorTab.player[pid] = {object = ObjectRefid} 
				cellTab.player[pid] = {cell = cellDescription} 
				creaTab.player[pid] = {}
				indexTab.player[pid] = {}
				LoadedCells[cellDescription]:QuicksaveToDrive()
				logicHandler.LoadCell(cellDescription)
				local playerPosX = tes3mp.GetPosX(pid)
				local playerPosY = tes3mp.GetPosY(pid)
				local cell = LoadedCells[cellDescription]				
				if cell ~= nil then				
					for _, uniqueIndex in pairs(cell.data.packets.actorList) do
						if cell.data.objectData[uniqueIndex] then
							if cell.data.objectData[uniqueIndex].refId and cell.data.objectData[uniqueIndex].location then
								local creatureRefId = cell.data.objectData[uniqueIndex].refId
								if tableHelper.containsValue(NpcData, string.lower(creatureRefId), true) then							
									local creaturePosX = cell.data.objectData[uniqueIndex].location.posX
									local creaturePosY = cell.data.objectData[uniqueIndex].location.posY							
									local distance = math.sqrt((playerPosX - creaturePosX) * (playerPosX - creaturePosX) + (playerPosY - creaturePosY) * (playerPosY - creaturePosY)) 									
									if distance < cfg.rad and not tableHelper.containsValue(cell.data.packets.death, uniqueIndex, true) and not tableHelper.containsValue(indexTab.player, uniqueIndex, true) then
										table.insert(creaTab.player[pid], creatureRefId)
										table.insert(indexTab.player[pid], uniqueIndex)								
									end	
								end
							end
						end
					end	
				end
			end
		end		
	end
end

DragonDoor.OnPlayerCellChange = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local playerPosX = tes3mp.GetPosX(pid)
		local playerPosY = tes3mp.GetPosY(pid)
		local playerPosZ = tes3mp.GetPosZ(pid)	
		local position = { posX = playerPosX, posY = playerPosY, posZ = playerPosZ, rotX = 0, rotY = 0, rotZ = 0 }
		local cellId = tes3mp.GetCell(pid)	
		if creaTab.player[pid] and doorTab.player[pid] then
			if doorTab.player[pid].object ~= nil then
				if tableHelper.containsValue(DoorData, string.lower(doorTab.player[pid].object), true) then
					for x, y in pairs(creaTab.player[pid]) do					
						creatureRefId = creaTab.player[pid][x]
						logicHandler.CreateObjectAtLocation(cellId, position, creatureRefId, "spawn")
						for _, uniqueIndex in pairs(LoadedCells[cellId].data.packets.actorList) do
							if LoadedCells[cellId].data.objectData[uniqueIndex] then
								if LoadedCells[cellId].data.objectData[uniqueIndex].refId == creatureRefId then
									logicHandler.SetAIForActor(LoadedCells[cellId], uniqueIndex, "2", pid)
								end
							end
						end
					end	
					LoadedCells[cellId]:QuicksaveToDrive()						
					if cellTab.player[pid].cell ~= nil then
						local cell = LoadedCells[cellTab.player[pid].cell]
						local useTemporaryLoad = false	
						if cell == nil then
							logicHandler.LoadCell(cellTab.player[pid].cell)
							useTemporaryLoad = true
							cell = LoadedCells[cellTab.player[pid].cell]							
							for _, uniqueIndex in pairs(cell.data.packets.actorList) do
								if tableHelper.containsValue(indexTab.player[pid], uniqueIndex, true) then
									tableHelper.removeValue(cell.data.objectData, uniqueIndex)
									tableHelper.removeValue(cell.data.packets, uniqueIndex)
									if tableHelper.getCount(Players) > 0 then
										logicHandler.DeleteObjectForEveryone(cellTab.player[pid].cell, uniqueIndex)
									end
								end
							end							
							cell:QuicksaveToDrive()			
						elseif cell ~= nil then								
							for _, uniqueIndex in pairs(cell.data.packets.actorList) do
								if tableHelper.containsValue(indexTab.player[pid], uniqueIndex, true) then
									tableHelper.removeValue(cell.data.objectData, uniqueIndex)
									tableHelper.removeValue(cell.data.packets, uniqueIndex)
									if tableHelper.getCount(Players) > 0 then
										logicHandler.DeleteObjectForEveryone(cellTab.player[pid].cell, uniqueIndex)
									end
								end
							end							
							cell:QuicksaveToDrive()
						end	
						if useTemporaryLoad == true then
							logicHandler.UnloadCell(cellTab.player[pid].cell)
						end			
					end
				end
			end
		end
		doorTab.player[pid] = {}
		cellTab.player[pid] = {}
		creaTab.player[pid] = {}
		indexTab.player[pid] = {}	
	end
end

customEventHooks.registerHandler("OnPlayerAuthentified", DragonDoor.OnPlayerConnect)
customEventHooks.registerHandler("OnObjectActivate", DragonDoor.OnObjectActivate)
customEventHooks.registerHandler("OnPlayerCellChange", DragonDoor.OnPlayerCellChange)

return DragonDoor
