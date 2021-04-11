--[[
DebugCharge.lua
tes3mp 0.7.0
---------------------------
DESCRIPTION :
version 0.7 does not dynamically save enchantment charges in the invent file. This script tries to solve this
---------------------------
CONFIGURATION :
change config.timeCheck for config the time of check all enchantmentCharge
change config.rechargeCharge for config the gain of enchantmentCharge
---------------------------
INSTALLATION:
Save the file as DebugCharge.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
DebugCharge = require("custom.DebugCharge")
---------------------------
]]
local config = {}
config.timeCheck = 10
config.rechargeCharge = 1

local TimerStartDebugCharge = tes3mp.CreateTimer("StartDebugCharge", time.seconds(config.timeCheck))

local DebugCharge = {}

function getIndexByValueRefId(inputTable, valueToFind)
    for key, value in pairs(inputTable) do
        if value.refId == valueToFind then
            return key
        end
    end
    return nil
end

function OnSaveEchantementCharge(pid)
	local Change = false
	local TableChange = {}
	for index = 0, tes3mp.GetEquipmentSize() - 1 do
        	local itemRefId = tes3mp.GetEquipmentItemRefId(pid, index)
		if itemRefId ~= "" then
			local enchantmentCharge = tes3mp.GetEquipmentItemEnchantmentCharge(pid, index)
			
			if enchantmentCharge ~= nil then
				local index = getIndexByValueRefId(Players[pid].data.inventory, itemRefId)
				
				if index then
					if Players[pid].data.inventory[index].enchantmentCharge ~= enchantmentCharge then
						Players[pid].data.inventory[index].enchantmentCharge = enchantmentCharge
						if Players[pid].data.inventory[index].maxCharge == nil and enchantmentCharge ~= -1 then
							Players[pid].data.inventory[index].maxCharge = math.floor(enchantmentCharge + 1)
						elseif Players[pid].data.inventory[index].maxCharge ~= nil and Players[pid].data.inventory[index].maxCharge < enchantmentCharge then
							Players[pid].data.inventory[index].maxCharge = math.floor(enchantmentCharge)
						end
						--tes3mp.LogAppend(enumerations.log.ERROR, itemRefId.." COPY CHARGE ENCHANT "..enchantmentCharge)	
						Change = true
					end
				end
			end
		end
	end
	for index, currentItem in pairs(Players[pid].data.inventory) do
		if currentItem ~= "" and currentItem ~= nil then
			index = index - 1
			if currentItem.refId then
				if not tableHelper.containsValue(Players[pid].data.equipment, currentItem.refId, true) then	
					if currentItem.maxCharge then			
						if currentItem.enchantmentCharge ~= -1 and currentItem.enchantmentCharge < currentItem.maxCharge then
							currentItem.enchantmentCharge = math.floor(currentItem.enchantmentCharge + config.rechargeCharge)	
							local itemRef = {
								refId = currentItem.refId,
								count = currentItem.count,
								charge = currentItem.charge,
								enchantmentCharge = currentItem.enchantmentCharge,
								soul = tes3mp.GetInventoryItemSoul(pid, index)							
							}
							table.insert(TableChange, itemRef)						
							--tes3mp.LogAppend(enumerations.log.ERROR, currentItem.refId.." RECHARGE CHARGE ENCHANT "..currentItem.enchantmentCharge)
							Change = true
							
						elseif currentItem.enchantmentCharge ~= -1 and currentItem.enchantmentCharge > currentItem.maxCharge then
							currentItem.enchantmentCharge = -1	
							local itemRef = {
								refId = currentItem.refId,
								count = currentItem.count,
								charge = currentItem.charge,
								enchantmentCharge = currentItem.enchantmentCharge,
								soul = tes3mp.GetInventoryItemSoul(pid, index)							
							}
							table.insert(TableChange, itemRef)						
							--tes3mp.LogAppend(enumerations.log.ERROR, currentItem.refId.." RESET CHARGE ENCHANT "..currentItem.enchantmentCharge)
							Change = true
						end
					end
				end
			end
		end
	end
	if Change then
		Players[pid]:QuicksaveToDrive()
		for x, itemref in pairs(TableChange) do
			Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)
			Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)
		end
	end
end

function StartDebugCharge()
	for pid, value in pairs(Players) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and Players[pid]:HasAccount() then
			OnSaveEchantementCharge(pid)
		end
	end
	tes3mp.RestartTimer(TimerStartDebugCharge, time.seconds(config.timeCheck))
end

DebugCharge.OnServerInit = function(eventStatus)
	tes3mp.StartTimer(TimerStartDebugCharge)
	tes3mp.LogAppend(enumerations.log.INFO, "....START TIMER DEBUG CHARGE....")		
end

customEventHooks.registerHandler("OnServerInit", DebugCharge.OnServerInit)

return DebugCharge
