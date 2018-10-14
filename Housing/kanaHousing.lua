-- kanaHousing - Release 1.5 - For tes3mp 0.6.1

--[[ INSTALLATION
1) Save this file as "kanaHousing.lua" in mp-stuff/scripts
2) Add [ kanaHousing = require("kanaHousing") ] to the top of serverCore.lua
3) Add the following to the elseif chain for commands in "OnPlayerSendMessage" inside commandHandler.lua
[	elseif cmd[1] == "house" or cmd[1] == "housing" then
		kanaHousing.OnUserCommand(pid) 
	elseif cmd[1] == "adminhouse" or cmd[1] == "adminhousing" then
		kanaHousing.OnAdminCommand(pid) 
	elseif cmd[1] == "houseinfo" then
		kanaHousing.OnInfoCommand(pid)	]
4) Add the following to OnGUIAction in serverCore.lua
	[ if kanaHousing.OnGUIAction(pid, idGui, data) then return end ]
5) Add the following to OnServerPostInit in serverCore.lua
	[ kanaHousing.OnServerPostInit() ]
6) Add the following to the end of OnPlayerCellChange in serverCore.lua
	[ kanaHousing.OnPlayerCellChange(pid) ]
7) Add the following to the end of OnObjectLock in serverCore.lua
	[ kanaHousing.OnObjectLock(pid, cellDescription) ]
8) Add the following to the end of OnContainer in serverCore.lua
	[ kanaHousing.OnContainer(pid, cellDescription) ]
9) Add the following to the end of OnObjectDelete in serverCore.lua
	[ kanaHousing.OnObjectDelete(pid, cellDescription) ]
n) If you have kanaFurniture installed, uncomment (remove the -- at the beginning) the line [ kanaFurniture = require("kanaFurniture") ] that is after this installation info box. Requires kanaFurniture release 2 or later.
]]

kanaFurniture = require("kanaFurniture")

local config = {}

config.defaultPrice = 5000 --The price a house defaults to when it's created
config.requiredAdminRank = 1 --The admin rank required to use the admin GUI
config.allowWarp = true --Whether or not players can use the option to warp to their home
config.logging = true --If the script reports its own information to the server log
config.chatColor = "#00FF7F" --The color used for the script's chat messages

config.AdminMainGUI = 31371
config.AdminHouseCreateGUI = 31372
config.AdminHouseSelectGUI = 31373
config.CellEditGUI = 31374
config.HouseEditGUI = 31375
config.HouseEditPriceGUI = 31376
config.HouseEditOwnerGUI = 31377
config.HouseInfoGUI = 31378
config.PlayerMainGUI = 31379
config.PlayerAllHouseSelectGUI = 31380
config.PlayerSettingGUI = 31381
config.PlayerOwnedHouseSelect = 31382
config.PlayerAddCoOwnerGUI = 31383
config.PlayerRemoveCoOwnerGUI = 31384
config.PlayerSellConfirmGUI = 31385

-------------------
jsonInterface = require("jsonInterface")
eventHandler = require("eventHandler")
inventoryHelper = require("inventoryHelper")
color = require("color")
local serverConfig = require("config")
enumerations = require("enumerations")

local Methods = {}
--Forward Declarations:
local showAdminMain, showHouseCreate, showAdminHouseSelect, showCellEditMain, showHouseEditMain, showHouseEditPricePrompt, showHouseEditOwnerPrompt, showHouseInfo, showUserMain, showAllHousesList, showPlayerSettingsMain, showPlayerSettingsOwnedList, showPlayerSettingsAddPrompt, showPlayerSettingsRemoveList, showPlayerSellOptions, onLockStatusChange
-------------------
local housingData = {houses = {}, cells = {}, owners = {}}

-------------------
local function doLog(text)
	if config.logging then
		tes3mp.LogMessage(1, "[kanaHousing] " .. text)
	end
end

local function msg(pid, text)
	tes3mp.SendMessage(pid, config.chatColor .. text .. "\n" .. color.Default)
end

local function Save()
	jsonInterface.save("kanaHousing.json", housingData)
end

local function Load()
	housingData = jsonInterface.load("kanaHousing.json")
end

Methods.OnServerPostInit = function()
	local file = io.open(os.getenv("MOD_DIR") .. "/kanaHousing.json", "r")
	if file ~= nil then
		io.close()
		Load()
	else
		Save()
	end
end
-------------------
local function getName(pid) --Slightly different from the usual one I use
	return string.lower(Players[pid].accountName)
end

