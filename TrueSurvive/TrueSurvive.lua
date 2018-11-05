--TrueSurvive.lua by Rick-Off and David.C

--TrueSurvive v 0.0.2
--tes3mp v 0.7.0
--openmw v 0.44

--A script that simulates the primary need for survival( sleep, drink, eat, attack max, weather)

tableHelper = require("tableHelper")
inventoryHelper = require("inventoryHelper")

local list_survive_eatdrinksleep = {"true_survive_fatigue", "true_survive_hunger", "true_survive_thirsth"}
local list_survive_weather = {"true_weather_ash", "true_weather_blight", "true_weather_snow", "true_weather_blizzard", "true_weather_thunder", "true_weather_rain", "true_weather_overcast", "true_weather_fog", "true_weather_clear"}

local SurviveMessage = {}
SurviveMessage.Fatigue = "You are tired, you should go to sleep!"
SurviveMessage.Hunger = "You are hungry, you should eat!"
SurviveMessage.Thirsth = "You are thirsty, you should drink!"
SurviveMessage.Sleep = "You rested."
SurviveMessage.Eat = "You eaten ."
SurviveMessage.Drink = "You drank ."

local config = {}
config.timerMessage = 10
config.timerCheck = 3 
config.sleepTime = 1200 
config.eatTime = 600 
config.drinkTime = 600 

local TrueSurvive = {}

local TimerStartStats = tes3mp.CreateTimer("StartCheckStats", time.seconds(config.timerCheck))
local TimerStartMessage = tes3mp.CreateTimer("StartCheckMessage", time.seconds(config.timerMessage))

