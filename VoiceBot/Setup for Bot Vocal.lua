For use Bot vocal discord:

insert the block under function OnPlayerConnect(pid) in server.lua:

"""
    local playerName = tes3mp.GetName(pid)

    if string.len(playerName) > 35 then
        playerName = string.sub(playerName, 0, 35)
    end

    if myMod.IsPlayerNameLoggedIn(playerName) then
        myMod.OnPlayerDeny(pid, playerName)
        return false -- deny player
    else
        tes3mp.LogMessage(1, "Nouveau joueur avec pid("..pid..") connecté!")
        myMod.OnPlayerConnect(pid, playerName)
        return true -- accept player
    end
"""

replace block Methods.OnPlayerDisconnect in mymod.lua to :
"""
Methods.OnPlayerDisconnect = function(pid)

    if Players[pid] ~= nil then

        -- Unload every cell for this player
        for index, loadedCellDescription in pairs(Players[pid].cellsLoaded) do

            Methods.UnloadCellForPlayer(pid, loadedCellDescription)
        end


        local playerLocations = {players={}}
        for pid, ply in pairs(Players) do
          local newindex = #playerLocations.players+1
          playerLocations.players[newindex] = {}
          for k, v in pairs(ply.data.location) do
            playerLocations.players[newindex][k] = v -- We're copying the table here or else we modify the player's actual data in the following assignment
          end
          playerLocations.players[newindex].name = "REPLACE TO NAME BOT"
        end
        jsonInterface.save("playerLocations.json", playerLocations)
        Players[pid]:Destroy()
        Players[pid] = nil		
    end
end
"""

and change "REPLACE TO NAME BOT"

    
