-- mwTDM by Texafornian modified by rickoff for ecarlate server
-- v1710.15 for TES3MP v0.6.2 hotfix
--
-- Many thanks to:
-- * David (inventory checker & general LUA-fu)
-- * ppsychrite (JSON scripting examples)

-----------------------
-- DO-NOT-TOUCH SECTION
-----------------------

local time = require("time")
require("actionTypes")

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

-- Names of the two teams
-- (Change "color.DarkCyan" and "...Brown" in function ProcessDeath)
teamOne = "L'ordre du temple"
teamTwo = "L'empire de septim"
teamThree = "Les renégats"
teamFour = "Les pélerins"

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

			if p.data.mwTDM == nil then
				tes3mp.LogMessage(2, "++++ Methods.MatchInit: Pre JSON Check ++++")
				JSONCheck(p.pid)
			end
			
			-- If player is alive, then begin reassign+respawn procedure
			if p.data.mwTDM.status == 1 then
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
        
		if p:IsLoggedIn() and p.data.mwTDM ~= nil then
			
			if p.data.mwTDM.team == 0 then
				-- Player is unassigned
			elseif p.data.mwTDM.team == 1 then
				tes3mp.LogMessage(2, "++++ Methods.ListTeams: Adding player " .. p.data.login.name .. " to " .. teamOne .. ". ++++")
				teamOneCount = teamOneCount + 1
				teamOneList = teamOneList .. "\n" .. p.data.login.name .. " | K: " .. p.data.mwTDM.kills .. " | D: " .. p.data.mwTDM.deaths
			elseif p.data.mwTDM.team == 2 then
				tes3mp.LogMessage(2, "++++ Methods.ListTeams: Adding player " .. p.data.login.name .. " to " .. teamTwo .. ". ++++")
				teamTwoCount = teamTwoCount + 1
				teamTwoList = teamTwoList .. "\n" .. p.data.login.name .. " | K: " .. p.data.mwTDM.kills .. " | D: " .. p.data.mwTDM.deaths
			elseif p.data.mwTDM.team == 3 then
				tes3mp.LogMessage(2, "++++ Methods.ListTeams: Adding player " .. p.data.login.name .. " to " .. teamThree .. ". ++++")
				teamThreeCount = teamThreeCount + 1
				teamThreeList = teamThreeList .. "\n" .. p.data.login.name .. " | K: " .. p.data.mwTDM.kills .. " | D: " .. p.data.mwTDM.deaths
			elseif p.data.mwTDM.team == 4 then
				tes3mp.LogMessage(2, "++++ Methods.ListTeams: Adding player " .. p.data.login.name .. " to " .. teamFour .. ". ++++")
				teamFourCount = teamFourCount + 1
				teamFourList = teamFourList .. "\n" .. p.data.login.name .. " | K: " .. p.data.mwTDM.kills .. " | D: " .. p.data.mwTDM.deaths				
			end
        end
	end
	
	tes3mp.MessageBox(pid, -1, teamOneList .. "\n\n" .. teamTwoList .. "\n\n" .. teamThreeList .. "\n\n" .. teamFourList)
end

Methods.OnPlayerDeath = function(pid) -- Called whenever player dies. Updates kill and death count

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		ProcessDeath(pid)
	end
end

Methods.OnDeathTimeExpiration = function(pid)
	
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
        tes3mp.Resurrect(pid, actionTypes.resurrect.REGULAR)
		Players[pid].data.mwTDM.spawnSeconds = spawnTime
		Players[pid].data.mwTDM.status = 1 -- Player is now alive and safe for teleporting
		TeamHandler(pid)
    end
end

