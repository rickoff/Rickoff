--TrueSurvive.lua by Rick-Off and David.C

--TrueSurvive v 0.0.1
--tes3mp v 0.7.0
--openmw v 0.44

--A script that simulates the primary need for survival( sleep, drink, eat)

--the next version will include the weather


tableHelper = require("tableHelper")
inventoryHelper = require("inventoryHelper")

local list_survive_fatigue = {"true_survive_fatigue"}
local list_survive_hunger = {"true_survive_hunger"}
local list_survive_thirsth = {"true_survive_thirsth"}

local config = {}

config.timerCheck = 10 --seconds
config.sleepTime = 360 
config.eatTime = 180 
config.drinkTime = 180 

local TrueSurvive = {}


local TimerStartStats = tes3mp.CreateTimer("StartCheckStats", time.seconds(config.timerCheck))

local listactivabledrinkingobjects = {"potion_ancient_brandy", "san_food_beer1b", "san_food_beer2", "aa_Big Ass Mug O' Mead", "KO_mug_tea_CH", "nom_beer_02", "nom_beer_03", "nom_beer_04", "nom_beer_08", "nom_beer_09", "nom_juice_apple", "nom_juice_comberry", "nom_juice_orange", "nom_juice_pear", "nom_wine_02", "nom_wine_03", "nom_wine_04", "nom_wine_08", "nom_wine_09", "p_vintagecomberrybrandy1", "plx_Guar_Milk", "potion_skooma_01", "potion_local_liquor_01", "Potion_Local_Brew_01", "Potion_Cyro_Whiskey_01", "potion_cyro_brandy_01", "potion_comberry_wine_01", "potion_comberry_brandy_01", "misc_com_bottle_01", "misc_com_bottle_02", "misc_com_bottle_03", "misc_com_bottle_04", "misc_com_bottle_05", "misc_com_bottle_06", "misc_com_bottle_08", "misc_com_bottle_09", "misc_com_bottle_11", "misc_com_bottle_13", "misc_com_bottle_14" }
local listnodisabledrinkingobjects = {"ex_nord_well_01", "nom_water_round", "ex_vivec_waterfall_01", "Ex_waterfall_mist_s_01", "furn_lavacave_pool00", "furn_moldcave_pool00", "furn_moldcave_spout00", "furn_mudcave_pool00", "furn_pycave_pool00", "nom_furn2_lavacave_pool00", "nom_furn_lavacave_pool00", "nom_kegstand_beer", "nom_kegstand_beer_de", "nom_kegstand_wine", "nom_kegstand_wine_de", "nom_MH_spuot", "nom_water_barrel", "nom_water_round", "nom_well_common_01", "nom_well_common_strong1", "nom_well_nord_01", "nom_well_nord_colony1", "Act_BM_well_01"}
local listactivatablediningobjects = {"Fshan_corn", "Fshan_egg01", "Fshan_egg02", "Fshan_fatfish", "Fshan_friedfish", "Fshan_garlic", "Fshan_grilledfish", "Fshan_lemon", "Fshan_lettuce01", "Fshan_meat", "Fshan_onion", "Fshan_orange", "Fshan_pear", "Fshan_pumpkin", "Fshan_saltfish", "Fshan_sucklingpig", "Fshan_tomato", "Fshan_veg", "Fshan_watermelon", "Fshan_wmelon_slice", "ingred_bear_meat_SA", "ingred_wolf_meat_SA", "nom_food_a_apple", "nom_food_a_lemon", "nom_food_a_orange", "nom_food_a_pear", "nom_food_a_tomato", "nom_food_bittergreen", "nom_food_bittersweet", "nom_food_boiled_rice", "nom_food_boiled_rice2", "nom_food_cheese", "nom_food_cheese2", "nom_food_cheese3", "nom_food_cheese_pie", "nom_food_chickenleg1", "nom_food_chickenleg1_breaded", "nom_food_chickenleg1_cook", "nom_food_corn", "nom_food_corn_boil", "nom_food_corn_roast", "nom_food_crab_slice", "nom_food_egg2", "nom_food_fish", "nom_food_fish_fat_01", "nom_food_fish_fat_02", "nom_food_fried_fish", "nom_food_grilled_fish", "nom_food_hackle-lo", "nom_food_ham", "nom_food_lemon_fish", "nom_food_marshmerrow", "nom_food_meat", "nom_food_meat_grilled", "nom_food_meat_grilled2", "nom_food_moon_pudding", "nom_food_omelette", "nom_food_omelette_crab", "nom_food_pie_appl", "nom_food_pie_comb", "nom_food_pie_oran", "nom_food_pie_pear", "nom_food_rat_pie", "nom_food_soup_onion", "nom_food_soup_rat", "nom_salt", "nom_sltw_food_a_banana", "nom_sltw_food_a_onion", "nom_sltw_food_bread_corn", "nom_sltw_food_cookiebig", "nom_sltw_food_cookiesmall", "nom_sugar", "plx_alit_meat", "plx_alit_meat_B", "plx_alit_meat_D", "plx_guar_meat", "plx_ingred_HellHound", "plx_ingred_kriin_flesh", "plx_ingred_paraflesh", "plx_kagouti_meat", "plx_netch_jelly", "plx_rabbit_foot", "plx_squirrel_tail", "sm_apple01", "sm_apple02", "sm_beef_meat_01", "sm_blackberries", "sm_CDOO_heart", "sm_orange", "tw_bread10b", "tw_bread10c", "tw_bread10d", "tw_bread10f", "tw_bread10g", "tw_bread11b", "tw_bread12", "tw_bread1a", "tw_bread2c", "tw_bread2d", "tw_bread2e", "tw_bread2f", "tw_bread2g", "tw_bread2h", "tw_bread2i", "tw_bread2l", "tw_bread2o", "tw_bread3a", "tw_bread3c", "tw_bread7c", "tw_bread7e", "tw_bread7f", "tw_bread7i", "tw_db_grapes01", "tw_db_grapes02", "tw_db_potatoe", "tw_monkshood", "tw_motherwort", "tw_NI_mandrakeroot", "tw_par_fireflower", "tw_prickly_pear2", "tw_radish", "tw_strawberry", "zz_dogFood", "tw_tobacaleaves", "bar_pie", "bar_pie01", "san_food_cake3", "san_food_cake3b", "san_food_cake8", "san_food_cake8b", "san_food_cake_a", "san_food_cake_b", "san_food_cake_c", "san_food_cake_d", "11AA_combategg", "1jw_KO_chicken_CH", "1jw_KO_potatoe_CH", "1jw_KO_pudding", "aa_ingred_monkshood_01", "Fshan_apple", "Fshan_apple2", "Fshan_banana", "Fshan_bigfish", "Fshan_bluecheese", "Fshan_chickenleg1", "ingred_willow_anther_01", "ingred_black_anther_01", "ingred_comberry_01", "ingred_kwama_cuttle_01", "ingred_heather_01", "ingred_roobrush_01", "ingred_bc_spore_pod", "ingred_crab_meat_01", "ingred_coprinus_01", "ingred_scuttle_01", "ingred_chokeweed_01", "ingred_kresh_fiber_01", "ingred_bc_coda_flower", "ingred_scrib_jelly_01", "food_kwama_egg_02", "ingred_scathecraw_01", "ingred_bc_hypha_facia", "ingred_ash_yam_01", "ingred_gold_kanet_01", "ingred_black_lichen_01", "ingred_red_lichen_01", "ingred_green_lichen_01", "ingred_bread_01_UNI3", "ingred_bread_01", "ingred_bread_01_UNI2", "food_kwama_egg_01", "ingred_marshmerrow_01", "ingred_bittergreen_petals_01", "ingred_stoneflower_petals_01", "ingred_corkbulb_root_01", "ingred_saltrice_01", "ingred_moon_sugar_01", "ingred_hound_meat_01", "ingred_rat_meat_01", "ingred_scrib_jerky_01", "ingred_wickwheat_01"}
local listactivatablesleepingobjects = {"active_de_bed_29", "active_de_bed_30", "active_de_bedroll", "active_de_p_bed_03", "active_de_p_bed_04", "active_de_p_bed_05", "active_de_p_bed_09", "active_de_p_bed_10", "active_de_p_bed_11", "active_de_p_bed_12", "active_de_p_bed_13", "active_de_p_bed_14", "active_de_p_bed_15", "active_de_p_bed_16", "active_de_p_bed_28", "active_de_pr_bed_07", "active_de_pr_bed_08", "active_de_pr_bed_21", "active_de_pr_bed_22", "active_de_pr_bed_23", "active_de_pr_bed_24", "active_de_pr_bed_25", "active_de_pr_bed_26", "active_de_pr_bed_27", "active_de_r_bed_01", "active_de_r_bed_02", "active_de_r_bed_06", "active_de_r_bed_17", "active_de_r_bed_18", "active_de_r_bed_19", "active_de_r_bed_20"}

