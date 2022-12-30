---@diagnostic disable: duplicate-set-field
function TSIL.Utils.Tables.GetDictionaryKeys(dictionary)
    local result = {}
    for i in pairs(dictionary) do
        table.insert(result, i)
    end
    return result
end
