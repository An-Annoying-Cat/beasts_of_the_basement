local Mod = BotB
local PUER = {}
local Entities = BotB.Enums.Entities

function PUER:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local puerPathfinder = npc.Pathfinder
    local room = Game():GetRoom()
    local multiTeleProjParams = ProjectileParams()
    multiTeleProjParams.BulletFlags = ProjectileFlags.SMART
    multiTeleProjParams.Color = Color(1,0,1)
    multiTeleProjParams.HomingStrength = 1
    multiTeleProjParams.Scale = 1
    multiTeleProjParams.FallingSpeedModifier = 0.5


    if npc.Type == BotB.Enums.Entities.PUER.TYPE and npc.Variant == BotB.Enums.Entities.PUER.VARIANT then 
        if data.teleDistance== nil then
            if npc.SubType == 1 then
                data.teleDistance = 100
            else
                data.teleDistance = 500
            end
            --data.teleDistance = 75
            --Teleport cooldown
            data.teleCooldownMax = 60
            data.teleCooldown = data.teleCooldownMax
            --Using this to delay where they shoot towards
            data.fireAtPos = npc.Position
            --Using this to better find a spot near the player to dig up at
            data.telePos = nil
            data.gotValidTelePos = false
            data.idleSoundOffset = math.random(0,239)
            data.teleBaseFrameCount = 0
        end
        data.targPos = targetpos
        --:AnimWalkFrame(HorizontalAnim, VerticalAnim, SpeedThreshold)
        --States:
        --99: Walk
        --100: Teleport
        if npc.State == 0 then
            --blakcslkcsdlkvlsdlkjdf
            npc.State = 99
            sprite:PlayOverlay("Head")
        end

        if npc.State == 99 then
            if npc.FrameCount == data.teleBaseFrameCount + 19 then
                if npc.SubType == 1 then
                    sfx:Play(BotB.Enums.SFX.PUER_SHOOT,1,0,false,math.random(100,120)/100)
                  else
                    sfx:Play(BotB.Enums.SFX.PUER_SHOOT,1,0,false,math.random(60,80)/100)
                  end
                --local projectile = Isaac.Spawn(9, 0, 0, data.afterimage.Position, (targetpos - data.afterimage.Position):Resized(7.5), npc):ToProjectile();
                local projectile = npc:FireProjectiles(data.afterimage.Position, (targetpos - data.afterimage.Position):Resized(7.5), 0, multiTeleProjParams)
                --projectile.ProjectileParams = multiTeleProjParams
            end
            npc:AnimWalkFrame("WalkHori", "WalkVert", 1)
            if npc.SubType == 1 then
                --[[
                if data.afterimage ~= nil then
                    data.adata.targetPosition = targetpos
                end
                --]]
                if room:IsPositionInRoom(npc.Position+Vector(100,0):Rotated(180+targetangle), 100) then
                    puerPathfinder:FindGridPath(npc.Position+Vector(100,0):Rotated(180+targetangle), 0.7, 1, true)
                    puerPathfinder:EvadeTarget(targetpos)
                else 
                    --puerPathfinder:MoveRandomly(false)
                    puerPathfinder:FindGridPath(npc.Position+Vector(100,0):Rotated(180+targetangle), 0.7, 1, true)
                    puerPathfinder:EvadeTarget(targetpos)
                end
                if (npc.FrameCount + data.idleSoundOffset) % 240 == 0 then
                    npc:PlaySound(BotB.Enums.SFX.PUER_IDLE,0.5,0,false,math.random(120, 150)/100)
                end
            else
                puerPathfinder:FindGridPath(targetpos, 0.7, 1, true)
                if (npc.FrameCount + data.idleSoundOffset) % 240 == 0 then
                    npc:PlaySound(BotB.Enums.SFX.PUER_IDLE,0.5,0,false,math.random(85, 115)/100)
                end
            end
            if data.teleCooldown ~= 0 then
                data.teleCooldown = data.teleCooldown - 1
            else
                if npc.SubType == 1 then
                    if targetdistance >= 200 then
                        npc.State = 100
                        data.teleCooldown = data.teleCooldownMax
                    end
                else
                    if targetdistance <= 100 then
                        npc.State = 100
                        data.teleCooldown = data.teleCooldownMax
                    end
                end
            end
        end

        if npc.State == 100 then
            repeat
                if npc.SubType == 1 then
                    data.telePos = targetpos + Vector(100,0):Rotated(math.random(360))
                    data.gotValidTelePos = true
                else
                    data.telePos = room:GetRandomPosition(100)
                    data.gotValidTelePos = true
                end
                
            until data.gotValidTelePos
            --after teleport is done...
            game:ShakeScreen(8)
            data.afterimage = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.PP_AFTERIMAGE.VARIANT,0,npc.Position,Vector(0,0),npc)
            data.adata = data.afterimage:GetData()
            data.afterimage.Parent = npc
            --data.adata.targetPosition = targetpos
            sfx:Play(BotB.Enums.SFX.PUER_TELE,2,0,false,math.random(60,80)/100)
            for i=0,10,1 do
	            data.teletargetangle = (data.telePos - npc.Position):GetAngleDegrees()
	            data.teletargetdistance = (data.telePos - npc.Position):Length()
                local lmaoSquare = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.BOX_PARTICLE.VARIANT,0,npc.Position + (Vector(data.teletargetdistance,0) * (i/10)):Rotated(data.teletargetangle),Vector(7,0):Rotated(math.random(0,359)),npc):ToEffect()
                lmaoSquare.Timeout = 15
                lmaoSquare:GetSprite().Scale = Vector(0.25,0.25)+Vector(math.random(),math.random())
            end
            npc.Position = data.telePos
            data.teleBaseFrameCount = npc.FrameCount
            npc.State = 99

        end
        
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, PUER.NPCUpdate, Isaac.GetEntityTypeByName("Puer"))


function BotB:ppEffect(effect)
    local data = effect:GetData()
    if effect.Parent.SubType == 1 then
        effect:GetSprite():Play("Puella")
    else
        effect:GetSprite():Play("Puer")
    end
    --[[
    if effect:GetSprite():IsEventTriggered("Shoot") then
      if effect.Parent.SubType == 1 then
        sfx:Play(BotB.Enums.SFX.PUER_SHOOT,1,0,false,math.random(100,120)/100)
      else
        sfx:Play(BotB.Enums.SFX.PUER_SHOOT,1,0,false,math.random(60,80)/100)
      end
      print("it should be firing at " .. effect.Parent:GetData().targPos)
      --data.fireAtThisYouFuckingIdiot = effect.Parent.Target
      --print(data.fireAtThisYouFuckingIdiot.Position)
      local projectile = Isaac.Spawn(9, 0, 0, effect.Position, (effect.Parent:GetData().targPos - effect.Position):Resized(5), npc):ToProjectile();
      --projectile.FallingSpeed = -30;
      ---projectile.FallingAccel = 2
      ---projectile.Height = -10
      
      game:ShakeScreen(8)
    end
    --]]
    if effect:GetSprite():IsEventTriggered("Remove") then
        effect:Remove()
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,BotB.ppEffect, Isaac.GetEntityVariantByName("PP Afterimage"))

function BotB:boxEffect(effect)
    if effect.FrameCount == 1 then
        
    end
    effect.Velocity = effect.Velocity:Rotated(effect.Velocity:GetAngleDegrees() + ((4*math.random())-2))
    if effect:GetSprite():IsEventTriggered("Remove") then
        effect:Remove()
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,BotB.boxEffect, Isaac.GetEntityVariantByName("Box Particle"))