
-- Create prototypes for entities and items
require("__WhistleStopFactories__.prototypes.prototypes")

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
  }
})