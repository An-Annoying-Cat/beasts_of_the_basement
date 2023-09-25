local Mod = BotB
local TIMES_TEN_SHITPOSTS = {}
local Items = BotB.Enums.Items

if EID then
	EID:addCollectible(Items.TEN_SOULS, "+10 soul hearts.")
	EID:addCollectible(Items.TEN_TRINKETS, "+10 trinkets.")
	EID:addCollectible(Items.TEN_ITEMS, "+10 items.")
	EID:addCollectible(Items.TEN_WISPS, "+10 random wisps.")
	EID:addCollectible(Items.TEN_CARDS, "+10 random consumables.")
	EID:addCollectible(Items.TEN_PILLS, "+10 random pills. #25% chance to be a horse pill per pill.")
	EID:addCollectible(Items.TEN_CLOTS, "+10 random clot familiars.")
	EID:addCollectible(Items.TEN_FLIES, "+10 blue flies.")
	EID:addCollectible(Items.TEN_SPIDERS, "+10 blue spiders.")
	EID:addCollectible(Items.TEN_SKUZZES, "+10 blue skuzzes.")
	EID:addCollectible(Items.TEN_DIPS, "+10 random friendly dips.")
	EID:addCollectible(Items.TEN_POOPS, "+10 poops.")
	EID:addCollectible(Items.TEN_TENS, "+10 x10 items.")
