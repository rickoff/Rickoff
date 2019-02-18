# WorldMining
*by RickOff and discordpeter*

**This Script enables you to craft Materials and place Objects**

* mine rocks and trees with the specific axe
* Create complete Dungeons
* place flora and rocks
* spawn doors to other places
* teleport to doors you spawned before
* and many more possibilites

##Installation

follow the instruction provided below to install this script to your server.


* add WorldMining.lua into your mpstuff/scripts folder
* add miscellaneous.json into your mp-stuff/data/recordstore/ folder (and replace with existing one)
* add rocks.json and flora.json in your mpstuff/data folder	
* add the following files to your mp-stuff/data folder: cave.json, createdDoors.json, creature.json, exampleInteriors.json, exterior.json, furn.json, npc.json, static.json


### Changes to mp-stuff/scripts/serverCore.lua

Find the following line:

```
menuHelper = require("menuHelper")
```

and replace with

```
menuHelper = require("menuHelper")
WorldMining = require("WorldMining") ]
```

Find the following line:

```
if eventHandler.OnGUIAction(pid, idGui, data) then return end -- if eventHandler.OnGUIAction is called	
```

and replace with

```
if eventHandler.OnGUIAction(pid, idGui, data) then return end -- if eventHandler.OnGUIAction is called	
if WorldMining.OnGUIAction(pid, idGui, data) then return end
```

Find the following lines:

```
tes3mp.SetRuleString("respawnCell", respawnCell)
ResetAdminCounter()
```

and replace with

```
tes3mp.SetRuleString("respawnCell", respawnCell)
ResetAdminCounter()
WorldMining.OnServerPostInit()
```

### Changes to mp-stuff/scripts/logicHandler.lua

Find the following lines:

```
LoadedCells[cellDescription]:CreateEntry()
```

and replace with:

```
LoadedCells[cellDescription]:CreateEntry()
contentFixer.AddPreexistingObjects(cellDescription)
```
			
### Changes to mp-stuff/scripts/contentFixer.lua

Find the following line:

```
local deadlyItems = { "keening" }
```

and replace with:

```
local deadlyItems = { "keening" }

function contentFixer.AddPreexistingObjects(cellDescription)
	
	if WorldInstance.data.customVariables ~= nil and WorldInstance.data.customVariables.WorldMining ~= nil and WorldInstance.data.customVariables.WorldMining.placed ~= nil then
		local placed = WorldInstance.data.customVariables.WorldMining.placed
		if placed[cellDescription] ~= nil then
			local unique = {}
			
			for refIndex, object in pairs(placed[cellDescription]) do
				--place kanaFurniture
				unique[refIndex] = logicHandler.CreateObjectAtLocation(cellDescription, object.loc, object.refId, "place")
			end
			
			for refIndex, uniqueId in pairs(unique) do
				-- swap positions in table after we created them
				WorldInstance.data.customVariables.WorldMining.placed[cellDescription][uniqueId] = WorldInstance.data.customVariables.WorldMining.placed[cellDescription][refIndex]
				WorldInstance.data.customVariables.WorldMining.placed[cellDescription][refIndex] = nil
			end
			
		LoadedCells[cellDescription].forceActorListRequest = true
		end
	end
	
end
```

### Changes to mp-stuff/scripts/menu/help.lua

Open up the file, make a new line at the bottom and add the following code:

```
Menus["menu prison house"] = {
    text = {
		color.Red .. "WARNING !!!",
		color.White .. "\n\nYou just committed a crime against the server.",
		color.Red .. "\n\ n\nTENTATIVE OF GLITCH !!!",
		color.Yellow .. "\n\nA message to was recorded in the server logs to warn the moderation",
		color.White .. "\n\nFeel attention next time",
		color.Yellow .. "\n\nThe object to was disabled only for you during this game session",
		color.White .. "\n\nTo make it reappear you can disconnect and reconnect",
		color.Cyan .. "\n\nGood play, fairplay and role play.",
		color.Red .. "\n\n\nBy continuing you agree not to duplicate this action?"
	},
    buttons = {                        
        { caption = "yes",
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
        { caption = "no",
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

```

### Changes to mp-stuff/scripts/eventHandler.lua


Find the following lines:

```
                if doesObjectHaveActivatingPlayer then
                    activatingPid = tes3mp.GetObjectActivatingPid(index)
					debugMessage = debugMessage .. logicHandler.GetChatName(activatingPid)
```

and replace with:

```
                if doesObjectHaveActivatingPlayer then
                    activatingPid = tes3mp.GetObjectActivatingPid(index)
					debugMessage = debugMessage .. logicHandler.GetChatName(activatingPid)
	
							--eventHandler OnActivate exchange for this door with uniqueIndex
							-- if its door and uniqueIndex is in placed list in WorldInstance
						if objectRefId and objectRefId == "ex_nord_door_01" then
							local cell = tes3mp.GetCell(pid)
							if WorldInstance.data.customVariables.WorldMining.placed[cellDescription] ~= nil then
								if WorldInstance.data.customVariables.WorldMining.placed[cellDescription][objectUniqueIndex] then
									WorldMining.OnDoor(pid, objectUniqueIndex)
									isValid = false
								else
									print("door was not in worldinstance")
								end
							end
						end
						if isValid == true and objectRefId and tes3mp.IsInExterior(pid) then
							isValid = not WorldMining.OnHitActivate(pid, objectUniqueIndex, objectRefId, tes3mp.GetObjectRefNum(index), tes3mp.GetObjectMpNum(index))
						end 
```

Find the following lines:

```
            for index = 0, tes3mp.GetObjectListSize() - 1 do

                local refId = tes3mp.GetObjectRefId(index)
                local uniqueIndex = tes3mp.GetObjectRefNum(index) .. "-" .. tes3mp.GetObjectMpNum(index)
```

and replace with:

```
            for index = 0, tes3mp.GetObjectListSize() - 1 do

                local refId = tes3mp.GetObjectRefId(index)
                local uniqueIndex = tes3mp.GetObjectRefNum(index) .. "-" .. tes3mp.GetObjectMpNum(index)
						if isValid == true then
							isValid = not WorldMining.OnObjectDelete(pid)
						end
```

### Changes to mp-stuff/scripts/commandHandler.lua

Find the following lines:

```

    elseif cmd[1] == "cells" and moderator then
		guiHelper.ShowCellList(pid)
```

and replace with:

```

    elseif cmd[1] == "cells" and moderator then
		guiHelper.ShowCellList(pid)
	--WorldMining Commands
	elseif cmd[1] == "furn" then
		WorldMining.OnCommand(pid)
	elseif cmd[1] == "build" or cmd[1] == "make" then
		WorldMining.OnBuild(pid)	
	elseif cmd[1] == "material" then
		WorldMining.OnCraftCommand(pid)
```


And you are done. Start up the Game and use the command /furn /build or /material in chat
Feel free to translate the texts in WorldMining.lua
