Menus["menu reset"] = {
    text = {color.Orange .. "MENU DES RESETS\n",
        color.White .. "\nRéinitialiser votre rang, votre réputation ou vos quêtes dans ce menu.\n"
	},	
    buttons = {	
        { caption = "Reset personnage",	
            destinations = { menuHelper.destinations.setDefault("reset player") }
        },
        { caption = "Reset journal",
            destinations = {
                menuHelper.destinations.setDefault("commande reset quest")
            }
        },
        { caption = "Reset guildes",
            destinations = {
                menuHelper.destinations.setDefault("commande reset ranks")
            }
        },
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu player")
            }
        },		
        { caption = "Quitter", destinations = nil }
    }
}

Menus["commande mage"] = {
    text = color.Orange .. "GUILDE DES MAGES\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "INTEGRATION\n" ..
            color.White .. "\nReinitialise votre integration au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\nPermet de s'exclure de la guilde\n"..			
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
        { caption = "INTEGRATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetintegration mages"})
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
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu reset")
            }
        },		
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande guerriers"] = {
    text = color.Orange .. "GUILDE DES GUERRIERS\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "INTEGRATION\n" ..
            color.White .. "\nReinitialise votre integration au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\nPermet de s'exclure de la guilde\n"..			
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
        { caption = "INTEGRATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetintegration fight"})
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
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu reset")
            }
        },		
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande voleurs"] = {
    text = color.Orange .. "GUILDE DES VOLEURS\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "INTEGRATION\n" ..
            color.White .. "\nReinitialise votre integration au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\nPermet de s'exclure de la guilde\n"..			
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
        { caption = "INTEGRATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetintegration thieves"})
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
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu reset")
            }
        },		
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande morag"] = {
    text = color.Orange .. "MORAG TONG\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "INTEGRATION\n" ..
            color.White .. "\nReinitialise votre integration au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\nPermet de s'exclure de la guilde\n"..					
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
        { caption = "INTEGRATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetintegration morag"})
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
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu reset")
            }
        },		
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande legion"] = {
    text = color.Orange .. "LEGION IMPERIALE\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "INTEGRATION\n" ..
            color.White .. "\nReinitialise votre integration au sein de la guilde pour 1k\n"..	
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\nPermet de s'exclure de la guilde\n"..					
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
        { caption = "INTEGRATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetintegration legion"})
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
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu reset")
            }
        },		
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande culte"] = {
    text = color.Orange .. "CULTE IMPERIALE\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "INTEGRATION\n" ..
            color.White .. "\nReinitialise votre integration au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\nPermet de s'exclure de la guilde\n"..					
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
        { caption = "INTEGRATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetintegration cult"})
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
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu reset")
            }
        },		
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande blade"] = {
    text = color.Orange .. "ORDRE DES LAMES\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "INTEGRATION\n" ..
            color.White .. "\nReinitialise votre integration au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\nPermet de s'exclure de la guilde\n"..					
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
        { caption = "INTEGRATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetintegration blades"})
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
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu reset")
            }
        },		
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande temple"] = {
    text = color.Orange .. "TEMPLE\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "INTEGRATION\n" ..
            color.White .. "\nReinitialise votre integration au sein de la guilde pour 1k\n"..	
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\nPermet de s'exclure de la guilde\n"..				
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
        { caption = "INTEGRATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetintegration temple"})
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
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu reset")
            }
        },		
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande hlaalu"] = {
    text = color.Orange .. "MAISONS HLAALU\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "INTEGRATION\n" ..
            color.White .. "\nReinitialise votre integration au sein de la guilde pour 1k\n"..	
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\nPermet de s'exclure de la guilde\n"..				
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
        { caption = "INTEGRATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetintegration hlaalu"})
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
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu reset")
            }
        },		
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande telvanni"] = {
    text = color.Orange .. "MAISONS TELVANNI\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "INTEGRATION\n" ..
            color.White .. "\nReinitialise votre integration au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\nPermet de s'exclure de la guilde\n"..				
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
        { caption = "INTEGRATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetINTEGRATION telvanni"})
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
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu reset")
            }
        },		
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande redoran"] = {
    text = color.Orange .. "MAISONS REDORAN\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "INTEGRATION\n" ..
            color.White .. "\nReinitialise votre integration au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\nPermet de s'exclure de la guilde\n"..				
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
        { caption = "INTEGRATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetintegration redoran"})
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
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu reset")
            }
        },		
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande orientale"] = {
    text = color.Orange .. "EMPIRE ORIENTALE\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "INTEGRATION\n" ..
            color.White .. "\nReinitialise votre integration au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\nPermet de s'exclure de la guilde\n"..				
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
        { caption = "INTEGRATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetintegration oriental"})
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
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu reset")
            }
        },		
        { caption = "Quitter", destinations = nil }		
	}		
}

