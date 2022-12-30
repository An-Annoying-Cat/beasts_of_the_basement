---@diagnostic disable: duplicate-set-field
function TSIL.Stage.OnAscent()
    return Game():GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH)
end
