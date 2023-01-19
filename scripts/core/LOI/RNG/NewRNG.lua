---@diagnostic disable: duplicate-set-field
function TSIL.RNG.NewRNG(seed)
    seed = seed or TSIL.RNG.GetRandomSeed()
    local rng = RNG()
    TSIL.RNG.SetSeed(rng, seed)
    return rng
end

