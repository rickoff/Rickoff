--[[
EcarlateWar by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Script principal War for Ecarlate
---------------------------
INSTALLATION:
Save the file as EcarlateWar.lua inside your server/scripts/custom folder.

Save the file as MenuFaction.lua inside your scripts/menu folder

Edits to customScripts.lua
EcarlateWar = require("custom.EcarlateWar")

Edits to config.lua
add in config.menuHelperFiles, "MenuFaction"
---------------------------
FUNCTION:
/menufaction in your chat for open menu
---------------------------
]]

 
local time = require("time")
require("enumerations")

local Methods = {}

math.randomseed(os.time())

mapRotationNum = 0
matchId = ""
teamOneScore = 0
teamTwoScore = 0
teamThreeScore = 0
teamFourScore = 0	
--------------------------
-- CONFIG/SETTINGS SECTION
--------------------------
-- Number of kills required for either team to win
scoreToWin = 10
-- Determines whether players are allowed to manually switch teams
canSwitchTeams = true
-- Default spawn time in seconds
spawnTime = 1
teamOne = "L'ordre du temple"
teamTwo = "L'empire de septim"
teamThree = "Les renégats"
teamFour = "Les pélerins"
rangZero = "Membre"
rangOne = "Hortator"
rangTwo = "Gouverneur"
rangThree = "Chef"
rangFour = "Maire"
------------------
-- METHODS SECTION
------------------
Methods.MatchInit = function() -- Starts new match, resets matchId, controls map rotation, and clears teams
	local tempAcrobatics = playerAcrobatics
	matchId = os.date("%y%m%d%H%M%S") -- Later used in TeamHandler to determine whether to reset character
	teamOneScore = 0
	teamTwoScore = 0
	teamThreeScore = 0
	teamFourScore = 0
	
    for pid, p in pairs(Players) do -- Iterate through all players and start assigning teams
		
		if p ~= nil and p:IsLoggedIn() then

			if p.data.ecWar == nil then
				tes3mp.LogMessage(2, "++++ Methods.MatchInit: Pre JSON Check ++++")
				JSONCheck(p.pid)
			end
			
			-- If player is alive, then begin reassign+respawn procedure
			if p.data.ecWar.status == 1 then
				TeamHandler(p.pid)
			end
        end
    end
end

Methods.ListTeams = function(pid)
	local teamOneCount = 0
	local teamTwoCount = 0
	local teamThreeCount = 0
	local teamFourCount = 0
	local teamOneList = teamOne .. " (" .. teamOneCount .. ") | Score: " .. teamOneScore .. "\n----------"
	local teamTwoList = teamTwo .. " (" .. teamTwoCount .. ") | Score: " .. teamTwoScore .. "\n----------"
	local teamThreeList = teamThree .. " (" .. teamThreeCount .. ") | Score: " .. teamThreeScore .. "\n----------"
	local teamFourList = teamFour .. " (" .. teamFour .. ") | Score: " .. teamFourScore .. "\n----------"
	tes3mp.LogMessage(2, "++++ Methods.ListTeams: Building list of teams + players. ++++")
    for pid, p in pairs(Players) do 
        
		if p:IsLoggedIn() and p.data.ecWar ~= nil then
			
			if p.data.ecWar.team == 0 then
				-- Player is unassigned
			elseif p.data.ecWar.team == 1 then
				tes3mp.LogMessage(2, "++++ Methods.ListTeams: Adding player " .. p.data.login.name .. " to " .. teamOne .. ". ++++")
				teamOneCount = teamOneCount + 1
				teamOneList = teamOneList .. "\n" .. p.data.login.name .. " | K: " .. p.data.ecWar.kills .. " | D: " .. p.data.ecWar.deaths
			elseif p.data.ecWar.team == 2 then
				tes3mp.LogMessage(2, "++++ Methods.ListTeams: Adding player " .. p.data.login.name .. " to " .. teamTwo .. ". ++++")
				teamTwoCount = teamTwoCount + 1
				teamTwoList = teamTwoList .. "\n" .. p.data.login.name .. " | K: " .. p.data.ecWar.kills .. " | D: " .. p.data.ecWar.deaths
			elseif p.data.ecWar.team == 3 then
				tes3mp.LogMessage(2, "++++ Methods.ListTeams: Adding player " .. p.data.login.name .. " to " .. teamThree .. ". ++++")
				teamThreeCount = teamThreeCount + 1
				teamThreeList = teamThreeList .. "\n" .. p.data.login.name .. " | K: " .. p.data.ecWar.kills .. " | D: " .. p.data.ecWar.deaths
			elseif p.data.ecWar.team == 4 then
				tes3mp.LogMessage(2, "++++ Methods.ListTeams: Adding player " .. p.data.login.name .. " to " .. teamFour .. ". ++++")
				teamFourCount = teamFourCount + 1
				teamFourList = teamFourList .. "\n" .. p.data.login.name .. " | K: " .. p.data.ecWar.kills .. " | D: " .. p.data.ecWar.deaths				
			end
        end
	end
	
	tes3mp.MessageBox(pid, -1, teamOneList .. "\n\n" .. teamTwoList .. "\n\n" .. teamThreeList .. "\n\n" .. teamFourList)
end

Methods.OnPlayerDeath = function(eventStatus, pid) -- Called whenever player dies. Updates kill and death count

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		ProcessDeath(pid)
		return customEventHooks.makeEventStatus(false,true)
	end
end

Methods.OnScoreCheck = function(pid, killerTeam) -- Called whenever player dies. Updates kill and death count

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		ScoreCheck(pid, killerTeam)
	end
end

Methods.OnDeathTime = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then 
		return customEventHooks.makeEventStatus(false,true)
	end
end

Methods.OnDeathTimeExpiration = function(eventStatus, pid)
	if eventStatus.validCustomHandlers then
		local state = false
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			for slot, k in pairs(Players[pid].data.spellbook) do
				if Players[pid].data.spellbook[slot] == "vampire sun damage" then
					state = true
				end
			end	
			if state == false then
				Players[pid].currentCustomMenu = "resurrect"--Menu Resurrect
				menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
				Players[pid].data.ecWar.spawnSeconds = spawnTime
				Players[pid].data.ecWar.status = 1 -- Player is now alive and safe for teleporting
				TeamHandler(pid)
			else 
				Players[pid].currentCustomMenu = "resurrectvamp"--Menu Resurrect Vampire
				menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
				Players[pid].data.ecWar.spawnSeconds = spawnTime
				Players[pid].data.ecWar.status = 1 -- Player is now alive and safe for teleporting
				TeamHandler(pid)
			end
		end
	end
end

