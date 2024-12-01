---------------------------------------------------------------------------------------------------------------------
--------------------------- Quantum Projects Gathering Configuration ------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
----- Please Read the Read Me before attempting to change anything in this file unless you know what your doing -----
---------------------------------------------------------------------------------------------------------------------
Config = {}
local gatherhash = require("gatherhash")                 --DONT TOUCH UNLESS YOU KNOW WHAT YOUR DOING

Config.CronJob = '*/1 * * * *'
--------------------------
-- Skill XP Integration --
--------------------------
Config.Skills = true
Config.SkillXP = math.random(1, 5) -- XP
------------------------
--- EXTRA Webhooks -----
------------------------
Config.Webhooks = {
    ["gatherering"] = "YOUR_WEBHOOK_LINK",                  -- Webhook for gathering to discord
}

Config.Gathering = {
  --BUSHES
  {
    Name = "Bush",
    Icon = "fa-solid fa-leaf",
    GatherModel = {gatherhash.bush},
    MaxHarvest = 2,
    Min = 1,
    Max = 2,
    Type = true,
    RewardItems = { "apple", "water" }
  },
  --TREES
  {
    Name = "Birch",
    GatherModel = {gatherhash.birch},
    MaxHarvest = 5,
    Min = 1,
    Max = 2,
    Type = true,
    RewardItems = { "wood", "fiber" }
  },
  {
    Name = "Cedar",
    GatherModel = {gatherhash.cedars},
    MaxHarvest = 5,
    Min = 1,
    Max = 2,
    Type = true,
    RewardItems = { "wood", "fiber" }
  },
  {
    Name = "Dead",
    GatherModel = {gatherhash.dead},
    MaxHarvest = 5,
    Min = 1,
    Max = 2,
    Type = true,
    RewardItems = { "wood", "fiber" }
  },
  {
    Name = "Maple",
    GatherModel = {gatherhash.maples},
    MaxHarvest = 5,
    Min = 1,
    Max = 2,
    Type = true,
    RewardItems = { "wood", "fiber" }
  },
  {
    Name = "Oak",
    GatherModel = {gatherhash.oaks},  -- Fixed the typo here
    MaxHarvest = 5,
    Min = 1,
    Max = 2,
    Type = true,
    RewardItems = { "wood", "fiber" }
  },
  {
    Name = "Palm",
    GatherModel = {gatherhash.palms},
    MaxHarvest = 5,
    Min = 1,
    Max = 2,
    Type = true,
    RewardItems = { "wood", "fiber" }
  },
  {
    Name = "Tall Tree",
    GatherModel = {gatherhash.tall_trees},
    MaxHarvest = 5,
    Min = 1,
    Max = 2,
    Type = true,
    RewardItems = { "wood", "fiber" }
  },
  {
    Name = "Tree",
    GatherModel = {gatherhash.trees},
    MaxHarvest = 5,
    Min = 1,
    Max = 2,
    Type = true,
    RewardItems = { "wood", "fiber" }
  },
  {
    Name = "Swamp",
    GatherModel = {gatherhash.swamp},
    MaxHarvest = 5,
    Min = 1,
    Max = 2,
    Type = true,
    RewardItems = { "wood", "fiber" }
  },
}