-- ===========
-- CHECK STATE
-- ===========

TrueSurvive.TimerStartCheck = function()
	tes3mp.StartTimer(TimerStartStats)
	tes3mp.LogAppend(enumerations.log.INFO, "....START TIMER CHECK SURVIVE....")			
end

function StartCheckStats()

	for pid, player in pairs(Players) do
		if Players[pid] ~= nil and player:IsLoggedIn() then	
			TrueSurvive.OnCheckTimePlayers(pid)
			tes3mp.LogAppend(enumerations.log.INFO, "....START CHECK TIME PLAYERS....")	
		end
	end

    tes3mp.RestartTimer(TimerStartStats, time.seconds(config.timerCheck))
    tes3mp.LogAppend(enumerations.log.INFO, "....RESTART TIMER CHECK....")
end



TrueSurvive.OnCheckTimePlayers = function(pid)

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
	
		local SleepTime = Players[pid].data.customVariables.SleepTime
		local HungerTime = Players[pid].data.customVariables.HungerTime
		local ThirsthTime = Players[pid].data.customVariables.ThirsthTime
		
		if SleepTime ~= nil then
			SleepTime = SleepTime + 1
		else
			SleepTime = 0
		end
		
		if HungerTime ~= nil then
			HungerTime = HungerTime + 1
		else
			HungerTime = 0
		end

		if ThirsthTime ~= nil then
			ThirsthTime = ThirsthTime + 1
		else
			ThirsthTime = 0
		end
		
		Players[pid].data.customVariables.SleepTime = SleepTime	
		Players[pid].data.customVariables.HungerTime = HungerTime				
		Players[pid].data.customVariables.ThirsthTime = ThirsthTime				

		TrueSurvive.OnCheckStatePlayer(pid)
		tes3mp.LogAppend(enumerations.log.INFO, "....CHECK STATE PLAYER....")
		
	end
	Players[pid]:Save()	
