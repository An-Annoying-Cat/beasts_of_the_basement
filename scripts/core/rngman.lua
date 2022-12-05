local Mod = BotB
local rngman = {}

local game, rng = Game(), RNG()
local seeds = game:GetSeeds()

BotB.GENERIC_RNG = RNG()
BotB.RECOMMENDED_SHIFT_IDX = 35
Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function ()
	Mod.GENERIC_RNG:SetSeed(Game():GetSeeds():GetStartSeed(), Mod.RECOMMENDED_SHIFT_IDX)
end)


---- set the seed to:
--	Entity.InitSeed for entities
--	Room:GetAwardSeed() for clear rewards and shop items
--	Room:GetSpawnSeed() for enemy spawns and enemy drops
--	Room:GetDecorationSeed() for the background decorations
--	Level:GetDungeonPlacementSeed() for crawl spaces
function rngman:RandomInt(seed, max)
	rng:SetSeed(seed, BotB.RECOMMENDED_SHIFT_IDX)
	return rng:RandomInt(max)
end

-- otherwise use this
function rngman:RandomIntStartSeed(max)
	rng:SetSeed(seeds:GetStartSeed(), BotB.RECOMMENDED_SHIFT_IDX)
	return rng:RandomInt(max)
end

return rngman