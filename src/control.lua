local inspect = require("inspect")

-- Provides spawn function which checks for valid spawn location and requests spawning
require("scripts.spawnFactory")

-- Handles big machine spawn events with its loaders
require("scripts.controlSpawnEvent")

-- Selects next spawn type using probability distribution
chooseNextSpawnType = require("scripts.chooseNextSpawnType")

-- Contains migration function for game and global variables
require("scripts.migrations")


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

-- Function that will return true 'percent' of the time.
function probability(percent)
    return math.random() <= percent
end

-- Returns true if no big structures within minimum distance threshholds
local function distanceOkay(point, surface_index)
    local minSetting = settings.global["whistle-min-distance"].value
    for k,v in pairs(global.bufferpoints) do
        if surface_index == v.surface_index then
            if (point.x - v.position.x)^2 + (point.y - v.position.y)^2 < (minSetting * (1 + v.distance_factor))^2 then
                return false
            end
        end
    end
    return true
end

script.on_event(defines.events.on_chunk_generated,
    function (event)
        if event.surface.index ~= 1 then  -- Only spawn on normal surface
            return
        end
        -- Probability adjusts based on previous success.  Will attempt more spawns if lots are being blocked by ore and water.
        local prob = (20 + global.whistlestats.valid_chunk_count) / (10 + global.whistlestats["big-furnace"] + global.whistlestats["big-assembly"]) / 10
        if not probability(prob) then -- Initial probability filter to give the map a more random spread and reduce cpu work
            return
        end

        global.whistlestats.valid_chunk_count = global.whistlestats.valid_chunk_count + 1
        
        -- Chunk center
        local center = {
            x=(event.area.left_top.x+event.area.right_bottom.x)/2,
            y=(event.area.left_top.y+event.area.right_bottom.y)/2}

        if not distanceOkay(center, event.surface.index) then -- too close to other big structure
            return
        end

        local nextSpawnType = chooseNextSpawnType()
        if nextSpawnType == "buffer" then
            debugWrite("Creating buffer point at (" .. center.x .. "," .. center.y .. ")")
            table.insert(global.bufferpoints, {position=center, surface_index=event.surface.index, distance_factor=math.random()})
        else
            debugWrite("Attempting " .. nextSpawnType .." point close to (" .. center.x .. "," .. center.y .. ")")
            spawn(center, event.surface, nextSpawnType)
        end
    end
)

script.on_init(
    function ()
        math.randomseed(game.surfaces[1].map_gen_settings.seed) --set the random seed to the map seed, so ruins are the same-ish with each generation.
        
        -- Tracks location of big factory and or buffer locations, starting with a buffer location at spawn
        global.bufferpoints = {{position={x=0, y=0}, surfaces=game.surfaces["nauvis"].index, distance_factor=1}}
        global.whistlestops = {}
        -- Specification:
            -- position=center
            -- type=entityname
            -- entity=entity
            -- surface=surface
            -- direction=entity.direction
            -- recipe=current recipe name
            -- tag=tag_number

        -- Stat Tracking
        global.whistlestats = {buffer=0, ["big-furnace"]=0, ["big-assembly"]=0, ["big-refinery"]=0, valid_chunk_count = 0}
    end
)

script.on_nth_tick(6*60, 
    function (event)
        for k,v in pairs(global.whistlestops) do

            -- Removes loaders for any entities that were destroyed by other mods without triggering destroy_entity event
            if not v.entity.valid then
                clean_up(v.surface, v.position)
                global.whistlestops[k] = nil
            end

            -- Creates tag for entities that have a set recipe
            local recipe = v.entity.get_recipe()
            if recipe then
                if recipe.name ~= v.recipe then
                    debugWrite("Recipe Change at (" .. v.position.x .. "," .. v.position.y .. ")")
                    v.recipe = recipe.name
                    if #recipe.products >= 1 then
                        local product = recipe.products[1]
                        for k2,v2 in pairs(v.entity.force.find_chart_tags(v.surface, {{v.position.x-1, v.position.y-1}, {v.position.x+1, v.position.y+1}})) do
                            v2.destroy()
                        end
                        local tag = v.entity.force.add_chart_tag(v.surface, {icon=product, position=v.position})
                        v.tag = tag.tag_number
                    end
                end
            else
                if v.recipe then -- recipe is now blank, but was set in previous scan, so delete tag
                    debugWrite("Recipe Removed at (" .. v.position.x .. "," .. v.position.y .. ")")
                    v.recipe = nil
                    for k2,v2 in pairs(v.entity.force.find_chart_tags(v.surface, {{v.position.x-1, v.position.y-1}, {v.position.x+1, v.position.y+1}})) do
                        v2.destroy()
                    end
                end
            end

            -- Checks for 
        end
    end
)

script.on_configuration_changed(
    function (configData)
        old_version = split(configData.mod_changes[script.mod_name].old_version, ".")
        if old_version[2] <= 0 then
            migration_to_1()
        end
    end
)