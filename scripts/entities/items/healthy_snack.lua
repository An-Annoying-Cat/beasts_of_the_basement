local Mod = BotB
local HEALTHY_SNACK = {}
local Items = BotB.Enums.Items

local HealthySnackBonus={
	TEAR=1,
	LUCK=1,
	RANGE=40,
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
	EID:addCollectible(Isaac.GetItemIdByName("Healthy Snack"), "#+1 heart container. #{{Tears}} -1 fire delay. #{{Range}} +1 Range. #{{Luck}} +1 Luck")
end
--Egocentrism moment

--Stats
function HEALTHY_SNACK:onCache(player, cacheFlag)
	if not player:HasCollectible(Items.HEALTHY_SNACK) then return end
	local Multiplier = player:GetCollectibleNum(Items.HEALTHY_SNACK, false)
	if (cacheFlag&CacheFlag.CACHE_FIREDELAY)==CacheFlag.CACHE_FIREDELAY then
	  local tps=30.0/(player.MaxFireDelay+1.0)
	  player.MaxFireDelay=30.0/(math.max(0.1,tps+Multiplier*HealthySnackBonus.TEAR))-1
	end
	if (cacheFlag&CacheFlag.CACHE_RANGE)==CacheFlag.CACHE_RANGE then
	  player.TearRange=player.TearRange+Multiplier*HealthySnackBonus.RANGE
	end
	if (cacheFlag&CacheFlag.CACHE_LUCK)==CacheFlag.CACHE_LUCK then
	  player.Luck=player.Luck+Multiplier*HealthySnackBonus.LUCK
	end
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, HEALTHY_SNACK.onCache)
