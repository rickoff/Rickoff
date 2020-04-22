--[[
GameplayAdvance by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Modifies several functions and improves the overall gameplay.
Touch automatically over a quarter of your tiredness.
Can not jump below quarter of your fatigue.
Relive the players by activating them.
Taking out a weapon or preparing a spell will slow you down according to the type of weapon.
the wearing of armor adds a penalty of acrobatics and athleticism.
Potions are no longer spammable and impossible to equip in shorthands
Prevent some custom effect on your custom potions
The maximum level is parametrable
---------------------------
INSTALLATION:
Save the file as GameplayAdvance.lua inside your server/scripts/custom folder
Save the file as MenuAdvance.lua inside your server/scripts/menu folder
Save the data file as .json inside your server/data folder
Edits to customScripts.lua
GameplayAdvance = require("custom.GameplayAdvance")
Edits to config.lua
add in config.menuHelperFiles, "MenuAdvance"
---------------------------
FUNCTION:
/menujoueur in your chat for open menu
---------------------------
]]


tableHelper = require("tableHelper")
jsonInterface = require("jsonInterface")

local configL = {}
configL.limitedstart = 10

local weaponsData = {}
local armorData = {}
local potionData = {}
local weaponsCustomData = {}
local armorCustomData = {}
local potionCustomData = {}
local GameplayAdvanceTab = { player = {} }
local GameplayAdvanceTabAtt = { player = {} }
local TimerDrawState = tes3mp.CreateTimer("StartCheckDraw", time.seconds(1))
local TimerPotionState = tes3mp.CreateTimer("StartCheckPotion", time.seconds(configL.limitedstart))
local TimerSkillsState = tes3mp.CreateTimer("TemporalyLoadSkills", time.seconds(1))
local playTimeGuiID = 01245780


local weaponsLoader = jsonInterface.load("custom/WeaponsEcarlate.json")
for index, item in pairs(weaponsLoader) do
	table.insert(weaponsData, {NAME = string.lower(item.NAME), REFID = string.lower(item.ID), TYPE = item.TYPE})
end

local armorLoader = jsonInterface.load("custom/ArmorEcarlate.json")
for index, item in pairs(armorLoader) do
	table.insert(armorData, {NAME = string.lower(item.NAME), REFID = string.lower(item.ID), WEIGTH = item.WEIGTH})
end

local potionLoader = jsonInterface.load("custom/EcarlatePotions.json")
for index, item in pairs(potionLoader) do
	table.insert(potionData, {NAME = string.lower(item.Name), REFID = string.lower(item.RefId)})
end

local weaponsCustom = jsonInterface.load("recordstore/weapon.json")
for index, item in pairs(weaponsCustom.generatedRecords) do
	local Slot = weaponsCustom.generatedRecords[index]
	table.insert(weaponsCustomData, {NAME = string.lower(Slot.name), REFID = string.lower(Slot.baseId), CUSTOMID = index})
end

local armorCustom = jsonInterface.load("recordstore/armor.json")
for index, item in pairs(armorCustom.generatedRecords) do
	local Slot = armorCustom.generatedRecords[index]
	table.insert(armorCustomData, {NAME = string.lower(Slot.name), REFID = string.lower(Slot.baseId), CUSTOMID = index})
end

local potionCustom = jsonInterface.load("recordstore/potion.json")
for index, item in pairs(potionCustom.generatedRecords) do
	local Slot = potionCustom.generatedRecords[index]
	table.insert(potionCustomData, {NAME = string.lower(Slot.name), CUSTOMID = index})
end

local GameplayAdvance = {}

GameplayAdvance.StartCheck = function(eventStatus)
	tes3mp.StartTimer(TimerDrawState)
	tes3mp.StartTimer(TimerPotionState)
	tes3mp.LogAppend(enumerations.log.INFO, "....START TIMER GAMEPLAYADVANCE....")		
end

function StartCheckDraw()
	for pid , value in pairs(Players) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			if not tes3mp.IsWerewolf(pid) then		
				GameplayAdvance.Speed(pid)
				GameplayAdvance.UpdatePlayTime()
			else
				GameplayAdvance.UpdatePlayTime()
			end
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
	tes3mp.RestartTimer(TimerPotionState, time.seconds(configL.limitedstart))
end

