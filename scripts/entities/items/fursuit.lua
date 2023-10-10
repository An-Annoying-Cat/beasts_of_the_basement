local Mod = BotB
local mod = FiendFolio
local FURSUIT = {}
local pickups = BotB.Enums.Pickups
local sfx = SFXManager()
local Items = BotB.Enums.Items


--local HiddenItemManager = require("scripts.core.hidden_item_manager")
if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Fursuit"), "Single-use active. #Grants you two animal-related passive items (Guppy, Cricket, etc) and one animal-related active item.")
end

local vanillaAnimalPassives = {
  CollectibleType.COLLECTIBLE_CRICKETS_HEAD,
  CollectibleType.COLLECTIBLE_CRICKETS_BODY,
  CollectibleType.COLLECTIBLE_DINNER, --It's dog food!
  CollectibleType.COLLECTIBLE_LUNCH, --It's also dog food!
  CollectibleType.COLLECTIBLE_SUPPER, --It's cat food!
  CollectibleType.COLLECTIBLE_DESSERT,
  CollectibleType.COLLECTIBLE_GUPPYS_COLLAR,
  CollectibleType.COLLECTIBLE_GUPPYS_EYE,
  CollectibleType.COLLECTIBLE_GUPPYS_HAIRBALL,
  CollectibleType.COLLECTIBLE_GUPPYS_TAIL,
  CollectibleType.COLLECTIBLE_GOAT_HEAD,
  CollectibleType.COLLECTIBLE_MUTANT_SPIDER,
  CollectibleType.COLLECTIBLE_DEAD_DOVE,
  CollectibleType.COLLECTIBLE_SISSY_LONGLEGS,
  CollectibleType.COLLECTIBLE_DADDY_LONGLEGS,
  CollectibleType.COLLECTIBLE_DEAD_CAT,
  CollectibleType.COLLECTIBLE_DEAD_BIRD,
  CollectibleType.COLLECTIBLE_BIRD_CAGE,
  CollectibleType.COLLECTIBLE_TAURUS,
  CollectibleType.COLLECTIBLE_ARIES,
  CollectibleType.COLLECTIBLE_LEO,
  CollectibleType.COLLECTIBLE_CANCER,
  CollectibleType.COLLECTIBLE_CAPRICORN,
  CollectibleType.COLLECTIBLE_PISCES,
  CollectibleType.COLLECTIBLE_INFESTATION_2,
  CollectibleType.COLLECTIBLE_CHARM_VAMPIRE,
  CollectibleType.COLLECTIBLE_PARASITOID,
  CollectibleType.COLLECTIBLE_FRUITY_PLUM,
  CollectibleType.COLLECTIBLE_BBF,
  --FF
  Isaac.GetItemIdByName("Bee Skin"),
  Isaac.GetItemIdByName("Dichromatic Butterfly"),
  Isaac.GetItemIdByName("Ophiuchus"),
  Isaac.GetItemIdByName("Cetus"),
  Isaac.GetItemIdByName("Musca"),
  Isaac.GetItemIdByName("Spelling Bee"),
  --BOTB
  Isaac.GetItemIdByName("B.H.F."),
  Isaac.GetItemIdByName("Mila's Collar"),
  Isaac.GetItemIdByName("Amorphous Globosa"),
  Isaac.GetItemIdByName("Buzz Fly"),
  Isaac.GetItemIdByName("Liquid Latex"), --lmao Changed

}

local vanillaAnimalActives = {
  CollectibleType.COLLECTIBLE_GUPPYS_PAW,
  CollectibleType.COLLECTIBLE_GUPPYS_HEAD,
  CollectibleType.COLLECTIBLE_PONY,
  CollectibleType.COLLECTIBLE_WHITE_PONY,
  CollectibleType.COLLECTIBLE_PLUM_FLUTE,
  CollectibleType.COLLECTIBLE_TAMMYS_HEAD,
  CollectibleType.COLLECTIBLE_BOX_OF_SPIDERS,
  CollectibleType.COLLECTIBLE_JAR_OF_FLIES,
  --FF
  Isaac.GetItemIdByName("Golden Plum Flute"),
  Isaac.GetItemIdByName("Kalu's Severed Head"),
  Isaac.GetItemIdByName("Rat Poison"),
  --BOTB
  Isaac.GetItemIdByName("Mila's Head"),
}


