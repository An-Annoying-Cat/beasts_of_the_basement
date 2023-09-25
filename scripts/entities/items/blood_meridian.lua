local Mod = BotB
local mod = FiendFolio
local BLOOD_MERIDIAN = {}
local pickups = BotB.Enums.Pickups
local sfx = SFXManager()
local fiftyShadesBaseDuration = 480

local HiddenItemManager = require("scripts.core.hidden_item_manager")

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Blood Meridian"), "On use: Enemies explode into blood and bone projectiles on death, as well as inflicting fear onto other enemies around them when they do so. #Passively turns on the More Gore seed effect while being held.")
end

function BLOOD_MERIDIAN:GetPlayers()
	local players = {}

	for i = 1, game:GetNumPlayers() do
		table.insert(players, game:GetPlayer(i))
	end

	return players
end

	function BLOOD_MERIDIAN:houseOfLeavesActiveItem(_, _, player, _, _, _)
		player:AnimateCollectible(Isaac.GetItemIdByName("Blood Meridian"))
		--sfx:Play(BotB.FF.Sounds.EnergyFairy,3,0,false,math.random(8000,12000)/10000)
		--local houseOfLeavesPortal = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.PORTAL_TELEPORT, math.random(0,3), Isaac.GetFreeNearPosition(player.Position, 10), Vector.Zero, player)
		HiddenItemManager:AddForRoom(player, BotB.Enums.Items.BLOOD_MERIDIAN_DUMMY, 0, 1)
	end
	Mod:AddCallback(ModCallbacks.MC_USE_ITEM,BLOOD_MERIDIAN.houseOfLeavesActiveItem,Isaac.GetItemIdByName("Blood Meridian"))







	function BLOOD_MERIDIAN:playerUpdate(player)
		--if player == nil then return end
		--passive effects while holding the active
		if not player:HasCollectible(Isaac.GetItemIdByName("Blood Meridian")) then return end
		local data = player:GetData()
		local level = Game():GetLevel()
		local seeds = Game():GetSeeds()

		--blood meridian passive

		
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
			BLOOD_MERIDIAN:setXXXL(player,true)
		end]]
		
	end
	Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, BLOOD_MERIDIAN.playerUpdate)

	function BLOOD_MERIDIAN:onDummyKill(entityPreConv)
		local entity = entityPreConv:ToNPC()
		local players = BLOOD_MERIDIAN:GetPlayers()
		local doesSomeoneHaveBloodMeridianDummy = false
		local playerWithMeridian
		for i=1,#players,1 do
			if players[i]:ToPlayer():HasCollectible(Isaac.GetItemIdByName("Blood Meridian Dummy")) then
				--print("dicks")
				doesSomeoneHaveBloodMeridianDummy = true
				playerWithMeridian = players[i]:ToPlayer()
			end
		end
		if not doesSomeoneHaveBloodMeridianDummy then return end
		
		if entity:IsEnemy() then
			if entity:IsBoss() then
				SFXManager():Play(Isaac.GetSoundIdByName("MadnessSplash"),3,0,false,math.random(70,80)/100)
				SFXManager():Play(Isaac.GetSoundIdByName("MeatyBurst"),3,0,false,math.random(70,80)/100)
				local entityToNPC = entity:ToNPC()
				local spawnPos = entity.Position
				local bloodMeridianBloodShotParams = ProjectileParams()
				bloodMeridianBloodShotParams.BulletFlags = ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES | ProjectileFlags.BURST
				bloodMeridianBloodShotParams.VelocityMulti = 3
				entityToNPC:FireBossProjectiles(12, spawnPos, 5, bloodMeridianBloodShotParams)
				local bloodMeridianBoneShotParams = ProjectileParams()
				bloodMeridianBoneShotParams.BulletFlags = ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES | ProjectileFlags.BOUNCE | ProjectileFlags.BOUNCE_FLOOR | ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT
				bloodMeridianBoneShotParams.Variant = ProjectileVariant.PROJECTILE_BONE
				bloodMeridianBoneShotParams.ChangeTimeout = 60
				bloodMeridianBoneShotParams.ChangeFlags = ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES | ProjectileFlags.BOUNCE
				bloodMeridianBoneShotParams.VelocityMulti = 2
				entityToNPC:FireBossProjectiles(4, spawnPos, 2, bloodMeridianBoneShotParams)
				local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, entity.Position, Vector(0,0), playerWithMeridian)
				creep.SpriteScale = creep.SpriteScale * 4
			else
				SFXManager():Play(Isaac.GetSoundIdByName("MadnessSplash"),2,0,false,math.random(100,120)/100)
			SFXManager():Play(Isaac.GetSoundIdByName("MeatyBurst"),2,0,false,math.random(100,120)/100)
			local entityToNPC = entity:ToNPC()
			local spawnPos = entity.Position
			local bloodMeridianBloodShotParams = ProjectileParams()
			bloodMeridianBloodShotParams.BulletFlags = ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES | ProjectileFlags.BURST
			bloodMeridianBloodShotParams.VelocityMulti = 3
			entityToNPC:FireBossProjectiles(math.random(2,3), spawnPos, 5, bloodMeridianBloodShotParams)
			local bloodMeridianBoneShotParams = ProjectileParams()
			bloodMeridianBoneShotParams.BulletFlags = ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES | ProjectileFlags.BOUNCE | ProjectileFlags.BOUNCE_FLOOR | ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT
			bloodMeridianBoneShotParams.Variant = ProjectileVariant.PROJECTILE_BONE
			bloodMeridianBoneShotParams.ChangeTimeout = 60
			bloodMeridianBoneShotParams.ChangeFlags = ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES | ProjectileFlags.BOUNCE
			bloodMeridianBoneShotParams.VelocityMulti = 2
			entityToNPC:FireBossProjectiles(math.random(1,2), spawnPos, 2, bloodMeridianBoneShotParams)
			local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, entity.Position, Vector(0,0), playerWithMeridian)
            creep.SpriteScale = creep.SpriteScale * 3
			end
			
		end

	end
	Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, BLOOD_MERIDIAN.onDummyKill)

