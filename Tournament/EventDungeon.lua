--[[
EventDungeon by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Syteme de donjon aléatoire avec boss et gain
---------------------------
INSTALLATION:
Save the file as EventDungeon.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
EventDungeon = require("custom.EventDungeon")
---------------------------
]]

tableHelper = require("tableHelper")
inventoryHelper = require("inventoryHelper")

local config = {}

config.timereventd = 60
config.timerstartd = 900
config.timerstopd = 600
config.timerboss = 300
config.countregister = 100
config.timerespawn = 10
config.gainxp = 100
config.timerRespawn = 0
config.bossId = "boss1_guerrier"
config.bossId2 = "boss2_rodeur"
config.bossId3 = "boss3_mage"
config.objetRare = "kal_dib_helmet"
config.salleBoss = "Vivec, maison_04"
config.creatures = {"boss1_guerrier", "boss2_rodeur", "boss3_mage"}
local EventDungeon = {}

local TimerStartd = tes3mp.CreateTimer("StartEventd", time.seconds(config.timerstartd))
local TimerStopd = tes3mp.CreateTimer("StopEventd", time.seconds(config.timerstopd))
local TimerBoss = tes3mp.CreateTimer("StopBoss", time.seconds(config.timerboss))

local eventDungeon = "inactive"
local eventBoss = false

local eventBossTab = {}
eventBossTab.count = 0

local dungeonTab = { player = {} }

local dungeonNumber = 0

EventDungeon.TimerStartEvent = function(eventStatus)
	tes3mp.StartTimer(TimerStartd)
	tes3mp.LogAppend(enumerations.log.INFO, "....START TIMER EVENT DUNGEON....")		
end

function StartEventd()
	if tableHelper.getCount(Players) > 0 and eventDungeon == "inactive" then
		Playerpid = tableHelper.getAnyValue(Players).pid
		EventDungeon.AdminStart(Playerpid)
	else
		tes3mp.RestartTimer(TimerStartd, time.seconds(config.timerstartd))
	end
end

function StopEventd()
	if tableHelper.getCount(Players) > 0 and eventDungeon == "active" then
		Playerpid = tableHelper.getAnyValue(Players).pid
		EventDungeon.Boss(Playerpid)
		eventBoss = true
		tes3mp.StartTimer(TimerBoss)
	else
		tes3mp.RestartTimer(TimerStartd, time.seconds(config.timerstartd))
	end
end

function StopBoss()
	for pid, pl in pairs(dungeonTab.player) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			tes3mp.SendMessage(pid,"Le temp pour tuer le boss est "..color.Red.."terminé ..\n",false)
			EventDungeon.End(pid)
		end
	end
end

EventDungeon.AdminStart = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local TimerEventd = tes3mp.CreateTimer("StartDungeon", time.seconds(config.timereventd))
		local Timerthreed = tes3mp.CreateTimer("threed", time.seconds(config.timereventd - 3))
		local Timertwod = tes3mp.CreateTimer("twod", time.seconds(config.timereventd - 2))
		local Timeroned = tes3mp.CreateTimer("oned", time.seconds(config.timereventd - 1))
		tes3mp.StartTimer(TimerEventd)
		tes3mp.StartTimer(Timerthreed)
		tes3mp.StartTimer(Timertwod)
		tes3mp.StartTimer(Timeroned)
		dungeonNumber = math.random(1, 8)
		if dungeonNumber == 1 then
			tes3mp.SendMessage(pid,color.Default.."Le donjon de "..color.Red.."la maison de la douleur"..color.Default.." a été lancé.\nEntrez"..color.Red.." /donjon"..color.White.." pour vous inscrire."..color.Yellow.."\ncoût :"..color.Default.." 100 pièces d'or.\n",true)
		elseif dungeonNumber == 2 then
			tes3mp.SendMessage(pid,color.Default.."Le donjon des "..color.Red.."morts-vivants"..color.Default.." a été lancé.\nEntrez"..color.Red.." /donjon"..color.White.." pour vous inscrire."..color.Yellow.."\ncoût :"..color.Default.." 100 pièces d'or.\n",true)		
		elseif dungeonNumber == 3 then
			tes3mp.SendMessage(pid,color.Default.."Le donjon du "..color.Red.."cimetière dwemer"..color.Default.." a été lancé.\nEntrez"..color.Red.." /donjon"..color.White.." pour vous inscrire."..color.Yellow.."\ncoût :"..color.Default.." 100 pièces d'or.\n",true)		
		elseif dungeonNumber == 4 then
			tes3mp.SendMessage(pid,color.Default.."Le donjon du "..color.Red.."challenge du gantelet"..color.Default.." a été lancé.\nEntrez"..color.Red.." /donjon"..color.White.." pour vous inscrire."..color.Yellow.."\ncoût :"..color.Default.." 100 pièces d'or.\n",true)
		elseif dungeonNumber == 5 then
			tes3mp.SendMessage(pid,color.Default.."Le donjon du "..color.Red.."sables des abysses"..color.Default.." a été lancé.\nEntrez"..color.Red.." /donjon"..color.White.." pour vous inscrire."..color.Yellow.."\ncoût :"..color.Default.." 100 pièces d'or.\n",true)	
		elseif dungeonNumber == 6 then
			tes3mp.SendMessage(pid,color.Default.."Le donjon de "..color.Red.."neselia"..color.Default.." a été lancé.\nEntrez"..color.Red.." /donjon"..color.White.." pour vous inscrire."..color.Yellow.."\ncoût :"..color.Default.." 100 pièces d'or.\n",true)	
		elseif dungeonNumber == 7 then
			tes3mp.SendMessage(pid,color.Default.."Le donjon des "..color.Red.."ruines d'Arkay"..color.Default.." a été lancé.\nEntrez"..color.Red.." /donjon"..color.White.." pour vous inscrire."..color.Yellow.."\ncoût :"..color.Default.." 100 pièces d'or.\n",true)	
		elseif dungeonNumber == 8 then
			tes3mp.SendMessage(pid,color.Default.."Le donjon de "..color.Red.."verre de Elokiel"..color.Default.." a été lancé.\nEntrez"..color.Red.." /donjon"..color.White.." pour vous inscrire."..color.Yellow.."\ncoût :"..color.Default.." 100 pièces d'or.\n",true)			
		end
	end
