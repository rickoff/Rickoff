--add file in folder script/menu
--add in config.lua find ``config.menuHelperFiles = { "forge de verre" } ``
--go to serverCore.lua and add to command text
        --elseif cmd[1] == "craftverre" then

            --Players[pid].currentCustomMenu = "menuverre"
            --menuHelper.displayMenu(pid, Players[pid].currentCustomMenu)


Menus["menuverre"] = {
    text = "#red ..***** ARME DE VERRE *****\n\
		Epee longue de verre - 10 > 1 \
		Hache de verre - 10 > 1 \
		Claymore de verre - 10 > 1 \
		Dague de verre - 10 > 1 \
		Hallebarde de verre - 10 > 1 \
		Baton de verre - 10 > 1 \
		Shuriken de verre - 1 > 1 \
		Couteau de lancer - 1 > 1 \
		Fleche de verre - 1 > 1 ",
		
    buttons = {
        { caption = "Epee longue de verre",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Epee longue de verre",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 10)
                })
            }
        },
        { caption = "Hache de verre",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Hache de verre",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 10)
                })
            }
        },
        { caption = "Claymore de verre",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Claymore de verre",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 10)
                })
            }
        },		
        { caption = "Dague de verre",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Dague de verre",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 10)
                })
            }
        },
        { caption = "Hallebarde de verre",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Hallebarde de verre",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 10)
                })
            }
        },
        { caption = "Baton de verre",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Baton de verre",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 10)
                })
            }
        },
        { caption = "Shuriken de verre",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Shuriken de verre",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 1)
                })
            }
        },	
        { caption = "Couteau de lancer",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Couteau de lancer",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 1)
                })
            }
        },		
        { caption = "Fleche de verre",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Fleche de verre",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 1)
                })
            }
        },
        { caption = "Page 2",
            destinations = {
                menuHelper.destinations.setDefault("crafting verre page 2")
            }
        },
        { caption = "Quitter", destinations = nil }		
	}
}

Menus["default crafting Epee longue de verre"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
					menuHelper.conditions.requireItem("ingred_raw_glass_01", 10)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 10),
                    menuHelper.effects.giveItem("glass longsword", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 50),
                    menuHelper.effects.giveItem("glass longsword", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuverre") } },		
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Hache de verre"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 10)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 10),
                    menuHelper.effects.giveItem("glass war axe", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 50),
                    menuHelper.effects.giveItem("glass war axe", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuverre") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Claymore de verre"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 10)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 10),
                    menuHelper.effects.giveItem("glass claymore", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 50),
                    menuHelper.effects.giveItem("glass claymore", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuverre") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Dague de verre"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 10)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 10),
                    menuHelper.effects.giveItem("glass dagger", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 50),
                    menuHelper.effects.giveItem("glass dagger", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuverre") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Hallebarde de verre"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 10)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 10),
                    menuHelper.effects.giveItem("glass halberd", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 50),
                    menuHelper.effects.giveItem("glass halberd", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuverre") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Baton de verre"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 10)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 10),
                    menuHelper.effects.giveItem("glass staff", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 50),
                    menuHelper.effects.giveItem("glass staff", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuverre") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Shuriken de verre"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 1)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 1),
                    menuHelper.effects.giveItem("glass throwing star", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 5)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 5),
                    menuHelper.effects.giveItem("glass throwing star", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuverre") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Couteau de lancer"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 1)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 1),
                    menuHelper.effects.giveItem("glass throwing knife", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 5)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 5),
                    menuHelper.effects.giveItem("glass throwing knife", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuverre") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Fleche de verre"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 1)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 1),
                    menuHelper.effects.giveItem("glass arrow", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 5)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 5),
                    menuHelper.effects.giveItem("glass arrow", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuverre") } },
        { caption = "Quitter", destinations = nil }
    }
}		
		
