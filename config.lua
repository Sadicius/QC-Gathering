---------------------------------------------------------------------------------------------------------------------
--------------------------- Quantum Projects Gathering Configuration ------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- Please Read the Read Me before attempting to change anything in this file unless you know what your doing -----
---------------------------------------------------------------------------------------------------------------------


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
      { 
        Min = 1, 
        Max = 5, 
        Item = 'apple', 
        Name = 'Blackberry',  
        MaxHarvest = 5, 
        Type = true, 
        Hash = 'rdr_bush_neat_aa_sim' 
      },
      { 
        Min = 1, 
        Max = 2, 
        Item = 'apple',     
        Name = 'Orange',      
        MaxHarvest = 5, 
        Type = true, 
        Hash = 'rdr_bush_ficus_aa_sim' 
      },
      { 
        Min = 1, 
        Max = 2, 
        Item = 'apple',      
        Name = 'Apple',       
        MaxHarvest = 5, 
        Type = true, 
        Hash = 'rdr_bush_sumac_aa_sim' 
      },
      { 
        Min = 1, 
        Max = 2, 
        Item = 'apple',     
        Name = 'Corn',        
        MaxHarvest = 5, 
        Type = true, 
        Hash = 's_inv_huckleberry01x' 
      },
    }
  }
}


