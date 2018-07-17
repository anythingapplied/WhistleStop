--checks for spawning validity and if valid, clears space for the spawn

inspect = require("inspect")

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

function spawn(center, surface, entityname)
    local force = game.forces.player

    if entityname ~= "big-refinery" then
        -- Move center for smaller buildings, so that it won't always be in the exact center of chunks
        -- Still making sure not to cross the edge of the chunk
        center = {x=center.x - 1 + math.random(-3,4)*2, y=center.y - 1 + math.random(-3,4)*2}
    end
    if surface.can_place_entity{name=entityname, position=center, force=force} and clearArea(center, surface) then
        
        global.whistlestats[entityname] = global.whistlestats[entityname] + 1
        
        local entity = surface.create_entity{name=entityname, position=center, force=force}
        table.insert(global.whistlestops, {position=center, type=entityname, entity=entity, surface=surface, direction=entity.direction, recipe=nil, tag=nil})
        table.insert(global.bufferpoints, {position=center, surface_index=surface.index, distance_factor=math.random()})

        local event = {created_entity=entity, player_index=1}
        debugWrite("Creating factory at (" .. center.x .. "," .. center.y .. ")")
        on_built_event(event)
    end
end
