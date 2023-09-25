local Mod = BotB
local OTHERCARDS = {}
local Items = BotB.Enums.Items

if EID then
	EID:addCard(Mod.Enums.Consumables.CARDS.ZAP, "Spawns 3 friendly Willos.")
	EID:addCard(Mod.Enums.Consumables.CARDS.BLADE_DANCE, "#Throws 3 homing, spectral projectiles styled after the Shiv cards from Slay the Spire. #These have extremely high range and the {{Collectible".. CollectibleType.COLLECTIBLE_CONTINUUM .."}} Continuum effect. #These cause Bleed and Hemorrhage on hit, and deal 3x your damage.")
	EID:addCard(Mod.Enums.Consumables.CARDS.MISPRINTED_JUSTICE, "Spawns a random x10 item ( {{Collectible" .. Isaac.GetItemIdByName("Boom!") .."}} Boom!, {{Collectible" .. Isaac.GetItemIdByName("Badump!") .."}} Badump!, {{Collectible" .. Isaac.GetItemIdByName("Ka Ching!") .."}} Ka Ching!, {{Collectible" .. Isaac.GetItemIdByName("Batoomkling!") .."}} Batoomkling!, {{Collectible" .. Isaac.GetItemIdByName("Bzzt!") .."}} Bzzt!, {{Collectible" .. Isaac.GetItemIdByName("Ska Padaba!") .."}} Ska Padaba!, {{Collectible" .. Isaac.GetItemIdByName("Chomp Chomp!") .."}} Chomp Chomp!, {{Collectible" .. Items.TEN_SOULS .."}} Haah!, {{Collectible" .. Items.TEN_TRINKETS .."}} Fwoop!, {{Collectible" .. Items.TEN_ITEMS .."}} Ahhh..., {{Collectible" .. Items.TEN_WISPS .."}} Fwoosh!, {{Collectible" .. Items.TEN_CARDS .."}} Ksshk!, {{Collectible" .. Items.TEN_PILLS .."}} Gulp!, {{Collectible" .. Items.TEN_CLOTS .."}} Shlop!, {{Collectible" .. Items.TEN_FLIES .."}} Buzz Buzz!, {{Collectible" .. Items.TEN_SPIDERS .."}} Skitter Skitter!, {{Collectible" .. Items.TEN_SKUZZES .."}} Boing Boing!, {{Collectible" .. Items.TEN_DIPS .."}} Plop!, {{Collectible" .. Items.TEN_TENS .."}} Oh Sweet Merciful Christ!) #Some are rarer than others, for reasons that are hopefully rather obvious.")
	EID:addCard(Mod.Enums.Consumables.CARDS.BANK_ERROR_IN_YOUR_FAVOR, "Gives you money equivalent to one-tenth of your current Donation Machine balance. #Always gives at least one cent.")
end

--local HiddenItemManager = require("scripts.core.hidden_item_manager")
--Use player:GetData().activeRoomCards for cards whose effects last for one room
--Use player:GetData().activeFloorCards for cards whose effects last for the floor

