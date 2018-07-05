require("luaMacros")

-- Create the item groups for the new big recipes
local function itemGroupSetup()
    for k,v in pairs(util.table.deepcopy(data.raw["item-group"])) do
        v.name = v.name .. "-big"
        v.order = "y" .. v.order
        data.raw["item-group"][k .. "-big"] = v
    end
    for k,v in pairs(util.table.deepcopy(data.raw["item-subgroup"])) do
        v.name = v.name .. "-big"
        v.group = v.group .. "-big"
        data.raw["item-subgroup"][k .. "-big"] = v
    end

    data.raw["item-group"]["combat-big"].icon = "__WhistleStopFactories__/graphics/item-group/military.png"
    data.raw["item-group"]["fluids-big"].icon = "__WhistleStopFactories__/graphics/item-group/fluids.png"
    data.raw["item-group"]["intermediate-products-big"].icon = "__WhistleStopFactories__/graphics/item-group/intermediate-products.png"
    data.raw["item-group"]["logistics-big"].icon = "__WhistleStopFactories__/graphics/item-group/logistics.png"
    data.raw["item-group"]["production-big"].icon = "__WhistleStopFactories__/graphics/item-group/production.png"
    data.raw["item-group"]["signals-big"].icon = "__WhistleStopFactories__/graphics/item-group/signals.png"
end

itemGroupSetup()