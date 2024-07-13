local Mod = BotB
local BLIGHTON = {}
local Entities = BotB.Enums.Entities

function BLIGHTON:NPCUpdate(npc)
    if npc.Type == BotB.Enums.Entities.BLIGHTON.TYPE and npc.Variant == BotB.Enums.Entities.BLIGHTON.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local jemPathfinder = npc.Pathfinder
        if npc.State == 0 then
            if data.botbBlightonChargeCooldownMax == nil then
                data.botbBlightonChargeCooldownMax = 160
                data.botbBlightonChargeCooldown = 80
                data.botbBlightonChargeDuration = 90

                data.botbBlightonSpecificOvie = Isaac.Spawn(Entities.OVIE.TYPE, Entities.OVIE.VARIANT, 0, npc.Position, Vector.Zero, npc):ToNPC()
                data.botbBlightonSpecificOvie.Parent = npc
                --[[
                for i=2,8,2 do
                    local jemChainEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.BLIGHTON_CHAIN.VARIANT,i,npc.Position,Vector.Zero,npc):ToEffect()
                    jemChainEffect.Parent = npc
                    jemChainEffect.Child = data.botbBlightonSpecificOvie
                end]]


            end
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                sprite:PlayOverlay("Head")
                npc.State = 99
            end
        end
        --print(sprite:GetAnimation())
        if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
        if npc.State == 99 then
            --npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            jemPathfinder:FindGridPath(targetpos, 0.6, 0, true)
            if data.botbBlightonChargeCooldown ~= 0 then
                data.botbBlightonChargeCooldown = data.botbBlightonChargeCooldown - 1
            else
                npc.State = 100
                sprite:PlayOverlay("HeadChargeIntro")
            end
        end
        if npc.State == 100 then
            --npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            
            if sprite:GetOverlayFrame() == 3 then
                npc:PlaySound(SoundEffect.SOUND_CHILD_HAPPY_ROAR_SHORT,0.5,0,false,math.random(70,80)/100)
            end
            if sprite:GetOverlayFrame() >= 3 then
                jemPathfinder:FindGridPath(targetpos, 1.2, 0, true)
            else
                jemPathfinder:FindGridPath(targetpos, 0.5, 0, true)
            end
            if sprite:IsOverlayFinished() then
                data.botbBlightonChargeCooldown = data.botbBlightonChargeCooldownMax
                data.botbBlightonChargeDuration = 120
                sprite:PlayOverlay("HeadCharge")
                npc.State = 101
            end
        end
        if npc.State == 101 then
            --npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            jemPathfinder:FindGridPath(targetpos, 1.2, 0, true)
            if data.botbBlightonChargeDuration ~= 0 then
                data.botbBlightonChargeDuration = data.botbBlightonChargeDuration - 1
            else
                npc.State = 99
                sprite:PlayOverlay("Head")
            end
        end
        --
        if npc.State ~= 0 then
            if npc.FrameCount % 4 == 0 then
                local creep = Isaac.Spawn(1000, EffectVariant.CREEP_RED, 0, npc.Position, Vector(0,0), npc):ToEffect();
			    creep.SpriteScale = Vector(1, 1)
			    creep:Update()
            end
        end
        
    end
        
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, BLIGHTON.NPCUpdate, Isaac.GetEntityTypeByName("Blighton"))



function BLIGHTON:OvieUpdate(npc)
    if npc.Type == BotB.Enums.Entities.OVIE.TYPE and npc.Variant == BotB.Enums.Entities.OVIE.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local jemPathfinder = npc.Pathfinder
        if npc.State == 0 then
            if data.botbOvieShootCooldownMax == nil then
                data.botbOvieShootCooldownMax = 80
                data.botbOvieShootCooldown = data.botbOvieShootCooldownMax
                data.botbOvieTriggerDistance = 240
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
            if data.botbOvieShootCooldown ~= 0 then
                data.botbOvieShootCooldown = data.botbOvieShootCooldown - 1
            else
                if targetdistance <= data.botbOvieTriggerDistance then
                    data.botbOvieShootCooldown = data.botbOvieShootCooldownMax
                    npc.State = 100
                    sprite:Play("Shoot")
                end
            end
            
            if npc.Parent == nil or npc.Parent:IsDead() then
                npc:Remove()
            end

        end
        --100: just shoot a projectile
        if npc.State == 100 then
            if sprite:GetFrame() == 10 then
                --shoot
                for i = 1, 30 do
                    FiendFolio.scheduleForUpdate(function()
                        if i % 10 == 0 then
                            local newtargetangle = (npc:GetPlayerTarget().Position - npc.Position):GetAngleDegrees()
                            npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,0.5,0,false,math.random(80,90)/100)
                            local miniParams = ProjectileParams()
                            miniParams.Scale = 0.5
                            miniParams.HeightModifier = 15
                            miniParams.FallingSpeedModifier = 0.1
                            npc:FireProjectiles(npc.Position, Vector(16,0):Rotated(newtargetangle), 0, miniParams)
                            --npc.Velocity = npc.Velocity + Vector (16,0):Rotated(targetangle-180)
                        end
                    end, i, ModCallbacks.MC_POST_RENDER)
                end
                
            end
            if sprite:IsFinished() or sprite:GetFrame() == 20 then
                npc.State = 99
                sprite:Play("Idle")
            end
        end

        if npc.Parent ~= nil then
            local cordedEnt = npc.Parent
            local cordedEntLength = 60
            local cordedEntDist = (cordedEnt.Position - npc.Position):Length()
            if cordedEntDist > cordedEntLength then
                local distToClose = (cordedEnt.Position - npc.Position) - (cordedEnt.Position - npc.Position):Resized(cordedEntLength)
                npc.Velocity = (npc.Velocity + distToClose*(1/16)):Clamped(-5,-5,5,5)
            end
        end
    end
        
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, BLIGHTON.OvieUpdate, Isaac.GetEntityTypeByName("Ovie"))


--[[
function BLIGHTON:chainEffect(effect)
    effect.Velocity = effect.Velocity:Rotated(effect.Velocity:GetAngleDegrees() + ((4*math.random())-2))
    if effect.Parent == nil or effect.Child == nil then
        effect:Remove()
    else
        effect.Position = effect.Parent.Position + ((effect.Child.Position - effect.Parent.Position) * (1-(effect.SubType/10)))
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,BLIGHTON.chainEffect, Isaac.GetEntityVariantByName("Blighton Chain"))]]



