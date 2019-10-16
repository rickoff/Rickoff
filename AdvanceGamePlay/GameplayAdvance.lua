--GameplayAdvance.lua
--Find in serverCore.lua "function OnServerInit()" and add

--       GameplayAdvance.StartCheck()

--Find in servercore.lua "function OnPlayerEquipment(pid)" and add
--       GameplayAdvance.Athletics(pid)
-- like this:
--function OnPlayerEquipment(pid)
--	tes3mp.LogMessage(enumerations.log.INFO, "Called \"OnPlayerEquipment\" for " .. logicHandler.GetChatName(pid))
--	eventHandler.OnPlayerEquipment(pid)
--	GameplayAdvance.Athletics(pid)	
--end

--GameplayAdvance.lua

tableHelper = require("tableHelper")
jsonInterface = require("jsonInterface")

local config = {}
config.limitedstart = 30

local weaponsData = {}
local armorData = {}
local potionData= {}
local weaponsCustomData = {}
local armorCustomData = {}
local potionCustomData = {}

local TimerDrawState = tes3mp.CreateTimer("StartCheckDraw", time.seconds(1))
local TimerPotionState = tes3mp.CreateTimer("StartCheckPotion", time.seconds(config.limitedstart))

local weaponsLoader = jsonInterface.load("WeaponsEcarlate.json")
for index, item in pairs(weaponsLoader) do
	table.insert(weaponsData, {NAME = item.NAME, REFID = item.ID, TYPE = item.TYPE})
end

local armorLoader = jsonInterface.load("ArmorEcarlate.json")
for index, item in pairs(armorLoader) do
	table.insert(armorData, {NAME = item.NAME, REFID = item.ID, WEIGTH = item.WEIGTH})
end

local potionLoader = jsonInterface.load("EcarlatePotions.json")
for index, item in pairs(potionLoader) do
	table.insert(potionData, {NAME = item.Name, REFID = item.RefId})
end

local weaponsCustom = jsonInterface.load("recordstore/weapon.json")
for index, item in pairs(weaponsCustom.generatedRecords) do
	local Slot = weaponsCustom.generatedRecords[index]
	table.insert(weaponsCustomData, {NAME = Slot.name, REFID = Slot.baseId, CUSTOMID = index})
end

local armorCustom = jsonInterface.load("recordstore/armor.json")
for index, item in pairs(armorCustom.generatedRecords) do
	local Slot = armorCustom.generatedRecords[index]
	table.insert(armorCustomData, {NAME = Slot.name, REFID = Slot.baseId, CUSTOMID = index})
end

local potionCustom = jsonInterface.load("recordstore/potion.json")
for index, item in pairs(potionCustom.generatedRecords) do
	local Slot = potionCustom.generatedRecords[index]
	table.insert(potionCustomData, {NAME = Slot.name, CUSTOMID = index})
end

local GameplayAdvance = {}

GameplayAdvance.StartCheck = function()
	tes3mp.StartTimer(TimerDrawState)
	tes3mp.StartTimer(TimerPotionState)	
	tes3mp.LogAppend(enumerations.log.INFO, "....START TIMER DRAW STATE....")		
end

function StartCheckDraw()
	for pid , value in pairs(Players) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then		
			GameplayAdvance.Speed(pid)
		end
	end
	tes3mp.RestartTimer(TimerDrawState, time.seconds(1))
end

function StartCheckPotion()
	for pid , value in pairs(Players) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then		
			GameplayAdvance.LimitedTimer(pid)
		end
	end
	tes3mp.RestartTimer(TimerPotionState, time.seconds(config.limitedstart))
end