end

TrueSurvive.OnCheckStatePlayer = function(pid)

	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
		local PlayerHealth = tes3mp.GetHealthCurrent(pid)
		local PlayerHealthBase = tes3mp.GetHealthBase(pid)	
		local PlayerMagicka = tes3mp.GetMagickaCurrent(pid)
		local PlayerMagickaBase = tes3mp.GetMagickaBase(pid)		
		local PlayerFatigue = tes3mp.GetFatigueCurrent(pid)
		local PlayerFatigueBase = tes3mp.GetFatigueBase(pid)	
		local spellid
		local spellid2
		local spellid3

		if PlayerFatigue <= (PlayerFatigueBase / 3) and PlayerFatigue > 0 then
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_attack")
			logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerJumping")
			
		elseif PlayerFatigue > (PlayerFatigueBase / 3) then	
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_attack")
			logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerJumping")
			
		elseif PlayerFatigue <= 0 then			
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_fatigue")		
		end
		
		if PlayerHealth <= 0 then	
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_hunger")
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_fatigue")
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_thirsth")
		end
		
		local SleepTime = Players[pid].data.customVariables.SleepTime
		local HungerTime = Players[pid].data.customVariables.HungerTime
		local ThirsthTime = Players[pid].data.customVariables.ThirsthTime
		
		if SleepTime >= config.sleepTime then
		
			for slot, k in pairs(Players[pid].data.spellbook) do
				if Players[pid].data.spellbook[slot] == "true_survive_fatigue" then
					spellid = Players[pid].data.spellbook[slot]
				end
			end		
			
			if PlayerFatigue >= 1 then
			
				logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_rests")
				
				if tableHelper.containsValue(list_survive_fatigue, spellid) then				
					tes3mp.MessageBox(pid, -1, "Vous êtes fatigué, vous devriez aller dormir !")
					logicHandler.RunConsoleCommandOnPlayer(pid, "FadeOut, 2")
					logicHandler.RunConsoleCommandOnPlayer(pid, "Fadein, 2")
					
				else
					tes3mp.MessageBox(pid, -1, "Vous êtes fatigué, vous devriez aller dormir !")
					logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_fatigue")
					logicHandler.RunConsoleCommandOnPlayer(pid, "FadeOut, 2")
					logicHandler.RunConsoleCommandOnPlayer(pid, "Fadein, 2")			

				end
			end
			
		elseif SleepTime >= (config.sleepTime / 2) and SleepTime < config.sleepTime then
		
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_rests")			

		end
		
		if HungerTime >= config.eatTime then	

			for slot, k in pairs(Players[pid].data.spellbook) do
				if Players[pid].data.spellbook[slot] == "true_survive_hunger" then
					spellid2 = Players[pid].data.spellbook[slot]
				end
			end			
		
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_digestion")
			
			if tableHelper.containsValue(list_survive_hunger, spellid2) then

				tes3mp.MessageBox(pid, -1, "Vous avez faim, vous devriez vous restaurer !")
				
			else

				tes3mp.MessageBox(pid, -1, "Vous avez faim, vous devriez vous restaurer !")					
				logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_hunger")

			end
			
		elseif HungerTime >= (config.eatTime / 2) and HungerTime < config.eatTime then	
		
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_digestion")	

		end
		
		if ThirsthTime >= config.drinkTime then

			for slot, k in pairs(Players[pid].data.spellbook) do
				if Players[pid].data.spellbook[slot] == "true_survive_thirsth" then
					spellid3 = Players[pid].data.spellbook[slot]
				end
			end	
		
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_hydrated")
			
			if tableHelper.containsValue(list_survive_thirsth, spellid3) then			
				
				tes3mp.MessageBox(pid, -1, "Vous avez soif, vous devriez aller boire !")
				
			else				
				
				tes3mp.MessageBox(pid, -1, "Vous avez soif, vous devriez aller boire !")
				logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_thirsth")											

			end
			
		elseif ThirsthTime >= (config.drinkTime / 2) and ThirsthTime < config.drinkTime then	
		
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_hydrated")	

		end					
		Players[pid]:Save()	
	end
	
	tes3mp.RestartTimer(TimerStartStats, time.seconds(config.timerCheck))
	tes3mp.LogAppend(enumerations.log.INFO, "....RESTART TIMER CHECK....")	
