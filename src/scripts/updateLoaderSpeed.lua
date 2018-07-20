-- Update Loader speed to fastest available loaders or belts in current mod set

local fastestBeltSpeed = data.raw.loader["express-loader"].speed
local searchList = {"transport-belt", "loader"}

for k,v in pairs(searchList) do
    for k2,v2 in pairs(data.raw[v]) do
        if type(v2) == "table" and type(v2.speed) == "number" then
            fastestBeltSpeed = math.max(fastestBeltSpeed, v2.speed)
        end
    end
end

data.raw.loader["express-loader-big"].speed = fastestBeltSpeed

-- Keeps animation speed constant so the belts won't look frozen or other wierd animation quirks
data.raw.loader["express-loader-big"].animation_speed_coefficient = data.raw.loader["express-loader"].animation_speed_coefficient * data.raw.loader["express-loader"].speed / fastestBeltSpeed