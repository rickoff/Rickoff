--[[
EventPvp by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Combat pvp en arêne
---------------------------
INSTALLATION:
Save the file as EventPvp.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
EventPvp = require("custom.EventPvp")
---------------------------
]]

tableHelper = require("tableHelper")
inventoryHelper = require("inventoryHelper")

local config = {}

config.timerevent = 60
config.timerstart = 460
config.timerstop = 300
config.countregister = 1000
config.countwinner = 5
config.timerespawn = 5
config.gainxp = 10000
local EventPvp = {}

local TimerStart = tes3mp.CreateTimer("StartEvent", time.seconds(config.timerstart))
local TimerStop = tes3mp.CreateTimer("StopEvent", time.seconds(config.timerstop))

local eventpvp = "inactive"

local pvpTab = { player = {} }

EventPvp.TimerStartEvent = function(eventStatus)
	tes3mp.StartTimer(TimerStart)
	tes3mp.LogAppend(enumerations.log.INFO, "....START TIMER EVENT PVP....")		
end

function StartEvent()
	if tableHelper.getCount(Players) > 0 and eventpvp == "inactive" then
		Playerpid = tableHelper.getAnyValue(Players).pid
		EventPvp.AdminStart(Playerpid)
	else
		tes3mp.RestartTimer(TimerStart, time.seconds(config.timerstart))
	end
end

function StopEvent()
	if tableHelper.getCount(Players) > 0 and eventpvp == "active" then
		Playerpid = tableHelper.getAnyValue(Players).pid
		EventPvp.End(Playerpid)
	else
		tes3mp.RestartTimer(TimerStart, time.seconds(config.timerstart))
	end
end

EventPvp.AdminStart = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local TimerEvent = tes3mp.CreateTimer("StartPvP", time.seconds(config.timerevent))
		local Timerthree = tes3mp.CreateTimer("three", time.seconds(config.timerevent - 3))
		local Timertwo = tes3mp.CreateTimer("two", time.seconds(config.timerevent - 2))
		local Timerone = tes3mp.CreateTimer("one", time.seconds(config.timerevent - 1))
		tes3mp.StartTimer(TimerEvent)
		tes3mp.StartTimer(Timerthree)
		tes3mp.StartTimer(Timertwo)
		tes3mp.StartTimer(Timerone)
		tes3mp.SendMessage(pid,color.Default.."L'événement de"..color.Red.." tournoi"..color.Default.." a été lancé.\nEntrez"..color.Red.." /pvp"..color.White.." pour vous inscrire."..color.Yellow.."\ncoût :"..color.Default.." 1000 pièces d'or.\n",true)
	end
end

EventPvp.Register = function(pid)
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
					tes3mp.SendMessage(pid,"Vous n'avez pas assez d'or pour vous inscrire au tournoi ! \n",false)	
				else
					Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count - newcount	
					tes3mp.SendMessage(pid,"Vous vous êtes inscrit au tournoi pvp !  \n",false)
					pvpTab.player[pid] = {score = 0}
					local itemref = {refId = "gold_001", count = newcount, charge = -1}			
					Players[pid]:Save()
					Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)
					Players[pid].data.customVariables.event	= true						
				end			
			elseif goldLoc == nil then
				tes3mp.SendMessage(pid,"Vous n'avez pas d'or pour vous inscrire au tournois ! \n",false)
			end
		else
			tes3mp.SendMessage(pid,"Vous êtes déjà inscrit dans un autre évènement ! \n",false)
		end			
	end
end

EventPvp.spawnRandom = function(pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		rando1 = math.random(1, 10)
		if rando1 == 1 then
			tes3mp.SetCell(pid, "Elokiel, Arene") 			
			tes3mp.SetPos(pid, 3420, 4300, 12072)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)	
		elseif rando1 == 2 then
			tes3mp.SetCell(pid, "Elokiel, Arene") 			
			tes3mp.SetPos(pid, 5746, 4336, 12435)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)	
		elseif rando1 == 3 then
			tes3mp.SetCell(pid, "Elokiel, Arene") 			
			tes3mp.SetPos(pid, 5013, 3304, 12435)		
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)	
		elseif rando1 == 4 then
			tes3mp.SetCell(pid, "Elokiel, Arene") 			
			tes3mp.SetPos(pid, 4121, 3234, 12439)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)	
		elseif rando1 == 5 then
			tes3mp.SetCell(pid, "Elokiel, Arene") 			
			tes3mp.SetPos(pid, 3274, 3243, 12435)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)	
		elseif rando1 == 6 then
			tes3mp.SetCell(pid, "Elokiel, Arene") 			
			tes3mp.SetPos(pid, 2603, 4335, 12435)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)	
		elseif rando1 == 7 then
			tes3mp.SetCell(pid, "Elokiel, Arene") 			
			tes3mp.SetPos(pid, 2898, 5116, 12435)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)	
		elseif rando1 == 8 then
			tes3mp.SetCell(pid, "Elokiel, Arene") 			
			tes3mp.SetPos(pid, 3905, 5420, 12439)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)	
		elseif rando1 == 9 then
			tes3mp.SetCell(pid, "Elokiel, Arene") 			
			tes3mp.SetPos(pid, 4841, 5396, 12435)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)	
		elseif rando1 == 10 then
			tes3mp.SetCell(pid, "Elokiel, Arene") 			
			tes3mp.SetPos(pid, 4890, 4365, 12072)	
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)	
		end
	end
