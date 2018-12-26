---------------------------
--MarketPlace by Rickoff and DiscordPeter
--helped by David.C
--for version tes3mp 0.7.0
---------------------------
--[[ INSTALLATION
1) Save this file as "MarketPlace.lua" in mp-stuff/scripts and EcarlateItems.json in mpstuff/data

2) Add [ MarketPlace = require("MarketPlace") ] to the top of serverCore.lua

3) Add the following to the elseif chain for commands in "OnPlayerSendMessage" inside commandHandler.lua
[		elseif cmd[1] == "hdv" then
			MarketPlace.showMainGUI(pid)
]	
		
4) Add the following to OnGUIAction in serverCore.lua
	[ if MarketPlace.OnGUIAction(pid, idGui, data) then return end ]
	
5) Add under pluginlist = {} in serverCore.lua
hdvlist = {}
hdvinv = {}

6) Add under function LoadPluginList() in serverCore.lua

function Loadhdvlist()
	tes3mp.LogMessage(2, "Reading hdvlist.json")
	
	hdvlist = jsonInterface.load("hdvlist.json")
	
	if hdvlist == nil then
		hdvlist.players = {}
	end
end

function Loadhdvinv()
	tes3mp.LogMessage(2, "Reading hdvinv.json")
	
	hdvinv = jsonInterface.load("hdvinv.json")
	
	if hdvinv == nil then
		hdvinv.players = {}
	end
end

7) Find function OnServerInit() and add above LoadPluginList() in serverCore.lua
	Loadhdvlist()
	Loadhdvinv()	
]]



local config = {}
 
config.MainGUI = 231363 -- "Transfert;Hotel de vente;Afficher;Fermer")
config.BuyGUI = 231364
config.InventoryGUI = 231365
config.ViewGUI = 231366
config.InventoryOptionsGUI = 231367
config.ViewOptionsGUI = 231368
config.HouseEditPriceGUI = 231369
 
jsonInterface = require("jsonInterface")
tableHelper = require("tableHelper")
inventoryHelper = require("inventoryHelper")
 
math.randomseed( os.time() )
  
MarketPlace = {}
--Forward declarations:
local showMainGUI, showBuyGUI, showInventoryGUI, showViewGUI, showInventoryOptionsGUI, showViewOptionsGUI, showEditPricePrompt
------------
local playerBuyOptions = {}
local playerInventoryOptions = {}
local playerInventoryChoice = {}
local playerViewOptions = {}
local playerViewChoice = {}
-- ===========
--  FONCTION LOCAL
-- ===========
-------------------------
local function getAvailableFurnitureStock(pid)  -- pack players.inventory.refId into table options 
    local options = {}
    local playerName = Players[pid].name
    local ipAddress = tes3mp.GetIP(pid)    
    local itemTable = jsonInterface.load("EcarlateItems.json")	
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
    local hdvlist = jsonInterface.load("hdvlist.json")    
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
    local playerName = Players[pid].name
    local ipAddress = tes3mp.GetIP(pid)
    local hdvinv = jsonInterface.load("hdvinv.json")      
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
    local playerName = Players[pid].name
    local ipAddress = tes3mp.GetIP(pid)
    local newItemid = data
    local newprice = price
    local newItem = { itemid = newItemid, price = newprice }
    local hdvinv = jsonInterface.load("hdvinv.json")
    local existingIndex = tableHelper.getIndexByNestedKeyValue(hdvinv.players[playerName].items, "itemid", newItemid)
 
    if existingIndex ~= nil then
        hdvinv.players[playerName].items[existingIndex] = newItem
        jsonInterface.save("hdvinv.json", hdvinv)
    end   
end
 
