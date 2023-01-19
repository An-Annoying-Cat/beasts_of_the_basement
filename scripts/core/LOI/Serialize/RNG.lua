---@diagnostic disable: duplicate-set-field
local KEYS = {"seed"}
local OBJECT_NAME = "RNG"





function TSIL.Serialize.SerializeRNG(rng)
    if not TSIL.IsaacAPIClass.IsRNG(rng) then
        error("Failed to serialize a " .. OBJECT_NAME .. " object since the provided object was not a userdata " .. OBJECT_NAME .. " class.")
    end

    local rngTable = {}
    TSIL.Utils.Tables.CopyUserdataValuesToTable(rng, KEYS, rngTable)
    rngTable[TSIL.Enums.SerializationBrand.RNG] = ""
    return rngTable
end
