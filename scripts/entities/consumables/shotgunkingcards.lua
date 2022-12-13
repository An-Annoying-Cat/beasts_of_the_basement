local Mod = BotB

if EID then
	EID:addCard(Mod.Enums.Consumables.CARDS.CORNERED_DESPOT, "Grants a large fire rate boost (-2 fire rate) for the room when within 2 tiles of the room's edge.")
	EID:addCard(Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE, "Grants an aura that pushes away projectiles, and repels enemies while lightly damaging them.")
	EID:addCard(Mod.Enums.Consumables.CARDS.HOMECOMING, "Turns the non-boss enemy with the highest base HP into a rainbow champion.#{{Warning}} Only works on enemies capable of becoming champions in the first place.")
	EID:addCard(Mod.Enums.Consumables.CARDS.AMMUNITION_DEPOT, "Doubles the max health of all enemies in the room.#All affected enemies drop pickups on death.")
end

--Use player:GetData().activeRoomCards for cards whose effects last for one room
--Use player:GetData().activeFloorCards for cards whose effects last for the floor

--Todo: Literally everything lmao

	function Mod:corneredDespotInit(cardID, player)
		data = player:GetData()
		print("CornDes = " .. Mod.Enums.Consumables.CARDS.CORNERED_DESPOT)
		--table.insert(data.activeRoomCards,Mod.Enums.Consumables.CARDS.CORNERED_DESPOT)
		sfx:Play(Isaac.GetSoundIdByName("ShotgunKingCard"),1,0,false,1)
	end

	function Mod:augustPresenceInit(cardID, player)
		print("AugPres = " .. Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE)
		--table.insert(player:GetData().activeRoomCards,Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE)
		sfx:Play(Isaac.GetSoundIdByName("ShotgunKingCard"),1,0,false,1)
	end

	function Mod:homecomingTransform(cardID, player)
		--print("HomeCom = " .. Mod.Enums.Consumables.CARDS.HOMECOMING)
		sfx:Play(Isaac.GetSoundIdByName("ShotgunKingCard"),1,0,false,1)
		local didTheHomecoming = false
		--Do the conversion shit here. It's just one enemy and it already drops all the stuff, so it doesn't need a table entry
		--Iterate through all entities
		for i, entity in ipairs(Isaac.GetRoomEntities()) do	
			if entity:IsEnemy() and entity:IsVulnerableEnemy() then
				data = entity:GetData()
				
				if entity:ToNPC():IsChampion() == false and data.homecomingEffect == nil and didTheHomecoming == false then
					entity:ToNPC():MakeChampion(1, ChampionColor.RAINBOW)
					data.homecomingEffect = true
					for i=0,10,1 do
						local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.ULTRA_GREED_BLING,0,entity.Position,Vector((0.1*math.random(-250,250)),(0.1*math.random(-250,250))),entity)
					end
					for i=0,10,1 do
						local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.ULTRA_GREED_BLING,0,entity.Position,Vector((0.1*math.random(-500,500)),(0.1*math.random(-500,500))),entity)
					end
					didTheHomecoming = true
				end
				
				
			end
		end
		
	end

	function Mod:ammoDepotTransform(cardID, player)
		print("AmmDep = " .. Mod.Enums.Consumables.CARDS.AMMUNITION_DEPOT)
		sfx:Play(Isaac.GetSoundIdByName("ShotgunKingCard"),1,0,false,1)
		--table.insert(player:GetData().activeRoomCards,Mod.Enums.Consumables.CARDS.AMMUNITION_DEPOT)
		--The above line is only here to keep a callback so enemies can drop pickups when killed
		--Iterate through all enemies
		for i, entity in ipairs(Isaac.GetRoomEntities()) do	
			if entity:IsEnemy() and entity:IsVulnerableEnemy() then
				data = entity:GetData()
				if data.ammoDepotEffect == nil then
					data.ammoDepotEffect = true
					entity.HitPoints = 2*entity.HitPoints
					for i=0,5,1 do
						local rubble = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.NAIL_PARTICLE,0,entity.Position,Vector((0.1*math.random(-50,50)),(0.1*math.random(-50,50))),entity)
					end
					for i=0,10,1 do
						local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.DARK_BALL_SMOKE_PARTICLE,0,entity.Position,Vector((0.1*math.random(-200,200)),(0.1*math.random(-200,200))),entity)
					end
				end
				--print(entity.Type, entity.Variant, entity.SubType)
				--print(entity.MaxHitPoints .. "is the max health")
				--entity.MaxHitPoints = 2*entity.MaxHitPoints

				--print("Post-op health: " .. entity.MaxHitPoints .. " max, " .. entity.HitPoints .. " current")
				--print(data.ammoDepotEffect)
				
			end
		end
	end

	function BotB:ammoNPCDeathCheck(npc)
		local data = npc:GetData()
		--print("DIE")
		if data.ammoDepotEffect == true then
			--print("DIE 2")
			sfx:Play(SoundEffect.SOUND_SLOTSPAWN,1,0,false,math.random(120, 150)/100)
			Isaac.Spawn(EntityType.ENTITY_PICKUP, 0, 0, npc.Position, Vector(math.random(-4,4),math.random(-4,4)), npc)
		end
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
			sfx:Play(Isaac.GetSoundIdByName("ShotgunKingCard"),1,0,false,1)
		end
	end
	--]]

	Mod:AddCallback(ModCallbacks.MC_USE_CARD, Mod.corneredDespotInit, Mod.Enums.Consumables.CARDS.CORNERED_DESPOT)
	Mod:AddCallback(ModCallbacks.MC_USE_CARD, Mod.augustPresenceInit, Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE)
	Mod:AddCallback(ModCallbacks.MC_USE_CARD, Mod.homecomingTransform, Mod.Enums.Consumables.CARDS.HOMECOMING)
	Mod:AddCallback(ModCallbacks.MC_USE_CARD, Mod.ammoDepotTransform, Mod.Enums.Consumables.CARDS.AMMUNITION_DEPOT)
	Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, BotB.ammoNPCDeathCheck)
	--Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Mod.corneredCache, CacheFlag.CACHE_FIREDELAY)
	--Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Mod.corneredPlayerUpdate, 0)