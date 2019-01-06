
--add menuguilds.lua in mp-stuff/scripts/menu/ 

--for open the menu enter /menuguilds in to the tchat



Menus["commande mage"] = {

    text = color.Orange .. "GUILD OF MAGES\n" ..

        color.Yellow .. "\nRANKS\n" ..

            color.White .. "\nReset your rank within the guild.\n"..

        color.Yellow .. "EVICTION\n" ..

            color.White .. "\nReset your eviction within the guild for 1k.\n"..

        color.Yellow .. "BANNING\n" ..

            color.White .. "\nLeave the guild.\n"..			

        color.Yellow .. "REPUTE\n" ..

            color.White .. "\nReset your repute within the guild.\n",			

    buttons = {				

        { caption = "RANKS",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetranks mages"})

				})

			}

        },

        { caption = "EVICTION",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexpulsion mages"})

				})

			}

        },

        { caption = "BANNING",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexclusion mages"})

				})

			}

        },		

        { caption = "REPUTE",

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

    text = color.Orange .. "GUILD OF WARRIORS\n" ..

        color.Yellow .. "\nRANKS\n" ..

            color.White .. "\nReset your rank within the guild.\n"..

        color.Yellow .. "EVICTION\n" ..

            color.White .. "\nReset your eviction within the guild for 1k.\n"..

        color.Yellow .. "BANNING\n" ..

            color.White .. "\nLeave the guild.\n"..			

        color.Yellow .. "REPUTE\n" ..

            color.White .. "\nReset your repute within the guild.\n",			

    buttons = {				

        { caption = "RANKS",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetranks fight"})

				})

			}

        },

        { caption = "EVICTION",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexpulsion fight"})

				})

			}

        },

        { caption = "BANNING",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexclusion fight"})

				})

			}

        },			

        { caption = "REPUTE",

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

    text = color.Orange .. "GUILD OF THIEVES\n" ..

        color.Yellow .. "\nRANKS\n" ..

            color.White .. "\nReset your rank within the guild.\n"..

        color.Yellow .. "EVICTION\n" ..

            color.White .. "\nReset your eviction within the guild for 1k.\n"..

        color.Yellow .. "BANNING\n" ..

            color.White .. "\nLeave the guild.\n"..			

        color.Yellow .. "REPUTE\n" ..

            color.White .. "\nReset your repute within the guild.\n",				

    buttons = {				

        { caption = "RANKS",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetranks thieves"})

				})

			}

        },

        { caption = "EVICTION",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexpulsion thieves"})

				})

			}

        },

        { caption = "BANNING",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexclusion thieves"})

				})

			}

        },			

        { caption = "REPUTE",

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

        color.Yellow .. "\nRANKS\n" ..

            color.White .. "\nReset your rank within the guild.\n"..

        color.Yellow .. "EVICTION\n" ..

            color.White .. "\nReset your eviction within the guild for 1k.\n"..

        color.Yellow .. "BANNING\n" ..

            color.White .. "\nLeave the guild.\n"..			

        color.Yellow .. "REPUTE\n" ..

            color.White .. "\nReset your repute within the guild.\n",			

    buttons = {				

        { caption = "RANKS",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetranks morag"})

				})

			}

        },

        { caption = "EVICTION",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexpulsion morag"})

				})

			}

        },

        { caption = "BANNING",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexclusion morag"})

				})

			}

        },			

        { caption = "REPUTE",

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

    text = color.Orange .. "IMPERIAL LEGION\n" ..

        color.Yellow .. "\nRANKS\n" ..

            color.White .. "\nReset your rank within the guild.\n"..

        color.Yellow .. "EVICTION\n" ..

            color.White .. "\nReset your eviction within the guild for 1k.\n"..

        color.Yellow .. "BANNING\n" ..

            color.White .. "\nLeave the guild.\n"..			

        color.Yellow .. "REPUTE\n" ..

            color.White .. "\nReset your repute within the guild.\n",		

    buttons = {				

        { caption = "RANKS",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetranks legion"})

				})

			}

        },

        { caption = "EVICTION",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexpulsion legion"})

				})

			}

        },

        { caption = "BANNING",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexclusion legion"})

				})

			}

        },			

        { caption = "REPUTE",

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

    text = color.Orange .. "IMPERIAL CULT\n" ..

        color.Yellow .. "\nRANKS\n" ..

            color.White .. "\nReset your rank within the guild.\n"..

        color.Yellow .. "EVICTION\n" ..

            color.White .. "\nReset your eviction within the guild for 1k.\n"..

        color.Yellow .. "BANNING\n" ..

            color.White .. "\nLeave the guild.\n"..			

        color.Yellow .. "REPUTE\n" ..

            color.White .. "\nReset your repute within the guild.\n",			

    buttons = {				

        { caption = "RANKS",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetranks cult"})

				})

			}

        },

        { caption = "EVICTION",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexpulsion cult"})

				})

			}

        },

        { caption = "BANNING",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexclusion cult"})

				})

			}

        },			

        { caption = "REPUTE",

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

    text = color.Orange .. "BLADES\n" ..

        color.Yellow .. "\nRANKS\n" ..

            color.White .. "\nReset your rank within the guild.\n"..

        color.Yellow .. "EVICTION\n" ..

            color.White .. "\nReset your eviction within the guild for 1k.\n"..

        color.Yellow .. "BANNING\n" ..

            color.White .. "\nLeave the guild.\n"..			

        color.Yellow .. "REPUTE\n" ..

            color.White .. "\nReset your repute within the guild.\n",			

    buttons = {				

        { caption = "RANKS",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetranks blades"})

				})

			}

        },

        { caption = "EVICTION",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexpulsion blades"})

				})

			}

        },

        { caption = "BANNING",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexclusion blades"})

				})

			}

        },			

        { caption = "REPUTE",

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

        color.Yellow .. "\nRANKS\n" ..

            color.White .. "\nReset your rank within the guild.\n"..

        color.Yellow .. "EVICTION\n" ..

            color.White .. "\nReset your eviction within the guild for 1k.\n"..

        color.Yellow .. "BANNING\n" ..

            color.White .. "\nLeave the guild.\n"..			

        color.Yellow .. "REPUTE\n" ..

            color.White .. "\nReset your repute within the guild.\n",			

    buttons = {				

        { caption = "RANKS",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetranks temple"})

				})

			}

        },

        { caption = "EVICTION",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexpulsion temple"})

				})

			}

        },

        { caption = "BANNING",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexclusion temple"})

				})

			}

        },			

        { caption = "REPUTE",

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

    text = color.Orange .. "HLAALU\n" ..

        color.Yellow .. "\nRANKS\n" ..

            color.White .. "\nReset your rank within the guild.\n"..

        color.Yellow .. "EVICTION\n" ..

            color.White .. "\nReset your eviction within the guild for 1k.\n"..

        color.Yellow .. "BANNING\n" ..

            color.White .. "\nLeave the guild.\n"..			

        color.Yellow .. "REPUTE\n" ..

            color.White .. "\nReset your repute within the guild.\n",		

    buttons = {				

        { caption = "RANKS",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetranks hlaalu"})

				})

			}

        },

        { caption = "EVICTION",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetEXPULSION hlaalu"})

				})

			}

        },	

        { caption = "BANNING",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexclusion hlaalu"})

				})

			}

        },			

        { caption = "REPUTE",

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

    text = color.Orange .. "TELVANNI\n" ..

        color.Yellow .. "\nRANKS\n" ..

            color.White .. "\nReset your rank within the guild.\n"..

        color.Yellow .. "EVICTION\n" ..

            color.White .. "\nReset your eviction within the guild for 1k.\n"..

        color.Yellow .. "BANNING\n" ..

            color.White .. "\nLeave the guild.\n"..			

        color.Yellow .. "REPUTE\n" ..

            color.White .. "\nReset your repute within the guild.\n",				

    buttons = {				

        { caption = "RANKS",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetranks telvanni"})

				})

			}

        },

        { caption = "EVICTION",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexpulsion telvanni"})

				})

			}

        },

        { caption = "BANNING",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexclusion telvanni"})

				})

			}

        },			

        { caption = "REPUTE",

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

    text = color.Orange .. "REDORAN\n" ..

        color.Yellow .. "\nRANKS\n" ..

            color.White .. "\nReset your rank within the guild.\n"..

        color.Yellow .. "EVICTION\n" ..

            color.White .. "\nReset your eviction within the guild for 1k.\n"..

        color.Yellow .. "BANNING\n" ..

            color.White .. "\nLeave the guild.\n"..			

        color.Yellow .. "REPUTE\n" ..

            color.White .. "\nReset your repute within the guild.\n",				

    buttons = {				

        { caption = "RANKS",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetranks redoran"})

				})

			}

        },

        { caption = "EVICTION",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexpulsion redoran"})

				})

			}

        },

        { caption = "BANNING",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexclusion redoran"})

				})

			}

        },			

        { caption = "REPUTE",

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

    text = color.Orange .. "EASTERN EMPIRE\n" ..

        color.Yellow .. "\nRANKS\n" ..

            color.White .. "\nReset your rank within the guild.\n"..

        color.Yellow .. "EVICTION\n" ..

            color.White .. "\nReset your eviction within the guild for 1k.\n"..

        color.Yellow .. "BANNING\n" ..

            color.White .. "\nLeave the guild.\n"..			

        color.Yellow .. "REPUTE\n" ..

            color.White .. "\nReset your repute within the guild.\n",			

    buttons = {				

        { caption = "RANKS",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetranks oriental"})

				})

			}

        },

        { caption = "EVICTION",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexpulsion oriental"})

				})

			}

        },

        { caption = "BANNING",

			destinations = {menuHelper.destinations.setDefault("commande reset ranks",

			{ 

			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",

					{menuHelper.variables.currentPid(), "/resetexclusion oriental"})

				})

			}

        },			

        { caption = "REPUTE",

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

Menus["commande reset ranks"] = {

    text = color.Orange .. "COMMANDE DE RESET RANGS\n" ..

        color.Yellow .. "\nSelectionne une guilde\n" ..

            color.White .. "\npermet de réinitialiser vos données de guildes\n",

    buttons = {				

        { caption = "Guild Of Mages",

            destinations = {

                menuHelper.destinations.setDefault("commande mage")

            }

        },

        { caption = "Guild Of Warriors",

            destinations = {

                menuHelper.destinations.setDefault("commande guerriers")

            }

        },

        { caption = "Guild Of Thieves",

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

        { caption = "Blades",

            destinations = {

                menuHelper.destinations.setDefault("commande blade")

            }

        },

        { caption = "Hlaalu",

            destinations = {

                menuHelper.destinations.setDefault("commande hlaalu")

            }

        },

        { caption = "Telvanni",

            destinations = {

                menuHelper.destinations.setDefault("commande telvanni")

            }

        },	

        { caption = "Redoran",

            destinations = {

                menuHelper.destinations.setDefault("commande redoran")

            }

        },

        { caption = "Eastern Empire",

            destinations = {

                menuHelper.destinations.setDefault("commande orientale")

            }

        },	

        { caption = "Quitter", destinations = nil }

    }

}
