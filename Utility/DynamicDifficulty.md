Go to player>Base.lua
Find function BasePlayer:SetDifficulty(difficulty)
Replace all the block to

    function BasePlayer:SetDifficulty(difficulty)

        local difficultyMin = 100
        local currentLevel = self.data.stats.level
        local difficultyTest = difficultyMin + (currentLevel * 4)

        if difficultyTest >= 0 then 
            difficulty = difficultyTest
            self.data.settings.difficulty = difficultyTest
        else
            difficulty = difficultyMin
            self.data.settings.difficulty = difficulty        
        end

        tes3mp.SetDifficulty(self.pid, difficulty)

        tes3mp.LogMessage(enumerations.log.INFO, "Set difficulty to " .. tostring(difficulty) .. " for " .. logicHandler.GetChatName(self.pid))
    end


Warning this version includes level 1 to 50, to go beyond changing the values
