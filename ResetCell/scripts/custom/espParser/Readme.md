espParser 0.6
---
By Jakob https://github.com/JakobCh
Mostly using: https://en.uesp.net/morrow/tech/mw_esm.txt

Updates will probably break your shit right now in the early stages.

Almost all record/subrecord data isn't parsed.

Needs DataManager.

Installation:
---
    1. Put espParser folder and struct.lua ( https://github.com/iryont/lua-struct ) in /server/scripts/custom/
    2. Add `require("custom.espParser.main")` to `/server/scripts/customScripts.lua`
    3. Create a folder called "esps" in `/server/data/custom/`
    4. Place your esp/esm files in the new folder (`/server/data/custom/esps/`)
    (5. Check the examples.lua)

Config:
---
* `espPath` path to the esp folder inside `server/data`. Default value: `custom/esps`
* `cache` if we should cache loaded files in memory
* `preload` whether all esps should be loaded on startup. Default value: `false`
* `useRequiredDataFiles` whether espParser should use `requiredDataFiles.json` for the load order. Default value: `true`
* `requiredDataFiles` path to `requiredDataFiles.json` inside data (or another file if you wish). Default value: `requiredDataFiles.json`
* `files` array of files to load if `useRequiredDataFiles` is `false`. Default value: `[]`