local Mod = BotB
local SKCARDS = {}

if EID then
	EID:addCard(Mod.Enums.Consumables.CARDS.CORNERED_DESPOT, "Grants a large fire rate boost (-2 fire rate) for the room when near the room's edge.")
	EID:addCard(Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE, "Grants an aura that pushes away projectiles, and repels enemies while lightly damaging them.")
	EID:addCard(Mod.Enums.Consumables.CARDS.HOMECOMING, "Turns the non-boss enemy with the highest base HP into a rainbow champion.#{{Warning}} Only works on enemies capable of becoming champions in the first place.")
	EID:addCard(Mod.Enums.Consumables.CARDS.AMMUNITION_DEPOT, "Doubles the max health of all enemies in the room.#All affected enemies drop pickups on death.")
end

--Use player:GetData().activeRoomCards for cards whose effects last for one room
--Use player:GetData().activeFloorCards for cards whose effects last for the floor

--Todo: Literally everything lmao

	function SKCARDS:corneredDespotInit(cardID, player)
		local data = player:GetData()
		--print("CornDes = " .. Mod.Enums.Consumables.CARDS.CORNERED_DESPOT)
		--table.insert(data.activeRoomCards,Mod.Enums.Consumables.CARDS.CORNERED_DESPOT)
		data.hasCorneredDespot = true
		sfx:Play(BotB.Enums.SFX.SHOTGUNKING_CARD,1,0,false,1)
	end

	function SKCARDS:augustPresenceInit(cardID, player)
		local data = player:GetData()
		--print("AugPres = " .. Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE)
		--table.insert(player:GetData().activeRoomCards,Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE)
		data.hasAugustPresence = true
		sfx:Play(BotB.Enums.SFX.SHOTGUNKING_CARD,1,0,false,1)
	end

	function SKCARDS:homecomingTransform(cardID, player)
		--print("HomeCom = " .. Mod.Enums.Consumables.CARDS.HOMECOMING)
		sfx:Play(BotB.Enums.SFX.SHOTGUNKING_CARD,1,0,false,1)
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

	function SKCARDS:ammoDepotTransform(cardID, player)
		--print("AmmDep = " .. Mod.Enums.Consumables.CARDS.AMMUNITION_DEPOT)
		sfx:Play(BotB.Enums.SFX.SHOTGUNKING_CARD,1,0,false,1)
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

	function SKCARDS:ammoNPCDeathCheck(npc)
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
			sfx:Play(BotB.Enums.SFX.SHOTGUNKING_CARD,1,0,false,1)
		end
	end
	--]]

	Mod:AddCallback(ModCallbacks.MC_USE_CARD, SKCARDS.corneredDespotInit, Mod.Enums.Consumables.CARDS.CORNERED_DESPOT)
	Mod:AddCallback(ModCallbacks.MC_USE_CARD, SKCARDS.augustPresenceInit, Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE)
	Mod:AddCallback(ModCallbacks.MC_USE_CARD, SKCARDS.homecomingTransform, Mod.Enums.Consumables.CARDS.HOMECOMING)
	Mod:AddCallback(ModCallbacks.MC_USE_CARD, SKCARDS.ammoDepotTransform, Mod.Enums.Consumables.CARDS.AMMUNITION_DEPOT)
	Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, SKCARDS.ammoNPCDeathCheck)
	--Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Mod.corneredCache, CacheFlag.CACHE_FIREDELAY)
	--Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Mod.corneredPlayerUpdate, 0)






	function SKCARDS:newRoomCheck()
		--print("stop the fucking presses")
		local playerList = TSIL.Players.GetPlayers(true)
		for i=1,#playerList,1 do
			local player = playerList[i]:ToPlayer()
			local data = player:GetData()
			if data.hasCorneredDespot ~= false then
				data.hasCorneredDespot = false
			end
			if data.hasAugustPresence ~= false then
				data.hasAugustPresence = false
			end
		end
	end
	Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SKCARDS.newRoomCheck)

	function SKCARDS:playerUpdate(player)
		local data = player:GetData()
		local level = Game():GetLevel()
		if data.hasCorneredDespot == nil then
			data.hasCorneredDespot = false
			data.CorneredDespotBaseStacks = 1
			data.hasAugustPresence = false
			data.AugustPresenceBaseStacks = 1
		end
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:EvaluateItems()
	end
	Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, SKCARDS.playerUpdate, 0)

	local corneredDespotBonus={
		TEAR=0.8,
	}

	--Stats
	--240 is baseline amt of decay frames for stat boost
	function SKCARDS:corneredDespotCache(player, cacheFlag)
		local data = player:GetData()
		
		--Multiplier is to be changed after measuring the player's position and shit
		local Multiplier = 0
		if data.hasCorneredDespot then
			local room = Game():GetRoom()
			local topLeft = room:GetTopLeftPos()
			local bottomRight = room:GetBottomRightPos()
			local sizeVec = bottomRight - topLeft
			local xLowThreshold = (topLeft.X + 0.2*sizeVec.X)
			local xHighThreshold = (topLeft.X + 0.8*sizeVec.X)
			local yLowThreshold = (topLeft.Y + 0.2*sizeVec.Y)
			local yHighThreshold = (topLeft.Y + 0.8*sizeVec.Y)
			if player.Position.X <= xLowThreshold then
				Multiplier = Multiplier + ((xLowThreshold - player.Position.X)/40)
			elseif player.Position.X >= xHighThreshold then 
				Multiplier = Multiplier + ((player.Position.X - xHighThreshold)/40)
			end
			if player.Position.Y <= yLowThreshold then
				Multiplier = Multiplier + ((yLowThreshold - player.Position.Y)/20)
				--print(player.Position.Y .. " and " .. yLowThreshold .. ", so " .. yLowThreshold - player.Position.Y)
			elseif player.Position.Y >= yHighThreshold then 
				Multiplier = Multiplier + ((player.Position.Y - yHighThreshold)/20)
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_TAROT_CLOTH, false) then
				Multiplier = Multiplier * 2
			end
			
			--print(Multiplier)
			if (cacheFlag&CacheFlag.CACHE_FIREDELAY)==CacheFlag.CACHE_FIREDELAY then
			  local tps=30.0/(player.MaxFireDelay+1.0)
			  player.MaxFireDelay=30.0/(math.max(0.1,tps+Multiplier*corneredDespotBonus.TEAR))-1
			end
		elseif data.hasCorneredDespot == false or data.hasCorneredDespot == nil then
			return
		end
	end
	Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, SKCARDS.corneredDespotCache)



	function SKCARDS:augustPresenceRepelNPC(npc)
		local playerList = TSIL.Players.GetPlayers(true)
		for i=1,#playerList,1 do
			local player = playerList[i]:ToPlayer()
			local data = player:GetData()
			if data.hasAugustPresence ~= false then
				if npc:IsVulnerableEnemy() then
					local npcDist = (player.Position - npc.Position):Length()
					if npcDist <= 100 then
						npc.Velocity = (0.99 * npc.Velocity) + (((0.01 * (player.Position - npc.Position)):Rotated(180)):Resized(5))
					end
				end
			end
		end
	end
	Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SKCARDS.augustPresenceRepelNPC)


	function SKCARDS:augustPresenceRepelProj(npc)
		local playerList = TSIL.Players.GetPlayers(true)
		for i=1,#playerList,1 do
			local player = playerList[i]:ToPlayer()
			local data = player:GetData()
			if data.hasAugustPresence ~= false then
				local npcDist = (player.Position - npc.Position):Length()
				if npcDist <= 75 then
					npc.Velocity = (0.99 * npc.Velocity) + (((0.01 * (player.Position - npc.Position)):Rotated(180)):Resized(2))
				end
			end
		end
	end
	Mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, SKCARDS.augustPresenceRepelProj)
