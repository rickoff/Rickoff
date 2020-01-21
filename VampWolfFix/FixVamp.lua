--[[
FixVamp by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Corrige un bug lié a la detection des vampires et loupgarou
---------------------------
INSTALLATION:
Save the file as FixVamp.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
FixVamp = require("custom.FixVamp")
---------------------------
]]
tableHelper = require("tableHelper")

local FixVamp = {}	
	
FixVamp.check = function(eventStatus, pid)	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local consoleCheck	
		if tableHelper.containsValue(Players[pid].data.spellbook, "vampire sun damage", true) then	
			consoleCheck = "set PCVampire to 1"		
		elseif tableHelper.containsValue(Players[pid].data.spellbook, "werewolf blood", true) then			
			consoleCheck = "set PCWerewolf to 1"
		end			
		if consoleCheck ~= nil then
			logicHandler.RunConsoleCommandOnPlayer(pid, consoleCheck)
		end
	end
end

customEventHooks.registerHandler("OnPlayerCellChange", FixVamp.check)

return FixVamp
