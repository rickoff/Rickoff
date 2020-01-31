--[[
DragonDoor by Rickoff
tes3mp 0.7.0
script version 0.6
---------------------------
DESCRIPTION :
creatures and npc follow players through doors
---------------------------
INSTALLATION:
Save the file as DragonDoor.lua inside your server/scripts/custom folder.
Save the file as EcarlateDoor.lua inside your server/data/custom folder.
Edits to customScripts.lua
DragonDoor = require("custom.DragonDoor")
]]

tableHelper = require("tableHelper")
jsonInterface = require("jsonInterface")

local Start = tes3mp.CreateTimer("Chase", time.seconds(1))

local cfg = {}
cfg.rad = 1000
cfg.chase = 2500

local DoorData = {}
local DoorList = jsonInterface.load("custom/EcarlateDoor.json")
for index, item in pairs(DoorList) do
	table.insert(DoorData, {NAME = item.name, REFID = string.lower(item.Refid)})
end

local doorTab = { player = {} }
local creaTab = { player = {} }
local indexTab = { player = {} }
local cellTab = { player = {} }
local chaseTab = { player = {} }

local listEscort = {"compagnon_guerrier", "compagnon_magicien", "compagnon_rodeur", "rat_pack_rerlas", "chien_pack_rerlas", "guar_pack_rerlas", "plx_butterfly", 
"assaba-bentus", "botrir", "ciralinde", "corky", "dandsa", "davina", "delyna mandas", "deval beleth", "din", "drerel indaren", "edras oril", "falura llervu",
"fjorgeir", "fonus rathryon", "frelene acques", "hannat zainsubani", "hides-his-foot", "hlormar wine-sot", "huleeya", "itermerel", "jadier mannick", "j'saddha", 
"larienna macrina", "madura seran", "malexa", "manilian scerius", "mathis dalobar", "menelras", "nartise arobar", "nevrasa dralor", "paur maston", "pemenie",
"rabinna", "ragash gra-shuzgub", "reeh-jah", "rollie the guar", "s'bakha", "saprius entius", "satyana", "shock centurion", "sinnammu mirpal",
"sondaale of shimmerene", "tarvyn faren", "tenyeminwe", "teres arothan", "teris raledran", "tul", "ulyne henim", "varvur sarethi", "vedelea othril", "viatrix petilia"}

local DragonDoor = {}

DragonDoor.TimerStart = function(eventStatus)
	tes3mp.StartTimer(Start)
	tes3mp.LogAppend(enumerations.log.INFO, "....START TIMER DRAGONDOOR CHASE....")
end

DragonDoor.OnPlayerConnect = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
		doorTab.player[pid] = nil
		cellTab.player[pid] = nil
		creaTab.player[pid] = nil
		indexTab.player[pid] = nil
		chaseTab.player[pid] = nil
	end
end

function Chase()
	for pid, y in pairs(chaseTab.player) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
			if chaseTab.player[pid].chase == true then
				if tes3mp.GetSneakState(pid) then
					local cell = tes3mp.GetCell(pid)
					for _, uniqueIndex in pairs(LoadedCells[cell].data.packets.actorList) do
						if LoadedCells[cell].data.objectData[uniqueIndex] then
							if LoadedCells[cell].data.objectData[uniqueIndex].location then
								local playerPosX = tes3mp.GetPosX(pid)
								local playerPosY = tes3mp.GetPosY(pid)							
								local creaturePosX = LoadedCells[cell].data.objectData[uniqueIndex].location.posX
								local creaturePosY = LoadedCells[cell].data.objectData[uniqueIndex].location.posY
								local distance = math.sqrt((playerPosX - creaturePosX) * (playerPosX - creaturePosX) + (playerPosY - creaturePosY) * (playerPosY - creaturePosY)) 	
								if distance > cfg.chase then
									logicHandler.SetAIForActor(LoadedCells[cell], uniqueIndex, "0", pid)
									logicHandler.SetAIForActor(LoadedCells[cell], uniqueIndex, "6", pid)
								end
							end
						end
					end
				end
			end
		end
	end
	tes3mp.RestartTimer(Start, time.seconds(1))
