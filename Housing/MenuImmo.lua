Menus["menu immobilier"] = {
	text = {color.Orange .. "MENU IMMOBILIER\n",
		color.Yellow.. "\n\n[Catalogue]",	
        color.White .. "\nvous permet d'acheter ou d'utiliser vos biens",
		color.Yellow.. "\n\n[Magasin]",
		color.White.. "\nacheter des objets de décorations",
		color.Yellow.. "\n\n[Décoration]",		
		color.White.. "\ndécorer votre espace\n"

	},	
    buttons = {
        { caption = "Catalogue",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/house"})
				})
			}
        },
        { caption = "Ma Maison",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/myhouse"})
				})
			}
        },		
        { caption = "Magasin",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/furn"})
				})
			}
        },
        { caption = "Décoration",
			destinations = {menuHelper.destinations.setDefault(nil,
			{ 
			menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/dh"})
				})
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

Menus["menu prison house"] = {
    text = {
		color.Red.."AVERTISSEMENT !!!",
		color.White.."\n\nVous venez de commettre un crime contre le serveur.",
		color.Red.."\n\n\nTENTATIVE DE GLITCH !!!",
		color.Yellow.."\n\nUn message à était enregistré dans les logs du serveur pour avertir la modération",
		color.White.."\n\nFaite attention la prochaine fois",
		color.Yellow.."\n\nL'objet à était désactivé seulement pour vous pendant cette session de jeu",
		color.White.."\n\nPour le faire réapparaitre vous pouvez vous déconnecter et vous reconnecter",
		color.Cyan.."\n\nBon jeu, fairplay et rôle play.",
		color.Red.."\n\n\nEn continuant vous acceptez de ne pas reproduire cette action ?"
	},
    buttons = {                        
        { caption = "oui",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("ecarlateScript", "PunishPrison", 
                    {
                        menuHelper.variables.currentPid(), menuHelper.variables.currentPid()
                    })					
                })
            }
        },             
        { caption = "non",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("ecarlateScript", "PunishKick", 
                    {
                        menuHelper.variables.currentPid(),
                    })					
                })
            }
        }		
    }
}	