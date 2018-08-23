--add file in folder script/menu
--add in config.lua find ``config.menuHelperFiles = { "forge d'ebonite" } ``
--go to server.lua and add to command text
        --elseif cmd[1] == "craftebonite" then

            --Players[pid].currentCustomMenu = "forge d'ebonite"
            --menuHelper.displayMenu(pid, Players[pid].currentCustomMenu)	

Menus["menuebonite"] = {
    text = "#red ..***** ARME EN EBONITE ***** \n\
		Baton de mage - 10 > 1 \
		Dague en ebonite - 10 > 1 \
		Hache de guerre - 10 > 1 \
		Lance en ebonite - 10 > 1 \
		Epee courte - 10 > 1 \
		Cimeterre d'ebonite - 10 > 1 \
		Masse d'armes - 10 > 1 \
		Epee longue - 10 > 1 \
		Epee large - 10 > 1 \
		Fleche en ebonite - 1 > 1 \
		Dard en ebonite - 1 > 1 \
		Shuriken en ebonite - 1 > 1",
		
    buttons = {
        { caption = "Baton de mage",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Baton de mage",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                })
            }
        },
        { caption = "Dague en ebonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Dague en ebonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                })
            }
        },
        { caption = "Hache de guerre",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Hache de guerre",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                })
            }
        },		
        { caption = "Lance en ebonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Lance en ebonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                })
            }
        },
        { caption = "Epee courte",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Epee courte",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                })
            }
        },
        { caption = "Cimeterre d'ebonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Cimeterre d'ebonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                })
            }
        },
        { caption = "Masse d'armes",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Masse d'armes",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                })
            }
        },	
        { caption = "Epee longue",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Epee longue",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                })
            }
        },		
        { caption = "Epee large",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Epee large",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                })
            }
        },
        { caption = "Fleche en ebonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Fleche en ebonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },	
        { caption = "Dard en ebonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Dard en ebonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },	
        { caption = "Shuriken en ebonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Shuriken en ebonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },			
        { caption = "Page 2",
            destinations = {
                menuHelper.destinations.setDefault("crafting ebonite page 2")
            }
        },
        { caption = "Quitter", destinations = nil }		
	}
}		
		
Menus["crafting ebonite page 2"] = {
    text = "#red ..***** ARMURE D'EBONITE *****\n\
		Bottes en ebonite - 50 > 1 \
		Bracelet en ebonite (G) - 50 > 1 \
		Bracelet en ebonite (D) - 50 > 1 \
		Cuirasse en ebonite - 100 > 1 \
		Jambières en ebonite - 75 > 1 \
		Casque en ebonite - 50 > 1 \
		Epaulière en ebonite (G) - 50 > 1 \
		Epaulière en ebonite (D) - 50 > 1 \
		Bouclier en ebonite - 50 > 1 \
		Ecu en ebonite - 50 > 1 ",
    buttons = {		
        { caption = "Bottes en ebonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Bottes en ebonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },	
        { caption = "Bracelet en ebonite (G)",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Bracelet en ebonite (G)",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },	
        { caption = "Bracelet en ebonite (D)",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Bracelet en ebonite (D)",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },	
        { caption = "Cuirasse en ebonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Cuirasse en ebonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },
        { caption = "Jambières en ebonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Jambières en ebonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },	
        { caption = "Casque en ebonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Casque en ebonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },	
        { caption = "Epaulière en ebonite (G)",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Epaulière en ebonite (G)",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },	
        { caption = "Epaulière en ebonite (D)",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Epaulière en ebonite (D)",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },
        { caption = "Bouclier en ebonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Bouclier en ebonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },
        { caption = "Ecu en ebonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Ecu en ebonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },
        { caption = "Page 1",
            destinations = {
                menuHelper.destinations.setDefault("menuebonite")
            }
        },		
        { caption = "Quitter", destinations = nil }
    }	
}

Menus["default crafting Baton de mage"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 10),
                    menuHelper.effects.giveItem("ebony wizard's staff", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 50),
                    menuHelper.effects.giveItem("glass longsword", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Dague en ebonite"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 10),
                    menuHelper.effects.giveItem("ebony_dagger_mehrunes", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 50),
                    menuHelper.effects.giveItem("ebony_dagger_mehrunes", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Hache de guerre"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 10),
                    menuHelper.effects.giveItem("ebony war axe", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 50),
                    menuHelper.effects.giveItem("ebony war axe", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Lance en ebonite"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 10),
                    menuHelper.effects.giveItem("ebony spear", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 50),
                    menuHelper.effects.giveItem("ebony spear", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Epee courte"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 10),
                    menuHelper.effects.giveItem("ebony shortsword", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 50),
                    menuHelper.effects.giveItem("ebony shortsword", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Cimeterre d'ebonite"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 10),
                    menuHelper.effects.giveItem("Ebony Scimitar", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 50),
                    menuHelper.effects.giveItem("Ebony Scimitar", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Masse d'armes"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 10),
                    menuHelper.effects.giveItem("glass throwing star", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 50),
                    menuHelper.effects.giveItem("glass throwing star", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Epee longue"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 10),
                    menuHelper.effects.giveItem("ebony longsword", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 50),
                    menuHelper.effects.giveItem("ebony longsword", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Epee large"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 10),
                    menuHelper.effects.giveItem("ebony broadsword", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 50),
                    menuHelper.effects.giveItem("ebony broadsword", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Fleche en ebonite"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 1),
                    menuHelper.effects.giveItem("ebony arrow", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 5)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 5),
                    menuHelper.effects.giveItem("ebony arrow", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Dard en ebonite"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 1),
                    menuHelper.effects.giveItem("ebony dart", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 5)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 5),
                    menuHelper.effects.giveItem("ebony dart", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Shuriken en ebonite"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 1),
                    menuHelper.effects.giveItem("ebony throwing star", 1)
                })
            }
        },
        { caption = "5",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic plural",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 5)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 5),
                    menuHelper.effects.giveItem("ebony throwing star", 5)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("menuebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Bottes en ebonite"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 50),
                    menuHelper.effects.giveItem("ebony_boots", 1)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("crafting ebonite page 2") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Bracelet en ebonite (G)"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 50),
                    menuHelper.effects.giveItem("ebony_bracer_left", 1)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("crafting ebonite page 2") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Bracelet en ebonite (D)"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 50),
                    menuHelper.effects.giveItem("ebony_bracer_right", 1)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("crafting ebonite page 2") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Cuirasse en ebonite"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 100)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 100),
                    menuHelper.effects.giveItem("ebony_cuirass", 1)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("crafting ebonite page 2") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Jambières en ebonite"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 75)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 75),
                    menuHelper.effects.giveItem("ebony_greaves", 1)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("crafting ebonite page 2") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Casque en ebonite"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 50),
                    menuHelper.effects.giveItem("ebony_closed_helm", 1)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("crafting ebonite page 2") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Epaulière en ebonite (G)"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 50),
                    menuHelper.effects.giveItem("ebony_pauldron_left", 1)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("crafting ebonite page 2") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Epaulière en ebonite (D)"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 50),
                    menuHelper.effects.giveItem("ebony_pauldron_right", 1)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("crafting ebonite page 2") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Bouclier en ebonite"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 50),
                    menuHelper.effects.giveItem("ebony_shield", 1)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("crafting ebonite page 2") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Ecu en ebonite"] = {
    text = "Combien voulez vous en fabriquer ?",
    buttons = {
        { caption = "1",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("reward generic singular",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 50)
                },
                {
                    menuHelper.effects.removeItem("ingred_raw_ebony_01", 50),
                    menuHelper.effects.giveItem("ebony_towershield", 1)
                })
            }
        },
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("crafting ebonite page 2") } },
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

