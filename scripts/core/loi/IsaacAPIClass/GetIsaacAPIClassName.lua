---@diagnostic disable: duplicate-set-field
function TSIL.IsaacAPIClass.GetIsaacAPIClassName(object)
    if type(object) ~= "userdata" then
        return
    end

    local metatable = getmetatable(object)

    if metatable == nil then
        return
    end

    local classType = metatable.__type

    if type(classType) ~= "string" then
        return
    end

    local trimmedName = string.gsub(classType, "const ", "")

    return trimmedName
end
