---------------------------
-- HunterWorld by Rickoff

   -- add 100 random spawn point for creature or npc
   -- when a boss creature appears the players receive a message
   -- when a player kills a boss he receives a reward and a message displays that a rare creature was killed

--
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
config.timerRandom = 1
config.count = 5000

--Boss
config.creature1 = "raz_reddragon"
config.creature2 = "raz_bluedragon"
config.creature3 = "raz_adult_blackdragon"
config.creature4 = "raz_adult_greendragon" 
config.creature5 = "Imperfect_ecarlate" 
config.creature6 = "worm lord"


HunterWorld = {}

HunterWorld.TimerEventWorld = function() 

	local TimerEvent = tes3mp.CreateTimer("EventSpawn", time.seconds(config.timerSpawn))
	local TimerRandom = tes3mp.CreateTimer("EventRandom", time.seconds(config.timerRandom))
	tes3mp.StartTimer(TimerEvent)
	tes3mp.StartTimer(TimerRandom)
	local packetType = "spawn"	
	local count
	local rando1
	local rando2
	
	function EventRandom()
		rando1 = math.random(1, 100)
		rando2 = math.random(1, 100)
		tes3mp.RestartTimer(TimerRandom, time.seconds(config.timerRandom))
	end
		
	function EventSpawn()	
		local cellTable = jsonInterface.load("EcarlateCreaturesSpawn.json")	
		local creatureTable = jsonInterface.load("EcarlateCreatures.json")
		local creaturerefId
		local creaturename
		local cellId
		local posx
		local posy
		local posz
		
		for slot1, creature in pairs(creatureTable.creatures) do
			
			if slot1 == rando1 then
				creaturerefId = creature.Refid
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
			
		if creaturerefId ~= nil and cellId ~= nil and posx ~= nil and posy ~= nil and posz ~= nil then
		
			local message = color.Red.. "Warning " ..color.Yellow..creaturename..color.Default.. " just made an appearance in the area " ..color.Yellow..cellId.. "\n"
			
			if tableHelper.getCount(Players) > 0 then
				if creaturerefId == config.creature1 then
					tes3mp.SendMessage(tableHelper.getAnyValue(Players).pid, message, true)
				elseif creaturerefId == config.creature2 then
					tes3mp.SendMessage(tableHelper.getAnyValue(Players).pid, message, true)				
				elseif creaturerefId == config.creature3 then
					tes3mp.SendMessage(tableHelper.getAnyValue(Players).pid, message, true)				
				elseif creaturerefId == config.creature4 then
					tes3mp.SendMessage(tableHelper.getAnyValue(Players).pid, message, true)				
				elseif creaturerefId == config.creature5 then
					tes3mp.SendMessage(tableHelper.getAnyValue(Players).pid, message, true)				
				elseif creaturerefId == config.creature6 then
					tes3mp.SendMessage(tableHelper.getAnyValue(Players).pid, message, true)			
				end
			end
			
			local position = { posX = tonumber(posx), posY = tonumber(posy), posZ = tonumber(posz), rotX = 0, rotY = 0, rotZ = 0 }
			tes3mp.LogMessage(2, "Spawn")
			tes3mp.LogMessage(2, creaturerefId)
			tes3mp.LogMessage(2, cellId)			
			myMod.CreateCreatureAtLocation(cellId, position, creaturerefId, packetType)
			tes3mp.RestartTimer(TimerEvent, time.seconds(config.timerSpawn))
		else
			tes3mp.LogMessage(2, "Restart")		
			tes3mp.RestartTimer(TimerEvent, time.seconds(config.timerSpawn))
		end					
	end	
end 


