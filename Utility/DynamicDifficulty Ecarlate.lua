--Go to player>Base.lua
--Find function BasePlayer:SetDifficulty(difficulty)
--Replace all the block to
--attention this version includes level 1 to 50, to go beyond changing the values
function BasePlayer:SetDifficulty(difficulty)
    local difficultyMin = config.difficulty
    local currentLevel = tes3mp.GetLevel(self.pid)
    local difficultyTest = difficultyMin + ((currentLevel - 1) * 4)
    if (difficultyTest >= 0 and difficultyTest <= 200) then
        difficulty = difficultyTest - difficultyTest % 4
    end
    self.data.settings.difficulty = difficulty
    tes3mp.SetDifficulty(self.pid, difficulty)
    tes3mp.LogMessage(1, "Set difficulty to " .. tostring(difficulty) .. " for " .. myMod.GetChatName(self.pid))
end
