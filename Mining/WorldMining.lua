--[[
WorldMining.lua by DiscorPeter, RickOff

1)add WorldMining.lua in mpstuff/script folder

2) Add [ WorldMining = require("WorldMining") ] to the top of serverCore.lua

3) add to eventHandlers.lua OnActivate under if doesObjectHaveActivatingPlayer then :
	if isValid == true and objectRefId and tes3mp.IsInExterior(pid) then
		isValid = not WorldMining.OnHitActivate(pid, objectUniqueIndex, objectRefId, tes3mp.GetObjectRefNum(index), tes3mp.GetObjectMpNum(index))
	end 

4) add to eventHandler.lua OnObjectDelete under for index = 0, tes3mp.GetObjectListSize() - 1 do :
	if isValid == true then
		isValid = not WorldMining.OnObjectDelete(pid)
	end
	
5) copy miscellaneous recordStore 

6) add rocks.json and flora.json in mpstuff/data folder	

7) add in menu.lua :
Menus["menu prison house"] = {
    text = {
		color.Red .. "WARNING !!!",
		color.White .. "\n\nYou just committed a crime against the server.",
		color.Red .. "\n\ n\nTENTATIVE OF GLITCH !!!",
		color.Yellow .. "\n\nA message to was recorded in the server logs to warn the moderation",
		color.White .. "\n\nFeel attention next time",
		color.Yellow .. "\n\nThe object to was disabled only for you during this game session",
		color.White .. "\n\nTo make it reappear you can disconnect and reconnect",
		color.Cyan .. "\n\nGood play, fairplay and role play.",
		color.Red .. "\n\n\nBy continuing you agree not to duplicate this action?"
	},
    buttons = {                        
        { caption = "yes",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("WorldMining", "PunishPrison", 
                    {
                        menuHelper.variables.currentPid(), menuHelper.variables.currentPid()
                    })					
                })
            }
        },             
        { caption = "no",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("WorldMining", "PunishKick", 
                    {
                        menuHelper.variables.currentPid(),
                    })					
                })
            }
        }		
    }
}
8) copy the provided jsons all over the place

9) add to eventHandlers OnActivate under if doesObjectHaveActivatingPlayer then

	activatingPid = tes3mp.GetObjectActivatingPid(index)
	debugMessage = debugMessage .. logicHandler.GetChatName(activatingPid)
	
		--eventHandler OnActivate exchange for this door with uniqueIndex
		-- if its door and uniqueIndex is in placed list in WorldInstance
	if objectRefId and objectRefId == "ex_nord_door_01" then
		local cell = tes3mp.GetCell(pid)
		if WorldInstance.data.customVariables.WorldMining.placed[cellDescription] ~= nil then
			if WorldInstance.data.customVariables.WorldMining.placed[cellDescription][objectUniqueIndex] then
				WorldMining.OnDoor(pid, objectUniqueIndex)
				isValid = false
			else
				print("door was not in worldinstance")
			end
		end
	end
	
10) change to contentFixers.lua add AddpreexistingObjects function

function contentFixer.AddPreexistingObjects(cellDescription)
	
	if WorldInstance.data.customVariables ~= nil and WorldInstance.data.customVariables.kanaFurnitureMod ~= nil and WorldInstance.data.customVariables.kanaFurnitureMod.placed ~= nil then
		local placed = WorldInstance.data.customVariables.kanaFurnitureMod.placed
		if placed[cellDescription] ~= nil then
			local unique = {}
			
			for refIndex, object in pairs(placed[cellDescription]) do
				--place kanaFurniture
				unique[refIndex] = logicHandler.CreateObjectAtLocation(cellDescription, object.loc, object.refId, "place")
			end
			
			for refIndex, uniqueId in pairs(unique) do
				-- swap positions in table after we created them
				WorldInstance.data.customVariables.kanaFurnitureMod.placed[cellDescription][uniqueId] = WorldInstance.data.customVariables.kanaFurnitureMod.placed[cellDescription][refIndex]
				WorldInstance.data.customVariables.kanaFurnitureMod.placed[cellDescription][refIndex] = nil
			end
			
		LoadedCells[cellDescription].forceActorListRequest = true
		end
	end
	
end

11) add to logicHandler.LoadCell under LoadedCells[cellDescription]:CreateEntry()
		contentFixer.AddPreexistingObjects(cellDescription)
			
12) Add the following to OnGUIAction in serverCore.lua
	[ if kanaFurnitureMod.OnGUIAction(pid, idGui, data) then return end ]
13) Add the following to the end of  OnServerPostInit in serverCore.lua
	[ kanaFurnitureMod.OnServerPostInit() ]
end	
]]
tableHelper = require("tableHelper")
logicHandler = require("logicHandler")
jsonInterface = require("jsonInterface")

local config = {}
config.whitelist = false --If true, the player must be given permission to place items in the cell that they're in (set using this script's methods, or editing the world.json). Note that this only prevents placement, players can still move/remove items they've placed in the cell.
config.sellbackModifier = 1 -- The base cost that an item is multiplied by when selling the items back (0.75 is 75%)
config.MainMenu = "menu player"
--GUI Ids used for the script's GUIs. Shouldn't have to be edited.
config.MainGUI = 91363
config.BuyGUI = 91364
config.InventoryGUI = 91365
config.ViewGUI = 91366
config.InventoryOptionsGUI = 91367
config.ViewOptionsGUI = 91368

