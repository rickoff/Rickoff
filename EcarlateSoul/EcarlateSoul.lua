--[[
EcarlateSoul by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Syteme d'experience et de competences
---------------------------
INSTALLATION:
Save the file as EcarlateSoul.lua inside your server/scripts/custom folder.
Save the file as MenuSoul.lua inside your scripts/menu folder

Edits to customScripts.lua
EcarlateSoul = require("custom.EcarlateSoul")

Edits to config.lua
add in config.menuHelperFiles, "MenuSoul"
---------------------------
FUNCTION:
/menusoul in your chat for open menu
---------------------------
]]

jsonInterface = require("jsonInterface")

-- ===========
--MAIN CONFIG
-- ===========
-------------------------
local NpcData = {}
local NpcList = jsonInterface.load("custom/EcarlateNpc.json")
local CreaList = jsonInterface.load("custom/EcarlateCreatures.json")
for index, item in pairs(NpcList) do
	if item.figth > 60 then
		table.insert(NpcData, {REFID = string.lower(item.refid), NAME = string.lower(item.name), SOUL = item.figth})
	end
end
for index, item in pairs(CreaList.creatures) do
	table.insert(NpcData, {REFID = string.lower(item.Refid), NAME = string.lower(item.name), SOUL = item.Soul})
end

local trad = {}
trad.Gain = "Vous avez gagné : "
trad.Pts = " points d'"
trad.Xp = "exp.\n\n"
trad.Bonus = "Bonus de groupe * "
trad.Feli = "Vous avez gagné un niveau félicitation : "
trad.Menu = "/menu>joueur>compétences"
trad.Dep = " pour dépenser vos points d'"
trad.Xps = "exp."
trad.NotPts = "Vous n'avez pas de points de compétences à diminuer"
trad.NoPt =  "Vous n'avez pas assez de points de compétences, actuel : "
trad.Req = " requis : "
trad.Death =  "Vous avez perdu : "
trad.WereWolf = "Le menu des compétences est interdit en forme de loup garou"

local EcarlateSoul = {}

EcarlateSoul.OnPlayerKillCreature = function(eventStatut, pid, cellDescription)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
		if LoadedCells[cellDescription] ~= nil then		
			LoadedCells[cellDescription]:SaveActorDeath(pid)			
			local actorIndex = tes3mp.GetActorListSize() - 1			
			if actorIndex ~= nil then			
				local uniqueIndex = tes3mp.GetActorRefNum(actorIndex) .. "-" .. tes3mp.GetActorMpNum(actorIndex)				
				local killerPid = tes3mp.GetActorKillerPid(actorIndex)				
				if uniqueIndex ~= nil and killerPid ~= nil then				
					if LoadedCells[cellDescription].data.objectData[uniqueIndex] then					
						local refId = LoadedCells[cellDescription].data.objectData[uniqueIndex].refId						
						if refId ~= nil then						
							if tes3mp.DoesActorHavePlayerKiller(actorIndex) then			
								if tableHelper.containsValue(NpcData, string.lower(refId), true) then
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
									if capSoul == nil then
										Players[killerPid].data.customVariables.capSoul = 500
									end	
									if pointSoul == nil then
										Players[killerPid].data.customVariables.pointSoul = 0
									end	
									local creatureRefId
									local creaturename
									local creatureSoul
									local Count
									rando1 = math.random(0, 100)								
									if levelSoul ~= nil then
										for slot, creature in pairs(NpcData) do
											creatureRefId = creature.REFID
											if creatureRefId == string.lower(refId) then
												creaturename = creature.NAME
												creatureSoul = creature.SOUL
												if TeamGroup then
													Count = TeamGroup.EcarlateBonus(killerPid)
												else
													Count = 1
												end
												if Count == 0 then
													Count = 1
												elseif Count > 2 then
													Count = 2
												end
												local totalGain = (creatureSoul + rando1) * Count
												if TeamGroup then
													TeamGroup.SendSoul(killerPid, totalGain)
												end
												if Players[killerPid] ~= nil then	
													if soulLoc == nil then
														Players[killerPid].data.customVariables.soul = totalGain
														soulLoc = Players[killerPid].data.customVariables.soul													
													else
														Players[killerPid].data.customVariables.soul = Players[killerPid].data.customVariables.soul + totalGain
														soulLoc = Players[killerPid].data.customVariables.soul	
													end
													if Count > 1 then
														tes3mp.MessageBox(killerPid, -1, color.Default..trad.Gain..color.Green..totalGain..color.Default..trad.Pts..color.Yellow..trad.Xp..color.DarkOrange.."-- "..creaturename.." --\n\n"..color.Green..trad.Bonus..color.Yellow.. Count)
													else
														tes3mp.MessageBox(killerPid, -1, color.Default..trad.Gain..color.Green..totalGain..color.Default..trad.Pts..color.Yellow..trad.Xp..color.DarkOrange.."-- "..creaturename.." --")					
													end
												end	
											end
										end								
										if soulLoc ~= nil and capSoul ~= nil and soulLoc >= capSoul then
											Players[killerPid].data.customVariables.levelSoul = Players[killerPid].data.customVariables.levelSoul + 1
											Players[killerPid].data.customVariables.soul = 0
											Players[killerPid].data.customVariables.capSoul = math.floor((levelSoul + 1) * 500)
											Players[killerPid].data.customVariables.pointSoul = Players[killerPid].data.customVariables.pointSoul + 5
											tes3mp.MessageBox(killerPid, -1, color.Default..trad.Feli..color.Green..trad.Menu..color.Default..trad.Dep..color.Yellow..trad.Xps)		
										end	
									end
									Players[killerPid]:QuicksaveToDrive()
									Players[killerPid]:LoadFromDrive()
								end
							end
						end
					end
				end
			end
		end
	end
