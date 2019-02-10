--[[
WorldMining.lua by DiscorPeter, RickOff

1)add WorldMining.lua in mpstuff/script folder

2) Add [ WorldMining = require("WorldMining") ] to the top of serverCore.lua

3) add to eventHandlers.lua OnActivate under if doesObjectHaveActivatingPlayer then :
	if isValid == true and objectRefId and tes3mp.IsInExterior(pid) then
		isValid = not WorldMining.OnHitActivate(pid, objectUniqueIndex, objectRefId, tes3mp.GetObjectRefNum(index), tes3mp.GetObjectMpNum(index))
	end 

4) add to eventHandler.lua OnObjectDelete under for index = 0, tes3mp.GetObjectListSize() - 1 do :
	if isValid == true then
		isValid = not WorldMining.OnObjectDelete(pid)
	end
	
5) copy miscellaneous recordStore 

6) add rocks.json and flora.json in mpstuff/data folder	

7) add in your main menu :
Menus["menu prison house"] = {
    text = {
		color.Red .. "WARNING !!!",
		color.White .. "\n\nYou just committed a crime against the server.",
		color.Red .. "\n\ n\nTENTATIVE OF GLITCH !!!",
		color.Yellow .. "\n\nA message to was recorded in the server logs to warn the moderation",
		color.White .. "\n\nFeel attention next time",
		color.Yellow .. "\n\nThe object to was disabled only for you during this game session",
		color.White .. "\n\nTo make it reappear you can disconnect and reconnect",
		color.Cyan .. "\n\nGood play, fairplay and role play.",
		color.Red .. "\n\n\nBy continuing you agree not to duplicate this action?"
	},
    buttons = {                        
        { caption = "yes",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("WorldMining", "PunishPrison", 
                    {
                        menuHelper.variables.currentPid(), menuHelper.variables.currentPid()
                    })					
                })
            }
        },             
        { caption = "no",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("WorldMining", "PunishKick", 
                    {
                        menuHelper.variables.currentPid(),
                    })					
                })
            }
        }		
    }
}	
]]
tableHelper = require("tableHelper")
logicHandler = require("logicHandler")
jsonInterface = require("jsonInterface")

local message = {}
message.Tools = color.White .. "Vous devez sortir un " .. color.Red .. "outil " .. color.White .. "pour commencer le travail"
message.Pick = color.White .. "Vous devez utiliser une " .. color.Red .. "pioche de mineur " .. color.White .. "pour récolter la pierre"
message.Axe = color.White .. "Vous devez utiliser une " .. color.Red .. "hache de bucheron " .. color.White .. "pour couper le bois proprement"
message.Rock = color.White .. "Vous venez de récupérer un élément de " .. color.Red .. "pierre " .. color.White .. "dans votre inventaire"
message.Flore = color.White .. "Vous venez de récupérer un élément de " .. color.Red .. "bois " .. color.White .. "dans votre inventaire"
message.WaitJail = color.White .. "Vous êtes en prison pour une durée de " .. color.Red .. "5 " .. color.White .. "minutes"
message.StopJail = color.White .. "Votre temps de " .. color.Red .. "prison " .. color.White .. "vient de se terminer"

local craftTableRock = {}
local craftTableFlora = {}
local craftTable = {}
local rocksLoader = jsonInterface.load("rocks.json")
for index, item in pairs(rocksLoader) do
	table.insert(craftTableRock, {refId = item.ID, tip = "rocks"})
	table.insert(craftTable, {refId = item.ID, tip = "rocks"})	
end

local floreLoader = jsonInterface.load("flora.json")
for index, item in pairs(floreLoader) do
	table.insert(craftTableFlora, {refId = item.ID, tip = "flora"})
	table.insert(craftTable, {refId = item.ID, tip = "flora"})	
end

local WorldMining = {}

