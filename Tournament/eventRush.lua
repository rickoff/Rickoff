--eventRush.lua

tableHelper = require("tableHelper")
inventoryHelper = require("inventoryHelper")
jsonInterface = require("jsonInterface")


local config = {}

config.timerevent = 60
config.timerstart = 300
config.timerstop = 150
config.countregister = 100
config.timerespawn = 3
config.timerstand = 10

local eventRush = {}

local TimerStart = tes3mp.CreateTimer("StartEvent", time.seconds(config.timerstart))
local TimerStop = tes3mp.CreateTimer("StopEvent", time.seconds(config.timerstop))
local TimerRush = tes3mp.CreateTimer("StartRush", time.seconds(config.timerstand))

local eventrush = "inactive"

local rushTab = { player = {} }

eventRush.TimerStartEvent = function()
	tes3mp.StartTimer(TimerStart)
	tes3mp.LogAppend(enumerations.log.INFO, "....START TIMER EVENT RUSH....")		
end

function StartEvent()
	if tableHelper.getCount(Players) > 0 then
		Playerpid = tableHelper.getAnyValue(Players).pid
		eventRush.AdminStart(Playerpid)
	else
		tes3mp.RestartTimer(TimerStart, time.seconds(config.timerstart))
	end
end

function StopEvent()
	if tableHelper.getCount(Players) > 0 and eventrush == "active" then
		Playerpid = tableHelper.getAnyValue(Players).pid
		eventRush.End(Playerpid)
	else
		tes3mp.RestartTimer(TimerStart, time.seconds(config.timerstart))
	end
end

function StartRush()
	if tableHelper.getCount(Players) > 0 and eventrush == "active" then
		Playerpid = tableHelper.getAnyValue(Players).pid
		logicHandler.RunConsoleCommandOnPlayer(Playerpid, "EnablePlayerControls")
		logicHandler.RunConsoleCommandOnPlayer(Playerpid, "EnablePlayerFighting")
	end
end

eventRush.AdminStart = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local TimerEvent = tes3mp.CreateTimer("StartPvP", time.seconds(config.timerevent))
		local Timerthirty = tes3mp.CreateTimer("CallforPvP", time.seconds(config.timerevent / 2))
		local Timerthree = tes3mp.CreateTimer("three", time.seconds((config.timerevent + config.timerstand) - 3))
		local Timertwo = tes3mp.CreateTimer("two", time.seconds((config.timerevent + config.timerstand) - 2))
		local Timerone = tes3mp.CreateTimer("one", time.seconds((config.timerevent + config.timerstand) - 1))
		local Timerzero = tes3mp.CreateTimer("zero", time.seconds(config.timerevent + config.timerstand))	
		tes3mp.StartTimer(TimerEvent)
		tes3mp.StartTimer(Timerthirty)
		tes3mp.StartTimer(Timerthree)
		tes3mp.StartTimer(Timertwo)
		tes3mp.StartTimer(Timerone)
		tes3mp.StartTimer(Timerzero)	
		tes3mp.SendMessage(pid,color.Default.."L'événement de"..color.Red.." rush"..color.Default.." a été lancé."..color.Yellow.."Tout le monde a 60 secondes pour s'inscrire. Taper /rush"..color.Yellow.." coût:"..color.Default.." 100 pièces d'or.\n",true)
	end
end


eventRush.Register = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)
		
		if goldLoc ~= nil then
			local goldamount = Players[pid].data.inventory[goldLoc].count
			local newcount = config.countregister
			if goldamount < newcount then
				tes3mp.SendMessage(pid,"Vous n'avez pas assez d'or pour vous inscrire au tournois ! \n",false)	
			else
				Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count - newcount	
				tes3mp.SendMessage(pid,"Vous vous êtes inscrit au prohain rush !  \n",false)
				rushTab.player[pid] = {score = 0}
				local itemref = {refId = "gold_001", count = newcount, charge = -1}			
				Players[pid]:Save()
				Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)		
			end	
			
		elseif goldLoc == nil then
			tes3mp.SendMessage(pid,"Vous n'avez pas d'or pour vous inscrire au tournois ! \n",false)
		end
	end
