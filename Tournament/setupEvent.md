EventSetup
    
1) Save this file as "eventPvp.lua" and/or "eventRush.lua" in mp-stuff/scripts

2) Add [ eventPvp = require("eventPvp") ] and/or [ eventRush = require("eventRush") ]  to the top of serverCore.lua

3) Find in serverCore.lua "function OnServerInit()" and add

       pvpEvent.TimerStartEvent()
       eventRush.TimerStartEvent()
       eventOblivion.TimerStartEvent()      
4) Add the following to the elseif chain for commands inside commandHandler.lua

		elseif cmd[1] == "pvp" then
			pvpEvent.Register(pid)
		elseif cmd[1] == "rush" then
			eventRush.Register(pid)	
5) Find and Replace function OnPlayerDeath(pid)

		function OnPlayerDeath(pid)
			tes3mp.LogMessage(enumerations.log.INFO, "Called \"OnPlayerDeath\" for " .. logicHandler.GetChatName(pid))
		    --eventHandler.OnPlayerDeath(pid)
			pvpEvent.TcheckKill(pid)
			eventRush.TcheckKill(pid)
			local pvp = pvpEvent.TcheckKill(pid)
			local rush = eventRush.TcheckKill(pid)	
			if pvp == false and rush == false then
				eventHandler.OnPlayerDeath(pid)
			end
		end

6) Find function OnPlayerCellChange(pid) and add under

		pvpEvent.tcheckcell(pid)
		eventRush.tcheckcell(pid)

7) For use eventOblivion.lua find function eventHandler.OnActorDeath and replace by :

		eventHandler.OnActorDeath = function(pid, cellDescription)
		    if LoadedCells[cellDescription] ~= nil then
			local actorIndex = tes3mp.GetActorListSize() - 1
			local uniqueIndex = tes3mp.GetActorRefNum(actorIndex) .. "-" .. tes3mp.GetActorMpNum(actorIndex)
				if actorIndex ~= nil and uniqueIndex ~= nil then
					if tes3mp.DoesActorHavePlayerKiller(actorIndex) then
						local killerPid = tes3mp.GetActorKillerPid(actorIndex)
						local crearefId = LoadedCells[cellDescription].data.objectData[uniqueIndex].refId	
						HunterWorld.HunterPrime(killerPid, crearefId)--if you use HunterWorld
						eventOblivion.Prime(killerPid, crearefId)--if you use eventOblivion
						EcarlateSoul.OnPlayerKillCreature(killerPid, crearefId)	--if you use EcarlateSoul	
					end
				end
				LoadedCells[cellDescription]:SaveActorDeath(pid)		
		    else
			tes3mp.LogMessage(enumerations.log.WARN, "Undefined behavior: " .. logicHandler.GetChatName(pid) ..
			    " sent ActorDeath for unloaded " .. cellDescription)
		    end
		end
