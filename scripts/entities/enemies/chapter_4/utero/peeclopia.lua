local Mod = BotB
local PEECLOPIA = {}
local Entities = BotB.Enums.Entities

function PEECLOPIA:NPCUpdate(npc)
    if npc.Type == BotB.Enums.Entities.PEECLOPIA.TYPE and npc.Variant == BotB.Enums.Entities.PEECLOPIA.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local somebodyPathfinder = npc.Pathfinder
        if npc.State == 0 then
            if data.botbPeeclopiaCordDummy == nil then
                data.botbPeeclopiaCordDummy = Isaac.Spawn(EntityType.ENTITY_EFFECT,Entities.PEECLOPIA_CORD_DUMMY.VARIANT,0,npc.Position,Vector.Zero,npc):ToEffect()
                data.botbPeeclopiaCordDummy.Parent = npc
                data.botbPeeclopiaEye = Isaac.Spawn(EntityType.ENTITY_PEEPER_FATTY,10,0,npc.Position,Vector.Zero,npc):ToNPC()
                --variant 10 is the peeper fatty eye
                data.botbPeeclopiaEye.Parent = npc
                data.botbPeeclopiaEyeCordDummy = Isaac.Spawn(EntityType.ENTITY_EFFECT,Entities.PEECLOPIA_CORD_DUMMY.VARIANT,0,npc.Position,Vector.Zero,npc):ToEffect()
                data.botbPeeclopiaEyeCordDummy.Parent = data.botbPeeclopiaEye
                data.botbPeeclopiaEye.DepthOffset = 99999

                data.botbPeeclopiaCord = Isaac.Spawn(EntityType.ENTITY_EVIS, 10, 0, npc.Position, Vector.Zero, npc):ToNPC()
                data.botbPeeclopiaCord:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/chapter_4/utero/peeclopia_cord.png")
                data.botbPeeclopiaCord:GetSprite():ReplaceSpritesheet(1, "gfx/monsters/chapter_4/utero/peeclopia_cord.png")
                data.botbPeeclopiaCord:GetSprite():LoadGraphics()
                data.botbPeeclopiaCord:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                data.botbPeeclopiaCord.Parent = data.botbPeeclopiaCordDummy
                data.botbPeeclopiaCord.Target = data.botbPeeclopiaEyeCordDummy

                data.botbPeeclopiaFireCooldown = 30
                data.botbPeeclopiaFireDist = 160
                data.botbPeeclopiaFireCheck = (targetpos - data.botbPeeclopiaEye.Position):Length()

            end
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                
                sprite:PlayOverlay("Head")
                npc.State = 99
                
            end
        end
        data.botbPeeclopiaFireCheck = (targetpos - data.botbPeeclopiaEye.Position):Length()
        if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
        if npc.State == 99 then
            --npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            somebodyPathfinder:FindGridPath(targetpos, 0.2, 0, false)
            if data.botbPeeclopiaFireCooldown ~= 0 then
                data.botbPeeclopiaFireCooldown = data.botbPeeclopiaFireCooldown - 1
            else
                if data.botbPeeclopiaFireCheck <= data.botbPeeclopiaFireDist then
                    npc.State = 100
                    sprite:PlayOverlay("Attack")
                    data.botbPeeclopiaFireCooldown = 60
                end
            end
        end
        data.botbPeeclopiaEye.TargetPosition = targetpos
        if npc.State == 100 then
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            somebodyPathfinder:FindGridPath(targetpos, 0.2, 0, false)
            if sprite:GetOverlayFrame() == 3 then
                npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,0,false,math.random(60,80)/100)
                --local bullet = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, data.botbPeeclopiaEye.Position, Vector(6,0):Rotated(data.botbPeeclopiaEye.Velocity:GetAngleDegrees()), data.botbPeeclopiaEye):ToProjectile()
                local bullet = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, data.botbPeeclopiaEye.Position, Vector(6,0):Rotated((data.botbPeeclopiaEye.TargetPosition - data.botbPeeclopiaEye.Position):GetAngleDegrees()), data.botbPeeclopiaEye):ToProjectile()
                        bullet:AddProjectileFlags(ProjectileFlags.BOUNCE)
                        bullet.Parent = npc
                        bullet.FallingAccel = -0.08
                        bullet.FallingSpeed = 0
                        if EntityRef(npc).IsFriendly then
                            bullet:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES)
                        end

                        --bullet:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
                        bullet:Update()
            end
            if sprite:IsOverlayFinished() then
                sprite:PlayOverlay("Head")
                npc.State = 99
            end
        end
    end
        
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, PEECLOPIA.NPCUpdate, Isaac.GetEntityTypeByName("Peeclopia"))


--
function PEECLOPIA:cordDummyEffect(effect)
    if effect.Parent ~= nil then
        if effect.Parent.Type == Entities.PEECLOPIA.TYPE then
            effect.Position = effect.Parent.Position + Vector(2,-18)
        else
            effect.Position = effect.Parent.Position + Vector(0,-4)
        end
        
        if effect.Parent:ToNPC():IsDead() then
            effect:Remove()
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,PEECLOPIA.cordDummyEffect, Isaac.GetEntityVariantByName("Peeclopia Cord Dummy"))