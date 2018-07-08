--add file in folder script/menu
--add in config.lua find ``config.menuHelperFiles = { "forge de verre" } ``
--go to server.lua and add to comman text
        --elseif cmd[1] == "craftverre" then

            --Players[pid].currentCustomMenu = "forge de verre"
            --menuHelper.displayMenu(pid, Players[pid].currentCustomMenu)


Menus["forge de verre"] = {
    text = "#red ..***** ARME DE VERRE *****\n\
		Epée longue de verre - 10 > 1 \
		Hache de verre - 10 > 1 \
		Claymore de verre - 10 > 1 \
		Dague de verre - 10 > 1 \
		Hallebarde de verre - 10 > 1 \
		Bâton de verre - 10 > 1 \
		Shuriken de verre - 1 > 1 \
		Couteau de lancer - 1 > 1 \
		Flèche de verre - 1 > 1 ",
		
    buttons = {
        { caption = "Epée longue",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Epée longue",
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
        { caption = "Bâton de verre",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Bâton de verre",
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
        { caption = "Flèche de verre",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Flèche de verre",
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
		
Menus["crafting verre page 2"] = {
    text = "#red ..***** ARMURE DE VERRE *****\n\
		Bottes de verre - 50 > 1 \
		Bracelet de verre (G) - 50 > 1 \
		Bracelet de verre (D) - 50 > 1 \
		Cuirasse de verre - 100 > 1 \
		Jambières de verre - 75 > 1 \
		Casque de verre - 50 > 1 \
		Epaulière de verre (G) - 50 > 1 \
		Epaulière de verre (D) - 50 > 1 \
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
        { caption = "Jambières de verre",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Jambières de verre",
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
        { caption = "Epaulière de verre (G)",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Epaulière de verre (G)",
                {
                    menuHelper.conditions.requireItem("ingred_raw_glass_01", 1)
                })
            }
        },	
        { caption = "Epaulière de verre (D)",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Epaulière de verre (D)",
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
                menuHelper.destinations.setDefault("forge de verre")
            }
        },		
        { caption = "Quitter", destinations = nil }
    }	
}

Menus["default crafting Epée longue"] = {
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge de verre") } },
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge de verre") } },
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge de verre") } },
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge de verre") } },
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge de verre") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Bâton de verre"] = {
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge de verre") } },
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge de verre") } },
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge de verre") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Flèche de verre"] = {
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge de verre") } },
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

Menus["default crafting Jambières de verre"] = {
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

Menus["default crafting Epaulière de verre (G)"] = {
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

Menus["default crafting Epaulière de verre (D)"] = {
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