--Returns the amount of gold in a player's inventory
local function getPlayerGold(playerName) --playerName is the name of the player (capitalization doesn't matter)

	if playerName ~= nil then
		local player = logicHandler.GetPlayerByName(playerName)
		
		if player then
			local goldLoc = inventoryHelper.getItemIndex(player.data.inventory, "gold_001", -1)
			
			if goldLoc then
				return player.data.inventory[goldLoc].count
			else
				return 0
			end
		else
			--Couldn't find the player
			return false
		end
	end
end

local function addGold(playerName, amount) --playerName is the name of the player to add the gold to (capitalization doesn't matter). Amount is the amount of gold to add (can be negative if you want to subtract gold).
	--Find the player
	local player = logicHandler.GetPlayerByName(playerName)
	
	--Check we found the player before proceeding
	if player then
		--Look through their inventory to find where their gold is, if they have any
		local goldLoc = inventoryHelper.getItemIndex(player.data.inventory, "gold_001", -1)
		
		--If they have gold in their inventory, edit that item's data. Otherwise make some new data.
		if goldLoc then
			player.data.inventory[goldLoc].count = player.data.inventory[goldLoc].count + amount
			
			--If the total is now 0 or lower, remove the entry from the player's inventory.
			if player.data.inventory[goldLoc].count < 1 then
				player.data.inventory[goldLoc] = nil
			end
		else
			--Only create a new entry for gold if the amount is actually above 0, otherwise we'll have negative money.
			if amount > 0 then
				table.insert(player.data.inventory, {refId = "gold_001", count = amount, charge = -1})
			end
		end
		
		--How we save the character is different depending on whether or not the player is online
		if player:IsLoggedIn() then
			--If the player is logged in, we have to update their inventory to reflect the changes
			player:Save()
			player:LoadInventory()
			player:LoadEquipment()
		else
			--If the player isn't logged in, we have to temporarily set the player's logged in variable to true, otherwise the Save function won't save the player's data
			player.loggedIn = true
			player:Save()
			player.loggedIn = false
		end
		
		return true
	else
		--Couldn't find any existing player with that name
		return false
	end
end

local function warpPlayer(pid, cell, pos, rot)
	tes3mp.SetCell(pid, cell)
	tes3mp.SendCell(pid)
	
	tes3mp.SetPos(pid, pos.x, pos.y, pos.z)
	--Rotation isn't actually used here :P
	tes3mp.SendPos(pid)
end

local function createNewHouse(houseName)
	housingData.houses[houseName] = {
		name = houseName, --The house name
		price = config.defaultPrice, --How much the house costs
		cells = {}, --Contains the names of cells associated with the house as keys
		doors = {}, --Contains the information on all the doors associated with the house, so the script can make sure that they're always unlocked. Requires manually editing the .json to add entries.
		--[[
			cell --The cell name
				{[INDEXED table containing table containing door's refId and refIndex under associated keys]}
		]]
		inside = {},
		outside = {},
	}
	Save()
end

local function createNewOwner(oname)
	local oname = string.lower(oname)
	housingData.owners[oname] = {
		houses = {},
	}
	Save()
end

local function createNewCell(cellDescription)
	housingData.cells[cellDescription] = {
		name = cellDescription, --Name of the cell
		house = nil, --Name of house that the cell is assigned to
		ownedContainers = false, --If the cell contains any containers marked as owned
		requiredAccess = false, --If the cell needs to be accessed/passed through for a quest
		requiresResets = false, --If the cell contains items/people etc. needed for a quest
		resetInfo = {}, --Contains more nuanced information on what exactly should be reset if requiresResets is true. Requires manually editing the .json to add entries, and a cell reset script that supports more precise resetting to begin with. If this is empty, the whole cell should just be reset
		--[[ Contains INDEXED tables of tables containing the items refIndex, refId, and instructions on what to do if it's missing
			{refIndex = a_refIndex, refId = a_refId, instruction = "replace"},
			{[Another example]}
			The instructions that I'm coining here are: "refill" - if the object is an irremovable container that needs its contents re-added (for example: the crate of limeware and silverware found in Chun-Ook's Lower Level for the quest "Liberate the Limeware"). "replace" - if the object is removable such as an in-world item or a creature/NPC that needs to exist for a quest (for example: the placed Vintage Brandy in Hlaalo Manor for the quest "The Vintage Brandy", or Ralen Hlaalo's corpse in the same place for the quest "The Death of Ralen Hlaalo" (activating the corpse isn't necessarily required for the quest, but is one of the ways to start it))
		]]
	}
	Save()
end

--Slightly hacky method for storing players' login names. Could probably do something fancy to get it.
local function registerName(pid)
	housingData.loginNames[getName(pid)] = Players[pid].data.login.name
end

local function deleteHouse(houseName)
	housingData.houses[houseName] = nil
	for cellName, v in pairs(housingData.cells) do
		if housingData.cells[cellName].house == houseName then
			housingData.cells[cellName].house = nil
		end
	end
	Save()
end

local function setHousePrice(houseName, price)
	if housingData.houses[houseName] then
			housingData.houses[houseName].price = tonumber(price) or config.defaultPrice --If the price somehow isn't a valid number, use the default price
		Save()
	end
end

local function getHouseOwnerName(houseName)
	for pname, v in pairs(housingData.owners) do
		if housingData.owners[pname].houses[houseName] ~= nil then
			return pname
		end
	end
	--If we get to here, we didn't find it
	return false
end

--Returns the name of the house they're in or false. If they're in a house, also returns the celldata of the cell that they're in.
local function getIsInHouse(pid)
	local currentCell = tes3mp.GetCell(pid)
	
	if housingData.cells[currentCell] and housingData.cells[currentCell].house ~= nil then
		return housingData.cells[currentCell].house, housingData.cells[currentCell]
	else
		return false
	end
end

local function assignCellToHouse(cell, houseName)
	if housingData.houses[houseName] then
		housingData.houses[houseName].cells[cell] = true
		housingData.cells[cell].house = houseName
		doLog("Assigned " .. cell .. " to " .. houseName)
		Save()
	end
end

local function removeCellFromHouse(cell, houseName)
	if housingData.houses[houseName] then
		housingData.houses[houseName].cells[cell] = nil
		housingData.cells[cell].house = nil
		Save()
	end
end

--furnReturn = "return" - remove furniture and add back to furniture inventory. "sell" remove and add resale value to player. "remove" - delete them all.
local function removeHouseOwner(houseName, refund, furnReturn)
	local oname = getHouseOwnerName(houseName)
	local hdata = housingData.houses[houseName]
	
	if not oname or not hdata then
		return false
	end

	if refund then
		addGold(oname, hdata.price)
	end
	
	if kanaFurniture ~= nil then
		for cellName, v in pairs(hdata.cells) do
			kanaFurniture.RemoveAllPermissions(cellName) --Remove the furniture placing permissions for the owner and coowners
			--For now, no matter the settings, the co-owners furniture always gets returned to them
			for coName, v in pairs(housingData.owners[oname].houses[houseName].coowners) do
				kanaFurniture.RemoveAllPlayerFurnitureInCell(coName, cellName, true)
			end
		end
		
		if furnReturn == "return" then
			for cellName, v in pairs(hdata.cells) do
				kanaFurniture.RemoveAllPlayerFurnitureInCell(oname, cellName, true)
			end
		elseif furnReturn == "sell" then
			local placedNum = 0
			local placedSellback = 0
		
			for cellName, v in pairs(hdata.cells) do
				local placed = kanaFurniture.GetPlacedInCell(cellName)
				if placed then
					for refIndex, v2 in pairs(placed) do
						if v2.owner == oname then
							placedNum = placedNum + 1
							placedSellback = placedSellback + kanaFurniture.GetSellBackPrice(kanaFurniture.GetFurnitureDataByRefId(v2.refId).price)
						end
					end
				end
				kanaFurniture.RemoveAllPlayerFurnitureInCell(oname, cellName, false)
			end
			
			addGold(oname, placedSellback)			
		end
	end
	
	housingData.owners[oname].houses[houseName] = nil
	Save()
	doLog(oname .. " a été retiré en tant que propriétaire de " .. houseName)
end

local function addHouseOwner(oname, houseName)
	local oname = string.lower(oname)
	local hdata = housingData.houses[houseName]
	if not housingData.owners[oname] then
		createNewOwner(oname)
	end
	--TODO Make all the other data
	housingData.owners[oname].houses[houseName] = {}
	housingData.owners[oname].houses[houseName].coowners = {}
	housingData.owners[oname].houses[houseName].isLocked = false
	-- TODO: Assign leftover kanaFurniture stuff to new owner?
	if kanaFurniture ~= nil then
		--Give the player permission to place furniture in all of the house's cells
		for cellName, v in pairs(hdata.cells) do
			kanaFurniture.AddPermission(oname, cellName)
		end
	end
	
	Save()
	doLog(oname .. " a été défini comme le propriétaire de " .. houseName)
end

local function addCoOwner(houseName, pname)
	local pname = string.lower(pname)
	local oname = getHouseOwnerName(houseName)
	local hdata = housingData.houses[houseName]
	
	if pname ~= oname then
		housingData.owners[oname].houses[houseName].coowners[pname] = true
		
		if kanaFurniture ~= nil then
			--Give the player permission to place furniture in all of the house's cells
			for cellName, v in pairs(hdata.cells) do
				kanaFurniture.AddPermission(pname, cellName)
			end
		end
	end
	
	Save()
end

local function removeCoOwner(houseName, pname)
	local pname = string.lower(pname)
	local oname = getHouseOwnerName(houseName)
	local hdata = housingData.houses[houseName]
	
	housingData.owners[oname].houses[houseName].coowners[pname] = nil
	
	if kanaFurniture ~= nil then
		--Remove the player's permission to place furniture in all of the house's cells, as well as return all the furniture that they placed.
		for cellName, v in pairs(hdata.cells) do
			kanaFurniture.RemovePermission(pname, cellName)
			kanaFurniture.RemoveAllPlayerFurnitureInCell(pname, cellName, true)
		end
	end
	
	Save()
	--Hack to trigger a reassessment to see if they should still be allowed in the house if they were in it when they were removed
	onLockStatusChange(houseName)
end

local function getHouseInfoLong(houseName, toggleMeanings) --Used in GUI labels
	local text = ""
	local hdata = housingData.houses[houseName]
	if not hdata then
		return false
	end
	
	text = text .. "=" .. hdata.name .. "=\n"
	local owner = "Personne"
	if getHouseOwnerName(hdata.name) then
		owner = getHouseOwnerName(hdata.name)
	end
	text = text .. "La maison vaut " .. hdata.price .. " or, actuellement détenue par " .. owner .. ".\n"
	
	local hasOwned, hasAccess, hasResets
	text = text .. "L'intérieur de la maison est constitué des cellules suivantes:\n"
	for cellName, v in pairs(hdata.cells) do
		local cdata = housingData.cells[cellName]
		local addText = "* "
		addText = addText .. cellName
		if cdata.ownedContainers then
			addText = addText .. " | Contient des conteneurs en propriété"
			hasOwned = true
		end
		if cdata.requiredAccess then
			addText = addText .. " | Est-ce que le passage est requis"
			hasAccess = true
		end
		if cdata.requiresResets then
			addText = addText .. " | Requiert des réinitialisations de cellules"
			hasResets = true
		end
		
		addText = addText .. "\n"
		text = text .. addText
	end
	
	if toggleMeanings then
		if hasOwned or hasAccess or hasResets then
			text = text .. "\n"
			if hasOwned then
				text = text .. "Si une cellule est marquée avec «conteneurs en propriété», cela signifie que certains ou tous les conteneurs de la cellule sont désignés en tant que NPC. Si vous deviez stocker et retirer des objets d'un conteneur appartenant à l'utilisateur, ces articles seront marqués comme volés"
			end
			if hasAccess then
				text = text .. "Les passages obligatoires sont des cellules auxquelles les autres joueurs doivent accéder, ou passer pour effectuer certaines quêtes. Les cellules marquées comme telles peuvent toujours être entrées par les joueurs, même si la maison est verrouillée."
			end
			if hasResets then
				text = text .. "Selon la façon dont le serveur est exécuté, les cellules marquées comme nécessitant des réinitialisations peuvent parfois réinitialiser une partie ou la totalité de leur contenu. Contactez un administrateur de serveur pour demander comment le serveur actuel gère les réinitialisations de cellule."
			end
		end
	end
	
	return text
end

--Not actually used because I realised that the script actually uses the names from the lists to find the correct house...
local function getHouseInfoShort(houseName) --Used as entries for lists
	local text = ""
	local hdata = housingData.houses[houseName]
	if not hdata then
		return false
	end
	
	text = text .. hdata.name
	
	text = text .. " - Vaut " .. hdata.price
	
	local owner = "Personne"
	if getHouseOwnerName(hdata.name) then
		owner = getHouseOwnerName(hdata.name)
	end
	
	text = text .. " - Possédé par " .. owner	
	
	return text
end

local function assignHouseInside(houseName, cell, x, y, z)
	local hdata = housingData.houses[houseName]
	if not hdata then
		return false
	end
	
	hdata.inside.cell = cell
	hdata.inside.pos = {x = x, y = y, z = z}
	
	Save()	
end

local function assignHouseOutside(houseName, cell, x, y, z)
	local hdata = housingData.houses[houseName]
	if not hdata then
		return false
	end
	
	hdata.outside.cell = cell
	hdata.outside.pos = {x = x, y = y, z = z}
	
	Save()	
end

local function isOwner(pname, houseName)
	local pname = string.lower(pname)
	--Assumes that the house is valid, etc.
	if getHouseOwnerName(houseName) == pname then
		return true
	else
		return false
	end
end

local function isCoOwner(pname, houseName)
	local pname = string.lower(pname)
	--Assumes that the house is valid, etc.
	local oname = getHouseOwnerName(houseName)
	for coOwner, v in pairs(housingData.owners[getHouseOwnerName(houseName)].houses[houseName].coowners) do
		if pname == string.lower(coOwner) then
			return true
		end
	end
	return false
end

local function isLocked(houseName)
	if getHouseOwnerName(houseName) then
		return housingData.owners[getHouseOwnerName(houseName)].houses[houseName].isLocked
	else
		return false
	end
end

--Used for determining if a player is allowed in a cell. Returns if they are allowed, as well as the reason why they are/aren't allowed.
local function isAllowedEnter(pid, cell)
	local pname = getName(pid)
	local cdata = housingData.cells[cell]
	
	if not cdata or cdata.house == nil then
		return true, "no data"
	end
	
	local hdata = housingData.houses[cdata.house]
	
	if not hdata then
		return true, "no data"
	end
	
	if isLocked(hdata.name) then
		if isOwner(pname, hdata.name) then
			return true, "owner"
		elseif isCoOwner(pname, hdata.name) then
			return true, "coowner"
		elseif Players[pid].data.settings.staffRank == 2 then --Moderators/Admins should always be allowed to enter
			return true, "admin"
		elseif cdata.requiredAccess then
			return true, "access"
		else
			return false, "close"
		end
	elseif not getHouseOwnerName(hdata.name) then --There's no owner
		return true, "unowned"
	else
		return true, "unlocked"
	end
end

local function canWarp(pid)
	return config.allowWarp
end

--Checks through all the recorded door data to find any records of doors in the provided cell. Makes sure the doors in the cell are all unlocked, and if they're not, unlocks them.
local function unlockChecks(cell)	
	local changes = false
	for houseName, hdata in pairs(housingData.houses) do
		for cellName, ddata in pairs(hdata.doors) do
			if cellName == cell then
				if LoadedCells[cell] == nil then
					eventHandler.LoadCell(cell)
				end
				
				for i, doorData in pairs(ddata) do
					local refIndex = doorData.refIndex
					local refId = doorData.refId
					if not LoadedCells[cell]:ContainsObject(refIndex) then
						LoadedCells[cell]:InitializeObjectData(refIndex, refId)
						changes = true
					end
					
					if not LoadedCells[cell].data.objectData[refIndex].lockLevel or LoadedCells[cell].data.objectData[refIndex].lockLevel ~= 0 then
						LoadedCells[cell].data.objectData[refIndex].lockLevel = 0
						tableHelper.insertValueIfMissing(LoadedCells[cell].data.packets.lock, refIndex)
						changes = true
					end
				end
				
			end
		end
	end
	
	if changes then
		LoadedCells[cell]:Save()
		for playerId, player in pairs(Players) do
			if player:IsLoggedIn() then
				LoadedCells[cell]:SendObjectsLocked(playerId)
			end
		end
	end
end

onLockStatusChange = function(houseName) --forward declared
	local hdata = housingData.houses[houseName]
	local destinationCell, destinationPos
	if hdata.outside.cell then --There's exit data saved for this house
		destinationCell = hdata.outside.cell
		destinationPos = hdata.outside.pos
	else
		--Without any data for an exit, we default to placing the players back at spawn
		destinationCell = serverConfig.defaultSpawnCell
		destinationPos = {x = serverConfig.defaultSpawnPos[1], y = serverConfig.defaultSpawnPos[2], z = serverConfig.defaultSpawnPos[3]}
	end
	
	if isLocked(houseName) then
		for playerId, player in pairs(Players) do
			if player:IsLoggedIn() then
				local inHouse, cdata = getIsInHouse(playerId)
				
				if inHouse == houseName then
					local canEnter, reason = isAllowedEnter(playerId, cdata.name)
					if reason == "owner" or reason == "coowner" or reason == "admin" then
						--Do Nothing
					elseif reason == "access" then
						msg(playerId, "Le propriétaire a verrouillé la maison, mais vous êtes autorisé à rester puisque la cellule dans laquelle vous vous trouvez est marquée comme une cellule d'accès requise.")
					else
						--Kick 'em out
						warpPlayer(playerId, destinationCell, destinationPos)
						msg(playerId, "Le propriétaire a fermé la maison.")
					end
				end
			end
		end
	end
	
	if isLocked(houseName) then
		doLog(getHouseOwnerName(houseName) .. " a verrouillé " .. hdata.name)
	else
		doLog(getHouseOwnerName(houseName) .. " a débloqué " .. hdata.name)
	end
end

local function onDirtyThief(pid)
	--Do nothing, for now. Future version could implement auto-banning if wanted, or a system that automatically returns the taken items.
	tes3mp.MessageBox(pid, -1, "Cela ne vous appartient pas. Remettre.")
end

-------------------
local adminSelectedHouse = {}
local adminHouseList = {}
local playerSelectedHouse = {}
local playerAllHouseList = {}
local playerOwnedHouseList = {}
local playerCoOwnerList = {}

-- PLAYER SELL OPTIONS
showPlayerSellOptions = function(pid)
	local message = ""
	local buttons = ""
	
	local hdata = housingData.houses[playerSelectedHouse[getName(pid)]]
	if kanaFurniture ~= nil then
		local placedNum = 0
		local placedSellback = 0
		
		for cellName, v in pairs(hdata.cells) do
			local placed = kanaFurniture.GetPlacedInCell(cellName)
			if placed then
				for refIndex, v2 in pairs(placed) do
					if v2.owner == getName(pid) then
						placedNum = placedNum + 1
						placedSellback = placedSellback + kanaFurniture.GetSellBackPrice(kanaFurniture.GetFurnitureDataByRefId(v2.refId).price)
					end
				end
			end
		end
	
		message = message .. hdata.name .. " vaut la peine " .. hdata.price .. " or. le " .. placedNum .. " les meubles que vous avez placés à l'intérieur ont une valeur de " .. placedSellback .. " or. Remarque: La vente de la maison rapportera tous les meubles placés par le copropriétaire dans son inventaire de meubles."
		buttons = "Vendre une maison + meubles;Vendre une maison + Collecter des meubles;Annuler"
	else
		message = message .. hdata.name .. " vaut la peine" .. hdata.price .. " or."
		buttons = "Vendre une maison;Annuler"
	end
	
	tes3mp.CustomMessageBox(pid, config.PlayerSellConfirmGUI, message, buttons)
end

local function onPlayerSellHouseAndFurniture(pid)
	removeHouseOwner(playerSelectedHouse[getName(pid)], true, "vendre")
end

local function onPlayerSellHouseAndCollect(pid)
	removeHouseOwner(playerSelectedHouse[getName(pid)], true, "revenir")
end

local function onPlayerSellHouse(pid)
	removeHouseOwner(playerSelectedHouse[getName(pid)], true)
end

-- PLAYER SETTINGS REMOVE CO-OWNER
showPlayerSettingsRemoveList = function(pid)
	local message = "Sélectionnez un copropriétaire à supprimer. Note: Retrait d'un copropriétaire va retourner tous leurs meubles."
	--Generate a list of options
	local options = {}	
	local list = "* CLOSE *\n"
	local coOwners = housingData.owners[getName(pid)].houses[playerSelectedHouse[getName(pid)]].coowners
	
	for coname, v in pairs(coOwners) do
		table.insert(options, coname)
	end
	for i=1, #options do
		list = list .. options[i]
		if not (i == #options) then
			list = list .. "\n"
		end
	end
	
	playerCoOwnerList[getName(pid)] = options
	return tes3mp.ListBox(pid, config.PlayerRemoveCoOwnerGUI, message, list)
end

local function onCoOwnerRemoveSelect(pid, index)
	removeCoOwner(playerSelectedHouse[getName(pid)], playerCoOwnerList[getName(pid)][index])
	return showPlayerSettingsMain(pid)
end

-- PLAYER SETTINGS ADD CO-OWNER
showPlayerSettingsAddPrompt = function(pid)
	local message = "Tapez le nom du personnage"
	
	return tes3mp.InputDialog(pid, config.PlayerAddCoOwnerGUI, message, "ajouter copropriétaire")
end

local function onPlayerSettingsAddPrompt(pid, data)
	if data == nil or data == "" then
		--Do nothing
	else
		addCoOwner(playerSelectedHouse[getName(pid)], string.lower(data))
	end
	return showPlayerSettingsMain(pid)
end

-- PLAYER SETTINGS OWNED LIST
showPlayerSettingsOwnedList = function(pid)
	local message = "Sélectionnez une maison appartenant à la liste"
	--Generate a list of options
	local options = {}	
	local list = "* CLOSE *\n"
	
	for houseName, v in pairs(housingData.houses) do
		if getHouseOwnerName(houseName) == getName(pid) then
			table.insert(options, houseName)
		end
	end
	for i=1, #options do
		list = list .. options[i]
		if not (i == #options) then
			list = list .. "\n"
		end
	end
	
	playerOwnedHouseList[getName(pid)] = options
	return tes3mp.ListBox(pid, config.PlayerOwnedHouseSelect, message, list)
end

local function onPlayerOwnedHouseSelect(pid, index)
	playerSelectedHouse[getName(pid)] = playerOwnedHouseList[getName(pid)][index]
	return
end

-- PLAYER SETTINGS MAIN
showPlayerSettingsMain = function(pid)
	local message = ""
	if playerSelectedHouse[getName(pid)] and getHouseOwnerName(playerSelectedHouse[getName(pid)]) ~= getName(pid) then
		playerSelectedHouse[getName(pid)] = nil
	end
	
	message = message .. "#red ..Maison actuellement sélectionnée: " .. (playerSelectedHouse[getName(pid)] or "Aucune") .. "\n\n\n"
	
	if playerSelectedHouse[getName(pid)] then
		local hdata = housingData.houses[playerSelectedHouse[getName(pid)]]
		
		message = message .. "La maison est actuellement "
		if isLocked(hdata.name) then
			message = message .. "fermé à clef.\n"
		else
			message = message .. "déverrouillé.\n"
		end
		--TODO: More?
	end
	
	message = message .. "\n"
	message = message .. "#cyan .Sélectionner la maison dont vous souhaitez modifier les paramètres.\n\n Pour ajouter un copropriétaire, utilisez 'Ajouter un copropriétaire' ou supprimez-en un avec 'Supprimer le copropriétaire'. Les copropriétaires sont autorisés à entrer dans votre maison pendant qu'elle est verrouillé mais ne peuvent pas ce teleporter.\n\n'Verrouiller' est utilisé pour verrouiller / déverrouiller la maison. Lorsqu'il est verrouillé, personne, sauf les propriétaires, les co-propriétaires ou les administrateures, ne peuvent entrer dans la maison.\n\n 'Teleporter' vous téléportera à la maison.\n\n Utilisez 'Vendre une maison' si vous voulez la vendre.\n\n"
	
	return tes3mp.CustomMessageBox(pid, config.PlayerSettingGUI, message, "Sélectionnez la maison possédée;ajoutez le copropriétaire;enlevez le copropriétaire;verrouillez le verrou;teleportez à la maison;vendez la maison;fermez")
end

local function onPlayerSettingsOwned(pid)
	showPlayerSettingsOwnedList(pid)
end

local function onPlayerSettingsAdd(pid)
	if playerSelectedHouse[getName(pid)] then
		showPlayerSettingsAddPrompt(pid)
	else
		return tes3mp.MessageBox(pid, -1, "Vous n'avez pas la maison sélectionnée.")
	end
end

local function onPlayerSelectRemove(pid)
	if playerSelectedHouse[getName(pid)] then
		showPlayerSettingsRemoveList(pid)
	else
		return tes3mp.MessageBox(pid, -1, "Vous n'avez pas la maison sélectionnée.")
	end
end

local function onPlayerSelectLock(pid)
	if playerSelectedHouse[getName(pid)] then
		housingData.owners[getName(pid)].houses[playerSelectedHouse[getName(pid)]].isLocked = (not housingData.owners[getName(pid)].houses[playerSelectedHouse[getName(pid)]].isLocked)
		Save()
		onLockStatusChange(playerSelectedHouse[getName(pid)])
	else
		return tes3mp.MessageBox(pid, -1, "Vous n'avez pas la maison sélectionnée.")
	end
	return showPlayerSettingsMain(pid)
end

local function onPlayerSelectWarp(pid)
	if not canWarp(pid) then
		local message
		if config.allowWarp == false then
			message = "La fonction téléportation est désactivée sur ce serveur."
		else
			message = "Vous ne pouvez pas vous téléporter en ce moment."
		end
		return false, tes3mp.MessageBox(pid, -1, message, false)
	end
	
	if playerSelectedHouse[getName(pid)] then
		local destinationCell
		local destinationPos
		
		local hdata = housingData.houses[playerSelectedHouse[getName(pid)]]
		--If there isn't a defined entrance, we have to get a bit janky
		if not hdata.inside.cell then
			for cellName, v in pairs(hdata.cells) do
				destinationCell = cellName --Assign the first cell we come across as the destination one. This means it might occasionally change where they are put.
				break
			end
			destinationPos = {x = 0, y = 0, z = 0} --Without anything to work with, we're just going to have to use the default position and hope for the best
		else
			destinationCell = hdata.inside.cell
			destinationPos = hdata.inside.pos
		end
		
		warpPlayer(pid, destinationCell, destinationPos)
	else
		return tes3mp.MessageBox(pid, -1, "Vous n'avez pas la maison sélectionnée.")
	end
end

local function onPlayerSelectSell(pid)
	--TODO
	if playerSelectedHouse[getName(pid)] then
		showPlayerSellOptions(pid)
	else
		return tes3mp.MessageBox(pid, -1, "Vous n'avez pas la maison sélectionnée.")
	end
end

-- PLAYER SELECT HOUSE ALL LIST
showAllHousesList = function(pid)
	local message = "Sélectionnez une maison dans la liste pour en savoir plus."
	
	--Generate a list of options
	local options = {}	
	local list = "* CLOSE *\n"
	
	for houseName, v in pairs(housingData.houses) do
		table.insert(options, houseName)
	end
	for i=1, #options do
		list = list .. options[i]
		if not (i == #options) then
			list = list .. "\n"
		end
	end
	
	playerAllHouseList[getName(pid)] = options
	return tes3mp.ListBox(pid, config.PlayerAllHouseSelectGUI, message, list)
end

local function onPlayerAllHouseSelect(pid, index)
	playerSelectedHouse[getName(pid)] = playerAllHouseList[getName(pid)][index]
	return showHouseInfo(pid)
end

-- PLAYER HOUSE CONTROL MAIN
showUserMain = function(pid)
	local message = "#red ..MENU DU LOGEMENT.\n\n\n#blue .Liste de toutes les maisons pour afficher la liste de toutes les maisons disponibles.\n\n#cyan .Modifier les paramètres de la maison pour configurer les maisons que vous possédez."
	tes3mp.CustomMessageBox(pid, config.PlayerMainGUI, message, "Liste de toutes les maisons;Modifier les paramètres de la maison;Fermer")
end

local function onPlayerMainList(pid)
	showAllHousesList(pid)
end

local function onPlayerMainEdit(pid)
	showPlayerSettingsMain(pid)
end

-- PLAYER HOUSE INFO
showHouseInfo = function(pid)
	local message = ""
	local hdata
	if not playerSelectedHouse[getName(pid)] or not housingData.houses[playerSelectedHouse[getName(pid)]] then
		local pcell = tes3mp.GetCell(pid)
		if housingData.cells[pcell] and housingData.cells[pcell].house and housingData.houses[housingData.cells[pcell].house] then
			hdata = housingData.houses[housingData.cells[pcell].house]
			playerSelectedHouse[getName(pid)] = hdata.name
		end
	else
		hdata = housingData.houses[playerSelectedHouse[getName(pid)]]
	end
	
	if hdata then
		message = message .. getHouseInfoLong(hdata.name, true)
	else
		message = message .. "Vous n'avez pas de maison sélectionnée, vous n'êtes pas non plus dans une maison."
		playerSelectedHouse[getName(pid)] = nil
	end
	
	return tes3mp.CustomMessageBox(pid, config.HouseInfoGUI, message, "Acheter;Fermer")
end

local function onHouseInfoBuy(pid)
	local hdata = housingData.houses[playerSelectedHouse[getName(pid)]]
	
	if hdata then
		if getHouseOwnerName(hdata.name) and getHouseOwnerName(hdata.name) ~= getName(pid) then
			return tes3mp.MessageBox(pid, -1, "Quelqu'un possède déjà cette maison!")
		elseif getHouseOwnerName(hdata.name) == getName(pid) then
			return tes3mp.MessageBox(pid, -1, "Vous possédez déjà cette maison.")
		else
			if getPlayerGold(getName(pid)) < hdata.price then
				return tes3mp.MessageBox(pid, -1, "Vous ne pouvez pas vous permettre cette maison.")
			end
			--Do the actual selling
			addGold(getName(pid), -hdata.price)
			addHouseOwner(getName(pid), hdata.name)
			return tes3mp.MessageBox(pid, -1, "Félicitations, vous êtes maintenant le fier propriétaire de".. hdata.name .."Utilisez la commande /house pour gérer les paramètres de votre maison.")
		end
	else
		return tes3mp.MessageBox(pid, -1, "Impossible de trouver la maison sélectionnée.")
	end
end

-- ADMIN EDIT HOUSE OWNER
showHouseEditOwnerPrompt = function(pid)
	local message = "Entrez 'none' pour supprimer"
	
	return tes3mp.InputDialog(pid, config.HouseEditOwnerGUI, message, "propriétaire actuel")
end

local function onHouseEditOwnerPrompt(pid, data)
	if data == nil or data == "" or string.lower(data) == "none" then
		--Do nothing
		removeHouseOwner(adminSelectedHouse[getName(pid)], true, "return")
	else
		if string.lower(data) == getHouseOwnerName(adminSelectedHouse[getName(pid)]) then
			--Player already owns this house... do nothing
		else
			removeHouseOwner(adminSelectedHouse[getName(pid)], true, "return")
			addHouseOwner(data, adminSelectedHouse[getName(pid)])
		end
	end
	return showHouseEditMain(pid)
end

-- ADMIN EDIT HOUSE PRICE
showHouseEditPricePrompt = function(pid)
	local message = "Entrer un nouveau prix"
	
	return tes3mp.InputDialog(pid, config.HouseEditPriceGUI, message)
end

local function onHouseEditPricePrompt(pid, data)
	local price
	if data == nil or data == "" or not tonumber(data) or tonumber(data) < 0 then
		price = config.defaultPrice
	else
		price = data
	end
	
	if housingData.houses[adminSelectedHouse[getName(pid)]] then
		setHousePrice(adminSelectedHouse[getName(pid)], price)
		return showHouseEditMain(pid)
	else
		tes3mp.MessageBox(pid,-1, "Votre maison sélectionnée ne semble plus exister!")
	end
end

-- ADMIN EDIT HOUSE MAIN
showHouseEditMain = function(pid)
	local message = getHouseInfoLong(adminSelectedHouse[getName(pid)], false)
	message = message .. "\n\n"
	
	message = message .. "'Définir ici en tant qu'entrée' désigne l'endroit où vous vous trouvez pour indiquer l'endroit où les joueurs arriveront lorsqu'ils se téléporteront ici. 'Définir ici comme sortie' indique où vous vous trouvez en tant qu'emplacement où les joueurs seront placés s'ils sont expulsés (par exemple s'ils essaient d'entrer alors que l'endroit est verrouillé et n'a pas la permission). Les deux devraient être fixés pour une maison. "
	
	message = message .. "\n\n"
	
	local hdata = housingData.houses[adminSelectedHouse[getName(pid)]]
	message = message .. "Entrée assignée: "
	if not hdata.inside.cell then
		message = message .. "Aucun\n"
	else
		message = message .. "Cell - " .. hdata.inside.cell .. " | Pos - " .. math.floor(hdata.inside.pos.x + 0.5) .. ", " .. math.floor(hdata.inside.pos.y + 0.5) .. ", " .. math.floor(hdata.inside.pos.z + 0.5) .."\n"
	end
	message = message .. "Sortie attribuée: "
	if not hdata.outside.cell then
		message = message .. "Aucun\n"
	else
		message = message .. "Cell - " .. hdata.outside.cell .. " | Pos - " .. math.floor(hdata.outside.pos.x + 0.5) .. ", " .. math.floor(hdata.outside.pos.y + 0.5) .. ", " .. math.floor(hdata.outside.pos.z + 0.5) .."\n"
	end
	
	return tes3mp.CustomMessageBox(pid, config.HouseEditGUI, message, "Définir le prix;Définir le propriétaire;Affecter la porte;Supprimer la porte;Définir ici comme entrée;Définir ici comme sortie;Supprimer la maison;Fermer")
end

local function onHouseEditPrice(pid)
	return showHouseEditPricePrompt(pid)
end

local function onHouseEditOwner(pid)
	return showHouseEditOwnerPrompt(pid)
end

local function onHouseEditDoor(pid)
	--TODO
	return tes3mp.MessageBox(pid, -1, "Pas encore implémenté. L'édition manuelle des fichiers de données est nécessaire pour attribuer une porte.")
end

local function onHouseEditRemoveDoor(pid)
	--TODO
	return tes3mp.MessageBox(pid, -1, "Pas encore implémenté. L'édition manuelle des fichiers de données est nécessaire pour annuler l'affectation d'une porte.")
end

local function onHouseEditDeleteHouse(pid)
	--Pssh, who needs a confirmation window? Just delete it! :P
	deleteHouse(adminSelectedHouse[getName(pid)])
	adminSelectedHouse[getName(pid)] = nil
	return showAdminMain(pid)
end

local function onHouseEditInside(pid)
	return assignHouseInside(adminSelectedHouse[getName(pid)], tes3mp.GetCell(pid), tes3mp.GetPosX(pid), tes3mp.GetPosY(pid), tes3mp.GetPosZ(pid)), showHouseEditMain(pid)
end

local function onHouseEditOutside(pid)
	return assignHouseOutside(adminSelectedHouse[getName(pid)], tes3mp.GetCell(pid), tes3mp.GetPosX(pid), tes3mp.GetPosY(pid), tes3mp.GetPosZ(pid)), showHouseEditMain(pid)
end

-- ADMIN EDIT CELL MAIN
showCellEditMain = function(pid)
	local cell = tes3mp.GetCell(pid)
	local message = ""
	--Generate Cell's entry if none exists
	if not housingData.cells[cell] then
		createNewCell(cell)
	end
	
	local cdata = housingData.cells[cell]
	
	--Cell name, Associated House, Owned Containers Status, Required Access Status. Description on buttons
	message = message .. "Nom: " .. cdata.name .. "\n"
	message = message .. "Maison associée: " .. (cdata.house or "no data")  .. "\n"
	message = message .. "Conteneurs possédés: " .. tostring(cdata.ownedContainers) .. "\n"
	message = message .. "Accès requis: " .. tostring(cdata.requiredAccess) .. "\n"
	message = message .. "Requiert des réinitialisations: " .. tostring(cdata.requiresResets) .. "\n"
	
	return tes3mp.CustomMessageBox(pid, config.CellEditGUI, message, "Attribuer à la maison sélectionnée;Supprimer de la maison sélectionnée;Basculer les conteneurs en propriété;Basculer l'accès requis;Basculer les réinitialisations requises;Fermer")
end

local function onCellEditAssign(pid)
	local cell = tes3mp.GetCell(pid)
	local pname = getName(pid)
	
	if adminSelectedHouse[pname] and housingData.houses[adminSelectedHouse[pname]] then
		assignCellToHouse(cell, adminSelectedHouse[pname])
		return true, showCellEditMain(pid, adminSelectedHouse[pname])
	else
		if not adminSelectedHouse[pname] then
			tes3mp.MessageBox(pid,-1, "Vous devez avoir sélectionné une maison pour y ajouter une cellule.")
		else
			tes3mp.MessageBox(pid,-1, "Votre maison sélectionnée ne semble plus exister!")
		end
	end
end

local function onCellEditRemove(pid)
	local cell = tes3mp.GetCell(pid)
	local pname = getName(pid)
	
	if adminSelectedHouse[pname] and housingData.houses[adminSelectedHouse[pname]] then
		removeCellFromHouse(cell, adminSelectedHouse[pname])
		return true, showCellEditMain(pid)
	else
		if not adminSelectedHouse[pname] then
			tes3mp.MessageBox(pid,-1, "Vous devez avoir une maison sélectionnée pour en retirer une cellule.")
		else
			tes3mp.MessageBox(pid,-1, "Votre maison sélectionnée ne semble plus exister!")
		end
	end
end

local function onCellEditContainers(pid)
	local cell = tes3mp.GetCell(pid)
	
	if housingData.cells[cell] then
		housingData.cells[cell].ownedContainers = (not housingData.cells[cell].ownedContainers)
		Save()
		return true, showCellEditMain(pid)
	else
		tes3mp.MessageBox(pid,-1, "Erm, n'a pas pu trouver la cellule. Cela ne devrait jamais arriver.")
	end
end

local function onCellEditAccess(pid)
	local cell = tes3mp.GetCell(pid)
	
	if housingData.cells[cell] then
		housingData.cells[cell].requiredAccess = (not housingData.cells[cell].requiredAccess)
		Save()
		return true, showCellEditMain(pid)
	else
		tes3mp.MessageBox(pid,-1, "Erm, n'a pas pu trouver la cellule. Cela ne devrait jamais arriver.")
	end
end

local function onCellEditResets(pid)
	local cell = tes3mp.GetCell(pid)
	
	if housingData.cells[cell] then
		housingData.cells[cell].requiresResets = (not housingData.cells[cell].requiresResets)
		Save()
		return true, showCellEditMain(pid)
	else
		tes3mp.MessageBox(pid,-1, "Erm, n'a pas pu trouver la cellule. Cela ne devrait jamais arriver.")
	end
end


-- ADMIN SELECT HOUSE
showAdminHouseSelect = function(pid)
	local message = "Sélectionnez une maison dans la liste"
	
	--Generate a list of options
	local options = {}	
	local list = "* CLOSE *\n"
	
	for houseName, v in pairs(housingData.houses) do
		table.insert(options, houseName)
	end
	for i=1, #options do
		list = list .. options[i]
		if not (i == #options) then
			list = list .. "\n"
		end
	end
	
	adminHouseList[getName(pid)] = options
	return tes3mp.ListBox(pid, config.AdminHouseSelectGUI, message, list)
end

local function onAdminHouseSelect(pid, index)
	adminSelectedHouse[getName(pid)] = adminHouseList[getName(pid)][index]
	return
end

-- ADMIN HOUSE CREATE
showHouseCreate = function(pid)
	local message = "Entrez un nom pour la maison"
	
	return tes3mp.InputDialog(pid, config.AdminHouseCreateGUI, message, "Maison")
end

local function onHouseCreatePrompt(pid, data)
	--TODO: Checks?
	createNewHouse(data)
	adminSelectedHouse[getName(pid)] = data
end

-- ADMIN MAIN
showAdminMain = function(pid)
	local message = ""
	if adminSelectedHouse[getName(pid)] then
		--TODO: Check if still valid house
		message = message .. "#red ..Maison actuellement sélectionnée: " .. adminSelectedHouse[getName(pid)] .. "\n\n\n"
	end
	
	message = message .. "#cyan .Créer une nouvelle maison pour créer et sélectionner une nouvelle maison, ou Sélectionner une maison pour en sélectionner une existante.\n\nModifier les données de la cellule est utilisé pour éditer les informations de cellule dans laquelle vous êtes actuellement. Si vous avez sélectionné une maison, vous pouvez ensuite affecter cette cellule à celle que vous avez sélectionnée.\n\nModifier les données de la maison est utilisé pour éditer toutes sortes de choses sur la maison elle-même. "
	
	return tes3mp.CustomMessageBox(pid, config.AdminMainGUI, message, "Créer une nouvelle maison;sélectionner une maison;modifier les données de la cellule;modifier les données de la maison;fermer")
end

local function onAdminMainCreate(pid)
	return showHouseCreate(pid)
end

local function onAdminMainSelect(pid)
	return showAdminHouseSelect(pid)
end

local function onAdminMainCellEdit(pid)
	return showCellEditMain(pid)
end

local function onAdminMainHouseEdit(pid)
	local pname = getName(pid)
	if not adminSelectedHouse[pname] or not housingData.houses[adminSelectedHouse[pname]] then
		--Either the admin doesn't have a house selected, or the house they do have selected no longer exists
		return tes3mp.MessageBox(pid,-1, "Veuillez d'abord sélectionner une maison valide.")
	else
		return showHouseEditMain(pid)
	end
end

-------------------

Methods.OnGUIAction = function(pid, idGui, data)
	if idGui == config.AdminMainGUI then --Admin Main
		if tonumber(data) == 0 then --Create New House
			onAdminMainCreate(pid)
			return true
		elseif tonumber(data) == 1 then --Select House
			onAdminMainSelect(pid)
			return true
		elseif tonumber(data) == 2 then --Edit Cell Data
			onAdminMainCellEdit(pid)
			return true
		elseif tonumber(data) == 3 then --Edit House Data
			onAdminMainHouseEdit(pid)
			return true
		elseif tonumber(data) == 4 then --Close
			--Do nothing
			return true
		end		
	elseif idGui == config.AdminHouseCreateGUI then --House Naming Prompt
		if data ~= nil and data ~= "" then
			onHouseCreatePrompt(pid, data)
		end
		return true, showAdminMain(pid)
	elseif idGui == config.AdminHouseSelectGUI then --Admin House Selector
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return true, showAdminMain(pid)
		else
			onAdminHouseSelect(pid, tonumber(data))
			return true, showAdminMain(pid)
		end
	elseif idGui == config.CellEditGUI then --Edit Cells Main
		if tonumber(data) == 0 then -- Assign to Selected House
			onCellEditAssign(pid)
			return true
		elseif tonumber(data) == 1 then -- Remove From Selected House
			onCellEditRemove(pid)
			return true
		elseif tonumber(data) == 2 then --Toggle Owned Containers
			onCellEditContainers(pid)
			return true
		elseif tonumber(data) == 3 then --Toggle Required Access
			onCellEditAccess(pid)
			return true
		elseif tonumber(data) == 4 then --Toggle Requires Resets
			onCellEditResets(pid)
			return true
		else -- Close
			--Do nothing
			return true, showAdminMain(pid)
		end
	elseif idGui == config.HouseEditGUI then --Edit House Main
		if tonumber(data) == 0 then -- Set Price
			onHouseEditPrice(pid)
			return true
		elseif tonumber(data) == 1 then -- Set Owner
			onHouseEditOwner(pid)
			return true
		elseif tonumber(data) == 2 then -- Assign Door
			onHouseEditDoor(pid)
			return true
		elseif tonumber(data) == 3 then -- Remove Door
			onHouseEditRemoveDoor(pid)
			return true
		elseif tonumber(data) == 4 then -- Set Entrance
			onHouseEditInside(pid)
			return true
		elseif tonumber(data) == 5 then -- Set Exit
			onHouseEditOutside(pid)
			return true	
		elseif tonumber(data) == 6 then -- Delete House
			onHouseEditDeleteHouse(pid)
			return true
		else --Close
			--Do nothing
			return true, showAdminMain(pid)
		end
	elseif idGui == config.HouseEditPriceGUI then --Edit House Price Prompt
		onHouseEditPricePrompt(pid, data)
		return true
	elseif idGui == config.HouseEditOwnerGUI then --Edit House Owner Prompt
		onHouseEditOwnerPrompt(pid, data)
		return true
	elseif idGui == config.HouseInfoGUI then -- House Info
		if tonumber(data) == 0 then --Buy
			onHouseInfoBuy(pid)
			return true
		else
			--Do nothing
			return true
		end
	elseif idGui == config.PlayerMainGUI then -- Player Main
		if tonumber(data) == 0 then --List all Houses
			onPlayerMainList(pid)
			return true
		elseif tonumber(data) == 1 then --Edit House Settings
			onPlayerMainEdit(pid)
			return true
		else --Close
			--Do nothing
			return true
		end	
	elseif idGui == config.PlayerAllHouseSelectGUI then --Player All House List Select
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return true, showUserMain(pid)
		else
			onPlayerAllHouseSelect(pid, tonumber(data))
			return true
		end
	elseif idGui == config.PlayerSettingGUI then --Player Setting Main
		if tonumber(data) == 0 then --Select Owned House
			onPlayerSettingsOwned(pid)
			return true
		elseif tonumber(data) == 1 then --Add Co-owner
			onPlayerSettingsAdd(pid)
			return true
		elseif tonumber(data) == 2 then --Remove Co-owner
			onPlayerSelectRemove(pid)
			return true
		elseif tonumber(data) == 3 then --Lock House
			onPlayerSelectLock(pid)
			return true
		elseif tonumber(data) == 4 then --Warp to House
			onPlayerSelectWarp(pid)
			return true
		elseif tonumber(data) == 5 then --Sell House
			onPlayerSelectSell(pid)
			return true
		else --Close
			--Do nothing
			return true
		end	
	elseif idGui == config.PlayerOwnedHouseSelect then --Player Owned House Select
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return true, showPlayerSettingsMain(pid)
		else
			onPlayerOwnedHouseSelect(pid, tonumber(data))
			return true, showPlayerSettingsMain(pid)
		end
	elseif idGui == config.PlayerAddCoOwnerGUI then --Player CoOwner Add Prompt
		onPlayerSettingsAddPrompt(pid, data)
		return true	
	elseif idGui == config.PlayerRemoveCoOwnerGUI then --Player CoOwner Remove Select
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return true, showPlayerSettingsMain(pid)
		else
			onCoOwnerRemoveSelect(pid, tonumber(data))
			return true, showPlayerSettingsMain(pid)
		end
	elseif idGui == config.PlayerSellConfirmGUI then
		if tonumber(data) == 0 then --Sell House/Sell House + Furniture
			if kanaFurniture ~= nil then
				onPlayerSellHouseAndFurniture(pid)
				return true
			else
				onPlayerSellHouse(pid)
				return true
			end
		elseif tonumber(data) == 1 then --Cancel/Sell House + Collect furniture
			if kanaFurniture ~= nil then
				onPlayerSellHouseAndCollect(pid)
				return true
			else
				--Do nothing, because cancel
				return true, showPlayerSettingsMain(pid)
			end
		elseif tonumber(data) == 2 then -- [Impossible]/Cancel
			--Can only get this far if in kanaFurniture mode, so no need to check
			--Do nothing
			return true, showPlayerSettingsMain(pid)
		end
	end
end

Methods.OnUserCommand = function(pid)
	return showUserMain(pid)
end

Methods.OnInfoCommand = function(pid)
	return showHouseInfo(pid)
end

Methods.OnAdminCommand = function(pid)
	local rank = Players[pid].data.settings.staffRank
	if rank < config.requiredAdminRank then
		--Not high enough rank to use the admin menu
		return false
	end
	return showAdminMain(pid)	
end

local lastEnteredHouse = {}
Methods.OnPlayerCellChange = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local currentCell = tes3mp.GetCell(pid)
		
		--Do the locked doors check stuff
		unlockChecks(currentCell)
		
		--If they're entering a house cell
		if housingData.cells[currentCell] and housingData.cells[currentCell].house ~= nil then
			hdata = housingData.houses[housingData.cells[currentCell].house]
			
			local canEnter, enterReason = isAllowedEnter(pid, currentCell)
			if enterReason == "unowned" then --A player has entered a house without an owner
				if lastEnteredHouse[getName(pid)] ~= hdata.name then --They've just entered the house
					msg(pid, " Vous êtes entré dans " .. hdata.name .. ", qui est une maison disponible à l'achat pour " .. hdata.price .. " or. Ecrire /houseinfo pour plus d'information.")
				end
				doLog(Players[pid].accountName .. " entré dans une cellule dans la maison sans propriétaire " .. hdata.name)
			elseif enterReason == "unlocked" then				
				if lastEnteredHouse[getName(pid)] ~= hdata.name then --They've just entered the house
					if isOwner(getName(pid), hdata.name) or isCoOwner(getName(pid), hdata.name) then
						msg(pid, "Bienvenue à la maison, " .. Players[pid].accountName .. ".")
					else
						msg(pid, "Bienvenue " .. getHouseOwnerName(hdata.name) .. " maison.")
					end
				end
				
				local logMessage = Players[pid].accountName .. " entré dans la maison non verrouillée " .. hdata.name
				
				if isOwner(getName(pid), hdata.name) then
					logMessage = logMessage .. " en tant que propriétaire"
				elseif isCoOwner(getName(pid), hdata.name) then
					logMessage = logMessage .. " en tant que copropriétaire"
				else
					logMessage = logMessage .. " en tant que visiteur"
				end
				
				doLog(logMessage)
				
			elseif enterReason == "owner" or enterReason == "coowner" then --An owner/coowner has entered
				if lastEnteredHouse[getName(pid)] ~= hdata.name then --They've just entered the house
					local message = "Bienvenue à la maison, " .. Players[pid].accountName .. "."
					if isLocked(hdata.name) then
						message = message .. " La maison est toujours fermée aux étrangers."
					end
					msg(pid, message)
				end
				
				doLog(Players[pid].accountName .. " entré dans la maison fermée à clé " .. hdata.name .. " en tant que propriétaire / copropriétaire")
			elseif enterReason == "Admin" then --An admin entered a locked house
				msg(pid, "Bienvenue " .. getHouseOwnerName(hdata.name) .. "de la maison, oh puissant admin. La maison est actuellement fermée à clé.")
				doLog(Players[pid].accountName .. " entré dans la maison fermée à clé " .. hdata.name .. " en tant qu'administrateur")
			elseif enterReason == "access" then
				local message = "Vous venez d'entrer une partie de " .. getHouseOwnerName(hdata.name) .. "La maison est actuellement fermée à clé, mais vous pouvez entrer ici parce que c'est important pour une quête." .. getHouseOwnerName(hdata.name) .. "propriété, et seulement faire ce que vous devez pour la quête."
				msg(pid, message)
				tes3mp.MessageBox(pid, -1, message)
				doLog(Players[pid].accountName .. " entré dans la maison fermée à clé" .. hdata.name .. " en tant que visiteur autorisé à entrer car la cellule est marquée comme requiredAccess")
			elseif canEnter == false then
				msg(pid, "Le propriétaire a fermé la maison.")
				local destinationCell, destinationPos
				if hdata.outside.cell then --There's exit data saved for this house
					destinationCell = hdata.outside.cell
					destinationPos = hdata.outside.pos
				else
					--Without any data for an exit, we default to placing the players back at spawn
					destinationCell = serverConfig.defaultSpawnCell
					destinationPos = {x = serverConfig.defaultSpawnPos[1], y = serverConfig.defaultSpawnPos[2], z = serverConfig.defaultSpawnPos[3]}
				end
				doLog(Players[pid].accountName .. " tenté d'entrer dans la maison fermée à clé" .. hdata.name .. "mais a été jeté parce qu'ils n'ont pas la permission d'être là")
				warpPlayer(pid, destinationCell, destinationPos)
			end
			
			lastEnteredHouse[getName(pid)] = hdata.name
		else
			--Not in a housing cell
			lastEnteredHouse[getName(pid)] = nil
		end
	end	
end

Methods.OnObjectLock = function(pid, cellDescription)
	unlockChecks(cellDescription)
end

Methods.OnContainer = function(pid, cellDescription)
	doLog("DEBUG: Container stuff start")
	tes3mp.ReadLastEvent()
	doLog("DEBUG: Container stuff Read Event")
	local action = tes3mp.GetEventAction()
	doLog("DEBUG: Container stuff got action")
	local pname
	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		pname = Players[pid].name
	else
		return
	end
	
	local houseName, cdata = getIsInHouse(pid)
	
	if not houseName then -- The player isn't in a house cell, so we don't care
		return false
	end
	
	if not getHouseOwnerName(houseName) then --It's not really stealing if nobody owns the house
		return false
	end
	
	if tes3mp.GetObjectChangesSize() < 1 then --Something funky is going on and causes crashes if we continue
		return false
	end
	
	--Get the container's data
	local refIndex = tes3mp.GetObjectRefNumIndex(0) .. "-" .. tes3mp.GetObjectMpNum(0)
	doLog("DEBUG: Container stuff Got refIndex")
	local refId = tes3mp.GetObjectRefId(0)
	doLog("DEBUG: Container stuff Got refId")
	
	if action == enumerations.container.REMOVE then
		if not isOwner(pname, houseName) and not isCoOwner(pname, houseName) then --We aren't interested in what the owners or co owners get up to in the cells they own.
			--Check if the container is listed in the cell's resetInfo, to see if they're taking from a container important for a quest.
			local dirtyThief = true --Guilty until proven innocent
			for index, resetData in pairs(cdata.resetInfo) do
				if resetData.refIndex == refIndex then
					dirtyThief = false
					break
				end
			end
			
			if dirtyThief then
				doLog("Voleur potentiel :" .. getName(pid) .. "a pris un objet du récipient" .. refIndex .. " dans " .. cdata.name .. " (Partie de " .. getHouseOwnerName(cdata.house) .. "La maison: " .. cdata.house .. ")Et ce conteneur n'a pas été marqué comme un conteneur de quête!")
				onDirtyThief(pid)
			else
				doLog(getName(pid) .. " a pris un objet du récipient " .. refIndex .. " dans " .. cdata.name .. " (Partie de " .. getHouseOwnerName(cdata.house) .. "La maison: " .. cdata.house .. ") mais c'est bon parce qu'il est marqué comme un conteneur de quête.") --Necessary to log?
			end
		end
	elseif action == enumerations.container.SET then
		doLog("DEBUG: Container stuff container is SET")
		if not isOwner(pname, houseName) and not isCoOwner(pname, houseName) then --We aren't interested in what the owners or co owners get up to in the cells they own.
			--Check if the container is listed in the cell's resetInfo, to see if they're taking from a container important for a quest.
			local dirtyThief = true --Guilty until proven innocent
			for index, resetData in pairs(cdata.resetInfo) do
				if resetData.refIndex == refIndex then
					dirtyThief = false
					break
				end
			end
			
			if dirtyThief then
				doLog("Voleur potentiel : " .. getName(pid) .. " Peut avoir pris tout du conteneur" .. refIndex .. " dans " .. cdata.name .. " (Partie de " .. getHouseOwnerName(cdata.house) .. "la maison: " .. cdata.house .. ")Et ce conteneur n'a pas été marqué comme un conteneur de quête! Il se peut, cependant, qu'ils aient juste généré la cellule pour la première fois.")
			else
				doLog(getName(pid) .. "Peut avoir pris tout du conteneur " .. refIndex .. " dans " .. cdata.name .. " (partie de " .. getHouseOwnerName(cdata.house) .. "la maison: " .. cdata.house .. ")mais c'est bon parce qu'il est marqué comme un conteneur de quête.") --Necessary to log?
			end
		end
	end
	doLog("DEBUG: Container stuff done")
end

Methods.OnObjectDelete = function (pid, cellDescription)
	tes3mp.ReadLastEvent()
	local pname
	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		pname = Players[pid].name
	else
		return
	end
	
	local houseName, cdata = getIsInHouse(pid)
	
	if not houseName then -- The player isn't in a house cell, so we don't care
		return false
	end
	
	if not getHouseOwnerName(houseName) then --It's not really stealing if nobody owns the house
		return false
	end
	
	--Get the item's data
	local refIndex = tes3mp.GetObjectRefNumIndex(0) .. "-" .. tes3mp.GetObjectMpNum(0)
	local refId = tes3mp.GetObjectRefId(0)
		
	if not isOwner(pname, houseName) and not isCoOwner(pname, houseName) then --We aren't interested in what the owners or co owners get up to in the cells they own.
		--Check if the container is listed in the cell's resetInfo, to see if they're taking an item important for a quest.
		local dirtyThief = true --Guilty until proven innocent
		for index, resetData in pairs(cdata.resetInfo) do
			if resetData.refIndex == refIndex then
				dirtyThief = false
				break
			end
		end
			
		if dirtyThief then
			doLog("Voleur potentiel " .. getName(pid) .. " ramassé un objet non-quête(" .. refIndex .. " - " .. refId ..") dans " .. cdata.name .. " (partie de " .. getHouseOwnerName(cdata.house) .. "la maison: " .. cdata.house .. ")!")
			onDirtyThief(pid)
		else
			doLog(getName(pid) .. "ramassé un objet de quête (" .. refIndex .. " - " .. refId ..") dans " .. cdata.name .. " (partie de " .. getHouseOwnerName(cdata.house) .. "la maison: " .. cdata.house .. "), ce qui est bon.") --Necessary to log?
		end
	end
end

-------------------

Methods.GetCellData = function(cell)
	return housingData.cells[cell] or false
end

Methods.GetHouseData = function(houseName)
	return housingData.houses[houseName] or false
end

Methods.GetOwnerData = function(ownerName)
	local oname = string.lower(ownerName)
	return housingData.owners[oname] or false
end

--If you change any of the housingData using external scripts, be sure to use this to save the changes afterwards.
Methods.Save = function()
	return Save()
end

Methods.CreateNewHouse = function(houseName)
	return createNewHouse(houseName)
end

Methods.CreateNewCell = function(cellDescription)
	return createNewCell(cellDescription)
end

Methods.CreateNewOwner = function(oname)
	return createNewOwner(oname)
end

Methods.GetHouseOwnerName = function(houseName)
	return getHouseOwnerName(houseName)
end

Methods.GetIsInHouse = function(pid)
	return getIsInHouse(pid)
end

Methods.IsOwner = function(pname, houseName)
	return isOwner(pname, houseName)
end

Methods.IsCoOwner = function(pname, houseName)
	return isCoOwner(pname, houseName)
end

Methods.IsLocked = function(houseName)
	return isLocked(houseName)
end
-------------------

return Methods

config.PlayerRemoveCoOwnerGUI = 31384
config.PlayerSellConfirmGUI = 31385

-------------------
jsonInterface = require("jsonInterface")
myMod = require("myMod")
inventoryHelper = require("inventoryHelper")
color = require("color")
local serverConfig = require("config")
actionTypes = require("actionTypes")

local Methods = {}
--Forward Declarations:
local showAdminMain, showHouseCreate, showAdminHouseSelect, showCellEditMain, showHouseEditMain, showHouseEditPricePrompt, showHouseEditOwnerPrompt, showHouseInfo, showUserMain, showAllHousesList, showPlayerSettingsMain, showPlayerSettingsOwnedList, showPlayerSettingsAddPrompt, showPlayerSettingsRemoveList, showPlayerSellOptions, onLockStatusChange
-------------------
local housingData = {houses = {}, cells = {}, owners = {}}

-------------------
local function doLog(text)
	if config.logging then
		tes3mp.LogMessage(1, "[kanaHousing] " .. text)
	end
end

local function msg(pid, text)
	tes3mp.SendMessage(pid, config.chatColor .. text .. "\n" .. color.Default)
end

local function Save()
	jsonInterface.save("kanaHousing.json", housingData)
end

local function Load()
	housingData = jsonInterface.load("kanaHousing.json")
end

Methods.OnServerPostInit = function()
	local file = io.open(os.getenv("MOD_DIR") .. "/kanaHousing.json", "r")
	if file ~= nil then
		io.close()
		Load()
	else
		Save()
	end
end
-------------------
local function getName(pid) --Slightly different from the usual one I use
	return string.lower(Players[pid].accountName)
end

--Returns the amount of gold in a player's inventory
local function getPlayerGold(playerName) --playerName is the name of the player (capitalization doesn't matter)
	local player = myMod.GetPlayerByName(playerName)
	
	if player then
		local goldLoc = inventoryHelper.getItemIndex(player.data.inventory, "gold_001", -1)
		
		if goldLoc then
			return player.data.inventory[goldLoc].count
		else
			return 0
		end
	else
		--Couldn't find the player
		return false
	end
end

local function addGold(playerName, amount) --playerName is the name of the player to add the gold to (capitalization doesn't matter). Amount is the amount of gold to add (can be negative if you want to subtract gold).
	--Find the player
	local player = myMod.GetPlayerByName(playerName)
	
	--Check we found the player before proceeding
	if player then
		--Look through their inventory to find where their gold is, if they have any
		local goldLoc = inventoryHelper.getItemIndex(player.data.inventory, "gold_001", -1)
		
		--If they have gold in their inventory, edit that item's data. Otherwise make some new data.
		if goldLoc then
			player.data.inventory[goldLoc].count = player.data.inventory[goldLoc].count + amount
			
			--If the total is now 0 or lower, remove the entry from the player's inventory.
			if player.data.inventory[goldLoc].count < 1 then
				player.data.inventory[goldLoc] = nil
			end
		else
			--Only create a new entry for gold if the amount is actually above 0, otherwise we'll have negative money.
			if amount > 0 then
				table.insert(player.data.inventory, {refId = "gold_001", count = amount, charge = -1})
			end
		end
		
		--How we save the character is different depending on whether or not the player is online
		if player:IsLoggedIn() then
			--If the player is logged in, we have to update their inventory to reflect the changes
			player:Save()
			player:LoadInventory()
			player:LoadEquipment()
		else
			--If the player isn't logged in, we have to temporarily set the player's logged in variable to true, otherwise the Save function won't save the player's data
			player.loggedIn = true
			player:Save()
			player.loggedIn = false
		end
		
		return true
	else
		--Couldn't find any existing player with that name
		return false
	end
end

local function warpPlayer(pid, cell, pos, rot)
	tes3mp.SetCell(pid, cell)
	tes3mp.SendCell(pid)
	
	tes3mp.SetPos(pid, pos.x, pos.y, pos.z)
	--Rotation isn't actually used here :P
	tes3mp.SendPos(pid)
end

local function createNewHouse(houseName)
	housingData.houses[houseName] = {
		name = houseName, --The house name
		price = config.defaultPrice, --How much the house costs
		cells = {}, --Contains the names of cells associated with the house as keys
		doors = {}, --Contains the information on all the doors associated with the house, so the script can make sure that they're always unlocked. Requires manually editing the .json to add entries.
		--[[
			cell --The cell name
				{[INDEXED table containing table containing door's refId and refIndex under associated keys]}
		]]
		inside = {},
		outside = {},
	}
	Save()
end

local function createNewOwner(oname)
	local oname = string.lower(oname)
	housingData.owners[oname] = {
		houses = {},
	}
	Save()
end

local function createNewCell(cellDescription)
	housingData.cells[cellDescription] = {
		name = cellDescription, --Name of the cell
		house = nil, --Name of house that the cell is assigned to
		ownedContainers = false, --If the cell contains any containers marked as owned
		requiredAccess = false, --If the cell needs to be accessed/passed through for a quest
		requiresResets = false, --If the cell contains items/people etc. needed for a quest
		resetInfo = {}, --Contains more nuanced information on what exactly should be reset if requiresResets is true. Requires manually editing the .json to add entries, and a cell reset script that supports more precise resetting to begin with. If this is empty, the whole cell should just be reset
		--[[ Contains INDEXED tables of tables containing the items refIndex, refId, and instructions on what to do if it's missing
			{refIndex = a_refIndex, refId = a_refId, instruction = "replace"},
			{[Another example]}
			The instructions that I'm coining here are: "refill" - if the object is an irremovable container that needs its contents re-added (for example: the crate of limeware and silverware found in Chun-Ook's Lower Level for the quest "Liberate the Limeware"). "replace" - if the object is removable such as an in-world item or a creature/NPC that needs to exist for a quest (for example: the placed Vintage Brandy in Hlaalo Manor for the quest "The Vintage Brandy", or Ralen Hlaalo's corpse in the same place for the quest "The Death of Ralen Hlaalo" (activating the corpse isn't necessarily required for the quest, but is one of the ways to start it))
		]]
	}
	Save()
end

--Slightly hacky method for storing players' login names. Could probably do something fancy to get it.
local function registerName(pid)
	housingData.loginNames[getName(pid)] = Players[pid].data.login.name
end

local function deleteHouse(houseName)
	housingData.houses[houseName] = nil
	for cellName, v in pairs(housingData.cells) do
		if housingData.cells[cellName].house == houseName then
			housingData.cells[cellName].house = nil
		end
	end
	Save()
end

local function setHousePrice(houseName, price)
	if housingData.houses[houseName] then
			housingData.houses[houseName].price = tonumber(price) or config.defaultPrice --If the price somehow isn't a valid number, use the default price
		Save()
	end
end

local function getHouseOwnerName(houseName)
	for pname, v in pairs(housingData.owners) do
		if housingData.owners[pname].houses[houseName] ~= nil then
			return pname
		end
	end
	--If we get to here, we didn't find it
	return false
end

--Returns the name of the house they're in or false. If they're in a house, also returns the celldata of the cell that they're in.
local function getIsInHouse(pid)
	local currentCell = tes3mp.GetCell(pid)
	
	if housingData.cells[currentCell] and housingData.cells[currentCell].house ~= nil then
		return housingData.cells[currentCell].house, housingData.cells[currentCell]
	else
		return false
	end
end

local function assignCellToHouse(cell, houseName)
	if housingData.houses[houseName] then
		housingData.houses[houseName].cells[cell] = true
		housingData.cells[cell].house = houseName
		doLog("Assigned " .. cell .. " to " .. houseName)
		Save()
	end
end

local function removeCellFromHouse(cell, houseName)
	if housingData.houses[houseName] then
		housingData.houses[houseName].cells[cell] = nil
		housingData.cells[cell].house = nil
		Save()
	end
end

--furnReturn = "return" - remove furniture and add back to furniture inventory. "sell" remove and add resale value to player. "remove" - delete them all.
local function removeHouseOwner(houseName, refund, furnReturn)
	local oname = getHouseOwnerName(houseName)
	local hdata = housingData.houses[houseName]
	
	if not oname or not hdata then
		return false
	end

	if refund then
		addGold(oname, hdata.price)
	end
	
	if kanaFurniture ~= nil then
		for cellName, v in pairs(hdata.cells) do
			kanaFurniture.RemoveAllPermissions(cellName) --Remove the furniture placing permissions for the owner and coowners
			--For now, no matter the settings, the co-owners furniture always gets returned to them
			for coName, v in pairs(housingData.owners[oname].houses[houseName].coowners) do
				kanaFurniture.RemoveAllPlayerFurnitureInCell(coName, cellName, true)
			end
		end
		
		if furnReturn == "return" then
			for cellName, v in pairs(hdata.cells) do
				kanaFurniture.RemoveAllPlayerFurnitureInCell(oname, cellName, true)
			end
		elseif furnReturn == "sell" then
			local placedNum = 0
			local placedSellback = 0
		
			for cellName, v in pairs(hdata.cells) do
				local placed = kanaFurniture.GetPlacedInCell(cellName)
				if placed then
					for refIndex, v2 in pairs(placed) do
						if v2.owner == oname then
							placedNum = placedNum + 1
							placedSellback = placedSellback + kanaFurniture.GetSellBackPrice(kanaFurniture.GetFurnitureDataByRefId(v2.refId).price)
						end
					end
				end
				kanaFurniture.RemoveAllPlayerFurnitureInCell(oname, cellName, false)
			end
			
			addGold(oname, placedSellback)			
		end
	end
	
	housingData.owners[oname].houses[houseName] = nil
	Save()
	doLog(oname .. " a été retiré en tant que propriétaire de" .. houseName)
end

local function addHouseOwner(oname, houseName)
	local oname = string.lower(oname)
	local hdata = housingData.houses[houseName]
	if not housingData.owners[oname] then
		createNewOwner(oname)
	end
	--TODO Make all the other data
	housingData.owners[oname].houses[houseName] = {}
	housingData.owners[oname].houses[houseName].coowners = {}
	housingData.owners[oname].houses[houseName].isLocked = false
	-- TODO: Assign leftover kanaFurniture stuff to new owner?
	if kanaFurniture ~= nil then
		--Give the player permission to place furniture in all of the house's cells
		for cellName, v in pairs(hdata.cells) do
			kanaFurniture.AddPermission(oname, cellName)
		end
	end
	
	Save()
	doLog(oname .. " a été défini comme le propriétaire de " .. houseName)
end

local function addCoOwner(houseName, pname)
	local pname = string.lower(pname)
	local oname = getHouseOwnerName(houseName)
	local hdata = housingData.houses[houseName]
	
	if pname ~= oname then
		housingData.owners[oname].houses[houseName].coowners[pname] = true
		
		if kanaFurniture ~= nil then
			--Give the player permission to place furniture in all of the house's cells
			for cellName, v in pairs(hdata.cells) do
				kanaFurniture.AddPermission(pname, cellName)
			end
		end
	end
	
	Save()
end

local function removeCoOwner(houseName, pname)
	local pname = string.lower(pname)
	local oname = getHouseOwnerName(houseName)
	local hdata = housingData.houses[houseName]
	
	housingData.owners[oname].houses[houseName].coowners[pname] = nil
	
	if kanaFurniture ~= nil then
		--Remove the player's permission to place furniture in all of the house's cells, as well as return all the furniture that they placed.
		for cellName, v in pairs(hdata.cells) do
			kanaFurniture.RemovePermission(pname, cellName)
			kanaFurniture.RemoveAllPlayerFurnitureInCell(pname, cellName, true)
		end
	end
	
	Save()
	--Hack to trigger a reassessment to see if they should still be allowed in the house if they were in it when they were removed
	onLockStatusChange(houseName)
end

local function getHouseInfoLong(houseName, toggleMeanings) --Used in GUI labels
	local text = ""
	local hdata = housingData.houses[houseName]
	if not hdata then
		return false
	end
	
	text = text .. "=" .. hdata.name .. "=\n"
	local owner = "Personne"
	if getHouseOwnerName(hdata.name) then
		owner = getHouseOwnerName(hdata.name)
	end
	text = text .. "La maison vaut" .. hdata.price .. " or, actuellement détenue par " .. owner .. ".\n"
	
	local hasOwned, hasAccess, hasResets
	text = text .. "L'intérieur de la maison est constitué des cellules suivantes:\n"
	for cellName, v in pairs(hdata.cells) do
		local cdata = housingData.cells[cellName]
		local addText = "* "
		addText = addText .. cellName
		if cdata.ownedContainers then
			addText = addText .. " | Contient des conteneurs en propriété"
			hasOwned = true
		end
		if cdata.requiredAccess then
			addText = addText .. " | Est-ce que le passage est requis"
			hasAccess = true
		end
		if cdata.requiresResets then
			addText = addText .. " | Requiert des réinitialisations de cellules"
			hasResets = true
		end
		
		addText = addText .. "\n"
		text = text .. addText
	end
	
	if toggleMeanings then
		if hasOwned or hasAccess or hasResets then
			text = text .. "\n"
			if hasOwned then
				text = text .. "Si une cellule est marquée avec «conteneurs en propriété», cela signifie que certains ou tous les conteneurs de la cellule sont désignés en tant que NPC. Si vous deviez stocker et retirer des objets d'un conteneur appartenant à l'utilisateur, ces articles seront marqués comme volés"
			end
			if hasAccess then
				text = text .. "Les passages obligatoires sont des cellules auxquelles les autres joueurs doivent accéder, ou passer pour effectuer certaines quêtes. Les cellules marquées comme telles peuvent toujours être entrées par les joueurs, même si la maison est verrouillée."
			end
			if hasResets then
				text = text .. "Selon la façon dont le serveur est exécuté, les cellules marquées comme nécessitant des réinitialisations peuvent parfois réinitialiser une partie ou la totalité de leur contenu. Contactez un administrateur de serveur pour demander comment le serveur actuel gère les réinitialisations de cellule."
			end
		end
	end
	
	return text
end

--Not actually used because I realised that the script actually uses the names from the lists to find the correct house...
local function getHouseInfoShort(houseName) --Used as entries for lists
	local text = ""
	local hdata = housingData.houses[houseName]
	if not hdata then
		return false
	end
	
	text = text .. hdata.name
	
	text = text .. " - Vaut " .. hdata.price
	
	local owner = "Personne"
	if getHouseOwnerName(hdata.name) then
		owner = getHouseOwnerName(hdata.name)
	end
	
	text = text .. " - Possédé par " .. owner	
	
	return text
end

local function assignHouseInside(houseName, cell, x, y, z)
	local hdata = housingData.houses[houseName]
	if not hdata then
		return false
	end
	
	hdata.inside.cell = cell
	hdata.inside.pos = {x = x, y = y, z = z}
	
	Save()	
end

local function assignHouseOutside(houseName, cell, x, y, z)
	local hdata = housingData.houses[houseName]
	if not hdata then
		return false
	end
	
	hdata.outside.cell = cell
	hdata.outside.pos = {x = x, y = y, z = z}
	
	Save()	
end

local function isOwner(pname, houseName)
	local pname = string.lower(pname)
	--Assumes that the house is valid, etc.
	if getHouseOwnerName(houseName) == pname then
		return true
	else
		return false
	end
end

local function isCoOwner(pname, houseName)
	local pname = string.lower(pname)
	--Assumes that the house is valid, etc.
	local oname = getHouseOwnerName(houseName)
	for coOwner, v in pairs(housingData.owners[getHouseOwnerName(houseName)].houses[houseName].coowners) do
		if pname == string.lower(coOwner) then
			return true
		end
	end
	return false
end

local function isLocked(houseName)
	if getHouseOwnerName(houseName) then
		return housingData.owners[getHouseOwnerName(houseName)].houses[houseName].isLocked
	else
		return false
	end
end

--Used for determining if a player is allowed in a cell. Returns if they are allowed, as well as the reason why they are/aren't allowed.
local function isAllowedEnter(pid, cell)
	local pname = getName(pid)
	local cdata = housingData.cells[cell]
	
	if not cdata or cdata.house == nil then
		return true, "no data"
	end
	
	local hdata = housingData.houses[cdata.house]
	
	if not hdata then
		return true, "no data"
	end
	
	if isLocked(hdata.name) then
		if isOwner(pname, hdata.name) then
			return true, "owner"
		elseif isCoOwner(pname, hdata.name) then
			return true, "coowner"
		elseif Players[pid].data.settings.admin > 0 then --Moderators/Admins should always be allowed to enter
			return true, "admin"
		elseif cdata.requiredAccess then
			return true, "access"
		else
			return false, "close"
		end
	elseif not getHouseOwnerName(hdata.name) then --There's no owner
		return true, "unowned"
	else
		return true, "unlocked"
	end
end

local function canWarp(pid)
	return config.allowWarp
end

--Checks through all the recorded door data to find any records of doors in the provided cell. Makes sure the doors in the cell are all unlocked, and if they're not, unlocks them.
local function unlockChecks(cell)	
	local changes = false
	for houseName, hdata in pairs(housingData.houses) do
		for cellName, ddata in pairs(hdata.doors) do
			if cellName == cell then
				if LoadedCells[cell] == nil then
					myMod.LoadCell(cell)
				end
				
				for i, doorData in pairs(ddata) do
					local refIndex = doorData.refIndex
					local refId = doorData.refId
					if not LoadedCells[cell]:ContainsObject(refIndex) then
						LoadedCells[cell]:InitializeObjectData(refIndex, refId)
						changes = true
					end
					
					if not LoadedCells[cell].data.objectData[refIndex].lockLevel or LoadedCells[cell].data.objectData[refIndex].lockLevel ~= 0 then
						LoadedCells[cell].data.objectData[refIndex].lockLevel = 0
						tableHelper.insertValueIfMissing(LoadedCells[cell].data.packets.lock, refIndex)
						changes = true
					end
				end
				
			end
		end
	end
	
	if changes then
		LoadedCells[cell]:Save()
		for playerId, player in pairs(Players) do
			if player:IsLoggedIn() then
				LoadedCells[cell]:SendObjectsLocked(playerId)
			end
		end
	end
end

onLockStatusChange = function(houseName) --forward declared
	local hdata = housingData.houses[houseName]
	local destinationCell, destinationPos
	if hdata.outside.cell then --There's exit data saved for this house
		destinationCell = hdata.outside.cell
		destinationPos = hdata.outside.pos
	else
		--Without any data for an exit, we default to placing the players back at spawn
		destinationCell = serverConfig.defaultSpawnCell
		destinationPos = {x = serverConfig.defaultSpawnPos[1], y = serverConfig.defaultSpawnPos[2], z = serverConfig.defaultSpawnPos[3]}
	end
	
	if isLocked(houseName) then
		for playerId, player in pairs(Players) do
			if player:IsLoggedIn() then
				local inHouse, cdata = getIsInHouse(playerId)
				
				if inHouse == houseName then
					local canEnter, reason = isAllowedEnter(playerId, cdata.name)
					if reason == "owner" or reason == "coowner" or reason == "admin" then
						--Do Nothing
					elseif reason == "access" then
						msg(playerId, "Le propriétaire a verrouillé la maison, mais vous êtes autorisé à rester puisque la cellule dans laquelle vous vous trouvez est marquée comme une cellule d'accès requise.")
					else
						--Kick 'em out
						warpPlayer(playerId, destinationCell, destinationPos)
						msg(playerId, "Le propriétaire a fermé la maison.")
					end
				end
			end
		end
	end
	
	if isLocked(houseName) then
		doLog(getHouseOwnerName(houseName) .. " a verrouillé" .. hdata.name)
	else
		doLog(getHouseOwnerName(houseName) .. " a débloqué " .. hdata.name)
	end
end

local function onDirtyThief(pid)
	--Do nothing, for now. Future version could implement auto-banning if wanted, or a system that automatically returns the taken items.
	tes3mp.MessageBox(pid, -1, "Cela ne vous appartient pas. Remettre.")
end

-------------------
local adminSelectedHouse = {}
local adminHouseList = {}
local playerSelectedHouse = {}
local playerAllHouseList = {}
local playerOwnedHouseList = {}
local playerCoOwnerList = {}

-- PLAYER SELL OPTIONS
showPlayerSellOptions = function(pid)
	local message = ""
	local buttons = ""
	
	local hdata = housingData.houses[playerSelectedHouse[getName(pid)]]
	if kanaFurniture ~= nil then
		local placedNum = 0
		local placedSellback = 0
		
		for cellName, v in pairs(hdata.cells) do
			local placed = kanaFurniture.GetPlacedInCell(cellName)
			if placed then
				for refIndex, v2 in pairs(placed) do
					if v2.owner == getName(pid) then
						placedNum = placedNum + 1
						placedSellback = placedSellback + kanaFurniture.GetSellBackPrice(kanaFurniture.GetFurnitureDataByRefId(v2.refId).price)
					end
				end
			end
		end
	
		message = message .. hdata.name .. " vaut la peine" .. hdata.price .. " or. le" .. placedNum .. "les meubles que vous avez placés à l'intérieur ont une valeur de " .. placedSellback .. " or. Remarque: La vente de la maison rapportera tous les meubles placés par le copropriétaire dans son inventaire de meubles."
		buttons = "Vendre une maison + meubles;Vendre une maison + Collecter des meubles;Annuler"
	else
		message = message .. hdata.name .. " vaut la peine" .. hdata.price .. " or."
		buttons = "Vendre une maison;Annuler"
	end
	
	tes3mp.CustomMessageBox(pid, config.PlayerSellConfirmGUI, message, buttons)
end

local function onPlayerSellHouseAndFurniture(pid)
	removeHouseOwner(playerSelectedHouse[getName(pid)], true, "vendre")
end

local function onPlayerSellHouseAndCollect(pid)
	removeHouseOwner(playerSelectedHouse[getName(pid)], true, "revenir")
end

local function onPlayerSellHouse(pid)
	removeHouseOwner(playerSelectedHouse[getName(pid)], true)
end

-- PLAYER SETTINGS REMOVE CO-OWNER
showPlayerSettingsRemoveList = function(pid)
	local message = "Sélectionnez un copropriétaire à supprimer. Note: Retrait d'un copropriétaire va retourner tous leurs meubles."
	--Generate a list of options
	local options = {}	
	local list = "* CLOSE *\n"
	local coOwners = housingData.owners[getName(pid)].houses[playerSelectedHouse[getName(pid)]].coowners
	
	for coname, v in pairs(coOwners) do
		table.insert(options, coname)
	end
	for i=1, #options do
		list = list .. options[i]
		if not (i == #options) then
			list = list .. "\n"
		end
	end
	
	playerCoOwnerList[getName(pid)] = options
	return tes3mp.ListBox(pid, config.PlayerRemoveCoOwnerGUI, message, list)
end

local function onCoOwnerRemoveSelect(pid, index)
	removeCoOwner(playerSelectedHouse[getName(pid)], playerCoOwnerList[getName(pid)][index])
	return showPlayerSettingsMain(pid)
end

-- PLAYER SETTINGS ADD CO-OWNER
showPlayerSettingsAddPrompt = function(pid)
	local message = "Tapez le nom du personnage à ajouter en tant que copropriétaire"
	
	return tes3mp.InputDialog(pid, config.PlayerAddCoOwnerGUI, message)
end

local function onPlayerSettingsAddPrompt(pid, data)
	if data == nil or data == "" then
		--Do nothing
	else
		addCoOwner(playerSelectedHouse[getName(pid)], string.lower(data))
	end
	return showPlayerSettingsMain(pid)
end

-- PLAYER SETTINGS OWNED LIST
showPlayerSettingsOwnedList = function(pid)
	local message = "Sélectionnez une maison appartenant à la liste"
	--Generate a list of options
	local options = {}	
	local list = "* CLOSE *\n"
	
	for houseName, v in pairs(housingData.houses) do
		if getHouseOwnerName(houseName) == getName(pid) then
			table.insert(options, houseName)
		end
	end
	for i=1, #options do
		list = list .. options[i]
		if not (i == #options) then
			list = list .. "\n"
		end
	end
	
	playerOwnedHouseList[getName(pid)] = options
	return tes3mp.ListBox(pid, config.PlayerOwnedHouseSelect, message, list)
end

local function onPlayerOwnedHouseSelect(pid, index)
	playerSelectedHouse[getName(pid)] = playerOwnedHouseList[getName(pid)][index]
	return
end

-- PLAYER SETTINGS MAIN
showPlayerSettingsMain = function(pid)
	local message = ""
	if playerSelectedHouse[getName(pid)] and getHouseOwnerName(playerSelectedHouse[getName(pid)]) ~= getName(pid) then
		playerSelectedHouse[getName(pid)] = nil
	end
	
	message = message .. "#red ..Maison actuellement sélectionnée: " .. (playerSelectedHouse[getName(pid)] or "Aucune") .. "\n\n\n"
	
	if playerSelectedHouse[getName(pid)] then
		local hdata = housingData.houses[playerSelectedHouse[getName(pid)]]
		
		message = message .. "La maison est actuellement "
		if isLocked(hdata.name) then
			message = message .. "fermé à clef.\n"
		else
			message = message .. "déverrouillé.\n"
		end
		--TODO: More?
	end
	
	message = message .. "\n"
	message = message .. "#cyan .Sélectionner la maison dont vous souhaitez modifier les paramètres.\n\n Pour ajouter un copropriétaire, utilisez 'Ajouter un copropriétaire' ou supprimez-en un avec 'Supprimer le copropriétaire'. Les copropriétaires sont autorisés à entrer dans votre maison pendant qu'elle est verrouillé mais ne peuvent pas ce teleporter.\n\n'Verrouiller' est utilisé pour verrouiller / déverrouiller la maison. Lorsqu'il est verrouillé, personne, sauf les propriétaires, les co-propriétaires ou les administrateures, ne peuvent entrer dans la maison.\n\n 'Teleporter' vous téléportera à la maison.\n\n Utilisez 'Vendre une maison' si vous voulez la vendre.\n\n"
	
	return tes3mp.CustomMessageBox(pid, config.PlayerSettingGUI, message, "Sélectionnez la maison possédée;ajoutez le copropriétaire;enlevez le copropriétaire;verrouillez le verrou;teleportez à la maison;vendez la maison;fermez")
end

local function onPlayerSettingsOwned(pid)
	showPlayerSettingsOwnedList(pid)
end

local function onPlayerSettingsAdd(pid)
	if playerSelectedHouse[getName(pid)] then
		showPlayerSettingsAddPrompt(pid)
	else
		return tes3mp.MessageBox(pid, -1, "Vous n'avez pas la maison sélectionnée.")
	end
end

local function onPlayerSelectRemove(pid)
	if playerSelectedHouse[getName(pid)] then
		showPlayerSettingsRemoveList(pid)
	else
		return tes3mp.MessageBox(pid, -1, "Vous n'avez pas la maison sélectionnée.")
	end
end

local function onPlayerSelectLock(pid)
	if playerSelectedHouse[getName(pid)] then
		housingData.owners[getName(pid)].houses[playerSelectedHouse[getName(pid)]].isLocked = (not housingData.owners[getName(pid)].houses[playerSelectedHouse[getName(pid)]].isLocked)
		Save()
		onLockStatusChange(playerSelectedHouse[getName(pid)])
	else
		return tes3mp.MessageBox(pid, -1, "Vous n'avez pas la maison sélectionnée.")
	end
	return showPlayerSettingsMain(pid)
end

local function onPlayerSelectWarp(pid)
	if not canWarp(pid) then
		local message
		if config.allowWarp == false then
			message = "La fonction déformer est désactivée sur ce serveur."
		else
			message = "Vous ne pouvez pas déformer en ce moment."
		end
		return false, tes3mp.MessageBox(pid, -1, message, false)
	end
	
	if playerSelectedHouse[getName(pid)] then
		local destinationCell
		local destinationPos
		
		local hdata = housingData.houses[playerSelectedHouse[getName(pid)]]
		--If there isn't a defined entrance, we have to get a bit janky
		if not hdata.inside.cell then
			for cellName, v in pairs(hdata.cells) do
				destinationCell = cellName --Assign the first cell we come across as the destination one. This means it might occasionally change where they are put.
				break
			end
			destinationPos = {x = 0, y = 0, z = 0} --Without anything to work with, we're just going to have to use the default position and hope for the best
		else
			destinationCell = hdata.inside.cell
			destinationPos = hdata.inside.pos
		end
		
		warpPlayer(pid, destinationCell, destinationPos)
	else
		return tes3mp.MessageBox(pid, -1, "Vous n'avez pas la maison sélectionnée.")
	end
end

local function onPlayerSelectSell(pid)
	--TODO
	if playerSelectedHouse[getName(pid)] then
		showPlayerSellOptions(pid)
	else
		return tes3mp.MessageBox(pid, -1, "Vous n'avez pas la maison sélectionnée.")
	end
end

-- PLAYER SELECT HOUSE ALL LIST
showAllHousesList = function(pid)
	local message = "Sélectionnez une maison dans la liste pour en savoir plus."
	
	--Generate a list of options
	local options = {}	
	local list = "* CLOSE *\n"
	
	for houseName, v in pairs(housingData.houses) do
		table.insert(options, houseName)
	end
	for i=1, #options do
		list = list .. options[i]
		if not (i == #options) then
			list = list .. "\n"
		end
	end
	
	playerAllHouseList[getName(pid)] = options
	return tes3mp.ListBox(pid, config.PlayerAllHouseSelectGUI, message, list)
end

local function onPlayerAllHouseSelect(pid, index)
	playerSelectedHouse[getName(pid)] = playerAllHouseList[getName(pid)][index]
	return showHouseInfo(pid)
end

-- PLAYER HOUSE CONTROL MAIN
showUserMain = function(pid)
	local message = "#red ..MENU DU LOGEMENT.\n\n\n#blue .Liste de toutes les maisons pour afficher la liste de toutes les maisons disponibles.\n\n#cyan .Modifier les paramètres de la maison pour configurer les maisons que vous possédez."
	tes3mp.CustomMessageBox(pid, config.PlayerMainGUI, message, "Liste de toutes les maisons;Modifier les paramètres de la maison;Fermer")
end

local function onPlayerMainList(pid)
	showAllHousesList(pid)
end

local function onPlayerMainEdit(pid)
	showPlayerSettingsMain(pid)
end

-- PLAYER HOUSE INFO
showHouseInfo = function(pid)
	local message = ""
	local hdata
	if not playerSelectedHouse[getName(pid)] or not housingData.houses[playerSelectedHouse[getName(pid)]] then
		local pcell = tes3mp.GetCell(pid)
		if housingData.cells[pcell] and housingData.cells[pcell].house and housingData.houses[housingData.cells[pcell].house] then
			hdata = housingData.houses[housingData.cells[pcell].house]
			playerSelectedHouse[getName(pid)] = hdata.name
		end
	else
		hdata = housingData.houses[playerSelectedHouse[getName(pid)]]
	end
	
	if hdata then
		message = message .. getHouseInfoLong(hdata.name, true)
	else
		message = message .. "Vous n'avez pas de maison sélectionnée, vous n'êtes pas non plus dans une maison."
		playerSelectedHouse[getName(pid)] = nil
	end
	
	return tes3mp.CustomMessageBox(pid, config.HouseInfoGUI, message, "Acheter;Fermer")
end

local function onHouseInfoBuy(pid)
	local hdata = housingData.houses[playerSelectedHouse[getName(pid)]]
	
	if hdata then
		if getHouseOwnerName(hdata.name) and getHouseOwnerName(hdata.name) ~= getName(pid) then
			return tes3mp.MessageBox(pid, -1, "Quelqu'un possède déjà cette maison!")
		elseif getHouseOwnerName(hdata.name) == getName(pid) then
			return tes3mp.MessageBox(pid, -1, "Vous possédez déjà cette maison.")
		else
			if getPlayerGold(getName(pid)) < hdata.price then
				return tes3mp.MessageBox(pid, -1, "Vous ne pouvez pas vous permettre cette maison.")
			end
			--Do the actual selling
			addGold(getName(pid), -hdata.price)
			addHouseOwner(getName(pid), hdata.name)
			return tes3mp.MessageBox(pid, -1, "Félicitations, vous êtes maintenant le fier propriétaire de".. hdata.name .."Utilisez la commande /house pour gérer les paramètres de votre maison.")
		end
	else
		return tes3mp.MessageBox(pid, -1, "Impossible de trouver la maison sélectionnée.")
	end
end

-- ADMIN EDIT HOUSE OWNER
showHouseEditOwnerPrompt = function(pid)
	local message = "Entrez 'none' pour supprimer le propriétaire actuel"
	
	return tes3mp.InputDialog(pid, config.HouseEditOwnerGUI, message)
end

local function onHouseEditOwnerPrompt(pid, data)
	if data == nil or data == "" or string.lower(data) == "none" then
		--Do nothing
		removeHouseOwner(adminSelectedHouse[getName(pid)], true, "return")
	else
		if string.lower(data) == getHouseOwnerName(adminSelectedHouse[getName(pid)]) then
			--Player already owns this house... do nothing
		else
			removeHouseOwner(adminSelectedHouse[getName(pid)], true, "return")
			addHouseOwner(data, adminSelectedHouse[getName(pid)])
		end
	end
	return showHouseEditMain(pid)
end

-- ADMIN EDIT HOUSE PRICE
showHouseEditPricePrompt = function(pid)
	local message = "Entrer un nouveau prix"
	
	return tes3mp.InputDialog(pid, config.HouseEditPriceGUI, message)
end

local function onHouseEditPricePrompt(pid, data)
	local price
	if data == nil or data == "" or not tonumber(data) or tonumber(data) < 0 then
		price = config.defaultPrice
	else
		price = data
	end
	
	if housingData.houses[adminSelectedHouse[getName(pid)]] then
		setHousePrice(adminSelectedHouse[getName(pid)], price)
		return showHouseEditMain(pid)
	else
		tes3mp.MessageBox(pid,-1, "Votre maison sélectionnée ne semble plus exister!")
	end
end

-- ADMIN EDIT HOUSE MAIN
showHouseEditMain = function(pid)
	local message = getHouseInfoLong(adminSelectedHouse[getName(pid)], false)
	message = message .. "\n\n"
	
	message = message .. "'Définir ici en tant qu'entrée' désigne l'endroit où vous vous trouvez pour indiquer l'endroit où les joueurs arriveront lorsqu'ils se téléporteront ici. 'Définir ici comme sortie' indique où vous vous trouvez en tant qu'emplacement où les joueurs seront placés s'ils sont expulsés (par exemple s'ils essaient d'entrer alors que l'endroit est verrouillé et n'a pas la permission). Les deux devraient être fixés pour une maison. "
	
	message = message .. "\n\n"
	
	local hdata = housingData.houses[adminSelectedHouse[getName(pid)]]
	message = message .. "Entrée assignée: "
	if not hdata.inside.cell then
		message = message .. "Aucun\n"
	else
		message = message .. "Cell - " .. hdata.inside.cell .. " | Pos - " .. math.floor(hdata.inside.pos.x + 0.5) .. ", " .. math.floor(hdata.inside.pos.y + 0.5) .. ", " .. math.floor(hdata.inside.pos.z + 0.5) .."\n"
	end
	message = message .. "Sortie attribuée: "
	if not hdata.outside.cell then
		message = message .. "Aucun\n"
	else
		message = message .. "Cell - " .. hdata.outside.cell .. " | Pos - " .. math.floor(hdata.outside.pos.x + 0.5) .. ", " .. math.floor(hdata.outside.pos.y + 0.5) .. ", " .. math.floor(hdata.outside.pos.z + 0.5) .."\n"
	end
	
	return tes3mp.CustomMessageBox(pid, config.HouseEditGUI, message, "Définir le prix;Définir le propriétaire;Affecter la porte;Supprimer la porte;Définir ici comme entrée;Définir ici comme sortie;Supprimer la maison;Fermer")
end

local function onHouseEditPrice(pid)
	return showHouseEditPricePrompt(pid)
end

local function onHouseEditOwner(pid)
	return showHouseEditOwnerPrompt(pid)
end

local function onHouseEditDoor(pid)
	--TODO
	return tes3mp.MessageBox(pid, -1, "Pas encore implémenté. L'édition manuelle des fichiers de données est nécessaire pour attribuer une porte.")
end

local function onHouseEditRemoveDoor(pid)
	--TODO
	return tes3mp.MessageBox(pid, -1, "Pas encore implémenté. L'édition manuelle des fichiers de données est nécessaire pour annuler l'affectation d'une porte.")
end

local function onHouseEditDeleteHouse(pid)
	--Pssh, who needs a confirmation window? Just delete it! :P
	deleteHouse(adminSelectedHouse[getName(pid)])
	adminSelectedHouse[getName(pid)] = nil
	return showAdminMain(pid)
end

local function onHouseEditInside(pid)
	return assignHouseInside(adminSelectedHouse[getName(pid)], tes3mp.GetCell(pid), tes3mp.GetPosX(pid), tes3mp.GetPosY(pid), tes3mp.GetPosZ(pid)), showHouseEditMain(pid)
end

local function onHouseEditOutside(pid)
	return assignHouseOutside(adminSelectedHouse[getName(pid)], tes3mp.GetCell(pid), tes3mp.GetPosX(pid), tes3mp.GetPosY(pid), tes3mp.GetPosZ(pid)), showHouseEditMain(pid)
end

-- ADMIN EDIT CELL MAIN
showCellEditMain = function(pid)
	local cell = tes3mp.GetCell(pid)
	local message = ""
	--Generate Cell's entry if none exists
	if not housingData.cells[cell] then
		createNewCell(cell)
	end
	
	local cdata = housingData.cells[cell]
	
	--Cell name, Associated House, Owned Containers Status, Required Access Status. Description on buttons
	message = message .. "Nom: " .. cdata.name .. "\n"
	message = message .. "Maison associée: " .. (cdata.house or "no data")  .. "\n"
	message = message .. "Conteneurs possédés: " .. tostring(cdata.ownedContainers) .. "\n"
	message = message .. "Accès requis: " .. tostring(cdata.requiredAccess) .. "\n"
	message = message .. "Requiert des réinitialisations: " .. tostring(cdata.requiresResets) .. "\n"
	
	return tes3mp.CustomMessageBox(pid, config.CellEditGUI, message, "Attribuer à la maison sélectionnée;Supprimer de la maison sélectionnée;Basculer les conteneurs en propriété;Basculer l'accès requis;Basculer les réinitialisations requises;Fermer")
end

local function onCellEditAssign(pid)
	local cell = tes3mp.GetCell(pid)
	local pname = getName(pid)
	
	if adminSelectedHouse[pname] and housingData.houses[adminSelectedHouse[pname]] then
		assignCellToHouse(cell, adminSelectedHouse[pname])
		return true, showCellEditMain(pid, adminSelectedHouse[pname])
	else
		if not adminSelectedHouse[pname] then
			tes3mp.MessageBox(pid,-1, "Vous devez avoir sélectionné une maison pour y ajouter une cellule.")
		else
			tes3mp.MessageBox(pid,-1, "Votre maison sélectionnée ne semble plus exister!")
		end
	end
end

local function onCellEditRemove(pid)
	local cell = tes3mp.GetCell(pid)
	local pname = getName(pid)
	
	if adminSelectedHouse[pname] and housingData.houses[adminSelectedHouse[pname]] then
		removeCellFromHouse(cell, adminSelectedHouse[pname])
		return true, showCellEditMain(pid)
	else
		if not adminSelectedHouse[pname] then
			tes3mp.MessageBox(pid,-1, "Vous devez avoir une maison sélectionnée pour en retirer une cellule.")
		else
			tes3mp.MessageBox(pid,-1, "Votre maison sélectionnée ne semble plus exister!")
		end
	end
end

local function onCellEditContainers(pid)
	local cell = tes3mp.GetCell(pid)
	
	if housingData.cells[cell] then
		housingData.cells[cell].ownedContainers = (not housingData.cells[cell].ownedContainers)
		Save()
		return true, showCellEditMain(pid)
	else
		tes3mp.MessageBox(pid,-1, "Erm, n'a pas pu trouver la cellule. Cela ne devrait jamais arriver.")
	end
end

local function onCellEditAccess(pid)
	local cell = tes3mp.GetCell(pid)
	
	if housingData.cells[cell] then
		housingData.cells[cell].requiredAccess = (not housingData.cells[cell].requiredAccess)
		Save()
		return true, showCellEditMain(pid)
	else
		tes3mp.MessageBox(pid,-1, "Erm, n'a pas pu trouver la cellule. Cela ne devrait jamais arriver.")
	end
end

local function onCellEditResets(pid)
	local cell = tes3mp.GetCell(pid)
	
	if housingData.cells[cell] then
		housingData.cells[cell].requiresResets = (not housingData.cells[cell].requiresResets)
		Save()
		return true, showCellEditMain(pid)
	else
		tes3mp.MessageBox(pid,-1, "Erm, n'a pas pu trouver la cellule. Cela ne devrait jamais arriver.")
	end
end


-- ADMIN SELECT HOUSE
showAdminHouseSelect = function(pid)
	local message = "Sélectionnez une maison dans la liste"
	
	--Generate a list of options
	local options = {}	
	local list = "* CLOSE *\n"
	
	for houseName, v in pairs(housingData.houses) do
		table.insert(options, houseName)
	end
	for i=1, #options do
		list = list .. options[i]
		if not (i == #options) then
			list = list .. "\n"
		end
	end
	
	adminHouseList[getName(pid)] = options
	return tes3mp.ListBox(pid, config.AdminHouseSelectGUI, message, list)
end

local function onAdminHouseSelect(pid, index)
	adminSelectedHouse[getName(pid)] = adminHouseList[getName(pid)][index]
	return
end

-- ADMIN HOUSE CREATE
showHouseCreate = function(pid)
	local message = "Entrez un nom pour la maison"
	
	return tes3mp.InputDialog(pid, config.AdminHouseCreateGUI, message)
end

local function onHouseCreatePrompt(pid, data)
	--TODO: Checks?
	createNewHouse(data)
	adminSelectedHouse[getName(pid)] = data
end

-- ADMIN MAIN
showAdminMain = function(pid)
	local message = ""
	if adminSelectedHouse[getName(pid)] then
		--TODO: Check if still valid house
		message = message .. "#red ..Maison actuellement sélectionnée: " .. adminSelectedHouse[getName(pid)] .. "\n\n\n"
	end
	
	message = message .. "#cyan .Créer une nouvelle maison pour créer et sélectionner une nouvelle maison, ou Sélectionner une maison pour en sélectionner une existante.\n\nModifier les données de la cellule est utilisé pour éditer les informations de cellule dans laquelle vous êtes actuellement. Si vous avez sélectionné une maison, vous pouvez ensuite affecter cette cellule à celle que vous avez sélectionnée.\n\nModifier les données de la maison est utilisé pour éditer toutes sortes de choses sur la maison elle-même. "
	
	return tes3mp.CustomMessageBox(pid, config.AdminMainGUI, message, "Créer une nouvelle maison;sélectionner une maison;modifier les données de la cellule;modifier les données de la maison;fermer")
end

local function onAdminMainCreate(pid)
	return showHouseCreate(pid)
end

local function onAdminMainSelect(pid)
	return showAdminHouseSelect(pid)
end

local function onAdminMainCellEdit(pid)
	return showCellEditMain(pid)
end

local function onAdminMainHouseEdit(pid)
	local pname = getName(pid)
	if not adminSelectedHouse[pname] or not housingData.houses[adminSelectedHouse[pname]] then
		--Either the admin doesn't have a house selected, or the house they do have selected no longer exists
		return tes3mp.MessageBox(pid,-1, "Veuillez d'abord sélectionner une maison valide.")
	else
		return showHouseEditMain(pid)
	end
end

-------------------

Methods.OnGUIAction = function(pid, idGui, data)
	if idGui == config.AdminMainGUI then --Admin Main
		if tonumber(data) == 0 then --Create New House
			onAdminMainCreate(pid)
			return true
		elseif tonumber(data) == 1 then --Select House
			onAdminMainSelect(pid)
			return true
		elseif tonumber(data) == 2 then --Edit Cell Data
			onAdminMainCellEdit(pid)
			return true
		elseif tonumber(data) == 3 then --Edit House Data
			onAdminMainHouseEdit(pid)
			return true
		elseif tonumber(data) == 4 then --Close
			--Do nothing
			return true
		end		
	elseif idGui == config.AdminHouseCreateGUI then --House Naming Prompt
		if data ~= nil and data ~= "" then
			onHouseCreatePrompt(pid, data)
		end
		return true, showAdminMain(pid)
	elseif idGui == config.AdminHouseSelectGUI then --Admin House Selector
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return true, showAdminMain(pid)
		else
			onAdminHouseSelect(pid, tonumber(data))
			return true, showAdminMain(pid)
		end
	elseif idGui == config.CellEditGUI then --Edit Cells Main
		if tonumber(data) == 0 then -- Assign to Selected House
			onCellEditAssign(pid)
			return true
		elseif tonumber(data) == 1 then -- Remove From Selected House
			onCellEditRemove(pid)
			return true
		elseif tonumber(data) == 2 then --Toggle Owned Containers
			onCellEditContainers(pid)
			return true
		elseif tonumber(data) == 3 then --Toggle Required Access
			onCellEditAccess(pid)
			return true
		elseif tonumber(data) == 4 then --Toggle Requires Resets
			onCellEditResets(pid)
			return true
		else -- Close
			--Do nothing
			return true, showAdminMain(pid)
		end
	elseif idGui == config.HouseEditGUI then --Edit House Main
		if tonumber(data) == 0 then -- Set Price
			onHouseEditPrice(pid)
			return true
		elseif tonumber(data) == 1 then -- Set Owner
			onHouseEditOwner(pid)
			return true
		elseif tonumber(data) == 2 then -- Assign Door
			onHouseEditDoor(pid)
			return true
		elseif tonumber(data) == 3 then -- Remove Door
			onHouseEditRemoveDoor(pid)
			return true
		elseif tonumber(data) == 4 then -- Set Entrance
			onHouseEditInside(pid)
			return true
		elseif tonumber(data) == 5 then -- Set Exit
			onHouseEditOutside(pid)
			return true	
		elseif tonumber(data) == 6 then -- Delete House
			onHouseEditDeleteHouse(pid)
			return true
		else --Close
			--Do nothing
			return true, showAdminMain(pid)
		end
	elseif idGui == config.HouseEditPriceGUI then --Edit House Price Prompt
		onHouseEditPricePrompt(pid, data)
		return true
	elseif idGui == config.HouseEditOwnerGUI then --Edit House Owner Prompt
		onHouseEditOwnerPrompt(pid, data)
		return true
	elseif idGui == config.HouseInfoGUI then -- House Info
		if tonumber(data) == 0 then --Buy
			onHouseInfoBuy(pid)
			return true
		else
			--Do nothing
			return true
		end
	elseif idGui == config.PlayerMainGUI then -- Player Main
		if tonumber(data) == 0 then --List all Houses
			onPlayerMainList(pid)
			return true
		elseif tonumber(data) == 1 then --Edit House Settings
			onPlayerMainEdit(pid)
			return true
		else --Close
			--Do nothing
			return true
		end	
	elseif idGui == config.PlayerAllHouseSelectGUI then --Player All House List Select
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return true, showUserMain(pid)
		else
			onPlayerAllHouseSelect(pid, tonumber(data))
			return true
		end
	elseif idGui == config.PlayerSettingGUI then --Player Setting Main
		if tonumber(data) == 0 then --Select Owned House
			onPlayerSettingsOwned(pid)
			return true
		elseif tonumber(data) == 1 then --Add Co-owner
			onPlayerSettingsAdd(pid)
			return true
		elseif tonumber(data) == 2 then --Remove Co-owner
			onPlayerSelectRemove(pid)
			return true
		elseif tonumber(data) == 3 then --Lock House
			onPlayerSelectLock(pid)
			return true
		elseif tonumber(data) == 4 then --Warp to House
			onPlayerSelectWarp(pid)
			return true
		elseif tonumber(data) == 5 then --Sell House
			onPlayerSelectSell(pid)
			return true
		else --Close
			--Do nothing
			return true
		end	
	elseif idGui == config.PlayerOwnedHouseSelect then --Player Owned House Select
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return true, showPlayerSettingsMain(pid)
		else
			onPlayerOwnedHouseSelect(pid, tonumber(data))
			return true, showPlayerSettingsMain(pid)
		end
	elseif idGui == config.PlayerAddCoOwnerGUI then --Player CoOwner Add Prompt
		onPlayerSettingsAddPrompt(pid, data)
		return true	
	elseif idGui == config.PlayerRemoveCoOwnerGUI then --Player CoOwner Remove Select
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return true, showPlayerSettingsMain(pid)
		else
			onCoOwnerRemoveSelect(pid, tonumber(data))
			return true, showPlayerSettingsMain(pid)
		end
	elseif idGui == config.PlayerSellConfirmGUI then
		if tonumber(data) == 0 then --Sell House/Sell House + Furniture
			if kanaFurniture ~= nil then
				onPlayerSellHouseAndFurniture(pid)
				return true
			else
				onPlayerSellHouse(pid)
				return true
			end
		elseif tonumber(data) == 1 then --Cancel/Sell House + Collect furniture
			if kanaFurniture ~= nil then
				onPlayerSellHouseAndCollect(pid)
				return true
			else
				--Do nothing, because cancel
				return true, showPlayerSettingsMain(pid)
			end
		elseif tonumber(data) == 2 then -- [Impossible]/Cancel
			--Can only get this far if in kanaFurniture mode, so no need to check
			--Do nothing
			return true, showPlayerSettingsMain(pid)
		end
	end
end

Methods.OnUserCommand = function(pid)
	return showUserMain(pid)
end

Methods.OnInfoCommand = function(pid)
	return showHouseInfo(pid)
end

Methods.OnAdminCommand = function(pid)
	local rank = Players[pid].data.settings.admin
	if rank < config.requiredAdminRank then
		--Not high enough rank to use the admin menu
		return false
	end
	return showAdminMain(pid)	
end

local lastEnteredHouse = {}
Methods.OnPlayerCellChange = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local currentCell = tes3mp.GetCell(pid)
		
		--Do the locked doors check stuff
		unlockChecks(currentCell)
		
		--If they're entering a house cell
		if housingData.cells[currentCell] and housingData.cells[currentCell].house ~= nil then
			local hdata = housingData.houses[housingData.cells[currentCell].house]
			
			local canEnter, enterReason = isAllowedEnter(pid, currentCell)
			if enterReason == "unowned" then --A player has entered a house without an owner
				if lastEnteredHouse[getName(pid)] ~= hdata.name then --They've just entered the house
					msg(pid, " Vous êtes entré dans " .. hdata.name .. ", qui est une maison disponible à l'achat pour " .. hdata.price .. " or. Ecrire /houseinfo pour plus d'information.")
				end
				doLog(Players[pid].accountName .. " entré dans une cellule dans la maison sans propriétaire " .. hdata.name)
			elseif enterReason == "unlocked" then				
				if lastEnteredHouse[getName(pid)] ~= hdata.name then --They've just entered the house
					if isOwner(getName(pid), hdata.name) or isCoOwner(getName(pid), hdata.name) then
						msg(pid, "Bienvenue à la maison, " .. Players[pid].accountName .. ".")
					else
						msg(pid, "Bienvenue " .. getHouseOwnerName(hdata.name) .. " maison.")
					end
				end
				
				local logMessage = Players[pid].accountName .. " entré dans la maison non verrouillée " .. hdata.name
				
				if isOwner(getName(pid), hdata.name) then
					logMessage = logMessage .. " en tant que propriétaire"
				elseif isCoOwner(getName(pid), hdata.name) then
					logMessage = logMessage .. " en tant que copropriétaire"
				else
					logMessage = logMessage .. " en tant que visiteur"
				end
				
				doLog(logMessage)
				
			elseif enterReason == "owner" or enterReason == "coowner" then --An owner/coowner has entered
				if lastEnteredHouse[getName(pid)] ~= hdata.name then --They've just entered the house
					local message = "Bienvenue à la maison, " .. Players[pid].accountName .. "."
					if isLocked(hdata.name) then
						message = message .. " La maison est toujours fermée aux étrangers."
					end
					msg(pid, message)
				end
				
				doLog(Players[pid].accountName .. " entré dans la maison fermée à clé " .. hdata.name .. " en tant que propriétaire / copropriétaire")
			elseif enterReason == "Admin" then --An admin entered a locked house
				msg(pid, "Bienvenue " .. getHouseOwnerName(hdata.name) .. "de la maison, oh puissant admin. La maison est actuellement fermée à clé.")
				doLog(Players[pid].accountName .. " entré dans la maison fermée à clé " .. hdata.name .. " en tant qu'administrateur")
			elseif enterReason == "access" then
				local message = "Vous venez d'entrer une partie de " .. getHouseOwnerName(hdata.name) .. "La maison est actuellement fermée à clé, mais vous pouvez entrer ici parce que c'est important pour une quête." .. getHouseOwnerName(hdata.name) .. "propriété, et seulement faire ce que vous devez pour la quête."
				msg(pid, message)
				tes3mp.MessageBox(pid, -1, message)
				doLog(Players[pid].accountName .. " entré dans la maison fermée à clé" .. hdata.name .. " en tant que visiteur autorisé à entrer car la cellule est marquée comme requiredAccess")
			elseif canEnter == false then
				msg(pid, "Le propriétaire a fermé la maison.")
				local destinationCell, destinationPos
				if hdata.outside.cell then --There's exit data saved for this house
					destinationCell = hdata.outside.cell
					destinationPos = hdata.outside.pos
				else
					--Without any data for an exit, we default to placing the players back at spawn
					destinationCell = serverConfig.defaultSpawnCell
					destinationPos = {x = serverConfig.defaultSpawnPos[1], y = serverConfig.defaultSpawnPos[2], z = serverConfig.defaultSpawnPos[3]}
				end
				doLog(Players[pid].accountName .. " tenté d'entrer dans la maison fermée à clé" .. hdata.name .. "mais a été jeté parce qu'ils n'ont pas la permission d'être là")
				warpPlayer(pid, destinationCell, destinationPos)
			end
			
			lastEnteredHouse[getName(pid)] = hdata.name
		else
			--Not in a housing cell
			lastEnteredHouse[getName(pid)] = nil
		end
	end	
end

Methods.OnObjectLock = function(pid, cellDescription)
	unlockChecks(cellDescription)
end

Methods.OnContainer = function(pid, cellDescription)
	doLog("DEBUG: Container stuff start")
	tes3mp.ReadLastEvent()
	doLog("DEBUG: Container stuff Read Event")
	local action = tes3mp.GetEventAction()
	doLog("DEBUG: Container stuff got action")
	local pname
	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		pname = Players[pid].name
	else
		return
	end
	
	local houseName, cdata = getIsInHouse(pid)
	
	if not houseName then -- The player isn't in a house cell, so we don't care
		return false
	end
	
	if not getHouseOwnerName(houseName) then --It's not really stealing if nobody owns the house
		return false
	end
	
	if tes3mp.GetObjectChangesSize() < 1 then --Something funky is going on and causes crashes if we continue
		return false
	end
	
	--Get the container's data
	local refIndex = tes3mp.GetObjectRefNumIndex(0) .. "-" .. tes3mp.GetObjectMpNum(0)
	doLog("DEBUG: Container stuff Got refIndex")
	local refId = tes3mp.GetObjectRefId(0)
	doLog("DEBUG: Container stuff Got refId")
	
	if action == actionTypes.container.REMOVE then
		if not isOwner(pname, houseName) and not isCoOwner(pname, houseName) then --We aren't interested in what the owners or co owners get up to in the cells they own.
			--Check if the container is listed in the cell's resetInfo, to see if they're taking from a container important for a quest.
			local dirtyThief = true --Guilty until proven innocent
			for index, resetData in pairs(cdata.resetInfo) do
				if resetData.refIndex == refIndex then
					dirtyThief = false
					break
				end
			end
			
			if dirtyThief then
				doLog("Voleur potentiel :" .. getName(pid) .. "a pris un objet du récipient" .. refIndex .. " dans " .. cdata.name .. " (Partie de " .. getHouseOwnerName(cdata.house) .. "La maison: " .. cdata.house .. ")Et ce conteneur n'a pas été marqué comme un conteneur de quête!")
				onDirtyThief(pid)
			else
				doLog(getName(pid) .. " a pris un objet du récipient " .. refIndex .. " dans " .. cdata.name .. " (Partie de " .. getHouseOwnerName(cdata.house) .. "La maison: " .. cdata.house .. ") mais c'est bon parce qu'il est marqué comme un conteneur de quête.") --Necessary to log?
			end
		end
	elseif action == actionTypes.container.SET then
		doLog("DEBUG: Container stuff container is SET")
		if not isOwner(pname, houseName) and not isCoOwner(pname, houseName) then --We aren't interested in what the owners or co owners get up to in the cells they own.
			--Check if the container is listed in the cell's resetInfo, to see if they're taking from a container important for a quest.
			local dirtyThief = true --Guilty until proven innocent
			for index, resetData in pairs(cdata.resetInfo) do
				if resetData.refIndex == refIndex then
					dirtyThief = false
					break
				end
			end
			
			if dirtyThief then
				doLog("Voleur potentiel : " .. getName(pid) .. " Peut avoir pris tout du conteneur" .. refIndex .. " dans " .. cdata.name .. " (Partie de " .. getHouseOwnerName(cdata.house) .. "la maison: " .. cdata.house .. ")Et ce conteneur n'a pas été marqué comme un conteneur de quête! Il se peut, cependant, qu'ils aient juste généré la cellule pour la première fois.")
			else
				doLog(getName(pid) .. "Peut avoir pris tout du conteneur " .. refIndex .. " dans " .. cdata.name .. " (partie de " .. getHouseOwnerName(cdata.house) .. "la maison: " .. cdata.house .. ")mais c'est bon parce qu'il est marqué comme un conteneur de quête.") --Necessary to log?
			end
		end
	end
	doLog("DEBUG: Container stuff done")
end

Methods.OnObjectDelete = function (pid, cellDescription)
	tes3mp.ReadLastEvent()
	local pname
	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		pname = Players[pid].name
	else
		return
	end
	
	local houseName, cdata = getIsInHouse(pid)
	
	if not houseName then -- The player isn't in a house cell, so we don't care
		return false
	end
	
	if not getHouseOwnerName(houseName) then --It's not really stealing if nobody owns the house
		return false
	end
	
	--Get the item's data
	local refIndex = tes3mp.GetObjectRefNumIndex(0) .. "-" .. tes3mp.GetObjectMpNum(0)
	local refId = tes3mp.GetObjectRefId(0)
		
	if not isOwner(pname, houseName) and not isCoOwner(pname, houseName) then --We aren't interested in what the owners or co owners get up to in the cells they own.
		--Check if the container is listed in the cell's resetInfo, to see if they're taking an item important for a quest.
		local dirtyThief = true --Guilty until proven innocent
		for index, resetData in pairs(cdata.resetInfo) do
			if resetData.refIndex == refIndex then
				dirtyThief = false
				break
			end
		end
			
		if dirtyThief then
			doLog("Voleur potentiel " .. getName(pid) .. " ramassé un objet non-quête(" .. refIndex .. " - " .. refId ..") dans " .. cdata.name .. " (partie de " .. getHouseOwnerName(cdata.house) .. "la maison: " .. cdata.house .. ")!")
			onDirtyThief(pid)
		else
			doLog(getName(pid) .. "ramassé un objet de quête (" .. refIndex .. " - " .. refId ..") dans " .. cdata.name .. " (partie de " .. getHouseOwnerName(cdata.house) .. "la maison: " .. cdata.house .. "), ce qui est bon.") --Necessary to log?
		end
	end
end

-------------------

Methods.GetCellData = function(cell)
	return housingData.cells[cell] or false
end

Methods.GetHouseData = function(houseName)
	return housingData.houses[houseName] or false
end

Methods.GetOwnerData = function(ownerName)
	local oname = string.lower(ownerName)
	return housingData.owners[oname] or false
end

--If you change any of the housingData using external scripts, be sure to use this to save the changes afterwards.
Methods.Save = function()
	return Save()
end

Methods.CreateNewHouse = function(houseName)
	return createNewHouse(houseName)
end

Methods.CreateNewCell = function(cellDescription)
	return createNewCell(cellDescription)
end

Methods.CreateNewOwner = function(oname)
	return createNewOwner(oname)
end

Methods.GetHouseOwnerName = function(houseName)
	return getHouseOwnerName(houseName)
end

Methods.GetIsInHouse = function(pid)
	return getIsInHouse(pid)
end

Methods.IsOwner = function(pname, houseName)
	return isOwner(pname, houseName)
end

Methods.IsCoOwner = function(pname, houseName)
	return isCoOwner(pname, houseName)
end

Methods.IsLocked = function(houseName)
	return isLocked(houseName)
end
-------------------

return Methods

