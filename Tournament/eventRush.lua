--[[
EventRush by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Course pvp sur parcour aléatoire
---------------------------
INSTALLATION:
Save the file as EventRush.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
EventRush = require("custom.EventRush")
---------------------------
]]

tableHelper = require("tableHelper")
inventoryHelper = require("inventoryHelper")

local config = {}

config.timereventrush = 60
config.rushstart = 300
config.rushstop = 150
config.countregister = 100
config.timerespawn = 3
config.timerstand = 15
config.gainxp = 2500
config.listCell = {"-2, 2", "0, -7", "2, 5", "15, 1", "12, 13"}

local EventRush = {}

local RushStart = tes3mp.CreateTimer("RushEvent", time.seconds(config.rushstart))
local RushStop = tes3mp.CreateTimer("StopRush", time.seconds(config.rushstop))
local TimerRush = tes3mp.CreateTimer("StartRush", time.seconds(config.timerstand))

local rushRandom = nil

local eventrush = "inactive"

local rushTab = { player = {} }

EventRush.TimerStartEvent = function(eventStatus)
	tes3mp.StartTimer(RushStart)
	tes3mp.LogAppend(enumerations.log.INFO, "....START TIMER EVENT RUSH....")		
end

function RushEvent()
	if tableHelper.getCount(Players) > 0 and eventrush == "inactive" then
		Playerpid = tableHelper.getAnyValue(Players).pid
		EventRush.AdminStart(Playerpid)
		rushRandom = math.random(1, 5)
	else
		tes3mp.RestartTimer(RushStart, time.seconds(config.rushstart))
	end
end

function StopRush()
	if tableHelper.getCount(Players) > 0 and eventrush == "active" then
		Playerpid = tableHelper.getAnyValue(Players).pid
		EventRush.End(Playerpid)
	else
		tes3mp.RestartTimer(RushStart, time.seconds(config.rushstart))
	end
end

function StartRush()
	if tableHelper.getCount(Players) > 0 and eventrush == "active" then
		for pid, value in pairs(rushTab.player) do
			logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerControls")
			logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerFighting")
		end
	end
end

EventRush.AdminStart = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local timereventrush = tes3mp.CreateTimer("StartR", time.seconds(config.timereventrush))
		local Timerthree = tes3mp.CreateTimer("threeR", time.seconds((config.timereventrush + config.timerstand) - 3))
		local Timertwo = tes3mp.CreateTimer("twoR", time.seconds((config.timereventrush + config.timerstand) - 2))
		local Timerone = tes3mp.CreateTimer("oneR", time.seconds((config.timereventrush + config.timerstand) - 1))
		local Timerzero = tes3mp.CreateTimer("zeroR", time.seconds(config.timereventrush + config.timerstand))	
		tes3mp.StartTimer(timereventrush)
		tes3mp.StartTimer(Timerthree)
		tes3mp.StartTimer(Timertwo)
		tes3mp.StartTimer(Timerone)
		tes3mp.StartTimer(Timerzero)	
		tes3mp.SendMessage(pid,color.White.."L'événement de"..color.Red.." rush"..color.White.." a été lancé.\nEntrez"..color.Red.." /rush"..color.White.." pour vous inscrire"..color.Yellow.."\ncoût :"..color.White.." 100 pièces d'or.\n",true)
	end
end


EventRush.Register = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local checkevent = Players[pid].data.customVariables.event	
		if checkevent == nil then
			Players[pid].data.customVariables.event = false
		end	
		local event = Players[pid].data.customVariables.event
		if event == false then	
			local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)
			
			if goldLoc ~= nil then
				local goldamount = Players[pid].data.inventory[goldLoc].count
				local newcount = config.countregister
				if goldamount < newcount then
					tes3mp.SendMessage(pid,"Vous n'avez pas assez d'or pour vous inscrire a la course ! \n",false)	
				else
					Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count - newcount	
					tes3mp.SendMessage(pid,"Vous vous êtes inscrit au prochain rush !  \n",false)
					rushTab.player[pid] = {score = 0}
					local itemref = {refId = "gold_001", count = newcount, charge = -1}			
					Players[pid]:SaveToDrive()
					Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)
					Players[pid].data.customVariables.event	= true						
				end	
				
			elseif goldLoc == nil then
				tes3mp.SendMessage(pid,"Vous n'avez pas d'or pour vous inscrire a la course ! \n",false)
			end
		else
			tes3mp.SendMessage(pid,"Vous êtes déjà inscrit dans un autre évènement ! \n",false)
		end				
	end
