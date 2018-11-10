--VocalDiscordCheck by Rick-Off
--
--
--If the player is not connected to the vocal discord then we kick him
--v 0.1

jsonInterface = require("jsonInterface")
tableHelper = require("tableHelper")

local config = {}
config.timerstart = 120
config.timerstartvocal = 30

VocalDiscord = {}

VocalDiscord.OnCheckPlayer = function(pid)

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and Players[pid].data.settings.staffRank ~= 2 then
	
		local TimerStart = tes3mp.CreateTimer("StartCheck", time.seconds(config.timerstart))
		tes3mp.StartTimer(TimerStart, time.seconds(config.timerstart))	
		local playerdiscordTable = jsonInterface.load("userdiscord.json")
		local playerName = Players[pid].name
		
		function StartCheck()
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and Players[pid].data.settings.staffRank ~= 2 then			
				if tableHelper.containsValue(playerdiscordTable.players, playerName) == false then
					local TimerVocal = tes3mp.CreateTimer("StartKick", time.seconds(config.timerstartvocal))				
					tes3mp.StartTimer(TimerVocal, time.seconds(config.timerstartvocal))
					tes3mp.MessageBox(pid, 0, ""..color.Red.."Attention!"..color.Default.."\n\nvous devez vous connecter sur le channel vocal pour continuer à jouer sinon vous serez deconnecté dans 1 minute!")						
				end
			end
		end
		
		function StartKick()
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and Players[pid].data.settings.staffRank ~= 2 then			
				if tableHelper.containsValue(playerdiscordTable.players, playerName) == false then
					tes3mp.Kick(pid)
					tes3mp.LogMessage(enumerations.log.INFO, "On Player Kick For Vocal")					
				end
			end
		end
		tes3mp.RestartTimer(TimerStart, time.seconds(config.timerstart))		
	end

end

return VocalDiscord