if Retribution then
  local retAnimalPassives = {
    Isaac.GetItemIdByName("Axolotl"),
    Isaac.GetItemIdByName("Baron Fly"),
    Isaac.GetItemIdByName("Bedbug"),
    Isaac.GetItemIdByName("Frail Fly"),
    Isaac.GetItemIdByName("Moxie's Head"),
    Isaac.GetItemIdByName("Sloth's Toe"),
    Isaac.GetItemIdByName("Silver Flesh"), --I mean, the mask Zacharie wears (which is this item's sprite) is specifically meant to be a cat, so...
    Isaac.GetItemIdByName("Sunken Fly"),
    Isaac.GetItemIdByName("Ham"),
    Isaac.GetItemIdByName("Melitodes"),
    Isaac.GetItemIdByName("Beeconomy"),
    Isaac.GetItemIdByName("Packaged Ham"),
    Isaac.GetItemIdByName("50% Beeconomy"),
    Isaac.GetItemIdByName("Milk of Baphomet"),
    Isaac.GetItemIdByName("Guppy's Pride"),
  }
  for i=1,#vanillaAnimalPassives do
    vanillaAnimalPassives[#vanillaAnimalPassives+1] = retAnimalPassives[i]
  end
end

if Retribution then
  local retAnimalActives = {
    Isaac.GetItemIdByName("Fry's Paw"),
  }
  for i=1,#vanillaAnimalActives do
    vanillaAnimalActives[#vanillaAnimalActives+1] = retAnimalActives[i]
  end
end

if TaintedTreasures then
  local ttAnimalPassives = {
    Isaac.GetItemIdByName("Cricket's Cranium"),
    Isaac.GetItemIdByName("Spider Freak"),
  }
  for i=1,#vanillaAnimalPassives do
    vanillaAnimalPassives[#vanillaAnimalPassives+1] = ttAnimalPassives[i]
  end
end

if Revelations then
  local revAnimalPassives = {
    Isaac.GetItemIdByName("Tummy Bug"),
    Isaac.GetItemIdByName("Half Chewed Pony"),
    Isaac.GetItemIdByName("Moxie's Paw"),
    Isaac.GetItemIdByName("Moxie's Yarn"),
  }
  for i=1,#vanillaAnimalPassives do
    vanillaAnimalPassives[#vanillaAnimalPassives+1] = revAnimalPassives[i]
  end
end

if Revelations then
  local revAnimalActives = {
    Isaac.GetItemIdByName("Moxie's Paw"),
    Isaac.GetItemIdByName("Moxie's Yarn"),
  }
  for i=1,#vanillaAnimalPassives do
    vanillaAnimalActives[#vanillaAnimalActives+1] = revAnimalActives[i]
  end
end



function FURSUIT:toyPhoneActiveItem(_, _, player, _, slot, _)
	player:AnimateCollectible(Isaac.GetItemIdByName("Fursuit"))
  SFXManager():Play(BotB.Enums.SFX.FURSUIT_MEOW, 8, 0, false, math.random(90,110)/100,0)
  player:RemoveCollectible(Items.FURSUIT)	
  Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,vanillaAnimalActives[math.random(1,#vanillaAnimalActives)],Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero, player)
  Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,vanillaAnimalPassives[math.random(1,#vanillaAnimalPassives)],Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero, player)
  Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,vanillaAnimalPassives[math.random(1,#vanillaAnimalPassives)],Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero, player)
end
Mod:AddCallback(ModCallbacks.MC_USE_ITEM,FURSUIT.toyPhoneActiveItem,Isaac.GetItemIdByName("Fursuit"))
