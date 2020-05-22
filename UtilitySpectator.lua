--Spectator.lua by rickoff for tes3mp 0.7.0 
--[[
Spectator by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
View Player
---------------------------
INSTALLATION:
Save the file as Spectator.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
Spectator = require("custom.Spectator")
---------------------------
]]
local Spectator = {}

Spectator.OnServerInit = function(eventStatus)
	local spellCustom = jsonInterface.load("recordstore/spell.json")
	local recordStore = RecordStores["spell"]
	
	if not tableHelper.containsValue(spellCustom.permanentRecords, "invisibility_ability") then
		local recordTable = {
		  name = "Invisible",
		  subtype = 1,
		  cost = 0,
		  flags = 0,
		  effects = {{
			  id = 39,
			  attribute = -1,
			  skill = -1,
			  rangeType = 0,
			  area = 0,
			  duration = 1,
			  magnitudeMax = 100,
			  magnitudeMin = 100
			}}
		}
		recordStore.data.permanentRecords["invisibility_ability"] = recordTable
	end	

	if not tableHelper.containsValue(spellCustom.permanentRecords, "levitate") then
		local recordTable = {
		  name = "Levitation",
		  subtype = 0,
		  cost = 0,
		  flags = 0,
		  effects = {}
		}
		recordStore.data.permanentRecords["levitate"] = recordTable
	end	
	
	recordStore:Save()	
end

Spectator.SpectateTPTimer = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and Players[pid]:IsServerStaff() then
		if Players[pid].SpectateTimer == nil then
			Players[pid].SpectateTimer = tes3mp.CreateTimerEx("SpectateTeleportEnd", time.seconds(5), "i", pid)
		end
		tes3mp.StartTimer(Players[pid].SpectateTimer)
		
		function SpectateTeleportEnd(pid)
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
				local TargetPid = Players[pid].SpectateTarget
				if Players[TargetPid] ~= nil then
					Spectator.TeleportToPlayerSpectate(pid, pid, TargetPid)
					tes3mp.RestartTimer(Players[pid].SpectateTimer, time.seconds(5))
				else
					Players[pid].SpectateTimer = nil
				end
			end
		end	
	end
end 

Spectator.ToggleSpectate = function(pid, cmd)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and Players[pid]:IsServerStaff() then
        if Players[pid].SpectateTarget ~= nil then
            local TargetPid = Players[pid].SpectateTarget
            tes3mp.SendMessage(pid, color.Warning.."Ne regarde plus "..Players[TargetPid].name.."\n", false)
			Players[pid].SpectateTarget = nil
        elseif logicHandler.CheckPlayerValidity(pid, cmd[2]) then
            local TargetPid = tonumber(cmd[2])
            Players[TargetPid].Spectator = pid
            Players[pid].SpectateTarget = TargetPid
            tes3mp.SendMessage(pid, color.Warning.."Regarde maintenant "..Players[TargetPid].name.."\n", false)
        end 		
		if Players[pid].Disabled == true then
			logicHandler.RunConsoleCommandOnPlayer(pid, "removespell invisibility_ability", true)
			logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerFighting", false)
			logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerViewSwitch", false)
			logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerMagic", false)
			logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerLooking", false)
			logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerControls", false)
			logicHandler.RunConsoleCommandOnPlayer(pid, "EnableVanityMode", false)
			logicHandler.RunConsoleCommandOnPlayer(pid, "tcl", false)
			logicHandler.RunConsoleCommandOnPlayer(pid, "tgm", false)			
			Players[pid].Disabled = nil
		else
			logicHandler.RunConsoleCommandOnPlayer(pid, "addspell invisibility_ability", true)
			logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerFighting", false)
			logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerViewSwitch", false)
			logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerMagic", false)
			logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerLooking", false)
			logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerControls", false)
			logicHandler.RunConsoleCommandOnPlayer(pid, "DisableVanityMode", false)
			logicHandler.RunConsoleCommandOnPlayer(pid, "PCForce1stPerson", false)	
			logicHandler.RunConsoleCommandOnPlayer(pid, "tcl", false)
			logicHandler.RunConsoleCommandOnPlayer(pid, "tgm", false)			
			Players[pid].Disabled = true
		end
	end
end

Spectator.SpectatePersist = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then 
		if Players[pid].Disabled == true then
			logicHandler.RunConsoleCommandOnPlayer(pid, "addspell invisibility_ability", true)	
			Players[pid].Disabled = true
		end
	end
end 

Spectator.TeleportSpectator = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if Players[pid] ~= nil and Players[pid].SpectateTarget ~= nil then
			local SpectatorPid = Players[pid].SpectateTarget
			Spectator.TeleportToPlayerSpectate(pid, pid, SpectatorPid)
		end 
	end	
end	

Spectator.TeleportToPlayerSpectate = function(pid, originPid, targetPid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if (not logicHandler.CheckPlayerValidity(pid, originPid)) or
			(not logicHandler.CheckPlayerValidity(pid, targetPid)) then
			return
		elseif tonumber(originPid) == tonumber(targetPid) then
			local message = "Vous ne pouvez pas vous téléporter à vous-même.\n"
			tes3mp.SendMessage(pid, message, false)
			return
		end
		local targetCell = ""
		local targetCellName
		local targetPos = {0, 0, 0}
		local targetRot = {0, 0}
		local targetGrid = {0, 0}
		targetPos[0] = tes3mp.GetPosX(targetPid) - 500
		targetPos[1] = tes3mp.GetPosY(targetPid) + 500
		targetPos[2] = tes3mp.GetPosZ(targetPid) + 1000
		targetRot[0] = tes3mp.GetRotX(pid)
		targetRot[1] = tes3mp.GetRotZ(pid)
		targetCell = tes3mp.GetCell(targetPid)
		tes3mp.SetCell(originPid, targetCell)
		tes3mp.SendCell(originPid)
		tes3mp.SetPos(originPid, targetPos[0], targetPos[1], targetPos[2])
		tes3mp.SetRot(originPid, targetRot[0], targetRot[1])
		tes3mp.SendPos(originPid)
	end
end

Spectator.OnPlayerCellChange = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and Players[pid].Spectator ~= nil then
		targetPid = Players[pid].Spectator
		Spectator.SpectatePersist(targetPid) 
		Spectator.TeleportSpectator(targetPid)
	end
end

Spectator.PlayerConnect = function(eventStatus, pid)
	if Players[pid] ~= nil then
		if Players[pid].SpectateTimer then
			Players[pid].SpectateTimer = nil
		end
		if Players[pid].SpectateTarget then
			Players[pid].SpectateTarget = nil
		end	
		if Players[pid].Spectator then
			Players[pid].Spectator = nil
		end
	end
end

customCommandHooks.registerCommand("spectate", Spectator.ToggleSpectate)
customCommandHooks.registerCommand("spectatetimer", Spectator.SpectateTPTimer)
customEventHooks.registerHandler("OnPlayerCellChange", Spectator.OnPlayerCellChange)
customEventHooks.registerHandler("OnServerInit", Spectator.OnServerInit)
customEventHooks.registerHandler("OnPlayerAuthentified", Spectator.PlayerConnect)

return Spectator 
