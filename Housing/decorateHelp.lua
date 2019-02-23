-- decorateHelp - Release 1 - For tes3mp v0.7.0
-- Alter positions of items using a GUI
-- precision adjustment x, y, z and rot
-- simplified use up, down, right, left and scaling 

--[[ INSTALLATION:
1) Save this file as "decorateHelp.lua" in mp-stuff/scripts
2) Add [ decorateHelp = require("decorateHelp") ] to the top of servercore.lua
3) Add the following to the elseif chain for commands in "OnPlayerSendMessage" inside commandhandler.lua

[	elseif cmd[1] == "decorator" or cmd[1] == "decorate" or cmd[1] == "dh" then
		decorateHelp.OnCommand(pid) ]
4) Add the following to OnGUIAction in servercore.lua
	[ if decorateHelp.OnGUIAction(pid, idGui, data) then return end ]
5) Add the following to OnObjectPlace in servercore.lua
	[ decorateHelp.OnObjectPlace(pid, cellDescription) ]
6) Add the following to OnPlayerCellChange in server.lua
	[ decorateHelp.OnPlayerCellChange(pid) ]

]]

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
trad.opt1 = "Choisir une option. Votre article actuel: "
trad.opt2 = "Ajuster le Nord;Ajuster l'est;Ajuster la hauteur;Tourner X;Tourner Y;Tourner Z;Monter;Descendre;Est;Ouest;Nord;Sud;Agrandir;Réduire;Fermer"
------

Methods = {}

tableHelper = require("tableHelper")

local playerSelectedObject = {}
local playerCurrentMode = {}

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
	
	if not object then
		return false
	end
	
	local refId = object.refId
	local count = object.count or 1
	local charge = object.charge or -1
	local posX, posY, posZ = object.location.posX, object.location.posY, object.location.posZ
	local rotX, rotY, rotZ = object.location.rotX, object.location.rotY, object.location.rotZ
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
			if inventory then
				tes3mp.SendContainer()
			end
		end
	end
	
	LoadedCells[cell]:Save() --Not needed, but it's nice to do anyways
end


local function showPromptGUI(pid)
	local message = "[" .. playerCurrentMode[tes3mp.GetName(pid)] .. trad.prompt

	tes3mp.InputDialog(pid, config.PromptId, message, "")
end

local function onEnterPrompt(pid, data)
	local cell = tes3mp.GetCell(pid)
	local pname = tes3mp.GetName(pid)
	local mode = playerCurrentMode[pname]
	local data = tonumber(data) or 0
	
	local object = getObject(playerSelectedObject[pname], cell)
	
	if not object then
		--The object no longer exists, so we should bail out now
		return false
	end
	
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
		logicHandler.RunConsoleCommandOnObject("setscale (getscale + 0.1)", cell, playerSelectedObject[pname])
	elseif mode == trad.lower then
		logicHandler.RunConsoleCommandOnObject("setscale (getscale - 0.1)", cell, playerSelectedObject[pname])		
	elseif mode == "return" then
		object.location.posY = object.location.posY		
		return
	end
	
	resendPlaceToAll(playerSelectedObject[pname], cell)
end

local function showMainGUI(pid)
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

local function setSelectedObject(pid, refIndex)
	playerSelectedObject[tes3mp.GetName(pid)] = refIndex
end

Methods.SetSelectedObject = function(pid, refIndex)
	setSelectedObject(pid, refIndex)
end

Methods.OnObjectPlace = function(pid, cellDescription)
	--Get the last event, which should hopefully be the place packet
	tes3mp.ReadLastEvent()
	
	--Get the refIndex of the first item in the object place packet (in theory, there should only by one)
	local refIndex = tes3mp.GetObjectRefNumIndex(0) .. "-" .. tes3mp.GetObjectMpNum(0)
	
	--Record that item as the last one the player interacted with in this cell
	setSelectedObject(pid, refIndex)
end

Methods.OnGUIAction = function(pid, idGui, data)
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
		elseif tonumber(data) == 14 then --Close
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

Methods.OnPlayerCellChange = function(pid)
	playerSelectedObject[tes3mp.GetName(pid)] = nil
end

Methods.OnCommand = function(pid)
	showMainGUI(pid)
end

return Methods