Menus["crafting verre page 2"] = {
    text = "#red ..***** ARMURE DE VERRE *****\n\
		Bottes de verre - 50 > 1 \
		Bracelet de verre (G) - 50 > 1 \
		Bracelet de verre (D) - 50 > 1 \
		Cuirasse de verre - 100 > 1 \
		Jambieres de verre - 75 > 1 \
		Casque de verre - 50 > 1 \
		Epauliere de verre (G) - 50 > 1 \
		Epauliere de verre (D) - 50 > 1 \
		Bouclier de verre - 50 > 1 \
		Ecu de verre - 50 > 1 ",
    buttons = {		
        { caption = "Bottes de verre",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Bottes de verre",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 1)
                })
            }
        },	
        { caption = "Bracelet de verre (G)",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Bracelet de verre (G)",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 1)
                })
            }
        },	
        { caption = "Bracelet de verre (D)",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Bracelet de verre (D)",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 1)
                })
            }
        },	
        { caption = "Cuirasse de verre",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Cuirasse de verre",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 1)
                })
            }
        },
        { caption = "Jambieres de verre",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Jambieres de verre",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 1)
                })
            }
        },	
        { caption = "Casque de verre",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Casque de verre",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 1)
                })
            }
        },	
        { caption = "Epauliere de verre (G)",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Epauliere de verre (G)",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 1)
                })
            }
        },	
        { caption = "Epauliere de verre (D)",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Epauliere de verre (D)",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 1)
                })
            }
        },
        { caption = "Bouclier de verre",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Bouclier de verre",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 1)
                })
            }
        },
        { caption = "Ecu de verre",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Ecu de verre",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 1)
                })
            }
        },
        { caption = "Page 1",
            destinations = {
                menuHelper.destinations.setDefault("menuverre")
            }
        },		
        { caption = "Quitter", destinations = nil }
    }	
}

Menus["default crafting Bottes de verre"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 50),
                    menuHelper.effects.giveItem("glass_boots", 1)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("crafting verre page 2") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Bracelet de verre (G)"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 50),
                    menuHelper.effects.giveItem("glass_bracer_left", 1)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("crafting verre page 2") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Bracelet de verre (D)"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 50),
                    menuHelper.effects.giveItem("glass_bracer_right", 1)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("crafting verre page 2") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Cuirasse de verre"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 100)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 100),
                    menuHelper.effects.giveItem("glass_cuirass", 1)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("crafting verre page 2") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Jambieres de verre"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 75)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 75),
                    menuHelper.effects.giveItem("glass_greaves", 1)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("crafting verre page 2") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Casque de verre"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 50),
                    menuHelper.effects.giveItem("glass_helm", 1)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("crafting verre page 2") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Epauliere de verre (G)"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 50),
                    menuHelper.effects.giveItem("glass_pauldron_left", 1)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("crafting verre page 2") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Epauliere de verre (D)"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 50),
                    menuHelper.effects.giveItem("glass_pauldron_right", 1)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("crafting verre page 2") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Bouclier de verre"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 50),
                    menuHelper.effects.giveItem("glass_shield", 1)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("crafting verre page 2") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Ecu de verre"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_glass_01", 50),
                    menuHelper.effects.giveItem("glass_towershield", 1)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("crafting verre page 2") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["lack of materials"] = {
    text = "Il vous manque les matériaux requis.",
    buttons = {
        { caption = "Retour", destinations = { menuHelper.destinations.setFromCustomVariable("previousCustomMenu") } },
        { caption = "Ok", destinations = nil }
    }
}

Menus["reward generic singular"] = {
    text = "Félicitations! L'article est fabriqué avec succès.",
    buttons = {
        { caption = "Craft", destinations = { menuHelper.destinations.setFromCustomVariable("previousCustomMenu") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["reward generic plural"] = {
    text = "Félicitations! Les articles ont était fabriqué avec succès.",
    buttons = {
        { caption = "Craft", destinations = { menuHelper.destinations.setFromCustomVariable("previousCustomMenu") } },
        { caption = "Quitter", destinations = nil }
    }
}

