local Mod = BotB
local CHOIR = {}
local Entities = BotB.Enums.Entities

function CHOIR:SopranoUpdate(npc)
    if npc.Type == BotB.Enums.Entities.SOPRANO.TYPE and npc.Variant == BotB.Enums.Entities.SOPRANO.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local pathfinder = npc.Pathfinder
        if npc.State == 0 then
            if data.choirDamageReactionCooldownMax == nil then
                data.choirDamageReactionCooldownMax = 120
                data.choirDamageReactionCooldown = 0
                npc:PlaySound(SoundEffect.SOUND_SKIN_PULL, 1, 0, false, math.random(90,110)/100)
            end
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                npc.State = 99
                sprite:Play("Idle")
            end
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        --States:
        --99: idle
        --100: reacting to damage
        if npc.State == 99 then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            pathfinder:FindGridPath(targetpos, 0.125, 999, true)
        end

        if npc.State == 100 then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            pathfinder:FindGridPath(targetpos, 0.125, 999, true)
            if sprite:GetFrame() == 0 then
                --print("ding")
                for i=0,270,90 do
                    local sopranoProj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_TEAR,0,npc.Position,Vector(20,0):Rotated(i+targetangle),npc):ToProjectile()
                    sopranoProj:AddProjectileFlags(ProjectileFlags.STASIS | ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT | ProjectileFlags.CHANGE_VELOCITY_AFTER_TIMEOUT)
                    sopranoProj.ChangeTimeout = 70
                    sopranoProj.ChangeVelocity = 8
                    sopranoProj.ChangeFlags = ProjectileFlags.SMART_PERFECT | ProjectileFlags.SMART
                    sopranoProj.Color = Color(0.4, 0.15, 0.38, 1, 0.27843, 0, 0.4549)
                    sopranoProj.FallingAccel = -0.04
                    sopranoProj.Parent = npc
                end
                
                --npc:FireProjectiles(npc.Position, Vector(4,0):Rotated(targetangle), 0, sopranoProjParams)
            end
            if sprite:IsFinished("React") then
                npc.State = 99
                sprite:Play("Idle")
            end
        end

        if data.choirDamageReactionCooldown ~= 0 then
            data.choirDamageReactionCooldown = data.choirDamageReactionCooldown - 1
            --print(data.choirDamageReactionCooldown)
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, CHOIR.SopranoUpdate, Isaac.GetEntityTypeByName("Soprano"))

function CHOIR:AltoUpdate(npc)
    if npc.Type == BotB.Enums.Entities.ALTO.TYPE and npc.Variant == BotB.Enums.Entities.ALTO.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local pathfinder = npc.Pathfinder
        if npc.State == 0 then
            if data.choirDamageReactionCooldownMax == nil then
                data.choirDamageReactionCooldownMax = 180
                data.choirDamageReactionCooldown = 0
                npc:PlaySound(SoundEffect.SOUND_SKIN_PULL, 1, 0, false, math.random(90,110)/100)
            end
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                npc.State = 99
                sprite:Play("Idle")
            end
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        --States:
        --99: idle
        --100: reacting to damage
        if npc.State == 99 then
            --print(npc.Velocity:Length())
            --
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            pathfinder:FindGridPath(targetpos, 0.125, 1000, true)
        end

        if npc.State == 100 then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            pathfinder:FindGridPath(targetpos, 0.25, 100, true)
            if sprite:GetFrame() == 0 then
                --backswing
                
                npc.Velocity = Vector(-40,0):Rotated(targetangle)
                
                
            end
            if sprite:GetFrame() == 8 then
                ---https://www.youtube.com/watch?v=SjkJKpG_sgw
            end
            if sprite:IsFinished("React") then
                npc:PlaySound(SoundEffect.SOUND_WHIP, 0.5, 0, false, math.random(60,80)/100)
                npc.Velocity = Vector(30,0):Rotated(targetangle)
                npc.State = 101
                sprite:Play("Ram")
            end
        end

        if npc.State == 101 then
            npc.Velocity = 0.9625 * npc.Velocity
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            if npc.FrameCount % 2 == 0 then
                local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.ULTRA_GREED_BLING,0,npc.Position,Vector.Zero,npc):ToEffect()
                trail.Timeout = 60
                trail.Color = Color(1,1,1,0.25,1,1,1)
                local tsprite = trail:GetSprite()
                tsprite:Load(sprite:GetFilename(), true)
                tsprite:SetFrame(sprite:GetAnimation(), sprite:GetFrame())
            end
            if npc.Velocity:Length() < 2.5 then
                npc.State = 99
                sprite:Play("Idle")
            end
        end

        if data.choirDamageReactionCooldown ~= 0 then
            data.choirDamageReactionCooldown = data.choirDamageReactionCooldown - 1
            --print(data.choirDamageReactionCooldown)
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, CHOIR.AltoUpdate, Isaac.GetEntityTypeByName("Alto"))