local message = {}
message.Tools = color.White .. "Vous devez sortir un " .. color.Red .. "outil " .. color.White .. "pour commencer le travail."
message.Pick = color.White .. "Vous devez utiliser une " .. color.Red .. "pioche de mineur " .. color.White .. "pour récolter la pierre."
message.Axe = color.White .. "Vous devez utiliser une " .. color.Red .. "hache de bucheron " .. color.White .. "pour couper le bois proprement."
message.Rock = color.White .. "Vous venez de récupérer un élément de " .. color.Red .. "pierre " .. color.White .. "dans votre inventaire."
message.Flore = color.White .. "Vous venez de récupérer un élément de " .. color.Red .. "bois " .. color.White .. "dans votre inventaire."
message.WaitJail = color.White .. "Vous êtes en prison pour une durée de " .. color.Red .. "5 " .. color.White .. "minutes."
message.StopJail = color.White .. "Votre temps de " .. color.Red .. "prison " .. color.White .. "vient de se terminer."
message.NoBuy = color.White .. "Vous ne pouvez pas vous permettre d'acheter un "
message.Buy = color.White .. " a était ajouté à votre inventaire."
message.SelectBuy = color.White .. "Sélectionnez un article que vous souhaitez acheter."
message.SelectFurnInv = color.White .. "Sélectionnez le meuble de votre inventaire avec lequel vous souhaitez faire quelque chose."
message.AddGold = color.White .. "L'or a été ajouté à votre inventaire."
message.NoPerm = color.White .. "Vous n'avez pas la permission de placer des meubles ici."
message.PlaceFurn = color.White .. "Sélectionnez un meuble que vous avez placé dans cette cellule. Remarque: le contenu des conteneurs sera perdu s'il est retiré."
message.SellFurn = color.White .. " d'or a été ajouté à votre inventaire et les meubles ont été retirés de la cellule."
message.UnFurn = color.White .. "L'objet semble avoir été enlevé."
message.AddFurn = color.White .. " a était ajouté à votre inventaire de fourniture"
message.SelectFurn = color.White .. "l'objet a était sélectionné utilisez /dh pour le déplacer"
message.InvOption = "Placer;Acheter;Retour" 
message.ViewOption = "Sélectionner;Récuperer;Vendre;Retour"
message.ChooseDoor = color.White .. "Choose one of your doors"
message.OnBuild = color.White .. "Choisissez une option"
message.OnBuildOption = "Creature;NPC;Tout;Donjons;Rochers;Plantes;Ext;Statics;Créer porte;Retour"
message.WhereDoor = "Où cette porte devrait-elle aller?"
message.WelcomeFurn = color.Green.."BIENVENUE DANS L'ATELIER.\n\n"..color.Yellow.."Acheter "..color.White.."pour acheter des objets pour votre réserve\n\n"..color.Yellow.."Inventaire "..color.White.."pour afficher les articles de meubles que vous possédez\n\n"..color.Yellow.."Afficher "..color.White.."pour afficher la liste de tous les meubles que vous possédez dans la cellule où vous êtes actuellement\n\n"
message.MainChoice = "Acheter;Inventaire;Afficher;Construction;Materiel;Retour"
message.MyDoor = "Nouveau donjon;Une de mes portes; Retour"
message.NoCraft = "Vous n'avez pas assez de roches et de bois\n"
message.CraftOption = "Fabriquer;Retour"

local craftTableRock = {}
local craftTableFlora = {}
local craftTable = {}
local furnitureData = {}

local furnLoader = jsonInterface.load("npc.json")
for index, item in pairs(furnLoader) do
	table.insert(furnitureData, {name = item.Name, refId = item.ID, tip = "npc", need = "spawn"})
end

local furnLoader = jsonInterface.load("creature.json")
for index, item in pairs(furnLoader) do
	table.insert(furnitureData, {name = item.FIELD3, refId = item.FIELD2, tip = "creature", need = "spawn"} )
end

local furnLoader = jsonInterface.load("cave.json")
for index, item in pairs(furnLoader) do
	table.insert(furnitureData, {name = item.ID, refId = item.ID, tip = "dungeon", need = "place"} )
end

local furnLoader = jsonInterface.load("furn.json")
for index, item in pairs(furnLoader) do
	table.insert(furnitureData, {name = item.ID, refId = item.ID, tip = "normal", need = "place"} )
end

local furnLoader = jsonInterface.load("exterior.json")
for index, item in pairs(furnLoader) do
	table.insert(furnitureData, {name = item.ID, refId = item.ID, tip = "exterior", need = "place"} )
end

local furnLoader = jsonInterface.load("static.json")
for index, item in pairs(furnLoader) do
	table.insert(furnitureData, {name = item.ID, refId = item.ID, tip = "static", need = "place"} )
end

local rocksLoader = jsonInterface.load("rocks.json")
for index, item in pairs(rocksLoader) do
	table.insert(craftTableRock, {refId = item.ID, tip = "rocks"})
	table.insert(craftTable, {refId = item.ID, tip = "rocks"})
	table.insert(furnitureData, {name = item.ID, refId = item.ID, tip = "rocks", need = "place"} )
end

local floreLoader = jsonInterface.load("flora.json")
for index, item in pairs(floreLoader) do
	table.insert(craftTableFlora, {refId = item.ID, tip = "flora"})
	table.insert(craftTable, {refId = item.ID, tip = "flora"})
	table.insert(furnitureData, {name = item.ID, refId = item.ID, tip = "flora", need = "place"} )
end

local WorldMining = {}
--Forward declarations:
local showMainGUI, showBuyGUI, showInventoryGUI, showViewGUI, showInventoryOptionsGUI, showViewOptionsGUI
------------
local playerBuyOptions = {}
local playerInventoryOptions = {} --
local playerInventoryChoice = {}
local playerViewOptions = {}
local playerViewChoice = {}

-- MAIN
showMainGUI = function(pid)
	local count = {terrain = 0, flora = 0, material = 0}

	local index = inventoryHelper.getItemIndex(Players[pid].data.inventory, "crafttree")
	if index ~= nil then count.flora = Players[pid].data.inventory[index].count end

	local index2 = inventoryHelper.getItemIndex(Players[pid].data.inventory, "craftrock")
	if index2 ~= nil then count.terrain = Players[pid].data.inventory[index2].count end
	
	local index3 = inventoryHelper.getItemIndex(Players[pid].data.inventory, "material")
	if index3 ~= nil then count.material = Players[pid].data.inventory[index3].count end
	
	local msg = message.WelcomeFurn
	local msgCustom = msg.."\n"..color.Yellow.."Bois : "..color.White..count.flora.."    "..color.Yellow.."Pierres : "..color.White..count.terrain.."    "..color.Yellow.."Materiel : "..color.White..count.material 
	tes3mp.CustomMessageBox(pid, config.MainGUI, msgCustom, message.MainChoice)
end

onMainBuy = function(pid)
	showBuyGUI(pid)
end

onMainInventory = function(pid)
	showInventoryGUI(pid)
end

onMainView = function(pid)
	showViewGUI(pid)
end

