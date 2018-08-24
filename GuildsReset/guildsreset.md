- add under function OnPlayerSendMessage(pid, message) in server.lua
  
  
		elseif cmd[1] == "resetreput" then
				Players[pid].data.factionReputation = {}
				Players[pid]:Save()
				Players[pid]:LoadFactionReputation()	

		elseif cmd[1] == "resetreputation" and cmd[2] ~= nil then					
			if cmd[2] == "blades" then
				for slot, k in pairs(Players[pid].data.factionReputation) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "blades" then						
						Players[pid].data.factionReputation[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionReputation()	
						local message = "Your reputation within the guild has been reset !"
						tes3mp.SendMessage(pid, message, false)
					end
				end
			elseif cmd[2] == "fight" then
				for slot, k in pairs(Players[pid].data.factionReputation) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "fighters guild" then						
						Players[pid].data.factionReputation[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionReputation()	
						local message = "Your reputation within the guild has been reset !"
						tes3mp.SendMessage(pid, message, false)
					end
				end														
			elseif cmd[2] == "oriental" then
				for slot, k in pairs(Players[pid].data.factionReputation) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "east empire company" then						
						Players[pid].data.factionReputation[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionReputation()	
						local message = "Your reputation within the guild has been reset !"
						tes3mp.SendMessage(pid, message, false)
					end
				end							
			elseif cmd[2] == "hlaalu" then
				for slot, k in pairs(Players[pid].data.factionReputation) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "hlaalu" then						
						Players[pid].data.factionReputation[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionReputation()	
						local message = "Your reputation within the guild has been reset !"
						tes3mp.SendMessage(pid, message, false)
					end
				end	
			elseif cmd[2] == "redoran" then
				for slot, k in pairs(Players[pid].data.factionReputation) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "redoran" then						
						Players[pid].data.factionReputation[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionReputation()	
						local message = "Your reputation within the guild has been reset !"
						tes3mp.SendMessage(pid, message, false)
					end
				end	
			elseif cmd[2] == "telvanni" then
				for slot, k in pairs(Players[pid].data.factionReputation) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "telvanni" then						
						Players[pid].data.factionReputation[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionReputation()	
						local message = "Your reputation within the guild has been reset !"
						tes3mp.SendMessage(pid, message, false)
					end
				end	
			elseif cmd[2] == "temple" then
				for slot, k in pairs(Players[pid].data.factionReputation) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "temple" then						
						Players[pid].data.factionReputation[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionReputation()	
						local message = "Your reputation within the guild has been reset !"
						tes3mp.SendMessage(pid, message, false)
					end
				end	
			elseif cmd[2] == "thieves" then
				for slot, k in pairs(Players[pid].data.factionReputation) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "thieves guild" then						
						Players[pid].data.factionReputation[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionReputation()	
						local message = "Your reputation within the guild has been reset !"
						tes3mp.SendMessage(pid, message, false)
					end
				end	
			elseif cmd[2] == "cult" then
				for slot, k in pairs(Players[pid].data.factionReputation) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "imperial cult" then						
						Players[pid].data.factionReputation[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionReputation()	
						local message = "Your reputation within the guild has been reset !"
						tes3mp.SendMessage(pid, message, false)
					end
				end	
			elseif cmd[2] == "legion" then
				for slot, k in pairs(Players[pid].data.factionReputation) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "imperial legion" then						
						Players[pid].data.factionReputation[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionReputation()	
						local message = "Your reputation within the guild has been reset !"
						tes3mp.SendMessage(pid, message, false)
					end
				end	
			elseif cmd[2] == "mages" then
				for slot, k in pairs(Players[pid].data.factionReputation) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "mages guild" then						
						Players[pid].data.factionReputation[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionReputation()	
						local message = "Your reputation within the guild has been reset !"
						tes3mp.SendMessage(pid, message, false)
					end
				end	
			elseif cmd[2] == "morag" then
				for slot, k in pairs(Players[pid].data.factionReputation) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "morag tong" then						
						Players[pid].data.factionReputation[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionReputation()	
						local message = "Your reputation within the guild has been reset !"
						tes3mp.SendMessage(pid, message, false)
					end
				end	
			else
				local message = "This guild does not exist!\n"
				tes3mp.SendMessage(pid, message, false)								
			end							
			
		elseif cmd[1] == "resetfaction" then
			Players[pid].data.factionExpulsion = {}
			Players[pid]:Save()
			Players[pid]:LoadFactionExpulsion()				

		elseif cmd[1] == "resetexpultion" and cmd[2] ~= nil then
				local player = Players[pid]
				local goldL = inventoryHelper.getItemIndex(player.data.inventory, "gold_001", -1)
				if goldL then
					local item = player.data.inventory[goldL]
					local refId = item.refId
					local count = item.count
					local reste = (item.count - 1000)
					if count >= 1000 then
						player.data.inventory[goldL] = {refId = "gold_001", count = reste, charge = -1}	
						Players[pid]:Save()
						Players[pid]:LoadInventory()
						Players[pid]:LoadEquipment()						
						if cmd[2] == "blades" then
							for slot, k in pairs(Players[pid].data.factionExpulsion) do
								local guild = slot
								tes3mp.LogMessage(2, guild)	
								if guild == "blades" then						
									Players[pid].data.factionExpulsion[slot] = false
									Players[pid]:Save()
									Players[pid]:LoadFactionExpulsion()	
									local message = "Votre expultion au sein de la guilde à été réinitialisé !"
									tes3mp.SendMessage(pid, message, false)
								end
							end
						elseif cmd[2] == "fight" then
							for slot, k in pairs(Players[pid].data.factionExpulsion) do
								local guild = slot
								tes3mp.LogMessage(2, guild)	
								if guild == "fighters guild" then						
									Players[pid].data.factionExpulsion[slot] = false
									Players[pid]:Save()
									Players[pid]:LoadFactionExpulsion()	
									local message = "Votre expultion au sein de la guilde à été réinitialisé !"
									tes3mp.SendMessage(pid, message, false)
								end
							end							
						elseif cmd[2] == "blood" then
							for slot, k in pairs(Players[pid].data.factionExpulsion) do
								local guild = slot
								tes3mp.LogMessage(2, guild)	
								if guild == "bloodfang tong" then						
									Players[pid].data.factionExpulsion[slot] = false
									Players[pid]:Save()
									Players[pid]:LoadFactionExpulsion()	
									local message = "Votre expultion au sein de la guilde à été réinitialisé !"
									tes3mp.SendMessage(pid, message, false)
								end
							end							
						elseif cmd[2] == "oriental" then
							for slot, k in pairs(Players[pid].data.factionExpulsion) do
								local guild = slot
								tes3mp.LogMessage(2, guild)	
								if guild == "east empire company" then						
									Players[pid].data.factionExpulsion[slot] = false
									Players[pid]:Save()
									Players[pid]:LoadFactionExpulsion()	
									local message = "Votre expultion au sein de la guilde à été réinitialisé !"
									tes3mp.SendMessage(pid, message, false)
								end
							end							
						elseif cmd[2] == "hlaalu" then
							for slot, k in pairs(Players[pid].data.factionExpulsion) do
								local guild = slot
								tes3mp.LogMessage(2, guild)	
								if guild == "hlaalu" then						
									Players[pid].data.factionExpulsion[slot] = false
									Players[pid]:Save()
									Players[pid]:LoadFactionExpulsion()	
									local message = "Votre expultion au sein de la guilde à été réinitialisé !"
									tes3mp.SendMessage(pid, message, false)
								end
							end	
						elseif cmd[2] == "redoran" then
							for slot, k in pairs(Players[pid].data.factionExpulsion) do
								local guild = slot
								tes3mp.LogMessage(2, guild)	
								if guild == "redoran" then						
									Players[pid].data.factionExpulsion[slot] = false
									Players[pid]:Save()
									Players[pid]:LoadFactionExpulsion()	
									local message = "Votre expultion au sein de la guilde à été réinitialisé !"
									tes3mp.SendMessage(pid, message, false)
								end
							end	
						elseif cmd[2] == "telvanni" then
							for slot, k in pairs(Players[pid].data.factionExpulsion) do
								local guild = slot
								tes3mp.LogMessage(2, guild)	
								if guild == "telvanni" then						
									Players[pid].data.factionExpulsion[slot] = false
									Players[pid]:Save()
									Players[pid]:LoadFactionExpulsion()	
									local message = "Votre expultion au sein de la guilde à été réinitialisé !"
									tes3mp.SendMessage(pid, message, false)
								end
							end	
						elseif cmd[2] == "temple" then
							for slot, k in pairs(Players[pid].data.factionExpulsion) do
								local guild = slot
								tes3mp.LogMessage(2, guild)	
								if guild == "temple" then						
									Players[pid].data.factionExpulsion[slot] = false
									Players[pid]:Save()
									Players[pid]:LoadFactionExpulsion()	
									local message = "Votre expultion au sein de la guilde à été réinitialisé !"
									tes3mp.SendMessage(pid, message, false)
								end
							end	
						elseif cmd[2] == "thieves" then
							for slot, k in pairs(Players[pid].data.factionExpulsion) do
								local guild = slot
								tes3mp.LogMessage(2, guild)	
								if guild == "thieves guild" then						
									Players[pid].data.factionExpulsion[slot] = false
									Players[pid]:Save()
									Players[pid]:LoadFactionExpulsion()	
									local message = "Votre expultion au sein de la guilde à été réinitialisé !"
									tes3mp.SendMessage(pid, message, false)
								end
							end	
						elseif cmd[2] == "sixth" then
							for slot, k in pairs(Players[pid].data.factionExpulsion) do
								local guild = slot
								tes3mp.LogMessage(2, guild)	
								if guild == "sixth house" then						
									Players[pid].data.factionExpulsion[slot] = false
									Players[pid]:Save()
									Players[pid]:LoadFactionExpulsion()	
									local message = "Votre expultion au sein de la guilde à été réinitialisé !"
									tes3mp.SendMessage(pid, message, false)
								end
							end
						elseif cmd[2] == "cult" then
							for slot, k in pairs(Players[pid].data.factionExpulsion) do
								local guild = slot
								tes3mp.LogMessage(2, guild)	
								if guild == "imperial cult" then						
									Players[pid].data.factionExpulsion[slot] = false
									Players[pid]:Save()
									Players[pid]:LoadFactionExpulsion()	
									local message = "Votre expultion au sein de la guilde à été réinitialisé !"
									tes3mp.SendMessage(pid, message, false)
								end
							end	
						elseif cmd[2] == "legion" then
							for slot, k in pairs(Players[pid].data.factionExpulsion) do
								local guild = slot
								tes3mp.LogMessage(2, guild)	
								if guild == "imperial legion" then						
									Players[pid].data.factionExpulsion[slot] = false
									Players[pid]:Save()
									Players[pid]:LoadFactionExpulsion()	
									local message = "Votre expultion au sein de la guilde à été réinitialisé !"
									tes3mp.SendMessage(pid, message, false)
								end
							end	
						elseif cmd[2] == "mages" then
							for slot, k in pairs(Players[pid].data.factionExpulsion) do
								local guild = slot
								tes3mp.LogMessage(2, guild)	
								if guild == "mages guild" then						
									Players[pid].data.factionExpulsion[slot] = false
									Players[pid]:Save()
									Players[pid]:LoadFactionExpulsion()	
									local message = "Votre expultion au sein de la guilde à été réinitialisé !"
									tes3mp.SendMessage(pid, message, false)
								end
							end	
						elseif cmd[2] == "morag" then
							for slot, k in pairs(Players[pid].data.factionExpulsion) do
								local guild = slot
								tes3mp.LogMessage(2, guild)	
								if guild == "morag tong" then						
									Players[pid].data.factionExpulsion[slot] = false
									Players[pid]:Save()
									Players[pid]:LoadFactionExpulsion()	
									local message = "Votre expultion au sein de la guilde à été réinitialisé !"
									tes3mp.SendMessage(pid, message, false)
								end
							end	
						else
							local message = "Cette guilde n'existe pas!\n"
							tes3mp.SendMessage(pid, message, false)								
						end							
					else
						local message = "Il vous faut 1000 pièces pour vous racheter!\n"
						tes3mp.SendMessage(pid, message, false)							
					end
				end
			
		elseif cmd[1] == "resetrang" then
			Players[pid].data.factionRanks = {}
			Players[pid]:Save()
			Players[pid]:LoadFactionRanks()	

		elseif cmd[1] == "resetranks" and cmd[2] ~= nil then					
			if cmd[2] == "blades" then
				for slot, k in pairs(Players[pid].data.factionRanks) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "blades" then						
						Players[pid].data.factionRanks[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionRanks()	
						local message = "Votre rang au sein de la guilde à été réinitialisé !"
						tes3mp.SendMessage(pid, message, false)
					end
				end
			elseif cmd[2] == "fight" then
				for slot, k in pairs(Players[pid].data.factionRanks) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "fighters guild" then						
						Players[pid].data.factionRanks[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionRanks()	
						local message = "Votre rang au sein de la guilde à été réinitialisé !"
						tes3mp.SendMessage(pid, message, false)
					end
				end							
			elseif cmd[2] == "blood" then
				for slot, k in pairs(Players[pid].data.factionRanks) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "bloodfang tong" then						
						Players[pid].data.factionRanks[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionRanks()	
						local message = "Votre rang au sein de la guilde à été réinitialisé !"
						tes3mp.SendMessage(pid, message, false)
					end
				end							
			elseif cmd[2] == "oriental" then
				for slot, k in pairs(Players[pid].data.factionRanks) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "east empire company" then						
						Players[pid].data.factionRanks[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionRanks()	
						local message = "Votre rang au sein de la guilde à été réinitialisé !"
						tes3mp.SendMessage(pid, message, false)
					end
				end							
			elseif cmd[2] == "hlaalu" then
				for slot, k in pairs(Players[pid].data.factionRanks) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "hlaalu" then						
						Players[pid].data.factionRanks[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionRanks()	
						local message = "Votre rang au sein de la guilde à été réinitialisé !"
						tes3mp.SendMessage(pid, message, false)
					end
				end	
			elseif cmd[2] == "redoran" then
				for slot, k in pairs(Players[pid].data.factionRanks) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "redoran" then						
						Players[pid].data.factionRanks[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionRanks()	
						local message = "Votre rang au sein de la guilde à été réinitialisé !"
						tes3mp.SendMessage(pid, message, false)
					end
				end	
			elseif cmd[2] == "telvanni" then
				for slot, k in pairs(Players[pid].data.factionRanks) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "telvanni" then						
						Players[pid].data.factionRanks[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionRanks()	
						local message = "Votre rang au sein de la guilde à été réinitialisé !"
						tes3mp.SendMessage(pid, message, false)
					end
				end	
			elseif cmd[2] == "temple" then
				for slot, k in pairs(Players[pid].data.factionRanks) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "temple" then						
						Players[pid].data.factionRanks[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionRanks()	
						local message = "Votre rang au sein de la guilde à été réinitialisé !"
						tes3mp.SendMessage(pid, message, false)
					end
				end	
			elseif cmd[2] == "thieves" then
				for slot, k in pairs(Players[pid].data.factionRanks) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "thieves guild" then						
						Players[pid].data.factionRanks[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionRanks()	
						local message = "Votre rang au sein de la guilde à été réinitialisé !"
						tes3mp.SendMessage(pid, message, false)
					end
				end	
			elseif cmd[2] == "sixth" then
				for slot, k in pairs(Players[pid].data.factionRanks) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "sixth house" then						
						Players[pid].data.factionRanks[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionRanks()	
						local message = "Votre rang au sein de la guilde à été réinitialisé !"
						tes3mp.SendMessage(pid, message, false)
					end
				end
			elseif cmd[2] == "cult" then
				for slot, k in pairs(Players[pid].data.factionRanks) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "imperial cult" then						
						Players[pid].data.factionRanks[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionRanks()	
						local message = "Votre rang au sein de la guilde à été réinitialisé !"
						tes3mp.SendMessage(pid, message, false)
					end
				end	
			elseif cmd[2] == "legion" then
				for slot, k in pairs(Players[pid].data.factionRanks) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "imperial legion" then						
						Players[pid].data.factionRanks[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionRanks()	
						local message = "Votre rang au sein de la guilde à été réinitialisé !"
						tes3mp.SendMessage(pid, message, false)
					end
				end	
			elseif cmd[2] == "mages" then
				for slot, k in pairs(Players[pid].data.factionRanks) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "mages guild" then						
						Players[pid].data.factionRanks[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionRanks()	
						local message = "Votre rang au sein de la guilde à été réinitialisé !"
						tes3mp.SendMessage(pid, message, false)
					end
				end	
			elseif cmd[2] == "morag" then
				for slot, k in pairs(Players[pid].data.factionRanks) do
					local guild = slot
					tes3mp.LogMessage(2, guild)	
					if guild == "morag tong" then						
						Players[pid].data.factionRanks[slot] = 0
						Players[pid]:Save()
						Players[pid]:LoadFactionRanks()	
						local message = "Votre rang au sein de la guilde à été réinitialisé !"
						tes3mp.SendMessage(pid, message, false)
					end
				end	
			else
				local message = "Cette guilde n'existe pas!\n"
				tes3mp.SendMessage(pid, message, false)	
			end
