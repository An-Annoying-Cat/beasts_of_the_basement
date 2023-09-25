local Mod = BotB
local FUCK_THAT_NOISE = {}
local sfx = SFXManager()


if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Fuck That Noise"), "Grants a 100% chance for an item pedestal to spawn in the Treasure and/or Angel room if there is not one. #Grants a 50% chance to spawn a pedestal in the Curse and Secret rooms if there is not one. #Spawns a Devil Deal in the Devil Room if there is not one. #{{Warning}} Multiple copies increase the chance at which an item spawns.")
end




	local function getPlayers()
		local game = Game()
		local numPlayers = game:GetNumPlayers()
	  
		local players = {}
		for i = 0, numPlayers - 1 do
		  local player = Isaac.GetPlayer(i)
		  table.insert(players, player)
		end
	  
		return players
	end

	function FUCK_THAT_NOISE:doFuckThatNoisePedestal()
		local room = Game():GetRoom()
		local game = Game()
		 local level = game:GetLevel()
		 local roomDescriptor = level:GetCurrentRoomDesc()
		 local roomConfigRoom = roomDescriptor.Data
		 --first visits only, no exploits
		if not roomDescriptor.VisitedCount == 1 then return end
		local players = getPlayers()
		local doesSomeoneHaveFuckThatNoise = false
		local bwcMultiplier= 0
		for i=1,#players,1 do
			if players[i]:ToPlayer():HasCollectible(Isaac.GetItemIdByName("Fuck That Noise")) then
				--print("dicks")
				doesSomeoneHaveFuckThatNoise = true
	
			end
		end
		if not doesSomeoneHaveFuckThatNoise then return end

		for i=1,#players,1 do
			if players[i]:ToPlayer():HasCollectible(Isaac.GetItemIdByName("Fuck That Noise")) then
				--print("dicks")
				local data = players[i]:ToPlayer():GetData()
				local roomHasAPedestal = false
				local botbFTNChanceThreshold = 0.5 ^ players[i]:ToPlayer():GetCollectibleNum(Isaac.GetItemIdByName("Fuck That Noise"), false)
				print(botbFTNChanceThreshold)
				--these 4 are pretty straightforward, just add a simple random chance to secret and curse cuz secret room items are powerful
				if roomConfigRoom.Type == RoomType.ROOM_SECRET then
					--print("secret?")
					local roomEntities = Isaac.GetRoomEntities() -- table
					for i = 1, #roomEntities do
						local entity = roomEntities[i]
						if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
							roomHasAPedestal = true
						end
					end
					if roomHasAPedestal then
						data.botbFTNHasCheckedTreasureRoom = true
					else
						local chance = math.random()
						--print(chance)
						if chance >= botbFTNChanceThreshold then
							--print("secret.")
							SFXManager():Play(SoundEffect.SOUND_THE_FORSAKEN_SCREAM,4,0,false,math.random(150,250)/100,0)
							local ftnPedestal = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(Game():GetRoom():GetCenterPos(), 10), Vector.Zero, players[i]):ToPickup()
							Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF01,0,ftnPedestal.Position, Vector.Zero, ftnPedestal)
						end
						data.botbFTNHasCheckedSecretRoom = true
					end
				end

				if roomConfigRoom.Type == RoomType.ROOM_CURSE then
					--print("curse?")
					local roomEntities = Isaac.GetRoomEntities() -- table
					for i = 1, #roomEntities do
						local entity = roomEntities[i]
						if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
							roomHasAPedestal = true
						end
					end
					if roomHasAPedestal then
						data.botbFTNHasCheckedCurseRoom = true
					else
						local chance = math.random()
						--print(chance)
						if chance >= botbFTNChanceThreshold then
							--print("curse.")
							SFXManager():Play(SoundEffect.SOUND_THE_FORSAKEN_SCREAM,4,0,false,math.random(150,250)/100,0)
							local ftnPedestal = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(Game():GetRoom():GetCenterPos(), 10), Vector.Zero, players[i]):ToPickup()
							Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF01,0,ftnPedestal.Position, Vector.Zero, ftnPedestal)
						end
						data.botbFTNHasCheckedCurseRoom = true
					end
		
				end

				if roomConfigRoom.Type == RoomType.ROOM_TREASURE  then
					--Search for pedestals
					local roomEntities = Isaac.GetRoomEntities() -- table
					for i = 1, #roomEntities do
						local entity = roomEntities[i]
						if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
							roomHasAPedestal = true
						end
					end
					if roomHasAPedestal then
						data.botbFTNHasCheckedTreasureRoom = true
					else
						SFXManager():Play(SoundEffect.SOUND_THE_FORSAKEN_SCREAM,4,0,false,math.random(150,250)/100,0)
						local ftnPedestal = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(Game():GetRoom():GetCenterPos(), 10), Vector.Zero, players[i]):ToPickup()
						Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF01,0,ftnPedestal.Position, Vector.Zero, ftnPedestal)
						data.botbFTNHasCheckedTreasureRoom = true
					end
				end

				if roomConfigRoom.Type == RoomType.ROOM_ANGEL  then
					--Search for pedestals
					local roomEntities = Isaac.GetRoomEntities() -- table
					for i = 1, #roomEntities do
						local entity = roomEntities[i]
						if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
							roomHasAPedestal = true
						end
					end
					if roomHasAPedestal then
						data.botbFTNHasCheckedAngelRoom = true
					else
						SFXManager():Play(SoundEffect.SOUND_THE_FORSAKEN_SCREAM,4,0,false,math.random(150,250)/100,0)
						local ftnPedestal = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(Game():GetRoom():GetCenterPos(), 10), Vector.Zero, players[i]):ToPickup()
						Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF01,0,ftnPedestal.Position, Vector.Zero, ftnPedestal)
						data.botbFTNHasCheckedAngelRoom = true
					end
				end

				if roomConfigRoom.Type == RoomType.ROOM_DEVIL  then
					--Search for pedestals
					local roomEntities = Isaac.GetRoomEntities() -- table
					for i = 1, #roomEntities do
						local entity = roomEntities[i]
						print(entity.Type, entity.Variant, entity.SubType)
						if entity.Type == EntityType.ENTITY_PICKUP and (entity.Variant == PickupVariant.PICKUP_SHOPITEM or entity.Variant == PickupVariant.PICKUP_COLLECTIBLE) then
							roomHasAPedestal = true
						end
					end
					if roomHasAPedestal then
						data.botbFTNHasCheckedDevilRoom = true
					else
						SFXManager():Play(SoundEffect.SOUND_THE_FORSAKEN_SCREAM,4,0,false,math.random(150,250)/100,0)
						local ftnPedestal = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_SHOPITEM, 0, Isaac.GetFreeNearPosition(Game():GetRoom():GetCenterPos(), 10), Vector.Zero, players[i]):ToPickup()
						Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF01,0,ftnPedestal.Position, Vector.Zero, ftnPedestal)
						data.botbFTNHasCheckedDevilRoom = true
					end
				end



			end
		end
		if not doesSomeoneHaveFuckThatNoise then return end

		
	
	  end
	  Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, FUCK_THAT_NOISE.doFuckThatNoisePedestal, 0)

	  --resets the checklist of room types to check
	  function FUCK_THAT_NOISE:resetFuckThatNoiseChecklist()
		--if not roomDescriptor.VisitedCount == 1 then return end
		local players = getPlayers()
		local doesSomeoneHaveFuckThatNoise = false
		local bwcMultiplier= 0
		for i=1,#players,1 do
			if players[i]:ToPlayer():HasCollectible(Isaac.GetTrinketIdByName("Fuck That Noise")) then
				--print("dicks")
				doesSomeoneHaveFuckThatNoise = true
	
			end
		end
		if not doesSomeoneHaveFuckThatNoise then return end

		for i=1,#players,1 do
			if players[i]:ToPlayer():HasCollectible(Isaac.GetTrinketIdByName("Fuck That Noise")) then
				--print("dicks")
				local data = players[i]:ToPlayer():GetData()
				if data.botbFTNHasCheckedTreasureRoom == nil then
					data.botbFTNHasCheckedTreasureRoom = false
					data.botbFTNHasCheckedCurseRoom = false
					data.botbFTNHasCheckedSecretRoom = false
					data.botbFTNHasCheckedDevilRoom = false
					data.botbFTNHasCheckedAngelRoom = false
				end
	
			end
		end
		if not doesSomeoneHaveFuckThatNoise then return end
	
	  end
	  Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, FUCK_THAT_NOISE.resetFuckThatNoiseChecklist, 0)