Menus["commande blood"] = {
    text = color.Orange .. "BLOODFANG TONG\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "INTEGRATION\n" ..
            color.White .. "\nReinitialise votre integration au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\nPermet de s'exclure de la guilde\n"..				
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
        { caption = "INTEGRATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetintegration blood"})
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
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu reset")
            }
        },		
        { caption = "Quitter", destinations = nil }	
	}		
}

Menus["commande sixth"] = {
    text = color.Orange .. "SIXIEME MAISONS\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "INTEGRATION\n" ..
            color.White .. "\nReinitialise votre integration au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\nPermet de s'exclure de la guilde\n"..				
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
        { caption = "INTEGRATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetintegration sixth"})
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
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu reset")
            }
        },		
        { caption = "Quitter", destinations = nil }		
	}
}

Menus["commande ashlanders"] = {
    text = color.Orange .. "DES CENDRAIS\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReinitialise votre rang au sein de la guilde\n"..
        color.Yellow .. "INTEGRATION\n" ..
            color.White .. "\nReinitialise votre integration au sein de la guilde pour 1k\n"..
        color.Yellow .. "EXCLUSION\n" ..
            color.White .. "\nPermet de s'exclure de la guilde\n"..				
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReinitialise votre reputation au sein de la guilde\n",			
    buttons = {				
        { caption = "RANGS",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetranks ashlanders"})
				})
			}
        },
        { caption = "INTEGRATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetintegration ashlanders"})
				})
			}
        },
        { caption = "EXCLUSION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetexclusion ashlanders"})
				})
			}
        },			
        { caption = "REPUTATION",
			destinations = {menuHelper.destinations.setDefault("commande reset ranks",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetreputation ashlanders"})
				})
			}
        },
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu reset")
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
        { caption = "Des Cendrais",
            destinations = {
                menuHelper.destinations.setDefault("commande ashlanders")
            }
        },		
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu reset")
            }
        },		
        { caption = "Quitter", destinations = nil }
    }
}

