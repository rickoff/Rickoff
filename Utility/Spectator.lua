--Spectator.lua by rickoff for tes3mp 0.7.0

--[[INSTALLATION
elseif cmd[1] == "spectatetimer" and admin then
	Spectator.SpectateTPTimer(pid)	

elseif cmd[1] == "spectate" and admin then
        if Players[pid].SpectateTarget ~= nil then
            Players[pid].SpectateTarget = nil
            local TargetPid = Players[pid].SpectateTarget
            if Players[TargetPid] ~= nil then
                Players[TargetPid].Spectator = nil
            end    
            Spectator.ToggleSpectate(pid)
            tes3mp.SendMessage(pid, color.Warning.."No longer spectating", false)
        elseif logicHandler.CheckPlayerValidity(pid, cmd[2]) then --So now just specify a target. Like /spectate 5 for example
            local TargetPid = tonumber(cmd[2])
            Players[TargetPid].Spectator = pid
            Players[pid].SpectateTarget = TargetPid
            Spectator.ToggleSpectate(pid)
            tes3mp.SendMessage(pid, color.Warning.."Now spectating "..Players[TargetPid].name, false)
        end  
add under function OnPlayerCellChange(pid)
	Spectator.SpectatePersist(pid) 
	Spectator.TeleportSpectator(pid)

]]


local Spectator = {}

Spectator.SetPlayerState = function(pid, State)
	local CurrentCell = tes3mp.GetCell(pid)
	tes3mp.InitializeEvent(pid)
	tes3mp.SetEventCell(CurrentCell)
	tes3mp.SetPlayerAsObject(pid)
	tes3mp.AddWorldObject()	
	tes3mp.SetEventConsoleCommand(State)
	tes3mp.SendConsoleCommand(true)
end

Spectator.ToggleSpectate = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if Players[pid].Disabled == true then
			Spectator.SetPlayerState(pid, "enable")
			Players[pid].Disabled = nil
		else
			Spectator.SetPlayerState(pid, "disable")
			Players[pid].Disabled = true
		end
	end
end

Spectator.SpectatePersist = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then 
		if Players[pid].Disabled == true then
			Spectator.SetPlayerState(pid, "disable")
			Players[pid].Disabled = true
		end
	end
end 

Spectator.TeleportSpectator = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if Players[pid] ~= nil and Players[pid].Spectator ~= nil then
			local SpectatorPid = Players[pid].Spectator
			Spectator.TeleportToPlayerSpectate(pid, SpectatorPid, pid)
			Spectator.SpectateTPTimer(pid)
		end 
	end	
end	


Spectator.SpectateTPTimer = function(pid) --Timer for if you want to repeatedly teleport to the spectate target
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if Players[pid].SpectateTimer ~= nil then
			return
		end	
		Players[pid].SpectateTimer = tes3mp.CreateTimerEx("SpectateTeleportEnd", time.seconds(3), "i", pid)
		tes3mp.StartTimer(Players[pid].SpectateTimer)
		
		function SpectateTeleportEnd(pid)
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
				local TargetPid = Players[pid].SpectateTarget
				if Players[TargetPid] ~= nil then
					Spectator.TeleportToPlayerSpectate(pid, pid, TargetPid)
					tes3mp.RestartTimer(Players[pid].SpectateTimer, time.seconds(3))
				else
					Players[pid].SpectateTimer = nil
				end
			end
		end	
	end
end 

Spectator.TeleportToPlayerSpectate = function(pid, originPid, targetPid)

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if (not logicHandler.CheckPlayerValidity(pid, originPid)) or (not logicHandler.CheckPlayerValidity(pid, targetPid)) then
			return
		elseif tonumber(originPid) == tonumber(targetPid) then
			local message = "You can't teleport to yourself.\n"
			tes3mp.SendMessage(pid, message, false)
			return
		end

		local originPlayerName = Players[tonumber(originPid)].name
		local targetPlayerName = Players[tonumber(targetPid)].name
		local targetCell = ""
		local targetCellName
		local targetPos = {0, 0, 0}
		local targetRot = {0, 0}
		local targetGrid = {0, 0}
		targetPos[0] = tes3mp.GetPosX(targetPid)
		targetPos[1] = tes3mp.GetPosY(targetPid)
		targetPos[2] = tes3mp.GetPosZ(targetPid)
		targetRot[0] = tes3mp.GetRotX(targetPid)
		targetRot[1] = tes3mp.GetRotZ(targetPid)
		targetCell = tes3mp.GetCell(targetPid)

		tes3mp.SetCell(originPid, targetCell)
		tes3mp.SendCell(originPid)
		tes3mp.SetPos(originPid, targetPos[0] , targetPos[1] , targetPos[2] + 50)
		tes3mp.SetRot(originPid, targetRot[0], targetRot[1])
		tes3mp.SendPos(originPid)
		Spectator.SpectatePersist(pid)
	end

end

return Spectator 
