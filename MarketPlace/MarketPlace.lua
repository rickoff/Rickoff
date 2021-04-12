--[[
MarketPlace by Rickoff and DiscordPeter
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Hotel de vente entre joueur avec menu
---------------------------
INSTALLATION:
Save the file as MarketPlace.lua inside your server/scripts/custom folder.
Save the file as hdvlist.json inside your server/data/custom folder.
Save the file as hdvinv.json inside your server/data/custom folder.
Save the file as EcarlateItems.json inside your server/data/custom folder.

Edits to customScripts.lua
MarketPlace = require("custom.MarketPlace")
---------------------------
]]
local config = {}
config.MainGUI = 231363
config.BuyGUI = 231364
config.InventoryGUI = 231365
config.ViewGUI = 231366
config.InventoryOptionsGUI = 231367
config.ViewOptionsGUI = 231368
config.HouseEditPriceGUI = 231369

local showMainGUI, showBuyGUI, showInventoryGUI, showViewGUI, showInventoryOptionsGUI, showViewOptionsGUI, showEditPricePrompt
------------
local playerBuyOptions = {}
local playerInventoryOptions = {}
local playerInventoryChoice = {}
local playerViewOptions = {}
local playerViewChoice = {}
local hdvlist = {}
local hdvinv = {}

local MarketPlace = {}
-- ===========
--  FONCTION LOCAL
-- ===========
-------------------------
local function Loadhdvlist()
	tes3mp.LogMessage(2, "Reading hdvlist.json")
	
	hdvlist = jsonInterface.load("custom/hdvlist.json")
	
	if hdvlist == nil then
		hdvlist.players = {}
	end
end

local function Loadhdvinv()
	tes3mp.LogMessage(2, "Reading hdvinv.json")
	
	hdvinv = jsonInterface.load("custom/hdvinv.json")
	
	if hdvinv == nil then
		hdvinv.players = {}
	end
end
 
local function getAvailableFurnitureStock(pid)  -- pack players.inventory.refId into table options
	local options = {}   
	local itemTable = jsonInterface.load("custom/EcarlateItems.json")
	
	for slot, k in pairs(Players[pid].data.inventory) do
		local itemid = Players[pid].data.inventory[slot].refId
		
		for slot2, item in pairs(itemTable.items) do
			if item.refid == itemid then			
				table.insert(options, itemid)
			end
		end 
		
	end
 
	return options
end
 
local function getHdvFurnitureStock(pid)  
	local options = {}
	local hdvlist = jsonInterface.load("custom/hdvlist.json") 
   
	for slot, player in pairs(hdvlist.players) do
		for slot2, stuff in pairs(player.items) do
			local item = hdvlist.players[slot].items[slot2]
			table.insert(options, item)         
		end
	end
	
   
	return options
end
 
local function getHdvInventoryStock(pid) -- does the same with hdvinv 
	local options = {}
	local playerName = string.lower(Players[pid].name)
	local hdvinv = jsonInterface.load("custom/hdvinv.json")   
   
	for slot, k in pairs(hdvinv.players[playerName].items) do
		local item = hdvinv.players[playerName].items[slot]
		table.insert(options, item)        
	end
   
   
	return options
end
 
local function getName(pid)
	return string.lower(Players[pid].accountName)
end
 
local function priceAdd(pid, price, data) --- where is that called. messed up. adds price to item in hdvinv
	local playerName = string.lower(Players[pid].name)
	local newItemid = data
	local newprice = price
	local newItem = { itemid = newItemid, price = newprice, owner = playerName }
	local hdvinv = jsonInterface.load("custom/hdvinv.json")
 
	local existingIndex = tableHelper.getIndexByNestedKeyValue(hdvinv.players[playerName].items, "itemid", newItemid)
 
	if existingIndex ~= nil then
		hdvinv.players[playerName].items[existingIndex] = newItem
		jsonInterface.save("custom/hdvinv.json", hdvinv)
	end
end
 
