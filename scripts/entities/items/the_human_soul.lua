local Mod = BotB
local THE_HUMAN_SOUL = {}
local Items = BotB.Enums.Items

local SoulBonus={
	TEAR=0.5,
	SPEED=0.25,
	LUCK=2.0,
	RANGE=30,
	DAMAGE=2
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
	EID:addCollectible(Isaac.GetItemIdByName("The Human Soul"), "Major all stats up. #Birthright is added to all item pools, but is removed from said pools once all players with The Human Soul also have Birthright.")
end
--Egocentrism moment

--Stats
function THE_HUMAN_SOUL:onCache(player, cacheFlag)
	if not player:HasCollectible(Items.THE_HUMAN_SOUL) then return end
	local Multiplier = player:GetCollectibleNum(Items.THE_HUMAN_SOUL, false)
	if (cacheFlag&CacheFlag.CACHE_DAMAGE)==CacheFlag.CACHE_DAMAGE then
	  player.Damage=player.Damage+Multiplier*SoulBonus.DAMAGE
	end
	if (cacheFlag&CacheFlag.CACHE_FIREDELAY)==CacheFlag.CACHE_FIREDELAY then
	  local tps=30.0/(player.MaxFireDelay+1.0)
	  player.MaxFireDelay=30.0/(math.max(0.1,tps+Multiplier*SoulBonus.TEAR))-1
	end
	if (cacheFlag&CacheFlag.CACHE_RANGE)==CacheFlag.CACHE_RANGE then
	  player.TearRange=player.TearRange+Multiplier*SoulBonus.RANGE
	end
	if (cacheFlag&CacheFlag.CACHE_SPEED)==CacheFlag.CACHE_SPEED then
	  player.MoveSpeed=player.MoveSpeed+Multiplier*SoulBonus.SPEED
	end
	if (cacheFlag&CacheFlag.CACHE_LUCK)==CacheFlag.CACHE_LUCK then
	  player.Luck=player.Luck+Multiplier*SoulBonus.LUCK
	end
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, THE_HUMAN_SOUL.onCache)

--Replacement chance
function THE_HUMAN_SOUL:replacePedestal(pickup)
	local config = Isaac.GetItemConfig()
	local item = config:GetCollectible(pickup.SubType)
	local room = game:GetRoom()
	
	if pickup.SubType ~= 0 and not item:HasTags(ItemConfig.TAG_QUEST) and pickup.SubType ~= Items.THE_HUMAN_SOUL and pickup.SubType ~= CollectibleType.COLLECTIBLE_BIRTHRIGHT and pickup.FrameCount == 1 then
		local numPlaceholders = 0
		local doTheyActuallyHaveThem = false
		local players = getPlayers()
		for i=1,#players,1 do
			if players[i]:HasCollectible(Items.THE_HUMAN_SOUL) then
				if players[i]:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
					doTheyActuallyHaveThem = false
				else
					numPlaceholders = numPlaceholders + players[i]:GetCollectibleNum(Items.THE_HUMAN_SOUL, false)
					doTheyActuallyHaveThem = true
				end
			end
		end

		if doTheyActuallyHaveThem == true or numPlaceholders ~= 0 then
			local room = Game():GetRoom()
        	local chance = Mod.Functions.RNG:RandomInt(room:GetSpawnSeed(), 10)
			print(chance .. " out of 10")
			--print(chance .. "/" .. 80*(0.5^(0.5*(numPlaceholders-1))))
			--print(numPlaceholders)
			if chance == 8 then
				--sfx:Play(SoundEffect.SOUND_EDEN_GLITCH,0.5,0,false,math.random(20, 40)/100)
				--sfx:Play(SoundEffect.SOUND_DOGMA_BLACKHOLE_OPEN,0.5,0,false,math.random(60, 80)/100)
				local rubble = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.CRACK_THE_SKY,0,pickup.Position,Vector.Zero,pickup)
				pickup:Morph(5, 100, CollectibleType.COLLECTIBLE_BIRTHRIGHT, true)
			end
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, THE_HUMAN_SOUL.replacePedestal, 100)
