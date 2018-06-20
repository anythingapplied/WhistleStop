--checks for spawning validity and if valid, clears space for the spawn
function clearArea(center, surface)
    for y = center.y-8, center.y+8 do --fail if any water in area
        for x = center.x-8, center.x+8 do
            if surface.get_tile(x, y).name == "water" or surface.get_tile(x, y).name == "deepwater" then
                return false
            end
        end
    end

    local area = {{center.x-8.8,center.y-8.8},{center.x+8.8,center.y+8.8}}
    -- Ensures factory won't overlap with resources or cliffs
    for index, entity in pairs(surface.find_entities(area)) do
        if entity.valid and entity.type ~= "tree" then
            return false
        end
    end

    -- If only obstacle is trees, remove the trees
    for index, entity in pairs(surface.find_entities(area)) do
        if entity.valid and entity.type == "tree" then --don't destroy ores, cliffs might become invalid after we destroy their neighbours, so check .valid
            entity.destroy()
        end
    end

    return true
end

function spawn(center, surface, itemname)
    local ce = surface.create_entity --save typing
    local force = game.forces.player

    if clearArea(center, surface) then
        if itemname == "big-furnace" then
            global.whistlestats.furnace_count = global.whistlestats.furnace_count + 1
            local en = ce{name = "big-furnace", position = {center.x, center.y}, force = force}
            local event = {created_entity=en, player_index=1}
            script.raise_event(defines.events.on_built_entity, event)
            en.minable = false
            --en.destructable = false
        elseif itemname == "big-assembly" then
            global.whistlestats.assembly_count = global.whistlestats.assembly_count + 1
            local en = ce{name = "big-assembly", position = {center.x, center.y}, force = force}
            local event = {created_entity=en, player_index=1}
            script.raise_event(defines.events.on_built_entity, event)
            en.minable = false
            --en.destructable = false
        elseif DEBUG then
            game.print("Error: itemname not recognized")
        end
    end
end
