INSTALLATION

1) Save this file as "HunterWorld.lua" in mp-stuff/scripts
CreaturesVanilla.json and CreatureSpawn.json in mpstuff/data

2) Add [HunterWorld = require("HunterWorld")] to the top of serverCore.lua

3) Find "function OnServerInit()" inside serverCore.lua and add at the end
	HunterWorld.TimerEventWorld()	

4) Find function OnWorldKillCount(pid) in serverCore.lua and add EventWorld.HunterPrime(pid) like this.

		function OnWorldKillCount(pid)
			tes3mp.LogMessage(enumerations.log.INFO, "Called \"OnWorldKillCount\" for " .. logicHandler.GetChatName(pid))
			eventHandler.OnWorldKillCount(pid)
			HunterWorld.HunterPrime(pid)	
		end
