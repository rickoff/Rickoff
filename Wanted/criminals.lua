--[[
Criminals by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Affiche un message quand un joueur a une prime, un joueur tuant un criminel gagne la prime
---------------------------
INSTALLATION:
Save the file as Criminals.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
Criminals = require("custom.Criminals")

]]

-- Settings
displayGlobalWanted = true -- whether or not to display the global messages in chat when a player's wanted status changes
displayGlobalClearedBounty = true -- whether or not to display a global message when a player clears their bounty
displayGlobalBountyClaim = true -- whether or not to display a global message when another player claims a bounty
bountyItem = "gold_001" -- item used as bounty, in case you use a custom currency
require("color")

Methods = {}
Methods.onLogin = function(eventStatus, pid) -- set the criminal level as a custom variable for players based on their bounty
    if Players[pid].data.customVariables.criminal == nil then
        local criminal
        local bounty = Players[pid].data.fame.bounty
        if bounty >= 5000 then
            criminal = 3
        elseif bounty >= 1000 then
            criminal = 2
        elseif bounty >= 500 then
            criminal = 1
        else
            criminal = 0
        end
        Players[pid].data.customVariables.criminal = criminal
		Methods.updateBounty(eventStatus, pid)
    end	
end

Methods.isCriminal = function(pid) -- get criminal prefix for chat messages
    local bounty = tes3mp.GetBounty(pid)
    local prefix = ""
    if bounty >= 5000 then
        prefix = color.Red .. "[Fugitif]" .. color.Default
    elseif bounty >= 1000 then
        prefix = color.Salmon .. "[Criminel]" .. color.Default
    elseif bounty >= 500 then
        prefix = color.LightSalmon .. "[Voleur]" .. color.Default
    end
    return prefix
end

Methods.getNewCriminalLevel = function(pid) -- get the criminal level based on current bounty and previous level
    local bounty = tes3mp.GetBounty(pid)
    local previousCriminal = Players[pid].data.customVariables.criminal
    local criminal
    if bounty >= 5000 then
        if previousCriminal ~= 3 then
            criminal = 3
        end
    elseif bounty >= 1000 then
        if previousCriminal ~= 2 then
            criminal = 2
        end
    elseif bounty >= 500 then
        if previousCriminal ~= 1 then
            criminal = 1
        end
    elseif bounty == 0 then
        if previousCriminal ~= 0 then
            criminal = 0
        end
    end
    if criminal == nil then
        criminal = -1
    else
        Players[pid].data.customVariables.criminal = criminal
    end
    return criminal
end

Methods.updateBounty = function(eventStatus, pid) -- display global messages if needed when a criminal level changes
    local message
    local playerName = tes3mp.GetName(pid)
    local criminal = Criminals.getNewCriminalLevel(pid)
    if criminal > 0 then
        if displayGlobalWanted == true then
            message = color.Crimson .. "[Attention] " .. color.Brown .. playerName .. " " .. color.Default
            if criminal == 1 then
                message = message .. "est déclaré comme un voleur.\n"
            elseif criminal == 2 then
                message = message .. "est déclaré comme un criminel.\n"
            elseif criminal == 3 then
                message = message .. "a un mandat d'arrêt. Ce fugitif sera tué à vue\n"
            else
                message = ""
            end
            tes3mp.SendMessage(pid, message, true)
        end
    elseif criminal == 0 then
        if displayGlobalClearedBounty == true then
            message = color.Green .. "[Info] " .. color.Brown .. playerName .. " " .. color.Default
            message = message .. "N'a plus de prime sur la tête.\n"
            tes3mp.SendMessage(pid, message, true)
        end
    end
end

Methods.processBountyReward = function(eventStatus, pid) -- give rewards for claiming a bounty
    if tes3mp.DoesPlayerHavePlayerKiller(pid) then
        local killerPid = tes3mp.GetPlayerKillerPid(pid)
		local playerName = tes3mp.GetName(pid)
        if pid ~= killerPid then
			local killerName = Players[killerPid].name
			if killerName ~= "" and killerName ~= playerName then
				local currentBounty = tes3mp.GetBounty(pid)
				local newBounty
				local reward
				local message
				if currentBounty >= 500 then -- don't want newbies losing gold over petty theft
					local message = currentBounty .. "\n"
					tes3mp.SendMessage(pid, message, false)
					for index, item in pairs(Players[pid].data.inventory) do
						if tableHelper.containsKeyValue(Players[pid].data.inventory, "refId", bountyItem, true) then
							itemIndex = tableHelper.getIndexByNestedKeyValue(Players[pid].data.inventory, "refId", bountyItem)
							itemCount = Players[pid].data.inventory[itemIndex].count -- find how much gold the player has
						else
							itemCount = 0
						end
					end
					if itemCount >= currentBounty then -- if a bounty can be fully cleared, do so
						newBounty = 0
						reward = currentBounty
					else
						newBounty = currentBounty - itemCount -- otherwise, clear it only partially
						reward = itemCount
					end
					local structuredItem = { refId = bountyItem, count = reward, charge = -1 } -- give the reward to the killer
					table.insert(Players[killerPid].data.inventory, structuredItem)
					if itemCount ~= 0 then -- if the player actually has gold
						Players[pid].data.inventory[itemIndex].count = Players[pid].data.inventory[itemIndex].count - reward --remove the gold
						if Players[pid].data.inventory[itemIndex].count == 0 then
							Players[pid].data.inventory[itemIndex] = nil
						end
						if displayGlobalBountyClaim == true then -- display messages
							local message2 = killer .. " " .. tostring(reward)
							message = color.Brown .. killer .. color.Default .. " a réclamé une prime de " .. tostring(reward) .. " en tuant " .. color.Brown .. Players[pid].name .. color.Default .. ".\n"
							tes3mp.SendMessage(pid, message, true)
						else
							message = color.Brown .. "Vous" .. color.Default .. " avez réclamé une prime pour " .. tostring(reward) .. " la mort de " .. color.Brown .. Players[pid].name .. color.Default .. ".\n"
							tes3mp.SendMessage(killerPid, message, false)
						end
						if newBounty == 0 then -- display additional message to let people know the player is no longer a criminal
							if displayGlobalClearedBounty == true then
								message = color.Green .. "[Info] " .. color.Brown .. playerName .. " " .. color.Default
								message = message .. "N'a plus de prime sur la tête.\n"
								tes3mp.SendMessage(pid, message, true)
							end
						end
						Players[pid].data.fame.bounty = newBounty -- set new bounty
						tes3mp.SetBounty(pid, Players[pid].data.fame.bounty)
						tes3mp.SendBounty(pid)
						local itemref = {refId = "gold_001", count = reward, charge = -1}			
						Players[pid]:SaveToDrive()
						Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)			
						Players[killerPid]:SaveToDrive()
						Players[killerPid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)
						Criminals.updateBounty(eventStatus, pid)
						Criminals.updateBounty(eventStatus, killerPid)						
					end
				end
            end
        end
    end
end

customEventHooks.registerHandler("OnPlayerFinishLogin", Methods.onLogin)
customEventHooks.registerHandler("OnPlayerBounty", Methods.updateBounty)
customEventHooks.registerHandler("OnPlayerDeath", Methods.processBountyReward)
	
return Methods
