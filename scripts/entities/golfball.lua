local Mod = BotB
local GOLFBALL = {}
local Entities = BotB.Enums.Entities
local sfx = SFXManager()
function GOLFBALL:GetCoeffFromAngleChangeDuration(dur)
    if dur <= 30 then
        return 2
    elseif dur <= 45 then
        return 4
    elseif dur <= 60 then
        return 6
    else 
        return 8
    end
end
function GOLFBALL:NPCUpdate(npc)
    local sprite = npc:GetSprite()
    local data = npc:GetData()
    if npc.Type == BotB.Enums.Entities.GOLFBALL.TYPE and npc.Variant == BotB.Enums.Entities.GOLFBALL.VARIANT then 
        --States:
        --0: Idle/angle select
        --1: Idle but no putt stuff. Used by other golf elements ONLY!
        --2: Power cycle up and down
        --3: Putt!
        --4: Hole reached
        --Data init
        if data.puttAngle == nil then
            data.puttAngle = 0
            --Putt angle movement timer
            data.puttAngleDuration = 0
            --Putt angle movement coeff
            data.puttAngleChangeCoeff = 1
            --True means growing, false means shrinking
            data.puttStrengthGrowBool = true
            data.puttStrength = 0
            data.puttStrengthVectorCoeff = 6.0 
            --Max vector achieved on putt is (puttStrength/100)*puttStrengthVectorCoeff rotated to puttAngle
            --Respawn point is set at the end of every putt, 
            --but reset point is basically when you reset the hole and go back to the beginning.
            data.respawnPoint = npc.Position
            data.resetPoint = npc.Position
            --Boolean tracker for if the ball is moving--dont accept inputs if the ball is, because you have to wait for it to stop basically
            data.isMoving = true
            --For later: Tracks when the ball is considered airborne and will not collide with rocks when set to true
            sprite:Play("Idle")
        end
        --Ball movement boolean update before any state shenanigans.
        --Coloring it red when moving so I can tell visually when the boolean is whatever.
        --Damn you, floating point...
        if npc.Velocity:Length() >= 0.05 then
            data.isMoving = true
            --print(npc.Velocity)
            npc.Color = Color(1,0,0)
        else
            data.isMoving = false
            --print("FUCK")
            npc.Color = Color(1,1,1)
        end
        --Idle angle stuff
        if npc.State == 0 then
            --Only if it isn't moving
            if data.isMoving == false then
                --Draw line effect.
                -- EffectVariant.TARGET
                -- EffectVariant.KINETI_BEAM
                --Npc position, plus a rotated offset
                --print("spawn target pls")
                local puttTarget = (npc.Position + Vector(250,0):Rotated(data.puttAngle))
                --print(puttTarget)
                data.puttTargetEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.GENERIC_TRACER,0,puttTarget,Vector(0,0),npc):ToEffect()
                data.puttTargetEffect.Rotation = data.puttAngle
                data.puttTargetEffect.Timeout = 1
                --Spawn the kineti line
                --print("spawn line pls")
                data.puttLine = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.KINETI_BEAM,0,Vector(0,0),Vector(0,0),npc):ToEffect()
                data.puttLine.Parent = data.puttTargetEffect
                data.puttLine.Target = npc
                data.puttLine.Color = Color(1,1,0.5)
                data.puttLine.Timeout = 1
                --Check for inputs regarding rotation.
                --Remember to loop stuff around appropriately!
                if Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, 0) then
                    data.puttAngleDuration = data.puttAngleDuration + 1
                    data.puttAngleChangeCoeff = GOLFBALL:GetCoeffFromAngleChangeDuration(data.puttAngleDuration)
                    if data.puttAngle < 360 then
                        data.puttAngle = data.puttAngle + data.puttAngleChangeCoeff
                    else
                        data.puttAngle = 0 + data.puttAngleChangeCoeff
                    end
                elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, 0) then
                        data.puttAngleDuration = data.puttAngleDuration + 1
                        data.puttAngleChangeCoeff = GOLFBALL:GetCoeffFromAngleChangeDuration(data.puttAngleDuration)
                    if data.puttAngle > 0 then
                        data.puttAngle = data.puttAngle - data.puttAngleChangeCoeff
                    else
                        data.puttAngle = 360 - data.puttAngleChangeCoeff
                    end
                else
                    data.puttAngleDuration = 0
                    data.puttAngleChangeCoeff = 1
                end
                if Input.IsActionPressed(ButtonAction.ACTION_MENUCONFIRM, 0) then
                    sfx:Play(SoundEffect.SOUND_DOGMA_RING_LOOP,1,0,true,((50+data.puttStrength)/100),0)
                    npc.State = 2
                end

            end
        end
        --Grow shrink the strength
        if npc.State == 2 then
            npc.Velocity = Vector.Zero
            if Input.IsActionPressed(ButtonAction.ACTION_MENUCONFIRM, 0) then
                --Strength processing.
                if data.puttStrengthGrowBool == true then
                    if data.puttStrength < 100 then
                        data.puttStrength = data.puttStrength + 5
                    else
                        data.puttStrengthGrowBool = false
                    end
                else
                    if data.puttStrength > 0 then
                        data.puttStrength = data.puttStrength - 5
                    else
                        data.puttStrengthGrowBool = true
                    end
                end
                if npc.FrameCount % 2 == 0 then
                    sfx:Play(SoundEffect.SOUND_BEEP,1,0,false,((50+data.puttStrength)/100),0)
                end
                local strengthTarget = (npc.Position + Vector(1*data.puttStrength,0):Rotated(data.puttAngle))
                --print(puttTarget)
                data.strengthTargetEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.LASER_IMPACT,0,strengthTarget,Vector(0,0),npc):ToEffect()
                data.strengthTargetEffectSprite = data.strengthTargetEffect:GetSprite()
                data.strengthTargetEffectSprite.Rotation = data.puttAngle - 90
                data.strengthTargetEffectSprite:Update()
                data.strengthTargetEffect.Timeout = 1
                sfx:AdjustPitch(SoundEffect.SOUND_DOGMA_RING_LOOP, ((50+data.puttStrength)/100))
            else
                npc.Velocity = (Vector(data.puttStrengthVectorCoeff*data.puttStrength,0):Rotated(data.puttAngle))
                sfx:Stop(SoundEffect.SOUND_DOGMA_RING_LOOP)
                npc.Friction = 0.1
                sprite:Play("Moving")
                data.PuttStrength = 0
                npc.State = 3
            end  
        end
        --Putt moving state
        if npc.State == 3 then
            if npc.Velocity:Length() >= 0.05 then
                data.isMoving = true
                --print(npc.Velocity)
                npc.Color = Color(1,0,0)
                --npc.Velocity = (0.95*npc.Velocity) + (0.1 * Vector.Zero)
            else
                data.isMoving = false
                --print("FUCK")
                npc.Color = Color(1,1,1)
                sprite:Play("Idle")
                npc.State = 0
            end
        end


    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, GOLFBALL.NPCUpdate, Isaac.GetEntityTypeByName("Golf Ball"))