Menus["invite player"] = {
    text = color.Gold .. "Voulez vous inviter\n" .. color.LightGreen ..
    " le joueur dans le groupe ?\n" ..
        color.White .. "...",
    buttons = {						
        { caption = "oui",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TeamGroup", "ActiveMenu", 
					{menuHelper.variables.currentPlayerDataVariable("targetPid")}),
				menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
						{menuHelper.variables.currentPid(), "/maingroup"})					
                })
            }
        },			
        { caption = "non", 
			destinations = {menuHelper.destinations.setDefault(nil,	
            { 
				menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage", 
					{menuHelper.variables.currentPid(), "/maingroup"})	
				})
			}
		}
    }
}

Menus["reponse player"] = {
    text = color.Gold .. "Voulez vous rejoindre\n" .. color.LightGreen ..
    " le groupe ?\n" ..
        color.White .. "...",
    buttons = {						
        { caption = "oui",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TeamGroup", "RegisterGroup", 
					{menuHelper.variables.currentPlayerDataVariable("targetPid"), menuHelper.variables.currentPid()})
                })
            }
        },			
        { caption = "non", destinations = nil }
    }
}