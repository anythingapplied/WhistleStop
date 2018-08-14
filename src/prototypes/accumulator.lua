local function create_accumulator(name, collision_box)
    data:extend({
    {
        type = "accumulator",
        name = name,
        localization = {"entity-name.wsf-accumulator"},
        icon = "__base__/graphics/icons/accumulator.png",
        icon_size = 32,
        flags = {"placeable-neutral", "placeable-player", "player-creation", "not-deconstructable", "not-blueprintable", "not-on-map", "hide-alt-info"},
        collision_mask = {},
        minable = {hardness = 0, minable = false, mining_time = 0},
        corpse = "medium-remnants",
        collision_box = collision_box,
        energy_source =
        {
            type = "electric",
            buffer_capacity = "100J",
            usage_priority = "terciary",
            input_flow_limit = "61W",
            output_flow_limit = "61W",
            render_no_power_icon = false,
            render_no_network_icon = false
        },
        picture =
        {
            filename =  "__WhistleStopFactories__/graphics/FFFFFF-0.png",
            width = 1,
            height = 1
        },
            charge_animation =
        {
            filename =  "__WhistleStopFactories__/graphics/FFFFFF-0.png",
            width = 1,
            height = 1,
            frame_count = 1
        },
        charge_cooldown = 30,
        charge_light = {intensity = 0.0, size = 7, color = {r = 1.0, g = 1.0, b = 1.0}},
        discharge_animation =
        {
            filename =  "__WhistleStopFactories__/graphics/FFFFFF-0.png",
            width = 1,
            height = 1,
            frame_count = 1
        },
        discharge_cooldown = 60,
        discharge_light = {intensity = 0.0, size = 7, color = {r = 1.0, g = 1.0, b = 1.0}},
        -- working_sound =
        -- {
        -- -- sound =
        -- -- {
        -- --     filename = "__base__/sound/accumulator-working.ogg",
        -- --     volume = 1
        -- -- },
        -- -- idle_sound =
        -- -- {
        -- --     filename = "__base__/sound/accumulator-idle.ogg",
        -- --     volume = 0.4
        -- -- },
        -- -- max_sounds_per_type = 5
        -- },

        circuit_wire_connection_point = circuit_connector_definitions["accumulator"].points,
        circuit_connector_sprites = circuit_connector_definitions["accumulator"].sprites,
        circuit_wire_max_distance = default_circuit_wire_max_distance,

        -- default_output_signal = {type = "virtual", name = "signal-A"}
    }
    })

  local accumulator_item = util.table.deepcopy(data.raw.item["accumulator"])

  accumulator_item.name = name
  accumulator_item.order = "b[" .. name .. "]"
  accumulator_item.place_result = name
  accumulator_item.flags = {"hidden"}

  data.raw.item[name] = accumulator_item

end

return create_accumulator