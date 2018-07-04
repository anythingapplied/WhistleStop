data:extend({
        {
            type = "int-setting",
            name = "whistle-min-distance",
            setting_type = "runtime-global",
            default_value = 180,
            order = "a",
        },
        {
            type = "string-setting",
            name = "whistle-buildable",
            setting_type = "runtime-global",
            default_value = "generate",
            allowed_values = {"generate", "build", "both"},
            order = "b",
        }
})
