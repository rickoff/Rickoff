--[[
TeamGroup by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Create a group inviting players
---------------------------
INSTALLATION:
Save the file as TeamGroup.lua inside your server/scripts/custom folder.
Save the file as MenuTeam.lua inside your scripts/menu folder
Edits to customScripts.lua
TeamGroup = require("custom.TeamGroup")
Edits to config.lua
add in config.menuHelperFiles, "MenuTeam"
---------------------------
FUNCTION:
/menugroup in your chat for open menu
Activate player for invite in your group or use a menu
---------------------------
]]

tableHelper = require("tableHelper")

local playerGroup = {}

local config = {}
 
config.MainGUI = 20001989
config.listGUI = 20001990
config.listPlayerGUI = 20001991
config.listPlayerExitGUI = 20001992
config.MessageInput = 20001993

local playerListOptions = {}
local playerListInvite = {}
local playerExitInvite = {}

local TeamGroup = {}

local function getListMemberGroup(pid) -- does the same with hdvinv 
   
    local options = {}
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
	    local playerName = Players[pid].name
		if tableHelper.containsValue(playerGroup, playerName, true) then		
			for x, y in pairs(playerGroup) do	
				if tableHelper.containsValue(playerGroup[x].members, playerName, true) then						
					for name, value in pairs(playerGroup[x].members) do
						if playerGroup[x].members[name] ~= nil then	
							table.insert(options, playerGroup[x].members[name])  							
						end
					end	
				end
			end			
		end		
	end

    return options
end

local function getListPlayer(pid) -- does the same with hdvinv 
   
    local options = {}
  
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local playerName = Players[pid].name
		for pid, player in pairs(Players) do
			if player:IsLoggedIn() then
				table.insert(options, Players[pid].name)  
			end
		end
	end

    return options
end


-- ===========
--  MAIN MENU
-- ===========
-------------------------

TeamGroup.onMainGui = function(pid)
    TeamGroup.showMainGUI(pid)
end
 
TeamGroup.showMainGUI = function(pid)
	
    local message = color.Orange .. "BIENVENUE DANS LE MENU GROUPE.\n" .. color.Yellow .. "\nCréation :" .. color.White ..  " pour créer un nouveau groupe.\n\n" .. color.Yellow .. "Liste/Téléportation :" .. color.White ..  " pour afficher les membres de votre groupe et ce teleporter.\n\n" .. color.Yellow .. "Quitter/Supprimer :" .. color.White .. " pour quitter ou supprimer un groupe.\n\n" .. color.Yellow .. "Invitation :" .. color.White .. " pour inviter un joueur dans votre groupe.\n\n" .. color.Yellow .. "Expultion :" .. color.White .. " pour expulser un joueur de votre groupe.\n\n" .. color.Yellow .. "Message :" .. color.White .. " pour envoyer un message aux membres de votre groupe.\n\n"
    tes3mp.CustomMessageBox(pid, config.MainGUI, message, "Création;Liste/Téléportation;Quitter/Supprimer;Invitation;Expultion;Message;Retour;Fermer")
	
end

TeamGroup.CreateGroup = function(pid)

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if not tableHelper.containsValue(playerGroup, Players[pid].name, true) then
			local tableGroup = {
				name = {},
				members = {}
			}
			table.insert(tableGroup.name, Players[pid].name)
			table.insert(tableGroup.members, Players[pid].name)
			table.insert(playerGroup, tableGroup)	
			tes3mp.SendMessage(pid,"Vous venez de créer un groupe !  \n",false)
		else
			tes3mp.SendMessage(pid,"Vous faite deja parti d'un groupe !  \n",false)
		end
	end
	
end

TeamGroup.onMessagePlayer = function(pid)
	TeamGroup.InputMessage(pid)
end

TeamGroup.InputMessage = function(pid)
    local message = "Entrer un message pour le groupe"
    return tes3mp.InputDialog(pid, config.MessageInput, message, "")
end

TeamGroup.onChoiceMessage = function(pid, loc)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
	    local playerName = Players[pid].name
		if tableHelper.containsValue(playerGroup, playerName, true) then		
			for x, y in pairs(playerGroup) do	
				if tableHelper.containsValue(playerGroup[x].members, playerName, true) then						
					for name, value in pairs(playerGroup[x].members) do
						if playerGroup[x].members[name] ~= nil then	
							local targetPid = logicHandler.GetPlayerByName(playerGroup[x].members[name]).pid
 							tes3mp.SendMessage(targetPid, color.Green.."Groupe : " ..color.Pink.. loc ..color.Default.. "\n",false)
						end
					end	
				end
			end			
		end		
	end	
