
Updates = {}
local current_version = 1

Updates.init = function()
	global.update_version = current_version
end

Updates.run = function()
    global.update_version = global.update_version or 0
	if global.update_version <= 1 then
        -- Location tracking
        global.whistlelocations = global.whistlelocations or {} -- Old
        global.whistlestops = global.whistlestops or {} -- New
        global.bufferpoints = global.bufferpoints or {} -- New
        global.bufferpoints2 = global.bufferpoints2 or {} -- New

        local minSetting = settings.global["whistle-min-distance"].value
        -- Migration to new location tracking
        for k,v in pairs(global.whistlelocations) do

            distance_factor = math.max(0, math.min(1, (v.mindist - minSetting)/minSetting))
            center = {x=v.x, y=v.y}
            addBuffer(center, 1, distance_factor)

            local entity = nil
            for _, entity_found in pairs(surface.find_entities_filtered{area={{center.x-1, center.y-1},{center.x+1, center.y+1}}, name={"big-furnace", "big-assembly"}}) do
                entity = entity_found
            end

            if entity and entity.valid then
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
    end
	global.update_version = current_version
end

return Updates