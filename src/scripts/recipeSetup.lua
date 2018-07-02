-- Creates 50x versions of each recipe from selected categories
require("luaMacros")
local inspect = require("inspect")

-- List of factors to try in case of ingredient limitations or stacksize limitations
local factor_list = {50, 40, 30, 20, 10, 5, 2, 1}

-- Game crashes if ingredient amount is higher than this
local maxIngredientCount = 65535

-- Output size maximum for fluid, 100 x (base_area=10)
local maxFluidBox = 1000

-- Lookup table for finding subgroup and stack_size which can be in various locations in data.raw
local dataRawLookup = {}
for k,v in pairs(data.raw) do
    for k2,v2 in pairs(v) do
        if dataRawLookup[k2] == nil then
            dataRawLookup[k2] = {}
        end
        if v2.subgroup ~= nil then
            dataRawLookup[k2].subgroup = v2.subgroup
        end
        if v2.stack_size ~= nil then
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
    return 1
end

local function getStackSize(item)
    if dataRawLookup[item].stack_size ~= nil then
        return dataRawLookup[item].stack_size
    end
    print("No stacksize found for " .. item)
    return 100
end

-- Multiplies energy required and result count by a set factor with default fallback
local function setFactor(value, factor, default)
    if value == nil then
        return default * factor
    end
    return value * factor
end

-- Figures out max ingredient amount to ensure nothing goes over the max allowable of 65535
local function maxRecipeAmount(ary)
    local maxAmount = 0
    for k,v in pairs(ary) do
        if v.amount ~= nil then
            if v.amount > maxAmount then
                maxAmount = v.amount
            end
        elseif v.amount_max ~= nil then
            if v.amount_max > maxAmount then
                    maxAmount = v.amount_max
            end
        elseif v[2] ~= nil then
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
        if v.amount == nil then
            if v[2] ~= nil then
                minAmount = math.min(getStackSize(v[1]) / v[2], minAmount)
            end
        else
            if v.type == "fluid" then
                minAmount = math.min(maxFluidBox / v.amount, minAmount)
            else
                minAmount = math.min(getStackSize(v.name) / v.amount, minAmount)
            end
        end
    end
    return minAmount
end

-- Multiplies the ingredient counts by a set factor
local function setFactorIngredients(ary, factor)
    for k,v in pairs(ary) do
        if v.amount ~= nil then
            v.amount = v.amount * factor
        elseif v.amount_max ~= nil then
            v.amount_max = v.amount_max * factor
            v.amount_min = v.amount_min * factor
        elseif v[2] ~= nil then
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
    if recipe.subgroup ~= nil then
        return recipe.subgroup
    end
    local product
    if recipe.result ~= nil then
        product = recipe.result
    elseif recipe.results ~= nil and #recipe.results == 1 then
        product = recipe.results[1].name
    elseif recipe.normal ~= nil and recipe.normal.result ~= nil then
        product = recipe.normal.result
    elseif recipe.normal ~= nil and recipe.normal.results ~= nil and #recipe.normal.results == 1 then
        product = recipe.normal.results[1].name
    elseif recipe.main_product ~= nil then
        product = recipe.main_product
    else
        print("No main product found " .. recipename .. inspect(recipe))
        return
    end
    if dataRawLookup[product] ~= nil then
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
    if recipe.result ~= nil then
        if recipe.result_count ~= nil then
            min_factor2 = getStackSize(recipe.result) / recipe.result_count
        else
            min_factor2 = getStackSize(recipe.result)
        end
    else
        min_factor2 = maxRecipeOutputFactor(recipe.results)
    end

    local factor = findfactor(math.min(min_factor1, min_factor2))

    recipe.energy_required = setFactor(recipe.energy_required, factor, 0.5)
    if recipe.result ~= nil then
        recipe.result_count = setFactor(recipe.result_count, factor, 1)
    else
        recipe.results = setFactorIngredients(recipe.results, factor)
    end
    recipe.ingredients = setFactorIngredients(recipe.ingredients, factor)
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
            v.subgroup = subgroup .. "-big"
        else
            print("No subgroup found for " .. v.name)
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