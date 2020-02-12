Menus["menu cmp ecarlate"] = {
	text = {color.Orange .. "MENU DES COMPETENCES\n",
		color.Yellow .. "\nExp : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.soul"), 
		color.Red .. " >= " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.capSoul"),
		"\n",		
		color.Yellow .. "\nNiveau : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.levelSoul"), 
		"\n",	
		color.Yellow .. "\npoints de compétences : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n",
	},
    buttons = {				
        { caption = "Ecoles",
			destinations = {menuHelper.destinations.setDefault("menu cmp def") 
			}
		},
        { caption = "Combats",
			destinations = {menuHelper.destinations.setDefault("menu cmp cmb")
			}
        },
        { caption = "Talents",
			destinations = {menuHelper.destinations.setDefault("menu cmp mag")
			}
        },
        { caption = "Survie",
			destinations = {menuHelper.destinations.setDefault("menu cmp survie")
			}
        },		
        { caption = "Retour",
            destinations = {menuHelper.destinations.setDefault("menu player")
            }
        },				
        { caption = "Quitter", destinations = nil }
    }
}

Menus["menu cmp cmb"] = {
	text = {color.Orange .. "AUGMENTER COMPETENCES DE COMBAT\n",
		color.Yellow .. "\nExp : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.soul"), 
		color.Red .. " >= " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.capSoul"),
		"\n",		
		color.Yellow .. "\nNiveau : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.levelSoul"), 
		"\n",	
		color.Yellow .. "\npoints de compétences : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n\n",
		color.White .. "\nSelectionnez une caractéristique dans la liste" .. color.Yellow,
		"\naugmente la caractéristique de :" .. color.Green,
		" + 1" .. color.White,
		" points.\n" .. color.Yellow,
		color.Yellow .. "\nCoût : ",
		color.White .. "1 points.\n"		
	},
    buttons = {						
        { caption = "Force",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Force", "Add"})
                })
            }
		},
        { caption = "Endurance",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Endurance", "Add"})
                })
            }
		},		
        { caption = "Rapidité",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Rapidité", "Add"})
                })
            }	
		},
        { caption = "Agilité",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Agilité", "Add"})
                })
            }	
		},		
        { caption = "Intelligence",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Intelligence", "Add"})
                })
            }
        },
        { caption = "Volonté",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Volonté", "Add"})
                })
            }
        },		
        { caption = "Chance",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Chance", "Add"})
                })
            }
        },
        { caption = "Personnalité",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Personnalité", "Add"})
                })
            }
        },
        { caption = "Diminuer",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb 2")
            }
        },		
        { caption = "Retour",
            destinations = {menuHelper.destinations.setDefault("menu cmp ecarlate")
            }
        },				
        { caption = "Quitter", destinations = nil }
    }
}

