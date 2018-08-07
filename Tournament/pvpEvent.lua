--pvpEvent.lua

tableHelper = require("tableHelper")

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
	pvpTab.player[pid] = {score = 0}
	tes3mp.SendMessage(pid,"You registered for PvP Event \n",false)
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
	for pid, value in pairs(pvpTab.player) do
		tes3mp.SendMessage(pid,"Event started you are being teleported. Fight each other",false)
		tes3mp.SetCell(pid, "Vivec, Arena")
		tes3mp.SendCell(pid)
        --tes3mp.SetPos(pid, pos.x, pos.y, pos.z)
        --tes3mp.SendCell(pid)    
        --tes3mp.SendPos(pid)		
	end
	eventpvp = "active"
end

pvpEvent.TcheckKill = function(pid)

	if eventpvp == "active" then
		pvpEvent.OnKill(pid)
	else
		myMod.OnPlayerDeath(pid)
	end	
	
end

pvpEvent.OnKill = function(pid)

	if myMod.GetPlayerByName(tes3mp.GetDeathReason(pid)) ~= nil then

		local pl = myMod.GetPlayerByName(tes3mp.GetDeathReason(pid))
		local newpid = pl.pid

		pvpTab.player[newpid].score = pvpTab.player[newpid].score + 1


		for pid, value in pairs(pvpTab.player) do
			tes3mp.SendMessage(pid,"Player "..Players[newpid].name.." scored. Now "..pvpTab.player[newpid].score.." Points!",false)
		end

		for pid, value in pairs(pvpTab.player) do
			if value.score >= 10 then
				tes3mp.SendMessage(pid,"The Winner is "..Players[pid].name..". Tournament ends here.",true)
				pvpEvent.End(pid)
			end
		end

		local List = ""
			
		for pid, value in pairs(pvpTab.player) do
			List = List..Players[pid].name.." got "..tostring(value.score).." Points \n"
		end

		tes3mp.ListBox(pid,333,"ScoreBoard:",List)


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
		tes3mp.SendCell(pid)
	end

	eventpvp = "inactive"

	pvpTab = { player = {} }
end

return pvpEvent
