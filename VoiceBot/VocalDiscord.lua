--[[
VocalDiscord by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Check the player in discord vocal or not
Use /vocal for active instancied vocal
---------------------------
REQUIRE:
create a bot on your discord
drop folder luadiscord in server/lib
edit the config.lua file in server/lib/luadiscord
execute start.bat located in server/lib/luadiscord
---------------------------
INSTALLATION:
Save the file as VocalDiscord.lua inside your server/scripts/custom folder.
Save the file as userdiscord.lua inside your server/data/custom folder.
Save the file as playerLocations.lua inside your server/data/custom folder.

Edits to customScripts.lua
VocalDiscord = require("custom.VocalDiscord")
---------------------------
CONFIG:
config.kickPlayer = true or config.kickPlayer = false if you want to kick players who are not in a vocal channel of your discord
change time config.timerstartvocal = 60 to modify the delay before expulsion
]]

jsonInterface = require("jsonInterface")
tableHelper = require("tableHelper")

local config = {}
config.timerstartvocal = 60
config.kickPlayer = true

VocalDiscord = {}

VocalDiscord.OnCheckPlayer = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and Players[pid]:HasAccount() then	
		if Players[pid].data.settings.staffRank == 0 then		
			local playerdiscordTable = jsonInterface.load("custom/userdiscord.json")
			local playerName = string.lower(Players[pid].name)
			if playerdiscordTable.players ~= nil then
				if not tableHelper.containsValue(playerdiscordTable.players, playerName, true) then
					local TimerVocal = tes3mp.CreateTimer("StartKick", time.seconds(config.timerstartvocal))				
					tes3mp.StartTimer(TimerVocal, time.seconds(config.timerstartvocal))
					tes3mp.MessageBox(pid, 0, color.Red.."Warning!"..color.Default.."\n\nyou must connect to the voice channel to continue playing otherwise you will be disconnected !")						
				end
			end		
			function StartKick()
				if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
					local playerdiscordTable = jsonInterface.load("custom/userdiscord.json")
					if playerdiscordTable then
						if not tableHelper.containsValue(playerdiscordTable.players, playerName, true) then
							tes3mp.Kick(pid)
							tes3mp.LogMessage(enumerations.log.INFO, "On Player Kick For Vocal")					
						end
					end
				end
			end
		end
		local playerLocations = {players={}}
		for pid, ply in pairs(Players) do
			local newindex = #playerLocations.players+1
			playerLocations.players[newindex] = {}
			for k, v in pairs(ply.data.location) do
				playerLocations.players[newindex][k] = v
			end
			playerLocations.players[newindex].name = ply.accountName
			playerLocations.players[newindex].level = ply.data.stats.level
			if ply.data.customVariables.vocal then
				playerLocations.players[newindex].vocal = ply.data.customVariables.vocal
			end	
		end
		jsonInterface.save("custom/playerLocations.json", playerLocations)		
	end
end

VocalDiscord.PlayerDisconnect = function(pid)
	local playerLocations = {players={}}
	for pid, ply in pairs(Players) do
		local newindex = #playerLocations.players+1
		playerLocations.players[newindex] = {}
		for k, v in pairs(ply.data.location) do
			playerLocations.players[newindex][k] = v
		end
		playerLocations.players[newindex].name = ply.accountName
		playerLocations.players[newindex].level = ply.data.stats.level
		if ply.data.customVariables.vocal then
			playerLocations.players[newindex].vocal = ply.data.customVariables.vocal
		end
	end
	jsonInterface.save("custom/playerLocations.json", playerLocations)
end

VocalDiscord.Vocalon = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and Players[pid]:HasAccount() then
		if Players[pid].data.customVariables.vocal == nil then
			Players[pid].data.customVariables.vocal = 1
			tes3mp.MessageBox(pid, -1, color.Gold.."Instantiated voice activated!")				
		elseif Players[pid].data.customVariables.vocal == 0 then
			Players[pid].data.customVariables.vocal = 1
			tes3mp.MessageBox(pid, -1, color.Gold.."Instantiated voice activated!")			
		elseif Players[pid].data.customVariables.vocal == 1 then	
			Players[pid].data.customVariables.vocal = 0
			tes3mp.MessageBox(pid, -1, color.Gold.."Instantiated voice disabled!")			
		end
		local playerLocations = {players={}}
		for pid, ply in pairs(Players) do
			local newindex = #playerLocations.players+1
			playerLocations.players[newindex] = {}
			for k, v in pairs(ply.data.location) do
				playerLocations.players[newindex][k] = v
			end
			playerLocations.players[newindex].name = ply.accountName
			playerLocations.players[newindex].level = ply.data.stats.level
			if ply.data.customVariables.vocal then
				playerLocations.players[newindex].vocal = ply.data.customVariables.vocal
			end
		end
		jsonInterface.save("custom/playerLocations.json", playerLocations)		
	end
end

VocalDiscord.PlayerConnect = function(eventStatus, pid)
	if Players[pid] ~= nil then
		Players[pid].data.customVariables.vocal	= 0
	end
end
	
customEventHooks.registerHandler("OnPlayerDisconnect", function(eventStatus, pid)
	VocalDiscord.PlayerDisconnect(pid)
end)
customCommandHooks.registerCommand("vocal", VocalDiscord.Vocalon)
if config.kickPlayer == true then
	customEventHooks.registerHandler("OnPlayerCellChange", VocalDiscord.OnCheckPlayer)
end
customEventHooks.registerHandler("OnPlayerAuthentified", VocalDiscord.PlayerConnect)

return VocalDiscord
