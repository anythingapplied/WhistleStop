inspect = require("inspect")

-- Creates 50x versions of each recipe from selected categories
require("scripts.recipeSetup")

-- Create the item groups for these new recipes
require("scripts.itemGroupSetup")

-- Adds big items to list of productivity module usable items
require("scripts.productivityFix")

-- Update Loader speed to fastest available loaders or belts in current mod set
require("scripts.updateLoaderSpeed")

-- Creates dummy items with recipe icons so tag images can match recip icons (normally only item icons are available)
require("scripts.tagIcons")