function TemporalyLoadSkills()
	for pid, value in pairs(GameplayAdvanceTab.player) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			if value == nil then value = 0 end
			if value ~= nil and value ~= Players[pid].data.skills.Athletics.damage then	
				local skillId = tes3mp.GetSkillId("Athletics")
				local skillId2 = tes3mp.GetSkillId("Acrobatics")			
				tes3mp.SetSkillDamage(pid, skillId, value)
				tes3mp.SetSkillDamage(pid, skillId2, value)	
				tes3mp.SendSkills(pid)
				GameplayAdvanceTab.player[pid] = nil
			end
		end
	end
end

GameplayAdvance.Speed = function(pid)
	local drawState = tes3mp.GetDrawState(pid)
	local attributeId = tes3mp.GetAttributeId("Speed")	
	local value
	local basevalue = GameplayAdvanceTabAtt.player[pid]
	if basevalue == nil then basevalue = 0 end
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and Players[pid].data.attributes.Speed.base then
		local PlayerSpeedCurrently = Players[pid].data.attributes.Speed.base
		if drawState == 1 then
			local Malus = 20
			local Type
			local itemEquipment = {}
			for x, y in pairs(Players[pid].data.equipment) do
				local equipement = (Players[pid].data.equipment[x])
				table.insert(itemEquipment, equipement)
				local refequip = string.lower(equipement.refId)
				
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
			value = math.floor((PlayerSpeedCurrently * Malus) / 100)
		elseif drawState == 2 then
			value = math.floor((PlayerSpeedCurrently * 20) / 100)
		else
			value = 0
		end	
	end
	if value ~= nil and basevalue ~= nil and value ~= basevalue then
		tes3mp.SetAttributeDamage(pid, attributeId, value)	
		tes3mp.SendAttributes(pid)
		tes3mp.SendEquipment(pid)
		GameplayAdvanceTabAtt.player[pid] = value
	end	
end
	
GameplayAdvance.Athletics = function(eventStatus, pid)
	local itemEquipment = {}
	local skillId = tes3mp.GetSkillId("Athletics")
	local skillId2 = tes3mp.GetSkillId("Acrobatics")
	local value	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and Players[pid].data.skills.Athletics.damage then	
		local Malus = 0		
		for x, y in pairs(Players[pid].data.equipment) do
			local equipement = (Players[pid].data.equipment[x])
			table.insert(itemEquipment, equipement)
			local refequip = string.lower(equipement.refId)
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
			value = math.floor((Weigth + Malus) / 10)						
		end	
		if tes3mp.IsWerewolf(pid) then
			value = 0
		end
		if value ~= nil then
			GameplayAdvanceTab.player[pid] = value
			tes3mp.StartTimer(TimerSkillsState)
		end			
	end
end

GameplayAdvance.LimitPotion = function(eventStatus, pid, Refid)
	local limitedPotion = Players[pid].data.customVariables.limitedPotion		
	if limitedPotion == nil then
		Players[pid].data.customVariables.limitedPotion = 0
		limitedPotion = Players[pid].data.customVariables.limitedPotion	
	end	
	if tableHelper.containsValue(potionCustomData, string.lower(Refid), true) then	
		if limitedPotion == 0 then				
			tes3mp.MessageBox(pid, -1, color.Yellow.. "Vous avez pris une potion")	
			Players[pid].data.customVariables.limitedPotion	= 1
		elseif limitedPotion == 1 then
			tes3mp.MessageBox(pid, -1, color.Red.. "ATTENTION !!!\n" ..color.Yellow.. " Vous avez déjà pris une potion.")
			return customEventHooks.makeEventStatus(false,false) 
		end
	end		
	if tableHelper.containsValue(potionData, string.lower(Refid), true) then	
		if limitedPotion == 0 then
			tes3mp.MessageBox(pid, -1, color.Yellow.. "Vous avez pris une potion")
			Players[pid].data.customVariables.limitedPotion	= 1
		elseif limitedPotion == 1 then
			tes3mp.MessageBox(pid, -1, color.Red.. "ATTENTION !!!\n" ..color.Yellow.. " Vous avez déjà pris une potion.")
			return customEventHooks.makeEventStatus(false,false)
		end
	end	
end

