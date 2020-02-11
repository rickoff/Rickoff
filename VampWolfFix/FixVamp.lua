--[[
FixVamp by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Fix Wolf and Vamp
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
		if tableHelper.containsValue(Players[pid].data.spellbook, "vampire attributes", true) then	
			consoleCheck = "set PCVampire to 1"		
		elseif tableHelper.containsValue(Players[pid].data.spellbook, "werewolf blood", true) then			
			consoleCheck = "set PCWerewolf to 1"
		end			
		if consoleCheck ~= nil then
			logicHandler.RunConsoleCommandOnPlayer(pid, consoleCheck)
		end
		
		local consoleCheckClan	
		if tableHelper.containsValue(Players[pid].data.spellbook, "vampire aundae specials", true) then	
			consoleCheckClan = "set VampClan to 1"		
		elseif tableHelper.containsValue(Players[pid].data.spellbook, "vampire berne specials", true) then			
			consoleCheckClan = "set VampClan to 2"
		elseif tableHelper.containsValue(Players[pid].data.spellbook, "vampire quarra specials", true) then			
			consoleCheckClan = "set VampClan to 3"
		end				
		if consoleCheckClan ~= nil then
			logicHandler.RunConsoleCommandOnPlayer(pid, consoleCheckClan)
		end		
	end
end
	
customEventHooks.registerHandler("OnPlayerCellChange", FixVamp.check)

return FixVamp
