
local function create_powerpole(name)
    data:extend({
        {
            type = "electric-pole",
            name = name,
            icon = "__base__/graphics/icons/medium-electric-pole.png",
            icon_size = 32,
            flags = {"placeable-neutral", "placeable-player", "player-creation", "not-deconstructable", "not-blueprintable", "not-on-map", "hide-alt-info"},
            collision_mask = {},
            minable = {hardness = 0, minable = false, mining_time = 0},
            corpse = "small-remnants",
            collision_box = {{-0.15, -0.15}, {0.15, 0.15}},
            maximum_wire_distance = 0,
            supply_area_distance = 0.5,
            pictures =
            {
                filename = "__WhistleStopFactories__/graphics/FFFFFF-0.png",
                width = 1,
                height = 1,
                direction_count = 1
            },
            connection_points =
            {
              {
                shadow = {},
                wire = {}
              }
            },
            radius_visualisation_picture =
            {
                filename = "__WhistleStopFactories__/graphics/FFFFFF-0.png",
                width = 1,
                height = 1
            }
          }
    })

    local powerpole_item = util.table.deepcopy(data.raw.item["medium-electric-pole"])

    powerpole_item.name = name
    powerpole_item.order = "b[" .. name .. "]"
    powerpole_item.place_result = name
    powerpole_item.flags = {"hidden"}

    data.raw.item[name] = powerpole_item

end

return create_powerpole