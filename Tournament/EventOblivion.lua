--[[
EventOblivion by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Invocation de daedra dans des portails aléatoire
---------------------------
INSTALLATION:
Save the file as EventOblivion.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
EventOblivion = require("custom.EventOblivion")
---------------------------
]]

tableHelper = require("tableHelper")
inventoryHelper = require("inventoryHelper")

local config = {}

config.timerevent = 60
config.oblivionstart = 360
config.oblivionstop = 300
config.timerstand = 1
config.count = 500
config.bosses = {"dremora", "dremora_lord", "plx_dremora8", "plx_dremora2_archer", "plx_strongscamp", "plx_clannterror", "plx_overlord"}
config.creatures = {"dremora", "dremora_lord", "plx_dremora8", "plx_dremora2_archer", "plx_strongscamp", "plx_clannterror", "plx_overlord"}
config.portail = {"in_strong_platform"}
config.CellId = {"5, -6", "2, 4", "-3, 6", "3, -9", "17, 4"}
local EventOblivion = {}

local OblivionStart = tes3mp.CreateTimer("OblivionEvent", time.seconds(config.oblivionstart))
local OblivionStop = tes3mp.CreateTimer("StopOblivion", time.seconds(config.oblivionstop))
local TimerOblivion = tes3mp.CreateTimer("StartOblivion", time.seconds(config.timerstand))

local oblivionRandom = nil
local cellId = nil
local portailRefId = "in_strong_platform"
local eventoblivion = "inactive"
local oblivionTab = {}
oblivionTab.count = 0
oblivionTab.port = 0

EventOblivion.TimerStartEvent = function(eventStatus)
	tes3mp.StartTimer(OblivionStart)
	tes3mp.LogAppend(enumerations.log.INFO, "....START TIMER EVENT OBLIVION....")
	local cellDescriptionX
	local cellDescriptionY
	for x = -99, 99 do
		cellDescriptionX = x
		for y = -99, 99 do
			cellDescriptionY = y
			local cellDescription = cellDescriptionX .. ", " .. cellDescriptionY
			if tableHelper.containsValue(config.CellId, cellDescription) then
				EventOblivion.CleanCell(cellDescription)
			end	
		end
	end
end

function OblivionEvent()
	EventOblivion.AdminStart()
	oblivionRandom = math.random(1, 5)
end

function StopOblivion()
	if eventoblivion == "active" then
		EventOblivion.End()
	else
		tes3mp.RestartTimer(OblivionStart, time.seconds(config.oblivionstart))
	end
end

function StartOblivion()
	if eventoblivion == "active" then
		EventOblivion.spawn()
		tes3mp.RestartTimer(TimerOblivion, time.seconds(config.timerstand))		
	else
		tes3mp.RestartTimer(OblivionStart, time.seconds(config.oblivionstart))
	end
end

EventOblivion.AdminStart = function()
	if tableHelper.getCount(Players) > 0 then
		Playerpid = tableHelper.getAnyValue(Players).pid
	end
	if Players[Playerpid] ~= nil and Players[Playerpid]:IsLoggedIn() then
		tes3mp.SendMessage(Playerpid,color.Default.."Une faille vers l'"..color.Red.." oblivion"..color.Default.." a été ouverte."..color.Yellow.."\nGain :"..color.Default.." 500 pièces d'or par ennemi tué.\n",true)
	end
	local TimerEvent = tes3mp.CreateTimer("StartO", time.seconds(config.timerevent))
	local Timerthirty = tes3mp.CreateTimer("CallforOblivion", time.seconds(config.timerevent / 2))
	tes3mp.StartTimer(TimerEvent)
	tes3mp.StartTimer(Timerthirty)	
end

EventOblivion.spawn = function()
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
			posx = 47899 + randoX
			posy = -48871 + randoY
			posz = 738		
			cellId = "5, -6" 
		elseif oblivionRandom == 2 then
			posx = 20073 + randoX
			posy = 36646 + randoY
			posz = 858		
			cellId = "2, 4" 
		elseif oblivionRandom == 3 then
			posx = -22007 + randoX
			posy = 54320 + randoY
			posz = 1031		
			cellId = "-3, 6"
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
		randoCrea = math.random(1, 7)
		local creatureRefId		
		for x, crea in pairs(config.creatures) do
			if x == randoCrea then
				creatureRefId = crea
			end
		end
		if oblivionTab.port > 0 and oblivionTab.count < 6 and creatureRefId ~= nil and cellId ~= nil and posx ~= nil and posy ~= nil and posz ~= nil then
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
	if tableHelper.getCount(Players) > 0 then
		for pid , value in pairs(Players) do	
			tes3mp.SendMessage(pid,"Attention !"..color.Yellow.." attaque"..color.Default.." dans 30 secondes.\nLe portail d'"..color.Red.." Oblivion"..color.Default..", est en approche.\n",false)
		end
	end
end

