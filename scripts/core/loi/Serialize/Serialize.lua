---@diagnostic disable: duplicate-set-field
local ISAAC_API_CLASS_TYPE_TO_BRAND = {
    [TSIL.Enums.CopyableIsaacAPIClassType.BIT_SET_128] = TSIL.Enums.SerializationBrand.BIT_SET_128,
    [TSIL.Enums.CopyableIsaacAPIClassType.COLOR] = TSIL.Enums.SerializationBrand.COLOR,
    [TSIL.Enums.CopyableIsaacAPIClassType.K_COLOR] = TSIL.Enums.SerializationBrand.K_COLOR,
    [TSIL.Enums.CopyableIsaacAPIClassType.RNG] = TSIL.Enums.SerializationBrand.RNG,
    [TSIL.Enums.CopyableIsaacAPIClassType.VECTOR] = TSIL.Enums.SerializationBrand.VECTOR,
}

local function getSerializedTableType(serializedIsaacAPIClass)
    for i, v in pairs(ISAAC_API_CLASS_TYPE_TO_BRAND) do
        if serializedIsaacAPIClass[v] ~= nil then
            return i
        end
    end
end




function TSIL.Serialize.IsCopyableIsaacAPIClass(object)
    return TSIL.IsaacAPIClass.IsBitSet128(object) or
    TSIL.IsaacAPIClass.IsColor(object) or
    TSIL.IsaacAPIClass.IsKColor(object) or
    TSIL.IsaacAPIClass.IsRNG(object) or
    TSIL.IsaacAPIClass.IsVector(object)
end

function TSIL.Serialize.CopyIsaacAPIClass(class)
    if type(class) ~= "userdata" then
        error("Failed to copy an ISaac API class since the provided object was of type: " .. type(class))
    end

    local isaacAPIClassType = TSIL.IsaacAPIClass.GetIsaacAPIClassName(class)

    if isaacAPIClassType == nil then
        error("Failed to copy an Isaac API class since it does not have a class type.")
    end

    local copyableIsaacAPIClassType = isaacAPIClassType

    if copyableIsaacAPIClassType == TSIL.Enums.CopyableIsaacAPIClassType.VECTOR then
        return TSIL.Vector.CopyVector(class)
    elseif copyableIsaacAPIClassType == TSIL.Enums.CopyableIsaacAPIClassType.BIT_SET_128 then
        return TSIL.BitSet128.CopyBitSet128(class)
    elseif copyableIsaacAPIClassType == TSIL.Enums.CopyableIsaacAPIClassType.COLOR then
        return TSIL.Color.CopyColor(class)
    elseif copyableIsaacAPIClassType == TSIL.Enums.CopyableIsaacAPIClassType.K_COLOR then
        return TSIL.Color.CopyKColor(class)
    elseif copyableIsaacAPIClassType == TSIL.Enums.CopyableIsaacAPIClassType.RNG then
        return TSIL.RNG.CopyRNG(class)
    end

    error("Failed to copy an Isaac API class since the associated functions were not found for Isaac API class type: " .. copyableIsaacAPIClassType)
end

function TSIL.Serialize.SerializeIsaacAPIClass(class)
    if type(class) ~= "userdata" then
        error("Failed to serialize an Isaac API class since the provided object was of type: " .. type(class))
    end

    local isaacAPIClassType = TSIL.IsaacAPIClass.GetIsaacAPIClassName(class)

    if isaacAPIClassType == nil then
        error("Failed to serialize an Isaac API class since it does not have a class type.")
    end

    local copyableIsaacAPIClassType = isaacAPIClassType

    if copyableIsaacAPIClassType == TSIL.Enums.CopyableIsaacAPIClassType.VECTOR then
        return TSIL.Serialize.SerializeVector(class)
    elseif copyableIsaacAPIClassType == TSIL.Enums.CopyableIsaacAPIClassType.BIT_SET_128 then
        return TSIL.Serialize.SerializeBitSet128(class)
    elseif copyableIsaacAPIClassType == TSIL.Enums.CopyableIsaacAPIClassType.COLOR then
        return TSIL.Serialize.SerializeColor(class)
    elseif copyableIsaacAPIClassType == TSIL.Enums.CopyableIsaacAPIClassType.K_COLOR then
        return TSIL.Serialize.SerializeKColor(class)
    elseif copyableIsaacAPIClassType == TSIL.Enums.CopyableIsaacAPIClassType.RNG then
        return TSIL.Serialize.SerializeRNG(class)
    end

    error("Failed to serialize an Isaac API class since the associated functions were not found for Isaac API class type: " .. copyableIsaacAPIClassType)
end