local function addHdv(pid, data) -- packs item from hdvinv into hdvlist. complicated 
	local playerName = Players[pid].name
	local ipAddress = tes3mp.GetIP(pid)
	local newItemid = data
	local newItem = { itemid = newItemid, price = 0 }  -- where comes that price from?
	local hdvinv = jsonInterface.load("hdvinv.json")
	local hdvlist = jsonInterface.load("hdvlist.json")
	local existingIndex = tableHelper.getIndexByNestedKeyValue(hdvinv.players[playerName].items, "itemid", newItemid)

	if existingIndex ~= nil and tableHelper.getCount(hdvlist.players[playerName].items) < 4 then        
		local newItem = hdvinv.players[playerName].items[existingIndex]
		table.insert(hdvlist.players[playerName].items, newItem)
		jsonInterface.save("hdvlist.json", hdvlist)
		hdvinv.players[playerName].items[existingIndex] = nil
		tableHelper.cleanNils(hdvinv.players[playerName].items)
		jsonInterface.save("hdvinv.json", hdvinv)
		
	else
		tes3mp.SendMessage(pid, "Vous avez atteint le nombre maximum d'articles")	 
	end   
end
 
local function itemAdd(pid, newItemid) -- gets itemrefId into data and removes 3 in players.inventory and packs it into hdvinv.json	
	local hdvinv = jsonInterface.load("hdvinv.json")   
	local playerName = Players[pid].name
	local newItem = { itemid = "" , price = 0}
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
        Players[pid]:Save() -- reload
	Players[pid]:Load()
        Players[pid]:LoadInventory()
        Players[pid]:LoadEquipment()       
    end	
	if newItem.itemid ~= "" then 
		table.insert(hdvinv.players[playerName].items, newItem)
        jsonInterface.save("hdvinv.json", hdvinv)
	end
end
 
local function itemAchat(pid, data)
    local playerName = Players[pid].name
    local ipAddress = tes3mp.GetIP(pid)
    local newItemid = data.itemid
    local hdvlist = jsonInterface.load("hdvlist.json")
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
				jsonInterface.save("hdvlist.json", hdvlist)
				
				--add item to players inventory and remove gold
				Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count - newPrice
				table.insert(Players[pid].data.inventory, {refId = newItem.itemid, count = count, charge = -1})
				
				
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
						player:Save()
						player:Load()
						player:LoadInventory()
						player:LoadEquipment()
					else
						--If the player isn't logged in, we have to temporarily set the player's logged in variable to true, otherwise the Save function won't save the player's data
						player.loggedIn = true
						player:Save()
						player.loggedIn = false
					end
				else
					table.insert(player.data.inventory, {refId = "gold_001", count = newPrice, charge = -1})	
					if player:IsLoggedIn() then
						--If the player is logged in, we have to update their inventory to reflect the changes
						player:Save()
						player:Load()
						player:LoadInventory()
						player:LoadEquipment()
					else
						--If the player isn't logged in, we have to temporarily set the player's logged in variable to true, otherwise the Save function won't save the player's data
						player.loggedIn = true
						player:Save()
						player.loggedIn = false
					end
				end
			end
		else
			tes3mp.MessageBox(pid, -1, "Vous ne pouvez pas acheter cette objet")				
		end							
	end		
	
	--reload player that bought
	Players[pid]:Save()
	Players[pid]:LoadInventory()
	Players[pid]:LoadEquipment()	
end

local function addItemPlayer(pid, data)
    local playerName = Players[pid].name
    local ipAddress = tes3mp.GetIP(pid)
    local newItemid = data
    local hdvinv = jsonInterface.load("hdvinv.json")
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
		jsonInterface.save("hdvinv.json", hdvinv)
		table.insert(Players[pid].data.inventory, {refId = newItem.itemid, count = count, charge = -1})			

	end	
	--reload player that bought
	Players[pid]:Save()
	Players[pid]:LoadInventory()
	Players[pid]:LoadEquipment()	
end
-- ===========
--  MAIN MENU
-- ===========
-------------------------

MarketPlace.onMainGui = function(pid)
    MarketPlace.showMainGUI(pid)
end
 
