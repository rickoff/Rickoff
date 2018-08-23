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
			destinations = {menuHelper.destinations.setDefault("help player",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/token"})
				})
			}
        },
        { caption = "Loterie",
			destinations = {menuHelper.destinations.setDefault("help player",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/loterie"})
				})
			}
        },
        { caption = "Jeter les dés",
			destinations = {menuHelper.destinations.setDefault("help player",
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
        { caption = "Reset rangs",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetrang"})
				})
			}
        },		
        { caption = "Score",
			destinations = {menuHelper.destinations.setDefault("commande page 2",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/score"})
				})
			}
        },
        { caption = "Stats",
			destinations = {menuHelper.destinations.setDefault("commande page 2",
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
					{menuHelper.variables.currentPid(), "/empire"})
				})
			}
        },
        { caption = "Temple",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/temple"})
				})
			}
        },
        { caption = "Renégats",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/renegat"})
				})
			}
        },
        { caption = "Pélerins",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/pelerin"})
				})
			}
        },	
        { caption = "Téléportation",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/warp"})
				})
			}
        },		
        { caption = "Page 1",
            destinations = {
                menuHelper.destinations.setDefault("help player")
            }
        },
        { caption = "Page 3",
            destinations = {
                menuHelper.destinations.setDefault("commande page 3")
            }
        },		
        { caption = "Quitter", destinations = nil }
    }
}

Menus["commande page 3"] = {
    text = color.Orange .. "MENU DES COMMANDES\n",
    buttons = {	
        { caption = "Gouvernant",	
            destinations = {
                menuHelper.destinations.setDefault("commande gouvernant")
            }
        },	
        { caption = "Hôtel de vente",	
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/hdv"})
				})
			}
        },
        { caption = "Emotes",	
            destinations = { menuHelper.destinations.setDefault("emote vocal") }
        },	
        { caption = "Page 1",
            destinations = {
                menuHelper.destinations.setDefault("help player")
            }
        },
        { caption = "Page 2",
            destinations = {
                menuHelper.destinations.setDefault("commande page 2")
            }
        },		
        { caption = "Quitter", destinations = nil }
    }
}

Menus["commande gouvernant"] = {
    text = color.Orange .. "COMMANDE DE GOUVERNANT\n" ..
        color.Yellow .. "\n/expulser <pid>\n" ..
            color.White .. "\nExpulse un membre de votre faction\n" ..
        color.Yellow .. "\n/recruter <pid>\n" ..
            color.White .. "\nRecruter un nouveau membre dans votre faction\n"..
        color.Yellow .. "\n/punition <pid>\n" ..
            color.White .. "\nPunir un joueur de sa faction en l'envoyant nager!\n"..
        color.Yellow .. "\n/prison <pid>\n" ..
            color.White .. "\nEnvoyer un joueur de sa faction en prison!\n"..
        color.Yellow .. "\n/stopprime <pid>\n" ..
            color.White .. "\nPayer 10k pour enlever la prime d'un joueur!\n",			
    buttons = {				
        { caption = "Retour",
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