end

EventDungeon.Register = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local checkevent = Players[pid].data.customVariables.event	
		if checkevent == nil then
			Players[pid].data.customVariables.event = false
		end	
		local event = Players[pid].data.customVariables.event
		if event == false then
			local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)	
			if goldLoc ~= nil then
				local goldamount = Players[pid].data.inventory[goldLoc].count
				local newcount = config.countregister
				if goldamount < newcount then
					tes3mp.SendMessage(pid,"Vous n'avez pas assez d'or pour vous inscrire au donjon ! \n",false)	
				else
					Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count - newcount	
					tes3mp.SendMessage(pid,"Vous vous êtes inscrit au prochain donjon !  \n",false)
					dungeonTab.player[pid] = {score = 0}
					local itemref = {refId = "gold_001", count = newcount, charge = -1}			
					Players[pid]:SaveToDrive()
					Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)
					Players[pid].data.customVariables.event	= true				
				end			
			elseif goldLoc == nil then
				tes3mp.SendMessage(pid,"Vous n'avez pas d'or pour vous inscrire au donjon ! \n",false)
			end
		else
			tes3mp.SendMessage(pid,"Vous êtes déjà inscrit dans un autre évènement ! \n",false)
		end
	end
end

EventDungeon.spawnRandom = function(pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if dungeonNumber == 1 then
			tes3mp.SetCell(pid, "Maison de la Douleur, Niveau 1") 			
			tes3mp.SetPos(pid, 3843, -476, -126)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)	
		elseif dungeonNumber == 2 then
			tes3mp.SetCell(pid, "Le Donjon des Morts-vivants, A") 			
			tes3mp.SetPos(pid, 5792, -5146, -214)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)	
		elseif dungeonNumber == 3 then
			tes3mp.SetCell(pid, "Cimetière Dwemer, Niveau 1") 			
			tes3mp.SetPos(pid, 1157, -876, -191)		
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)	
		elseif dungeonNumber == 4 then
			tes3mp.SetCell(pid, "Challenge du Gantelet, Niveau 1")
			tes3mp.SetPos(pid, 3849, -1733, -127)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)	
		elseif dungeonNumber == 5 then
			tes3mp.SetCell(pid, "Sables des abysses, entrée") 			
			tes3mp.SetPos(pid, 894, -3424, 530)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)	
		elseif dungeonNumber == 6 then
			tes3mp.SetCell(pid, "Neselia, Auransel") 			
			tes3mp.SetPos(pid, 5017, 3388, 15048)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)
		elseif dungeonNumber == 7 then
			tes3mp.SetCell(pid, "Jarvik, Ruine, Arkay") 			
			tes3mp.SetPos(pid, 2031, 5941, 17921)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)
		elseif dungeonNumber == 8 then
			tes3mp.SetCell(pid, "Elokiel, donjon de verre") 			
			tes3mp.SetPos(pid, 419, 781, -1034)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)						
		end
	end
