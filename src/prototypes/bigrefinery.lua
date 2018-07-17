-- Big furnace prototype definition
local bigrefinery = util.table.deepcopy(data.raw["assembling-machine"]["oil-refinery"])

bigrefinery.name = "big-refinery"
-- bigrefinery.icon = "__WhistleStopFactories__/graphics/icons/big-furnace.png"

bigrefinery.minable = nil
bigrefinery.fast_replaceable_group = nil
bigrefinery.dying_explosion = "big-explosion"

bigrefinery.collision_box = {{-14.5, -14.5}, {14.5, 14.5}}
bigrefinery.selection_box = {{-15, -15}, {15, 15}}
bigrefinery.drawing_box = {{-15, -15.3}, {15, 15}}

bigrefinery.crafting_categories = {"big-refinery"}
bigrefinery.crafting_speed = 18

bigrefinery.energy_usage = "1680kW"
bigrefinery.module_specification.module_slots = 6
bigrefinery.map_color = {r=199, g=199, b=247}
bigrefinery.scale_entity_info_icon = true

bigrefinery.create_ghost_on_death = false
bigrefinery.flags = {"placeable-neutral", "placeable-player", "player-creation", "not-deconstructable", "not-blueprintable"}
bigrefinery.collision_mask = bigrefinery.collision_mask or {"item-layer", "object-layer", "player-layer", "water-tile"}
table.insert(bigrefinery.collision_mask, "resource-layer")
bigrefinery.resistances = bigrefinery.resistances or {}
table.insert(bigrefinery.resistances, {percent=100, type="poison"})  -- Prevent termite damage

bigrefinery.has_backer_name = nil

local function fluidBox(type, position)
    retvalue = {
            production_type = type,
            pipe_covers = pipecoverspictures(),
            base_area = 50,
            pipe_connections = {{ type=type, position=position }},
        }
    if type == "input" then
        retvalue.base_level = -1
    else
        retvalue.base_level = 1
    end
    return retvalue
end

bigrefinery.fluid_boxes = {
    fluidBox("input", {-6, 15}),
    fluidBox("input", {6, 15}),
    fluidBox("output", {-12, -15}),
    fluidBox("output", {0, -15}),
    fluidBox("output", {12, -15})
}
-- Scale graphics by a factor and correct animation speed
local function bumpUp(animation, factor)
    animation.scale = factor
    animation.animation_speed = 0.05
    animation.shift[1] = animation.shift[1] + 3.05
    animation.shift[2] = animation.shift[2] + .6
end

for _, direction in pairs({"north", "east", "south", "west"}) do
    for k,v in pairs(bigrefinery.animation[direction].layers) do
        bumpUp(v, 5.8)
        bumpUp(v.hr_version, 2.9)
    end
end

data.raw["assembling-machine"][bigrefinery.name] = bigrefinery