MarketPlace.showMainGUI = function(pid)
	MarketPlace.listCheck(pid)
	MarketPlace.itemCheck(pid)
	local message = color.Green .. "BIENVENUE DANS L'HOTEL DE VENTE.\n" .. color.Brown .. "\nAcheter pour acheter des objets.\n Inventaire pour afficher les articles que vous possédez.\n Afficher pour une liste de tous les objets que vous possédez dans la boutique en attente de vente." .. color.Default
	tes3mp.CustomMessageBox(pid, config.MainGUI, message, "Transfert;Hotel de vente;Afficher;Fermer")
end
 
-- ===========
--  TRANSFERT MENU
-- ===========
-------------------------
MarketPlace.onMainBuy = function(pid) ----------- THIS IS NOT BUY ITS SELL. PACK ITEM INTO MARKET
    MarketPlace.showBuyGUI(pid)
end
 
MarketPlace.showBuyGUI = function(pid)
    local playerName = Players[pid].name
    local ipAddress = tes3mp.GetIP(pid)
    local options = getAvailableFurnitureStock(pid) -- gets all available refIds in Inventory
    local list = "* Retour *\n"
    local listItemChanged = false
    local itemTable = jsonInterface.load("EcarlateItems.json")
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
 
MarketPlace.onBuyChoice = function(pid, data)
    local choice = playerBuyOptions[getName(pid)].opt[data]
    itemAdd(pid, choice)   -- this just adds the refId, count 3 and price 0 to hdvinv
end
 
-- ===========
--  HOTEL DE VENTE MENU
-- ===========
-------------------------
MarketPlace.onMainInventory = function(pid)
    MarketPlace.showInventoryGUI(pid)
end
 
MarketPlace.showInventoryGUI = function(pid)
    local playerName = Players[pid].name
    local ipAddress = tes3mp.GetIP(pid)
    local options = getHdvFurnitureStock(pid) -- gets hdvlist 
    local list = "* Retour *\n"
    local listItemChanged = false
    local itemTable = jsonInterface.load("EcarlateItems.json")
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
    playerInventoryOptions[getName(pid)] = {opt = options} 
    tes3mp.ListBox(pid, config.InventoryGUI, "Sélectionnez l'objet que vous voulez acheter ou récupérer", list)
end
 
MarketPlace.onInventoryChoice = function(pid, loc)
    MarketPlace.showInventoryOptionsGUI(pid, loc)
end
 
MarketPlace.showInventoryOptionsGUI = function(pid, loc)
    local message = ""
    local choice = playerInventoryOptions[getName(pid)].opt[loc]
   
    message = message .. "Item ID: " .. choice.itemid
    playerInventoryOptions[getName(pid)].choice = choice
    tes3mp.CustomMessageBox(pid, config.InventoryOptionsGUI, message, "Acheter/Récupérer;Fermer")
end
 
MarketPlace.onInventoryOptionBuy = function(pid, loc)
    local choice = playerInventoryOptions[getName(pid)].choice
    itemAchat(pid, choice)     
end
 
MarketPlace.onInventoryOptionRec = function(pid)
end
 
-- ===========
--  HOTEL ATTENTE MENU
-- ===========
-------------------------
MarketPlace.onMainView = function(pid)
    MarketPlace.showViewGUI(pid)
end
 
MarketPlace.showViewGUI = function(pid) 
    local playerName = Players[pid].name
    local ipAddress = tes3mp.GetIP(pid)
    local options = getHdvInventoryStock(pid) -- gets hdvinv for pid
    local list = "* Retour *\n"
    local listItemChanged = false
    local itemTable = jsonInterface.load("EcarlateItems.json")
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
 
MarketPlace.onViewChoice = function(pid, loc)
    MarketPlace.showViewOptionsGUI(pid, loc)
end
 
MarketPlace.showViewOptionsGUI = function(pid, loc)
 
    local choice = playerViewOptions[getName(pid)].opt[loc].itemid
    local message = choice
   
    playerViewChoice[getName(pid)] = choice
    tes3mp.CustomMessageBox(pid, config.ViewOptionsGUI, message, "Changer le prix;Mettre en vente;Retour")
