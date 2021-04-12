--[[
DebugCharge.lua
tes3mp 0.7.0
---------------------------
DESCRIPTION :
version 0.7 does not dynamically save enchantment charges in the inventory file. This script tries to solve this
---------------------------
CONFIGURATION :
change config.timeCheck for config the time of check all enchantmentCharge
change config.rechargeCharge for config the gain of enchantmentCharge
change config.showlog to true or false for show process in your log
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
config.showlog = true

local TimerStartDebugCharge = tes3mp.CreateTimer("StartDebugCharge", time.seconds(config.timeCheck))

local DebugCharge = {}

function OnSaveEchantementChargeInventory(pid)
	local Change = false
	local TableChange = {}
	for index, currentItem in pairs(Players[pid].data.inventory) do
		if currentItem ~= "" and currentItem ~= nil then
			index = index - 1
			if currentItem.refId and currentItem.enchantmentCharge and currentItem.maxCharge then
				if not tableHelper.containsValue(Players[pid].data.equipment, currentItem.refId, true) then			
					if currentItem.enchantmentCharge ~= -1 and currentItem.enchantmentCharge < currentItem.maxCharge then
						currentItem.enchantmentCharge = math.floor(currentItem.enchantmentCharge + config.rechargeCharge)	
						table.insert(TableChange, currentItem)	
						Change = true
						if config.showlog then
							tes3mp.LogAppend(enumerations.log.ERROR, "DEBUG CHARGE : "..currentItem.refId
							.." RECHARGE CHARGE ENCHANT "..currentItem.enchantmentCharge)
						end						
					elseif currentItem.enchantmentCharge ~= -1 and currentItem.enchantmentCharge > currentItem.maxCharge then
						currentItem.enchantmentCharge = -1	
						table.insert(TableChange, currentItem)
						Change = true
						if config.showlog then
							tes3mp.LogAppend(enumerations.log.ERROR, "DEBUG CHARGE : "..currentItem.refId
							.." RESET CHARGE ENCHANT "..currentItem.enchantmentCharge)
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

function OnSaveEchantementChargeEquipment(pid)
	local Change = false
    	for index = 0, tes3mp.GetEquipmentSize() - 1 do
        	local itemRefId = tes3mp.GetEquipmentItemRefId(pid, index)
		if itemRefId ~= "" and itemRefId ~= nil then
			local enchantmentCharge = math.floor(tes3mp.GetEquipmentItemEnchantmentCharge(pid, index))
			if enchantmentCharge ~= nil then
				local index = tableHelper.getIndexByNestedKeyValue(Players[pid].data.inventory, "refId", itemRefId)		
				if index then
					if Players[pid].data.inventory[index].enchantmentCharge ~= enchantmentCharge then
						Players[pid].data.inventory[index].enchantmentCharge = enchantmentCharge
						local effectiveCost = math.floor(50 - (Players[pid].data.skills.Enchant.base / 2.24))
						if effectiveCost <= 0 then effectiveCost = 1 end
						if Players[pid].data.inventory[index].maxCharge == nil and enchantmentCharge ~= -1 then
							Players[pid].data.inventory[index].maxCharge = enchantmentCharge + effectiveCost
						elseif Players[pid].data.inventory[index].maxCharge ~= nil and Players[pid].data.inventory[index].maxCharge < enchantmentCharge then						
							Players[pid].data.inventory[index].maxCharge = enchantmentCharge
						end
						Change = true						
						if config.showlog then						
							tes3mp.LogAppend(enumerations.log.ERROR, "DEBUG CHARGE : "..itemRefId
							.." COPY CHARGE ENCHANT "..enchantmentCharge)
						end
					end
				end
			end
		end
	end
	if Change then
		Players[pid]:QuicksaveToDrive()
	end
end

function StartDebugCharge()
	for pid, value in pairs(Players) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and Players[pid]:HasAccount() then
			OnSaveEchantementChargeInventory(pid)
		end
	end
	tes3mp.RestartTimer(TimerStartDebugCharge, time.seconds(config.timeCheck))
end

DebugCharge.OnServerInit = function(eventStatus)
	tes3mp.StartTimer(TimerStartDebugCharge)
	if config.showlog then		
		tes3mp.LogAppend(enumerations.log.ERROR, "DEBUG CHARGE CONFIGURATION TIMER : "..config.timeCheck)
		tes3mp.LogAppend(enumerations.log.ERROR, "DEBUG CHARGE CONFIGURATION RECHARGE : "..config.rechargeCharge)		
	end
end

DebugCharge.OnPlayerEquipment = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and Players[pid]:HasAccount() then
		OnSaveEchantementChargeEquipment(pid)
	end
end

customEventHooks.registerHandler("OnServerInit", DebugCharge.OnServerInit)
customEventHooks.registerHandler("OnPlayerEquipment", DebugCharge.OnPlayerEquipment)

return DebugCharge
