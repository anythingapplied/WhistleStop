-- Adds 50x recipes versions to each technology
require('luaMacros')

function processTech(tech, techeffects)
    -- Checks an indivdual technology's effects for recipes to unlock adding the big version recipe when found
    local valid_categories = {"crafting", "advanced-crafting", "crafting-with-fluid", "chemistry", "smelting"}
    for k2,v2 in pairs(techeffects) do
        if v2.type == "unlock-recipe" then
            cat = data.raw.recipe[v2.recipe].category
            if cat == nil or inlist(cat, valid_categories) then
                table.insert(data.raw.technology[tech].effects, {recipe=v2.recipe .. "-big", type="unlock-recipe"})
            end
        end
    end
end

function techSetup()
    -- Cycles through techs adding unlocks for big recipes versions
    for k,v in pairs(data.raw.technology) do
        if v.effects ~= nil then
            veffects = copy(v.effects)
            processTech(k, veffects)
        end
    end
end

techSetup()