Methods.OnGUIAction = function(eventStatus, pid, idGui, data)
    if Players[pid] ~= nil then
        data = tostring(data) -- data can be numeric, but we should convert it to a string      
		if Players[pid]:IsLoggedIn() then		
			if idGui == config.customMenuIds.confiscate and Players[pid].confiscationTargetName ~= nil then
				local targetName = Players[pid].confiscationTargetName
				local targetPlayer = logicHandler.GetPlayerByName(targetName)

				-- Because the window's item index starts from 0 while the Lua table for
				-- inventories starts from 1, adjust the former here
				local inventoryItemIndex = data + 1
				local item = targetPlayer.data.inventory[inventoryItemIndex]

				if item ~= nil then

					inventoryHelper.addItem(Players[pid].data.inventory, item.refId, item.count, item.charge,
						item.enchantmentCharge, item.soul)
					Players[pid]:LoadItemChanges({item}, enumerations.inventory.ADD)

					-- If the item is equipped by the target, unequip it first
					if inventoryHelper.containsItem(targetPlayer.data.equipment, item.refId, item.charge) then
						local equipmentItemIndex = inventoryHelper.getItemIndex(targetPlayer.data.equipment,
							item.refId, item.charge)
						targetPlayer.data.equipment[equipmentItemIndex] = nil
					end

					targetPlayer.data.inventory[inventoryItemIndex] = nil
					tableHelper.cleanNils(targetPlayer.data.inventory)

					Players[pid]:Message("You've confiscated " .. item.refId .. " from " ..
						targetName .. "\n")

					if targetPlayer:IsLoggedIn() then
						targetPlayer:LoadItemChanges({item}, enumerations.inventory.REMOVE)
					end
				else
					Players[pid]:Message("Invalid item index\n")
				end

				targetPlayer:SetConfiscationState(false)
				targetPlayer:QuicksaveToDrive()

				Players[pid].confiscationTargetName = nil

			elseif idGui == config.customMenuIds.menuHelper and Players[pid].currentCustomMenu ~= nil then

				local buttonIndex = tonumber(data) + 1
				local buttonPressed = Players[pid].displayedMenuButtons[buttonIndex]

				local destination = menuHelper.GetButtonDestination(pid, buttonPressed)

				menuHelper.ProcessEffects(pid, destination.effects)
				menuHelper.DisplayMenu(pid, destination.targetMenu)

				Players[pid].previousCustomMenu = Players[pid].currentCustomMenu
				Players[pid].currentCustomMenu = destination.targetMenu
			end
		else
			if idGui == guiHelper.ID.LOGIN then
				if data == nil then
					Players[pid]:Message("Mot de passe incorrect!\n")
					guiHelper.ShowLogin(pid)
				end

				Players[pid]:LoadFromDrive()

				-- Just in case the password from the data file is a number, make sure to turn it into a string
				if tostring(Players[pid].data.login.password) ~= data then
					Players[pid]:Message("Mot de passe incorrect!\n")
					guiHelper.ShowLogin(pid)
				end

				-- Is this player on the banlist? If so, store their new IP and ban them
				if tableHelper.containsValue(banList.playerNames, string.lower(Players[pid].accountName)) == true then
					Players[pid]:QuicksaveToDriveIpAddress()
					Players[pid]:Message(Players[pid].accountName .. " est banni de ce serveur.\n")
					tes3mp.BanAddress(tes3mp.GetIP(pid))
				else
					
					if Players[pid].data.ecWar == nil then
						JSONCheck(pid)
					elseif Players[pid].data.ecWar == 1 then
						Players[pid].data.ecWar.team = 1
						Players[pid].data.ecWar.status = 1	
					elseif Players[pid].data.ecWar == 2 then
						Players[pid].data.ecWar.team = 2
						Players[pid].data.ecWar.status = 1	
					elseif Players[pid].data.ecWar == 3 then
						Players[pid].data.ecWar.team = 3
						Players[pid].data.ecWar.status = 1	
					elseif Players[pid].data.ecWar == 4 then
						Players[pid].data.ecWar.team = 4
						Players[pid].data.ecWar.status = 1					
					end
					Players[pid]:FinishLogin()
					Players[pid]:Message("" .. color.White .. "Vous vous êtes connecté avec succès.\nUtilisez" ..color.Yellow.." Y" ..color.White.." pour utiliser la messagerie.\nEntrez " .. color.Red .. "/menu " .. color.White .. "pour plus d'informations.\n")			
					TeamHandler(pid)
					tes3mp.CustomMessageBox(pid, -1, ""..color.Red.."Bienvenue sur Ecarlate!"..color.Default.."\n\nle serveur pour la communauté rôleplay française!"..color.Green.."\n\nReboot :"..color.White.."\nToutes les 6h"..color.Yellow.."\n6h/12h ; 18h/00h\n"..color.Default.."\n\nVeuillez lire les règles pour le confort de tous sur notre discord :\n"..color.Cyan.."\nhttps://discord.gg/KgqkCGD\n"..color.Red.."\nAvertissement :\n"..color.White.."\nToutes formes de triches est strictement interdite.\n"..color.Green.."\nBon jeu à tous. \n\n ", "Ok")
					if Players[pid].data.customVariables.Jailer == nil then
						Players[pid].data.customVariables.Jailer = false
					elseif Players[pid].data.customVariables.Jailer == true then	
						WorldMining.PunishPrison(pid, pid)
					end						
				end	
				
			elseif idGui == guiHelper.ID.REGISTER then
				if data == nil then
					Players[pid]:Message("Le mot de passe ne peut pas être vide\n")
					guiHelper.ShowRegister(pid)
				end
				Players[pid]:Register(data)
				Players[pid]:Message("" .. color.White .. "Vous vous êtes connecté avec succès.\nUtilisez" ..color.Yellow.." Y" ..color.White.." pour utiliser la messagerie.\nEntrez " .. color.Red .. "/menu " .. color.White .. "pour plus d'informations.\n")
				tes3mp.CustomMessageBox(pid, -1, ""..color.Red.."Bienvenue sur Ecarlate!"..color.Default.."\n\nle serveur pour la communauté rôleplay française!"..color.Green.."\n\nReboot :"..color.White.."\nToutes les 6h"..color.Yellow.."\n6h/12h ; 18h/00h\n"..color.Default.."\n\nVeuillez lire les règles pour le confort de tous sur notre discord :\n"..color.Cyan.."\nhttps://discord.gg/KgqkCGD\n"..color.Red.."\nAvertissement :\n"..color.White.."\nToutes formes de triches est strictement interdite.\n"..color.Green.."\nBon jeu à tous. \n\n ", "Ok")              
			end
		end
		return customEventHooks.makeEventStatus(false,false) 
	end
end

Methods.OnPlayerEndCharGen = function(eventStatus, pid)
    if Players[pid] ~= nil then
        EndCharGen(pid)	
    end
end

Methods.SwitchTeamsTemple = function(pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local targetName = Players[pid].name
		if Players[pid].data.ecWar.team == 1 then
			local message = targetName .. " est déjà un membre du temple.\n"
			tes3mp.SendMessage(pid, message, false)
		else	
			local player = Players[pid]
			local goldL = inventoryHelper.getItemIndex(player.data.inventory, "gold_001", -1)
			if goldL then
				local item = player.data.inventory[goldL]
				local refId = item.refId
				local count = item.count
				local reste = (item.count - 10000)
				if count >= 10000 then
					local itemref = {refId = "gold_001", count = 10000, charge = -1}			
					player.data.inventory[goldL].count = player.data.inventory[goldL].count - 10000
					Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)
					local message = "Vous venez de dépenser 10000 pièces pour changer de faction\n"
					tes3mp.SendMessage(pid, message, false)
					local message1 = targetName .. " vous avez rejoint le temple!\n"
					tes3mp.SendMessage(pid, message1, true)
					if canSwitchTeams == true then

						if Players[pid].data.ecWar.team == 2 then
							Players[pid].data.ecWar.team = 1
							tes3mp.SendMessage(pid, color.DarkCyan .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamOne .. ".\n", true)
						elseif Players[pid].data.ecWar.team == 3 then
							Players[pid].data.ecWar.team = 1
							tes3mp.SendMessage(pid, color.DarkCyan .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamOne .. ".\n", true)
						elseif Players[pid].data.ecWar.team == 4 then
							Players[pid].data.ecWar.team = 1
							tes3mp.SendMessage(pid, color.DarkCyan .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamOne .. ".\n", true)			
						end				
					elseif canSwitchTeams == false then
						tes3mp.SendMessage(pid, color.Yellow .. "Changer d'équipe est désactivé.\n", false)
					end			
					Players[pid]:QuicksaveToDrive()
				else
					local message = "Vous n'avez pas 10000 pièces pour changer de faction\n"
					tes3mp.SendMessage(pid, message, false)
				end	
			else
				local message = "Pour changer de faction il vous faut 10000 pièces\n"
				tes3mp.SendMessage(pid, message, false)								
			end
		end	
	end
