-- Creates 50x versions of each recipe from selected categories
require("luaMacros")
local inspect = require("inspect")

local maxIngredientCount = 65535 -- Game crashes if ingredient amount is higher than this

-- Multiplies energy required and result count by a set factor with default fallback
local function setFactor(value, default)
    if value == nil then
        return default * factor
    end
    return value * factor
end

-- Figures out max ingredient amount to ensure nothing goes over the max allowable of 65535
local function maxRecipeAmount(ary)
    local maxAmount = 0
    for k,v in pairs(ary) do
        if v.amount == nil then
            if v[2] ~= nil then
                if v[2] > maxAmount then
                    maxAmount = v[2]
                end
            end
        else
            if v.amount > maxAmount then
                maxAmount = v.amount
            end
        end
    end
    return maxAmount
end

-- Multiplies the ingredient counts by a set factor
local function setFactorIngredients(ary)
    for k,v in pairs(ary) do
        if v.amount == nil then
            if v[2] ~= nil then
                v[2] = v[2] * factor
            elseif DEBUG then
                print("Recipe with no amount and no 2nd index " .. inspect(v) .. inspect(ary))
            end
        else
            v.amount = v.amount * factor
        end
    end
    return ary
end

-- Find the subgroup for a given item
local function findSubgroup(recipename)
    local recipe = data.raw.recipe[recipename]
    if recipe.subgroup ~= nil then
        return recipe.subgroup
    else
        local product
        if recipe.result ~= nil then
            product = recipe.result
        elseif recipe.results ~= nil then
            product = recipe.results[1].name
        else
            product = recipe.normal.result
        end
        for k,v in pairs(data.raw) do
            if v[product] ~= nil then
                if v[product].subgroup ~= nil then
                    return v[product].subgroup
                end
            end
        end
    end
end

-- Adjusts counts on all variables by factor.  Does nothing if factor would go over max ingredient amount.
local function setValues(recipe)
    if maxRecipeAmount(recipe.ingredients) * factor <= maxIngredientCount then
        recipe.energy_required = setFactor(recipe.energy_required, 0.5)
        if recipe.result ~= nil then
            recipe.result_count = setFactor(recipe.result_count, 1)
        else
            recipe.results = setFactorIngredients(recipe.results)
        end
        recipe.ingredients = setFactorIngredients(recipe.ingredients)
    end
end

local function recipeSetup()
    local recipe2 = copy(data.raw.recipe)
    -- Cycles through recipes adding big version to recipe list
    for k,v in pairs(recipe2) do
        if v.normal ~= nil then --Recipe is split into normal/expensive
            setValues(v.normal)
            setValues(v.expensive)
        else
            setValues(v)
        end

        local subgroup = findSubgroup(v.name)
        if subgroup ~= nil then
            v.subgroup = findSubgroup(v.name) .. "-big"
        elseif DEBUG then
            print("No subgroup found " .. inspect(v))
        end
        v.name = v.name .. "-big"

        local cat_list1 = data.raw["assembling-machine"]["assembling-machine-3"]["crafting_categories"]
        local cat_list2 = data.raw.furnace["electric-furnace"]["crafting_categories"]
        local cat_list3 = data.raw["assembling-machine"]["chemical-plant"]["crafting_categories"]

        -- Big furnace recipes
        if inlist(v.category, cat_list2) then
            v.category = "big-smelting"
            data.raw.recipe[k .. "-big"] = v
        
        -- Big assembly recipes
        -- nil category means the same as "crafting"
        elseif v.category == nil or inlist(v.category, cat_list1) or inlist(v.category, cat_list3) then
            v.category = "big-recipe"
            data.raw.recipe[k .. "-big"] = v
        end
    end
end

recipeSetup()