local Mod = BotB
local MOLDY_HORF = {}
local Entities = BotB.Enums.Entities
--print("geo horf script loaded!")
function MOLDY_HORF:NPCUpdate(npc)

    if npc.Type == BotB.Enums.Entities.MOLDY_HORF.TYPE and npc.Variant == BotB.Enums.Entities.MOLDY_HORF.VARIANT then 

        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local cursedPooterPathfinder = npc.Pathfinder

        --States:
        --99: Idle
        --100: Shoot

        if data.moldyHorfAttackCooldownMax == nil then
            data.moldyHorfAttackCooldownMax = 45
            data.moldyHorfAttackCooldown = 90
            data.moldyHorfTriggerDistance = 200
        end

        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end

        if npc.State == 0 then
            --Init
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                npc.State = 99
                sprite:Play("Shake")
            end
        end
        npc.Velocity = 0.8 * npc.Velocity
        if npc.State == 99 then
            
            --cursedPooterPathfinder:MoveRandomly(true)
            if data.moldyHorfAttackCooldown ~= 0 then
                data.moldyHorfAttackCooldown = data.moldyHorfAttackCooldown - 1
            else
                if targetdistance <= data.moldyHorfTriggerDistance then
                    npc.State = 100
                    data.moldyHorfAttackCooldown = data.moldyHorfAttackCooldownMax
                    sprite:Play("Attack")
                end
            end
        end

        if npc.State == 100 then
            if sprite:IsEventTriggered("Shoot") then
                npc:PlaySound(FiendFolio.Sounds.AGShoot,1,0,false,math.random(90,110)/100)
                for i=0,2 do
                    local bullet = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, npc.Position, Vector(math.random(40,80)/10,0):Rotated(targetangle+(math.random(-300,300)/10)), npc):ToProjectile()
                        bullet:GetData().isMoldProjectile = true
                        bullet.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                        bullet.Parent = npc
                        bullet.FallingAccel = -0.08
                        bullet.FallingSpeed = 0
                        local bsprite = bullet:GetSprite()
                        bsprite:Load("gfx/monsters/chapter_1/mold_projectile.anm2", true)
                        bsprite:Play("Move", true)
                        --bullet:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
                        bullet:Update()
                end
            end

            if sprite:IsFinished() then
                npc.State = 99
                sprite:Play("Shake")
            end
        end

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, MOLDY_HORF.NPCUpdate, Isaac.GetEntityTypeByName("Moldy Horf"))

function MOLDY_HORF:BulletCheck(bullet)
    --mold projectile spawnstuff
    if bullet:GetData().isMoldProjectile == true then
        bullet.Velocity = 0.95*bullet.Velocity
      --effect:PlaySound(Isaac.GetSoundIdByName("AcmeDeath"),1,0,false,math.random(120,150)/100)
      if bullet:IsDead() then
        sfx:Play(SoundEffect.SOUND_SUMMON_POOF,0.5,0,false,math.random(120,150)/100)
        local idiot = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, bullet.Position, Vector.Zero, bullet)
        bullet:Remove()
      end
    end
    

end

Mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, MOLDY_HORF.BulletCheck)