GameplayAdvance.NoKeyPotion = function(eventStatus, pid)
    local shouldReloadKeys = false
    for index = 0, tes3mp.GetQuickKeyChangesSize(pid) - 1 do
        local slot = tes3mp.GetQuickKeySlot(pid, index)
        local itemKeys = tes3mp.GetQuickKeyItemId(pid, index)
        if itemKeys ~= "" then
            if tableHelper.containsValue(potionCustomData, string.lower(itemKeys), true) or
            tableHelper.containsValue(potionData, string.lower(itemKeys), true) then
                shouldReloadKeys = true

                Players[pid].data.quickKeys[slot] = {
                    keyType = 0,
                    itemId = "placeholder"
                }
            end
        end
    end
    if shouldReloadKeys then
        logicHandler.RunConsoleCommandOnPlayer(pid, "player->additem placeholder 1")
        tes3mp.MessageBox(pid, -1, color.Red.. "ATTENTION !!!\n" ..color.Yellow.. " Les potions sont interdite dans les raccourcis!")
        Players[pid]:LoadQuickKeys() 
        logicHandler.RunConsoleCommandOnPlayer(pid, "player->removeitem placeholder 1")
		return customEventHooks.makeEventStatus(false,false)
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

GameplayAdvance.Trottiner = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local drawState = tes3mp.GetDrawState(pid)	
		if drawState >= 1 then
			local message = color.Red.."!!! Attention !!!\n"..color.White.."Veuillez enlever la position de combat pour changer de mode de course."
			tes3mp.MessageBox(pid, -1, message)		
		else	
			local attributeId = tes3mp.GetAttributeId("Speed")	
			local PlayerSpeedBase = Players[pid].data.customVariables.PlayerSpeedBase
			local PlayerSpeedCurrently = Players[pid].data.attributes.Speed.base 
			if PlayerSpeedBase == nil then
				PlayerSpeedBase = PlayerSpeedCurrently
				Players[pid].data.customVariables.PlayerSpeedBase = PlayerSpeedBase	
			else
				local value = PlayerSpeedBase / 10
				tes3mp.SetAttributeBase(pid, attributeId, value)			
				tes3mp.SendAttributes(pid)
			end
		end
	end
end

GameplayAdvance.Courir = function(pid)	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local drawState = tes3mp.GetDrawState(pid)
		if drawState >= 1 then
			local message = color.Red.."!!! Attention !!!\n"..color.White.."Veuillez enlever la position de combat pour changer de mode de course."
			tes3mp.MessageBox(pid, -1, message)		
		else
			local attributeId = tes3mp.GetAttributeId("Speed")		
			local PlayerSpeedBase = Players[pid].data.customVariables.PlayerSpeedBase
			local PlayerSpeedCurrently = Players[pid].data.attributes.Speed.base 
			if PlayerSpeedBase == nil then
				PlayerSpeedBase = PlayerSpeedCurrently
				Players[pid].data.customVariables.PlayerSpeedBase = PlayerSpeedBase	
			else
				local value = PlayerSpeedBase / 2
				tes3mp.SetAttributeBase(pid, attributeId, value)			
				tes3mp.SendAttributes(pid)
			end
		end
	end
end

GameplayAdvance.Sprinter = function(pid)				
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local drawState = tes3mp.GetDrawState(pid)	
		if drawState >= 1 then
			local message = color.Red.."!!! Attention !!!\n"..color.White.."Veuillez enlever la position de combat pour changer de mode de course."
			tes3mp.MessageBox(pid, -1, message)		
		else	
			local attributeId = tes3mp.GetAttributeId("Speed")		
			local PlayerSpeedBase = Players[pid].data.customVariables.PlayerSpeedBase
			local PlayerSpeedCurrently = Players[pid].data.attributes.Speed.base 
			if PlayerSpeedBase == nil then
				PlayerSpeedBase = PlayerSpeedCurrently
				Players[pid].data.customVariables.PlayerSpeedBase = PlayerSpeedBase	
			else
				local value = PlayerSpeedBase
				tes3mp.SetAttributeBase(pid, attributeId, value)			
				tes3mp.SendAttributes(pid)
			end
		end
	end
end

GameplayAdvance.LevelMax = function(eventStatus, pid)	
	local maxLevel = 50
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then		
		local player = Players[pid]
		if player.data.stats.level >= maxLevel then
			player.data.stats.level = maxLevel
			player.data.stats.levelProgress = 0
			player:LoadLevel()
			return customEventHooks.makeEventStatus(false,false) 
		end
	end
