local Mod = BotB
local HALFTOP = {}
local Entities = BotB.Enums.Entities

function HALFTOP:NPCUpdate(npc)

    


    if npc.Type == BotB.Enums.Entities.HALFTOP.TYPE and npc.Variant == BotB.Enums.Entities.HALFTOP.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local halftopPathfinder = npc.Pathfinder
        
        if npc.State == 0 then
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if data.botbHalfTopFireAngle == nil then
                data.botbHalfTopFireAngle = 0
                data.botbHalfTopFaceRipDelay = math.random(60,240)
            end
            if sprite:IsFinished("Appear") then
                if npc.SubType == 1 then
                    sprite:PlayOverlay("Head2Down")
                    npc.State = 101
                else
                    sprite:PlayOverlay("HeadDown")
                    npc.State = 99
                end
            end
        end
        --99: idle
        --100: throw face
        --101: faceless
        if npc.State == 99 then
            sprite.PlaybackSpeed = 1
            if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            end
            if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            end
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            halftopPathfinder:FindGridPath(targetpos, 0.2, 0, false)
            local animAngle = npc.Velocity:GetAngleDegrees() % 360
            --print(animAngle)
            --sprite.FlipX = false
            
            if animAngle % 360 > 315 or animAngle % 360 <= 45 then
                --print("sector 1")
                sprite:PlayOverlay("HeadHori")     
                       
            elseif animAngle % 360 > 45 and animAngle % 360 <= 135 then
                --print("sector 2")
                sprite:PlayOverlay("HeadDown")
                
            elseif animAngle % 360 > 135 and animAngle % 360 <= 225 then
                --print("sector 3")
                sprite:PlayOverlay("HeadHori")
                
            elseif animAngle % 360 > 225 and animAngle % 360 <= 315 then
                sprite:PlayOverlay("HeadUp")
                
            end

            if data.botbHalfTopFaceRipDelay ~= 0 then
                data.botbHalfTopFaceRipDelay = data.botbHalfTopFaceRipDelay - 1
            else
                npc.State = 100
                sprite:RemoveOverlay()
                sprite:Play("ThrowFace")
            end
            if npc.HitPoints < npc.MaxHitPoints then
                npc.State = 100
                sprite:RemoveOverlay()
                sprite:Play("ThrowFace")
            end
        end

        if npc.State == 100 then
            sprite.PlaybackSpeed = 0.75
            if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ENEMIES then
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
            end
            if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            end
            --npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            npc.Velocity = Vector.Zero
            if sprite:IsEventTriggered("Sound") then
                npc:PlaySound(Isaac.GetSoundIdByName("ClothRip"),1,0,false,0.8)
                npc:PlaySound(SoundEffect.SOUND_MEATY_DEATHS,2,0,false,math.random(70,90)/100)
                Game():ShakeScreen(4)
            end
            if sprite:IsEventTriggered("Throw") then
                npc:PlaySound(SoundEffect.SOUND_FETUS_FEET,1,0,false,math.random(70,90)/100)
                local bullet = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, npc.Position, Vector(math.floor(0.05 * targetdistance),0):Rotated(targetangle), npc):ToProjectile()
                bullet:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
                bullet.FallingSpeed = -30;
                bullet.FallingAccel = 2
                bullet.Height = -32
                bullet.Parent = npc
                local bsprite = bullet:GetSprite()
                bsprite:Load("gfx/monsters/chapter_4/scarred_womb/puck_projectile.anm2", true)
                bsprite:Play("Move", true)
                --bullet:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
                bullet:Update()
            end
            if sprite:IsFinished("ThrowFace") then
                sprite:PlayOverlay("Head2Down")
                npc.State = 101
            end
            
        end
        
        if npc.State == 101 then
            sprite.PlaybackSpeed = 1
            if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            end
            if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            end
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            halftopPathfinder:FindGridPath(targetpos, 0.4, 0, false)
            local animAngle = npc.Velocity:GetAngleDegrees() % 360
            --print(animAngle)
            --sprite.FlipX = false
            local halfTopFacelessProjParams = ProjectileParams()
            halfTopFacelessProjParams.BulletFlags = ProjectileFlags.DECELERATE
            halfTopFacelessProjParams.Scale = math.random(100,1900)/1000
            if animAngle % 360 > 315 or animAngle % 360 <= 45 then
                --print("sector 1")
                sprite:PlayOverlay("Head2Hori")   
                if npc.FrameCount % 12 == 0 then
                    npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,0.8,0,false,math.random(70,90)/100)
                    data.botbHalfTopFireAngle = 0
                    npc:FireProjectiles(npc.Position, npc.Velocity+Vector(math.random(2,4),0):Rotated(data.botbHalfTopFireAngle+math.random(-15,15)), 0, halfTopFacelessProjParams)
                end                 
            elseif animAngle % 360 > 45 and animAngle % 360 <= 135 then
                --print("sector 2")
                sprite:PlayOverlay("Head2Down")
                if npc.FrameCount % 12 == 0 then
                    npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,0.8,0,false,math.random(70,90)/100)
                    data.botbHalfTopFireAngle = 90
                    npc:FireProjectiles(npc.Position, npc.Velocity+Vector(math.random(3,5),0):Rotated(data.botbHalfTopFireAngle+math.random(-15,15)), 0, halfTopFacelessProjParams)
                end  
            elseif animAngle % 360 > 135 and animAngle % 360 <= 225 then
                --print("sector 3")
                sprite:PlayOverlay("Head2Hori")
                if npc.FrameCount % 12 == 0 then
                    npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,0.8,0,false,math.random(70,90)/100)
                    data.botbHalfTopFireAngle = 180
                    npc:FireProjectiles(npc.Position, npc.Velocity+Vector(math.random(2,4),0):Rotated(data.botbHalfTopFireAngle+math.random(-15,15)), 0, halfTopFacelessProjParams)
                end  
            elseif animAngle % 360 > 225 and animAngle % 360 <= 315 then
                sprite:PlayOverlay("Head2Up")
                if npc.FrameCount % 12 == 0 then
                    npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,0.8,0,false,math.random(70,90)/100)
                    data.botbHalfTopFireAngle = 270
                    npc:FireProjectiles(npc.Position, npc.Velocity+Vector(math.random(3,5),0):Rotated(data.botbHalfTopFireAngle+math.random(-15,15)), 0, halfTopFacelessProjParams)
                end  
            end
        end
    end
        
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, HALFTOP.NPCUpdate, Isaac.GetEntityTypeByName("Halftop"))

