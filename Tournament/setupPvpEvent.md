EventPvpSetup
    
1) Save this file as "eventPvp.lua" in mp-stuff/scripts

2) Add [ eventPvp = require("eventPvp") ] to the top of server.lua

3) Find in server.lua "function OnServerInit()" and add

       pvpEvent.TimerStartEvent()
        
4) Add the following to the elseif chain for commands inside server.lua

		elseif cmd[1] == "pvp" then
			pvpEvent.Register(pid)
	
5) Find and Replace

        function OnPlayerDeath(pid)
          myMod.OnPlayerDeath(pid)
        end

to

    function OnPlayerDeath(pid)
      pvpEvent.TcheckKill(pid)
    end
