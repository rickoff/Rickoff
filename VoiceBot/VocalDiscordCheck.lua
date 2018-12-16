--VocalDiscordCheck by Rick-Off
--
--
--
--v 0.2

jsonInterface = require("jsonInterface")
tableHelper = require("tableHelper")

local config = {}
config.timerstartvocal = 60

VocalDiscord = {}

VocalDiscord.OnCheckPlayer = function(pid)

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

return VocalDiscord
