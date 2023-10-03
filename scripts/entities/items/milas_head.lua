local Mod = BotB
local mod = FiendFolio
local MILAS_HEAD = {}
local pickups = BotB.Enums.Pickups
local sfx = SFXManager()

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Mila's Head"), "Spawns 4-8 friendly blue ants.")
end

--local HiddenItemManager = require("scripts.core.hidden_item_manager")
function MILAS_HEAD:milasHeadActiveItem(_, _, player, _, _, _)
	--player:AnimateCollectible(Isaac.GetItemIdByName("MILAS_HEAD"))
	--print("lol how do i card")
	--print(#Isaac.GetItemConfig():GetCards())
	--At least I can get how many cards there are!
	--local cardIDLimit = (#Isaac.GetItemConfig():GetCards())-1
	--Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,math.random(1,cardIDLimit),Isaac.GetFreeNearPosition(player.Position, 10),Vector.Zero,player)
	local room = Game():GetRoom()
	local roomEntities = room:GetEntities() -- cppcontainer
	local amount = math.random(4,8)
	for i=1, amount do
		Isaac.Spawn(BotB.Enums.Entities.ATTACK_ANT_ENEMY.TYPE, BotB.Enums.Entities.ATTACK_ANT_ENEMY.VARIANT, 0, player.Position, Vector(6,0):Rotated(math.random(0,359)), player):ToNPC()
	end
	
end
Mod:AddCallback(ModCallbacks.MC_USE_ITEM,MILAS_HEAD.milasHeadActiveItem,Isaac.GetItemIdByName("Mila's Head"))