end

Methods.SwitchTeamsEmpire = function(pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local targetName = Players[pid].name
		if Players[pid].data.ecWar.team == 2 then
			local message = targetName .. " est déjà un membre de l'empire.\n"
			tes3mp.SendMessage(pid, message, false)
		else	
			local player = Players[pid]
			local goldL = inventoryHelper.getItemIndex(player.data.inventory, "gold_001", -1)
			if goldL then
				local item = player.data.inventory[goldL]
				local refId = item.refId
				local count = item.count
				local reste = (item.count - 10000)
				if count >= 10000 then
					local itemref = {refId = "gold_001", count = 10000, charge = -1}			
					player.data.inventory[goldL].count = player.data.inventory[goldL].count - 10000
					Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)			
					local message = "Vous venez de dépenser 10000 pièces pour changer de faction\n"
					tes3mp.SendMessage(pid, message, false)			
					local message1 = targetName .. " vous avez rejoint l'empire!\n"
					tes3mp.SendMessage(pid, message1, true)
					if canSwitchTeams == true then
						if Players[pid].data.ecWar.team == 1 then
							Players[pid].data.ecWar.team = 2
							tes3mp.SendMessage(pid, color.DarkRed .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamTwo .. ".\n", true)
						elseif Players[pid].data.ecWar.team == 3 then
							Players[pid].data.ecWar.team = 2
							tes3mp.SendMessage(pid, color.DarkRed .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamTwo .. ".\n", true)
						elseif Players[pid].data.ecWar.team == 4 then
							Players[pid].data.ecWar.team = 2
							tes3mp.SendMessage(pid, color.DarkRed .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamTwo .. ".\n", true)			
						end				
					elseif canSwitchTeams == false then
						tes3mp.SendMessage(pid, color.Yellow .. "Changer d'équipe est désactivé.\n", false)
					end		
					Players[pid]:QuicksaveToDrive()				
				else
					local message = "Vous n'avez pas 10000 pièces pour changer de faction\n"
					tes3mp.SendMessage(pid, message, false)
				end	
			else
				local message = "Pour changer de faction il vous faut 10000 pièces\n"
				tes3mp.SendMessage(pid, message, false)								
			end
		end	
	end
end

Methods.SwitchTeamsRenegats = function(pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local targetName = Players[pid].name
		if Players[pid].data.ecWar.team == 3 then
			local message = targetName .. " est déjà un membre des renégats.\n"
			tes3mp.SendMessage(pid, message, false)
		else	
			local player = Players[pid]
			local goldL = inventoryHelper.getItemIndex(player.data.inventory, "gold_001", -1)
			if goldL then
				local item = player.data.inventory[goldL]
				local refId = item.refId
				local count = item.count
				local reste = (item.count - 10000)
				if count >= 10000 then
					local itemref = {refId = "gold_001", count = 10000, charge = -1}			
					player.data.inventory[goldL].count = player.data.inventory[goldL].count - 10000
					Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)			
					local message = "Vous venez de dépenser 10000 pièces pour changer de faction\n"
					tes3mp.SendMessage(pid, message, false)
					local message1 = targetName .. " vous avez rejoint les renégats!\n"
					tes3mp.SendMessage(pid, message1, true)
					if canSwitchTeams == true then
						if Players[pid].data.ecWar.team == 1 then
							Players[pid].data.ecWar.team = 3
							tes3mp.SendMessage(pid, color.DarkOrange .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamThree .. ".\n", true)
						elseif Players[pid].data.ecWar.team == 2 then
							Players[pid].data.ecWar.team = 3
							tes3mp.SendMessage(pid, color.DarkOrange .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamThree .. ".\n", true)
						elseif Players[pid].data.ecWar.team == 4 then
							Players[pid].data.ecWar.team = 3
							tes3mp.SendMessage(pid, color.DarkOrange .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamThree .. ".\n", true)			
						end				
					elseif canSwitchTeams == false then
						tes3mp.SendMessage(pid, color.Yellow .. "Changer d'équipe est désactivé.\n", false)
					end	
					Players[pid]:QuicksaveToDrive()				
				else
					local message = "Vous n'avez pas 10000 pièces pour changer de faction\n"
					tes3mp.SendMessage(pid, message, false)
				end	
			else
				local message = "Pour changer de faction il vous faut 10000 pièces\n"
				tes3mp.SendMessage(pid, message, false)								
			end
		end
	end
end

