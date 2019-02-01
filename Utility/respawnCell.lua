--respawnCell.lua by Rick-Off for tes3mp 0.7

--[[ SETUP

1) place respawnCell.lua in mpstuff/script folder

2) open eventHandler and replace OnObjectDelete like this :


eventHandler.OnObjectDelete = function(pid, cellDescription)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		
        tes3mp.ReadReceivedObjectList()
        local packetOrigin = tes3mp.GetObjectListOrigin()
        tes3mp.LogAppend(enumerations.log.INFO, "- packetOrigin was " ..
            tableHelper.getIndexByValue(enumerations.packetOrigin, packetOrigin))

        if logicHandler.IsPacketFromConsole(packetOrigin) and not logicHandler.IsPlayerAllowedConsole(pid) then
            tes3mp.Kick(pid)
            tes3mp.SendMessage(pid, logicHandler.GetChatName(pid) .. consoleKickMessage, true)
            return
        end

        if LoadedCells[cellDescription] ~= nil then

            -- Iterate through the objects in the ObjectDelete packet and only sync and save them
            -- if all their refIds are valid
            local isValid = true
            local rejectedObjects = {}
			local listIndexActor = {}			
            local unusableContainerUniqueIndexes = LoadedCells[cellDescription].unusableContainerUniqueIndexes
			for index = 0, tes3mp.GetObjectListSize() - 1 do

				local refId = tes3mp.GetObjectRefId(index)
				local uniqueIndex = tes3mp.GetObjectRefNum(index) .. "-" .. tes3mp.GetObjectMpNum(index)	
				for x, index in pairs(LoadedCells[cellDescription].data.packets.actorList) do
					local refIndex = LoadedCells[cellDescription].data.packets.actorList[x]			
					table.insert(listIndexActor, refIndex)
				end
				if tableHelper.containsValue(config.disallowedDeleteRefIds, refId) or
					tableHelper.containsValue(unusableContainerUniqueIndexes, uniqueIndex) or
					tableHelper.containsValue(listIndexActor, uniqueIndex) then
					table.insert(rejectedObjects, refId .. " " .. uniqueIndex)
					isValid = false
				end
			end
			
            if isValid then
                LoadedCells[cellDescription]:SaveObjectsDeleted(pid)

                tes3mp.CopyReceivedObjectListToStore()
                -- Objects can sometimes be deleted clientside without the server's approval and
                -- sometimes not, but we should always send ObjectDelete packets back to the sender
                -- for the sake of the latter situations
                -- i.e. sendToOtherPlayers is true and skipAttachedPlayer is false
                tes3mp.SendObjectDelete(true, false)
            else
                tes3mp.LogMessage(enumerations.log.INFO, "Rejected ObjectDelete from " .. logicHandler.GetChatName(pid) ..
                    " about " .. tableHelper.concatenateArrayValues(rejectedObjects, 1, ", "))
            end

        else
            tes3mp.LogMessage(enumerations.log.WARN, "Undefined behavior: " .. logicHandler.GetChatName(pid) ..
                " sent ObjectDelete for unloaded " .. cellDescription)
        end
    else
        tes3mp.Kick(pid)
    end
end


3) open servercore.lua add respawnCell = require("respawnCell")

4) open servercore.lua find function OnPlayerCellChange(pid) and add a last line respawnCell.OnPlayerChangeCell(pid)
]] 
local respawnCell = {}

local config = {}
config.timerRespawn = 1800

respawnCell.OnPlayerChangeCell = function(pid) 
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local cellId = tes3mp.GetCell(pid)
		local cell = LoadedCells[cellId]
        local Time = os.time()	
		local tempCell = cell.data.entry.creationTime
		if tempCell ~= nil then
			local calculTime = Time - tempCell		
			if cell ~= nil then		
				if calculTime > config.timerRespawn then				
					for x, index in pairs(cell.data.packets.actorList) do
						local refIndex = cell.data.packets.actorList[x]
						if refIndex ~= nil then
							if cell.data.objectData[refIndex] then
								local refId = cell.data.objectData[refIndex].refId
								if cell.data.objectData[refIndex].stats then
									local state = cell.data.objectData[refIndex].stats.healthCurrent							
									if cell.data.objectData[refIndex].location then
										local location = {
											posX = cell.data.objectData[refIndex].location.posX,
											posY = cell.data.objectData[refIndex].location.posY,
											posZ = cell.data.objectData[refIndex].location.posZ
										}
										local position = { posX = location.posX, posY = location.posY, posZ = location.posZ, rotX = 0, rotY = 0, rotZ = 0 }
										if state == 0 then								
											cell.data.packets.actorList[refIndex] = nil
											tableHelper.removeValue(cell.data.packets.actorList, refIndex)
											logicHandler.DeleteObjectForEveryone(cellId, refIndex)											
											logicHandler.CreateObjectAtLocation(cellId, position, refId, "spawn") 
										end
									end
								end
							end
						end
					end									
					cell.data.entry.creationTime = os.time()
					cell:Save()
				end
			end	
		end
	end
end

return respawnCell
