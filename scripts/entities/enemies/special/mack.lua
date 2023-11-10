local Mod = BotB
local MACK = {}
local Entities = BotB.Enums.Entities

function MACK:NPCUpdate(npc)

    


    if npc.Type == BotB.Enums.Entities.MACK.TYPE and npc.Variant == BotB.Enums.Entities.MACK.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local mackPathfinder = npc.Pathfinder

        if npc.State == 0 then
            if data.botbMackAttackCooldownMax == nil then
                data.botbMackAttackCooldownMax = 60
                data.botbMackAttackCooldown = data.botbMackAttackCooldownMax
                data.botbMackWalkSpeed = 0.25
                data.botbMackBaseAngryFrame = 0
            end
            if sprite:IsPlaying("Appear") ~= true then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                sprite:PlayOverlay("Head")
                npc.State = 99
            end
        end

        if npc.State == 99 then
            
            if data.botbMackAttackCooldown ~= 0 then
                data.botbMackAttackCooldown = data.botbMackAttackCooldown - 1
            else
                sprite:PlayOverlay("Attack")
                npc.State = 100
            end
        end

        if npc.State == 100 then
            if sprite:GetOverlayFrame() == 3  then
                npc:PlaySound(SoundEffect.SOUND_DOGMA_GODHEAD,1,0,false,4.0)
                data.MackChildProj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,npc.Position,Vector(8,0):Rotated(targetangle),npc):ToProjectile()
                data.MackChildProj:AddProjectileFlags(ProjectileFlags.TURN_HORIZONTAL)
                data.MackChildProj.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                data.MackChildProj.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
                data.MackChildProj.FallingAccel = -0.05
                data.MackChildProj.FallingSpeed = -1
                if EntityRef(npc).IsFriendly or EntityRef(npc).IsCharmed then
                    data.MackChildProj:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES)
                end
                data.botbMackWalkSpeed = 0.75
            end
            if sprite:IsOverlayFinished("Attack") then
                npc.State = 101
                data.botbMackBaseAngryFrame = npc.FrameCount
                sprite:PlayOverlay("HeadAttack")
            end
        end

        if npc.State == 101 then
            if data.MackChildProj:IsDead() or npc.FrameCount > data.botbMackBaseAngryFrame + 1200 then
                npc.State = 102
                sprite:PlayOverlay("HeadCalm")
            end
        end

        if npc.State == 102 then
            if sprite:GetOverlayFrame() == 3  then
                npc:PlaySound(BotB.Enums.SFX.GLITCH_NOISE,0.8,0,false,2.0)
                npc.Velocity = Vector.Zero
                data.botbMackWalkSpeed = 0
            end
            if sprite:IsOverlayFinished("HeadCalm") then
                npc.State = 99
                data.botbMackWalkSpeed = 0.25
                data.botbMackAttackCooldown = data.botbMackAttackCooldownMax + math.random(-30,30)
                sprite:PlayOverlay("Head")
            end
        end
        if npc.State ~= 0 then
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            if npc.State > 99 then
                mackPathfinder:FindGridPath(targetpos, data.botbMackWalkSpeed, 0, true)
            else
                mackPathfinder:FindGridPath(targetpos, data.botbMackWalkSpeed, 0, false)
            end
            
        end
        

    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, MACK.NPCUpdate, Isaac.GetEntityTypeByName("Mack"))