Methods.SwitchTeamsPelerins = function(pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local targetName = Players[pid].name
		if Players[pid].data.ecWar.team == 4 then
			local message = targetName .. " est déjà un membre des pélerins.\n"
			tes3mp.SendMessage(pid, message, false)
		else				
			local message = targetName .. " vous avez rejoint les pélerins!\n"
			tes3mp.SendMessage(pid, message, true)
			if canSwitchTeams == true then

				if Players[pid].data.ecWar.team == 1 then
					Players[pid].data.ecWar.team = 4
					tes3mp.SendMessage(pid, color.DarkGreen .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamFour .. ".\n", true)
				elseif Players[pid].data.ecWar.team == 2 then
					Players[pid].data.ecWar.team = 4
					tes3mp.SendMessage(pid, color.DarkGreen .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamFour .. ".\n", true)
				elseif Players[pid].data.ecWar.team == 3 then
					Players[pid].data.ecWar.team = 4
					tes3mp.SendMessage(pid, color.DarkGreen .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamFour .. ".\n", true)			
				end
				Players[pid]:QuicksaveToDrive()					
			elseif canSwitchTeams == false then
				tes3mp.SendMessage(pid, color.Yellow .. "Changer d'équipe est désactivé.\n", false)
			end			
		end	
	end
end
--------------------
-- FUNCTIONS SECTION
--------------------

function EndCharGen(pid)
	Players[pid].data.customVariables.HungerTime = 0
	Players[pid].data.customVariables.SleepTime = 0	
	Players[pid].data.customVariables.ThirsthTime = 0	
	TeamHandler(pid)
end

function ResetCharacter(pid) -- Called from Methods.TeamHandler to reset characters for each new match
	-- Reset ecWar info
	Players[pid].data.ecWar.kills = 0
	Players[pid].data.ecWar.deaths = 0
	Players[pid].data.ecWar.spree = 0
	Players[pid].data.ecWar.spawnSeconds = spawnTime
	
	-- Reload player with reset information
	Players[pid]:QuicksaveToDrive()
	Players[pid]:LoadLevel()
	Players[pid]:LoadAttributes()
	Players[pid]:LoadSkills()
	Players[pid]:LoadStatsDynamic()
end

function JSONCheck(pid) -- Add TDM info to player JSON files if not present
	tes3mp.LogMessage(2, "++++ Function JSONCheck: Checking player JSON file for " .. Players[pid].data.login.name .. ". ++++")
	
	if Players[pid].data.ecWar == nil then
		local tdmInfo = {}
		tdmInfo.matchId = ""
		tdmInfo.status = 1 -- 1 = alive
		tdmInfo.team = 0
		tdmInfo.rang = 0
		tdmInfo.kills = 0
		tdmInfo.deaths = 0
		tdmInfo.spree = 0
		tdmInfo.spawnSeconds = spawnTime
		tdmInfo.totalKills = 0
		tdmInfo.totalDeaths = 0
		Players[pid].data.ecWar = tdmInfo
	end
end

function ProcessDeath(pid) -- Update player kills/deaths and team scores
	Players[pid].data.ecWar.status = 0  -- Player is dead and not safe for teleporting
	Players[pid].data.ecWar.deaths = Players[pid].data.ecWar.deaths + 1
	Players[pid].data.ecWar.totalDeaths = Players[pid].data.ecWar.totalDeaths + 1
	Players[pid].data.ecWar.spree = 0
	Players[pid].data.customVariables.HungerTime = 0
	Players[pid].data.customVariables.SleepTime = 0	
	Players[pid].data.customVariables.ThirsthTime = 0

	local deathReason = tes3mp.GetDeathReason(pid)
	local killCheck = false
	local killerTeam = 0
	
	tes3mp.LogMessage(1, "Origine de la mort " .. deathReason)
	
	if deathReason == "suicide" then
		deathReason = "suicide"
		Players[pid].data.ecWar.kills = Players[pid].data.ecWar.kills - 1
		
		if addSpawnDelay == true then
			Players[pid].data.ecWar.spawnSeconds = Players[pid].data.ecWar.spawnSeconds + spawnDelay
		end
	else
		local playerKiller = deathReason
		
		for pid2, player in pairs(Players) do
		
			if Players[pid2]:IsLoggedIn() then

				if string.lower(playerKiller) == string.lower(player.name) then
					
					if Players[pid].data.ecWar.team == Players[pid2].data.ecWar.team then
						Players[pid2].data.ecWar.kills = Players[pid2].data.ecWar.kills - 1
						Players[pid2].data.ecWar.totalKills = Players[pid2].data.ecWar.totalKills - 1
						Players[pid2].data.ecWar.spree = 0
						
						if Players[pid].data.ecWar.team == 1 then
							teamOneScore = teamOneScore - 1
						elseif Players[pid].data.ecWar.team == 2 then
							teamTwoScore = teamTwoScore - 1
						elseif Players[pid].data.ecWar.team == 3 then
							teamThreeScore = teamThreeScore - 1
						elseif Players[pid].data.ecWar.team == 4 then
							teamFourScore = teamFourScore - 1							
						end
						
					else 
						Players[pid2].data.ecWar.kills = Players[pid2].data.ecWar.kills + 1
						Players[pid2].data.ecWar.totalKills = Players[pid2].data.ecWar.totalKills + 1
						Players[pid2].data.ecWar.spree = Players[pid2].data.ecWar.spree + 1
						killCheck = true
						killerTeam = Players[pid2].data.ecWar.team
						
						if Players[pid].data.ecWar.team == 1 then
							teamThreeScore = teamThreeScore + 1														
						elseif Players[pid].data.ecWar.team == 2 then
							teamThreeScore = teamThreeScore + 1														
						elseif Players[pid].data.ecWar.team == 3 then
							teamOneScore = teamOneScore + 1	
							teamTwoScore = teamTwoScore + 1	
						elseif Players[pid].data.ecWar.team == 4 then
							teamThreeScore = teamThreeScore + 1							
						end
					end
					
					if Players[pid2].data.ecWar.spree == 3 then
						tes3mp.SendMessage(pid, color.Green .. Players[pid2].data.login.name .. " est en folie meurtrière!\n", true)
					end
					
					break
				end
			end
		end
		deathReason = "est mort par " .. deathReason		
		killer = string.sub(deathReason, 14)
		local lastPid = tes3mp.GetLastPlayerId()
		local killerPID = -1
        for i = 0, lastPid do
            if Players[i] ~= nil and Players[i]:IsLoggedIn() then
                if tostring(Players[i].name) == tostring(killer) then
                    killerPID = Players[i].pid -- get killer's PID, assuming it was an actual player
                    break
                end
            end
        end	
	end

	local message = ("%s (%d) %s"):format(Players[pid].data.login.name, pid, deathReason)
	
	if killCheck == true then
		
		if Players[pid].data.ecWar.team == 1 then
			message = color.DarkCyan .. message .. ".\n"
		elseif Players[pid].data.ecWar.team == 2 then
			message = color.Red .. message .. ".\n"
		elseif Players[pid].data.ecWar.team == 3 then
			message = color.DarkOrange .. message .. ".\n"
		elseif Players[pid].data.ecWar.team == 4 then
			message = color.Green .. message .. ".\n"			
		end
		
		tes3mp.SendMessage(pid, message, true)
		ScoreCheck(pid, killerTeam)
	else
		message = message .. ".\n"
		tes3mp.SendMessage(pid, message, true)
	end
	
	local timer = tes3mp.CreateTimerEx("OnDeathTimeExpiration", time.seconds(config.deathTime), "i", pid)			
	tes3mp.StartTimer(timer)		
end

function ScoreCheck(pid, teamNumber) -- Called from function OnPlayerDeath, checks whether team has won
    local message = ""
    
    if teamNumber == 1 then
        
        if teamOneScore == (scoreToWin - 5) then
            tes3mp.SendMessage(pid, color.DarkCyan .. "L'équipe " .. teamOne .. " à besoin de 5 kills pour gagner!\n", true)
        end
    elseif teamNumber == 2 then
    
        if teamTwoScore == (scoreToWin - 5) then
            tes3mp.SendMessage(pid, color.DarkRed .. "L'équipe " .. teamTwo .. " à besoin de 5 kills pour gagner!\n", true)
        end
    elseif teamNumber == 3 then
	
        if teamThreeScore == (scoreToWin - 5) then
            tes3mp.SendMessage(pid, color.DarkOrange .. "L'équipe " .. teamThree .. " à besoin de 5 kills pour gagner!\n", true)
        end
    elseif teamNumber == 4 then
	
        if teamFourScore == (scoreToWin - 5) then
            tes3mp.SendMessage(pid, color.Green .. "L'équipe " .. teamFour .. " à besoin de 5 kills pour gagner!\n", true)
        end
    end	
	
    if teamOneScore >= scoreToWin or teamTwoScore >= scoreToWin or teamThreeScore >= scoreToWin or teamFourScore >= scoreToWin then
        local winningTeam = 0
        
        if teamOneScore >= scoreToWin then
            winningTeam = 1
            message = color.DarkCyan .. "L'équipe  " .. teamOne .. " à gagné !\ndébut d'une nouvelle bataille...\n"
        elseif teamTwoScore >= scoreToWin then
            winningTeam = 2
            message = color.DarkRed .. "L'équipe  " .. teamTwo .. " à gagné !\ndébut d'une nouvelle bataille...\n"
        elseif teamThreeScore >= scoreToWin then
            winningTeam = 3
            message = color.DarkOrange .. "L'équipe  " .. teamThree .. " à gagné !\ndébut d'une nouvelle bataille...\n"
        elseif teamFourScore >= scoreToWin then
            winningTeam = 4
            message = color.Green .. "L'équipe  " .. teamFour .. " à gagné !\ndébut d'une nouvelle bataille...\n"			
        end
        
        tes3mp.SendMessage(pid, message, true)
        
        for i, p in pairs(Players) do -- Iterate through all winners
                
            if p ~= nil and p:IsLoggedIn() and p.data.ecWar ~= nil then
                
                if Players[i].data.ecWar.team == winningTeam then
					local itemref = {refId = "gold_001", count = 10000, charge = -1}
                    --table.insert(Players[i].data.inventory, itemRef)
					table.insert(Players[i].data.inventory, {refId = "gold_001", count = 10000, charge = -1})
					Players[pid]:QuicksaveToDrive()
					Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)
                end
            end
        end
        
        Methods.MatchInit()
    end
end


