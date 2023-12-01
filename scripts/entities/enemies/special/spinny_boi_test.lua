local Mod = BotB
local SPINNY_BOI_TEST = {}
local Entities = BotB.Enums.Entities

--her name is beebis

function SPINNY_BOI_TEST:NPCUpdate(npc)

    

    --print("shitfuck")
    if npc.Type == BotB.Enums.Entities.SPINNY_BOI_TEST.TYPE and npc.Variant == BotB.Enums.Entities.SPINNY_BOI_TEST.VARIANT then 

        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()

        if data.botbSpinTestNumSegments == nil then
            --[[
            if npc.SubType ~= nil then
                data.botbSpinTestNumSegments = npc.SubType
            else
                data.botbSpinTestNumSegments = 3
            end]]
            data.botbSpinTestNumSegments = 4
            data.botbSpinTestList = {}
            for i=1, data.botbSpinTestNumSegments do
                local thisSegment = Isaac.Spawn(Entities.SPINNY_BOI_CHILD_TEST.TYPE,Entities.SPINNY_BOI_CHILD_TEST.VARIANT,0,npc.Position,Vector.Zero,npc):ToNPC()
                print("spawned")
                data.botbSpinTestList[#data.botbSpinTestList+1] = thisSegment
                thisSegment:GetData().botbSpinTestMasterSegment = npc
                thisSegment:GetData().botbSpinTestSegmentIndex = i
                thisSegment:GetData().botbSpinTestSegmentNum = data.botbSpinTestNumSegments
            end

            data.botbSpinnyAttackChangeTimerMax = 360
            data.botbSpinnyAttackChangeTimer = data.botbSpinnyAttackChangeTimerMax
            data.botbSpinnyLastState = 0
            data.botbSpinnySalvoBaseStateFrame = 0
        end
        if npc:HasEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK) ~= true then
            npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
        end
        if npc:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) ~= true then
            npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        end

        
        if npc.State == 0 then
            
            --local thisSegment = Isaac.Spawn(Entities.SPINNY_BOI_TEST_BODY.TYPE,Entities.SPINNY_BOI_TEST_BODY.VARIANT,0,npc.Position,Vector.Zero,npc):ToNPC()
            --sprite:ReplaceSpritesheet(0, "gfx/monsters/tests/segment_head.png")
			--sprite:LoadGraphics()
            npc.Visible = false
            sprite:Play("Idle")
            data.botbSpinTestMyIntro = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.SPINNY_BOI_INTRO.VARIANT,0,Game():GetRoom():GetCenterPos(), Vector.Zero, npc):ToEffect()
            data.botbSpinTestMyIntro.Parent = npc
            MusicManager():Fadeout(0.08)
            npc.State = 97
        end

        if npc.State == 96 then
            npc.Position = Vector(99999,99999)
            npc.Velocity = Vector.Zero

            for i=1, #data.botbSpinTestList do
                local seg = data.botbSpinTestList[i]:ToNPC()
                seg.Position = npc.Position
                npc.Velocity = Vector.Zero
            end

            if npc.FrameCount == data.botbSpinnySalvoBaseStateFrame then
                SFXManager():Play(SoundEffect.SOUND_EDEN_GLITCH,1,0,false,0.5,0)
                local warningTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.WARNING_TARGET.VARIANT,0,Game():GetRoom():GetCenterPos(),Vector(0,0),nil):ToEffect()
                warningTarget.Color = Color(1,1,1,1,1,2,2)
                            warningTarget.SpriteScale = Vector(3,3)
            end

            if npc.FrameCount == data.botbSpinnySalvoBaseStateFrame + 60 then
                SFXManager():Play(SoundEffect.SOUND_EDEN_GLITCH,1,0,false,0.5,0)
                local blackhole = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.DOGMA_BLACKHOLE,0,Game():GetRoom():GetCenterPos(),Vector(0,0),nil):ToEffect()
                --local blackhole2 = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.DOGMA_BLACKHOLE,0,Game():GetRoom():GetCenterPos(),Vector(0,0),nil):ToEffect()
            end
            
            if npc.FrameCount == data.botbSpinnySalvoBaseStateFrame + 320 then
                SFXManager():Play(SoundEffect.SOUND_1UP,0.5,0,false,0.5,0)
                local warningTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.WARNING_TARGET.VARIANT,0,Game():GetRoom():GetCenterPos(),Vector(0,0),nil):ToEffect()
                warningTarget.Color = Color(1,1,1,1,1,2,2)
                            warningTarget.SpriteScale = Vector(3,3)
            end

            if npc.FrameCount == data.botbSpinnySalvoBaseStateFrame + 360 then
                npc.Visible = true
                for i=1, #data.botbSpinTestList do
                    local seg = data.botbSpinTestList[i]:ToNPC()
                    seg.Position = npc.Position
                    seg.Visible = true
                end
                npc.Position = Game():GetRoom():GetCenterPos()
                npc.Velocity = Vector.Zero
                data.botbSpinnyAttackChangeTimer = data.botbSpinnyAttackChangeTimerMax
                if MusicManager():GetCurrentMusicID() ~= Music.MUSIC_VOID_BOSS then
                    MusicManager():Play(Music.MUSIC_VOID_BOSS,1)
                    MusicManager():UpdateVolume()
                end
                npc.State = 99
            end
        end

        if npc.State == 97 then
            npc.Position = Vector(99999,99999)
            npc.Velocity = Vector.Zero
            if (targetpos - data.botbSpinTestMyIntro.Position):Length() <= 160 then
                if data.botbSpinTestMyIntro:GetSprite():IsPlaying("Fakeout") ~= true then
                    data.botbSpinTestMyIntro:GetSprite():Play("Fakeout")
                end
            end
            if data.botbSpinTestMyIntro:GetSprite():IsFinished("Fakeout") then
                data.botbSpinTestMyIntro:Remove()
                data.botbSpinnyAttackChangeTimer = -1
                data.botbSpinnySalvoBaseStateFrame = npc.FrameCount
                data.botbSpinnyLastState = 103
                npc.State = 96
            end
        end
        --96: intro blackhole
        --97: wait for intro
        --98: wait to do shoot and spin
        --99: random other state
        --100: cycloid
        --101: shoot n spin
        --102: segments as turrets
        --103: blackhole
        --local scaleVector = Vector(math.random(50,150)/100,math.random(50,150)/100)
        npc.Scale = math.random(75,125)/100
        if npc.State > 99 then
            if data.botbSpinnyAttackChangeTimer ~= 0 then
                data.botbSpinnyAttackChangeTimer = data.botbSpinnyAttackChangeTimer - 1
            else
                data.botbSpinnyLastState = npc.State
                --INITIATE ATTACK CHANGE
                npc.State = 99
                data.botbSpinnyAttackChangeTimer = data.botbSpinnyAttackChangeTimerMax
                

            end
        end
        --

        if npc.State == 99 then
            --
            if sprite:IsPlaying("Idle") ~= true then
                sprite:Play("Idle")
            end
            local toState = math.random(100,103)
            print(toState)
            for i=0,1000 do
                if toState ~= data.botbSpinnyLastState then
                    break
                else
                    toState = math.random(100,103)
                end
            end
            if toState == 100 then
                npc.State = 100
                for i=1, #data.botbSpinTestList do
                    local seg = data.botbSpinTestList[i]:ToNPC()
                    seg.Position = npc.Position
                end
                Game():ShowHallucination(30)
            end
            if toState == 101 then
                npc.State = 98
                for i = 1, 480 do
                    BotB.FF.scheduleForUpdate(function()
                        if i == 0 or i == 240 or i == 360 or i == 420 then
                            SFXManager():Play(SoundEffect.SOUND_BERSERK_TICK,0.5,0,false,0.5,0)
                            local warningTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.WARNING_TARGET.VARIANT,0,Game():GetRoom():GetCenterPos(),Vector(0,0),nil):ToEffect()
                            warningTarget.Color = Color(1,1,1,1,1,2,2)
                            warningTarget.SpriteScale = Vector(3,3)
                        end 
                        if i == 480 then
                            npc.Position = Game():GetRoom():GetCenterPos()
                            Game():ShowHallucination(30)
                            npc.State = 101
                        end
                    end, i, ModCallbacks.MC_NPC_UPDATE)
                end
            end
            if toState == 102 then
                data.botbSpinnyAttackChangeTimer = -1
                data.botbSpinnySalvoBaseStateFrame = npc.FrameCount
                data.botbSpinnyLastState = 102
                npc.State = 102
            end
            if toState == 103 then
                data.botbSpinnyAttackChangeTimer = -1
                data.botbSpinnySalvoBaseStateFrame = npc.FrameCount
                data.botbSpinnyLastState = 103
                npc.State = 103
            end
        end
        --
        if npc.State == 100 then
            if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS 
            end
            --npc.Velocity = ((0.9975 * npc.Velocity) + (0.0025 * (target.Position - npc.Position))):Clamped(-15,-15,15,15)
            npc.Velocity = (0.95 * npc.Velocity) + (0.05 * FiendFolio:diagonalMove(npc, 8, 1))
            for i=1, #data.botbSpinTestList do
                local seg = data.botbSpinTestList[i]:ToNPC()
                local rotSpeedOffset = 0.5*((math.sin(npc.FrameCount/64)))
                local rotframe = (npc.FrameCount * (4)) % 360
                local radiusSine = 0.5 * ((math.sin(npc.FrameCount/16)))
                local offset = Vector((160 * (1+radiusSine)),0):Rotated( ( ( seg:GetData().botbSpinTestSegmentIndex / seg:GetData().botbSpinTestSegmentNum ) * 360) + rotframe)
                --local ySine = ((math.sin(npc.FrameCount/8)))
                local ySine = 1
                seg:GetData().spinnyTargetPos = npc.Position + Vector(offset.X, ySine*offset.Y)
                seg.Position = (0.5 * seg.Position) + (0.5 * seg:GetData().spinnyTargetPos)
                --seg.Velocity = ((0.9 * seg.Velocity) + (0.1 * (seg:GetData().spinnyTargetPos - seg.Position))):Clamped(-15,-15,15,15)
                if seg.FrameCount % 2 == 0 then
                    local creep = Isaac.Spawn(1000, EffectVariant.CREEP_STATIC, 0, seg.Position, Vector.Zero, npc):ToEffect()
                    creep.Scale = creep.Scale * 1
                    creep:SetTimeout(64)
                    creep:Update()
                end
            end

            if npc.FrameCount % 45 == 0 then
                local spinnyRingProjParams = ProjectileParams()
                spinnyRingProjParams.Variant = ProjectileVariant.PROJECTILE_FCUK
                spinnyRingProjParams.Scale = 2
                spinnyRingProjParams.FallingAccelModifier = -0.07
                spinnyRingProjParams.FallingSpeedModifier = 0
                spinnyRingProjParams.BulletFlags = ProjectileFlags.BOUNCE
                local spinnyRingProjParams2 = ProjectileParams()
                spinnyRingProjParams2.Variant = ProjectileVariant.PROJECTILE_FCUK
                spinnyRingProjParams2.Scale = 1
                spinnyRingProjParams2.FallingAccelModifier = -0.07
                spinnyRingProjParams2.FallingSpeedModifier = 0
                spinnyRingProjParams2.BulletFlags = ProjectileFlags.BOUNCE
                local spinnyRingProjParams3 = ProjectileParams()
                spinnyRingProjParams3.Variant = ProjectileVariant.PROJECTILE_FCUK
                spinnyRingProjParams3.Scale = 0.5
                spinnyRingProjParams3.FallingAccelModifier = -0.07
                spinnyRingProjParams3.FallingSpeedModifier = 0
                spinnyRingProjParams3.BulletFlags = ProjectileFlags.BOUNCE
                SFXManager():Play(BotB.Enums.SFX.GLITCHY_BOOM,1,0,false,math.random(75,125)/100)
                npc:FireProjectiles(npc.Position, Vector(10,0), 8, spinnyRingProjParams)
                npc:FireProjectiles(npc.Position, Vector(12,0), 8, spinnyRingProjParams2)
                npc:FireProjectiles(npc.Position, Vector(14,0), 8, spinnyRingProjParams3)

            end

        end

        if npc.State == 101 then
            if sprite:IsPlaying("Barrage") ~= true then
                sprite:Play("Barrage")
            end
            npc.Position = Game():GetRoom():GetCenterPos()
            npc.Velocity = Vector.Zero
            for i=1, #data.botbSpinTestList do
                local seg = data.botbSpinTestList[i]:ToNPC()
                local rotSpeedOffset = 8
                local rotframe = (npc.FrameCount * (rotSpeedOffset)) % 360
                local radiusSine = 0.5 * ((math.sin(npc.FrameCount/4)))
                local offset = Vector((80 * (1+radiusSine)),0):Rotated( ( ( seg:GetData().botbSpinTestSegmentIndex / seg:GetData().botbSpinTestSegmentNum ) * 360) + rotframe)
                local ySine = 1
                seg:GetData().spinnyTargetPos = npc.Position + Vector(offset.X, ySine*offset.Y)
                seg.Position = seg:GetData().spinnyTargetPos
                if seg.FrameCount % 3 == 0 then
                    local bullet = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_FCUK, 0, seg.Position, Vector(-1,0):Rotated((npc.Position - seg.Position):GetAngleDegrees()), npc):ToProjectile()
                        --bullet:GetData().doSpinnyBoiBulletAccel = true
                        bullet.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                        bullet.Parent = npc
                        bullet.FallingAccel = -0.08
                        bullet.FallingSpeed = 0
                        local bsprite = bullet:GetSprite()
                        bullet:GetData().doSpinnyBoiBulletAccel = true
                        --bsprite:Load("gfx/monsters/chapter_1/mold_projectile.anm2", true)
                        --bsprite:Play("Move", true)
                        --bullet:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
                        bullet:Update()
                end
                --seg.Velocity = ((0.9 * seg.Velocity) + (0.1 * (seg:GetData().spinnyTargetPos - seg.Position))):Clamped(-15,-15,15,15)
            end

        end

        --segments as turrets
        if npc.State == 102 then
            npc.Position = Vector(0,0)
            npc.Velocity = Vector.Zero

            if npc.FrameCount == data.botbSpinnySalvoBaseStateFrame or
            npc.FrameCount == data.botbSpinnySalvoBaseStateFrame + 30 or
            npc.FrameCount == data.botbSpinnySalvoBaseStateFrame + 60 or
            npc.FrameCount == data.botbSpinnySalvoBaseStateFrame + 90 or
            npc.FrameCount == data.botbSpinnySalvoBaseStateFrame + 120 or
            npc.FrameCount == data.botbSpinnySalvoBaseStateFrame + 150 or
            npc.FrameCount == data.botbSpinnySalvoBaseStateFrame + 180 or
            npc.FrameCount == data.botbSpinnySalvoBaseStateFrame + 210 or
            npc.FrameCount == data.botbSpinnySalvoBaseStateFrame + 240
             then
                local babyPos = SPINNY_BOI_TEST:FindValidSegTurretPos(npc)
                local babby = Isaac.Spawn(950,10,0,babyPos,Vector(0,0),nil):ToEffect()

                for i=1, #data.botbSpinTestList do
                    local segChosenPos = SPINNY_BOI_TEST:FindValidSegTurretPos(npc)
                        for j = 1, 180 do
                            
                            FiendFolio.scheduleForUpdate(function()
                                if j == 90 then
                                    --SFXManager():Play(SoundEffect.SOUND_BERSERK_TICK,0.5,0,false,2,0)
                                    local warningTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.WARNING_TARGET.VARIANT,0,segChosenPos,Vector(0,0),nil):ToEffect()
                                    warningTarget.Color = Color(1,1,1,1,1,2,2)
                                    warningTarget.SpriteScale = Vector(1,1)
                                end 
                                if j == 180 then
                                    SFXManager():Play(BotB.Enums.SFX.GLITCH_NOISE,0.5,0,false,math.random(75,125)/100)
                                    local bullet = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_FCUK, 0, segChosenPos, Vector(6,0):Rotated((targetpos - segChosenPos):GetAngleDegrees()), npc):ToProjectile()
                                    --bullet:GetData().doSpinnyBoiBulletAccel = true
                                    bullet.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                                    bullet:AddProjectileFlags(ProjectileFlags.SMART_PERFECT | ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT)
                                    bullet.ChangeTimeout = 8
                                    bullet.ChangeFlags = (ProjectileFlags.SMART)
                                    bullet.Parent = npc
                                    local bsprite = bullet:GetSprite()
                                    --bsprite:Load("gfx/monsters/chapter_1/mold_projectile.anm2", true)
                                    --bsprite:Play("Move", true)
                                    --bullet:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
                                    bullet:Update()
                                end
                            end, j + (20 * i), ModCallbacks.MC_NPC_UPDATE)
            
                        end
                end




            end
            
            if npc.FrameCount == data.botbSpinnySalvoBaseStateFrame + 320 then
                SFXManager():Play(SoundEffect.SOUND_1UP,0.5,0,false,0.5,0)
                local warningTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.WARNING_TARGET.VARIANT,0,Game():GetRoom():GetCenterPos(),Vector(0,0),nil):ToEffect()
                warningTarget.Color = Color(1,1,1,1,1,2,2)
                            warningTarget.SpriteScale = Vector(3,3)
            end

            if npc.FrameCount == data.botbSpinnySalvoBaseStateFrame + 360 then
                npc.Position = Game():GetRoom():GetCenterPos()
                npc.Velocity = Vector.Zero
                data.botbSpinnyAttackChangeTimer = data.botbSpinnyAttackChangeTimerMax
                npc.State = 99
            end

        end

        if npc.State == 103 then
            npc.Position = Vector(99999,99999)
            npc.Velocity = Vector.Zero

            for i=1, #data.botbSpinTestList do
                local seg = data.botbSpinTestList[i]:ToNPC()
                seg.Position = npc.Position
                npc.Velocity = Vector.Zero
            end

            if npc.FrameCount == data.botbSpinnySalvoBaseStateFrame then
                SFXManager():Play(SoundEffect.SOUND_EDEN_GLITCH,1,0,false,0.5,0)
                local warningTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.WARNING_TARGET.VARIANT,0,Game():GetRoom():GetCenterPos(),Vector(0,0),nil):ToEffect()
                warningTarget.Color = Color(1,1,1,1,1,2,2)
                            warningTarget.SpriteScale = Vector(3,3)
            end

            if npc.FrameCount == data.botbSpinnySalvoBaseStateFrame + 60 then
                SFXManager():Play(SoundEffect.SOUND_EDEN_GLITCH,1,0,false,0.5,0)
                local blackhole = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.DOGMA_BLACKHOLE,0,Game():GetRoom():GetCenterPos(),Vector(0,0),nil):ToEffect()
                --local blackhole2 = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.DOGMA_BLACKHOLE,0,Game():GetRoom():GetCenterPos(),Vector(0,0),nil):ToEffect()
            end
            
            if npc.FrameCount == data.botbSpinnySalvoBaseStateFrame + 320 then
                SFXManager():Play(SoundEffect.SOUND_1UP,0.5,0,false,0.5,0)
                local warningTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.WARNING_TARGET.VARIANT,0,Game():GetRoom():GetCenterPos(),Vector(0,0),nil):ToEffect()
                warningTarget.Color = Color(1,1,1,1,1,2,2)
                            warningTarget.SpriteScale = Vector(3,3)
            end

            if npc.FrameCount == data.botbSpinnySalvoBaseStateFrame + 360 then
                npc.Position = Game():GetRoom():GetCenterPos()
                npc.Velocity = Vector.Zero
                data.botbSpinnyAttackChangeTimer = data.botbSpinnyAttackChangeTimerMax
                npc.State = 99
            end

        end

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SPINNY_BOI_TEST.NPCUpdate, Isaac.GetEntityTypeByName("Spinny Boi Test"))


