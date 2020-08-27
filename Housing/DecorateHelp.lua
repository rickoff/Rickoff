--[[
DecorateHelp by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Positionner des objets dans l'espace
---------------------------
INSTALLATION:
Save the file as DecorateHelp.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
DecorateHelp = require("custom.DecorateHelp")
---------------------------
]]
tableHelper = require("tableHelper")
------
local config = {}
config.MainId = 31360
config.PromptId = 31361
------
local trad = {}
trad.prompt = "] - Entrez un nombre à ajouter / soustraire"
trad.rotx = "Rotation X"
trad.roty = "Rotation Y"
trad.rotz = "Rotation Z"
trad.movn = "+/- Nord"
trad.move = "+/- Est"
trad.movup = "+/- Hauteur"
trad.up = "Monter"
trad.down = "Descendre"
trad.east = "Est"
trad.west = "Ouest" 
trad.north = "Nord"
trad.sud = "Sud"
trad.bigger = "Agrandir"
trad.lower = "Réduire"
trad.drop = "Attraper"
trad.noselect = "Aucun objet sélectionné."
trad.nooption = "Objet impossible à modifier."
trad.placeobjet = "L'objet vient d'être placé."
trad.warningcell = "Attention l'objet sort de la zone !!!"
trad.info = "Pour poser l'objet passez en mode discretion.\nPour faire pivoter sortez votre arme ou votre magie."
trad.opt1 = "Choisir une option. Votre article actuel: "
trad.opt2 = "Ajuster le Nord;Ajuster l'est;Ajuster la hauteur;Tourner X;Tourner Y;Tourner Z;Monter;Descendre;Est;Ouest;Nord;Sud;Agrandir;Réduire;Attraper;Fermer"
------

local TimerDrop = tes3mp.CreateTimer("StartDrop", time.seconds(0.01))
local playerSelectedObject = {}
local playerCurrentMode = {}
local playersTab = { player = {} }

local Methods = {}

function StartDrop()	
	for pid, value in pairs(playersTab.player) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			local namep = playersTab.player[pid].name
			for pid1, value in pairs(Players) do	
				if Players[pid1] ~= nil and Players[pid1]:IsLoggedIn() then			
					local name = Players[pid1].name
					if name == namep then
						Methods.moveObject(pid1)
					end
				end
			end
		end
	end
end

local function getObject(refIndex, cell)
	if refIndex == nil then
		return false
	end

	if LoadedCells[cell]:ContainsObject(refIndex) then 
		return LoadedCells[cell].data.objectData[refIndex]
	else
		return false
	end	
end

local function resendPlaceToAll(refIndex, cell)
	local object = getObject(refIndex, cell)
	local refId = object.refId
	local count = object.count or 1
	local charge = object.charge or -1
	local posX, posY, posZ = object.location.posX, object.location.posY, object.location.posZ
	local rotX, rotY, rotZ = object.location.rotX, object.location.rotY, object.location.rotZ
	local scale = object.scale

	local refIndex = refIndex
	
	local inventory = object.inventory or nil
	
	local splitIndex = refIndex:split("-")

	for pid, pdata in pairs(Players) do
		if Players[pid]:IsLoggedIn() then
			--First, delete the original
			tes3mp.InitializeEvent(pid)
			tes3mp.SetEventCell(cell)
			tes3mp.SetObjectRefNumIndex(0)
			tes3mp.SetObjectMpNum(splitIndex[2])
			tes3mp.AddWorldObject() --?
			tes3mp.SendObjectDelete()
			
			--Now remake it
			tes3mp.InitializeEvent(pid)
			tes3mp.SetEventCell(cell)
			tes3mp.SetObjectRefId(refId)
			tes3mp.SetObjectCount(count)
			tes3mp.SetObjectCharge(charge)
			tes3mp.SetObjectPosition(posX, posY, posZ)
			tes3mp.SetObjectRotation(rotX, rotY, rotZ)
			tes3mp.SetObjectScale(scale)
			tes3mp.SetObjectRefNumIndex(0)
			tes3mp.SetObjectMpNum(splitIndex[2])
			if inventory then
				for itemIndex, item in pairs(inventory) do
					tes3mp.SetContainerItemRefId(item.refId)
					tes3mp.SetContainerItemCount(item.count)
					tes3mp.SetContainerItemCharge(item.charge)

					tes3mp.AddContainerItem()
				end
			end
			
			tes3mp.AddWorldObject()
			tes3mp.SendObjectPlace()
			tes3mp.SendObjectScale()
			if inventory then
				tes3mp.SendContainer()
			end
		end
	end
	if WorldMining then
		if WorldInstance.data.customVariables.WorldMining.placed[cell] then
			if WorldInstance.data.customVariables.WorldMining.placed[cell][refIndex] then
				WorldInstance.data.customVariables.WorldMining.placed[cell][refIndex]["loc"] = object.location
				WorldInstance:QuicksaveToDrive()
			end
		end
	end
	if EcarlateFurniture then
		if WorldInstance.data.customVariables.EcarlateFurniture.placed[cell] then	
			if WorldInstance.data.customVariables.EcarlateFurniture.placed[cell][refIndex] then
				WorldInstance.data.customVariables.EcarlateFurniture.placed[cell][refIndex]["loc"] = object.location
				WorldInstance:QuicksaveToDrive()
			end	
		end
	end
	LoadedCells[cell]:QuicksaveToDrive()
