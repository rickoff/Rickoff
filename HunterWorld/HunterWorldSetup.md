INSTALLATION

1) Save this file as "HunterWorld.lua" in mp-stuff/scripts
CreaturesVanilla.json and CreatureSpawn.json in mpstuff/data

2) Add [HunterWorld = require("HunterWorld")] to the top of serverCore.lua

3) Find "function OnServerInit()" inside serverCore.lua and add at the end
		HunterWorld.TimerEventWorld()	

4) Find function OnPlayerCellChange(pid) in serverCore.lua and add this at the end
		HunterWorld.OnPlayerChangeCell(pid)

5) Find function eventHandler.OnActorDeath in eventHandler.lua and change like this:

		eventHandler.OnActorDeath = function(pid, cellDescription)
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
				if LoadedCells[cellDescription] ~= nil then
					LoadedCells[cellDescription]:SaveActorDeath(pid)
					local actorIndex = tes3mp.GetActorListSize() - 1
					if actorIndex ~= nil then
						local uniqueIndex = tes3mp.GetActorRefNum(actorIndex) .. "-" .. tes3mp.GetActorMpNum(actorIndex)
						local killerPid = tes3mp.GetActorKillerPid(actorIndex)
						if uniqueIndex ~= nil and killerPid ~= nil then
							if LoadedCells[cellDescription].data.objectData[uniqueIndex] then
								local creaRefId = LoadedCells[cellDescription].data.objectData[uniqueIndex].refId
								if creaRefId ~= nil then
									if tes3mp.DoesActorHavePlayerKiller(actorIndex) then
										HunterWorld.HunterPrime(killerPid, creaRefId)
									end
								end
							end
						end
					end
				else
					tes3mp.LogMessage(enumerations.log.WARN, "Undefined behavior: " .. logicHandler.GetChatName(pid) ..
						" sent ActorDeath for unloaded " .. cellDescription)
				end
			end
		end

6) Find function eventHandler.OnObjectSpawn in eventHandler.lua and change like this:

		eventHandler.OnObjectSpawn = function(pid, cellDescription)
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
					-- Iterate through the objects in the ObjectSpawn packet and only sync and save them
					-- if all their refIds are valid
					local isValid = true
					local rejectedObjects = {}

					for index = 0, tes3mp.GetObjectListSize() - 1 do

						local refId = tes3mp.GetObjectRefId(index)
						local uniqueIndex = tes3mp.GetObjectRefNum(index) .. "-" .. tes3mp.GetObjectMpNum(index)
						local location = {
							posX = tes3mp.GetObjectPosX(index),
							posY = tes3mp.GetObjectPosY(index),
							posZ = tes3mp.GetObjectPosZ(index),
							rotX = tes3mp.GetObjectRotX(index),
							rotY = tes3mp.GetObjectRotY(index),
							rotZ = tes3mp.GetObjectRotZ(index)
						}
						HunterWorld.OnCreatureSpawn(pid, refId, cellDescription, location.posX, location.posY, location.posZ) 
						if tableHelper.containsValue(config.disallowedCreateRefIds, refId) then
							table.insert(rejectedObjects, refId .. " " .. uniqueIndex)
							isValid = false
						end				
					end

					if isValid == true then
						LoadedCells[cellDescription]:SaveObjectsSpawned(pid)
						tes3mp.CopyReceivedObjectListToStore()
						-- Objects can't be spawned clientside without the server's approval, so we send
						-- the packet to other players and also back to the player who sent it,
						-- i.e. sendToOtherPlayers is true and skipAttachedPlayer is false
						tes3mp.SendObjectSpawn(true, false)			
					else
						tes3mp.LogMessage(enumerations.log.INFO, "Rejected ObjectSpawn from " .. logicHandler.GetChatName(pid) ..
							" about " .. tableHelper.concatenateArrayValues(rejectedObjects, 1, ", "))
					end
				else
					tes3mp.LogMessage(enumerations.log.WARN, "Undefined behavior: " .. logicHandler.GetChatName(pid) ..
						" sent ObjectSpawn for unloaded " .. cellDescription)
				end
			else
				tes3mp.Kick(pid)
			end
		end
