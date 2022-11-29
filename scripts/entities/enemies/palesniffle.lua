local Mod = BotB
local PALESNIFFLE = {}
local Entities = BotB.Enums.Entities

function PALESNIFFLE:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local target = npc:GetPlayerTarget()
    local targetpos = target.Position
    --This breaks the code if you define it beforehand, idk why but it does
    --local warningTarget
    --[[
  if npc.Type == Entities.PALESNIFFLE.TYPE and npc.Variant == Entities.PALESNIFFLE.VARIANT then
    
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

  if npc.State == NpcState.STATE_ATTACK then
    if npc.Variant == Entities.PALE_SNIFFLE.VARIANT then
            --npc.Velocity = nilvector + (npc.Velocity * 0.6)
            --sprite:SetFrame("WalkVert", 0)
        if sprite:IsOverlayFinished("Shoot") then
            npc.StateFrame = 0
            npc.State = NpcState.STATE_MOVE
        elseif npc.StateFrame == 2 then
            sfx:Play(SoundEffect.SOUND_LOW_INHALE,1,0,false,math.random(175, 185)/100)
            --Take aim...
            local aimTarget = target.Position
            warningTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT,Entities.WARNING_TARGET.VARIANT,0,aimTarget,Vector(0,0),npc)
        elseif npc.StateFrame == 15 then
            --FIRE!!
            local room = Game():GetRoom()
            npc:PlaySound(BotB.FF.Sounds.ShotgunBlast,3,0,false,math.random(8,12)/10)
            npc:PlaySound(Isaac.GetSoundIdByName("CartoonRicochet"),0.5,0,false,math.random(120, 150)/100)
            local techAngleVector = -(npc.Position - warningTarget.Position)
			local laser = EntityLaser.ShootAngle(2, npc.Position, techAngleVector:GetAngleDegrees(), 4, Vector(0,0), npc)
            laser.GridHit = true
            local _, laserEndPoint = room:CheckLine(npc.Position, npc.Position+(90*techAngleVector), 2, 0, false, true)
            --print(laserEndPoint:Normalized())
            --Position is so goddamned wonky idek what to do here
            --I GOT IT FUCKIN WORKING
            local rubble = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.DARK_BALL_SMOKE_PARTICLE,0,room:GetLaserTarget(npc.Position, techAngleVector),Vector(0,0),npc)
            local rubble = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.ROCK_POOF,0,room:GetLaserTarget(npc.Position, techAngleVector),Vector((0.1*math.random(-20,20)),(0.1*math.random(-20,20))),npc)
            for i=0,5,1 do
                local rubble = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.NAIL_PARTICLE,0,room:GetLaserTarget(npc.Position, techAngleVector),Vector((0.1*math.random(-20,20)),(0.1*math.random(-20,20))),npc)
            end
            
			laser.Color = Color(0, 0, 0, 0)
			laser.Parent = npc
			laser:GetData().offSetSpawn = Vector(0, -30)
            --None of these three work...
            Mod.SFX:Stop(SoundEffect.SOUND_REDLIGHTNING_ZAP)
            Mod.SFX:Stop(SoundEffect.SOUND_REDLIGHTNING_ZAP_WEAK)
            Mod.SFX:Stop(SoundEffect.SOUND_REDLIGHTNING_ZAP_STRONG)
			laser:Update()

        else
            BotB.FF:spriteOverlayPlay(sprite, "Shoot")
        end
    end
end
end

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, PALESNIFFLE.NPCUpdate, Entities.PALE_SNIFFLE.TYPE)