local function addHdv(pid, data) -- packs item from hdvinv into hdvlist. complicated
	local playerName = string.lower(Players[pid].name)
	local newItemid = data
	local newItem = { itemid = newItemid, price = 0, owner = playerName }  -- where comes that price from?
	local hdvinv = jsonInterface.load("custom/hdvinv.json")
	local hdvlist = jsonInterface.load("custom/hdvlist.json")

	local existingIndex = tableHelper.getIndexByNestedKeyValue(hdvinv.players[playerName].items, "itemid", newItemid)

	if existingIndex ~= nil and tableHelper.getCount(hdvlist.players[playerName].items) < 4 then
		
		local newItem = hdvinv.players[playerName].items[existingIndex]
		table.insert(hdvlist.players[playerName].items, newItem)
		jsonInterface.save("custom/hdvlist.json", hdvlist)
		hdvinv.players[playerName].items[existingIndex] = nil
		tableHelper.cleanNils(hdvinv.players[playerName].items)
		jsonInterface.save("custom/hdvinv.json", hdvinv)	
	else
		tes3mp.SendMessage(pid, "Vous avez atteint le nombre maximum d'articles")
	end
end
 
local function itemAdd(pid, newItemid) -- gets itemrefId into data and removes 3 in players.inventory and packs it into hdvinv.json
	local hdvinv = jsonInterface.load("custom/hdvinv.json")   
	local playerName = string.lower(Players[pid].name)
	local newItem = { itemid = "" , price = 0, owner = playerName}
	local removedCount = 1 -- you need to get the real count th player wants to remove
	local existingIndex = nil
	
	for slot, item in pairs(Players[pid].data.inventory) do -- does item exist in inventory
		if Players[pid].data.inventory[slot].refId == newItemid then
			existingIndex = slot
		end
	end
 
	if existingIndex ~= nil then -- if he got item then change count and or remove 
		local inventoryItem = Players[pid].data.inventory[existingIndex] -- get it for working
		
		newItem.itemid = inventoryItem.refId -- save for adding into hdvinv
		newItem.price = 0
		
		for slot, inv in pairs(Players[pid].data.equipment) do -- does player have item equipped
			if inv.refId == newItem.itemid then
				Players[pid].data.equipment[slot] = nil
			end    
		end		
		
		inventoryItem.count = inventoryItem.count - removedCount
		
		if inventoryItem.count < 1 then
			inventoryItem = nil
		end
 
		Players[pid].data.inventory[existingIndex] = inventoryItem -- pack it back

		local itemref = {refId = newItem.itemid, count = 1, charge = -1}
		Players[pid]:QuicksaveToDrive()
		Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)		
	   
	end
	
	if newItem.itemid ~= "" then 
		table.insert(hdvinv.players[playerName].items, newItem)
		jsonInterface.save("custom/hdvinv.json", hdvinv)
	end
end
 
