local Mod = BotB
local OJCARDS = {}

if EID then
	EID:addCard(Mod.Enums.Consumables.CARDS.OH_MY_FRIEND, "Has a 50/50 chance of either effect: #{{ArrowUp}} Uses {{Collectible".. CollectibleType.COLLECTIBLE_DELIRIOUS .."}} Delirious. #{{ArrowDown}} Spawns a random boss from the floor you're on, and grants Betrayal. #{{Warning}} Should the latter occur, the boss will start with its health at 75% of its normal maximum. Killing this boss will also spawn a pedestal item.")
	EID:addCard(Mod.Enums.Consumables.CARDS.FLIP_OUT, "The next time the player gets hurt, negate the damage. All enemies and bosses in the room take 40 damage (ignoring boss armor!) and drop 3 pennies when this occurs.")
	EID:addCard(Mod.Enums.Consumables.CARDS.MIMYUUS_HAMMER, "When used, this card is placed on the ground where it idly spins. #The first enemy to step on this card takes 60 damage, and the card is consumed in the process.")
	EID:addCard(Mod.Enums.Consumables.CARDS.FLAMETHROWER, "When used, this card is placed on the ground where it idly spins. #The first enemy to step on this card is instantly killed, and drops a number of cards proportional to its max health.")
end

--Use player:GetData().activeRoomCards for cards whose effects last for one room
--Use player:GetData().activeFloorCards for cards whose effects last for the floor



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