function SPINNY_BOI_TEST:ChildNPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.SPINNY_BOI_CHILD_TEST.TYPE and npc.Variant == BotB.Enums.Entities.SPINNY_BOI_CHILD_TEST.VARIANT then 
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_NONE then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE 
        end
        --npc.SpriteScale = Vector(0.125,0.125)
        if npc.State == 0 then
            --sprite:ReplaceSpritesheet(0, "gfx/monsters/tests/segment_tail.png")
			sprite:LoadGraphics()
            sprite:Play("Segment")
            npc.State = 99
            npc.Visible = false
        end
        if npc:HasEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK) ~= true then
            npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
        end
        if npc:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) ~= true then
            npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        end
        if npc.Parent ~= nil then
            if npc.Parent.State == 97 or npc.Parent.State == 98 or npc.Parent.State == 102 or npc.Parent.State == 103 then
                npc.Visible = false
                npc.Position = npc.Parent.Position
            end
        end
        --[[
        if npc.FrameCount % 1 == 0 then
            local creep = Isaac.Spawn(1000, EffectVariant.CREEP_STATIC, 0, npc.Position, Vector.Zero, npc):ToEffect()
            creep.Scale = creep.Scale * 0.75
            creep:SetTimeout(32)
            creep:Update()
        end]]

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SPINNY_BOI_TEST.ChildNPCUpdate, Isaac.GetEntityTypeByName("Spinny Boi Child Test"))