end	

TeamGroup.onExitPlayer =function(pid)
	TeamGroup.CheckPlayerExit(pid)
end

TeamGroup.CheckPlayerExit = function(pid)

    local playerName = Players[pid].name
    local options = getListPlayer(pid)
    local list = "* Retour *\n"
    local listItemChanged = false
    local listItem = ""
	
    for i = 1, #options do
		for x, y in pairs(Players) do
			if y:IsLoggedIn() then
				if Players[x].name == options[i] then
					listItem = Players[x].name
					listItemChanged = true
					break
				else
					listItemChanged = false
				end
			end
		end 
		
		if listItemChanged == true then
			list = list .. listItem
		end
		
		if listItemChanged == false then
			list= list .. "\n"
		end
		
        if not(i == #options) then
            list = list .. "\n"
        end
    end
	
	listItemChanged = false
    playerExitInvite[playerName] = {opt = options}
    tes3mp.ListBox(pid, config.listPlayerExitGUI, color.CornflowerBlue .. "Selectionner un joueur pour l'expulser de votre groupe." .. color.Default, list)	
end

TeamGroup.onChoiceExit = function(pid, loc)
    TeamGroup.showChoiceExit(pid, loc)
end
 
TeamGroup.showChoiceExit = function(pid, loc)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local choice = playerExitInvite[Players[pid].name].opt[loc]
		local targetPid = logicHandler.GetPlayerByName(choice).pid
		playerExitInvite[Players[pid].name].choice = choice
		Players[pid].data.targetPid = targetPid
		Players[targetPid].data.targetPid = pid
		for x, y in pairs(playerGroup) do
			if tableHelper.containsValue(playerGroup[x].name, Players[pid].name, true) then
				if tableHelper.containsValue(playerGroup[x].members, Players[pid].name, true) then
					for name, value in pairs(playerGroup[x].members) do	
						if playerGroup[x].members[name] == Players[targetPid].name then
							playerGroup[x].members[name] = nil
							tes3mp.SendMessage(pid,"Vous venez d'expulser un membre du groupe !  \n",false)
							tes3mp.SendMessage(targetPid,"Vous venez d'être expulsé du groupe !  \n",false)
						end
					end	
					for r, s in pairs(playerGroup[x].name) do
						if playerGroup[x].name[r] == Players[pid].name then
							playerGroup[x] = nil
							tes3mp.SendMessage(pid,"Vous venez de supprimer votre groupe !  \n",false)
						end
					end						
				end
			end
		end			
	end
end

TeamGroup.ExitGroup = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
		if tableHelper.containsValue(playerGroup, Players[pid].name, true) then	
			for x, y in pairs(playerGroup) do
				if tableHelper.containsValue(playerGroup[x].name, Players[pid].name, true) then
					playerGroup[x] = nil
					tes3mp.SendMessage(pid,"Vous venez de supprimer votre groupe !  \n",false)
				elseif tableHelper.containsValue(playerGroup[x].members, Players[pid].name, true) then
					for name, value in pairs(playerGroup[x].members) do	
						if playerGroup[x].members[name] == Players[pid].name then
							playerGroup[x].members[name] = nil
							tes3mp.SendMessage(pid,"Vous venez de quitter le groupe !  \n",false)
						end
					end	
				end
			end	
		else
			tes3mp.SendMessage(pid,"Vous n'avez pas de groupe !  \n",false)				
		end			
	end
end

TeamGroup.onListPlayer =function(pid)
	TeamGroup.CheckPlayer(pid)
end

TeamGroup.CheckPlayer = function(pid)

    local playerName = Players[pid].name
    local options = getListPlayer(pid)
    local list = "* Retour *\n"
    local listItemChanged = false
    local listItem = ""
	
    for i = 1, #options do
		for x, y in pairs(Players) do
			if y:IsLoggedIn() then
				if Players[x].name == options[i] then
					listItem = Players[x].name
					listItemChanged = true
					break
				else
					listItemChanged = false
				end
			end
		end 
		
		if listItemChanged == true then
			list = list .. listItem
		end
		
		if listItemChanged == false then
			list= list .. "\n"
		end
		
        if not(i == #options) then
            list = list .. "\n"
        end
    end
	
	listItemChanged = false
    playerListInvite[playerName] = {opt = options}
    tes3mp.ListBox(pid, config.listPlayerGUI, color.CornflowerBlue .. "Selectionner un joueur pour lancer une invitation" .. color.Default, list)	
end

TeamGroup.onChoiceInvite = function(pid, loc)
    TeamGroup.showChoiceInvite(pid, loc)
end
 
TeamGroup.showChoiceInvite = function(pid, loc)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local message = ""
		local choice = playerListInvite[Players[pid].name].opt[loc]
		local targetPid = logicHandler.GetPlayerByName(choice).pid
		message = message .. "Nom du membre: " .. choice
		playerListInvite[Players[pid].name].choice = choice
		Players[pid].data.targetPid = targetPid
		Players[targetPid].data.targetPid = pid
		Players[pid].currentCustomMenu = "invite player"--Invite Menu
		menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
	end
end

TeamGroup.onListCheck = function(pid) 
    TeamGroup.CheckGroup(pid)
end

TeamGroup.CheckGroup = function(pid)
    local playerName = Players[pid].name
    local options = getListMemberGroup(pid)
    local list = "* Retour *\n"
    local listItemChanged = false
    local listItem = ""
	
    for i = 1, #options do
 
		for x, y in pairs(playerGroup) do
			for name, value in pairs(playerGroup[x].members) do	
				if playerGroup[x].members[name] == options[i] then
					listItem = playerGroup[x].members[name]
					listItemChanged = true
					break
				else
					listItemChanged = false
				end
			end
		end 
		
		if listItemChanged == true then
			list = list .. listItem
		end
		
		if listItemChanged == false then
			list= list .. "\n"
		end
		
        if not(i == #options) then
            list = list .. "\n"
        end
    end
	
	listItemChanged = false
    playerListOptions[playerName] = {opt = options}
    tes3mp.ListBox(pid, config.listGUI, color.CornflowerBlue .. "Selectionner un joueur pour vous teleporter" .. color.Default, list)	
end

TeamGroup.onChoiceList = function(pid, loc)
    TeamGroup.showChoiceList(pid, loc)
end
 
TeamGroup.showChoiceList = function(pid, loc)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local message = ""
		local choice = playerListOptions[Players[pid].name].opt[loc]
		local targetPid = logicHandler.GetPlayerByName(choice).pid
		message = message .. "Nom du membre: " .. choice
		playerListOptions[Players[pid].name].choice = choice
		logicHandler.TeleportToPlayer(pid, pid, targetPid)	
	end
end

TeamGroup.RegisterGroup = function(pid, invitePid)	

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if not tableHelper.containsValue(playerGroup, Players[invitePid].name, true) then	
			for x, y in pairs(playerGroup) do	
				if tableHelper.containsValue(playerGroup[x].name, Players[pid].name, true) then		
					if not tableHelper.containsValue(playerGroup[x].members, Players[invitePid].name, true) then
						table.insert(playerGroup[x].members, Players[invitePid].name)
						tes3mp.SendMessage(pid, Players[invitePid].name.." viens de rejoindre le groupe de " ..Players[pid].name.. "\n", false)
						tes3mp.SendMessage(invitePid,"Vous venez de rejoindre le groupe de " ..Players[pid].name.. "\n", false)					
					end			
				end
			end
		else
			tes3mp.SendMessage(pid,"Le joueur fait deja parti d'un groupe !\n",false)				
		end
	end			
end

TeamGroup.EcarlateBonus = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local Count = 0
		local CellPlayer = tes3mp.GetCell(pid)
		if tableHelper.containsValue(playerGroup, Players[pid].name, true) then		
			for x, y in pairs(playerGroup) do	
				if tableHelper.containsValue(playerGroup[x].members, Players[pid].name, true) then		
					for name, value in pairs(playerGroup[x].members) do
						local targetPid = logicHandler.GetPlayerByName(playerGroup[x].members[name]).pid
						local CellTarget = tes3mp.GetCell(targetPid)
						if CellPlayer == CellTarget then
							Count = (Count -1) + 2
						end
					end	
				end
			end	
			return Count
		else
			return Count
		end
	end
end

TeamGroup.SendSoul = function(pid, soul)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local CellPlayer = tes3mp.GetCell(pid)
		if tableHelper.containsValue(playerGroup, Players[pid].name, true) then		
			for x, y in pairs(playerGroup) do	
				if tableHelper.containsValue(playerGroup[x].members, Players[pid].name, true) then		
					for name, value in pairs(playerGroup[x].members) do
						local targetPid = logicHandler.GetPlayerByName(playerGroup[x].members[name]).pid
						local CellTarget = tes3mp.GetCell(targetPid)
						local soulLoc = Players[targetPid].data.customVariables.soul
						local levelSoul = Players[targetPid].data.customVariables.levelSoul	
						local capSoul = Players[targetPid].data.customVariables.capSoul						
						if CellPlayer == CellTarget and targetPid ~= pid then
							if soulLoc == nil then
								Players[targetPid].data.customVariables.soul = soul
								tes3mp.MessageBox(targetPid, -1, color.Default.. "Vous avez gagné : "..color.Green.. soul ..color.Default.. " points d'" ..color.Yellow.. "exp\n\n" ..color.Green.. "Bonus de groupe * " ..color.Yellow.. 2)		
							elseif soulLoc >= capSoul then
								Players[targetPid].data.customVariables.levelSoul = Players[targetPid].data.customVariables.levelSoul + 1
								Players[targetPid].data.customVariables.soul = 0
								Players[targetPid].data.customVariables.capSoul = math.floor((levelSoul + 1) * 500)
								Players[targetPid].data.customVariables.pointSoul = Players[targetPid].data.customVariables.pointSoul + 5
								tes3mp.MessageBox(targetPid, -1, color.Default.. "Vous avez gagné un niveau félicitation : "..color.Green.. "/menu>joueur>compétences" ..color.Default.. " pour dépenser vos points d'" ..color.Yellow.. "exp.")										
							else
								Players[targetPid].data.customVariables.soul = Players[targetPid].data.customVariables.soul + soul
								tes3mp.MessageBox(targetPid, -1, color.Default.. "Vous avez gagné : "..color.Green.. soul ..color.Default.. " points d'" ..color.Yellow.. "exp\n\n" ..color.Green.. "Bonus de groupe * " ..color.Yellow.. 2)		
							end							
						end
					end	
				end
			end	
		end
	end
end

-- GENERAL
TeamGroup.OnGUIAction = function(pid, idGui, data)
   
    if idGui == config.MainGUI then -- Main
        if tonumber(data) == 0 then --CreerGroup
            TeamGroup.CreateGroup(pid)
            return TeamGroup.onMainGui(pid)
        elseif tonumber(data) == 1 then -- ListeMembres/Teleportation
            TeamGroup.onListCheck(pid)
            return true
        elseif tonumber(data) == 2 then -- Supprimer/Quitter
            TeamGroup.ExitGroup(pid)
            return TeamGroup.onMainGui(pid)	
        elseif tonumber(data) == 3 then -- Inviter
            TeamGroup.onListPlayer(pid)
            return true
        elseif tonumber(data) == 4 then -- Expulser
            TeamGroup.onExitPlayer(pid)
            return true	
        elseif tonumber(data) == 5 then -- Message
            TeamGroup.onMessagePlayer(pid)
            return true				
        elseif tonumber(data) == 6 then -- retour
			Players[pid].currentCustomMenu = "menu player"
			menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)
            return true
        elseif tonumber(data) == 7 then -- fermer
			--Do nothing
            return true			
        end
    elseif idGui == config.listGUI then -- Liste
        if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then            
            return TeamGroup.onMainGui(pid)
        else   
			TeamGroup.onChoiceList(pid, tonumber(data)) 
            return TeamGroup.onMainGui(pid)
        end 
    elseif idGui == config.listPlayerGUI then -- Liste
        if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then            
            return TeamGroup.onMainGui(pid)
        else   
			TeamGroup.onChoiceInvite(pid, tonumber(data)) 
            return true
        end 
    elseif idGui == config.listPlayerExitGUI then -- Liste
        if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then            
            return TeamGroup.onMainGui(pid)
        else   
			TeamGroup.onChoiceExit(pid, tonumber(data)) 
            return true
        end 	
    elseif idGui == config.MessageInput then -- Liste
        if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then            
            return TeamGroup.onMainGui(pid)
        else   
			TeamGroup.onChoiceMessage(pid, tostring(data)) 
            return TeamGroup.onMainGui(pid)
		end		
	end
end

TeamGroup.ActiveMenu = function(pid)
	Players[pid].currentCustomMenu = "reponse player"--Invite Menu
	menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
end

customEventHooks.registerValidator("OnPlayerDisconnect", function(eventStatus, pid)
	TeamGroup.ExitGroup(pid)
end)	
customEventHooks.registerHandler("OnGUIAction", function(eventStatus, pid, idGui, data)
	if TeamGroup.OnGUIAction(pid, idGui, data) then return end	
end)
customCommandHooks.registerCommand("menugroup", TeamGroup.onMainGui)

return TeamGroup
