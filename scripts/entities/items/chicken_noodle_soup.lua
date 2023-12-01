local Mod = BotB
local mod = FiendFolio
local CHICKEN_NOODLE_SOUP = {}
local pickups = BotB.Enums.Pickups
local sfx = SFXManager()
local fiftyShadesBaseDuration = 480

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Chicken Noodle Soup"), "Grants a fading damage up upon entering an uncompleted room. Entering an uncompleted room while this damage up is still active deals fake damage to the player, grants a minor permanent tears up, and resets the damage up to its beginning strength.")
end

function CHICKEN_NOODLE_SOUP:GetPlayers()
	local players = {}

	for i = 1, game:GetNumPlayers() do
		table.insert(players, game:GetPlayer(i))
	end

	return players
end

function CHICKEN_NOODLE_SOUP:GetBestCandidates()
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
--[[
	function CHICKEN_NOODLE_SOUP:enlightenmentActiveItem(_, _, player, _, _, _)
		player:AnimateCollectible(Isaac.GetItemIdByName("Chicken Noodle Soup"))
		--sfx:Play(BotB.FF.Sounds.EnergyFairy,3,0,false,math.random(8000,12000)/10000)
		local enlightenmentBestCandidates = CHICKEN_NOODLE_SOUP:GetBestCandidates()
		print(#enlightenmentBestCandidates)
		local chosenEnlightenmentCandidate
		if #enlightenmentBestCandidates ~= 0 then
			if #enlightenmentBestCandidates == 1 then
				chosenEnlightenmentCandidate = enlightenmentBestCandidates[1]
			elseif #enlightenmentBestCandidates > 1 then
				chosenEnlightenmentCandidate = enlightenmentBestCandidates[math.random(1,#enlightenmentBestCandidates)]
			end
			--stats
			player:GetData().botbChickenSoupTimer = player:GetData().botbChickenSoupTimer + 240
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
	Mod:AddCallback(ModCallbacks.MC_USE_ITEM,CHICKEN_NOODLE_SOUP.enlightenmentActiveItem,Isaac.GetItemIdByName("Chicken Noodle Soup"))
]]

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

function CHICKEN_NOODLE_SOUP:doBlankWhiteCardReroll()
    local room = Game():GetRoom()
    local game = Game()
     local level = game:GetLevel()
     local roomDescriptor = level:GetCurrentRoomDesc()
     local roomConfigRoom = roomDescriptor.Data
    if not roomDescriptor.VisitedCount == 1 then return end
    local players = getPlayers()
    local doesSomeoneHaveChickenNoodleSoup = false


    if roomDescriptor.VisitedCount == 1 then
           
        for i=1,#players,1 do
            if players[i]:ToPlayer():HasCollectible(Isaac.GetItemIdByName("Chicken Noodle Soup")) then
                --print("dicks")
                if players[i]:ToPlayer():GetData().botbChickenSoupTimer ~= 0 then
                    --players[i]:ToPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, UseFlag.USE_NOANIM, ActiveSlot.SLOT_PRIMARY)


                    players[i]:ToPlayer():GetData().botbChickenSoupDoFakeDamage = true
                    --players[i]:ToPlayer():TakeDamage(1, DamageFlag.DAMAGE_FAKE, EntityRef(players[i]:ToPlayer()), players[i]:ToPlayer():GetDamageCooldown())
                    players[i]:ToPlayer():GetData().botbChickenSoupPermanent = players[i]:ToPlayer():GetData().botbChickenSoupPermanent + 1
                    
                end
                if players[i]:ToPlayer():GetData().botbChickenSoupTimer ~= nil then
                    players[i]:ToPlayer():GetData().botbChickenSoupTimer = 240
                end
    
            end
        end

    end
  end
  Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CHICKEN_NOODLE_SOUP.doBlankWhiteCardReroll, 0)



	function CHICKEN_NOODLE_SOUP:playerUpdate(player)
		if not player:HasCollectible(Isaac.GetItemIdByName("Chicken Noodle Soup")) then return end
		local data = player:GetData()
		local level = Game():GetLevel()

			if data.botbChickenSoupTimer == nil then
				data.botbChickenSoupTimer = 0	
                data.botbChickenSoupPermanent = 0
                data.botbChickenSoupDoFakeDamage = false
			end
            if data.botbChickenSoupDoFakeDamage ~= false or data.botbChickenSoupDoFakeDamage == true then

                for i = 1, 30 do
                    FiendFolio.scheduleForUpdate(function()
                        if i == 30 then
                            --player:UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, UseFlag.USE_NOANIM, ActiveSlot.SLOT_PRIMARY)
                            player:TakeDamage(1, DamageFlag.DAMAGE_FAKE, EntityRef(player), player:GetDamageCooldown())
                            SFXManager():Play(SoundEffect.SOUND_FIREDEATH_HISS,0.6,0,false,1.5,0)
                            
                        end
                    end, i, ModCallbacks.MC_POST_RENDER)
                end
                data.botbChickenSoupDoFakeDamage = false

                
            end
			if data.botbChickenSoupTimer ~= 0 then
                if Game():GetRoom():GetRoomShape() > RoomShape.ROOMSHAPE_IV then
                    --if the room is big, decay at half the speed
                    if player.FrameCount % 8 == 0 then
						data.botbChickenSoupTimer = data.botbChickenSoupTimer - 1
					end
                else
                    if player.FrameCount % 4 == 0 then
						data.botbChickenSoupTimer = data.botbChickenSoupTimer - 1
					end
                end
					
				
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY )
				player:EvaluateItems()

			end

            if data.botbChickenSoupPermanent ~= 0 then
            
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY )
                player:EvaluateItems()
            end
		
	end
	Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, CHICKEN_NOODLE_SOUP.playerUpdate, 0)


	local enlightenmentBonus={
		TEAR=0.05,
		DAMAGE=0.25
	}
	
	--Stats
	--240 is baseline amt of decay frames for stat boost
	function CHICKEN_NOODLE_SOUP:onSoupCache(player, cacheFlag)
		if player:HasCollectible(Isaac.GetItemIdByName("Chicken Noodle Soup")) then
			local data = player:GetData()
            --Temporary damage up
			if data.botbChickenSoupTimer ~= 0 then
				local Multiplier = data.botbChickenSoupTimer / 24
				if (cacheFlag&CacheFlag.CACHE_DAMAGE)==CacheFlag.CACHE_DAMAGE then
				  player.Damage=player.Damage+Multiplier*enlightenmentBonus.DAMAGE
				end
			elseif data.botbChickenSoupTimer == 0 or data.botbChickenSoupTimer == nil then
				return
			end
		end
		
	end
	Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CHICKEN_NOODLE_SOUP.onSoupCache)

    function CHICKEN_NOODLE_SOUP:onSoupCachePerm(player, cacheFlag)
		if player:HasCollectible(Isaac.GetItemIdByName("Chicken Noodle Soup")) then
			local data = player:GetData()
            --Permanent tears up
			if data.botbChickenSoupPermanent ~= 0 then
				local Multiplier = data.botbChickenSoupPermanent
				if (cacheFlag&CacheFlag.CACHE_FIREDELAY)==CacheFlag.CACHE_FIREDELAY then
				  local tps=30.0/(player.MaxFireDelay+1.0)
				  player.MaxFireDelay=30.0/(math.max(0.1,tps+Multiplier*enlightenmentBonus.TEAR))-1
				end
			elseif data.botbChickenSoupPermanent == 0 or data.botbChickenSoupPermanent == nil then
				return
			end
		end
		
	end
	Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CHICKEN_NOODLE_SOUP.onSoupCachePerm)