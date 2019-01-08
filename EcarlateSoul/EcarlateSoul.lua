---------------------------
-- EcarlateSoul by Rickoff inspired by RageFire
--
--
---------------------------
jsonInterface = require("jsonInterface")

-- ===========
--MAIN CONFIG
-- ===========
-------------------------
EcarlateSoul = {}

EcarlateSoul.OnPlayerKillCreature = function(killerPid, refId)
	
	local creatureTable = jsonInterface.load("EcarlateCreatures.json")
	local soulLoc = Players[killerPid].data.customVariables.soul
	local levelSoul = Players[killerPid].data.customVariables.levelSoul	
	local capSoul = Players[killerPid].data.customVariables.capSoul
	local pointSoul = Players[killerPid].data.customVariables.pointSoul
	
	if soulLoc == nil then
		Players[killerPid].data.customVariables.soul = 0
	end
	if levelSoul == nil then
		Players[killerPid].data.customVariables.levelSoul = 1
	end	
	if capSoul ~= nil then
		Players[killerPid].data.customVariables.capSoul = 25000
	else 
		Players[killerPid].data.customVariables.capSoul = 25000
	end	
	if pointSoul == nil then
		Players[killerPid].data.customVariables.pointSoul = 0
	end	

	local creatureRefId
	local creaturename
	local creatureSoul
	rando1 = math.random(0, 25)
	
	if levelSoul ~= nil then
		for slot, creature in pairs(creatureTable.creatures) do
			creatureRefId = creature.Refid
			if creatureRefId == refId then
				creaturename = creature.name
				creatureSoul = creature.Soul
				local totalGain = creatureSoul + rando1	
				if Players[killerPid] ~= nil then	
					if soulLoc == nil then
						Players[killerPid].data.customVariables.soul = totalGain	
					else
						Players[killerPid].data.customVariables.soul = Players[killerPid].data.customVariables.soul + totalGain
					end
					tes3mp.MessageBox(killerPid, -1, color.Default.. "Vous avez gagné : "..color.Green.. totalGain ..color.Default.. " points d'" ..color.Yellow.. "exp.")								
				end	
			end
		end
	
		if soulLoc ~= nil and capSoul ~= nil and soulLoc >= capSoul then
			Players[killerPid].data.customVariables.levelSoul = Players[killerPid].data.customVariables.levelSoul + 1
			Players[killerPid].data.customVariables.soul = 0
			Players[killerPid].data.customVariables.capSoul = 25000
			Players[killerPid].data.customVariables.pointSoul = Players[killerPid].data.customVariables.pointSoul + 5
			tes3mp.MessageBox(killerPid, -1, color.Default.. "Vous avez gagné un niveau félicitation : "..color.Green.. "/menu>joueur>compétences" ..color.Default.. " pour dépenser vos points d'" ..color.Yellow.. "exp.")		
		end	
	end
	Players[killerPid]:Save()
	Players[killerPid]:Load()	
end	 