function HALFTOP:BulletCheck(bullet)
    --Humbled projectile spawnstuff
    if bullet.Parent ~= nil and bullet.Parent.Type == BotB.Enums.Entities.HALFTOP.TYPE and bullet.Parent.Variant == BotB.Enums.Entities.HALFTOP.VARIANT then
      if bullet:IsDead() then
        local dumbass = Isaac.GetEntityVariantByName("Humbled")
        sfx:Play(SoundEffect.SOUND_CLAP,1,0,false,math.random(120,150)/100)
        sfx:Play(SoundEffect.SOUND_MEAT_IMPACTS,2,0,false,math.random(120,150)/100)
        local idiot = Isaac.Spawn(BotB.Enums.Entities.PUCK.TYPE, BotB.Enums.Entities.PUCK.VARIANT, 0, bullet.Position, bullet.Velocity, bullet.Parent)
        idiot:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        bullet:Remove()
      end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, HALFTOP.BulletCheck)




function HALFTOP:PuckUpdate(npc)
    if npc.Type == BotB.Enums.Entities.PUCK.TYPE and npc.Variant == BotB.Enums.Entities.PUCK.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        --local halftopPathfinder = npc.Pathfinder
        
        if npc.State == 0 then
            npc.State = 99
        end
        --99: idle
        --100: throw face
        --101: faceless
        if npc.State == 99 then
            --sprite.PlaybackSpeed = 1
            npc.Velocity = ((0.995 * npc.Velocity) + (0.005 * (target.Position - npc.Position))):Clamped(-6,-6,6,6)
            if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            end
            if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            end
            --npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            --halftopPathfinder:FindGridPath(targetpos, 0.5, 0, true)
            local animAngle = npc.Velocity:GetAngleDegrees() % 360
            --print(animAngle)
            --sprite.FlipX = false
            
            if animAngle % 360 > 315 or animAngle % 360 <= 45 then
                --print("sector 1")
                sprite:Play("Hori")     
                sprite.FlipX = false
            elseif animAngle % 360 > 45 and animAngle % 360 <= 135 then
                --print("sector 2")
                sprite:Play("Down")
                sprite.FlipX = false
            elseif animAngle % 360 > 135 and animAngle % 360 <= 225 then
                --print("sector 3")
                sprite:Play("Hori")
                sprite.FlipX = true
            elseif animAngle % 360 > 225 and animAngle % 360 <= 315 then
                sprite:Play("Up")
                sprite.FlipX = false    
            end

            if npc.FrameCount % 4 == 0 then
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, npc.Position, Vector(0,0), npc):ToEffect()
                creep:SetTimeout(30)
                creep:Update()
            end

        end

    end
        
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, HALFTOP.PuckUpdate, Isaac.GetEntityTypeByName("Puck"))