end

	
function threed()
	for pid, pl in pairs(dungeonTab.player) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			tes3mp.SendMessage(pid,"Le donjon commence dans"..color.Red.." 3 ...\n",false)
		end
	end
end

function twod()
	for pid, pl in pairs(dungeonTab.player) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			tes3mp.SendMessage(pid,"Le donjon commence dans"..color.Red.." 2 ..\n",false)
		end
	end
end

function oned()
	for pid, pl in pairs(dungeonTab.player) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			tes3mp.SendMessage(pid,"Le donjon commence dans"..color.Red.." 1 .\n",false)
		end
	end
end

function StartDungeon()
	local count = 0	
	for pid, pl in pairs(dungeonTab.player) do
		count = count + 1
	end
	if count >= 1 then
		for pid, value in pairs(dungeonTab.player) do
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
				tes3mp.SendMessage(pid,"Le donjon à commencé !\nTuer le boss, vous avez "..color.Red.."10 minutes"..color.White.." pour tuer des créatures avant de l'affronter !\n",false)
				EventDungeon.spawnRandom(pid)
			end
		end
		eventDungeon = "active"
		tes3mp.StartTimer(TimerStopd)		
	else
		for pid, value in pairs(dungeonTab.player) do
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
				tes3mp.SendMessage(pid,"Il n'y a pas assez de participant pour commencer le donjon !  \n",false)
				Players[pid].data.customVariables.event	= false
			end
		end	
		eventDungeon = "inactive"
		tes3mp.RestartTimer(TimerStartd, time.seconds(config.timerstartd))
	end
end

EventDungeon.checkKill = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if eventDungeon == "active" and dungeonTab.player[pid] ~= nil then
			EventDungeon.OnKill(pid)		
			return customEventHooks.makeEventStatus(false,false)
		end	
	end
end

EventDungeon.OnKill = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local timer = tes3mp.CreateTimerEx("Revivedungeon", time.seconds(config.timerespawn), "i", pid)
		tes3mp.StartTimer(timer)
	end
end

EventDungeon.OnKillCrea = function(eventStatus, pid, cellDescription)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
		if LoadedCells[cellDescription] ~= nil then		
			LoadedCells[cellDescription]:SaveActorDeath(pid)			
			local actorIndex = tes3mp.GetActorListSize() - 1			
			if actorIndex ~= nil then			
				local uniqueIndex = tes3mp.GetActorRefNum(actorIndex) .. "-" .. tes3mp.GetActorMpNum(actorIndex)				
				local killerPid = tes3mp.GetActorKillerPid(actorIndex)				
				if uniqueIndex ~= nil and killerPid ~= nil then				
					if LoadedCells[cellDescription].data.objectData[uniqueIndex] then					
						local creaId = LoadedCells[cellDescription].data.objectData[uniqueIndex].refId	
						if dungeonTab.player[pid] ~= nil then
							dungeonTab.player[pid].score = dungeonTab.player[pid].score + 1
						end	
						if creaId == config.bossId then
							EventDungeon.End(pid)
							local itemref = {refId = config.objetRare, count = 1, charge = -1}			
							Players[pid]:SaveToDrive()
							Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)
							tes3mp.SendMessage(pid,"Vous avez remporté l'objet rare de l'évènement, félicitation !\n",false)
						end
					end
				end
			end
		end
	end
end

function Revivedungeon(pid)	
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if eventBoss == false then
			EventDungeon.spawnRandom(pid)
			tes3mp.Resurrect(pid,0)
		elseif eventBoss == true then
			EventDungeon.Boss(pid)
			tes3mp.Resurrect(pid,0)
		end
    end	
end

EventDungeon.Boss = function(pid)
	for pid, value in pairs(dungeonTab.player) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			tes3mp.SetCell(pid, config.salleBoss) 			
			tes3mp.SetPos(pid, 3224, 3459, 13025)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)	
			tes3mp.SendMessage(pid,"Tuer le boss pour gagner l'objet rare !\n",false)	
		end
	end
	if eventBossTab.count == 0 then
		local packetType = "spawn"
		local position = { posX = 3573, posY = 5074, posZ = 12998, rotX = 0, rotY = 0, rotZ = 0 }
		logicHandler.CreateObjectAtLocation(config.salleBoss, position, config.bossId, packetType)
		logicHandler.CreateObjectAtLocation(config.salleBoss, position, config.bossId2, packetType)
		logicHandler.CreateObjectAtLocation(config.salleBoss, position, config.bossId3, packetType)		
		eventBossTab.count = eventBossTab.count + 1	
	end
end