end

GameplayAdvance.ResurrectProcess = function(pid)	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
		local currentResurrectType
		if config.respawnAtImperialShrine == true then
			if config.respawnAtTribunalTemple == true then
				if math.random() > 0.5 then
					currentResurrectType = enumerations.resurrect.IMPERIAL_SHRINE
				else
					currentResurrectType = enumerations.resurrect.TRIBUNAL_TEMPLE
				end
			else
				currentResurrectType = enumerations.resurrect.IMPERIAL_SHRINE
			end
		elseif config.respawnAtTribunalTemple == true then
			currentResurrectType = enumerations.resurrect.TRIBUNAL_TEMPLE
		elseif config.defaultRespawnCell ~= nil then
			currentResurrectType = enumerations.resurrect.REGULAR
			tes3mp.SetCell(pid, config.defaultRespawnCell)
			tes3mp.SendCell(pid)
			if config.defaultRespawnPos ~= nil and config.defaultRespawnRot ~= nil then
				tes3mp.SetPos(pid, config.defaultRespawnPos[1],
					config.defaultRespawnPos[2], config.defaultRespawnPos[3])
				tes3mp.SetRot(pid, config.defaultRespawnRot[1], config.defaultRespawnRot[2])
				tes3mp.SendPos(pid)
			end
		end
		local message = "Vous avez été réanimé"
		if currentResurrectType == enumerations.resurrect.IMPERIAL_SHRINE then
			message = message .. " au sanctuaire le plus proche"
		elseif currentResurrectType == enumerations.resurrect.TRIBUNAL_TEMPLE then
			message = message .. " au temple le plus proche"
		end
		message = message .. ".\n"
		if Players[pid].data.shapeshift.isWerewolf == true then
			Players[pid]:SetWerewolfState(false)
		end
		contentFixer.UnequipDeadlyItems(pid)
		tes3mp.Resurrect(pid, currentResurrectType)
		local levelPlayer = math.floor((tes3mp.GetLevel(pid) * 5) / 100) 
		if config.deathPenaltyJailDays > 0 then
			local resurrectionText = "Vous avez été réanimé et ramené ici, " ..
				"mais vos compétences ont été affectées par "
			local jailTime = config.deathPenaltyJailDays * levelPlayer

			if config.bountyResetOnDeath == true then
				if config.bountyDeathPenalty == true then
					local currentBounty = tes3mp.GetBounty(pid)

					if currentBounty > 0 then
						jailTime = ((jailTime + math.floor(currentBounty / 100)) * levelPlayer )
						resurrectionText = resurrectionText .. "votre prime et "
					end
				end
				tes3mp.SetBounty(pid, 0)
				tes3mp.SendBounty(pid)
				Players[pid]:SaveBounty()
			end
			resurrectionText = resurrectionText .. "votre temps passé inactif.\n"
			tes3mp.Jail(pid, jailTime, true, true, "Récupération", resurrectionText)
		end
		tes3mp.SendMessage(pid, message, false)
	end
end

GameplayAdvance.ResurrectCheck = function(eventStatus, pid)
	GameplayAdvance.ResurrectProcess(pid)
	return customEventHooks.makeEventStatus(false,false)	
end	

