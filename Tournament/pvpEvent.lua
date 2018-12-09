--pvpEvent.lua

tableHelper = require("tableHelper")
inventoryHelper = require("inventoryHelper")
jsonInterface = require("jsonInterface")


local config = {}

config.timerevent = 60
config.timerstart = 450
config.timerstop = 300
config.countregister = 1000
config.countwinner = 3
config.timerespawn = 10

local pvpEvent = {}

local TimerStart = tes3mp.CreateTimer("StartEvent", time.seconds(config.timerstart))
local TimerStop = tes3mp.CreateTimer("StopEvent", time.seconds(config.timerstop))

local eventpvp = "inactive"

local pvpTab = { player = {} }

pvpEvent.TimerStartEvent = function()
	tes3mp.StartTimer(TimerStart)
	tes3mp.LogAppend(enumerations.log.INFO, "....START TIMER EVENT PVP....")		
end

function StartEvent()
	if tableHelper.getCount(Players) > 0 then
		Playerpid = tableHelper.getAnyValue(Players).pid
		pvpEvent.AdminStart(Playerpid)
	else
		tes3mp.RestartTimer(TimerStart, time.seconds(config.timerstart))
	end
end

function StopEvent()
	if tableHelper.getCount(Players) > 0 and eventrush == "active" then
		Playerpid = tableHelper.getAnyValue(Players).pid
		pvpEvent.End(Playerpid)
	else
		tes3mp.RestartTimer(TimerStart, time.seconds(config.timerstart))
	end
end

pvpEvent.AdminStart = function(pid)
	local TimerEvent = tes3mp.CreateTimer("StartPvP", time.seconds(config.timerevent))
	local Timerthirty = tes3mp.CreateTimer("CallforPvP", time.seconds(config.timerevent / 2))
	local Timerthree = tes3mp.CreateTimer("three", time.seconds(config.timerevent - 3))
	local Timertwo = tes3mp.CreateTimer("two", time.seconds(config.timerevent - 2))
	local Timerone = tes3mp.CreateTimer("one", time.seconds(config.timerevent - 1))
	tes3mp.StartTimer(TimerEvent)
	tes3mp.StartTimer(Timerthirty)
	tes3mp.StartTimer(Timerthree)
	tes3mp.StartTimer(Timertwo)
	tes3mp.StartTimer(Timerone)
	tes3mp.SendMessage(pid,color.Default.."L'événement de"..color.Red.." tournoi"..color.Default.." a été lancé."..color.Yellow.."Tout le monde a 60 secondes, pour s'inscrire tapez /pvp"..color.Yellow.." coût:"..color.Default.." 1000 pièces d'or.\n",true)
end


pvpEvent.Register = function(pid)

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
		end	
		
	elseif goldLoc == nil then
		tes3mp.SendMessage(pid,"Vous n'avez pas d'or pour vous inscrire au tournois ! \n",false)
	end
	
end

pvpEvent.spawnRandom = function(pid)
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

pvpEvent.tcheckcell = function(pid)

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and eventpvp == "active" then        
		for pid1, plr in pairs(Players) do
			if plr:IsLoggedIn() then
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
	end   
	
end

function CallforPvP()
	for p , pl in pairs(Players) do
		tes3mp.SendMessage(p,"Il ne vous reste que"..color.Yellow.." 30"..color.Default.." secondes pour vous inscrire au tournoi. Utilisez"..color.Red.." /pvp"..color.Default..", cout:1000 pièces d'or.\n",false)
	end
end
	
function three()
	for pid, pl in pairs(pvpTab.player) do
		tes3mp.SendMessage(pid,"La course commence dans"..color.Red.." 3 ...\n",false)
	end
end

function two()
	for pid, pl in pairs(pvpTab.player) do
		tes3mp.SendMessage(pid,"La course commence dans"..color.Red.." 2 ..\n",false)
	end
end

