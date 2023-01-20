---@diagnostic disable: duplicate-set-field
local KEYS = {"X", "Y"}
local OBJECT_NAME = "Vector"



function TSIL.Serialize.SerializeVector(vector)
    if not TSIL.IsaacAPIClass.IsVector(vector) then
        error("Failed to serialize a " .. OBJECT_NAME .. " object since the provided object was not a userdata " .. OBJECT_NAME .. " class.")
    end

    local vectorTable = {}
    TSIL.Utils.Tables.CopyUserdataValuesToTable(vector, KEYS, vectorTable)
    vectorTable[TSIL.Enums.SerializationBrand.VECTOR] = ""
    return vectorTable
end
