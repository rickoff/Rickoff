--[[
EcarlateFurniture by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Achat Vente d'objet de decoration et autre
---------------------------
INSTALLATION:
Save the file as EcarlateFurniture.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
EcarlateFurniture = require("custom.EcarlateFurniture")
---------------------------
]]

local config = {}
config.whitelist = false --If true, the player must be given permission to place items in the cell that they're in (set using this script's methods, or editing the world.json). Note that this only prevents placement, players can still move/remove items they've placed in the cell.
config.sellbackModifier = 1.0 -- The base cost that an item is multiplied by when selling the items back (0.75 is 75%)

--GUI Ids used for the script's GUIs. Shouldn't have to be edited.
config.MainGUI = 31363
config.BuyGUI = 31364
config.InventoryGUI = 31365
config.ViewGUI = 31366
config.InventoryOptionsGUI = 31367
config.ViewOptionsGUI = 31368

------------
--Indexed table of all available furniture. refIds should be in all lowercase
--Best resource I could find online was this: http://tamriel-rebuilt.org/content/resource-guide-models-morrowind (note, items that begin with TR are part of Tamriel Rebuilt, not basic Morrowind, and it certainly doesn't list all the furniture items)

local furnitureData = {

--Containers
{name = "", refId = "", price = 00},
{name = "#red ..CONTENEURS", refId = "#option", price = 00},
{name = "Baril 1", refId = "barrel_01", price = 50},
{name = "Baril 2", refId = "barrel_02", price = 50},
{name = "Caisse 1", refId = "crate_01_empty", price = 200},
{name = "Caisse 2", refId = "crate_02_empty", price = 200},
{name = "Panier", refId = "com_basket_01", price = 50},
{name = "Sac (plat)", refId = "com_sack_01", price = 50},
{name = "Sac (sac)", refId = "com_sack_02", price = 50},
{name = "Sac (froisse)", refId = "com_sack_03", price = 50},
{name = "Sac (leger)", refId = "com_sack_00", price = 50},
{name = "Urne 1", refId = "urn_01", price = 100},
{name = "Urne 2", refId = "urn_02", price = 100},
{name = "Urne 3", refId = "urn_03", price = 100},
{name = "Urne 4", refId = "urn_04", price = 100},
{name = "Urne 5", refId = "urn_05", price = 100},
{name = "Fut en acier", refId = "dwrv_barrel00_empty", price = 150},
{name = "Barre en acier", refId = "dwrv_barrel10_empty", price = 75},

--Chesty Containers
{name = "", refId = "#option", price = 00},
{name = "#red ..COFFRES", refId = "#option", price = 00},
{name = "Cheap coffre", refId = "com_chest_11_empty", price = 150},
{name = "Cheap coffre (Ouvert)", refId = "com_chest_11_open", price = 150},
{name = "Petit coffre (Metal)", refId = "chest_small_01", price = 50}, --*2 price because fancier material
{name = "Petit coffre (Bois)", refId = "chest_small_02", price = 25},

--Imperial Furniture Set
{name = "", refId = "#option", price = 00},
{name = "#red ..IMPERIAL", refId = "#option", price = 00},
{name = "Imperial Armoire", refId = "com_closet_01", price = 300},
{name = "Imperial Placard", refId = "com_cupboard_01", price = 100},
{name = "Imperial Tiroirs", refId = "com_drawers_01", price = 300},
{name = "Imperial boite", refId = "com_hutch_01", price = 75},
{name = "Imperial coffre (Cheap)", refId = "com_chest_01", price = 150},
{name = "Imperial coffre (Fine)", refId = "com_chest_02", price = 400}, --*2 price because fancier

--Dunmer Furniture Set
{name = "", refId = "#option", price = 00},
{name = "#red ..TEMPLE", refId = "#option", price = 00},
{name = "Dunmer Placard (Cheap)", refId = "de_p_closet_02", price = 300},
{name = "Dunmer Placard (Fine)", refId = "de_r_closet_01", price = 600}, --*2 for quality
{name = "Dunmer Bureau", refId = "de_p_desk_01", price = 75},
{name = "Dunmer Tiroir (Cheap)", refId = "de_drawers_02", price = 300},
{name = "Dunmer Tiroir (Fine)", refId = "de_r_drawers_01", price = 600},
{name = "Dunmer Tiroir Table (Large)", refId = "de_p_table_02", price = 25},
{name = "Dunmer Tiroir Table (Petit)", refId = "de_p_table_01", price = 25},
{name = "Dunmer chaise (Cheap)", refId = "de_r_chest_01", price = 200},
{name = "Dunmer chaise (Fine)", refId = "de_p_chest_02", price = 400}, --*2 because fancy

--General Furniture
{name = "", refId = "#option", price = 00},
{name = "#red ..FOURNITURES", refId = "#option", price = 00},
{name = "Tabouret (Brut)", refId = "furn_de_ex_stool_02", price = 50},
{name = "Tabouret (Prayer)", refId = "furn_velothi_prayer_stool_01", price = 50},
{name = "Tabouret (Bar Stool)", refId = "furn_com_rm_barstool", price = 100},
{name = "chaise (Camp)", refId = "furn_com_pm_chair_02", price = 50},
{name = "chaise (General 1)", refId = "furn_com_rm_chair_03", price = 100},
{name = "chaise (General 2)", refId = "furn_de_p_chair_01", price = 100},
{name = "chaise (General 3)", refId = "furn_de_p_chair_02", price = 100},
{name = "chaise (Fine)", refId = "furn_de_r_chair_03", price = 200},
{name = "chaise (Padded)", refId = "furn_com_r_chair_01", price = 200},
{name = "chaise (Chieftain)", refId = "furn_chieftains_chair", price = 200},
{name = "Banc, Long (Cheap)", refId = "furn_de_p_bench_03", price = 200},
{name = "Banc, Court (Cheap)", refId = "furn_de_p_bench_04", price = 200},
{name = "Banc, Long (Fine)", refId = "furn_de_r_bench_01", price = 400},
{name = "Banc, Court (Fine)", refId = "furn_de_r_bench_02", price = 400},
{name = "Banc (Brut)", refId = "furn_de_p_bench_03", price = 150},
{name = "Banc Commun 1", refId = "furn_com_p_bench_01", price = 200},
{name = "Banc Commun 2", refId = "furn_com_rm_bench_02", price = 200},
{name = "Table, Grand Oval (Fine)", refId = "furn_de_r_table_03", price = 800},
{name = "Table, Grand Rectangle (Cheap)", refId = "furn_de_p_table_04", price = 400},
{name = "Table, Grand Rectangle (Fine)", refId = "furn_de_r_table_07", price = 800},
{name = "Table, petit Rond (Cheap) 1", refId = "furn_de_p_table_01", price = 400},
{name = "Table, petit Rond (Cheap) 2", refId = "furn_de_p_table_06", price = 400},
{name = "Table, petit Rond (Fine)", refId = "furn_de_r_table_08", price = 800},
{name = "Table, petit Carre (Cheap)", refId = "furn_de_p_table_05", price = 400},
{name = "Table, petit Carre (Fine)", refId = "furn_de_r_table_09", price = 800},
{name = "Table, petit Rond (Cheap)", refId = "furn_de_p_table_02", price = 400},
{name = "Table, Carre (Brut)", refId = "furn_de_ex_table_02", price = 200},
{name = "Table, Rectangle (Brut)", refId = "furn_de_ex_table_03", price = 200},
{name = "Table, Colonie", refId = "furn_com_table_colony", price = 400},
{name = "Table, Rectangle 1", refId = "furn_com_rm_table_04", price = 400},
{name = "Table, Rectangle 2", refId = "furn_com_r_table_01", price = 800},
{name = "Table, Petit Rectangle", refId = "furn_com_rm_table_05", price = 400},
{name = "Table, Ronde", refId = "furn_com_rm_table_03", price = 400},
{name = "Table, Ovale", refId = "furn_de_table10", price = 800},
{name = "Bar, milieu", refId = "furn_com_rm_bar_01", price = 200},
{name = "Bar, fin 1", refId = "furn_com_rm_bar_04", price = 200},
{name = "Bar, fin 2", refId = "furn_com_rm_bar_02", price = 200},
{name = "Bar, Coin", refId = "furn_com_rm_bar_03", price = 200},
{name = "Bar, milieu (Dunmer)", refId = "furn_de_bar_01", price = 200},
{name = "Bar, fin 1 (Dunmer)", refId = "furn_de_bar_04", price = 200},
{name = "Bar, fin 2 (Dunmer)", refId = "furn_de_bar_02", price = 200},
{name = "Bar, Coin (Dunmer)", refId = "furn_de_bar_03", price = 200},
{name = "Bar, porte", refId = "active_com_bar_door", price = 200},
{name = "Bibliothèque, soutenue (pas cher)", refId = "furn_com_rm_bookshelf_02", price = 500},
{name = "Bibliothèque, soutenue (qualite)", refId = "furn_com_r_bookshelf_01", price = 1000},
{name = "Bibliothèque, Debout (pas cher)", refId = "furn_de_p_bookshelf_01", price = 350},
{name = "Bibliothèque, Debout (qualite)", refId = "furn_de_r_bookshelf_02", price = 700},

--Beds
{name = "", refId = "#option", price = 00},
{name = "#red ..LITS", refId = "#option", price = 00},
{name = "Lit de camp", refId = "active_de_bedroll", price = 100},
{name = "Hammac", refId = "active_de_r_bed_02", price = 150},
{name = "Lit superpose 1", refId = "active_com_bunk_01", price = 800},
{name = "Lit superpose 2", refId = "active_com_bunk_02", price = 800},
{name = "Lit superpose 3", refId = "active_de_p_bed_03", price = 800},
{name = "Lit superpose 4", refId = "active_de_p_bed_09", price = 800},
{name = "Lit, Simple 1 (Dark, Red Patterned)", refId = "active_com_bed_02", price = 400},
{name = "Lit, Simple 2 (Light, Pale Red)", refId = "active_com_bed_03", price = 400},
{name = "Lit, Simple 3 (Dark, Pale Green)", refId = "active_com_bed_04", price = 400},
{name = "Lit, Simple 4 (Light, Grey)", refId = "active_com_bed_05", price = 400},
{name = "Lit, Simple 5 (Grey-Brown)", refId = "active_de_p_bed_04", price = 400},
{name = "Lit, Simple 6 (Pale Red)", refId = "active_de_p_bed_10", price = 400},
{name = "Lit, Simple 7 (Blue Patterned)", refId = "active_de_p_bed_11", price = 400},
{name = "Lit, Simple 8 (Blue Patterned)", refId = "active_de_p_bed_12", price = 400},
{name = "Lit, Simple 9 (Red Patterned)", refId = "active_de_p_bed_13", price = 400},
{name = "Lit, Simple 10 (Dunmer, Grey)", refId = "active_de_p_bed_14", price = 400},
{name = "Lit, Simple 11 (Blue Patterned)", refId = "active_de_pr_bed_07", price = 400},
{name = "Lit, Simple 12 (Blue Patterned)", refId = "active_de_pr_bed_21", price = 400},
{name = "Lit, Simple 13 (Red Patterned)", refId = "active_de_pr_bed_22", price = 400},
{name = "Lit, Simple 14 (Red Patterned)", refId = "active_de_pr_bed_23", price = 400},
{name = "Lit, Simple 15 (Grey-Brown)", refId = "active_de_pr_bed_24", price = 400},
{name = "Lit, Simple 16 (Pale Green)", refId = "active_de_pr_bed_24", price = 400},      
{name = "Lit, Simple Cot 1 (Blue Patterned)", refId = "active_de_r_bed_01", price = 400},
{name = "Lit, Simple Cot 2 (Blue Patterned)", refId = "active_de_r_bed_17", price = 400},
{name = "Lit, Simple Cot 3 (Red Patterned)", refId = "active_de_r_bed_18", price = 400},
{name = "Lit, Simple Cot 4 (Red Patterned)", refId = "active_de_r_bed_19", price = 400},
{name = "Lit, Double 1 (Pale Green)", refId = "active_de_p_bed_05", price = 800},
{name = "Lit, Double 2 (Red Patterned)", refId = "active_de_p_bed_15", price = 800},
{name = "Lit, Double 3 (Red Patterned)", refId = "active_de_p_bed_16", price = 800},
{name = "Lit, Double 4 (Pale Green)", refId = "active_de_pr_bed_27", price = 800},
{name = "Lit, Double 5 (Red Patterned)", refId = "active_de_pr_bed_26", price = 800},
{name = "Lit, Double 6 (Red Patterned)", refId = "active_de_pr_bed_08", price = 800},
{name = "Lit, Double 7 (Red Patterned)", refId = "active_de_r_bed_20", price = 800},
{name = "Lit, Double 8 (Red Patterned)", refId = "active_de_r_bed_06", price = 800},
{name = "Lit, Double 9 (Imperial Blue)", refId = "active_com_bed_06", price = 800},

--Rugs
{name = "", refId = "#option", price = 00},
{name = "#red ..TAPIS", refId = "#option", price = 00},
{name = "Tapis Dunmer 1", refId = "furn_de_rug_01", price = 200},
{name = "Tapis Dunmer 2", refId = "furn_de_rug_02", price = 200},
{name = "Tapis en peau de loup", refId = "furn_colony_wolfrug01", price = 50},
{name = "Tapis en peau dours", refId = "furn_rug_bearskin", price = 100},
{name = "Tapis, grand rond 1 (Red)", refId = "furn_de_rug_big_01", price = 200},
{name = "Tapis, grand rond 2 (Red)", refId = "furn_de_rug_big_02", price = 200},
{name = "Tapis, grand rond 3 (Green)", refId = "furn_de_rug_big_03", price = 200},
{name = "Tapis, grand rond 4 (Blue)", refId = "furn_de_rug_big_08", price = 200},
{name = "Tapis, grand rectangle 1 (Red)", refId = "furn_de_rug_big_04", price = 200},
{name = "Tapis, grand rectangle 2 (Red)", refId = "furn_de_rug_big_05", price = 200},
{name = "Tapis, grand rectangle 3 (Green)", refId = "furn_de_rug_big_06", price = 200},
{name = "Tapis, grand rectangle 4 (Green)", refId = "furn_de_rug_big_07", price = 200},
{name = "Tapis, grand rectangle 5 (Blue)", refId = "furn_de_rug_big_09", price = 200},

--Fireplaces
{name = "", refId = "#option", price = 00},
{name = "#red ..FOYERS", refId = "#option", price = 00},
{name = "Feu De Camp", refId = "furn_de_firepit", price = 100},
{name = "Feu De Camp 2", refId = "furn_de_firepit_01", price = 100},
{name = "Feu Foyer (Simple Oven)", refId = "furn_t_fireplace_01", price = 500},
{name = "Feu Foyer (Forge)", refId = "furn_de_forge_01", price = 500},
{name = "Feu Foyer (Nord)", refId = "in_nord_fireplace_01", price = 1500},
{name = "Feu Foyer", refId = "furn_fireplace10", price = 2000},
{name = "Feu Foyer (Grand Imperial)", refId = "in_imp_fireplace_grand", price = 5000},

--Lighting
{name = "", refId = "#option", price = 00},
{name = "#red ..LUMIERES", refId = "#option", price = 00},
{name = "Lanterne en papier jaune", refId = "light_de_lantern_03", price = 25},
{name = "Lanterne en papier bleu", refId = "light_de_lantern_08", price = 25},
{name = "Bougies jaunes", refId = "light_com_candle_07", price = 25},
{name = "Bougies bleues", refId = "light_com_candle_11", price = 25},
{name = "Applique murale (Trois bougies)", refId = "light_com_sconce_02_128", price = 25},
{name = "Applique murale (Une bougies)", refId = "light_com_sconce_01", price = 25},
{name = "Bougeoir (Trois bougies)", refId = "light_com_lamp_02_128", price = 50},
{name = "Chandelier, Simple (Quatre bougies)", refId = "light_com_chandelier_03", price = 50},

--Special Containers
{name = "", refId = "#option", price = 00},
{name = "#red ..MANNEQUINS", refId = "#option", price = 00},
{name = "Squelette 1", refId = "contain_corpse00", price = 122}, --120 for weight + 2 for the bonemeal :P
{name = "Squelette 2", refId = "contain_corpse10", price = 122},
{name = "Squelette 3", refId = "contain_corpse20", price = 122},
{name = "Mannequin", refId = "armor mannequin", price = 100},

--Misc
{name = "", refId = "#option", price = 00},
{name = "#red ..DECORATIONS", refId = "#option", price = 00},
{name = "Enclume", refId = "furn_anvil00", price = 200},
{name = "Le stand", refId = "furn_com_kegstand", price = 200},
{name = "Chaudron", refId = "furn_com_cauldron_01", price = 100},
{name = "Bac a cendres", refId = "in_velothi_ashpit_01", price = 100},
{name = "Cabane auvent", refId = "ex_de_shack_awning_03", price = 100},
{name = "Cabane grande", refId = "EX_MH_bazaar_tent", price = 500},
{name = "Tete dours (marron)", refId = "bm_bearhead_brown", price = 200},
{name = "Tete de loup (blanc)", refId = "bm_wolfhead_white", price = 200},
{name = "Papier peint", refId = "furn_de_r_wallscreen_02", price = 100},
{name = "Banniere (Imperial, Tapestry 2 - Tree)", refId = "furn_com_tapestry_02", price = 100},
{name = "Banniere (Imperial, Tapestry 3)", refId = "furn_com_tapestry_03", price = 100},
{name = "Banniere (Imperial, Tapestry 4 - Empire)", refId = "furn_com_tapestry_04", price = 100},
{name = "Banniere (Imperial, Tapestry 5)", refId = "furn_com_tapestry_05", price = 100},    
{name = "Banniere (Dunmer, Tapestry 2)", refId = "furn_de_tapestry_02", price = 100},
{name = "Banniere (Dunmer, Tapestry 5)", refId = "furn_de_tapestry_05", price = 100},
{name = "Banniere (Dunmer, Tapestry 6)", refId = "furn_de_tapestry_06", price = 100},
{name = "Banniere (Dunmer, Tapestry 7)", refId = "furn_de_tapestry_07", price = 100},       
{name = "Banniere (Temple 1)", refId = "furn_banner_temple_01_indoors", price = 100},
{name = "Banniere (Temple 2)", refId = "furn_banner_temple_02_indoors", price = 100},
{name = "Banniere (Temple 3)", refId = "furn_banner_temple_03_indoors", price = 100}, 
{name = "Banniere (Akatosh)", refId = "furn_c_t_akatosh_01", price = 100},
{name = "Banniere (Arkay)", refId = "furn_c_t_arkay_01", price = 100},
{name = "Banniere (Dibella)", refId = "furn_c_t_dibella_01", price = 100},
{name = "Banniere (Juilianos)", refId = "furn_c_t_julianos_01", price = 100},
{name = "Banniere (Kynareth)", refId = "furn_c_t_kynareth_01", price = 100},
{name = "Banniere (Mara)", refId = "furn_c_t_mara_01", price = 100},
{name = "Banniere (Stendarr)", refId = "furn_c_t_stendarr_01", price = 100},
{name = "Banniere (Zenithar)", refId = "furn_c_t_zenithar_01", price = 100},
{name = "Banniere (Apprentice)", refId = "furn_c_t_apprentice_01", price = 100},
{name = "Banniere (Golem)", refId = "furn_c_t_golem_01", price = 100},
{name = "Banniere (Lady)", refId = "furn_c_t_lady_01", price = 100},
{name = "Banniere (Lord)", refId = "furn_c_t_lord_01", price = 100},
{name = "Banniere (Lover)", refId = "furn_c_t_lover_01", price = 100},
{name = "Banniere (Ritual)", refId = "furn_c_t_ritual_01", price = 100},
{name = "Banniere (Shadow)", refId = "furn_c_t_shadow_01", price = 100},
{name = "Banniere (Steed)", refId = "furn_c_t_steed_01", price = 100},
{name = "Banniere (Thief)", refId = "furn_c_t_thief_01", price = 100},
{name = "Banniere (Tower)", refId = "furn_c_t_tower_01", price = 100},
{name = "Banniere (Warrior)", refId = "furn_c_t_warrior_01", price = 100},
{name = "Banniere (Wizard)", refId = "furn_c_t_wizard_01", price = 100},

--Wood (wood wall = stairs , wall , door wall , windowed wall , ...)
{name = "", refId = "#option", price = 00},
{name = "#red ..CONSTRUCTION", refId = "#option", price = 00},
{name = "mur en bois", refId = "BM_colony_wall04", price = 1000},
{name = "mur en bois avec emplacement de porte", refId = "BM_colony_wall03", price = 1500},
{name = "Mur de pierre", refId = "ex_imp_foundation_01", price = 2500},
{name = "Mur daedric", refId = "ex_dae_wall_512_01", price = 3000},
{name = "porte décoré", refId = "in_mh_door_02_play", price = 500},
{name = "Planche escalier", refId = "chargen_plank", price = 500},
{name = "Planche en bois", refId = "Ex_common_plat_LRG", price = 500},
{name = "Petite planche en bois", refId = "ex_de_shack_plank_01", price = 250},
{name = "Structure en bois", refId = "ex_common_trellis", price = 2000},
{name = "Struture pierre", refId = "ex_ruin_00", price = 5000},
{name = "Pont en bois", refId = "Ex_de_scaffold_01a", price = 2000},
{name = "Poteau en bois", refId = "Ex_De_Docks_Piling_01", price = 500},
{name = "Grande echelle en bois", refId = "ex_de_shack_steps", price = 1000},
{name = "Echelle en bois", refId = "Ex_De_Shack_Steps_01", price = 750},
{name = "Bloc de pierre", refId = "ex_dwrv_block00", price = 100},
{name = "Fondation en pierre", refId = "ex_v_foundation_01", price = 5000},
{name = "Barriere en bois", refId = "ex_S_fence_01", price = 100},
{name = "Hute en bois", refId = "Ex_S_FoodHut", price = 10000},
{name = "Fenetre", refId = "ex_S_window01", price = 500},
{name = "Puits", refId = "nom_well_common_01", price = 10000},


--Personnage (garde , vendeur , ect , ...)
{name = "", refId = "#option", price = 00},
{name = "#red ..PERSONNAGES", refId = "#option", price = 00},
{name = "Garde de l'empire", refId = "Elokiel Garde Empire", price = 5000},
{name = "Garde du temple", refId = "Elokiel Garde du temple", price = 5000},
{name = "Marchand de Elokiel", refId = "Elokiel Marchand", price = 2500},
{name = "Danseuse de Elokiel", refId = "Elokiel dancer girl", price = 2500},

--Compagnons (rats , chien , ect , ...)
{name = "", refId = "#option", price = 00},
{name = "#red ..COMPAGNONS", refId = "#option", price = 00},
{name = "Rat de compagnie", refId = "Rat_pack_rerlas", price = 500},
{name = "Chien de compagnie", refId = "Chien_pack_rerlas", price = 1000},
{name = "Guar de compagnie", refId = "Guar_pack_rerlas", price = 2500},
{name = "Braillard de compagnie", refId = "Braillard_pack_rerlas", price = 2500},

--[[Dwarven Furniture Set
{name = "Heavy Dwemer Chest", refId = "dwrv_chest00", price = 200}, --NOTE: Contains 2 random dwarven items
{name = "Heavy Dwemer Chest", refId = "dwrv_chest00", price = 200},
{name = "Dwemer Cabinet", refId = "dwrv_cabinet10", price = 200},
{name = "Dwemer Desk", refId = "dwrv_desk00", price = 50},
{name = "Dwemer Drawers", refId = "dwrv_desk00", price = 300}, --NOTE: Contains paper + one dwarven coin
{name = "Dwemer Drawer Table", refId = "dwrv_table00", price = 50}, --NOTE: Contains dwarven coin
{name = "Dwemer Chair", refId = "furn_dwrv_chair00", price = 000},
{name = "Dwemer Shelf", refId = "furn_dwrv_bookshelf00", price = 000},

--in_dwe_slate00 to in_dwe_slate11
--furn_com_p_table_01
--furn_com_planter
]]
}
-- {name = "name", refId = "ref_id", price = 50},

