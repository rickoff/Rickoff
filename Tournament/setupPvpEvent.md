EventPvpSetup
    
1) Save this file as "eventPvp.lua" in mp-stuff/scripts

2) Add [ eventPvp = require("eventPvp") ] to the top of serverCore.lua

3) Find in serverCore.lua "function OnServerInit()" and add

       pvpEvent.TimerStartEvent()
        
4) Add the following to the elseif chain for commands inside commandHandler.lua

		elseif cmd[1] == "pvp" then
			pvpEvent.Register(pid)
	
5) Find and Replace function OnPlayerDeath(pid)

		function OnPlayerDeath(pid)
			tes3mp.LogMessage(enumerations.log.INFO, "Called \"OnPlayerDeath\" for " .. logicHandler.GetChatName(pid))
			--eventHandler.OnPlayerDeath(pid)
			pvpEvent.TcheckKill(pid)	
		end

6) Find function OnPlayerCellChange(pid) and add under

		pvpEvent.tcheckcell(pid)
