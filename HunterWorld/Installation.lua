INSTALLATION

--1) Save this file as "HunterWorld.lua" in mp-stuff/scripts
--EcarlateCreature.json and EcarlateCreatureSpawn.json in mpstuff/data

--2) Add [HunterWorld = require("HunterWorld")] to the top of server.lua

--3) Find "function OnServerInit()" inside server.lua and add at the end
HunterWorld.TimerEventWorld()
		
--4) Go to myMod.lua and find CreateObjectAtLocation, add underneath function

Methods.CreateCreatureAtLocation = function(cell, location, refId, packetType)

    local mpNum = WorldInstance:GetCurrentMpNum() + 1
    local refIndex =  0 .. "-" .. mpNum

    WorldInstance:SetCurrentMpNum(mpNum)
    tes3mp.SetCurrentMpNum(mpNum)

    local useTemporaryLoad = false

    if LoadedCells[cell] == nil then
	Methods.LoadCell(cell)
	useTemporaryLoad = true
    end

    LoadedCells[cell]:InitializeObjectData(refIndex, refId)
    LoadedCells[cell].data.objectData[refIndex].location = location

    if packetType == "place" then
	table.insert(LoadedCells[cell].data.packets.place, refIndex)
    elseif packetType == "spawn" then
	table.insert(LoadedCells[cell].data.packets.spawn, refIndex)
	table.insert(LoadedCells[cell].data.packets.actorList, refIndex)
    end

    LoadedCells[cell]:Save()

    if useTemporaryLoad then
	Methods.UnloadCell(cell)
    end

    -- Are there any players on the server? If so, initialize the event
    -- for the first one we find and just send the corresponding packet
    -- to everyone
    if tableHelper.getCount(Players) > 0 then
	tes3mp.InitializeEvent(tableHelper.getAnyValue(Players).pid)
	tes3mp.SetEventCell(cell)
	tes3mp.SetObjectRefId(refId)
	tes3mp.SetObjectRefNumIndex(0)
	tes3mp.SetObjectMpNum(mpNum)
	tes3mp.SetObjectPosition(location.posX, location.posY, location.posZ)
	tes3mp.SetObjectRotation(location.rotX, location.rotY, location.rotZ)
	tes3mp.AddWorldObject()

	if packetType == "place" then
	    tes3mp.SendObjectPlace(true)
	elseif packetType == "spawn" then
	    tes3mp.SendObjectSpawn(true)
	end
    end
end
	

--6) Open jsonfiles EcarlateCreature and edit with the id corresponding to your server

--7) Find function OnPlayerKillCount(pid) in myMod.lua and add EventWorld.HunterPrime(pid)

function OnPlayerKillCount(pid)
    myMod.OnPlayerKillCount(pid)
    EventWorld.HunterPrime(pid)
end
