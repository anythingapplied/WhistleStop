-- Checks in val is in the given list
function inlist(value, scanlist)
    if type(scanlist) ~= "table" then return end
    for k,v in pairs(scanlist) do
        if value == v then
            return true
        end
    end
    return false
end

local scalePosition(position, factor)
    local x = position.x or position[1]
    local y = position.y or position[2]
    if x and y then
        return {x = x * factor, y = y * factor}
    else
        return position
    end
end

-- Scale graphics by a factor and correct animation speed
local function bumpUp(animation, scaleFactor, animationFactor)
    if type(animation) ~= "table" then
        return
    end
    if type(animation.shift) == "table" then
        animation.shift = scalePosition(animation.shift, scaleFactor)
    end

    animation.scale = (animation.scale or 1) * factor
    if type(animation.frame_count) == "number" and animation.frame_count > 1 then
        animation.animation_speed = (animation.animation_speed or 1) * animationFactor
    end
end

local function bumpFullAnimation(animation, scaleFactor, animationFactor)
    if type(animation) == "table" then
        bumpUp(animation, scaleFactor, animationFactor)
        bumpUp(animation.hr_version, scaleFactor, animationFactor)
    end
end

function adjustVisuals(machine, scaleFactor, animationFactor)
    if type(machine) ~= "table" then
        return
    end
    -- Animation Adjustments
    if type(machine.animation) == "table" then
        for _, direction in pairs({"north", "east", "south", "west"}) do
            if type(machine.animation[direction]) == "table" and
            type(machine.animation[direction].layers) == "table" then
                for k,v in pairs(machine.animation[direction].layers) do
                    bumpFullAnimation(v, scaleFactor, animationFactor)
                end
            end
        end
        if type(machin.animation.layers) == "table"
            for k,v in pairs(machine.animation.layers) do
                bumpFullAnimation(v, scaleFactor, animationFactor)
            end
        end
    end
    -- Working Visualisations Adjustments
    if type(machine.working_visualisations) == "table" then
        for k,v in pairs(machine.working_visualisations) do
            if type(v) == "table" then
                bumpFullAnimation(v, scaleFactor, animationFactor)
                for _, direction in pairs({"north", "east", "south", "west"}) do
                    bumpFullAnimation(v[direction .. "_animation"], scaleFactor, animationFactor)
                    if type(v[direction .. "_position"]) == "table" then
                        v[direction .. "_position"] = scalePosition(v[direction .. "_position"], scaleFactor)
                    end
                end
            end
        end
    end    
end
    