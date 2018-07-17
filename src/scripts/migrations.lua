require("controlSpawnEvent")
-- Contains migration script for global and game variables (which can't be affected in normal migrations)

function migration_to_1()
    debugWrite("Begin 0.1.0 migration")
    -- Location tracking
    global.whistlelocations = global.whistlelocations or {} -- Old
    global.whistlestops = global.whistlestops or {} -- New
    global.bufferpoints = global.bufferpoints or {} -- New

    local minSetting = settings.global["whistle-min-distance"].value
    -- Migration to new location tracking
    for k,v in pairs(global.whistlelocations) do

        distance_factor = math.max(0, math.min(1, (v.mindist - minSetting)/minSetting))
        center = {x=v.x, y=v.y}
        table.insert(global.bufferpoints, {position=center, surface_index=game.surfaces["nauvis"].index, distance_factor=distance_factor})

        local entity = nil
        for _, entity_found in pairs(surface.find_entities_filtered{area={{center.x-1, center.y-1},{center.x+1, center.y+1}}, name={"big-furnace", "big-assembly"}}) do
            entity = entity_found
        end

        if entity then
            table.insert(global.whistlestops, {position=center, type=entity.name, entity=entity, surface=entity.surface, direction=entity.direction, recipe=nil, tag=nil})
        else
            clean_up(entity.surface, center)
        end
    end

    -- Stat Tracking
    global.whistlestats = global.whistlestats or {}
    global.whistlestats["big-furnace"] = global.whistlestats["big-furnace"] or 0
    global.whistlestats["big-assembly"] = global.whistlestats["big-assembly"] or 0
    global.whistlestats["big-refinery"] = global.whistlestats["big-refinery"] or 0
    global.whistlestats["buffer"] = global.whistlestats["buffer"] or 
        (math.max(#global.whistlelocations, #global.whistlestops) - global.whistlestats["big-furnace"] - global.whistlestats["big-assembly"] - global.whistlestats["big-refinery"])

    global.whistlelocations = nil
    game.print("Whistle Stop Factories migration complete")
end