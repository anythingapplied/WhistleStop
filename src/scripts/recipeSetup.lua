-- Creates 50x versions of each recipe from selected categories
require("luaMacros")
local inspect = require("inspect")

-- List of factors to try in case of ingredient limitations or stacksize limitations, in order of what is tried
local factor_list = {50, 40, 30, 20, 10, 5, 2, 1}

-- Game crashes if ingredient amount is higher than this
local maxIngredientCount = 65535

-- Output size maximum for fluid, 100 x (base_area=10)
local maxFluidBox = 1000

-- Lookup table for finding subgroup and stack_size which can be in various locations in data.raw
local dataRawLookup = {}
for k,v in pairs(data.raw) do
    for k2,v2 in pairs(v) do
        dataRawLookup[k2] = dataRawLookup[k2] or {}
        if v2.subgroup then
            dataRawLookup[k2].subgroup = v2.subgroup
        end
        if v2.stack_size then
            dataRawLookup[k2].stack_size = v2.stack_size
        end
    end
end

-- Provides the lowest value from factor_list that works
local function findfactor(min_value)
    for k,v in pairs(factor_list) do
        if v <= min_value then
            return v
        end
    end
    -- Edge case for some recipes that ALREADY exceed max stack size, such as creative mode mod
    return 1
end

local function getStackSize(item)
    if dataRawLookup[item].stack_size then
        return dataRawLookup[item].stack_size
    end
    print("No stacksize found for " .. item)
    return 100
end

-- Figures out max ingredient amount to ensure nothing goes over the max allowable of 65535
local function maxRecipeAmount(ary)
    local maxAmount = 0
    for k,v in pairs(ary) do
        if v.amount then
            if v.amount > maxAmount then
                maxAmount = v.amount
            end
        elseif v.amount_max then
            if v.amount_max > maxAmount then
                    maxAmount = v.amount_max
            end
        elseif v[2] then
            if v[2] > maxAmount then
                    maxAmount = v[2]
            end
        else
            print("Recipe with no amount registered " .. inspect(v))
        end
    end
    return maxAmount
end

-- Figures out max result amount to ensure the machine doesn't try to output more than the stacksize
local function maxRecipeOutputFactor(ary)
    local minAmount = factor_list[1]
    for k,v in pairs(ary) do
        if v.amount then
            if v.type == "fluid" then
                minAmount = math.min(maxFluidBox / v.amount, minAmount)
            else
                minAmount = math.min(getStackSize(v.name) / v.amount, minAmount)
            end
        else
            if v[2] then
                minAmount = math.min(getStackSize(v[1]) / v[2], minAmount)
            end
        end
    end
    return minAmount
end

-- Multiplies the ingredient counts by a set factor
local function setFactorIngredients(ary, factor)
    for k,v in pairs(ary) do
        if v.amount then
            v.amount = v.amount * factor
        elseif v.amount_max then
            v.amount_max = v.amount_max * factor
            v.amount_min = v.amount_min * factor
        elseif v[2] then
            v[2] = v[2] * factor
        else
            print("Recipe with no amount registered " .. inspect(v))
        end
    end
    return ary
end

-- Find the subgroup for a given item
local function findSubgroup(recipename)
    local recipe = data.raw.recipe[recipename]
    if recipe.subgroup then
        return recipe.subgroup
    end
    local product
    if recipe.result then
        product = recipe.result
    elseif recipe.results and #recipe.results == 1 then
        product = recipe.results[1].name
    elseif recipe.normal and recipe.normal.result then
        product = recipe.normal.result
    elseif recipe.normal and recipe.normal.results and #recipe.normal.results == 1 then
        product = recipe.normal.results[1].name
    elseif recipe.main_product then
        product = recipe.main_product
    else
        print("No main product found " .. recipename .. inspect(recipe))
        return
    end
    if dataRawLookup[product] then
        return dataRawLookup[product].subgroup
    else
        print("No subgroup found for " .. product)
    end
end

-- Adjusts counts on all variables by factor.  Does nothing if factor would go over max ingredient amount.
local function setValues(recipe)
    -- Highest factor that would excede the maximum ingredient limit
    local min_factor1 = maxIngredientCount / maxRecipeAmount(recipe.ingredients)

    -- Highest factor that would excede the item stacksize for the output
    local min_factor2
    if recipe.result then
        if recipe.result_count then
            min_factor2 = getStackSize(recipe.result) / recipe.result_count
        else
            min_factor2 = getStackSize(recipe.result)
        end
    else
        min_factor2 = maxRecipeOutputFactor(recipe.results)
    end

    local factor = findfactor(math.min(min_factor1, min_factor2))

    recipe.energy_required = (recipe.energy_required or 0.5) * factor
    if recipe.result then
        recipe.result_count = (recipe.result_count or 1) * factor
    else
        recipe.results = setFactorIngredients(recipe.results, factor)
    end
    recipe.ingredients = setFactorIngredients(recipe.ingredients, factor)
end

local function recipeSetup()
    -- Cycles through recipes adding big version to recipe list
    for k,v in pairs(copy(data.raw.recipe)) do
        if v.normal then --Recipe is split into normal/expensive
            setValues(v.normal)
            setValues(v.expensive)
        else
            setValues(v)
        end

        local subgroup = findSubgroup(v.name)
        if subgroup then
            v.subgroup = subgroup .. "-big"
        else
            print("No subgroup found for " .. v.name)
        end
        v.name = v.name .. "-big"

        local cat_list1 = data.raw.furnace["electric-furnace"]["crafting_categories"]
        local cat_list2 = data.raw["assembling-machine"]["assembling-machine-3"]["crafting_categories"]
        local cat_list3 = data.raw["assembling-machine"]["chemical-plant"]["crafting_categories"]

        -- Big furnace recipes
        if inlist(v.category, cat_list1) then
            v.category = "big-smelting"
            data.raw.recipe[v.name .. "-big"] = v

        -- Big assembly recipes
        -- nil category means the same as "crafting"
        elseif v.category == nil or inlist(v.category, cat_list2) or inlist(v.category, cat_list3) then
            v.category = "big-recipe"
            data.raw.recipe[v.name .. "-big"] = v
        end
    end
end

recipeSetup()