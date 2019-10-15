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

local weaponsData = {}
local armorData = {}
local weaponsCustomData = {}
local armorCustomData = {}

local TimerDrawState = tes3mp.CreateTimer("StartCheckDraw", time.seconds(1))

local weaponsLoader = jsonInterface.load("WeaponsEcarlate.json")
for index, item in pairs(weaponsLoader) do
	table.insert(weaponsData, {NAME = item.NAME, REFID = item.ID, TYPE = item.TYPE})
end

local armorLoader = jsonInterface.load("ArmorEcarlate.json")
for index, item in pairs(armorLoader) do
	table.insert(armorData, {NAME = item.NAME, REFID = item.ID, WEIGTH = item.WEIGTH})
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

local GameplayAdvance = {}

GameplayAdvance.StartCheck = function()
	tes3mp.StartTimer(TimerDrawState)
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

GameplayAdvance.Speed = function(pid)

	local drawState = tes3mp.GetDrawState(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
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
						local RefId = y.REFID	
						for s, v in pairs(weaponsCustomData) do
							local CustomId = v.REFID
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
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
		local Malus = 0		
		for x, y in pairs(Players[pid].data.equipment) do
			local equipement = (Players[pid].data.equipment[x])
			table.insert(itemEquipment, equipement)
			local refequip = (equipement.refId)
			if tableHelper.containsValue(armorCustomData, refequip, true) then
				for x, y in pairs(armorData) do
					local RefId = y.REFID	
					for s, v in pairs(armorCustomData) do
						local CustomId = v.REFID
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
			Players[pid]:LoadSkills()			
		end		
	end
end

return GameplayAdvance	
