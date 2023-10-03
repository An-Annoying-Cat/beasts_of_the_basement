local Mod = BotB
local STUNKY = {}
local Entities = BotB.Enums.Entities
local ff = FiendFolio

function STUNKY:NPCUpdate(npc)

    if npc.Type == BotB.Enums.Entities.STUNKY.TYPE and npc.Variant == BotB.Enums.Entities.STUNKY.VARIANT then 

        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
    

        if npc.State == 0 then
            if data.highClottyAttackCooldownMax == nil then
                data.highClottyAttackCooldownMax = 160
                data.highClottyAttackCooldown = data.highClottyAttackCooldownMax + ((math.random(0,120)) - 60)
                data.highClottyMoveMode = math.random(0,1)
                data.randomDir = 0
                data.everyOther = false
            end
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") or sprite:IsEventTriggered("Back") then
                sprite:Play("Hop")
                npc.State = 99
            end
        end
        --States:
        --99: Idle
        --100: Shoot
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end

        --Idle
        if npc.State == 99 then
            if sprite:GetFrame() == 12 then
                if data.everyOther == true then
                    if data.highClottyMoveMode == 0 then
                        --random
                        data.randomDir = math.random(0,359)
                        npc.Velocity = Vector(2.5,0):Rotated(data.randomDir)
                    else
                        --toward target
                        npc.Velocity = Vector(2.5,0):Rotated(targetangle)
                    end
                    data.everyOther = false
                else
                    data.everyOther = true
                end
                data.highClottyMoveMode = math.random(0,1)
                
            end
            npc.Velocity = (0.9 * npc.Velocity)
            if data.highClottyAttackCooldown ~= 0 then
                data.highClottyAttackCooldown = data.highClottyAttackCooldown - 1
            else
                npc.State = 100
                sprite:Play("Attack")
            end
        end

        --Shoot
        if npc.State == 100 then
            if sprite:IsEventTriggered("Shoot") then
                --Shoot
                npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS, 1, 0, false, math.random(70,90)/100)

                local highClottyProj1Params = ProjectileParams()
                highClottyProj1Params.BulletFlags = ProjectileFlags.ACCELERATE_TO_POSITION | ProjectileFlags.NO_WALL_COLLIDE
                highClottyProj1Params.Color = FiendFolio.ColorWigglyMaggot
                highClottyProj1Params.TargetPosition = npc.Position
                highClottyProj1Params.Scale = 2
                local highClottyProj2Params = ProjectileParams()
                highClottyProj2Params.BulletFlags = ProjectileFlags.ACCELERATE_TO_POSITION | ProjectileFlags.NO_WALL_COLLIDE
                highClottyProj2Params.Color = FiendFolio.ColorWigglyMaggot
                highClottyProj2Params.TargetPosition = npc.Position
                highClottyProj2Params.Scale = 1.5
                local highClottyProj3Params = ProjectileParams()
                highClottyProj3Params.BulletFlags = ProjectileFlags.ACCELERATE_TO_POSITION | ProjectileFlags.NO_WALL_COLLIDE
                highClottyProj3Params.Color = FiendFolio.ColorWigglyMaggot
                highClottyProj3Params.TargetPosition = npc.Position
                highClottyProj3Params.Scale = 1
                --
                for i=0,7 do
                    npc:FireProjectiles(npc.Position, Vector(18,0):Rotated(45 * i), 0, highClottyProj1Params)
                    npc:FireProjectiles(npc.Position, Vector(16,0):Rotated(45 * i), 0, highClottyProj2Params)
                    npc:FireProjectiles(npc.Position, Vector(14,0):Rotated(45 * i), 0, highClottyProj3Params)
                end
                npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, 1)
                npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS, 0.7, 0, false, 1)
                --data.NoTrail = false

            end
            if sprite:IsFinished("Attack") then
                data.highClottyAttackCooldown = data.highClottyAttackCooldownMax
                sprite:Play("Hop")
                npc.State = 99
                
            end
        end
        
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, STUNKY.NPCUpdate, Isaac.GetEntityTypeByName("Stunky"))



--[[
function STUNKY:ChubberProjUpdate(npc)
    if not ((npc.Type == EntityType.ENTITY_VIS and npc.Variant == 22 and npc.SubType == 1) and npc:GetData().isHighClottyChubber == true) then return end
    --print("dude")
    local data = npc:GetData()
    local sprite = npc:GetSprite()
    if data.GoBack == nil then
        data.GoBack = false
    end
    if (npc.Parent.Position - npc.Position):Length() >= 50 and data.GoBack == false then
        print("ding!")
        data.GoBack = true
        if sprite:GetAnimation() == "Side" then
            if sprite.FlipX == true then
                sprite.FlipX = false
            elseif sprite.FlipX == false then
                sprite.FlipX = true
            end
        elseif sprite:GetAnimation() == "Down" then
            sprite:Play("Up")
        elseif sprite:GetAnimation() == "Up" then
            sprite:Play("Down")
        end
    end
    if data.GoBack == true then
        --print("tire_skid.wav")
        local parentangle = (npc.Parent.Position - npc.Position):GetAngleDegrees()
        npc.Velocity = 0.9 * npc.Velocity + ((npc.Parent.Position - npc.Position))
    else
        npc.Velocity = 0.5 * npc.Velocity
    end
    --print((npc.Parent.Position - npc.Position):Length())
    if (npc.Parent.Position - npc.Position):Length() <= 12 and data.GoBack == true then
        npc:Remove()
    end
    
end

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, STUNKY.ChubberProjUpdate, Isaac.GetEntityTypeByName("Chubber Projectile"))
]]