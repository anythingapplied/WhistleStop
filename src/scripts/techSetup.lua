-- Adds 50x recipes versions to each technology
require("luaMacros")

function processTech(tech, techeffects)
    -- Checks an indivdual technology's effects for recipes to unlock adding the big version recipe when found
    local cat_list1 = data.raw["assembling-machine"]["assembling-machine-3"]["crafting_categories"]
    local cat_list2 = data.raw.furnace["electric-furnace"]["crafting_categories"]
    local cat_list3 = data.raw["assembling-machine"]["chemical-plant"]["crafting_categories"]
    
    for k2,v2 in pairs(techeffects) do
        if v2.type == "unlock-recipe" then
            cat = data.raw.recipe[v2.recipe].category
            if cat == nil or inlist(cat, cat_list1) or inlist(cat, cat_list2) or inlist(cat, cat_list3) then
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