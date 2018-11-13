--ActivePlayer.lua by Rick-Off, Snapjaw, David.C

--Script version 0.0.3
--Tes3mp version 0.7.0
--OpenMw version 0.44

--Add ActivePlayer.lua in mp-stuff/script.

--Find "doesObjectHaveActivatingPlayer" in eventHandler.lua and replace by :
--[[

                if doesObjectHaveActivatingPlayer then
                    activatingPid = tes3mp.GetObjectActivatingPid(index)

                    if isObjectPlayer then
                        Players[activatingPid].data.targetPid = objectPid
                        ActivePlayer.OnCheckStatePlayer(objectPid, activatingPid)
                    end

]]--

--Open logicHandler.lua and add at the bottom :
--[[

logicHandler.ResurrectPlayer = function(targetPid)
    tes3mp.Resurrect(tonumber(targetPid), 0)
end

]]--

--Create a file named gameplayMenus.lua in scripts/menu (so it has a clearer name) and make it contain this :
--[[

Menus["resurrect player"] = {
    text = color.Gold .. "Do you want\n" .. color.LightGreen ..
    "revive\n" .. color.Gold .. "this player ?\n" ..
        color.White .. "...",
    buttons = {                        
        { caption = "yes",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
                menuHelper.effects.runGlobalFunction("logicHandler", "ResurrectPlayer", 
                    {menuHelper.variables.currentPlayerDataVariable("targetPid")})
                })
            }
        },            
        { caption = "no", destinations = nil }
    }
}

]]--

--Open config.lua find config.menuHelperFiles and add the name of menu like this :
--config.menuHelperFiles = { "help", "defaultCrafting", "advancedExample", "gameplayMenus" }

ActivePlayer = {}

ActivePlayer.OnCheckStatePlayer = function(objectPid, pid)

	local PlayerActivatedHealth = tes3mp.GetHealthCurrent(objectPid)
	
	if PlayerActivatedHealth <= 0 then
		Players[pid].currentCustomMenu = "resurrect player"--Menu Resurrect
		menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
		tes3mp.LogAppend(enumerations.log.INFO, objectPid)		
	else
		Players[pid].currentCustomMenu = "active player"--other Menu
		menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)				
	end
	
end

return ActivePlayer
