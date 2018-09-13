data:extend({
        {
            type = "int-setting",
            name = "whistle-min-distance",
            setting_type = "runtime-global",
            default_value = 180,
            order = "a",
        },

        {
            type = "bool-setting",
            name = "whistle-enable-tagging",
            setting_type = "runtime-global",
            default_value = true,
            order = "b",
        },

        {
            type = "bool-setting",
            name = "whistle-indestructible",
            setting_type = "runtime-global",
            default_value = false,
            order = "c",
        },

        {
            type = "bool-setting",
            name = "whistle-centrifuge",
            setting_type = "startup",
            default_value = false,
            order = "a",
        },
})
