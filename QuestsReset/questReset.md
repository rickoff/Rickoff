- add under function OnPlayerSendMessage(pid, message) in server.lua
  
  
  		elseif cmd[1] == "menuquest" then
		    Players[pid].currentCustomMenu = "commande reset quest"
		    menuHelper.displayMenu(pid, Players[pid].currentCustomMenu)	

		elseif cmd[1] == "resetlog" then
			Players[pid].data.journal = {}
			Players[pid]:Save()
			Players[pid]:LoadJournal()
			local message = "To apply its effect please disconnect."
			tes3mp.SendMessage(pid, message, false)

		elseif cmd[1] == "resetquest" and cmd[2] ~= nil then
			local list = {}
			list.mainquest = {"a1", "a2", "b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8", "c0", "c2", "c3"}	
			for slot, k in pairs(Players[pid].data.journal) do	
				for slot1, x in pairs(Players[pid].data.journal[slot]) do	
					local questlog = slot1			
					if cmd[2] == "tribunal" then							
						if questlog == "quest" then	
							local quest = (Players[pid].data.journal[slot][slot1])
							local questsub = string.sub(quest, 1, 2)
							if questsub == "tr" then
								Players[pid].data.journal[slot] = nil
								Players[pid]:Save()
								local message = "To apply its effect please disconnect."
								tes3mp.SendMessage(pid, message, false)					
							end
						end
					elseif cmd[2] == "nerevarine" then							
						if questlog == "quest" then	
							local quest = (Players[pid].data.journal[slot][slot1])
							local questsub = string.sub(quest, 1, 2)
							if tableHelper.containsValue(list.mainquest, questsub) then
								Players[pid].data.journal[slot] = nil
								Players[pid]:Save()
								local message = "To apply its effect please disconnect."
								tes3mp.SendMessage(pid, message, false)					
							end
						end
					elseif cmd[2] == "blades" then							
						if questlog == "quest" then	
							local quest = (Players[pid].data.journal[slot][slot1])
							local questsub = string.sub(quest, 1, 3)
							if questsub == "bla" then
								Players[pid].data.journal[slot] = nil
								Players[pid]:Save()
								local message = "To apply its effect please disconnect."
								tes3mp.SendMessage(pid, message, false)					
							end
						end	
					elseif cmd[2] == "daedras" then							
						if questlog == "quest" then	
							local quest = (Players[pid].data.journal[slot][slot1])
							local questsub = string.sub(quest, 1, 2)
							if questsub == "da" then
								Players[pid].data.journal[slot] = nil
								Players[pid]:Save()
								local message = "To apply its effect please disconnect."
								tes3mp.SendMessage(pid, message, false)					
							end
						end	
					elseif cmd[2] == "vivec" then							
						if questlog == "quest" then	
							local quest = (Players[pid].data.journal[slot][slot1])
							local questsub = string.sub(quest, 1, 2)
							if questsub == "eb" then
								Players[pid].data.journal[slot] = nil
								Players[pid]:Save()
								local message = "To apply its effect please disconnect."
								tes3mp.SendMessage(pid, message, false)					
							end
						end	
					elseif cmd[2] == "fight" then							
						if questlog == "quest" then	
							local quest = (Players[pid].data.journal[slot][slot1])
							local questsub = string.sub(quest, 1, 2)
							if questsub == "fg" then
								Players[pid].data.journal[slot] = nil
								Players[pid]:Save()
								local message = "To apply its effect please disconnect."
								tes3mp.SendMessage(pid, message, false)					
							end
						end	
					elseif cmd[2] == "hlaalu" then							
						if questlog == "quest" then	
							local quest = (Players[pid].data.journal[slot][slot1])
							local questsub = string.sub(quest, 1, 2)
							if questsub == "hh" then
								Players[pid].data.journal[slot] = nil
								Players[pid]:Save()
								local message = "To apply its effect please disconnect."
								tes3mp.SendMessage(pid, message, false)					
							end
						end	
					elseif cmd[2] == "redoran" then							
						if questlog == "quest" then	
							local quest = (Players[pid].data.journal[slot][slot1])
							local questsub = string.sub(quest, 1, 2)
							if questsub == "hr" then
								Players[pid].data.journal[slot] = nil
								Players[pid]:Save()
								local message = "To apply its effect please disconnect."
								tes3mp.SendMessage(pid, message, false)					
							end
						end	
					elseif cmd[2] == "telvanni" then							
						if questlog == "quest" then	
							local quest = (Players[pid].data.journal[slot][slot1])
							local questsub = string.sub(quest, 1, 2)
							if questsub == "ht" then
								Players[pid].data.journal[slot] = nil
								Players[pid]:Save()
								local message = "To apply its effect please disconnect."
								tes3mp.SendMessage(pid, message, false)					
							end
						end	
					elseif cmd[2] == "cult" then							
						if questlog == "quest" then	
							local quest = (Players[pid].data.journal[slot][slot1])
							local questsub = string.sub(quest, 1, 2)
							if questsub == "ic" then
								Players[pid].data.journal[slot] = nil
								Players[pid]:Save()
								local message = "To apply its effect please disconnect."
								tes3mp.SendMessage(pid, message, false)					
							end
						end
					elseif cmd[2] == "legion" then							
						if questlog == "quest" then	
							local quest = (Players[pid].data.journal[slot][slot1])
							local questsub = string.sub(quest, 1, 2)
							if questsub == "il" then
								Players[pid].data.journal[slot] = nil
								Players[pid]:Save()
								local message = "To apply its effect please disconnect."
								tes3mp.SendMessage(pid, message, false)					
							end
						end
					elseif cmd[2] == "mage" then							
						if questlog == "quest" then	
							local quest = (Players[pid].data.journal[slot][slot1])
							local questsub = string.sub(quest, 1, 2)
							if questsub == "mg" then
								Players[pid].data.journal[slot] = nil
								Players[pid]:Save()
								local message = "To apply its effect please disconnect."
								tes3mp.SendMessage(pid, message, false)					
							end
						end		
					elseif cmd[2] == "morag" then							
						if questlog == "quest" then	
							local quest = (Players[pid].data.journal[slot][slot1])
							local questsub = string.sub(quest, 1, 2)
							if questsub == "mt" then
								Players[pid].data.journal[slot] = nil
								Players[pid]:Save()
								local message = "To apply its effect please disconnect."
								tes3mp.SendMessage(pid, message, false)					
							end
						end	
					elseif cmd[2] == "thieves" then							
						if questlog == "quest" then	
							local quest = (Players[pid].data.journal[slot][slot1])
							local questsub = string.sub(quest, 1, 2)
							if questsub == "tg" then
								Players[pid].data.journal[slot] = nil
								Players[pid]:Save()
								local message = "To apply its effect please disconnect."
								tes3mp.SendMessage(pid, message, false)					
							end
						end	
					elseif cmd[2] == "temple" then							
						if questlog == "quest" then	
							local quest = (Players[pid].data.journal[slot][slot1])
							local questsub = string.sub(quest, 1, 2)
							if questsub == "tt" then
								Players[pid].data.journal[slot] = nil
								Players[pid]:Save()
								local message = "To apply its effect please disconnect."
								tes3mp.SendMessage(pid, message, false)					
							end
						end	
					elseif cmd[2] == "vamp" then							
						if questlog == "quest" then	
							local quest = (Players[pid].data.journal[slot][slot1])
							local questsub = string.sub(quest, 1, 2)
							if questsub == "va" then
								Players[pid].data.journal[slot] = nil
								Players[pid]:Save()
								local message = "To apply its effect please disconnect."
								tes3mp.SendMessage(pid, message, false)					
							end
						end		
					elseif cmd[2] == "bloodmoon" then							
						if questlog == "quest" then	
							local quest = (Players[pid].data.journal[slot][slot1])
							local questsub = string.sub(quest, 1, 2)
							if questsub == "bm" then
								Players[pid].data.journal[slot] = nil
								Players[pid]:Save()
								local message = "To apply its effect please disconnect."
								tes3mp.SendMessage(pid, message, false)					
							end
						end	
					elseif cmd[2] == "oriental" then							
						if questlog == "quest" then	
							local quest = (Players[pid].data.journal[slot][slot1])
							local questsub = string.sub(quest, 1, 2)
							if questsub == "co" then
								Players[pid].data.journal[slot] = nil
								Players[pid]:Save()
								local message = "To apply its effect please disconnect."
								tes3mp.SendMessage(pid, message, false)					
							end
						end								
					end
				end
			end
