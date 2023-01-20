---@diagnostic disable: duplicate-set-field
function TSIL.Log.GetParentFunctionDescription(levels)
    levels = levels or 3
    
    if debug == nil then
        return
    end

    local debugTable = debug.getinfo(levels)
    if debugTable ~= nil then
        return debugTable.name .. ":" .. debugTable.linedefined
    end
end
