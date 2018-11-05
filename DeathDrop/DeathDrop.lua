-- This is the modified version of DeathDrop made for Rickoff so that only gold is dropped on death.

-- DeathDrop.lua -*-lua-*-
-- "THE BEER-WARE LICENCE" (Revision 42):
-- <mail@michael-fitzmayer.de> wrote this file.  As long as you retain
-- this notice you can do whatever you want with this stuff. If we meet
-- some day, and you think this stuff is worth it, you can buy me a beer
-- in return.  Michael Fitzmayer


Methods = {}

inventoryHelper = require("inventoryHelper")

-- Add [ DeathDrop = require("DeathDrop") ] to the top of myMod.lua

-- Find "Players[pid]:ProcessDeath()" inside myMod.lua and add:
-- [ DeathDrop.Drop(pid) ]
-- directly above it.


Methods.Drop = function(pid)
	local player = Players[pid]
	local goldLoc = inventoryHelper.getItemIndex(player.data.inventory, "gold_001", -1)
	
	--Only drop the player's gold if they have any in their inventory
	if goldLoc then
		local item = player.data.inventory[goldLoc]
			
		local mpNum = WorldInstance:GetCurrentMpNum() + 1
		local cell = tes3mp.GetCell(pid)
		local location = {
			posX = tes3mp.GetPosX(pid), posY = tes3mp.GetPosY(pid), posZ = tes3mp.GetPosZ(pid),
		}
		local refId = item.refId
		local count = (item.count - 100)
		local refIndex =  0 .. "-" .. mpNum
		
		WorldInstance:SetCurrentMpNum(mpNum)
		tes3mp.SetCurrentMpNum(mpNum)

		LoadedCells[cell]:InitializeObjectData(refIndex, refId)
		LoadedCells[cell].data.objectData[refIndex].location = location
		table.insert(LoadedCells[cell].data.packets.place, refIndex)
		LoadedCells[cell]:Save()

		for onlinePid, player in pairs(Players) do
			if player:IsLoggedIn() then
				tes3mp.InitializeEvent(onlinePid)
				tes3mp.SetEventCell(cell)
				tes3mp.SetObjectRefId(refId)
				tes3mp.SetObjectCount(count)
				tes3mp.SetObjectRefNumIndex(0)
				tes3mp.SetObjectMpNum(mpNum)

				tes3mp.SetObjectPosition(location.posX, location.posY, location.posZ)
				tes3mp.AddWorldObject()
				tes3mp.SendObjectPlace()
			end
		end
		
		player.data.inventory[goldLoc] = {refId = "gold_001", count = 100, charge = -1}
		
		local itemref = {refId = "gold_001", count = 100, charge = -1}			
		Players[pid]:Save()
		Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)			

	end
end


return Methods
