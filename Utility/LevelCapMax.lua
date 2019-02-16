--LevelCapMax.lua

--[[ INSTALLATION

1) Save this file as "LevelCapMax.lua" in mp-stuff/scripts

2) Add [ LevelCapMax = require("LevelCapMax") ] to the top of server.lua
	
3) Add to eventHandler.OnObjectActivate = function(pid, cellDescription)

    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		  LevelCapMax.CheckLevel(pid)
]]
local config = {}
config.maxLevel = 50

local LevelCapMax = {}

LevelCapMax.CheckLevel = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local level = tes3mp.GetLevel(pid)
		if level >= config.maxLevel then 
			Players[pid].data.stats.level = config.maxLevel
			tes3mp.SetLevelProgress(pid, 0)
			tes3mp.SendLevel(pid)
		else
			Players[pid].data.stats.level = tes3mp.GetLevel(pid)
			Players[pid].data.stats.levelProgress = tes3mp.GetLevelProgress(pid)
		end
	end
end	

return LevelCapMax