Menus["menu cmp cmb 2"] = {
	text = {color.Orange .. "DIMINUER COMPETENCES DE COMBAT\n",
		color.Yellow .. "\nExp : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.soul"), 
		color.Red .. " >= " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.capSoul"),
		"\n",		
		color.Yellow .. "\nNiveau : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.levelSoul"), 
		"\n",	
		color.Yellow .. "\npoints de compétences : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n\n",
		color.White .. "\nSelectionnez une caractéristique dans la liste" .. color.Yellow,
		"\ndiminue la caractéristique de :" .. color.Green,
		" - 1" .. color.White,
		" points.\n" .. color.Yellow,
		color.Yellow .. "\nGain : ",
		color.White .. "1 points.\n"		
	},
    buttons = {						
        { caption = "Force",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb 2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Force", "Remove"})
                })
            }
		},
        { caption = "Endurance",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb 2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Endurance", "Remove"})
                })
            }
		},		
        { caption = "Rapidité",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb 2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Rapidité", "Remove"})
                })
            }	
		},
        { caption = "Agilité",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb 2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Agilité", "Remove"})
                })
            }	
		},		
        { caption = "Intelligence",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb 2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Intelligence", "Remove"})
                })
            }
        },
        { caption = "Volonté",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb 2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Volonté", "Remove"})
                })
            }
        },		
        { caption = "Chance",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb 2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Chance", "Remove"})
                })
            }
        },
        { caption = "Personnalité",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb 2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Personnalité", "Remove"})
                })
            }
        },
        { caption = "Augmenter",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb")
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
	text = {color.Orange .. "AUGMENTER ECOLES\n",
		color.Yellow .. "\nExp : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.soul"), 
		color.Red .. " >= " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.capSoul"),
		"\n",		
		color.Yellow .. "\nNiveau : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.levelSoul"),
		"\n",	
		color.Yellow .. "\npoints de compétences : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n\n",
		color.Yellow .. "\nGuerrier : " .. color.White,
		"augmente la santé de base de :" .. color.Green,
		" + 10 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.life"),
		color.Red .. " <= 5\n",	
		color.Yellow .. "Coût : ",
		color.White .. "3 points.\n",		
		color.Yellow .. "\nMage : " .. color.White,
		"augmente la magie de base de :" .. color.Green,
		" + 10 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.peau"),
		color.Red .. " <= 5\n",
		color.Yellow .. "Coût : ",
		color.White .. "3 points.\n",		
		color.Yellow .. "\nVoleur: " .. color.White,
		"augmente la fatigue de base de :" .. color.Green,
		" + 10 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.guexp"),
		color.Red .. " <= 5\n",
		color.Yellow .. "Coût : ",
		color.White .. "3 points.\n"		
	},
    buttons = {						
        { caption = "Guerrier",
            destinations = {menuHelper.destinations.setDefault("menu cmp def",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Life", "Add"})
                })
            }
		},
        { caption = "Mage",
            destinations = {menuHelper.destinations.setDefault("menu cmp def",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Peau", "Add"})
                })
            }	
		},
        { caption = "Voleur",
            destinations = {menuHelper.destinations.setDefault("menu cmp def",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Guexp", "Add"})
                })
            }
        },
        { caption = "Diminuer",
            destinations = {menuHelper.destinations.setDefault("menu cmp def 2")
            }
        },		
        { caption = "Retour",
            destinations = {menuHelper.destinations.setDefault("menu cmp ecarlate")
            }
        },				
        { caption = "Quitter", destinations = nil }
    }
}

Menus["menu cmp def 2"] = {
	text = {color.Orange .. "DIMINUER ECOLES\n",
		color.Yellow .. "\nExp : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.soul"), 
		color.Red .. " >= " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.capSoul"),
		"\n",		
		color.Yellow .. "\nNiveau : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.levelSoul"),
		"\n",	
		color.Yellow .. "\npoints de compétences : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n\n",
		color.Yellow .. "\nGuerrier : " .. color.White,
		"diminue la santé de base de :" .. color.Green,
		" - 10 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.life"),
		color.Red .. " <= 5\n",	
		color.Yellow .. "Gain : ",
		color.White .. "3 points.\n",		
		color.Yellow .. "\nMage : " .. color.White,
		"diminue la magie de base de :" .. color.Green,
		" - 10 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.peau"),
		color.Red .. " <= 5\n",
		color.Yellow .. "Gain : ",
		color.White .. "3 points.\n",		
		color.Yellow .. "\nVoleur: " .. color.White,
		"diminue la fatigue de base de :" .. color.Green,
		" - 10 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.guexp"),
		color.Red .. " <= 5\n",
		color.Yellow .. "Gain : ",
		color.White .. "3 points.\n"		
	},
    buttons = {						
        { caption = "Guerrier",
            destinations = {menuHelper.destinations.setDefault("menu cmp def 2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Life", "Remove"})
                })
            }
		},
        { caption = "Mage",
            destinations = {menuHelper.destinations.setDefault("menu cmp def 2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Peau", "Remove"})
                })
            }	
		},
        { caption = "Voleur",
            destinations = {menuHelper.destinations.setDefault("menu cmp def 2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Guexp", "Remove"})
                })
            }
        },
        { caption = "Augmenter",
            destinations = {menuHelper.destinations.setDefault("menu cmp def")
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
	text = {color.Orange .. "Augmenter talents page 1\n",
		color.Yellow .. "\nExp : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.soul"), 
		color.Red .. " >= " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.capSoul"),
		"\n",		
		color.Yellow .. "\nNiveau : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.levelSoul"),
		"\n",	
		color.Yellow .. "\npoints de compétences : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n\n",
		color.White .. "\nSelectionnez un talent dans la liste" .. color.Yellow,
		"\naugmente le talent de :" .. color.Green,
		" + 1" .. color.White,
		" points.\n" .. color.Yellow,
		color.Yellow .. "\nCoût : ",
		color.White .. "1 points.\n"
	},
    buttons = {	
        { caption = "Mains nues",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Handtohand", "Add"})
                })
            }
        },	
        { caption = "Lame courte",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Shortblade", "Add"})
                })
            }	
		},	
        { caption = "Lame longue",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Longblade", "Add"})
                })
            }
        },
        { caption = "Hache",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Axe", "Add"})
                })
            }
        },	
        { caption = "Contondant",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Bluntweapon", "Add"})
                })
            }
        },		
        { caption = "Lance",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Spear", "Add"})
                })
            }
        },		
        { caption = "Sécurité",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Security", "Add"})
                })
            }
		},		
        { caption = "Athlétisme",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Athletics", "Add"})
                })
            }
        },		
        { caption = "Précision",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Marksman", "Add"})
                })
            }
		},
        { caption = "Acrobatie",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Acrobatics", "Add"})
                })
            }	
		},
        { caption = "Discrétion",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Sneak", "Add"})
                })
            }
        },	
        { caption = "Marchandage",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Mercantile", "Add"})
                })
            }
		},		
        { caption = "Sans armure",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Unarmored", "Add"})
                })
            }
        },
        { caption = "Diminuer",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag3")
            }
        },			
        { caption = "Page 2",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2")
            }
        },			
        { caption = "Retour",
            destinations = {menuHelper.destinations.setDefault("menu cmp ecarlate")
            }
        },				
        { caption = "Quitter", destinations = nil }
    }
}

