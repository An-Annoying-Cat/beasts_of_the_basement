local Mod = BotB
local JEM = {}
local Entities = BotB.Enums.Entities

function JEM:NPCUpdate(npc)
    if npc.Type == BotB.Enums.Entities.JEM.TYPE and npc.Variant == BotB.Enums.Entities.JEM.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local jemPathfinder = npc.Pathfinder
        if npc.State == 0 then
            if data.botbJemChargeCooldownMax == nil then
                data.botbJemChargeCooldownMax = 120
                data.botbJemChargeCooldown = 90
                data.botbJemChargeDuration = 120

                data.botbJemSpecificMini = Isaac.Spawn(Entities.MINI.TYPE, Entities.MINI.VARIANT, 0, npc.Position, Vector.Zero, npc):ToNPC()
                data.botbJemSpecificMini.Parent = npc

                for i=2,8,2 do
                    local jemChainEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.JEM_CHAIN.VARIANT,i,npc.Position,Vector.Zero,npc):ToEffect()
                    jemChainEffect.Parent = npc
                    jemChainEffect.Child = data.botbJemSpecificMini
                end


            end
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                
                sprite:PlayOverlay("Head")
                npc.State = 99
            end
        end
        if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
        if npc.State == 99 then
            --npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            jemPathfinder:FindGridPath(targetpos, 0.5, 0, true)
            if data.botbJemChargeCooldown ~= 0 then
                data.botbJemChargeCooldown = data.botbJemChargeCooldown - 1
            else
                npc.State = 100
                sprite:PlayOverlay("HeadChargeIntro")
            end
        end
        if npc.State == 100 then
            --npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            
            if sprite:GetOverlayFrame() == 3 then
                npc:PlaySound(SoundEffect.SOUND_CHILD_HAPPY_ROAR_SHORT,0.5,0,false,math.random(80,90)/100)
            end
            if sprite:GetOverlayFrame() >= 3 then
                jemPathfinder:FindGridPath(targetpos, 1, 0, true)
            else
                jemPathfinder:FindGridPath(targetpos, 0.5, 0, true)
            end
            if sprite:IsOverlayFinished() then
                data.botbJemChargeCooldown = data.botbJemChargeCooldownMax
                data.botbJemChargeDuration = 120
                sprite:PlayOverlay("HeadCharge")
                npc.State = 101
            end
        end
        if npc.State == 101 then
            --npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            jemPathfinder:FindGridPath(targetpos, 1, 0, true)
            if data.botbJemChargeDuration ~= 0 then
                data.botbJemChargeDuration = data.botbJemChargeDuration - 1
            else
                npc.State = 99
                sprite:PlayOverlay("Head")
            end
        end
        --[[
        if npc.State ~= 0 then
            local cordedEnt = data.botbJemSpecificMini
                local cordedEntLength = 120
                local cordedEntDist = (cordedEnt.Position - npc.Position):Length()
                if cordedEntDist > cordedEntLength then
                    local distToClose = (cordedEnt.Position - npc.Position) - (cordedEnt.Position - npc.Position):Resized(cordedEntLength)
                    npc.Velocity = npc.Velocity + distToClose*(1/8)
                end
        end
        ]]
    end
        
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, JEM.NPCUpdate, Isaac.GetEntityTypeByName("Jem"))



function JEM:MiniUpdate(npc)
    if npc.Type == BotB.Enums.Entities.MINI.TYPE and npc.Variant == BotB.Enums.Entities.MINI.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local jemPathfinder = npc.Pathfinder
        if npc.State == 0 then
            if data.botbMiniShootCooldownMax == nil then
                data.botbMiniShootCooldownMax = 80
                data.botbMiniShootCooldown = data.botbMiniShootCooldownMax
                data.botbMiniTriggerDistance = 120
            end
            sprite:Play("Idle")
            npc.State = 99
        end
        if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        end
        if npc.State == 99 then
            npc.Velocity = npc.Velocity:Clamped(-8,-8,8,8)
            if data.botbMiniShootCooldown ~= 0 then
                data.botbMiniShootCooldown = data.botbMiniShootCooldown - 1
            else
                if targetdistance <= data.botbMiniTriggerDistance then
                    data.botbMiniShootCooldown = data.botbMiniShootCooldownMax
                    npc.State = 100
                    sprite:Play("Shoot")
                end
            end
            
            if npc.Parent == nil or npc.Parent:IsDead() then
                npc.State = 101
                sprite:Play("GetAngy")
            end

        end
        --100: just shoot a projectile
        if npc.State == 100 then
            if sprite:GetFrame() == 10 then
                --shoot
                npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,0.5,0,false,math.random(80,90)/100)
                local miniParams = ProjectileParams()
                    miniParams.Scale = 0.5
                    miniParams.HeightModifier = 15
                    miniParams.FallingSpeedModifier = 0.1
                    npc:FireProjectiles(npc.Position, Vector(8,0):Rotated(targetangle), 0, miniParams)
                    --npc.Velocity = npc.Velocity + Vector (16,0):Rotated(targetangle-180)
            end
            if sprite:IsFinished() or sprite:GetFrame() == 20 then
                npc.State = 99
                sprite:Play("Idle")
            end
        end

        --101: angy transition
        if npc.State == 101 then
            npc.Velocity = ((0.9975 * npc.Velocity) + (0.0025 * (target.Position - npc.Position))):Clamped(-10,-10,10,10)
            if sprite:IsFinished() then
                npc.State = 102
                sprite:Play("Angy")
            end
        end

        --102: angy
        if npc.State == 102 then
            npc:AnimWalkFrame("Angy", "Angy", 0.1)
            npc.Velocity = ((0.9975 * npc.Velocity) + (0.0025 * (target.Position - npc.Position))):Clamped(-10,-10,10,10)
        end

        if npc.Parent ~= nil then
            local cordedEnt = npc.Parent
            local cordedEntLength = 60
            local cordedEntDist = (cordedEnt.Position - npc.Position):Length()
            if cordedEntDist > cordedEntLength then
                local distToClose = (cordedEnt.Position - npc.Position) - (cordedEnt.Position - npc.Position):Resized(cordedEntLength)
                npc.Velocity = (npc.Velocity + distToClose*(1/32)):Clamped(-8,-8,8,8)
            end
        end
    end
        
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, JEM.MiniUpdate, Isaac.GetEntityTypeByName("Mini"))



function JEM:chainEffect(effect)
    effect.Velocity = effect.Velocity:Rotated(effect.Velocity:GetAngleDegrees() + ((4*math.random())-2))
    if effect.Parent == nil or effect.Child == nil then
        effect:Remove()
    else
        effect.Position = effect.Parent.Position + ((effect.Child.Position - effect.Parent.Position) * (1-(effect.SubType/10)))
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,JEM.chainEffect, Isaac.GetEntityVariantByName("Jem Chain"))