end
--[[
--Spawn dirt clump and a random worm trinket
FiendFolio.AddItemPickupCallback(function(player)
	--local rng = player:GetCollectibleRNG(BotB.Enums.Items.TIMES_TEN_SHITPOSTS)
	--local pickupType = FiendFolio.GetRandomObject(rng)
	Isaac.Spawn(5, 10, HeartSubType.HEART_ROTTEN, room:FindFreePickupSpawnPosition(player.Position, 20)+BotB.FF:shuntedPosition(10, rng), Vector.Zero, nil)
end, nil, BotB.Enums.Items.TIMES_TEN_SHITPOSTS)
--]]
--
function TIMES_TEN_SHITPOSTS:onItemGet(player, type)
	--print("test")
	local room = Game():GetRoom()
	if type == Items.TEN_SOULS then
		SFXManager():Play(SoundEffect.SOUND_HOLY,2,0,false,0.8,0)
		player:AddSoulHearts(20)
	end
	if type == Items.TEN_TRINKETS then
		SFXManager():Play(SoundEffect.SOUND_FETUS_FEET,2,0,false,0.5,0)
		for i=0,9 do
			Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TRINKET,0,Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero,player)
		end
	end
	if type == Items.TEN_ITEMS then
		SFXManager():Play(SoundEffect.SOUND_POWERUP1,2,0,false,0.5,0)
		for i=0,9 do
			Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,0,Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero,player)
		end
	end
	if type == Items.TEN_WISPS then
		SFXManager():Play(SoundEffect.SOUND_CANDLE_LIGHT,2,0,false,0.5,0)
		local basedata = player:GetData()
			local data = basedata.ffsavedata or basedata
		for i=0,9 do
			TIMES_TEN_SHITPOSTS:spawnFreeCrackWisp(player, data)	
		end
	end
	if type == Items.TEN_CARDS then
		SFXManager():Play(Isaac.GetSoundIdByName("CardDraw"),2,0,false,0.5,0)
		for i=0,9 do
			local cardIDLimit = (#Isaac.GetItemConfig():GetCards())-1
			Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,math.random(1,cardIDLimit),Isaac.GetFreeNearPosition(player.Position, 10),Vector(math.random(2,5),0):Rotated(math.random(0,359)),player)
	
		end
	end
	if type == Items.TEN_PILLS then
		SFXManager():Play(SoundEffect.SOUND_POWERUP_SPEWER,2,0,false,0.5,0)
		for i=0,9 do
			--25% chance to be horse pills
			if math.random(0,3) == 1 then
				local pill = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, Isaac.GetFreeNearPosition(player.Position, 10), Vector(math.random(2,5),0):Rotated(math.random(0,359)), player):ToPickup()
						--entityPickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, true, true, true)
						local pillToGiant = pill.SubType + PillColor.PILL_GIANT_FLAG
						pill:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, pillToGiant, true, true, true)
			else
				local pill = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_PILL,0,Isaac.GetFreeNearPosition(player.Position, 10),Vector.Zero,player)
			end
		end
	end
	if type == Items.TEN_CLOTS then
		SFXManager():Play(SoundEffect.SOUND_HEARTOUT,2,0,false,0.5,0)
		local clotPool = {
			0,
			1,
			2,
			3,
			4,
			5,
			6,
			7,
			920, --immoral
			921, --morbid
		}
		for i=0,9 do
			Isaac.Spawn(EntityType.ENTITY_FAMILIAR,FamiliarVariant.BLOOD_BABY,clotPool[math.random(1,#clotPool)],Isaac.GetFreeNearPosition(player.Position, 10),Vector.Zero,player)
		end
	end

	if type == Items.TEN_FLIES then
		SFXManager():Play(Isaac.GetSoundIdByName("BeeBuzz"),2,0,false,0.5,0)
		for i=0,9 do
			Isaac.Spawn(EntityType.ENTITY_FAMILIAR,FamiliarVariant.BLUE_FLY,0,Isaac.GetFreeNearPosition(player.Position, 10),Vector.Zero,player)
		end
	end

	if type == Items.TEN_SPIDERS then
		SFXManager():Play(Isaac.GetSoundIdByName("CardMove"),2,0,false,0.5,0)
		for i=0,9 do
			Isaac.Spawn(EntityType.ENTITY_FAMILIAR,FamiliarVariant.BLUE_SPIDER,0,Isaac.GetFreeNearPosition(player.Position, 10),Vector.Zero,player)
		end
	end

	if type == Items.TEN_SKUZZES then
		SFXManager():Play(SoundEffect.SOUND_SKIN_PULL,2,0,false,0.5,0)
		for i=0,9 do
			Isaac.Spawn(EntityType.ENTITY_FAMILIAR,1026,0,Isaac.GetFreeNearPosition(player.Position, 10),Vector.Zero,player)
		end
	end

	if type == Items.TEN_DIPS then
		SFXManager():Play(Isaac.GetSoundIdByName("FunnyFart"),2,0,false,0.5,0)
		local dipPool = {
			0,
			1,
			2,
			3,
			4,
			5,
			6,
			12,
			13,
			14,
			20,
			666,
			667,
			668,
			668,
			670,
			671,
			672,
			673
		}
		for i=0,9 do
			Isaac.Spawn(EntityType.ENTITY_FAMILIAR,FamiliarVariant.DIP,dipPool[math.random(1,#dipPool)],Isaac.GetFreeNearPosition(player.Position, 10),Vector.Zero,player)
		end
	end
	local poopTypePool = {
		{"grid", 0},
		{"grid", 1},
		{"grid", 2},
		{"grid", 3},
		{"grid", 4},
		{"grid", 5},
		{"grid", 6},
		{"grid", 11},
		--FF poops
		{"spawn", 183, 1026, 0},
		{"spawn", 183, 1028, 0},
		{"spawn", 184, 1031, 0},
		{"spawn", 184, 1032, 0},
		{"spawn", 183, 1033, 0},
		{"spawn", 183, 1037, 0},
		{"spawn", 184, 1037, 40},
	}
	local rarePoopTypePool = {
		{"spawn", 183, 1027, 0},
		{"spawn", 183, 1036, 0},
	}
	if type == Items.TEN_POOPS then
		SFXManager():Play(SoundEffect.SOUND_FART_MEGA,5,0,false,0.5,0)
		for i=0,9 do
			local randoPos = Game():GetRoom():FindFreeTilePosition(Game():GetRoom():GetRandomPosition(10), 0)
			local randoPoop
			if math.random(1,1000) == 1 then
				randoPoop = rarePoopTypePool[math.random(1,#rarePoopTypePool)]
			else
				randoPoop = poopTypePool[math.random(1,#poopTypePool)]
			end
			
			if randoPoop[1] == "grid" then 
				local spawnedPoop = Isaac.GridSpawn(GridEntityType.GRID_POOP,randoPoop[2],randoPos,true)
			elseif randoPoop[1] == "spawn" then
				local spawnedPoop = Isaac.Spawn(randoPoop[2],randoPoop[3],randoPoop[4],randoPos,Vector.Zero,player)
			end
        	Game():ButterBeanFart(randoPos, 140, player, true, false)
		end
	end

	if type == Items.TEN_TENS then
		for i = 1, 100 do
			FiendFolio.scheduleForUpdate(function()
				--local opacity
				if i % 1 == 0 then
					SFXManager():Play(BotB.Enums.SFX.PLUS_TEN,math.random(300,500)/100,0,false,math.random(500,2000)/1000,0)
				end
			end, i, ModCallbacks.MC_POST_RENDER)
		end
		for i=0,9 do
			player:UseCard(Isaac.GetCardIdByName("Misprinted Justice"), UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
		end
	end

end
Mod:AddCallback(TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED, TIMES_TEN_SHITPOSTS.onItemGet)


function TIMES_TEN_SHITPOSTS:spawnFreeCrackWisp(player, data)
	local PageOfVirtuesId = FiendFolio:rollPageOfVitruesEffect()
	local wisp = player:AddWisp(PageOfVirtuesId, player.Position, true)
	if wisp then
		sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT, 1, 0, false, 1)
	end
end

--