local ListActivableDrinkingObjects = {"potion_ancient_brandy", "san_food_beer1b", "san_food_beer2", "aa_Big Ass Mug O' Mead", "KO_mug_tea_CH", "nom_beer_02", "nom_beer_03", "nom_beer_04", "nom_beer_08", "nom_beer_09", "nom_juice_apple", "nom_juice_comberry", "nom_juice_orange", "nom_juice_pear", "nom_wine_02", "nom_wine_03", "nom_wine_04", "nom_wine_08", "nom_wine_09", "p_vintagecomberrybrandy1", "plx_Guar_Milk", "potion_skooma_01", "potion_local_liquor_01", "Potion_Local_Brew_01", "Potion_Cyro_Whiskey_01", "potion_cyro_brandy_01", "potion_comberry_wine_01", "potion_comberry_brandy_01", "misc_com_bottle_01", "misc_com_bottle_02", "misc_com_bottle_03", "misc_com_bottle_04", "misc_com_bottle_05", "misc_com_bottle_06", "misc_com_bottle_08", "misc_com_bottle_09", "misc_com_bottle_11", "misc_com_bottle_13", "misc_com_bottle_14" }
local ListNoDisableDrinkingObjects = {"ex_nord_well_01", "nom_water_round", "ex_vivec_waterfall_01", "Ex_waterfall_mist_s_01", "furn_lavacave_pool00", "furn_moldcave_pool00", "furn_moldcave_spout00", "furn_mudcave_pool00", "furn_pycave_pool00", "nom_furn2_lavacave_pool00", "nom_furn_lavacave_pool00", "nom_kegstand_beer", "nom_kegstand_beer_de", "nom_kegstand_wine", "nom_kegstand_wine_de", "nom_MH_spuot", "nom_water_barrel", "nom_water_round", "nom_well_common_01", "nom_well_common_strong1", "nom_well_nord_01", "nom_well_nord_colony1", "Act_BM_well_01"}
local ListActivatableDiningObjects = {"Fshan_corn", "Fshan_egg01", "Fshan_egg02", "Fshan_fatfish", "Fshan_friedfish", "Fshan_garlic", "Fshan_grilledfish", "Fshan_lemon", "Fshan_lettuce01", "Fshan_meat", "Fshan_onion", "Fshan_orange", "Fshan_pear", "Fshan_pumpkin", "Fshan_saltfish", "Fshan_sucklingpig", "Fshan_tomato", "Fshan_veg", "Fshan_watermelon", "Fshan_wmelon_slice", "ingred_bear_meat_SA", "ingred_wolf_meat_SA", "nom_food_a_apple", "nom_food_a_lemon", "nom_food_a_orange", "nom_food_a_pear", "nom_food_a_tomato", "nom_food_bittergreen", "nom_food_bittersweet", "nom_food_boiled_rice", "nom_food_boiled_rice2", "nom_food_cheese", "nom_food_cheese2", "nom_food_cheese3", "nom_food_cheese_pie", "nom_food_chickenleg1", "nom_food_chickenleg1_breaded", "nom_food_chickenleg1_cook", "nom_food_corn", "nom_food_corn_boil", "nom_food_corn_roast", "nom_food_crab_slice", "nom_food_egg2", "nom_food_fish", "nom_food_fish_fat_01", "nom_food_fish_fat_02", "nom_food_fried_fish", "nom_food_grilled_fish", "nom_food_hackle-lo", "nom_food_ham", "nom_food_lemon_fish", "nom_food_marshmerrow", "nom_food_meat", "nom_food_meat_grilled", "nom_food_meat_grilled2", "nom_food_moon_pudding", "nom_food_omelette", "nom_food_omelette_crab", "nom_food_pie_appl", "nom_food_pie_comb", "nom_food_pie_oran", "nom_food_pie_pear", "nom_food_rat_pie", "nom_food_soup_onion", "nom_food_soup_rat", "nom_salt", "nom_sltw_food_a_banana", "nom_sltw_food_a_onion", "nom_sltw_food_bread_corn", "nom_sltw_food_cookiebig", "nom_sltw_food_cookiesmall", "nom_sugar", "plx_alit_meat", "plx_alit_meat_B", "plx_alit_meat_D", "plx_guar_meat", "plx_ingred_HellHound", "plx_ingred_kriin_flesh", "plx_ingred_paraflesh", "plx_kagouti_meat", "plx_netch_jelly", "plx_rabbit_foot", "plx_squirrel_tail", "sm_apple01", "sm_apple02", "sm_beef_meat_01", "sm_blackberries", "sm_CDOO_heart", "sm_orange", "tw_bread10b", "tw_bread10c", "tw_bread10d", "tw_bread10f", "tw_bread10g", "tw_bread11b", "tw_bread12", "tw_bread1a", "tw_bread2c", "tw_bread2d", "tw_bread2e", "tw_bread2f", "tw_bread2g", "tw_bread2h", "tw_bread2i", "tw_bread2l", "tw_bread2o", "tw_bread3a", "tw_bread3c", "tw_bread7c", "tw_bread7e", "tw_bread7f", "tw_bread7i", "tw_db_grapes01", "tw_db_grapes02", "tw_db_potatoe", "tw_monkshood", "tw_motherwort", "tw_NI_mandrakeroot", "tw_par_fireflower", "tw_prickly_pear2", "tw_radish", "tw_strawberry", "zz_dogFood", "tw_tobacaleaves", "bar_pie", "bar_pie01", "san_food_cake3", "san_food_cake3b", "san_food_cake8", "san_food_cake8b", "san_food_cake_a", "san_food_cake_b", "san_food_cake_c", "san_food_cake_d", "11AA_combategg", "1jw_KO_chicken_CH", "1jw_KO_potatoe_CH", "1jw_KO_pudding", "aa_ingred_monkshood_01", "Fshan_apple", "Fshan_apple2", "Fshan_banana", "Fshan_bigfish", "Fshan_bluecheese", "Fshan_chickenleg1", "ingred_willow_anther_01", "ingred_black_anther_01", "ingred_comberry_01", "ingred_kwama_cuttle_01", "ingred_heather_01", "ingred_roobrush_01", "ingred_bc_spore_pod", "ingred_crab_meat_01", "ingred_coprinus_01", "ingred_scuttle_01", "ingred_chokeweed_01", "ingred_kresh_fiber_01", "ingred_bc_coda_flower", "ingred_scrib_jelly_01", "food_kwama_egg_02", "ingred_scathecraw_01", "ingred_bc_hypha_facia", "ingred_ash_yam_01", "ingred_gold_kanet_01", "ingred_black_lichen_01", "ingred_red_lichen_01", "ingred_green_lichen_01", "ingred_bread_01_UNI3", "ingred_bread_01", "ingred_bread_01_UNI2", "food_kwama_egg_01", "ingred_marshmerrow_01", "ingred_bittergreen_petals_01", "ingred_stoneflower_petals_01", "ingred_corkbulb_root_01", "ingred_saltrice_01", "ingred_moon_sugar_01", "ingred_hound_meat_01", "ingred_rat_meat_01", "ingred_scrib_jerky_01", "ingred_wickwheat_01"}
local ListActivatableSleepingObjects = {"active_de_bed_29", "active_de_bed_30", "active_de_bedroll", "active_de_p_bed_03", "active_de_p_bed_04", "active_de_p_bed_05", "active_de_p_bed_09", "active_de_p_bed_10", "active_de_p_bed_11", "active_de_p_bed_12", "active_de_p_bed_13", "active_de_p_bed_14", "active_de_p_bed_15", "active_de_p_bed_16", "active_de_p_bed_28", "active_de_pr_bed_07", "active_de_pr_bed_08", "active_de_pr_bed_21", "active_de_pr_bed_22", "active_de_pr_bed_23", "active_de_pr_bed_24", "active_de_pr_bed_25", "active_de_pr_bed_26", "active_de_pr_bed_27", "active_de_r_bed_01", "active_de_r_bed_02", "active_de_r_bed_06", "active_de_r_bed_17", "active_de_r_bed_18", "active_de_r_bed_19", "active_de_r_bed_20"}
-- ===========
-- TIMER START
-- ===========

