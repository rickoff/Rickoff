---------------------------
-- MarketPlace by Rickoff and DiscordPeter
-- helped by Davic.C
--
---------------------------
--[[ INSTALLATION:

Put MarketPlace.lua in mpstuff/scripts folder
Put hdvlist.json and hdvinv.json in mp-stuff/data folder

--add in server.lua on top : 

MarketPlace = require("MarketPlace"),

--add under pluginlist = {} : 

hdvlist = {} 
hdvinv = {}

--add under function LoadPluginList()

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

--add in function OnServerInit() under LoadPluginList()

	Loadhdvlist()
	Loadhdvinv()
	
--add in function OnPlayerSendMessage(pid, message) under elseif cmd

		elseif cmd[1] == "hdv" then
			MarketPlace.itemCheck(pid)		
			MarketPlace.listCheck(pid)
			MarketPlace.showMainGUI(pid)

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
 
    for slot, k in pairs(Players[pid].data.inventory) do
		local itemid = Players[pid].data.inventory[slot].refId
		table.insert(options, itemid)              
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
    tes3mp.MessageBox(pid, -1, newItemid)
 
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
    local newItem = { itemid = newItemid, price = price }  -- where comes that price from?
    local hdvinv = jsonInterface.load("hdvinv.json")
    local hdvlist = jsonInterface.load("hdvlist.json")
 
    local existingIndex = tableHelper.getIndexByNestedKeyValue(hdvinv.players[playerName].items, "itemid", newItemid)
 
    if existingIndex ~= nil then
        local newItem = hdvinv.players[playerName].items[existingIndex]
        hdvlist.players[playerName].items[existingIndex] = newItem
        jsonInterface.save("hdvlist.json", hdvlist)
        hdvinv.players[playerName].items[existingIndex] = nil
        tableHelper.cleanNils(hdvinv.players[playerName].items)
        jsonInterface.save("hdvinv.json", hdvinv)
    end
   
end
 
local function itemAdd(pid, data) -- gets itemrefId into data and removes 3 in players.inventory and packs it into hdvinv.json
 
    local playerName = Players[pid].name
    local ipAddress = tes3mp.GetIP(pid)
    local newItemid = data
    local newItem = { itemid = newItemid, price = 0 }
	hdvinv = {}
    --local hdvinv = jsonInterface.load("hdvinv.json")   
    local removedCount = 1 -- you need to get the real count th player wants to remove
 
	for slot, item in pairs(Players[pid].data.inventory) do
		if Players[pid].data.inventory[slot].refId == newItemid then
			existingIndex = slot
		end
	end
 
    if existingIndex ~= nil then
        local inventoryItem = Players[pid].data.inventory[existingIndex]
        
		newitem = inventoryItem -- save for adding into hdvinv
		
		inventoryItem.count = inventoryItem.count - removedCount
        --Players[pid]:Message("Vous avez mis un objet en attente de vente ")
       
        if inventoryItem.count < 0 then
            inventoryItem = nil
        end
 
        Players[pid].data.inventory[existingIndex] = inventoryItem
		
        Players[pid]:Save()
        Players[pid]:LoadInventory()
        Players[pid]:LoadEquipment()
    end
		hdvinv.players ={[playerName] = {items ={}}}
		
		
	if newitem ~= nil then 
		table.insert(hdvinv.players[playerName].items, newItem)
        jsonInterface.save("hdvinv.json", hdvinv)
	end

end
 
local function itemAchat(pid, data)

    local playerName = Players[pid].name
    local ipAddress = tes3mp.GetIP(pid)
    local newItemid = data.itemid
    local hdvlist = jsonInterface.load("hdvlist.json")
    --local existingIndex = tableHelper.getIndexByNestedKeyValue(hdvlist.players[playerName].items, "itemid", newItemid)
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
    
    
    
    --tes3mp.SendMessage(pid,tostring(existingIndex).."\n")
    local newItem = hdvlist.players[existingPlayer].items[existingIndex]     
    --tes3mp.SendMessage(pid,newItem.itemid.."\n")
    local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)
    local newPrice = newItem.price
    local itemLoc = newItem.itemid
    local goldcount = Players[pid].data.inventory[goldLoc].count
    local count = 1
	
    if goldLoc then
        Players[pid]:Message("goldLoc is " .. tostring(goldcount) .. "\n")
        if goldcount >= newPrice then
			Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count - newPrice
            if existingIndex ~= nil then
                Players[pid]:Message("existingIndex " .. tostring(existingIndex) .. "\n")    
                local newItem = hdvlist.players[existingPlayer].items[existingIndex]    
                hdvlist.players[existingPlayer].items[existingIndex] = nil
                tableHelper.cleanNils(hdvlist.players[existingPlayer].items)
                jsonInterface.save("hdvlist.json", hdvlist)

                table.insert(Players[pid].data.inventory, {refId = newItem.itemid, count = count, charge = -1})
            end
        else
            tes3mp.MessageBox(pid, -1, "Vous ne pouvez pas acheter cette objet")                
        end
    end        

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
    hdvlist = jsonInterface.load("hdvlist.json")
    hdvinv = jsonInterface.load("hdvinv.json")    
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
    local list = "* CLOSE *\n"
   
    for i = 1, #options do
        list = list .. options[i]
   
        if not(i == #options) then
            list = list .. "\n"
        end
    end
   
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
    local list = "* CLOSE *\n"
   
    for i = 1, #options do
        list = list .. options[i].itemid.." for Gold: "..options[i].price
   
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
    tes3mp.CustomMessageBox(pid, config.InventoryOptionsGUI, message, "Acheter;Récupérer;Fermer")
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
    local list = "* CLOSE *\n"
   
    for i = 1, #options do
        list = list .. options[i].itemid.." Gold: "..options[i].price
   
        if not(i == #options) then
            list = list .. "\n"
        end
    end
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
    tes3mp.CustomMessageBox(pid, config.ViewOptionsGUI, message, "Changer le prix;Mettre en vente;Récupérer;Fermer")
end
 
MarketPlace.onViewOptionSelect = function(pid, loc)
    MarketPlace.showEditPricePrompt(pid, loc)
end
 
MarketPlace.showEditPricePrompt = function(pid, loc)
    local itemchoice = playerViewChoice[getName(pid)]
    tes3mp.MessageBox(pid, -1, itemchoice) 
    local message = "Entrer un nouveau prix pour"
    return tes3mp.InputDialog(pid, config.HouseEditPriceGUI, message)
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
    addItem(pid, choice)
end
 
-- ===========
--  MarketPlace CHECK
-- ===========
-------------------------
 
MarketPlace.itemCheck = function(pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
        local playerName = Players[pid].name
        local ipAddress = tes3mp.GetIP(pid)    
 
        for slot= 0, 200, 1 do
            if Players[pid].data.inventory[slot] ~= nil then
                local itemid = Players[pid].data.inventory[slot].refId
                nilItemCheck(playerName, ipAddress, itemid)            
            end
        end
       
    end
end
 
function nilItemCheck(playerName, ipAddress, itemid) -- Used to create and manage entries in tokenlist.json    
    -- If this IP address entry doesn't exist, then make new blank entry
    if hdvlist.players[playerName] == nil then
        local player = {}
        player.names = {}
        player.items = {}
        player.items[1] = {}
        player.items[1].itemid = ""
        player.items[1].price = 0
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
 
MarketPlace.listCheck = function(pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
        local playerName = Players[pid].name
        local ipAddress = tes3mp.GetIP(pid)    
        nilListCheck(playerName, ipAddress)        
    end
end
 
function nilListCheck(playerName, ipAddress) -- Used to create and manage entries in tokenlist.json        
    -- If this IP address entry doesn't exist, then make new blank entry
    if hdvinv.players[playerName] == nil then
        local player = {}
        player.names = {}
        player.items = {}
        player.items[1] = {}
        player.items[1].itemid = ""
        player.items[1].price = 0
        hdvinv.players[playerName] = player
        jsonInterface.save("hdvinv.json", hdvinv)
       
    -- If this IP address does exist check whether player has been logged
    else
        -- If this IP address already exists for another character, then add this character to it
        if tableHelper.containsValue(hdvlist.players[playerName].names, playerName) == false then
            table.insert(hdvlist.players[playerName].names, playerName)
            jsonInterface.save("hdvlist.json", hdvlist)    
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
            return true
        else   
            MarketPlace.onBuyChoice(pid, tonumber(data))
            return true
        end
    elseif idGui == config.HouseEditPriceGUI then
        if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
            --Do nothing
            return true
        else
            MarketPlace.addPriceItem(pid, tonumber(data))
            return true
        end        
    elseif idGui == config.InventoryGUI then --Hotel de vente
        if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
            --Do nothing
            return true
        else
            MarketPlace.onInventoryChoice(pid, tonumber(data))
            return true
        end
    elseif idGui == config.InventoryOptionsGUI then --Hotel de vente option
        if tonumber(data) == 0 then --Acheter
            MarketPlace.onInventoryOptionBuy(pid)
            return true
        elseif tonumber(data) == 1 then --Récupérer
            MarketPlace.onInventoryOptionRec(pid)
            return true
        else --Close
            --Do nothing
            return true
        end
    elseif idGui == config.ViewGUI then --Hotel d'attente
        if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
            --Do nothing
            return true
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
        elseif tonumber(data) == 2 then --Recuperer
            MarketPlace.onViewOptionSell(pid)
        else --Close
            --Do nothing
            return true
        end
    end
end
 
 
 
return MarketPlace
