-- Provides spawn function which checks for valid spawn location and requests spawning
require("spawnFactory")
-- Handles big machine spawn events with its loaders
require("controlSpawnEvent")

--TODO: Test game with Multi-Force PvP games?
--TODO: Minimum distances from each other? May break seed based generation... actually seed based is already broken
-- because it depends on chunk load order
--TODO: Item-group hide from players
--TODO: Make animation speed slower?
--TODO: Check if furnace loaders can be made more visible
--TODO: Balancing: Crafting speed, power, pollution, recipe factor
--TODO: Balancing: Rarer as distance gets further? Multiple types of machines based on distance? Tech to enhance machines?

local DEBUG = false --used for debug, users should not enable

--Stat Tracking
global.whistlestats = {furnace_count=0, assembly_count=0, valid_chunk_count=0}

--function that will return true 'percent' of the time.
function probability(percent)
    return math.random() <= percent
end

script.on_event({defines.events.on_chunk_generated},
    function (e)

        local center = {x=(e.area.left_top.x+e.area.right_bottom.x)/2, y=(e.area.left_top.y+e.area.right_bottom.y)/2}
        local min_distance = settings.global["whistle-min-distance-from-spawn"].value
        if math.abs(center.x) < min_distance and math.abs(center.y) < min_distance then return end --too close to spawn

        global.whistlestats.valid_chunk_count = global.whistlestats.valid_chunk_count + 1
        --random variance so they aren't always chunk aligned
        center.x = center.x + math.random(-8,8)
        center.y = center.y + math.random(-8,8)

        if probability(settings.global["whistle-furnace-chance"].value) then
            --spawn big furnace
            if DEBUG then
                game.print("A big furnace spawn attempt at " .. center.x .. "," .. center.y .. " (" .. global.whistlestats.furnace_count .. "/" .. global.whistlestats.valid_chunk_count .. ")")
            end

            spawn(center, e.surface, "big-furnace")
        elseif probability(settings.global["whistle-assembly-chance"].value) then
            --spawn big assembly machine
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