require("scripts.luaMacros")

-- Big furnace item specification
local bigrefinery = util.table.deepcopy(data.raw["assembling-machine"]["oil-refinery"])

bigrefinery.name = "big-refinery"
-- bigrefinery.icon = "__WhistleStopFactories__/graphics/icons/big-furnace.png"

bigrefinery.minable = {hardness = 0, minable = false, mining_time = 0}
bigrefinery.fast_replaceable_group = nil
bigrefinery.dying_explosion = "big-explosion"

bigrefinery.collision_box = {{-8.1, -8.1}, {8.1, 8.1}}
bigrefinery.selection_box = {{-8.8, -9}, {8.8, 9}}
bigrefinery.drawing_box = {{-8.8, -8.8}, {8.8, 8.8}}

bigrefinery.crafting_categories = {"big-refinery"}
bigrefinery.crafting_speed = 18

bigrefinery.energy_usage = "1680kW"
bigrefinery.module_specification.module_slots = 6
bigrefinery.map_color = {r=199, g=199, b=247}
bigrefinery.scale_entity_info_icon = true

bigrefinery.create_ghost_on_death = false
bigrefinery.flags = {"placeable-neutral", "placeable-player", "player-creation", "not-deconstructable", "not-blueprintable"}
table.insert(bigassembly.collision_mask, "resource-layer")
table.insert(bigrefinery.resistances, {percent=100, type="poison"})  -- Prevent termite damage

-- Scale graphics by a factor and correct animation speed
local function bumpUp(animation, factor)
    animation.scale = factor
    animation.animation_speed = 0.05
    for k,v in pairs(animation.shift) do
        animation.shift[k] = v * factor
    end
end

for k,v in pairs(bigrefinery.animation.layers) do
    bumpUp(v, 6)
    bumpUp(v.hr_version, 3)
end

data.raw["assembling-machine"][bigrefinery.name] = bigrefinery