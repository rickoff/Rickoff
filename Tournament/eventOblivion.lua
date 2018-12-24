--eventOblivion.lua

tableHelper = require("tableHelper")
inventoryHelper = require("inventoryHelper")
jsonInterface = require("jsonInterface")


local config = {}

config.timerevent = 60
config.oblivionstart = 300
config.oblivionstop = 240
config.timerstand = 1
config.count = 500
config.bosses = {"dremora"}
config.portail = {"in_strong_platform"}
local eventOblivion = {}

local OblivionStart = tes3mp.CreateTimer("OblivionEvent", time.seconds(config.oblivionstart))
local OblivionStop = tes3mp.CreateTimer("StopOblivion", time.seconds(config.oblivionstop))
local TimerOblivion = tes3mp.CreateTimer("StartOblivion", time.seconds(config.timerstand))

local oblivionRandom = nil
local cellId = nil
local creatureRefId = "dremora"
local portailRefId = "in_strong_platform"
local eventoblivion = "inactive"
local oblivionTab = {}
oblivionTab.count = 0
oblivionTab.port = 0

eventOblivion.TimerStartEvent = function()
	tes3mp.StartTimer(OblivionStart)
	tes3mp.LogAppend(enumerations.log.INFO, "....START TIMER EVENT OBLIVION....")		
end

function OblivionEvent()
	if tableHelper.getCount(Players) > 0 then
		Playerpid = tableHelper.getAnyValue(Players).pid
		eventOblivion.AdminStart(Playerpid)
		oblivionRandom = math.random(1, 5)
	else
		tes3mp.RestartTimer(OblivionStart, time.seconds(config.oblivionstart))
	end
end

function StopOblivion()
	if tableHelper.getCount(Players) > 0 and eventoblivion == "active" then
		Playerpid = tableHelper.getAnyValue(Players).pid
		eventOblivion.End(Playerpid)
	else
		tes3mp.RestartTimer(OblivionStart, time.seconds(config.oblivionstart))
	end
end

function StartOblivion()
	if tableHelper.getCount(Players) > 0 and eventoblivion == "active" then
		eventOblivion.spawn(pid)
		tes3mp.RestartTimer(TimerOblivion, time.seconds(config.timerstand))		
	else
		tes3mp.RestartTimer(OblivionStart, time.seconds(config.oblivionstart))
	end
end

eventOblivion.AdminStart = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local TimerEvent = tes3mp.CreateTimer("StartO", time.seconds(config.timerevent))
		local Timerthirty = tes3mp.CreateTimer("CallforOblivion", time.seconds(config.timerevent / 2))
		tes3mp.StartTimer(TimerEvent)
		tes3mp.StartTimer(Timerthirty)	
		tes3mp.SendMessage(pid,color.Default.."Une faille vers l'"..color.Red.." oblivion"..color.Default.." a été ouverte."..color.Yellow.."Preparez vous a repousser les forces du mal."..color.Yellow.." Gain:"..color.Default.." 500 pièces d'or par ennemie tué.\n",true)
	end
end

eventOblivion.spawn = function(pid)
    if eventoblivion == "active" then
		local packetType = "spawn"
		local randoX
		local randoY
		local posx
		local posy
		local posz	
		randoX = math.random(25, 500)
		randoY = math.random(25, 500)
		if oblivionRandom == 1 then
			posx = -23536 + randoX
			posy = -15629 + randoY
			posz = 510		
			cellId = "-3, -2" 
		elseif oblivionRandom == 2 then
			posx = 5624 + randoX
			posy = -56180 + randoY
			posz = 1681		
			cellId = "0, -7" 
		elseif oblivionRandom == 3 then
			posx = -12173 + randoX
			posy = 54353 + randoY
			posz = 2339		
			cellId = "-2, 6"
		elseif oblivionRandom == 4 then
			posx = 30058 + randoX
			posy = -73404 + randoY
			posz = 428		
			cellId = "3, -9" 	
		elseif oblivionRandom == 5 then
			posx = 143157 + randoX
			posy = 35893 + randoY
			posz = 469		
			cellId = "17, 4" 
		end
		
		if oblivionTab.count < 10 and creatureRefId ~= nil and cellId ~= nil and posx ~= nil and posy ~= nil and posz ~= nil then
			local packetType = "spawn"
			local position = { posX = tonumber(posx), posY = tonumber(posy), posZ = tonumber(posz), rotX = 0, rotY = 0, rotZ = 0 }
			tes3mp.LogMessage(2, "Spawn")
			tes3mp.LogMessage(2, creatureRefId)
			tes3mp.LogMessage(2, cellId)
			logicHandler.CreateObjectAtLocation(cellId, position, creatureRefId, packetType)
			oblivionTab.count = oblivionTab.count + 1
			
		elseif oblivionTab.port == 0 and portailRefId ~= nil and cellId ~= nil and posx ~= nil and posy ~= nil and posz ~= nil then
			local packetType = "place"
			local position = { posX = tonumber(posx), posY = tonumber(posy), posZ = tonumber(posz), rotX = 0, rotY = 0, rotZ = 0 }
			tes3mp.LogMessage(2, "place")
			tes3mp.LogMessage(2, portailRefId)
			tes3mp.LogMessage(2, cellId)
			logicHandler.CreateObjectAtLocation(cellId, position, portailRefId, packetType)
			oblivionTab.port = oblivionTab.port + 1	
		end
	end
