---@diagnostic disable: duplicate-set-field
local KEYS = {"R", "G", "B", "A", "RO", "GO", "BO"}
local OBJECT_NAME = "Color"






function TSIL.Serialize.SerializeColor(color)
    if not TSIL.IsaacAPIClass.IsColor(color) then
        error("Failed to serialize a " .. OBJECT_NAME .. " object since the provided object was not a userdata " .. OBJECT_NAME .. " class.")
    end

    local colorTable = {}
    TSIL.Utils.Tables.CopyUserdataValuesToTable(color, KEYS, colorTable)
    colorTable[TSIL.Enums.SerializationBrand.COLOR] = ""
    return colorTable
end
