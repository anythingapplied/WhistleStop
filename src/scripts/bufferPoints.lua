local grid_size = 500

-- Returns true if no big structures within minimum distance threshholds
function distanceOkay(point, surface_index)
    local minSetting = settings.global["whistle-min-distance"].value
    if not global.bufferpoints[surface_index] then -- No other points on that surface found
        return true
    end
    for x=math.floor((point.x - 2*minSetting) / grid_size),math.floor((point.x + 2*minSetting) / grid_size) do
        for y=math.floor((point.y - 2*minSetting) / grid_size),math.floor((point.y + 2*minSetting) / grid_size) do
            if global.bufferpoints[surface_index][x] and global.bufferpoints[surface_index][x][y] then
                for k,v in pairs(global.bufferpoints[surface_index][x][y]) do
                    if (point.x - v.position.x)^2 + (point.y - v.position.y)^2 < (minSetting * (1 + v.distance_factor))^2 then
                        return false
                    end
                end
            end
        end
    end
    return true
end

-- Adds a point to the list of points used to determine if a new factory is far enough away from previous factories
function addBuffer(position, surface_index, distance_factor)
    local distance_factor = distance_factor or math.random()
    global.bufferpoints[surface_index] = global.bufferpoints[surface_index] or {}
    local xgrid = math.floor(position.x / grid_size)
    global.bufferpoints[surface_index][xgrid] = global.bufferpoints[surface_index][xgrid] or {}
    local ygrid = math.floor(position.y / grid_size)
    global.bufferpoints[surface_index][xgrid][ygrid] = global.bufferpoints[surface_index][xgrid][ygrid] or {}
    table.insert(global.bufferpoints[surface_index][xgrid][ygrid], {position=position, surface_index=surface_index, distance_factor=distance_factor})
end