---------------------------
--[[
CompagnonScript by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Invoquer et donner des ordres a un compagnon
---------------------------
INSTALLATION:
Save the file as CompagnonScript.lua inside your server/scripts/custom folder.

Save the file as MenuComp.lua in server/scripts/menu folder

Edits to customScripts.lua
CompagnonScript = require("custom.CompagnonScript")

Edits to config.lua
add in config.menuHelperFiles, "MenuComp"

add this list on permanent record in server\data\recordstore\npc.json

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

---------------------------  
--]]

local CompagnonScript = {}

local config = {}
config.warrior = "compagnon_guerrier"
config.wizzard = "compagnon_magicien"
config.thief = "compagnon_rodeur"
config.rat = "Rat_pack_rerlas"
config.wolf = "Chien_pack_rerlas"
config.guar = "Guar_pack_rerlas"
config.butterfly = "plx_butterfly"
config.count = 500
local compagnonData = {}
--=========
--FUNCTIONS
--=========
local function CheckSpeedNorth(playerAngle)
	local speedMultiplier = 1
	
	if playerAngle > 0 then
		speedMultiplier = (playerAngle / 1.5) * 15
	else
		speedMultiplier = (playerAngle / -1.5) * 15
	end
	
	return 15 - speedMultiplier
end

local function CheckSpeedEast(playerAngle)
	local speedMultiplier = 1
	
	if playerAngle > 3.0 then
		playerAngle = 3.0
	elseif playerAngle < -3.0 then
		playerAngle = -3.0
	end
	
	if playerAngle >= 0 and playerAngle <= 1.5 then
		speedMultiplier = (playerAngle / 1.5) * 15
	elseif playerAngle > 1.5 then
		speedMultiplier = 15 - (15 * ((playerAngle - 1.5) / 1.5))
	elseif playerAngle >= -1.5 then
		speedMultiplier = (playerAngle / 1.5) * 15
	else
		speedMultiplier = (15 * ((playerAngle + 1.5) / -1.5)) - 15
	end
	
	return speedMultiplier
end


local function CreateCompagnon(refId, pid)

	local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)
	
	if goldLoc ~= nil then	
	
		local goldamount = Players[pid].data.inventory[goldLoc].count
		local newcount = config.count
		if goldamount < newcount then
			tes3mp.SendMessage(compagnonData.pid,"Vous n'avez pas assez d'or pour engager un compagnon ! \n",false)	
		else
			Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count - newcount	
			tes3mp.SendMessage(compagnonData.pid,"Vous venez d'engager un compagnons !  \n",false)
			local itemref = {refId = "gold_001", count = newcount, charge = -1}			
			Players[pid]:SaveToDrive()
			Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)	
			LoadedCells[compagnonData.cell]:InitializeObjectData(compagnonData.uniqueIndex, refId)
			LoadedCells[compagnonData.cell].data.objectData[compagnonData.uniqueIndex].location = compagnonData.location
			table.insert(LoadedCells[compagnonData.cell].data.packets.actorList, compagnonData.uniqueIndex)		
			local objectData = {}
			objectData.refId = refId
			objectData.location = compagnonData.location		
			packetBuilder.AddObjectPlace(compagnonData.uniqueIndex, objectData)		
			tes3mp.SendObjectPlace(true, false)		
			tes3mp.SetPos(compagnonData.pid, compagnonData.location.posX, compagnonData.location.posY, compagnonData.location.posZ)
			tes3mp.SendPos(compagnonData.pid)			
		end	
		
	elseif goldLoc == nil then
		tes3mp.SendMessage(pid,"Vous n'avez pas d'or pour engager un compagnon ! \n",false)
	end		
end

