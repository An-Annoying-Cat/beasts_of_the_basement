---@diagnostic disable: duplicate-set-field
function TSIL.RNG.GetRandomSeed()
    local randomNumber = Random()
    local safeRandomNumber = math.max(1, randomNumber) -- Ensure the seed can never be 0.
    return safeRandomNumber
end
