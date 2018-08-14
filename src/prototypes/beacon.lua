
local function create_beacon(name)
    data:extend({
    {
        type = "beacon",
        name = name,
        localization = {"entity-name.wsf-beacon"},
        icon = "__base__/graphics/icons/beacon.png",
        icon_size = 32,
        flags = {"placeable-neutral", "placeable-player", "player-creation", "not-deconstructable", "not-blueprintable", "not-on-map", "hide-alt-info"},
        collision_mask = {},
        minable = {hardness = 0, minable = false, mining_time = 0},
        collision_box = {{-.1, -.1}, {.1, .1}},
        allowed_effects = {"consumption", "speed"},
        base_picture =
        {
            filename =  "__WhistleStopFactories__/graphics/FFFFFF-0.png",
            width = 1,
            height = 1
        },
        animation =
        {
            filename =  "__WhistleStopFactories__/graphics/FFFFFF-0.png",
            frame_count = 1,
            width = 1,
            height = 1
        },
        animation_shadow =
        {
            filename =  "__WhistleStopFactories__/graphics/FFFFFF-0.png",
            frame_count = 1,
            width = 1,
            height = 1
        },
        radius_visualisation_picture =
        {
            filename = "__WhistleStopFactories__/graphics/FFFFFF-0.png",
            width = 1,
            height = 1
        },
        supply_area_distance = -3,
        energy_source =
        {
            type = "electric",
            usage_priority = "secondary-input",
            render_no_power_icon = false,
            render_no_network_icon = false
        },
        energy_usage = "60W",
        distribution_effectivity = 5,
        module_specification = {module_slots=12}
    }
    })

    local beacon_item = util.table.deepcopy(data.raw.item["beacon"])

    beacon_item.name = name
    beacon_item.order = "b[" .. name .. "]"
    beacon_item.place_result = name
    beacon_item.flags = {"hidden"}

    data.raw.item[name] = beacon_item

end

return create_beacon