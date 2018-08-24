add to server.lua underneath command tchat text

		elseif cmd[1] == "resetlog" then
			Players[pid].data.journal = {}
			tes3mp.Kick(pid)	
