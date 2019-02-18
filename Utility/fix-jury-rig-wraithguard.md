fix by david cernat

**just make a custom record and remove its script for now**
*for version 0.7 alpha*

Open up data/recordstore/armor.json and add this to permanentRecords:
```
    "wraithguard_jury_rig":{
        "baseId":"wraithguard_jury_rig",
        "script":""
    }
```
So, for example, if you don't have any other permanentRecords in there, it's going to look like this:
```
  "permanentRecords":{
    "wraithguard_jury_rig":{
        "baseId":"wraithguard_jury_rig",
        "script":""
    }
  },
```
Instead of the default:
```
  "permanentRecords":[],
```
