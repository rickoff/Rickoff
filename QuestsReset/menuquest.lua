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
        { caption = "Page 2",
            destinations = {
                menuHelper.destinations.setDefault("menu reset quest page 2")
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
					{menuHelper.variables.currentPid(), "/resetlog"})
				})
			}
        },	
        { caption = "Page 1",
            destinations = {
                menuHelper.destinations.setDefault("commande reset quest")
            }
        },			
        { caption = "Quitter", destinations = nil }
    }
}
