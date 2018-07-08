

Menus["forge d'ebonite"] = {
    text = "#red ..***** ARME EN EBONITE ***** \n\
		Bâton de mage - 10 > 1 \
		Dague en ébonite - 10 > 1 \
		Hache de guerre - 10 > 1 \
		Lance en ébonite - 10 > 1 \
		Epée courte - 10 > 1 \
		Cimeterre d'ébonite - 10 > 1 \
		Masse d'armes - 10 > 1 \
		Epée longue - 10 > 1 \
		Epée large - 10 > 1 \
		Flèche en ébonite - 1 > 1 \
		Dard en ébonite - 1 > 1 \
		Shuriken en ébonite - 1 > 1",
		
    buttons = {
        { caption = "Bâton de mage",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Bâton de mage",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                })
            }
        },
        { caption = "Dague en ébonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Dague en ébonite",
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
        { caption = "Lance en ébonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Lance en ébonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                })
            }
        },
        { caption = "Epée courte",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Epée courte",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                })
            }
        },
        { caption = "Cimeterre d'ébonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Cimeterre d'ébonite",
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
        { caption = "Epée longue",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Epée longue",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                })
            }
        },		
        { caption = "Epée large",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Epée large",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 10)
                })
            }
        },
        { caption = "Flèche en ébonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Flèche en ébonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },	
        { caption = "Dard en ébonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Dard en ébonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },	
        { caption = "Shuriken en ébonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Shuriken en ébonite",
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
		Bottes en ébonite - 50 > 1 \
		Bracelet en ébonite (G) - 50 > 1 \
		Bracelet en ébonite (D) - 50 > 1 \
		Cuirasse en ébonite - 100 > 1 \
		Jambières en ébonite - 75 > 1 \
		Casque en ébonite - 50 > 1 \
		Epaulière en ébonite (G) - 50 > 1 \
		Epaulière en ébonite (D) - 50 > 1 \
		Bouclier en ébonite - 50 > 1 \
		Ecu en ébonite - 50 > 1 ",
    buttons = {		
        { caption = "Bottes en ébonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Bottes en ébonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },	
        { caption = "Bracelet en ébonite (G)",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Bracelet en ébonite (G)",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },	
        { caption = "Bracelet en ébonite (D)",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Bracelet en ébonite (D)",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },	
        { caption = "Cuirasse en ébonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Cuirasse en ébonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },
        { caption = "Jambières en ébonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Jambières en ébonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },	
        { caption = "Casque en ébonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Casque en ébonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },	
        { caption = "Epaulière en ébonite (G)",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Epaulière en ébonite (G)",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },	
        { caption = "Epaulière en ébonite (D)",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Epaulière en ébonite (D)",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },
        { caption = "Bouclier en ébonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Bouclier en ébonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },
        { caption = "Ecu en ébonite",
            destinations = {
                menuHelper.destinations.setDefault("lack of materials"),
                menuHelper.destinations.setConditional("default crafting Ecu en ébonite",
                {
                    menuHelper.conditions.requireItem("ingred_raw_ebony_01", 1)
                })
            }
        },
        { caption = "Page 1",
            destinations = {
                menuHelper.destinations.setDefault("forge d'ebonite")
            }
        },		
        { caption = "Quitter", destinations = nil }
    }	
}

Menus["default crafting Bâton de mage"] = {
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge d'ebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Dague en ébonite"] = {
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge d'ebonite") } },
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge d'ebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Lance en ébonite"] = {
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge d'ebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Epée courte"] = {
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge d'ebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Cimeterre d'ébonite"] = {
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge d'ebonite") } },
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge d'ebonite") } },
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge d'ebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Epée large"] = {
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge d'ebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Flèche en ébonite"] = {
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge d'ebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Dard en ébonite"] = {
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge d'ebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Shuriken en ébonite"] = {
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
        { caption = "Retour", destinations = { menuHelper.destinations.setDefault("forge d'ebonite") } },
        { caption = "Quitter", destinations = nil }
    }
}

Menus["default crafting Bottes en ébonite"] = {
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

Menus["default crafting Bracelet en ébonite (G)"] = {
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

Menus["default crafting Bracelet en ébonite (D)"] = {
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

Menus["default crafting Cuirasse en ébonite"] = {
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

Menus["default crafting Jambières en ébonite"] = {
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

Menus["default crafting Casque en ébonite"] = {
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

Menus["default crafting Epaulière en ébonite (G)"] = {
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

Menus["default crafting Epaulière en ébonite (D)"] = {
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

Menus["default crafting Bouclier en ébonite"] = {
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

Menus["default crafting Ecu en ébonite"] = {
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
