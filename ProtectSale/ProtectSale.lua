--[[
ProtectSale by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Protect item sale
---------------------------
INSTALLATION:
Save the file as ProtectSale.lua inside your server/scripts/custom folder.
save the file as EcarclateNpc.json inside your server/data
Edits to customScripts.lua
ProtectSale = require("custom.ProtectSale")
---------------------------
]]
tableHelper = require("tableHelper")
jsonInterface = require("jsonInterface")

local config = {}
config.tabItem = {"misc_soulgem_azura", "misc_soulgem_common", "misc_soulgem_grand", "misc_soulgem_greater", "misc_soulgem_lesser", "misc_soulgem_petty"}--add in list your item not sale

local ProtectSaleNpcTab = { player = {} }
local ProtectSaleTab = { player = {} }

local ProtectSale = {}

local npcTable = jsonInterface.load("EcarlateNpc.json")
local listIdNpc = {}
for slot1, npc in pairs(npcTable.Npc) do
	local refId = string.lower(npc.Refid)			
	table.insert(listIdNpc, refId)
end	

ProtectSale.OnObjectActivate = function(eventStatus, pid, cellDescription, objects, players)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local ObjectIndex
		local ObjectRefid
		local pname = getName(pid)
		for _, object in pairs(objects) do
			ObjectIndex = object.uniqueIndex
			ObjectRefid = object.refId
		end	
		if ObjectIndex ~= nil and ObjectRefid ~= nil then
			if tableHelper.containsValue(listIdNpc, string.lower(ObjectRefid), true) then
				ProtectSaleNpcTab.player[pid] = true
			else
				ProtectSaleNpcTab.player[pid] = false
			end
		end
	end
end

ProtectSale.OnPlayerInventory = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if ProtectSaleNpcTab.player[pid] == true then
			local action = tes3mp.GetInventoryChangesAction(pid)
			local itemChangesCount = tes3mp.GetInventoryChangesSize(pid)

			if action == enumerations.inventory.REMOVE then

				for index = 0, itemChangesCount - 1 do
					local itemRefId = tes3mp.GetInventoryItemRefId(pid, index)

					if itemRefId ~= "" then

						local item = {
							refId = itemRefId,
							count = tes3mp.GetInventoryItemCount(pid, index),
							charge = tes3mp.GetInventoryItemCharge(pid, index),
							enchantmentCharge = tes3mp.GetInventoryItemEnchantmentCharge(pid, index),
							soul = tes3mp.GetInventoryItemSoul(pid, index)
						}
						if tableHelper.containsValue(config.tabItem, item.refId, true) then				
							if item.soul ~= nil and item.soul ~= "" then
								ProtectSaleTab.player[pid] = true
							end
						end
					end
				end	
			elseif action == enumerations.inventory.ADD then
				if ProtectSaleTab.player[pid] ~= nil and ProtectSaleTab.player[pid] == true then
					for index = 0, itemChangesCount - 1 do
						local itemRefId = tes3mp.GetInventoryItemRefId(pid, index)
						if itemRefId ~= "" then
							local item = {
								refId = itemRefId,
								count = tes3mp.GetInventoryItemCount(pid, index),
								charge = tes3mp.GetInventoryItemCharge(pid, index),
								enchantmentCharge = tes3mp.GetInventoryItemEnchantmentCharge(pid, index),
								soul = tes3mp.GetInventoryItemSoul(pid, index)
							}
							if item.refId == "gold_001" then					
								local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)	
								if goldLoc ~= nil then
									local goldamount = Players[pid].data.inventory[goldLoc].count
									Players[pid].data.inventory[goldLoc].count = (Players[pid].data.inventory[goldLoc].count - item.count) - 1	
									local itemref = {refId = "gold_001", count = item.count, charge = -1, soul = ""}			
									Players[pid]:SaveToDrive()
									Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)
									ProtectSaleTab.player[pid] = nil
									tes3mp.MessageBox(pid, -1, "Cette objet est interdit à la vente, l'or de la vente a était retiré de votre inventaire.")								
								end
							end
						end
					end
				end
			end
		end
	end
end

customEventHooks.registerHandler("OnObjectActivate", ProtectSale.OnObjectActivate)
customEventHooks.registerHandler("OnPlayerInventory", ProtectSale.OnPlayerInventory)

return ProtectSale