function CHOIR:TenorUpdate(npc)
    if npc.Type == BotB.Enums.Entities.TENOR.TYPE and npc.Variant == BotB.Enums.Entities.TENOR.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local pathfinder = npc.Pathfinder
        if npc.State == 0 then
            if data.choirDamageReactionCooldownMax == nil then
                data.choirDamageReactionCooldownMax = 200
                data.choirDamageReactionCooldown = 0
                npc:PlaySound(SoundEffect.SOUND_SKIN_PULL, 1, 0, false, math.random(90,110)/100)
            end
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                npc.State = 99
                sprite:Play("Idle")
            end
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        --States:
        --99: idle
        --100: reacting to damage
        if npc.State == 99 then
            --print(npc.Velocity:Length())
            --
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            pathfinder:FindGridPath(targetpos, 0.125, 1000, true)
        end

        if npc.State == 100 then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            pathfinder:FindGridPath(targetpos, 0.25, 100, true)
            if sprite:GetFrame() == 0 then
                --backswing
                
                npc.Velocity = Vector(-40,0):Rotated(targetangle)
                
                
            end
            if sprite:GetFrame() == 8 then
                ---https://www.youtube.com/watch?v=SjkJKpG_sgw
            end
            if sprite:IsFinished("React") then
                --npc:PlaySound(SoundEffect.SOUND_WHIP, 0.5, 0, false, math.random(60,80)/100)
                --npc.Velocity = Vector(15,0):Rotated(targetangle)
                npc.State = 101
                sprite:Play("Slam")
            end
        end

        if npc.State == 101 then
            if sprite:GetFrame() < 31 then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                npc.Velocity = ((0.9975 * npc.Velocity) + (0.0025 * (target.Position - npc.Position))):Clamped(-15,-15,15,15)
                npc.Velocity = 0.95 * npc.Velocity
            else
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            end
            
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            if sprite:GetFrame() == 31 then
                npc.Velocity = Vector.Zero
                --SLAM
                npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS, 4, 0, false, 1)
                Game():ShakeScreen(16)
                --local wave = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.SHOCKWAVE,0,npc.Position,Vector.Zero,npc):ToEffect()
                --wave:SetDamageSource(BotB.Enums.Entities.TENOR.TYPE)
                --wave.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
                local tenorProjectileParams = ProjectileParams()
                tenorProjectileParams.Variant = ProjectileVariant.PROJECTILE_ROCK
                tenorProjectileParams.Color = Color(47/255,83/255,104/255,1)
                tenorProjectileParams.VelocityMulti = 6
                npc:FireProjectiles(npc.Position, Vector(1,0), 8, tenorProjectileParams)
                local crater = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.BOMB_CRATER,0,npc.Position,Vector.Zero,npc):ToEffect()
                crater.Color = Color(1,1,1,0.5)
                --npc:FireBossProjectiles(15, npc.Position, 0, tenorProjectileParams)
                Game():ButterBeanFart(npc.Position, 500, npc, false, false)
            end
            if sprite:IsFinished("Slam") then
                npc.State = 99
                sprite:Play("Idle")
            end
        end

        if data.choirDamageReactionCooldown ~= 0 then
            data.choirDamageReactionCooldown = data.choirDamageReactionCooldown - 1
            --print(data.choirDamageReactionCooldown)
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, CHOIR.TenorUpdate, Isaac.GetEntityTypeByName("Tenor"))

