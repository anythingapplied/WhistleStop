-- Provides spawn function which checks for valid spawn location and requests spawning
require("scripts.spawnFactory")
-- Handles big machine spawn events with its loaders
require("scripts.controlSpawnEvent")

DEBUG = true -- Used for debug, users should not enable
local debugCount = 0 -- Stops debugging messages 
local debugType = "Screen" -- "File" to output to .log, anything else to output to screen

-- Writes to the final debug output method based on type selection
local function debugWriteType(text)
    if debugType == "File" then
        game.write_file("whistlestop_debug.log", text, true)
    else
        game.print(text)
    end
end

-- Debug writer for calling elsewhere in the program
function debugWrite(text)
    if DEBUG then
        debugCount = debugCount + 1
        if debugCount < 100 then
            debugWriteType(text)
        elseif debugCount == 100 then 
            debugWriteType("Message count at 100, logging stopped")
        end
    end
end

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
local function distanceOkay(a)
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

script.on_event(defines.events.on_chunk_generated,
    function (e)
        -- Probability adjusts based on previous success.  Will spawn more if lots are being blocked by ore and water.
        local prob = (20 + global.whistlestats.valid_chunk_count) / (10 + global.whistlestats["big-furnace"] + global.whistlestats["big-assembly"]) / 400
        if probability(prob) then -- Initial probability filter to give the map a more random spread
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
            debugWrite("Creating buffer point at (" .. center.x .. "," .. center.y .. ")")
            addPoint(center)
            return
        end

        spawn(center, e.surface)
        
        debugWrite("Spawned " .. global.whistlestats["big-furnace"] + global.whistlestats["big-assembly"] .. "/" .. global.whistlestats.valid_chunk_count  .. " with probability " .. prob)
    end
)

script.on_init(
    function()
        math.randomseed(game.surfaces[1].map_gen_settings.seed) --set the random seed to the map seed, so ruins are the same-ish with each generation.
        
        -- Tracks location of big factory and or buffer locations, starting with a buffer location at spawn
        global.whistlelocations = {{x=0, y=0, mindist=2 * settings.global["whistle-min-distance"].value}}

        -- Stat Tracking
        global.whistlestats = {}
        global.whistlestats["big-furnace"] = 0
        global.whistlestats["big-assembly"] = 0
        global.whistlestats.valid_chunk_count = 0
    end
)