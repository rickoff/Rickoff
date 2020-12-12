--[[
RemoveNpc by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Remove all native npc when player enter in cell
---------------------------
INSTALLATION:
Save the file as RemoveNpc.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
RemoveNpc = require("custom.RemoveNpc")
---------------------------
]]
tableHelper = require("tableHelper")

local config = {}
config.tabCell = {""}--add in list your cell cible
config.tabNpc = {""}--add in list your npc cible if allReset is false
config.allReset = true --if is true all npc in cell is delete, if false npc cible is delete

local RemoveNpc = {}

RemoveNpc.OnActorList = function(eventStatus, pid, cellDescription)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if cellDescription ~= nil then
			local cell = LoadedCells[cellDescription]
			local useTemporaryLoad = false	
			if cell == nil then
				logicHandler.LoadCell(cellDescription)
				useTemporaryLoad = true
				cell = LoadedCells[cellDescription]
			end
			if tableHelper.containsValue(config.tabCell, cellDescription) then
				if config.allReset == true then  			 
					for _, uniqueIndex in pairs(cell.data.packets.actorList) do
						tableHelper.removeValue(cell.data.objectData, uniqueIndex)
						tableHelper.removeValue(cell.data.packets.actorList, uniqueIndex)
						logicHandler.DeleteObjectForEveryone(cellDescription, uniqueIndex)                
					end
				else
					for _, uniqueIndex in pairs(cell.data.packets.actorList) do			
						if tableHelper.containsValue(config.tabNpc, cell.data.objectData[uniqueIndex].refId) then
							tableHelper.removeValue(cell.data.objectData, uniqueIndex)
							tableHelper.removeValue(cell.data.packets.actorList, uniqueIndex)
							logicHandler.DeleteObjectForEveryone(cellDescription, uniqueIndex)   
						end
					end
				end
				cell:SaveToDrive()
			end	
			if useTemporaryLoad == true then
				logicHandler.UnloadCell(cellDescription)
			end
		end
	end
end

customEventHooks.registerHandler("OnActorList", RemoveNpc.OnActorList)

return RemoveNpc