function TeamHandler(pid) -- Called from Methods.OnPlayerEndCharGen, Methods.OnGUIAction, and Methods.OnDeathTimeExpiration
	local teamOneCounter = 0
	local teamTwoCounter = 0
	local teamThreeCounter = 0
	local teamFourCounter = 0	
	JSONCheck(pid) -- Check if player has TDM info added to their JSON file
	
	tes3mp.LogMessage(2, "++++ Function TeamHandler: Checking matchId of player " .. Players[pid].data.login.name .. " nouvelle bataille #" .. matchId .. ". ++++")
	
	-- Check player's last matchId to determine whether to reset their character
	if Players[pid].data.ecWar.matchId == matchId then
		tes3mp.LogMessage(2, "++++ Function TeamHandler: matchId is the same. ++++")
	else -- Player's latest match ID doesn't equal that of current match
	
		if Players[pid].data.ecWar.matchId == nil then
			-- New character so no need to wipe it
		else -- Character was created prior to current match so we reset it
			tes3mp.LogMessage(2, "++++ Function TeamHandler: matchId is different -- Calling ResetCharacter(). ++++")
			ResetCharacter(pid) -- Reset character
		end
		
		tes3mp.LogMessage(2, "++++ Function TeamHandler: Assigning new matchId to player. ++++")
		Players[pid].data.ecWar.matchId = matchId -- Set player's match ID to current match ID
	end
	
	-- Iterate through all players to get # of players on each team (when player joins match in progress)
    for pid, p in pairs(Players) do 
        
		tes3mp.LogMessage(2, "++++ Function TeamHandler: Counting # of players on each team. ++++")
		if p:IsLoggedIn() and p.data.ecWar ~= nil then
			
			if p.data.ecWar.team == 0 then
				-- Player is unassigned, so counter doesn't increase
			elseif p.data.ecWar.team == 1 then
				tes3mp.LogMessage(2, "++++ Function TeamHandler: Adding player " .. p.data.login.name .. " rejoint " .. teamOne .. ". ++++")
				teamOneCounter = teamOneCounter + 1
			elseif p.data.ecWar.team == 2 then
				tes3mp.LogMessage(2, "++++ Function TeamHandler: Adding player " .. p.data.login.name .. " rejoint " .. teamTwo .. ". ++++")
				teamTwoCounter = teamTwoCounter + 1	
			elseif p.data.ecWar.team == 3 then				
				tes3mp.LogMessage(2, "++++ Function TeamHandler: Adding player " .. p.data.login.name .. " rejoint " .. teamThree .. ". ++++")
				teamThreeCounter = teamThreeCounter + 1					
			end
        end
		
		tes3mp.LogMessage(2, "++++ Function TeamHandler: # of players on team one: " .. teamOneCounter .. " | # of players on team two: " .. teamTwoCounter .. " | # of players on team three: " .. teamThreeCounter .. " | # of players on team four: " .. teamFourCounter .. " ++++")
    end
	
	local tempTeam = Players[pid].data.ecWar.team
	
	-- Team assigning + auto-balancing checks
	if tempTeam == 0 then
		Players[pid].data.ecWar.team = 4
		tes3mp.SendMessage(pid, color.Green .. Players[pid].data.login.name .. " vient de rejoindre la faction neutre " .. teamFour .. ".\n", true)				
	elseif tempTeam == 1 then
		Players[pid].data.ecWar.team = 1
		tes3mp.SendMessage(pid, color.DarkCyan .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamOne .. ".\n", true)				
	elseif tempTeam == 2 then
		Players[pid].data.ecWar.team = 2
		tes3mp.SendMessage(pid, color.DarkRed .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamTwo .. ".\n", true)				
	elseif tempTeam == 3 then
		Players[pid].data.ecWar.team = 3
		tes3mp.SendMessage(pid, color.DarkOrange .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamThree .. ".\n", true)				
	elseif tempTeam == 4 then
		Players[pid].data.ecWar.team = 4
		tes3mp.SendMessage(pid, color.Green .. Players[pid].data.login.name .. " vient de rejoindre la faction neutre " .. teamFour .. ".\n", true)					
	end

end

Methods.checkScore = function(pid)
	tes3mp.SendMessage(pid, color.Yellow .. "SCORES: \n" .. teamOne .. ": " .. teamOneScore .. "\n" .. teamTwo .. ": " .. teamTwoScore .. "\n" .. teamThree .. ": " .. teamThreeScore .. "\n", false)
end	

Methods.Prison = function(pid, cmd)
	if logicHandler.CheckPlayerValidity(pid, cmd[2]) then
		local TargetPid = tonumber(cmd[2])			
		local targetName = Players[TargetPid].name
		local RankP = tonumber(Players[pid].data.ecWar.rang)
		if Players[pid]:IsAdmin() then		
			if Players[TargetPid]:IsAdmin() then
				local message = targetName .. " ne peux pas pas être sanctionné!\n"
				tes3mp.SendMessage(pid, message, true)
			else
				local message = targetName .. " a était sanctionné par un modérateur!\n"
				tes3mp.SendMessage(pid, message, true)
				Methods.PunishPrison(pid, TargetPid)					
			end
		
		elseif RankP == 4 then
			if Players[TargetPid].data.ecWar.team == 4 then
				local message = targetName .. " a était sanctionné par le maire!\n"
				tes3mp.SendMessage(pid, message, true)
				Methods.PunishPrison(pid, TargetPid)
			else
				local message = targetName .. " n'appartient pas à la faction des pélerins!\n"
				tes3mp.SendMessage(pid, message, true)					
			end	
		elseif RankP == 3 then		
			if Players[TargetPid].data.ecWar.team == 3 then
				local message = targetName .. " a était sanctionné par les renégats!\n"
				tes3mp.SendMessage(pid, message, true)
				Methods.PunishPrison(pid, TargetPid)
			else
				local message = targetName .. " n'appartient pas à la faction des renégats!\n"
				tes3mp.SendMessage(pid, message, true)					
			end	
		elseif RankP == 2 then
			if Players[TargetPid].data.ecWar.team == 2 then
				local message = targetName .. " a était sanctionné par l'empire!\n"
				tes3mp.SendMessage(pid, message, true)
				Methods.PunishPrison(pid, TargetPid)
			else
				local message = targetName .. " n'appartient pas à la faction de l'empire!\n"
				tes3mp.SendMessage(pid, message, true)					
			end	
		elseif RankP == 1 then
			if Players[TargetPid].data.ecWar.team == 1 then
				local message = targetName .. " a était sanctionné par le temple!\n"
				tes3mp.SendMessage(pid, message, true)
				ecarlateScript.PunishPrison(pid, TargetPid)
			else
				local message = targetName .. " n'appartient pas à la faction du temple!\n"
				tes3mp.SendMessage(pid, message, true)					
			end	
		end
	end
end

