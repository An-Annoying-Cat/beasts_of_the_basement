---@diagnostic disable: duplicate-set-field
function TSIL.Stage.OnFirstFloor()
    local effectiveStage = TSIL.Stage.GetEffectiveStage()
    local isOnAscent = TSIL.Stage.OnAscent()

    return effectiveStage == 1 and not isOnAscent
end
