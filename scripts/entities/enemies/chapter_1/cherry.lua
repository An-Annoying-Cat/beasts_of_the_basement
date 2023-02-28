local Mod = BotB
local CHERRY = {}
local Entities = BotB.Enums.Entities
local ff = FiendFolio

function CHERRY:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.CHERRY.TYPE and npc.Variant == BotB.Enums.Entities.CHERRY.VARIANT then 
        if npc.State == 0 then
            if data.cherrySlamCooldownMax == nil then
                data.cherrySlamCooldownMax = 120
                data.cherrySlamCooldown = data.cherrySlamCooldownMax
                data.cherryDashCooldownMax = 240
                data.cherryDashCooldown = data.cherryDashCooldownMax
                data.cherryDashDurationMax = 90
                data.cherryDashDuration = data.cherryDashDurationMax
                
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
        if data.cherrySlamCooldown ~= 0 then
            data.cherrySlamCooldown = data.cherrySlamCooldown - 1
        end
        if data.cherryDashCooldown ~= 0 then
            data.cherryDashCooldown = data.cherryDashCooldown - 1
        end

        --Idle
        if npc.State == 99 then
            npc.Velocity = (0.95 * npc.Velocity) + (0.05*Vector(8,0):Rotated(targetangle))
            if data.cherrySlamCooldown == 0 and targetdistance <= 300 then
                --Do the slam, and also do the little weird effect
                npc:PlaySound(BotB.Enums.SFX.SEDUCER_ATTACK,1,0,false,math.random(150,170)/100)
                --npc:PlaySound(SoundEffect.SOUND_CHILD_HAPPY_ROAR_SHORT,0.5,0,false,(randoPitchForDoublingEffect - 1)/100)
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                npc.CollisionDamage = 0
                data.cherrySlamCooldown = data.cherrySlamCooldownMax
                sprite:Play("Slam")
                npc.State = 100
            end
            if data.cherryDashCooldown == 0 then
                npc.State = 101
                sprite:Play("DashStart")
            end
        end

        --Slam
        if npc.State == 100 then
            if sprite:GetFrame() <= 12 then
                npc.Velocity = (0.95 * npc.Velocity) + (0.05*Vector(32,0):Rotated(targetangle))
                
            else
                npc.Velocity = 0.8 * npc.Velocity
            end
            if sprite:IsEventTriggered("Slam") then
                --Collision
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                npc.CollisionDamage = 1
                --Effects
                Game():ShakeScreen(12)
                npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS,0.5,0,false,math.random(160,180)/100)
                npc:PlaySound(SoundEffect.SOUND_ANIMAL_SQUISH,1,0,false,math.random(120,140)/100)
                npc:PlaySound(BotB.Enums.SFX.SKIPFLY_BOUNCE, 1, 0, false, math.random(80,120)/100)
                --Projectiles
                local cherrySlamParams = ProjectileParams()
                local cherrySlamSmallParams = ProjectileParams()
                cherrySlamSmallParams.Scale = 0.6
                npc:FireProjectiles(npc.Position, Vector(6,0), 6, cherrySlamParams)
                npc:FireProjectiles(npc.Position, Vector(2.5,0), 7, cherrySlamSmallParams)
                --Creep
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, npc.Position, Vector(0,0), npc):ToEffect()
                creep.SpriteScale = creep.SpriteScale * 2.25
                creep.Timeout = 30
                creep:Update()
            end
            if sprite:IsEventTriggered("Back") then
                sprite:Play("Idle")
                npc.State = 99
                data.cherrySlamCooldown = data.cherrySlamCooldownMax
            end
        end
        --Dash start
        if npc.State == 101 then
            if sprite:IsEventTriggered("Back") then
                sprite:Play("DashFront")
                npc.State = 102
                data.cherryDashDuration = data.cherryDashDurationMax
            end
        end
        --Dashing
        if npc.State == 102 then
            npc.Velocity = (0.995 * npc.Velocity) + (0.005 * ff:diagonalMove(npc, 64, 1))
            --Time for the funny angle shit...
            local animAngle = npc.Velocity:GetAngleDegrees() % 360
            --print(animAngle)
            if (animAngle >= 0 and animAngle < 90) then
                if not sprite:IsPlaying("DashBack") then
                    sprite:Play("DashBack")
                end
                if sprite.FlipX then
                    sprite.FlipX = false
                end
            elseif (animAngle >= 90 and animAngle < 180)  then
                if not sprite:IsPlaying("DashBack") then
                    sprite:Play("DashBack")
                end
                if not sprite.FlipX then
                    sprite.FlipX = true
                end
            elseif (animAngle >= 180 and animAngle < 270)  then
                if not sprite:IsPlaying("DashFront") then
                    sprite:Play("DashFront")
                end
                if not sprite.FlipX then
                    sprite.FlipX = true
                end
            elseif (animAngle >= 270 and animAngle < 360)  then
                if not sprite:IsPlaying("DashFront") then
                    sprite:Play("DashFront")
                end
                if sprite.FlipX then
                    sprite.FlipX = false
                end
            end
            if sprite:IsEventTriggered("Shoot") then
                npc:PlaySound(SoundEffect.SOUND_BOSS2_BUBBLES,0.5,0,false,math.random(160,180)/100)
                local cherryDashParams = ProjectileParams()
                cherryDashParams.BulletFlags = ProjectileFlags.BOUNCE
                cherryDashParams.Scale = math.random(5,50)/100
                cherryDashParams.FallingAccelModifier = math.random(100,150)/100
                npc:FireProjectiles(npc.Position, (npc.Velocity:Resized(math.random(100,400)/100)):Rotated(180 + (math.random(-90,90))), 0, cherryDashParams)
            end
            if data.cherryDashDuration ~= 0 then
                data.cherryDashDuration = data.cherryDashDuration - 1
            else
                sprite:Play("DashEnd")
                npc.State = 103
            end
        end
        --End dash
        if npc.State == 103 then
            if not sprite:IsPlaying("DashEnd") then
                sprite:Play("DashEnd")
            end
            if sprite:IsEventTriggered("Back") then
                sprite:Play("Idle")
                npc.State = 99
                data.cherryDashCooldown = data.cherryDashCooldownMax
                data.cherrySlamCooldown = data.cherrySlamCooldownMax
            end
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, CHERRY.NPCUpdate, Isaac.GetEntityTypeByName("Cherry"))