GameplayAdvance.OnCheckStatePlayer = function(eventStatus, pid, cellDescription, objects, players)
	if eventStatus.validCustomHandlers then
		local PlayerPid
		for _, object in pairs(players) do
			PlayerPid = object.pid
		end	
		if PlayerPid ~= nil then
			Players[pid].data.targetPid = PlayerPid	
			Players[PlayerPid].data.targetPid = pid			
			local PlayerActivatedHealth = tes3mp.GetHealthCurrent(PlayerPid)
			if PlayerActivatedHealth <= 0 then
				Players[pid].currentCustomMenu = "resurrect player"--Menu Resurrect
				menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
			elseif tes3mp.GetSneakState(pid) == true and PlayerActivatedHealth > 0 then
				local valueSneak = Players[pid].data.skills.Sneak.base
				local valueSneakCible = Players[PlayerPid].data.skills.Sneak.base
				local randoSneak = math.random(0, 50)
				local calcul = (valueSneak - (valueSneakCible + randoSneak))
				if calcul > 0 then
					local playerCible = Players[PlayerPid]
					local goldLocCible = inventoryHelper.getItemIndex(playerCible.data.inventory, "gold_001", -1)
					if goldLocCible then
						local itemCible = playerCible.data.inventory[goldLocCible]
						local refId = itemCible.refId
						local totalcount = itemCible.count
						local removeGold = math.floor((totalcount * 10) / 100)
						local reste = totalcount - removeGold
						local itemref = {refId = "gold_001", count = (removeGold), charge = -1, soul = ""}		
						playerCible.data.inventory[goldLocCible].count = reste
						Players[PlayerPid]:SaveToDrive()
						Players[PlayerPid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)
						local player = Players[pid]
						local goldLoc = inventoryHelper.getItemIndex(player.data.inventory, "gold_001", -1)
						if goldLoc then
							local item = player.data.inventory[goldLoc]
							local refId = item.refId
							local totalcount = item.count
							local reste = totalcount + removeGold	
							player.data.inventory[goldLoc].count = reste
						else
							table.insert(player.data.inventory, itemref)
						end	
						Players[pid]:SaveToDrive()
						Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)						
						tes3mp.MessageBox(pid, -1, color.White.."Vous avez volé : "..color.Red..removeGold..color.White.." pièces d'or.")						
					else
						tes3mp.MessageBox(pid, -1, color.White.."La cible ne possède pas d'or.")
					end
				else
					Players[pid].data.fame.bounty = Players[pid].data.fame.bounty + 1000
					tes3mp.SetBounty(pid, Players[pid].data.fame.bounty)
					tes3mp.SendBounty(pid)				
					tes3mp.MessageBox(pid, -1, color.White.."Vous avez était pris en flagrant délit, votre prime a augmenté de 1000.")
					tes3mp.MessageBox(PlayerPid, -1, color.White.."Vous venez de subir une tentative de vole.")
					Players[pid]:SaveToDrive()
				end
			else
				if TeamGroup then
					Players[pid].currentCustomMenu = "invite player"--Invite Menu
					menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
				end
			end	
		end
	end
end

function GameplayAdvance.StartMenu(pid)
    if Players[pid]~= nil and Players[pid]:IsLoggedIn() then
		Players[pid].currentCustomMenu = "menu joueur"
		menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
	end
end

GameplayAdvance.UpdatePlayTime = function()
    for pid, player in pairs(Players) do
        if Players[pid] ~= nil and player:IsLoggedIn() then
            local playTime = Players[pid].data.customVariables.playTime
            if playTime ~= nil then
                playTime = playTime + 1
            else
                playTime = 0
            end
			Players[pid].data.customVariables.playTime = playTime	
        end
    end
end

GameplayAdvance.ShowPlayTime = function(pid)
    local timeString = GameplayAdvance.GetTimeString(pid, false)
    local message = "Vous avez joué " .. timeString
    tes3mp.MessageBox(pid, -1, message)
end


GameplayAdvance.GetConnectedPlayersPlayTime = function()
    local lastPid = tes3mp.GetLastPlayerId()
    local list = ""
    local divider = ""
    for i = 0, lastPid do
        if i == lastPid then
            divider = ""
        else
            divider = "\n"
        end
        if Players[i] ~= nil and Players[i]:IsLoggedIn() then
            local timeString = GameplayAdvance.GetTimeString(i, true)
            list = list .. tostring(Players[i].name)
            list = list .. " (ID: " .. tostring(Players[i].pid) .. ") "
            list = list .. "Temps de jeu " ..  timeString
            list = list .. divider
        end
    end
    return list
end

GameplayAdvance.ShowPlayTimeAllConnected = function(pid)
    local label = "Temps de jeu des joueurs connectés"
    tes3mp.ListBox(pid, playTimeGuiID, label, GameplayAdvance.GetConnectedPlayersPlayTime())
end

