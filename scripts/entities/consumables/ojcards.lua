local Mod = BotB
local OJCARDS = {}

if EID then
	EID:addCard(Mod.Enums.Consumables.CARDS.OH_MY_FRIEND, "Has a 50/50 chance of either effect: #Uses {{Collectible".. CollectibleType.COLLECTIBLE_DELIRIOUS .."}} Delirious. #Uses {{Collectible".. Isaac.GetItemIdByName("The Fiend Folio") .."}} The Fiend Folio.")
	EID:addCard(Mod.Enums.Consumables.CARDS.FLIP_OUT, "The next time the player gets hurt, negate the damage. All enemies and bosses in the room take 40 damage (ignoring boss armor!) and drop 3 pennies when this occurs.")
	EID:addCard(Mod.Enums.Consumables.CARDS.MIMYUUS_HAMMER, "When used, this card is placed on the ground where it idly spins. #The first enemy to step on this card takes 60 damage, and the card is consumed in the process.")
	EID:addCard(Mod.Enums.Consumables.CARDS.FLAMETHROWER, "When used, this card is placed on the ground where it idly spins. #The first enemy to step on this card is instantly killed, and drops a number of cards proportional to its max health. #{{Warning}} Bosses are not instantly killed. However, they still drop cards (although at a decreased rate), and their health is lowered to one quarter of its maximum.")
end

--Use player:GetData().activeRoomCards for cards whose effects last for one room
--Use player:GetData().activeFloorCards for cards whose effects last for the floor


--Flip Out
function OJCARDS:flipOutInit(cardID, player)
	local data = player:GetData()
	--print("AugPres = " .. Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE)
	--table.insert(player:GetData().activeRoomCards,Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TAROT_CLOTH, false) then
		data.amountFlipOut = data.amountFlipOut + 2
	else
		data.amountFlipOut = data.amountFlipOut + 1
	end
	sfx:Play(BotB.Enums.SFX.OJ_CARD,1,0,false,1)
end
Mod:AddCallback(ModCallbacks.MC_USE_CARD, OJCARDS.flipOutInit, Mod.Enums.Consumables.CARDS.FLIP_OUT)

--Mimyuu's Hammer
function OJCARDS:mimyuusHammerInit(cardID, player)
	local data = player:GetData()
	--print("AugPres = " .. Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE)
	--table.insert(player:GetData().activeRoomCards,Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TAROT_CLOTH, false) then
		Isaac.Spawn(BotB.Enums.Entities.OJ_TRAPCARD.TYPE,BotB.Enums.Entities.OJ_TRAPCARD.VARIANT,0,player.Position,Vector.Zero,player)
		Isaac.Spawn(BotB.Enums.Entities.OJ_TRAPCARD.TYPE,BotB.Enums.Entities.OJ_TRAPCARD.VARIANT,0,player.Position,Vector.Zero,player)
	else
		Isaac.Spawn(BotB.Enums.Entities.OJ_TRAPCARD.TYPE,BotB.Enums.Entities.OJ_TRAPCARD.VARIANT,0,player.Position,Vector.Zero,player)
	end
	sfx:Play(BotB.Enums.SFX.OJ_CARD,1,0,false,1)
end
Mod:AddCallback(ModCallbacks.MC_USE_CARD, OJCARDS.mimyuusHammerInit, Mod.Enums.Consumables.CARDS.MIMYUUS_HAMMER)

--Flamethrower
function OJCARDS:flameThrowerInit(cardID, player)
	local data = player:GetData()
	--print("AugPres = " .. Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE)
	--table.insert(player:GetData().activeRoomCards,Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TAROT_CLOTH, false) then
		Isaac.Spawn(BotB.Enums.Entities.OJ_TRAPCARD.TYPE,BotB.Enums.Entities.OJ_TRAPCARD.VARIANT,1,player.Position,Vector.Zero,player)
		Isaac.Spawn(BotB.Enums.Entities.OJ_TRAPCARD.TYPE,BotB.Enums.Entities.OJ_TRAPCARD.VARIANT,1,player.Position,Vector.Zero,player)
	else
		Isaac.Spawn(BotB.Enums.Entities.OJ_TRAPCARD.TYPE,BotB.Enums.Entities.OJ_TRAPCARD.VARIANT,1,player.Position,Vector.Zero,player)
	end
	sfx:Play(BotB.Enums.SFX.OJ_CARD,1,0,false,1)
end
Mod:AddCallback(ModCallbacks.MC_USE_CARD, OJCARDS.flameThrowerInit, Mod.Enums.Consumables.CARDS.FLAMETHROWER)







--Stage --> StageType --> (Type, variant, subtype)
local ohMyFriendBossTable = {
	--Stage 1 (values 1 and 2)
	{
		--Basement
		{

		},
		--Cellar
		{

		},
		--Burning Basement
		{

		},
		--Fuckin' deprecated value. thanks greed.
		{},
		--Downpour
		{

		},
		--Dross
		{

		}
	},
	--Stage 2 (values 3 and 4)
	{
		--Caves
		{

		},
		--Catacombs
		{

		},
		--Flooded
		{

		},
		--Fuckin' deprecated value. thanks greed.
		{},
		--Mines
		{

		},
		--Ashpit
		{

		}
	},
	--Stage 3 (values 5 and 6)
	{
		--Depths
		{

		},
		--Necropolis
		{

		},
		--Dank
		{

		},
		--Fuckin' deprecated value. thanks greed.
		{},
		--Maus
		{

		},
		--Gehenna
		{

		}
	},
	--Stage 4 (values 7 and 8)
	{
		--Womb
		{

		},
		--Utero
		{

		},
		--Scarred
		{

		},
		--Fuckin' deprecated value. thanks greed.
		{},
		--Corpse
		{

		},
		--"""not done""" aka Mortis
		{

		}
	},
	--Random for all onward (sheol...home)

}