EventDungeon.End = function(pid)
	eventDungeon = "inactive"	
	for pid2, value in pairs(dungeonTab.player) do
		if Players[pid2] ~= nil and Players[pid2]:IsLoggedIn() then	
			local score = dungeonTab.player[pid2].score
			local newprice = config.countregister * score			
			local goldLoc = inventoryHelper.getItemIndex(Players[pid2].data.inventory, "gold_001", -1)
			local newsoul = config.gainxp * score				
			if goldLoc == nil then
				tes3mp.SendMessage(pid2,"Vous venez de terminer l'évènement du donjon ! \n",false)
				table.insert(Players[pid2].data.inventory, {refId = "gold_001", count = newprice, charge = -1})
			else
				Players[pid2].data.inventory[goldLoc].count = Players[pid2].data.inventory[goldLoc].count + newprice	
				tes3mp.SendMessage(pid2,"Vous venez de terminer l'évènement du donjon !  \n",false)
			end	
			local soulLoc = Players[pid2].data.customVariables.soul
			if soulLoc == nil then
				Players[pid2].data.customVariables.soul = newsoul
			else
				Players[pid2].data.customVariables.soul = Players[pid2].data.customVariables.soul + newsoul
			end
			tes3mp.MessageBox(pid2, -1, color.Default.. "Vous avez gagné : "..color.Green.. newsoul ..color.Default.. "points d'" ..color.Yellow.. "exp.")
			tes3mp.MessageBox(pid2, -1, color.Default.. "Vous avez gagné : "..color.Green.. newprice ..color.Default.. "pièces " ..color.Yellow.. "d'or.")				
			local itemref = {refId = "gold_001", count = newprice, charge = -1}			
			Players[pid2]:SaveToDrive()
			Players[pid2]:LoadItemChanges({itemref}, enumerations.inventory.ADD)					
		end
	end		
	for pid, value in pairs(dungeonTab.player) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then		
			tes3mp.SendMessage(pid,"L'événement s'est terminé, vous êtes de retour en ville. \n",false)
			tes3mp.SetCell(pid, "-3,-2")  
			tes3mp.SetPos(pid, -23974, -15787, 505)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)	
			Players[pid].data.customVariables.event	= false	
		end
	end
	dungeonTab = { player = {} }
	eventBossTab.count = 0	
	EventDungeon.CleanCell(config.salleBoss)
	tes3mp.RestartTimer(TimerStartd, time.seconds(config.timerstartd))	
end

EventDungeon.CleanCell = function(cellDescription)
	if cellDescription ~= nil then
		local cell = LoadedCells[cellDescription]
		local useTemporaryLoad = false	
		if cell == nil then
			logicHandler.LoadCell(cellDescription)
			useTemporaryLoad = true
			cell = LoadedCells[cellDescription]
			local creatureRefId		
			for x, crea in pairs(config.creatures) do
				creatureRefId = crea		
				for _, uniqueIndex in pairs(cell.data.packets.spawn) do
					if cell.data.objectData[uniqueIndex].refId == creatureRefId then
						cell.data.objectData[uniqueIndex] = nil
						tableHelper.removeValue(cell.data.packets.spawn, uniqueIndex)	
						if tableHelper.getCount(Players) > 0 then		
							logicHandler.DeleteObjectForEveryone(cellDescription, uniqueIndex)
						end
					end
				end
			end
			cell:SaveToDrive()			
		elseif cell ~= nil then
			local creatureRefId		
			for x, crea in pairs(config.creatures) do
				creatureRefId = crea		
				for _, uniqueIndex in pairs(cell.data.packets.spawn) do
					if cell.data.objectData[uniqueIndex].refId == creatureRefId then
						cell.data.objectData[uniqueIndex] = nil
						tableHelper.removeValue(cell.data.packets.spawn, uniqueIndex)
						logicHandler.DeleteObjectForEveryone(cellDescription, uniqueIndex)				
					end
				end
			end
			cell:SaveToDrive()
		end	
		if useTemporaryLoad == true then
			logicHandler.UnloadCell(cellDescription)
		end
	end
end

EventDungeon.PlayerConnect = function(eventStatus, pid)
	Players[pid].data.customVariables.event	= false	
end

customCommandHooks.registerCommand("donjon", EventDungeon.Register)
customEventHooks.registerHandler("OnPlayerFinishLogin", EventDungeon.PlayerConnect)
customEventHooks.registerHandler("OnServerInit", EventDungeon.TimerStartEvent)
customEventHooks.registerHandler("OnActorDeath", EventDungeon.OnKillCrea)
customEventHooks.registerValidator("OnPlayerDeath", EventDungeon.checkKill)

return EventDungeon