local function itemAchat(pid, data)
	local playerName = string.lower(Players[pid].name)
	local newItemid = data.itemid
	local hdvlist = jsonInterface.load("custom/hdvlist.json")
	local existingIndex = 0
	local existingPlayer = ""
	for slot, player in pairs(hdvlist.players) do
		for itemSlot, item in pairs(player.items) do
			if item.itemid == newItemid then
				existingIndex = itemSlot
				existingPlayer = slot
			end
		end
	end

	local newItem = hdvlist.players[existingPlayer].items[existingIndex] 	
	local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)
	local newPrice = newItem.price
	local itemLoc = newItem.itemid
	local count = 1
		
	if goldLoc == nil then
		tes3mp.MessageBox(pid, -1, "Vous n'avez pas d'or sur vous!")
	elseif goldLoc then
		local goldcount = Players[pid].data.inventory[goldLoc].count
		if goldcount >= newPrice then
			if existingIndex ~= nil then
				
				-- remove item from hdvlist
				hdvlist.players[existingPlayer].items[existingIndex] = nil
				tableHelper.cleanNils(hdvlist.players[existingPlayer].items)
				jsonInterface.save("custom/hdvlist.json", hdvlist)
				
				--add item to players inventory and remove gold
				Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count - newPrice
				table.insert(Players[pid].data.inventory, {refId = newItem.itemid, count = count, charge = -1, soul = ""})
				local goldprice = {refId = "gold_001", count = newPrice, charge = -1, soul = ""}	
				local itemref = {refId = newItem.itemid, count = count, charge = -1, soul = ""}
				Players[pid]:QuicksaveToDrive()
				Players[pid]:LoadItemChanges({goldprice}, enumerations.inventory.REMOVE)				
				Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)	
				
				--add Gold to Sellers Inventory
				local player = logicHandler.GetPlayerByName(existingPlayer)
				local goldLocSeller = nil
				
				for slot, item in pairs(player.data.inventory) do
					if item.refId == "gold_001" then
						goldLocSeller = slot
					end
				end
				
				if goldLocSeller ~= nil then
					player.data.inventory[goldLocSeller].count = player.data.inventory[goldLocSeller].count + newPrice
				
					if player:IsLoggedIn() then
						--If the player is logged in, we have to update their inventory to reflect the changes
						local itemref = {refId = "gold_001", count = newPrice, charge = -1, soul = ""}	
						player:QuicksaveToDrive()
						player:LoadItemChanges({itemref}, enumerations.inventory.ADD)						
					else
						--If the player isn't logged in, we have to temporarily set the player's logged in variable to true, otherwise the Save function won't save the player's data
						player.loggedIn = true
						player:QuicksaveToDrive()
						player.loggedIn = false
					end
				else
					table.insert(player.data.inventory, {refId = "gold_001", count = newPrice, charge = -1, soul = ""})	
					if player:IsLoggedIn() then
						--If the player is logged in, we have to update their inventory to reflect the changes
						local itemref = {refId = "gold_001", count = newPrice, charge = -1, soul = ""}	
						player:QuicksaveToDrive()
						player:LoadItemChanges({itemref}, enumerations.inventory.ADD)
					else
						--If the player isn't logged in, we have to temporarily set the player's logged in variable to true, otherwise the Save function won't save the player's data
						player.loggedIn = true
						player:QuicksaveToDrive()
						player.loggedIn = false
					end
				end
			end
		else
			tes3mp.MessageBox(pid, -1, "Vous ne pouvez pas acheter cette objet")				
		end							
	end	
end

local function addItemPlayer(pid, data)
	local playerName = string.lower(Players[pid].name)
	local newItemid = data
	local hdvinv = jsonInterface.load("custom/hdvinv.json")
	--local existingIndex = tableHelper.getIndexByNestedKeyValue(hdvlist.players[playerName].items, "itemid", newItemid)
	local existingIndex = 0
	local existingPlayer = ""
	
	for slot, player in pairs(hdvinv.players) do
		for itemSlot, item in pairs(player.items) do
			if item.itemid == newItemid then
				existingIndex = itemSlot
				existingPlayer = slot
			end
		end
	end
	
	local newItem = hdvinv.players[existingPlayer].items[existingIndex] 	
	local itemLoc = newItem.itemid
	local count = 1

	if existingIndex ~= nil then
		
		-- remove item from hdvlist
		hdvinv.players[existingPlayer].items[existingIndex] = nil
		tableHelper.cleanNils(hdvinv.players[existingPlayer].items)
		jsonInterface.save("custom/hdvinv.json", hdvinv)
		table.insert(Players[pid].data.inventory, {refId = newItem.itemid, count = count, charge = -1})
		local itemref = {refId = newItem.itemid, count = count, charge = -1}
		Players[pid]:QuicksaveToDrive()
		Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)						
	end
end

function nilItemCheck(playerName) -- Used to create and manage entries in tokenlist.json    
    -- If this IP address entry doesn't exist, then make new blank entry
	hdvlist = {}
	hdvlist.players = {}
	hdvlist.players[playerName] = nil
	
	
	if tes3mp.GetCaseInsensitiveFilename(tes3mp.GetDataPath().. "/custom/","hdvlist.json") == "invalid" then
		jsonInterface.save("custom/hdvlist.json", hdvlist)
	else
		hdvlist = jsonInterface.load("custom/hdvlist.json")
	end

	
	if hdvlist.players[playerName] == nil then
        local player = {}
        player.names = {}
		table.insert(player.names, playerName)
        player.items = {}
        hdvlist.players[playerName] = player
        jsonInterface.save("custom/hdvlist.json", hdvlist)
    -- If this IP address does exist check whether player has been logged
    else
        -- If this IP address already exists for another character, then add this character to it
        if tableHelper.containsValue(hdvlist.players[playerName].names, playerName) == false then
            table.insert(hdvlist.players[playerName].names, playerName)
            jsonInterface.save("custom/hdvlist.json", hdvlist)
        end
    end
