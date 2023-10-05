local Mod = BotB
local BUPRINORPHINE = {}
local Items = BotB.Enums.Items

local BuprinorphineBonus={
	TEAR=0.05,
	SHOTSPEED=0.025,
	RANGE=5,
}

function BUPRINORPHINE:getPlayers()
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
	EID:addCollectible(Isaac.GetItemIdByName("Buprinorphine"), "#Grants a stacking buff to {{Tears}} Tears, {{Range}} Range, and {{Shotspeed}} Shot Speed for every pill the player has taken this run. #{{Warning}} Pills will no longer spawn!")
end
--Egocentrism moment

--Stats
function BUPRINORPHINE:onCache(player, cacheFlag)
	if not player:HasCollectible(Items.BUPRINORPHINE) then return end
	local data = player:GetData()
	if data.numPillsTakenThisRun == nil then
		data.numPillsTakenThisRun = 1
	end
	local Multiplier = player:GetCollectibleNum(Items.BUPRINORPHINE, false) * data.numPillsTakenThisRun
	if (cacheFlag&CacheFlag.CACHE_FIREDELAY)==CacheFlag.CACHE_FIREDELAY then
	  local tps=30.0/(player.MaxFireDelay+1.0)
	  player.MaxFireDelay=30.0/(math.max(0.1,tps+Multiplier*BuprinorphineBonus.TEAR))-1
	end
	if (cacheFlag&CacheFlag.CACHE_RANGE)==CacheFlag.CACHE_RANGE then
	  player.TearRange=player.TearRange+Multiplier*BuprinorphineBonus.RANGE
	end
	if (cacheFlag&CacheFlag.CACHE_SHOTSPEED)==CacheFlag.CACHE_SHOTSPEED then
	  player.ShotSpeed=player.ShotSpeed+Multiplier*BuprinorphineBonus.SHOTSPEED
	end
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BUPRINORPHINE.onCache)





function BUPRINORPHINE:incrementCounter(pillID, player)
	--sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER,2,0,false,1)
	local data = player:GetData()
	--sfx:Play(BotB.Enums.SFX.VOIDRAIN_CARD,2,0,false,1)
	--HiddenItemManager:AddForFloor(player,BotB.Enums.Items.STARLIGHT)
	if data.numPillsTakenThisRun == nil then
		data.numPillsTakenThisRun = 1
	else
		data.numPillsTakenThisRun = data.numPillsTakenThisRun + 1
	end
end
Mod:AddCallback(ModCallbacks.MC_USE_PILL, BUPRINORPHINE.incrementCounter)



--
function BUPRINORPHINE:deletePills(pickup)
	--sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER,2,0,false,1)
	local someoneHasBup = false
	local players = BUPRINORPHINE:getPlayers()
		for i=1,#players,1 do
			if players[i]:HasCollectible(Items.BUPRINORPHINE) then
				someoneHasBup = true
			end
		end
	if someoneHasBup ~= true then return end
		if pickup.SubType >= PillColor.PILL_GIANT_FLAG then
					Isaac.Spawn(EntityType.ENTITY_PICKUP,0,0,Isaac.GetFreeNearPosition(pickup.Position, 10),Vector.Zero,pickup)
				end
				if pickup.SubType == PillColor.PILL_GOLD then
					Isaac.Spawn(EntityType.ENTITY_PICKUP,0,0,Isaac.GetFreeNearPosition(pickup.Position, 10),Vector.Zero,pickup)
					Isaac.Spawn(EntityType.ENTITY_PICKUP,0,0,Isaac.GetFreeNearPosition(pickup.Position, 10),Vector.Zero,pickup)
					Isaac.Spawn(EntityType.ENTITY_PICKUP,0,0,Isaac.GetFreeNearPosition(pickup.Position, 10),Vector.Zero,pickup)
				end
				Isaac.Spawn(EntityType.ENTITY_PICKUP,0,0,Isaac.GetFreeNearPosition(pickup.Position, 10),Vector.Zero,pickup)
				pickup:Remove()
end
Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, BUPRINORPHINE.deletePills, PickupVariant.PICKUP_PILL)