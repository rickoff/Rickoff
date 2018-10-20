--ActivePlayer.lua by Rick-Off, Snapjaw, David.C

--Script version 0.0.2
--Tes3mp version 0.7.0
--OpenMw version 0.44

--Add ActivePlayer.lua in mp-stuff/data/script.

--Find "doesObjectHaveActivatingPlayer" in eventHandler.lua and add directly above :

--					if isObjectPlayer then
--						Players[activatingPid].data.targetPid = objectPid
--						ActivePlayer.OnCheckStatePlayer(objectPid, activatingPid)
--					end

--Open logicHandler.lua and add at the bottom :

--logicHandler.ResurrectPlayer = function(targetPid)
--    tes3mp.Resurrect(tonumber(targetPid), 0)
--end

--Open Menu.lua and add at the bottom :

--Menus["resurrect player"] = {
--    text = color.Gold .. "Voulez vous\n" .. color.LightGreen ..
--    "réanimer\n" .. color.Gold .. "ce joueur ?\n" ..
--        color.White .. "...",
--    buttons = {                        
--        { caption = "oui",
--            destinations = {menuHelper.destinations.setDefault(nil,
--            { 
--                menuHelper.effects.runGlobalFunction("logicHandler", "ResurrectPlayer", 
--                    {menuHelper.variables.currentPlayerDataVariable("targetPid")})
--                })
--            }
--        },            
--        { caption = "non", destinations = nil }
--    }
--}




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
