local Mod = BotB
local CONQUEROR = {}
local Entities = BotB.Enums.Entities
local mod = FiendFolio

function CONQUEROR:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local conquerorPathfinder = npc.Pathfinder


    if npc.Type == BotB.Enums.Entities.CONQUEROR.TYPE and npc.Variant == BotB.Enums.Entities.CONQUEROR.VARIANT then 
        --States:
        --99: Idle
        --100: Shoot
        if data.conquerorAttackCooldownMax == nil then
            data.conquerorAttackCooldownMax = 120
            data.conquerorAttackCooldown = 30
            data.botbConquerorSmallJumpCooldownMax = 60
            data.botbConquerorSmallJumpCooldown = data.botbConquerorSmallJumpCooldownMax
            data.botbConquerorBigJumpCooldownMax = 80
            data.botbConquerorBigJumpCooldown = data.botbConquerorBigJumpCooldownMax
            data.botbConquerorBigJumpBaseFrame = 0
            data.botbConquerorIsMidair = false
        end

        if data.botbConquerorIsMidair == false then
            if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            end
            if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            end
        else
            if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            end
            if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_NONE then
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            end
        end

        if npc.State == 0 then
            --Init
            
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                npc.State = 99
                sprite:Play("Idle")
            end
        end

        if npc.State == 99 then
            npc.Velocity = 0.8 * npc.Velocity
            
            if data.botbConquerorSmallJumpCooldown ~= 0 then
                data.botbConquerorSmallJumpCooldown = data.botbConquerorSmallJumpCooldown - 1
            else
                if targetdistance >= 120 and targetdistance <= 240 then
                    npc.State = 98
                    data.botbConquerorSmallJumpCooldown = data.botbConquerorSmallJumpCooldownMax
                    data.botbConquerorJumpTarget = targetpos
                    local warningTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.WARNING_TARGET.VARIANT,0,data.botbConquerorJumpTarget,Vector(0,0),nil):ToEffect()
                                    warningTarget.Color = Color(1,1,1,1,1,2,2)
                                    warningTarget.SpriteScale = Vector(1,1)
                    sprite:Play("Jump")
                end
                
            end

            if data.conquerorAttackCooldown ~= 0 then
                data.conquerorAttackCooldown = data.conquerorAttackCooldown - 1
            else
                npc.State = 100
                data.conquerorAttackCooldown = data.conquerorAttackCooldownMax
                sprite:Play("Shoot")
            end
            
        end

        if npc.State == 100 then
            if sprite:IsEventTriggered("Shoot") then
                sfx:Play(SoundEffect.SOUND_BLOODSHOOT,1,0,false,math.random(90,110)/100)
                local bullet = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_TEAR, 0, npc.Position, Vector(6,0):Rotated(targetangle), npc):ToProjectile()
                        --bullet:GetData().doSpinnyBoiBulletAccel = true
                        bullet.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                        bullet.Parent = npc
                        bullet.FallingAccel = -0.0825
                        bullet.FallingSpeed = 0
                        local bsprite = bullet:GetSprite()
                        bullet:AddProjectileFlags(ProjectileFlags.SMART | ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT)
                        bullet.ChangeTimeout = 8
                        bullet.ChangeFlags = (ProjectileFlags.SMART)
                        --bsprite:Load("gfx/monsters/chapter_1/mold_projectile.anm2", true)
                        --bsprite:Play("Move", true)
                        --bullet:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
                        bullet:Update()
            end
            if sprite:IsFinished() then
                npc.State = 99
                data.botbConquerorBigJumpCooldown = data.botbConquerorBigJumpCooldown + 60
                sprite:Play("Idle")
            end
        end

        if npc.State == 98 then
            if sprite:IsEventTriggered("Jump") then
                data.botbConquerorIsMidair = true
                npc:PlaySound(SoundEffect.SOUND_FETUS_JUMP,1,0,false,1)
            end
            if sprite:IsEventTriggered("Land") then
                data.botbConquerorIsMidair = false
                npc.Position = data.botbConquerorJumpTarget
                --npc:PlaySound(SoundEffect.SOUND_BONE_HEART,1,0,false,0.5)
            end
            if data.botbConquerorIsMidair == true then
                npc.Position = (0.75 * npc.Position) + (0.25 * data.botbConquerorJumpTarget)
            end
            if sprite:IsFinished("Jump") then
                npc.State = 99
                sprite:Play("Idle")
                data.botbConquerorSmallJumpCooldown = data.botbConquerorSmallJumpCooldownMax + math.random(-60,60)
            end
        end

        if npc.State == 101 then
            if sprite:IsEventTriggered("BigJump") then
                data.botbConquerorIsMidair = true
                npc:PlaySound(SoundEffect.SOUND_FETUS_JUMP,1,0,false,1)
            end
            if sprite:IsFinished() then
                npc.State = 102
                sprite:Play("Midair")
                data.botbConquerorBigJumpBaseFrame = npc.FrameCount
            end
        end

        if npc.State == 102 then

            if npc.FrameCount % 8 == 0 then
                local segChosenPos = CONQUEROR:FindValidSegTurretPos(npc)
                        for j = 0, 16 do
                            FiendFolio.scheduleForUpdate(function()
                                if j == 0 then
                                    --SFXManager():Play(SoundEffect.SOUND_BERSERK_TICK,0.5,0,false,2,0)
                                    local warningTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.WARNING_TARGET.VARIANT,0,segChosenPos,Vector(0,0),nil):ToEffect()
                                    warningTarget.Color = Color(1,1,1,1,1,2,2)
                                    warningTarget.SpriteScale = Vector(1,1)
                                end 
                                if j == 16 then
                                    local beam = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.CRACK_THE_SKY,0,segChosenPos,Vector(0,0),npc):ToEffect()
                                    beam:SetTimeout(240)
                                end
                            end, j, ModCallbacks.MC_NPC_UPDATE)
                        end
            end

            if npc.FrameCount == data.botbConquerorBigJumpBaseFrame + 40 then
                if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_NONE then
                    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                end
                npc.Position = targetpos
                local warningTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.WARNING_TARGET.VARIANT,0,npc.Position,Vector(0,0),nil):ToEffect()
						warningTarget.Color = Color(1,1,1,1,2,2,2)
						warningTarget.SpriteScale = Vector(3,3)
            end

            if npc.FrameCount >= data.botbConquerorBigJumpBaseFrame + 60 then
                npc.State = 103
                sprite:Play("Down")
            end
        end

        if npc.State == 103 then
            if sprite:IsEventTriggered("BigLand") then
                Game():ShakeScreen(16)
                npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS,1,0,false,1)
                data.botbConquerorIsMidair = false
                local botbEnlightenmentVirtueBeam = Isaac.Spawn(1000,mod.FF.ZealotBeam.Var,mod.FF.ZealotBeam.Sub,npc.Position,Vector.Zero,npc):ToEffect()
                        botbEnlightenmentVirtueBeam.Parent = npc
						botbEnlightenmentVirtueBeam:GetData().botbVirtueBeamIsFromHolySquirt = true
						botbEnlightenmentVirtueBeam.SpriteScale = Vector(1,1)
                        botbEnlightenmentVirtueBeam:SetTimeout(180)
						--botbEnlightenmentVirtueBeam:SetDamageSource(EntityType.ENTITY_PLAYER)
						local botbEnlightenmentVirtueSprite = botbEnlightenmentVirtueBeam:GetSprite()
						for i = 0, 2 do
							botbEnlightenmentVirtueSprite:ReplaceSpritesheet(i, "gfx/enemies/zealot/monster_zealot_cathedral.png")
						end
						
						botbEnlightenmentVirtueSprite:LoadGraphics()
                for k=45,315,90 do
                    local bullet = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_TEAR, 0, npc.Position, Vector(6,0):Rotated(k), npc):ToProjectile()
                        --bullet:GetData().doSpinnyBoiBulletAccel = true
                        bullet.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                        bullet.Parent = npc
                        bullet.FallingAccel = -0.0825
                        bullet.FallingSpeed = 0
                        local bsprite = bullet:GetSprite()
                        bullet:AddProjectileFlags(ProjectileFlags.SMART | ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT)
                        bullet.ChangeTimeout = 8
                        bullet.ChangeFlags = (ProjectileFlags.SMART)
                        --bsprite:Load("gfx/monsters/chapter_1/mold_projectile.anm2", true)
                        --bsprite:Play("Move", true)
                        --bullet:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
                        bullet:Update()
                end
            end
            if sprite:IsFinished() then
                npc.State = 98
                sprite:Play("Jump")
            end
        end





    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, CONQUEROR.NPCUpdate, Isaac.GetEntityTypeByName("Conqueror"))

function CONQUEROR:FindValidSegTurretPos(npc)
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