-- Big loader prototype and item definition

local function create_bigloader(name)
    local bigloader = util.table.deepcopy(data.raw["loader"]["express-loader"])

    bigloader.name = name
    bigloader.minable = nil
    bigloader.destructible = false
    bigloader.fast_replaceable_group = nil

    bigloader.create_ghost_on_death = false
    bigloader.flags = {"placeable-neutral", "placeable-player", "player-creation", "not-deconstructable", "not-blueprintable"}

    data.raw["loader"][name] = bigloader

    local bigrefinery_item = util.table.deepcopy(data.raw.item["express-loader"])

    bigrefinery_item.name = name
    -- bigrefinery_item.icon = icon
    bigrefinery_item.order = "d[loader]-c[" .. name .."]"
    bigrefinery_item.place_result = name

    data.raw.item[name] = bigrefinery_item
end

return create_bigloader