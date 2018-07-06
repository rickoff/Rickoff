--Go to player>Base.lua
--Find function BasePlayer:SetDifficulty(difficulty)
--Replace all the block to
--attention this version includes level 1 to 50, to go beyond changing the values
function BasePlayer:SetDifficulty(difficulty)

	local difficultyMin = config.difficulty
	local currentLevel = tes3mp.GetLevel(self.pid)
	local difficultytest = difficultyMin + (currentLevel * 4)

	if difficultytest <= 4 then
		difficulty = 0 
	elseif difficultytest <= 8 then
		difficulty = 4 
	elseif difficultytest <= 12 then
		difficulty = 8 
	elseif difficultytest <= 16 then
		difficulty = 12 
	elseif difficultytest <= 20 then
		difficulty = 16 
	elseif difficultytest <= 24 then
		difficulty = 20 
	elseif difficultytest <= 28 then
		difficulty = 24 
	elseif difficultytest <= 32 then
		difficulty = 28
	elseif difficultytest <= 36 then
		difficulty = 32 
	elseif difficultytest <= 40 then
		difficulty = 36 
	elseif difficultytest <= 44 then
		difficulty = 40 
	elseif difficultytest <= 48 then
		difficulty = 44 
	elseif difficultytest <= 52 then
		difficulty = 48 
	elseif difficultytest <= 56 then
		difficulty = 52 
	elseif difficultytest <= 60 then
		difficulty = 56
	elseif difficultytest <= 64 then
		difficulty = 60 
	elseif difficultytest <= 68 then
		difficulty = 64 
	elseif difficultytest <= 72 then
		difficulty = 68 
	elseif difficultytest <= 76 then
		difficulty = 72 
	elseif difficultytest <= 80 then
		difficulty = 76 
	elseif difficultytest <= 84 then
		difficulty = 80 
	elseif difficultytest <= 88 then
		difficulty = 84
	elseif difficultytest <= 92 then
		difficulty = 88 
	elseif difficultytest <= 96 then
		difficulty = 92 
	elseif difficultytest <= 100 then
		difficulty = 96 
	elseif difficultytest <= 104 then
		difficulty = 100 
	elseif difficultytest <= 108 then
		difficulty = 104 
	elseif difficultytest <= 112 then
		difficulty = 108 
	elseif difficultytest <= 116 then
		difficulty = 112
	elseif difficultytest <= 120 then
		difficulty = 116 
	elseif difficultytest <= 124 then
		difficulty = 120 
	elseif difficultytest <= 128 then
		difficulty = 124 
	elseif difficultytest <= 132 then
		difficulty = 128 
	elseif difficultytest <= 136 then
		difficulty = 132 
	elseif difficultytest <= 140 then
		difficulty = 136 
	elseif difficultytest <= 144 then
		difficulty = 140
	elseif difficultytest <= 148 then
		difficulty = 144 
	elseif difficultytest <= 152 then
		difficulty = 148 
	elseif difficultytest <= 156 then
		difficulty = 152 
	elseif difficultytest <= 160 then
		difficulty = 156 
	elseif difficultytest <= 164 then
		difficulty = 160 
	elseif difficultytest <= 168 then
		difficulty = 164 
	elseif difficultytest <= 172 then
		difficulty = 168
	elseif difficultytest <= 176 then
		difficulty = 172 
	elseif difficultytest <= 180 then
		difficulty = 176 
	elseif difficultytest <= 184 then
		difficulty = 180 
	elseif difficultytest <= 188 then
		difficulty = 184 
	elseif difficultytest <= 192 then
		difficulty = 188 
	elseif difficultytest <= 196 then
		difficulty = 192 
	elseif difficultytest <= 200 then
		difficulty = 196
	elseif difficultytest <= 204 then
		difficulty = 200		
	else
		self.data.settings.difficulty = difficulty
	end
	self.data.settings.difficulty = difficulty
	tes3mp.SetDifficulty(self.pid, difficulty)
	tes3mp.LogMessage(1, "Set difficulty to " .. tostring(difficulty) .. " for " .. myMod.GetChatName(self.pid))
end
