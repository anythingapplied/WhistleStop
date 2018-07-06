-- Adds 50x recipes versions to each technology
require("luaMacros")

local function techSetup()
    -- Cycles through techs adding unlocks for big recipes versions
    for k,v in pairs(data.raw.technology) do
        if v.effects then
            techeffects = util.table.deepcopy(v.effects)
            local cat_list1 = data.raw.furnace["electric-furnace"]["crafting_categories"]
            local cat_list2 = data.raw["assembling-machine"]["assembling-machine-3"]["crafting_categories"]
            local cat_list3 = data.raw["assembling-machine"]["chemical-plant"]["crafting_categories"]
            
            for _, effect in pairs(techeffects) do
                if effect.type == "unlock-recipe" then
                    cat = data.raw.recipe[effect.recipe].category or "crafting"
                    if inlist(cat, cat_list1) or inlist(cat, cat_list2) or inlist(cat, cat_list3) then
                        table.insert(data.raw.technology[k].effects, {recipe=effect.recipe .. "-big", type="unlock-recipe"})
                    end
                end
            end
        end
    end
end

techSetup()