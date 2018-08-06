Put Criminals.lua file in ...\tes3mp\mp-stuff\scripts\ folder.

Open server.lua and add Criminals = require("Criminals") at the top along with other require lines.

(OPTIONAL) Find return false -- default behavior, chat messages should not and replace it with:

        local prefix = Criminals.isCriminal(pid)
        tes3mp.SendMessage(pid, prefix .. playerName .. " (" .. pid .. "): " .. message .. "\n", true)
        return false -- default behavior, chat messages should not

Save server.lua, open myMod.lua.

Find Players[pid]:Message("You have successfully logged in.\n") and below it add 

        Criminals.onLogin(pid).

Find Players[pid]:SaveBounty() and add below it.

        Criminals.updateBounty(pid) 

Save myMod.lua and open \player\base.lua or script with processdeath

Find deathReason = "was killed by " .. deathReason and below it add 

        Criminals.processBountyReward(self.pid, deathReason).

Save base.lua and start the server. Try committing a crime to gain a bounty of 500 or more and see if a message is displayed in the chat.
