--checks for spawning validity and if valid, clears space for the spawn
local function clearArea(center, surface)
    for y = center.y-8, center.y+8 do --fail if any water in area
        for x = center.x-8, center.x+8 do
            if surface.get_tile(x, y).name == "water" or surface.get_tile(x, y).name == "deepwater" then
                debugWrite("Factory at (" .. center.x .. "," .. center.y .. ") overlaps with water.  Canceling attempt.")
                return false
            end
        end
    end

    local area = {{center.x-8.8,center.y-8.8},{center.x+8.8,center.y+8.8}}
    -- Ensures factory won't overlap with resources or cliffs
    for index, entity in pairs(surface.find_entities(area)) do
        if entity.valid and entity.type ~= "tree" then
            debugWrite("Factory at (" .. center.x .. "," .. center.y .. ") overlaps with ores, cliffs, or other non-tree entities.  Canceling attempt.")
            return false
        end
    end

    -- If only obstacle is trees, remove the trees
    for index, entity in pairs(surface.find_entities(area)) do
        if entity.valid and entity.type == "tree" then
            entity.destroy()
        end
    end

    debugWrite("Factory at (" .. center.x .. "," .. center.y .. ") Area clear! Good to go!")
    return true
end

function spawn(center, surface)
    local force = game.forces.player
    local assembly_to_furnace_ratio = 1.2  -- How many assembly machines you want per furnace spawn

    if clearArea(center, surface) then
        addPoint(center)

        if probability(1/(1+assembly_to_furnace_ratio)) then
            entityname = "big-furnace"
        else
            entityname = "big-assembly"
        end
        
        global.whistlestats[entityname] = (global.whistlestats[entityname] or 0) + 1
        local entity = surface.create_entity{name = entityname, position = {center.x, center.y}, force = force}
        local event = {created_entity=entity, player_index=1}
        debugWrite("Creating factory at (" .. center.x .. "," .. center.y .. ")")
        on_built_event(event)
    end
end