-- GENERAL
WorldMining.OnGUIAction = function(pid, idGui, data)
	
	if idGui == config.MainGUI then -- Main
		if tonumber(data) == 0 then --Buy
			onMainBuy(pid)
			return true
		elseif tonumber(data) == 1 then -- Inventory
			onMainInventory(pid)
			return true
		elseif tonumber(data) == 2 then -- View
			onMainView(pid)
			return true
		elseif tonumber(data) == 3 then -- Craft
			WorldMining.OnBuild(pid)
			return true
		elseif tonumber(data) == 4 then -- Material
			WorldMining.OnCraftCommand(pid)
			return true
		elseif tonumber(data) == 5 then -- Return Main Menu
			Players[pid].currentCustomMenu = config.MainMenu
			menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
			return true
		end
	elseif idGui == config.BuyGUI then -- Buy
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing return 
			return showMainGUI(pid)
		else
			onBuyChoice(pid, tonumber(data))
			showMainGUI(pid)
			return true
		end
	elseif idGui == config.InventoryGUI then --Inventory main
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing return
			return showMainGUI(pid)
		else
			onInventoryChoice(pid, tonumber(data))
			return true
		end
	elseif idGui == config.InventoryOptionsGUI then --Inventory options
		if tonumber(data) == 0 then --Place
			onInventoryOptionPlace(pid)
			return true
		elseif tonumber(data) == 1 then --Sell
			onInventoryOptionSell(pid)
			return true
		else 
			--Do nothing return
			return showMainGUI(pid)
		end
	elseif idGui == config.ViewGUI then --View
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing return
			return showMainGUI(pid)
		else
			onViewChoice(pid, tonumber(data))
			return true
		end
	elseif idGui == config.ViewOptionsGUI then -- View Options
		if tonumber(data) == 0 then --Select
			onViewOptionSelect(pid)
			return true
		elseif tonumber(data) == 1 then --Put away
			onViewOptionPutAway(pid)
		elseif tonumber(data) == 2 then --Sell
			onViewOptionSell(pid)
		else 
			--Do nothing return
			return showMainGUI(pid)
		end
	elseif idGui == 1334 then
		if tonumber(data) == 0 then
			WorldMining.showBuyGUIall(pid,"creature")
		elseif tonumber(data) == 1 then
			WorldMining.showBuyGUIall(pid,"npc")
		elseif tonumber(data) == 2 then
			WorldMining.showBuyGUIall(pid,"all")
		elseif tonumber(data) == 3 then
			WorldMining.showBuyGUIall(pid,"dungeon")
		elseif tonumber(data) == 4 then
			WorldMining.showBuyGUIall(pid,"rocks")
		elseif tonumber(data) == 5 then
			WorldMining.showBuyGUIall(pid,"flora")
		elseif tonumber(data) == 6 then
			WorldMining.showBuyGUIall(pid,"exterior")
		elseif tonumber(data) == 7 then
			WorldMining.showBuyGUIall(pid,"static")
		elseif tonumber(data) == 8 then -- door
			tes3mp.CustomMessageBox(pid, 1335, message.WhereDoor, message.MyDoor)
		elseif tonumber(data) == 9 then -- return
			return showMainGUI(pid)
		end
	elseif idGui == 1335 then
		if tonumber(data) == 0 then
			newDungeon(pid)
		elseif tonumber(data) == 1 then
			toDoor(pid)
		elseif tonumber(data) == 2 then
			return WorldMining.OnBuild(pid)
		end
	elseif idGui == 1336 then
		if Players[pid].DoorOptions[tonumber(data)] ~= nil then
			toDoorSecond(pid, tonumber(data))
		else
			print("error with dooroptions")
		end
	elseif idGui == 1337 then
		if tonumber(data) == 0 then
			craft(pid)
		elseif tonumber(data) == 1 then
			return WorldMining.OnBuild(pid)
		end
	end
end

--all, normal, dungeon, npc, creature, rocks, furn, flora, exterior, static,
WorldMining.OnCommand = function(pid)
	showMainGUI(pid)
end

WorldMining.OnBuild = function(pid)
	tes3mp.CustomMessageBox(pid, 1334, message.OnBuild, message.OnBuildOption)
end

newDungeon = function(pid) --just create some doors in interiors
	local interiors = jsonInterface.load("exampleInteriors.json")
	local dungeonCell
	local counter = 0
	local currentCell = tes3mp.GetCell(pid)
	local pname = getName(pid)
	-- on interior get necessary variables
	-- choose any interior
	-- if player is in interior take this one
	if tes3mp.IsInExterior(pid) == false then
		dungeonCell = tes3mp.GetCell(pid)
	else
		-- else choose from list --make a good example list
		-- get the one with smallest dungeonCount from example list
		for index, item in pairs(interiors) do
			if item.dungeonCount < counter or counter == 0 then
				counter = item.dungeonCount
				dungeonCell = index
			end
		end
	end

	-- save which examples have been taken how many times
	-- increase dungeoncount
	if interiors[dungeonCell] == nil then interiors[dungeonCell] = {} end
	if interiors[dungeonCell].dungeonCount == nil then
		interiors[dungeonCell].dungeonCount = 1
	else
		interiors[dungeonCell].dungeonCount = interiors[dungeonCell].dungeonCount + 1
	end
	-- save interiors json back inter
	jsonInterface.save("exampleInteriors.json", interiors)
	--now we got a cell for it
	-- get location in that cell
	local Ilse = interiors[dungeonCell].dungeonCount + 1
	local dungeonLocation = {posX = 0, posY = 0, posZ = 1000 * Ilse,  rotX = 0, rotY = 0, rotZ= 0 }	
	--save door into json for OnActivate
	--save loc
	local pPos = {posX = tes3mp.GetPosX(pid), posY = tes3mp.GetPosY(pid), posZ = tes3mp.GetPosZ(pid),  rotX = tes3mp.GetRotX(pid), rotY = 0, rotZ= tes3mp.GetRotZ(pid) }
	--save door with loc and owner into json
	--plus desination
	myDoor = {location = pPos, owner = pname, destination = {cell = dungeonCell, location = dungeonLocation}}	
	local doors = jsonInterface.load("createdDoors.json")
	if doors[currentCell] == nil then doors[currentCell] = {} end
	table.insert(doors[currentCell], myDoor)
	jsonInterface.save("createdDoors.json", doors)
	--spawn door 
	local furnRefIndex = placeFurniture("ex_nord_door_01", myDoor.location, currentCell, "place")	--Update the database of all placed furniture
	-- save to all placed ones
	addPlaced(furnRefIndex, currentCell, pname, "ex_nord_door_01", true, myDoor.location, "place")
	--Set the placed item as the player's active object for decorateHelp to use
	-- dont do this since we spawn him in new cell instead
	--decorateHelp.SetSelectedObject(pid, furnRefIndex)
	--spawn plate in this cell
	local furnRefIndex = placeFurniture("ex_de_docks_end", dungeonLocation, dungeonCell, "place")	--Update the database of all placed furniture
	-- save to all placed ones
	addPlaced(furnRefIndex, dungeonCell, pname, "ex_de_docks_end", true, dungeonLocation, "place")
	--Set the placed item as the player's active object for decorateHelp to use
	decorateHelp.SetSelectedObject(pid, furnRefIndex)
	--spawn player on top of plate	
	tes3mp.SetCell(pid, dungeonCell)
	tes3mp.SendCell(pid)
	tes3mp.SetPos(pid, dungeonLocation.posX, dungeonLocation.posY, dungeonLocation.posZ + 10)
	tes3mp.SetRot(pid, 0, 0)
	tes3mp.SendPos(pid)	
	-- send fancy message
end
	
toDoor = function(pid)
	--on players door.
	--check json for a list of existing doors
	local doors = jsonInterface.load("createdDoors.json")
	
	local list = ""
	local count = 0
	local pname = getName(pid)
	Players[pid].DoorOptions = {}
	
	for cell, item2 in pairs(doors) do
		for index, item in pairs(item2) do
			if item.owner == pname then
				Players[pid].DoorOptions[count] = {cell = cell, loc = item.location}
				count = count + 1
				list = list.."Door in Cell "..cell.."\n"
			else
				print("item was")
				print("not owner")
				print(item.owner)
			end
		end
	end
	
	tes3mp.ListBox(pid, 1336, message.ChooseDoor, list)
