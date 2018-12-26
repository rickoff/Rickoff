---------------------------
-- HunterWorld by Rickoff
-- Tes3mp 0.7.0
-- add 100 random spawn point for creature or npc
-- when a boss creature appears the players receive a message
-- when a player kills the boss he receives a reward and the message displays that a rare creature was killed
---------------------------
tableHelper = require("tableHelper")
inventoryHelper = require("inventoryHelper")
jsonInterface = require("jsonInterface")
-- ===========
--MAIN CONFIG
-- ===========
-------------------------
local config = {}

config.timerSpawn = 120
config.timerPrice = 3600
config.count = 5000
config.bosses = {"", "", "", "", "", "", "", "", "", ""} --place id boss

HunterWorld = {}

HunterWorld.TimerEventWorld = function()
	local TimerEvent = tes3mp.CreateTimer("EventSpawn", time.seconds(config.timerSpawn))
	local TimerPrice = tes3mp.CreateTimer("EventPrice", time.seconds(config.timerPrice))
	tes3mp.StartTimer(TimerEvent)
	tes3mp.StartTimer(TimerPrice)
	local packetType = "spawn"
	local count
	local rando1
	local rando2
	function EventSpawn()	
		local cellTable = jsonInterface.load("EcarlateCreaturesSpawn.json")
		local creatureTable = jsonInterface.load("EcarlateCreatures.json")
		local creatureRefId
		local creaturename
		local cellId
		local posx
		local posy
		local posz
		rando1 = math.random(1, 107)
		rando2 = math.random(1, 100)		
		for slot1, creature in pairs(creatureTable.creatures) do
			if slot1 == rando1 then
				creatureRefId = creature.Refid
				creaturename = creature.name
			end
		end
		for slot2, cell in pairs(cellTable.cells) do
			if slot2 == rando2 then
				cellId = cell.Refid
				posx = cell.Posx
				posy = cell.Posy
				posz = cell.Posz
			end
		end
		if creatureRefId ~= nil and cellId ~= nil and posx ~= nil and posy ~= nil and posz ~= nil then
			local message = color.Red.. "Attention " ..color.Yellow..creaturename..color.Default.. " a fait une apparition dans la zone " ..color.Yellow..cellId.. "\n"
			if tableHelper.getCount(Players) > 0 then
				if tableHelper.containsValue(config.bosses, creatureRefId) then
					tes3mp.SendMessage(tableHelper.getAnyValue(Players).pid, message, true)
				end
			end
			local position = { posX = tonumber(posx), posY = tonumber(posy), posZ = tonumber(posz), rotX = 0, rotY = 0, rotZ = 0 }
			tes3mp.LogMessage(2, "Spawn")
			tes3mp.LogMessage(2, creatureRefId)
			tes3mp.LogMessage(2, cellId)
			logicHandler.CreateObjectAtLocation(cellId, position, creatureRefId, packetType)
		else
			tes3mp.LogMessage(2, "Restart")		
		end

		tes3mp.RestartTimer(TimerEvent, time.seconds(config.timerSpawn))
	end		
	function EventPrice()	
		for pid, player in pairs(Players) do
			if Players[pid] ~= nil and player:IsLoggedIn() then	
				local message = color.Blue.. "Votre récompense vient d'être versé dans votre inventaire pour votre temps passé en jeu, merci.\n"
				tes3mp.SendMessage(pid, message, false)	
				local player = Players[pid]
				local goldL = inventoryHelper.getItemIndex(player.data.inventory, "gold_001", -1)			
				if goldL ~= nil then
					local item = player.data.inventory[goldL]
					local refId = item.refId
					local count = item.count
					local rest = (item.count + 1000)
					player.data.inventory[goldL] = {refId = "gold_001", count = rest, charge = -1}			
				else
					table.insert(Players[pid].data.inventory, {refId = "gold_001", count = 1000, charge = -1})
				end	
				local itemref = {refId = "gold_001", count = 1000, charge = -1}			
				Players[pid]:Save()
				Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)					
			end
		end
		tes3mp.RestartTimer(TimerPrice, time.seconds(config.timerPrice))
	end
end 

HunterWorld.HunterPrime = function(pid)
	local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)
	local addgold = 0
	local message = color.Red.. "Une créature rare vient d'être tuée !\n"
	local refId
	for i = 0, tes3mp.GetKillChangesSize(pid) - 1 do
		refId = tes3mp.GetKillRefId(pid, i)
	end
	if tableHelper.containsValue(config.bosses, refId) then
		if goldLoc == nil then
			table.insert(Players[pid].data.inventory, {refId = "gold_001", count = config.count, charge = -1})			
		else
			Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count + config.count
			local countprice = Players[pid].data.inventory[goldLoc].count + config.count
		end
		tes3mp.MessageBox(pid, -1, "Tu a récupéré une prime de chasse !")
		tes3mp.SendMessage(pid, message, true)
		local itemref = {refId = "gold_001", count = config.count, charge = -1}			
		Players[pid]:Save()
		Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)						
	end
end
	
return HunterWorld
