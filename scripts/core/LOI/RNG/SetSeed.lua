---@diagnostic disable: duplicate-set-field
local RECOMMENDED_SHIFT_IDX = 35

function TSIL.RNG.SetSeed(rng, seed)
    assert(seed ~= 0, "You cannot set an RNG object to a seed of 0 or the game will crash.")
    rng:SetSeed(seed, RECOMMENDED_SHIFT_IDX)
end
