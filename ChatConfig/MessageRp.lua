--[[
MessageRp by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Script principal for rp message in chat
---------------------------
INSTALLATION:
Save the file as MessageRp.lua inside your server/scripts/custom folder.
Save the file as MenuChat.lua inside your scripts/menu folder.

Edits to customScripts.lua
MessageRp = require("custom.MessageRp")

Edits to config.lua
add in config.menuHelperFiles, "MenuChat"
---------------------------
FUNCTION:
/chat for open menu config chat select your channel
/short before message in your chat for whisper "Cyan" 2 meters
/medium before message in your chat for speak "White" 5 meters
/long before message in your chat for cry "Orange" 10 meters
/global before message in your chat for global "Red" all world
Change the value cfg.rad, actualy: 500 ~ 5 meters
---------------------------
]]

local Methods = {}

local cfg = {}
cfg.rad = 500

Methods.MainMenu = function(pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		Players[pid].currentCustomMenu = "menu chat"
		menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
	end
end

Methods.OnPlayerSendMessage = function(eventStatus, pid, message)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then 
		local chat = Players[pid].data.customVariables.chat
		if message:sub(1, 1) == '/' then	
		else
			local message1 = color.Grey .. logicHandler.GetChatName(pid) .. color.White .. " : " .. message .. "\n"		
			if chat == "global" then
				message1 = color.Grey .. logicHandler.GetChatName(pid) .. color.Red .. " : [Global] : " .. message .. "\n"	
			elseif chat == "short" then
				message1 = color.Grey .. logicHandler.GetChatName(pid) .. color.Cyan .. " : [Whispers] : " .. message .. "\n"	
			elseif chat == "medium" then
				message1 = color.Grey .. logicHandler.GetChatName(pid) .. color.White .. " : [Speak] : " .. message .. "\n"
			elseif chat == "long" then
				message1 = color.Grey .. logicHandler.GetChatName(pid) .. color.Orange .. " : [Scream] : " .. message .. "\n"
			end		

			if Players[pid]:IsServerStaff() then 
				if Players[pid]:IsServerOwner() then
					message1 = config.rankColors.serverOwner .. "[Adm] " .. message1
				elseif Players[pid]:IsAdmin() then
					message1 = config.rankColors.admin .. "[Adm] " .. message1
				elseif Players[pid]:IsModerator() then
					message1 = config.rankColors.moderator .. "[Mod] " .. message1
				end
			end	
			if chat == "global" then
				tes3mp.SendMessage(pid, message1, true)
			elseif chat == "short" then
				Methods.SendLocalMessage(pid, message1, "short")
			elseif chat == "medium" then
				Methods.SendLocalMessage(pid, message1, "medium")
			elseif chat == "long" then
				Methods.SendLocalMessage(pid, message1, "long")
			end
			return customEventHooks.makeEventStatus(false,false)	
		end		
	end
end

Methods.SendLocalMessage = function(pid, message, state)
	local playerName = Players[pid].name
	local localChatCellRadius = 1	
	local myCellDescription = Players[pid].data.location.cell	
	if tes3mp.IsInExterior(pid) == true then
		local cellX = tonumber(string.sub(myCellDescription, 1, string.find(myCellDescription, ",") - 1))
		local cellY = tonumber(string.sub(myCellDescription, string.find(myCellDescription, ",") + 2))		
		local firstCellX = cellX - localChatCellRadius
		local firstCellY = cellY + localChatCellRadius		
		local length = localChatCellRadius * 2	
		for x = 0, length, 1 do
			for y = 0, length, 1 do
				local tempCell = (x+firstCellX)..", "..(firstCellY-y)
				if LoadedCells[tempCell] ~= nil then
					SendMessageToAllInCell(pid, tempCell, message, state)
				end
			end
		end
	else
		SendMessageToAllInCell(pid, myCellDescription, message, state)
	end
end

function SendMessageToAllInCell(pidcible, cellDescription, message, state)
	local mult = 1
	if state == "short" then
		mult = 2	
	elseif state == "medium" then
		mult = 1	
	elseif state == "long" then	
		mult = 0.5
	end
	local playerPosX = tes3mp.GetPosX(pidcible)
	local playerPosY = tes3mp.GetPosY(pidcible)
	local playerPosZ = tes3mp.GetPosZ(pidcible)		
	for index,pid in pairs(LoadedCells[cellDescription].visitors) do
		if Players[pid].data.location.cell == cellDescription then
			local pPosX = tes3mp.GetPosX(pid)
			local pPosY = tes3mp.GetPosY(pid)
			local pPosZ = tes3mp.GetPosZ(pid)	
			local distance = math.sqrt((playerPosX - pPosX) * (playerPosX - pPosX) + (playerPosY - pPosY) * (playerPosY - pPosY)) 
			if distance < (cfg.rad / mult) then
				tes3mp.SendMessage(pid, message, false)
			end
		end
	end
end

Methods.CheckVariables = function(eventStatus, pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then 
		if Players[pid].data.customVariables.chat == nil then
			Players[pid].data.customVariables.chat = "medium"
		end
	end
end

Methods.customVariableShort = function(pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then 
		Players[pid].data.customVariables.chat = "short"
		local message = color.Cyan .. "[Channel whisper]\n"
		tes3mp.SendMessage(pid, message, false)
	end
end

Methods.customVariableMedium = function(pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then 
		Players[pid].data.customVariables.chat = "medium"
		local message = color.White .. "[Channel speak]\n"
		tes3mp.SendMessage(pid, message, false)		
	end
end

Methods.customVariableLong = function(pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then 
		Players[pid].data.customVariables.chat = "long"
		local message = color.Orange .. "[Channel scream]\n"
		tes3mp.SendMessage(pid, message, false)		
	end
end

Methods.customVariableGlobal = function(pid)
	Players[pid].data.customVariables.chat = "global"
		local message = color.Red .. "[Channel global]\n"
		tes3mp.SendMessage(pid, message, false)	
end

customEventHooks.registerHandler("OnPlayerAuthentified", Methods.CheckVariables)
customCommandHooks.registerCommand("chat", Methods.MainMenu)
customEventHooks.registerValidator("OnPlayerSendMessage", Methods.OnPlayerSendMessage)
customCommandHooks.registerCommand("short", Methods.customVariableShort)
customCommandHooks.registerCommand("medium", Methods.customVariableMedium)
customCommandHooks.registerCommand("long", Methods.customVariableLong)
customCommandHooks.registerCommand("global", Methods.customVariableGlobal)

return Methods
