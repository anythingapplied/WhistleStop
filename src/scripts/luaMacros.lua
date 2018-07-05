-- Checks in val is in the given list
function inlist(value, scanlist)
    for k,v in pairs(scanlist) do
        if value == v then
            return true
        end
    end
    return false
end