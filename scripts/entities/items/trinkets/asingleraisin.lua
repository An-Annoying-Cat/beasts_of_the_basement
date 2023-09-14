local Mod = BotB
local A_SINGLE_RAISIN = {}
local ff = FiendFolio

if EID then
	EID:addTrinket(Isaac.GetTrinketIdByName("A Single Raisin"), "Picking up hearts has a 25% chance to spawn a half Immoral Heart.")
end

function A_SINGLE_RAISIN:getHeart(pickup,collider,_)
    local pickupdata = pickup:GetData()
    local sprite = pickup:GetSprite()
    --print(pickup.Type .. "," .. pickup.Variant .. "," .. pickup.SubType)
	
    if collider.Type == Isaac.GetEntityTypeByName("Player") and collider:ToPlayer():HasTrinket(BotB.Enums.Trinkets.A_SINGLE_RAISIN, true) then
		local player = collider:ToPlayer()
		local data = player:GetData()
		local singleRaisinCheck = false
        if pickup.Variant == PickupVariant.PICKUP_HEART then
            singleRaisinCheck = true
		end
		if singleRaisinCheck then
			if player:HasTrinket(BotB.Enums.Trinkets.A_SINGLE_RAISIN) then
                local rng = player:GetTrinketRNG(BotB.Enums.Trinkets.A_SINGLE_RAISIN)
                if rng:RandomFloat() < 1 - 0.75 then
                    Isaac.Spawn(5, ff.PICKUP.VARIANT.HALF_IMMORAL_HEART, 0, game:GetRoom():FindFreePickupSpawnPosition(pickup.Position, 40, false), Vector.Zero, nil)
                end
            end
		end
    end
end

Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION,A_SINGLE_RAISIN.getHeart,PickupVariant.PICKUP_HEART)
