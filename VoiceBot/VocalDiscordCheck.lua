--[[
VocalDiscord by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Check the player in discord vocal or not
---------------------------
INSTALLATION:
Save the file as VocalDiscord.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
VocalDiscord = require("custom.VocalDiscord")
---------------------------
]]

jsonInterface = require("jsonInterface")
tableHelper = require("tableHelper")

local config = {}
config.timerstartvocal = 60

VocalDiscord = {}

VocalDiscord.OnCheckPlayer = function(eventStatus, pid)

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
		if Players[pid].data.settings.staffRank ~= 2 then		
			if Players[pid].data.settings.staffRank ~= 1 then
				local playerdiscordTable = jsonInterface.load("userdiscord.json")
				local playerName = Players[pid].name
				
				if tableHelper.containsValue(playerdiscordTable.players, playerName) == false then
					local TimerVocal = tes3mp.CreateTimer("StartKick", time.seconds(config.timerstartvocal))				
					tes3mp.StartTimer(TimerVocal, time.seconds(config.timerstartvocal))
					tes3mp.MessageBox(pid, 0, ""..color.Red.."Attention!"..color.Default.."\n\nvous devez vous connecter sur le channel vocal pour continuer à jouer sinon vous serez deconnecté dans 1 minute !")						
				end
				
				function StartKick()
					if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
						local playerdiscordTable = jsonInterface.load("userdiscord.json")					
						if tableHelper.containsValue(playerdiscordTable.players, playerName) == false then
							tes3mp.Kick(pid)
							tes3mp.LogMessage(enumerations.log.INFO, "On Player Kick For Vocal")					
						end
					end
				end
			end
		end
	end
end

VocalDiscord.OnPlayerCellChange = function(eventStatus, pid)

    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local playerLocations = {players={}}
		for pid, ply in pairs(Players) do
			local newindex = #playerLocations.players+1
			playerLocations.players[newindex] = {}
			for k, v in pairs(ply.data.location) do
				playerLocations.players[newindex][k] = v -- We're copying the table here or else we modify the player's actual data in the following assignment
			end
			playerLocations.players[newindex].name = ply.accountName
			playerLocations.players[newindex].level = ply.data.stats.level
			if ply.data.customVariables.levelSoul ~= nil then
				playerLocations.players[newindex].levelSoul = ply.data.customVariables.levelSoul
			else
				playerLocations.players[newindex].levelSoul = 0
			end
		end
		jsonInterface.save("playerLocations.json", playerLocations)
    end
end

VocalDiscord.PlayerDisconnect = function(pid)
	local playerLocations = {players={}}
	for pid, ply in pairs(Players) do
		local newindex = #playerLocations.players+1
		playerLocations.players[newindex] = {}
		for k, v in pairs(ply.data.location) do
			playerLocations.players[newindex][k] = v -- We're copying the table here or else we modify the player's actual data in the following assignment
		end
		playerLocations.players[newindex].name = ply.accountName
		playerLocations.players[newindex].level = ply.data.stats.level
		if ply.data.customVariables.levelSoul ~= nil then
			playerLocations.players[newindex].levelSoul = ply.data.customVariables.levelSoul
		else
			playerLocations.players[newindex].levelSoul = 0
		end
	end
	jsonInterface.save("playerLocations.json", playerLocations)
end


customEventHooks.registerHandler("OnPlayerDisconnect", function(eventStatus, pid)
	VocalDiscord.PlayerDisconnect(pid)
end)
customEventHooks.registerHandler("OnPlayerCellChange", VocalDiscord.OnCheckPlayer)
customEventHooks.registerHandler("OnPlayerCellChange", VocalDiscord.OnPlayerCellChange)


return VocalDiscord
