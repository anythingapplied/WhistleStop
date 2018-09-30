-- Create the item groups for the new big recipes
require("util")

local function itemGroupSetup()
    for k,v in pairs(util.table.deepcopy(data.raw["item-group"])) do
        v.localised_name = v.localised_name or {"item-group-name." .. v.name}
        v.name = v.name .. "-big"
        v.order = "y" .. v.order
        data.raw["item-group"][k .. "-big"] = v
    end
    for k,v in pairs(util.table.deepcopy(data.raw["item-subgroup"])) do
        v.name = v.name .. "-big"
        v.group = v.group .. "-big"
        data.raw["item-subgroup"][k .. "-big"] = v
    end
end

itemGroupSetup()