Menus["commande reset quest"] = {
    text = color.Orange .. "COMMANDE DE RESET QUETES\n" ..
        color.Yellow .. "\nSelectionne une guilde\n" ..
            color.White .. "\npermet de réinitialiser vos quetes\n",
    buttons = {				
        { caption = "Guilde des Mages",
			destinations = {menuHelper.destinations.setDefault("commande reset quest",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest mage"})
				})
			}
        },
        { caption = "Guilde des Guerriers",
			destinations = {menuHelper.destinations.setDefault("commande reset quest",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest fight"})
				})
			}
        },
        { caption = "Guilde des Voleurs",
			destinations = {menuHelper.destinations.setDefault("commande reset quest",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest thieves"})
				})
			}
        },
        { caption = "Morag Tong",
			destinations = {menuHelper.destinations.setDefault("commande reset quest",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest morag"})
				})
			}
        },
        { caption = "Legion Imperiale",
			destinations = {menuHelper.destinations.setDefault("commande reset quest",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest legion"})
				})
			}
        },
        { caption = "Culte Imperiale",
			destinations = {menuHelper.destinations.setDefault("commande reset quest",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest cult"})
				})
			}
        },
        { caption = "Temple",
			destinations = {menuHelper.destinations.setDefault("commande reset quest",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest temple"})
				})
			}
        },
        { caption = "L'ordre des lames",
			destinations = {menuHelper.destinations.setDefault("commande reset quest",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest blades"})
				})
			}
        },
        { caption = "Maison Hlaalu",
			destinations = {menuHelper.destinations.setDefault("commande reset quest",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest hlaalu"})
				})
			}
        },
        { caption = "Maison Telvanni",
			destinations = {menuHelper.destinations.setDefault("commande reset quest",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest telvanni"})
				})
			}
        },
        { caption = "Maison Redoran",
			destinations = {menuHelper.destinations.setDefault("commande reset quest",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest redoran"})
				})
			}
        },
        { caption = "Quete Dragon",
			destinations = {menuHelper.destinations.setDefault("commande reset quest",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest dragon"})
				})
			}
        },		
        { caption = "Page 2",
            destinations = {
                menuHelper.destinations.setDefault("menu reset quest page 2")
            }
        },
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu reset")
            }
        },		
        { caption = "Quitter", destinations = nil }
    }
}

Menus["menu reset quest page 2"] = {
    text = color.Orange .. "RESET QUETES PAGE 2\n" ..
        color.Yellow .. "\nSelectionne une guilde\n" ..
            color.White .. "\npermet de réinitialiser vos quetes\n",
    buttons = {				
        { caption = "Empire Orientale",
			destinations = {menuHelper.destinations.setDefault("menu reset quest page 2",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest oriental"})
				})
			}
        },
        { caption = "Bloodfang Tong",
			destinations = {menuHelper.destinations.setDefault("menu reset quest page 2",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest bloodfang"})
				})
			}
        },
        { caption = "Sixieme Maisons",
			destinations = {menuHelper.destinations.setDefault("menu reset quest page 2",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest sixth"})
				})
			}
        },
        { caption = "BloodMoon",
			destinations = {menuHelper.destinations.setDefault("menu reset quest page 2",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest bloodmoon"})
				})
			}
        },	
        { caption = "Lokken",
			destinations = {menuHelper.destinations.setDefault("menu reset quest page 2",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest loken"})
				})
			}
        },	
        { caption = "Vampire",
			destinations = {menuHelper.destinations.setDefault("menu reset quest page 2",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest vamp"})
				})
			}
        },
        { caption = "VampireCure",
			destinations = {menuHelper.destinations.setDefault("menu reset quest page 2",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest vampcure"})
				})
			}
        },		
        { caption = "Annexe",
			destinations = {menuHelper.destinations.setDefault("menu reset quest page 2",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest annex"})
				})
			}
        },
        { caption = "Vivec",
			destinations = {menuHelper.destinations.setDefault("menu reset quest page 2",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest vivec"})
				})
			}
        },
        { caption = "Daedras",
			destinations = {menuHelper.destinations.setDefault("menu reset quest page 2",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest daedras"})
				})
			}
        },
        { caption = "Nerevarine",
			destinations = {menuHelper.destinations.setDefault("menu reset quest page 2",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest nerevarine"})
				})
			}
        },	
        { caption = "Tribunal",
			destinations = {menuHelper.destinations.setDefault("menu reset quest page 2",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest tribunal"})
				})
			}
        },
        { caption = "Tout",
			destinations = {menuHelper.destinations.setDefault("menu reset quest page 2",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest all"})
				})
			}
        },	
        { caption = "Page 1",
            destinations = {
                menuHelper.destinations.setDefault("commande reset quest")
            }
        },	
        { caption = "Retour",
            destinations = {
                menuHelper.destinations.setDefault("menu reset")
            }
        },		
        { caption = "Quitter", destinations = nil }
    }
}