------------
DecorateHelp = require("custom.DecorateHelp")
tableHelper = require("tableHelper")
eventHandler = require("eventHandler")

Methods = {}
--Forward declarations:
local showMainGUI, showBuyGUI, showInventoryGUI, showViewGUI, showInventoryOptionsGUI, showViewOptionsGUI
------------
local playerBuyOptions = {} --Used to store the lists of items each player is offered so we know what they're trying to buy
local playerInventoryOptions = {} --
local playerInventoryChoice = {}
local playerViewOptions = {} -- [pname = [index = [refIndex = x, refId = y] ]
local playerViewChoice = {}

-- ===========
--  DATA ACCESS
-- ===========

local function getFurnitureInventoryTable()
	return WorldInstance.data.customVariables.EcarlateFurniture.inventories
end

local function getPermissionsTable()
	return WorldInstance.data.customVariables.EcarlateFurniture.permissions
end

local function getPlacedTable()
	return WorldInstance.data.customVariables.EcarlateFurniture.placed
end

local function addPlaced(refIndex, cell, pname, refId, save)
	local placed = getPlacedTable()
	
	if not placed[cell] then
		placed[cell] = {}
	end
	
	placed[cell][refIndex] = {owner = pname, refId = refId}
	
	if save then
		WorldInstance:SaveToDrive()
	end
end

local function removePlaced(refIndex, cell, save)
	local placed = getPlacedTable()
	
	placed[cell][refIndex] = nil
	
	if save then
		WorldInstance:SaveToDrive()
	end
end

local function getPlaced(cell)
	local placed = getPlacedTable()
	
	if placed[cell] then
		return placed[cell]
	else
		return false
	end
end

local function addFurnitureItem(pname, refId, count, save)
	local fInventories = getFurnitureInventoryTable()
	
	if fInventories[pname] == nil then
		fInventories[pname] = {}
	end
	
	fInventories[pname][refId] = (fInventories[pname][refId] or 0) + (count or 1)
	
	--Remove the entry if the count is 0 or less (so we can use this function to remove items, too!)
	if fInventories[pname][refId] <= 0 then
		fInventories[pname][refId] = nil
	end
	
	if save then
		WorldInstance:SaveToDrive()
	end
end

Methods.OnServerPostInit = function(eventStatus)
	--Create the script's required data if it doesn't exits
	if WorldInstance.data.customVariables.EcarlateFurniture == nil then
		WorldInstance.data.customVariables.EcarlateFurniture = {}
		WorldInstance.data.customVariables.EcarlateFurniture.placed = {}
		WorldInstance.data.customVariables.EcarlateFurniture.permissions = {}
		WorldInstance.data.customVariables.EcarlateFurniture.inventories = {}
		WorldInstance:SaveToDrive()
	end
	
	--Slight Hack for updating pnames to their new values. In release 1, the script stored player names as their login names, in release 2 it stores them as their all lowercase names.
	local placed = getPlacedTable()
	for cell, v in pairs(placed) do
		for refIndex, v in pairs(placed[cell]) do
			placed[cell][refIndex].owner = string.lower(placed[cell][refIndex].owner)
		end
	end
	local permissions = getPermissionsTable()
		
	for cell, v in pairs(permissions) do
		local newNames = {}
		
		for pname, v in pairs(permissions[cell]) do
			table.insert(newNames, string.lower(pname))
		end
		
		permissions[cell] = {}
		for k, newName in pairs(newNames) do
			permissions[cell][newName] = true
		end
	end
	
	local inventories = getFurnitureInventoryTable()
	local newInventories = {}
	for pname, invData in pairs(inventories) do
		newInventories[string.lower(pname)] = invData
	end
	
	WorldInstance.data.customVariables.EcarlateFurniture.inventories = newInventories
	
	WorldInstance:SaveToDrive()
end

-------------------------

local function getSellValue(baseValue)
	return math.max(0, math.floor(baseValue * config.sellbackModifier))
end

local function getName(pid)
	--return Players[pid].data.login.name
	--Release 2 change: Now uses all lowercase name for storage
	return string.lower(Players[pid].accountName)
end

local function getObject(refIndex, cell)
	if refIndex == nil then
		return false
	end
	
	if not LoadedCells[cell] then
		--TODO: Should ideally be temporary
		logicHandler.LoadCell(cell)
	end

	if LoadedCells[cell]:ContainsObject(refIndex)  then 
		return LoadedCells[cell].data.objectData[refIndex]
	else
		return false
	end	
end

--Returns the amount of gold in a player's inventory
local function getPlayerGold(pid)
	local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)
	
	if goldLoc then
		return Players[pid].data.inventory[goldLoc].count
	else
		return 0
	end
