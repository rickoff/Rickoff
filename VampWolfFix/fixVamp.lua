--fixVamp.lua by rickoff

--INSTALLATION
--add fixVamp.lua file in mp-stuff/script
--open server.lua and find function OnPlayerCellChange(pid) and a add in :
--fixVamp.tcheckVamp(pid)	
--fixVamp.tcheckWolf(pid)
 
local fixVamp = {}	
	
fixVamp.tcheckVamp = function(pid)	
    local vampireClan
    local consoleTcheckvamp
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		for index, item in pairs(Players[pid].data.spellbook) do
			if tableHelper.containsKeyValue(Players[pid].data.spellbook, "spellId", "vampire berne specials", true) then
				vampireClan = "berne"
			elseif tableHelper.containsKeyValue(Players[pid].data.spellbook, "spellId", "vampire aundae specials", true) then
				vampireClan = "aundae"
			elseif tableHelper.containsKeyValue(Players[pid].data.spellbook, "spellId", "vampire quarra specials", true) then
				vampireClan = "quarra"
			else
				vampireClan = "none"
			end
		end
		if vampireClan ~= "none" then
			consoleTcheckvamp = "set PCVampire to 1"
		else
			consoleTcheckvamp = "set PCVampire to 0"
		end
		myMod.RunConsoleCommandOnPlayer(pid, consoleTcheckvamp)
	end
end

fixVamp.tcheckWolf = function(pid)	
	local playerWolf
	local consoleTcheckwolf
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		for index, item in pairs(Players[pid].data.spellbook) do
			if tableHelper.containsKeyValue(Players[pid].data.spellbook, "spellId", "werewolf blood", true) then
				playerWolf = "true"
			else
				playerWolf = "false"
			end
		end
		if playerWolf ~= "false" then
			consoleTcheckwolf = "set PCWerewolf to 1"
		else
			consoleTcheckwolf = "set PCWerewolf to 0"
		end
		myMod.RunConsoleCommandOnPlayer(pid, consoleTcheckwolf)
	end
end

return fixVamp