end

EventPvp.checkcell = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and eventpvp == "active" then 
		local count = 0	
		for pid, pl in pairs(pvpTab.player) do
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
				count = count + 1
			end
		end
		if count >= 2 then	
			for pid1, plr in pairs(Players) do
				if Players[pid1] ~= nil and Players[pid1]:IsLoggedIn() then
					local cell = tes3mp.GetCell(pid1)
					if pvpTab.player[pid1] then
						if cell ~= "Elokiel, Arene" then
							tes3mp.SetCell(pid1, "Elokiel, Arene")             
							tes3mp.SetPos(pid1, 5746, 4336, 12435)
							tes3mp.SendCell(pid1)    
							tes3mp.SendPos(pid1)    
							tes3mp.SendMessage(pid1,"Le tournoi est en cours, retournez au combat !\n",false)
						end
					elseif cell == "Elokiel, Arene" then
						tes3mp.SetCell(pid, "-14,-11")  
						tes3mp.SetPos(pid, -110194, -87041, 249)
						tes3mp.SendCell(pid)    
						tes3mp.SendPos(pid)    
						tes3mp.SendMessage(pid,"Le tournoi est en cours et vous n'etes pas inscrit !\n",false) -- CHANGE THIS
					end
				end
			end
		elseif count == 1 then
			EventPvp.End(pid)
		end
	end   	
end
	
function three()
	for pid, pl in pairs(pvpTab.player) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			tes3mp.SendMessage(pid,"Le combat commence dans"..color.Red.." 3 ...\n",false)
		end
	end
end

function two()
	for pid, pl in pairs(pvpTab.player) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			tes3mp.SendMessage(pid,"Le combat commence dans"..color.Red.." 2 ..\n",false)
		end
	end
end

function one()
	for pid, pl in pairs(pvpTab.player) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			tes3mp.SendMessage(pid,"Le combat commence dans"..color.Red.." 1 .\n",false)
		end
	end
end

function StartPvP()
	local count = 0	
	for pid, pl in pairs(pvpTab.player) do
		count = count + 1
	end
	if count >= 2 then
		for pid, value in pairs(pvpTab.player) do
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
				tes3mp.SendMessage(pid,"Le tournoi à commencé battez vous !\nLe premier à faire "..color.Red.."10 morts"..color.White.." remporte la mise !\nVous avez "..color.Yellow.."10 minutes !\n",false)
				EventPvp.spawnRandom(pid)
			end
		end
		eventpvp = "active"
		tes3mp.StartTimer(TimerStop)		
	else
		for pid, value in pairs(pvpTab.player) do
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
				tes3mp.SendMessage(pid,"Il n'y a pas assez de participant pour commencer le tournoi !  \n",false)	
				Players[pid].data.customVariables.event	= false
			end
		end	
		eventpvp = "inactive"
		tes3mp.RestartTimer(TimerStart, time.seconds(config.timerstart))
	end
end

EventPvp.checkKill = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if eventpvp == "active" and pvpTab.player[pid] ~= nil then
			EventPvp.OnKill(pid)		
			return customEventHooks.makeEventStatus(false,false)
		end
	end
end

