
1) Save this file as "DeathDrop.lua" in mp-stuff/scripts

2) Add [ DeathDrop = require("DeathDrop") ] to the top of logicHandler.lua

3) Find "function OnPlayerDeath(pid)" inside serverCore.lua and replace by:

		function OnPlayerDeath(pid)
			tes3mp.LogMessage(enumerations.log.INFO, "Called \"OnPlayerDeath\" for " .. logicHandler.GetChatName(pid))
		  --eventHandler.OnPlayerDeath(pid)
		  DeathDrop.Drop(pid) 	
		end

