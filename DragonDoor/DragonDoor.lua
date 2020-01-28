--[[
DragonDoor by Rickoff
tes3mp 0.7.0
script version 0.1
---------------------------
DESCRIPTION :

---------------------------
INSTALLATION:
Save the file as DragonDoor.lua inside your server/scripts/custom folder.
Save the file as EcarlateDoor.lua inside your server/data/custom folder.

Edits to customScripts.lua
DragonDoor = require("custom.DragonDoor")
]]

tableHelper = require("tableHelper")
jsonInterface = require("jsonInterface")

local cfg = {}
cfg.rad = 1000

local DoorData = {}
local DoorList = jsonInterface.load("custom/EcarlateDoor.json")
for index, item in pairs(DoorList) do
	table.insert(DoorData, {NAME = item.name, REFID = string.lower(item.Refid)})
end

local doorTab = { player = {} }
local creaTab = { player = {} }
local indexTab = { player = {} }
local cellTab = { player = {} }

local DragonDoor = {}

DragonDoor.OnObjectActivate = function(eventStatus, pid, cellDescription, objects)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local ObjectIndex
		local ObjectRefid
		local playerPosX = tes3mp.GetPosX(pid)
		local playerPosY = tes3mp.GetPosY(pid)
		local cell = LoadedCells[cellDescription]		
		for _, object in pairs(objects) do
			ObjectIndex = object.uniqueIndex
			ObjectRefid = object.refId
		end	
		if ObjectIndex ~= nil and ObjectRefid ~= nil then	
			if tableHelper.containsValue(DoorData, string.lower(ObjectRefid), true) then	
				doorTab.player[pid] = {object = ObjectRefid} 
				cellTab.player[pid] = {cell = cellDescription} 
				creaTab.player[pid] = {}
				indexTab.player[pid] = {}				
				for _, uniqueIndex in pairs(cell.data.packets.spawn) do
					if cell.data.objectData[uniqueIndex] then
						creatureRefId = cell.data.objectData[uniqueIndex].refId								
						if cell.data.objectData[uniqueIndex].location and cell.data.objectData[uniqueIndex].stats then
							local healthCurrent = cell.data.objectData[uniqueIndex].stats.healthCurrent							
							local creaturePosX = cell.data.objectData[uniqueIndex].location.posX
							local creaturePosY = cell.data.objectData[uniqueIndex].location.posY
							local distance = math.sqrt((playerPosX - creaturePosX) * (playerPosX - creaturePosX) + (playerPosY - creaturePosY) * (playerPosY - creaturePosY)) 
							if distance < cfg.rad and healthCurrent > 0 then
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
					end
					if cellTab.player[pid].cell ~= nil then
						local cell = LoadedCells[cellTab.player[pid].cell]
						local useTemporaryLoad = false	
						if cell == nil then
							logicHandler.LoadCell(cellTab.player[pid].cell)
							useTemporaryLoad = true
							cell = LoadedCells[cellTab.player[pid].cell]	
							for _, uniqueIndex in pairs(cell.data.packets.spawn) do
								if tableHelper.containsValue(indexTab.player[pid], uniqueIndex, true) then
									cell.data.objectData[uniqueIndex] = nil
									tableHelper.removeValue(cell.data.packets.spawn, uniqueIndex)	
									if tableHelper.getCount(Players) > 0 then		
										logicHandler.DeleteObjectForEveryone(cellTab.player[pid].cell, uniqueIndex)
									end
								end
							end
							cell:SaveToDrive()			
						elseif cell ~= nil then	
							for _, uniqueIndex in pairs(cell.data.packets.spawn) do
								if tableHelper.containsValue(indexTab.player[pid], uniqueIndex, true) then
									cell.data.objectData[uniqueIndex] = nil
									tableHelper.removeValue(cell.data.packets.spawn, uniqueIndex)
									if tableHelper.getCount(Players) > 0 then	
										logicHandler.DeleteObjectForEveryone(cellTab.player[pid].cell, uniqueIndex)	
									end
								end
							end
							cell:SaveToDrive()
						end	
						if useTemporaryLoad == true then
							logicHandler.UnloadCell(cellTab.player[pid].cell)
						end			
					end
					doorTab.player[pid].object = nil
					cellTab.player[pid].cell = nil
					creaTab.player[pid] = nil
					indexTab.player[pid] = nil
				end
			end
		end
	end
end

customEventHooks.registerValidator("OnObjectActivate", DragonDoor.OnObjectActivate)
customEventHooks.registerHandler("OnPlayerCellChange", DragonDoor.OnPlayerCellChange)

return DragonDoor
