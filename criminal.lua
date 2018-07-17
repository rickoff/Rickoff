

   --Put Criminals.lua file in ...\tes3mp\mp-stuff\scripts\ folder.

   --Open server.lua and add Criminals = require("Criminals") at the top along with other require lines.

    --(OPTIONAL) Find return false -- default behavior, chat messages should not and replace it with:

--local prefix = Criminals.isCriminal(pid)
--tes3mp.SendMessage(pid, prefix .. playerName .. " (" .. pid .. "): " .. message .. "\n", true)
--return false -- default behavior, chat messages should not

    --Save server.lua, open myMod.lua.

    --Find Players[pid]:Message("You have successfully logged in.\n") and below it add Criminals.onLogin(pid).

    --Find Players[pid]:SaveBounty() and add Criminals.updateBounty(pid) below it.

    --Save myMod.lua and open \player\base.lua or script with processdeath

    --Find deathReason = "was killed by " .. deathReason and below it add Criminals.processBountyReward(self.pid, deathReason).

    --Save base.lua and start the server. Try committing a crime to gain a bounty of 500 or more and see if a message is displayed in the chat.

-- Settings
displayGlobalWanted = true -- whether or not to display the global messages in chat when a player's wanted status changes
displayGlobalClearedBounty = true -- whether or not to display a global message when a player clears their bounty
displayGlobalBountyClaim = true -- whether or not to display a global message when another player claims a bounty
bountyItem = "gold_001" -- item used as bounty, in case you use a custom currency
require("color")

Methods = {}
Methods.onLogin = function(pid) -- set the criminal level as a custom variable for players based on their bounty
    if Players[pid].data.customVariables.criminal == nil then
        local criminal
        local bounty = Players[pid].data.stats.bounty
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

Methods.updateBounty = function(pid) -- display global messages if needed when a criminal level changes
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

Methods.processBountyReward = function(pid, killertxt) -- give rewards for claiming a bounty
    local playerName = tes3mp.GetName(pid)
    killer = string.sub(killertxt, 14)
    local lastPid = tes3mp.GetLastPlayerId()
    local killerPID = -1
    local currentBounty = tes3mp.GetBounty(pid)
    local newBounty
    local reward
    local message
    if currentBounty >= 500 then -- don't want newbies losing gold over petty theft
        for i = 0, lastPid do
            if Players[i] ~= nil and Players[i]:IsLoggedIn() then
                if tostring(Players[i].name) == tostring(killer) then
                    killerPID = Players[i].pid -- get killer's PID, assuming it was an actual player
                    break
                end
            end
        end
        if killerPID ~= -1 then -- if a killer was found
            if bountyItem ~= "" then
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
                table.insert(Players[killerPID].data.inventory, structuredItem)
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
                        tes3mp.SendMessage(killerPID, message, false)
                    end
                    if newBounty == 0 then -- display additional message to let people know the player is no longer a criminal
                        if displayGlobalClearedBounty == true then
                            message = color.Green .. "[Info] " .. color.Brown .. playerName .. " " .. color.Default
                            message = message .. "N'a plus de prime sur la tête.\n"
                            tes3mp.SendMessage(pid, message, true)
                        end
                    end
                    Players[pid].data.stats.bounty = newBounty -- set new bounty
                    tes3mp.SetBounty(pid, Players[pid].data.stats.bounty)
                    tes3mp.SendBounty(pid)
                    Players[pid]:LoadInventory() -- save inventories for both players
                    Players[pid]:LoadEquipment()
                    Players[pid]:Save()
                    Players[killerPID]:LoadInventory()
                    Players[killerPID]:LoadEquipment()
                    Players[killerPID]:Save()
                    Criminals.getNewCriminalLevel(pid)
                end
            end
        end
    end
end

return Methods