EcarlateSoul.OnPlayerCompetence = function(Pid, Comp)

	local levelSoul = Players[Pid].data.customVariables.levelSoul	
	local GuerrierCount = Players[Pid].data.customVariables.guerrier
	local VoleurCount = Players[Pid].data.customVariables.voleur
	local MageCount = Players[Pid].data.customVariables.mage
	local LifeCount = Players[Pid].data.customVariables.life
	local PeauCount = Players[Pid].data.customVariables.peau	
	local GuexpCount = Players[Pid].data.customVariables.guexp
	local ArchiCount = Players[Pid].data.customVariables.archi
	local MoineCount = Players[Pid].data.customVariables.moine	
	local DaedraCount = Players[Pid].data.customVariables.daedra		
	local PointCount = Players[Pid].data.customVariables.pointSoul
	if PointCount == nil then
		Players[Pid].data.customVariables.pointSoul = 0
		PointCount = Players[Pid].data.customVariables.pointSoul			
	end		
	if levelSoul == nil then
		Players[Pid].data.customVariables.levelSoul = 1
		levelSoul = Players[Pid].data.customVariables.levelSoul	
	elseif levelSoul ~= nil then	
		if GuerrierCount == nil then
			Players[Pid].data.customVariables.guerrier = 0
			GuerrierCount = Players[Pid].data.customVariables.guerrier
		else
			if Comp == "Guerrier" and GuerrierCount < 5 and PointCount >= 3 then
				local attrId = tes3mp.GetAttributeId("Strength")
				local attrId2 = tes3mp.GetAttributeId("Endurance")	
				local valueS = Players[Pid].data.attributes.Strength + 4
				local valueS2 = Players[Pid].data.attributes.Endurance + 4				
				tes3mp.SetAttributeBase(Pid, attrId, valueS)
				tes3mp.SetAttributeBase(Pid, attrId2, valueS2)
				Players[Pid].data.customVariables.guerrier = Players[Pid].data.customVariables.guerrier + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3	
			elseif Comp == "Guerrier" and GuerrierCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")					
			end
		end
		if VoleurCount == nil then
			Players[Pid].data.customVariables.voleur = 0
			VoleurCount = Players[Pid].data.customVariables.voleur	
		else
			if Comp == "Voleur" and VoleurCount < 5 and PointCount >= 3 then
				local attrId = tes3mp.GetAttributeId("Agility")
				local attrId2 = tes3mp.GetAttributeId("Speed")		
				local valueS = Players[Pid].data.attributes.Agility + 4
				local valueS2 = Players[Pid].data.attributes.Speed + 4			
				tes3mp.SetAttributeBase(Pid, attrId, valueS)
				tes3mp.SetAttributeBase(Pid, attrId2, valueS2)		
				Players[Pid].data.customVariables.voleur = Players[Pid].data.customVariables.voleur + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3
			elseif Comp == "Voleur" and VoleurCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
			end
		end
		if MageCount == nil then
			Players[Pid].data.customVariables.mage = 0
			MageCount = Players[Pid].data.customVariables.mage			
		else
			if Comp == "Mage" and MageCount < 5 and PointCount >= 3 then
				local attrId = tes3mp.GetAttributeId("Intelligence")
				local attrId2 = tes3mp.GetAttributeId("Willpower")		
				local valueS = Players[Pid].data.attributes.Intelligence + 4
				local valueS2 = Players[Pid].data.attributes.Willpower + 4			
				tes3mp.SetAttributeBase(Pid, attrId, valueS)
				tes3mp.SetAttributeBase(Pid, attrId2, valueS2)		
				Players[Pid].data.customVariables.mage = Players[Pid].data.customVariables.mage + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3	
			elseif Comp == "Mage" and MageCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
			end
		end	
		if RoublardCount == nil then
			Players[Pid].data.customVariables.roublard = 0
			RoublardCount = Players[Pid].data.customVariables.roublard			
		else
			if Comp == "Roublard" and RoublardCount < 5 and PointCount >= 3 then
				local attrId = tes3mp.GetAttributeId("Personality")
				local attrId2 = tes3mp.GetAttributeId("Luck")		
				local valueS = Players[Pid].data.attributes.Personality + 4
				local valueS2 = Players[Pid].data.attributes.Luck + 4			
				tes3mp.SetAttributeBase(Pid, attrId, valueS)
				tes3mp.SetAttributeBase(Pid, attrId2, valueS2)		
				Players[Pid].data.customVariables.roublard = Players[Pid].data.customVariables.roublard + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3	
			elseif Comp == "Roublard" and RoublardCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
			end
		end			
		if LifeCount == nil then
			Players[Pid].data.customVariables.life = 0
			LifeCount = Players[Pid].data.customVariables.life		
		else
			if Comp == "Life" and LifeCount < 5 and PointCount >= 3 then -- guerrier
				local valueS = Players[Pid].data.stats.healthBase + 10		
				tes3mp.SetHealthBase(Pid, valueS)
				Players[Pid].data.customVariables.life = Players[Pid].data.customVariables.life + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3	
			elseif Comp == "Life" and LifeCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
			end
		end	
		if PeauCount == nil then
			Players[Pid].data.customVariables.peau = 0
			PeauCount = Players[Pid].data.customVariables.peau			
		else
			if Comp == "Peau" and PeauCount < 5 and PointCount >= 3 then	-- mage
				local valueS = Players[Pid].data.stats.magickaBase + 10	
				tes3mp.SetMagickaBase(Pid, valueS)	
				Players[Pid].data.customVariables.peau = Players[Pid].data.customVariables.peau + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3	
			elseif Comp == "Peau" and PeauCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
			end
		end	
		if GuexpCount == nil then
			Players[Pid].data.customVariables.guexp = 0
			GuexpCount = Players[Pid].data.customVariables.guexp		
		else
			if Comp == "Guexp" and GuexpCount < 5 and PointCount >= 3 then -- voleur	
				local valueS2 = Players[Pid].data.stats.fatigueBase + 10
				tes3mp.SetFatigueBase(Pid, valueS2)					
				Players[Pid].data.customVariables.guexp = Players[Pid].data.customVariables.guexp + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3	
			elseif Comp == "Guexp" and GuexpCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
			end
		end	
		if Comp == "Block" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Block")
			local valueC = Players[Pid].data.skills.Block + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Block" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Alchemy" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Alchemy")
			local valueC = Players[Pid].data.skills.Alchemy + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Alchemy" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end	
		if Comp == "Handtohand" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Handtohand")
			local valueC = Players[Pid].data.skills.Handtohand + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Handtohand" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Conjuration" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Conjuration")
			local valueC = Players[Pid].data.skills.Conjuration + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Conjuration" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Shortblade" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Shortblade")
			local valueC = Players[Pid].data.skills.Shortblade + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Shortblade" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Alteration" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Alteration")
			local valueC = Players[Pid].data.skills.Alteration + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Alteration" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Mediumarmor" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Mediumarmor")
			local valueC = Players[Pid].data.skills.Mediumarmor + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Mediumarmor" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Heavyarmor" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Heavyarmor")
			local valueC = Players[Pid].data.skills.Heavyarmor + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Heavyarmor" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Bluntweapon" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Bluntweapon")
			local valueC = Players[Pid].data.skills.Bluntweapon + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Bluntweapon" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Marksman" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Marksman")
			local valueC = Players[Pid].data.skills.Marksman + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Marksman" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Acrobatics" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Acrobatics")
			local valueC = Players[Pid].data.skills.Acrobatics + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Acrobatics" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Sneak" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Sneak")
			local valueC = Players[Pid].data.skills.Sneak + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Sneak" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Lightarmor" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Lightarmor")
			local valueC = Players[Pid].data.skills.Lightarmor + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Lightarmor" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Longblade" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Longblade")
			local valueC = Players[Pid].data.skills.Longblade + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Longblade" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Armorer" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Armorer")
			local valueC = Players[Pid].data.skills.Armorer + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Armorer" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Speechcraft" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Speechcraft")
			local valueC = Players[Pid].data.skills.Speechcraft + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Speechcraft" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Axe" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Axe")
			local valueC = Players[Pid].data.skills.Axe + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Axe" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Security" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Security")
			local valueC = Players[Pid].data.skills.Security + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Security" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Enchant" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Enchant")
			local valueC = Players[Pid].data.skills.Enchant + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Enchant" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Destruction" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Destruction")
			local valueC = Players[Pid].data.skills.Destruction + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Destruction" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Athletics" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Athletics")
			local valueC = Players[Pid].data.skills.Athletics + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Athletics" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Illusion" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Illusion")
			local valueC = Players[Pid].data.skills.Illusion + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Illusion" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Mysticism" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Mysticism")
			local valueC = Players[Pid].data.skills.Mysticism + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Mysticism" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Spear" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Spear")
			local valueC = Players[Pid].data.skills.Spear + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Spear" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Mercantile" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Mercantile")
			local valueC = Players[Pid].data.skills.Mercantile + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Mercantile" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Restoration" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Restoration")
			local valueC = Players[Pid].data.skills.Restoration + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Restoration" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Unarmored" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Unarmored")
			local valueC = Players[Pid].data.skills.Unarmored + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Unarmored" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end			
        Players[Pid]:SaveStatsDynamic()		
		Players[Pid]:SaveAttributes()	
		Players[Pid]:SaveSkills()			
		tes3mp.SendAttributes(Pid)
		tes3mp.SendSkills(Pid)	
		tes3mp.SendStatsDynamic(Pid)
	else
		tes3mp.MessageBox(Pid, -1, color.Default.. "Vous avez atteint le niveau maximum : "..color.Green.. "50" ..color.Default.. " en points de" ..color.Yellow.. "compétences.")		
	end
end	

EcarlateSoul.OnPlayerDeath = function(Pid)
	local soulLoc = Players[Pid].data.customVariables.soul
	local levelSoul = Players[Pid].data.customVariables.levelSoul	
	local capSoul = Players[Pid].data.customVariables.capSoul
	local pointSoul = Players[Pid].data.customVariables.pointSoul
	local totalPerte = ((soulLoc * 25) / 100)
	if levelSoul == nil then
		Players[Pid].data.customVariables.levelSoul = 1
	end	
	if capSoul ~= nil then
		Players[Pid].data.customVariables.capSoul = 25000
	else 
		Players[Pid].data.customVariables.capSoul = 25000
	end	
	if pointSoul == nil then
		Players[Pid].data.customVariables.pointSoul = 0
	end	
	if soulLoc == nil then
		Players[Pid].data.customVariables.soul = totalPerte	
	else
		Players[Pid].data.customVariables.soul = Players[Pid].data.customVariables.soul - totalPerte
	end
	tes3mp.MessageBox(Pid, -1, color.Default.. "Vous avez perdu : "..color.Green.. totalPerte ..color.Default.. " points d'" ..color.Yellow.. "exp.")		
end

return EcarlateSoul
