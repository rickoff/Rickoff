--pvpEvent.lua

tableHelper = require("tableHelper")
inventoryHelper = require("inventoryHelper")
jsonInterface = require("jsonInterface")

local config = {}

config.timerevent = 60
config.timerstart = 600

pvpEvent = {}

local TimerStart = tes3mp.CreateTimer("StartEvent", time.seconds(config.timerstart))

local eventpvp = "inactive"

local pvpTab = { player = {} }

pvpEvent.TimerStartEvent = function()
	tes3mp.StartTimer(TimerStart)
end

function StartEvent()
	if tableHelper.getCount(Players) > 0 then
		Playerpid = tableHelper.getAnyValue(Players).pid
		pvpEvent.AdminStart(Playerpid)
		tes3mp.RestartTimer(TimerStart, time.seconds(config.timerstart))
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
	tes3mp.SendMessage(pid,"PvP Event has been started. Everyone has 60 Seconds to register. with /pvp \n",true)
end


pvpEvent.Register = function(pid)

	local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)
	local goldamount = Players[pid].data.inventory[goldLoc].count
	local newcount = 1000
	
	if goldLoc == nil then
		tes3mp.SendMessage(pid,"You do not have gold to register for the tournaments! \n",false)
		
	elseif goldamount < newcount then
		tes3mp.SendMessage(pid,"You do not have enough gold to register for the tournaments! \n",false)
		
	else
		Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count - newcount	
		tes3mp.SendMessage(pid,"You registered for the pvp tournament! \n",false)
		pvpTab.player[pid] = {score = 0}
		Players[pid]:Save()
		Players[pid]:LoadInventory()
		Players[pid]:LoadEquipment()		
	end	
	
end


function CallforPvP()
	for p , pl in pairs(Players) do
		tes3mp.SendMessage(p,"You have only 30 Seconds left to register for PvPEvent. Use /pvp.\n",false)
	end
end
	
function three()
	for p , pl in pairs(Players) do
		tes3mp.SendMessage(p,"PvPEvent starts in 3 ......\n",false)
	end
end
function two()
	for p , pl in pairs(Players) do
		tes3mp.SendMessage(p,"PvPEvent starts in 2 ....\n",false)
	end
end

function one()
	for p , pl in pairs(Players) do
		tes3mp.SendMessage(p,"PvPEvent starts in 1 ..\n",false)
	end
end

function StartPvP()

	local count = 0
	
	for pid, pl in pairs(pvpTab.player) do
		count = count + 1
	end

	if count >= 2 then
		for pid, value in pairs(pvpTab.player) do
			tes3mp.SendMessage(pid,"The event has begun, you are teleported. Beat you !  \n",false)
			tes3mp.SetCell(pid, "Vivec, Arena")  
			--tes3mp.SetPos(pid, 4082, 4351, 12072)
			tes3mp.SendCell(pid)    
			--tes3mp.SendPos(pid)		
		end
		eventpvp = "active"
	else
		for pid, value in pairs(pvpTab.player) do
			tes3mp.SendMessage(pid,"There are not enough participants to start the tournament!  \n",false)	
		end	
		eventpvp = "inactive"
	end
end

pvpEvent.TcheckKill = function(pid)

	if eventpvp == "active" and pvpTab.player [pid] ~= nil then
		pvpEvent.OnKill(pid)
	else
		myMod.OnPlayerDeath(pid)
	end	
	
end

pvpEvent.OnKill = function(pid)

	local count = 0
	
	for pid, pl in pairs(pvpTab.player) do
		count = count + 1
	end

	local newprice = 1000 * count	

	if myMod.GetPlayerByName(tes3mp.GetDeathReason(pid)) ~= nil then

		local pl = myMod.GetPlayerByName(tes3mp.GetDeathReason(pid))
		local newpid = pl.pid

		pvpTab.player[newpid].score = pvpTab.player[newpid].score + 1


		for pid, value in pairs(pvpTab.player) do
			tes3mp.SendMessage(pid,Players[newpid].name.." got "..pvpTab.player[newpid].score.." Points !  \n",false)
		end

		for pid, value in pairs(pvpTab.player) do
			if value.score >= 10 then			
				tes3mp.SendMessage(pid,"The winner is "..Players[pid].name..". The tournament is over.  \n",true)
				local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)
				if goldLoc == nil then
					tes3mp.SendMessage(pid,"You have just won the tournament! \n",false)
					table.insert(Players[pid].data.inventory, {refId = "gold_001", count = newprice, charge = -1})
					Players[pid]:Save()
					Players[pid]:LoadInventory()
					Players[pid]:LoadEquipment()					
				else
					Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count + newprice	
					tes3mp.SendMessage(pid,"You have just won the tournament!  \n",false)
					Players[pid]:Save()
					Players[pid]:LoadInventory()
					Players[pid]:LoadEquipment()		
				end					
				pvpEvent.End(pid)
			end
		end

		local List = ""
			
		for pid, value in pairs(pvpTab.player) do
			List = List..Players[pid].name.." got "..tostring(value.score).." Points \n"
		end

		tes3mp.ListBox(pid,333,"Scores:",List)


		local timer = tes3mp.CreateTimerEx("Revive", time.seconds(10), "i", pid)
		tes3mp.StartTimer(timer)
	end
end

function Revive(pid)
	
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
        tes3mp.Resurrect(pid,0)
    end
	
end

pvpEvent.End = function(pid)

	for pid, value in pairs(pvpTab.player) do
		tes3mp.SendMessage(pid,"Event ended you are being teleported",false)
		tes3mp.SetCell(pid, "-3,-2")
		--tes3mp.SetPos(pid, 4082, 4351, 12072)
		tes3mp.SendCell(pid)
		--tes3mp.SendPos(pid)
	end

	eventpvp = "inactive"

	pvpTab = { player = {} }
end

return pvpEvent