TrueSurvive.TimerStartCheck = function()
	tes3mp.StartTimer(TimerStartStats)
	tes3mp.StartTimer(TimerStartMessage)	
	tes3mp.LogAppend(enumerations.log.INFO, "....START TIMER CHECK SURVIVE....")			
end

function StartCheckStats()

	for pid, player in pairs(Players) do
		if Players[pid] ~= nil and player:IsLoggedIn() then	
			TrueSurvive.OnCheckTimePlayers(pid)
		end
	end

    tes3mp.RestartTimer(TimerStartStats, time.seconds(config.timerCheck))
end


function StartCheckMessage()

	for pid, player in pairs(Players) do
		if Players[pid] ~= nil and player:IsLoggedIn() then	
			TrueSurvive.OnCheckMessagePlayersSleep(pid)
		end
	end

    tes3mp.RestartTimer(TimerStartMessage, time.seconds(config.timerMessage))
end

-- ==================
-- CHECK TIMER PLAYER
-- ==================

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
		
	end
end

-- =================
-- CHECK STAT PLAYER
-- =================

TrueSurvive.OnCheckStatePlayer = function(pid)

	local listattack = {"true_survive_attack"}
	local listfatigue = {"true_survive_fatigue"}	
	local attackspell
	local fatiguespell
	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
	
		for slot, k in pairs(Players[pid].data.spellbook) do
			if Players[pid].data.spellbook[slot] == "true_survive_attack" then
				attackspell = Players[pid].data.spellbook[slot]
			elseif Players[pid].data.spellbook[slot] == "true_survive_fatigue" then 
				fatiguespell = Players[pid].data.spellbook[slot]
			end
		end	
		
		local PlayerHealth = tes3mp.GetHealthCurrent(pid)
		local PlayerHealthBase = tes3mp.GetHealthBase(pid)	
		local PlayerMagicka = tes3mp.GetMagickaCurrent(pid)
		local PlayerMagickaBase = tes3mp.GetMagickaBase(pid)		
		local PlayerFatigue = tes3mp.GetFatigueCurrent(pid)
		local PlayerFatigueBase = tes3mp.GetFatigueBase(pid)

		if PlayerFatigue <= (PlayerFatigueBase / 3) and PlayerFatigue > 0 and tableHelper.containsValue(listattack, attackspell) then	
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_attack")
			logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerJumping")
			
		elseif PlayerFatigue > (PlayerFatigueBase / 3) and not tableHelper.containsValue(listattack, attackspell) then	
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_attack")
			logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerJumping")
			
		elseif PlayerFatigue <= 0 and tableHelper.containsValue(listfatigue, fatiguespell) then				
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_fatigue")		
		end
		
		if PlayerHealth <= 0 then	
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_hunger")
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_fatigue")
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_thirsth")
		end
	end
