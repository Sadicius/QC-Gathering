# QC-Gathering

A completly new Gathering script designated to be used with ox target in the [RSG Framework](https://github.com/Rexshack-RedM). Script uses hashes to identify plant type.

# Information

- Ensure players have the required tools for harvesting.
- Players interact with props set in configuration to harvest.
- The system logs the event in gathering.json.

# Developer Information

- To add more plant types, use spooner to get hash :) 

```
Config = {
  BushHarvest = {
    Items = {
      { 
        Min = 1,                          -- Min and Max means how many items you can get from the bush.
        Max = 5, 
        Item = 'apple',                   -- Item is what item you get from the bush.
        Name = 'BlueBerry',               -- Name is the name of the item that will be displayed in the notification.
        MaxHarvest = 5,                   -- MaxHarvest is how many times you can harvest the bush before beeing empty.
        Type = true,                      --DONT TOUCH THIS YET
        Hash = 'rdr_bush_neat_bb_sim'     -- Hash is the hash of the bush.
      },
    },
    }
  }
```

## Support:
[Quantum Projects](https://discord.gg/xkr9R4H8)

## Dependancies
- rsg-core
- ox_lib
- ox_target [RexShack Edit](https://github.com/Rexshack-RedM/ox_target)