end

local function addGold(pid, amount)
	--TODO: Add functionality to add gold to offline player's inventories, too
	local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)
	
	if goldLoc then
		Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count + amount
	else
		table.insert(Players[pid].data.inventory, {refId = "gold_001", count = amount, charge = -1, soul = -1})
	end
	
	local itemref = {refId = "gold_001", count = amount, charge = -1, soul = -1}			
	Players[pid]:SaveToDrive()
	Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)			
end

local function removeGold(pid, amount)
	--TODO: Add functionality to add gold to offline player's inventories, too
	local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)	
	Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count - amount
	
	local itemref = {refId = "gold_001", count = amount, charge = -1, soul = -1}			
	Players[pid]:SaveToDrive()
	Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)			
end

local function getFurnitureData(refId)
	local location = tableHelper.getIndexByNestedKeyValue(furnitureData, "refId", refId)
	if location then
		return furnitureData[location], location
	else
		return false
	end
end

local function hasPlacePermission(pname, cell)
	local perms = getPermissionsTable()
	
	if not config.whitelist then
		return true
	end
	
	if perms[cell] then
		if perms[cell]["all"] or perms[cell][pname] then
			return true
		else
			return false
		end
	else
		--There's not even any data for that cell
		return false
	end
end

local function getPlayerFurnitureInventory(pid)
	local invlist = getFurnitureInventoryTable()
	local pname = getName(pid)
	
	if invlist[pname] == nil then
		invlist[pname] = {}
		WorldInstance:SaveToDrive()
	end
	
	return invlist[pname]
