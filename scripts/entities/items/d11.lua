local Mod = BotB
local mod = FiendFolio
local D11 = {}
local pickups = BotB.Enums.Pickups
local sfx = SFXManager()

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("D11"), "Rerolls all consumables (pills, cards, runes, etc) in the room.")
end

local HiddenItemManager = require("scripts.core.hidden_item_manager")
function D11:dustyD6ActiveItem(_, _, player, _, _, _)
	--player:AnimateCollectible(Isaac.GetItemIdByName("D11"))
	--print("lol how do i card")
	--print(#Isaac.GetItemConfig():GetCards())
	--At least I can get how many cards there are!
	--local cardIDLimit = (#Isaac.GetItemConfig():GetCards())-1
	--Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,math.random(1,cardIDLimit),Isaac.GetFreeNearPosition(player.Position, 10),Vector.Zero,player)
	local room = Game():GetRoom()
	local roomEntities = room:GetEntities() -- cppcontainer
        for i = 0, #roomEntities - 1 do
            local entity = roomEntities:Get(i)
            --print(entity.Type, entity.Variant, entity.SubType)
            if (entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_TAROTCARD) or (entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_PILL) then
                local spawnPos = entity.Position
                local cardIDLimit = (#Isaac.GetItemConfig():GetCards())-1
                local entityPickup = entity:ToPickup()
				if math.random() < 0.25 then
					local randoPick = math.random(0,1)
					if randoPick == 0 then
						--pill
						Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, spawnPos, Vector.Zero, entityPickup)
						entityPickup:Remove()
					elseif randoPick == 1 then
						--horse pill
						local pill = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, spawnPos, Vector.Zero, entityPickup):ToPickup()
						entityPickup:Remove()
						--entityPickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, true, true, true)
						local pillToGiant = entityPickup.SubType + PillColor.PILL_GIANT_FLAG
						pill:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, pillToGiant, true, true, true)

					end
				else
					entityPickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, math.random(1,cardIDLimit), true, true, true)
				end
                
                --Golden trinket or mom's box: You get a choice between however many consumables instead of just one

            end
        end  
end
Mod:AddCallback(ModCallbacks.MC_USE_ITEM,D11.dustyD6ActiveItem,Isaac.GetItemIdByName("D11"))



