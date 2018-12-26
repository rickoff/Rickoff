--CompagnonScript
--tes3mp 0.7.0
--======
--SETUP
--======
--version 0.1
--call companions and give them orders to follow, activated, stop and other 

--add CompagnonScript.lua in folder mp-stuff\scripts\

--open in mp-stuff\data\recordstore\npc.json and add in permanentRecords :
--modify the npc according to your desire

--[[
	"compagnon_guerrier":{
      "name":"Compagnon Guerrier",
      "gender":1,
      "race":"orc",
      "hair":"b_n_orc_m_hair_01",
      "head":"b_n_orc_m_head_01",
      "class":"barbarian",
      "autoCalc":1,
      "items":[{
          "id":"iron boots",
          "count":1
        },{
          "id":"iron_cuirass",
          "count":1
        },{
          "id":"iron_gauntlet_left",
          "count":1
        },{
          "id":"iron_gauntlet_right",
          "count":1
        },{
          "id":"iron_pauldron_left",
          "count":1
        },{
          "id":"iron_pauldron_right",
          "count":1
        },{
          "id":"iron_greaves",
          "count":1
        },{
          "id":"iron_bracer_left",
          "count":1
        },{
          "id":"iron_towershield",
          "count":1
        },{
          "id":"iron battle axe",
          "count":1
        },{
          "id":"iron_bracer_right",
          "count":1
        }],
      "level":25
    },
    "compagnon_magicien":{
      "name":"Compagnon Magicien",
      "gender":1,
      "race":"high elf",
      "hair":"warhehm6a_beard_blonde",
      "head":"war_zhe_mhr1c",
      "class":"Mage",
      "autoCalc":1,
      "items":[{
          "id":"WAR_HIGHELF_ROBE_01a",
          "count":1
        },{
          "id":"WAR_HIGHELF_BOOT_02a",
          "count":1
        },{
          "id":"a_ss_sorcstaff",
          "count":1
        }],
      "level":25
    },
    "compagnon_rodeur":{
      "name":"Compagnon Rodeur",
      "gender":1,
      "race":"khajiit",
      "hair":"war_kj_fh4d",
      "head":"b_n_khajiit_f_hair02",
      "class":"Archer",
      "autoCalc":1,
      "items":[{
          "id":"archer leather gauntlet-L",
          "count":1
        },{
          "id":"archer leather gauntlet-R",
          "count":1
        },{
          "id":"archer leather pauldron-L",
          "count":1
        },{
          "id":"archer leather pauldron-R",
          "count":1
        },{	
          "id":"archer_leather_cuirass_",
          "count":1
        },{	
          "id":"iron arrow",
          "count":200
        },{	
          "id":"AT_LongBow_14_07_elven",
          "count":1
        },{	
          "id":"glass dagger",
          "count":1
        },{			
          "id":"archer leather greaves",
          "count":1
        }],
      "level":25
    },	
  },  

--add menu in mp-stuff\scripts\menu
  
Menus["menu compagnons"] = {
    text = color.Orange .. "MENU COMPAGNONS\n" ..
        color.Yellow .. "\nSelectionne un compagnon\n",
    buttons = {				
        { caption = "Guerrier",	
            destinations = {
                menuHelper.destinations.setDefault("menu cmd guerrier")
            }
        },	
        { caption = "Magicien",	
            destinations = {
                menuHelper.destinations.setDefault("menu cmd magicien")
            }
        },		
        { caption = "Rodeur",	
            destinations = {
                menuHelper.destinations.setDefault("menu cmd rodeur")
            }
        },
        { caption = "Retour",	
            destinations = {
                menuHelper.destinations.setDefault("menu player")
            }
        }			
    }
}

Menus["menu cmd guerrier"] = {
    text = color.Orange .. "MENU GUERRIER\n" ..
        color.Yellow .. "\nSelectionne une action\n" ..
            color.White .. "\ncontrôle le guerrier\n",
    buttons = {				
        { caption = "Appeler",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/appeler warrior"})
				})
			}
        },
        { caption = "Suivre",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/suivre warrior"})
				})
			}
        },	
        { caption = "Stop",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/stop warrior"})
				})
			}
        },			
    }
}

Menus["menu cmd magicien"] = {
    text = color.Orange .. "MENU MAGICIEN\n" ..
        color.Yellow .. "\nSelectionne une action\n" ..
            color.White .. "\ncontrôle le magicien\n",
    buttons = {				
        { caption = "Appeler",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/appeler wizzard"})
				})
			}
        },
        { caption = "Suivre",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/suivre wizzard"})
				})
			}
        },	
        { caption = "Stop",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/stop wizzard"})
				})
			}
        },			
    }
}

Menus["menu cmd rodeur"] = {
    text = color.Orange .. "MENU RODEUR\n" ..
        color.Yellow .. "\nSelectionne une action\n" ..
            color.White .. "\ncontrôle le rodeur\n",
    buttons = {				
        { caption = "Appeler",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/appeler thief"})
				})
			}
        },
        { caption = "Suivre",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/suivre thief"})
				})
			}
        },	
        { caption = "Stop",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/stop thief"})
				})
			}
        },			
    }
}