end

local function getSortedPlayerFurnitureInventory(pid)
	local inv = getPlayerFurnitureInventory(pid)
	local sorted = {}
	
	for refId, amount in pairs(inv) do
		local name = getFurnitureData(refId).name
		table.insert(sorted, {name = name, count = amount, refId = refId})
	end
	
	return sorted
end

local function placeFurniture(refId, loc, cell)
	local mpNum = WorldInstance:GetCurrentMpNum() + 1
	local location = {
		posX = loc.x, posY = loc.y, posZ = loc.z,
		rotX = 0, rotY = 0, rotZ = 0
	}
	local refIndex =  0 .. "-" .. mpNum
	local scale = 1
	
	WorldInstance:SetCurrentMpNum(mpNum)
	tes3mp.SetCurrentMpNum(mpNum)
	
	if not LoadedCells[cell] then
		--TODO: Should ideally be temporary
		logicHandler.LoadCell(cell)
	end

	LoadedCells[cell]:InitializeObjectData(refIndex, refId)
	LoadedCells[cell].data.objectData[refIndex].location = location
	LoadedCells[cell].data.objectData[refIndex].scale = scale
	table.insert(LoadedCells[cell].data.packets.scale, refIndex)
	table.insert(LoadedCells[cell].data.packets.place, refIndex)
 
	for onlinePid, player in pairs(Players) do
		if player:IsLoggedIn() then
			tes3mp.InitializeEvent(onlinePid)
			tes3mp.SetEventCell(cell)
			tes3mp.SetObjectRefId(refId)
			tes3mp.SetObjectRefNumIndex(0)
			tes3mp.SetObjectMpNum(mpNum)
			tes3mp.SetObjectPosition(location.posX, location.posY, location.posZ)
			tes3mp.SetObjectRotation(location.rotX, location.rotY, location.rotZ)
			tes3mp.SetObjectScale(scale)
			tes3mp.AddWorldObject()
			tes3mp.SendObjectPlace()
		end
	end
		
	LoadedCells[cell]:SaveToDrive()
	
	return refIndex