end
 
MarketPlace.onViewOptionSelect = function(pid, loc)
    MarketPlace.showEditPricePrompt(pid, loc)
end
 
MarketPlace.showEditPricePrompt = function(pid, loc)
    local itemchoice = playerViewChoice[getName(pid)]
    local message = "Entrer un nouveau prix pour"
    return tes3mp.Dialog(pid, config.HouseEditPriceGUI, message, "")
end
 
MarketPlace.addPriceItem = function(pid, loc)
    local choice = playerViewChoice[getName(pid)]  
    priceAdd(pid, loc, choice)
end
 
MarketPlace.onViewOptionPutAway = function(pid, loc)
    local choice = playerViewChoice[getName(pid)]
    addHdv(pid, choice)
end
 
MarketPlace.onViewOptionSell = function(pid, loc)
    local choice = playerViewChoice[getName(pid)]
    addItemPlayer(pid, choice)
end
 
-- ===========
--  MarketPlace CHECK
-- ===========
-------------------------
 
MarketPlace.itemCheck = function(pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local playerName = Players[pid].name  
		nilItemCheck(playerName)                  
    end
end
 
function nilItemCheck(playerName) -- Used to create and manage entries in tokenlist.json    
    -- If this IP address entry doesn't exist, then make new blank entry
	hdvlist = {}
	hdvlist.players = {}
	hdvlist.players[playerName] = nil	
	if tes3mp.GetCaseInsensitiveFilename(os.getenv("MOD_DIR").."/","hdvlist.json") == "invalid" then
		jsonInterface.save("hdvlist.json", hdvlist)
	else
		hdvlist = jsonInterface.load("hdvlist.json")
	end	
	if hdvlist.players[playerName] == nil then
        local player = {}
        player.names = {}
		table.insert(player.names, playerName)
        player.items = {}
        hdvlist.players[playerName] = player
        jsonInterface.save("hdvlist.json", hdvlist)
    -- If this IP address does exist check whether player has been logged
    else
        -- If this IP address already exists for another character, then add this character to it
        if tableHelper.containsValue(hdvlist.players[playerName].names, playerName) == false then
            table.insert(hdvlist.players[playerName].names, playerName)
            jsonInterface.save("hdvlist.json", hdvlist)
        end
    end
end
 
MarketPlace.listCheck = function(pid)				--tes3mp.SendMessage(pid,"inside listcheck called",false)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
        local playerName = Players[pid].name
        local ipAddress = tes3mp.GetIP(pid)    
        nilListCheck(playerName)        
    end
end
 
function nilListCheck(playerName) -- Used to create and manage entries in tokenlist.json        
    -- If this IP address entry doesn't exist, then make new blank entry
	hdvinv = {}
	hdvinv.players = {}
	hdvinv.players[playerName] = nil
	
	if tes3mp.GetCaseInsensitiveFilename(os.getenv("MOD_DIR").."/","hdvinv.json") == "invalid" then
		jsonInterface.save("hdvinv.json", hdvinv)
	else
		hdvinv = jsonInterface.load("hdvinv.json")
	end
	
	if hdvinv.players[playerName] == nil then
        local player = {}
        player.names = {}
		table.insert(player.names, playerName)
        player.items = {}
        hdvinv.players[playerName] = player
        jsonInterface.save("hdvinv.json", hdvinv)
       
    -- If this IP address does exist check whether player has been logged
    else
        -- If this IP address already exists for another character, then add this character to it
        if tableHelper.containsValue(hdvinv.players[playerName].names, playerName) == false then
            table.insert(hdvinv.players[playerName].names, playerName)
            jsonInterface.save("hdvinv.json", hdvlist)    
        end
    end
end
 
-- GENERAL
MarketPlace.OnGUIAction = function(pid, idGui, data) 
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
        elseif tonumber(data) == 3 then -- Fermer
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

return MarketPlace
