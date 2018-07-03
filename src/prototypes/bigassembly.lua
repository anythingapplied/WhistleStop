require("scripts.luaMacros")

-- Big Assembly item specification
local bigassembly = copy(data.raw["assembling-machine"]["assembling-machine-3"])

bigassembly.name = "big-assembly"
bigassembly.icon = "__WhistleStopFactories__/graphics/icons/big-assembly.png"

bigassembly.minable = nil
bigassembly.fast_replaceable_group = nil
bigassembly.dying_explosion = "big-explosion"

bigassembly.collision_box = {{-8.1, -8.1}, {8.1, 8.1}}
bigassembly.selection_box = {{-8.8, -9}, {8.8, 9}}
bigassembly.drawing_box = {{-8.8, -8.8}, {8.8, 8.8}}

bigassembly.crafting_categories = {"big-recipe"}
bigassembly.crafting_speed = 40

bigassembly.energy_usage = "1500kW"
bigassembly.ingredient_count = 10
bigassembly.module_specification.module_slots = 5
bigassembly.map_color = {r=103, g=247, b=247}
bigassembly.scale_entity_info_icon = true

table.insert(bigassembly.resistances, {percent=100, type="poison"})  -- Prevent termite damage

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

bigassembly.fluid_boxes = {
    fluidBox("input", {1, -9}),
    fluidBox("input", {-9, -1}),
    fluidBox("output", {9, 1}),
    fluidBox("output", {-1, 9}),
    off_when_no_fluid_recipe = true
}

-- Scale graphics by a factor and correct animation speed
local function bumpUp(animation, factor)
    animation.scale = factor
    animation.animation_speed = 0.05
    for k,v in pairs(animation.shift) do
        animation.shift[k] = v * factor
    end
end

for k,v in pairs(bigassembly.animation.layers) do
    bumpUp(v, 6)
    bumpUp(v.hr_version, 3)
end

data.raw["assembling-machine"]["big-assembly"] = bigassembly