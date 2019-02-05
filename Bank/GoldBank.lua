--GoldBank.lua by RickOff for tes3mp 0.7.0

--[[ INSTALLATION
1) Save this file as "GoldBank.lua" in mp-stuff/scripts

2) Add [ GoldBank = require("GoldBank") ] to the top of server.lua

3) Add the following to the elseif chain for commands in "OnPlayerSendMessage" inside server.lua
[		elseif cmd[1] == "bank" then
			GoldBank.showMainGUI(pid)
]	
		
4) Add the following to OnGUIAction in server.lua
	[ if GoldBank.OnGUIAction(pid, idGui, data) then return end ]
]]
-- ===========
--MAIN CONFIG
-- ===========
-------------------------
local config = {}
config.TaxGold = 4
config.MainGUI = 856100
config.BankAddGold = 856101
config.BankRemoveGold = 856102

local GoldBank = {}

local showMainGUI, showEditPriceAdd, showEditPriceRemove
-- ===========
--  MAIN MENU
-- ===========
-------------------------

GoldBank.onMainGui = function(pid)
    GoldBank.showMainGUI(pid)
end
 
GoldBank.showMainGUI = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local goldBankCount = 0
		local goldPlayerCount = 0
		if Players[pid].data.customVariables.goldBank == nil then
			Players[pid].data.customVariables.goldBank = 0
			goldBankCount = 0
		else
			goldBankCount = Players[pid].data.customVariables.goldBank
		end	
		local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)			
		if goldLoc == nil then
			goldPlayerCount = 0		
		else
			goldPlayerCount = Players[pid].data.inventory[goldLoc].count
		end
		local message = color.Orange .. "BIENVENUE DANS LA BANQUE ECARLATE.\n\n" .. color.Yellow .. "Déposer :" .. color.White .. " pour transférer l'or de votre inventaire à la banque.\n\n" .. color.Yellow .. "Retirer :" .. color.White .. " pour retirer l'or de votre banque dans votre inventaire.\n\n" .. color.Yellow .. "Banque : " .. color.Red .. goldBankCount .. "\n\n" .. color.Yellow .. "Inventaire : " .. color.Red .. goldPlayerCount .. "\n\n" .. color.Yellow .. "Taxe : " .. color.Red .. config.TaxGold .. " %\n\n"
		tes3mp.CustomMessageBox(pid, config.MainGUI, message, "Déposer;Retirer;Fermer")
	end
end

GoldBank.OnGUIAction = function(pid, idGui, data)
    if idGui == config.MainGUI then -- Main
        if tonumber(data) == 0 then --Add
            GoldBank.onViewOptionAdd(pid)
            return true
        elseif tonumber(data) == 1 then --Remove
            GoldBank.onViewOptionRemove(pid)
            return true	
        elseif tonumber(data) == 2 then --Exit
			return true	
        end
    elseif idGui == config.BankAddGold then
        if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
            --Do nothing
            return GoldBank.onMainGui(pid)
        else
            GoldBank.PlayerAddGold(pid, tonumber(data))
            return GoldBank.onMainGui(pid)
        end 
    elseif idGui == config.BankRemoveGold then
        if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
            --Do nothing
            return GoldBank.onMainGui(pid)
        else
            GoldBank.PlayerRemoveGold(pid, tonumber(data))
            return GoldBank.onMainGui(pid)
        end 		
	end
end

GoldBank.onViewOptionAdd = function(pid, loc)
    GoldBank.showEditPriceAdd(pid, loc)
end

GoldBank.showEditPriceAdd = function(pid, loc)
    local message = "Entrer le montant"
    return tes3mp.InputDialog(pid, config.BankAddGold, message, "")
end

GoldBank.onViewOptionRemove = function(pid, loc)
    GoldBank.showEditPriceRemove(pid, loc)
end

GoldBank.showEditPriceRemove = function(pid, loc)
    local message = "Entrer le montant"
    return tes3mp.InputDialog(pid, config.BankRemoveGold, message, "")
end
	
GoldBank.PlayerAddGold = function(pid, count)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)			
		if goldLoc == nil then
			tes3mp.MessageBox(pid, -1, "Vous n'avez pas d'or dans votre inventaire.")			
		else
			local goldCount = Players[pid].data.inventory[goldLoc].count
			if count ~= nil then 
				if goldCount >= count then
					totalTax = math.floor((config.TaxGold * count)/100)
					totalCount = count - totalTax				
					Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count - count						
					tes3mp.MessageBox(pid, -1, color.White.."Vous avez déposé "..color.Yellow..count..color.White.." pièces d'or et la banque fait "..color.Yellow..totalTax..color.White.." pièces d'or de profit")
					if Players[pid].data.customVariables.goldBank == nil then
						Players[pid].data.customVariables.goldBank = totalCount
					else
						Players[pid].data.customVariables.goldBank = Players[pid].data.customVariables.goldBank + totalCount
					end
					local itemref = {refId = "gold_001", count = count, charge = -1}			
					Players[pid]:Save()
					Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)					
				end
			end
		end
	end
end

GoldBank.PlayerRemoveGold = function(pid, count)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local goldBankCount
		if Players[pid].data.customVariables.goldBank == nil then
			Players[pid].data.customVariables.goldBank = 0
			tes3mp.MessageBox(pid, -1, "Vous n'avez pas d'or dans votre banque.")
			goldBankCount = 0
		else
			goldBankCount = Players[pid].data.customVariables.goldBank
		end
		if goldBankCount ~= nil and goldBankCount >= count then		
			local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)			
			if goldLoc == nil then
				table.insert(Players[pid].data.inventory, {refId = "gold_001", count = count, charge = -1})				
			else
				Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count + count									
			end
			Players[pid].data.customVariables.goldBank = Players[pid].data.customVariables.goldBank - count
			local itemref = {refId = "gold_001", count = count, charge = -1}			
			Players[pid]:Save()
			Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)					
			tes3mp.MessageBox(pid, -1, color.White.."Vous avez récupéré "..color.Yellow..count..color.White.." pièces d'or de la banque.")			
		end
	end	
end

return GoldBank
