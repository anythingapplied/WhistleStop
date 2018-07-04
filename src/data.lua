data:extend({

  -- Big furnace item definition
  {
    type = "item",
    name = "big-furnace",
    icon = "__WhistleStopFactories__/graphics/icons/big-furnace.png",
    icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "smelting-machine",
    order = "d[big-furnace]",
    place_result = "big-furnace",
    stack_size = 50
  },
  
  -- Big furnace recipe category
  {
    type = "recipe-category",
    name = "big-smelting"
  },

  -- Big assembly tech for building it
  {
    type = "technology",
    name = "advanced-material-big",
    icon_size = 128,
    icon = "__base__/graphics/technology/advanced-material-processing.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "big-furnace"
      }
    },
    prerequisites = {"advanced-material-processing-2"},
    unit =
    {
      count = 300,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 1},
        {"production-science-pack", 1}
      },
      time = 30
    },
    order = "c-c-b"
  },

  -- Big assembly item definition
  {
    type = "item",
    name = "big-assembly",
    icon = "__WhistleStopFactories__/graphics/icons/big-assembly.png",
    icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "production-machine",
    order = "c[big-assembling-machine]",
    place_result = "big-assembly",
    stack_size = 50
  },

  -- Big assembly recipe category
  {
    type = "recipe-category",
    name = "big-recipe"
  },

  -- Big assembly tech for building it
  {
    type = "technology",
    name = "automation-big",
    icon_size = 128,
    icon = "__base__/graphics/technology/automation.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "big-assembly"
      }
    },
    prerequisites = {"logistics-3"},
    unit =
    {
      count = 450,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 1},
        {"production-science-pack", 1}
      },
      time = 60
    },
    order = "a-b-c"
  },

  })