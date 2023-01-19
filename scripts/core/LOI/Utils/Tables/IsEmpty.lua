---@diagnostic disable: duplicate-set-field
function TSIL.Utils.Tables.IsEmpty(map)
    for _ in pairs(map) do
        return false
    end
    return true
end
