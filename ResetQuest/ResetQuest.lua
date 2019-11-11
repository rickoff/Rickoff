--[[
ResetQuest by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Gestionnaire de journal de quete et de guildes
---------------------------
INSTALLATION:
Save the file as ResetQuest.lua inside your server/scripts/custom folder.

Save the file as MenuReset.lua inside your server/scripts/menu folder

Edits to customScripts.lua
ResetQuest = require("custom.ResetQuest")

Edits to config.lua
add in config.menuHelperFiles, "MenuReset"
---------------------------
FUNCTION:
/menureset in your chat for open menu
---------------------------
]]

local ResetQuest = {}

ResetQuest.MainMenu = function(pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		Players[pid].currentCustomMenu = "menu reset"
		menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
	end
end

ResetQuest.Quest = function(pid, cmd)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local list = {}
		list.mainquest = {"a1", "a2", "b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8", "c0", "c2", "c3"}
		local message = "Pour appliquer son effet veuillez vous deconnecter.\n"
		tes3mp.SendMessage(pid, message, false)				
		for slot, k in pairs(Players[pid].data.journal) do	
			for slot1, x in pairs(Players[pid].data.journal[slot]) do	
				local questlog = slot1
				if questlog == "quest" then						
					if cmd[2] == "tribunal" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub == "tr" and quest ~= "tr_dbattack" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()				
						end
					elseif cmd[2] == "nerevarine" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if tableHelper.containsValue(list.mainquest, questsub) then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()				
						end
					elseif cmd[2] == "blades" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 3)
						if questsub == "bla" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()				
						end
					elseif cmd[2] == "daedras" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub == "da" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()				
						end
					elseif cmd[2] == "vivec" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub == "eb" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()				
						end
					elseif cmd[2] == "fight" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub == "fg" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()				
						end
					elseif cmd[2] == "hlaalu" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub == "hh" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()				
						end
					elseif cmd[2] == "redoran" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub == "hr" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()				
						end
					elseif cmd[2] == "telvanni" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub == "ht" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()				
						end
					elseif cmd[2] == "cult" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub == "ic" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()
						end
					elseif cmd[2] == "legion" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub == "il" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()
						end
					elseif cmd[2] == "mage" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub == "mg" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()				
						end
					elseif cmd[2] == "annex" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub == "ms" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()				
						end
					elseif cmd[2] == "morag" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub == "mt" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()				
						end
					elseif cmd[2] == "thieves" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub == "tg" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()
						end
					elseif cmd[2] == "temple" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub == "tt" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()			
						end
					elseif cmd[2] == "vamp" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub == "va" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()				
						end
					elseif cmd[2] == "vampcure" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						if quest == "ms_vampirecure" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()				
						end						
					elseif cmd[2] == "bloodfang" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub == "a_" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()
						end
					elseif cmd[2] == "loken" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub == "aa" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()
						end
					elseif cmd[2] == "bloodmoon" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub == "bm" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()
						end
					elseif cmd[2] == "oriental" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub == "co" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()				
						end
					elseif cmd[2] == "sixth" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub == "sh" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()				
						end
					elseif cmd[2] == "dragon" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 3)
						if questsub == "raz" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()				
						end							
					elseif cmd[2] == "all" then							
						local quest = (Players[pid].data.journal[slot][slot1])
						local questsub = string.sub(quest, 1, 2)
						if questsub ~= nil and quest ~= "tr_dbattack" then
							Players[pid].data.journal[slot] = nil
							Players[pid]:Save()
						end						
					elseif cmd[2] == nil then	
						local message = "Pour appliquer son effet veuillez choisir une quete.\n"
						tes3mp.SendMessage(pid, message, false)		
					end
				end
			end
		end	
	end
end