end


function CallforOblivion()
	for pid , value in pairs(Players) do	
		tes3mp.SendMessage(pid,"Attention !"..color.Yellow.." attaque"..color.Default.." dans 30 secondes. Le portail d'"..color.Red.." Oblivion"..color.Default..", est en approche.\n",false)
	end
end

function StartO()
	for pid , value in pairs(Players) do	
		if oblivionRandom == 1 then
			tes3mp.SendMessage(pid,"Le combat a commencé !"..color.Red.." defendez les terres de Vvardenfell contre l'invasion !"..color.Default.." Le portail est apparu à Balmora !\n",false)
		elseif oblivionRandom == 2 then	
			tes3mp.SendMessage(pid,"Le combat a commencé !"..color.Red.." defendez les terres de Vvardenfell contre l'invasion !"..color.Default.." Le portail est apparu à Pelagiad !\n",false)			
		elseif oblivionRandom == 3 then	
			tes3mp.SendMessage(pid,"Le combat a commencé !"..color.Red.." defendez les terres de Vvardenfell contre l'invasion !"..color.Default.." Le portail est apparu à Ald'ruhn !\n",false)		
		elseif oblivionRandom == 4 then	
			tes3mp.SendMessage(pid,"Le combat a commencé !"..color.Red.." defendez les terres de Vvardenfell contre l'invasion !"..color.Default.." Le portail est apparu à Vivec !\n",false)			
		elseif oblivionRandom == 5 then	
			tes3mp.SendMessage(pid,"Le combat a commencé !"..color.Red.." defendez les terres de Vvardenfell contre l'invasion !"..color.Default.." Le portail est apparue à Sadrith Mora !\n",false)		
		end
	end	
	eventoblivion = "active" 
	tes3mp.StartTimer(TimerOblivion)		
	tes3mp.StartTimer(OblivionStop)	
end

eventOblivion.Prime = function(pid)
	local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)
	local refId	
    for index = 0, tes3mp.GetKillChangesSize(pid) - 1 do
        refId = tes3mp.GetKillRefId(pid, index)
	end		
	local cell = tes3mp.GetCell(pid)
	
	if tableHelper.containsValue(config.bosses, refId) and eventoblivion == "active" then
		if goldLoc == nil then
			table.insert(Players[pid].data.inventory, {refId = "gold_001", count = config.count, charge = -1})			
		else
			Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count + config.count
			local countprice = Players[pid].data.inventory[goldLoc].count + config.count
		end
		tes3mp.MessageBox(pid, -1, "Tu a récupéré une prime !")
		local itemref = {refId = "gold_001", count = config.count, charge = -1}			
		Players[pid]:Save()
		Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)						
	end
end

eventOblivion.End = function(pid)
	eventoblivion = "inactive"
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		for pid , value in pairs(Players) do	
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
				tes3mp.SendMessage(pid,color.Blue.."Le portail d'oblivion est maintenant fermé.  \n",false)
				eventOblivion.CleanCell(cellId)
			end
		end
	end
	tes3mp.RestartTimer(OblivionStart, time.seconds(config.oblivionstart))	
	oblivionTab.count = 0
	oblivionTab.port = 0
end