end		
-- ===================
-- CHECK SLEEP PLAYER
-- ===================
TrueSurvive.OnCheckMessagePlayersSleep = function(pid)

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			
		local PlayerFatigue = tes3mp.GetFatigueCurrent(pid)	
		local SleepTime = Players[pid].data.customVariables.SleepTime

		if SleepTime ~= nil and SleepTime >= config.sleepTime then
			if PlayerFatigue > 0 then		
				local spellid
				local spellcible
				for slot, k in pairs(Players[pid].data.spellbook) do
					if Players[pid].data.spellbook[slot] ~= "true_survive_rests" then
						if Players[pid].data.spellbook[slot] == "true_survive_fatigue" then
							spellid = Players[pid].data.spellbook[slot]
						end
					else
						spellcible = true
					end
				end	
				
				if spellcible ~= nil then
					logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_rests")
				end	
			
				if tableHelper.containsValue(list_survive_eatdrinksleep, spellid) then				
					tes3mp.MessageBox(pid, -1, SurviveMessage.Fatigue)
					logicHandler.RunConsoleCommandOnPlayer(pid, "FadeOut, 2")
					logicHandler.RunConsoleCommandOnPlayer(pid, "Fadein, 2")
					
				else
					tes3mp.MessageBox(pid, -1, SurviveMessage.Fatigue)
					logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_fatigue")
					logicHandler.RunConsoleCommandOnPlayer(pid, "FadeOut, 2")
					logicHandler.RunConsoleCommandOnPlayer(pid, "Fadein, 2")			

				end
			end		
		elseif SleepTime ~= nil and SleepTime >= (config.sleepTime / 2) and SleepTime < config.sleepTime then
			if PlayerFatigue > 0 then			
				local spellcible
				for slot, k in pairs(Players[pid].data.spellbook) do
					if Players[pid].data.spellbook[slot] ~= "true_survive_rests" then

					else
						spellcible = true
					end
				end		
				
				if spellcible ~= nil then
					logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_rests")
				end	
			end
		end
		TrueSurvive.OnCheckMessagePlayersHunger(pid)
	end
end
-- ====================
-- CHECK HUNGER PLAYER
-- ====================	
TrueSurvive.OnCheckMessagePlayersHunger = function(pid)	

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
	
		local PlayerHealth = tes3mp.GetHealthCurrent(pid)
		local HungerTime = Players[pid].data.customVariables.HungerTime
		
		if HungerTime ~= nil and HungerTime >= config.eatTime then	
		
			if PlayerHealth > 0 then		
				local spellid
				local spellcible
				for slot, k in pairs(Players[pid].data.spellbook) do
					if Players[pid].data.spellbook[slot] ~= "true_survive_digestion" then
						if Players[pid].data.spellbook[slot] == "true_survive_hunger" then
							spellid = Players[pid].data.spellbook[slot]
						end
					else
						spellcible = true
					end
				end	
				
				if spellcible ~= nil then
					logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_digestion")
				end			
			
				if tableHelper.containsValue(list_survive_eatdrinksleep, spellid) then
					tes3mp.MessageBox(pid, -1, SurviveMessage.Hunger)
				else
					tes3mp.MessageBox(pid, -1, SurviveMessage.Hunger)					
					logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_hunger")
				end
			end			
		elseif HungerTime ~= nil and HungerTime >= (config.eatTime / 2) and HungerTime < config.eatTime then
		
			if PlayerHealth > 0 then			
				local spellcible
				for slot, k in pairs(Players[pid].data.spellbook) do
					if Players[pid].data.spellbook[slot] ~= "true_survive_digestion" then

					else
						spellcible = true
					end
				end		
				
				if spellcible ~= nil then
					logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_digestion")
				end	
			end	
		end
		TrueSurvive.OnCheckMessagePlayersThirsth(pid)		
	end	