end	 

EcarlateSoul.OnPlayerCompetence = function(Pid, Comp, State)
	if Players[Pid] ~= nil and Players[Pid]:IsLoggedIn() then
		local levelSoul = Players[Pid].data.customVariables.levelSoul	
		local LifeCount = Players[Pid].data.customVariables.life
		local PeauCount = Players[Pid].data.customVariables.peau	
		local GuexpCount = Players[Pid].data.customVariables.guexp		
		local PointCount = Players[Pid].data.customVariables.pointSoul
		local HungerCount = Players[Pid].data.customVariables.hungerCount
		local ThirstCount = Players[Pid].data.customVariables.thirstCount
		local SleepCount = Players[Pid].data.customVariables.sleepCount
		local ForceCount = Players[Pid].data.customVariables.forceCount
		local EnduranceCount = Players[Pid].data.customVariables.enduranceCount
		local AgiliteCount = Players[Pid].data.customVariables.agiliteCount
		local RapiditeCount = Players[Pid].data.customVariables.rapiditeCount
		local IntelligenceCount = Players[Pid].data.customVariables.intelligenceCount
		local VolonteCount = Players[Pid].data.customVariables.volonteCount
		local PersonnaliteCount = Players[Pid].data.customVariables.personnaliteCount
		local ChanceCount = Players[Pid].data.customVariables.chanceCount
		local BlockCount = Players[Pid].data.customVariables.blockCount
		local AlchemyCount = Players[Pid].data.customVariables.alchemyCount
		local HandtohandCount = Players[Pid].data.customVariables.handtohandCount
		local ConjurationCount = Players[Pid].data.customVariables.conjurationCount
		local ShortbladeCount = Players[Pid].data.customVariables.shortbladeCount
		local AlterationCount = Players[Pid].data.customVariables.alterationCount
		local MediumarmorCount = Players[Pid].data.customVariables.mediumarmorCount
		local HeavyarmorCount = Players[Pid].data.customVariables.heavyarmorCount
		local BluntweaponCount = Players[Pid].data.customVariables.bluntweaponCount
		local MarksmanCount = Players[Pid].data.customVariables.marksmanCount
		local AcrobaticsCount = Players[Pid].data.customVariables.acrobaticsCount
		local SneakCount = Players[Pid].data.customVariables.sneakCount
		local LightarmorCount = Players[Pid].data.customVariables.lightarmorCount
		local LongbladeCount = Players[Pid].data.customVariables.longbladeCount
		local ArmorerCount = Players[Pid].data.customVariables.armorerCount
		local SpeechcraftCount = Players[Pid].data.customVariables.speechcraftCount
		local AxeCount = Players[Pid].data.customVariables.axeCount
		local SecurityCount = Players[Pid].data.customVariables.securityCount
		local EnchantCount = Players[Pid].data.customVariables.enchantCount
		local DestructionCount = Players[Pid].data.customVariables.destructionCount
		local AthleticsCount = Players[Pid].data.customVariables.athleticsCount
		local IllusionCount = Players[Pid].data.customVariables.illusionCount
		local MysticismCount = Players[Pid].data.customVariables.mysticismCount
		local SpearCount = Players[Pid].data.customVariables.spearCount
		local MercantileCount = Players[Pid].data.customVariables.mercantileCount
		local RestorationCount = Players[Pid].data.customVariables.restorationCount
		local UnarmoredCount = Players[Pid].data.customVariables.unarmoredCount
		
		if PointCount == nil then
			Players[Pid].data.customVariables.pointSoul = 0
			PointCount = Players[Pid].data.customVariables.pointSoul			
		end	
		
		if levelSoul == nil then
			Players[Pid].data.customVariables.levelSoul = 1
			levelSoul = Players[Pid].data.customVariables.levelSoul	
		elseif levelSoul ~= nil then
		
			if ForceCount == nil then
				Players[Pid].data.customVariables.forceCount = 0
				ForceCount = Players[Pid].data.customVariables.forceCount			
			else	
				if Comp == "Force" and PointCount >= 1 and State == "Add" then
					local attrId = tes3mp.GetAttributeId("Strength")
					local valueS = Players[Pid].data.attributes.Strength.base + 1	
					tes3mp.SetAttributeBase(Pid, attrId, valueS)
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.forceCount = Players[Pid].data.customVariables.forceCount + 1
				elseif Comp == "Force" and ForceCount > 0 and State == "Remove" then	
					local attrId = tes3mp.GetAttributeId("Strength")
					local valueS = Players[Pid].data.attributes.Strength.base - 1	
					tes3mp.SetAttributeBase(Pid, attrId, valueS)
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.forceCount = Players[Pid].data.customVariables.forceCount - 1
				elseif Comp == "Force" and ForceCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Force" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")					
				end
			end
			
			if EnduranceCount == nil then
				Players[Pid].data.customVariables.enduranceCount = 0
				EnduranceCount = Players[Pid].data.customVariables.enduranceCount			
			else		
				if Comp == "Endurance" and PointCount >= 1 and State == "Add" then
					local attrId2 = tes3mp.GetAttributeId("Endurance")	
					local valueS2 = Players[Pid].data.attributes.Endurance.base + 1	
					tes3mp.SetAttributeBase(Pid, attrId2, valueS2)
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.enduranceCount = Players[Pid].data.customVariables.enduranceCount + 1				
				elseif Comp == "Endurance" and EnduranceCount > 0 and State == "Remove" then
					local attrId2 = tes3mp.GetAttributeId("Endurance")	
					local valueS2 = Players[Pid].data.attributes.Endurance.base - 1	
					tes3mp.SetAttributeBase(Pid, attrId2, valueS2)
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.enduranceCount = Players[Pid].data.customVariables.enduranceCount - 1
				elseif Comp == "Endurance" and EnduranceCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Endurance" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")					
				end
			end
			
			if AgiliteCount == nil then
				Players[Pid].data.customVariables.agiliteCount = 0
				AgiliteCount = Players[Pid].data.customVariables.agiliteCount			
			else			
				if Comp == "Agilité" and PointCount >= 1 and State == "Add" then
					local attrId = tes3mp.GetAttributeId("Agility")	
					local valueS = Players[Pid].data.attributes.Agility.base + 1	
					tes3mp.SetAttributeBase(Pid, attrId, valueS)
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.agiliteCount = Players[Pid].data.customVariables.agiliteCount + 1
				elseif Comp == "Agilité" and AgiliteCount > 0 and State == "Remove" then
					local attrId = tes3mp.GetAttributeId("Agility")	
					local valueS = Players[Pid].data.attributes.Agility.base - 1	
					tes3mp.SetAttributeBase(Pid, attrId, valueS)
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.agiliteCount = Players[Pid].data.customVariables.agiliteCount - 1
				elseif Comp == "Agilité" and AgiliteCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Agilité" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end
			
			if RapiditeCount == nil then
				Players[Pid].data.customVariables.rapiditeCount = 0
				RapiditeCount = Players[Pid].data.customVariables.rapiditeCount			
			else		
				if Comp == "Rapidité" and PointCount >= 1 and State == "Add" then
					local attrId2 = tes3mp.GetAttributeId("Speed")		
					local valueS2 = Players[Pid].data.attributes.Speed.base + 1
					tes3mp.SetAttributeBase(Pid, attrId2, valueS2)	
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.rapiditeCount	 = Players[Pid].data.customVariables.rapiditeCount + 1
				elseif Comp == "Rapidité" and RapiditeCount > 0 and State == "Remove" then
					local attrId2 = tes3mp.GetAttributeId("Speed")		
					local valueS2 = Players[Pid].data.attributes.Speed.base - 1
					tes3mp.SetAttributeBase(Pid, attrId2, valueS2)	
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.rapiditeCount	 = Players[Pid].data.customVariables.rapiditeCount - 1
				elseif Comp == "Rapidité" and RapiditeCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Rapidité" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end	
			end

			if IntelligenceCount == nil then
				Players[Pid].data.customVariables.intelligenceCount = 0
				IntelligenceCount = Players[Pid].data.customVariables.intelligenceCount			
			else			
				if Comp == "Intelligence" and PointCount >= 1 and State == "Add" then
					local attrId = tes3mp.GetAttributeId("Intelligence")	
					local valueS = Players[Pid].data.attributes.Intelligence.base + 1	
					tes3mp.SetAttributeBase(Pid, attrId, valueS)
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.intelligenceCount	 = Players[Pid].data.customVariables.intelligenceCount + 1
				elseif Comp == "Intelligence" and IntelligenceCount > 0 and State == "Remove" then
					local attrId = tes3mp.GetAttributeId("Intelligence")	
					local valueS = Players[Pid].data.attributes.Intelligence.base - 1	
					tes3mp.SetAttributeBase(Pid, attrId, valueS)
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.intelligenceCount	 = Players[Pid].data.customVariables.intelligenceCount - 1
				elseif Comp == "Intelligence" and IntelligenceCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
				elseif Comp == "Intelligence" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if VolonteCount == nil then
				Players[Pid].data.customVariables.volonteCount = 0
				VolonteCount = Players[Pid].data.customVariables.volonteCount			
			else			
				if Comp == "Volonté" and PointCount >= 1 and State == "Add" then
					local attrId2 = tes3mp.GetAttributeId("Willpower")		
					local valueS2 = Players[Pid].data.attributes.Willpower.base + 1
					tes3mp.SetAttributeBase(Pid, attrId2, valueS2)	
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.volonteCount = Players[Pid].data.customVariables.volonteCount + 1
				elseif Comp == "Volonté" and VolonteCount > 0 and State == "Remove" then
					local attrId2 = tes3mp.GetAttributeId("Willpower")		
					local valueS2 = Players[Pid].data.attributes.Willpower.base - 1
					tes3mp.SetAttributeBase(Pid, attrId2, valueS2)	
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.volonteCount = Players[Pid].data.customVariables.volonteCount - 1	
				elseif Comp == "Volonté" and VolonteCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
				elseif Comp == "Volonté" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if PersonnaliteCount == nil then
				Players[Pid].data.customVariables.personnaliteCount = 0
				PersonnaliteCount = Players[Pid].data.customVariables.personnaliteCount			
			else		
				if Comp == "Personnalité" and PointCount >= 1 and State == "Add" then
					local attrId = tes3mp.GetAttributeId("Personality")	
					local valueS = Players[Pid].data.attributes.Personality.base + 1	
					tes3mp.SetAttributeBase(Pid, attrId, valueS)
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.personnaliteCount	= Players[Pid].data.customVariables.personnaliteCount + 1
				elseif Comp == "Personnalité" and PersonnaliteCount > 0 and State == "Remove" then
					local attrId = tes3mp.GetAttributeId("Personality")	
					local valueS = Players[Pid].data.attributes.Personality.base - 1	
					tes3mp.SetAttributeBase(Pid, attrId, valueS)
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.personnaliteCount	= Players[Pid].data.customVariables.personnaliteCount - 1
				elseif Comp == "Personnalité" and PersonnaliteCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
				elseif Comp == "Personnalité" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end
			
			if ChanceCount == nil then
				Players[Pid].data.customVariables.chanceCount = 0
				ChanceCount = Players[Pid].data.customVariables.chanceCount			
			else			
				if Comp == "Chance" and PointCount >= 1 and State == "Add" then
					local attrId2 = tes3mp.GetAttributeId("Luck")		
					local valueS2 = Players[Pid].data.attributes.Luck.base + 1
					tes3mp.SetAttributeBase(Pid, attrId2, valueS2)	
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.chanceCount = Players[Pid].data.customVariables.chanceCount + 1
				elseif Comp == "Chance" and ChanceCount > 0 and State == "Remove" then
					local attrId2 = tes3mp.GetAttributeId("Luck")		
					local valueS2 = Players[Pid].data.attributes.Luck.base - 1
					tes3mp.SetAttributeBase(Pid, attrId2, valueS2)	
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.chanceCount = Players[Pid].data.customVariables.chanceCount - 1
				elseif Comp == "Chance" and ChanceCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Chance" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end	
			end
			
			if HungerCount == nil then
				Players[Pid].data.customVariables.hungerCount = 0
				HungerCount = Players[Pid].data.customVariables.hungerCount			
			else
				if Comp == "Hunger" and HungerCount < 5 and PointCount >= 3 and State == "Add" then
					Players[Pid].data.customVariables.HungerTimeMax = Players[Pid].data.customVariables.HungerTimeMax + 60
					Players[Pid].data.customVariables.hungerCount = Players[Pid].data.customVariables.hungerCount + 1
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3
				elseif Comp == "Hunger" and HungerCount > 0 and State == "Remove" then
					Players[Pid].data.customVariables.HungerTimeMax = Players[Pid].data.customVariables.HungerTimeMax - 60
					Players[Pid].data.customVariables.hungerCount = Players[Pid].data.customVariables.hungerCount - 1
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 3
				elseif Comp == "Hunger" and HungerCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
				elseif Comp == "Hunger" and HungerCount ~= nil and PointCount < 3 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "3.")								
				end
			end
			
			if ThirstCount == nil then
				Players[Pid].data.customVariables.thirstCount = 0
				ThirstCount = Players[Pid].data.customVariables.thirstCount			
			else
				if Comp == "Thirst" and ThirstCount < 5 and PointCount >= 3 and State == "Add" then
					Players[Pid].data.customVariables.ThirsthTimeMax = Players[Pid].data.customVariables.ThirsthTimeMax + 60			
					Players[Pid].data.customVariables.thirstCount = Players[Pid].data.customVariables.thirstCount + 1
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3
				elseif Comp == "Thirst" and ThirstCount > 0 and State == "Remove" then
					Players[Pid].data.customVariables.ThirsthTimeMax = Players[Pid].data.customVariables.ThirsthTimeMax - 60			
					Players[Pid].data.customVariables.thirstCount = Players[Pid].data.customVariables.thirstCount - 1
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 3
				elseif Comp == "Thirst" and ThirstCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Thirst" and ThirstCount ~= nil and PointCount < 3 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "3.")								
				end
			end
			
			if SleepCount == nil then
				Players[Pid].data.customVariables.sleepCount = 0
				SleepCount = Players[Pid].data.customVariables.sleepCount			
			else
				if Comp == "Sleep" and SleepCount < 5 and PointCount >= 3 and State == "Add" then
					Players[Pid].data.customVariables.SleepTimeMax = Players[Pid].data.customVariables.SleepTimeMax + 120
					Players[Pid].data.customVariables.sleepCount = Players[Pid].data.customVariables.sleepCount + 1
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3
				elseif Comp == "Sleep" and SleepCount > 0 and State == "Remove" then
					Players[Pid].data.customVariables.SleepTimeMax = Players[Pid].data.customVariables.SleepTimeMax - 120
					Players[Pid].data.customVariables.sleepCount = Players[Pid].data.customVariables.sleepCount - 1
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 3
				elseif Comp == "Sleep" and SleepCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
				elseif Comp == "Sleep" and SleepCount ~= nil and PointCount < 3 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "3.")								
				end
			end	
			
			if LifeCount == nil then
				Players[Pid].data.customVariables.life = 0
				LifeCount = Players[Pid].data.customVariables.life		
			else
				if Comp == "Life" and LifeCount < 5 and PointCount >= 3 and State == "Add" then -- guerrier
					local valueS = Players[Pid].data.stats.healthBase + 10		
					tes3mp.SetHealthBase(Pid, valueS)
					Players[Pid].data.customVariables.life = Players[Pid].data.customVariables.life + 1
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3
				elseif Comp == "Life" and LifeCount > 0 and State == "Remove" then -- guerrier
					local valueS = Players[Pid].data.stats.healthBase - 10		
					tes3mp.SetHealthBase(Pid, valueS)
					Players[Pid].data.customVariables.life = Players[Pid].data.customVariables.life - 1
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 3
				elseif Comp == "Life" and LifeCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Life" and LifeCount ~= nil and PointCount < 3 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "3.")								
				end
			end	
			
			if PeauCount == nil then
				Players[Pid].data.customVariables.peau = 0
				PeauCount = Players[Pid].data.customVariables.peau			
			else
				if Comp == "Peau" and PeauCount < 5 and PointCount >= 3 and State == "Add" then	-- mage
					local valueS = Players[Pid].data.stats.magickaBase + 10	
					tes3mp.SetMagickaBase(Pid, valueS)	
					Players[Pid].data.customVariables.peau = Players[Pid].data.customVariables.peau + 1
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3
				elseif Comp == "Peau" and PeauCount > 0 and State == "Remove" then	-- mage
					local valueS = Players[Pid].data.stats.magickaBase - 10	
					tes3mp.SetMagickaBase(Pid, valueS)	
					Players[Pid].data.customVariables.peau = Players[Pid].data.customVariables.peau - 1
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 3
				elseif Comp == "Peau" and PeauCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
				elseif Comp == "Peau" and PeauCount ~= nil and PointCount < 3 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "3.")								
				end
			end	
			
			if GuexpCount == nil then
				Players[Pid].data.customVariables.guexp = 0
				GuexpCount = Players[Pid].data.customVariables.guexp		
			else
				if Comp == "Guexp" and GuexpCount < 5 and PointCount >= 3 and State == "Add" then -- voleur	
					local valueS2 = Players[Pid].data.stats.fatigueBase + 10
					tes3mp.SetFatigueBase(Pid, valueS2)					
					Players[Pid].data.customVariables.guexp = Players[Pid].data.customVariables.guexp + 1
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3
				elseif Comp == "Guexp" and GuexpCount > 0 and State == "Remove" then -- voleur	
					local valueS2 = Players[Pid].data.stats.fatigueBase - 10
					tes3mp.SetFatigueBase(Pid, valueS2)					
					Players[Pid].data.customVariables.guexp = Players[Pid].data.customVariables.guexp - 1
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 3
				elseif Comp == "Guexp" and GuexpCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Guexp" and GuexpCount ~= nil and PointCount < 3 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "3.")								
				end
			end	

			if BlockCount == nil then
				Players[Pid].data.customVariables.blockCount = 0
				BlockCount = Players[Pid].data.customVariables.blockCount		
			else		
				if Comp == "Block" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Block")
					local valueC = Players[Pid].data.skills.Block.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.blockCount = Players[Pid].data.customVariables.blockCount + 1	
				elseif Comp == "Block" and BlockCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Block")
					local valueC = Players[Pid].data.skills.Block.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.blockCount = Players[Pid].data.customVariables.blockCount - 1
				elseif Comp == "Block" and BlockCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
				elseif Comp == "Block" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if AlchemyCount == nil then
				Players[Pid].data.customVariables.alchemyCount = 0
				AlchemyCount = Players[Pid].data.customVariables.alchemyCount		
			else		
				if Comp == "Alchemy" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Alchemy")
					local valueC = Players[Pid].data.skills.Alchemy.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.alchemyCount = Players[Pid].data.customVariables.alchemyCount + 1					
				elseif Comp == "Alchemy" and AlchemyCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Alchemy")
					local valueC = Players[Pid].data.skills.Alchemy.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.alchemyCount = Players[Pid].data.customVariables.alchemyCount - 1
				elseif Comp == "Alchemy" and AlchemyCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Alchemy" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if HandtohandCount == nil then
				Players[Pid].data.customVariables.handtohandCount = 0
				HandtohandCount = Players[Pid].data.customVariables.handtohandCount		
			else		
				if Comp == "Handtohand" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Handtohand")
					local valueC = Players[Pid].data.skills.Handtohand.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.handtohandCount = Players[Pid].data.customVariables.handtohandCount + 1					
				elseif Comp == "Handtohand" and HandtohandCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Handtohand")
					local valueC = Players[Pid].data.skills.Handtohand.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.handtohandCount = Players[Pid].data.customVariables.handtohandCount - 1
				elseif Comp == "Handtohand" and HandtohandCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Handtohand" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if ConjurationCount == nil then
				Players[Pid].data.customVariables.conjurationCount = 0
				ConjurationCount = Players[Pid].data.customVariables.conjurationCount		
			else		
				if Comp == "Conjuration" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Conjuration")
					local valueC = Players[Pid].data.skills.Conjuration.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.conjurationCount = Players[Pid].data.customVariables.conjurationCount + 1
				elseif Comp == "Conjuration" and ConjurationCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Conjuration")
					local valueC = Players[Pid].data.skills.Conjuration.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.conjurationCount = Players[Pid].data.customVariables.conjurationCount - 1
				elseif Comp == "Conjuration" and ConjurationCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
				elseif Comp == "Conjuration" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if ShortbladeCount == nil then
				Players[Pid].data.customVariables.shortbladeCount = 0
				ShortbladeCount = Players[Pid].data.customVariables.shortbladeCount		
			else		
				if Comp == "Shortblade" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Shortblade")
					local valueC = Players[Pid].data.skills.Shortblade.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.shortbladeCount = Players[Pid].data.customVariables.shortbladeCount + 1
				elseif Comp == "Shortblade" and ShortbladeCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Shortblade")
					local valueC = Players[Pid].data.skills.Shortblade.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.shortbladeCount = Players[Pid].data.customVariables.shortbladeCount - 1
				elseif Comp == "Shortblade" and ShortbladeCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Shortblade" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if AlterationCount == nil then
				Players[Pid].data.customVariables.alterationCount = 0
				AlterationCount = Players[Pid].data.customVariables.alterationCount		
			else		
				if Comp == "Alteration" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Alteration")
					local valueC = Players[Pid].data.skills.Alteration.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.alterationCount = Players[Pid].data.customVariables.alterationCount + 1
				elseif Comp == "Alteration" and AlterationCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Alteration")
					local valueC = Players[Pid].data.skills.Alteration.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.alterationCount = Players[Pid].data.customVariables.alterationCount - 1
				elseif Comp == "Alteration" and AlterationCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Alteration" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if MediumarmorCount == nil then
				Players[Pid].data.customVariables.mediumarmorCount = 0
				MediumarmorCount = Players[Pid].data.customVariables.mediumarmorCount		
			else			
				if Comp == "Mediumarmor" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Mediumarmor")
					local valueC = Players[Pid].data.skills.Mediumarmor.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.mediumarmorCount = Players[Pid].data.customVariables.mediumarmorCount + 1
				elseif Comp == "Mediumarmor" and MediumarmorCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Mediumarmor")
					local valueC = Players[Pid].data.skills.Mediumarmor.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.mediumarmorCount = Players[Pid].data.customVariables.mediumarmorCount - 1
				elseif Comp == "Mediumarmor" and MediumarmorCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Mediumarmor" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if HeavyarmorCount == nil then
				Players[Pid].data.customVariables.heavyarmorCount = 0
				HeavyarmorCount = Players[Pid].data.customVariables.heavyarmorCount		
			else			
				if Comp == "Heavyarmor" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Heavyarmor")
					local valueC = Players[Pid].data.skills.Heavyarmor.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.heavyarmorCount = Players[Pid].data.customVariables.heavyarmorCount + 1
				elseif Comp == "Heavyarmor" and HeavyarmorCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Heavyarmor")
					local valueC = Players[Pid].data.skills.Heavyarmor.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.heavyarmorCount = Players[Pid].data.customVariables.heavyarmorCount - 1
				elseif Comp == "Heavyarmor" and HeavyarmorCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Heavyarmor" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if BluntweaponCount == nil then
				Players[Pid].data.customVariables.bluntweaponCount = 0
				BluntweaponCount = Players[Pid].data.customVariables.bluntweaponCount		
			else		
				if Comp == "Bluntweapon" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Bluntweapon")
					local valueC = Players[Pid].data.skills.Bluntweapon.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.bluntweaponCount = Players[Pid].data.customVariables.bluntweaponCount + 1
				elseif Comp == "Bluntweapon" and BluntweaponCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Bluntweapon")
					local valueC = Players[Pid].data.skills.Bluntweapon.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.bluntweaponCount = Players[Pid].data.customVariables.bluntweaponCount - 1	
				elseif Comp == "Bluntweapon" and BluntweaponCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Bluntweapon" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if MarksmanCount == nil then
				Players[Pid].data.customVariables.marksmanCount = 0
				MarksmanCount = Players[Pid].data.customVariables.marksmanCount		
			else		
				if Comp == "Marksman" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Marksman")
					local valueC = Players[Pid].data.skills.Marksman.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.marksmanCount	= Players[Pid].data.customVariables.marksmanCount + 1	
				elseif Comp == "Marksman" and MarksmanCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Marksman")
					local valueC = Players[Pid].data.skills.Marksman.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.marksmanCount	= Players[Pid].data.customVariables.marksmanCount - 1
				elseif Comp == "Marksman" and MarksmanCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
				elseif Comp == "Marksman" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if AcrobaticsCount == nil then
				Players[Pid].data.customVariables.acrobaticsCount = 0
				AcrobaticsCount = Players[Pid].data.customVariables.acrobaticsCount		
			else		
				if Comp == "Acrobatics" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Acrobatics")
					local valueC = Players[Pid].data.skills.Acrobatics.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.acrobaticsCount = Players[Pid].data.customVariables.acrobaticsCount + 1
				elseif Comp == "Acrobatics" and AcrobaticsCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Acrobatics")
					local valueC = Players[Pid].data.skills.Acrobatics.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.acrobaticsCount = Players[Pid].data.customVariables.acrobaticsCount - 1
				elseif Comp == "Acrobatics" and AcrobaticsCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Acrobatics" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if SneakCount == nil then
				Players[Pid].data.customVariables.sneakCount = 0
				SneakCount = Players[Pid].data.customVariables.sneakCount		
			else		
				if Comp == "Sneak" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Sneak")
					local valueC = Players[Pid].data.skills.Sneak.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.sneakCount = Players[Pid].data.customVariables.sneakCount	+ 1	
				elseif Comp == "Sneak" and SneakCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Sneak")
					local valueC = Players[Pid].data.skills.Sneak.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.sneakCount = Players[Pid].data.customVariables.sneakCount	- 1	
				elseif Comp == "Sneak" and SneakCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
				elseif Comp == "Sneak" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if LightarmorCount == nil then
				Players[Pid].data.customVariables.lightarmorCount = 0
				LightarmorCount = Players[Pid].data.customVariables.lightarmorCount		
			else		
				if Comp == "Lightarmor" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Lightarmor")
					local valueC = Players[Pid].data.skills.Lightarmor.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.lightarmorCount = Players[Pid].data.customVariables.lightarmorCount + 1
				elseif Comp == "Lightarmor" and LightarmorCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Lightarmor")
					local valueC = Players[Pid].data.skills.Lightarmor.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.lightarmorCount = Players[Pid].data.customVariables.lightarmorCount - 1
				elseif Comp == "Lightarmor" and LightarmorCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Lightarmor" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if LongbladeCount == nil then
				Players[Pid].data.customVariables.longbladeCount = 0
				LongbladeCount = Players[Pid].data.customVariables.longbladeCount		
			else		
				if Comp == "Longblade" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Longblade")
					local valueC = Players[Pid].data.skills.Longblade.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.longbladeCount = Players[Pid].data.customVariables.longbladeCount + 1
				elseif Comp == "Longblade" and LongbladeCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Longblade")
					local valueC = Players[Pid].data.skills.Longblade.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.longbladeCount = Players[Pid].data.customVariables.longbladeCount - 1
				elseif Comp == "Longblade" and LongbladeCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Longblade" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if ArmorerCount == nil then
				Players[Pid].data.customVariables.armorerCount = 0
				ArmorerCount = Players[Pid].data.customVariables.armorerCount		
			else		
				if Comp == "Armorer" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Armorer")
					local valueC = Players[Pid].data.skills.Armorer.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.armorerCount = Players[Pid].data.customVariables.armorerCount + 1
				elseif Comp == "Armorer" and ArmorerCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Armorer")
					local valueC = Players[Pid].data.skills.Armorer.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.armorerCount = Players[Pid].data.customVariables.armorerCount - 1
				elseif Comp == "Armorer" and ArmorerCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Armorer" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if SpeechcraftCount == nil then
				Players[Pid].data.customVariables.speechcraftCount = 0
				SpeechcraftCount = Players[Pid].data.customVariables.speechcraftCount		
			else			
				if Comp == "Speechcraft" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Speechcraft")
					local valueC = Players[Pid].data.skills.Speechcraft.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.speechcraftCount = Players[Pid].data.customVariables.speechcraftCount + 1
				elseif Comp == "Speechcraft" and SpeechcraftCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Speechcraft")
					local valueC = Players[Pid].data.skills.Speechcraft.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.speechcraftCount = Players[Pid].data.customVariables.speechcraftCount - 1	
				elseif Comp == "Speechcraft" and SpeechcraftCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Speechcraft" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if AxeCount == nil then
				Players[Pid].data.customVariables.axeCount = 0
				AxeCount = Players[Pid].data.customVariables.axeCount		
			else		
				if Comp == "Axe" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Axe")
					local valueC = Players[Pid].data.skills.Axe.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.axeCount = Players[Pid].data.customVariables.axeCount + 1
				elseif Comp == "Axe" and AxeCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Axe")
					local valueC = Players[Pid].data.skills.Axe.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.axeCount = Players[Pid].data.customVariables.axeCount - 1
				elseif Comp == "Axe" and AxeCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
				elseif Comp == "Axe" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if SecurityCount == nil then
				Players[Pid].data.customVariables.securityCount = 0
				SecurityCount = Players[Pid].data.customVariables.securityCount		
			else		
				if Comp == "Security" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Security")
					local valueC = Players[Pid].data.skills.Security.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.securityCount = Players[Pid].data.customVariables.securityCount + 1
				elseif Comp == "Security" and SecurityCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Security")
					local valueC = Players[Pid].data.skills.Security.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.securityCount = Players[Pid].data.customVariables.securityCount - 1
				elseif Comp == "Security" and SecurityCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
				elseif Comp == "Security" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if EnchantCount == nil then
				Players[Pid].data.customVariables.enchantCount = 0
				EnchantCount = Players[Pid].data.customVariables.enchantCount		
			else			
				if Comp == "Enchant" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Enchant")
					local valueC = Players[Pid].data.skills.Enchant.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.enchantCount = Players[Pid].data.customVariables.enchantCount + 1
				elseif Comp == "Enchant" and EnchantCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Enchant")
					local valueC = Players[Pid].data.skills.Enchant.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.enchantCount = Players[Pid].data.customVariables.enchantCount - 1
				elseif Comp == "Enchant" and EnchantCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
				elseif Comp == "Enchant" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if DestructionCount == nil then
				Players[Pid].data.customVariables.destructionCount = 0
				DestructionCount = Players[Pid].data.customVariables.destructionCount		
			else		
				if Comp == "Destruction" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Destruction")
					local valueC = Players[Pid].data.skills.Destruction.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.destructionCount = Players[Pid].data.customVariables.destructionCount + 1
				elseif Comp == "Destruction" and DestructionCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Destruction")
					local valueC = Players[Pid].data.skills.Destruction.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.destructionCount = Players[Pid].data.customVariables.destructionCount - 1
				elseif Comp == "Destruction" and DestructionCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
				elseif Comp == "Destruction" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if AthleticsCount == nil then
				Players[Pid].data.customVariables.athleticsCount = 0
				AthleticsCount = Players[Pid].data.customVariables.athleticsCount		
			else		
				if Comp == "Athletics" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Athletics")
					local valueC = Players[Pid].data.skills.Athletics.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.athleticsCount = Players[Pid].data.customVariables.athleticsCount + 1
				elseif Comp == "Athletics" and AthleticsCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Athletics")
					local valueC = Players[Pid].data.skills.Athletics.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.athleticsCount = Players[Pid].data.customVariables.athleticsCount - 1	
				elseif Comp == "Athletics" and AthleticsCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
				elseif Comp == "Athletics" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if IllusionCount == nil then
				Players[Pid].data.customVariables.illusionCount = 0
				IllusionCount = Players[Pid].data.customVariables.illusionCount		
			else		
				if Comp == "Illusion" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Illusion")
					local valueC = Players[Pid].data.skills.Illusion.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.illusionCount	= Players[Pid].data.customVariables.illusionCount + 1
				elseif Comp == "Illusion" and IllusionCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Illusion")
					local valueC = Players[Pid].data.skills.Illusion.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.illusionCount	= Players[Pid].data.customVariables.illusionCount - 1
				elseif Comp == "Illusion" and IllusionCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
				elseif Comp == "Illusion" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if MysticismCount == nil then
				Players[Pid].data.customVariables.mysticismCount = 0
				MysticismCount = Players[Pid].data.customVariables.mysticismCount		
			else		
				if Comp == "Mysticism" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Mysticism")
					local valueC = Players[Pid].data.skills.Mysticism.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.mysticismCount = Players[Pid].data.customVariables.mysticismCount + 1
				elseif Comp == "Mysticism" and MysticismCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Mysticism")
					local valueC = Players[Pid].data.skills.Mysticism.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.mysticismCount = Players[Pid].data.customVariables.mysticismCount - 1
				elseif Comp == "Mysticism" and MysticismCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
				elseif Comp == "Mysticism" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if SpearCount == nil then
				Players[Pid].data.customVariables.spearCount = 0
				SpearCount = Players[Pid].data.customVariables.spearCount		
			else		
				if Comp == "Spear" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Spear")
					local valueC = Players[Pid].data.skills.Spear.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.spearCount = Players[Pid].data.customVariables.spearCount + 1
				elseif Comp == "Spear" and SpearCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Spear")
					local valueC = Players[Pid].data.skills.Spear.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.spearCount = Players[Pid].data.customVariables.spearCount - 1
				elseif Comp == "Spear" and SpearCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Spear" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if MercantileCount == nil then
				Players[Pid].data.customVariables.mercantileCount = 0
				MercantileCount = Players[Pid].data.customVariables.mercantileCount		
			else		
				if Comp == "Mercantile" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Mercantile")
					local valueC = Players[Pid].data.skills.Mercantile.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.mercantileCount = Players[Pid].data.customVariables.mercantileCount + 1
				elseif Comp == "Mercantile" and MercantileCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Mercantile")
					local valueC = Players[Pid].data.skills.Mercantile.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.mercantileCount = Players[Pid].data.customVariables.mercantileCount - 1
				elseif Comp == "Mercantile" and MercantileCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
				elseif Comp == "Mercantile" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if RestorationCount == nil then
				Players[Pid].data.customVariables.restorationCount = 0
				RestorationCount = Players[Pid].data.customVariables.restorationCount		
			else		
				if Comp == "Restoration" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Restoration")
					local valueC = Players[Pid].data.skills.Restoration.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.restorationCount = Players[Pid].data.customVariables.restorationCount + 1
				elseif Comp == "Restoration" and RestorationCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Restoration")
					local valueC = Players[Pid].data.skills.Restoration.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.restorationCount = Players[Pid].data.customVariables.restorationCount - 1
				elseif Comp == "Restoration" and RestorationCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
				elseif Comp == "Restoration" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end

			if UnarmoredCount == nil then
				Players[Pid].data.customVariables.unarmoredCount = 0
				UnarmoredCount = Players[Pid].data.customVariables.unarmoredCount		
			else		
				if Comp == "Unarmored" and PointCount >= 1 and State == "Add" then
					local skillId = tes3mp.GetSkillId("Unarmored")
					local valueC = Players[Pid].data.skills.Unarmored.base + 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 1
					Players[Pid].data.customVariables.unarmoredCount = Players[Pid].data.customVariables.unarmoredCount + 1
				elseif Comp == "Unarmored" and UnarmoredCount > 0 and State == "Remove" then
					local skillId = tes3mp.GetSkillId("Unarmored")
					local valueC = Players[Pid].data.skills.Unarmored.base - 1
					tes3mp.SetSkillBase(Pid, skillId, valueC)			
					Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul + 1
					Players[Pid].data.customVariables.unarmoredCount = Players[Pid].data.customVariables.unarmoredCount - 1
				elseif Comp == "Unarmored" and UnarmoredCount == 0 and State == "Remove" then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
				elseif Comp == "Unarmored" and PointCount < 1 then
					tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow.. "1.")								
				end
			end
			
			Players[Pid]:SaveStatsDynamic()		
			Players[Pid]:SaveAttributes()	
			Players[Pid]:SaveSkills()			
			tes3mp.SendAttributes(Pid)
			tes3mp.SendSkills(Pid)	
			tes3mp.SendStatsDynamic(Pid)	
		end
	end
