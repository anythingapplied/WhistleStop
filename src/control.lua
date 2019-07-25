--serpent = require("serpent")

-- Provides spawn function which checks for valid spawn location and requests spawning
require("__WhistleStopFactories__.scripts.spawnFactory")

-- Handles big machine spawn events with its loaders
require("__WhistleStopFactories__.scripts.controlSpawnEvent")

-- Lists points used to determine if a new factory is far enough away from previous factories
require("__WhistleStopFactories__.scripts.bufferPoints")

-- Selects next spawn type using probability distribution
chooseNextSpawnType = require("__WhistleStopFactories__.scripts.chooseNextSpawnType")

-- Contains migration function for game and global variables
local Updates = require("__WhistleStopFactories__.updates")

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

function recipevalidation()
    log("Whistle Stop recipe check starts...")
    local cat_list1 = util.table.deepcopy(game.entity_prototypes["electric-furnace"]["crafting_categories"])
    cat_list1["chemical-furnace"] = true  -- Support for Bobs chemical furnaces
    cat_list1["mixing-furnace"] = true -- Support for Bobs mixing furnaces
    local cat_list2 = util.table.deepcopy(game.entity_prototypes["assembling-machine-3"]["crafting_categories"])
    if settings.startup["whistle-centrifuge"].value then
        cat_list2["centrifuging"] = true
    end
    local cat_list3 = util.table.deepcopy(game.entity_prototypes["chemical-plant"]["crafting_categories"])
    cat_list3["electrolysis"] = true -- Support for Bobs electrolysis
    local cat_list4 = util.table.deepcopy(game.entity_prototypes["oil-refinery"]["crafting_categories"])
    
    local foundissue = false
    local prod2
    local ingr2
    for _, recipe in pairs(game.recipe_prototypes) do
        local cat = recipe.category
        if inkey(cat, cat_list1) or inkey(cat, cat_list2) or inkey(cat, cat_list3) or inkey(cat, cat_list4) then
            if not game.recipe_prototypes[recipe.name .. "-big"] or not inlist(game.recipe_prototypes[recipe.name .. "-big"].category, {"big-smelting", "big-recipe", "big-chem", "big-refinery"}) then
                log("No big recipe pair for " .. recipe.name)
                foundissue = true
            end
        elseif  inlist(cat, {"big-smelting", "big-recipe", "big-chem", "big-refinery"}) then
            local small_recipe = game.recipe_prototypes[string.sub(recipe.name,1,-5)]
            if not small_recipe or not (inkey(small_recipe.category, cat_list1) or inkey(small_recipe.category, cat_list2) or inkey(small_recipe.category, cat_list3) or inkey(small_recipe.category, cat_list4)) then
                log("No small recipe pair for " .. recipe.name)
                foundissue = true
            else
                if #small_recipe.products == #recipe.products and #small_recipe.ingredients == #recipe.ingredients then
                    local ratio_max
                    local ratio_min
                    for k,prod in pairs(recipe.products) do
                        prod2 = small_recipe.products[k]
                        if prod.type ~= prod2.type
                                or prod.name ~= prod2.name
                                or type(prod.amount) ~= type(prod2.amount)
                                or prod.temperature ~= prod2.temperature
                                or type(prod.amount_min) ~= type(prod2.amount_min)
                                or type(prod.amount_max) ~= type(prod2.amount_max)
                                or prod.probability ~= prod2.probability
                                or type(prod.catalyst_amount) ~= type(prod2.catalyst_amount) then
                            log("Products don't match for" .. recipe.name .. serpent.line(prod) .. serpent.line(prod2))
                            foundissue = true
                        else
                            for k,v in pairs({"amount", "amount_min", "amount_max", "catalyst_amount"}) do
                                if prod[v] then
                                    if not ratio_max then
                                        ratio_max = prod[v]/prod2[v]
                                        ratio_min = prod[v]/prod2[v]
                                    else
                                        ratio_max = math.max(ratio_max,prod[v]/prod2[v])
                                        ratio_min = math.min(ratio_min,prod[v]/prod2[v])
                                    end
                                end
                            end
                        end
                    end
                    for k,ingr in pairs(recipe.ingredients) do
                        ingr2 = small_recipe.ingredients[k]
                        if ingr.type ~= ingr2.type
                                or ingr.name ~= ingr2.name
                                or type(ingr.amount) ~= type(ingr2.amount)
                                or ingr.minimum_temperature ~= ingr2.minimum_temperature
                                or ingr.maximum_temperature ~= ingr2.maximum_temperature
                                or type(ingr.catalyst_amount) ~= type(ingr2.catalyst_amount) then
                            log("Ingredients don't match for" .. recipe.name .. serpent.line(ingr) .. serpent.line(ingr2))
                            foundissue = true
                        else
                            for k,v in pairs({"amount", "amount_min", "amount_max", "catalyst_amount"}) do
                                if ingr[v] then
                                    if not ratio_max then
                                        ratio_max = ingr[v]/ingr2[v]
                                        ratio_min = ingr[v]/ingr2[v]
                                    else
                                        ratio_max = math.max(ratio_max,ingr[v]/ingr2[v])
                                        ratio_min = math.min(ratio_min,ingr[v]/ingr2[v])
                                    end
                                end
                            end
                        end
                    end
                    if ratio_min + .005 < ratio_max then
                        log("Recipe Ratio not consistent for recipe " .. recipe.name)
                        foundissue = true
                    end
                else
                    log("Different number of products/ingredients for recipe " .. recipe.name)
                    foundissue = true
                end
            end
        end
    end
    if foundissue then
        game.print("Whistle Stop recipe check found a issue with another mod.  See factorio-current.log for more information.")
        game.print("Please report to the Whistle Stop author here: https://mods.factorio.com/mod/WhistleStopFactories/discussion")
    else
        log("Whistle Stop recipe check complete.  No issues found.")
    end
