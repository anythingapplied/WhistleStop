-- Provides spawn function which checks for valid spawn location and requests spawning
require("scripts.spawnFactory")
-- Handles big machine spawn events with its loaders
require("scripts.controlSpawnEvent")

DEBUG = true --used for debug, users should not enable

-- Stat Tracking
global.whistlestats = {}
global.whistlestats["big-furnace"] = 0
global.whistlestats["big-assembly"] = 0
global.whistlestats.valid_chunk_count = 0

-- Tracks location of big factory and or buffer locations, starting with a buffer location at spawn
global.whistlelocations = {{x=0, y=0, mindist=2 * settings.global["whistle-min-distance"].value}}

-- Registers a new location of a big factory or buffer location with a random minimum distance threshhold
function addPoint(center)
    local minSetting = settings.global["whistle-min-distance"].value
    table.insert(global.whistlelocations, {x=center.x, y=center.y, mindist=math.random(minSetting, 2*minSetting)})
end

-- Function that will return true 'percent' of the time.
function probability(percent)
    return math.random() <= percent
end

-- Returns true if no big structures within minimum distance threshholds
function distanceOkay(a)
    for k,v in pairs(global.whistlelocations) do
        if v.mindist == nil then
            local minSetting = settings.global["whistle-min-distance"].value
            v.mindist = math.random(minSetting, 2*minSetting)
        end
        if (a.x-v.x)^2 + (a.y-v.y)^2 < v.mindist^2 then
            return false
        end
    end
    return true
end

script.on_event({defines.events.on_chunk_generated},
    function (e)
        if probability(0.005) then -- Initial probability filter to give the map a more random spread
            return
        end
        
        -- Chunk center plus random variance so they aren't always chunk aligned
        local center = {
            x=(e.area.left_top.x+e.area.right_bottom.x)/2 + math.random(-8,8),
            y=(e.area.left_top.y+e.area.right_bottom.y)/2 + math.random(-8,8)}

        if not distanceOkay(center) then -- too close to other big structure
            return
        end

        global.whistlestats.valid_chunk_count = global.whistlestats.valid_chunk_count + 1

        if probability(0.3) then -- Insert fake big factory placeholder to cause more spreading out
            addPoint(center)
            return
        end

        spawn(center, e.surface)
    
    end
)

script.on_init(
    function()
        math.randomseed(game.surfaces[1].map_gen_settings.seed) --set the random seed to the map seed, so ruins are the same-ish with each generation.
    end
)