--add menuquest.lua in mp-stuff/scripts/menu/ 
--for open the menu enter /menuquest in to the tchat

Menus["commande reset quest"] = {
    text = color.Orange .. "COMMANDE DE RESET QUETES\n" ..
        color.Yellow .. "\nSelectionne une guilde\n" ..
            color.White .. "\npermet de réinitialiser vos quetes\n",
    buttons = {				
        { caption = "Mages Guild",
			destinations = {menuHelper.destinations.setDefault("commande reset quest",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest mage"})
				})
			}
        },
        { caption = "Fighters Guild",
			destinations = {menuHelper.destinations.setDefault("commande reset quest",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest fight"})
				})
			}
        },
        { caption = "Thieves Guild",
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
        { caption = "Imperial legion",
			destinations = {menuHelper.destinations.setDefault("commande reset quest",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest legion"})
				})
			}
        },
        { caption = "Imperial Cult",
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
        { caption = "House Hlaalu",
			destinations = {menuHelper.destinations.setDefault("commande reset quest",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest hlaalu"})
				})
			}
        },
        { caption = "House Telvanni",
			destinations = {menuHelper.destinations.setDefault("commande reset quest",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest telvanni"})
				})
			}
        },
        { caption = "House Redoran",
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
        { caption = "East Empire",
			destinations = {menuHelper.destinations.setDefault("menu reset quest page 2",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest oriental"})
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
        { caption = "Vampire",
			destinations = {menuHelper.destinations.setDefault("menu reset quest page 2",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest vamp"})
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
        { caption = "Blades",
			destinations = {menuHelper.destinations.setDefault("commande reset quest",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resetquest blades"})
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
        { caption = "All Quests",
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