function CHOIR:ChoirCheck(npc, _, _, source, _)
    if not (npc.Variant >= BotB.Enums.Entities.SOPRANO.VARIANT and npc.Variant <= BotB.Enums.Entities.TENOR.VARIANT) then return end
    --print("sharb")
    local roomEntities = Isaac.GetRoomEntities() -- table
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        if entity.Type == Entities.SOPRANO.TYPE then
            if entity.Variant == Entities.SOPRANO.VARIANT or entity.Variant == Entities.ALTO.VARIANT or entity.Variant == Entities.TENOR.VARIANT then
                if entity:GetData().choirDamageReactionCooldown == 0 and not (entity:GetSprite():IsPlaying("React") or entity:GetSprite():IsPlaying("Dash") or entity:GetSprite():IsPlaying("Slam")) then
                    
                        local src = source.Entity
                        if src ~= nil and (src.Type == Entities.SOPRANO.TYPE and (src.Variant == Entities.SOPRANO.VARIANT or src.Variant == Entities.ALTO.VARIANT or src.Variant == Entities.TENOR.VARIANT)) then
                            return false
                        end
                    
                        if entity.Variant == Entities.SOPRANO.VARIANT then
                            if math.random(0,1000000) == 0 then
                                entity:ToNPC():PlaySound(BotB.Enums.SFX.CHOIR_HURT_FUNNY, 1, 0, false, 1)
                            else
                                entity:ToNPC():PlaySound(BotB.Enums.SFX.CHOIR_HURT, 2, 0, false, math.random(140,160)/100)
                            end
                            
                            --print("SPAWN THE FUCKING SHOCKWAVE")
                            Game():MakeShockwave(entity.Position, 0.035, 0.025, 10)

                            entity:ToNPC().State = 100
                            entity:GetData().choirDamageReactionCooldown = entity:GetData().choirDamageReactionCooldownMax
                            entity:ToNPC():GetSprite():Play("React")

                        end
                        if entity.Variant == Entities.ALTO.VARIANT then
                            if math.random(0,1000000) == 0 then
                                entity:ToNPC():PlaySound(BotB.Enums.SFX.CHOIR_HURT_FUNNY, 1, 0, false, 1)
                            else
                                entity:ToNPC():PlaySound(BotB.Enums.SFX.CHOIR_HURT, 3, 0, false, math.random(90,110)/100)
                            end
                            

                            Game():MakeShockwave(entity.Position, 0.035, 0.025, 10)

                            entity:ToNPC().State = 100
                            entity:GetData().choirDamageReactionCooldown = entity:GetData().choirDamageReactionCooldownMax
                            entity:ToNPC():GetSprite():Play("React")

                        end
                        if entity.Variant == Entities.TENOR.VARIANT then
                            if math.random(0,1000000) == 0 then
                                entity:ToNPC():PlaySound(BotB.Enums.SFX.CHOIR_HURT_FUNNY, 2, 0, false, 1)
                            else
                                entity:ToNPC():PlaySound(BotB.Enums.SFX.CHOIR_HURT, 4, 0, false, math.random(40,60)/100)
                            end
                            
                            Game():MakeShockwave(entity.Position, 0.035, 0.025, 10)
                            

                            entity:ToNPC().State = 100
                            entity:GetData().choirDamageReactionCooldown = entity:GetData().choirDamageReactionCooldownMax
                            entity:ToNPC():GetSprite():Play("React")

                        end
                

                    
                end
            end
        end
    end
    
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CHOIR.ChoirCheck, Isaac.GetEntityTypeByName("Soprano"))
