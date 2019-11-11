--[[
MainMenu by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Script principal Main Menu for manage all script Ecarlate
---------------------------
INSTALLATION:

Save the file as Menu.lua inside your scripts/menu folder

Edits to config.lua
add in config.menuHelperFiles, "Menu"
---------------------------
]]

Menus["menu player"] = {
    text = {color.Orange .. "MENU DES COMMANDES\n",
		color.White .. "le menu global vous permet d'éxécuter différentes fonctions\n\n",
		color.Yellow .. "Joueur :" .. color.White .. " Survie, Liste, Prime\n",
		color.Yellow .. "Immobilier :" .. color.White ..  " Maison, Décoration, Boutique\n",
		color.Yellow .. "Faction :" .. color.White ..  " Compagnons, Insciptions, Score\n",	
		color.Yellow .. "Loterie :" .. color.White ..  " Jetons, Dés, Loterie\n",		
		color.Yellow .. "Reset :" .. color.White ..  " Quetes, Guildes, Rangs\n",
		color.Yellow .. "Compétence :" .. color.White ..  " Dépensez vos points d'experience\n",
		color.Yellow .. "Compagnons :" .. color.White ..  " Guerrier, Magicien, Rodeur\n",	
		color.Yellow .. "Hôtel de vente :" .. color.White ..  " Achat, Stock, Vente\n",			
		color.Yellow .. "Banque :" .. color.White ..  " Stocker votre gold en lieu sûr\n",
		color.Yellow .. "Construction :" .. color.White ..  " Miner des éléments pour fabriquer\n",
		color.Yellow .. "Groupe :" .. color.White ..  " Créer un groupe et inviter des joueurs\n",	
		color.Yellow .. "Forteresse :" .. color.White ..  " Acheter un domaine pour contruire\n",			
		color.Yellow .. "HotKey :" .. color.White ..  " Utilitaire de raccourci clavier\n"		
	},
    buttons = {
        { caption = "Joueur",
			destinations = {menuHelper.destinations.setDefault("menu joueur")}
        },	
        { caption = "Immobilier",
			destinations = {menuHelper.destinations.setDefault("menu immobilier")}
        },
        { caption = "Faction",
			destinations = {menuHelper.destinations.setDefault("menu faction")}
        },								
        { caption = "Loterie",
            destinations = { menuHelper.destinations.setDefault("menu loterie")}
        },
        { caption = "Reset",
			destinations = {menuHelper.destinations.setDefault("menu reset")}
        },	
        { caption = "Compétences",	
			destinations = {menuHelper.destinations.setDefault("menu cmp ecarlate")}
        },
        { caption = "Compagnons",	
			destinations = {menuHelper.destinations.setDefault("menu compagnons")}
        },		
        { caption = "Hôtel de vente",	
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/hdv"})
				})
			}
        },
        { caption = "Banque",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/bank"})
				})
			}
        },
        { caption = "Construction",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/mining"})
				})
			}
        },
        { caption = "Groupe",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/menugroup"})
				})
			}
        },
        { caption = "Forteresse",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/fort"})
				})
			}
        },
        { caption = "HotKey",	
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/hotkey"})
				})
			}
        },			
        { caption = "Quitter", destinations = nil }
    }
}		