ResetQuest.Reputation = function(pid, cmd)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local message = "Votre reputation au sein de la guilde à été reset !\n"
		tes3mp.SendMessage(pid, message, false)		
		for slot, k in pairs(Players[pid].data.factionReputation) do
			local guild = slot		
			if cmd[2] == "blades" then	
				if guild == "blades" then						
					Players[pid].data.factionReputation[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionReputation()	
				end
			elseif cmd[2] == "fight" then
				if guild == "fighters guild" then						
					Players[pid].data.factionReputation[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionReputation()	
				end						
			elseif cmd[2] == "blood" then
				if guild == "bloodfang tong" then						
					Players[pid].data.factionReputation[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionReputation()	
				end						
			elseif cmd[2] == "oriental" then
				if guild == "east empire company" then						
					Players[pid].data.factionReputation[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionReputation()	
				end						
			elseif cmd[2] == "hlaalu" then
				if guild == "hlaalu" then						
					Players[pid].data.factionReputation[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionReputation()	
				end
			elseif cmd[2] == "redoran" then
				if guild == "redoran" then						
					Players[pid].data.factionReputation[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionReputation()	
				end	
			elseif cmd[2] == "telvanni" then
				if guild == "telvanni" then						
					Players[pid].data.factionReputation[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionReputation()	
				end
			elseif cmd[2] == "temple" then
				if guild == "temple" then						
					Players[pid].data.factionReputation[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionReputation()	
				end
			elseif cmd[2] == "thieves" then
				if guild == "thieves guild" then						
					Players[pid].data.factionReputation[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionReputation()	
				end
			elseif cmd[2] == "sixth" then
				if guild == "sixth house" then						
					Players[pid].data.factionReputation[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionReputation()	
				end
			elseif cmd[2] == "cult" then
				if guild == "imperial cult" then						
					Players[pid].data.factionReputation[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionReputation()	
				end
			elseif cmd[2] == "legion" then
				if guild == "imperial legion" then						
					Players[pid].data.factionReputation[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionReputation()	
				end
			elseif cmd[2] == "mages" then
				if guild == "mages guild" then						
					Players[pid].data.factionReputation[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionReputation()	
				end
			elseif cmd[2] == "morag" then
				if guild == "morag tong" then						
					Players[pid].data.factionReputation[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionReputation()	
				end
			elseif cmd[2] == "ashlanders" then
				if guild == "ashlanders" then						
					Players[pid].data.factionReputation[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionReputation()	
				end
			else
				local message = "Cette guilde n'existe pas!\n"
				tes3mp.SendMessage(pid, message, false)								
			end	
		end
	end
end

ResetQuest.Integration = function(pid, cmd)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local player = Players[pid]
		local goldL = inventoryHelper.getItemIndex(player.data.inventory, "gold_001", -1)
		if goldL then
			local item = player.data.inventory[goldL]
			local refId = item.refId
			local count = item.count
			local reste = (item.count - 1000)
			if count >= 1000 then
				local itemref = {refId = "gold_001", count = 1000, charge = -1}			
				player.data.inventory[goldL].count = player.data.inventory[goldL].count - 1000
				Players[pid]:Save()
				Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)
				
				for slot, k in pairs(Players[pid].data.factionExpulsion) do
					local guild = slot
					tes3mp.LogMessage(1, slot)
					if cmd[2] == "blades" then
						if guild == "blades" then						
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						elseif guild ~= "blades" then
							local slot = "blades"
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						end
					elseif cmd[2] == "fight" then
						if guild == "fighters guild" then						
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						elseif guild ~= "fighters guild" then
							local slot = "fighters guild"
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						end					
					elseif cmd[2] == "blood" then
						if guild == "bloodfang tong" then						
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						elseif guild ~= "bloodfang tong" then
							local slot = "bloodfang tong"
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						end						
					elseif cmd[2] == "oriental" then
						if guild == "east empire company" then						
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						elseif guild ~= "east empire company" then
							local slot = "east empire company"
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						end						
					elseif cmd[2] == "hlaalu" then
						if guild == "hlaalu" then						
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						elseif guild ~= "hlaalu" then
							local slot = "hlaalu"
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						end	
					elseif cmd[2] == "redoran" then
						if guild == "redoran" then						
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						elseif guild ~= "redoran" then
							local slot = "redoran"
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						end	
					elseif cmd[2] == "telvanni" then
						if guild == "telvanni" then						
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						elseif guild ~= "telvanni" then
							local slot = "telvanni"
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						end	
					elseif cmd[2] == "temple" then
						if guild == "temple" then						
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						elseif guild ~= "temple" then
							local slot = "temple"
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						end	
					elseif cmd[2] == "thieves" then
						if guild == "thieves guild" then						
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						elseif guild ~= "thieves guild" then
							local slot = "thieves guild"
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						end	
					elseif cmd[2] == "sixth" then
						if guild == "sixth house" then						
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						elseif guild ~= "sixth house" then
							local slot = "sixth house"
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						end
					elseif cmd[2] == "cult" then
						if guild == "imperial cult" then						
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						elseif guild ~= "imperial cult" then
							local slot = "imperial cult"
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						end	
					elseif cmd[2] == "legion" then
						if guild == "imperial legion" then						
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						elseif guild ~= "imperial legion" then
							local slot = "imperial legion"
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						end	
					elseif cmd[2] == "mages" then
						if guild == "mages guild" then						
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						elseif guild ~= "mages guild" then
							local slot = "mages guild"
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						end	
					elseif cmd[2] == "morag" then
						if guild == "morag tong" then						
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						elseif guild ~= "morag tong" then
							local slot = "morag tong"
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						end	
					elseif cmd[2] == "ashlanders" then
						if guild == "ashlanders" then						
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						elseif guild ~= "ashlanders" then
							local slot = "ashlanders"
							Players[pid].data.factionExpulsion[slot] = false
							Players[pid]:Save()
							Players[pid]:LoadFactionExpulsion()	
						end	
					else
						local message = "Cette guilde n'existe pas!\n"
						tes3mp.SendMessage(pid, message, false)								
					end					
				end
				local message = "Votre expulsion au sein de la guilde à été reset !\n"
				tes3mp.SendMessage(pid, message, false)							
			else
				local message = "Il vous faut 1000 pièces pour vous racheter!\n"
				tes3mp.SendMessage(pid, message, false)							
			end
		else
			local message = "Il vous faut de l'or pour vous racheter!\n"
			tes3mp.SendMessage(pid, message, false)							
		end	
	end
end

ResetQuest.Exclusion = function(pid, cmd)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local message = "Votre expulsion au sein de la guilde à été validé !\n"
		tes3mp.SendMessage(pid, message, false)			
		for slot, k in pairs(Players[pid].data.factionExpulsion) do
			local guild = slot
			tes3mp.LogMessage(1, slot)
			if cmd[2] == "blades" then
				if guild == "blades" then						
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				elseif guild ~= "blades" then
					local slot = "blades"
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				end
			elseif cmd[2] == "fight" then
				if guild == "fighters guild" then						
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				elseif guild ~= "fighters guild" then
					local slot = "fighters guild"
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				end					
			elseif cmd[2] == "blood" then
				if guild == "bloodfang tong" then						
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				elseif guild ~= "bloodfang tong" then
					local slot = "bloodfang tong"
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				end						
			elseif cmd[2] == "oriental" then
				if guild == "east empire company" then						
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				elseif guild ~= "east empire company" then
					local slot = "east empire company"
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				end						
			elseif cmd[2] == "hlaalu" then
				if guild == "hlaalu" then						
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				elseif guild ~= "hlaalu" then
					local slot = "hlaalu"
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				end	
			elseif cmd[2] == "redoran" then
				if guild == "redoran" then						
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				elseif guild ~= "redoran" then
					local slot = "redoran"
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				end	
			elseif cmd[2] == "telvanni" then
				if guild == "telvanni" then						
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				elseif guild ~= "telvanni" then
					local slot = "telvanni"
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				end	
			elseif cmd[2] == "temple" then
				if guild == "temple" then						
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				elseif guild ~= "temple" then
					local slot = "temple"
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				end	
			elseif cmd[2] == "thieves" then
				if guild == "thieves guild" then						
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				elseif guild ~= "thieves guild" then
					local slot = "thieves guild"
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				end	
			elseif cmd[2] == "sixth" then
				if guild == "sixth house" then						
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				elseif guild ~= "sixth house" then
					local slot = "sixth house"
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				end
			elseif cmd[2] == "cult" then
				if guild == "imperial cult" then						
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				elseif guild ~= "imperial cult" then
					local slot = "imperial cult"
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				end	
			elseif cmd[2] == "legion" then
				if guild == "imperial legion" then						
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				elseif guild ~= "imperial legion" then
					local slot = "imperial legion"
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				end	
			elseif cmd[2] == "mages" then
				if guild == "mages guild" then						
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				elseif guild ~= "mages guild" then
					local slot = "mages guild"
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				end	
			elseif cmd[2] == "morag" then
				if guild == "morag tong" then						
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				elseif guild ~= "morag tong" then
					local slot = "morag tong"
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				end	
			elseif cmd[2] == "ashlanders" then
				if guild == "ashlanders" then						
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				elseif guild ~= "ashlanders" then
					local slot = "ashlanders"
					Players[pid].data.factionExpulsion[slot] = true
					Players[pid]:Save()
					Players[pid]:LoadFactionExpulsion()	
				end	
			else
				local message = "Cette guilde n'existe pas!\n"
				tes3mp.SendMessage(pid, message, false)								
			end					
		end	
	end
end

ResetQuest.Ranks = function(pid, cmd)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local message = "Votre rang au sein de la guilde à été reset !\n"
		tes3mp.SendMessage(pid, message, false)				
		for slot, k in pairs(Players[pid].data.factionRanks) do
			local guild = slot		
			if cmd[2] == "blades" then
				if guild == "blades" then						
					Players[pid].data.factionRanks[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionRanks()	
				end
			elseif cmd[2] == "fight" then
				if guild == "fighters guild" then						
					Players[pid].data.factionRanks[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionRanks()	
				end						
			elseif cmd[2] == "blood" then
				if guild == "bloodfang tong" then						
					Players[pid].data.factionRanks[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionRanks()	
				end						
			elseif cmd[2] == "oriental" then
				if guild == "east empire company" then						
					Players[pid].data.factionRanks[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionRanks()	
				end						
			elseif cmd[2] == "hlaalu" then
				if guild == "hlaalu" then						
					Players[pid].data.factionRanks[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionRanks()	
				end
			elseif cmd[2] == "redoran" then	
				if guild == "redoran" then						
					Players[pid].data.factionRanks[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionRanks()	
				end
			elseif cmd[2] == "telvanni" then
				if guild == "telvanni" then						
					Players[pid].data.factionRanks[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionRanks()	
				end
			elseif cmd[2] == "temple" then
				if guild == "temple" then						
					Players[pid].data.factionRanks[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionRanks()	
				end
			elseif cmd[2] == "thieves" then
				if guild == "thieves guild" then						
					Players[pid].data.factionRanks[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionRanks()	
				end
			elseif cmd[2] == "sixth" then
				if guild == "sixth house" then						
					Players[pid].data.factionRanks[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionRanks()	
				end
			elseif cmd[2] == "cult" then
				if guild == "imperial cult" then						
					Players[pid].data.factionRanks[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionRanks()	
				end
			elseif cmd[2] == "legion" then
				if guild == "imperial legion" then						
					Players[pid].data.factionRanks[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionRanks()	
				end
			elseif cmd[2] == "mages" then
				if guild == "mages guild" then						
					Players[pid].data.factionRanks[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionRanks()	
				end
			elseif cmd[2] == "morag" then
				if guild == "morag tong" then						
					Players[pid].data.factionRanks[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionRanks()	
				end
			elseif cmd[2] == "ashlanders" then
				if guild == "ashlanders" then						
					Players[pid].data.factionRanks[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionRanks()	
				end					
			elseif cmd[2] == "all" then
				if guild ~= nil then						
					Players[pid].data.factionRanks[slot] = 0
					Players[pid]:Save()
					Players[pid]:LoadFactionRanks()	
				end					
			else
				local message = "Cette guilde n'existe pas!\n"
				tes3mp.SendMessage(pid, message, false)	
			end
		end
	end
end

customCommandHooks.registerCommand("menureset", ResetQuest.MainMenu)	
customCommandHooks.registerCommand("resetquest", ResetQuest.Quest)
customCommandHooks.registerCommand("resetreputation", ResetQuest.Reputation)
customCommandHooks.registerCommand("resetintegration", ResetQuest.Integration)
customCommandHooks.registerCommand("resetexclusion", ResetQuest.Exclusion)
customCommandHooks.registerCommand("resetranks", ResetQuest.Ranks)

return ResetQuest
