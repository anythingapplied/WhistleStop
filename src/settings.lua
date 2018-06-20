data:extend({
        {
            type = "int-setting",
            name = "whistle-min-distance-from-spawn",
            setting_type = "runtime-global",
            default_value = 250,
            order = "a",
        },
        {
            type = "double-setting",
            name = "whistle-furnace-chance",
            setting_type = "runtime-global",
            default_value = 0.01,
            minimum_value = 0.0,
            maximum_value = 1.0,
            order = "b",
        },
        {
            type = "double-setting",
            name = "whistle-assembly-chance",
            setting_type = "runtime-global",
            default_value = 0.02,
            minimum_value = 0.0,
            maximum_value = 1.0,
            order = "c",
        }
})
