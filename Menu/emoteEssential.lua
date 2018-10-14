--add file in folder script/menu
--add in config.lua find ``config.menuHelperFiles = { "emoteEssential" } ``
--go to commandHandler.lua and add to command text
	--elseif cmd[1] == "emotes" then
		--Players[pid].currentCustomMenu = "emote vocal"
		--menuHelper.displayMenu(pid, Players[pid].currentCustomMenu)

Menus["emote vocal"] = {
    text = color.Orange .. "MENU DES VOCALS\n" ..
        color.Yellow .. "\nle menu global vous permet d'éxécuter différentes emotes",
    buttons = {
        { caption = "Je vous ecoute",
			destinations = {menuHelper.destinations.setDefault("emote vocal",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/s hello 40"})
				})
			}
        },	
        { caption = "Que voulez vous ?",
			destinations = {menuHelper.destinations.setDefault("emote vocal",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/s hello 57"})
				})
			}
        },
        { caption = "Oui",
			destinations = {menuHelper.destinations.setDefault("emote vocal",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/s hello 61 "})
				})
			}
        },
        { caption = "Monsieur",
			destinations = {menuHelper.destinations.setDefault("emote vocal",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/s hello 42 "})
				})
			}
        },
        { caption = "Madame",
			destinations = {menuHelper.destinations.setDefault("emote vocal",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/s hello 63 "})
				})
			}
        },
        { caption = "Bienvenue",
			destinations = {menuHelper.destinations.setDefault("emote vocal",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/s hello 78"})
				})
			}
        },
        { caption = "Aidez ?",
			destinations = {menuHelper.destinations.setDefault("emote vocal",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/s hello 100"})
				})
			}
        },
        { caption = "Bonjour",
			destinations = {menuHelper.destinations.setDefault("emote vocal",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/s hello 117"})
				})
			}
        },
        { caption = "Sifflement",
			destinations = {menuHelper.destinations.setDefault("emote vocal",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/s idle 6"})
				})
			}
        },		
        { caption = "Fredonnement",
			destinations = {menuHelper.destinations.setDefault("emote vocal",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/s idle 7"})
				})
			}
        },
        { caption = "Hmm, Hmm !",
			destinations = {menuHelper.destinations.setDefault("emote vocal",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/s idle 8"})
				})
			}
        },
        { caption = "A l'aide !",
			destinations = {menuHelper.destinations.setDefault("emote vocal",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/s flee 2"})
				})
			}
        },
        { caption = "Garde !",
			destinations = {menuHelper.destinations.setDefault("emote vocal",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/s thief 2"})
				})
			}
        },		
        { caption = "Merci",
			destinations = {menuHelper.destinations.setDefault("emote vocal",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/s follower 3"})
				})
			}
        },
        { caption = "Emotes",
            destinations = {
                menuHelper.destinations.setDefault("emote")
            }
        },			
        { caption = "Quitter", destinations = nil }
    }
}

Menus["emote"] = {
    text = color.Orange .. "MENU DES EMOTES\n",
    buttons = {
        { caption = "Toucher le menton",
			destinations = {menuHelper.destinations.setDefault("emote",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/a touch_chin"})
				})
			}
        },	
        { caption = "Verifier son equipement",
			destinations = {menuHelper.destinations.setDefault("emote",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/a check_missing_item"})
				})
			}
        },		
        { caption = "Toucher son epaule",
			destinations = {menuHelper.destinations.setDefault("emote",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/a touch_shoulder"})
				})
			}
        },	
        { caption = "Impatiente",
			destinations = {menuHelper.destinations.setDefault("emote",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/a act_impatient"})
				})
			}
        },
        { caption = "Gratter la tete",
			destinations = {menuHelper.destinations.setDefault("emote",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/a scratch_neck"})
				})
			}
        },
        { caption = "Changer de pied",
			destinations = {menuHelper.destinations.setDefault("emote",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/a shift_feet"})
				})
			}
        },
        { caption = "Regarder autour",
			destinations = {menuHelper.destinations.setDefault("emote",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/a look_behind"})
				})
			}
        },
        { caption = "Regarder sa main",
			destinations = {menuHelper.destinations.setDefault("emote",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/a examine_hand"})
				})
			}
        },		
        { caption = "Page 1",
            destinations = {
                menuHelper.destinations.setDefault("emote vocal")
            }
        },	
        { caption = "Quitter", destinations = nil }
    }
}