end

toDoorSecond = function(pid, data)	

	-- get old door
	local chosen = Players[pid].DoorOptions[data]
	local chosenCell = chosen.cell
	local chosenLoc = chosen.loc
	local currentCell = tes3mp.GetCell(pid)
	local pname = getName(pid)
	local doors = jsonInterface.load("createdDoors.json")

	--save new door into json for OnActivate
	--save loc
	local pPos = {posX = tes3mp.GetPosX(pid), posY = tes3mp.GetPosY(pid), posZ = tes3mp.GetPosZ(pid),  rotX = tes3mp.GetRotX(pid), rotY = 0, rotZ= tes3mp.GetRotZ(pid) }

	--save door with loc and owner into json
	--plus desination
	myDoor = {location = pPos, owner = pname, destination = {cell = chosenCell, location = chosenLoc}}

	if doors[currentCell] == nil then doors[currentCell] = {} end
	table.insert(doors[currentCell], myDoor)
	jsonInterface.save("createdDoors.json", doors)


	--spawn new door
	local furnRefIndex = placeFurniture("ex_nord_door_01", myDoor.location, currentCell, "place")	--Update the database of all placed furniture
	-- save to all placed ones
	addPlaced(furnRefIndex, currentCell, pname, "ex_nord_door_01", true, myDoor.location, "place")
	--Set the placed item as the player's active object for decorateHelp to use
	-- dont do this since we spawn him in new cell instead
	--decorateHelp.SetSelectedObject(pid, furnRefIndex)
	decorateHelp.SetSelectedObject(pid, furnRefIndex)	
	--fancy message
	
end
-- ===========
--  DATA ACCESS
-- ===========

local function getFurnitureInventoryTable()
	return WorldInstance.data.customVariables.WorldMining.inventories
end

local function getPermissionsTable()
	return WorldInstance.data.customVariables.WorldMining.permissions
end

local function getPlacedTable()
	return WorldInstance.data.customVariables.WorldMining.placed
end

addPlaced = function(refIndex, cell, pname, refId, save, pPos, packetType)
	local placed = getPlacedTable()
	
	if not placed[cell] then
		placed[cell] = {}
	end
	
	placed[cell][refIndex] = {owner = pname, refId = refId, loc = pPos, need = packetType}
	
	if save then
		WorldInstance:Save()
	end
end

removePlaced = function(refIndex, cell, save)
	local placed = getPlacedTable()
	
	placed[cell][refIndex] = nil
	
	if save then
		WorldInstance:Save()
	end
end

getPlaced = function(cell)
	local placed = getPlacedTable()
	
	if placed[cell] then
		return placed[cell]
	else
		return false
	end
end

addFurnitureItem = function(pname, refId, count, save)
	local fInventories = getFurnitureInventoryTable()
	
	if fInventories[pname] == nil then
		fInventories[pname] = {}
	end
	
	fInventories[pname][refId] = (fInventories[pname][refId] or 0) + (count or 1)
	
	--Remove the entry if the count is 0 or less (so we can use this function to remove items, too!)
	if fInventories[pname][refId] <= 0 then
		fInventories[pname][refId] = nil
	end
	
	if save then
		WorldInstance:Save()
	end
end

WorldMining.OnServerPostInit = function()
	--Create the script's required data if it doesn't exits
	if WorldInstance.data.customVariables.WorldMining == nil then
		WorldInstance.data.customVariables.WorldMining = {}
		WorldInstance.data.customVariables.WorldMining.placed = {}
		WorldInstance.data.customVariables.WorldMining.permissions = {}
		WorldInstance.data.customVariables.WorldMining.inventories = {}
		WorldInstance:Save()
	end
	
	--Slight Hack for updating pnames to their new values. In release 1, the script stored player names as their login names, in release 2 it stores them as their all lowercase names.
	local placed = getPlacedTable()
	for cell, v in pairs(placed) do
		for refIndex, v in pairs(placed[cell]) do
			placed[cell][refIndex].owner = string.lower(placed[cell][refIndex].owner)
		end
	end
	local permissions = getPermissionsTable()
		
	for cell, v in pairs(permissions) do
		local newNames = {}
		
		for pname, v in pairs(permissions[cell]) do
			table.insert(newNames, string.lower(pname))
		end
		
		permissions[cell] = {}
		for k, newName in pairs(newNames) do
			permissions[cell][newName] = true
		end
	end
	
	local inventories = getFurnitureInventoryTable()
	local newInventories = {}
	for pname, invData in pairs(inventories) do
		newInventories[string.lower(pname)] = invData
	end
	
	WorldInstance.data.customVariables.WorldMining.inventories = newInventories
	
	WorldInstance:Save()
end

-------------------------

getSellValue = function (baseValue)
	return math.max(0, math.floor(baseValue * config.sellbackModifier))
end

getName = function(pid)
	--return Players[pid].data.login.name
	--Release 2 change: Now uses all lowercase name for storage
	return string.lower(Players[pid].accountName)
end

getObject = function(refIndex, cell)
	if refIndex == nil then
		return false
	end
	
	if not LoadedCells[cell] then
		--TODO: Should ideally be temporary
		logicHandler.LoadCell(cell)
	end

	if LoadedCells[cell]:ContainsObject(refIndex)  then 
		return LoadedCells[cell].data.objectData[refIndex]
	else
		return false
	end	
end

--Returns the amount of gold in a player's inventory
getPlayerGold = function(pid)
	local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "material", -1)
	
	if goldLoc then
		return Players[pid].data.inventory[goldLoc].count
	else
		return 0
	end
end

addGold = function(pid, amount)
	--TODO: Add functionality to add gold to offline player's inventories, too
	local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "material", -1)
	
	if goldLoc then
		Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count + amount
	else
		table.insert(Players[pid].data.inventory, {refId = "material", count = amount, charge = -1})
	end
	
	Players[pid]:Save()
	local itemref = {refId = "material", count = 1, charge = -1}	
	Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)	
end

getFurnitureData = function(refId)
	local location = tableHelper.getIndexByNestedKeyValue(furnitureData, "refId", refId)
	if location then
		return furnitureData[location], location
	else
		return false
	end
end

hasPlacePermission = function(pname, cell)
	local perms = getPermissionsTable()
	
	if not config.whitelist then
		return true
	end
	
	if perms[cell] then
		if perms[cell]["all"] or perms[cell][pname] then
			return true
		else
			return false
		end
	else
		--There's not even any data for that cell
		return false
	end
end

getPlayerFurnitureInventory = function(pid)
	local invlist = getFurnitureInventoryTable()
	local pname = getName(pid)
	
	if invlist[pname] == nil then
		invlist[pname] = {}
		WorldInstance:Save()
	end
	
	return invlist[pname]