WorldMining.OnHitActivate = function(pid, unique, refId, refNum, mpNum)
	--count to 3 for uniqueId
	local drawState = tes3mp.GetDrawState(pid)

	local itemEquipment = {}
	for x, y in pairs(Players[pid].data.equipment) do
		table.insert(itemEquipment, (Players[pid].data.equipment[x]))
	end
	if tableHelper.containsValue(craftTableRock, refId, true) then
		if drawState == 1 then	
			if tableHelper.containsValue(itemEquipment, "miner's pick", true) then			
				logicHandler.RunConsoleCommandOnPlayer(pid, "player->say, \"AM/MinerSOund1.wav\", \"\"", false)
				logicHandler.RunConsoleCommandOnPlayer(pid, "player->PlayGroup, PickProbe, 0", false)
				if Players[pid].data.customVariables.craftUnique == nil then
					Players[pid].data.customVariables.craftUnique = unique
					Players[pid].data.customVariables.craftCount = 1
					return true
				elseif Players[pid].data.customVariables.craftUnique == unique then
					if Players[pid].data.customVariables.craftCount < 3 then
						Players[pid].data.customVariables.craftCount = Players[pid].data.customVariables.craftCount + 1
						return true
					else
						-- he hit 3 times get him a rock or tree
						for index, item in pairs(craftTableRock) do
							if string.lower(item.refId) == refId then
								if item.tip == "rocks" then -- should we go over inventory at all, or store just in a table instead?
									inventoryHelper.addItem(Players[pid].data.inventory, "craftrock", 1, -1, -1, "")
									local itemref = {refId = "craftrock", count = 1, charge = -1}	
									Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)	
								end
								break -- found one match for that inventory item break loop
							end
						end
						objectUniqueIndex = (refNum .. "-" .. mpNum)
						logicHandler.RunConsoleCommandOnObject("disable", tes3mp.GetCell(pid), objectUniqueIndex)
						tes3mp.MessageBox(pid, -1, message.Rock)
						--send fancy message
					end
				else -- if he activated another one
					Players[pid].data.customVariables.craftUnique = unique
					Players[pid].data.customVariables.craftCount = 1
				end
			else
				tes3mp.MessageBox(pid, -1, message.Pick)
			end
		else
			tes3mp.MessageBox(pid, -1, message.Tools)
		end	
		return true
	elseif tableHelper.containsValue(craftTableFlora, refId, true) then
		if drawState == 1 then		
			if tableHelper.containsValue(itemEquipment, "iron battle axe", true) then			
				logicHandler.RunConsoleCommandOnPlayer(pid, "player->say, \"AM/MinerSound2.wav\", \"\"", false)
				logicHandler.RunConsoleCommandOnPlayer(pid, "player->PlayGroup, PickProbe, 0", false)
				if Players[pid].data.customVariables.craftUnique == nil then
					Players[pid].data.customVariables.craftUnique = unique
					Players[pid].data.customVariables.craftCount = 1
				elseif Players[pid].data.customVariables.craftUnique == unique then
					if Players[pid].data.customVariables.craftCount < 3 then
						Players[pid].data.customVariables.craftCount = Players[pid].data.customVariables.craftCount + 1
					else
						-- he hit 3 times get him a rock or tree
						for index, item in pairs(craftTableFlora) do
							if string.lower(item.refId) == refId then
								if item.tip == "flora" then
									inventoryHelper.addItem(Players[pid].data.inventory, "crafttree", 1, -1, -1, "")
									local itemref = {refId = "crafttree", count = 1, charge = -1}	
									Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)	
								end
								break -- found one match for that inventory item break loop
							end
						end
						objectUniqueIndex = (refNum .. "-" .. mpNum)
						logicHandler.RunConsoleCommandOnObject("disable", tes3mp.GetCell(pid), objectUniqueIndex)
						tes3mp.MessageBox(pid, -1, message.Flore)
						--send fancy message
					end
				else -- if he activated another one
					Players[pid].data.customVariables.craftUnique = unique
					Players[pid].data.customVariables.craftCount = 1
				end
			else
				tes3mp.MessageBox(pid, -1, message.Axe)
			end
		else
			tes3mp.MessageBox(pid, -1, message.Tools)
		end			
		return true
	else
		return false
	end
