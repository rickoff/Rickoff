fix by david cernat


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