end

function nilListCheck(playerName) -- Used to create and manage entries in tokenlist.json        
    -- If this IP address entry doesn't exist, then make new blank entry
	hdvinv = {}
	hdvinv.players = {}
	hdvinv.players[playerName] = nil
	
	if tes3mp.GetCaseInsensitiveFilename(tes3mp.GetDataPath().. "/custom/","hdvinv.json") == "invalid" then
		jsonInterface.save("custom/hdvinv.json", hdvinv)
	else
		hdvinv = jsonInterface.load("custom/hdvinv.json")
	end
	
	if hdvinv.players[playerName] == nil then
        local player = {}
        player.names = {}
		table.insert(player.names, playerName)
        player.items = {}
        hdvinv.players[playerName] = player
        jsonInterface.save("custom/hdvinv.json", hdvinv)
       
    -- If this playerName does exist check whether player has been logged
    else
        -- If this playerName already exists for another character, then add this character to it
        if tableHelper.containsValue(hdvinv.players[playerName].names, playerName) == false then
            table.insert(hdvinv.players[playerName].names, playerName)
            jsonInterface.save("custom/hdvinv.json", hdvlist)    
        end
    end
end
-- ===========
--  MAIN MENU
-- ===========
-------------------------

MarketPlace.OnServerPostInit = function(eventStatus)
	Loadhdvlist()
	Loadhdvinv()
end

MarketPlace.onMainGui = function(pid)
    MarketPlace.showMainGUI(pid)
end
 
MarketPlace.showMainGUI = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		MarketPlace.listCheck(pid)
		MarketPlace.itemCheck(pid)	
		local message = color.Orange .. "BIENVENUE DANS L'HOTEL DE VENTE.\n" .. color.Yellow .. "\nTransfert:" .. color.White ..  " pour afficher les objets de votre inventaire.\n\n"  .. color.Yellow .. "Hotel de vente:" .. color.White ..  "pour afficher les objets en vente.\n\n" .. color.Yellow .. "Stock:" .. color.White .. " pour afficher la liste de vos objets en attente.\n" .. color.Default
		tes3mp.CustomMessageBox(pid, config.MainGUI, message, "Transfert;Hotel de vente;Stock;Retour;Fermer")
	end
end
 
-- ===========
--  TRANSFERT MENU
-- ===========
-------------------------
MarketPlace.onMainBuy = function(pid) ----------- THIS IS NOT BUY ITS SELL. PACK ITEM INTO MARKET
    MarketPlace.showBuyGUI(pid)
end
 