end

getSortedPlayerFurnitureInventory = function(pid)
	local inv = getPlayerFurnitureInventory(pid)
	local sorted = {}
	
	for refId, amount in pairs(inv) do
		local name = getFurnitureData(refId).name
		table.insert(sorted, {name = name, count = amount, refId = refId})
	end
	
	return sorted
end

placeFurniture = function(refId, loc, cell, packetType)
	print("placing item")
	print(refId)
	print(packetType)
	local mpNum = WorldInstance:GetCurrentMpNum() + 1
	local location = {
		posX = loc.posX, posY = loc.posY, posZ = loc.posZ,
		rotX = 0, rotY = 0, rotZ = 0
	}
	local refIndex =  0 .. "-" .. mpNum
	
	WorldInstance:SetCurrentMpNum(mpNum)
	tes3mp.SetCurrentMpNum(mpNum)
	
	if not LoadedCells[cell] then
		--TODO: Should ideally be temporary
		logicHandler.LoadCell(cell)
	end

	LoadedCells[cell]:InitializeObjectData(refIndex, refId)
	LoadedCells[cell].data.objectData[refIndex].location = location
	table.insert(LoadedCells[cell].data.packets.place, refIndex)
	
    if packetType == "place" then
        table.insert(LoadedCells[cell].data.packets.place, refIndex)
    elseif packetType == "spawn" then
        table.insert(LoadedCells[cell].data.packets.spawn, refIndex)
        table.insert(LoadedCells[cell].data.packets.actorList, refIndex)
    end

	for onlinePid, player in pairs(Players) do
		if player:IsLoggedIn() then
			tes3mp.InitializeEvent(onlinePid)
			tes3mp.SetEventCell(cell)
			tes3mp.SetObjectRefId(refId)
			tes3mp.SetObjectRefNumIndex(0)
			tes3mp.SetObjectMpNum(mpNum)
			tes3mp.SetObjectPosition(location.posX, location.posY, location.posZ)
			tes3mp.SetObjectRotation(location.rotX, location.rotY, location.rotZ)
			tes3mp.AddWorldObject()	
			if packetType == "place" then
				tes3mp.SendObjectPlace(true)
			elseif packetType == "spawn" then
				tes3mp.SendObjectSpawn(true)
			end
		end
	end
	
	LoadedCells[cell]:Save()
	
	return refIndex
end

removeFurniture = function(refIndex, cell)
	--If for some reason the cell isn't loaded, load it. Causes a bit of spam in the server log, but that can't really be helped.
	--TODO: Ideally this should only be a temporary load
	if LoadedCells[cell] == nil then
		logicHandler.LoadCell(cell)
	end
	
	if LoadedCells[cell]:ContainsObject(refIndex) and not tableHelper.containsValue(LoadedCells[cell].data.packets.delete, refIndex) then --Shouldn't ever have a delete packet, but it's worth checking anyway
		--Delete the object for all the players currently online
		local splitIndex = refIndex:split("-")
		
		for onlinePid, player in pairs(Players) do
			if player:IsLoggedIn() then
				tes3mp.InitializeEvent(onlinePid)
				tes3mp.SetEventCell(cell)
				tes3mp.SetObjectRefNumIndex(splitIndex[1])
				tes3mp.SetObjectMpNum(splitIndex[2])
				tes3mp.AddWorldObject()
				tes3mp.SendObjectDelete()
			end
		end
		
		LoadedCells[cell]:DeleteObjectData(refIndex)
		LoadedCells[cell]:Save()
		--Removing the object from the placed list will be done elsewhere
	end
end

getAvailableFurnitureStock = function(pid, tip)
	--In the future this can be used to customise what items are available for a particular player, like making certain items only available for things like their race, class, level, their factions, or the quests they've completed. For now, however, everything in furnitureData is available :P
	
	local options = {}
	
	for i = 1, #furnitureData do
		if furnitureData[i].tip == tip or tip == "all" then
			table.insert(options, furnitureData[i])
		end
	end
	
	return options
end

--If the player has placed items in the cell, returns an indexed table containing all the refIndexes of furniture that they have placed.
getPlayerPlacedInCell = function(pname, cell)
	local cellPlaced = getPlaced(cell)
	
	if not cellPlaced then
		-- Nobody has placed items in this cell
		return false
	end
	
	local list = {}
	for refIndex, data in pairs(cellPlaced) do
		if data.owner == pname then
			table.insert(list, refIndex)
		end
	end
	
	if #list > 0 then
		return list
	else
		--The player hasn't placed any items in this cell
		return false
	end
end

addFurnitureData = function(data)
	--Check the furniture doesn't already have an entry, if it does, overwrite it
	--TODO: Should probably check that the data is valid
	local fdata, loc = getFurnitureData(data.refId)
	
	if fdata then
		furnitureData[loc] = data
	else
		table.insert(furnitureData, data)
	end
end

WorldMining.AddFurnitureData = function(data)
	addFurnitureData(data)
end
--NOTE: Both AddPermission and RemovePermission use pname, rather than pid
WorldMining.AddPermission = function(pname, cell)
	local perms = getPermissionsTable()
	
	if not perms[cell] then
		perms[cell] = {}
	end
	
	perms[cell][pname] = true
	WorldInstance:Save()
end

WorldMining.RemovePermission = function(pname, cell)
	local perms = getPermissionsTable()
	
	if not perms[cell] then
		return
	end
	
	perms[cell][pname] = nil
	
	WorldInstance:Save()
end

WorldMining.RemoveAllPermissions = function(cell)
	local perms = getPermissionsTable()
	
	perms[cell] = nil
	WorldInstance:Save()
end

WorldMining.RemoveAllPlayerFurnitureInCell = function(pname, cell, returnToOwner)
	local placed = getPlacedTable()
	local cInfo = placed[cell] or {}
	
	for refIndex, info in pairs(cInfo) do
		if info.owner == pname then
			if returnToOwner then
				addFurnitureItem(info.owner, info.refId, 1, false)
			end
			removeFurniture(refIndex, cell)
			removePlaced(refIndex, cell, false)
		end
	end
	WorldInstance:Save()
end

WorldMining.RemoveAllFurnitureInCell = function(cell, returnToOwner)
	local placed = getPlacedTable()
	local cInfo = placed[cell] or {}
	
	for refIndex, info in pairs(cInfo) do
		if returnToOwner then
			addFurnitureItem(info.owner, info.refId, 1, false)
		end
		removeFurniture(refIndex, cell)
		removePlaced(refIndex, cell, false)
	end
	WorldInstance:Save()
end

