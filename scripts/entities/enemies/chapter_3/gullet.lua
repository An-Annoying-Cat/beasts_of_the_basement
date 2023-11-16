local Mod = BotB
local GULLET = {}
local Entities = BotB.Enums.Entities
--print("geo horf script loaded!")
function GULLET:NPCUpdate(npc)

    if npc.Type == BotB.Enums.Entities.GULLET.TYPE and npc.Variant == BotB.Enums.Entities.GULLET.VARIANT then 


        if npc.SubType == 1 and npc:GetData().isUnchained ~= true then
            --CHAINED
            local sprite = npc:GetSprite()
            local player = npc:GetPlayerTarget()
            local data = npc:GetData()
            local target = npc:GetPlayerTarget()
            local targetpos = target.Position
            local targetangle = (targetpos - npc.Position):GetAngleDegrees()
            --(npc:GetPlayerTarget().Position - bullet.Parent:ToNPC().Position):GetAngleDegrees()
            local targetdistance = (targetpos - npc.Position):Length()
            local cursedPooterPathfinder = npc.Pathfinder
    
            --States:
            --99: Shoot
            --100: Return
            
            if npc.Parent:IsDead() then
                data.isUnchained = true
                if npc.State == 99 then
                    npc.State = 100
                elseif npc.State == 100 then
                    npc.State = 99
                end
            end
    
            if npc.State == 99 then
                if sprite:IsEventTriggered("Shoot") then
                    npc:PlaySound(FiendFolio.Sounds.AGShoot,0.6,0,false,math.random(70,90)/100)
                    local bullet = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, npc.Position, Vector(6,0):Rotated(targetangle), npc):ToProjectile()
                            bullet:GetData().isGulletProjectile = true
                            bullet:AddProjectileFlags(ProjectileFlags.DECELERATE)
                            if EntityRef(npc).IsFriendly then
                                bullet:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES)
                            end
                            bullet.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                            bullet.Parent = npc
                            --bullet.Height = 15
                            bullet.FallingSpeed = -2
                            bullet:ToProjectile().Scale = 1.5
                            
                            
                            local bsprite = bullet:GetSprite()
                            --bullet:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
                            bullet:Update()
                end
    
                if sprite:IsFinished() then
                    npc.State = 100
                    sprite:Play("Idle")
                end
            end
            npc.Velocity = ((0.99 * npc.Velocity) + (0.01 * (npc.Parent.Position - npc.Position))):Clamped(-15,-15,15,15)
        else
            --NOT CHAINED
            local sprite = npc:GetSprite()
            local player = npc:GetPlayerTarget()
            local data = npc:GetData()
            local target = npc:GetPlayerTarget()
            local targetpos = target.Position
            local targetangle = (targetpos - npc.Position):GetAngleDegrees()
            --(npc:GetPlayerTarget().Position - bullet.Parent:ToNPC().Position):GetAngleDegrees()
            local targetdistance = (targetpos - npc.Position):Length()
            local cursedPooterPathfinder = npc.Pathfinder
    
            --States:
            --99: Idle
            --100: Shoot
    
            if data.gulletAttackCooldownMax == nil then
                data.gulletAttackCooldownMax = 45
                data.gulletAttackCooldown = 90
                data.gulletTriggerDistance = 200
            end
            if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            end
    
            if npc.State == 0 then
                --Init
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                if not sprite:IsPlaying("Appear") then
                    sprite:Play("Appear")
                end
                if sprite:IsFinished("Appear") then
                    npc.State = 99
                    sprite:Play("Idle")
                end
            end
            npc.Velocity = 0.8 * npc.Velocity
            if npc.State == 99 then
                npc.Velocity = ((0.9975 * npc.Velocity) + (0.0025 * (target.Position - npc.Position))):Clamped(-15,-15,15,15)
                --cursedPooterPathfinder:MoveRandomly(true)
                if data.gulletAttackCooldown ~= 0 then
                    data.gulletAttackCooldown = data.gulletAttackCooldown - 1
                else
                    if targetdistance <= data.gulletTriggerDistance then
                        npc.State = 100
                        data.gulletAttackCooldown = data.gulletAttackCooldownMax
                        sprite:Play("Shoot")
                    end
                end
            end
    
            if npc.State == 100 then
                if sprite:IsEventTriggered("Shoot") then
                    npc:PlaySound(FiendFolio.Sounds.AGShoot,0.6,0,false,math.random(70,90)/100)
                    local bullet = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, npc.Position, Vector(6,0):Rotated(targetangle), npc):ToProjectile()
                            bullet:GetData().isGulletProjectile = true
                            bullet:AddProjectileFlags(ProjectileFlags.DECELERATE)
                            if EntityRef(npc).IsFriendly then
                                bullet:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES)
                            end
                            bullet.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                            bullet.Parent = npc
                            --bullet.Height = 15
                            bullet.FallingSpeed = -2
                            bullet:ToProjectile().Scale = 1.5
                            
                            local bsprite = bullet:GetSprite()
                            --bullet:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
                            bullet:Update()
                end
    
                if sprite:IsFinished() then
                    npc.State = 99
                    sprite:Play("Idle")
                end
            end
            
        end


        

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, GULLET.NPCUpdate, Isaac.GetEntityTypeByName("Gullet"))

function GULLET:BulletCheck(bullet)
    --mold projectile spawnstuff
    if bullet:GetData().isGulletProjectile == true then
        --print(bullet.FrameCount)
        --bullet.Velocity = 0.95*bullet.Velocity
      --effect:PlaySound(Isaac.GetSoundIdByName("AcmeDeath"),1,0,false,math.random(120,150)/100)
      if bullet.FrameCount == 15 then
        if bullet.Parent ~= nil and bullet.Parent:IsDead() ~= true and bullet.Parent:ToNPC() ~= nil then
            local angle = (bullet.Parent:ToNPC():GetPlayerTarget().Position - bullet.Position):GetAngleDegrees()

            local params = ProjectileParams()
                params.HeightModifier = 15
                params.FallingSpeedModifier = -2
                params.Spread = 14
                if EntityRef(bullet.Parent:ToNPC()).IsFriendly then
                    params.BulletFlags = ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES
                end
                bullet.Parent:ToNPC():FireProjectiles(bullet.Position, Vector(10,0):Rotated(angle-22.5),0, params)
                bullet.Parent:ToNPC():FireProjectiles(bullet.Position, Vector(10,0):Rotated(angle),0, params)
                bullet.Parent:ToNPC():FireProjectiles(bullet.Position, Vector(10,0):Rotated(angle+22.5),0, params)
                local splitpoof = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF02,0,bullet.Position,Vector.Zero,bullet):ToEffect()
                splitpoof:GetSprite().Scale = Vector(0.5,0.5)
                splitpoof:GetSprite().Offset = Vector(0,-15)
                bullet:Remove()
        end
      end
    end
    

end

Mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, GULLET.BulletCheck)