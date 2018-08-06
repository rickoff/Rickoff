

add in server.lua
		elseif cmd[1] == "spectatetimer" and admin then
			myMod.SpectateTPTimer(pid)	
			
		elseif cmd[1] == "spectate" and admin then
            if Players[pid].SpectateTarget ~= nil then
                Players[pid].SpectateTarget = nil
                local TargetPid = Players[pid].SpectateTarget
                if Players[TargetPid] ~= nil then
                    Players[TargetPid].Spectator = nil
                end    
                myMod.ToggleSpectate(pid)
                tes3mp.SendMessage(pid, color.Warning.."No longer spectating", false)
            elseif myMod.CheckPlayerValidity(pid, cmd[2]) then --So now just specify a target. Like /spectate 5 for example
                local TargetPid = tonumber(cmd[2])
                Players[TargetPid].Spectator = pid
                Players[pid].SpectateTarget = TargetPid
                myMod.ToggleSpectate(pid)
                tes3mp.SendMessage(pid, color.Warning.."Now spectating "..Players[TargetPid].name, false)
            end 
            
add under function OnPlayerCellChange(pid)          
	myMod.SpectatePersist(pid)
	myMod.TeleportSpectator(pid)           
            
            
            
add in mymod.lua 
	
	Methods.SpectatePersist = function(pid) 
	    if Players[pid].Disabled == true then
		Methods.SetPlayerState(pid, "disable")
		Players[pid].Disabled = true
	    end
	end 

	Methods.TeleportSpectator = function(pid)
	    if Players[pid] ~= nil and Players[pid].Spectator ~= nil then
		local SpectatorPid = Players[pid].Spectator
		Methods.TeleportToPlayerSpectate(pid, SpectatorPid, pid)
			Methods.SpectateTPTimer(pid)
	    end    
	end	


	Methods.SpectateTPTimer = function(pid) --Timer for if you want to repeatedly teleport to the spectate target
		if Players[pid].SpectateTimer ~= nil then
			return
		end	
		Players[pid].SpectateTimer = tes3mp.CreateTimerEx("SpectateTeleportEnd", time.seconds(3), "i", pid)
		tes3mp.StartTimer(Players[pid].SpectateTimer)

		function SpectateTeleportEnd(pid)
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
				local TargetPid = Players[pid].SpectateTarget
				if Players[TargetPid] ~= nil then
					Methods.TeleportToPlayerSpectate(pid, pid, TargetPid)
					tes3mp.RestartTimer(Players[pid].SpectateTimer, time.seconds(3))
				else
					Players[pid].SpectateTimer = nil
				end
			end
		end	
	end 
