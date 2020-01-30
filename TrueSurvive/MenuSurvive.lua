Menus["survive hunger"] = {
    text = color.Gold .. "Voulez vous\n" .. color.LightGreen ..
    "manger\n" .. color.Gold .. "cet aliment ?\n" ..
        color.White .. "...",
    buttons = {						
        { caption = "oui",
            destinations = {
				menuHelper.destinations.setDefault(nil,
				{ 
					menuHelper.effects.runGlobalFunction("TrueSurvive", "OnHungerObject", 
					{
                        menuHelper.variables.currentPid()
                    }),
                    menuHelper.effects.runGlobalFunction("logicHandler", "DeleteObjectForEveryone",
                    {
                        menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    }),
					menuHelper.effects.runFunction("PlaySound", {"swallow"})					
                })
            }
        },            
        { caption = "non",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("logicHandler", "ActivateObjectForPlayer",
                    {
                        menuHelper.variables.currentPid(), menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    })
                })
            }
        }
    }
}

Menus["survive drink"] = {
    text = color.Gold .. "Voulez vous\n" .. color.LightGreen ..
    "boire\n" .. color.Gold .. "le contenue ?\n" ..
        color.White .. "...",
    buttons = {                        
        { caption = "oui",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("TrueSurvive", "OnDrinkObject", 
                    {
                        menuHelper.variables.currentPid()
                    }),
                    menuHelper.effects.runGlobalFunction("logicHandler", "DeleteObjectForEveryone",
                    {
                        menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    }),
					menuHelper.effects.runFunction("PlaySound", {"drink"})						
                })
            }
        },            
        { caption = "non",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("logicHandler", "ActivateObjectForPlayer",
                    {
                        menuHelper.variables.currentPid(), menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    })
                })
            }
        }
    }
}

Menus["survive drink active"] = {
    text = color.Gold .. "Voulez vous\n" .. color.LightGreen ..
    "boire\n" .. color.Gold .. "le contenue ?\n" ..
        color.White .. "...",
    buttons = {                        
        { caption = "oui",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("TrueSurvive", "OnDrinkObject", 
                    {
                        menuHelper.variables.currentPid()
                    }),
					menuHelper.effects.runFunction("PlaySound", {"drink"})					
                })
            }
        },            
        { caption = "non",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("logicHandler", "ActivateObjectForPlayer",
                    {
                        menuHelper.variables.currentPid(), menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    })
                })
            }
        }
    }
}

Menus["survive sleep"] = {
    text = color.Gold .. "Voulez vous\n" .. color.LightGreen ..
    "dormir\n" .. color.Gold .. "dans ce lit ?\n" ..
        color.White .. "...",
    buttons = {						
        { caption = "repos survie",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TrueSurvive", "OnSleepObject", 
					{menuHelper.variables.currentPid()})
                })
            }
        },			
        { caption = "repos normal",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TrueSurvive", "OnSleepObjectVanilla", 
					{menuHelper.variables.currentPid()})
                })
            }
        },	
    }
}

Menus["survive vamp"] = {
    text = color.Gold .. "Voulez vous\n" .. color.LightGreen ..
    "sucer\n" .. color.Gold .. "le sang ?\n" ..
        color.White .. "...",
    buttons = {                        
        { caption = "oui",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("TrueSurvive", "OnVampDrink", 
                    {
                        menuHelper.variables.currentPid()
                    }),
					menuHelper.effects.runFunction("PlaySound", {"drink"})					
                })
            }
        },            
        { caption = "non",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("logicHandler", "ActivateObjectForPlayer",
                    {
                        menuHelper.variables.currentPid(), menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    })
                })
            }
        }
    }
}

Menus["survive wolf"] = {
    text = color.Gold .. "Voulez vous\n" .. color.LightGreen ..
    "manger\n" .. color.Gold .. "la chaire fraiche ?\n" ..
        color.White .. "...",
    buttons = {                        
        { caption = "oui",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("TrueSurvive", "OnWolfHunger", 
                    {
                        menuHelper.variables.currentPid()
                    }),
					menuHelper.effects.runFunction("PlaySound", {"weregrowl"})					
                })
            }
        },            
        { caption = "non",
            destinations = {
                menuHelper.destinations.setDefault(nil,
                { 
                    menuHelper.effects.runGlobalFunction("logicHandler", "ActivateObjectForPlayer",
                    {
                        menuHelper.variables.currentPid(), menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    })
                })
            }
        }
    }
}