GameplayAdvance.Speed = function(pid)
	local drawState = tes3mp.GetDrawState(pid)
	local levelP = tes3mp.GetLevel(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and levelP > 1 then
		if drawState == 1 then
			local Malus = 20
			local Type
			local itemEquipment = {}
			for x, y in pairs(Players[pid].data.equipment) do
				local equipement = (Players[pid].data.equipment[x])
				table.insert(itemEquipment, equipement)
				local refequip = (equipement.refId)
				
				if tableHelper.containsValue(weaponsCustomData, refequip, true) then
					for x, y in pairs(weaponsData) do
						local RefId = string.lower(y.REFID)	
						for s, v in pairs(weaponsCustomData) do
							local CustomId = string.lower(v.REFID)
							if RefId == CustomId then						
								Type = y.TYPE
							end
						end
					end
				end
			end			
			if itemEquipment ~= nil then
				for x, y in pairs(weaponsData) do
					local RefId = y.REFID				
					if tableHelper.containsValue(itemEquipment, RefId, true) then		
						Type = y.TYPE		
					end
				end
			end			
			if Type ~= nil then
				if Type == "ShortBladeOneHand" then
					Malus = 30
				elseif Type == "MarksmanThrown" then	
					Malus = 30
				elseif Type == "BluntOneHand" then	
					Malus = 40
				elseif Type == "BluntTwoWide" then	
					Malus = 40
				elseif Type == "AxeOneHand" then		
					Malus = 40						
				elseif Type == "SpearTwoWide" then 	
					Malus = 40	
				elseif Type == "LongBladeOneHand" then	
					Malus = 40						
				elseif Type == "LongBladeTwoClose" then
					Malus = 50					
				elseif Type == "AxeTwoClose" then		
					Malus = 50						
				elseif Type == "BluntTwoClose" then
					Malus = 50						
				elseif Type == "MarksmanBow" then
					Malus = 30
				elseif Type == "MarksmanCrossbow" then
					Malus = 50
				end
			end			
			local PlayerSpeedCurrently = Players[pid].data.attributes.Speed.base
			Players[pid].data.attributes.Speed.damage = math.floor((PlayerSpeedCurrently * Malus) / 100)	
			Players[pid]:LoadAttributes()			
		else
			Players[pid].data.attributes.Speed.damage = 0
			Players[pid]:LoadAttributes()	
		end
	end
end

GameplayAdvance.Athletics = function(pid)
	local itemEquipment = {}
	local levelP = tes3mp.GetLevel(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and levelP > 1 then	
		local Malus = 0		
		for x, y in pairs(Players[pid].data.equipment) do
			local equipement = (Players[pid].data.equipment[x])
			table.insert(itemEquipment, equipement)
			local refequip = (equipement.refId)
			if tableHelper.containsValue(armorCustomData, refequip, true) then
				for x, y in pairs(armorData) do
					local RefId = string.lower(y.REFID)	
					for s, v in pairs(armorCustomData) do
						local CustomId = string.lower(v.REFID)
						if RefId == CustomId then						
							Malus = y.WEIGTH
						end
					end
				end
			end				
		end		
		if itemEquipment ~= nil then
			local Weigth = 0	
			for x, y in pairs(armorData) do
				if tableHelper.containsValue(itemEquipment, y.REFID, true) then		
					Weigth = (Weigth + y.WEIGTH)
				end			
			end		
			Players[pid].data.skills.Athletics.damage = math.floor((Weigth + Malus) / 3)
			Players[pid].data.skills.Acrobatics.damage = math.floor((Weigth + Malus) / 3)			
			Players[pid]:LoadSkills()			
		end		
	end
end

GameplayAdvance.LimitPotion = function(pid, Refid)

	local limitedPotion = Players[pid].data.customVariables.limitedPotion	
	
	if limitedPotion == nil then
		Players[pid].data.customVariables.limitedPotion = 0
	end
	
	if tableHelper.containsValue(potionCustomData, Refid, true) then	
		if limitedPotion == 0 then				
			tes3mp.MessageBox(pid, -1, color.Yellow.. "Vous avez pris une potion")	
			Players[pid].data.customVariables.limitedPotion	= 1
			return false
		elseif limitedPotion == 1 then
			tes3mp.MessageBox(pid, -1, color.Red.. "ATTENTION !!!\n" ..color.Yellow.. " Vous avez déjà pris une potion.")
			return true
		end
	end	
	
	if tableHelper.containsValue(potionData, Refid, true) then	
		if limitedPotion == 0 then
			tes3mp.MessageBox(pid, -1, color.Yellow.. "Vous avez pris une potion")
			Players[pid].data.customVariables.limitedPotion	= 1
			return false
		elseif limitedPotion == 1 then
			tes3mp.MessageBox(pid, -1, color.Red.. "ATTENTION !!!\n" ..color.Yellow.. " Vous avez déjà pris une potion.")
			return true
		end
	end	
end

GameplayAdvance.LimitedTimer = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local limitedPotion = Players[pid].data.customVariables.limitedPotion				
		if limitedPotion == nil then
			Players[pid].data.customVariables.limitedPotion = 0	
		elseif limitedPotion > 0 then
			Players[pid].data.customVariables.limitedPotion	= 0
		end
	end
end

return GameplayAdvance	