Menus["menu cmp mag3"] = {
	text = {color.Orange .. "Diminuer talents page 1\n",
		color.Yellow .. "\nExp : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.soul"), 
		color.Red .. " >= " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.capSoul"),
		"\n",		
		color.Yellow .. "\nNiveau : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.levelSoul"),
		"\n",	
		color.Yellow .. "\npoints de compétences : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n\n",
		color.White .. "\nSelectionnez un talent dans la liste" .. color.Yellow,
		"\ndiminue le talent de :" .. color.Green,
		" - 1" .. color.White,
		" points.\n" .. color.Yellow,
		color.Yellow .. "\nGain : ",
		color.White .. "1 points.\n"
	},
    buttons = {	
        { caption = "Mains nues",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag3",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Handtohand", "Remove"})
                })
            }
        },	
        { caption = "Lame courte",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag3",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Shortblade", "Remove"})
                })
            }	
		},	
        { caption = "Lame longue",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag3",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Longblade", "Remove"})
                })
            }
        },
        { caption = "Hache",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag3",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Axe", "Remove"})
                })
            }
        },	
        { caption = "Contondant",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag3",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Bluntweapon", "Remove"})
                })
            }
        },		
        { caption = "Lance",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag3",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Spear", "Remove"})
                })
            }
        },		
        { caption = "Sécurité",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag3",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Security", "Remove"})
                })
            }
		},		
        { caption = "Athlétisme",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag3",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Athletics", "Remove"})
                })
            }
        },		
        { caption = "Précision",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag3",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Marksman", "Remove"})
                })
            }
		},
        { caption = "Acrobatie",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag3",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Acrobatics", "Remove"})
                })
            }	
		},
        { caption = "Discrétion",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag3",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Sneak", "Remove"})
                })
            }
        },	
        { caption = "Marchandage",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag3",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Mercantile", "Remove"})
                })
            }
		},		
        { caption = "Sans armure",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag3",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Unarmored", "Remove"})
                })
            }
        },
        { caption = "Augmenter",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag")
            }
        },			
        { caption = "Page 2",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag4")
            }
        },			
        { caption = "Retour",
            destinations = {menuHelper.destinations.setDefault("menu cmp ecarlate")
            }
        },				
        { caption = "Quitter", destinations = nil }
    }
}

