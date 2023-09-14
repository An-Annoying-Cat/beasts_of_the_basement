local Mod = BotB
local mod = FiendFolio
local ENLIGHTENMENT = {}
local pickups = BotB.Enums.Pickups
local sfx = SFXManager()
local fiftyShadesBaseDuration = 480

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Enlightenment"), "Grants 10 seconds of invulnerability and a large, fading buff to your {{Speed}} Speed and {{Luck}} Luck. #{{Warning}} The enemy in the room with the highest health is annihilated by a massive fucking beam of light, from which Revelation beams are shot from in an X-formation.")
end

function ENLIGHTENMENT:GetPlayers()
	local players = {}

	for i = 1, game:GetNumPlayers() do
		table.insert(players, game:GetPlayer(i))
	end

	return players
end

function ENLIGHTENMENT:GetBestCandidates()
	local healthBaseline = 0
		local bestCandidates = {}
		for i, entity in ipairs(Isaac.GetRoomEntities()) do
			if entity.MaxHitPoints > healthBaseline then
				healthBaseline = entity.MaxHitPoints
			end
		end
		for i, entity in ipairs(Isaac.GetRoomEntities()) do
			if entity.MaxHitPoints == healthBaseline then
				table.insert(bestCandidates, entity)
			end
		end
		return bestCandidates
