--add menuguilds.lua in mp-stuff/scripts/menu/ 
--for open the menu enter /menuguilds in to the tchat

Menus["commande mage"] = {
    text = color.Orange .. "Mages Guild\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReset your rank within the guild\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReset your expulsion within the guild for 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReset your reputation in the guild\n",			
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
        { caption = "Exit", destinations = nil }	
	}		
}

Menus["commande guerriers"] = {
    text = color.Orange .. "Fighters Guild\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReset your rank within the guild\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReset your expulsion within the guild for 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReset your reputation in the guild\n",			
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
        { caption = "Exit", destinations = nil }	
	}		
}

Menus["commande voleurs"] = {
    text = color.Orange .. "Thieves Guild\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReset your rank within the guild\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReset your expulsion within the guild for 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReset your reputation in the guild\n",			
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
        { caption = "Exit", destinations = nil }	
	}		
}

Menus["commande morag"] = {
    text = color.Orange .. "Morag Tong\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReset your rank within the guild\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReset your expulsion within the guild for 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReset your reputation in the guild\n",			
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
        { caption = "Exit", destinations = nil }	
	}		
}

Menus["commande legion"] = {
    text = color.Orange .. "Imperial Legion\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReset your rank within the guild\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReset your expulsion within the guild for 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReset your reputation in the guild\n",			
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
        { caption = "Exit", destinations = nil }	
	}		
}

Menus["commande culte"] = {
    text = color.Orange .. "Imperial Cult\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReset your rank within the guild\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReset your expulsion within the guild for 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReset your reputation in the guild\n",			
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
        { caption = "Exit", destinations = nil }	
	}		
}

Menus["commande blade"] = {
    text = color.Orange .. "The Blades\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReset your rank within the guild\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReset your expulsion within the guild for 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReset your reputation in the guild\n",			
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
        { caption = "Exit", destinations = nil }	
	}		
}

Menus["commande temple"] = {
    text = color.Orange .. "Temple\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReset your rank within the guild\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReset your expulsion within the guild for 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReset your reputation in the guild\n",			
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
        { caption = "Exit", destinations = nil }	
	}		
}

Menus["commande hlaalu"] = {
    text = color.Orange .. "House Hlaalu\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReset your rank within the guild\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReset your expulsion within the guild for 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReset your reputation in the guild\n",			
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
        { caption = "Exit", destinations = nil }	
	}		
}

Menus["commande telvanni"] = {
    text = color.Orange .. "House Telvanni\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReset your rank within the guild\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReset your expulsion within the guild for 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReset your reputation in the guild\n",			
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
        { caption = "Exit", destinations = nil }	
	}		
}

Menus["commande redoran"] = {
    text = color.Orange .. "House Redoran\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReset your rank within the guild\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReset your expulsion within the guild for 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReset your reputation in the guild\n",			
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
        { caption = "Exit", destinations = nil }	
	}		
}

Menus["commande orientale"] = {
    text = color.Orange .. "East Empire\n" ..
        color.Yellow .. "\nRANGS\n" ..
            color.White .. "\nReset your rank within the guild\n"..
        color.Yellow .. "EXPULTION\n" ..
            color.White .. "\nReset your expulsion within the guild for 1k\n"..			
        color.Yellow .. "REPUTATION\n" ..
            color.White .. "\nReset your reputation in the guild\n",			
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
        { caption = "Exit", destinations = nil }		
	}		
}

Menus["commande reset ranks"] = {
    text = color.Orange .. "RESET RANGS\n" ..
        color.Yellow .. "\nSelect a guild\n" ..
            color.White .. "\nReset your data in a guild\n",
    buttons = {				
        { caption = "Guilde des Mages",
            destinations = {
                menuHelper.destinations.setDefault("commande mage")
            }
        },
        { caption = "Fighters Guild",
            destinations = {
                menuHelper.destinations.setDefault("commande guerriers")
            }
        },
        { caption = "Thieves Guild",
            destinations = {
                menuHelper.destinations.setDefault("commande voleurs")
            }
        },
        { caption = "Morag Tong",
            destinations = {
                menuHelper.destinations.setDefault("commande morag")
            }
        },
        { caption = "Imperial Legion",
            destinations = {
                menuHelper.destinations.setDefault("commande legion")
            }
        },
        { caption = "Imperial Cult",
            destinations = {
                menuHelper.destinations.setDefault("commande culte")
            }
        },
        { caption = "Temple",
            destinations = {
                menuHelper.destinations.setDefault("commande temple")
            }
        },
        { caption = "The Blades",
            destinations = {
                menuHelper.destinations.setDefault("commande blades")
            }
        },
        { caption = "House Hlaalu",
            destinations = {
                menuHelper.destinations.setDefault("commande hlaalu")
            }
        },
        { caption = "House Telvanni",
            destinations = {
                menuHelper.destinations.setDefault("commande telvanni")
            }
        },	
        { caption = "House Redoran",
            destinations = {
                menuHelper.destinations.setDefault("commande redoran")
            }
        },
        { caption = "Empire Orientale",
            destinations = {
                menuHelper.destinations.setDefault("commande orientale")
            }
        },	
        { caption = "Exit", destinations = nil }
    }
}
