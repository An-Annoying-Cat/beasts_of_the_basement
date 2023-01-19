---@diagnostic disable: duplicate-set-field
function TSIL.Stage.GetEffectiveStage()
    local level = Game():GetLevel()
    local stage = level:GetStage()

    if TSIL.Stage.OnRepentanceStage() then
        return stage + 1
    end

    return stage
end