end

TrueSurvive.OnActivatedObject = function(objectRefId, pid)

	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then

		if tableHelper.containsValue(listactivabledrinkingobjects, objectRefId) then	-- drink
			Players[pid].currentCustomMenu = "survive drink"--Menu drink
			menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
			tes3mp.LogAppend(enumerations.log.INFO, objectRefId)	
			return true
		end
		
		if tableHelper.containsValue(listnodisabledrinkingobjects, objectRefId) then	-- drink
			Players[pid].currentCustomMenu = "survive drink active"--Menu drink
			menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
			tes3mp.LogAppend(enumerations.log.INFO, objectRefId)	
			return true
		end		
		
		if tableHelper.containsValue(listactivatablediningobjects, objectRefId) then	-- eat
			Players[pid].currentCustomMenu = "survive hunger"--Menu Hunger
			menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
			tes3mp.LogAppend(enumerations.log.INFO, objectRefId)
			return true
		end		
		
		if tableHelper.containsValue(listactivatablesleepingobjects, objectRefId) then -- sleep	
			Players[pid].currentCustomMenu = "survive sleep"--Menu Sleep
			menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
			tes3mp.LogAppend(enumerations.log.INFO, objectRefId)
			return true
		end	
		
	end
	
	return false
end

TrueSurvive.OnHungerObject = function(pid)

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local HungerTime = 0
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_hunger")
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_digestion")
		Players[pid].data.customVariables.HungerTime = HungerTime	
	end
	Players[pid]:Save()		
