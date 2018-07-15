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

  {
    type = "recipe-category",
    name = "big-chem"
  },
  
  -- Big refinery item definition
  {
    type = "item",
    name = "big-refinery",
    icon = "__base__/graphics/icons/oil-refinery.png",
    icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "production-machine",
    order = "d[refinery]",
    place_result = "big-assembly",
    stack_size = 10
  },

  -- Big refinery recipe category
  {
    type = "recipe-category",
    name = "big-refinery"
  },
   
  })