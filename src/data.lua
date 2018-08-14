
-- Create prototypes for entities and items
require("prototypes.prototypes")

data:extend({ 
  -- Big furnace recipe category
  {
    type = "recipe-category",
    name = "big-smelting"
  },
   
  -- Big assembly recipe category
  {
    type = "recipe-category",
    name = "big-recipe"
  },

  {
    type = "recipe-category",
    name = "big-chem"
  },

  -- Big refinery recipe category
  {
    type = "recipe-category",
    name = "big-refinery"
  },

  -- Speed Technologies

  {
    type = "technology",
    name = "whistlestop-speed-1",
    icon_size = 128,
    icon = "__base__/graphics/technology/automation.png",
    prerequisites = {"automation-3"},
    unit =
    {
      count = 200,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 1},
        {"production-science-pack", 1}
      },
      time = 30
    },
    order = "a-f-d",
    upgrade = "true"
  },

  {
    type = "technology",
    name = "whistlestop-speed-2",
    icon_size = 128,
    icon = "__base__/graphics/technology/automation.png",
    prerequisites = {"whistlestop-speed-1"},
    unit =
    {
      count_formula = "100+100*L",
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 1},
        {"production-science-pack", 1},
        {"high-tech-science-pack", 1}
      },
      time = 30
    },
    order = "a-f-d",
    upgrade = "true",
    max_level = 12
  },

    -- Speed Technologies

    {
      type = "technology",
      name = "whistlestop-loader-1",
      icon_size = 128,
      icon = "__base__/graphics/technology/logistics.png",
      prerequisites = {"logistics-2"},
      unit =
      {
        count = 200,
        ingredients =
        {
          {"science-pack-1", 1},
          {"science-pack-2", 1},
          {"science-pack-3", 1},
          {"production-science-pack", 1}
        },
        time = 30
      },
      order = "a-f-d",
      upgrade = "true"
    },
  
    {
      type = "technology",
      name = "whistlestop-loader-2",
      icon_size = 128,
      icon = "__base__/graphics/technology/logistics.png",
      prerequisites = {"whistlestop-loader-1"},
      unit =
      {
        count_formula = "100+100*L",
        ingredients =
        {
          {"science-pack-1", 1},
          {"science-pack-2", 1},
          {"science-pack-3", 1},
          {"production-science-pack", 1},
          {"high-tech-science-pack", 1}
        },
        time = 30
      },
      order = "a-f-d",
      upgrade = "true",
      max_level = 12
    },
  

  -- Speed Module
  {
    type = "module",
    name = "wsf-speed-module",
    localised_name = {"item-name.speed-module"},
    localised_description = {"item-description.speed-module"},
    icon = "__base__/graphics/icons/speed-module.png",
    icon_size = 32,
    flags = {"hidden"},
    subgroup = "module",
    category = "speed",
    tier = 1,
    order = "a[speed]-a[speed-module-1]",
    stack_size = 50,
    default_request_amount = 10,
    effect = { speed = {bonus = 0.1}, consumption = {bonus = 0.14}}
  },
})