function one()
	for pid, pl in pairs(pvpTab.player) do
		tes3mp.SendMessage(pid,"La course commence dans"..color.Red.." 1 .\n",false)
	end
end

function StartPvP()

	local count = 0
	
	for pid, pl in pairs(pvpTab.player) do
		count = count + 1
	end

	if count >= 2 then
		for pid, value in pairs(pvpTab.player) do
			tes3mp.SendMessage(pid,"Le tournoi à commencé battez vous ! Le premier à faire 5 morts remporte la mise ! Vous avez 10 minutes !\n",false)
			pvpEvent.spawnRandom(pid) 			
		end
		eventpvp = "active"
		tes3mp.StartTimer(TimerStop)		
	else
		for pid, value in pairs(pvpTab.player) do
			tes3mp.SendMessage(pid,"Il n'y a pas assez de participant pour commencer le tournoi !  \n",false)	
		end	
		eventpvp = "inactive"
		tes3mp.RestartTimer(TimerStart, time.seconds(config.timerstart))
	end
end

pvpEvent.TcheckKill = function(pid)

	if eventpvp == "active" and pvpTab.player[pid] ~= nil then
		pvpEvent.OnKill(pid)
	else
		return false
	end	
	
end

pvpEvent.OnKill = function(pid)

	local count = 0
	
	for pid, pl in pairs(pvpTab.player) do
		count = count + 1
	end

	local newprice = config.countregister * count

	if logicHandler.GetPlayerByName(tes3mp.GetDeathReason(pid)) ~= nil then

		local pl = logicHandler.GetPlayerByName(tes3mp.GetDeathReason(pid))
		local newpid = pl.pid
		
		if pvpTab.player[newpid] ~= nil then
			pvpTab.player[newpid].score = pvpTab.player[newpid].score + 1
		end


		for pid, value in pairs(pvpTab.player) do
			tes3mp.SendMessage(pid,Players[newpid].name.." a "..pvpTab.player[newpid].score.." Points !  \n",false)
		end

		for pid, value in pairs(pvpTab.player) do
			if value.score >= config.countwinner then			
				tes3mp.SendMessage(pid,"Le gagnant est "..Players[pid].name..". Le tournoi est fini.  \n",true)
				local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)
				if goldLoc == nil then
					tes3mp.SendMessage(pid,"Vous venez de gagner le tournoi ! \n",false)
					table.insert(Players[pid].data.inventory, {refId = "gold_001", count = newprice, charge = -1})
				else
					Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count + newprice	
					tes3mp.SendMessage(pid,"Vous venez de gagner le tournoi !  \n",false)
				end				
				local itemref = {refId = "gold_001", count = newprice, charge = -1}			
				Players[pid]:Save()
				Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)					
				pvpEvent.End(pid)
			end
		end

		local List = ""
			
		for pid, value in pairs(pvpTab.player) do
			List = List..Players[pid].name.." a "..tostring(value.score).." Points \n"
		end

		tes3mp.ListBox(pid,333,"Scores:",List)
	end
	
	local timer = tes3mp.CreateTimerEx("Revive", time.seconds(config.timerespawn), "i", pid)
	tes3mp.StartTimer(timer)	
end

function Revive(pid)
	
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
        tes3mp.Resurrect(pid,0)
		pvpEvent.spawnRandom(pid)
    end
	
end

pvpEvent.End = function(pid)

	eventpvp = "inactive"

	for pid, value in pairs(pvpTab.player) do
		tes3mp.SendMessage(pid,"L'événement s'est terminé, vous êtes de retour en ville.  \n",false)
		tes3mp.SetCell(pid, "-3,-2")  
		tes3mp.SetPos(pid, -23974, -15787, 505)
		tes3mp.SendCell(pid)    
		tes3mp.SendPos(pid)			
	end

	pvpTab = { player = {} }
	
	tes3mp.RestartTimer(TimerStart, time.seconds(config.timerstart))	
end

return pvpEvent
