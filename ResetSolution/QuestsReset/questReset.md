- add under function OnPlayerSendMessage(pid, message) in commandHandler.lua
  
  
  		elseif cmd[1] == "menuquest" then
		    Players[pid].currentCustomMenu = "commande reset quest"
		    menuHelper.displayMenu(pid, Players[pid].currentCustomMenu)	

		elseif cmd[1] == "resetquest" and cmd[2] ~= nil then
			local list = {}
			list.mainquest = {"a1", "a2", "b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8", "c0", "c2", "c3"}
			local message = "To apply its effect please disconnect."
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
						elseif cmd[2] == "all" then							
							local quest = (Players[pid].data.journal[slot][slot1])
							local questsub = string.sub(quest, 1, 2)
							if questsub ~= nil and quest ~= "tr_dbattack" then
								Players[pid].data.journal[slot] = nil
								Players[pid]:Save()
							end						
						end
					end
				end
			end	
