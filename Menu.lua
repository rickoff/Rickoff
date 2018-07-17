--add file in folder script/menu
--add in config.lua find ``config.menuHelperFiles = { "Menu" } ``
--go to server.lua and add to command text
        --elseif cmd[1] == "menu" then

            --Players[pid].currentCustomMenu = "help player"
            --menuHelper.displayMenu(pid, Players[pid].currentCustomMenu)	


Menus["help player"] = {
    text = color.Orange .. "MENU DES COMMANDES\n" ..
        color.Yellow .. "\nle menu global vous permet d'éxécuter différentes fonctions",
    buttons = {
        { caption = "Aide",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/help"})
				})
			}
        },	
        { caption = "Liste",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/list"})
				})
			}
        },
        { caption = "Maison",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/house"})
				})
			}
        },
        { caption = "Magasin",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/furn"})
				})
			}
        },
        { caption = "Décoration",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/dh"})
				})
			}
        },
        { caption = "Jetons",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/token"})
				})
			}
        },
        { caption = "Loterie",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/loterie"})
				})
			}
        },
        { caption = "Jeter les dés",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/roll"})
				})
			}
        },
        { caption = "Utiliser jetons",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/perks"})
				})
			}
        },		
        { caption = "craft verre",
            destinations = { menuHelper.destinations.setDefault("forge de verre") }
        },
        { caption = "craft ebonite",
            destinations = { menuHelper.destinations.setDefault("forge d'ebonite") }
        },											
        { caption = "Page 2",
            destinations = {
                menuHelper.destinations.setDefault("commande page 2")
            }
        },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["commande page 2"] = {
    text = color.Orange .. "MENU DES COMMANDES\n",
    buttons = {
        { caption = "Prime",
            destinations = {
                menuHelper.destinations.setDefault("commande prime")
            }
        },	
        { caption = "Tchat",
            destinations = {
                menuHelper.destinations.setDefault("commande tchat")
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
        { caption = "Reset journal",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetlog"})
				})
			}
        },
        { caption = "Reset faction",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetfaction"})
				})
			}
        },
        { caption = "Score",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/score"})
				})
			}
        },
        { caption = "Stats",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/stats"})
				})
			}
        },
        { caption = "Team",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/teams"})
				})
			}
        },
        { caption = "Empire",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/Empire"})
				})
			}
        },
        { caption = "Temple",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/Temple"})
				})
			}
        },
        { caption = "Renégats",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/renegats"})
				})
			}
        },
        { caption = "Pélerins",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/pelerins"})
				})
			}
        },		
        { caption = "Page 1",
            destinations = {
                menuHelper.destinations.setDefault("help player")
            }
        },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["commande prime"] = {
    text = color.Orange .. "COMMANDE DE PRIME\n" ..
        color.Yellow .. "\n/prime <pid>\n" ..
            color.White .. "\nMet une prime de 10k sur le joueur choisit\n",
    buttons = {				
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("help player")
            }
        },
        { caption = "Quitter", destinations = nil }
    }
}
Menus["commande tchat"] = {
    text = color.Orange .. "COMMANDE DU TCHAT\n" ..
        color.Yellow .. "\n/msg <pid> <message>\n" ..
            color.White .. "\nEnvoi un message privé au joueur demandé\n" ..		
        color.Yellow .. "\n/a <animation>\n" ..
            color.White .. "\nEffectue l'animation demandé\n" ..
        color.Yellow .. "\n/s <type> <index>\n" ..
            color.White .. "\nEffectue le son demandé\n",
    buttons = {			
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("help player")
            }
        },
        { caption = "Quitter", destinations = nil }
    }
}
