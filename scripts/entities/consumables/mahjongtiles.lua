local Mod = BotB
local MAHJONG_TILES = {}
local Tiles = BotB.Enums.Consumables.OBJECTS

function MAHJONG_TILES:OneDotUse(cardID, player)
    for _, e in pairs(Isaac.GetRoomEntities()) do
        if (e.Type == EntityType.ENTITY_PICKUP
        and e.Variant ~= (PickupVariant.PICKUP_COLLECTIBLE
        or PickupVariant.PICKUP_SHOPITEM
        or PickupVariant.PICKUP_TROPHY
        or PickupVariant.PICKUP_BED
        or PickupVariant.PICKUP_MOMSCHEST)) or (e:IsEnemy()
        and e:ToNPC()
		and e:IsActiveEnemy(false)
        and not e:HasMortalDamage()
        and not e:IsBoss()) then
            local c = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 0, e.Position, Vector.Zero, nil)
            c.Parent = player --initially nil so it doesnt remove health from the player when spawning
            e:Remove()
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_USE_CARD, MAHJONG_TILES.OneDotUse, Tiles.ONE_DOT)