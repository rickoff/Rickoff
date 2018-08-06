go to player>base.lua
find ``function BasePlayer:SaveSkills()``
add under ``local maxSkillValue = config.maxSkillValue`` 

		local maxlevel = 50

		if self.data.stats.level >= maxlevel then
			tes3mp.SetLevel(self.pid, maxlevel)
			tes3mp.SendSkills(self.pid)
			if self.data.stats.levelProgress >= 10 then
				tes3mp.SetLevelProgress(self.pid, 0)
				tes3mp.SendSkills(self.pid)
			end
		end
