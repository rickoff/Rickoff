Menus["commande mage"] = {
    text = color.Orange .. "GUILDE DES MAGES\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReinitialise votre expultion au sein de la guilde pour 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReinitialise votre reputation au sein de la guilde\n",			
    buttons = {				
        { caption = "RANGS",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetranks mages"})
				})
			}
        },
        { caption = "EXPULTION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpultion mages"})
				})
			}
        },
        { caption = "REPUTATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetreputation mages"})
				})
			}
        },
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande guerriers"] = {
    text = color.Orange .. "GUILDE DES GUERRIERS\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReinitialise votre expultion au sein de la guilde pour 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReinitialise votre reputation au sein de la guilde\n",			
    buttons = {				
        { caption = "RANGS",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetranks fight"})
				})
			}
        },
        { caption = "EXPULTION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpultion fight"})
				})
			}
        },
        { caption = "REPUTATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetreputation fight"})
				})
			}
        },
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande voleurs"] = {
    text = color.Orange .. "GUILDE DES VOLEURS\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReinitialise votre expultion au sein de la guilde pour 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReinitialise votre reputation au sein de la guilde\n",			
    buttons = {				
        { caption = "RANGS",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetranks thieves"})
				})
			}
        },
        { caption = "EXPULTION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpultion thieves"})
				})
			}
        },
        { caption = "REPUTATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetreputation thieves"})
				})
			}
        },
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande morag"] = {
    text = color.Orange .. "MORAG TONG\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReinitialise votre expultion au sein de la guilde pour 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReinitialise votre reputation au sein de la guilde\n",			
    buttons = {				
        { caption = "RANGS",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetranks morag"})
				})
			}
        },
        { caption = "EXPULTION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpultion morag"})
				})
			}
        },
        { caption = "REPUTATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetreputation morag"})
				})
			}
        },
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande legion"] = {
    text = color.Orange .. "LEGION IMPERIALE\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReinitialise votre expultion au sein de la guilde pour 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReinitialise votre reputation au sein de la guilde\n",			
    buttons = {				
        { caption = "RANGS",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetranks legion"})
				})
			}
        },
        { caption = "EXPULTION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpultion legion"})
				})
			}
        },
        { caption = "REPUTATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetreputation legion"})
				})
			}
        },
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande culte"] = {
    text = color.Orange .. "CULTE IMPERIALE\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReinitialise votre expultion au sein de la guilde pour 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReinitialise votre reputation au sein de la guilde\n",			
    buttons = {				
        { caption = "RANGS",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetranks cult"})
				})
			}
        },
        { caption = "EXPULTION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpultion cult"})
				})
			}
        },
        { caption = "REPUTATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetreputation cult"})
				})
			}
        },
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande blade"] = {
    text = color.Orange .. "ORDRE DES LAMES\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReinitialise votre expultion au sein de la guilde pour 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReinitialise votre reputation au sein de la guilde\n",			
    buttons = {				
        { caption = "RANGS",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetranks blades"})
				})
			}
        },
        { caption = "EXPULTION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpultion blades"})
				})
			}
        },
        { caption = "REPUTATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetreputation blades"})
				})
			}
        },
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande temple"] = {
    text = color.Orange .. "TEMPLE\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReinitialise votre expultion au sein de la guilde pour 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReinitialise votre reputation au sein de la guilde\n",			
    buttons = {				
        { caption = "RANGS",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetranks temple"})
				})
			}
        },
        { caption = "EXPULTION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpultion temple"})
				})
			}
        },
        { caption = "REPUTATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetreputation temple"})
				})
			}
        },
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande hlaalu"] = {
    text = color.Orange .. "MAISONS HLAALU\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReinitialise votre expultion au sein de la guilde pour 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReinitialise votre reputation au sein de la guilde\n",			
    buttons = {				
        { caption = "RANGS",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetranks hlaalu"})
				})
			}
        },
        { caption = "EXPULTION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpultion hlaalu"})
				})
			}
        },
        { caption = "REPUTATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetreputation hlaalu"})
				})
			}
        },
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande telvanni"] = {
    text = color.Orange .. "MAISONS TELVANNI\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReinitialise votre expultion au sein de la guilde pour 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReinitialise votre reputation au sein de la guilde\n",			
    buttons = {				
        { caption = "RANGS",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetranks telvanni"})
				})
			}
        },
        { caption = "EXPULTION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpultion telvanni"})
				})
			}
        },
        { caption = "REPUTATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetreputation telvanni"})
				})
			}
        },
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande redoran"] = {
    text = color.Orange .. "MAISONS REDORAN\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReinitialise votre expultion au sein de la guilde pour 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReinitialise votre reputation au sein de la guilde\n",			
    buttons = {				
        { caption = "RANGS",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetranks redoran"})
				})
			}
        },
        { caption = "EXPULTION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpultion redoran"})
				})
			}
        },
        { caption = "REPUTATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetreputation redoran"})
				})
			}
        },
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande orientale"] = {
    text = color.Orange .. "EMPIRE ORIENTALE\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReinitialise votre expultion au sein de la guilde pour 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReinitialise votre reputation au sein de la guilde\n",			
    buttons = {				
        { caption = "RANGS",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetranks orientale"})
				})
			}
        },
        { caption = "EXPULTION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpultion orientale"})
				})
			}
        },
        { caption = "REPUTATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetreputation orientale"})
				})
			}
        },
        { caption = "Quitter", destinations = nil }		
	}		
}

