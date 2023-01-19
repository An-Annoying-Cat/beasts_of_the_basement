---@diagnostic disable: duplicate-set-field
local KEYS = {"Red", "Green", "Blue", "Alpha"}
local OBJECT_NAME = "KColor"





function TSIL.Serialize.SerializeKColor(kColor)
    if not TSIL.IsaacAPIClass.IsKColor(kColor) then
        error("Failed to serialize a " .. OBJECT_NAME .. " object since the provided object was not a userdata " .. OBJECT_NAME .. " class.")
    end

    local kColorTable = {}
    TSIL.Utils.Tables.CopyUserdataValuesToTable(kColor, KEYS, kColorTable)
    kColorTable[TSIL.Enums.SerializationBrand.K_COLOR] = ""
    return kColorTable
end
