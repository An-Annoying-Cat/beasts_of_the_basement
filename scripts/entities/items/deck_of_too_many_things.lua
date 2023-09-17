local Mod = BotB
local mod = FiendFolio
local DECK_OF_TOO_MANY_THINGS = {}
local pickups = BotB.Enums.Pickups
local sfx = SFXManager()

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Deck Of Too Many Things"), "Spawns a random card, rune, or object. #This is COMPLETELY unweighted and includes ALL defined modded consumables.")
end


function DECK_OF_TOO_MANY_THINGS:triggerButtonActiveItem(_, _, player, _, _, _)
	player:AnimateCollectible(Isaac.GetItemIdByName("Deck Of Too Many Things"))
	--print("lol how do i card")
	--print(#Isaac.GetItemConfig():GetCards())
	--At least I can get how many cards there are!
	local cardIDLimit = (#Isaac.GetItemConfig():GetCards())-1
	Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,math.random(1,cardIDLimit),Isaac.GetFreeNearPosition(player.Position, 10),Vector.Zero,player)


end
Mod:AddCallback(ModCallbacks.MC_USE_ITEM,DECK_OF_TOO_MANY_THINGS.triggerButtonActiveItem,Isaac.GetItemIdByName("Deck Of Too Many Things"))