end

	function ENLIGHTENMENT:enlightenmentActiveItem(_, _, player, _, _, _)
		player:AnimateCollectible(Isaac.GetItemIdByName("Enlightenment"))
		--sfx:Play(BotB.FF.Sounds.EnergyFairy,3,0,false,math.random(8000,12000)/10000)
		local enlightenmentBestCandidates = ENLIGHTENMENT:GetBestCandidates()
		print(#enlightenmentBestCandidates)
		local chosenEnlightenmentCandidate
		if #enlightenmentBestCandidates ~= 0 then
			if #enlightenmentBestCandidates == 1 then
				chosenEnlightenmentCandidate = enlightenmentBestCandidates[1]
			elseif #enlightenmentBestCandidates > 1 then
				chosenEnlightenmentCandidate = enlightenmentBestCandidates[math.random(1,#enlightenmentBestCandidates)]
			end
			--stats
			player:GetData().botbEnlightenmentTimer = player:GetData().botbEnlightenmentTimer + 240
			--
			local botbEnlightenmentBeamPos = chosenEnlightenmentCandidate.Position
			local candidate = EntityRef(chosenEnlightenmentCandidate)
			local botbEnlightenmentDelay = 150
            for i = 1, botbEnlightenmentDelay do
                BotB.FF.scheduleForUpdate(function()
                    --print(i)
                    if i >= botbEnlightenmentDelay then
                        --Utter goddamn chaos
						
						local botbEnlightenmentVirtueBeam = Isaac.Spawn(1000,mod.FF.ZealotBeam.Var,mod.FF.ZealotBeam.Sub,botbEnlightenmentBeamPos,Vector.Zero,player):ToEffect()
						botbEnlightenmentVirtueBeam:GetData().botbVirtueBeamIsFromEnlightenment = true
						botbEnlightenmentVirtueBeam.SpriteScale = Vector(2,2)
						--botbEnlightenmentVirtueBeam:SetDamageSource(EntityType.ENTITY_PLAYER)
						local botbEnlightenmentVirtueSprite = botbEnlightenmentVirtueBeam:GetSprite()
						for i = 0, 2 do
							botbEnlightenmentVirtueSprite:ReplaceSpritesheet(i, "gfx/effects/enlightenment_zealot_beam.png")
						end
						
						botbEnlightenmentVirtueSprite:LoadGraphics()
						
						--local botbEnlightenmentRevelationCircBeam = EntityLaser.ShootAngle(7, botbEnlightenmentBeamPos, 0, 40, Vector.Zero, player)
							local botbEnlightenmentRevelationCircBeam = Isaac.Spawn(EntityType.ENTITY_LASER,8,LaserSubType.LASER_SUBTYPE_RING_FOLLOW_PARENT,botbEnlightenmentBeamPos,Vector.Zero,player):ToLaser()
							botbEnlightenmentRevelationCircBeam.Parent = player
							botbEnlightenmentRevelationCircBeam.DisableFollowParent = true
							botbEnlightenmentRevelationCircBeam.Radius = 100
							botbEnlightenmentRevelationCircBeam:GetSprite().Scale = Vector(2,2)
							botbEnlightenmentRevelationCircBeam:SetTimeout(480)
							botbEnlightenmentRevelationCircBeam.CollisionDamage = player.Damage*5
							botbEnlightenmentRevelationCircBeam:SetOneHit(false)
							BotB.FF.scheduleForUpdate(function()
								SFXManager():Stop(SoundEffect.SOUND_ANGEL_BEAM)	
							end, i, ModCallbacks.MC_POST_LASER_UPDATE)
						--For some reason I have to specify the variant, using the enum just gives me brimtech
						for i=0, 270, 90 do
							local botbEnlightenmentRevelationBeam = EntityLaser.ShootAngle(8, botbEnlightenmentBeamPos+Vector(0,90):Rotated((-i-45)+180), -i+45, 40, Vector.Zero, player)
							botbEnlightenmentRevelationBeam.DisableFollowParent = true
							botbEnlightenmentRevelationBeam:SetMaxDistance(90)
							botbEnlightenmentRevelationBeam:SetTimeout(480)
							botbEnlightenmentRevelationBeam:GetSprite().Scale = Vector(2,2)
							BotB.FF.scheduleForUpdate(function()
								SFXManager():Stop(SoundEffect.SOUND_ANGEL_BEAM)	
							end, i, ModCallbacks.MC_POST_LASER_UPDATE)
							botbEnlightenmentRevelationBeam.CollisionDamage = player.Damage*5
							botbEnlightenmentRevelationBeam:SetOneHit(false)
						end
						
						--Play the sound
						SFXManager():Play(Isaac.GetSoundIdByName("EnlightenmentFire"),10,0,false,math.random(90, 110)/100)
					elseif i == 1 then
						botbEnlightenmentBeamPos = candidate.Entity.Position
						--Warning!!
						local warningTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.WARNING_TARGET.VARIANT,0,botbEnlightenmentBeamPos,Vector(0,0),nil):ToEffect()
						warningTarget.Color = Color(1,1,1,1,2,1,0)
						warningTarget.SpriteScale = Vector(3,3)
                    else
						botbEnlightenmentBeamPos = candidate.Entity.Position
                        --Nothing lol
                    end
                    
                end, i, ModCallbacks.MC_NPC_UPDATE)
				
            end
		else
			player:AnimateSad()
		end
		
	end
	Mod:AddCallback(ModCallbacks.MC_USE_ITEM,ENLIGHTENMENT.enlightenmentActiveItem,Isaac.GetItemIdByName("Enlightenment"))





	function ENLIGHTENMENT:enlightenmentVirtueBeamUpdate(effect)
		local sprite = effect:GetSprite()
		if not (effect.SubType == mod.FF.ZealotBeam.Sub and effect:GetData().botbVirtueBeamIsFromEnlightenment) then return end
		--the specific beam
		if effect.FrameCount > 12 or game:GetRoom():IsClear() then
            sprite:Play("Disappear")
            sfx:Play(mod.Sounds.ZealotFade, 0.2)
            Isaac.Spawn(1000,18,1,effect.Position,Vector.Zero,effect)
        end
		if sprite:IsPlaying("Disappear") and sprite:GetFrame() == 9 then
			sfx:Stop(mod.Sounds.ZealotHum)
		end
    end

	Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, ENLIGHTENMENT.enlightenmentVirtueBeamUpdate,mod.FF.ZealotBeam.Var)




	function ENLIGHTENMENT:playerUpdate(player)
		if not player:HasCollectible(Isaac.GetItemIdByName("Enlightenment")) then return end
		local data = player:GetData()
		local level = Game():GetLevel()

			if data.botbEnlightenmentTimer == nil then
				data.botbEnlightenmentTimer = 0	
			end

			if data.botbEnlightenmentTimer ~= 0 then
					if player.FrameCount % 4 == 0 then
						data.botbEnlightenmentTimer = data.botbEnlightenmentTimer - 1
					end
				
				player:AddCacheFlags(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_LUCK )
				player:EvaluateItems()

			end
		
	end
	Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, ENLIGHTENMENT.playerUpdate, 0)


	local enlightenmentBonus={
		TEAR=0.2,
		SPEED=0.05,
		LUCK=1,

	}
	
	--Stats
	--240 is baseline amt of decay frames for stat boost
	function ENLIGHTENMENT:onEnlightenmentCache(player, cacheFlag)
		if player:HasCollectible(Isaac.GetItemIdByName("Enlightenment")) then
			local data = player:GetData()
			if data.botbEnlightenmentTimer ~= 0 then
				local Multiplier = data.botbEnlightenmentTimer / 24
				if (cacheFlag&CacheFlag.CACHE_FIREDELAY)==CacheFlag.CACHE_FIREDELAY then
				  local tps=30.0/(player.MaxFireDelay+1.0)
				  player.MaxFireDelay=30.0/(math.max(0.1,tps+Multiplier*enlightenmentBonus.TEAR))-1
				end
				if (cacheFlag&CacheFlag.CACHE_SPEED)==CacheFlag.CACHE_SPEED then
				  player.MoveSpeed=player.MoveSpeed+Multiplier*enlightenmentBonus.SPEED
				end
				if (cacheFlag&CacheFlag.CACHE_LUCK)==CacheFlag.CACHE_LUCK then
				  player.Luck=player.Luck+Multiplier*enlightenmentBonus.LUCK
				end
			elseif data.botbEnlightenmentTimer == 0 or data.botbEnlightenmentTimer == nil then
				return
			end
		end
		
	end
	Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ENLIGHTENMENT.onEnlightenmentCache)