-- Big Assembly prototype and item definition
require("adjustVisuals")

local function create_bigchemplant(name, energy, speed)
    local bigchemplant = util.table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
    -- local icon = "__WhistleStopFactories__/graphics/icons/big-assembly.png"

    bigchemplant.name = name
    -- bigchemplant.icon = icon
    bigchemplant.localised_name = {"entity-name.big-chemplant"}

    bigchemplant.minable = nil
    bigchemplant.fast_replaceable_group = nil
    bigchemplant.dying_explosion = "big-explosion"

    bigchemplant.collision_box = {{-8.1, -8.1}, {8.1, 8.1}}
    bigchemplant.selection_box = {{-8.8, -9}, {8.8, 9}}
    bigchemplant.drawing_box = {{-8.8, -8.8}, {8.8, 8.8}}

    bigchemplant.crafting_categories = {"big-chem"}
    bigchemplant.crafting_speed = speed

    bigchemplant.energy_usage = energy
    bigchemplant.ingredient_count = 10
    bigchemplant.module_specification.module_slots = 5
    bigchemplant.map_color = {r=103, g=247, b=103}
    bigchemplant.scale_entity_info_icon = true

    bigchemplant.create_ghost_on_death = false
    -- Normal flags for assembly machine: {"placeable-neutral", "placeable-player", "player-creation"}
    bigchemplant.flags = {"placeable-neutral", "placeable-player", "player-creation", "not-deconstructable", "not-blueprintable"}
    bigchemplant.collision_mask = bigchemplant.collision_mask or {"item-layer", "object-layer", "player-layer", "water-tile"}
    table.insert(bigchemplant.collision_mask, "resource-layer")
    bigchemplant.resistances = bigchemplant.resistances or {}
    table.insert(bigchemplant.resistances, {percent=100, type="poison"})  -- Prevent termite damage

    local function fluidBox(type, position)
        retvalue = {
                production_type = type,
                pipe_picture = assembler3pipepictures(),
                pipe_covers = pipecoverspictures(),
                base_area = 10,
                pipe_connections = {{ type=type, position=position }},
                secondary_draw_orders = { north = -1 }
            }
        if type == "input" then
            retvalue.base_level = -1
        else
            retvalue.base_level = 1
        end
        return retvalue
    end

    bigchemplant.fluid_boxes = {
        fluidBox("input", {-5, -9}),
        fluidBox("input", {5, -9}),
        fluidBox("output", {-5, 9}),
        fluidBox("output", {5, 9}),
        -- off_when_no_fluid_recipe = true -- Allows for rotation
    }

    adjustVisuals(bigchemplant, 5, 1/20)

    data.raw["assembling-machine"][name] = bigchemplant

    local bigchemplant_item = util.table.deepcopy(data.raw.item["chemical-plant"])

    bigchemplant_item.name = name
    -- bigchemplant_item.icon = icon
    bigchemplant_item.order = "c[" .. name .. "]"
    bigchemplant_item.place_result = name

    data.raw.item[name] = bigchemplant_item
end

return create_bigchemplant