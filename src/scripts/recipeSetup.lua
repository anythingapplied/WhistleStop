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
for _, class in pairs(data.raw) do
    for className, classData in pairs(class) do
        dataRawLookup[className] = dataRawLookup[className] or {}
        if classData.subgroup then
            dataRawLookup[className].subgroup = classData.subgroup
        end
        if classData.stack_size then
            dataRawLookup[className].stack_size = classData.stack_size
        end
    end
end

-- Provides the lowest value from factor_list that works
local function findfactor(min_value)
    for _, factor in pairs(factor_list) do
        if factor <= min_value then
            return factor
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
local function maxRecipeAmount(ingredients)
    local maxAmount = 0
    for _, ingredient in pairs(ingredients) do
        if ingredient.amount then
            if ingredient.amount > maxAmount then
                maxAmount = ingredient.amount
            end
        elseif ingredient.amount_max then
            if ingredient.amount_max > maxAmount then
                maxAmount = ingredient.amount_max
            end
        elseif ingredient[2] then
            if ingredient[2] > maxAmount then
                maxAmount = ingredient[2]
            end
        else
            print("Recipe with no amount registered " .. inspect(ingredient))
        end
    end
    return maxAmount
end

-- Figures out max result amount to ensure the machine doesn't try to output more than the stacksize
local function maxRecipeOutputFactor(recipeOutputs)
    local minAmount = factor_list[1]
    for _, recipeOutput in pairs(recipeOutputs) do
        if recipeOutput.amount then
            if recipeOutput.type == "fluid" then
                minAmount = math.min(maxFluidBox / recipeOutput.amount, minAmount)
            else
                minAmount = math.min(getStackSize(recipeOutput.name) / recipeOutput.amount, minAmount)
            end
        else
            if recipeOutput[2] then
                minAmount = math.min(getStackSize(recipeOutput[1]) / recipeOutput[2], minAmount)
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

    -- Final factor used to scale all values of the recipe
    local factor = findfactor(math.min(min_factor1, min_factor2))

    -- Recipe ingredient adjustment
    recipe.ingredients = setFactorIngredients(recipe.ingredients, factor)

    -- Recipe time adjustment
    recipe.energy_required = (recipe.energy_required or 0.5) * factor

    -- Recipe output adjustment
    if recipe.result then
        recipe.result_count = (recipe.result_count or 1) * factor
    else
        recipe.results = setFactorIngredients(recipe.results, factor)
    end
end

local function recipeSetup()
    -- Cycles through recipes adding big version to recipe list
    for _, recipe in pairs(copy(data.raw.recipe)) do
        if recipe.normal then -- Recipe is split into normal/expensive
            setValues(recipe.normal)
            setValues(recipe.expensive)
        else
            setValues(recipe)
        end

        local subgroup = findSubgroup(recipe.name)
        if subgroup then
            recipe.subgroup = subgroup .. "-big"
        else
            print("No subgroup found for " .. recipe.name)
        end
        recipe.name = recipe.name .. "-big"

        local cat_list1 = data.raw.furnace["electric-furnace"]["crafting_categories"]
        local cat_list2 = data.raw["assembling-machine"]["assembling-machine-3"]["crafting_categories"]
        local cat_list3 = data.raw["assembling-machine"]["chemical-plant"]["crafting_categories"]

        -- Big furnace recipes
        if inlist(recipe.category, cat_list1) then
            recipe.category = "big-smelting"
            data.raw.recipe[recipe.name .. "-big"] = recipe

        -- Big assembly recipes
        -- nil category means the same as "crafting"
        elseif recipe.category == nil or inlist(recipe.category, cat_list2) or inlist(recipe.category, cat_list3) then
            recipe.category = "big-recipe"
            data.raw.recipe[recipe.name .. "-big"] = recipe
        end
    end
end

recipeSetup()