GameplayAdvance.GetTimeString = function(pid, returnList)
    local playTime = Players[pid].data.customVariables.playTime
    local timeString = ""
    local mod
    local timeArray = {0, 0, 0}
    local timeSection = {86400, 3600, 60}
    local timeName
    local div1
    local div2
    local plural
    local dot
    if returnList == false then
        timeName = {" jour", " heure", " minute", " seconde"}
        div1 = ", "
        div2 = " and "
        plural = "s"
        dot = "."
    else
        timeName = {"j", "h", "m", "s"}
        div1 = " "
        div2 = " "
        plural = ""
        dot = ""
    end
    for i = 1, 3 do
        mod = playTime % timeSection[i]
        timeArray[i] = (playTime - mod) / timeSection[i]
        if timeArray[i] > 0 then
            if i > 1 then
                if timeArray[i-1] > 0 then
                    if mod ~= 0 then
                        timeString = timeString .. div1 .. timeArray[i]
                    else
                        timeString = timeString .. div2 .. timeArray[i]
                    end
                else
                    timeString = timeString .. timeArray[i]
                end
            else
                timeString = timeArray[i]
            end
            if timeArray[i] > 1 then
                timeString = timeString .. timeName[i] .. plural
            else
                timeString = timeString .. timeName[i]
            end
        end
        playTime = mod
    end
    if mod ~= 0 then
        if timeString ~= "" then
            if mod > 1 then
                timeString = timeString .. div2 .. mod .. timeName[4] .. plural .. dot
            else
                timeString = timeString .. div2 .. mod .. timeName[4] .. dot
            end
        else
            if mod > 1 then
                timeString = mod .. timeName[4] .. plural .. dot
            else
                timeString = mod .. timeName[4] .. dot
            end
        end
    end
    return timeString
end

