-- Adds big items to list of productivity module usable items
require("luaMacros")

local function productivityFix()
    for _, module in pairs(data.raw.module) do
        if module.limitation then
            for _, allowedRecipe in pairs(util.table.deepcopy(module.limitation)) do
                if data.raw.recipe[allowedRecipe .. "-big"] then
                    table.insert(module.limitation, allowedRecipe .. "-big")
                end
            end
        end
    end
end

productivityFix()