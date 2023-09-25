local Mod = BotB
local PILLS = {}

if EID then
	EID:addPill(Isaac.GetPillEffectByName("Free Crack"), "Spawns a random {{Collectible" .. CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES .. "}}Book Of Virtues wisp.")
	EID:addPill(Isaac.GetPillEffectByName("Uppers!"), "Big, fading all stats up.")
	EID:addPill(Isaac.GetPillEffectByName("Downers!"), "Big, fading all stats down.")
	EID:addPill(Isaac.GetPillEffectByName("Ritalin"), "Grants the Super Hot effect for a room.")
	EID:addPill(Isaac.GetPillEffectByName("Psychedelics"), "Free use of {{Collectible" .. CollectibleType.COLLECTIBLE_WAVY_CAP .. "}} Wavy Cap.")
end

--local HiddenItemManager = require("scripts.core.hidden_item_manager")
--Use player:GetData().activeRoomCards for cards whose effects last for one room
--Use player:GetData().activeFloorCards for cards whose effects last for the floor

--Todo: Literally everything lmao

	function PILLS:freeCrackInit(cardID, player)
		sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER,2,0,false,1)
		--HiddenItemManager:AddForFloor(player,BotB.Enums.Items.STARLIGHT)
		local basedata = player:GetData()
		local data = basedata.ffsavedata or basedata
		PILLS:spawnFreeCrackWisp(player, data)	
	end


	function PILLS:spawnFreeCrackWisp(player, data)
		local PageOfVirtuesId = FiendFolio:rollPageOfVitruesEffect()
		
		local wisp = player:AddWisp(PageOfVirtuesId, player.Position, true)
		if wisp then
			sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT, 1, 0, false, 1)
		end
	end

	function PILLS:uppersInit(cardID, player)
		sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER,2,0,false,1)
		local data = player:GetData()
		--sfx:Play(BotB.Enums.SFX.VOIDRAIN_CARD,2,0,false,1)
		--HiddenItemManager:AddForFloor(player,BotB.Enums.Items.STARLIGHT)
		data.UppersDuration = data.UppersDuration + 240
	end

	function PILLS:downersInit(cardID, player)
		sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,2,0,false,1)
		local data = player:GetData()
		--sfx:Play(BotB.Enums.SFX.VOIDRAIN_CARD,2,0,false,1)
		--HiddenItemManager:AddForFloor(player,BotB.Enums.Items.STARLIGHT)
		data.DownersDuration = data.DownersDuration + 240
	end
	--[[
	function PILLS:ritalinInit(cardID, player)
		local data = player:GetData()
		--sfx:Play(BotB.Enums.SFX.VOIDRAIN_CARD,2,0,false,1)
		--HiddenItemManager:AddForFloor(player,BotB.Enums.Items.STARLIGHT)
		local seeds = Game():GetSeeds()
		data.addedMovePitch = false
		data.addedSuperHot = false
		if seeds:CanAddSeedEffect(SeedEffect.SEED_MOVEMENT_PITCH) then
			seeds:AddSeedEffect(SeedEffect.SEED_MOVEMENT_PITCH)
			data.addedMovePitch = true
		end
		if seeds:CanAddSeedEffect(SeedEffect.SEED_SUPER_HOT) then
			seeds:AddSeedEffect(SeedEffect.SEED_SUPER_HOT)
			data.addedSuperHot = true
		end
	end]]

	function PILLS:psychedelicsInit(cardID, player)
		sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER,2,0,false,1)
		--sfx:Play(BotB.Enums.SFX.VOIDRAIN_CARD,2,0,false,1)
		player:UseActiveItem(CollectibleType.COLLECTIBLE_WAVY_CAP, UseFlag.USE_NOANIM)
		player:UseActiveItem(CollectibleType.COLLECTIBLE_WAVY_CAP, UseFlag.USE_NOANIM)
		player:UseActiveItem(CollectibleType.COLLECTIBLE_WAVY_CAP, UseFlag.USE_NOANIM)
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

	Mod:AddCallback(ModCallbacks.MC_USE_PILL, PILLS.freeCrackInit, Isaac.GetPillEffectByName("Free Crack"))
	Mod:AddCallback(ModCallbacks.MC_USE_PILL, PILLS.uppersInit, Isaac.GetPillEffectByName("Uppers!"))
	Mod:AddCallback(ModCallbacks.MC_USE_PILL, PILLS.downersInit, Isaac.GetPillEffectByName("Downers!"))
	--Mod:AddCallback(ModCallbacks.MC_USE_PILL, PILLS.ritalinInit, Isaac.GetPillEffectByName("Ritalin!"))
	Mod:AddCallback(ModCallbacks.MC_USE_PILL, PILLS.psychedelicsInit, Isaac.GetPillEffectByName("Psychedelics"))
	--Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, VOIDRAINCARDS.ammoNPCDeathCheck)
	--Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Mod.corneredCache, CacheFlag.CACHE_FIREDELAY)
	--Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Mod.corneredPlayerUpdate, 0)



	function PILLS:newRoomCheck()
		--print("stop the fucking presses")
		local seeds = Game():GetSeeds()
		local playerList = TSIL.Players.GetPlayers(true)
		for i=1,#playerList,1 do
			local player = playerList[i]:ToPlayer()
			local data = player:GetData()
			
			if data.addedMovePitch ~= false then
				data.addedMovePitch = false
				seeds:RemoveSeedEffect(SeedEffect.SEED_MOVEMENT_PITCH)
			end
			if data.addedSuperHot ~= false then
				data.addedSuperHot = false
				seeds:RemoveSeedEffect(SeedEffect.SEED_SUPER_HOT)
			end
		end
	end
	Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, PILLS.newRoomCheck)

	function PILLS:playerUpdate()
		--print("stop the fucking presses")
		local seeds = Game():GetSeeds()
		local playerList = TSIL.Players.GetPlayers(true)
		for i=1,#playerList,1 do
			local player = playerList[i]:ToPlayer()
			local data = player:GetData()

			if data.UppersDuration == nil then
				data.UppersDuration = 0
			end
			if data.DownersDuration == nil then
				data.DownersDuration = 0
			end
			--[[
			if data.addedMovePitch == nil then
				if seeds:CanAddSeedEffect(SeedEffect.SEED_MOVEMENT_PITCH) then
					data.addedMovePitch = true
				else
					data.addedMovePitch = false
				end
			end
			if data.addedSuperHot == nil then
				if seeds:CanAddSeedEffect(SeedEffect.SEED_SUPER_HOT) then
					data.addedSuperHot = true
				else
					data.addedSuperHot = false
				end
			end]]

			if data.UppersDuration ~= 0 and player.FrameCount % 8 == 0 then
				data.UppersDuration = data.UppersDuration - 1
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_RANGE | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_LUCK)
				player:EvaluateItems()
			end
			if data.DownersDuration ~= 0 and player.FrameCount % 8 == 0 then
				data.DownersDuration = data.DownersDuration - 1
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_RANGE | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_LUCK)
				player:EvaluateItems()
			end

		end
	end
	Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, PILLS.playerUpdate)


	local uppersBonus={
		TEAR=0.4,
		SPEED=0.1,
		LUCK=1,
		RANGE=10,
		DAMAGE=2
	}
	
	--Stats
	--240 is baseline amt of decay frames for stat boost
	function PILLS:onUpCache(player, cacheFlag)

			local data = player:GetData()
			if data.UppersDuration ~= 0 and data.UppersDuration ~= nil then
				local Multiplier = data.UppersDuration / 120
				if (cacheFlag&CacheFlag.CACHE_DAMAGE)==CacheFlag.CACHE_DAMAGE then
				  player.Damage=player.Damage+Multiplier*uppersBonus.DAMAGE
				end
				if (cacheFlag&CacheFlag.CACHE_FIREDELAY)==CacheFlag.CACHE_FIREDELAY then
				  local tps=30.0/(player.MaxFireDelay+1.0)
				  player.MaxFireDelay=30.0/(math.max(0.1,tps+Multiplier*uppersBonus.TEAR))-1
				end
				if (cacheFlag&CacheFlag.CACHE_RANGE)==CacheFlag.CACHE_RANGE then
				  player.TearRange=player.TearRange+Multiplier*uppersBonus.RANGE
				end
				if (cacheFlag&CacheFlag.CACHE_SPEED)==CacheFlag.CACHE_SPEED then
				  player.MoveSpeed=player.MoveSpeed+Multiplier*uppersBonus.SPEED
				end
				if (cacheFlag&CacheFlag.CACHE_LUCK)==CacheFlag.CACHE_LUCK then
				  player.Luck=player.Luck+Multiplier*uppersBonus.LUCK
				end
			elseif data.UppersDuration == 0 or data.UppersDuration == nil then
				return
			end
		
	end
	Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, PILLS.onUpCache)

	local downersMalus={
		TEAR=-0.2,
		SPEED=-0.05,
		LUCK=-0.5,
		RANGE=-5,
		DAMAGE=-1
	}
	
	--Stats
	--240 is baseline amt of decay frames for stat boost
	function PILLS:onDownCache(player, cacheFlag)
			local data = player:GetData()
			if data.DownersDuration ~= 0  and data.DownersDuration ~= nil then
				local Multiplier = data.DownersDuration / 60
				if (cacheFlag&CacheFlag.CACHE_DAMAGE)==CacheFlag.CACHE_DAMAGE then
				  player.Damage=player.Damage+Multiplier*downersMalus.DAMAGE
				end
				if (cacheFlag&CacheFlag.CACHE_FIREDELAY)==CacheFlag.CACHE_FIREDELAY then
				  local tps=30.0/(player.MaxFireDelay+1.0)
				  player.MaxFireDelay=30.0/(math.max(0.1,tps+Multiplier*downersMalus.TEAR))-1
				end
				if (cacheFlag&CacheFlag.CACHE_RANGE)==CacheFlag.CACHE_RANGE then
				  player.TearRange=player.TearRange+Multiplier*downersMalus.RANGE
				end
				if (cacheFlag&CacheFlag.CACHE_SPEED)==CacheFlag.CACHE_SPEED then
				  player.MoveSpeed=player.MoveSpeed+Multiplier*downersMalus.SPEED
				end
				if (cacheFlag&CacheFlag.CACHE_LUCK)==CacheFlag.CACHE_LUCK then
				  player.Luck=player.Luck+Multiplier*downersMalus.LUCK
				end
			elseif data.DownersDuration == 0 or data.DownersDuration == nil then
				return
			end
		
	end
	Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, PILLS.onDownCache)