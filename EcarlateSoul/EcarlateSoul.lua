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
		Players[killerPid].data.customVariables.capSoul = 10000 * Players[killerPid].data.customVariables.levelSoul 
	else 
		Players[killerPid].data.customVariables.capSoul = 10000
	end	
	if pointSoul == nil then
		Players[killerPid].data.customVariables.pointSoul = 0
	end	

	local creatureRefId
	local creaturename
	local creatureSoul
	rando1 = math.random(0, 25)
	
	if levelSoul ~= nil and levelSoul < 50 then
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
			Players[killerPid].data.customVariables.capSoul = 10000 * Players[killerPid].data.customVariables.levelSoul
			Players[killerPid].data.customVariables.pointSoul = Players[killerPid].data.customVariables.pointSoul + 5
			tes3mp.MessageBox(killerPid, -1, color.Default.. "Vous avez gagné un niveau félicitation : "..color.Green.. "/menu>joueur>compétences" ..color.Default.. " pour dépenser vos points d'" ..color.Yellow.. "exp.")		
		end	
	end
	Players[killerPid]:Save()
	Players[killerPid]:Load()	
end	 

EcarlateSoul.OnPlayerCompetence = function(Pid, Comp)

	local levelSoul = Players[Pid].data.customVariables.levelSoul	
	local BarbareCount = Players[Pid].data.customVariables.barbare
	local GuerrierCount = Players[Pid].data.customVariables.guerrier
	local RodeurCount = Players[Pid].data.customVariables.rodeur
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
	elseif levelSoul ~= nil and levelSoul < 50 then	
		if BarbareCount == nil then
			Players[Pid].data.customVariables.barbare = 0
			BarbareCount = Players[Pid].data.customVariables.barbare
		else
			if Comp == "Barbare" and BarbareCount ~= nil and PointCount >= 3 then
				local attrId = tes3mp.GetAttributeId("Strength")
				local attrId2 = tes3mp.GetAttributeId("Endurance")		
				local skillId = tes3mp.GetSkillId("Heavyarmor")
				local valueS = Players[Pid].data.attributes.Strength + 4
				local valueS2 = Players[Pid].data.attributes.Endurance + 4			
				local valueC = Players[Pid].data.skills.Heavyarmor + 4	
				tes3mp.SetAttributeBase(Pid, attrId, valueS)
				tes3mp.SetAttributeBase(Pid, attrId2, valueS2)
				tes3mp.SetSkillBase(Pid, skillId, valueC)
				Players[Pid].data.customVariables.barbare = Players[Pid].data.customVariables.barbare + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3	
			elseif Comp == "Barbare" and BarbareCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")					
			end
		end
		if GuerrierCount == nil then
			Players[Pid].data.customVariables.guerrier = 0
			GuerrierCount = Players[Pid].data.customVariables.guerrier	
		else
			if Comp == "Guerrier" and GuerrierCount ~= nil and PointCount >= 3 then
				local attrId = tes3mp.GetAttributeId("Strength")
				local attrId2 = tes3mp.GetAttributeId("Speed")		
				local skillId = tes3mp.GetSkillId("Mediumarmor")
				local valueS = Players[Pid].data.attributes.Strength + 4
				local valueS2 = Players[Pid].data.attributes.Speed + 4			
				local valueC = Players[Pid].data.skills.Mediumarmor + 4
				tes3mp.SetAttributeBase(Pid, attrId, valueS)
				tes3mp.SetAttributeBase(Pid, attrId2, valueS2)		
				tes3mp.SetSkillBase(Pid, skillId, valueC)
				Players[Pid].data.customVariables.guerrier = Players[Pid].data.customVariables.guerrier + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3
			elseif Comp == "Guerrier" and GuerrierCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
			end
		end
		if RodeurCount == nil then
			Players[Pid].data.customVariables.rodeur = 0
			RodeurCount = Players[Pid].data.customVariables.rodeur			
		else
			if Comp == "Rodeur" and RodeurCount ~= nil and PointCount >= 3 then
				local attrId = tes3mp.GetAttributeId("Agility")
				local attrId2 = tes3mp.GetAttributeId("Speed")		
				local skillId = tes3mp.GetSkillId("Lightarmor")
				local valueS = Players[Pid].data.attributes.Agility + 4
				local valueS2 = Players[Pid].data.attributes.Speed + 4			
				local valueC = Players[Pid].data.skills.Lightarmor + 4
				tes3mp.SetAttributeBase(Pid, attrId, valueS)
				tes3mp.SetAttributeBase(Pid, attrId2, valueS2)		
				tes3mp.SetSkillBase(Pid, skillId, valueC)
				Players[Pid].data.customVariables.rodeur = Players[Pid].data.customVariables.rodeur + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3	
			elseif Comp == "Rodeur" and RodeurCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
			end
		end	
		if LifeCount == nil then
			Players[Pid].data.customVariables.life = 0
			LifeCount = Players[Pid].data.customVariables.life		
		else
			if Comp == "Life" and LifeCount < 5 and PointCount >= 3 then
				local valueS = Players[Pid].data.stats.healthBase + 10
				local valueS2 = Players[Pid].data.stats.fatigueBase + 10			
				tes3mp.SetHealthBase(Pid, valueS)
				tes3mp.SetFatigueBase(Pid, valueS2)
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
			if Comp == "Peau" and PeauCount ~= nil and PointCount >= 3 then	
				local skillId = tes3mp.GetSkillId("Unarmored")
				local skillId2 = tes3mp.GetSkillId("Handtohand")		
				local valueC = Players[Pid].data.skills.Unarmored + 10
				local valueC2 = Players[Pid].data.skills.Handtohand + 10		
				tes3mp.SetSkillBase(Pid, skillId, valueC)
				tes3mp.SetSkillBase(Pid, skillId2, valueC2)		
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
			if Comp == "Guexp" and GuexpCount ~= nil and PointCount >= 3 then
				local skillId = tes3mp.GetSkillId("Block")
				local skillId2 = tes3mp.GetSkillId("Armorer")		
				local valueC = Players[Pid].data.skills.Block + 10
				local valueC2 = Players[Pid].data.skills.Armorer + 10		
				tes3mp.SetSkillBase(Pid, skillId, valueC)
				tes3mp.SetSkillBase(Pid, skillId2, valueC2)	
				Players[Pid].data.customVariables.guexp = Players[Pid].data.customVariables.guexp + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3	
			elseif Comp == "Guexp" and GuexpCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
			end
		end	
		if ArchiCount == nil then
			Players[Pid].data.customVariables.archi = 0
			ArchiCount = Players[Pid].data.customVariables.archi		
		else
			if Comp == "Archi" and ArchiCount < 5 and PointCount >= 3 then
				local valueS = Players[Pid].data.stats.magickaBase + 10
				local valueS2 = Players[Pid].data.stats.fatigueBase + 10
				tes3mp.SetFatigueBase(Pid, valueS2)		
				tes3mp.SetMagickaBase(Pid, valueS)
				Players[Pid].data.customVariables.archi = Players[Pid].data.customVariables.archi + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
			elseif Comp == "Archi" and ArchiCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
			end
		end	
		if MoineCount == nil then
			Players[Pid].data.customVariables.moine = 0
			MoineCount = Players[Pid].data.customVariables.moine			
		else
			if Comp == "Moine" and MoineCount ~= nil and PointCount >= 3 then	
				local skillId = tes3mp.GetSkillId("Restoration")
				local skillId2 = tes3mp.GetSkillId("Mysticism")		
				local valueC = Players[Pid].data.skills.Restoration + 10
				local valueC2 = Players[Pid].data.skills.Mysticism + 10		
				tes3mp.SetSkillBase(Pid, skillId, valueC)
				tes3mp.SetSkillBase(Pid, skillId2, valueC2)		
				Players[Pid].data.customVariables.moine = Players[Pid].data.customVariables.moine + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3	
			elseif Comp == "Moine" and MoineCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
			end
		end	
		if DaedraCount == nil then
			Players[Pid].data.customVariables.daedra = 0
			DaedraCount = Players[Pid].data.customVariables.daedra		
		else
			if Comp == "Daedra" and DaedraCount ~= nil and PointCount >= 3 then
				local skillId = tes3mp.GetSkillId("Destruction")
				local skillId2 = tes3mp.GetSkillId("Conjuration")		
				local valueC = Players[Pid].data.skills.Destruction + 10
				local valueC2 = Players[Pid].data.skills.Conjuration + 10		
				tes3mp.SetSkillBase(Pid, skillId, valueC)
				tes3mp.SetSkillBase(Pid, skillId2, valueC2)	
				Players[Pid].data.customVariables.daedra = Players[Pid].data.customVariables.daedra + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3	
			elseif Comp == "Daedra" and DaedraCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
			end
		end		
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
		Players[Pid].data.customVariables.capSoul = 10000 * Players[Pid].data.customVariables.levelSoul 
	else 
		Players[Pid].data.customVariables.capSoul = 10000
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
