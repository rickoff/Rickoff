--[[
MultiMark by Rickoff
tes3mp 0.7.0
ready for the next version
script version 0.1
---------------------------
DESCRIPTION :
multi mark location with /mark and /recall command
---------------------------
INSTALLATION:
Save the file as MultiMark.lua inside your server/scripts/custom folder.

Edits to customScripts.lua add :
MultiMark = require("custom.MultiMark")
---------------------------
CONFIG :
Change trad in your language for your server
Change config MaxMark for config limite mark
Change config GUI numbers for a unique numbers 
]]

---------------------------
--------CONFIGURATION------
---------------------------
local trad = {}
trad.BackList = "* Back *\n"
trad.LimiteMark = color.Red.."The number of mark is limited to : "
trad.SelectMark = color.Green.."Select a mark to edit or teleport"
trad.ChoiceMark = color.Yellow.."Select an option"
trad.ChoiceMarkOpt = "Recall;Remove"

local config = {}
config.MarkId = "mark"
config.RecallId = "recall"
config.MaxMark = 10
config.MainGUI = 23101989
config.ChoiceGUI = 23101990

local playerIndex = {}

---------------------------
--------FUNCTION-----------
---------------------------
local function GetName(pid)
	return string.lower(Players[pid].accountName)
end

local function SelectChoice(pid, index)
	playerIndex[GetName(pid)] = index
    tes3mp.CustomMessageBox(pid, config.ChoiceGUI, trad.ChoiceMark, trad.ChoiceMarkOpt)	
end

local function ListMark(pid)
    local options = Player[pid].data.customVariables.markLocation
    local list = trad.BackList 
    local listItemChanged = false
    local listItem = ""
	
    for i = 1, #options do
 
		for x, slot in pairs(Player[pid].data.customVariables.markLocation) do	
			if slot == options[i] then
				listItem = slot.cell.." : "..math.floor(slot.posX).." ; "..math.floor(slot.posY).." ; "..math.floor(slot.posZ)
				listItemChanged = true
				break
			else
				listItemChanged = false
			end
		end
		
		if listItemChanged == true then
			list = list .. listItem
		end
		
		if listItemChanged == false then
			list= list .. "\n"
		end
		
        if not(i == #options) then
            list = list .. "\n"
        end
    end
	
	listItemChanged = false
    tes3mp.ListBox(pid, config.MainGUI, trad.SelectMark..color.Default, list)	
end

local function CountMark(pid)
	local count = 0
	for x, slot in pairs(Player[pid].data.customVariables.markLocation) do
		count = count + 1
	end
	return count
end

local function AddMark(pid)
	if CountMark(pid) < config.MaxMark then
		local tablePos = {}
		tablePos.cell = tes3mp.GetCell(pid)
		tablePos.posX = tes3mp.GetPosX(pid)
		tablePos.posY = tes3mp.GetPosY(pid)
		tablePos.posZ = tes3mp.GetPosZ(pid)
		tablePos.rotX = tes3mp.GetRotX(pid)
		tablePos.rotZ = tes3mp.GetRotZ(pid)  
		Player[pid].data.customVariables.markLocation = {}				
		table.insert(Player[pid].data.customVariables.markLocation, tablePos)
		Player[pid]:QuicksaveToDrive()
	else
		tes3mp.MessageBox(pid, -1, trad.LimiteMark..color.Green..config.MaxMark)
	end
end

local function RemoveMark(pid)
	local index = playerIndex[GetName(pid)]
	Player[pid].data.customVariables.markLocation[index] = nil	
	Player[pid]:QuicksaveToDrive()
end

local function RecallPlayer(pid)
	local index = playerIndex[GetName(pid)]
	local cell = Player[pid].data.miscellaneous[index].posX			
	local posX = Player[pid].data.miscellaneous[index].posX
	local posY = Player[pid].data.miscellaneous[index].posY
	local posZ = Player[pid].data.miscellaneous[index].posZ
	local rotX = Player[pid].data.miscellaneous[index].rotX
	local rotZ = Player[pid].data.miscellaneous[index].rotZ      
	tes3mp.SetCell(pid, cell)
	tes3mp.SendCell(pid)
	tes3mp.SetPos(pid, posX, posY, posZ)
	tes3mp.SetRot(pid, rotX, rotZ)				
	tes3mp.SendPos(pid)		
end

---------------------------
--------EVENTS-------------
---------------------------
local MultiMark = {}

--[[
MultiMark.OnPlayerSpellsActive = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		for spellIndex = 0, tes3mp.GetSpellsActiveChangesSize(pid) - 1 do
			local spellId = tes3mp.GetSpellsActiveId(pid, spellIndex)    
			if spellId == config.MarkId then
				AddMark(pid)
				return customEventHooks.makeEventStatus(false, false)
			elseif spellId == config.RecallId then
				ListMark(pid)
				return customEventHooks.makeEventStatus(false, false)
			end			
		end
	end
end
]]

MultiMark.CommandAddMark = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		AddMark(pid)
	end
end

MultiMark.CommandRecallMark = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		ListMark(pid)
	end
end

MultiMark.OnGUIAction = function(pid, idGui, data)
 	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then  
		if idGui == config.MainGUI then -- Main
			if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing
				return true
			else   
				SelectChoice(pid, tonumber(data)) --Select
				return true
			end
		elseif idGui == config.ChoiceGUI then -- Choice
			if tonumber(data) == 0 then --Recall
				RecallPlayer(pid)
				return true
			elseif tonumber(data) == 1 then --Remove
				RemoveMark(pid)
				return true		
			end
		end
		
	end
end

--customEventHooks.registerValidator("OnPlayerSpellsActive", MultiMark.OnPlayerSpellsActive) --WAIT NEXT VERSION
customCommandHooks.registerCommand("mark", MultiMark.CommandAddMark)
customCommandHooks.registerCommand("recall", MultiMark.CommandRecallMark)
customEventHooks.registerHandler("OnGUIAction", function(eventStatus, pid, idGui, data)
	if MultiMark.OnGUIAction(pid, idGui, data) then return end	
end)

return MultiMark