end	

EcarlateSoul.OnPlayerDeath = function(eventStatus, Pid)
	if Players[Pid] ~= nil and Players[Pid]:IsLoggedIn() then
		if eventStatus.validCustomHandlers then	
			local soulLoc = Players[Pid].data.customVariables.soul
			local levelSoul = Players[Pid].data.customVariables.levelSoul	
			local capSoul = Players[Pid].data.customVariables.capSoul
			local pointSoul = Players[Pid].data.customVariables.pointSoul
			local totalPerte 
			if levelSoul == nil then
				Players[Pid].data.customVariables.levelSoul = 1
				levelSoul = Players[Pid].data.customVariables.levelSoul
			end	
			if capSoul ~= nil then
				Players[Pid].data.customVariables.capSoul = levelSoul * 500
			else 
				Players[Pid].data.customVariables.capSoul = levelSoul * 500
				capSoul = Players[Pid].data.customVariables.capSoul
			end	
			if pointSoul == nil then
				Players[Pid].data.customVariables.pointSoul = 0
				pointSoul = Players[Pid].data.customVariables.pointSoul
			end	
			if soulLoc == nil then
				Players[Pid].data.customVariables.soul = 0	
				soulLoc = Players[Pid].data.customVariables.soul
				totalPerte = 0
			else
				totalPerte = math.floor((soulLoc * 25) / 100)	
				Players[Pid].data.customVariables.soul = Players[Pid].data.customVariables.soul - totalPerte
			end	
			tes3mp.MessageBox(Pid, -1, color.Default..trad.Death..color.Green..totalPerte..color.Default..trad.Pts..color.Yellow..trad.Xps)
		end
	end
end

EcarlateSoul.MainMenu = function(Pid)
    if Players[Pid]~= nil and Players[Pid]:IsLoggedIn() then
		if not tes3mp.IsWerewolf(Pid) then
			Players[Pid].currentCustomMenu = "menu cmp ecarlate"
			menuHelper.DisplayMenu(Pid, Players[Pid].currentCustomMenu)
		else
			tes3mp.MessageBox(Pid, -1, trad.WereWolf)
		end
	end
end

customCommandHooks.registerCommand("soul", EcarlateSoul.MainMenu)
customEventHooks.registerHandler("OnActorDeath", EcarlateSoul.OnPlayerKillCreature)
customEventHooks.registerHandler("OnPlayerDeath", EcarlateSoul.OnPlayerDeath)

return EcarlateSoul
