Menus["menu chat"] = {
    text = {color.Orange .. "MENU CHAT\n",
        color.White .. "\nSelect the channel of the chat you want to talk to.\n"
	},	
    buttons = {	
        { caption = "Global",
			destinations = {menuHelper.destinations.setDefault("menu chat",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/global"})
				})
			}
        },
        { caption = "Whisper",
			destinations = {menuHelper.destinations.setDefault("menu chat",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/short"})
				})
			}
        },
        { caption = "Speak",
			destinations = {menuHelper.destinations.setDefault("menu chat",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/medium"})
				})
			}
        },		
        { caption = "Scream",
			destinations = {menuHelper.destinations.setDefault("menu chat",
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/long"})
				})
			}
        },		
        { caption = "Quitter", destinations = nil }
    }
}