end

eventRush.spawn = function(pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local posx = -19606
		local posy = -9303
		local posz = 182		
		tes3mp.SetCell(pid, "-3, -2") 			
		tes3mp.SetPos(pid, posx, posy, posz)
		tes3mp.SendCell(pid)    
		tes3mp.SendPos(pid)	
	end
end

eventRush.tcheckcell = function(pid)

	local count = 0
	
	for pid, pl in pairs(rushTab.player) do
		count = count + 1
	end

	local newprice = config.countregister * count
	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and eventrush == "active" then        
		for pid1, plr in pairs(Players) do
			if plr:IsLoggedIn() then
				local cell = tes3mp.GetCell(pid1)
				if rushTab.player[pid1] then
					if cell == "-2, 2" then 
						tes3mp.SendMessage(pid,"Le gagnant est "..color.Yellow..Players[pid].name..color.Default..". Le tournoi est fini.  \n",true)
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
						eventRush.End(pid)						
					end
				end
			end
		end
	end   
	
end

function CallforPvP()
	for p , pl in pairs(Players) do
		tes3mp.SendMessage(p,"Il ne vous reste que"..color.Yellow.." 30"..color.Default.." secondes pour vous inscrire à la course. Utilisez"..color.Red.." /rush"..color.Default..", cout:100 pièces d'or.\n",false)
	end
end
	
function three()
	for pid, value in pairs(rushTab.player) do
		tes3mp.SendMessage(pid,"La course commence dans"..color.Red.." 3 ......\n",false)
	end
end
function two()
	for pid, value in pairs(rushTab.player) do
		tes3mp.SendMessage(pid,"La course commence dans"..color.Red.." 2 ....\n",false)
	end
end

function one()
	for pid, value in pairs(rushTab.player) do
		tes3mp.SendMessage(pid,"La course commence dans"..color.Red.." 1 ..\n",false)
	end
end

function zero()
	for pid, value in pairs(rushTab.player) do
		tes3mp.SendMessage(pid,color.Red.."Ruuuusssshhhh !!!!!\n",false)
	end
end

function StartPvP()

	local count = 0
	
	for pid, pl in pairs(rushTab.player) do
		count = count + 1
	end

	if count >= 2 then
		for pid, value in pairs(rushTab.player) do		
			tes3mp.SendMessage(pid,"La course va commencer !"..color.Red.." preparez vous !"..color.Default.." Le premier à Caldera remporte la mise !\n",false)
			eventRush.spawn(pid) 
			logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerControls")					
			logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerFighting")			
			logicHandler.RunConsoleCommandOnPlayer(pid, "DisableTeleporting")
			logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerJumping")	
		end
		eventrush = "active" 
		tes3mp.StartTimer(TimerRush)		
		tes3mp.StartTimer(TimerStop)		
	else
		for pid, value in pairs(rushTab.player) do
			tes3mp.SendMessage(pid,"Il n'y a pas assez de participant pour commencer la course !\n",false)	
		end	
		eventrush = "inactive"
		tes3mp.RestartTimer(TimerStart, time.seconds(config.timerstart))
	end
end

eventRush.TcheckKill = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if eventrush == "active" and rushTab.player[pid] ~= nil then
			eventRush.OnKill(pid)
		else
			return false
		end	
	end
end

eventRush.OnKill = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local timer = tes3mp.CreateTimerEx("Revive", time.seconds(config.timerespawn), "i", pid)
		tes3mp.StartTimer(timer)
	end
end

function Revive(pid)	
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
        tes3mp.Resurrect(pid,0)
    end	
end

eventRush.End = function(pid)

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
			end
		end
	end

	rushTab = { player = {} }
	
	tes3mp.RestartTimer(TimerStart, time.seconds(config.timerstart))	
end

return eventRush