end


local function showPromptGUI(pid)
	local message = "[" .. playerCurrentMode[tes3mp.GetName(pid)] .. trad.prompt

	tes3mp.InputDialog(pid, config.PromptId, message, "")
end

local function onEnterPrompt(pid, data)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local cell = tes3mp.GetCell(pid)
		local pname = tes3mp.GetName(pid)
		local mode = playerCurrentMode[pname]
		local data = tonumber(data) or 0
		local object = getObject(playerSelectedObject[pname], cell)
		local cellSize = 8192	
		local checkPosSafe = true	
		if not object then
			tes3mp.MessageBox(pid, -1, trad.noselect)		
			return false
		else
			local scaling = object.scale	
			if mode == trad.rotx then
				local curDegrees = math.deg(object.location.rotX)
				local newDegrees = (curDegrees + data) % 360
				object.location.rotX = math.rad(newDegrees)
			elseif mode == trad.roty then
				local curDegrees = math.deg(object.location.rotY)
				local newDegrees = (curDegrees + data) % 360
				object.location.rotY = math.rad(newDegrees)
			elseif mode == trad.rotz then
				local curDegrees = math.deg(object.location.rotZ)
				local newDegrees = (curDegrees + data) % 360
				object.location.rotZ = math.rad(newDegrees)
			elseif mode == trad.movn then
				object.location.posY = object.location.posY + data
			elseif mode == trad.move then
				object.location.posX = object.location.posX + data
			elseif mode == trad.movup then
				object.location.posZ = object.location.posZ + data
			elseif mode == trad.up then
				object.location.posZ = object.location.posZ + 10
			elseif mode == trad.down then
				object.location.posZ = object.location.posZ - 10
			elseif mode == trad.east then
				object.location.posX = object.location.posX + 10
			elseif mode == trad.west then
				object.location.posX = object.location.posX - 10
			elseif mode == trad.north then
				object.location.posY = object.location.posY + 10
			elseif mode == trad.sud then
				object.location.posY = object.location.posY - 10
			elseif mode == trad.bigger then
				if scaling ~= nil then
					if scaling < 2 then
						object.scale = object.scale + 0.1
					else
						object.scale = object.scale
					end
				else
					tes3mp.MessageBox(pid, -1, trad.nooption)		
				end
			elseif mode == trad.lower then
				if scaling ~= nil then
					if scaling > 0.1 then
						object.scale = object.scale - 0.1
					else
						object.scale = object.scale
					end
				else
					tes3mp.MessageBox(pid, -1, trad.nooption)		
				end		
			elseif mode == "return" then
				object.location.posY = object.location.posY		
				return
			end
		end

		if tes3mp.IsInExterior(pid) then
			local correctGridX = math.floor(object.location.posX / cellSize)
			local correctGridY = math.floor(object.location.posY / cellSize)
			if LoadedCells[cell].gridX ~= correctGridX or LoadedCells[cell].gridY ~= correctGridY then
				checkPosSafe = false
			end
		end
		if checkPosSafe == true then		
			resendPlaceToAll(playerSelectedObject[pname], cell)
		else
			tes3mp.MessageBox(pid, -1, trad.warningcell)
		end
	end