eventOblivion.CleanCell = function(cellDescription)
	if cellDescription ~= nil then
		local cell = LoadedCells[cellDescription]
		local useTemporaryLoad = false
		if cell == nil then
			logicHandler.LoadCell(cellDescription)
			useTemporaryLoad = true
		end
		if cell ~= nil then
			for _, uniqueIndex in pairs(cell.data.packets.spawn) do
				if cell.data.objectData[uniqueIndex].refId == creatureRefId then
					cell.data.objectData[uniqueIndex] = nil
					tableHelper.removeValue(cell.data.packets.spawn, uniqueIndex)
					logicHandler.DeleteObjectForEveryone(cellDescription, uniqueIndex)				
				end
			end
			for _, uniqueIndex in pairs(cell.data.packets.place) do			
				if cell.data.objectData[uniqueIndex].refId == portailRefId then
					cell.data.objectData[uniqueIndex] = nil
					tableHelper.removeValue(cell.data.packets.place, uniqueIndex)
					logicHandler.DeleteObjectForEveryone(cellDescription, uniqueIndex)	
				end
			end
			cell:Save()
		end	
		if useTemporaryLoad then
			logicHandler.UnloadCell(cellDescription)
		end
	end
end

return eventOblivion
		eventOblivion.End(Playerpid)
	else
		tes3mp.RestartTimer(OblivionStart, time.seconds(config.oblivionstart))
	end
end

function StartOblivion()
	if tableHelper.getCount(Players) > 0 and eventoblivion == "active" then
		eventOblivion.spawn(pid)
		tes3mp.RestartTimer(TimerOblivion, time.seconds(config.timerstand))		
	else
		tes3mp.RestartTimer(OblivionStart, time.seconds(config.oblivionstart))
	end
end

eventOblivion.AdminStart = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local TimerEvent = tes3mp.CreateTimer("StartO", time.seconds(config.timerevent))
		local Timerthirty = tes3mp.CreateTimer("CallforOblivion", time.seconds(config.timerevent / 2))
		tes3mp.StartTimer(TimerEvent)
		tes3mp.StartTimer(Timerthirty)	
		tes3mp.SendMessage(pid,color.Default.."Une faille vers l'"..color.Red.." oblivion"..color.Default.." à été ouverte."..color.Yellow.."Preparez vous à repousser les forces du mal."..color.Yellow.." Gain:"..color.Default.." 500 pièces d'or par ennemie tué.\n",true)
	end
end

eventOblivion.spawn = function(pid)
    if eventoblivion == "active" then
		local packetType = "spawn"
		local randoX
		local randoY
		local posx
		local posy
		local posz	
		randoX = math.random(25, 500)
		randoY = math.random(25, 500)
		if oblivionRandom == 1 then
			posx = -23536 + randoX
			posy = -15629 + randoY
			posz = 510		
			cellId = "-3, -2" 
		elseif oblivionRandom == 2 then
			posx = 5624 + randoX
			posy = -56180 + randoY
			posz = 1681		
			cellId = "0, -7" 
		elseif oblivionRandom == 3 then
			posx = -12173 + randoX
			posy = 54353 + randoY
			posz = 2339		
			cellId = "-2, 6"
		elseif oblivionRandom == 4 then
			posx = 30058 + randoX
			posy = -73404 + randoY
			posz = 428		
			cellId = "3, -9" 	
		elseif oblivionRandom == 5 then
			posx = 143157 + randoX
			posy = 35893 + randoY
			posz = 469		
			cellId = "17, 4" 
		end
		
		if oblivionTab.count < 10 and creatureRefId ~= nil and cellId ~= nil and posx ~= nil and posy ~= nil and posz ~= nil then
			local packetType = "spawn"
			local position = { posX = tonumber(posx), posY = tonumber(posy), posZ = tonumber(posz), rotX = 0, rotY = 0, rotZ = 0 }
			tes3mp.LogMessage(2, "Spawn")
			tes3mp.LogMessage(2, creatureRefId)
			tes3mp.LogMessage(2, cellId)
			logicHandler.CreateObjectAtLocation(cellId, position, creatureRefId, packetType)
			oblivionTab.count = oblivionTab.count + 1
			
		elseif oblivionTab.port == 0 and portailRefId ~= nil and cellId ~= nil and posx ~= nil and posy ~= nil and posz ~= nil then
			local packetType = "place"
			local position = { posX = tonumber(posx), posY = tonumber(posy), posZ = tonumber(posz), rotX = 0, rotY = 0, rotZ = 0 }
			tes3mp.LogMessage(2, "place")
			tes3mp.LogMessage(2, portailRefId)
			tes3mp.LogMessage(2, cellId)
			logicHandler.CreateObjectAtLocation(cellId, position, portailRefId, packetType)
			oblivionTab.port = oblivionTab.port + 1	
		end
	end
end