--Change the ownership of the specified furniture object (via refIndex) to another character's (playerToName). If playerCurrentName is false, the owner will be changed to the new one regardless of who owned it first.
WorldMining.TransferOwnership = function(refIndex, cell, playerCurrentName, playerToName, save)
	local placed = getPlacedTable()
	
	if placed[cell] and placed[cell][refIndex] and (placed[cell][refIndex].owner == playerCurrentName or not playerCurrentName) then
		placed[cell][refIndex].owner = playerToName
	end
	
	if save then
		WorldInstance:Save()
	end
	
	--Unset the current player's selected item, just in case they had that furniture as their selected item
	if playerCurrentName and logicHandler.IsPlayerNameLoggedIn(playerCurrentName) then
		decorateHelp.SetSelectedObject(logicHandler.GetPlayerByName(playerCurrentName).pid, "")
	end
end

--Same as TransferOwnership, but for all items in a given cell
WorldMining.TransferAllOwnership = function(cell, playerCurrentName, playerToName, save)
	local placed = getPlacedTable()
	
	if not placed[cell] then
		return false
	end
	
	for refIndex, info in pairs(placed[cell]) do
		if not playerCurrentName or info.owner == playerCurrentName then
			placed[cell][refIndex].owner = playerToName
		end
	end
	
	if save then
		WorldInstance:Save()
	end
	
	--Unset the current player's selected item, just in case they had any of the furniture as their selected item
	if playerCurrentName and logicHandler.IsPlayerNameLoggedIn(playerCurrentName) then
		decorateHelp.SetSelectedObject(logicHandler.GetPlayerByName(playerCurrentName).pid, "")
	end
end

--New Release 2 WorldMining:
WorldMining.GetSellBackPrice = function(value)
	return getSellValue(value)
end

WorldMining.GetFurnitureDataByRefId = function(refId)
	return getFurnitureData(refId)
end

WorldMining.GetPlacedInCell = function(cell)
	return getPlaced(cell)
end

-- VIEW (OPTIONS)
showViewOptionsGUI = function(pid, loc)
	local msg = ""
	local choice = playerViewOptions[getName(pid)][loc]
	local fdata = getFurnitureData(choice.refId)
	
	msg = msg .. "Item Name: " .. fdata.name .. " (RefIndex: " .. choice.refIndex .. "). Price: 1 (Sell price: 1)"
	
	playerViewChoice[getName(pid)] = choice
	tes3mp.CustomMessageBox(pid, config.ViewOptionsGUI, msg, message.ViewOption)
end

onViewOptionSelect = function(pid)
	local pname = getName(pid)
	local choice = playerViewChoice[pname]
	local cell = tes3mp.GetCell(pid)
	
	if getObject(choice.refIndex, cell) then
		decorateHelp.SetSelectedObject(pid, choice.refIndex)
		tes3mp.MessageBox(pid, -1, message.SelectFurn)
	else
		tes3mp.MessageBox(pid, -1, message.UnFurn)
	end
end

onViewOptionPutAway = function(pid)
	local pname = getName(pid)
	local choice = playerViewChoice[pname]
	local cell = tes3mp.GetCell(pid)
	
	if getObject(choice.refIndex, cell) then
		removeFurniture(choice.refIndex, cell)
		removePlaced(choice.refIndex, cell, true)
		
		addFurnitureItem(pname, choice.refId, 1, true)
		tes3mp.MessageBox(pid, -1, getFurnitureData(choice.refId).name .. message.AddFurn)
	else
		tes3mp.MessageBox(pid, -1, message.UnFurn)
	end
end

onViewOptionSell = function(pid)
	local pname = getName(pid)
	local choice = playerViewChoice[pname]
	local cell = tes3mp.GetCell(pid)
	
	if getObject(choice.refIndex, cell) then
		local saleGold = 1
		
		--Add gold to inventory
		addGold(pid, saleGold)
		
		--Remove the item from the cell
		removeFurniture(choice.refIndex, cell)
		removePlaced(choice.refIndex, cell, true)
		
		--Inform the player
		tes3mp.MessageBox(pid, -1, saleGold .. message.SellFurn)
	else
		tes3mp.MessageBox(pid, -1, message.UnFurn)
	end
end

