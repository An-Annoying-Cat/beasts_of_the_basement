local Mod = BotB
local DOUBLE_CHERRY = {}
local Entities = BotB.Enums.Entities
local ff = FiendFolio

function DOUBLE_CHERRY:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.DOUBLE_CHERRY.TYPE and npc.Variant == BotB.Enums.Entities.DOUBLE_CHERRY.VARIANT then 
        local doubleCherryPathfindeer = npc.Pathfinder
        if npc.State == 0 then
            if data.doubleCherrySlamCooldownMax == nil then
                data.doubleCherrySlamCooldownMax = 120
                data.doubleCherrySlamCooldown = data.doubleCherrySlamCooldownMax
                data.doubleCherryDashCooldownMax = 240
                data.doubleCherryDashCooldown = data.doubleCherryDashCooldownMax
                data.doubleCherryDashDurationMax = 120
                data.doubleCherryDashDuration = data.doubleCherryDashDurationMax
                data.doubleCherrySpinAngle = 0
                data.doubleCherryDizzyCooldownMax = 120
                data.doubleCherryDizzyCooldown = data.doubleCherryDizzyCooldownMax
            end
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") or sprite:IsEventTriggered("Back") then
                sprite:Play("Idle")
                npc.State = 99
            end
        end
        --States:
        --99: Idle
        --100: Slam
        --101: Dash start (dash is baby plum projectile attack)
        --102: Dashing
        --103: Dash end
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        end
        if data.doubleCherrySlamCooldown ~= 0 then
            data.doubleCherrySlamCooldown = data.doubleCherrySlamCooldown - 1
        end
        if data.doubleCherryDashCooldown ~= 0 then
            data.doubleCherryDashCooldown = data.doubleCherryDashCooldown - 1
        end

        --Idle
        if npc.State == 99 then
            npc.Velocity = (0.95 * npc.Velocity) + (0.05*Vector(8,0):Rotated(targetangle))
            if data.doubleCherrySlamCooldown == 0 and targetdistance <= 300 then
                --Do the slam, and also do the little weird effect
                npc:PlaySound(BotB.Enums.SFX.SEDUCER_ATTACK,1,0,false,math.random(150,170)/100)
                --npc:PlaySound(SoundEffect.SOUND_CHILD_HAPPY_ROAR_SHORT,0.5,0,false,(randoPitchForDoublingEffect - 1)/100)
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                npc.CollisionDamage = 0
                data.doubleCherrySlamCooldown = data.doubleCherrySlamCooldownMax
                sprite:Play("Slam")
                npc.State = 100
            end
            if data.doubleCherryDashCooldown == 0 then
                npc.State = 101
                sprite:Play("SpinStart")
            end
        end

        --Slam
        if npc.State == 100 then
            if sprite:GetFrame() <= 22 then
                npc.Velocity = (0.925 * npc.Velocity) + (0.075*Vector(32,0):Rotated(targetangle))
                
            else
                npc.Velocity = 0.8 * npc.Velocity
            end
            if sprite:IsEventTriggered("Slam") then
                --Collision
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                npc.CollisionDamage = 1
                --Effects
                Game():ShakeScreen(24)
                npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS,0.5,0,false,math.random(120,140)/100)
                npc:PlaySound(SoundEffect.SOUND_ANIMAL_SQUISH,1,0,false,math.random(80,90)/100)
                npc:PlaySound(BotB.Enums.SFX.SKIPFLY_BOUNCE, 2, 0, false, math.random(80,90)/100)
                --Projectiles
                local cherrySlamParams = ProjectileParams()
                local cherrySlamSmallParams = ProjectileParams()
                cherrySlamSmallParams.Scale = 0.6
                npc:FireProjectiles(npc.Position, Vector(12,0), 8, cherrySlamParams)
                npc:FireProjectiles(npc.Position, Vector(5,0), 8, cherrySlamSmallParams)
                --Creep
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, npc.Position, Vector(0,0), npc):ToEffect()
                creep.SpriteScale = creep.SpriteScale * 3
                creep.Timeout = 240
                creep:Update()
            end
            if sprite:IsEventTriggered("Back") then
                sprite:Play("Idle")
                npc.State = 99
                data.doubleCherrySlamCooldown = data.doubleCherrySlamCooldownMax
            end
        end
        --Dash start
        if npc.State == 101 then
            if sprite:IsEventTriggered("Back") then
                sprite:Play("SpinLoop")
                npc.State = 102
                data.doubleCherryDashDuration = data.doubleCherryDashDurationMax
            end
        end
        --Dashing
        if npc.State == 102 then
            npc.Velocity = (0.995 * npc.Velocity) + (0.005 * ff:diagonalMove(npc, 64, 1))
            --Time for the funny angle shit...
            local animAngle = npc.Velocity:GetAngleDegrees() % 360
            --print(animAngle)
            if not sprite:IsPlaying("SpinLoop") then
                sprite:Play("SpinLoop")
            end
            if sprite:IsEventTriggered("Shoot") then
                npc:PlaySound(SoundEffect.SOUND_BOSS2_BUBBLES,0.5,0,false,math.random(160,180)/100)
                local doubleCherryDashParams = ProjectileParams()
                doubleCherryDashParams.BulletFlags = ProjectileFlags.BOUNCE
                doubleCherryDashParams.Scale = 1
                doubleCherryDashParams.FallingAccelModifier = -0.05
                --spinny
                if npc.FrameCount % 4 == 0 then
                    for i=0,270,90 do
                        npc:FireProjectiles(npc.Position, (Vector(4,0):Rotated((npc.FrameCount % 360)+i)), 0, doubleCherryDashParams)
                    end
                end
                
            end
            if data.doubleCherryDashDuration ~= 0 then
                data.doubleCherryDashDuration = data.doubleCherryDashDuration - 1
            else
                sprite:Play("SpinEnd")
                npc.State = 103
            end
        end
        --End dash
        if npc.State == 103 then
            if not sprite:IsPlaying("SpinEnd") then
                sprite:Play("SpinEnd")
            end
            if sprite:IsEventTriggered("Back") then
                sprite:Play("Dizzy")
                npc.State = 104
                data.doubleCherryDashCooldown = data.doubleCherryDashCooldownMax
                data.doubleCherrySlamCooldown = data.doubleCherrySlamCooldownMax
                data.doubleCherryDizzyCooldown = data.doubleCherryDizzyCooldownMax
            end
        end
        --dizzy state
        if npc.State == 104 then
            npc.Velocity = (0.95 * npc.Velocity) + (0.05*Vector(8,0):Rotated(math.random(0,359)))
            if data.doubleCherryDizzyCooldown == 0 then
                npc.State = 99
                sprite:Play("Idle")
                data.doubleCherryDizzyCooldown = data.doubleCherryDizzyCooldownMax
            else
                data.doubleCherryDizzyCooldown = data.doubleCherryDizzyCooldown - 1
            end
        end

        if npc:HasMortalDamage() then
            Isaac.Spawn(BotB.Enums.Entities.CHERRY.TYPE,BotB.Enums.Entities.CHERRY.VARIANT,0,npc.Position,Vector(10,0):Rotated(180),npc)
            Isaac.Spawn(BotB.Enums.Entities.CHERRY.TYPE,BotB.Enums.Entities.CHERRY.VARIANT,0,npc.Position,Vector(10,0),npc)
            if npc.State == 104 then
                Isaac.Spawn(EntityType.ENTITY_ATTACKFLY,0,0,npc.Position,Vector.Zero,npc)
            end
            npc:PlaySound(SoundEffect.SOUND_ROCKET_BLAST_DEATH,1,0,false,math.random(150,170)/100)
            local rubble = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF02,0,npc.Position,Vector(0,0),npc)
            npc:Remove()
        end

    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, DOUBLE_CHERRY.NPCUpdate, Isaac.GetEntityTypeByName("Double Cherry"))