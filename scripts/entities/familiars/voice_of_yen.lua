local Mod = BotB
local VOICE_OF_YEN = {}
local Familiars = BotB.Enums.Familiars
local Items = BotB.Enums.Items
local Entities = BotB.Enums.Entities
--print("poopnis")
function VOICE_OF_YEN:FamiliarUpdate(npc)
    --print("poopnis")

    if npc.Type == EntityType.ENTITY_FAMILIAR and npc.Variant == Familiars.VOICE_OF_YEN.VARIANT then
        local sprite = npc:GetSprite()
        local data = npc:GetData()
        local room = Game():GetRoom()
        local player = npc.Player
        local roomEntities = Isaac.GetRoomEntities()
        --print(npc.State)
            if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            end
            if npc.FrameCount == 1 then
                npc.Velocity = Vector(math.random(8,12),0):Rotated(math.random(360))
            end
            if npc.State == 0 then
                npc.Velocity = 0.8 * npc.Velocity
                --[[
                if data.botbVoiceFollowThisDude == nil then
                    data.botbVoiceFollowThisDude = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.HUNGRY_SOUL,0,npc.Position,Vector.Zero,npc)
                    data.botbVoiceFollowThisDude.Visible = false
                end
                data.botbVoiceFollowThisDude.Position = npc.Position]]
                if sprite:IsPlaying("Appear") ~= true then
                    npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    sprite:Play("Appear")
                    
                end
                if sprite:IsFinished() then
                    sprite:Play("Idle")
                    npc.State = 99
                end
            end
            if data.botbVoiceLifeTimer == nil then
                data.botbVoiceLifeTimer = 120
                
            end
            --[[
            if npc.Target == nil then
                npc:PickEnemyTarget(1000, 13, 0)
            else
                if npc.Target:IsDead() == true then
                    npc:PickEnemyTarget(1000, 13, 0)
                end
            end]]
            --npc.Friction = 1
            --States
            -- 99 - idle
            -- 100 - die
            if npc.State == 99 then
                --npc.Position = data.botbVoiceFollowThisDude.Position
                --
                npc:PickEnemyTarget(1000, 13, 0)
                if npc.Target ~= nil then
                    local target = npc.Target
                    local targetpos = target.Position
                    local targetangle = (targetpos - npc.Position):GetAngleDegrees()
                    npc.Velocity = (0.99 * npc.Velocity) + (0.01 * (npc.Target.Position - npc.Position)):Clamped(-15,-15,15,15)
                else
                    local target = npc.Player
                    local targetpos = target.Position
                    local targetangle = (targetpos - npc.Position):GetAngleDegrees()
                    npc.Velocity = ((0.99 * npc.Velocity) + (0.01 * (target.Position - npc.Position))):Clamped(-15,-15,15,15)
                end
                if data.botbVoiceLifeTimer ~= 0 then
                    data.botbVoiceLifeTimer = data.botbVoiceLifeTimer - 1
                else
                    npc.State = 100
                    sprite:Play("Die")
                end
            end
            if npc.State == 100 then
                --data.botbVoiceFollowThisDude:Remove()
                npc.Velocity = 0.8 * npc.Velocity
                if sprite:IsFinished() then
                    --
                    for i = 1, #roomEntities do
                        local entity = roomEntities[i]
                        if (entity.Position - npc.Position):Length() <= 85 then
                            if entity:ToNPC() ~= nil and entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly ~= true then
                                entity:AddMidasFreeze(EntityRef(player), 120)
                            end
                        end
                    end
                    for i=0,17 do
                        Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.GOLD_PARTICLE,0,npc.Position,Vector(math.random(8,12),0):Rotated(math.random(360)),npc)
                    end
                    for i=0,9 do
                        Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.ULTRA_GREED_BLING,0,npc.Position,Vector(math.random(8,12),0):Rotated(math.random(360)),npc)
                    end
                    local goldCrater = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.BOMB_CRATER,0,npc.Position,Vector.Zero,npc):ToEffect()
                    SFXManager():Play(SoundEffect.SOUND_GOLD_HEART,0.8,0,false,1.25,0)
                    goldCrater.Scale = 0.5
                    goldCrater.Size = 0.5
                    goldCrater.Color = Color(1,1,1,1,1,1,0)
                    Game():BombExplosionEffects(npc.Position, 10, TearFlags.TEAR_COIN_DROP_DEATH, Color(1,1,0,1), player, 0.25, true, false, DamageFlag.DAMAGE_IGNORE_ARMOR)
                    npc:Remove()
                end
            end
    
             -- table
                for i = 1, #roomEntities do
                    local entity = roomEntities[i]
                    if (entity.Position - npc.Position):Length() <= 25 then
                        if entity:ToNPC() ~= nil and entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly ~= true then
                            entity:AddMidasFreeze(EntityRef(player), 60)
                            entity:TakeDamage(0.25,DamageFlag.DAMAGE_IGNORE_ARMOR,EntityRef(player),0)
                        end
                    end
                end
    end

    

end
Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, VOICE_OF_YEN.FamiliarUpdate, Familiars.VOICE_OF_YEN.VARIANT)



--ITEM code

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Voice of Yen"), "When an enemy is killed or you are hurt, you have a chance to spawn a special, temporary ghostly familiar that inflicts enemies with midas freezing on contact. #After a while, the familiar explodes, and enemies killed by this explosion have a chance to drop coins.")
end



function VOICE_OF_YEN:VOYHurt()
    --print("cocks")
    local player = Isaac.GetPlayer()
    local data = player:GetData()
        if player:HasCollectible(Isaac.GetItemIdByName("Voice of Yen")) then
            if math.random(0,1) == 0 then
                Isaac.Spawn(EntityType.ENTITY_FAMILIAR,Familiars.VOICE_OF_YEN.VARIANT,0,player.Position,Vector(math.random(1,4),0):Rotated(math.random(360)),player)
            end
        end
    end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, VOICE_OF_YEN.VOYHurt, EntityType.ENTITY_PLAYER)





function VOICE_OF_YEN:GetPlayers()
	local players = {}

	for i = 1, game:GetNumPlayers() do
		table.insert(players, game:GetPlayer(i))
	end

	return players
end

	function VOICE_OF_YEN:NPCDeathCheck(entity,amount)
		--print("hurmt")
		if not entity:IsEnemy() then return end
		if not entity:IsVulnerableEnemy() then return end
		if amount >= entity.HitPoints then
			--print("khill")
			local players = BotB.Functions:GetPlayers()
				local doTheyActuallyHaveThem = false
				for i=1,#players,1 do
					if players[i]:HasCollectible(BotB.Enums.Items.VOICE_OF_YEN) then
						local wigglyBoyPlayer = players[i]:ToPlayer()
						doTheyActuallyHaveThem = true
						--
						local wigglyBoyThreshold = 125+(players[i].Luck*50)
						if wigglyBoyThreshold < 125 then
							wigglyBoyThreshold = 125
							--Base 1 in 8 chance even if luck is negative
						end
						if math.random(0,1000) <= wigglyBoyThreshold then
							Isaac.Spawn(EntityType.ENTITY_FAMILIAR,Familiars.VOICE_OF_YEN.VARIANT,0, entity.Position,Vector(math.random(1,4),0):Rotated(math.random(360)), wigglyBoyPlayer)
						end

					end
				end
			if doTheyActuallyHaveThem ~= false then return end
		end		
	end

	Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, VOICE_OF_YEN.NPCDeathCheck)