Menus["menu cmp mag2"] = {
	text = {color.Orange .. "Augmenter talents page 2\n",
		color.Yellow .. "\nExp : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.soul"), 
		color.Red .. " >= " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.capSoul"),
		"\n",		
		color.Yellow .. "\nNiveau : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.levelSoul"), 
		"\n",	
		color.Yellow .. "\npoints de compétences : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n\n",
		color.White .. "\nSelectionne un talent dans la liste" .. color.Yellow,
		"\naugmente le talent de :" .. color.Green,
		" + 1" .. color.White,
		" points.\n" .. color.Yellow,
		color.Yellow .. "\nCoût : ",
		color.White .. "1 points.\n"
	},
    buttons = {		
        { caption = "Armure légère",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Lightarmor", "Add"})
                })
            }	
		},
        { caption = "Armure inter",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Mediumarmor", "Add"})
                })
            }
		},
        { caption = "Armure lourde",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Heavyarmor", "Add"})
                })
            }	
		},
        { caption = "Parade",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Block", "Add"})
                })
            }
		},		
        { caption = "Armurier",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Armorer", "Add"})
                })
            }
		},
        { caption = "Eloquence",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Speechcraft", "Add"})
                })
            }	
		},
        { caption = "Enchantement",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Enchant", "Add"})
                })
            }	
		},
        { caption = "Destruction",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Destruction", "Add"})
                })
            }
        },
        { caption = "Conjuration",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Conjuration", "Add"})
                })
            }
		},		
        { caption = "Illusion",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Illusion", "Add"})
                })
            }
		},
        { caption = "Alteration",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Alteration", "Add"})
                })
            }
        },		
        { caption = "Mysticisme",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Mysticism", "Add"})
                })
            }	
		},
        { caption = "Guérison",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Restoration", "Add"})
                })
            }	
		},
        { caption = "Alchimie",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Alchemy", "Add"})
                })
            }	
		},
        { caption = "Diminuer",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag4")
            }
        },		
        { caption = "Page 1",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag")
            }
        },		
        { caption = "Retour",
            destinations = {menuHelper.destinations.setDefault("menu cmp ecarlate")
            }
        },				
        { caption = "Quitter", destinations = nil }
    }
}

Menus["menu cmp mag4"] = {
	text = {color.Orange .. "Diminuer talents page 2\n",
		color.Yellow .. "\nExp : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.soul"), 
		color.Red .. " >= " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.capSoul"),
		"\n",		
		color.Yellow .. "\nNiveau : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.levelSoul"), 
		"\n",	
		color.Yellow .. "\npoints de compétences : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n\n",
		color.White .. "\nSelectionne un talent dans la liste" .. color.Yellow,
		"\ndiminue le talent de :" .. color.Green,
		" - 1" .. color.White,
		" points.\n" .. color.Yellow,
		color.Yellow .. "\nGain : ",
		color.White .. "1 points.\n"
	},
    buttons = {		
        { caption = "Armure légère",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag4",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Lightarmor", "Remove"})
                })
            }	
		},
        { caption = "Armure inter",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag4",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Mediumarmor", "Remove"})
                })
            }
		},
        { caption = "Armure lourde",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag4",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Heavyarmor", "Remove"})
                })
            }	
		},
        { caption = "Parade",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag4",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Block", "Remove"})
                })
            }
		},		
        { caption = "Armurier",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag4",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Armorer", "Remove"})
                })
            }
		},
        { caption = "Eloquence",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag4",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Speechcraft", "Remove"})
                })
            }	
		},
        { caption = "Enchantement",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag4",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Enchant", "Remove"})
                })
            }	
		},
        { caption = "Destruction",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag4",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Destruction", "Remove"})
                })
            }
        },
        { caption = "Conjuration",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag4",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Conjuration", "Remove"})
                })
            }
		},		
        { caption = "Illusion",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag4",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Illusion", "Remove"})
                })
            }
		},
        { caption = "Alteration",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag4",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Alteration", "Remove"})
                })
            }
        },		
        { caption = "Mysticisme",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag4",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Mysticism", "Remove"})
                })
            }	
		},
        { caption = "Guérison",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag4",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Restoration", "Remove"})
                })
            }	
		},
        { caption = "Alchimie",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag4",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Alchemy", "Remove"})
                })
            }	
		},
        { caption = "Augmenter",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2")
            }
        },		
        { caption = "Page 1",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag3")
            }
        },		
        { caption = "Retour",
            destinations = {menuHelper.destinations.setDefault("menu cmp ecarlate")
            }
        },				
        { caption = "Quitter", destinations = nil }
    }
}