end
-- ====================
-- CHECK THIRSTH PLAYER
-- ====================
TrueSurvive.OnCheckMessagePlayersThirsth = function(pid)	

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
	
		local PlayerMagicka = tes3mp.GetMagickaCurrent(pid)	
		local ThirsthTime = Players[pid].data.customVariables.ThirsthTime
		
		if ThirsthTime ~= nil and ThirsthTime >= config.drinkTime then
		
			if PlayerMagicka > 0 then		
				local spellid
				local spellcible
				for slot, k in pairs(Players[pid].data.spellbook) do
					if Players[pid].data.spellbook[slot] ~= "true_survive_hydrated" then
						if Players[pid].data.spellbook[slot] == "true_survive_thirsth" then
							spellid = Players[pid].data.spellbook[slot]
						end
					else
						spellcible = true
					end
				end	
				
				if spellcible ~= nil then
					logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_hydrated")
				end			
			
				if tableHelper.containsValue(list_survive_eatdrinksleep, spellid) then					
					tes3mp.MessageBox(pid, -1, SurviveMessage.Thirsth)	
				else					
					tes3mp.MessageBox(pid, -1, SurviveMessage.Thirsth)
					logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_thirsth")											
				end
			end			
		elseif ThirsthTime ~= nil and ThirsthTime >= (config.drinkTime / 2) and ThirsthTime < config.drinkTime then	
			if PlayerMagicka > 0 then			
				local spellcible
				for slot, k in pairs(Players[pid].data.spellbook) do
					if Players[pid].data.spellbook[slot] ~= "true_survive_hydrated" then

					else
						spellcible = true
					end
				end		
				
				if spellcible ~= nil then
					logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_hydrated")
				end	
			end			
		end	
		TrueSurvive.OnCheckMessagePlayersWeather(pid)		
	end	
