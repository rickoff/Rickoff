
1) Save this file as "DeathDrop.lua" in mp-stuff/scripts

2) Add [ DeathDrop = require("DeathDrop") ] to the top of myMod.lua

3) Find "Players[pid]:ProcessDeath()" inside myMod.lua and add:
[ DeathDrop.Drop(pid) ]
directly above it.