end

local function removeFurniture(refIndex, cell)
	--If for some reason the cell isn't loaded, load it. Causes a bit of spam in the server log, but that can't really be helped.
	--TODO: Ideally this should only be a temporary load
	if LoadedCells[cell] == nil then
		logicHandler.LoadCell(cell)
	end
	
	if LoadedCells[cell]:ContainsObject(refIndex) and not tableHelper.containsValue(LoadedCells[cell].data.packets.delete, refIndex) then --Shouldn't ever have a delete packet, but it's worth checking anyway
		--Delete the object for all the players currently online
		local splitIndex = refIndex:split("-")
		
		for onlinePid, player in pairs(Players) do
			if player:IsLoggedIn() then
				tes3mp.InitializeEvent(onlinePid)
				tes3mp.SetEventCell(cell)
				tes3mp.SetObjectRefNumIndex(splitIndex[1])
				tes3mp.SetObjectMpNum(splitIndex[2])
				tes3mp.AddWorldObject()
				tes3mp.SendObjectDelete()
			end
		end
		
		LoadedCells[cell]:DeleteObjectData(refIndex)
		LoadedCells[cell]:SaveToDrive()
		--Removing the object from the placed list will be done elsewhere
	end
end

local function getAvailableFurnitureStock(pid)
	--In the future this can be used to customise what items are available for a particular player, like making certain items only available for things like their race, class, level, their factions, or the quests they've completed. For now, however, everything in furnitureData is available :P
	
	local options = {}
	
	for i = 1, #furnitureData do
		table.insert(options, furnitureData[i])
	end
	
	return options