end

TrueSurvive.OnDrinkObject = function(pid)

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local Thirsth = 0
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_thirsth")
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_hydrated")
		Players[pid].data.customVariables.ThirsthTime = Thirsth	
	end
	Players[pid]:Save()		
end

TrueSurvive.OnSleepObject = function(pid)

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local SleepTime = 0
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_fatigue")	
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_rests")
		logicHandler.RunConsoleCommandOnPlayer(pid, "FadeOut, 2")
		logicHandler.RunConsoleCommandOnPlayer(pid, "Fadein, 5")
		tes3mp.MessageBox(pid, -1, "Vous vous êtes reposés .")		
		Players[pid].data.customVariables.SleepTime = SleepTime
	end
	Players[pid]:Save()	
end

return TrueSurvive

---------
--SETUP--
---------

--add in Menu.lua
--[[
Menus["survive hunger"] = {
    text = color.Gold .. "Voulez vous\n" .. color.LightGreen ..
    "manger\n" .. color.Gold .. "cet aliment ?\n" ..
        color.White .. "...",
    buttons = {						
        { caption = "oui",
            destinations = {
				menuHelper.destinations.setDefault(nil,
				{ 
					menuHelper.effects.runGlobalFunction("TrueSurvive", "OnHungerObject", 
					{
                        menuHelper.variables.currentPid()
                    }),
                    menuHelper.effects.runGlobalFunction("logicHandler", "DeleteObjectForEveryone",
                    {
                        menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    })
                })
            }
        },            
        { caption = "non",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("logicHandler", "ActivateObjectForPlayer",
                    {
                        menuHelper.variables.currentPid(), menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    })
                })
            }
        }
    }
}

Menus["survive drink"] = {
    text = color.Gold .. "Voulez vous\n" .. color.LightGreen ..
    "boire\n" .. color.Gold .. "le contenue ?\n" ..
        color.White .. "...",
    buttons = {                        
        { caption = "oui",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("TrueSurvive", "OnDrinkObject", 
                    {
                        menuHelper.variables.currentPid()
                    }),
                    menuHelper.effects.runGlobalFunction("logicHandler", "DeleteObjectForEveryone",
                    {
                        menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    })
                })
            }
        },            
        { caption = "non",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("logicHandler", "ActivateObjectForPlayer",
                    {
                        menuHelper.variables.currentPid(), menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    })
                })
            }
        }
    }
}

Menus["survive drink active"] = {
    text = color.Gold .. "Voulez vous\n" .. color.LightGreen ..
    "boire\n" .. color.Gold .. "le contenue ?\n" ..
        color.White .. "...",
    buttons = {                        
        { caption = "oui",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("TrueSurvive", "OnDrinkObject", 
                    {
                        menuHelper.variables.currentPid()
                    })
                })
            }
        },            
        { caption = "non",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("logicHandler", "ActivateObjectForPlayer",
                    {
                        menuHelper.variables.currentPid(), menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    })
                })
            }
        }
    }
}

