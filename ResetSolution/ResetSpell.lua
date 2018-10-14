---------------------------
-- ResetSort by Rickoff and DiscordPeter
--helped by David.C
--
---------------------------
--[[ INSTALLATION
1) Save this file as "ResetSort.lua" in mp-stuff/scripts

2) Add [ ResetSort = require("ResetSort") ] to the top of serverCore.lua

3) Add the following to the elseif chain for commands in "OnPlayerSendMessage" inside commandHandler.lua
[		elseif cmd[1] == "resetspell" then
			ResetSort.showMainGUI(pid)
]	
		
4) Add the following to OnGUIAction in serverCore.lua
	[ if ResetSort.OnGUIAction(pid, idGui, data) then return end ]

]]



local config = {}
 
config.MainGUI = 2231363
config.BuyGUI = 2231364
 
jsonInterface = require("jsonInterface")
tableHelper = require("tableHelper")
inventoryHelper = require("inventoryHelper")
 
math.randomseed( os.time() )
 
 
ResetSort = {}
--Forward declarations:
local showMainGUI, showBuyGUI
------------
local playerBuyOptions = {}
 
-- ===========
--  FONCTION LOCAL
-- ===========
-------------------------
 
local function getAvailableFurnitureStock(pid)  -- pack players.inventory.refId into table options
 
    local options = {}
    local playerName = Players[pid].name
    local ipAddress = tes3mp.GetIP(pid)    
    local itemTable = jsonInterface.load("EcarlateItems.json")
	
    for slot, k in pairs(Players[pid].data.spellbook) do
		local itemid = Players[pid].data.spellbook[slot]	
		table.insert(options, itemid)
    end
     
    return options
end
 
local function getName(pid)
    return string.lower(Players[pid].accountName)
end
 
local function itemAdd(pid, newItemid) -- gets itemrefId into data and removes 3 in players.inventory and packs it into hdvinv.json
	  
    local playerName = Players[pid].name
	local existingIndex = nil
	
	for slot, item in pairs(Players[pid].data.spellbook) do -- does item exist in inventory
		if Players[pid].data.spellbook[slot] == newItemid then
			existingIndex = slot
		end
	end
 
    if existingIndex ~= nil then -- if he got item then change count and or remove 
        local inventoryItem = Players[pid].data.spellbook[existingIndex] -- get it for working
        Players[pid].data.spellbook[existingIndex] = nil -- pack it back
		
        Players[pid]:Save() -- reload
		Players[pid]:Load()
        Players[pid]:LoadInventory()
        Players[pid]:LoadEquipment()
       
    end
	
end
-- ===========
--  MAIN MENU
-- ===========
-------------------------

ResetSort.onMainGui = function(pid)
    ResetSort.showMainGUI(pid)
end
 
ResetSort.showMainGUI = function(pid)
	
    local message = color.Green .. "BIENVENUE DANS LE MENU DES SORTS.\n" .. color.Brown .. "\nListe pour oublier un sort appris." .. color.Default
    tes3mp.CustomMessageBox(pid, config.MainGUI, message, "Liste;Fermer")
end
 
-- ===========
--  TRANSFERT MENU
-- ===========
-------------------------
ResetSort.onMainBuy = function(pid) ----------- THIS IS NOT BUY ITS SELL. PACK ITEM INTO MARKET
    ResetSort.showBuyGUI(pid)
end
 
ResetSort.showBuyGUI = function(pid)
    local playerName = Players[pid].name
    local ipAddress = tes3mp.GetIP(pid)
    local options = getAvailableFurnitureStock(pid) -- gets all available refIds in Inventory
    local list = "* Retour *\n"
    local listItemChanged = false
    local itemTable = jsonInterface.load("EcarlateItems.json")
    local listItem = ""
	
    for i = 1, #options do
 
		for slot, item in pairs(itemTable.items) do
			if item.refid ~= options[i] then
				listItem = options[i]
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
    tes3mp.ListBox(pid, config.BuyGUI, color.CornflowerBlue .. "Sélectionnez un sort que vous souhaitez oublier, pour appliquer son effet veuillez vous deconnecter." .. color.Default, list)
end
 
ResetSort.onBuyChoice = function(pid, data)
    local choice = playerBuyOptions[getName(pid)].opt[data]
    itemAdd(pid, choice)   -- this just adds the refId, count 3 and price 0 to hdvinv
end
 
 
-- GENERAL
ResetSort.OnGUIAction = function(pid, idGui, data)
   
    if idGui == config.MainGUI then -- Main
        if tonumber(data) == 0 then --Tranfert
            ResetSort.onMainBuy(pid)
            return true
        end
    elseif idGui == config.BuyGUI then -- Tranfert
        if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
            --Do nothing
            return ResetSort.onMainGui(pid)
        else   
            ResetSort.onBuyChoice(pid, tonumber(data))
            return ResetSort.onMainGui(pid)
        end
    end
	
end
 

 
return ResetSort
