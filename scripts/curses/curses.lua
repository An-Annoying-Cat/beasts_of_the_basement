


local function levelHasCurse(level, curse)
    if level == nil then return false end
    if curse == -1 then return false end
    return level:GetCurses() & (1 << curse - 1) >= (1 << curse - 1)
end


