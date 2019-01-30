Here is a solution to allow your players to recover files for your mods or server devs update and connect directly your server.

-1) create a dropbox or other hosting service for your files : https://www.dropbox.com/ free 2go
-2) download innosetup for compile your files for update your server : http://www.jrsoftware.org/isinfo.php
-3) compile your update with inno setup and drop setup.exe in your dropbox
-4) place VersionServer.txt in your DropBox
-5) place OpenMw.cfg in your dropbox
-6) place your tesmp-client-default.cfg with good configuration for your server ip and password
-7) select your link and replace corresponding files in Serverlink.txt exemple :
    - https://www.dropbox.com/Openmw.cfg?dl=1 
    - https://www.dropbox.com/setup.exe?dl=1
    - https://www.dropbox.com/VersionServer.txt?dl=1
    - https://www.dropbox.com/tes3mp-client-default.cfg?dl=1
    - https://discord.gg/ECJk293
    - https://tes3mp.com/
-8) place VersionClient.txt in directory to client games directory
-9) send launcher folder and VersionClient for all players of your server
-10) if VersionClient is not egal a VersionServer then the launcher download and setup the last upate.
