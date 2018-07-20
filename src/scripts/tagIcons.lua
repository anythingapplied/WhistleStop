-- Adds big items to list of productivity module usable items
local function tagIcons()
    for k,v in pairs(data.raw.recipe) do
        if type(v) == "table" then
            if v.icon or v.icons then
                data:extend({{
                    name = v.name .. "_tagicon",
                    type = "item",
                    icon = v.icon,
                    icons = v.icons,
                    icon_size = v.icon_size,
                    stack_size = 1,
                    flags = {"hidden"}
                }})
            end
        end
    end
end

tagIcons()