Menus["survive sleep"] = {
    text = color.Gold .. "Voulez vous\n" .. color.LightGreen ..
    "dormir\n" .. color.Gold .. "dans ce lit ?\n" ..
        color.White .. "...",
    buttons = {						
        { caption = "oui",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TrueSurvive", "OnSleepObject", 
					{menuHelper.variables.currentPid()})
                })
            }
        },			
        { caption = "non",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
                menuHelper.effects.runGlobalFunction("logicHandler", "ActivateObjectForPlayer",
                    {
                        menuHelper.variables.currentPid(), menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    })
                })
            }
        }
    }
}

--add in eventHandler.lua find eventHandler.OnObjectActivate = function(pid, cellDescription)

                if doesObjectHaveActivatingPlayer then
                    activatingPid = tes3mp.GetObjectActivatingPid(index)
                    
                    if isObjectPlayer then
                        Players[activatingPid].data.targetPid = objectPid
                        ActivePlayer.OnCheckStatePlayer(objectPid, activatingPid)
                    else
                        Players[activatingPid].data.targetRefId = objectRefId
                        Players[activatingPid].data.targetUniqueIndex = objectUniqueIndex
                        Players[activatingPid].data.targetCellDescription = cellDescription
                        isValid = not TrueSurvive.OnActivatedObject(objectRefId, activatingPid)                     
                    end

--add in logicHandler.lua

logicHandler.ActivateObjectForPlayer = function(pid, objectCellDescription, objectUniqueIndex)

    tes3mp.ClearObjectList()
    tes3mp.SetObjectListPid(pid)
    tes3mp.SetObjectListCell(objectCellDescription)

    local splitIndex = objectUniqueIndex:split("-")
    tes3mp.SetObjectRefNum(splitIndex[1])
    tes3mp.SetObjectMpNum(splitIndex[2])
    tes3mp.SetObjectActivatingPid(pid)

    tes3mp.AddObject()
    tes3mp.SendObjectActivate()
end
	
--add custom spell permanent records

  "permanentRecords":{
    "true_survive_digestion":{
      "name":"Digestion",
      "subtype":4,
      "cost":1,
      "flags":0,
      "effects":[{
          "id":77,
          "attribute":-1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":0,
          "magnitudeMax":1,
          "magnitudeMin":1
        }]
    },
    "true_survive_fatigue":{
      "name":"Fatigue",
      "subtype":4,
      "cost":1,
      "flags":0,
      "effects":[{
          "id":88,
          "attribute":-1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":0,
          "magnitudeMax":3,
          "magnitudeMin":3
        }]
    },
    "true_survive_thirsth":{
      "name":"Thirsth",
      "subtype":4,
      "cost":1,
      "flags":0,
      "effects":[{
          "id":87,
          "attribute":-1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":0,
          "magnitudeMax":2,
          "magnitudeMin":2
        }]
    },
    "true_survive_hunger":{
      "name":"Hunger",
      "subtype":4,
      "cost":1,
      "flags":0,
      "effects":[{
          "id":88,
          "attribute":-1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":0,
          "magnitudeMax":2,
          "magnitudeMin":2
        }]
    },
    "true_survive_hydrated":{
      "name":"Hydrated",
      "subtype":3,
      "cost":1,
      "flags":0,
      "effects":[{
          "id":76,
          "attribute":-1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":1,
          "magnitudeMax":2,
          "magnitudeMin":2
        }]
    },
    "true_survive_attack":{
      "name":"Maximus Attack",
      "subtype":3,
      "cost":1,
      "flags":0,
      "effects":[{
          "id":117,
          "attribute":-1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":1,
          "magnitudeMax":1000,
          "magnitudeMin":1000
        }]
    },
    "true_survive_rests":{
      "name":"Rests",
      "subtype":3,
      "cost":1,
      "flags":0,
      "effects":[{
          "id":77,
          "attribute":-1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":1,
          "magnitudeMax":1,
          "magnitudeMin":1
        }]
    }
  },
  
]]--


