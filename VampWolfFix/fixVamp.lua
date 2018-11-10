--fixVamp.lua by rickoff

--INSTALLATION
--add fixVamp.lua file in mp-stuff/script
--open serverCore.lua and find function OnPlayerCellChange(pid) and a add in :
--fixVamp.tcheckVamp(pid)	
--fixVamp.tcheckWolf(pid)

local fixVamp = {}	
	
fixVamp.tcheckVamp = function(pid)	

    local consoleTcheckvamp
	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		for slot, k in pairs(Players[pid].data.spellbook) do
			if Players[pid].data.spellbook[slot] == "vampire berne specials" then
				consoleTcheckvamp = "set PCVampire to 1"
				logicHandler.RunConsoleCommandOnPlayer(pid, consoleTcheckvamp)	
			elseif Players[pid].data.spellbook[slot] == "vampire aundae specials" then
				consoleTcheckvamp = "set PCVampire to 1"
				logicHandler.RunConsoleCommandOnPlayer(pid, consoleTcheckvamp)	
			elseif Players[pid].data.spellbook[slot] == "vampire quarra specials" then
				consoleTcheckvamp = "set PCVampire to 1"
				logicHandler.RunConsoleCommandOnPlayer(pid, consoleTcheckvamp)					
			end
		end	
	end
end

fixVamp.tcheckWolf = function(pid)	

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

return fixVamp
