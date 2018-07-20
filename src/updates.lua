-- Lists points used to determine if a new factory is far enough away from previous factories
require("scripts.bufferPoints")

-- Handles big machine spawn events with its loaders
require("scripts.controlSpawnEvent")

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

        local minSetting = settings.global["whistle-min-distance"].value
        -- Migration to new location tracking
        for k,v in pairs(global.whistlelocations) do
            local area = {{v.x-8.8, v.y-8.8}, {v.x+8.8, v.y+8.8}}
            for _, entity in pairs(game.surfaces[1].find_entities_filtered{area=area, name="express-loader"}) do
                if not entity.destructible and not entity.minable then -- Destroys all old-style loaders
                    entity.destroy()
                end
            end
        end

        for k,v in pairs(global.whistlelocations) do
            distance_factor = math.max(0, math.min(1, (v.mindist - minSetting)/minSetting))
            center = {x=v.x, y=v.y}
            addBuffer(center, 1, distance_factor)

            for _, entity in pairs(game.surfaces[1].find_entities_filtered{area={{center.x-1, center.y-1},{center.x+1, center.y+1}}, name={"big-furnace", "big-assembly"}}) do
                if entity and entity.valid then
                    table.insert(global.whistlestops, {position=center, type=entity.name, entity=entity, surface=entity.surface, direction=entity.direction, recipe=nil, tag=nil})
                    on_built_event({created_entity=entity}) -- Places new loaders back down
                end
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