Methods.OnGUIAction = function(pid, idGui, data)
    data = tostring(data) -- data can be numeric, but we should convert this to string
    if idGui == GUI.ID.LOGIN then
        if data == nil then
            Players[pid]:Message("Mot de passe incorrect!\n")
            GUI.ShowLogin(pid)
            return true
        end

        Players[pid]:Load()

        -- Just in case the password from the data file is a number, make sure to turn it into a string
        if tostring(Players[pid].data.login.password) ~= data then
            Players[pid]:Message("Mot de passe incorrect!\n")
            GUI.ShowLogin(pid)
            return true
        end

        -- Is this player on the banlist? If so, store their new IP and ban them
        if tableHelper.containsValue(banList.playerNames, string.lower(Players[pid].accountName)) == true then
            Players[pid]:SaveIpAddress()

            Players[pid]:Message(Players[pid].accountName .. " est banni de ce serveur.\n")
            tes3mp.BanAddress(tes3mp.GetIP(pid))
        else
            Players[pid]:FinishLogin()
            Players[pid]:Message("Vous vous êtes connecté avec succès.\n")
        
			if Players[pid].data.mwTDM == nil then
				Players[pid].data.mwTDM.team = 0
				Players[pid].data.mwTDM.status = 1
			elseif Players[pid].data.mwTDM == 1 then
				Players[pid].data.mwTDM.team = 1
				Players[pid].data.mwTDM.status = 1	
			elseif Players[pid].data.mwTDM == 2 then
				Players[pid].data.mwTDM.team = 2
				Players[pid].data.mwTDM.status = 1	
			elseif Players[pid].data.mwTDM == 3 then
				Players[pid].data.mwTDM.team = 3
				Players[pid].data.mwTDM.status = 1	
			elseif Players[pid].data.mwTDM == 4 then
				Players[pid].data.mwTDM.team = 4
				Players[pid].data.mwTDM.status = 1					
			end
			
			TeamHandler(pid)
        end	
		
    elseif idGui == GUI.ID.REGISTER then
        if data == nil then
            Players[pid]:Message("Le mot de passe ne peut pas être vide\n")
            GUI.ShowRegister(pid)
            return true
        end
        Players[pid]:Registered(data)
        Players[pid]:Message("Vous vous etes enregistré avec succès.\nUtilisez Y par défaut pour discuter ou modifier à partir de votre configuration client.\n")
		
    elseif idGui == config.customMenuIds.confiscate and Players[pid].confiscationTargetName ~= nil then

        local targetName = Players[pid].confiscationTargetName
        local targetPlayer = Methods.GetPlayerByName(targetName)

        -- Because the window's item index starts from 0 while the Lua table for
        -- inventories starts from 1, adjust the former here
        local inventoryItemIndex = data + 1
        local item = targetPlayer.data.inventory[inventoryItemIndex]

        if item ~= nil then
        
            table.insert(Players[pid].data.inventory, item)
            Players[pid]:LoadInventory()
            Players[pid]:LoadEquipment()

            -- If the item is equipped by the target, unequip it first
            if inventoryHelper.containsItem(targetPlayer.data.equipment, item.refId, item.charge) then
                local equipmentItemIndex = inventoryHelper.getItemIndex(targetPlayer.data.equipment, item.refId, item.charge)
                targetPlayer.data.equipment[equipmentItemIndex] = nil
            end

            targetPlayer.data.inventory[inventoryItemIndex] = nil
            tableHelper.cleanNils(targetPlayer.data.inventory)

            Players[pid]:Message("Vous avez confisqué" .. item.refId .. " de " .. targetName .. "\n")

            if targetPlayer:IsLoggedIn() then
                targetPlayer:LoadInventory()
                targetPlayer:LoadEquipment()
            end
        else
            Players[pid]:Message("Id d'élément invalide\n")
        end

        targetPlayer:SetConfiscationState(false)
        targetPlayer:Save()

        Players[pid].confiscationTargetName = nil

    elseif idGui == config.customMenuIds.menuHelper and Players[pid].currentCustomMenu ~= nil then
        local buttonIndex = tonumber(data) + 1
        local buttonPressed = Players[pid].displayedMenuButtons[buttonIndex]

        local destination = menuHelper.getButtonDestination(pid, buttonPressed)

        menuHelper.processEffects(pid, destination.effects)
        menuHelper.displayMenu(pid, destination.targetMenu)

        Players[pid].previousCustomMenu = Players[pid].currentCustomMenu
        Players[pid].currentCustomMenu = destination.targetMenu		
		
    end
    return false
end

