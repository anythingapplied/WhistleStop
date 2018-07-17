-- Checks in val is in the given list
function inlist(value, scanlist)
    if type(scanlist) ~= "table" then return end
    for k,v in pairs(scanlist) do
        if value == v then
            return true
        end
    end
    return false
end

-- Checks all locations for potential main product results
local function checkForProduct(recipe)
    if type(recipe) ~= "table" then
        return
    elseif recipe.result then
        return recipe.result
    elseif type(recipe.results) == "table" and #recipe.results == 1 and type(recipe.results[1]) == "table" and recipe.results[1].name then
        return recipe.results[1].name
    elseif type(recipe.results) == "table" and #recipe.results == 1 and type(recipe.results[1]) == "table" and recipe.results[1][1] then
        return recipe.results[1][1]
    end
end

-- Search all possible locations where the "main product" where recipes inherit their subgroup can be found
function checkForProductAll(recipe)
    if type(recipe) ~= "table" then
        return
    end
    local product = checkForProduct(recipe)
    product = product or checkForProduct(recipe.normal)
    product = product or checkForProduct(recipe.expensive)
    product = product or recipe.main_product
    return product
end