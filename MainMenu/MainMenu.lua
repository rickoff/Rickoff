--[[
MainMenu by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Script principal Main Menu for manage all script Ecarlate
---------------------------
INSTALLATION:
Save the file as MainMenu.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
MainMenu = require("custom.MainMenu")

Save the file as Menu.lua inside your scripts/menu folder

Edits to config.lua
add in config.menuHelperFiles, "Menu"
---------------------------
]]
local MainMenu = {}

MainMenu.MainMenu = function(pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		Players[pid].currentCustomMenu = "menu player"
		menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
	end
end


customCommandHooks.registerCommand("menu", MainMenu.MainMenu)




