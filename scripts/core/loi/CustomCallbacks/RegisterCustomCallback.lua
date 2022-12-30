---@diagnostic disable: duplicate-set-field
local OPTIONAL_PARAMS_PER_OPTIONAL_ARG_TYPE = {
    [TSIL.Enums.CallbackOptionalArgType.GENERIC] = function (param, optionalArgs)
        optionalArgs[#optionalArgs+1] = param
    end,

    [TSIL.Enums.CallbackOptionalArgType.NONE] = function () end,

    [TSIL.Enums.CallbackOptionalArgType.ENTITY_TYPE] = function (param, optionalArgs)
        optionalArgs[#optionalArgs+1] = param.Type
    end,

    [TSIL.Enums.CallbackOptionalArgType.ENTITY_TYPE_VARIANT] = function (param, optionalArgs)
        optionalArgs[#optionalArgs+1] = param.Type
        optionalArgs[#optionalArgs+1] = param.Variant
    end,

    [TSIL.Enums.CallbackOptionalArgType.ENTITY_TYPE_VARIANT_SUBTYPE] = function (param, optionalArgs)
        optionalArgs[#optionalArgs+1] = param.Type
        optionalArgs[#optionalArgs+1] = param.Variant
        optionalArgs[#optionalArgs+1] = param.SubType
    end,

    [TSIL.Enums.CallbackOptionalArgType.ENTITY_VARIANT_SUBTYPE] = function (param, optionalArgs)
        optionalArgs[#optionalArgs+1] = param.Variant
        optionalArgs[#optionalArgs+1] = param.SubType
    end,

    [TSIL.Enums.CallbackOptionalArgType.ENTITY_SUBTYPE] = function (param, optionalArgs)
        optionalArgs[#optionalArgs+1] = param.SubType
    end,

    [TSIL.Enums.CallbackOptionalArgType.GRID_TYPE] = function (param, optionalArgs)
        optionalArgs[#optionalArgs+1] = param:GetType()
    end,

    [TSIL.Enums.CallbackOptionalArgType.GRID_TYPE_VARIANT] = function (param, optionalArgs)
        optionalArgs[#optionalArgs+1] = param:GetType()
        optionalArgs[#optionalArgs+1] = param:GetVariant()
    end,

    [TSIL.Enums.CallbackOptionalArgType.GRID_VARIANT] = function (param, optionalArgs)
        optionalArgs[#optionalArgs+1] = param:GetVariant()
    end,

    [TSIL.Enums.CallbackOptionalArgType.PLAYER_TYPE_VARIANT] = function (param, optionalArgs)
        optionalArgs[#optionalArgs+1] = param:GetPlayerType()
        optionalArgs[#optionalArgs+1] = param.Variant
    end,

    [TSIL.Enums.CallbackOptionalArgType.PLAYER_TYPE] = function (param, optionalArgs)
        optionalArgs[#optionalArgs+1] = param:GetPlayerType()
    end,
}


local function GetOptionalParams(functionParams, optionalArgTypes)
    local optionalArgs = {}

    for index, optionalArgType in ipairs(optionalArgTypes) do
        OPTIONAL_PARAMS_PER_OPTIONAL_ARG_TYPE[optionalArgType](functionParams[index], optionalArgs)
    end

    return optionalArgs
end


local function CheckOptionalParams(param, optionalParams)
    if type(param) ~= "table" then
        return optionalParams[1] == param
    end

    for index, targetParam in ipairs(optionalParams) do
        if param[index] ~= nil and param[index] ~= targetParam then
            return false
        end
    end

    return true
end


function TSIL.__RegisterCustomCallback(callback, returnMode, ...)
    local optionalArgTypes = {...}
    local CallbackReturnMode = TSIL.Enums.CallbackReturnMode

    if returnMode == nil then
        returnMode = CallbackReturnMode.NONE
    end

    local registeredCustomCallbacks = TSIL.__VERSION_PERSISTENT_DATA.RegisteredCustomCallbacks

    local foundRegistered = registeredCustomCallbacks[callback]

    if foundRegistered and foundRegistered.Version > TSIL.__LOCAL_VERSION then
        return
    end

    local newRegistered = {
        Version = TSIL.__LOCAL_VERSION,
        Trigger = function (...)
            local functionParams = {...}
            local optionalParams = GetOptionalParams(functionParams, optionalArgTypes)


            local callbacks = Isaac.GetCallbacks(callback)
            local filteredCallbacks = {}

            for _, callbackEntry in ipairs(callbacks) do
                local param = callbackEntry.Param

                if (param == nil or #optionalParams == 0) or
                CheckOptionalParams(param, optionalParams) then
                    filteredCallbacks[#filteredCallbacks+1] = callbackEntry
                end
            end

            if #filteredCallbacks == 0 then return end

            local finalReturn

            for _, callbackEntry in ipairs(filteredCallbacks) do
                local status, returnValue = pcall(callbackEntry.Function, callbackEntry.Mod, ...)

                if status and returnValue ~= nil then
                    if returnMode == CallbackReturnMode.SKIP_NEXT then
                        return returnValue
                    elseif returnMode == CallbackReturnMode.LAST_WINS then
                        finalReturn = returnValue
                    elseif returnMode == CallbackReturnMode.NEXT_ARGUMENT then
                        finalReturn = returnValue

                        if type(returnValue) == "table" then
                            for i, n in ipairs(returnValue) do
                                functionParams[i] = n
                            end
                        else
                            functionParams[1] = returnValue
                        end
                    end
                end
            end

            return finalReturn
        end
    }

    registeredCustomCallbacks[callback] = newRegistered
end




function TSIL.__TriggerCustomCallback(callback, ...)
    local registeredCustomCallbacks = TSIL.__VERSION_PERSISTENT_DATA.RegisteredCustomCallbacks

    local foundRegistered = registeredCustomCallbacks[callback]

    if not foundRegistered then return end

    return foundRegistered.Trigger(...)
end
