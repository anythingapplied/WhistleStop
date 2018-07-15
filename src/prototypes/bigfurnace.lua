require("scripts.luaMacros")

-- Big furnace item specification
local bigfurnace = util.table.deepcopy(data.raw.furnace["electric-furnace"])

bigfurnace.name = "big-furnace"
bigfurnace.icon = "__WhistleStopFactories__/graphics/icons/big-furnace.png"

bigfurnace.minable = {hardness = 0, minable = false, mining_time = 0}
bigfurnace.fast_replaceable_group = nil
bigfurnace.dying_explosion = "big-explosion"

bigfurnace.collision_box = {{-8.1, -8.1}, {8.1, 8.1}}
bigfurnace.selection_box = {{-8.8, -9}, {8.8, 9}}
bigfurnace.drawing_box = {{-8.8, -8.8}, {8.8, 8.8}}

bigfurnace.crafting_categories = {"big-smelting"}
bigfurnace.crafting_speed = 100

bigfurnace.energy_usage = "2000kW"
bigfurnace.module_specification.module_slots = 6
bigfurnace.map_color = {r=199, g=103, b=247}
bigfurnace.scale_entity_info_icon = true

-- Set this to an assembling machine type
bigfurnace.type = "assembling-machine"
bigfurnace.result_inventory_size = nil
bigfurnace.source_inventory_size = nil
bigfurnace.ingredient_count = 1

bigfurnace.create_ghost_on_death = false
bigfurnace.flags = {"placeable-neutral", "placeable-player", "player-creation", "not-deconstructable", "not-blueprintable"}
table.insert(bigfurnace.collision_mask, "resource-layer")
table.insert(bigfurnace.resistances, {percent=100, type="poison"})  -- Prevent termite damage

-- Scale graphics by a factor and correct animation speed
local function bumpUp(animation, factor)
    animation.scale = factor
    animation.animation_speed = 0.01
    for k,v in pairs(animation.shift) do
        animation.shift[k] = v * factor
    end
end

local scaleFactor = 2.7
for k,v in pairs(bigfurnace.animation.layers) do
    bumpUp(v, 2 * scaleFactor)
    bumpUp(v.hr_version, scaleFactor)
end
for k,v in pairs(bigfurnace.working_visualisations) do
    bumpUp(v.animation, 2 * scaleFactor)
    bumpUp(v.animation.hr_version, scaleFactor)
    -- Extra manual adjustment needed for HR version working visuals.
    -- Not sure why needed, but won't be right if you change scaleFactor
    v.animation.hr_version.shift[1] = v.animation.hr_version.shift[1] * 2
    v.animation.hr_version.shift[2] = v.animation.hr_version.shift[2] * 2 - .5
end

data.raw["assembling-machine"][bigfurnace.name] = bigfurnace