end

EventRush.spawn = function(pid)
    if Players[pid] ~= nil and rushRandom ~= nil and Players[pid]:IsLoggedIn() then
		if rushRandom == 1 then
			local posx = -19606
			local posy = -9303
			local posz = 182		
			tes3mp.SetCell(pid, "-3, -2") 			
			tes3mp.SetPos(pid, posx, posy, posz)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)
		elseif rushRandom == 2 then
			local posx = -3768
			local posy = -71753
			local posz = 178	
			tes3mp.SetCell(pid, "-1, -9") 			
			tes3mp.SetPos(pid, posx, posy, posz)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)	
		elseif rushRandom == 3 then
			local posx = 4847
			local posy = 17930
			local posz = 1609		
			tes3mp.SetCell(pid, "0, 2") 			
			tes3mp.SetPos(pid, posx, posy, posz)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)	
		elseif rushRandom == 4 then
			local posx = 147200
			local posy = 34979
			local posz = 1298		
			tes3mp.SetCell(pid, "17, 4") 			
			tes3mp.SetPos(pid, posx, posy, posz)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)	
		elseif rushRandom == 5 then
			local posx = 77095
			local posy = 87327
			local posz = 879		
			tes3mp.SetCell(pid, "9, 10") 			
			tes3mp.SetPos(pid, posx, posy, posz)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)				
		end
	end
end

EventRush.checkcell = function(eventStatus, pid)

	local count = 0
	
	for pid, pl in pairs(rushTab.player) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			count = count + 1
		end
	end

	local newprice = config.countregister * count
	
	if Players[pid] ~= nil and rushRandom ~= nil and Players[pid]:IsLoggedIn() and eventrush == "active" then        
		for pid1, plr in pairs(Players) do
			if plr:IsLoggedIn() then
				local cell = tes3mp.GetCell(pid1)
				if rushTab.player[pid1] then
					if tableHelper.containsValue(config.listCell, cell) then
						tes3mp.SendMessage(pid,"Le gagnant est "..color.Yellow..Players[pid].name..color.Default..".\nLa course est fini.  \n",true)
						local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)
						if goldLoc == nil then
							tes3mp.SendMessage(pid,"Vous venez de gagner la course ! \n",false)
							table.insert(Players[pid].data.inventory, {refId = "gold_001", count = newprice, charge = -1})
						else
							Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count + newprice	
							tes3mp.SendMessage(pid,"Vous venez de gagner la course !  \n",false)
						end	
						local soulLoc = Players[pid].data.customVariables.soul
						if soulLoc == nil then
							Players[pid].data.customVariables.soul = config.gainxp 	
						else
							Players[pid].data.customVariables.soul = Players[pid].data.customVariables.soul + config.gainxp 
						end
						tes3mp.MessageBox(pid, -1, color.Default.. "Vous avez gagné : "..color.Green.. config.gainxp ..color.Default.. " points d'" ..color.Yellow.. "exp.")																		
						local itemref = {refId = "gold_001", count = newprice, charge = -1}			
						Players[pid]:SaveToDrive()
						Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)					
						EventRush.End(pid)
					end
				end
			end
		end
	end   	
end
	
function threeR()
	for pid, value in pairs(rushTab.player) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			tes3mp.SendMessage(pid,"La course commence dans"..color.Red.." 3 ...\n",false)
		end
	end
end
function twoR()
	for pid, value in pairs(rushTab.player) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			tes3mp.SendMessage(pid,"La course commence dans"..color.Red.." 2 ..\n",false)
		end
	end
end

function oneR()
	for pid, value in pairs(rushTab.player) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			tes3mp.SendMessage(pid,"La course commence dans"..color.Red.." 1 .\n",false)
		end
	end
end

function zeroR()
	for pid, value in pairs(rushTab.player) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			tes3mp.SendMessage(pid,color.Red.."Ruuuusssshhhh !!!!!\n",false)
		end	
	end
end