function OJCARDS:ohMyFriendInit(cardID, player)
	local randomChooser = math.random(0,1)
	local data = player:GetData()
	--print("AugPres = " .. Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE)
	--table.insert(player:GetData().activeRoomCards,Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TAROT_CLOTH, false) then
		randomChooser = math.random(0,1)
		if randomChooser == 1 then
			player:UseActiveItem(CollectibleType.COLLECTIBLE_DELIRIOUS, UseFlag.USE_NOANIM)
		else
			player:UseActiveItem(Isaac.GetItemIdByName("The Fiend Folio"), UseFlag.USE_NOANIM)
		end
		randomChooser = math.random(0,1)
		if randomChooser == 1 then
			player:UseActiveItem(CollectibleType.COLLECTIBLE_DELIRIOUS, UseFlag.USE_NOANIM)
		else
			player:UseActiveItem(Isaac.GetItemIdByName("The Fiend Folio"), UseFlag.USE_NOANIM)
		end
	else
		randomChooser = math.random(0,1)
		if randomChooser == 1 then
			player:UseActiveItem(CollectibleType.COLLECTIBLE_DELIRIOUS, UseFlag.USE_NOANIM)
		else
			player:UseActiveItem(Isaac.GetItemIdByName("The Fiend Folio"), UseFlag.USE_NOANIM)
		end
		
	end
end
Mod:AddCallback(ModCallbacks.MC_USE_CARD, OJCARDS.ohMyFriendInit, Mod.Enums.Consumables.CARDS.OH_MY_FRIEND)












--init the flip out value
function OJCARDS:playerUpdate(player)
	local data = player:GetData()
	local level = Game():GetLevel()
	if data.amountFlipOut == nil then
		data.amountFlipOut = 0
	end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, OJCARDS.playerUpdate, 0)

function OJCARDS:flipOutHurt(player)
	--print("cocks")
	--local player = Isaac.GetPlayer()
	local data = player:GetData()
		if data.amountFlipOut > 0 then
			Game():ShakeScreen(16)
			sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS,2,0,false,(math.random(60,80)/100))
			for i, entity in ipairs(Isaac.GetRoomEntities()) do
				if entity:IsVulnerableEnemy() then
					entity:TakeDamage(40, DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(player), 0)
					for i=1,3,1 do
						Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COIN,CoinSubType.COIN_PENNY,entity.Position,Vector(6,0):Rotated(math.random(360)),player)
					end
				end
			end
			data.amountFlipOut = data.amountFlipOut - 1
			--player:AnimateTeleport(false)
			sfx:Play(SoundEffect.SOUND_THE_FORSAKEN_LAUGH,2,0,false,(math.random(75,85)/100))
			return false
		end
	end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, OJCARDS.flipOutHurt, EntityType.ENTITY_PLAYER)


--Trap card shit
local Entities = BotB.Enums.Entities
--Subtype 0: Mimyuu's Hammer
--Subtype 1: Flamethrower
function OJCARDS:NPCUpdate(npc)
    local data = npc:GetData()
	local sprite = npc:GetSprite()
    if npc.Type == BotB.Enums.Entities.OJ_TRAPCARD.TYPE and npc.Variant == BotB.Enums.Entities.OJ_TRAPCARD.VARIANT then 
        if data.cardMode == nil then
			if npc.SubType ~= nil then
				data.cardMode = npc.SubType
			else
				data.cardMode = 0
			end
			if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ENEMIES then
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
			end
			sprite:Play("Spin")
		end
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, OJCARDS.NPCUpdate, Isaac.GetEntityTypeByName("OJ Trap Card"))

function OJCARDS:executeTrapCard(card, collider)
	local data = card:GetData()
	if card.Variant == BotB.Enums.Entities.OJ_TRAPCARD.VARIANT then
		if collider:IsVulnerableEnemy() then
			if data.cardMode == 0 then
				--Mimyuu's Hammer
				collider:AddConfusion(EntityRef(card), 120, false)
				collider:TakeDamage(60, DamageFlag.DAMAGE_CRUSH | DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(card), 0)
				Game():ShakeScreen(30)
				sfx:Play(BotB.FF.Sounds.FunnyBonk,1,0,false,1)
			elseif data.cardMode == 1 then
				--Flamethrower
				local cardQueue = 1
				if collider:IsBoss() then
					collider.HitPoints = math.ceil(collider.MaxHitPoints / 4)
					cardQueue = math.ceil((collider.MaxHitPoints / 10) * 0.75)
				else
					cardQueue = math.ceil(collider.MaxHitPoints / 10)
					sfx:Play(BotB.FF.Sounds.SmashHitFatal,1,0,false,1)
					Game():ShakeScreen(60)
					collider:BloodExplode()
					collider:BloodExplode()
					collider:Kill()
				end
				--Failsafe
				if cardQueue == 0 then
					cardQueue = 1
				end
				--Flamethrower card spawning
				for i=0,cardQueue,1 do
					local toSpawn = 0
					if toSpawn == 0 then
						--basic card
						Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,0,card.Position,Vector((0.1*math.random(-50,50)),(0.1*math.random(-50,50))),card)
					end
				end
			end
			--Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF04,0,card.Position,Vector.Zero,card)
			card:Remove()
		else
			if collider.Type == EntityType.ENTITY_PLAYER or collider.Type == EntityType.ENTITY_PICKUP or collider.Type == EntityType.ENTITY_FAMILIAR then
				return true
			end
		end
	end
end
Mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, OJCARDS.executeTrapCard, Isaac.GetEntityTypeByName("OJ Trap Card"))