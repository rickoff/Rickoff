TWM.lua

"Team World Match" for TES3MP v0.7.0

    /score
    /stats
    /pelerins
    /renegats
    /temple
    /empire
    /teams

Installation

Download both mwTDM.lua and place them in your .../mp-stuff/scripts/ (WINDOWS) or .../PluginExamples/scripts (LINUX PACKAGE) folder, then read both sections below.
Changes to .../scripts/serverCore.lua

Open the existing serverCore.lua file in the same folder and make the following changes (use CTRL-F or something similar):

Add on the top:

mwTDM = require("mwTDM")

Find function OnServerInit() and add down:

	mwTDM.MatchInit()

Find function OnPlayerDeath(pid) and change like this:

	function OnPlayerDeath(pid)
		tes3mp.LogMessage(enumerations.log.INFO, "Called \"OnPlayerDeath\" for " .. logicHandler.GetChatName(pid))
		--eventHandler.OnPlayerDeath(pid)
		pvpEvent.TcheckKill(pid)	
	end

Find function OnDeathTimeExpiration(pid) and change like this:

	function OnDeathTimeExpiration(pid)
		--eventHandler.OnDeathTimeExpiration(pid)
		mwTDM.OnDeathTimeExpiration(pid)	
	end

Find function OnGUIAction(pid, idGui, data) and change like this:

	function OnGUIAction(pid, idGui, data)
		tes3mp.LogMessage(enumerations.log.INFO, "Called \"OnGUIAction\" for " .. logicHandler.GetChatName(pid))
		--if eventHandler.OnGUIAction(pid, idGui, data) then return end -- if eventHandler.OnGUIAction is called
		if mwTDM.OnGUIAction(pid, idGui, data) then return end
	end

Find OnPlayerCellChange(pid) and change the like this:

	function OnPlayerCellChange(pid)
		tes3mp.LogMessage(enumerations.log.INFO, "Called \"OnPlayerCellChange\" for " .. logicHandler.GetChatName(pid))
		eventHandler.OnPlayerCellChange(pid)
		mwTDM.OnPlayerCellChange(pid)
	end

Find OnPlayerEndCharGen(pid) and change like this:

	function OnPlayerEndCharGen(pid)
		tes3mp.LogMessage(enumerations.log.INFO, "Called \"OnPlayerEndCharGen\" for " .. logicHandler.GetChatName(pid))
		--eventHandler.OnPlayerEndCharGen(pid)
		mwTDM.OnPlayerEndCharGen(pid)	
	end

Open commandHandler.lua and add command text:
			
		elseif cmd[1] == "score" then
			tes3mp.SendMessage(pid, color.Yellow .. "SCORES: \n" .. teamOne .. ": " .. teamOneScore .. "\n" .. teamTwo .. ": " .. teamTwoScore .. "\n" .. teamThree .. ": " .. teamThreeScore .. "\n", false)
		
		elseif cmd[1] == "stats" then
			tes3mp.SendMessage(pid, color.Yellow .. "STATS: \nKills: " .. Players[pid].data.mwTDM.kills .. " | Deaths: " .. Players[pid].data.mwTDM.deaths .. "\nTotal Kills: " .. Players[pid].data.mwTDM.totalKills .. " | Total Deaths " .. Players[pid].data.mwTDM.totalDeaths .. "\n", false)
		
		elseif cmd[1] == "empire" then
			mwTDM.SwitchTeamsEmpire(pid)
			
		elseif cmd[1] == "temple" then
			mwTDM.SwitchTeamsTemple(pid)

		elseif cmd[1] == "renegats" then
			mwTDM.SwitchTeamsRenegats(pid)			

		elseif cmd[1] == "pelerins" then
			mwTDM.SwitchTeamsPelerins(pid)						
		
		elseif cmd[1] == "teams" then
			mwTDM.ListTeams(pid)
