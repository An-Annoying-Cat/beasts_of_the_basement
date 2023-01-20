---@diagnostic disable: duplicate-set-field
local function deepCopyUserdata(value, serializationType)
    local classType = TSIL.IsaacAPIClass.GetIsaacAPIClassName(value)
    
    if classType == nil then
        error("The deep copy function was not able to derive the Isaac API class type!")
    end

    if not TSIL.Serialize.IsCopyableIsaacAPIClass(value) then
        error("The deep copy function does not support serializing this, since it is an Isaac API class of type: " .. classType)
    end

    if serializationType == TSIL.Enums.SerializationType.NONE then
        return TSIL.Serialize.CopyIsaacAPIClass(value)
    elseif serializationType == TSIL.Enums.SerializationType.SERIALIZE then
        return TSIL.Serialize.SerializeIsaacAPIClass(value)
    elseif serializationType == TSIL.Enums.SerializationType.DESERIALIZE then
        error("The deep copy can not deserialize this since it is userdata.")
    end
end


function TSIL.Utils.DeepCopy.DeepCopy(value, serializationType, copies)
    copies = copies or {}
    local orig_type = type(value)
    local copy
    if orig_type == 'table' then
        if copies[value] then
            copy = copies[value]
        else
            copy = {}
            copies[value] = copy
            for orig_key, orig_value in next, value, nil do
                copy[TSIL.Utils.DeepCopy.DeepCopy(orig_key, serializationType, copies)] = TSIL.Utils.DeepCopy.DeepCopy(orig_value, serializationType, copies)
            end
            setmetatable(copy, TSIL.Utils.DeepCopy.DeepCopy(getmetatable(value), serializationType, copies))
        end
    elseif orig_type == "userdata" then
        copy = deepCopyUserdata(value, serializationType)
    else
        copy = value
    end

    return copy
end
