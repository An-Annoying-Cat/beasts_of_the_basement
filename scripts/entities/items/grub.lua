local Mod = BotB
local GRUB = {}
local Items = BotB.Enums.Items

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Grub"), "+1 empty heart container. #Spawns a {{RottenHeart}} Rotten Heart, and gives the player {{Trinket".. TrinketType.TRINKET_LIL_LARVA .."}} Lil Larva as a passive effect.")
end
--[[
--Spawn dirt clump and a random worm trinket
FiendFolio.AddItemPickupCallback(function(player)
	--local rng = player:GetCollectibleRNG(BotB.Enums.Items.GRUB)
	--local pickupType = FiendFolio.GetRandomObject(rng)
	Isaac.Spawn(5, 10, HeartSubType.HEART_ROTTEN, room:FindFreePickupSpawnPosition(player.Position, 20)+BotB.FF:shuntedPosition(10, rng), Vector.Zero, nil)
end, nil, BotB.Enums.Items.GRUB)
--]]
--
function GRUB:onItemGet(player, type)
	--print("test")
	local room = Game():GetRoom()
	if type == Isaac.GetItemIdByName("Grub") then
		Isaac.Spawn(5, 10, HeartSubType.HEART_ROTTEN, room:FindFreePickupSpawnPosition(player.Position, 20), Vector.Zero, nil)
		TSIL.Players.AddSmeltedTrinket(player,TrinketType.TRINKET_LIL_LARVA)
	end
end
Mod:AddCallback(TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED, GRUB.onItemGet)



--