--Todo: Literally everything lma

	function OTHERCARDS:zapInit(cardID, player)
		--print("oops not done yet")
		for i=0,2 do
			local willo = Isaac.Spawn(EntityType.ENTITY_WILLO,0,0,player.Position,Vector.Zero,player):ToNPC()
			willo:GetSprite().Color = Color(1,0,0,1)
			willo:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
		end
	end

	function OTHERCARDS:bladeDanceInit(cardID, player)
		print("oops not done yet 2: electric boogaloo")
		--sfx:Play(BotB.Enums.SFX.VOIDRAIN_CARD,2,0,false,1)
		--HiddenItemManager:AddForFloor(player,BotB.Enums.Items.QUICKLOVE)
	end

	local misprintedJusticeCollectiblePoolBad = {
		Isaac.GetItemIdByName("Badump!"),
		Isaac.GetItemIdByName("Bzzt!"),
		Items.TEN_FLIES,
		Items.TEN_SPIDERS,
		Items.TEN_SKUZZES,
		Items.TEN_DIPS,
		Items.TEN_POOPS,
	}
	local misprintedJusticeCollectiblePoolNeutral = {
		Items.TEN_CLOTS,
		Items.TEN_WISPS,
		Isaac.GetItemIdByName("Boom!"),
		Isaac.GetItemIdByName("Ka Ching!"),
		Isaac.GetItemIdByName("Batoomkling!"),
	}
	local misprintedJusticeCollectiblePoolGood = {
		Items.TEN_SOULS,
		Items.TEN_CARDS,
		Items.TEN_PILLS,
		Items.TEN_TRINKETS,
		Isaac.GetItemIdByName("Chomp Chomp!"),
	}

	local misprintedJusticeCollectiblePoolGodlike = {
		Items.TEN_ITEMS,
		Items.TEN_TENS,
	}

	function OTHERCARDS:misprintedJusticeInit(cardID, player)
		--sfx:Play(BotB.Enums.SFX.VOIDRAIN_CARD,2,0,false,1)
		--HiddenItemManager:AddForFloor(player,CollectibleType.COLLECTIBLE_POLYDACTYLY)
		local misprintedJusticePoolPick = math.random(0,1000)
		--0: Bad, 1-2: Neutral, 3: Good
		if misprintedJusticePoolPick <= 350 then
			SFXManager():Play(SoundEffect.SOUND_PORTAL_SPAWN,1,0,false,1)
			SFXManager():Play(Isaac.GetSoundIdByName("AceVenturaLaugh"),2,15,false,1)
			player:AnimateSad()
			Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,misprintedJusticeCollectiblePoolBad[math.random(1,#misprintedJusticeCollectiblePoolBad)],Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero,player)
		elseif misprintedJusticePoolPick > 350 and misprintedJusticePoolPick <= 750 then
			SFXManager():Play(SoundEffect.SOUND_PORTAL_SPAWN,1,0,false,1)
			Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,misprintedJusticeCollectiblePoolNeutral[math.random(1,#misprintedJusticeCollectiblePoolNeutral)],Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero,player)
		elseif misprintedJusticePoolPick >= 750 and misprintedJusticePoolPick <= 999 then
			player:AnimateHappy()
			SFXManager():Play(SoundEffect.SOUND_PORTAL_SPAWN,1,0,false,1)
			SFXManager():Play(Isaac.GetSoundIdByName("CrowdCheer"),2,15,false,1)
			Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,misprintedJusticeCollectiblePoolGood[math.random(1,#misprintedJusticeCollectiblePoolGood)],Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero,player)
		elseif misprintedJusticePoolPick > 999 then
			player:AnimateHappy()
			SFXManager():Play(SoundEffect.SOUND_PORTAL_SPAWN,1,0,false,1)
				SFXManager():Play(BotB.Enums.SFX.PLUS_TEN,math.random(100,500)/100,math.random(0,500),false,math.random(500,2000)/1000,0)
				SFXManager():Play(BotB.Enums.SFX.PLUS_TEN,math.random(100,500)/100,math.random(0,500),false,math.random(500,2000)/1000,0)
				SFXManager():Play(BotB.Enums.SFX.PLUS_TEN,math.random(100,500)/100,math.random(0,500),false,math.random(500,2000)/1000,0)
				SFXManager():Play(BotB.Enums.SFX.PLUS_TEN,math.random(100,500)/100,math.random(0,500),false,math.random(500,2000)/1000,0)
				SFXManager():Play(BotB.Enums.SFX.PLUS_TEN,math.random(100,500)/100,math.random(0,500),false,math.random(500,2000)/1000,0)
			SFXManager():Play(Isaac.GetSoundIdByName("CrowdCheer"),1,15,false,1)
			Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,misprintedJusticeCollectiblePoolGood[math.random(1,#misprintedJusticeCollectiblePoolGood)],Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero,player)
		end
		
	end

	function OTHERCARDS:bankErrorInit(cardID, player)
		SFXManager():Play(SoundEffect.SOUND_CASH_REGISTER,2,0,false,1)
		local donoCount = math.ceil(Game():GetDonationModAngel()/10)+1
		print(donoCount)
		player:AddCoins(donoCount)
		--HiddenItemManager:AddForFloor(player,BotB.Enums.Items.LUCKY_FLOWER)

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

	Mod:AddCallback(ModCallbacks.MC_USE_CARD, OTHERCARDS.zapInit, Mod.Enums.Consumables.CARDS.ZAP)
	Mod:AddCallback(ModCallbacks.MC_USE_CARD, OTHERCARDS.bladeDanceInit, Mod.Enums.Consumables.CARDS.BLADE_DANCE)
	Mod:AddCallback(ModCallbacks.MC_USE_CARD, OTHERCARDS.misprintedJusticeInit, Mod.Enums.Consumables.CARDS.MISPRINTED_JUSTICE)
	Mod:AddCallback(ModCallbacks.MC_USE_CARD, OTHERCARDS.bankErrorInit, Mod.Enums.Consumables.CARDS.BANK_ERROR_IN_YOUR_FAVOR)
	--Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, OTHERCARDS.ammoNPCDeathCheck)
	--Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Mod.corneredCache, CacheFlag.CACHE_FIREDELAY)
	--Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Mod.corneredPlayerUpdate, 0)


	--Stats