HunterWorld.HunterPrime = function(pid)

	local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)	
	local addgold = 0
	local message = color.Red.. "A rare creature has just been killed !\n"
	local refId
	
    for i = 0, tes3mp.GetKillChangesSize(pid) - 1 do
        refId = tes3mp.GetKillRefId(pid, i)
	end	
	
	if refId == config.creature1 then
	
		if goldLoc == nil then
			tes3mp.MessageBox(pid, -1, "You have just recovered the hunting bonus ! ")
			table.insert(Players[pid].data.inventory, {refId = "gold_001", count = config.count, charge = -1})
			tes3mp.SendMessage(pid, message, true)
			Players[pid]:Save()
			Players[pid]:LoadInventory()
			Players[pid]:LoadEquipment()				
		elseif goldLoc then			
			Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count + config.count
			tes3mp.MessageBox(pid, -1, "You have just recovered the hunting bonus !")
			tes3mp.SendMessage(pid, message, true)
			Players[pid]:Save()
			Players[pid]:LoadInventory()
			Players[pid]:LoadEquipment()				
		end
		
	elseif refId == config.creature2 then
	
		if goldLoc == nil then
			tes3mp.MessageBox(pid, -1, "You have just recovered the hunting bonus !")
			table.insert(Players[pid].data.inventory, {refId = "gold_001", count = config.count, charge = -1})
			tes3mp.SendMessage(pid, message, true)	
			Players[pid]:Save()
			Players[pid]:LoadInventory()
			Players[pid]:LoadEquipment()				
		elseif goldLoc then			
			Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count + config.count
			tes3mp.MessageBox(pid, -1, "You have just recovered the hunting bonus !")
			tes3mp.SendMessage(pid, message, true)
			Players[pid]:Save()
			Players[pid]:LoadInventory()
			Players[pid]:LoadEquipment()				
		end	
		
	elseif refId == config.creature3 then
	
		if goldLoc == nil then
			tes3mp.MessageBox(pid, -1, "You have just recovered the hunting bonus !")
			table.insert(Players[pid].data.inventory, {refId = "gold_001", count = config.count, charge = -1})		
			tes3mp.SendMessage(pid, message, true)	
			Players[pid]:Save()
			Players[pid]:LoadInventory()
			Players[pid]:LoadEquipment()				
		elseif goldLoc then			
			Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count + config.count
			tes3mp.MessageBox(pid, -1, "You have just recovered the hunting bonus !")
			tes3mp.SendMessage(pid, message, true)	
			Players[pid]:Save()
			Players[pid]:LoadInventory()
			Players[pid]:LoadEquipment()
		end	
		
	elseif refId == config.creature4 then
	
		if goldLoc == nil then
			tes3mp.MessageBox(pid, -1, "You have just recovered the hunting bonus !")
			table.insert(Players[pid].data.inventory, {refId = "gold_001", count = config.count, charge = -1})	
			tes3mp.SendMessage(pid, message, true)	
			Players[pid]:Save()
			Players[pid]:LoadInventory()
			Players[pid]:LoadEquipment()				
		elseif goldLoc then			
			Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count + config.count
			tes3mp.MessageBox(pid, -1, "You have just recovered the hunting bonus !")	
			tes3mp.SendMessage(pid, message, true)
			Players[pid]:Save()
			Players[pid]:LoadInventory()
			Players[pid]:LoadEquipment()
		end	
		
	elseif refId == config.creature5 then
	
		if goldLoc == nil then
			tes3mp.MessageBox(pid, -1, "You have just recovered the hunting bonus !")
			table.insert(Players[pid].data.inventory, {refId = "gold_001", count = config.count, charge = -1})
			tes3mp.SendMessage(pid, message, true)
			Players[pid]:Save()
			Players[pid]:LoadInventory()
			Players[pid]:LoadEquipment()				
		elseif goldLoc then			
			Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count + config.count
			tes3mp.MessageBox(pid, -1, "You have just recovered the hunting bonus !")
			tes3mp.SendMessage(pid, message, true)
			Players[pid]:Save()
			Players[pid]:LoadInventory()
			Players[pid]:LoadEquipment()				
		end	
		
	elseif refId == config.creature6 then

		if goldLoc == nil then
			tes3mp.MessageBox(pid, -1, "You have just recovered the hunting bonus !")
			table.insert(Players[pid].data.inventory, {refId = "gold_001", count = config.count, charge = -1})
			tes3mp.SendMessage(pid, message, true)	
			Players[pid]:Save()
			Players[pid]:LoadInventory()
			Players[pid]:LoadEquipment()				
		elseif goldLoc then			
			Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count + config.count
			tes3mp.MessageBox(pid, -1, "You have just recovered the hunting bonus !")
			tes3mp.SendMessage(pid, message, true)	
			Players[pid]:Save()
			Players[pid]:LoadInventory()
			Players[pid]:LoadEquipment()				
		end				
	end
end
	
return HunterWorld