end

--If the player has placed items in the cell, returns an indexed table containing all the refIndexes of furniture that they have placed.
local function getPlayerPlacedInCell(pname, cell)
	local cellPlaced = getPlaced(cell)
	
	if not cellPlaced then
		-- Nobody has placed items in this cell
		return false
	end
	
	local list = {}
	for refIndex, data in pairs(cellPlaced) do
		if data.owner == pname then
			table.insert(list, refIndex)
		end
	end
	
	if #list > 0 then
		return list
	else
		--The player hasn't placed any items in this cell
		return false
	end
end

local function addFurnitureData(data)
	--Check the furniture doesn't already have an entry, if it does, overwrite it
	--TODO: Should probably check that the data is valid
	local fdata, loc = getFurnitureData(data.refId)
	
	if fdata then
		furnitureData[loc] = data
	else
		table.insert(furnitureData, data)
	end
end

Methods.AddFurnitureData = function(data)
	addFurnitureData(data)
end
--NOTE: Both AddPermission and RemovePermission use pname, rather than pid
Methods.AddPermission = function(pname, cell)
	local perms = getPermissionsTable()
	
	if not perms[cell] then
		perms[cell] = {}
	end
	
	perms[cell][pname] = true
	WorldInstance:SaveToDrive()
end

Methods.RemovePermission = function(pname, cell)
	local perms = getPermissionsTable()
	
	if not perms[cell] then
		return
	end
	
	perms[cell][pname] = nil
	
	WorldInstance:SaveToDrive()
end

Methods.RemoveAllPermissions = function(cell)
	local perms = getPermissionsTable()
	
	perms[cell] = nil
	WorldInstance:SaveToDrive()
end

Methods.RemoveAllPlayerFurnitureInCell = function(pname, cell, returnToOwner)
	local placed = getPlacedTable()
	local cInfo = placed[cell] or {}
	
	for refIndex, info in pairs(cInfo) do
		if info.owner == pname then
			if returnToOwner then
				addFurnitureItem(info.owner, info.refId, 1, false)
			end
			removeFurniture(refIndex, cell)
			removePlaced(refIndex, cell, false)
		end
	end
	WorldInstance:SaveToDrive()
end

Methods.RemoveAllFurnitureInCell = function(cell, returnToOwner)
	local placed = getPlacedTable()
	local cInfo = placed[cell] or {}
	
	for refIndex, info in pairs(cInfo) do
		if returnToOwner then
			addFurnitureItem(info.owner, info.refId, 1, false)
		end
		removeFurniture(refIndex, cell)
		removePlaced(refIndex, cell, false)
	end
	WorldInstance:SaveToDrive()
end

--Change the ownership of the specified furniture object (via refIndex) to another character's (playerToName). If playerCurrentName is false, the owner will be changed to the new one regardless of who owned it first.
Methods.TransferOwnership = function(refIndex, cell, playerCurrentName, playerToName, save)
	local placed = getPlacedTable()
	
	if placed[cell] and placed[cell][refIndex] and (placed[cell][refIndex].owner == playerCurrentName or not playerCurrentName) then
		placed[cell][refIndex].owner = playerToName
	end
	
	if save then
		WorldInstance:SaveToDrive()
	end
	
	--Unset the current player's selected item, just in case they had that furniture as their selected item
	if playerCurrentName and eventHandler.IsPlayerNameLoggedIn(playerCurrentName) then
		DecorateHelp.SetSelectedObject(eventHandler.GetPlayerByName(playerCurrentName).pid, "")
	end
end