Methods.PunishPrison = function(pid, cmd) -- Used to send a player into the prison
	if cmd[2] ~= nil then
		local targetPlayerName = Players[tonumber(targetPlayer)].name
		local msg = color.Orange .. "SERVER: " .. targetPlayerName .. " est en prison.\n"
		local cell = "Coeurébène, Fort Noctuelle"
		tes3mp.SetCell(targetPlayer, cell)
		tes3mp.SendCell(targetPlayer)	
		tes3mp.SetPos(targetPlayer, 756, 2560, -383)
		tes3mp.SetRot(targetPlayer, 0, 0)
		tes3mp.SendPos(targetPlayer)	
		tes3mp.SendMessage(pid, msg, true)
		if Players[targetPlayer].data.customVariables.Jailer == nil then
			Players[targetPlayer].data.customVariables.Jailer = true
		else	
			Players[targetPlayer].data.customVariables.Jailer = true
		end
		local TimerJail = tes3mp.CreateTimer("EventJail", time.seconds(300))
		tes3mp.StartTimer(TimerJail)
		tes3mp.MessageBox(targetPlayer, -1, message.WaitJail)		
		function EventJail()
			for pid, player in pairs(Players) do
				if Players[pid] ~= nil and player:IsLoggedIn() then
					if Players[pid].data.customVariables.Jailer == true then
						Players[pid].data.customVariables.Jailer = false
						tes3mp.MessageBox(pid, -1, message.StopJail)
						tes3mp.SetCell(pid, "-3, -2")  
						tes3mp.SetPos(pid, -23974, -15787, 505)
						tes3mp.SetRot(pid, 0, 0)
						tes3mp.SendCell(pid)    
						tes3mp.SendPos(pid)
					end
				end
			end
		end
	else
		message = color.Gold .. "Veuillez choisir un pid pour punir un joueur.\n"
		tes3mp.SendMessage(pid, message, false)	
	end	
end

Methods.Recrutement = function(pid, cmd)
	if logicHandler.CheckPlayerValidity(pid, cmd[2]) then	
		local TargetPid = tonumber(cmd[2])			
		local targetName = Players[TargetPid].name
		local RankP = tonumber(Players[pid].data.ecWar.rang)
		if Players[TargetPid]:IsAdmin() then
			local message = targetName .. " ne peux pas pas être recruté!\n"
			tes3mp.SendMessage(pid, message, true)
		else
			if RankP == 3 then		
				if Players[TargetPid].data.ecWar.team ~= 3 then
					local message = targetName .. " a était recruté chez les renégats!\n"
					tes3mp.SendMessage(pid, message, true)
					Players[TargetPid].data.ecWar.team = 3
					tes3mp.SendMessage(pid, color.DarkOrange .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamThree .. ".\n", true)			
					Players[TargetPid]:QuicksaveToDrive()
				else
					local message = targetName .. " fait déjà parti de la faction.\n"
					tes3mp.SendMessage(pid, message, true)					
				end	
			elseif RankP == 2 then
				if Players[TargetPid].data.ecWar.team ~= 2 then
					local message = targetName .. " a était recruté dans l'empire!\n"
					tes3mp.SendMessage(pid, message, true)
					Players[TargetPid].data.ecWar.team = 2
					tes3mp.SendMessage(pid, color.DarkRed .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamTwo .. ".\n", true)			
					Players[TargetPid]:QuicksaveToDrive()
				else
					local message = targetName .. " fait déjà parti de la faction.\n"
					tes3mp.SendMessage(pid, message, true)					
				end	
			elseif RankP == 1 then
				if Players[TargetPid].data.ecWar.team ~= 1 then
					local message = targetName .. " a était recruté au temple!\n"
					tes3mp.SendMessage(pid, message, true)
					Players[TargetPid].data.ecWar.team = 1
					tes3mp.SendMessage(pid, color.DarkCyan .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamOne .. ".\n", true)			
					Players[TargetPid]:QuicksaveToDrive()
				else
					local message = targetName .. " fait déjà parti de la faction.\n"
					tes3mp.SendMessage(pid, message, true)					
				end	
			end
		end
	end
end

Methods.Expulser = function(pid, cmd)
	if logicHandler.CheckPlayerValidity(pid, cmd[2]) then	
		local TargetPid = tonumber(cmd[2])			
		local targetName = Players[TargetPid].name
		local RankP = tonumber(Players[pid].data.ecWar.rang)
		if Players[TargetPid]:IsAdmin() then
			local message = targetName .. " ne peux pas pas être expulsé!\n"
			tes3mp.SendMessage(pid, message, true)
		else
			if RankP == 3 then		
				if Players[TargetPid].data.ecWar.team == 3 then
					local message = targetName .. " a était expulsé des renégats!\n"
					tes3mp.SendMessage(pid, message, true)
					Players[TargetPid].data.ecWar.team = 4
					tes3mp.SendMessage(pid, color.DarkOrange .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamThree .. ".\n", true)			
					Players[TargetPid]:QuicksaveToDrive()
				else
					local message = targetName .. " fait déjà parti de la faction.\n"
					tes3mp.SendMessage(pid, message, true)					
				end	
			elseif RankP == 2 then
				if Players[TargetPid].data.ecWar.team == 2 then
					local message = targetName .. " a était expulsé de l'empire!\n"
					tes3mp.SendMessage(pid, message, true)
					Players[TargetPid].data.ecWar.team = 4
					tes3mp.SendMessage(pid, color.DarkRed .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamTwo .. ".\n", true)			
					Players[TargetPid]:QuicksaveToDrive()
				else
					local message = targetName .. " fait déjà parti de la faction.\n"
					tes3mp.SendMessage(pid, message, true)					
				end	
			elseif RankP == 1 then
				if Players[TargetPid].data.ecWar.team == 1 then
					local message = targetName .. " a était expulsé du temple!\n"
					tes3mp.SendMessage(pid, message, true)
					Players[TargetPid].data.ecWar.team = 4
					tes3mp.SendMessage(pid, color.DarkCyan .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamOne .. ".\n", true)			
					Players[TargetPid]:QuicksaveToDrive()
				else
					local message = targetName .. " fait déjà parti de la faction.\n"
					tes3mp.SendMessage(pid, message, true)					
				end	
			end
		end
	end
end

Methods.Warp = function(pid)
	local destinationCell		
	local destinationPos
	local TeamP = tonumber(Players[pid].data.ecWar.team)	
	if TeamP == 1 then			
		destinationCell = "-14, -11"
		destinationPos = {x = -107732, y = -87562, z = 1610}
		eventHandler.warpPlayer(pid, destinationCell, destinationPos)

	elseif TeamP == 2 then
		destinationCell = "-14, -11"
		destinationPos = {x = -107732, y = -87562, z = 1610}
		eventHandler.warpPlayer(pid, destinationCell, destinationPos)				
		
	elseif TeamP == 3 then
		destinationCell = "-19, 13"
		destinationPos = {x = -148711, y = 114340, z = 147}
		eventHandler.warpPlayer(pid, destinationCell, destinationPos)			
		
	elseif TeamP == 4 then				
		destinationCell = "-1, -3"
		destinationPos = {x = -5051, y = -18186, z = 1004}
		eventHandler.warpPlayer(pid, destinationCell, destinationPos)
	end	
end

