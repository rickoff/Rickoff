--[[
DebugCharge.lua
tes3mp 0.7.0
---------------------------
DESCRIPTION :

---------------------------
INSTALLATION:
Save the file as DebugCharge.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
DebugCharge = require("custom.DebugCharge")
---------------------------
]]

local TimerStartDebugCharge = tes3mp.CreateTimer("StartDebugCharge", time.seconds(3))

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
	for index = 0, tes3mp.GetEquipmentSize() - 1 do
        	local itemRefId = tes3mp.GetEquipmentItemRefId(pid, index)
		if itemRefId ~= "" then
			local enchantmentCharge = tes3mp.GetEquipmentItemEnchantmentCharge(pid, index)
			
			if enchantmentCharge ~= nil then
				local index = getIndexByValueRefId(Players[pid].data.inventory, itemRefId)
				
				if index then
					if Players[pid].data.inventory[index].enchantmentCharge ~= enchantmentCharge then
						Players[pid].data.inventory[index].enchantmentCharge = enchantmentCharge
						--tes3mp.LogAppend(enumerations.log.ERROR, itemRefId.." "..enchantmentCharge)	
						Change = true
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
			OnSaveEchantementCharge(pid)
		end
	end
	tes3mp.RestartTimer(TimerStartDebugCharge, time.seconds(3))
end

DebugCharge.OnServerInit = function(eventStatus)
	tes3mp.StartTimer(TimerStartDebugCharge)
	tes3mp.LogAppend(enumerations.log.INFO, "....START TIMER DEBUG CHARGE....")		
end

customEventHooks.registerHandler("OnServerInit", DebugCharge.OnServerInit)

return DebugCharge