--=====
--THIEF
--=====
function CompagnonScript.CreateThief(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		local refId = config.thief
		local mpNum = "99" .. string.byte(logicHandler.GetChatName(compagnonData.pid))
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum

		compagnonData.location = {
			posX = tes3mp.GetPosX(compagnonData.pid), posY = tes3mp.GetPosY(compagnonData.pid), posZ = tes3mp.GetPosZ(compagnonData.pid),
			rotX = 0, rotY = 0, rotZ = tes3mp.GetRotZ(compagnonData.pid) + 3.1
		}
		
		if LoadedCells[compagnonData.cell]:ContainsObject(compagnonData.uniqueIndex) then
			logicHandler.DeleteObjectForEveryone(compagnonData.cell, compagnonData.uniqueIndex)
		end

		CreateCompagnon(refId, pid)
	end
end

function CompagnonScript.DeleteThief(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		local refId = config.thief
		local mpNum = "99" .. string.byte(logicHandler.GetChatName(compagnonData.pid))
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum

		compagnonData.location = {
			posX = tes3mp.GetPosX(compagnonData.pid), posY = tes3mp.GetPosY(compagnonData.pid), posZ = tes3mp.GetPosZ(compagnonData.pid),
			rotX = 0, rotY = 0, rotZ = tes3mp.GetRotZ(compagnonData.pid) + 3.1
		}
		
		if LoadedCells[compagnonData.cell]:ContainsObject(compagnonData.uniqueIndex) then
			logicHandler.DeleteObjectForEveryone(compagnonData.cell, compagnonData.uniqueIndex)
		end

	end
end

function CompagnonScript.FollowPlayerThief(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		
		local mpNum = "99" .. string.byte(logicHandler.GetChatName(compagnonData.pid))
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum

		targetindex = compagnonData.uniqueIndex	
		local message = "/setai " .. targetindex .. " FOLLOW " .. pid 
		eventHandler.OnPlayerSendMessage(pid, message)		
	end
	
end

function CompagnonScript.CancelPlayerThief(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		
		local mpNum = "99" .. string.byte(logicHandler.GetChatName(compagnonData.pid))
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum

		targetindex = compagnonData.uniqueIndex	
		local message = "/setai " .. targetindex .. " CANCEL " .. pid 
		eventHandler.OnPlayerSendMessage(pid, message)		
	end
	
end
--=======
--WARRIOR
--=======
function CompagnonScript.CreateWarrior(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		local refId = config.warrior
		local mpNum = "98" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum

		compagnonData.location = {
			posX = tes3mp.GetPosX(compagnonData.pid), posY = tes3mp.GetPosY(compagnonData.pid), posZ = tes3mp.GetPosZ(compagnonData.pid),
			rotX = 0, rotY = 0, rotZ = tes3mp.GetRotZ(compagnonData.pid) + 3.1
		}
		
		if LoadedCells[compagnonData.cell]:ContainsObject(compagnonData.uniqueIndex) then
			logicHandler.DeleteObjectForEveryone(compagnonData.cell, compagnonData.uniqueIndex)
		end

		CreateCompagnon(refId, pid)
	end
end

function CompagnonScript.DeleteWarrior(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		local refId = config.warrior
		local mpNum = "98" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum

		compagnonData.location = {
			posX = tes3mp.GetPosX(compagnonData.pid), posY = tes3mp.GetPosY(compagnonData.pid), posZ = tes3mp.GetPosZ(compagnonData.pid),
			rotX = 0, rotY = 0, rotZ = tes3mp.GetRotZ(compagnonData.pid) + 3.1
		}
		
		if LoadedCells[compagnonData.cell]:ContainsObject(compagnonData.uniqueIndex) then
			logicHandler.DeleteObjectForEveryone(compagnonData.cell, compagnonData.uniqueIndex)
		end
		
	end
end

function CompagnonScript.FollowPlayerWarrior(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		
		local mpNum = "98" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum
		
		targetindex = compagnonData.uniqueIndex	
		local message = "/setai " .. targetindex .. " FOLLOW " .. pid 
		eventHandler.OnPlayerSendMessage(pid, message, true)		
	end
	
end

function CompagnonScript.CancelPlayerWarrior(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		
		local mpNum = "98" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum
		
		targetindex = compagnonData.uniqueIndex	
		local message = "/setai " .. targetindex .. " CANCEL " .. pid 
		eventHandler.OnPlayerSendMessage(pid, message, true)		
	end
	
end
--=======
--WIZZARD
--=======
function CompagnonScript.CreateWizzard(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		local refId = config.wizzard
		local mpNum = "97" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum

		compagnonData.location = {
			posX = tes3mp.GetPosX(compagnonData.pid), posY = tes3mp.GetPosY(compagnonData.pid), posZ = tes3mp.GetPosZ(compagnonData.pid),
			rotX = 0, rotY = 0, rotZ = tes3mp.GetRotZ(compagnonData.pid) + 3.1
		}
		
		if LoadedCells[compagnonData.cell]:ContainsObject(compagnonData.uniqueIndex) then
			logicHandler.DeleteObjectForEveryone(compagnonData.cell, compagnonData.uniqueIndex)
		end

		CreateCompagnon(refId, pid)
	end
end

function CompagnonScript.DeleteWizzard(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		local refId = config.wizzard
		local mpNum = "97" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum

		compagnonData.location = {
			posX = tes3mp.GetPosX(compagnonData.pid), posY = tes3mp.GetPosY(compagnonData.pid), posZ = tes3mp.GetPosZ(compagnonData.pid),
			rotX = 0, rotY = 0, rotZ = tes3mp.GetRotZ(compagnonData.pid) + 3.1
		}
		
		if LoadedCells[compagnonData.cell]:ContainsObject(compagnonData.uniqueIndex) then
			logicHandler.DeleteObjectForEveryone(compagnonData.cell, compagnonData.uniqueIndex)
		end
	end
end

function CompagnonScript.FollowPlayerWizzard(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		
		local mpNum = "97" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum
		
		targetindex = compagnonData.uniqueIndex	
		local message = "/setai " .. targetindex .. " FOLLOW " .. pid 
		eventHandler.OnPlayerSendMessage(pid, message)		
	end
end

function CompagnonScript.CancelPlayerWizzard(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		
		local mpNum = "97" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum
		
		targetindex = compagnonData.uniqueIndex	
		local message = "/setai " .. targetindex .. " CANCEL " .. pid 
		eventHandler.OnPlayerSendMessage(pid, message)		
	end
end

--=======
--RATS
--=======
function CompagnonScript.CreateRat(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		local refId = config.rat
		local mpNum = "96" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum

		compagnonData.location = {
			posX = tes3mp.GetPosX(compagnonData.pid), posY = tes3mp.GetPosY(compagnonData.pid), posZ = tes3mp.GetPosZ(compagnonData.pid),
			rotX = 0, rotY = 0, rotZ = tes3mp.GetRotZ(compagnonData.pid) + 3.1
		}
		
		if LoadedCells[compagnonData.cell]:ContainsObject(compagnonData.uniqueIndex) then
			logicHandler.DeleteObjectForEveryone(compagnonData.cell, compagnonData.uniqueIndex)
		end

		CreateCompagnon(refId, pid)
	end
end

function CompagnonScript.DeleteRat(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		local refId = config.rat
		local mpNum = "96" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum

		compagnonData.location = {
			posX = tes3mp.GetPosX(compagnonData.pid), posY = tes3mp.GetPosY(compagnonData.pid), posZ = tes3mp.GetPosZ(compagnonData.pid),
			rotX = 0, rotY = 0, rotZ = tes3mp.GetRotZ(compagnonData.pid) + 3.1
		}
		
		if LoadedCells[compagnonData.cell]:ContainsObject(compagnonData.uniqueIndex) then
			logicHandler.DeleteObjectForEveryone(compagnonData.cell, compagnonData.uniqueIndex)
		end
	end
end

function CompagnonScript.FollowPlayerRat(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		
		local mpNum = "96" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum
		
		targetindex = compagnonData.uniqueIndex	
		local message = "/setai " .. targetindex .. " FOLLOW " .. pid 
		eventHandler.OnPlayerSendMessage(pid, message)		
	end
end

function CompagnonScript.CancelPlayerRat(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		
		local mpNum = "96" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum
		
		targetindex = compagnonData.uniqueIndex	
		local message = "/setai " .. targetindex .. " CANCEL " .. pid 
		eventHandler.OnPlayerSendMessage(pid, message)		
	end
end
--=======
--WOLF	
--=======
function CompagnonScript.CreateWolf(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		local refId = config.wolf
		local mpNum = "95" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum

		compagnonData.location = {
			posX = tes3mp.GetPosX(compagnonData.pid), posY = tes3mp.GetPosY(compagnonData.pid), posZ = tes3mp.GetPosZ(compagnonData.pid),
			rotX = 0, rotY = 0, rotZ = tes3mp.GetRotZ(compagnonData.pid) + 3.1
		}
		
		if LoadedCells[compagnonData.cell]:ContainsObject(compagnonData.uniqueIndex) then
			logicHandler.DeleteObjectForEveryone(compagnonData.cell, compagnonData.uniqueIndex)
		end

		CreateCompagnon(refId, pid)
	end
end

function CompagnonScript.DeleteWolf(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		local refId = config.wolf
		local mpNum = "95" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum

		compagnonData.location = {
			posX = tes3mp.GetPosX(compagnonData.pid), posY = tes3mp.GetPosY(compagnonData.pid), posZ = tes3mp.GetPosZ(compagnonData.pid),
			rotX = 0, rotY = 0, rotZ = tes3mp.GetRotZ(compagnonData.pid) + 3.1
		}
		
		if LoadedCells[compagnonData.cell]:ContainsObject(compagnonData.uniqueIndex) then
			logicHandler.DeleteObjectForEveryone(compagnonData.cell, compagnonData.uniqueIndex)
		end
	end
end

function CompagnonScript.FollowPlayerWolf(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		
		local mpNum = "95" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum
		
		targetindex = compagnonData.uniqueIndex	
		local message = "/setai " .. targetindex .. " FOLLOW " .. pid 
		eventHandler.OnPlayerSendMessage(pid, message)		
	end
end

function CompagnonScript.CancelPlayerWolf(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		
		local mpNum = "95" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum
		
		targetindex = compagnonData.uniqueIndex	
		local message = "/setai " .. targetindex .. " CANCEL " .. pid 
		eventHandler.OnPlayerSendMessage(pid, message)		
	end
end


--=======
--GUAR	
--=======
local timerGuar = tes3mp.CreateTimer("StartMountPlayerGuar", time.seconds(.1))

function StartMountPlayerGuar()
	CompagnonScript.MountPlayerGuar(compagnonData.pid)
end

function CompagnonScript.CreateGuar(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		local refId = config.guar
		local mpNum = "94" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum

		compagnonData.location = {
			posX = tes3mp.GetPosX(compagnonData.pid), posY = tes3mp.GetPosY(compagnonData.pid), posZ = tes3mp.GetPosZ(compagnonData.pid),
			rotX = 0, rotY = 0, rotZ = tes3mp.GetRotZ(compagnonData.pid) + 3.1
		}
		
		if LoadedCells[compagnonData.cell]:ContainsObject(compagnonData.uniqueIndex) then
			logicHandler.DeleteObjectForEveryone(compagnonData.cell, compagnonData.uniqueIndex)
		end

		CreateCompagnon(refId, pid)
	end
end

function CompagnonScript.DeleteGuar(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		local refId = config.guar
		local mpNum = "94" .. string.byte(logicHandler.GetChatName(compagnonData.pid)) --set boat index to 99 + player's name turned to byte, hopefully unique
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum

		compagnonData.location = {
			posX = tes3mp.GetPosX(compagnonData.pid), posY = tes3mp.GetPosY(compagnonData.pid), posZ = tes3mp.GetPosZ(compagnonData.pid),
			rotX = 0, rotY = 0, rotZ = tes3mp.GetRotZ(compagnonData.pid) + 3.1
		}
		
		if LoadedCells[compagnonData.cell]:ContainsObject(compagnonData.uniqueIndex) then
			logicHandler.DeleteObjectForEveryone(compagnonData.cell, compagnonData.uniqueIndex)
		end
	end
end

function CompagnonScript.FollowPlayerGuar(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		
		local mpNum = "94" .. string.byte(logicHandler.GetChatName(compagnonData.pid))
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum
		
		targetindex = compagnonData.uniqueIndex	
		local message = "/setai " .. targetindex .. " FOLLOW " .. pid 
		eventHandler.OnPlayerSendMessage(pid, message)		
	end
end

function CompagnonScript.CancelPlayerGuar(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		
		local mpNum = "94" .. string.byte(logicHandler.GetChatName(compagnonData.pid))
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum
		
		targetindex = compagnonData.uniqueIndex	
		local message = "/setai " .. targetindex .. " CANCEL " .. pid 
		eventHandler.OnPlayerSendMessage(pid, message)		
	end
end
--[[
function CompagnonScript.MountPlayerGuar(pid)
    if Players[pid]:IsLoggedIn() then
		local CellDescription = tes3mp.GetCell(pid)
		compagnonData.pid = pid	
		local guarIndex = 0 .. "-" .. "94" .. string.byte(logicHandler.GetChatName(pid))
		local mpNum = "94" .. string.byte(logicHandler.GetChatName(pid))		
		local cell = LoadedCells[CellDescription]		
		if LoadedCells[CellDescription] ~= nil then
            for uniqueIndex, x in pairs(cell.data.objectData) do
				local shouldMove = Players[pid].data.customVariables.shouldMove
				if uniqueIndex == guarIndex then			
					local locationGuar = {
						posX = cell.data.objectData[uniqueIndex].location.posX,
						posY = cell.data.objectData[uniqueIndex].location.posY,
						posZ = cell.data.objectData[uniqueIndex].location.posZ,
						rotX = cell.data.objectData[uniqueIndex].location.rotX,
						rotY = cell.data.objectData[uniqueIndex].location.rotY,
						rotZ = cell.data.objectData[uniqueIndex].location.rotZ
					}	
					local playerAngle = tes3mp.GetRotZ(pid)
					local playerCell = tes3mp.GetCell(pid)
					local refId = cell.data.objectData[uniqueIndex].refId
					local boatX = 0
					local boatY = 0

					boatY = CheckSpeedNorth(playerAngle)
					boatX = CheckSpeedEast(playerAngle)
					
					local message = "/setai " .. uniqueIndex .. " TRAVEL " .. (locationGuar.posX + boatX) .. " " .. (locationGuar.posY + boatY) .. " " .. locationGuar.posZ 					
					eventHandler.OnPlayerSendMessage(pid, message)
					local locationGuarAi = {
						posX = cell.data.objectData[uniqueIndex].ai.posX,
						posY = cell.data.objectData[uniqueIndex].ai.posY,
						posZ = cell.data.objectData[uniqueIndex].ai.posZ
					}						
					tes3mp.SetCell(pid, CellDescription) 			
					tes3mp.SetPos(pid, tonumber(locationGuarAi.posX), tonumber(locationGuarAi.posY), tonumber(locationGuar.posZ) + 100, tonumber(locationGuar.rotX), tonumber(locationGuar.rotY), tonumber(playerAngle) + 3.1)
					tes3mp.SendCell(pid)    
					tes3mp.SendPos(pid)
					cell.data.objectData[uniqueIndex].location.posX = cell.data.objectData[uniqueIndex].ai.posX
					cell.data.objectData[uniqueIndex].location.posY = cell.data.objectData[uniqueIndex].ai.posY
					cell.data.objectData[uniqueIndex].location.posZ	= cell.data.objectData[uniqueIndex].ai.posZ
					cell.data.objectData[uniqueIndex].location.rotX = cell.data.objectData[uniqueIndex].location.posX
					cell.data.objectData[uniqueIndex].location.rotY = 0
					cell.data.objectData[uniqueIndex].location.rotZ	= playerAngle + 3.1
					cell:Save()				
					if shouldMove == true then
						tes3mp.RestartTimer(timerGuar, time.seconds(0.1))
					else
						tes3mp.StopTimer(timerGuar)
					end
				end
            end		
		end
	end
end

function CompagnonScript.MoveGuar(pid)
	local shouldMove = Players[pid].data.customVariables.shouldMove		
	if shouldMove == nil then
		Players[pid].data.customVariables.shouldMove = true
		shouldMove = Players[pid].data.customVariables.shouldMove
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->tcl")		
	else
		Players[pid].data.customVariables.shouldMove = true	
		shouldMove = true				
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->tcl")
	end
	tes3mp.StartTimer(timerGuar)
end

function CompagnonScript.StopGuar(pid)
	local shouldMove = Players[pid].data.customVariables.shouldMove		
	if shouldMove == nil then
		Players[pid].data.customVariables.shouldMove = false
		shouldMove = Players[pid].data.customVariables.shouldMove
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->tcl")		
	else
		shouldMove = false	
		Players[pid].data.customVariables.shouldMove = false		
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->tcl")
	end
end	
]]				
--=====
--BUTTERFLY
--=====
function CompagnonScript.CreateButterfly(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		local refId = config.butterfly
		local mpNum = "93" .. string.byte(logicHandler.GetChatName(compagnonData.pid))
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum

		compagnonData.location = {
			posX = tes3mp.GetPosX(compagnonData.pid), posY = tes3mp.GetPosY(compagnonData.pid), posZ = tes3mp.GetPosZ(compagnonData.pid),
			rotX = 0, rotY = 0, rotZ = tes3mp.GetRotZ(compagnonData.pid) + 3.1
		}
		
		if LoadedCells[compagnonData.cell]:ContainsObject(compagnonData.uniqueIndex) then
			logicHandler.DeleteObjectForEveryone(compagnonData.cell, compagnonData.uniqueIndex)
		end

		CreateCompagnon(refId, pid)
	end
end

function CompagnonScript.DeleteButterfly(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		local refId = config.Butterfly
		local mpNum = "93" .. string.byte(logicHandler.GetChatName(compagnonData.pid))
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum

		compagnonData.location = {
			posX = tes3mp.GetPosX(compagnonData.pid), posY = tes3mp.GetPosY(compagnonData.pid), posZ = tes3mp.GetPosZ(compagnonData.pid),
			rotX = 0, rotY = 0, rotZ = tes3mp.GetRotZ(compagnonData.pid) + 3.1
		}
		
		if LoadedCells[compagnonData.cell]:ContainsObject(compagnonData.uniqueIndex) then
			logicHandler.DeleteObjectForEveryone(compagnonData.cell, compagnonData.uniqueIndex)
		end

	end
end

function CompagnonScript.FollowPlayerButterfly(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		
		local mpNum = "93" .. string.byte(logicHandler.GetChatName(compagnonData.pid))
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum
		
		targetindex = compagnonData.uniqueIndex	
		local message = "/setai " .. targetindex .. " FOLLOW " .. pid 
		eventHandler.OnPlayerSendMessage(pid, message)		
	end
	
end

function CompagnonScript.CancelPlayerButterfly(pid)

    if Players[pid]:IsLoggedIn() then
		compagnonData.pid = pid
		compagnonData.cell = tes3mp.GetCell(compagnonData.pid)
		
		local mpNum = "93" .. string.byte(logicHandler.GetChatName(compagnonData.pid))
		compagnonData.uniqueIndex = 0 .. "-" .. mpNum
		
		targetindex = compagnonData.uniqueIndex	
		local message = "/setai " .. targetindex .. " CANCEL " .. pid 
		eventHandler.OnPlayerSendMessage(pid, message)		
	end
	
end

function CompagnonScript.StartMenu(pid)
    if Players[pid]~= nil and Players[pid]:IsLoggedIn() then
		Players[pid].currentCustomMenu = "menu compagnons"
		menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
	end
end

customCommandHooks.registerCommand("appeler_warrior", CompagnonScript.CreateWarrior)
customCommandHooks.registerCommand("appeler_wizzard", CompagnonScript.CreateWizzard)
customCommandHooks.registerCommand("appeler_thief", CompagnonScript.CreateThief)
customCommandHooks.registerCommand("suivre_warrior", CompagnonScript.FollowPlayerWarrior)
customCommandHooks.registerCommand("suivre_wizzard", CompagnonScript.FollowPlayerWizzard)
customCommandHooks.registerCommand("suivre_thief", CompagnonScript.FollowPlayerThief)
customCommandHooks.registerCommand("stop_warrior", CompagnonScript.CancelPlayerWarrior)
customCommandHooks.registerCommand("stop_wizzard", CompagnonScript.CancelPlayerWizzard)
customCommandHooks.registerCommand("stop_thief", CompagnonScript.CancelPlayerThief)
customCommandHooks.registerCommand("renvoyer_warrior", CompagnonScript.DeleteWarrior)
customCommandHooks.registerCommand("renvoyer_wizzard", CompagnonScript.DeleteWizzard)
customCommandHooks.registerCommand("renvoyer_thief", CompagnonScript.DeleteThief)
customCommandHooks.registerCommand("appeler_rat", CompagnonScript.CreateRat)
customCommandHooks.registerCommand("appeler_chien", CompagnonScript.CreateWolf)
customCommandHooks.registerCommand("appeler_guar", CompagnonScript.CreateGuar)
customCommandHooks.registerCommand("appeler_butter", CompagnonScript.CreateButterfly)
customCommandHooks.registerCommand("suivre_rat", CompagnonScript.FollowPlayerRat)
customCommandHooks.registerCommand("suivre_chien", CompagnonScript.FollowPlayerWolf)
customCommandHooks.registerCommand("suivre_guar", CompagnonScript.FollowPlayerGuar)
customCommandHooks.registerCommand("suivre_butter", CompagnonScript.FollowPlayerButterfly)
customCommandHooks.registerCommand("stop_rat", CompagnonScript.CancelPlayerRat)
customCommandHooks.registerCommand("stop_chien", CompagnonScript.CancelPlayerWolf)
customCommandHooks.registerCommand("stop_guar", CompagnonScript.CancelPlayerGuar)
customCommandHooks.registerCommand("stop_butter", CompagnonScript.CancelPlayerButterfly)
customCommandHooks.registerCommand("renvoyer_rat", CompagnonScript.DeleteRat)
customCommandHooks.registerCommand("renvoyer_chien", CompagnonScript.DeleteWolf)
customCommandHooks.registerCommand("renvoyer_guar", CompagnonScript.DeleteGuar)
customCommandHooks.registerCommand("renvoyer_butter", CompagnonScript.DeleteButterfly)
customCommandHooks.registerCommand("menucomp", CompagnonScript.StartMenu)

return CompagnonScript