Methods.Promotion = function(pid, cmd)
	if logicHandler.CheckPlayerValidity(pid, cmd[2]) then	
		local TargetPid = tonumber(cmd[2])
		local TargetFaction = tonumber(cmd[3])
		local targetName = Players[TargetPid].name
		local RankP = tonumber(Players[TargetPid].data.ecWar.rang)
		if Players[pid]:IsAdmin() then
			if TargetPid ~= nil then
				if TargetFaction ~= nil then
					if RankP ~= 4 and TargetFaction == 4 then
						if Players[TargetPid].data.ecWar.team == 4 then
							local message = targetName .. " vous avez était promu en tant que Maire!\n"
							tes3mp.SendMessage(pid, message, true)
							Players[TargetPid].data.ecWar.rang = 4				
							Players[TargetPid]:QuicksaveToDrive()
						else
							local message = targetName .. " ne fait pas parti de la faction.\n"
							tes3mp.SendMessage(pid, message, true)					
						end			
					elseif RankP ~= 3 and TargetFaction == 3 then		
						if Players[TargetPid].data.ecWar.team == 3 then
							local message = targetName .. " vous avez était promu en tant que Chef!\n"
							tes3mp.SendMessage(pid, message, true)
							Players[TargetPid].data.ecWar.rang = 3
							Players[TargetPid]:QuicksaveToDrive()
						else
							local message = targetName .. " ne fait pas parti de la faction.\n"
							tes3mp.SendMessage(pid, message, true)					
						end	
					elseif RankP ~= 2 and TargetFaction == 2 then
						if Players[TargetPid].data.ecWar.team == 2 then
							local message = targetName .. " vous avez était promu comme Gouverneur!\n"
							tes3mp.SendMessage(pid, message, true)
							Players[TargetPid].data.ecWar.rang = 2					
							Players[TargetPid]:QuicksaveToDrive()
						else
							local message = targetName .. " ne fait pas parti de la faction.\n"
							tes3mp.SendMessage(pid, message, true)					
						end	
					elseif RankP ~= 1 and TargetFaction == 1 then
						if Players[TargetPid].data.ecWar.team == 1 then
							local message = targetName .. " vous avez était promu comme Hortator!\n"
							tes3mp.SendMessage(pid, message, true)
							Players[TargetPid].data.ecWar.rang = 1					
							Players[TargetPid]:QuicksaveToDrive()
						else
							local message = targetName .. " ne fait pas parti de la faction.\n"
							tes3mp.SendMessage(pid, message, true)					
						end	
					end
				else
					local message = "Veuillez choisir une faction en plus du pid.\n"
					tes3mp.SendMessage(pid, message, true)	
				end					
			else
				local message = "Veuillez choisir un pid.\n"
				tes3mp.SendMessage(pid, message, true)	
			end
		end
	end
end

Methods.PrimePay = function(pid, cmd)

	if logicHandler.CheckPlayerValidity(pid, cmd[2]) then 
		local TargetPid = tonumber(cmd[2])
		local targetName = Players[TargetPid].name	
		local RankP = tonumber(Players[pid].data.ecWar.rang)	
		local TeamP = tonumber(Players[TargetPid].data.ecWar.team)	
		if Players[pid]:IsServerStaff() then
			Players[TargetPid].wanted = pid
			Players[pid].PrimeTarget = TargetPid
			local message = targetName .. " la prime a était payé par un modérateur!\n"
			tes3mp.SendMessage(pid, message, true)
			Methods.StopPrimeToPlayer(pid, pid, TargetPid)									                
		elseif RankP == 3 then
			if TeamP ~= 3 then
				Players[TargetPid].wanted = pid
				Players[pid].PrimeTarget = TargetPid
				local message = targetName .. " la prime a était payé par le chef!\n"
				tes3mp.SendMessage(pid, message, true)
				Methods.StopPrimeToPlayer(pid, pid, TargetPid)
			else
				local message = targetName .. " le joueur fait partie d'une autre faction!\n"
				tes3mp.SendMessage(pid, message, false)	
			end				               
		elseif RankP == 2 then
			if TeamP ~= 2 then
				Players[TargetPid].wanted = pid
				Players[pid].PrimeTarget = TargetPid
				local message = targetName .. " la prime a était payé par le gouverneur!\n"
				tes3mp.SendMessage(pid, message, true)
				Methods.StopPrimeToPlayer(pid, pid, TargetPid)
			else
				local message = targetName .. " le joueur fait partie d'une autre faction!\n"
				tes3mp.SendMessage(pid, message, false)	
			end		
		elseif RankP == 1 then
			if TeamP ~= 1 then
				Players[TargetPid].wanted = pid
				Players[pid].PrimeTarget = TargetPid
				local message = targetName .. " la prime a était payé par l'hortator!\n"
				tes3mp.SendMessage(pid, message, true)
				Methods.StopPrimeToPlayer(pid, pid, TargetPid)
			else
				local message = targetName .. " le joueur fait partie d'une autre faction!\n"
				tes3mp.SendMessage(pid, message, false)	
			end	
		end					
	end 
end	

Methods.StopPrimeToPlayer = function(pid, originPid, targetPid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if Players[targetPid] ~= nil and Players[targetPid]:IsLoggedIn() then
			local player = Players[pid]
			local goldL = inventoryHelper.getItemIndex(player.data.inventory, "gold_001", -1)
			if goldL then
				local item = player.data.inventory[goldL]
				local refId = item.refId
				local count = item.count
				local reste = (item.count - 10000)
				if count >= 10000 then
					local itemref = {refId = "gold_001", count = 10000, charge = -1}			
					player.data.inventory[goldL].count = player.data.inventory[goldL].count - 10000
					Players[pid]:QuicksaveToDrive()
					Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)
					local message = "Vous venez de dépenser 10000 pièces pour enlever cette prime\n"
					tes3mp.SendMessage(pid, message, false)				
					Methods.StopPrime(targetPid)
				else
					local message = "Vous n'avez pas 10000 pièces pour enlever cette prime\n"
					tes3mp.SendMessage(pid, message, false)	
				end
			else
				local message = "Vous n'avez pas de pièces pour enlever une prime\n"
				tes3mp.SendMessage(pid, message, false)			
			end
		end
    end
end 

Methods.StopPrime = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local prime = 0
		Players[pid].data.fame.bounty = prime -- set new bounty
		tes3mp.SetBounty(pid, Players[pid].data.fame.bounty)
		tes3mp.SendBounty(pid)
		Players[pid]:QuicksaveToDrive()
		tes3mp.SendBounty(pid)
	end
end 

Methods.Prime = function(pid, cmd)
	if logicHandler.CheckPlayerValidity(pid, cmd[2]) then --So now just specify a target.
		local TargetPid = tonumber(cmd[2])
		Players[TargetPid].wanted = pid
		Players[pid].PrimeTarget = TargetPid
		Methods.PrimeToPlayer(pid, pid, TargetPid)
	end	
end

Methods.PrimeToPlayer = function(pid, originPid, targetPid)
    if tonumber(originPid) == tonumber(targetPid) then
        local message = "Vous ne pouvez pas mettre de prime sur vous meme.\n"
        tes3mp.SendMessage(pid, message, false)
        return
    elseif tonumber(originPid) ~= tonumber(targetPid) then
		local player = Players[pid]
		local goldL = inventoryHelper.getItemIndex(player.data.inventory, "gold_001", -1)
		if goldL then
			local item = player.data.inventory[goldL]
			local refId = item.refId
			local count = item.count
			local reste = (item.count - 10000)
			if count >= 10000 then
				local itemref = {refId = "gold_001", count = 10000, charge = -1}			
				player.data.inventory[goldL].count = player.data.inventory[goldL].count - 10000
				Players[pid]:QuicksaveToDrive()
				Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)
				local message = "Vous venez de dépenser 10000 pièces pour mettre une prime\n"
				tes3mp.SendMessage(pid, message, false)				
				Methods.PrimePlayer(targetPid)
			else
				local message = "Vous n'avez pas 10000 pièces pour mettre une prime\n"
				tes3mp.SendMessage(pid, message, false)	
			end
		else
			local message = "Vous n'avez pas de pièces pour mettre une prime\n"
			tes3mp.SendMessage(pid, message, false)			
		end
    end
end  

Methods.PrimePlayer = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local prime = 10000
		Players[pid].data.fame.bounty = prime -- set new bounty
		tes3mp.SetBounty(pid, Players[pid].data.fame.bounty)
		tes3mp.SendBounty(pid)
		Players[pid]:QuicksaveToDrive()
	end
end  

Methods.ResPlayer = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if logicHandler.CheckPlayerValidity(pid, cmd[2]) then --So now just specify a target.
			local TargetPid = tonumber(cmd[2])
			local targetName = Players[TargetPid].name				
			if Players[TargetPid] ~= nil then
				tes3mp.Resurrect(pid,0)		
				local message = targetName .. " à était ressucité !\n"
				tes3mp.SendMessage(pid, message, true)
			else
				local message =  "ce joueur n'est pas connecté !\n"
				tes3mp.SendMessage(pid, message, true)					
			end					
		end 
	end
