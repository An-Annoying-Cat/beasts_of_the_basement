---@diagnostic disable: duplicate-set-field
function TSIL.Stage.OnRepentanceStage()
    local level = Game():GetLevel()
    local stageType = level:GetStageType()
    
    return stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B
end
