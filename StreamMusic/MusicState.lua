--[[
MusicState by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
MusicState script
---------------------------
INSTALLATION:
Save the file as MusicState.lua inside your server/scripts/custom folder.
Save files EcarlateNpc.json and EcarlateCreaIa.json in your custom data folder.
Edits to customScripts.lua
MusicState = require("custom.MusicState")
---------------------------
]]
tableHelper = require("tableHelper")
jsonInterface = require("jsonInterface")

local MusicState = {}

local NpcData = {}
local NpcList = jsonInterface.load("custom/EcarlateNpc.json")
for index, item in pairs(NpcList) do
	if item.figth > 80 then
		table.insert(NpcData, {REFID = string.lower(item.refid)})
	end
end

local CreaList = jsonInterface.load("custom/EcarlateCreaIa.json")
for index, item in pairs(CreaList) do
	if item.figth > 60 then
		table.insert(NpcData, {REFID = string.lower(item.refid)})
	end
end

local Battle = {"Arena", "Assault", "Battle Intro", "MW battle1", "Cimmerians Theme", "MW battle3", "Desperate Measures", "March of beast", "MW battle 7", "MW battle 8"}
local Explore = {"mx_explore_1", "mx_explore_2", "mx_explore_3", "mx_explore_4", "mx_explore_5", "mx_explore_6", "mx_explore_7", "mx_explore_8", "mx_explore_9", "mx_explore_10"}

local TimerMusicBattle = tes3mp.CreateTimer("FunctionMusicBattle", time.seconds(1))
local TimerMusicExplore = tes3mp.CreateTimer("FunctionMusicExplore", time.seconds(1))

local PlayerPid
local MusicPlayerBattle = false

local cfg = {}
cfg.rad = 2000

MusicState.StartCheck = function(eventStatus)
	tes3mp.StartTimer(TimerMusicBattle)
	tes3mp.StartTimer(TimerMusicExplore)	
	tes3mp.LogAppend(enumerations.log.INFO, "....START TIMER MUSICSTATE....")		
end

function FunctionMusicBattle()
	if MusicPlayerBattle == false then
		for pid ,value in pairs(Players) do
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
				local playerPosX = tes3mp.GetPosX(pid)
				local playerPosY = tes3mp.GetPosY(pid)
				local cellDescription = tes3mp.GetCell(pid)
				if LoadedCells[cellDescription] then
					logicHandler.LoadCell(cellDescription)				
					local cell = LoadedCells[cellDescription]	
					if cell ~= nil then
						for _, uniqueIndex in pairs(cell.data.packets.actorList) do
							if cell.data.objectData[uniqueIndex] then
								if cell.data.objectData[uniqueIndex].refId and cell.data.objectData[uniqueIndex].location then
									local creatureRefId = cell.data.objectData[uniqueIndex].refId	
									if tableHelper.containsValue(NpcData, string.lower(creatureRefId), true) then								
										local creaturePosX = cell.data.objectData[uniqueIndex].location.posX
										local creaturePosY = cell.data.objectData[uniqueIndex].location.posY
										local distance = math.sqrt((playerPosX - creaturePosX) * (playerPosX - creaturePosX) + (playerPosY - creaturePosY) * (playerPosY - creaturePosY)) 
										if distance < cfg.rad and not tableHelper.containsValue(cell.data.packets.death, uniqueIndex, true) then
											PlayerPid = pid
											MusicPlayerBattle = true
											break
										end	
									end
								end
							end
						end					
					end
				end
			end
		end
		if MusicPlayerBattle == true and PlayerPid ~= nil then
			if Players[PlayerPid] ~= nil and Players[PlayerPid]:IsLoggedIn() then	
				local rando = math.random(1, 10)
				local BattleMusic 		
				for slot, music in pairs(Battle) do
					if slot == rando then
						BattleMusic = music
					end
				end									
				logicHandler.RunConsoleCommandOnPlayer(PlayerPid, 'Streammusic "battle/'..BattleMusic..'.mp3"', false)
			end
		end		
	end
	tes3mp.RestartTimer(TimerMusicBattle, time.seconds(1))	
end

function FunctionMusicExplore()
	local PlayerSafe = true
	if MusicPlayerBattle == true then
		for pid ,value in pairs(Players) do
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
				PlayerPid = pid
				local playerPosX = tes3mp.GetPosX(pid)
				local playerPosY = tes3mp.GetPosY(pid)
				local cellDescription = tes3mp.GetCell(pid)
				if LoadedCells[cellDescription] then
					logicHandler.LoadCell(cellDescription)				
					local cell = LoadedCells[cellDescription]	
					if cell ~= nil then
						for _, uniqueIndex in pairs(cell.data.packets.actorList) do
							if cell.data.objectData[uniqueIndex] then
								if cell.data.objectData[uniqueIndex].refId and cell.data.objectData[uniqueIndex].location then
									local creatureRefId = cell.data.objectData[uniqueIndex].refId
									if tableHelper.containsValue(NpcData, string.lower(creatureRefId), true) then							
										local creaturePosX = cell.data.objectData[uniqueIndex].location.posX
										local creaturePosY = cell.data.objectData[uniqueIndex].location.posY
										local distance = math.sqrt((playerPosX - creaturePosX) * (playerPosX - creaturePosX) + (playerPosY - creaturePosY) * (playerPosY - creaturePosY)) 
										if distance < cfg.rad and not tableHelper.containsValue(cell.data.packets.death, uniqueIndex, true) then
											PlayerSafe = false
											MusicPlayerBattle = true
											break
										end	
									end
								end
							end
						end					
					end
				end
			end
		end
		if PlayerSafe == true and PlayerPid ~= nil then	
			if Players[PlayerPid] ~= nil and Players[PlayerPid]:IsLoggedIn() then	
				local rando = math.random(1, 10)
				local ExploreMusic 		
				for slot, music in pairs(Explore) do
					if slot == rando then
						ExploreMusic = music
					end
				end		
				logicHandler.RunConsoleCommandOnPlayer(PlayerPid, 'Streammusic "explore/'..ExploreMusic..'.mp3"', false)
				MusicPlayerBattle = false
			end
		end
	end
	tes3mp.RestartTimer(TimerMusicExplore, time.seconds(1))		
end

customEventHooks.registerHandler("OnServerInit", MusicState.StartCheck)

return MusicState
