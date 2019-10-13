--GameplayAdvance.lua

tableHelper = require("tableHelper")
jsonInterface = require("jsonInterface")

local weaponsData = {}
local armorData = {}

local TimerDrawState = tes3mp.CreateTimer("StartCheckDraw", time.seconds(1))

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
	tes3mp.RestartTimer(TimerDrawState, time.seconds(1))
end

GameplayAdvance.Speed = function(pid)

	local drawState = tes3mp.GetDrawState(pid)
	local levelP = tes3mp.GetLevel(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and levelP > 1 then
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
							Malus = 1.1
						elseif Type == "MarksmanThrown" then	
							Malus = 1.2
						elseif Type == "BluntOneHand" then	
							Malus = 1.3
						elseif Type == "BluntTwoWide" then	
							Malus = 1.4
						elseif Type == "AxeOneHand" then		
							Malus = 1.5						
						elseif Type == "SpearTwoWide" then 	
							Malus = 1.6	
						elseif Type == "LongBladeOneHand" then	
							Malus = 1.7						
						elseif Type == "LongBladeTwoClose" then
							Malus = 1.8					
						elseif Type == "AxeTwoClose" then		
							Malus = 1.9						
						elseif Type == "BluntTwoClose" then
							Malus = 2.0						
						elseif Type == "MarksmanBow" then
							Malus = 2.5
						elseif Type == "MarksmanCrossbow" then
							Malus = 3.0
						end
					end
				end

				local PlayerSpeedCurrently = Players[pid].data.attributes.Speed.base
				Players[pid].data.attributes.Speed.damage = math.floor(PlayerSpeedCurrently / Malus)	
				Players[pid]:LoadAttributes()		
			end	
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
		for x, y in pairs(Players[pid].data.equipment) do
			local equipement = (Players[pid].data.equipment[x])
			table.insert(itemEquipment, equipement)
		end
		if itemEquipment ~= nil then
			local Weigth = 0	
			for x, y in pairs(armorData) do
				if tableHelper.containsValue(itemEquipment, y.REFID, true) then		
					Weigth = (Weigth + y.WEIGTH)
				end
			end

			Players[pid].data.skills.Athletics.damage = Weigth / 3
			Players[pid]:LoadSkills()
		end
	end
end
