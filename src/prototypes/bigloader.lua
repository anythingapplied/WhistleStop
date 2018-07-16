-- Big furnace prototype definition
local bigloader = util.table.deepcopy(data.raw["loader"]["express-loader"])

bigloader.name = "express-loader-big"

bigloader.minable = nil
bigloader.destructible = false
bigloader.fast_replaceable_group = nil

bigloader.create_ghost_on_death = false
bigloader.flags = {"placeable-neutral", "placeable-player", "player-creation", "not-deconstructable", "not-blueprintable"}

data.raw["loader"][bigloader.name] = bigloader