-- VIEW (MAIN)
showViewGUI = function(pid)
	local pname = getName(pid)
	local cell = tes3mp.GetCell(pid)
	local options = getPlayerPlacedInCell(pname, cell)
	
	local list = "* Retour *\n"
	local newOptions = {}
	
	if options and #options > 0 then
		for i = 1, #options do
			--Make sure the object still exists, and get its data
			local object = getObject(options[i], cell)
			
			if object then
				local furnData = getFurnitureData(object.refId)
				
				list = list .. furnData.name .. " (at " .. math.floor(object.location.posX + 0.5) .. ", "  ..  math.floor(object.location.posY + 0.5) .. ", " .. math.floor(object.location.posZ + 0.5) .. ")"
				if not(i == #options) then
					list = list .. "\n"
				end
				
				table.insert(newOptions, {refIndex = options[i], refId = object.refId})
			end
		end
	end
	
	playerViewOptions[pname] = newOptions
	tes3mp.ListBox(pid, config.ViewGUI, message.PlaceFurn, list)
	--getPlayerPlacedInCell(pname, cell)
end

onViewChoice = function(pid, loc)
	showViewOptionsGUI(pid, loc)
end

-- INVENTORY (OPTIONS)
showInventoryOptionsGUI = function(pid, loc)
	local msg = ""
	local choice = playerInventoryOptions[getName(pid)][loc]
	local fdata = getFurnitureData(choice.refId)
	
	msg = msg .. "Item Name: " .. choice.name .. ". Price: 1 (Sell price: 1)"
	
	playerInventoryChoice[getName(pid)] = choice
	tes3mp.CustomMessageBox(pid, config.InventoryOptionsGUI, msg, message.InvOption)
end

onInventoryOptionPlace = function(pid)
	local pname = getName(pid)
	local curCell = tes3mp.GetCell(pid)
	local choice = playerInventoryChoice[pname]
	
	--First check the player is allowed to place items where they are currently
	if config.whitelist and not hasPlacePermission(pname, curCell) then
		--Player isn't allowed
		tes3mp.MessageBox(pid, -1, message.NoPerm)
		return false
	end
	
	--Remove 1 instance of the item from the player's inventory
	addFurnitureItem(pname, choice.refId, -1, true)
	
	--Place the furniture in the world
	local pPos = {posX = tes3mp.GetPosX(pid), posY = tes3mp.GetPosY(pid), posZ = tes3mp.GetPosZ(pid),  rotX = tes3mp.GetRotX(pid), rotY = 0, rotZ= tes3mp.GetRotZ(pid) }
	for index, item in pairs(furnitureData) do
		if item.refId == choice.refId then
			choice.need = item.need
			break
		end
	end
	local furnRefIndex = placeFurniture(choice.refId, pPos, curCell, choice.need)
	
	--Update the database of all placed furniture
	addPlaced(furnRefIndex, curCell, pname, choice.refId, true, pPos, choice.need)
	--Set the placed item as the player's active object for decorateHelp to use
	decorateHelp.SetSelectedObject(pid, furnRefIndex)
end

onInventoryOptionSell = function(pid)
	local pname = getName(pid)
	local choice = playerInventoryChoice[pname]
	
	local saleGold = 1
	
	--Add gold to inventory
	addGold(pid, saleGold)
	
	--Remove 1 instance of the item from the player's inventory
	addFurnitureItem(pname, choice.refId, -1, true)
	
	--Inform the player
	tes3mp.MessageBox(pid, -1, saleGold .. message.AddGold)
end

-- INVENTORY (MAIN)
showInventoryGUI = function(pid)
	local options = getSortedPlayerFurnitureInventory(pid)
	local list = "* Retour *\n"
	
	for i = 1, #options do
		list = list .. options[i].name .. " (" .. options[i].count .. ")"
		if not(i == #options) then
			list = list .. "\n"
		end
	end
	
	playerInventoryOptions[getName(pid)] = options
	tes3mp.ListBox(pid, config.InventoryGUI, message.SelectFurnInv, list)
end

onInventoryChoice = function(pid, loc)
	showInventoryOptionsGUI(pid, loc)
end

-- BUY (MAIN)
showBuyGUI = function(pid)
	local options = getAvailableFurnitureStock(pid, "normal")
	local list = "* Retour *\n"
	
	for i = 1, #options do
		list = list .. options[i].name
		if not(i == #options) then
			list = list .. "\n"
		end
	end
	playerBuyOptions[getName(pid)] = options
	tes3mp.ListBox(pid, config.BuyGUI, message.SelectBuy, list)
end

WorldMining.showBuyGUIall = function(pid, tip)
	local options = getAvailableFurnitureStock(pid, tip)
	local list = "* Retour *\n"
	
	for i = 1, #options do
		list = list .. options[i].name
		if not(i == #options) then
			list = list .. "\n"
		end
	end
	
	playerBuyOptions[getName(pid)] = options
	tes3mp.ListBox(pid, config.BuyGUI, message.SelectBuy, list)
end

onBuyChoice = function(pid, loc)
	local pgold = getPlayerGold(pid)
	local choice = playerBuyOptions[getName(pid)][loc]
	
	if pgold < 1 then
		tes3mp.MessageBox(pid, -1, message.NoBuy .. choice.name .. ".")
		return false
	end
	
	addGold(pid, -1)
	addFurnitureItem(getName(pid), choice.refId, 1, true)
	
	tes3mp.MessageBox(pid, -1, choice.name .. message.Buy)
	return true
end

WorldMining.OnHitActivate = function(pid, unique, refId, refNum, mpNum)
	--count to 3 for uniqueId
	local drawState = tes3mp.GetDrawState(pid)

	local itemEquipment = {}
	for x, y in pairs(Players[pid].data.equipment) do
		table.insert(itemEquipment, (Players[pid].data.equipment[x]))
	end
	if tableHelper.containsValue(craftTableRock, refId, true) then
		if drawState == 1 then	
			if tableHelper.containsValue(itemEquipment, "miner's pick", true) then			
				logicHandler.RunConsoleCommandOnPlayer(pid, "player->say, \"AM/MinerSOund1.wav\", \"\"", false)
				logicHandler.RunConsoleCommandOnPlayer(pid, "player->PlayGroup, PickProbe, 0", false)
				if Players[pid].data.customVariables.craftUnique == nil then
					Players[pid].data.customVariables.craftUnique = unique
					Players[pid].data.customVariables.craftCount = 1
					return true
				elseif Players[pid].data.customVariables.craftUnique == unique then
					if Players[pid].data.customVariables.craftCount < 3 then
						Players[pid].data.customVariables.craftCount = Players[pid].data.customVariables.craftCount + 1
						return true
					else
						-- he hit 3 times get him a rock or tree
						for index, item in pairs(craftTableRock) do
							if string.lower(item.refId) == refId then
								if item.tip == "rocks" then -- should we go over inventory at all, or store just in a table instead?
									inventoryHelper.addItem(Players[pid].data.inventory, "craftrock", 1, -1, -1, "")
									local itemref = {refId = "craftrock", count = 1, charge = -1}	
									Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)	
								end
								break -- found one match for that inventory item break loop
							end
						end
						objectUniqueIndex = (refNum .. "-" .. mpNum)
						logicHandler.RunConsoleCommandOnObject("disable", tes3mp.GetCell(pid), objectUniqueIndex)
						tes3mp.MessageBox(pid, -1, message.Rock)
						--send fancy message
					end
				else -- if he activated another one
					Players[pid].data.customVariables.craftUnique = unique
					Players[pid].data.customVariables.craftCount = 1
				end
			else
				tes3mp.MessageBox(pid, -1, message.Pick)
			end
		else
			tes3mp.MessageBox(pid, -1, message.Tools)
		end	
		return true
	elseif tableHelper.containsValue(craftTableFlora, refId, true) then
		if drawState == 1 then		
			if tableHelper.containsValue(itemEquipment, "iron battle axe", true) then			
				logicHandler.RunConsoleCommandOnPlayer(pid, "player->say, \"AM/MinerSound2.wav\", \"\"", false)
				logicHandler.RunConsoleCommandOnPlayer(pid, "player->PlayGroup, PickProbe, 0", false)
				if Players[pid].data.customVariables.craftUnique == nil then
					Players[pid].data.customVariables.craftUnique = unique
					Players[pid].data.customVariables.craftCount = 1
				elseif Players[pid].data.customVariables.craftUnique == unique then
					if Players[pid].data.customVariables.craftCount < 3 then
						Players[pid].data.customVariables.craftCount = Players[pid].data.customVariables.craftCount + 1
					else
						-- he hit 3 times get him a rock or tree
						for index, item in pairs(craftTableFlora) do
							if string.lower(item.refId) == refId then
								if item.tip == "flora" then
									inventoryHelper.addItem(Players[pid].data.inventory, "crafttree", 1, -1, -1, "")
									local itemref = {refId = "crafttree", count = 1, charge = -1}	
									Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)	
								end
								break -- found one match for that inventory item break loop
							end
						end
						objectUniqueIndex = (refNum .. "-" .. mpNum)
						logicHandler.RunConsoleCommandOnObject("disable", tes3mp.GetCell(pid), objectUniqueIndex)
						tes3mp.MessageBox(pid, -1, message.Flore)
						--send fancy message
					end
				else -- if he activated another one
					Players[pid].data.customVariables.craftUnique = unique
					Players[pid].data.customVariables.craftCount = 1
				end
			else
				tes3mp.MessageBox(pid, -1, message.Axe)
			end
		else
			tes3mp.MessageBox(pid, -1, message.Tools)
		end			
		return true
	else
		return false
	end
end

WorldMining.OnObjectDelete = function(pid)
	tes3mp.ReadLastEvent()
	local refId = tes3mp.GetObjectRefId(0)
	local cellId = tes3mp.GetCell(pid)
	local location = {
		posX = tes3mp.GetPosX(pid), posY = tes3mp.GetPosY(pid), posZ = tes3mp.GetPosZ(pid),
		rotX = tes3mp.GetRotX(pid), rotY = 0, rotZ = tes3mp.GetRotZ(pid)
	}
	if tableHelper.containsValue(craftTable, refId, true) then
		local removedCount = 1 -- you need to get the real count th player wants to remove
		local existingIndex = nil				
		for slot, item in pairs(Players[pid].data.inventory) do -- does item exist in inventory
			if Players[pid].data.inventory[slot].refId == refId then
				existingIndex = slot
			end
		end			 
		if existingIndex ~= nil then -- if he got item then change count and or remove 
			local inventoryItem = Players[pid].data.inventory[existingIndex] -- get it for working					
			local itemid = inventoryItem.refId -- save for adding into hdvinv					
			for slot, inv in pairs(Players[pid].data.equipment) do -- does player have item equipped
				if inv.refId == itemid then
					Players[pid].data.equipment[slot] = nil
				end    
			end							
			inventoryItem.count = inventoryItem.count - removedCount					
			if inventoryItem.count < 1 then
				inventoryItem = nil
			end			 
			Players[pid].data.inventory[existingIndex] = inventoryItem -- pack it back
			local itemref = {refId = refId, count = 1, charge = -1}
			Players[pid]:Save()
			Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)
			--logicHandler.CreateObjectAtLocation(cellId, location, refId, "place")			
			Players[pid].currentCustomMenu = "menu avertissement mining"--Avertissement
			menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)
			return true
		else
			return true
		end
	else
		return false
	end
