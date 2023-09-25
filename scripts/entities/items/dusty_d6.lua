local Mod = BotB
local mod = FiendFolio
local DUSTY_D6 = {}
local pickups = BotB.Enums.Pickups
local sfx = SFXManager()

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Dusty D6"), "Rerolls item pedestals in the room. #Will only ever reroll items into non-modded ones.")
end


function DUSTY_D6:dustyD6ActiveItem(_, _, player, _, _, _)
	player:AnimateCollectible(Isaac.GetItemIdByName("Dusty D6"))
	local room = Game():GetRoom()
	local roomEntities = room:GetEntities() -- cppcontainer
        for i = 0, #roomEntities - 1 do
            local entity = roomEntities:Get(i)
			if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
				--it's a pedestal item
				local entityPickup = entity:ToPickup()
				local roomType = room:GetType()
				local pool = Game():GetItemPool():GetPoolForRoom(roomType, Game():GetSeeds():GetStartSeed())
				--so now we have the item pool
				local collectibleTypeResult = 0
				for j=0,1000 do
					if collectibleTypeResult == 0 then
						local collectibleTypeToTest = Game():GetItemPool():GetCollectible(pool, false, Random(), CollectibleType.COLLECTIBLE_SAD_ONION)
						
						if collectibleTypeToTest <= 732 then
							collectibleTypeResult = collectibleTypeToTest
							break
						end
					end
				end
				if j == 1000 then
					--failsafe
					collectibleTypeResult = CollectibleType.COLLECTIBLE_BREAKFAST
				end
				entityPickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectibleTypeResult, true, true, false)
			end
		end
            

end
Mod:AddCallback(ModCallbacks.MC_USE_ITEM,DUSTY_D6.dustyD6ActiveItem,Isaac.GetItemIdByName("Dusty D6"))



