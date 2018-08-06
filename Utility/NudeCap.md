Go to player->base.lua
Find function BasePlayer:SaveAttributes()
Replace all the block to

	function BasePlayer:SaveAttributes()
	    for name in pairs(self.data.attributes) do

		local attributeId = tes3mp.GetAttributeId(name)

		local baseValue = tes3mp.GetAttributeBase(self.pid, attributeId)
		local modifierValue = tes3mp.GetAttributeModifier(self.pid, attributeId)
		local maxAttributeValue = config.maxAttributeValue

		if name == "Speed" then
		    maxAttributeValue = config.maxSpeedValue
		end

		if baseValue > maxAttributeValue then
		    self:LoadAttributes()
				self.data.equipment = {}
				self:LoadEquipment()

		    local message = "Votre base " .. name .. " a dépassé la valeur maximale autorisée et a été réinitialisé à son dernier enregistrement.\n"
		    tes3mp.SendMessage(self.pid, message)
		elseif (baseValue + modifierValue) > maxAttributeValue then
		    tes3mp.ClearAttributeModifier(self.pid, attributeId)
		    tes3mp.SendAttributes(self.pid)
				self.data.equipment = {}
				self:LoadEquipment()	

		    local message = "Votre " .. name .. " l'enrichissement a dépassé la valeur maximale autorisée et a été retiré.\n"
		    tes3mp.SendMessage(self.pid, message)
		else
		    self.data.attributes[name] = baseValue			
		end
	    end
	end

Find function BasePlayer:SaveSkills()
Replace all the block to

	function BasePlayer:SaveSkills()
	    for name in pairs(self.data.skills) do

		local skillId = tes3mp.GetSkillId(name)

		local baseValue = tes3mp.GetSkillBase(self.pid, skillId)
		local modifierValue = tes3mp.GetSkillModifier(self.pid, skillId)
		local maxSkillValue = config.maxSkillValue
			local maxlevel = 50

			if self.data.stats.level >= maxlevel then
				tes3mp.SetLevel(self.pid, maxlevel)
				tes3mp.SendSkills(self.pid)
				if self.data.stats.levelProgress >= 10 then
					tes3mp.SetLevelProgress(self.pid, 0)
					tes3mp.SendSkills(self.pid)
				end
			end

		if name == "Acrobatics" then
		    maxSkillValue = config.maxAcrobaticsValue
		end

		if baseValue > maxSkillValue then
		    self:LoadSkills()
				self.data.equipment = {}
				self:LoadEquipment()

		    local message = "Votre base " .. name .. " a dépassé la valeur maximale autorisée et a été réinitialisé à son dernier enregistrement.\n"
		    tes3mp.SendMessage(self.pid, message)
		elseif (baseValue + modifierValue) > maxSkillValue then
		    tes3mp.ClearSkillModifier(self.pid, skillId)
		    tes3mp.SendSkills(self.pid)
				self.data.equipment = {}
				self:LoadEquipment()

		    local message = "Votre " .. name .. " l'enrichissement a dépassé la valeur maximale autorisée et a été retiré.\n"
		    tes3mp.SendMessage(self.pid, message)
		else
		    self.data.skills[name] = baseValue
		    self.data.skillProgress[name] = tes3mp.GetSkillProgress(self.pid, skillId)			
		end 
	    end

	    for name in pairs(self.data.attributeSkillIncreases) do
		local attributeId = tes3mp.GetAttributeId(name)
		self.data.attributeSkillIncreases[name] = tes3mp.GetSkillIncrease(self.pid, attributeId)
	    end

	    self.data.stats.levelProgress = tes3mp.GetLevelProgress(self.pid)
	end
