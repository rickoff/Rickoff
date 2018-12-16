* To start you have to install python3 available here:https://www.python.org/downloads/

* To install the library without full voice support, you can just run the following command:
python3 -m pip install -U discord.py

* For use Bot vocal discord with a server tes3mp add botdiscordtes3mp.py in tes3mp folder.

* Find eventHandler.OnPlayerDisconnect = function(pid) in eventHandler.lua and add :

        --Players[pid]:Destroy()
        --Players[pid] = nil

		local playerLocations = {players={}}
		for pid, ply in pairs(Players) do
			local newindex = #playerLocations.players+1
			playerLocations.players[newindex] = {}
			
			for k, v in pairs(ply.data.location) do
				playerLocations.players[newindex][k] = v
			end
			playerLocations.players[newindex] = nil
		end
		jsonInterface.save("playerLocations.json", playerLocations)	

        Players[pid]:Destroy()
        Players[pid] = nil

* Find eventHandler.OnPlayerCellChange = function(pid) in eventHandler.lua and add :

        if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
            local playerLocations = {players={}}
            for pid, ply in pairs(Players) do
                local newindex = #playerLocations.players+1
                playerLocations.players[newindex] = {}
                for k, v in pairs(ply.data.location) do
                    playerLocations.players[newindex][k] = v
                end
                playerLocations.players[newindex].name = ply.accountName
            end
            jsonInterface.save("playerLocations.json", playerLocations)
        end	

* For use Check Vocal Discord with a server tes3mp add VocalDiscordCheck.lua in mpstuff//script folder:

* Find 'function OnPlayerCellChange(pid)' in ServerCore.lua and add above

                	vocalDiscord.OnCheckPlayer(pid)	
