Menus["menu avertissement mining"] = {
    text = {
		color.Red.."AVERTISSEMENT !!!",
		color.White.."\n\nVous venez de commettre un crime contre le serveur.",
		color.Red.."\n\n\nTENTATIVE DE GLITCH !!!",
		color.Yellow.."\n\nUn message à était enregistré dans les logs du serveur pour avertir la modération",
		color.White.."\n\nFaite attention la prochaine fois",
		color.Yellow.."\n\nL'objet à était replacé à votre emplacement",
		color.Cyan.."\n\nBon jeu, fairplay et rôle play.",
		color.Red.."\n\n\nEn continuant vous acceptez de ne pas reproduire cette action ?"
	},
    buttons = {                        
        { caption = "oui",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("WorldMining", "PunishPrison", 
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
                    menuHelper.effects.runGlobalFunction("WorldMining", "PunishKick", 
                    {
                        menuHelper.variables.currentPid(),
                    })					
                })
            }
        }		
    }
}	