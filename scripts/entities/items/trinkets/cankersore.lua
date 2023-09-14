local Mod = BotB
local CANKER_SORE = {}

if EID then
	EID:addTrinket(Isaac.GetTrinketIdByName("Canker Sore"), "Grants a fading boost to fire rate after the player successfully picks up any kind of heart, accompanied by fake damage.")
end

function CANKER_SORE:getHeart(pickup,collider,_)
    local pickupdata = pickup:GetData()
    local sprite = pickup:GetSprite()
    --print(pickup.Type .. "," .. pickup.Variant .. "," .. pickup.SubType)
	
    if collider.Type == Isaac.GetEntityTypeByName("Player") and collider:ToPlayer():HasTrinket(BotB.Enums.Trinkets.CANKER_SORE, true) then
		local player = collider:ToPlayer()
		local data = player:GetData()
		local cankerSoreCheck = false
        if (pickup.SubType == HeartSubType.HEART_FULL or pickup.SubType == HeartSubType.HEART_HALF or pickup.SubType == HeartSubType.HEART_DOUBLEPACK) and collider:ToPlayer():CanPickRedHearts() then
			cankerSoreCheck = true
		elseif (pickup.SubType == HeartSubType.HEART_SOUL or pickup.SubType == HeartSubType.HEART_HALF_SOUL or pickup.SubType == HeartSubType.HEART_BLENDED) and collider:ToPlayer():CanPickSoulHearts() then
			cankerSoreCheck = true
		elseif (pickup.SubType == HeartSubType.HEART_BLACK) and collider:ToPlayer():CanPickBlackHearts() then
			cankerSoreCheck = true
		elseif (pickup.SubType == HeartSubType.HEART_GOLDEN) and collider:ToPlayer():CanPickGoldenHearts() then
			cankerSoreCheck = true
		elseif (pickup.SubType == HeartSubType.HEART_ROTTEN) and collider:ToPlayer():CanPickRottenHearts() then
			cankerSoreCheck = true
		elseif (pickup.SubType == HeartSubType.HEART_BONE) and collider:ToPlayer():CanPickBoneHearts() then
			cankerSoreCheck = true
		end
		if cankerSoreCheck then
			if data.cankerSoreTimer ~= nil then
				data.cankerSoreTimer = data.cankerSoreTimer + (480*player:GetTrinketMultiplier(BotB.Enums.Trinkets.CANKER_SORE))
				player:UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, UseFlag.USE_NOANIM)
			end
		end
    end
end

Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION,CANKER_SORE.getHeart,PickupVariant.PICKUP_HEART)


--Timer shit
function CANKER_SORE:playerUpdate(player)
	if not player:HasTrinket(BotB.Enums.Trinkets.CANKER_SORE, true) then return end
	local data = player:GetData()
	local level = Game():GetLevel()
    if data.cankerSoreTimer == nil then
		data.cankerSoreTimer = 0
	end
	if data.cankerSoreTimer ~= 0  then
		data.cankerSoreTimer = data.cankerSoreTimer - 1
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:EvaluateItems()

	end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, CANKER_SORE.playerUpdate, 0)

local cankerTearBonus={
	TEAR=0.5,
}
--Stats
--240 is baseline amt of decay frames for stat boost
function CANKER_SORE:onCankerCache(player, cacheFlag)
	if not player:HasTrinket(BotB.Enums.Trinkets.CANKER_SORE, true) then return end
	local data = player:GetData()
	if data.cankerSoreTimer ~= 0 and data.cankerSoreTimer ~= nil then
		local Multiplier = data.cankerSoreTimer / 240
		if (cacheFlag&CacheFlag.CACHE_FIREDELAY)==CacheFlag.CACHE_FIREDELAY then
		  local tps=30.0/(player.MaxFireDelay+1.0)
		  player.MaxFireDelay=30.0/(math.max(0.1,tps+Multiplier*cankerTearBonus.TEAR))-1
		end
	elseif data.cankerSoreTimer == 0 or data.cankerSoreTimer == nil then
		return
	end
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CANKER_SORE.onCankerCache)