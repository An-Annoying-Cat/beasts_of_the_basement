---@diagnostic disable: duplicate-set-field
local DEFAULT_MOD_DATA = "{}"

local function mergeSaveData(oldSaveData, newSaveData)
    TSIL.Utils.Tables.IterateTableInOrder(newSaveData, function (_, persistentVariable)
        for i, oldPersistentVariable in ipairs(oldSaveData) do
            if oldPersistentVariable.name == persistentVariable.name then
                oldSaveData[i] = TSIL.Utils.DeepCopy.DeepCopy(persistentVariable, TSIL.Enums.SerializationType.NONE)
                return
            end
        end

        oldSaveData[#oldSaveData+1] = TSIL.Utils.DeepCopy.DeepCopy(persistentVariable, TSIL.Enums.SerializationType.NONE)
    end)
end

local function readSaveDatFile()
    local ok, jsonStringOrErrMsg = pcall(function()
        return TSIL.__MOD:LoadData()
    end)

    if not ok then
        print([[Failed to read from the "save#.dat" file: ]] .. jsonStringOrErrMsg)
        return DEFAULT_MOD_DATA
    end

    if jsonStringOrErrMsg == nil then
        return DEFAULT_MOD_DATA
    end

    local jsonStringTrimmed = string.gsub(jsonStringOrErrMsg, " ", "")

    if jsonStringOrErrMsg == "" then
        return DEFAULT_MOD_DATA
    end

    return jsonStringTrimmed
end

function TSIL.SaveManager.LoadFromDisk()
    local oldSavedata = TSIL.__VERSION_PERSISTENT_DATA.PersistentData
    if not TSIL.__MOD:HasData() then
        return
    end

    local jsonString = readSaveDatFile()
    local newSaveData = TSIL.JSON.Decode(jsonString)

    TSIL.Utils.Tables.IterateTableInOrder(newSaveData, function(modName, persistentVariables)
        if type(modName) ~= "string" then
            return
        end

        if type(oldSavedata) ~= "table" then
            return
        end

        local newModData = {}

        TSIL.Utils.Tables.IterateTableInOrder(persistentVariables, function(_, variable)
            newModData[#newModData+1] = variable
        end)

        local oldSaveDataForSubscriber = TSIL.Utils.Tables.FindFirst(oldSavedata, function (_, oldModPersistentData)
            return oldModPersistentData.mod == modName
        end)

        if oldSaveDataForSubscriber == nil then
            return
        end

        mergeSaveData(oldSaveDataForSubscriber.variables, persistentVariables)
    end)
end