end

script.on_event(defines.events.on_chunk_generated,
    function (event)
        -- Probability adjusts based on previous success.  Will attempt more spawns if lots are being blocked by ore and water.
        local prob = (20 + global.whistlestats.valid_chunk_count) / (10 + global.whistlestats["wsf-big-furnace"] + global.whistlestats["wsf-big-assembly"] + global.whistlestats["wsf-big-refinery"]) / 10
        if not probability(prob) then -- Initial probability filter to give the map a more random spread and reduce cpu work
            return
        end
        
        -- Chunk center
        local center = {
            x=(event.area.left_top.x+event.area.right_bottom.x)/2,
            y=(event.area.left_top.y+event.area.right_bottom.y)/2}

        if not distanceOkay(center, event.surface.index) then -- too close to other big structure
            return
        end

        global.whistlestats.valid_chunk_count = global.whistlestats.valid_chunk_count + 1

        if not global.nextSpawnType then -- Keeps trying the same spawn type until successful
            global.nextSpawnType = chooseNextSpawnType()
        end
        if global.nextSpawnType == "buffer" then
            debugWrite("Creating buffer point at (" .. center.x .. "," .. center.y .. ")")
            addBuffer(center, event.surface.index)
            global.whistlestats.buffer = global.whistlestats.buffer + 1
            global.nextSpawnType = nil
        else
            if global.nextSpawnType ~= "wsf-big-refinery" then
                -- Move center for smaller buildings, so that it won't always be in the exact center of chunks
                -- Still making sure not to cross the edge of the chunk
                center = {x=center.x - 1 + math.random(-3,4)*2, y=center.y - 1 + math.random(-3,4)*2}
            end

            local success = spawn(center, event.surface, global.nextSpawnType)
            if success then
                debugWrite("Creating " .. global.nextSpawnType .. " at (" .. center.x .. "," .. center.y .. ").  Counts = " .. serpent.line(global.whistlestats))
                addBuffer(center, event.surface.index)
                global.whistlestats[global.nextSpawnType] = global.whistlestats[global.nextSpawnType] + 1
                global.nextSpawnType = nil
            else
                debugWrite("Failed creating " .. global.nextSpawnType .."  at (" .. center.x .. "," .. center.y .. ")")
            end
        end
    end
)

script.on_init(
    function ()
        math.randomseed(game.surfaces[1].map_gen_settings.seed) --set the random seed to the map seed, so ruins are the same-ish with each generation.
    
        -- Tracks location of big factory and or buffer locations, starting with a buffer location at spawn
        global.bufferpoints = {}
        addBuffer({x=0, y=0}, 1, 1)
        global.whistlestops = {}
        -- Specification:
            -- position=center
            -- type=entityname
            -- entity=entity
            -- surface=surface
            -- direction=entity.direction (used to compare to see if updated)
            -- recipe=current recipe name (used to compare to see if updated)
            -- tag=tag_number

        -- Stat Tracking
        global.whistlestats = {buffer=0, ["wsf-big-furnace"]=0, ["wsf-big-assembly"]=0, ["wsf-big-refinery"]=0, ["wsf-big-chemplant"]=0, valid_chunk_count=0}

        Updates.init()

        recipevalidation()
    end
)

script.on_nth_tick(6*60, 
    function (event)
        for k,v in pairs(global.whistlestops) do
            -- Removes loaders for any entities that were destroyed by other mods without triggering destroy_entity event
            if not v.entity.valid then
                debugWrite("Factory not properly cleaned up at " .. v.position.x .. "," .. v.position.y .. ".  Cleaning now.")
                on_destroy_event({entity={name=v.type, unit_number=k}})
            elseif settings.global["whistle-enable-tagging"].value then
                -- Creates tag for entities that have a set recipe
                local recipe = v.entity.get_recipe()
                if type(recipe) == "table" then
                    if recipe.name ~= v.recipe then
                        debugWrite("Recipe Change at (" .. v.position.x .. "," .. v.position.y .. ")")
                        v.recipe = recipe.name
                        for k2,v2 in pairs(v.entity.force.find_chart_tags(v.surface, {{v.position.x-1, v.position.y-1}, {v.position.x+1, v.position.y+1}})) do
                            v2.destroy()
                        end
                        local product = nil
                        if game.item_prototypes[v.recipe .. "_tagicon"] then
                            product = {name=v.recipe .. "_tagicon", type="item"}
                        else
                            product = recipe.products[1]
                        end

                        local tag = v.entity.force.add_chart_tag(v.surface, {icon=product, position=v.position})
                        v.tag = tag.tag_number
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
            end
        end
    end
)

script.on_configuration_changed(
    function (configData)
        Updates.run()

        recipevalidation()
        
    end
)

script.on_event(defines.events.on_runtime_mod_setting_changed,
    function (event)
        if event.setting == "whistle-indestructible" then
            for k,v in pairs(global.whistlestops) do
                if v.entity.valid then
                    v.entity.destructible = not settings.global["whistle-indestructible"].value
                end
            end
        end
    end
)

-- Unlock big recipe versions when technology is researched
script.on_event(defines.events.on_research_finished,
    function (event)
        local force = event.research.force
        for _, effect in pairs(event.research.effects) do
            if type(effect) == 'table' and effect.type == "unlock-recipe" then
                if force.recipes[effect.recipe .. "-big"] and
                        inlist(force.recipes[effect.recipe .. "-big"].category, {"big-smelting", "big-recipe", "big-chem", "big-refinery"})  then
                    force.recipes[effect.recipe .. "-big"].enabled = true
                end
            end
        end
    end
)