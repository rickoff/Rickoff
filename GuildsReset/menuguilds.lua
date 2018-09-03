--add menuguilds.lua in mp-stuff/scripts/menu/ 
--for open the menu enter /menuguilds in to the tchat

Menus["commande mage"] = {
    text = color.Orange .. "GUILDE DES MAGES\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "EXPULSION\n" ..
            color.White .. "\nReinitialise votre expulsion au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\Permet de s'exclure de la guilde\n"..			
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
        { caption = "EXPULSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpulsion mages"})
				})
			}
        },
        { caption = "EXCLUSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexclusion mages"})
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
        color.Yellow .. "EXPULSION\n" ..
            color.White .. "\nReinitialise votre expulsion au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\Permet de s'exclure de la guilde\n"..			
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
        { caption = "EXPULSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpulsion fight"})
				})
			}
        },
        { caption = "EXCLUSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexclusion fight"})
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
        color.Yellow .. "EXPULSION\n" ..
            color.White .. "\nReinitialise votre expulsion au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\Permet de s'exclure de la guilde\n"..			
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
        { caption = "EXPULSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpulsion thieves"})
				})
			}
        },
        { caption = "EXCLUSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexclusion thieves"})
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
        color.Yellow .. "EXPULSION\n" ..
            color.White .. "\nReinitialise votre expulsion au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\Permet de s'exclure de la guilde\n"..					
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
        { caption = "EXPULSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpulsion morag"})
				})
			}
        },
        { caption = "EXCLUSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexclusion morag"})
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
        color.Yellow .. "EXPULSION\n" ..
            color.White .. "\nReinitialise votre EXPULSION au sein de la guilde pour 1k\n"..	
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\Permet de s'exclure de la guilde\n"..					
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
        { caption = "EXPULSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpulsion legion"})
				})
			}
        },
        { caption = "EXCLUSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexclusion legion"})
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
        color.Yellow .. "EXPULSION\n" ..
            color.White .. "\nReinitialise votre expulsion au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\Permet de s'exclure de la guilde\n"..					
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
        { caption = "EXPULSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpulsion cult"})
				})
			}
        },
        { caption = "EXCLUSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexclusion cult"})
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
        color.Yellow .. "EXPULSION\n" ..
            color.White .. "\nReinitialise votre expulsion au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\Permet de s'exclure de la guilde\n"..					
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
        { caption = "EXPULSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpulsion blades"})
				})
			}
        },
        { caption = "EXCLUSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexclusion blades"})
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
        color.Yellow .. "EXPULSION\n" ..
            color.White .. "\nReinitialise votre expulsion au sein de la guilde pour 1k\n"..	
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\Permet de s'exclure de la guilde\n"..				
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
        { caption = "EXPULSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpulsion temple"})
				})
			}
        },
        { caption = "EXCLUSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexclusion temple"})
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
        color.Yellow .. "EXPULSION\n" ..
            color.White .. "\nReinitialise votre expulsion au sein de la guilde pour 1k\n"..	
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\Permet de s'exclure de la guilde\n"..				
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
        { caption = "EXPULSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetEXPULSION hlaalu"})
				})
			}
        },	
        { caption = "EXCLUSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexclusion hlaalu"})
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
        color.Yellow .. "EXPULSION\n" ..
            color.White .. "\nReinitialise votre expulsion au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\Permet de s'exclure de la guilde\n"..				
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
        { caption = "EXPULSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpulsion telvanni"})
				})
			}
        },
        { caption = "EXCLUSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexclusion telvanni"})
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
        color.Yellow .. "EXPULSION\n" ..
            color.White .. "\nReinitialise votre expulsion au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\Permet de s'exclure de la guilde\n"..				
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
        { caption = "EXPULSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpulsion redoran"})
				})
			}
        },
        { caption = "EXCLUSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexclusion redoran"})
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
        color.Yellow .. "EXPULSION\n" ..
            color.White .. "\nReinitialise votre expulsion au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\Permet de s'exclure de la guilde\n"..				
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReinitialise votre reputation au sein de la guilde\n",			
    buttons = {				
        { caption = "RANGS",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetranks oriental"})
				})
			}
        },
        { caption = "EXPULSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpulsion oriental"})
				})
			}
        },
        { caption = "EXCLUSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexclusion oriental"})
				})
			}
        },			
        { caption = "REPUTATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetreputation oriental"})
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
        color.Yellow .. "EXPULSION\n" ..
            color.White .. "\nReinitialise votre expulsion au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\Permet de s'exclure de la guilde\n"..				
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReinitialise votre reputation au sein de la guilde\n",			
    buttons = {				
        { caption = "RANGS",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetranks blood"})
				})
			}
        },
        { caption = "EXPULSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpulsion blood"})
				})
			}
        },
        { caption = "EXCLUSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexclusion blood"})
				})
			}
        },			
        { caption = "REPUTATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetreputation blood"})
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
        color.Yellow .. "EXPULSION\n" ..
            color.White .. "\nReinitialise votre expulsion au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\Permet de s'exclure de la guilde\n"..				
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
        { caption = "EXPULSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexpulsion sixth"})
				})
			}
        },
        { caption = "EXCLUSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexclusion sixth"})
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
        color.Yellow .. "\nSelectionne une guilde\n" ..
            color.White .. "\npermet de réinitialiser vos données de guildes\n",
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
                menuHelper.destinations.setDefault("commande blade")
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
