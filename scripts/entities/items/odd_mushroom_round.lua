local Mod = BotB
local ODD_MUSHROOM_ROUND = {}
local Items = BotB.Enums.Items

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Odd Mushroom (Round)"), "+0.1 tears #+3.75 range #Grants a free use of {{Collectible".. CollectibleType.COLLECTIBLE_WAVY_CAP .."}} Wavy Cap at the beginning of each new floor.")
end
--[[
--Spawn dirt clump and a random worm trinket
FiendFolio.AddItemPickupCallback(function(player)
	--local rng = player:GetCollectibleRNG(BotB.Enums.Items.ODD_MUSHROOM_ROUND)
	--local pickupType = FiendFolio.GetRandomObject(rng)
	Isaac.Spawn(5, 10, HeartSubType.HEART_ROTTEN, room:FindFreePickupSpawnPosition(player.Position, 20)+BotB.FF:shuntedPosition(10, rng), Vector.Zero, nil)
end, nil, BotB.Enums.Items.ODD_MUSHROOM_ROUND)
--]]
--
local OddMushRoundBonus={
	TEAR=0.1,
	RANGE=2.75,
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


--Stats
function ODD_MUSHROOM_ROUND:onCache(player, cacheFlag)
	if not player:HasCollectible(Items.ODD_MUSHROOM_ROUND) then return end
	local Multiplier = player:GetCollectibleNum(Items.ODD_MUSHROOM_ROUND, false)
	if (cacheFlag&CacheFlag.CACHE_FIREDELAY)==CacheFlag.CACHE_FIREDELAY then
	  local tps=30.0/(player.MaxFireDelay+1.0)
	  player.MaxFireDelay=30.0/(math.max(0.1,tps+Multiplier*OddMushRoundBonus.TEAR))-1
	end
	if (cacheFlag&CacheFlag.CACHE_RANGE)==CacheFlag.CACHE_RANGE then
	  player.TearRange=player.TearRange+Multiplier*OddMushRoundBonus.RANGE
	end
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ODD_MUSHROOM_ROUND.onCache)





function ODD_MUSHROOM_ROUND:onNewLevel(player, type)
	--print("test")
	local players = getPlayers()
		for i=1,#players,1 do
			if players[i]:HasCollectible(Items.ODD_MUSHROOM_ROUND) then
				local timesForOddMushToUseWavyCap = players[i]:GetCollectibleNum(Items.ODD_MUSHROOM_ROUND, false)
				for i=0,timesForOddMushToUseWavyCap,1 do
					players[i]:ToPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_WAVY_CAP, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
				end
			end
		end
end
Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ODD_MUSHROOM_ROUND.onNewLevel)



--