function CallforOblivion()
	for pid , value in pairs(Players) do	
		tes3mp.SendMessage(pid,"Attention !"..color.Yellow.." attaque"..color.Default.." dans 30 secondes. Le portail d'"..color.Red.." Oblivion"..color.Default..", est en approche.\n",false)
	end
end

function StartO()
	for pid , value in pairs(Players) do	
		if oblivionRandom == 1 then
			tes3mp.SendMessage(pid,"Le combat a commencé !"..color.Red.." defendez les terres de Vvardenfell contre l'invasion !"..color.Default.." Le portail est apparue à Balmora !\n",false)
		elseif oblivionRandom == 2 then	
			tes3mp.SendMessage(pid,"Le combat a commencé !"..color.Red.." defendez les terres de Vvardenfell contre l'invasion !"..color.Default.." Le portail est apparue à Pelagiad !\n",false)			
		elseif oblivionRandom == 3 then	
			tes3mp.SendMessage(pid,"Le combat a commencé !"..color.Red.." defendez les terres de Vvardenfell contre l'invasion !"..color.Default.." Le portail est apparue à Ald'ruhn !\n",false)		
		elseif oblivionRandom == 4 then	
			tes3mp.SendMessage(pid,"Le combat a commencé !"..color.Red.." defendez les terres de Vvardenfell contre l'invasion !"..color.Default.." Le portail est apparue à Vivec !\n",false)			
		elseif oblivionRandom == 5 then	
			tes3mp.SendMessage(pid,"Le combat a commencé !"..color.Red.." defendez les terres de Vvardenfell contre l'invasion !"..color.Default.." Le portail est apparue à Sadrith Mora !\n",false)		
		end
	end	
	eventoblivion = "active" 
	tes3mp.StartTimer(TimerOblivion)		
	tes3mp.StartTimer(OblivionStop)	
end

eventOblivion.Prime = function(pid)
	local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)
	local addgold = 0
	local message = color.Red.. "Un drémora vient d'être tuée !\n"
	local refId	
    for index = 0, tes3mp.GetKillChangesSize(pid) - 1 do
        refId = tes3mp.GetKillRefId(pid, index)
	end		
	local cell = tes3mp.GetCell(pid)
	
	if tableHelper.containsValue(config.bosses, refId) and eventoblivion == "active" then
		if goldLoc == nil then
			table.insert(Players[pid].data.inventory, {refId = "gold_001", count = config.count, charge = -1})			
		else
			Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count + config.count
			local countprice = Players[pid].data.inventory[goldLoc].count + config.count
		end
		tes3mp.MessageBox(pid, -1, "Tu a récupéré une prime !")
		tes3mp.SendMessage(pid, message, true)
		local itemref = {refId = "gold_001", count = config.count, charge = -1}			
		Players[pid]:Save()
		Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)						
	end
end

eventOblivion.End = function(pid)
	eventoblivion = "inactive"
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		for pid , value in pairs(Players) do	
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
				tes3mp.SendMessage(pid,color.Blue.."Le portail d'oblivion est maintenant fermé.  \n",false)
				eventOblivion.CleanCell(cellId)
			end
		end
	end
	tes3mp.RestartTimer(OblivionStart, time.seconds(config.oblivionstart))	
	oblivionTab.count = 0
	oblivionTab.port = 0
end

eventOblivion.CleanCell = function(cellDescription)
	if cellDescription ~= nil then
		local cell = LoadedCells[cellDescription]
		local useTemporaryLoad = false
		if cell == nil then
			logicHandler.LoadCell(cellDescription)
			useTemporaryLoad = true
		end
		if cell ~= nil then
			for _, uniqueIndex in pairs(cell.data.packets.spawn) do
				if cell.data.objectData[uniqueIndex].refId == creatureRefId then
					cell.data.objectData[uniqueIndex] = nil
					tableHelper.removeValue(cell.data.packets.spawn, uniqueIndex)
					logicHandler.DeleteObjectForEveryone(cellDescription, uniqueIndex)				
				end
			end
			for _, uniqueIndex in pairs(cell.data.packets.place) do			
				if cell.data.objectData[uniqueIndex].refId == portailRefId then
					cell.data.objectData[uniqueIndex] = nil
					tableHelper.removeValue(cell.data.packets.place, uniqueIndex)
					logicHandler.DeleteObjectForEveryone(cellDescription, uniqueIndex)	
				end
			end
			cell:Save()
		end	
		if useTemporaryLoad then
			logicHandler.UnloadCell(cellDescription)
		end
	end
end

return eventOblivion