--Same as TransferOwnership, but for all items in a given cell
Methods.TransferAllOwnership = function(cell, playerCurrentName, playerToName, save)
	local placed = getPlacedTable()
	
	if not placed[cell] then
		return false
	end
	
	for refIndex, info in pairs(placed[cell]) do
		if not playerCurrentName or info.owner == playerCurrentName then
			placed[cell][refIndex].owner = playerToName
		end
	end
	
	if save then
		WorldInstance:SaveToDrive()
	end
	
	--Unset the current player's selected item, just in case they had any of the furniture as their selected item
	if playerCurrentName and eventHandler.IsPlayerNameLoggedIn(playerCurrentName) then
		DecorateHelp.SetSelectedObject(eventHandler.GetPlayerByName(playerCurrentName).pid, "")
	end
end

--New Release 2 Methods:
Methods.GetSellBackPrice = function(value)
	return getSellValue(value)
end

Methods.GetFurnitureDataByRefId = function(refId)
	return getFurnitureData(refId)
end

Methods.GetPlacedInCell = function(cell)
	return getPlaced(cell)
end


-- ====
--  GUI
-- ====

-- VIEW (OPTIONS)
showViewOptionsGUI = function(pid, loc)
	local message = ""
	local choice = playerViewOptions[getName(pid)][loc]
	local fdata = getFurnitureData(choice.refId)
	
	message = message .. "Nom: " .. fdata.name .. " (RefIndex: " .. choice.refIndex .. "). Prix d'achat: " .. fdata.price .. " (Prix de vente: " .. getSellValue(fdata.price) .. ")"
	
	playerViewChoice[getName(pid)] = choice
	tes3mp.CustomMessageBox(pid, config.ViewOptionsGUI, message, "Sélectionnez;Enlever;Vendre;Retour")
end

local function onViewOptionSelect(pid)
	local pname = getName(pid)
	local choice = playerViewChoice[pname]
	local cell = tes3mp.GetCell(pid)
	
	if getObject(choice.refIndex, cell) then
		DecorateHelp.SetSelectedObject(pid, choice.refIndex)
		tes3mp.MessageBox(pid, -1, "Objet sélectionné, utilisez /dh pour déplacer.")
	else
		tes3mp.MessageBox(pid, -1, "L'objet semble avoir été retiré.")
	end
end

local function onViewOptionPutAway(pid)
	local pname = getName(pid)
	local choice = playerViewChoice[pname]
	local cell = tes3mp.GetCell(pid)
	
	if getObject(choice.refIndex, cell) then
		removeFurniture(choice.refIndex, cell)
		removePlaced(choice.refIndex, cell, true)
		
		addFurnitureItem(pname, choice.refId, 1, true)
		tes3mp.MessageBox(pid, -1, getFurnitureData(choice.refId).name .. " a été ajouté à votre inventaire de meubles.")
	else
		tes3mp.MessageBox(pid, -1, "L'objet semble avoir été retiré.")
	end
end

local function onViewOptionSell(pid)
	local pname = getName(pid)
	local choice = playerViewChoice[pname]
	local cell = tes3mp.GetCell(pid)
	
	if getObject(choice.refIndex, cell) then
		local saleGold = getSellValue(getFurnitureData(choice.refId).price)
		
		--Add gold to inventory
		addGold(pid, saleGold)
		
		--Remove the item from the cell
		removeFurniture(choice.refIndex, cell)
		removePlaced(choice.refIndex, cell, true)
		
		--Inform the player
		tes3mp.MessageBox(pid, -1, saleGold .. " d'or a été ajouté à votre inventaire et le mobilier a été retiré de la cellule.")
	else
		tes3mp.MessageBox(pid, -1, "L'objet semble avoir été retiré.")
	end
end