EventPvp.OnKill = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local count = 0	
		for pid, pl in pairs(pvpTab.player) do
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
				count = count + 1
			end
		end
		local newprice = config.countregister * count
		if logicHandler.GetPlayerByName(tes3mp.GetDeathReason(pid)) ~= nil then
			local pl = logicHandler.GetPlayerByName(tes3mp.GetDeathReason(pid))
			local newpid = pl.pid	
			if pvpTab.player[newpid] ~= nil then
				local killerPid = tes3mp.GetPlayerKillerPid(pid)
				if pid == killerPid then
					pvpTab.player[newpid].score = pvpTab.player[newpid].score - 1
				else
					pvpTab.player[newpid].score = pvpTab.player[newpid].score + 1
				end
			end
			for pid1, value in pairs(pvpTab.player) do
				if Players[pid1] ~= nil and Players[pid1]:IsLoggedIn() then
					if Players[newpid] ~= nil and Players[newpid]:IsLoggedIn() then
						tes3mp.SendMessage(pid1,Players[newpid].name.." a "..pvpTab.player[newpid].score.." Points !  \n",false)
					end
				end
			end
			for pid2, value in pairs(pvpTab.player) do
				if Players[pid2] ~= nil and Players[pid2]:IsLoggedIn() then
					if value.score >= config.countwinner then			
						tes3mp.SendMessage(pid2,"Le gagnant est "..Players[pid2].name..".\nLe tournoi est fini.  \n",true)
						local goldLoc = inventoryHelper.getItemIndex(Players[pid2].data.inventory, "gold_001", -1)
						if goldLoc == nil then
							tes3mp.SendMessage(pid2,"Vous venez de gagner le tournoi ! \n",false)
							table.insert(Players[pid2].data.inventory, {refId = "gold_001", count = newprice, charge = -1})
						elseif goldLoc ~= nil then
							Players[pid2].data.inventory[goldLoc].count = Players[pid2].data.inventory[goldLoc].count + newprice	
							tes3mp.SendMessage(pid2,"Vous venez de gagner le tournoi !  \n",false)
						end	
						local soulLoc = Players[pid2].data.customVariables.soul
						if soulLoc == nil then
							Players[pid2].data.customVariables.soul = config.gainxp 	
						else
							Players[pid2].data.customVariables.soul = Players[pid2].data.customVariables.soul + config.gainxp 
						end
						tes3mp.MessageBox(pid2, -1, color.Default.. "Vous avez gagné : "..color.Green.. config.gainxp ..color.Default.. " points d'" ..color.Yellow.. "exp.")												
						local itemref = {refId = "gold_001", count = newprice, charge = -1}			
						Players[pid2]:Save()
						Players[pid2]:LoadItemChanges({itemref}, enumerations.inventory.ADD)					
						EventPvp.End(pid2)
					end
				end
			end
			local List = ""
				
			for pid3, value in pairs(pvpTab.player) do
				if pid3 ~= nil then
					if Players[pid3] ~= nil and Players[pid3]:IsLoggedIn() then
						List = List..Players[pid3].name.." a "..tostring(value.score).." Points \n"
					end
				end
			end
			tes3mp.ListBox(pid,333,"Scores:",List)
		end	
		local timer = tes3mp.CreateTimerEx("Revivepvp", time.seconds(config.timerespawn), "i", pid)
		tes3mp.StartTimer(timer)
	end
end

function Revivepvp(pid)	
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		EventPvp.spawnRandom(pid)
		tes3mp.Resurrect(pid,0)
    end	
end

EventPvp.End = function(pid)
	eventpvp = "inactive"
	for pid, value in pairs(pvpTab.player) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
			tes3mp.SendMessage(pid,"L'événement s'est terminé, vous êtes de retour en ville. \n",false)
			tes3mp.SetCell(pid, "-3,-2")  
			tes3mp.SetPos(pid, -23974, -15787, 505)
			tes3mp.SendCell(pid)    
			tes3mp.SendPos(pid)
			Players[pid].data.customVariables.event	= false	
		end
	end
	pvpTab = { player = {} }	
	tes3mp.RestartTimer(TimerStart, time.seconds(config.timerstart))	
end

EventPvp.PlayerConnect = function(eventStatus, pid)
	Players[pid].data.customVariables.event	= false	
end

EventPvp.OnCheckStatePlayer = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and eventpvp == "active" then 
		if pvpTab.player[pid] then
			return customEventHooks.makeEventStatus(false,false)
		end
	end
end

EventPvp.OnDeathTimeExpiration = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and eventpvp == "active" then 
		if pvpTab.player[pid] then
			return customEventHooks.makeEventStatus(false,false)
		end
	end
end

customEventHooks.registerValidator("OnPlayerDeath", EventPvp.checkKill)
customEventHooks.registerValidator("OnDeathTimeExpiration", EventPvp.OnDeathTimeExpiration)
customEventHooks.registerValidator("OnObjectActivate", EventPvp.OnCheckStatePlayer)
customEventHooks.registerHandler("OnPlayerFinishLogin", EventPvp.PlayerConnect)
customEventHooks.registerHandler("OnServerInit", EventPvp.TimerStartEvent)
customEventHooks.registerHandler("OnPlayerCellChange", EventPvp.checkcell)
customCommandHooks.registerCommand("pvp", EventPvp.Register)

return EventPvp
