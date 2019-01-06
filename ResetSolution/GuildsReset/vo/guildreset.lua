
elseif cmd[1] == "menuguilds" then

	Players[pid].currentCustomMenu = "commande reset ranks"

	menuHelper.displayMenu(pid, Players[pid].currentCustomMenu)	



elseif cmd[1] == "resetreputation" and cmd[2] ~= nil then

	local message = "Your reputation within the guild has been reset !"

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

		else

			local message = "This guild does not exist !\n"

			tes3mp.SendMessage(pid, message, false)								

		end	

	end



elseif cmd[1] == "resetexpulsion" and cmd[2] ~= nil then

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

					else

						local message = "This guild does not exist !\n"

						tes3mp.SendMessage(pid, message, false)								

					end					

				end

				local message = "Your expulsion within the guild has been reset !"

				tes3mp.SendMessage(pid, message, false)							

			else

				local message = "You need 1000 gold !\n"

				tes3mp.SendMessage(pid, message, false)							

			end

		else

			local message = "You need 1000 gold !\n"

			tes3mp.SendMessage(pid, message, false)							

		end					



elseif cmd[1] == "resetexclusion" and cmd[2] ~= nil then

	local message = "Your eviction within the guild has been validated !"

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

		else

			local message = "This guild does not exist !\n"

			tes3mp.SendMessage(pid, message, false)								

		end					

	end			



elseif cmd[1] == "resetranks" and cmd[2] ~= nil then

	local message = "Your rank within the guild has been reset !"

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

		elseif cmd[2] == "all" then

			if guild ~= nil then						

				Players[pid].data.factionRanks[slot] = 0

				Players[pid]:Save()

				Players[pid]:LoadFactionRanks()	

			end					

		else

			local message = "This guild does not exist !\n"

			tes3mp.SendMessage(pid, message, false)	

		end

	end
