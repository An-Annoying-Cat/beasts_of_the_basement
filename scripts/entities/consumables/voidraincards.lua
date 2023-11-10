local Mod = BotB
local VOIDRAINCARDS = {}

if EID then
	EID:addCard(Mod.Enums.Consumables.CARDS.QUICKLOVE, "Multiplies your {{Damage}} Damage by 1.25 for the rest of the floor.")
	EID:addCard(Mod.Enums.Consumables.CARDS.STARLIGHT, "Grants two heart containers (or whichever relevant heart) and a Holy Mantle shield.")
	EID:addCard(Mod.Enums.Consumables.CARDS.PALE_BOX, "Grants the effect of {{Collectible" .. CollectibleType.COLLECTIBLE_POLYDACTYLY .."}} Polydactyly, and spawns a Toy Chest.")
	EID:addCard(Mod.Enums.Consumables.CARDS.LUCKY_FLOWER, "Grants +2 {{Luck}} Luck, and a +0.5 {{Luck}} Luck bonus for each room completed on the floor after using this card.")
end

local HiddenItemManager = require("scripts.core.hidden_item_manager")
--Use player:GetData().activeRoomCards for cards whose effects last for one room
--Use player:GetData().activeFloorCards for cards whose effects last for the floor

--Todo: Literally everything lmao

	function VOIDRAINCARDS:starlightInit(cardID, player)
		sfx:Play(BotB.Enums.SFX.VOIDRAIN_CARD,2,0,false,1)
		HiddenItemManager:AddForFloor(player,BotB.Enums.Items.STARLIGHT)
		player:UseCard(Card.CARD_HOLY, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
	end

	function VOIDRAINCARDS:quickloveInit(cardID, player)
		sfx:Play(BotB.Enums.SFX.VOIDRAIN_CARD,2,0,false,1)
		HiddenItemManager:AddForFloor(player,BotB.Enums.Items.QUICKLOVE)
	end

	function VOIDRAINCARDS:paleBoxInit(cardID, player)
		--print("HomeCom = " .. Mod.Enums.Consumables.CARDS.HOMECOMING)
		sfx:Play(BotB.Enums.SFX.VOIDRAIN_CARD,2,0,false,1)
		HiddenItemManager:AddForFloor(player,CollectibleType.COLLECTIBLE_POLYDACTYLY)
		--print("spawn a toy chest i guess. for now we're spawning a wooden one until i code the toy chest")
		Isaac.Spawn(EntityType.ENTITY_PICKUP,1229,0,Game():GetRoom():FindFreePickupSpawnPosition(player.Position),Vector.Zero,player)
	end

	function VOIDRAINCARDS:luckyFlowerInit(cardID, player)
		sfx:Play(BotB.Enums.SFX.VOIDRAIN_CARD,2,0,false,1)
		if player:GetData().botbLuckyFlowerBonusCount == nil then
			player:GetData().botbLuckyFlowerBonusCount = 0
		end
		HiddenItemManager:AddForFloor(player,BotB.Enums.Items.LUCKY_FLOWER)

	end


	--[[
	function Mod:corneredCache(player, cacheFlags)
		local data = player:GetData()
		if Mod.Tables:ContainsValue(data.activeRoomCards,Mod.Enums.Consumables.CARDS.CORNERED_DESPOT) then
			if cacheFlags & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
				local fireDelayBoost = 0.5
				player.MaxFireDelay = player.MaxFireDelay*fireDelayBoost
			end
		end
	end

	function Mod:corneredPlayerUpdate(player)
		local data = player:GetData()
		if Mod.Tables:ContainsValue(data.activeRoomCards,Mod.Enums.Consumables.CARDS.CORNERED_DESPOT) then
			player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
  			player:EvaluateItems()
			sfx:Play(BotB.Enums.SFX.VOIDRAIN_CARD,1,0,false,1)
		end
	end
	--]]

	Mod:AddCallback(ModCallbacks.MC_USE_CARD, VOIDRAINCARDS.starlightInit, Mod.Enums.Consumables.CARDS.STARLIGHT)
	Mod:AddCallback(ModCallbacks.MC_USE_CARD, VOIDRAINCARDS.quickloveInit, Mod.Enums.Consumables.CARDS.QUICKLOVE)
	Mod:AddCallback(ModCallbacks.MC_USE_CARD, VOIDRAINCARDS.paleBoxInit, Mod.Enums.Consumables.CARDS.PALE_BOX)
	Mod:AddCallback(ModCallbacks.MC_USE_CARD, VOIDRAINCARDS.luckyFlowerInit, Mod.Enums.Consumables.CARDS.LUCKY_FLOWER)
	--Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, VOIDRAINCARDS.ammoNPCDeathCheck)
	--Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Mod.corneredCache, CacheFlag.CACHE_FIREDELAY)
	--Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Mod.corneredPlayerUpdate, 0)


	--Stats

	local quickLoveBonus={
		DAMAGE=1.25,
	}
	local Items = BotB.Enums.Items
	--Stats
	function VOIDRAINCARDS:onQuickLoveCache(player, cacheFlag)
		if not player:HasCollectible(Items.QUICKLOVE) then return end
		local Multiplier = player:GetCollectibleNum(Items.QUICKLOVE, false)
		if (cacheFlag&CacheFlag.CACHE_DAMAGE)==CacheFlag.CACHE_DAMAGE then
		  player.Damage=player.Damage*Multiplier*quickLoveBonus.DAMAGE
		end

	end
	Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, VOIDRAINCARDS.onQuickLoveCache)
	

	local luckyFlowerBonus={
		--0.5 per enemy killed
		LUCK=2,
	}
	local Items = BotB.Enums.Items
	--Stats
	function VOIDRAINCARDS:onLuckyFlowerCache(player, cacheFlag)
		if not player:HasCollectible(Items.LUCKY_FLOWER) then return end
		local Multiplier = player:GetCollectibleNum(Items.LUCKY_FLOWER, false)
		if (cacheFlag&CacheFlag.CACHE_LUCK)==CacheFlag.CACHE_LUCK then
			player.Luck=player.Luck+(Multiplier*luckyFlowerBonus.LUCK) + (player:GetData().botbLuckyFlowerBonusCount * 0.5)
		  end
	end
	Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, VOIDRAINCARDS.onLuckyFlowerCache)





	function VOIDRAINCARDS:luckyFlowerRoomClearCheck(_,_)
		print("balls")
		local players = BotB.Functions:GetPlayers()
				--local doTheyActuallyHaveThem = false
				for i=1,#players,1 do
					if players[i]:HasCollectible(Items.LUCKY_FLOWER) then
						--doTheyActuallyHaveThem = true
						if players[i]:GetData().botbLuckyFlowerBonusCount ~= nil then
							players[i]:GetData().botbLuckyFlowerBonusCount = players[i]:GetData().botbLuckyFlowerBonusCount + 1
							players[i]:AddCacheFlags(CacheFlag.CACHE_LUCK )
							players[i]:EvaluateItems()
						end
					end
				end
		
	end

	Mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, VOIDRAINCARDS.luckyFlowerRoomClearCheck)