end
-- ====================
-- CHECK WEATHER PLAYER
-- ====================
TrueSurvive.OnCheckMessagePlayersWeather = function(pid)	

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
	
		local regionName = Players[pid].data.location.regionName
		
		if regionName ~= "" then			
		
			local playerWeather = WorldInstance.storedRegions[regionName].currentWeather

			if WorldInstance.storedRegions[regionName].currentWeather == 0 then	
				--clear		
				local spell
				local spellcible
				for slot, k in pairs(Players[pid].data.spellbook) do
					if Players[pid].data.spellbook[slot] ~= "true_weather_clear" then
						spell = Players[pid].data.spellbook[slot]
					else
						spellcible = true
					end
					
					if tableHelper.containsValue(list_survive_weather, spell) then				
						logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell "..spell)
					end
				end	
				
				if spellcible == nil then
					logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_weather_clear")
				end								
			elseif WorldInstance.storedRegions[regionName].currentWeather == 1 then
				--Cloudy			
				local spell				
				for slot, k in pairs(Players[pid].data.spellbook) do
					spell = Players[pid].data.spellbook[slot]
			
					if tableHelper.containsValue(list_survive_weather, spell) then				
						logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell "..spell)
					end
				end									
			elseif WorldInstance.storedRegions[regionName].currentWeather == 2 then
				--Foggy
				local spell
				local spellcible				
				for slot, k in pairs(Players[pid].data.spellbook) do
					if Players[pid].data.spellbook[slot] ~= "true_weather_fog" then
						spell = Players[pid].data.spellbook[slot]
					else
						spellcible = true
					end
					
					if tableHelper.containsValue(list_survive_weather, spell) then				
						logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell "..spell)
					end
				end	
				
				if spellcible == nil then
					logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_weather_fog")
				end									
			elseif WorldInstance.storedRegions[regionName].currentWeather == 3 then
				--Overcast
				local spell
				local spellcible					
				for slot, k in pairs(Players[pid].data.spellbook) do
					if Players[pid].data.spellbook[slot] ~= "true_weather_overcast" then
						spell = Players[pid].data.spellbook[slot]
					else
						spellcible = true
					end
					
					if tableHelper.containsValue(list_survive_weather, spell) then				
						logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell "..spell)
					end
				end	
				
				if spellcible == nil then
					logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_weather_overcast")		
				end								
			elseif WorldInstance.storedRegions[regionName].currentWeather == 4 then
				--Rain
				local spell
				local spellcible
				for slot, k in pairs(Players[pid].data.spellbook) do
					if Players[pid].data.spellbook[slot] ~= "true_weather_rain" then
						spell = Players[pid].data.spellbook[slot]
					else
						spellcible = true
					end
					
					if tableHelper.containsValue(list_survive_weather, spell) then				
						logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell "..spell)
					end
				end	

				if spellcible == nil then
					logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_weather_rain")		
				end								
			elseif WorldInstance.storedRegions[regionName].currentWeather == 5 then
				--Thunder
				local spell
				local spellcible
				for slot, k in pairs(Players[pid].data.spellbook) do
					if Players[pid].data.spellbook[slot] ~= "true_weather_thunder" then
						spell = Players[pid].data.spellbook[slot]
					else
						spellcible = true
					end
					
					if tableHelper.containsValue(list_survive_weather, spell) then				
						logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell "..spell)
					end
				end		

				if spellcible == nil then
					logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_weather_thunder")		
				end					
			elseif WorldInstance.storedRegions[regionName].currentWeather == 6 then
				--Ash		
				local spell
				local spellcible
				for slot, k in pairs(Players[pid].data.spellbook) do
					if Players[pid].data.spellbook[slot] ~= "true_weather_ash" then
						spell = Players[pid].data.spellbook[slot]
					else
						spellcible = true
					end
					
					if tableHelper.containsValue(list_survive_weather, spell) then				
						logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell "..spell)
					end
				end		
				
				if spellcible == nil then
					logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_weather_ash")	
				end					
			elseif WorldInstance.storedRegions[regionName].currentWeather == 7 then
				--Blight
				local spell
				local spellcible
				for slot, k in pairs(Players[pid].data.spellbook) do
					if Players[pid].data.spellbook[slot] ~= "true_weather_blight" then
						spell = Players[pid].data.spellbook[slot]
					else
						spellcible = true
					end
					
					if tableHelper.containsValue(list_survive_weather, spell) then				
						logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell "..spell)
					end
				end	

				if spellcible == nil then
					logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_weather_blight")		
				end					
			elseif WorldInstance.storedRegions[regionName].currentWeather == 8 then
				--Snow 
				local spell
				local spellcible
				for slot, k in pairs(Players[pid].data.spellbook) do
					if Players[pid].data.spellbook[slot] ~= "true_weather_snow" then
						spell = Players[pid].data.spellbook[slot]
					else
						spellcible = true
					end
					
					if tableHelper.containsValue(list_survive_weather, spell) then				
						logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell "..spell)
					end
				end	

				if spellcible == nil then
					logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_weather_snow")	
				end								
			elseif WorldInstance.storedRegions[regionName].currentWeather == 9 then
				--Blizzard  
				local spell
				local spellcible
				for slot, k in pairs(Players[pid].data.spellbook) do
					if Players[pid].data.spellbook[slot] ~= "true_weather_blizzard" then
						spell = Players[pid].data.spellbook[slot]
					end
					
					if tableHelper.containsValue(list_survive_weather, spell) then				
						logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell "..spell)
					end
				end	
				
				if spellcible == nil then
					logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_weather_blizzard")
				end					
			end
		else
			local spell
			for slot, k in pairs(Players[pid].data.spellbook) do
				spell = Players[pid].data.spellbook[slot]
		
				if tableHelper.containsValue(list_survive_weather, spell) then				
					logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell "..spell)
				end
			end
		end	
	end
end


-- =====================
-- OBJECT ACTIVATED MENU
-- =====================

TrueSurvive.OnActivatedObject = function(objectRefId, pid)

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then

		if tableHelper.containsValue(ListActivableDrinkingObjects, objectRefId) then	-- drink
			Players[pid].currentCustomMenu = "survive drink"--Menu drink
			menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
			tes3mp.LogAppend(enumerations.log.INFO, objectRefId)	
			return true
		end
		
		if tableHelper.containsValue(ListNoDisableDrinkingObjects, objectRefId) then	-- drink
			Players[pid].currentCustomMenu = "survive drink active"--Menu drink
			menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
			tes3mp.LogAppend(enumerations.log.INFO, objectRefId)	
			return true
		end		
		
		if tableHelper.containsValue(ListActivatableDiningObjects, objectRefId) then	-- eat
			Players[pid].currentCustomMenu = "survive hunger"--Menu Hunger
			menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
			tes3mp.LogAppend(enumerations.log.INFO, objectRefId)
			return true
		end		
		
		if tableHelper.containsValue(ListActivatableSleepingObjects, objectRefId) then -- sleep	
			Players[pid].currentCustomMenu = "survive sleep"--Menu Sleep
			menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
			tes3mp.LogAppend(enumerations.log.INFO, objectRefId)
			return true
		end	
		
	end
	
	return false