Menus["menu cmp survie"] = {
	text = {color.Orange .. "AUGMENTER SURVIE\n",
		color.Yellow .. "\nFaim : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.HungerTime"), 
		color.Red .. " >= " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.HungerTimeMax"),
		"\n",		
		color.Yellow .. "\nSoif : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.ThirsthTime"),
		color.Red .. " >= " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.ThirsthTimeMax"),
		"\n",	
		color.Yellow .. "\nSommeil : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.SleepTime"),
		color.Red .. " >= " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.SleepTimeMax"),
		"\n\n",	
		color.Yellow .. "\nFaim : " .. color.White,
		"augmente la faim de base de :" .. color.Green,
		" + 60 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.hungerCount"),
		color.Red .. " <= 5\n",	
		color.Yellow .. "Coût : ",
		color.White .. "3 points.\n",		
		color.Yellow .. "\nSoif : " .. color.White,
		"augmente la soif de base de :" .. color.Green,
		" + 60 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.thirstCount"),
		color.Red .. " <= 5\n",
		color.Yellow .. "Coût : ",
		color.White .. "3 points.\n",		
		color.Yellow .. "\nSommeil: " .. color.White,
		"augmente le sommeil de base de :" .. color.Green,
		" + 120 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.sleepCount"),
		color.Red .. " <= 5\n",
		color.Yellow .. "Coût : ",
		color.White .. "3 points.\n"		
	},
    buttons = {						
        { caption = "Faim",
            destinations = {menuHelper.destinations.setDefault("menu cmp survie",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Hunger", "Add"})
                })
            }
		},
        { caption = "Soif",
            destinations = {menuHelper.destinations.setDefault("menu cmp survie",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Thirst", "Add"})
                })
            }	
		},
        { caption = "Sommeil",
            destinations = {menuHelper.destinations.setDefault("menu cmp survie",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Sleep", "Add"})
                })
            }
        },
        { caption = "Diminuer",
            destinations = {menuHelper.destinations.setDefault("menu cmp survie2")
            }
        },		
        { caption = "Retour",
            destinations = {menuHelper.destinations.setDefault("menu cmp ecarlate")
            }
        },				
        { caption = "Quitter", destinations = nil }
    }
}

Menus["menu cmp survie2"] = {
	text = {color.Orange .. "DIMINUER SURVIE\n",
		color.Yellow .. "\nFaim : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.HungerTime"), 
		color.Red .. " >= " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.HungerTimeMax"),
		"\n",		
		color.Yellow .. "\nSoif : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.ThirsthTime"),
		color.Red .. " >= " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.ThirsthTimeMax"),
		"\n",	
		color.Yellow .. "\nSommeil : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.SleepTime"),
		color.Red .. " >= " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.SleepTimeMax"),
		"\n\n",	
		color.Yellow .. "\nFaim : " .. color.White,
		"diminue la faim de base de :" .. color.Green,
		" - 60 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.hungerCount"),
		color.Red .. " <= 5\n",	
		color.Yellow .. "Gain : ",
		color.White .. "3 points.\n",		
		color.Yellow .. "\nSoif : " .. color.White,
		"diminue la soif de base de :" .. color.Green,
		" - 60 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.thirstCount"),
		color.Red .. " <= 5\n",
		color.Yellow .. "Gain : ",
		color.White .. "3 points.\n",		
		color.Yellow .. "\nSommeil: " .. color.White,
		"diminue le sommeil de base de :" .. color.Green,
		" - 120 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.sleepCount"),
		color.Red .. " <= 5\n",
		color.Yellow .. "Gain : ",
		color.White .. "3 points.\n"		
	},
    buttons = {						
        { caption = "Faim",
            destinations = {menuHelper.destinations.setDefault("menu cmp survie2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Hunger", "Remove"})
                })
            }
		},
        { caption = "Soif",
            destinations = {menuHelper.destinations.setDefault("menu cmp survie2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Thirst", "Remove"})
                })
            }	
		},
        { caption = "Sommeil",
            destinations = {menuHelper.destinations.setDefault("menu cmp survie2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Sleep", "Remove"})
                })
            }
        },
        { caption = "Augmenter",
            destinations = {menuHelper.destinations.setDefault("menu cmp survie")
            }
        },		
        { caption = "Retour",
            destinations = {menuHelper.destinations.setDefault("menu cmp ecarlate")
            }
        },				
        { caption = "Quitter", destinations = nil }
    }
}
