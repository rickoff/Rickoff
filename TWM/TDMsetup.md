TWM.lua

"Team World Match" for TES3MP v0.6.2.hotfix

    /score
    /stats
    /pelerins
    /renegats
    /temple
    /empire
    /teams

Installation

Download both mwTDM.lua and place them in your .../mp-stuff/scripts/ (WINDOWS) or .../PluginExamples/scripts (LINUX PACKAGE) folder, then read both sections below.
Changes to .../scripts/server.lua

Open the existing server.lua file in the same folder and make the following changes (use CTRL-F or something similar):

Find and change the following:

myMod = require("myMod")

to:

myMod = require("myMod")

mwTDM = require("mwTDM")

Find function OnServerInit() and add down:

	mwTDM.MatchInit()

Find function OnPlayerDeath(pid) and change the following:

	function OnPlayerDeath(pid)
		myMod.OnPlayerDeath(pid)
	end

to:

	function OnPlayerDeath(pid)
		mwTDM.OnPlayerDeath(pid)
		-- myMod.OnPlayerDeath(pid)
	end

Find function OnDeathTimeExpiration(pid) and change the following:

	function OnDeathTimeExpiration(pid)
		myMod.OnDeathTimeExpiration(pid)
	end

to:

	function OnDeathTimeExpiration(pid)
		mwTDM.OnDeathTimeExpiration(pid)
		-- myMod.OnDeathTimeExpiration(pid)
	end

Find function OnGUIAction(pid, idGui, data) and change the following:

	function OnGUIAction(pid, idGui, data)
		if myMod.OnGUIAction(pid, idGui, data) then return end -- if myMod.OnGUIAction is called
	end

to:

	function OnGUIAction(pid, idGui, data)
		if mwTDM.OnGUIAction(pid, idGui, data) then return end
		-- if myMod.OnGUIAction(pid, idGui, data) then return end -- if myMod.OnGUIAction is called
	end

Find OnPlayerCellChange(pid) and change the following:

	function OnPlayerCellChange(pid)
		myMod.OnPlayerCellChange(pid)
	end

to:

	function OnPlayerCellChange(pid)
		mwTDM.OnPlayerCellChange(pid)
		-- myMod.OnPlayerCellChange(pid)
	end

Find OnPlayerEndCharGen(pid) and change the following:

	function OnPlayerEndCharGen(pid)
		myMod.OnPlayerEndCharGen(pid)
	end

to:

	function OnPlayerEndCharGen(pid)
		mwTDM.OnPlayerEndCharGen(pid)
		-- myMod.OnPlayerEndCharGen(pid)
	end

Find the following block:

        elseif (cmd[1] == "greentext" or cmd[1] == "gt") and cmd[2] ~= nil then
            local message = myMod.GetChatName(pid) .. ": " .. color.GreenText .. ">" .. tableHelper.concatenateFromIndex(cmd, 2) .. "\n"
            tes3mp.SendMessage(pid, message, true)

        else
            local message = "Not a valid command. Type /help for more info.\n"
            tes3mp.SendMessage(pid, color.Error..message..color.Default, false)
        end

	return true -- default behavior, chat messages should not
end

and change it to:

        elseif (cmd[1] == "greentext" or cmd[1] == "gt") and cmd[2] ~= nil then
            local message = myMod.GetChatName(pid) .. ": " .. color.GreenText .. ">" .. tableHelper.concatenateFromIndex(cmd, 2) .. "\n"
            tes3mp.SendMessage(pid, message, true)
			
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

        else
            local message = "Not a valid command. Type /help for more info.\n"
            tes3mp.SendMessage(pid, color.Error..message..color.Default, false)
        end

	return true -- default behavior, chat messages should not
end
