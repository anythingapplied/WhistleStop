-- Provides spawn function which checks for valid spawn location and requests spawning
require("scripts.spawnFactory")
-- Handles big machine spawn events with its loaders
require("scripts.controlSpawnEvent")

--TODO: Test game with Multi-Force PvP games?
--TODO: Item-group hide from players
--TODO: Balancing: Crafting speed, power, pollution, recipe factor
--TODO: Balancing: Rarer as distance gets further? Multiple types of machines based on distance? Tech to enhance machines?
--TODO: helmod doesn't recognize productivity modules as valid for big iron recipe

local DEBUG = false --used for debug, users should not enable

-- Stat Tracking
global.whistlestats = {furnace_count=0, assembly_count=0, valid_chunk_count=0}
global.whistlelocations = {{x=0,y=0}}  -- fake location at spawn to prevent ones close to starting area

-- Function that will return true 'percent' of the time.
function probability(percent)
    return math.random() <= percent
end

-- Returns true of no big structures within whistle-min-distances
function distanceOkay(a)
    for k,v in pairs(global.whistlelocations) do
        if (a.x-v.x)^2+(a.y-v.y)^2 < settings.global["whistle-min-distance"].value^2 then
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
        

        local assembly_to_furnace_ratio = 1.2  -- How many assembly machines you want per furnace spawn

        if probability(1/(1+assembly_to_furnace_ratio)) then
            -- Spawn big furnace
            if DEBUG then
                game.print("A big furnace spawn attempt at " .. center.x .. "," .. center.y .. " (" .. global.whistlestats.furnace_count .. "/" .. global.whistlestats.valid_chunk_count .. ")")
            end

            spawn(center, e.surface, "big-furnace")
        else
            -- Spawn big assembly machine
            if DEBUG then
                game.print("A big assembly machine spawn attempt at " .. center.x .. "," .. center.y .. " (" .. global.whistlestats.assembly_count .. "/" .. global.whistlestats.valid_chunk_count .. ")")
            end

            spawn(center, e.surface, "big-assembly")
        end
    end
)

script.on_init(
    function()
        math.randomseed(game.surfaces[1].map_gen_settings.seed) --set the random seed to the map seed, so ruins are the same-ish with each generation.
    end
)