end		

Methods.ResVamp = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		tes3mp.SetCell(pid, "RENEGATS, grand hall") 			
		tes3mp.SetPos(pid, 4153, 4930, 14045)
		tes3mp.SendCell(pid)    
		tes3mp.SendPos(pid)	
		tes3mp.Resurrect(pid,0)			
		if config.deathPenaltyJailDays > 0 then
			local levelPlayer = math.floor((tes3mp.GetLevel(pid) * 80) / 100) 		
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
			tes3mp.Jail(pid, jailTime, true, true, "Récupération", resurrectionText)
		end	
	end
end		

Methods.Res = function(pid)
	if GameplayAdvance then
		GameplayAdvance.ResurrectProcess(pid)
	else
		Players[pid]:Resurrect()
	end
end

function Methods.StartMenu(pid)
    if Players[pid]~= nil and Players[pid]:IsLoggedIn() then
		Players[pid].currentCustomMenu = "menu faction"
		menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
	end
end

Methods.OnPlayerSendMessage = function(eventStatus, pid, message)

    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then 
		tes3mp.LogMessage(enumerations.log.INFO, logicHandler.GetChatName(pid) .. ": " .. message) 
		local RankP = tonumber(Players[pid].data.ecWar.rang)
        -- Is this a chat command? If so, pass it over to the commandHandler
        if not message:sub(1, 1) == '/' then
			local message1 = color.Grey .. logicHandler.GetChatName(pid) .. color.White .. " : " .. message

            if Players[pid]:IsServerStaff() then 
				if Players[pid]:IsServerOwner() then
					message1 = config.rankColors.serverOwner .. "[Adm] " .. message1 .. "\n"
				elseif Players[pid]:IsAdmin() then
					message1 = config.rankColors.admin .. "[Adm] " .. message1 .. "\n"
				elseif Players[pid]:IsModerator() then
					message1 = config.rankColors.moderator .. "[Mod] " .. message1 .. "\n"
				end
			else
				if RankP == 4 then
					message1 = config.rankColors.pelerin .. "[Pel] ".. message1	.. "\n"
				elseif RankP == 1 then
					message1 = config.rankColors.temple .. "[Tem] ".. message1 .. "\n"
				elseif RankP == 2 then
					message1 = config.rankColors.empire .. "[Emp] ".. message1 .. "\n"
				elseif RankP == 3 then
					message1 = config.rankColors.renegat .. "[Ren] ".. message1	.. "\n"			
				end
			end
			if message:sub(1, 1) == '!' then			
				tes3mp.SendGlobalMessage(pid, message1, true)
			else
				tes3mp.SendLocalMessage(pid, message1, true)
			end

			return customEventHooks.makeEventStatus(false,false)	
		end	
	end
end

Methods.SendGlobalMessage = function(pid, message, useName)
	if useName == true then
		tes3mp.SendMessage(pid, message, true)
	else
		tes3mp.SendMessage(pid, message, true)
	end
end

Methods.SendLocalMessage = function(pid, message, useName)
	local playerName = Players[pid].name
	
	-- Get top left cell from our cell
	local myCellDescription = Players[pid].data.location.cell
	
	if tes3mp.IsInExterior(pid) == true then
		local cellX = tonumber(string.sub(myCellDescription, 1, string.find(myCellDescription, ",") - 1))
		local cellY = tonumber(string.sub(myCellDescription, string.find(myCellDescription, ",") + 2))
		
		local firstCellX = cellX - localChatCellRadius
		local firstCellY = cellY + localChatCellRadius
		
		local length = localChatCellRadius * 2
		
		for x = 0, length, 1 do
			for y = 0, length, 1 do
				-- loop through all y inside of x
				local tempCell = (x+firstCellX)..", "..(firstCellY-y)
				-- send message to each player in cell
				if LoadedCells[tempCell] ~= nil then
					if useName == true then
						SendMessageToAllInCell(tempCell, message.."\n")
					else
						SendMessageToAllInCell(tempCell, message.."\n")
					end
				end
			end
		end
	else
		if useName == true then
			SendMessageToAllInCell(myCellDescription, message.."\n")
		else
			SendMessageToAllInCell(myCellDescription, message.."\n")
		end
	end
end

function SendMessageToAllInCell(cellDescription, message)
	for index,pid in pairs(LoadedCells[cellDescription].visitors) do
		if Players[pid].data.location.cell == cellDescription then
			tes3mp.SendMessage(pid, message, false)
		end
	end
end

Methods.OnPlayerConnect = function(eventStatus, pid)
	if Players[pid] ~= nil then
		local playerName = Players[pid].name
		local message = logicHandler.GetChatName(pid) .. " rejoint le serveur.\n"
		tes3mp.SendMessage(pid, message, true)

		message = "" .. color.Blue .. "Bienvenue " .. playerName .. ".\nVous avez " .. color.Yellow .. tostring(config.loginTime) .. color.Blue .. " secondes pour vous "

		if Players[pid]:HasAccount() then
			message = message .. " connecter.\n"
			guiHelper.ShowLogin(pid)
		else
			message = message .. " enregistrer.\n"
			guiHelper.ShowRegister(pid)
		end

		tes3mp.SendMessage(pid, message, false)

		Players[pid].loginTimerId = tes3mp.CreateTimerEx("OnLoginTimeExpiration",
			time.seconds(config.loginTime), "i", pid)
		tes3mp.StartTimer(Players[pid].loginTimerId)

		return customEventHooks.makeEventStatus(false,false)	
	end
end

customEventHooks.registerValidator("OnPlayerConnect", Methods.OnPlayerConnect)
customEventHooks.registerValidator("OnPlayerSendMessage", Methods.OnPlayerSendMessage)
customEventHooks.registerValidator("OnGUIAction", Methods.OnGUIAction)
customEventHooks.registerValidator("OnPlayerDeath", Methods.OnPlayerDeath)
customEventHooks.registerValidator("OnDeathTimeExpiration", Methods.OnDeathTime)
customEventHooks.registerHandler("OnDeathTimeExpiration", Methods.OnDeathTimeExpiration)
customEventHooks.registerHandler("OnPlayerEndCharGen", Methods.OnPlayerEndCharGen)
customCommandHooks.registerCommand("score", Methods.checkScore)
customCommandHooks.registerCommand("teams", Methods.ListTeams)
customCommandHooks.registerCommand("empire", Methods.SwitchTeamsEmpire)
customCommandHooks.registerCommand("temple", Methods.SwitchTeamsTemple)
customCommandHooks.registerCommand("renegat", Methods.SwitchTeamsRenegats)
customCommandHooks.registerCommand("pelerin", Methods.SwitchTeamsPelerins)
customCommandHooks.registerCommand("prison", Methods.Prison)
customCommandHooks.registerCommand("recruter", Methods.Recrutement)
customCommandHooks.registerCommand("expulser", Methods.Expulser)
customCommandHooks.registerCommand("warp", Methods.Warp)
customCommandHooks.registerCommand("promot", Methods.Promotion)
customCommandHooks.registerCommand("stopprime", Methods.PrimePay)
customCommandHooks.registerCommand("prime", Methods.Prime)
customCommandHooks.registerCommand("resurrectplayer", Methods.ResPlayer)
customCommandHooks.registerCommand("resurrectvamp", Methods.ResVamp)
customCommandHooks.registerCommand("resurrect", Methods.Res)
customCommandHooks.registerCommand("menufaction", Methods.StartMenu)

return Methods
