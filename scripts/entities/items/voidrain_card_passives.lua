local Mod = BotB
local PLACEHOLDER_ITEM = {}
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
	EID:addCollectible(Isaac.GetItemIdByName("Item"), "Medium all stats up. #Has a 20% chance to replace later items with this item.#{{Warning}} This chance will increase the more copies of this item you and other players have!#{{Warning}} Formula, for nerds: 80*(0.5^(0.5*copies)% chance to not replace")
end
--Egocentrism moment

--Stats
function PLACEHOLDER_ITEM:onCache(player, cacheFlag)
	if not player:HasCollectible(Items.PLACEHOLDER_ITEM) then return end
	local Multiplier = player:GetCollectibleNum(Items.PLACEHOLDER_ITEM, false)
	if (cacheFlag&CacheFlag.CACHE_DAMAGE)==CacheFlag.CACHE_DAMAGE then
	  player.Damage=player.Damage+Multiplier*PlaceholderBonus.DAMAGE
	end
	if (cacheFlag&CacheFlag.CACHE_FIREDELAY)==CacheFlag.CACHE_FIREDELAY then
	  local tps=30.0/(player.MaxFireDelay+1.0)
	  player.MaxFireDelay=30.0/(math.max(0.1,tps+Multiplier*PlaceholderBonus.TEAR))-1
	end
	if (cacheFlag&CacheFlag.CACHE_RANGE)==CacheFlag.CACHE_RANGE then
	  player.TearRange=player.TearRange+Multiplier*PlaceholderBonus.RANGE
	end
	if (cacheFlag&CacheFlag.CACHE_SPEED)==CacheFlag.CACHE_SPEED then
	  player.MoveSpeed=player.MoveSpeed+Multiplier*PlaceholderBonus.SPEED
	end
	if (cacheFlag&CacheFlag.CACHE_LUCK)==CacheFlag.CACHE_LUCK then
	  player.Luck=player.Luck+Multiplier*PlaceholderBonus.LUCK
	end

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
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, PLACEHOLDER_ITEM.onCache)

--Replacement chance
function PLACEHOLDER_ITEM:replacePedestal(pickup)
	local config = Isaac.GetItemConfig()
	local item = config:GetCollectible(pickup.SubType)
	local room = game:GetRoom()

	if pickup.SubType ~= 0 and not item:HasTags(ItemConfig.TAG_QUEST) and pickup.SubType ~= Items.PLACEHOLDER_ITEM and pickup.FrameCount == 1 then
		local numPlaceholders = 0
		local doTheyActuallyHaveThem = false
		local players = getPlayers()
		for i=1,#players,1 do
			if players[i]:HasCollectible(Items.PLACEHOLDER_ITEM) then
				numPlaceholders = numPlaceholders + players[i]:GetCollectibleNum(Items.PLACEHOLDER_ITEM, false)
				doTheyActuallyHaveThem = true
			end
		end

		if doTheyActuallyHaveThem == true then
			local chance = math.random(100)
			print(chance .. "/" .. 80*(0.5^(0.5*(numPlaceholders-1))))
			print(numPlaceholders)
			if chance >= 80*(0.5^(0.5*numPlaceholders)) then
				sfx:Play(SoundEffect.SOUND_EDEN_GLITCH,0.5,0,false,math.random(20, 40)/100)
				sfx:Play(SoundEffect.SOUND_DOGMA_BLACKHOLE_OPEN,0.5,0,false,math.random(60, 80)/100)
				for i=0,5,1 do
					local rubble = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.SPRITE_TRAIL,0,pickup.Position,Vector((0.1*math.random(-10,10)),(0.1*math.random(-10,10))),pickup)
				end
				pickup:Morph(5, 100, Items.PLACEHOLDER_ITEM, true)
			end
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, PLACEHOLDER_ITEM.replacePedestal, 100)