end

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
		logicHandler.LoadCell(cellDescription)		
		if ObjectIndex ~= nil and ObjectRefid ~= nil then	
			if tableHelper.containsValue(DoorData, string.lower(ObjectRefid), true) then	
				doorTab.player[pid] = {object = ObjectRefid} 
				cellTab.player[pid] = {cell = cellDescription} 
				creaTab.player[pid] = {}
				indexTab.player[pid] = {}	
				for _, uniqueIndex in pairs(cell.data.packets.spawn) do
					if cell.data.objectData[uniqueIndex] then
						if cell.data.objectData[uniqueIndex].refId and cell.data.objectData[uniqueIndex].location then
							local creatureRefId = cell.data.objectData[uniqueIndex].refId							
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
				for _, uniqueIndex in pairs(cell.data.packets.actorList) do
					if cell.data.objectData[uniqueIndex] then
						if cell.data.objectData[uniqueIndex].refId and cell.data.objectData[uniqueIndex].location then
							local creatureRefId = cell.data.objectData[uniqueIndex].refId							
							local creaturePosX = cell.data.objectData[uniqueIndex].location.posX
							local creaturePosY = cell.data.objectData[uniqueIndex].location.posY
							local distance = math.sqrt((playerPosX - creaturePosX) * (playerPosX - creaturePosX) + (playerPosY - creaturePosY) * (playerPosY - creaturePosY)) 
							local fatigueBase
							local fatigueCurrent							
							tes3mp.ReadCellActorList(cell.description)
							local actorListSize = tes3mp.GetActorListSize()
							if actorListSize == 0 then
								return
							end
							for objectIndex = 0, actorListSize - 1 do
								local uniqueIndexCheck = tes3mp.GetActorRefNum(objectIndex) .. "-" .. tes3mp.GetActorMpNum(objectIndex)
								if tes3mp.DoesActorHaveStatsDynamic(objectIndex) == true and cell:ContainsObject(uniqueIndex) and uniqueIndexCheck == uniqueIndex then						
									fatigueBase = tes3mp.GetActorFatigueModified(objectIndex)
									fatigueCurrent = tes3mp.GetActorFatigueCurrent(objectIndex)
								end
							end
							if fatigueBase ~= nil and fatigueCurrent ~= nil then
								if distance < cfg.rad and not tableHelper.containsValue(cell.data.packets.death, uniqueIndex, true) and not tableHelper.containsValue(listEscort, string.lower(creatureRefId), true) and not tableHelper.containsValue(indexTab.player, uniqueIndex, true) and fatigueCurrent ~= fatigueBase then
									table.insert(creaTab.player[pid], creatureRefId)
									table.insert(indexTab.player[pid], uniqueIndex)							
								end	
							end
						end
					end
				end	
				if creaTab.player[pid] ~= nil then
					chaseTab.player[pid] = {chase = true}
				else
					chaseTab.player[pid] = {chase = false}
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
							for _, uniqueIndex in pairs(cell.data.packets.spawn) do
								if tableHelper.containsValue(indexTab.player[pid], uniqueIndex, true) then
									tableHelper.removeValue(cell.data.objectData, uniqueIndex)
									tableHelper.removeValue(cell.data.packets, uniqueIndex)
									logicHandler.DeleteObjectForEveryone(cellTab.player[pid].cell, uniqueIndex)
								end
							end	
							for _, uniqueIndex in pairs(cell.data.packets.actorList) do
								if tableHelper.containsValue(indexTab.player[pid], uniqueIndex, true) then
									tableHelper.removeValue(cell.data.objectData, uniqueIndex)
									tableHelper.removeValue(cell.data.packets, uniqueIndex)
									logicHandler.DeleteObjectForEveryone(cellTab.player[pid].cell, uniqueIndex)
								end
							end								
							cell:QuicksaveToDrive()			
						elseif cell ~= nil then	
							for _, uniqueIndex in pairs(cell.data.packets.spawn) do
								if tableHelper.containsValue(indexTab.player[pid], uniqueIndex, true) then
									tableHelper.removeValue(cell.data.objectData, uniqueIndex)
									tableHelper.removeValue(cell.data.packets, uniqueIndex)
									logicHandler.DeleteObjectForEveryone(cellTab.player[pid].cell, uniqueIndex)	
								end
							end	
							for _, uniqueIndex in pairs(cell.data.packets.actorList) do
								if tableHelper.containsValue(indexTab.player[pid], uniqueIndex, true) then
									tableHelper.removeValue(cell.data.objectData, uniqueIndex)
									tableHelper.removeValue(cell.data.packets, uniqueIndex)
									logicHandler.DeleteObjectForEveryone(cellTab.player[pid].cell, uniqueIndex)
								end
							end								
							cell:QuicksaveToDrive()
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

customEventHooks.registerHandler("OnServerInit", DragonDoor.TimerStart)
customEventHooks.registerHandler("OnPlayerAuthentified", DragonDoor.OnPlayerConnect)
customEventHooks.registerHandler("OnObjectActivate", DragonDoor.OnObjectActivate)
customEventHooks.registerHandler("OnPlayerCellChange", DragonDoor.OnPlayerCellChange)

return DragonDoor
