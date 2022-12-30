---@diagnostic disable: duplicate-set-field
local KEYS = {"l", "h"}
local OBJECT_NAME = "BitSet128"






function TSIL.Serialize.SerializeBitSet128(bitSet128)
    if not TSIL.IsaacAPIClass.IsBitSet128(bitSet128) then
        error("Failed to serialize a " .. OBJECT_NAME .. " object since the provided object was not a userdata " .. OBJECT_NAME .. " class.")
    end

    local bitSet128Table = {}
    TSIL.Utils.Tables.CopyUserdataValuesToTable(bitSet128, KEYS, bitSet128Table)
    bitSet128Table[TSIL.Enums.SerializationBrand.BIT_SET_128] = ""
    return bitSet128Table
end
