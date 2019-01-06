Menus["menu cmp ecarlate"] = {
	text = {color.Orange .. "MENU DES COMPETENCES\n",
		color.Yellow .. "\nExp : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.soul"), 
		color.Red .. " >= " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.capSoul"),
		"\n",		
		color.Yellow .. "\nNiveau : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.levelSoul"), 
		color.Red .. " >= 50",
		"\n",	
		color.Yellow .. "\npoints de compétences : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n",
	},
    buttons = {				
        { caption = "Defence",
			destinations = {menuHelper.destinations.setDefault("menu cmp def") 
			}
		},
        { caption = "Combat",
			destinations = {menuHelper.destinations.setDefault("menu cmp cmb")
			}
        },
        { caption = "Magie",
			destinations = {menuHelper.destinations.setDefault("menu cmp mag")
			}
        },
        { caption = "Retour",
            destinations = {menuHelper.destinations.setDefault("menu joueur")
            }
        },				
        { caption = "Quitter", destinations = nil }
    }
}

Menus["menu cmp cmb"] = {
	text = {color.Orange .. "COMPETENCES DE COMBAT\n",
		color.Yellow .. "\nExp : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.soul"), 
		color.Red .. " >= " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.capSoul"),
		"\n",		
		color.Yellow .. "\nNiveau : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.levelSoul"), 
		color.Red .. " >= 50",
		"\n",	
		color.Yellow .. "\npoints de compétences : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n\n",
		color.Yellow .. "\ncompétence du barbare : " .. color.White,
		"augmente la force, l'endurance et l'armure lourde de :" .. color.Green,
		" + 4 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.barbare"),
		color.Red .. " <= infini\n",	
		color.Yellow .. "Coût : ",
		color.White .. "3 points.\n",		
		color.Yellow .. "\ncompétence du guerrier : " .. color.White,
		"augmente la force, la vitesse et l'armure intermediaire de :" .. color.Green,
		" + 4 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.guerrier"),
		color.Red .. " <= infini\n",
		color.Yellow .. "Coût : ",
		color.White .. "3 points.\n",		
		color.Yellow .. "\ncompétence du rodeur : " .. color.White,
		"augmente la vitesse, l'agilité et l'armure légère de :" .. color.Green,
		" + 4 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.rodeur"),
		color.Red .. " <= infini\n",
		color.Yellow .. "Coût : ",
		color.White .. "3 points.\n"		
	},
    buttons = {						
        { caption = "Barbare",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Barbare"})
                })
            }
		},
        { caption = "Guerrier",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Guerrier"})
                })
            }	
		},
        { caption = "Rodeur",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Rodeur"})
                })
            }
        },
        { caption = "Retour",
            destinations = {menuHelper.destinations.setDefault("menu cmp ecarlate")
            }
        },				
        { caption = "Quitter", destinations = nil }
    }
}

Menus["menu cmp def"] = {
	text = {color.Orange .. "COMPETENCES DEFENSIVE\n",
		color.Yellow .. "\nExp : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.soul"), 
		color.Red .. " >= " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.capSoul"),
		"\n",		
		color.Yellow .. "\nNiveau : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.levelSoul"), 
		color.Red .. " >= 50",
		"\n",	
		color.Yellow .. "\npoints de compétences : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n\n",
		color.Yellow .. "\nsanté de fer : " .. color.White,
		"augmente la vie et la fatigue de :" .. color.Green,
		" + 10 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.life"),
		color.Red .. " <= 5\n",	
		color.Yellow .. "Coût : ",
		color.White .. "3 points.\n",		
		color.Yellow .. "\npeau endurcie : " .. color.White,
		"augmente le combat sans armure et l'attaque à mains nues de :" .. color.Green,
		" + 10 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.peau"),
		color.Red .. " <= infini\n",
		color.Yellow .. "Coût : ",
		color.White .. "3 points.\n",		
		color.Yellow .. "\nguerrier expérimenté : " .. color.White,
		"augmente la parade et l'armurerie de :" .. color.Green,
		" + 10 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.guexp"),
		color.Red .. " <= infini\n",
		color.Yellow .. "Coût : ",
		color.White .. "3 points.\n"		
	},
    buttons = {						
        { caption = "Santé de fer",
            destinations = {menuHelper.destinations.setDefault("menu cmp def",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Life"})
                })
            }
		},
        { caption = "Peau endurcie",
            destinations = {menuHelper.destinations.setDefault("menu cmp def",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Peau"})
                })
            }	
		},
        { caption = "Guerrier expérimenté",
            destinations = {menuHelper.destinations.setDefault("menu cmp def",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Guexp"})
                })
            }
        },
        { caption = "Retour",
            destinations = {menuHelper.destinations.setDefault("menu cmp ecarlate")
            }
        },				
        { caption = "Quitter", destinations = nil }
    }
}

Menus["menu cmp mag"] = {
	text = {color.Orange .. "COMPETENCES DE MAGIE\n",
		color.Yellow .. "\nExp : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.soul"), 
		color.Red .. " >= " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.capSoul"),
		"\n",		
		color.Yellow .. "\nNiveau : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.levelSoul"), 
		color.Red .. " >= 50",
		"\n",	
		color.Yellow .. "\npoints de compétences : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n\n",
		color.Yellow .. "\narchimage : " .. color.White,
		"augmente la magie et la fatigue de :" .. color.Green,
		" + 10" .. color.White,
		" points.\n" .. color.Yellow,
		"Niveau : " .. color.White,		
		menuHelper.variables.currentPlayerDataVariable("customVariables.archi"),
		color.Red .. " >= 5",
		color.Yellow .. "Coût : ",
		color.White .. "3 points.\n",		
		color.Yellow .. "\nmoine : " .. color.White,
		"augmente la guerison et le mystisisme de :" .. color.Green,
		" + 10" .. color.White,
		" points.\n" .. color.Yellow,
		"Niveau : " .. color.White,		
		menuHelper.variables.currentPlayerDataVariable("customVariables.moine"),
		color.Red .. " <= infini\n",
		color.Yellow .. "Coût : ",
		color.White .. "3 points.\n",		
		color.Yellow .. "\ndaedra : " .. color.White,
		"augmente la destruction et l'invocation de :" .. color.Green,
		" + 10" .. color.White,
		" points.\n" .. color.Yellow,
		"Niveau : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.daedra"),
		color.Red .. " <= infini\n",
		color.Yellow .. "Coût : ",
		color.White .. "3 points."
	},
    buttons = {						
        { caption = "Archimage",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Archi"})
                })
            }
		},
        { caption = "Moine",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Moine"})
                })
            }	
		},
        { caption = "Daedra",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Daedra"})
                })
            }
        },
        { caption = "Retour",
            destinations = {menuHelper.destinations.setDefault("menu cmp ecarlate")
            }
        },				
        { caption = "Quitter", destinations = nil }
    }
}		
