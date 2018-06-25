-- Creates 50x versions of each recipe from selected categories
require('luaMacros')

-- Multiplies energy required and result count by a set factor with default fallback
function setFactor(value, default)
    if value == nil then
        return default * factor
    end
    return value * factor
end

-- Multiplies the ingredient counts by a set factor
function setFactorIngredients(ary)
    for k,v in pairs(ary) do
        if v.amount == nil then
            v[2] = v[2] * factor
        else
            v.amount = v.amount * factor
        end
    end
    return ary
end

-- Find the subgroup for a given item
function findSubgroup(recipename)
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

-- Adjusts counts on all variables
function setValues(recipe)
    recipe.energy_required = setFactor(recipe.energy_required, 0.5)
    if recipe.result ~= nil then
        recipe.result_count = setFactor(recipe.result_count, 1)
    else
        recipe.results = setFactorIngredients(recipe.results)
    end
    recipe.ingredients = setFactorIngredients(recipe.ingredients)
end

function recipeSetup()
    local recipe2 = copy(data.raw.recipe)
    -- Cycles through recipes adding big version to recipe list
    for k,v in pairs(recipe2) do
        if v.normal ~= nil then --Recipe is split into normal/expensive
            setValues(v.normal)
            setValues(v.expensive)
        else
            setValues(v)
        end

        v.subgroup = findSubgroup(v.name) .. "-big"
        v.name = v.name .. "-big"

        local valid_assembly_categories = {"crafting", "advanced-crafting", "crafting-with-fluid", "chemistry"}

        -- Big furnace recipes
        if v.category == "smelting" then
            v.category = "big-smelting"
            data.raw.recipe[k .. "-big"] = v
        
        -- Big assembly recipes
        -- nil category means the same as "crafting"
        elseif v.category == nil or inlist(v.category, valid_assembly_categories) then
            v.category = "big-recipe"
            data.raw.recipe[k .. "-big"] = v
        end
    end
end

recipeSetup()