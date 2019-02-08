--[[SETUP
--add ProtectCell.lua in mpstuff/script
--open servercore.lua add to the top ProtectCell = require("ProtectCell")
--find function OnPlayerCellChange and add ProtectCell.CheckCell(pid)
]]

local config = {}
config.listCell = {"Longsanglot, palais royal : salle du trône" , "Jarvik, Ruine, Arkay", "Elokiel, donjon de verre"}
config.Teleporting = true
config.Levitation = true
config.PlayerJumping = true
config.PlayerFighting = false
config.PlayerLooking = false
config.PlayerMagic = false
config.PlayerViewSwitch = false
config.VanityMode = false

local ProtectCell = {}

ProtectCell.CheckCell = function(pid)
	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then    
    
		local cell = tes3mp.GetCell(pid)
		local BlockCurrent 
		
		if Players[pid].data.customVariables.Block == nil then
			Players[pid].data.customVariables.Block = false		
			BlockCurrent = Players[pid].data.customVariables.Block
		else
			BlockCurrent = Players[pid].data.customVariables.Block
		end	
		
		if tableHelper.containsValue(config.listCell, cell) and BlockCurrent == false then
			if config.Teleporting == true then logicHandler.RunConsoleCommandOnPlayer(pid, "DisableTeleporting") end
			if config.Levitation == true then logicHandler.RunConsoleCommandOnPlayer(pid, "DisableLevitation") end
			if config.PlayerFighting == true then logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerFighting") end
			if config.PlayerJumping == true then logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerJumping") end
			if config.PlayerLooking == true then logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerLooking") end
			if config.PlayerMagic == true then logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerMagic") end
			if config.PlayerViewSwitch == true then logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerViewSwitch") end
			if config.VanityMode == true then logicHandler.RunConsoleCommandOnPlayer(pid, "DisableVanityMode") end		
			Players[pid].data.customVariables.Block = true
			
		elseif not tableHelper.containsValue(config.listCell, cell) and BlockCurrent == true then
			if config.Teleporting == true then logicHandler.RunConsoleCommandOnPlayer(pid, "EnableTeleporting") end
			if config.Levitation == true then logicHandler.RunConsoleCommandOnPlayer(pid, "EnableLevitation") end
			if config.PlayerFighting == true then logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerFighting") end
			if config.PlayerJumping == true then logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerJumping") end
			if config.PlayerLooking == true then logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerLooking") end
			if config.PlayerMagic == true then logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerMagic") end
			if config.PlayerViewSwitch == true then logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerViewSwitch") end
			if config.VanityMode == true then logicHandler.RunConsoleCommandOnPlayer(pid, "EnableVanityMode") end					
			Players[pid].data.customVariables.Block = false 	
		end	
	end   	
end

return ProtectCell
