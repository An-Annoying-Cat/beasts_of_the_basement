---@diagnostic disable: duplicate-set-field
function TSIL.Log.Log(message)
    local parentFunctionDescription = TSIL.Log.GetParentFunctionDescription()

    if not parentFunctionDescription then
        Isaac.DebugString(message)
    else
        Isaac.DebugString(parentFunctionDescription .. " - " .. message)
    end
end