Menus["commande blood"] = {
    text = color.Orange .. "BLOODFANG TONG\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReinitialise votre expultion au sein de la guilde pour 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReinitialise votre reputation au sein de la guilde\n",			
    buttons = {				
        { caption = "RANGS",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetranks orientale"})
				})
			}
        },
        { caption = "EXPULTION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpultion orientale"})
				})
			}
        },
        { caption = "REPUTATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetreputation orientale"})
				})
			}
        },
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande sixth"] = {
    text = color.Orange .. "SIXIEME MAISONS\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReinitialise votre expultion au sein de la guilde pour 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReinitialise votre reputation au sein de la guilde\n",			
    buttons = {				
        { caption = "RANGS",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetranks sixth"})
				})
			}
        },
        { caption = "EXPULTION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpultion sixth"})
				})
			}
        },
        { caption = "REPUTATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetreputation sixth"})
				})
			}
        },
        { caption = "Quitter", destinations = nil }		
	}
}

Menus["commande reset ranks"] = {
    text = color.Orange .. "COMMANDE DE RESET RANGS\n" ..
        color.Yellow .. "\n/Selectionne une faction\n" ..
            color.White .. "\npermet de réinitialiser votre rang au sein d'une guilde\n",
    buttons = {				
        { caption = "Guilde des Mages",
            destinations = {
                menuHelper.destinations.setDefault("commande mage")
            }
        },
        { caption = "Guilde des Guerriers",
            destinations = {
                menuHelper.destinations.setDefault("commande guerriers")
            }
        },
        { caption = "Guilde des Voleurs",
            destinations = {
                menuHelper.destinations.setDefault("commande voleurs")
            }
        },
        { caption = "Morag Tong",
            destinations = {
                menuHelper.destinations.setDefault("commande morag")
            }
        },
        { caption = "Legion Imperiale",
            destinations = {
                menuHelper.destinations.setDefault("commande legion")
            }
        },
        { caption = "Culte Imperiale",
            destinations = {
                menuHelper.destinations.setDefault("commande culte")
            }
        },
        { caption = "Temple",
            destinations = {
                menuHelper.destinations.setDefault("commande temple")
            }
        },
        { caption = "L'ordre des lames",
            destinations = {
                menuHelper.destinations.setDefault("commande blades")
            }
        },
        { caption = "Maison Hlaalu",
            destinations = {
                menuHelper.destinations.setDefault("commande hlaalu")
            }
        },
        { caption = "Maison Telvanni",
            destinations = {
                menuHelper.destinations.setDefault("commande telvanni")
            }
        },	
        { caption = "Maison Redoran",
            destinations = {
                menuHelper.destinations.setDefault("commande redoran")
            }
        },
        { caption = "Empire Orientale",
            destinations = {
                menuHelper.destinations.setDefault("commande orientale")
            }
        },	
        { caption = "Bloodfang Tong",
            destinations = {
                menuHelper.destinations.setDefault("commande blood")
            }
        },
        { caption = "Sixieme Maisons",
            destinations = {
                menuHelper.destinations.setDefault("commande sixth")
            }
        },	
        { caption = "Quitter", destinations = nil }
    }
}
