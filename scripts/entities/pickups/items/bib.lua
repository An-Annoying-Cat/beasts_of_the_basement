local Mod = BotB
local BIB = {}

function BIB:updateDevilledEggFireDelay(player)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.DEVILLED_EGG) then
		player.MaxFireDelay = Mod.Functions.TearsUp(player.MaxFireDelay, (0.3 * player:GetCollectibleNum(CollectibleType.COLLECTIBLE_DEVILLED_EGG)))
	end
end
--cache thing