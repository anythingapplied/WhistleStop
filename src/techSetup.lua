-- Adds 50x recipes versions to each technology
function techSetup()
    -- Cycles through techs adding unlocks for big recipes versions
    for k,v in pairs(data.raw.technology) do
        if v.effects ~= nil then
            veffects = copy(v.effects)
            for k2,v2 in pairs(veffects) do
                if v2.type == "unlock-recipe" then
                    cat = data.raw.recipe[v2.recipe].category
                    if cat == nil or cat == "crafting" or cat == "advanced-crafting" or cat == "crafting-with-fluid" or cat == "chemistry" or cat == "smelting" then
                        table.insert(data.raw.technology[k].effects, {recipe=v2.recipe .. "-big", type="unlock-recipe"})
                    end
                end
            end
        end
    end
end

return techSetup