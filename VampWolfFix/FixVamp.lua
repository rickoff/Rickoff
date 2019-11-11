--[[
FixVamp by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Corige un bug lié a la detection des vampires et loupgarou
---------------------------
INSTALLATION:
Save the file as FixVamp.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
FixVamp = require("custom.FixVamp")
---------------------------
]]

local FixVamp = {}	
	
FixVamp.checkVamp = function(pid)	

    local consoleTcheckvamp
	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		for slot, k in pairs(Players[pid].data.spellbook) do
			if Players[pid].data.spellbook[slot] == "vampire sun damage" then
				consoleTcheckvamp = "set PCVampire to 1"
				logicHandler.RunConsoleCommandOnPlayer(pid, consoleTcheckvamp)				
			end
		end	
	end
end

FixVamp.checkWolf = function(pid)	

	local consoleTcheckwolf
	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		for slot, k in pairs(Players[pid].data.spellbook) do
			if Players[pid].data.spellbook[slot] == "werewolf blood" then
				consoleTcheckwolf = "set PCWerewolf to 1"
				logicHandler.RunConsoleCommandOnPlayer(pid, consoleTcheckwolf)	
			end
		end		
	end
end

customEventHooks.registerHandler("OnPlayerCellChange", FixVamp.checkVamp)
customEventHooks.registerHandler("OnPlayerCellChange", FixVamp.checkWolf)

return FixVamp