end

WorldMining.OnObjectDelete = function(pid)
	tes3mp.ReadLastEvent()
	local refId = tes3mp.GetObjectRefId(0)
	local cellId = tes3mp.GetCell(pid)
	local location = {
		posX = tes3mp.GetPosX(pid), posY = tes3mp.GetPosY(pid), posZ = tes3mp.GetPosZ(pid),
		rotX = tes3mp.GetRotX(pid), rotY = 0, rotZ = tes3mp.GetRotZ(pid)
	}
	if tableHelper.containsValue(craftTable, refId, true) then
		local removedCount = 1 -- you need to get the real count th player wants to remove
		local existingIndex = nil				
		for slot, item in pairs(Players[pid].data.inventory) do -- does item exist in inventory
			if Players[pid].data.inventory[slot].refId == refId then
				existingIndex = slot
			end
		end			 
		if existingIndex ~= nil then -- if he got item then change count and or remove 
			local inventoryItem = Players[pid].data.inventory[existingIndex] -- get it for working					
			local itemid = inventoryItem.refId -- save for adding into hdvinv					
			for slot, inv in pairs(Players[pid].data.equipment) do -- does player have item equipped
				if inv.refId == itemid then
					Players[pid].data.equipment[slot] = nil
				end    
			end							
			inventoryItem.count = inventoryItem.count - removedCount					
			if inventoryItem.count < 1 then
				inventoryItem = nil
			end			 
			Players[pid].data.inventory[existingIndex] = inventoryItem -- pack it back
			local itemref = {refId = refId, count = 1, charge = -1}
			Players[pid]:Save()
			Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)
			--logicHandler.CreateObjectAtLocation(cellId, location, refId, "place")			
			Players[pid].currentCustomMenu = "menu avertissement mining"--Avertissement
			menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)
			return true
		else
			return true
		end
	else
		return false
	end
end

WorldMining.PunishPrison = function(pid, targetPlayer) -- Used to send a player into the prison
	local targetPlayerName = Players[tonumber(targetPlayer)].name
	local msg = color.Orange .. "SERVER: " .. targetPlayerName .. " est en prison.\n"
	local cell = "Coeurébène, Fort Noctuelle"
	tes3mp.SetCell(pid, cell)
	tes3mp.SendCell(pid)	
	tes3mp.SetPos(pid, 756, 2560, -383)
	tes3mp.SetRot(pid, 0, 0)
	tes3mp.SendPos(pid)	
	tes3mp.SendMessage(pid, msg, true)
	if Players[pid].data.customVariables.Jailer == nil then
		Players[pid].data.customVariables.Jailer = true
	else	
		Players[pid].data.customVariables.Jailer = true
	end
	local TimerJail = tes3mp.CreateTimer("EventJail", time.seconds(300))
	tes3mp.StartTimer(TimerJail)
	tes3mp.MessageBox(pid, -1, message.WaitJail)		
	function EventJail()
		for pid, player in pairs(Players) do
			if Players[pid] ~= nil and player:IsLoggedIn() then
				if Players[pid].data.customVariables.Jailer == true then
					Players[pid].data.customVariables.Jailer = false
					tes3mp.MessageBox(pid, -1, message.StopJail)
					tes3mp.SetCell(pid, "-3, -2")  
					tes3mp.SetPos(pid, -23974, -15787, 505)
					tes3mp.SetRot(pid, 0, 0)
					tes3mp.SendCell(pid)    
					tes3mp.SendPos(pid)
				end
			end
		end
	end
end

WorldMining.PunishKick = function(pid, targetPlayer) -- Used to send a player into the kick
	Players[pid]:Kick()
end

return WorldMining
