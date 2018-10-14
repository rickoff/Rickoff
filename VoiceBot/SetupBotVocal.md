For use Bot vocal discord:


find and replace all eventHandler.OnPlayerDisconnect = function(pid) in eventHandler.lua :

        eventHandler.OnPlayerDisconnect = function(pid)

            if Players[pid] ~= nil then

                Players[pid]:DeleteSummons()

                -- Was this player confiscating from someone? If so, clear that
                if Players[pid].confiscationTargetName ~= nil then
                    local targetName = Players[pid].confiscationTargetName
                    local targetPlayer = logicHandler.GetPlayerByName(targetName)
                    targetPlayer:SetConfiscationState(false)
                end

                Players[pid]:SaveCell()
                Players[pid]:SaveStatsDynamic()
                        Players[pid]:SaveEquipment()
                        Players[pid]:SaveInventory()
                tes3mp.LogMessage(enumerations.log.INFO, "Saving player " .. logicHandler.GetChatName(pid))
                Players[pid]:Save()

                -- Unload every cell for this player
                for index, loadedCellDescription in pairs(Players[pid].cellsLoaded) do
                    logicHandler.UnloadCellForPlayer(pid, loadedCellDescription)
                end

                if Players[pid].data.location.regionName ~= nil then
                    logicHandler.UnloadRegionForPlayer(pid, Players[pid].data.location.regionName)
                end

                        local playerLocations = {players={}}
                        for pid, ply in pairs(Players) do
                                local newindex = #playerLocations.players+1
                                playerLocations.players[newindex] = {}

                                for k, v in pairs(ply.data.location) do
                                        playerLocations.players[newindex][k] = v -- We're copying the table here or else we modify the player's actual data in the following assignment
                                end
                                playerLocations.players[newindex].name = ply.accountName
                        end
                        jsonInterface.save("playerLocations.json", playerLocations)

                local playerTimeUnix = {players={}}        
                for pid, ply in pairs(Players) do
                                local newindex = #playerTimeUnix.players+1
                                playerTimeUnix.players[newindex] = {os.time(os.date("!*t"))}
                                playerTimeUnix.players[newindex].name = ply.accountName
                end        
                jsonInterface.save("playerTimeUnix.json", playerTimeUnix) 		

                Players[pid]:Destroy()
                Players[pid] = nil
            end
        end
Find and replace eventHandler.OnPlayerCellChange = function(pid) in eventHandler.lua

        eventHandler.OnPlayerCellChange = function(pid)

            if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then

                if contentFixer.ValidateCellChange(pid) then

                    local previousCellDescription = Players[pid].data.location.cell

                    -- If this player is changing their region, add them to the visitors of the new
                    -- region while removing them from the visitors of their old region
                    if tes3mp.IsChangingRegion(pid) then
                        local regionName = string.lower(tes3mp.GetRegion(pid))

                        if regionName ~= "" then

                            local debugMessage = logicHandler.GetChatName(pid) .. " has "

                            local hasFinishedInitialTeleportation = Players[pid].hasFinishedInitialTeleportation
                            local previousCellIsStillLoaded = tableHelper.containsValue(Players[pid].cellsLoaded,
                                previousCellDescription)

                            -- It's possible we've been teleported to a cell we had already loaded when
                            -- spawning on the server, so also check whether this is the player's first
                            -- cell change since joining
                            local isTeleported = not previousCellIsStillLoaded or not hasFinishedInitialTeleportation

                            if isTeleported then
                                debugMessage = debugMessage .. "teleported"
                            else
                                debugMessage = debugMessage .. "walked"
                            end

                            debugMessage = debugMessage .. " to region " .. regionName .. "\n"
                            tes3mp.LogMessage(enumerations.log.INFO, debugMessage)

                            logicHandler.LoadRegionForPlayer(pid, regionName, isTeleported)
                        end

                        local previousRegionName = Players[pid].data.location.regionName

                        if previousRegionName ~= nil and previousRegionName ~= regionName then
                            logicHandler.UnloadRegionForPlayer(pid, previousRegionName)
                        end

                        -- Exchange generated records with the other players who have this cell loaded
                        local currentCellDescription = tes3mp.GetCell(pid)
                        logicHandler.ExchangeGeneratedRecords(pid, LoadedCells[currentCellDescription].visitors)

                        Players[pid].data.location.regionName = regionName
                        Players[pid].hasFinishedInitialTeleportation = true
                    end

                    Players[pid]:SaveCell()
                    Players[pid]:SaveStatsDynamic()			
                    tes3mp.LogMessage(enumerations.log.INFO, "Saving player " .. logicHandler.GetChatName(pid))
                    Players[pid]:Save()

                    if config.shareMapExploration == true then
                        WorldInstance:SaveMapExploration(pid)
                    end
                else
                    Players[pid].data.location.posX = tes3mp.GetPreviousCellPosX(pid)
                    Players[pid].data.location.posY = tes3mp.GetPreviousCellPosY(pid)
                    Players[pid].data.location.posZ = tes3mp.GetPreviousCellPosZ(pid)
                    Players[pid]:LoadCell()
                end
            end

        local playerLocations = {players={}}

            if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
                Players[pid]:SaveCell()
                Players[pid]:SaveStatsDynamic()
                tes3mp.LogMessage(1, "Enregistrer le joueur " .. pid)
                Players[pid]:Save()
                        local playerLocations = {players={}}
                        for pid, ply in pairs(Players) do
                                local newindex = #playerLocations.players+1
                                playerLocations.players[newindex] = {}
                                for k, v in pairs(ply.data.location) do
                                        playerLocations.players[newindex][k] = v -- We're copying the table here or else we modify the player's actual data in the following assignment
                                end
                                playerLocations.players[newindex].name = ply.accountName
                        end
                        jsonInterface.save("playerLocations.json", playerLocations)
            end	
        end
