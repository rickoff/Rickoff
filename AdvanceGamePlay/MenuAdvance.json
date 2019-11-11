Menus["menu joueur"] = {
	text = {color.Orange .. "MENU DES JOUEURS\n",
        color.White .. "\nle menu des joueurs vous permet d'utiliser certaines fonctions pour votre personnage.\n"
	},
    buttons = {
        { caption = "Liste",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/list"})
				})
			}
        },				
        { caption = "Prime",
            destinations = {
                menuHelper.destinations.setDefault("commande prime")
            }
        },	
        { caption = "Message",
            destinations = {
                menuHelper.destinations.setDefault("commande tchat")
            }
        },	
        { caption = "Emotes",	
            destinations = { menuHelper.destinations.setDefault("emote vocal") }
        },
        { caption = "Course",	
            destinations = { menuHelper.destinations.setDefault("menu cmd run") }
        },		
        { caption = "Temp de jeu",	
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/playtimeall"})
				})
			}
        },		
        { caption = "Suicide",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/suicide"})
				})
			}
        },		
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu player")
            }
        },	
        { caption = "Quitter", destinations = nil }
    }
}

Menus["resurrect player"] = {
    text = color.Gold .. "Voulez vous\n" .. color.LightGreen ..
    "réanimer\n" .. color.Gold .. "ce joueur ?\n" ..
        color.White .. "...",
    buttons = {						
        { caption = "oui",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("logicHandler", "ResurrectPlayer", 
					{menuHelper.variables.currentPlayerDataVariable("targetPid")})
                })
            }
        },			
        { caption = "non", destinations = nil }
    }
}

Menus["commande prime"] = {
    text = {color.Orange .. "COMMANDE DE PRIME\n",
		color.Yellow .. "\n/prime <pid>\n",
		color.White .. "\nMet une prime de 10k sur le joueur choisit\n",
	},
    buttons = {				
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu joueur")
            }
        },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["commande tchat"] = {
    text = {color.Orange .. "COMMANDE DU TCHAT\n",
		color.Yellow .. "\n/msg <pid> <message>\n",
		color.White .. "\nEnvoi un message privé au joueur demandé\n",		
		color.Yellow .. "\n/a <animation>\n",
		color.White .. "\nEffectue l'animation demandé\n",
		color.Yellow .. "\n/s <type> <index>\n",
		color.White .. "\nEffectue le son demandé\n"
	},
    buttons = {			
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu joueur")
            }
        },
        { caption = "Quitter", destinations = nil }
    }
}
Menus["menu cmd run"] = {
    text = color.Orange .. "MENU VITESSE DE COURSE\n" ..
        color.Yellow .. "\nSelectionne une vitesse\n" ..
            color.White .. "\nmodifie la vitesse de course\n",
    buttons = {				
        { caption = "Trottiner",
			destinations = {menuHelper.destinations.setDefault("menu cmd run",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/trottiner"})
				})
			}
        },
        { caption = "Courir",
			destinations = {menuHelper.destinations.setDefault("menu cmd run",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/courir"})
				})
			}
        },
        { caption = "Sprinter",
			destinations = {menuHelper.destinations.setDefault("menu cmd run",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/sprinter"})
				})
			}
        },
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu joueur")
            }
        },				
        { caption = "Quitter", destinations = nil }
    }
}
