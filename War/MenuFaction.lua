Menus["menu faction"] = {
	text = {color.Orange .. "MENU DES FACTIONS\n",
		color.Red .. "\nSTATS: \n",
		color.Yellow .. "\nKills: " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("mwTDM.kills"),
		color.Yellow .. "\n\nDeaths: " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("mwTDM.deaths"),
		color.Yellow .. "\n\nTotal Kills: " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("mwTDM.totalKills"),
		color.Yellow .. "\n\nTotal Deaths " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("mwTDM.totalDeaths"),
		"\n"
	},
    buttons = {
        { caption = "Team",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/teams"})
				})
			}
        },
        { caption = "Empire",
			destinations = {menuHelper.destinations.setDefault("menu faction",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/empire"})
				})
			}
        },
        { caption = "Temple",
			destinations = {menuHelper.destinations.setDefault("menu faction",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/temple"})
				})
			}
        },
        { caption = "Renégats",
			destinations = {menuHelper.destinations.setDefault("menu faction",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/renegat"})
				})
			}
        },
        { caption = "Pélerins",
			destinations = {menuHelper.destinations.setDefault("menu faction",
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
        { caption = "Gouvernant",	
            destinations = {
                menuHelper.destinations.setDefault("commande gouvernant")
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

Menus["resurrectvamp"] = {
    text = color.Gold .. "Vous êtes mort !!!\n" .. color.LightGreen ..
    "vous devez\n" .. color.Gold .. "attendre un joueur\n" ..
        color.White .. "...",
    buttons = {						
       { caption = "revivre",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resurrectvamp"})
                })
            }
        },			
        { caption = "attendre", destinations = nil }
    }
}

Menus["resurrect"] = {
    text = color.Gold .. "Vous êtes mort !!!\n" .. color.LightGreen ..
    "vous devez\n" .. color.Gold .. "attendre un joueur\n" ..
        color.White .. "...",
    buttons = {						
        { caption = "revivre",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resurrect"})
                })
            }
        },			
        { caption = "attendre", destinations = nil }
    }
}

Menus["commande gouvernant"] = {
    text = {color.Orange .. "COMMANDE DE GOUVERNANT\n",
		color.Yellow .. "\n/expulser <pid>\n",
		color.White .. "\nExpulse un membre de votre faction\n",
		color.Yellow .. "\n/recruter <pid>\n",
		color.White .. "\nRecruter un nouveau membre dans votre faction\n",
		color.Yellow .. "\n/punition <pid>\n",
		color.White .. "\nPunir un joueur de sa faction en l'envoyant nager!\n",
		color.Yellow .. "\n/prison <pid>\n",
		color.White .. "\nEnvoyer un joueur de sa faction en prison!\n",
		color.Yellow .. "\n/stopprime <pid>\n",
		color.White .. "\nPayer 10k pour enlever la prime d'un joueur!\n"
	},
    buttons = {				
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu faction")
            }
        },
        { caption = "Quitter", destinations = nil }
    }
}