GameplayAdvance.OnRecordDynamic = function(eventStatus, pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
        tes3mp.ReadReceivedWorldstate()
        local disallowedEffectIds = { 17, 22, 74, 85, 106, 110, 108, 134, 103, 104, 105, 114, 115, 113, 109, 112, 102, 107, 116, 111, 135, 138, 139, 140, 141, 142, 137 }
        local recordNumericalType = tes3mp.GetRecordType(pid)
        local isValid = true
        local rejectedRecords = {}
        local recordCount = tes3mp.GetRecordCount(pid)
        for recordIndex = 0, recordCount - 1 do
            local recordName = tes3mp.GetRecordName(recordIndex)
            if recordNumericalType ~= enumerations.recordType.ENCHANTMENT and not logicHandler.IsNameAllowed(recordName) then
                table.insert(rejectedRecords, recordName)
                Players[pid]:Message("Vous n'êtes pas autorisé à créer!" .. recordName .. "\n")
				isValid = false
				return customEventHooks.makeEventStatus(false,false) 				
            elseif recordNumericalType == enumerations.recordType.ENCHANTMENT then
                local effects = packetReader.GetRecordEffects(recordIndex)
                for _, disallowedEffectId in ipairs(disallowedEffectIds) do
                    if tableHelper.containsKeyValue(effects, "id", disallowedEffectId) then
                        Players[pid]:Message("Vous n'êtes pas autorisé à créer un enchantment avec cette effet!")
						isValid = false
						return customEventHooks.makeEventStatus(false,false) 						
                    end
                end
				if isValid then
					for _, effect in pairs(effects) do
						if effect.id == 75 and effect.magnitudeMax > 1 then
							Players[pid]:Message("Vous n'êtes pas autorisé à créer cette effet (+1 max)!")
							return customEventHooks.makeEventStatus(false,false) 
						elseif effect.id == 76 and effect.magnitudeMax > 1 then
							Players[pid]:Message("Vous n'êtes pas autorisé à créer cette effet (+1 max)!")
							return customEventHooks.makeEventStatus(false,false) 							
						elseif effect.id == 77 and effect.magnitudeMax > 1 then
							Players[pid]:Message("Vous n'êtes pas autorisé à créer cette effet (+1 max)!")	
							return customEventHooks.makeEventStatus(false,false) 							
						end
					end
				end											
            elseif recordNumericalType == enumerations.recordType.SPELL then
                local effects = packetReader.GetRecordEffects(recordIndex)
                for _, disallowedEffectId in ipairs(disallowedEffectIds) do
                    if tableHelper.containsKeyValue(effects, "id", disallowedEffectId) then
                        Players[pid]:Message("Vous n'êtes pas autorisé à créer un sort avec cette effet!")
						isValid = false
						return customEventHooks.makeEventStatus(false,false) 						
                    end
                end	
				if isValid then
					for _, effect in pairs(effects) do
						if effect.id == 76 then
							Players[pid]:Message("Vous n'êtes pas autorisé à créer un sort avec cette effet!")
							return customEventHooks.makeEventStatus(false,false) 							
						end
					end
				end	
            end
        end
	end
end	

GameplayAdvance.OnPlayerDiff = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local difficultyMin = 0
		local currentLevel = Players[pid].data.stats.level
		local difficultyTest
		local difficulty		
		if currentLevel <= 10 then
			difficultyTest = difficultyMin + (currentLevel * 5)
		elseif currentLevel > 10 and currentLevel <= 25 then
			difficultyTest = difficultyMin + (currentLevel * 6)
		elseif currentLevel > 25 and currentLevel <= 50 then
			difficultyTest = difficultyMin + (currentLevel * 7)
		end	
		if difficultyTest >= 0 then 
			difficulty = difficultyTest
			Players[pid].data.settings.difficulty = difficultyTest
		else
			difficulty = difficultyMin
			Players[pid].data.settings.difficulty = difficulty        
		end
		tes3mp.SetDifficulty(Players[pid].pid, difficulty)
		tes3mp.LogMessage(enumerations.log.INFO, "Set difficulty to " .. tostring(difficulty) .. " for " ..logicHandler.GetChatName(Players[pid].pid))
	end
end

GameplayAdvance.ReloadCustom = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local weaponsCustom = jsonInterface.load("recordstore/weapon.json")
		for index, item in pairs(weaponsCustom.generatedRecords) do
			local Slot = weaponsCustom.generatedRecords[index]
			table.insert(weaponsCustomData, {NAME = string.lower(Slot.name), REFID = string.lower(Slot.baseId), CUSTOMID = index})
		end
		local armorCustom = jsonInterface.load("recordstore/armor.json")
		for index, item in pairs(armorCustom.generatedRecords) do
			local Slot = armorCustom.generatedRecords[index]
			table.insert(armorCustomData, {NAME = string.lower(Slot.name), REFID = string.lower(Slot.baseId), CUSTOMID = index})
		end
		local potionCustom = jsonInterface.load("recordstore/potion.json")
		for index, item in pairs(potionCustom.generatedRecords) do
			local Slot = potionCustom.generatedRecords[index]
			table.insert(potionCustomData, {NAME = string.lower(Slot.name), CUSTOMID = index})
		end
	end
end

GameplayAdvance.CheckDraw = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local drawState = tes3mp.GetDrawState(pid)	
		if drawState == 1 then
			return customEventHooks.makeEventStatus(false,false)
		end
	end
end

customEventHooks.registerValidator("OnPlayerEquipment", GameplayAdvance.CheckDraw)
customEventHooks.registerValidator("OnRecordDynamic", GameplayAdvance.OnRecordDynamic)
customEventHooks.registerValidator("OnPlayerLevel", GameplayAdvance.LevelMax)
customEventHooks.registerValidator("OnPlayerQuickKeys", GameplayAdvance.NoKeyPotion)
customEventHooks.registerValidator("OnPlayerItemUse", GameplayAdvance.LimitPotion)
customEventHooks.registerValidator("OnPlayerResurrect", GameplayAdvance.ResurrectCheck)
customEventHooks.registerHandler("OnRecordDynamic", GameplayAdvance.ReloadCustom)
customEventHooks.registerHandler("OnPlayerAuthentified", GameplayAdvance.OnPlayerDiff)
customEventHooks.registerHandler("OnPlayerLevel", GameplayAdvance.OnPlayerDiff)
customEventHooks.registerHandler("OnObjectActivate", GameplayAdvance.OnCheckStatePlayer)
customEventHooks.registerHandler("OnServerInit", GameplayAdvance.StartCheck)
customEventHooks.registerHandler("OnPlayerEquipment", GameplayAdvance.Athletics)
customCommandHooks.registerCommand("trottiner", GameplayAdvance.Trottiner)	
customCommandHooks.registerCommand("courir", GameplayAdvance.Courir)
customCommandHooks.registerCommand("sprinter", GameplayAdvance.Sprinter)
customCommandHooks.registerCommand("joueur", GameplayAdvance.StartMenu)
customCommandHooks.registerCommand("playtimeall", GameplayAdvance.ShowPlayTimeAllConnected)
customCommandHooks.registerCommand("playtime", GameplayAdvance.ShowPlayTime)

return GameplayAdvance	
