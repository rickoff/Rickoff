MarketPlaceSetup

    a global marketplace to sell your items or buy items put up for sale by other players
    players can only sell items in the EcarlateItems.json list
    the id of the objects are displayed by the names present in the json
    the seller makes money even if he is disconnected
    
1) Save this file as "MarketPlace.lua" in mp-stuff/scripts and EcarlateItems.json in mpstuff/data

2) Add [ MarketPlace = require("MarketPlace") ] to the top of server.lua

3) Add the following to the elseif chain for commands in "OnPlayerSendMessage" inside server.lua

		elseif cmd[1] == "hdv" then
			MarketPlace.showMainGUI(pid)
	
		
4) Add the following to OnGUIAction in server.lua

	if MarketPlace.OnGUIAction(pid, idGui, data) then return end
	
5) Add under pluginlist = {}

		hdvlist = {}
		hdvinv = {}

6) Add under function LoadPluginList()

        function Loadhdvlist()
          tes3mp.LogMessage(2, "Reading hdvlist.json")

          hdvlist = jsonInterface.load("hdvlist.json")

          if hdvlist == nil then
            hdvlist.players = {}
          end
        end
        function Loadhdvinv()
          tes3mp.LogMessage(2, "Reading hdvinv.json")

          hdvinv = jsonInterface.load("hdvinv.json")

          if hdvinv == nil then
            hdvinv.players = {}
          end
        end
        
7) Find function OnServerInit() and add above LoadPluginList()

		Loadhdvlist()
		Loadhdvinv()	
