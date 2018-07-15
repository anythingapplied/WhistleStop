-- Provides spawn function which checks for valid spawn location and requests spawning
require("scripts.spawnFactory")
-- Handles big machine spawn events with its loaders
require("scripts.controlSpawnEvent")

DEBUG = true -- Used for debug, users should not enable
local debugCount = 0 -- Stops debugging messages
local debugMaxCount = 0 -- Maximum debug messages, 0 for infinite
local debugType = "Screen" -- "File" to output to a .log file, "Terminal" to output to terminal, anything else to output to in-game console

-- Writes to the final debug output method based on type selection
local function debugWriteType(text)
    if debugType == "File" then
        game.write_file("whistlestop_debug.log", text, true)
    elseif debugType == "Terminal" then
        log(text)
    else
        game.print(text)
    end
end

-- Debug writer for calling elsewhere in the program
function debugWrite(text)
    if DEBUG then
        debugCount = debugCount + 1
        if debugMaxCount == 0 or debugCount < debugMaxCount then
            debugWriteType(text)
        elseif debugCount == debugMaxCount then 
            debugWriteType("Message count at " .. debugMaxCount .. ", logging stopped")
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

local function positionRandomMove(position, amount)
    return {x=position.x + math.random(-amount, amount), y=position.y + math.random(-amount, amount)}
end

-- The ideal propotions of different kinds of machine for end game
local goal_proportion = {}
goal_proportion["buffer"] = 30
goal_proportion["big-furnace"] = 35
goal_proportion["big-assembly"] = 35
goal_proportion["big-refinery"] = 2

-- Offsets to trick the game into thinking your starting amounts of machines are at certain levels.
-- Higher numbers will push spawning off until more factories are discovered, negative numbers will spawn more earlier
local initial_boost = {}
initial_boost["buffer"] = 0
initial_boost["big-furnace"] = 0
initial_boost["big-assembly"] = 0
initial_boost["big-refinery"] = 0

-- Calculate sums of all sets of points for probability calculation
local total_proportion = 0
local total_boost = 0
for k,v in pairs({'buffer', 'big-furnace', 'big-assembly', 'big-refinery'}) do
    total_proportion = total_proportion + goal_proportion[v]
    total_boost = total_boost + initial_boost[v]
end

script.on_event(defines.events.on_chunk_generated,
    function(event)
        -- Probability adjusts based on previous success.  Will attempt more spawns if lots are being blocked by ore and water.
        local prob = (20 + global.whistlestats.valid_chunk_count) / (10 + global.whistlestats["big-furnace"] + global.whistlestats["big-assembly"]) / 10
        if not probability(prob) then -- Initial probability filter to give the map a more random spread and reduce cpu work
            return
        end
        
        -- Chunk center plus random variance so they aren't always chunk aligned
        local center = {
            x=(event.area.left_top.x+event.area.right_bottom.x)/2,
            y=(event.area.left_top.y+event.area.right_bottom.y)/2}

        if not distanceOkay(center) then -- too close to other big structure
            return
        end

        global.whistlestats.valid_chunk_count = global.whistlestats.valid_chunk_count + 1

        -- Calculate sums of all sets of points for probability calculation
        local total_historical = 0
        for k,v in pairs({'buffer', 'big-furnace', 'big-assembly', 'big-refinery'}) do
            total_historical = total_historical + global.whistlestats[v]
        end

        -- Tries to make sure you'll have exactly you're ideal target by the time you hit goal_target number of machines
        -- and uses the distribution of what would need to be spawned between now and then as your probability of spawning each
        local goal_target = (total_historical + total_boost) + goal_addition
        local adjusted_probability = {}
        local adjusted_probability_total = 0
        for k,v in pairs({'buffer', 'big-furnace', 'big-assembly', 'big-refinery'}) do
            adjusted_probability[v] = goal_target * goal_proportion[v] / total_proportion - global.whistlestats[v] - initial_boost[v]
            adjusted_probability_total = adjusted_probability_total + adjusted_probability[v]
        end
        
        local selection_var = math.random()
        if selector_var <= adjusted_probability["buffer"]/adjusted_probability_total then
            debugWrite("Creating buffer point at (" .. center.x .. "," .. center.y .. ")")
            addPoint(center)
        elseif selector_var <= (adjusted_probability["buffer"] + adjusted_probability["big-furnace"])/adjusted_probability_total then
            spawn(positionRandomMove(center, 7) , e.surface, "big-furnace")
        elseif selector_var <= (adjusted_probability["buffer"] + adjusted_probability["big-furnace"] + adjusted_probability["big-assembly"])/adjusted_probability_total then
            spawn(positionRandomMove(center, 7), e.surface, "big-assembly")
        else
            spawn(positionRandomMove(center, 2), e.surface, "big-refinery")
        end
    end
)

script.on_init(
    function()
        math.randomseed(game.surfaces[1].map_gen_settings.seed) --set the random seed to the map seed, so ruins are the same-ish with each generation.
        
        -- Tracks location of big factory and or buffer locations, starting with a buffer location at spawn
        global.whistlelocations = {{x=0, y=0, mindist=2 * settings.global["whistle-min-distance"].value}}
        global.whistlestops = {}

        -- Stat Tracking
        global.whistlestats = {}
        global.whistlestats["buffer"] = 0
        global.whistlestats["big-furnace"] = 0
        global.whistlestats["big-assembly"] = 0
        global.whistlestats["big-refinery"] = 0
        global.whistlestats.valid_chunk_count = 0
    end
)

script.on_nth_tick(10*60, 
    function(event)
        for k,v in pairs(global.whistlestops) do
            if not v.entity.valid then
                clean_up(v.surface, v.position)
            end
        end
    end
)

script.on_configuration_changed(
    function 
)