function StartR()

	local count = 0
	
	for pid, pl in pairs(rushTab.player) do
		count = count + 1
	end

	if count >= 2 then
		for pid, value in pairs(rushTab.player) do	
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
				if rushRandom == 1 then
					tes3mp.SendMessage(pid,"La course va commencer !"..color.Red.." preparez vous !"..color.Default.."\nLe premier à "..color.Red.."Caldera "..color.White.."remporte la mise !\n",false)
				elseif rushRandom == 2 then	
					tes3mp.SendMessage(pid,"La course va commencer !"..color.Red.." preparez vous !"..color.Default.."\nLe premier à "..color.Red.."Pelagiad "..color.White.."remporte la mise !\n",false)			
				elseif rushRandom == 3 then	
					tes3mp.SendMessage(pid,"La course va commencer !"..color.Red.." preparez vous !"..color.Default.."\nLe premier à "..color.Red.."la Porte des âmes "..color.White.."remporte la mise !\n",false)			
				elseif rushRandom == 4 then	
					tes3mp.SendMessage(pid,"La course va commencer !"..color.Red.." preparez vous !"..color.Default.."\nLe premier à "..color.Red.."Tel Fyr "..color.White.."remporte la mise !\n",false)			
				elseif rushRandom == 5 then	
					tes3mp.SendMessage(pid,"La course va commencer !"..color.Red.." preparez vous !"..color.Default.."\nLe premier à "..color.Red.."Vos "..color.White.."remporte la mise !\n",false)			
				end
				EventRush.spawn(pid) 
				logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerControls")					
				logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerFighting")			
				logicHandler.RunConsoleCommandOnPlayer(pid, "DisableTeleporting")
				logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerJumping")	
			end
		end
		eventrush = "active" 
		tes3mp.StartTimer(TimerRush)		
		tes3mp.StartTimer(RushStop)		
	else
		for pid, value in pairs(rushTab.player) do
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then		
				tes3mp.SendMessage(pid,"Il n'y a pas assez de participant pour commencer la course !\n",false)
				Players[pid].data.customVariables.event	= false
			end
		end	
		eventrush = "inactive"
		tes3mp.RestartTimer(RushStart, time.seconds(config.rushstart))
	end
end

EventRush.checkKill = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if eventrush == "active" and rushTab.player[pid] ~= nil then
			EventRush.OnKill(pid)		
			return customEventHooks.makeEventStatus(false,false)
		end	
	end
end

EventRush.OnKill = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local timer = tes3mp.CreateTimerEx("Reviverush", time.seconds(config.timerespawn), "i", pid)
		tes3mp.StartTimer(timer)
	end
end

function Reviverush(pid)	
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
        tes3mp.Resurrect(pid,0)
    end	
end

EventRush.End = function(pid)

	eventrush = "inactive"
	
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		for pid, value in pairs(rushTab.player) do
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
				tes3mp.SendMessage(pid,color.Blue.."L'événement s'est terminé, vous êtes de retour en ville.  \n",false)
				tes3mp.SetCell(pid, "-3,-2")  
				tes3mp.SetPos(pid, -23974, -15787, 505)
				tes3mp.SendCell(pid)    
				tes3mp.SendPos(pid)	
				logicHandler.RunConsoleCommandOnPlayer(pid, "EnableTeleporting")
				logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerJumping")
				Players[pid].data.customVariables.event	= false	
			end
		end
	end

	rushTab = { player = {} }
	
	tes3mp.RestartTimer(RushStart, time.seconds(config.rushstart))	
end

EventRush.PlayerConnect = function(eventStatus, pid)
	Players[pid].data.customVariables.event	= false	
end

EventRush.OnCheckStatePlayer = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and eventrush == "active" then 
		if rushTab.player[pid] then
			return customEventHooks.makeEventStatus(false,false)
		end
	end
end

EventRush.OnDeathTimeExpiration = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and eventrush == "active" then 
		if rushTab.player[pid] then
			return customEventHooks.makeEventStatus(false,false)
		end
	end
end

customEventHooks.registerHandler("OnPlayerFinishLogin", EventRush.PlayerConnect)
customEventHooks.registerHandler("OnServerInit", EventRush.TimerStartEvent)
customEventHooks.registerHandler("OnPlayerCellChange", EventRush.checkcell)
customEventHooks.registerValidator("OnPlayerDeath", EventRush.checkKill)
customEventHooks.registerValidator("OnDeathTimeExpiration", EventRush.OnDeathTimeExpiration)
customEventHooks.registerValidator("OnObjectActivate", EventRush.OnCheckStatePlayer)
customCommandHooks.registerCommand("rush", EventRush.Register)

return EventRush
