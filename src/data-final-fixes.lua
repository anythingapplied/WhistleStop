--serpent = require("serpent")

-- Creates 50x versions of each recipe from selected categories
require("__WhistleStopFactories__.scripts.recipeSetup")

-- Create the item groups for these new recipes
require("__WhistleStopFactories__.scripts.itemGroupSetup")

-- Adds big items to list of productivity module usable items
require("__WhistleStopFactories__.scripts.productivityFix")

-- Creates dummy items with recipe icons so tag images can match recip icons (normally only item icons are available)
require("__WhistleStopFactories__.scripts.tagIcons")

-- Big Loader prototype and item definition (moved to data-final to capture visual updates on default loader some mods implement)
local create_bigloader = require("__WhistleStopFactories__.prototypes.bigloader")
create_bigloader("wsf-factory-loader")

-- Update Loader speed to fastest available loaders or belts in current mod set
require("__WhistleStopFactories__.scripts.updateLoaderSpeed")