MarketPlace.showBuyGUI = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local playerName = string.lower(Players[pid].name)
		local options = getAvailableFurnitureStock(pid) -- gets all available refIds in Inventory
		local list = "* Retour *\n"
		local listItemChanged = false
		local itemTable = jsonInterface.load("custom/EcarlateItems.json")
		local listItem = ""
		
		for i = 1, #options do
	 
			for slot, item in pairs(itemTable.items) do
				if item.refid == options[i] then
					listItem = item.name
					listItemChanged = true
					break
				else
					listItemChanged = false
				end
			end 
			
			if listItemChanged == true then
				list = list .. listItem
			end
			
			if listItemChanged == false then
				list= list .. "\n"
			end
			
			if not(i == #options) then
				list = list .. "\n"
			end
		end
		
		listItemChanged = false
		playerBuyOptions[getName(pid)] = {opt = options}
		tes3mp.ListBox(pid, config.BuyGUI, color.CornflowerBlue .. "Sélectionnez un article que vous souhaitez mettre en attente de vente" .. color.Default, list)
	end  
end
 
MarketPlace.onBuyChoice = function(pid, data)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local choice = playerBuyOptions[getName(pid)].opt[data]
		itemAdd(pid, choice)   -- this just adds the refId, count 3 and price 0 to hdvinv
	end
end
 
-- ===========
--  HOTEL DE VENTE MENU
-- ===========
-------------------------
MarketPlace.onMainInventory = function(pid)
    MarketPlace.showInventoryGUI(pid)
end
 
MarketPlace.showInventoryGUI = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local playerName = string.lower(Players[pid].name)
		local options = getHdvFurnitureStock(pid) -- gets hdvlist 
		local list = "* Retour *\n"
		local listItemChanged = false
		local itemTable = jsonInterface.load("custom/EcarlateItems.json")
		local listItem = ""
	   	
		for i = 1, #options do
			for slot, item in pairs(itemTable.items) do
				if item.refid == options[i].itemid then
					listItem = item.name
					listItemChanged = true
					break
				else
					listItemChanged = false
				end
			end 

			if listItemChanged == true then
				list = list..options[i].owner.." : "..listItem.." : "..options[i].price.." Gold "
			end
			
			if listItemChanged == false then
				list = list..options[i].owner.." : "..options[i].itemid.." : "..options[i].price.." Gold "
			end
			
			if not(i == #options) then
				list = list .. "\n"
			end
		end
		
		playerInventoryOptions[getName(pid)] = {opt = options} 
		tes3mp.ListBox(pid, config.InventoryGUI, "Sélectionnez l'objet que vous voulez acheter ou récupérer", list)
	end
end
 
MarketPlace.onInventoryChoice = function(pid, loc)
    MarketPlace.showInventoryOptionsGUI(pid, loc)
end
 
MarketPlace.showInventoryOptionsGUI = function(pid, loc)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local message = ""
		local choice = playerInventoryOptions[getName(pid)].opt[loc]
		if choice ~= nil and choice.itemid ~= nil then
			message = message .. "Item ID: " .. choice.itemid
			playerInventoryOptions[getName(pid)].choice = choice
			tes3mp.CustomMessageBox(pid, config.InventoryOptionsGUI, message, "Acheter/Récupérer;Retour")
		else
			tes3mp.SendMessage(pid, "Désolé vous êtes en retard. Cet article vient d'être acheté.\n",false)
		end
	end
end
 
MarketPlace.onInventoryOptionBuy = function(pid, loc)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local choice = playerInventoryOptions[getName(pid)].choice
		if choice ~= nil then	
			itemAchat(pid, choice) 
		end
	end
end
-- ===========
--  HOTEL ATTENTE MENU
-- ===========
-------------------------
MarketPlace.onMainView = function(pid)
    MarketPlace.showViewGUI(pid)
end
 
MarketPlace.showViewGUI = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local playerName = string.lower(Players[pid].name)
		local options = getHdvInventoryStock(pid) -- gets hdvinv for pid
		local list = "* Retour *\n"
		local listItemChanged = false
		local itemTable = jsonInterface.load("custom/EcarlateItems.json")
		local listItem = ""
		
		for i = 1, #options do
	 
			for slot, item in pairs(itemTable.items) do
				if item.refid == options[i].itemid then
					listItem = item.name
					listItemChanged = true
					break
				else
					listItemChanged = false
				end
			end 
			
			if listItemChanged == true then
				list = list .. listItem.." pour: "..options[i].price.." Gold "
			end
			
			if listItemChanged == false then
				list = list.. options[i].itemid.." pour: "..options[i].price.." Gold "
			end
			
			if not(i == #options) then
				list = list .. "\n"
			end
		end
		listItemChanged = false
		playerViewOptions[getName(pid)] = {opt = options}
		tes3mp.ListBox(pid, config.ViewGUI, "Sélectionnez un article que vous avez mit en attente pour le modifier.", list)
	end
end
 
MarketPlace.onViewChoice = function(pid, loc)
    MarketPlace.showViewOptionsGUI(pid, loc)
end
 
MarketPlace.showViewOptionsGUI = function(pid, loc)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then 
		local choice = playerViewOptions[getName(pid)].opt[loc].itemid
		local message = choice
	   
		playerViewChoice[getName(pid)] = choice
		tes3mp.CustomMessageBox(pid, config.ViewOptionsGUI, message, "Changer le prix;Mettre en vente;Retour")
	end
end
 
MarketPlace.onViewOptionSelect = function(pid, loc)
    MarketPlace.showEditPricePrompt(pid, loc)
end
 
MarketPlace.showEditPricePrompt = function(pid, loc)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local itemchoice = playerViewChoice[getName(pid)]
		local message = "Entrer un nouveau prix pour"
		return tes3mp.InputDialog(pid, config.HouseEditPriceGUI, message, "")
	end
end
 
MarketPlace.addPriceItem = function(pid, loc)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local choice = playerViewChoice[getName(pid)]  
		priceAdd(pid, loc, choice)
	end
end
 
MarketPlace.onViewOptionPutAway = function(pid, loc)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local choice = playerViewChoice[getName(pid)]
		addHdv(pid, choice)
	end
end
 
MarketPlace.onViewOptionSell = function(pid, loc)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local choice = playerViewChoice[getName(pid)]
		addItemPlayer(pid, choice)
	end
end
 
-- ===========
--  MarketPlace CHECK
-- ===========
-------------------------
 
MarketPlace.itemCheck = function(pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local playerName = string.lower(Players[pid].name)  
		nilItemCheck(playerName)                  
    end
end
 
MarketPlace.listCheck = function(pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
        local playerName = string.lower(Players[pid].name)   
        nilListCheck(playerName)        
    end
end
 
-- GENERAL
MarketPlace.OnGUIAction = function(pid, idGui, data)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then   
		if idGui == config.MainGUI then -- Main
			if tonumber(data) == 0 then --Tranfert
				MarketPlace.onMainBuy(pid)
				return true
			elseif tonumber(data) == 1 then -- Hotel de vente
				MarketPlace.onMainInventory(pid)
				return true
			elseif tonumber(data) == 2 then -- Hotel d'attente
				MarketPlace.onMainView(pid)
				return true
			elseif tonumber(data) == 3 then -- retour
				Players[pid].currentCustomMenu = "menu player"
				menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)
				return true
			elseif tonumber(data) == 4 then -- fermer
				--Do nothing
				return true			
			end
		elseif idGui == config.BuyGUI then -- Tranfert
			if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
				--Do nothing
				return MarketPlace.onMainGui(pid)
			else   
				MarketPlace.onBuyChoice(pid, tonumber(data))
				return MarketPlace.onMainGui(pid)
			end
		elseif idGui == config.HouseEditPriceGUI then
			if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
				--Do nothing
				return true
			else
				MarketPlace.addPriceItem(pid, tonumber(data))
				return MarketPlace.onMainView(pid)
			end        
		elseif idGui == config.InventoryGUI then --Hotel de vente
			if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
				--Do nothing
				return MarketPlace.onMainGui(pid)
			else
				MarketPlace.onInventoryChoice(pid, tonumber(data))
				return true
			end
		elseif idGui == config.InventoryOptionsGUI then --Hotel de vente option
			if tonumber(data) == 0 then --Acheter
				MarketPlace.onInventoryOptionBuy(pid)
				return MarketPlace.onMainInventory(pid)
			else --Close
				--Do nothing
				return true
			end
		elseif idGui == config.ViewGUI then --Hotel d'attente
			if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
				--Do nothing
				return MarketPlace.onMainGui(pid)
			else
				MarketPlace.onViewChoice(pid, tonumber(data))
				return true
			end
		elseif idGui == config.ViewOptionsGUI then -- Hotel d'attente
			if tonumber(data) == 0 then --Prix
				MarketPlace.onViewOptionSelect(pid)
				return true
			elseif tonumber(data) == 1 then --Vente
				MarketPlace.onViewOptionPutAway(pid)
				return MarketPlace.onMainView(pid)
			else --Retour
				--Do nothing
				return MarketPlace.onMainView(pid)
			end
		end
	end
end

customEventHooks.registerHandler("OnServerPostInit", MarketPlace.OnServerPostInit)
customCommandHooks.registerCommand("hdv", MarketPlace.showMainGUI)
customEventHooks.registerHandler("OnGUIAction", function(eventStatus, pid, idGui, data)
	if MarketPlace.OnGUIAction(pid, idGui, data) then return end
end)

return MarketPlace