Methods.OnPlayerCellChange = function(pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
        Players[pid]:SaveCell()
        Players[pid]:SaveStatsDynamic()
        tes3mp.LogMessage(1, "Enregistrer le joueur " .. pid)
        Players[pid]:Save()

    end
end

Methods.OnPlayerEndCharGen = function(pid)
    if Players[pid] ~= nil then
        Players[pid]:EndCharGen()
		TeamHandler(pid)	
    end
end

Methods.SwitchTeamsTemple = function(pid)

	if canSwitchTeams == true then
	
		if Players[pid].data.mwTDM.team == 1 then
			Players[pid].data.mwTDM.team = 1
			tes3mp.SendMessage(pid, color.DarkCyan .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamOne .. ".\n", true)
		elseif Players[pid].data.mwTDM.team == 2 then
			Players[pid].data.mwTDM.team = 1
			tes3mp.SendMessage(pid, color.DarkCyan .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamOne .. ".\n", true)
		elseif Players[pid].data.mwTDM.team == 3 then
			Players[pid].data.mwTDM.team = 1
			tes3mp.SendMessage(pid, color.DarkCyan .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamOne .. ".\n", true)
		elseif Players[pid].data.mwTDM.team == 4 then
			Players[pid].data.mwTDM.team = 1
			tes3mp.SendMessage(pid, color.DarkCyan .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamOne .. ".\n", true)			
		end

	elseif canSwitchTeams == false then
		tes3mp.SendMessage(pid, color.Yellow .. "Changer d'équipe est désactivé.\n", false)
	end
end

Methods.SwitchTeamsEmpire = function(pid)

	if canSwitchTeams == true then
	
		if Players[pid].data.mwTDM.team == 1 then
			Players[pid].data.mwTDM.team = 2
			tes3mp.SendMessage(pid, color.DarkRed .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamTwo .. ".\n", true)
		elseif Players[pid].data.mwTDM.team == 2 then
			Players[pid].data.mwTDM.team = 2
			tes3mp.SendMessage(pid, color.DarkRed .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamTwo .. ".\n", true)
		elseif Players[pid].data.mwTDM.team == 3 then
			Players[pid].data.mwTDM.team = 2
			tes3mp.SendMessage(pid, color.DarkRed .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamTwo .. ".\n", true)
		elseif Players[pid].data.mwTDM.team == 4 then
			Players[pid].data.mwTDM.team = 2
			tes3mp.SendMessage(pid, color.DarkRed .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamTwo .. ".\n", true)			
		end

	elseif canSwitchTeams == false then
		tes3mp.SendMessage(pid, color.Red .. "Changing teams is disabled on this server.\n", false)
	end
end

Methods.SwitchTeamsRenegats = function(pid)

	if canSwitchTeams == true then
	
		if Players[pid].data.mwTDM.team == 1 then
			Players[pid].data.mwTDM.team = 3
			tes3mp.SendMessage(pid, color.DarkOrange .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamThree .. ".\n", true)
		elseif Players[pid].data.mwTDM.team == 2 then
			Players[pid].data.mwTDM.team = 3
			tes3mp.SendMessage(pid, color.DarkOrange .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamThree .. ".\n", true)
		elseif Players[pid].data.mwTDM.team == 3 then
			Players[pid].data.mwTDM.team = 3
			tes3mp.SendMessage(pid, color.DarkOrange .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamThree .. ".\n", true)
		elseif Players[pid].data.mwTDM.team == 4 then
			Players[pid].data.mwTDM.team = 3
			tes3mp.SendMessage(pid, color.DarkOrange .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamThree .. ".\n", true)			
		end
    
	elseif canSwitchTeams == false then
		tes3mp.SendMessage(pid, color.Red .. "Changing teams is disabled on this server.\n", false)
	end
end

Methods.SwitchTeamsPelerins = function(pid)

	if canSwitchTeams == true then
	
		if Players[pid].data.mwTDM.team == 1 then
			Players[pid].data.mwTDM.team = 4
			tes3mp.SendMessage(pid, color.Green .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamFour .. ".\n", true)
		elseif Players[pid].data.mwTDM.team == 2 then
			Players[pid].data.mwTDM.team = 4
			tes3mp.SendMessage(pid, color.Green .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamFour .. ".\n", true)
		elseif Players[pid].data.mwTDM.team == 3 then
			Players[pid].data.mwTDM.team = 4
			tes3mp.SendMessage(pid, color.Green .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamFour .. ".\n", true)
		elseif Players[pid].data.mwTDM.team == 4 then
			Players[pid].data.mwTDM.team = 4
			tes3mp.SendMessage(pid, color.Green .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamFour .. ".\n", true)			
		end
    
	elseif canSwitchTeams == false then
		tes3mp.SendMessage(pid, color.Red .. "Changing teams is disabled on this server.\n", false)
	end
end
--------------------
-- FUNCTIONS SECTION
--------------------

function EndCharGen(pid)

    Players[pid]:SaveLogin()
    Players[pid]:SaveCharacter()
    Players[pid]:SaveClass()
    Players[pid]:SaveStatsDynamic()
    Players[pid]:SaveEquipment()
    Players[pid]:SaveIpAddress()
    Players[pid]:CreateAccount()

    if config.shareJournal == true then
        WorldInstance:LoadJournal(pid)
    else
        Players[pid]:LoadJournal()
    end

    WorldInstance:LoadTopics(pid)
	TeamHandler(pid)
end

function JSONCheck(pid) -- Add TDM info to player JSON files if not present
	tes3mp.LogMessage(2, "++++ Function JSONCheck: Checking player JSON file for " .. Players[pid].data.login.name .. ". ++++")
	
	if Players[pid].data.mwTDM == nil then
		local tdmInfo = {}
		tdmInfo.matchId = ""
		tdmInfo.status = 1 -- 1 = alive
		tdmInfo.team = 0
		tdmInfo.kills = 0
		tdmInfo.deaths = 0
		tdmInfo.spree = 0
		tdmInfo.spawnSeconds = spawnTime
		tdmInfo.totalKills = 0
		tdmInfo.totalDeaths = 0
		Players[pid].data.mwTDM = tdmInfo
	end
end

function ProcessDeath(pid) -- Update player kills/deaths and team scores
	Players[pid].data.mwTDM.status = 0  -- Player is dead and not safe for teleporting
	Players[pid].data.mwTDM.deaths = Players[pid].data.mwTDM.deaths + 1
	Players[pid].data.mwTDM.totalDeaths = Players[pid].data.mwTDM.totalDeaths + 1
	Players[pid].data.mwTDM.spree = 0
	Players[pid]:Resurrect()
	
	local deathReason = tes3mp.GetDeathReason(pid)
	local killCheck = false
	local killerTeam = 0
	
	tes3mp.LogMessage(1, "Origine de la mort " .. deathReason)
	
	if deathReason == "suicide" then
		deathReason = "suicide"
		Players[pid].data.mwTDM.kills = Players[pid].data.mwTDM.kills - 1
		
		if addSpawnDelay == true then
			Players[pid].data.mwTDM.spawnSeconds = Players[pid].data.mwTDM.spawnSeconds + spawnDelay
		end
	else
		local playerKiller = deathReason
		
		for pid2, player in pairs(Players) do
		
			if Players[pid2]:IsLoggedIn() then

				if string.lower(playerKiller) == string.lower(player.name) then
					
					if Players[pid].data.mwTDM.team == Players[pid2].data.mwTDM.team then
						Players[pid2].data.mwTDM.kills = Players[pid2].data.mwTDM.kills - 1
						Players[pid2].data.mwTDM.totalKills = Players[pid2].data.mwTDM.totalKills - 1
						Players[pid2].data.mwTDM.spree = 0
						
						if Players[pid].data.mwTDM.team == 1 then
							teamOneScore = teamOneScore - 1
						elseif Players[pid].data.mwTDM.team == 2 then
							teamTwoScore = teamTwoScore - 1
						elseif Players[pid].data.mwTDM.team == 3 then
							teamThreeScore = teamThreeScore - 1
						elseif Players[pid].data.mwTDM.team == 4 then
							teamFourScore = teamFourScore - 1							
						end
						
					else 
						Players[pid2].data.mwTDM.kills = Players[pid2].data.mwTDM.kills + 1
						Players[pid2].data.mwTDM.totalKills = Players[pid2].data.mwTDM.totalKills + 1
						Players[pid2].data.mwTDM.spree = Players[pid2].data.mwTDM.spree + 1
						killCheck = true
						killerTeam = Players[pid2].data.mwTDM.team
						
						if Players[pid].data.mwTDM.team == 1 then
							teamTwoScore = teamTwoScore + 1 
							teamThreeScore = teamThreeScore + 1														
						elseif Players[pid].data.mwTDM.team == 2 then
							teamOneScore = teamOneScore + 1
							teamThreeScore = teamThreeScore + 1														
						elseif Players[pid].data.mwTDM.team == 3 then
							teamOneScore = teamOneScore + 1	
							teamTwoScore = teamTwoScore + 1	
						elseif Players[pid].data.mwTDM.team == 4 then
							teamThreeScore = teamThreeScore + 1							
						end
					end
					
					if Players[pid2].data.mwTDM.spree == 3 then
						tes3mp.SendMessage(pid, color.Green .. Players[pid2].data.login.name .. " est en folie meurtrière!\n", true)
					end
					
					break
				end
			end
		end
		
		deathReason = "est mort par " .. deathReason	
		Criminals.processBountyReward(pid, deathReason)		
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
		if killerPID == -1 then
			DeathDrop.Drop(pid)
		end
	end

	local message = ("%s (%d) %s"):format(Players[pid].data.login.name, pid, deathReason)
	
	if killCheck == true then
		
		if Players[pid].data.mwTDM.team == 1 then
			message = color.DarkCyan .. message .. ".\n"
		elseif Players[pid].data.mwTDM.team == 2 then
			message = color.Red .. message .. ".\n"
		elseif Players[pid].data.mwTDM.team == 3 then
			message = color.DarkOrange .. message .. ".\n"
		elseif Players[pid].data.mwTDM.team == 4 then
			message = color.Green .. message .. ".\n"			
		end
		
		tes3mp.SendMessage(pid, message, true)
		ScoreCheck(pid, killerTeam)
	else
		message = message .. ".\n"
		tes3mp.SendMessage(pid, message, true)
	end
	
    --local timer = tes3mp.CreateTimerEx("OnDeathTimeExpiration", time.seconds(Players[pid].data.mwTDM.spawnSeconds), "i", pid)
    local timer = tes3mp.CreateTimerEx("OnDeathTimeExpiration", time.seconds(config.deathTime), "i", pid)
    
    tes3mp.StartTimer(timer)
end

function ScoreCheck(pid, teamNumber) -- Called from function OnPlayerDeath, checks whether team has won
    local message = ""
    
    if teamNumber == 1 then
        
        if teamOneScore == (scoreToWin - 5) then
            tes3mp.SendMessage(pid, color.DarkCyan .. "L'équipe de " .. teamOne .. " à besoin de 5 kills pour gagner!\n", true)
        end
    elseif teamNumber == 2 then
    
        if teamTwoScore == (scoreToWin - 5) then
            tes3mp.SendMessage(pid, color.DarkRed .. "L'équipe de " .. teamTwo .. " à besoin de 5 kills pour gagner!\n", true)
        end
    elseif teamNumber == 3 then
	
        if teamThreeScore == (scoreToWin - 5) then
            tes3mp.SendMessage(pid, color.DarkOrange .. "L'équipe de " .. teamThree .. " à besoin de 5 kills pour gagner!\n", true)
        end
    elseif teamNumber == 4 then
	
        if teamFourScore == (scoreToWin - 5) then
            tes3mp.SendMessage(pid, color.Green .. "L'équipe de " .. teamFour .. " à besoin de 5 kills pour gagner!\n", true)
        end
    end	
	
    if teamOneScore >= scoreToWin or teamTwoScore >= scoreToWin or teamThreeScore >= scoreToWin or teamFourScore >= scoreToWin then
        local winningTeam = 0
        
        if teamOneScore >= scoreToWin then
            winningTeam = 1
            message = color.DarkCyan .. "L'équipe de  " .. teamOne .. " à gagné!n\ndébut d'une nouvelle bataille...\n"
        elseif teamTwoScore >= scoreToWin then
            winningTeam = 2
            message = color.DarkRed .. "L'équipe de  " .. teamTwo .. " à gagné!\n\ndébut d'une nouvelle bataille...\n"
        elseif teamThreeScore >= scoreToWin then
            winningTeam = 3
            message = color.DarkOrange .. "L'équipe de  " .. teamThree .. " à gagné!\n\ndébut d'une nouvelle bataille...\n"
        elseif teamFourScore >= scoreToWin then
            winningTeam = 4
            message = color.Green .. "L'équipe de  " .. teamFour .. " à gagné!\n\ndébut d'une nouvelle bataille...\n"			
        end
        
        tes3mp.SendMessage(pid, message, true)
        
        for i, p in pairs(Players) do -- Iterate through all winners
                
            if p ~= nil and p:IsLoggedIn() and p.data.mwTDM ~= nil then
                
                if Players[i].data.mwTDM.team == winningTeam then
					--local itemref = {refId = gold_001, count = 500, charge = -1}
                    --table.insert(Players[i].data.inventory, itemRef)
					table.insert(Players[i].data.inventory, {refId = "gold_001", count = 1000, charge = -1})
					Players[i]:LoadInventory()
                    Players[i]:LoadEquipment()
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
	if Players[pid].data.mwTDM.matchId == matchId then
		tes3mp.LogMessage(2, "++++ Function TeamHandler: matchId is the same. ++++")
	else -- Player's latest match ID doesn't equal that of current match
	
		if Players[pid].data.mwTDM.matchId == nil then
			-- New character so no need to wipe it
		else -- Character was created prior to current match so we reset it
			tes3mp.LogMessage(2, "++++ Function TeamHandler: matchId is different -- Calling ResetCharacter(). ++++")
		end
		
		tes3mp.LogMessage(2, "++++ Function TeamHandler: Assigning new matchId to player. ++++")
		Players[pid].data.mwTDM.matchId = matchId -- Set player's match ID to current match ID
	end
	
	-- Iterate through all players to get # of players on each team (when player joins match in progress)
    for pid, p in pairs(Players) do 
        
		tes3mp.LogMessage(2, "++++ Function TeamHandler: Counting # of players on each team. ++++")
		if p:IsLoggedIn() and p.data.mwTDM ~= nil then
			
			if p.data.mwTDM.team == 0 then
				-- Player is unassigned, so counter doesn't increase
			elseif p.data.mwTDM.team == 1 then
				tes3mp.LogMessage(2, "++++ Function TeamHandler: Adding player " .. p.data.login.name .. " rejoint " .. teamOne .. ". ++++")
				teamOneCounter = teamOneCounter + 1
			elseif p.data.mwTDM.team == 2 then
				tes3mp.LogMessage(2, "++++ Function TeamHandler: Adding player " .. p.data.login.name .. " rejoint " .. teamTwo .. ". ++++")
				teamTwoCounter = teamTwoCounter + 1	
			elseif p.data.mwTDM.team == 3 then				
				tes3mp.LogMessage(2, "++++ Function TeamHandler: Adding player " .. p.data.login.name .. " rejoint " .. teamThree .. ". ++++")
				teamThreeCounter = teamThreeCounter + 1					
			end
        end
		
		tes3mp.LogMessage(2, "++++ Function TeamHandler: # of players on team one: " .. teamOneCounter .. " | # of players on team two: " .. teamTwoCounter .. " | # of players on team three: " .. teamThreeCounter .. " | # of players on team four: " .. teamFourCounter .. " ++++")
    end
	
	local tempTeam = Players[pid].data.mwTDM.team
	
	-- Team assigning + auto-balancing checks
	if tempTeam == 0 then
		Players[pid].data.mwTDM.team = 4
		tes3mp.SendMessage(pid, color.Green .. Players[pid].data.login.name .. " vient de rejoindre la faction neutre " .. teamFour .. ".\n", true)				
	elseif tempTeam == 1 then
		Players[pid].data.mwTDM.team = 1
		tes3mp.SendMessage(pid, color.DarkCyan .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamOne .. ".\n", true)				
	elseif tempTeam == 2 then
		Players[pid].data.mwTDM.team = 2
		tes3mp.SendMessage(pid, color.DarkRed .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamTwo .. ".\n", true)				
	elseif tempTeam == 3 then
		Players[pid].data.mwTDM.team = 3
		tes3mp.SendMessage(pid, color.DarkOrange .. Players[pid].data.login.name .. " vient de rejoindre le combat pour " .. teamThree .. ".\n", true)				
	elseif tempTeam == 4 then
		Players[pid].data.mwTDM.team = 4
		tes3mp.SendMessage(pid, color.Green .. Players[pid].data.login.name .. " vient de rejoindre la faction neutre " .. teamFour .. ".\n", true)					
	end
	
end