-- VIEW (MAIN)
showViewGUI = function(pid)
	local pname = getName(pid)
	local cell = tes3mp.GetCell(pid)
	local options = getPlayerPlacedInCell(pname, cell)
	
	local list = "* Retour *\n"
	local newOptions = {}
	
	if options and #options > 0 then
		for i = 1, #options do
			--Make sure the object still exists, and get its data
			local object = getObject(options[i], cell)
			
			if object then
				local furnData = getFurnitureData(object.refId)
				
				list = list .. furnData.name .. " (at " .. math.floor(object.location.posX + 0.5) .. ", "  ..  math.floor(object.location.posY + 0.5) .. ", " .. math.floor(object.location.posZ + 0.5) .. ")"
				if not(i == #options) then
					list = list .. "\n"
				end
				
				table.insert(newOptions, {refIndex = options[i], refId = object.refId})
			end
		end
	end
	
	playerViewOptions[pname] = newOptions
	tes3mp.ListBox(pid, config.ViewGUI, "Sélectionnez un meuble que vous avez placé dans cette cellule. Remarque: Le contenu des conteneurs sera perdu s'il est retiré.", list)
	--getPlayerPlacedInCell(pname, cell)
end

local function onViewChoice(pid, loc)
	showViewOptionsGUI(pid, loc)
end

-- INVENTORY (OPTIONS)
showInventoryOptionsGUI = function(pid, loc)
	local message = ""
	local choice = playerInventoryOptions[getName(pid)][loc]
	local fdata = getFurnitureData(choice.refId)
	
	message = message .. "Nom: " .. choice.name .. ". Prix d'achat: " .. fdata.price .. " (Prix de vente: " .. getSellValue(fdata.price) .. ")"
	
	playerInventoryChoice[getName(pid)] = choice
	tes3mp.CustomMessageBox(pid, config.InventoryOptionsGUI, message, "Lieu;Vendre;Retour")
end

local function onInventoryOptionPlace(pid)
	local pname = getName(pid)
	local curCell = tes3mp.GetCell(pid)
	local choice = playerInventoryChoice[pname]
	local playerAngle = tes3mp.GetRotZ(pid)
	if playerAngle > 3.0 then
		playerAngle = 3.0
	elseif playerAngle < -3.0 then
		playerAngle = -3.0
	end
	local PosX = (100 * math.sin(playerAngle) + tes3mp.GetPosX(pid))
	local PosY = (100 * math.cos(playerAngle) + tes3mp.GetPosY(pid))
	local PosZ = tes3mp.GetPosZ(pid)		
	--First check the player is allowed to place items where they are currently
	if config.whitelist and not hasPlacePermission(pname, curCell) then
		--Player isn't allowed
		tes3mp.MessageBox(pid, -1, "Vous n'avez pas la permission de placer des meubles ici.")
		return false
	end
	--Remove 1 instance of the item from the player's inventory
	addFurnitureItem(pname, choice.refId, -1, true)
	
	--Place the furniture in the world	

	local pPos = {x = PosX, y = PosY, z = PosZ}
	local furnRefIndex = placeFurniture(choice.refId, pPos, curCell)
	
	--Update the database of all placed furniture
	addPlaced(furnRefIndex, curCell, pname, choice.refId, true)
	--Set the placed item as the player's active object for DecorateHelp to use
	DecorateHelp.SetSelectedObject(pid, furnRefIndex)
	DecorateHelp.OnGUIAction(pid, 31360, 14)	
end

local function onInventoryOptionSell(pid)
	local pname = getName(pid)
	local choice = playerInventoryChoice[pname]
	
	local saleGold = getSellValue(getFurnitureData(choice.refId).price)
	
	--Add gold to inventory
	addGold(pid, saleGold)
	
	--Remove 1 instance of the item from the player's inventory
	addFurnitureItem(pname, choice.refId, -1, true)
	
	--Inform the player
	tes3mp.MessageBox(pid, -1, saleGold .. " L'or a été ajouté à votre inventaire.")
end

-- INVENTORY (MAIN)
showInventoryGUI = function(pid)
	local options = getSortedPlayerFurnitureInventory(pid)
	local list = "* Retour *\n"
	
	for i = 1, #options do
		list = list .. options[i].name .. " (" .. options[i].count .. ")"
		if not(i == #options) then
			list = list .. "\n"
		end
	end
	
	playerInventoryOptions[getName(pid)] = options
	tes3mp.ListBox(pid, config.InventoryGUI, "Sélectionnez le meuble de votre inventaire avec lequel vous souhaitez faire quelque chose", list)
end

local function onInventoryChoice(pid, loc)
	showInventoryOptionsGUI(pid, loc)
end

-- BUY (MAIN)
showBuyGUI = function(pid)
	local options = getAvailableFurnitureStock(pid)
	local list = "* Retour *\n"
	
	for i = 1, #options do
		if (options[i].price == 00) then
			list = list .. options[i].name
		end
		if (options[i].price > 00) then
			list = list .. options[i].name .. " (" .. options[i].price .. ") "
		end		
		if not(i == #options) then
			list = list .. "\n"
		end
	end
	
	playerBuyOptions[getName(pid)] = options
	tes3mp.ListBox(pid, config.BuyGUI, color.CornflowerBlue .. "Sélectionnez un article que vous souhaitez acheter" .. color.Default, list)
end

local function onBuyChoice(pid, loc)
	local pgold = getPlayerGold(pid)
	local choice = playerBuyOptions[getName(pid)][loc]
	
	if pgold < choice.price then
		tes3mp.MessageBox(pid, -1, "Vous ne pouvez pas vous permettre d'acheter" .. choice.name .. ".")
		return false
	else
		removeGold(pid, choice.price)
		addFurnitureItem(getName(pid), choice.refId, 1, true)
		
		tes3mp.MessageBox(pid, -1, "" .. choice.name .. " a été ajouté à votre inventaire de meubles.")
		return true	
	end	
end

-- MAIN
showMainGUI = function(pid)
	local message = color.Green.."BIENVENUE DANS LE MAGASIN.\n\n"..color.Yellow.."Acheter "..color.White.."pour acheter des meubles pour votre inventaire de meubles\n\n"..color.Yellow.."Inventaire "..color.White.."pour afficher les articles de meubles que vous possédez\n\n"..color.Yellow.."Afficher "..color.White.."pour afficher la liste de tous les meubles que vous possédez dans la cellule où vous êtes actuellement\n\n"
	tes3mp.CustomMessageBox(pid, config.MainGUI, message, "Acheter;Inventaire;Afficher;Retour")
end

local function onMainBuy(pid)
	showBuyGUI(pid)
end

local function onMainInventory(pid)
	showInventoryGUI(pid)
end

local function onMainView(pid)
	showViewGUI(pid)
end

-- GENERAL
Methods.OnGUIAction = function(pid, idGui, data)
	
	if idGui == config.MainGUI then -- Main
		if tonumber(data) == 0 then --Buy
			onMainBuy(pid)
			return true
		elseif tonumber(data) == 1 then -- Inventory
			onMainInventory(pid)
			return true
		elseif tonumber(data) == 2 then -- View
			onMainView(pid)
			return true
		elseif tonumber(data) == 3 then -- Close
			Players[pid].currentCustomMenu = "menu player"
			menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
			return true
		end
	elseif idGui == config.BuyGUI then -- Buy
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return showMainGUI(pid)
		else
			onBuyChoice(pid, tonumber(data))
			return onMainBuy(pid)
		end
	elseif idGui == config.InventoryGUI then --Inventory main
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return showMainGUI(pid)
		else
			onInventoryChoice(pid, tonumber(data))
			return true 
		end
	elseif idGui == config.InventoryOptionsGUI then --Inventory options
		if tonumber(data) == 0 then --Place
			onInventoryOptionPlace(pid)
			return true
		elseif tonumber(data) == 1 then --Sell
			onInventoryOptionSell(pid)
			return onMainInventory
		else --Close
			--Do nothing
			return showMainGUI(pid)
		end
	elseif idGui == config.ViewGUI then --View
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return showMainGUI(pid)
		else
			onViewChoice(pid, tonumber(data))
			return true
		end
	elseif idGui == config.ViewOptionsGUI then -- View Options
		if tonumber(data) == 0 then --Select
			onViewOptionSelect(pid)
			return true
		elseif tonumber(data) == 1 then --Put away
			onViewOptionPutAway(pid)
			return onMainView(pid)
		elseif tonumber(data) == 2 then --Sell
			onViewOptionSell(pid)
			return onMainView(pid)		
		else --Close
			--Do nothing
			return showMainGUI(pid)
		end
	end
end

Methods.OnCommand = function(pid)
	showMainGUI(pid)
end

customCommandHooks.registerCommand("furn", Methods.OnCommand)
customEventHooks.registerHandler("OnGUIAction", function(eventStatus, pid, idGui, data)
	if EcarlateFurniture.OnGUIAction(pid, idGui, data) then return end
end)
customEventHooks.registerHandler("OnServerPostInit", Methods.OnServerPostInit)

return Methods
