--[[
SendKills by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
the death counter is now independent per player
shares the account to players in the same cell at the time of the kill
---------------------------
INSTALLATION:
Save the file as SendKills.lua inside your server/scripts/custom folder

Edits to customScripts.lua
SendKills = require("custom.SendKills")

Edits to config.lua add
config.shareKill = false

Edits to player/base.lua
Replace WorldInstance:LoadKills(self.pid) in function BasePlayer:FinishLogin() to
if config.shareKill == true then
	WorldInstance:LoadKills(self.pid)
else
	self:LoadKill()
end

Replace WorldInstance:LoadKills(self.pid) in function BasePlayer:EndCharGen() to
if config.shareKill == true then
	WorldInstance:LoadKills(self.pid)
else
	self:LoadKill()
end

Add function under function BasePlayer:SaveReputation()
function BasePlayer:LoadKill()
	SendKills.LoadKill(self.pid)
end
---------------------------
FUNCTION:
/resetkills in your chat for reset your kill count
---------------------------
]]
local SendKills = {}

local trad = {}
trad.killreset = "Vos kills ont été réinitialisé !\n"

SendKills.SaveKillsPlayer = function(eventStatus, pid, cellDescription)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
		if LoadedCells[cellDescription] ~= nil then		
			LoadedCells[cellDescription]:SaveActorDeath(pid)			
			local actorIndex = tes3mp.GetActorListSize() - 1			
			if actorIndex ~= nil then			
				local uniqueIndex = tes3mp.GetActorRefNum(actorIndex) .. "-" .. tes3mp.GetActorMpNum(actorIndex)				
				local killerPid = tes3mp.GetActorKillerPid(actorIndex)
				local cell = tes3mp.GetCell(killerPid)				
				if uniqueIndex ~= nil and killerPid ~= nil then					
					if LoadedCells[cellDescription].data.objectData[uniqueIndex] then					
						local ObjectRefid = LoadedCells[cellDescription].data.objectData[uniqueIndex].refId		
						if Players[killerPid] ~= nil then
							if ObjectRefid ~= nil then
								if Players[killerPid].data.kills[ObjectRefid] then
									Players[killerPid].data.kills[ObjectRefid] = Players[killerPid].data.kills[ObjectRefid] + 1
								else
									Players[killerPid].data.kills[ObjectRefid] = 1
								end	
							end
							Players[killerPid]:QuicksaveToDrive()
							SendKills.LoadKill(pid)	
						end
						for pid2, player in pairs(Players) do		
							if Players[pid2] ~= nil and Players[pid2]:IsLoggedIn() and pid2 ~= killerPid then
								local cell2 = tes3mp.GetCell(pid2)
								if cell2 == cell then
									if ObjectRefid ~= nil then
										if Players[pid2].data.kills[ObjectRefid] then
											Players[pid2].data.kills[ObjectRefid] = Players[pid2].data.kills[ObjectRefid] + 1
										else
											Players[pid2].data.kills[ObjectRefid] = 1
										end	
									end
									Players[pid2]:QuicksaveToDrive()
									SendKills.LoadKill(pid2)
								end
							end
						end	
					end
				end
			end
		end
	end	
end

SendKills.PlayerConnect = function(eventStatus, pid)	
    tes3mp.ClearKillChanges(pid)	
	if Players[pid].data.kills == nil then
		Players[pid].data.kills = {}
	else
		for refId, number in pairs(Players[pid].data.kills) do
			if refId ~= nil and refId ~= ""  then
				tes3mp.AddKill(pid, refId, number)
			end
		end
	end	
    tes3mp.SendKillChanges(pid)
end

SendKills.LoadKill = function(pid)
    tes3mp.ClearKillChanges(pid)	
	if Players[pid].data.kills == nil then
		Players[pid].data.kills = {}
	else
		for refId, number in pairs(Players[pid].data.kills) do	
			if refId ~= nil and refId ~= ""  then
				tes3mp.AddKill(pid, refId, number)
			end
		end
	end	
    tes3mp.SendKillChanges(pid)
end

SendKills.ResetKills = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		Players[pid].data.kills = {}
		local message = trad.killreset
		tes3mp.SendMessage(pid, message, false)	
		SendKills.LoadKill(pid)		
	end
end

customEventHooks.registerHandler("OnActorDeath", SendKills.SaveKillsPlayer)
customEventHooks.registerHandler("OnPlayerAuthentified", SendKills.PlayerConnect)
customCommandHooks.registerCommand("resetkills", SendKills.ResetKills)

return SendKills
