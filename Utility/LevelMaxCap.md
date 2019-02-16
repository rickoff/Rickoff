go to player>base.lua
* find ``function BasePlayer:SaveSkills()``
* add under ``local maxSkillValue = config.maxSkillValue`` 
```
		local maxlevel = 50

		if self.data.stats.level >= maxlevel then
			tes3mp.SetLevel(self.pid, maxlevel)
			tes3mp.SendSkills(self.pid)
			if self.data.stats.levelProgress >= 1 then
				self.data.stats.level = maxlevel
				tes3mp.SetLevelProgress(self.pid, 0)
				tes3mp.SendSkills(self.pid)
			end
		end
```
Alternative way by discordpeter
* got to player>base.lua
* find ``function BasePlayer:SaveLevel()``
* replace the complete function with 
```
function BasePlayer:SaveLevel()
	config.maxLevel = 50

	local level = tes3mp.GetLevel(self.pid)
	if level > config.maxLevel then --somehow got above level maxLevel
		self:LoadLevel()
	elseif level == config.maxLevel then
		if level == self.data.stats.level then -- skillprogress with maxLevel: reload data to rewind back
			self:LoadLevel()
		else -- in case someone just reached level 50 and is still 49 in data
			self.data.stats.level = tes3mp.GetLevel(self.pid)
			tes3mp.SetLevelProgress(self.pid, 0)
			tes3mp.SendLevel(self.pid)
		end
	else -- otherwise below that level act normal
		self.data.stats.level = tes3mp.GetLevel(self.pid)
		self.data.stats.levelProgress = tes3mp.GetLevelProgress(self.pid)
	end
end
```
