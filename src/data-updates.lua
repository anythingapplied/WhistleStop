local inspect = require('inspect')

-- Makes a deep copy of any object
function copy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
    return res
end

factor = 50

-- Creates 50x versions of each recipe from selected categories
local recipeSetup = require('recipeSetup')
recipeSetup()

-- Create the item groups for these new recipes
local itemGroupSetup = require('itemGroupSetup')
itemGroupSetup()

-- Adds 50x recipes versions to each technology
local techSetup = require('techSetup')
techSetup()