end

-- ================
-- OBJECT ACTIVATED
-- ================

TrueSurvive.OnHungerObject = function(pid)

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local HungerTime = 0
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_hunger")
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_digestion")
		tes3mp.MessageBox(pid, -1, SurviveMessage.Eat)		
		Players[pid].data.customVariables.HungerTime = HungerTime	
	end	
end

TrueSurvive.OnDrinkObject = function(pid)

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local Thirsth = 0
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_thirsth")
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_hydrated")
		tes3mp.MessageBox(pid, -1, SurviveMessage.Drink)		
		Players[pid].data.customVariables.ThirsthTime = Thirsth	
	end	
end

TrueSurvive.OnSleepObject = function(pid)

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local SleepTime = 0
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_fatigue")	
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_rests")
		logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerControls")
		logicHandler.RunConsoleCommandOnPlayer(pid, "FadeOut, 2")
		logicHandler.RunConsoleCommandOnPlayer(pid, "Fadein, 5")
		tes3mp.MessageBox(pid, -1, SurviveMessage.Sleep)
		logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerControls")		
		Players[pid].data.customVariables.SleepTime = SleepTime
	end
end

return TrueSurvive

---------
--SETUP--
---------

--add in Menu.lua
--[[
Menus["survive hunger"] = {
    text = color.Gold .. "Do you want\n" .. color.LightGreen ..
    "eat\n" .. color.Gold .. "this food ?\n" ..
        color.White .. "...",
    buttons = {						
        { caption = "yes",
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
        { caption = "no",
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
    text = color.Gold .. "Do you want\n" .. color.LightGreen ..
    "drink\n" .. color.Gold .. "the contained ?\n" ..
        color.White .. "...",
    buttons = {                        
        { caption = "yes",
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
        { caption = "no",
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
    text = color.Gold .. "Do you want\n" .. color.LightGreen ..
    "drink\n" .. color.Gold .. "the contained ?\n" ..
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
    text = color.Gold .. "Do you want\n" .. color.LightGreen ..
    "sleep\n" .. color.Gold .. "in this bed\n" ..
        color.White .. "...",
    buttons = {						
        { caption = "yes",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TrueSurvive", "OnSleepObject", 
					{menuHelper.variables.currentPid()})
                })
            }
        },			
        { caption = "no",
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

	
--add custom spell permanent records

  "permanentRecords":{
    "true_weather_blizzard":{
      "name":"Blizzard",
      "subtype":4,
      "cost":0,
      "flags":0,
      "effects":[{
          "id":17,
          "attribute":0,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":20,
          "magnitudeMin":20
        },{
          "id":17,
          "attribute":1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":20,
          "magnitudeMin":20
        },{
          "id":17,
          "attribute":3,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":20,
          "magnitudeMin":19
        },{
          "id":17,
          "attribute":4,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":20,
          "magnitudeMin":20
        }]
    },  
    "true_weather_snow":{
      "name":"Snow",
      "subtype":4,
      "cost":0,
      "flags":0,
      "effects":[{
          "id":17,
          "attribute":0,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":0,
          "magnitudeMax":20,
          "magnitudeMin":20
        },{
          "id":17,
          "attribute":5,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":20,
          "magnitudeMin":20
        },{
          "id":17,
          "attribute":3,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":10,
          "magnitudeMin":10
        },{
          "id":17,
          "attribute":4,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":10,
          "magnitudeMin":10
        }]
    },  
    "true_weather_blight":{
      "name":"Blight",
      "subtype":4,
      "cost":0,
      "flags":0,
      "effects":[{
          "id":17,
          "attribute":1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":20,
          "magnitudeMin":20
        },{
          "id":17,
          "attribute":2,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":20,
          "magnitudeMin":20
        },{
          "id":17,
          "attribute":3,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":20,
          "magnitudeMin":20
        },{
          "id":17,
          "attribute":6,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":20,
          "magnitudeMin":20
        }]
    },  
    "true_weather_ash":{
      "name":"Ash",
      "subtype":4,
      "cost":0,
      "flags":0,
      "effects":[{
          "id":17,
          "attribute":0,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":10,
          "magnitudeMin":10
        },{
          "id":17,
          "attribute":4,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":10,
          "magnitudeMin":10
        },{
          "id":17,
          "attribute":2,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":10,
          "magnitudeMin":10
        },{
          "id":17,
          "attribute":7,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":30,
          "magnitudeMin":30
        }]
    },  
    "true_weather_thunder":{
      "name":"Thunder",
      "subtype":4,
      "cost":0,
      "flags":0,
      "effects":[{
          "id":17,
          "attribute":1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":20,
          "magnitudeMin":20
        },{
          "id":17,
          "attribute":2,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":20,
          "magnitudeMin":20
        },{
          "id":17,
          "attribute":6,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":20,
          "magnitudeMin":20
        },{
          "id":17,
          "attribute":7,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":20,
          "magnitudeMin":20
        }]
    },  
    "true_weather_rain":{
      "name":"Rain",
      "subtype":4,
      "cost":0,
      "flags":0,
      "effects":[{
          "id":17,
          "attribute":4,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":20,
          "magnitudeMin":20
        },{
          "id":17,
          "attribute":2,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":20,
          "magnitudeMin":20
        },{
          "id":17,
          "attribute":7,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":20,
          "magnitudeMin":20
        },{
          "id":17,
          "attribute":1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":10,
          "magnitudeMin":10
        }]
    },  
    "true_weather_overcast":{
      "name":"Overcast",
      "subtype":4,
      "cost":0,
      "flags":0,
      "effects":[{
          "id":17,
          "attribute":7,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":10,
          "magnitudeMin":10
        },{
          "id":17,
          "attribute":6,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":10,
          "magnitudeMin":10
        },{
          "id":17,
          "attribute":2,
          "skill":-1,
          "rangeType":1,
          "area":0,
          "duration":-1,
          "magnitudeMax":10,
          "magnitudeMin":10
        }]
    },  
    "true_weather_fog":{
      "name":"Fog",
      "subtype":4,
      "cost":0,
      "flags":0,
      "effects":[{
          "id":17,
          "attribute":3,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":10,
          "magnitudeMin":10
        },{
          "id":17,
          "attribute":4,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":10,
          "magnitudeMin":10
        },{
          "id":17,
          "attribute":7,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":10,
          "magnitudeMin":10
        }]
    },  
    "true_weather_clear":{
      "name":"Clear",
      "subtype":4,
      "cost":0,
      "flags":0,
      "effects":[{
          "id":79,
          "attribute":4,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":10,
          "magnitudeMin":10
        },{
          "id":79,
          "attribute":2,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":10,
          "magnitudeMin":10
        },{
          "id":79,
          "attribute":3,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":10,
          "magnitudeMin":10
        },{
          "id":79,
          "attribute":7,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":-1,
          "magnitudeMax":10,
          "magnitudeMin":10
        }]
    },  
    "true_survive_digestion":{
      "name":"Digestion",
      "subtype":4,
      "cost":1,
      "flags":0,
      "effects":[{
          "id":75,
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
          "magnitudeMax":5,
          "magnitudeMin":5
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
          "magnitudeMax":1,
          "magnitudeMin":1
        }]
    },
    "true_survive_hunger":{
      "name":"Hunger",
      "subtype":4,
      "cost":1,
      "flags":0,
      "effects":[{
          "id":23,
          "attribute":-1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":0,
          "magnitudeMax":1,
          "magnitudeMin":1
        }]
    },
    "true_survive_hydrated":{
      "name":"Hydrated",
      "subtype":4,
      "cost":1,
      "flags":0,
      "effects":[{
          "id":76,
          "attribute":-1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":1,
          "magnitudeMax":1,
          "magnitudeMin":1
        }]
    },
    "true_survive_attack":{
      "name":"Attack Max",
      "subtype":4,
      "cost":1,
      "flags":0,
      "effects":[{
          "id":117,
          "attribute":-1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":1,
          "magnitudeMax":100,
          "magnitudeMin":100
        }]
    },
    "true_survive_rests":{
      "name":"Rest",
      "subtype":4,
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


