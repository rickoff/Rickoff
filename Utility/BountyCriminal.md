add in server.lua		

	elseif cmd[1] == "prime" then
		if myMod.CheckPlayerValidity(pid, cmd[2]) then --So now just specify a target.
			local TargetPid = tonumber(cmd[2])
			Players[TargetPid].wanted = pid
			Players[pid].PrimeTarget = TargetPid
			myMod.PrimeToPlayer(pid, pid, TargetPid)
		end
		
	elseif cmd[1] == "stopprime" and admin then
		if myMod.CheckPlayerValidity(pid, cmd[2]) then --So now just specify a target.
			local TargetPid = tonumber(cmd[2])
			local targetName = Players[TargetPid].name				
				if Players[TargetPid]:IsAdmin() then
					Players[TargetPid].wanted = pid
					Players[pid].PrimeTarget = TargetPid
					local message = targetName .. " la prime a était payé par un modérateur!\n"
					tes3mp.SendMessage(pid, message, true)
					myMod.StopPrimeToPlayer(pid, pid, TargetPid)					
				else
					Players[TargetPid].wanted = pid
					Players[pid].PrimeTarget = TargetPid
					local message = targetName .. " la prime a était payé par un modérateur!\n"
					tes3mp.SendMessage(pid, message, true)	
					myMod.StopPrimeToPlayer(pid, pid, TargetPid)					
				end					               
		end 
            
            
add in mymod.lua

	Methods.PrimeToPlayer = function(pid, originPid, targetPid)
	    if tonumber(originPid) == tonumber(targetPid) then
		local message = "Vous ne pouvez pas mettre de prime sur vous meme.\n"
		tes3mp.SendMessage(pid, message, false)
		return
	    elseif tonumber(originPid) ~= tonumber(targetPid) then
			local player = Players[pid]
			local goldL = inventoryHelper.getItemIndex(player.data.inventory, "gold_001", -1)
			if goldL then
				local item = player.data.inventory[goldL]
				local refId = item.refId
				local count = item.count
				local reste = (item.count - 10000)
				if count >= 10000 then
					player.data.inventory[goldL] = {refId = "gold_001", count = reste, charge = -1}	
					Players[pid]:Save()
					Players[pid]:LoadInventory()
					Players[pid]:LoadEquipment()
					local message = "Vous venez de dépenser 10000 pièces pour mettre une prime\n"
					tes3mp.SendMessage(pid, message, false)				
					Methods.PrimePlayer(targetPid)
				else
					local message = "Vous n'avez pas 10000 pièces pour mettre une prime\n"
					tes3mp.SendMessage(pid, message, false)	
				end
			else
				local message = "Vous n'avez pas de pièces pour mettre une prime\n"
				tes3mp.SendMessage(pid, message, false)			
			end
	    end
	end 

	Methods.StopPrimeToPlayer = function(pid, originPid, targetPid)
	    if tonumber(originPid) == tonumber(targetPid) then
		local message = "Vous ne pouvez pas mettre de prime sur vous meme.\n"
		tes3mp.SendMessage(pid, message, false)
		return
	    elseif tonumber(originPid) ~= tonumber(targetPid) then
			local player = Players[pid]
			local goldL = inventoryHelper.getItemIndex(player.data.inventory, "gold_001", -1)
			if goldL then
				local item = player.data.inventory[goldL]
				local refId = item.refId
				local count = item.count
				local reste = (item.count - 10000)
				if count >= 10000 then
					player.data.inventory[goldL] = {refId = "gold_001", count = reste, charge = -1}	
					Players[pid]:Save()
					Players[pid]:LoadInventory()
					Players[pid]:LoadEquipment()
					local message = "Vous venez de dépenser 10000 pièces pour enlever cette prime\n"
					tes3mp.SendMessage(pid, message, false)				
					Methods.StopPrime(targetPid)
				else
					local message = "Vous n'avez pas 10000 pièces pour enlever cette prime\n"
					tes3mp.SendMessage(pid, message, false)	
				end
			else
				local message = "Vous n'avez pas de pièces pour enlever une prime\n"
				tes3mp.SendMessage(pid, message, false)			
			end
	    end
	end 

	Methods.PrimePlayer = function(pid)
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			local prime = 10000
			Players[pid].data.stats.bounty = prime -- set new bounty
			tes3mp.SetBounty(pid, Players[pid].data.stats.bounty)
			tes3mp.SendBounty(pid)
			Players[pid]:LoadInventory() -- save inventories for both players
			Players[pid]:LoadEquipment()
			Players[pid]:Save()
			Criminals.updateBounty(pid)
		end
	end 
	
	Methods.StopPrime = function(pid)
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			local prime = 0
			Players[pid].data.stats.bounty = prime -- set new bounty
			tes3mp.SetBounty(pid, Players[pid].data.stats.bounty)
			tes3mp.SendBounty(pid)
			Players[pid]:LoadInventory() -- save inventories for both players
			Players[pid]:LoadEquipment()
			Players[pid]:Save()
			Criminals.updateBounty(pid)
		end
	end 	
        
