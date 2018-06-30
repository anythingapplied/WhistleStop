-- Adds big items to list of productivity module usable items
require("luaMacros")

local function productivityFix()
    for k,v in pairs(data.raw.module) do
        if v.limitation ~= nil then
            for k2,v2 in pairs(copy(v.limitation)) do
                if data.raw.recipe[v2 .. "-big"] ~= nil then
                    table.insert(v.limitation, v2 .. "-big")
                end
            end
        end
    end
end

productivityFix()