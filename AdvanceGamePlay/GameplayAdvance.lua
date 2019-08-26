--GameplayAdvance.lua
--Find in serverCore.lua "function OnServerInit()" and add

--       GameplayAdvance.StartCheck()

tableHelper = require("tableHelper")
jsonInterface = require("jsonInterface")

local weaponsData = {}
local armorData = {}

local TimerDrawState = tes3mp.CreateTimer("StartCheckDraw", time.seconds(0.5))

local weaponsLoader = jsonInterface.load("WeaponsEcarlate.json")
for index, item in pairs(weaponsLoader) do
	table.insert(weaponsData, {NAME = item.NAME, REFID = item.ID, TYPE = item.TYPE})
end

local armorLoader = jsonInterface.load("ArmorEcarlate.json")
for index, item in pairs(armorLoader) do
	table.insert(armorData, {NAME = item.NAME, REFID = item.ID, WEIGTH = item.WEIGTH})
end

local GameplayAdvance = {}

GameplayAdvance.StartCheck = function()
	tes3mp.StartTimer(TimerDrawState)
	tes3mp.LogAppend(enumerations.log.INFO, "....START TIMER DRAW STATE....")		
end

function StartCheckDraw()
	if tableHelper.getCount(Players) > 0 then
		for pid , value in pairs(Players) do
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then		
				GameplayAdvance.Speed(pid)
				GameplayAdvance.Athletics(pid)
			end
		end
	end
	tes3mp.RestartTimer(TimerDrawState, time.seconds(0.5))
end

GameplayAdvance.Speed = function(pid)

	local drawState = tes3mp.GetDrawState(pid)

	if drawState == 1 then
		local itemEquipment = {}
		for x, y in pairs(Players[pid].data.equipment) do
			local equipement = (Players[pid].data.equipment[x])
			table.insert(itemEquipment, equipement)
		end
		if itemEquipment ~= nil then
			local Malus = 2	
			for x, y in pairs(weaponsData) do
				if tableHelper.containsValue(itemEquipment, y.REFID, true) then		
					local Type = y.TYPE
					tes3mp.LogAppend(enumerations.log.INFO, Type)		
					if Type == "ShortBladeOneHand" then
						Malus = 3
					elseif Type == "MarksmanThrown" then	
						Malus = 3
					elseif Type == "AxeOneHand" then		
						Malus = 6
					elseif Type == "LongBladeOneHand" then	
						Malus = 5
					elseif Type == "BluntOneHand" then	
						Malus = 4
					elseif Type == "AxeTwoClose" then		
						Malus = 8
					elseif Type == "SpearTwoWide" then 	
						Malus = 5	
					elseif Type == "LongBladeTwoClose" then
						Malus = 6
					elseif Type == "BluntTwoWide" then	
						Malus = 4
					elseif Type == "BluntTwoClose" then
						Malus = 10						
					elseif Type == "MarksmanBow" then
						Malus = 4
					elseif Type == "MarksmanCrossbow" then
						Malus = 10
					end
				end
			end
			local PlayerSpeedBase = Players[pid].data.customVariables.PlayerSpeedBase
			local PlayerSpeedCurrently = Players[pid].data.attributes.Speed
			if PlayerSpeedBase == nil then
				PlayerSpeedBase = PlayerSpeedCurrently
				Players[pid].data.customVariables.PlayerSpeedBase = PlayerSpeedBase	
			else
				Players[pid].data.attributes.Speed = PlayerSpeedBase / Malus	
				Players[pid]:LoadAttributes()
			end				
		end	
	else
		local PlayerSpeedBase = Players[pid].data.customVariables.PlayerSpeedBase
		local PlayerSpeedCurrently = Players[pid].data.attributes.Speed
		if PlayerSpeedBase == nil then
			PlayerSpeedBase = PlayerSpeedCurrently
			Players[pid].data.customVariables.PlayerSpeedBase = PlayerSpeedBase	
		else
			Players[pid].data.attributes.Speed = PlayerSpeedBase
			Players[pid]:LoadAttributes()
		end
	end
end

GameplayAdvance.Athletics = function(pid)

	local itemEquipment = {}
	for x, y in pairs(Players[pid].data.equipment) do
		local equipement = (Players[pid].data.equipment[x])
		table.insert(itemEquipment, equipement)
	end
	if itemEquipment ~= nil then
		local Weigth = 0	
		for x, y in pairs(armorData) do
			if tableHelper.containsValue(itemEquipment, y.REFID, true) then		
				Weigth = Weigth + y.WEIGTH
			end
		end
		
		local PlayerAthleticsBase = Players[pid].data.customVariables.PlayerAthleticsBase
		local PlayerAthleticsCurrently = Players[pid].data.skills.Athletics.base
		if PlayerAthleticsBase == nil then
			PlayerAthleticsBase = PlayerAthleticsCurrently
			Players[pid].data.customVariables.PlayerAthleticsBase = PlayerAthleticsBase	
		else
			local skillId = tes3mp.GetSkillId("Athletics")
			local valueC = PlayerAthleticsBase - Weigth
			tes3mp.SetSkillBase(pid, skillId, valueC)
			Players[pid]:SaveStatsDynamic()		
			Players[pid]:SaveSkills()
			tes3mp.SendSkills(pid)	
			tes3mp.SendStatsDynamic(pid)
		end	
	end	
end

return GameplayAdvance	
