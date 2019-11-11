Menus["menu compagnons"] = {
    text = color.Orange .. "MENU COMPAGNONS\n" ..
        color.Yellow .. "\nSelectionne un compagnon\n",
    buttons = {				
        { caption = "Guerrier",	
            destinations = {
                menuHelper.destinations.setDefault("menu cmd guerrier")
            }
        },	
        { caption = "Magicien",	
            destinations = {
                menuHelper.destinations.setDefault("menu cmd magicien")
            }
        },		
        { caption = "Rodeur",	
            destinations = {
                menuHelper.destinations.setDefault("menu cmd rodeur")
            }
        },
        { caption = "Rat",	
            destinations = {
                menuHelper.destinations.setDefault("menu cmd rat")
            }
        },
        { caption = "Chien",	
            destinations = {
                menuHelper.destinations.setDefault("menu cmd chien")
            }
        },
        { caption = "Guar",	
            destinations = {
                menuHelper.destinations.setDefault("menu cmd guar")
            }
        },	
        { caption = "Papillon",	
            destinations = {
                menuHelper.destinations.setDefault("menu cmd butter")
            }
        },			
        { caption = "Retour",	
            destinations = {
                menuHelper.destinations.setDefault("menu player")
            }
        }			
    }
}

Menus["menu cmd guerrier"] = {
    text = color.Orange .. "MENU GUERRIER\n" ..
        color.Yellow .. "\nSelectionne une action\n" ..
            color.White .. "\ncontrôle le guerrier\n",
    buttons = {				
        { caption = "Appeler",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/appeler_warrior"})
				})
			}
        },
        { caption = "Suivre",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/suivre_warrior"})
				})
			}
        },	
        { caption = "Renvoyer",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/renvoyer_warrior"})
				})
			}
        },				
        { caption = "Stop",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/stop_warrior"})
				})
			}
        },
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu compagnons")
            }
        },		
    }
}

Menus["menu cmd magicien"] = {
    text = color.Orange .. "MENU MAGICIEN\n" ..
        color.Yellow .. "\nSelectionne une action\n" ..
            color.White .. "\ncontrôle le magicien\n",
    buttons = {				
        { caption = "Appeler",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/appeler_wizzard"})
				})
			}
        },
        { caption = "Suivre",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/suivre_wizzard"})
				})
			}
        },	
        { caption = "Renvoyer",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/renvoyer_wizzard"})
				})
			}
        },				
        { caption = "Stop",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/stop_wizzard"})
				})
			}
        },
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu compagnons")
            }
        },			
    }
}

Menus["menu cmd rodeur"] = {
    text = color.Orange .. "MENU RODEUR\n" ..
        color.Yellow .. "\nSelectionne une action\n" ..
            color.White .. "\ncontrôle le rodeur\n",
    buttons = {				
        { caption = "Appeler",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/appeler_thief"})
				})
			}
        },
        { caption = "Suivre",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/suivre_thief"})
				})
			}
        },	
        { caption = "Renvoyer",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/renvoyer_thief"})
				})
			}
        },			
        { caption = "Stop",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/stop_thief"})
				})
			}
        },	
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu compagnons")
            }
        },			
    }
}

Menus["menu cmd rat"] = {
    text = color.Orange .. "MENU RAT\n" ..
        color.Yellow .. "\nSelectionne une action\n" ..
            color.White .. "\ncontrôle le rat\n",
    buttons = {				
        { caption = "Appeler",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/appeler_rat"})
				})
			}
        },
        { caption = "Suivre",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/suivre_rat"})
				})
			}
        },	
        { caption = "Renvoyer",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/renvoyer_rat"})
				})
			}
        },				
        { caption = "Stop",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/stop_rat"})
				})
			}
        },	
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu compagnons")
            }
        },			
    }
}

Menus["menu cmd chien"] = {
    text = color.Orange .. "MENU CHIEN\n" ..
        color.Yellow .. "\nSelectionne une action\n" ..
            color.White .. "\ncontrôle le chien\n",
    buttons = {				
        { caption = "Appeler",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/appeler_chien"})
				})
			}
        },
        { caption = "Suivre",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/suivre_chien"})
				})
			}
        },	
        { caption = "Renvoyer",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/renvoyer_chien"})
				})
			}
        },				
        { caption = "Stop",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/stop_chien"})
				})
			}
        },
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu compagnons")
            }
        },			
    }
}

Menus["menu cmd guar"] = {
    text = color.Orange .. "MENU GUAR\n" ..
        color.Yellow .. "\nSelectionne une action\n" ..
            color.White .. "\ncontrôle le guar\n",
    buttons = {				
        { caption = "Appeler",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/appeler_guar"})
				})
			}
        },
        { caption = "Suivre",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/suivre_guar"})
				})
			}
        },	
        { caption = "Renvoyer",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/renvoyer_guar"})
				})
			}
        },				
        { caption = "Stop",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/stop_guar"})
				})
			}
        },	
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu compagnons")
            }
        },			
    }
}

Menus["menu cmd butter"] = {
    text = color.Orange .. "MENU PAPILLON\n" ..
        color.Yellow .. "\nSelectionne une action\n" ..
            color.White .. "\ncontrôle le papillon\n",
    buttons = {				
        { caption = "Appeler",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/appeler_butter"})
				})
			}
        },
        { caption = "Suivre",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/suivre_butter"})
				})
			}
        },	
        { caption = "Renvoyer",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/renvoyer_butter"})
				})
			}
        },				
        { caption = "Stop",
			destinations = {menuHelper.destinations.setDefault("menu compagnons",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/stop_butter"})
				})
			}
        },
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu compagnons")
            }
        },			
    }
}