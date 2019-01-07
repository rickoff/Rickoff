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
		"\n",	
		color.Yellow .. "\npoints de compétences : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n\n",
		color.Yellow .. "\ncompétence du guerrier : " .. color.White,
		"augmente la force et l'endurance :" .. color.Green,
		" + 4 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.guerrier"),
		color.Red .. " <= 5\n",	
		color.Yellow .. "Coût : ",
		color.White .. "3 points.\n",		
		color.Yellow .. "\ncompétence du voleur : " .. color.White,
		"augmente la vitesse et l'agilité de :" .. color.Green,
		" + 4 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.voleur"),
		color.Red .. " <= 5\n",
		color.Yellow .. "Coût : ",
		color.White .. "3 points.\n",		
		color.Yellow .. "\ncompétence du mage : " .. color.White,
		"augmente l'intelligence et la volonté de :" .. color.Green,
		" + 4 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.mage"),
		color.Red .. " <= 5\n",
		color.Yellow .. "Coût : ",
		color.White .. "3 points.\n",
		color.Yellow .. "\ncompétence du roublard : " .. color.White,
		"augmente la chance et la personnalité de :" .. color.Green,
		" + 4 " .. color.White,
		" points. " .. color.Yellow,
		"\nNiveau : " .. color.White,			
		menuHelper.variables.currentPlayerDataVariable("customVariables.roublard"),
		color.Red .. " <= 5\n",
		color.Yellow .. "Coût : ",
		color.White .. "3 points.\n"		
	},
    buttons = {						
        { caption = "Guerrier",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Guerrier"})
                })
            }
		},
        { caption = "Voleur",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Voleur"})
                })
            }	
		},
        { caption = "Mage",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Mage"})
                })
            }
        },
        { caption = "Roublard",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Roublard"})
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
	text = {color.Orange .. "ECOLES\n",
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
					{menuHelper.variables.currentPid(), "Life"})
                })
            }
		},
        { caption = "Mage",
            destinations = {menuHelper.destinations.setDefault("menu cmp def",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Peau"})
                })
            }	
		},
        { caption = "Voleur",
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
	text = {color.Orange .. "Talents page 1\n",
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
		" + 10" .. color.White,
		" points.\n" .. color.Yellow,
		color.Yellow .. "\nCoût : ",
		color.White .. "3 points.\n"
	},
    buttons = {	
        { caption = "Mains nues",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Handtohand"})
                })
            }
        },	
        { caption = "Lame courte",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Shortblade"})
                })
            }	
		},	
        { caption = "Lame longue",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Longblade"})
                })
            }
        },
        { caption = "Hache",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Axe"})
                })
            }
        },	
        { caption = "Contondant",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Bluntweapon"})
                })
            }
        },		
        { caption = "Lance",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Spear"})
                })
            }
        },		
        { caption = "Sécurité",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Security"})
                })
            }
		},		
        { caption = "Athlétisme",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Athletics"})
                })
            }
        },		
        { caption = "Précision",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Marksman"})
                })
            }
		},
        { caption = "Acrobatie",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Acrobatics"})
                })
            }	
		},
        { caption = "Discrétion",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Sneak"})
                })
            }
        },	
        { caption = "Marchandage",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Mercantile"})
                })
            }
		},		
        { caption = "Sans armure",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Unarmored"})
                })
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

Menus["menu cmp mag2"] = {
	text = {color.Orange .. "Talents page 2\n",
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
		" + 10" .. color.White,
		" points.\n" .. color.Yellow,
		color.Yellow .. "\nCoût : ",
		color.White .. "3 points.\n"
	},
    buttons = {		
        { caption = "Armure légère",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Lightarmor"})
                })
            }	
		},
        { caption = "Armure inter",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Mediumarmor"})
                })
            }
		},
        { caption = "Armure lourde",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Heavyarmor"})
                })
            }	
		},
        { caption = "Parade",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Block"})
                })
            }
		},		
        { caption = "Armurier",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Armorer"})
                })
            }
		},
        { caption = "Eloquence",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Speechcraft"})
                })
            }	
		},
        { caption = "Enchantement",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Enchant"})
                })
            }	
		},
        { caption = "Destruction",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Destruction"})
                })
            }
        },
        { caption = "Conjuration",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Conjuration"})
                })
            }
		},		
        { caption = "Illusion",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Illusion"})
                })
            }
		},
        { caption = "Alteration",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Alteration"})
                })
            }
        },		
        { caption = "Mysticisme",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Mysticism"})
                })
            }	
		},
        { caption = "Guérison",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Restoration"})
                })
            }	
		},
        { caption = "Alchimie",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2",
            { 
				menuHelper.effects.runGlobalFunction("EcarlateSoul", "OnPlayerCompetence", 
					{menuHelper.variables.currentPid(), "Alchemy"})
                })
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