function StartO()
	if tableHelper.getCount(Players) > 0 then
		for pid , value in pairs(Players) do	
			if oblivionRandom == 1 then
				tes3mp.SendMessage(pid,"Le combat a commencé !"..color.Red.."\nDefendez les terres de Vvardenfell contre l'invasion !"..color.Default.."\nLe portail est apparu à "..color.Red.."Suran !\n",false)
			elseif oblivionRandom == 2 then	
				tes3mp.SendMessage(pid,"Le combat a commencé !"..color.Red.."\nDefendez les terres de Vvardenfell contre l'invasion !"..color.Default.."\nLe portail est apparu à "..color.Red.."La porte des ames !\n",false)			
			elseif oblivionRandom == 3 then	
				tes3mp.SendMessage(pid,"Le combat a commencé !"..color.Red.."\nDefendez les terres de Vvardenfell contre l'invasion !"..color.Default.."\nLe portail est apparu à "..color.Red.."Ald'ruhn !\n",false)		
			elseif oblivionRandom == 4 then	
				tes3mp.SendMessage(pid,"Le combat a commencé !"..color.Red.."\nDefendez les terres de Vvardenfell contre l'invasion !"..color.Default.."\nLe portail est apparu à "..color.Red.."Vivec !\n",false)			
			elseif oblivionRandom == 5 then	
				tes3mp.SendMessage(pid,"Le combat a commencé !"..color.Red.."\nDefendez les terres de Vvardenfell contre l'invasion !"..color.Default.."\nLe portail est apparue à "..color.Red.."Sadrith Mora !\n",false)		
			end
		end
	end
	eventoblivion = "active" 
	tes3mp.StartTimer(TimerOblivion)		
	tes3mp.StartTimer(OblivionStop)	
end

EventOblivion.Prime = function(eventStatus, pid, cellDescription)	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
		if LoadedCells[cellDescription] ~= nil then		
			LoadedCells[cellDescription]:SaveActorDeath(pid)			
			local actorIndex = tes3mp.GetActorListSize() - 1			
			if actorIndex ~= nil then			
				local uniqueIndex = tes3mp.GetActorRefNum(actorIndex) .. "-" .. tes3mp.GetActorMpNum(actorIndex)				
				local killerPid = tes3mp.GetActorKillerPid(actorIndex)				
				if uniqueIndex ~= nil and killerPid ~= nil then					
					if LoadedCells[cellDescription].data.objectData[uniqueIndex] then					
						local refId = LoadedCells[cellDescription].data.objectData[uniqueIndex].refId		
						if Players[killerPid] ~= nil then
							local goldLoc = inventoryHelper.getItemIndex(Players[killerPid].data.inventory, "gold_001", -1)
							local cell = tes3mp.GetCell(killerPid)							
							if tableHelper.containsValue(config.bosses, refId) and eventoblivion == "active" and cell == cellId then
								if goldLoc == nil then
									table.insert(Players[killerPid].data.inventory, {refId = "gold_001", count = config.count, charge = -1, soul = ""})			
								else
									Players[killerPid].data.inventory[goldLoc].count = Players[killerPid].data.inventory[goldLoc].count + config.count
								end
								tes3mp.MessageBox(killerPid, -1, "Tu a récupéré une prime !")
								local itemref = {refId = "gold_001", count = config.count, charge = -1, soul = ""}			
								Players[killerPid]:QuicksaveToDrive()
								Players[killerPid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)						
							end
						end
					end
				end
			end
		end
	end
end

EventOblivion.End = function()
	eventoblivion = "inactive"
	if tableHelper.getCount(Players) > 0 then
		Playerpid = tableHelper.getAnyValue(Players).pid	
	end
	if Players[Playerpid] ~= nil and Players[Playerpid]:IsLoggedIn() then
		for pid , value in pairs(Players) do	
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
				tes3mp.SendMessage(pid,color.Blue.."Le portail d'oblivion est maintenant fermé.\n",false)
			end
		end
	end
	EventOblivion.CleanCell(cellId)	
	tes3mp.RestartTimer(OblivionStart, time.seconds(config.oblivionstart))	
	oblivionTab.count = 0
	oblivionTab.port = 0
end

EventOblivion.CleanCell = function(cellDescription)
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
						tableHelper.removeValue(cell.data.objectData, uniqueIndex)
						tableHelper.removeValue(cell.data.packets, uniqueIndex)
						if tableHelper.getCount(Players) > 0 then		
							logicHandler.DeleteObjectForEveryone(cellDescription, uniqueIndex)
						end
					end
				end
			end
			for _, uniqueIndex in pairs(cell.data.packets.place) do			
				if cell.data.objectData[uniqueIndex].refId == portailRefId then
					tableHelper.removeValue(cell.data.objectData, uniqueIndex)
					tableHelper.removeValue(cell.data.packets, uniqueIndex)
					if tableHelper.getCount(Players) > 0 then		
						logicHandler.DeleteObjectForEveryone(cellDescription, uniqueIndex)
					end					
				end
			end
			cell:QuicksaveToDrive()			
		elseif cell ~= nil then
			local creatureRefId		
			for x, crea in pairs(config.creatures) do
				creatureRefId = crea		
				for _, uniqueIndex in pairs(cell.data.packets.spawn) do
					if cell.data.objectData[uniqueIndex].refId == creatureRefId then
						tableHelper.removeValue(cell.data.objectData, uniqueIndex)
						tableHelper.removeValue(cell.data.packets, uniqueIndex)
						if tableHelper.getCount(Players) > 0 then		
							logicHandler.DeleteObjectForEveryone(cellDescription, uniqueIndex)
						end					
					end
				end
			end
			for _, uniqueIndex in pairs(cell.data.packets.place) do			
				if cell.data.objectData[uniqueIndex].refId == portailRefId then
					tableHelper.removeValue(cell.data.objectData, uniqueIndex)
					tableHelper.removeValue(cell.data.packets, uniqueIndex)
					if tableHelper.getCount(Players) > 0 then		
						logicHandler.DeleteObjectForEveryone(cellDescription, uniqueIndex)
					end		
				end
			end
			cell:QuicksaveToDrive()
		end	
		if useTemporaryLoad == true then
			logicHandler.UnloadCell(cellDescription)
		end
	end
end

customEventHooks.registerHandler("OnServerInit", EventOblivion.TimerStartEvent)
customEventHooks.registerHandler("OnActorDeath", EventOblivion.Prime)

return EventOblivion
