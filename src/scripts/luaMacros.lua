-- Makes a deep copy of any object
function copy(obj, seen)
    if type(obj) ~= "table" then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
    return res
end

-- Checks in val is in the given list
function inlist(val, scanlist)
    for k,v in pairs(scanlist) do
        if val == v then
            return true
        end
    end
    return false
end