function SPINNY_BOI_TEST:BulletCheck(bullet)
    --mold projectile spawnstuff
    if bullet:GetData().doSpinnyBoiBulletAccel == true then
        bullet.Velocity = 1.045*bullet.Velocity
      
    end
    

end

Mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, SPINNY_BOI_TEST.BulletCheck)


function SPINNY_BOI_TEST:FindValidSegTurretPos(npc)
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
    local targetpos = target.Position    
    local returnedPos = Vector.Zero
    local targetdistance = (targetpos - returnedPos):Length()
    for i=0, 1000 do
        returnedPos =  Game():GetRoom():FindFreePickupSpawnPosition(targetpos + Vector(math.random(180,320),0):Rotated(math.random(360)), 1, true, false)
        if targetdistance >= 60 then
            break
        end
    end
    return returnedPos
end



function SPINNY_BOI_TEST:introEffect(effect)
    if effect.Parent ~= nil then        
        if effect:GetSprite():IsEventTriggered("Shake") then
            SFXManager():Play(BotB.Enums.SFX.GLITCHY_BOOM,1,0,false,math.random(50,75)/100)
            Game():ShakeScreen(16)
        end
        if effect:GetSprite():IsEventTriggered("Shake2") then
            SFXManager():Play(BotB.Enums.SFX.GLITCHY_BOOM,5,0,false,math.random(50,75)/100)
            SFXManager():Play(BotB.Enums.SFX.GLITCHY_BOOM,5,0,false,math.random(75,100)/100)
            Game():ShakeScreen(32)
        end
        if effect:GetSprite():IsEventTriggered("Eye") then
            SFXManager():Play(SoundEffect.SOUND_DOGMA_ANGEL_TRANSFORM_END,5,0,false,1)
            Game():ShakeScreen(8)
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,SPINNY_BOI_TEST.introEffect, Isaac.GetEntityVariantByName("Spinny Boi Intro"))