local Mod = BotB
local mod = FiendFolio
local HOUSE_OF_LEAVES = {}
local pickups = BotB.Enums.Pickups
local sfx = SFXManager()
local fiftyShadesBaseDuration = 480

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("House Of Leaves"), "On use: Spawns a random Card Reading portal leading somewhere on the {{ColorBlue}}floor{{ColorReset}}. #{{Warning}} Passively: {{ColorBlue}}Floors{{ColorReset}} generate much larger, but extra special rooms of random types can generate.")
end

function HOUSE_OF_LEAVES:GetPlayers()
	local players = {}

	for i = 1, game:GetNumPlayers() do
		table.insert(players, game:GetPlayer(i))
	end

	return players
end

	function HOUSE_OF_LEAVES:houseOfLeavesActiveItem(_, _, player, _, _, _)
		player:AnimateCollectible(Isaac.GetItemIdByName("House Of Leaves"))
		--sfx:Play(BotB.FF.Sounds.EnergyFairy,3,0,false,math.random(8000,12000)/10000)
		local seeds = Game():GetSeeds()
		
		--[[
		
		seeds:AddSeedEffect(SeedEffect.SEED_HEALTH_PITCH)
            seeds:AddSeedEffect(SeedEffect.SEED_PERMANENT_CURSE_LOST)
            seeds:AddSeedEffect(SeedEffect.SEED_PERMANENT_CURSE_MAZE)
		]]
		if Isaac.GetChallenge() == Isaac.GetChallengeIdByName("[BOTB] MyBasement.lua") or Isaac.GetChallenge() == Challenge.CHALLENGE_XXXXXXXXL or (seeds:HasSeedEffect(SeedEffect.SEED_HEALTH_PITCH) and seeds:HasSeedEffect(SeedEffect.SEED_PERMANENT_CURSE_LOST) and seeds:HasSeedEffect(SeedEffect.SEED_PERMANENT_CURSE_MAZE) ) then
			--print("penis check passed")
			if game:GetLevel():GetStage() == LevelStage.STAGE1_1 then
				SFXManager():Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ,0.5,0,false,0.5,0)
			else
				local randoBossBlacklisted = math.random(0,3)
				--No boss if you're playing mybasement! That would be a cheap win!
				--0: treasure
				--1: secret
				--2: uncompleted
				if randoBossBlacklisted == 0 then
					local houseOfLeavesPortal = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.PORTAL_TELEPORT, 0, Isaac.GetFreeNearPosition(player.Position, 10), Vector.Zero, player)
				elseif randoBossBlacklisted == 1 then
					local houseOfLeavesPortal = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.PORTAL_TELEPORT, 2, Isaac.GetFreeNearPosition(player.Position, 10), Vector.Zero, player)
				elseif randoBossBlacklisted == 2 then
					local houseOfLeavesPortal = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.PORTAL_TELEPORT, 3, Isaac.GetFreeNearPosition(player.Position, 10), Vector.Zero, player)
				elseif randoBossBlacklisted == 3 then
					local houseOfLeavesPortal = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.PORTAL_TELEPORT, 3, Isaac.GetFreeNearPosition(player.Position, 10), Vector.Zero, player)
				end
				SFXManager():Play(BotB.Enums.SFX.GLITCHY_BOOM,3,0,false,math.random(40,60)/100)
			end
			
			
		else
			--normal
			local houseOfLeavesPortal = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.PORTAL_TELEPORT, math.random(0,3), Isaac.GetFreeNearPosition(player.Position, 10), Vector.Zero, player)
			SFXManager():Play(BotB.Enums.SFX.GLITCHY_BOOM,3,0,false,math.random(40,60)/100)
		end

		
		
	end
	Mod:AddCallback(ModCallbacks.MC_USE_ITEM,HOUSE_OF_LEAVES.houseOfLeavesActiveItem,Isaac.GetItemIdByName("House Of Leaves"))







	function HOUSE_OF_LEAVES:playerUpdate(player)
		
		--if player == nil then return end
		if not player:HasCollectible(Isaac.GetItemIdByName("House Of Leaves")) then return end

		local players = HOUSE_OF_LEAVES:GetPlayers()
		local doesSomeoneHaveBloodMeridianDummy = false
		local playerWithMeridian
		for i=1,#players,1 do
			if players[i]:ToPlayer():HasCollectible(Isaac.GetItemIdByName("House Of Leaves")) then
				--print("dicks")
				doesSomeoneHaveBloodMeridianDummy = true
				--playerWithMeridian = players[i]:ToPlayer()
			end
		end
		if not doesSomeoneHaveBloodMeridianDummy then return end

		local data = player:GetData()
		local level = Game():GetLevel()
		local seeds = Game():GetSeeds()
		if Game().Challenge ~= Challenge.CHALLENGE_NULL then
			--challenge compat
			local convertChallenge = Game().Challenge
			local trapdoorsTable = TSIL.GridSpecific.GetTrapdoors(TSIL.Enums.TrapdoorVariant.NORMAL)
			if #trapdoorsTable ~= 0 then
				--compare distance
				for i=1, #trapdoorsTable, 1 do
					if trapdoorsTable[i].Position:Distance(player.Position) <= 10 then
						if Game().Challenge ~= Challenge.CHALLENGE_XXXXXXXXL then
							Game().Challenge = Challenge.CHALLENGE_XXXXXXXXL
						end
					end
				end
			else
				if Game().Challenge == Challenge.CHALLENGE_XXXXXXXXL then
					Game().Challenge = convertChallenge
				end
			end

		else

			local trapdoorsTable = TSIL.GridSpecific.GetTrapdoors(TSIL.Enums.TrapdoorVariant.NORMAL)
			if #trapdoorsTable ~= 0 then
				--compare distance
				for i=1, #trapdoorsTable, 1 do
					if trapdoorsTable[i].Position:Distance(player.Position) <= 10 then
						if Game().Challenge ~= Challenge.CHALLENGE_XXXXXXXXL then
							Game().Challenge = Challenge.CHALLENGE_XXXXXXXXL
						end
					end
				end
			else
				if Game().Challenge == Challenge.CHALLENGE_XXXXXXXXL then
					Game().Challenge = Challenge.CHALLENGE_NULL
				end
			end

		end
		
		--[[
		if (not (Isaac.GetCurseIdByName("Curse of the Labyrinth") & level:GetCurses() == Isaac.GetCurseIdByName("Curse of the Labyrinth"))) and level:CanStageHaveCurseOfLabyrinth(level:GetAbsoluteStage()) then
			--if curse of the labyrinth isnt there already
			level:AddCurse(1 << (Isaac.GetCurseIdByName("Curse of the Labyrinth") - 1), true)
		end]]
		--print(seeds:HasSeedEffect(SeedEffect.SEED_PERMANENT_CURSE_LABYRINTH))
		--[[
		if (not seeds:HasSeedEffect(SeedEffect.SEED_PERMANENT_CURSE_LABYRINTH)) and seeds:CanAddSeedEffect(SeedEffect.SEED_PERMANENT_CURSE_LABYRINTH) then
			print("now has the seed effect")
			seeds:AddSeedEffect(SeedEffect.SEED_PERMANENT_CURSE_LABYRINTH)
		end
		]]
		
		
		--[[
		if data.hasHouseOfLeavesXXL ~= true then
			HOUSE_OF_LEAVES:setXXXL(player,true)
		end]]
		
	end
	Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, HOUSE_OF_LEAVES.playerUpdate)


	--[[
	function HOUSE_OF_LEAVES:preNewFloorLogic(player)
		--print("test")
		print("now has xxxxxxl")
			local character = player:GetPlayerType()
			game.Challenge = Challenge.CHALLENGE_XXXXXXXXL
	  		player:ChangePlayerType(character)
	end
	Mod:AddCallback(TSIL.Enums.CustomCallback.PRE_NEW_LEVEL, HOUSE_OF_LEAVES.preNewFloorLogic)]]


	--modified from Atlas from Tainted Treasures to make special rooms generate more
	function HOUSE_OF_LEAVES:botbHOLFloorLogic()
		--[[
		local level = Game():GetLevel()
		if Game().Challenge ~= Challenge.CHALLENGE_XXXXXXXXL then
			print("now has xxxxxxl")
			local character = player:GetPlayerType()
			game.Challenge = Challenge.CHALLENGE_XXXXXXXXL
	  		player:ChangePlayerType(character)
		end
		]]
		local doesSomeoneHaveHouseOfLeaves = false
		local players = HOUSE_OF_LEAVES:GetPlayers()
		for i=1,#players,1 do
			if players[i]:ToPlayer():HasCollectible(Isaac.GetItemIdByName("House Of Leaves")) then
				--print("dicks")
				doesSomeoneHaveHouseOfLeaves = true
				if players[i]:ToPlayer():GetData().botbGotTheirMyBasementShit2 == true then
					--Game().Challenge = Isaac.GetChallengeIdByName("[BOTB] MyBasement.lua")
				end
	
			end
		end
		if not doesSomeoneHaveHouseOfLeaves then return end

		Game().Challenge = Challenge.CHALLENGE_NULL


		local level = game:GetLevel()
		if level:GetStage() ~= LevelStage.STAGE8 then --Home
			local generate = 20
			local currentroomidx = level:GetCurrentRoomIndex()
			--[[
			for i, player in pairs(HOUSE_OF_LEAVES:GetPlayersHoldingCollectible(TaintedCollectibles.ATLAS)) do
				generate = generate + player:GetCollectibleNum(TaintedCollectibles.ATLAS)
			end
			
			
			local houseOfLeavesSpecialRoomTypes = {
				"shop",
				--"error",
				--"miniboss",
				--"secret",
				--"supersecret",
				"arcade",
				"curse",
				--"challenge",
				"library",
				--"sacrifice",
				--"devil",
				--"angel",
				"isaacs",
				"barren",
				"chest",
				"dice",
				"treasure",
			}]]

			--randomized special rooms...
			for i = 0, generate, 1 do
				--[[
				local houseOfLeavesRandomType = math.random(1,#houseOfLeavesSpecialRoomTypes)
				print(houseOfLeavesSpecialRoomTypes[houseOfLeavesRandomType])
				local typeString = houseOfLeavesRandomType
				HOUSE_OF_LEAVES:doThisRoom(typeString)]]
				--[[
				if houseOfLeavesRandomType == "shop" then
					TaintedTreasure:GenerateSpecialRoom("shop", 1, 17, true)
				elseif houseOfLeavesRandomType == "miniboss" then
					TaintedTreasure:GenerateSpecialRoom("miniboss", 2000, 2262, true)
				elseif houseOfLeavesRandomType == "arcade" then
					TaintedTreasure:GenerateSpecialRoom("arcade", 0, 51, true)
				elseif houseOfLeavesRandomType == "curse" then
					TaintedTreasure:GenerateSpecialRoom("curse", 0, 40, true)
				elseif houseOfLeavesRandomType == "challenge" then
					TaintedTreasure:GenerateSpecialRoom("challenge", 0, 24, true)
				elseif houseOfLeavesRandomType == "library" then
					TaintedTreasure:GenerateSpecialRoom("library", 0, 17, true)
				elseif houseOfLeavesRandomType == "sacrifice" then
					TaintedTreasure:GenerateSpecialRoom("sacrifice", 1, 999, true)
				elseif houseOfLeavesRandomType == "devil" then
					TaintedTreasure:GenerateSpecialRoom("devil", 1, 999, true)
				elseif houseOfLeavesRandomType == "angel" then
					TaintedTreasure:GenerateSpecialRoom("angel", 0, 45, true)
				elseif houseOfLeavesRandomType == "isaacs" then
					TaintedTreasure:GenerateSpecialRoom("isaacs", 0, 29, true)
				elseif houseOfLeavesRandomType == "barren" then
					TaintedTreasure:GenerateSpecialRoom("barren", 0, 28, true)
				elseif houseOfLeavesRandomType == "chest" then
					TaintedTreasure:GenerateSpecialRoom("chest", 0, 48, true)
				elseif houseOfLeavesRandomType == "dice" then
					TaintedTreasure:GenerateSpecialRoom("dice", 0, 20, true)
				elseif houseOfLeavesRandomType == "treasure" then
					TaintedTreasure:GenerateSpecialRoom("treasure", 0, 37, true)
				end
				--]]
				
				--Merciful christ.

				--And it didn't even work...

				--sisyphus.jpeg

				TaintedTreasure:GenerateExtraRoom()
				--StageAPI.SetRoomFromList(roomsList, roomType, requireRoomType, isExtraRoom, load, seed, shape, fromSaveData)
			end
		end
	end
	Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, HOUSE_OF_LEAVES.botbHOLFloorLogic, 0)
	