local Mod = BotB
local PLACEHOLDER_ITEM = {}
local Items = BotB.Enums.Items

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Grub"), "+1 empty heart container. Spawns a {{RottenHeart}}Rotten Heart.")
end

--Spawn dirt clump and a random worm trinket
FiendFolio.AddItemPickupCallback(function(player)
	--local rng = player:GetCollectibleRNG(BotB.Enums.Items.GRUB)
	--local pickupType = FiendFolio.GetRandomObject(rng)
	Isaac.Spawn(5, 10, HeartSubType.HEART_ROTTEN, room:FindFreePickupSpawnPosition(player.Position, 20)+BotB.FF:shuntedPosition(10, rng), Vector.Zero, nil)
end, nil, BotB.Enums.Items.GRUB)