end

WorldMining.PunishPrison = function(pid, targetPlayer) -- Used to send a player into the prison
	local targetPlayerName = Players[tonumber(targetPlayer)].name
	local msg = color.Orange .. "SERVER: " .. targetPlayerName .. " est en prison.\n"
	local cell = "Coeurébène, Fort Noctuelle"
	tes3mp.SetCell(pid, cell)
	tes3mp.SendCell(pid)	
	tes3mp.SetPos(pid, 756, 2560, -383)
	tes3mp.SetRot(pid, 0, 0)
	tes3mp.SendPos(pid)	
	tes3mp.SendMessage(pid, msg, true)
	if Players[pid].data.customVariables.Jailer == nil then
		Players[pid].data.customVariables.Jailer = true
	else	
		Players[pid].data.customVariables.Jailer = true
	end
	local TimerJail = tes3mp.CreateTimer("EventJail", time.seconds(300))
	tes3mp.StartTimer(TimerJail)
	tes3mp.MessageBox(pid, -1, message.WaitJail)		
	function EventJail()
		for pid, player in pairs(Players) do
			if Players[pid] ~= nil and player:IsLoggedIn() then
				if Players[pid].data.customVariables.Jailer == true then
					Players[pid].data.customVariables.Jailer = false
					tes3mp.MessageBox(pid, -1, message.StopJail)
					tes3mp.SetCell(pid, "-3, -2")  
					tes3mp.SetPos(pid, -23974, -15787, 505)
					tes3mp.SetRot(pid, 0, 0)
					tes3mp.SendCell(pid)    
					tes3mp.SendPos(pid)
				end
			end
		end
	end
end

WorldMining.PunishKick = function(pid, targetPlayer) -- Used to send a player into the kick
	Players[pid]:Kick()
end

WorldMining.OnDoor = function(pid, unqId)
	local cell = tes3mp.GetCell(pid)
	local activated = WorldInstance.data.customVariables.WorldMining.placed[cell][unqId]
	local solution
	-- if thers more than one door in that cell compare with position in json
	-- and take the one that is closer to the activated one
	local doors = jsonInterface.load("createdDoors.json")
	if #doors[cell] > 1 then
			--beginn complicated math
		local distance = {}
		for index, item in pairs(doors[cell]) do
			distance[index] = math.sqrt((item.location.posX - activated.loc.posX)^2 + (item.location.posY - activated.loc.posY)^2 + (item.location.posZ - activated.loc.posZ)^2)
		end
			--get smallest distance
		local count = -1
		for index, item in pairs(distance) do
			if item < count or count == -1 then
				solution = doors[cell][index] -- we got the best door in solution
				count = item
			end
		end
	else
		for index, item in pairs(doors[cell]) do
			solution = doors[cell][index]
			break
		end
	end
	--teleport to destination
	tes3mp.SetCell(pid, solution.destination.cell)
	tes3mp.SendCell(pid)
	tes3mp.SetPos(pid, solution.destination.location.posX, solution.destination.location.posY, solution.destination.location.posZ + 10)
	tes3mp.SetRot(pid, 0, 0)
	tes3mp.SendPos(pid)
	--maybe fancy message you entered one of playerNames doors
end

craft = function(pid)
	--require material while kanaFurnin
	--remove one of each
	inventoryHelper.removeItem(Players[pid].data.inventory, "crafttree", 1)
	inventoryHelper.removeItem(Players[pid].data.inventory, "craftrock", 1)

	--add material
	inventoryHelper.addItem(Players[pid].data.inventory, "material", 1, -1, -1, "")
	local itemMat = {refId = "material", count = 1, charge = -1}	
	local itemTree = {refId = "crafttree", count = 1, charge = -1}
	local itemRock = {refId = "craftrock", count = 1, charge = -1}		
	Players[pid]:LoadItemChanges({itemMat}, enumerations.inventory.ADD)
	Players[pid]:LoadItemChanges({itemTree}, enumerations.inventory.REMOVE)	
	Players[pid]:LoadItemChanges({itemRock}, enumerations.inventory.REMOVE)		
	--fancy message
	logicHandler.RunConsoleCommandOnPlayer(pid, "player->say, \"AM/MinerSOund2.wav\", \"\"", false)
	WorldMining.OnCraftCommand(pid)
end
	
WorldMining.OnCraftCommand = function(pid)
	--get counts
	local count = {terrain = 0, flora = 0}

	local index = inventoryHelper.getItemIndex(Players[pid].data.inventory, "crafttree")
	if index ~= nil then count.flora = Players[pid].data.inventory[index].count end

	local index2 = inventoryHelper.getItemIndex(Players[pid].data.inventory, "craftrock")
	if index2 ~= nil then count.terrain = Players[pid].data.inventory[index2].count end

	--craftrock, crafttree
	if count.terrain > 0 and count.flora > 0 then
		tes3mp.CustomMessageBox(pid, 1337, "Vous avez "..count.terrain.." Roche et "..count.flora.." Bois", message.CraftOption)
	else
		tes3mp.SendMessage(pid, message.NoCraft, false)
		return showMainGUI(pid)
	end
end

return WorldMining
