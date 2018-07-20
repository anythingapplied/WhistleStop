-- Adds big items to list of productivity module usable items
local function productivityFix()
    seen = {} -- ensures you don't fix the same unique table multiple times
    for _, module in pairs(data.raw.module) do
        if module.limitation and not seen[module.limitation] then
            seen[module.limitation] = true
            for _, allowedRecipe in pairs(util.table.deepcopy(module.limitation)) do
                if data.raw.recipe[allowedRecipe .. "-big"] then
                    table.insert(module.limitation, allowedRecipe .. "-big")
                end
            end
        end
    end
end

productivityFix()