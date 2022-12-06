local Mod = BotB
local BATSO = {}
local Entities = BotB.Enums.Entities
local gameFunc = Game()

function BATSO:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    data = npc:GetData()
    if data.DashCooldown == nil then -- Keys of data should be strings
        data.DashCooldownMax = 240
        data.DashCooldown = 0
        data.DashTimerMax = 120
        data.DashTimer = 0
    end
    --This breaks the code if you define it beforehand, idk why but it does
    --local warningTarget
    --[[
  if npc.Type == Entities.BATSO.TYPE and npc.Variant == Entities.BATSO.VARIANT then
    
    if npc.State == 8 then npc.State = 99 sprite:PlayOverlay("Shoot") end 
    if npc.State == 99 then
        if npc.StateFrame == 17 then npc.State = 8 npc.StateFrame = 0 end
        if sprite:IsEventTriggered("shoot") then
                sfx:Play(Isaac.GetSoundIdByName("CartoonRicochet"),1,0,false,math.random(75, 85)/100)
                local spawnedFly = Isaac.Spawn(18, 0, 0, npc.Position + Vector(5,0):Rotated(targetangle), Vector(0,0), npc)
                spawnedFly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                spawnedFly.Velocity = Vector(6,0):Rotated(targetangle)
                spawnedFly.HitPoints = 1
        end
        
    end
  end
  --]]
  --Todo: Replace this with a choice based on distance. If they are too far, they should dash at you instead of shooting.
    if npc.Variant == Entities.BATSO.VARIANT then
        if npc.State == 8 then npc.State = 99 sprite:Play("Shooting") end 


        --Bonked State
        if npc.State == 96 then
            if sprite:IsEventTriggered("Back") then
                data.DashCooldown = data.DashCooldownMax
                npc.State = 8
                sprite:Play("Idle")
                npc.StateFrame = 0
                --Go back to idle, switch cooldown to full
            end
        end

        --Actual dash
        if npc.State == 97 then
            if data.DashTimer ~= 0 then
                --
                local battySpeedLimit = npc.Velocity
                npc.Velocity = (npc.Velocity + npc.Velocity*Vector(0.5,0.5)):Clamped(-15, -15, 15, 15)
                data.DashTimer = data.DashTimer - 1
                if npc:CollidesWithGrid() == true then
                    --Bonk!
                    npc:PlaySound(BotB.FF.Sounds.FunnyBonk,0.25,0,false,math.random(8,9)/10)
                    npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS,1,0,false,math.random(8,9)/10)
                    npc.State = 96
                    npc.StateFrame = 0
                    sprite:Play("Bonk")
                    gameFunc:ShakeScreen(30)
                    for i=0,10,1 do
                        local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, npc.Position, Vector(math.random(-10,10),math.random(-10,10)), npc):ToEffect()
                    end
                    for i=0,3,1 do
                        local rubble = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.ROCK_POOF,0,npc.Position,Vector((0.1*math.random(-20,20)),(0.1*math.random(-20,20))),npc)
                    end
                    --[[
                    local params = ProjectileParams()
                    params.Variant = 8

                    
                    params.FallingSpeedModifier = 15
                    params.FallingAccelModifier = 10
                    params.HeightModifier = 46
                    params.Scale = (math.random(1,10)/10)
                    --]]
                    --3*(math.random(-100,100)/100)
                    for i=0,8,1 do
                        local proj = Isaac.Spawn(9, 9, 0, npc.Position, Vector(8*(math.random(-100,100)/100),8*(math.random(-100,100)/100)), npc):ToProjectile()
                        proj.Scale = (math.random(3,12)/10)
                        proj.FallingSpeed = -15
                        proj.FallingAccel = 1
                        proj.Height = -10
                        if proj.FrameCount < 1 and proj.SpawnerType == npc.Type and proj.SpawnerVariant == npc.Variant then
                            local pSprite = proj:GetSprite()
                            pSprite:Load("gfx/009.009_rock projectile.anm2", true)
                            pSprite:Play("Rotate2", true)
                            --pSprite:ReplaceSpritesheet(0, "gfx/projectiles/rock_tears.png")
                            pSprite:LoadGraphics()
                            proj:GetData().makeSplat = 145
                            proj:GetData().customProjSound = {SoundEffect.SOUND_ROCK_CRUMBLE, 0.1, math.random(8,12)/10}
                            proj:GetData().toothParticles = BotB.FF.ColorRockGibs
                            --proj:Update()
                        end
                    end

                    npc.Velocity = Vector.Zero
                end
            else
                sprite:Play("idle")
                npc.State = 8
                npc.StateFrame = 0
            end
        end


        --Starting up a dash...
        if npc.State == 98 then
            --print("cockass")
            if sprite:IsEventTriggered("Back") then
                sprite:Play("Dash")
                npc.Velocity = npc.Velocity + Vector(math.floor(0.03 * targetdistance),0):Rotated(targetangle)
                data.DashTimer = data.DashTimerMax
                
                npc.State = 97
                npc.StateFrame = 0
            end
        end

            if npc.State == 99 then
                if sprite:IsEventTriggered("Shoot") then
                    sfx:Play(SoundEffect.SOUND_SHAKEY_KID_ROAR,1,0,false,math.random(75, 85)/100)
                    local longAssAttackVector = (Vector(math.floor(0.05 * targetdistance * (math.random(8, 10) / 10), 6),0):Rotated(targetangle))
                    local projectile = Isaac.Spawn(9, 0, 0, npc.Position, longAssAttackVector:Clamped(-7, -7, 7, 7), npc):ToProjectile();
		            projectile.FallingSpeed = -15;
		            projectile.FallingAccel = 1
		            projectile.Height = -10
                    projectile.ChangeTimeout = 60
                    projectile.Scale = 2
                    projectile:AddProjectileFlags(ProjectileFlags.BOUNCE | ProjectileFlags.BOUNCE_FLOOR | ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT)
                    projectile:AddChangeFlags(ProjectileFlags.BURST8)
                end
                if sprite:IsEventTriggered("Back") then
                    npc.State = 4 
                    npc.StateFrame = 0
                end
            end
            
            
            

            

        --If the player gets too close when the cooldown is at zero, initiate charge
        --print(targetdistance)
        
        if data.DashCooldown ~= 0 then
            data.DashCooldown = data.DashCooldown - 1
            --print(data.DashCooldown)
        else
            if targetdistance >= 150 then
                --Do the dash state here
                npc.State = 98
                sprite:Play("DashStart")
                --npc.Velocity = Vector(math.floor(0.15 * targetdistance),0):Rotated(targetangle)
                sfx:Play(Isaac.GetSoundIdByName("CartoonRicochet"),0.5,0,false,math.random(120, 150)/100)
            end
            data.DashCooldown = data.DashCooldownMax
        end
    end

end

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, BATSO.NPCUpdate, Isaac.GetEntityTypeByName("Batso"))