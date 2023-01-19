local Mod = BotB
local VOIDRAIN_PASSIVES = {}
local Items = BotB.Enums.Items

local PlaceholderBonus={
	TEAR=0.2,
	SPEED=0.1,
	LUCK=0.5,
	RANGE=10,
	DAMAGE=0.75
}

local function getPlayers()
	local game = Game()
	local numPlayers = game:GetNumPlayers()
  
	local players = {}
	for i = 0, numPlayers - 1 do
	  local player = Isaac.GetPlayer(i)
	  table.insert(players, player)
	end
  
	return players
end

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Quicklove"), "x1.12 damage multiplier.")
	EID:addCollectible(Isaac.GetItemIdByName("Starlight"), "2 heart containers and a 20% chance to block damage.")
	EID:addCollectible(Isaac.GetItemIdByName("Lucky Flower"), "+0.5 Luck per completed room until the end of the floor. #Luck bonus persists afterward.")
	EID:addCollectible(Isaac.GetItemIdByName("Pale Box"), "Gives the effect of Polydactyly. #Spawns a Wooden (Toy, eventually) Chest at the beginning of each floor, and every time a boss or miniboss is defeated.")
end
--Egocentrism moment

--Stats
function VOIDRAIN_PASSIVES:onCache(player, cacheFlag)

	if player:HasCollectible(Items.QUICKLOVE) then
		local Multiplier = player:GetCollectibleNum(Items.QUICKLOVE, false)
		if (cacheFlag&CacheFlag.CACHE_DAMAGE)==CacheFlag.CACHE_DAMAGE then
			player.Damage=player.Damage*(1.12*Multiplier)
		end
	end

	if player:HasCollectible(Items.STARLIGHT) then
		local Multiplier = player:GetCollectibleNum(Items.STARLIGHT, false)
		if (cacheFlag&CacheFlag.CACHE_DAMAGE)==CacheFlag.CACHE_DAMAGE then
			player.Damage=player.Damage*(1.12*Multiplier)
		end
	end

end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, VOIDRAIN_PASSIVES.onCache)