end

local function showMainGUI(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		--Determine if the player has an item
		local currentItem = "None" --default
		local selected = playerSelectedObject[tes3mp.GetName(pid)]
		local object = getObject(selected, tes3mp.GetCell(pid))
		
		if selected and object then --If they have an entry and it isn't gone
			currentItem = object.refId .. " (" .. selected .. ")"
		end
		
		local message = trad.opt1 .. currentItem
		tes3mp.CustomMessageBox(pid, config.MainId, message, trad.opt2)
	end
end

local function setSelectedObject(pid, refIndex)
	playerSelectedObject[tes3mp.GetName(pid)] = refIndex
end

Methods.StartDropTimer = function()
	tes3mp.StartTimer(TimerDrop)
end

Methods.SetSelectedObject = function(pid, refIndex)
	setSelectedObject(pid, refIndex)
end

Methods.OnObjectPlace = function(eventStatus, pid, cellDescription)
	--Get the last event, which should hopefully be the place packet
	tes3mp.ReadLastEvent()
	
	--Get the refIndex of the first item in the object place packet (in theory, there should only by one)
	local refIndex = tes3mp.GetObjectRefNumIndex(0) .. "-" .. tes3mp.GetObjectMpNum(0)
	
	--Record that item as the last one the player interacted with in this cell
	setSelectedObject(pid, refIndex)
end

Methods.OnGUIAction = function(pid, idGui, data)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local pname = tes3mp.GetName(pid)
		
		if idGui == config.MainId then
			if tonumber(data) == 0 then --Move North
				playerCurrentMode[pname] = trad.movn
				showPromptGUI(pid)
				return true
			elseif tonumber(data) == 1 then --Move East
				playerCurrentMode[pname] = trad.move
				showPromptGUI(pid)
				return true
			elseif tonumber(data) == 2 then --Move Up
				playerCurrentMode[pname] = trad.movup
				showPromptGUI(pid)
				return true
			elseif tonumber(data) == 3 then --Rotate X
				playerCurrentMode[pname] = trad.rotx
				showPromptGUI(pid)
				return true
			elseif tonumber(data) == 4 then --Rotate Y
				playerCurrentMode[pname] = trad.roty
				showPromptGUI(pid)
				return true
			elseif tonumber(data) == 5 then --Rotate Z
				playerCurrentMode[pname] = trad.rotz
				showPromptGUI(pid)
				return true
			elseif tonumber(data) == 6 then --Monter
				playerCurrentMode[pname] = trad.up
				onEnterPrompt(pid, 0)			
				return true, showMainGUI(pid)
			elseif tonumber(data) == 7 then --Descendre
				playerCurrentMode[pname] = trad.down
				onEnterPrompt(pid, 0)			
				return true, showMainGUI(pid)
			elseif tonumber(data) == 8 then --Est
				playerCurrentMode[pname] = trad.east
				onEnterPrompt(pid, 0)			
				return true, showMainGUI(pid)	
			elseif tonumber(data) == 9 then --Ouest
				playerCurrentMode[pname] = trad.west
				onEnterPrompt(pid, 0)			
				return true, showMainGUI(pid)
			elseif tonumber(data) == 10 then --Nord
				playerCurrentMode[pname] = trad.north
				onEnterPrompt(pid, 0)			
				return true, showMainGUI(pid)
			elseif tonumber(data) == 11 then --Sud
				playerCurrentMode[pname] = trad.sud
				onEnterPrompt(pid, 0)
				return true, showMainGUI(pid)
			elseif tonumber(data) == 12 then --Agrandir
				playerCurrentMode[pname] = trad.bigger
				onEnterPrompt(pid, 0)			
				return true, showMainGUI(pid)
			elseif tonumber(data) == 13 then --Reduire
				playerCurrentMode[pname] = trad.lower
				onEnterPrompt(pid, 0)
				return true, showMainGUI(pid)	
			elseif tonumber(data) == 14 then --Attraper
				playersTab.player[pid] = {name = Players[pid].name}
				tes3mp.MessageBox(pid, -1, trad.info)	
				Methods.StartDropTimer()
				return true				
			elseif tonumber(data) == 15 then --Close
				--Do nothing
				return true
			end
		elseif idGui == config.PromptId then
			if data ~= nil and data ~= "" and tonumber(data) then
				onEnterPrompt(pid, data)
			end
			
			playerCurrentMode[tes3mp.GetName(pid)] = nil
			return true, showMainGUI(pid)
		end
	end
end

Methods.moveObject = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
		local cellSize = 8192	
		local cell = tes3mp.GetCell(pid)
		local pname = tes3mp.GetName(pid)
		local object = getObject(playerSelectedObject[pname], cell)	
		local drawState = tes3mp.GetDrawState(pid)
		if not object then
			tes3mp.MessageBox(pid, -1, trad.noselect)	
			return false
		else
			local playerAngleZ = tes3mp.GetRotZ(pid)
			if playerAngleZ > 3.0 then
				playerAngleZ = 3.0
			elseif playerAngleZ < -3.0 then
				playerAngleZ = -3.0
			end
			local playerAngleX = tes3mp.GetRotX(pid)
			if playerAngleX > 1.5 then
				playerAngleX = 1.5
			elseif playerAngleX < -1.5 then
				playerAngleX = -1.5
			end			
			local PosX = (200 * math.sin(playerAngleZ) + tes3mp.GetPosX(pid))
			local PosY = (200 * math.cos(playerAngleZ) + tes3mp.GetPosY(pid))
			local PosZ = (200 * math.sin(-playerAngleX) + (tes3mp.GetPosZ(pid) + 100))
			if tes3mp.IsInExterior(pid) == true then
				local correctGridX = math.floor(PosX / cellSize)
				local correctGridY = math.floor(PosY / cellSize)

				if LoadedCells[cell].gridX ~= correctGridX or LoadedCells[cell].gridY ~= correctGridY then
					PosX = tes3mp.GetPosX(pid)
					PosY = tes3mp.GetPosY(pid)
					PosZ = (tes3mp.GetPosZ(pid) - 10000)
					tes3mp.MessageBox(pid, -1, trad.warningcell)	
				end
			end			
			if drawState == 1 then
				local curDegrees = math.deg(object.location.rotZ)
				local newDegrees = (curDegrees + 1) % 360
				object.location.rotZ = math.rad(newDegrees)
			elseif drawState == 2 then
				local curDegrees = math.deg(object.location.rotX)
				local newDegrees = (curDegrees + 1) % 360
				object.location.rotX = math.rad(newDegrees)
			end			
			object.location.posX = PosX
			object.location.posY = PosY
			object.location.posZ = PosZ
			resendPlaceToAll(playerSelectedObject[pname], cell)			
		end
		if tes3mp.GetSneakState(pid) then			
			tes3mp.MessageBox(pid, -1, trad.placeobjet)	
			playersTab.player[pid] = nil		
			return false
		else
			tes3mp.RestartTimer(TimerDrop, time.seconds(0.01))	
		end
	end
end

Methods.OnCheckStateMove = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then 
		if playersTab.player[pid] then
			return customEventHooks.makeEventStatus(false,false)
		end
	end
end

Methods.OnPlayerCellChange = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then 
		playerSelectedObject[tes3mp.GetName(pid)] = nil
		if playersTab.player[pid] then
			playersTab.player[pid] = nil
		end
	end
end

Methods.OnCommand = function(pid)
	showMainGUI(pid)
end

Methods.PlayerConnect = function(eventStatus, pid)
	if playersTab.player[pid] then
		playersTab.player[pid] = nil
	end
end

customEventHooks.registerValidator("OnObjectActivate", Methods.OnCheckStateMove)
customCommandHooks.registerCommand("dh", Methods.OnCommand)
customEventHooks.registerHandler("OnGUIAction", function(eventStatus, pid, idGui, data)
	DecorateHelp.OnGUIAction(pid, idGui, data)
end)
customEventHooks.registerHandler("OnObjectPlace", Methods.OnObjectPlace)
customEventHooks.registerHandler("OnPlayerCellChange", Methods.OnPlayerCellChange)
customEventHooks.registerHandler("OnPlayerAuthentified", Methods.PlayerConnect)

return Methods
