-- Big Assembly prototype and item definition
require("__WhistleStopFactories__.prototypes.adjustVisuals")
require("util")

commonAdjustments = require("__WhistleStopFactories__.prototypes.commonAdjustments")

local function create_bigassembly(name, energy, speed)
    local bigassembly = util.table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
    local icon = "__WhistleStopFactories__/graphics/icons/big-assembly.png"

    bigassembly.name = name
    bigassembly.icon = icon
    bigassembly.icon_size = 32
    bigassembly.localised_name = {"entity-name.wsf-big-assembly"}

    bigassembly.collision_box = {{-8.1, -8.1}, {8.1, 8.1}}
    bigassembly.selection_box = {{-8.8, -9}, {8.8, 9}}
    bigassembly.drawing_box = {{-8.8, -8.8}, {8.8, 8.8}}

    bigassembly.crafting_categories = {"big-recipe", "big-chem"}
    bigassembly.crafting_speed = speed

    bigassembly.energy_usage = energy
    bigassembly.ingredient_count = 10
    bigassembly.module_specification.module_slots = 5
    bigassembly.map_color = {r=103, g=247, b=247}

    commonAdjustments(bigassembly)

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

    if name == "wsf-big-assembly-old" then
        bigassembly.fluid_boxes = {
            fluidBox("input", {1, -9}),
            fluidBox("input", {-9, -1}),
            fluidBox("output", {9, 1}),
            fluidBox("output", {-1, 9}),
        }
    else
        bigassembly.fluid_boxes = {
            fluidBox("input", {0, -9}),
            fluidBox("input", {-9, 0}),
            fluidBox("output", {9, 0}),
            fluidBox("output", {0, 9}),
        }
    end

    adjustVisuals(bigassembly, 6, 1/32)

    data.raw["assembling-machine"][name] = bigassembly

    local bigassembly_item = util.table.deepcopy(data.raw.item["assembling-machine-3"])

    bigassembly_item.name = name
    bigassembly_item.icon = icon
    bigassembly_item.icon_size = 32
    bigassembly_item.order = "c[" .. name .. "]"
    bigassembly_item.place_result = name

    data.raw.item[name] = bigassembly_item
end

return create_bigassembly