--open commandHandler.lua and add in chain command

	elseif cmd[1] == "appeler" and cmd[2] ~= nil then
		if cmd[2] == "warrior" then
			CompagnonFunctions.CreateWarrior(pid)
		elseif cmd[2] == "wizzard" then
			CompagnonFunctions.CreateWizzard(pid)
		elseif cmd[2] == "thief" then
			CompagnonFunctions.CreateThief(pid)			
		end
		
	elseif cmd[1] == "suivre" and cmd[2] ~= nil then
		if cmd[2] == "warrior" then
			targetindex = CompagnonFunctions.FollowPlayerWarrior(pid)	
			local message = "/setai " .. targetindex .. " FOLLOW " .. pid 
			eventHandler.OnPlayerSendMessage(pid, message)
			return
		elseif cmd[2] == "wizzard" then
			targetindex = CompagnonFunctions.FollowPlayerWizzard(pid)	
			local message = "/setai " .. targetindex .. " FOLLOW " .. pid 
			eventHandler.OnPlayerSendMessage(pid, message)
			return			
		elseif cmd[2] == "thief" then
			targetindex = CompagnonFunctions.FollowPlayerThief(pid)	
			local message = "/setai " .. targetindex .. " FOLLOW " .. pid 
			eventHandler.OnPlayerSendMessage(pid, message)	
			return			
		end	
	
	elseif cmd[1] == "stop" and cmd[2] ~= nil then
		if cmd[2] == "warrior" then
			targetindex = CompagnonFunctions.FollowPlayerWarrior(pid)	
			local message = "/setai " .. targetindex .. " CANCEL " .. pid 
			eventHandler.OnPlayerSendMessage(pid, message)
			return			
		elseif cmd[2] == "wizzard" then
			targetindex = CompagnonFunctions.FollowPlayerWizzard(pid)	
			local message = "/setai " .. targetindex .. " CANCEL " .. pid 
			eventHandler.OnPlayerSendMessage(pid, message)
			return			
		elseif cmd[2] == "thief" then
			targetindex = CompagnonFunctions.FollowPlayerThief(pid)	
			local message = "/setai " .. targetindex .. " CANCEL " .. pid 
			eventHandler.OnPlayerSendMessage(pid, message)	
			return			
		end	

--]]

local config = {}
config.warrior = "compagnon_guerrier"
config.wizzard = "compagnon_magicien"
config.thief = "compagnon_rodeur"

local compagnonData = {}
--=========
--FUNCTIONS
--=========

local function CreateCompagnon(refId)
	LoadedCells[compagnonData.cell]:InitializeObjectData(compagnonData.uniqueIndex, refId)
    LoadedCells[compagnonData.cell].data.objectData[compagnonData.uniqueIndex].location = compagnonData.location

	table.insert(LoadedCells[compagnonData.cell].data.packets.actorList, compagnonData.uniqueIndex)
	
	local objectData = {}
	objectData.refId = refId
	objectData.goldValue = 2500
	objectData.location = compagnonData.location
	
	packetBuilder.AddObjectPlace(compagnonData.uniqueIndex, objectData)
	
	tes3mp.SendObjectPlace(true, false)
	
	tes3mp.SetPos(compagnonData.pid, compagnonData.location.posX, compagnonData.location.posY, compagnonData.location.posZ)
    tes3mp.SendPos(compagnonData.pid)
end

local CompagnonFunctions = {}
--=====
--THIEF
--=====
function CompagnonFunctions.CreateThief(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		local refId = config.thief
		local mpNum = "99" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum

		compagnonData.location = {
			posX = (tes3mp.GetPosX(compagnonData.pid) + 150), posY = tes3mp.GetPosY(compagnonData.pid), posZ = tes3mp.GetPosZ(compagnonData.pid),
			rotX = 0, rotY = 0, rotZ = tes3mp.GetRotZ(compagnonData.pid) + 3.1
		}
		
		if LoadedCells[compagnonData.cell]:ContainsObject(compagnonData.uniqueIndex) then
			logicHandler.DeleteObjectForEveryone(compagnonData.cell, compagnonData.uniqueIndex)
		end

		CreateCompagnon(refId)
	end
end

function CompagnonFunctions.FollowPlayerThief(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		
		local mpNum = "99" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum
		
		return compagnonData.uniqueIndex
	end
	
end
--=======
--WARRIOR
--=======
function CompagnonFunctions.CreateWarrior(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		local refId = config.warrior
		local mpNum = "98" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum

		compagnonData.location = {
			posX = tes3mp.GetPosX(compagnonData.pid) + 100, posY = tes3mp.GetPosY(compagnonData.pid), posZ = tes3mp.GetPosZ(compagnonData.pid),
			rotX = 0, rotY = 0, rotZ = tes3mp.GetRotZ(compagnonData.pid) + 3.1
		}
		
		if LoadedCells[compagnonData.cell]:ContainsObject(compagnonData.uniqueIndex) then
			logicHandler.DeleteObjectForEveryone(compagnonData.cell, compagnonData.uniqueIndex)
		end

		CreateCompagnon(refId)
	end
end

function CompagnonFunctions.FollowPlayerWarrior(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		
		local mpNum = "98" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum
		
		return compagnonData.uniqueIndex
	end
	
end
--=======
--WIZZARD
--=======
function CompagnonFunctions.CreateWizzard(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		local refId = config.wizzard
		local mpNum = "97" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum

		compagnonData.location = {
			posX = tes3mp.GetPosX(compagnonData.pid) + 100, posY = tes3mp.GetPosY(compagnonData.pid), posZ = tes3mp.GetPosZ(compagnonData.pid),
			rotX = 0, rotY = 0, rotZ = tes3mp.GetRotZ(compagnonData.pid) + 3.1
		}
		
		if LoadedCells[compagnonData.cell]:ContainsObject(compagnonData.uniqueIndex) then
			logicHandler.DeleteObjectForEveryone(compagnonData.cell, compagnonData.uniqueIndex)
		end

		CreateCompagnon(refId)
	end
end

function CompagnonFunctions.FollowPlayerWizzard(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		
		local mpNum = "97" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum
		
		return compagnonData.uniqueIndex
	end
end

return CompagnonFunctions
