---@diagnostic disable: duplicate-set-field
function TSIL.Utils.Tables.IterateTableInOrder(map, func, inOrder)
    if inOrder == nil then
        inOrder = true
    end

    if not inOrder then
        for key, value in pairs(map) do
            func(key, value)
        end
        return
    end

    local keys = TSIL.Utils.Tables.GetDictionaryKeys(map)
    local hasAllNumberKeys = TSIL.Utils.Tables.All(keys, function(_, key)
        return type(key) == "number"
    end)
    local hasAllStringKeys = TSIL.Utils.Tables.All(keys, function(_, key)
        return type(key) == "string"
    end)

    if not hasAllNumberKeys and not hasAllStringKeys then
        for key, value in pairs(map) do
            func(key, value)
        end
        return
    end

    table.sort(keys)

    for _, key in pairs(keys) do
        local value = map[key]
        if value ~= nil then
            func(key, value)
        end
    end
end
