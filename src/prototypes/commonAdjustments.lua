local function commonAdjustments(factory)
    factory.minable = nil
    factory.next_upgrade = nil
    factory.fast_replaceable_group = nil
    factory.dying_explosion = "big-explosion"
    factory.max_health = 1600

    factory.scale_entity_info_icon = true

    factory.create_ghost_on_death = false
    factory.flags = {"placeable-neutral", "placeable-player", "player-creation", "not-deconstructable", "not-blueprintable"}
    factory.collision_mask = factory.collision_mask or {"item-layer", "object-layer", "player-layer", "water-tile"}
    if not settings.startup["whistle-spawn-over-ore"].value then
        table.insert(factory.collision_mask, "resource-layer")
    end
    factory.resistances = {{type="poison", percent=90}, {type="acid", percent=80}, {type="physical", percent=70},
        {type="fire", percent=70}, {type="explosion", percent=-100}}

    factory.has_backer_name = nil
end

return commonAdjustments
