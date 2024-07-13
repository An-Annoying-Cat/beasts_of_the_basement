local Mod = BotB
local ROSTELLUM = {}
local Entities = BotB.Enums.Entities

function ROSTELLUM:NPCUpdate(npc)


    if npc.Type == BotB.Enums.Entities.ROSTELLUM.TYPE and npc.Variant == BotB.Enums.Entities.ROSTELLUM.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local room = Game():GetRoom()
    
    
    
        --this is for the butt, not the head.
        if npc.State == 0 then
            if data.rostellumIsUnder == nil then
                data.rostellumIsUnder = false
                data.rostellumUnderTimerMax = 60
                data.rostellumUnderTimer = data.rostellumUnderTimerMax
                data.rostellumShootAngle = 0
                local rostellumHead = Isaac.Spawn(BotB.Enums.Entities.ROSTELLUM_HEAD.TYPE,BotB.Enums.Entities.ROSTELLUM_HEAD.VARIANT,0,Game():GetRoom():FindFreePickupSpawnPosition(npc.Position, 1, true, false),Vector.Zero,npc)
                rostellumHead.Parent = npc
            end
            if sprite:IsPlaying("Appear") ~= true then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                npc.State = 99
                sprite:Play("DigIn")
            end
        end
    
        if data.rostellumIsUnder then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        else
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
    
        if npc.Velocity.Length ~= 0 then
            npc.Velocity = Vector.Zero
        end
    
        --99: Go underground
        if npc.State == 99 then
            if sprite:IsFinished("DigIn") then
                data.rostellumIsUnder = true
                npc.Position = Game():GetRoom():FindFreePickupSpawnPosition(Game():GetRoom():GetRandomPosition(40), 1, true, false)
                data.rostellumUnderTimer = data.rostellumUnderTimerMax
                npc.State = 100
            end
        end
    
        --100: underground
        if npc.State == 100 then
            if data.rostellumUnderTimer ~= 0 then
                data.rostellumUnderTimer = data.rostellumUnderTimer - 1
            else
                npc.State = 101
                sprite:Play("DigOut")
                data.rostellumIsUnder = false
            end
        end
    
        --101: surface and shoot
        if npc.State == 101 then
            if sprite:IsEventTriggered("PreShoot") then
                data.rostellumShootAngle = targetangle
            end
            if sprite:IsEventTriggered("Shoot") then
                npc:PlaySound(SoundEffect.SOUND_FART,0.5,0,false,math.random(150,200)/100)
                    for i = 1, 15 do
                        local proj = Isaac.Spawn(9, 0, 0, npc.Position, (target.Position - npc.Position):Resized(math.random(8,12)):Rotated(-15+math.random(30)), npc):ToProjectile()
                        proj.Scale = math.random(8,10)/10
                        proj.FallingSpeed = -15 - math.random(20)/10
                        proj.FallingAccel = 0.9 + math.random(10)/10
                    end
            end
            if sprite:IsFinished("DigOut") then
                npc.State = 99
                sprite:Play("DigIn")
            end
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, ROSTELLUM.NPCUpdate, Isaac.GetEntityTypeByName("Rostellum"))

function ROSTELLUM:HeadUpdate(npc)


    if npc.Type == BotB.Enums.Entities.ROSTELLUM_HEAD.TYPE and npc.Variant == BotB.Enums.Entities.ROSTELLUM_HEAD.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local room = Game():GetRoom()
    
    
    
        --this is for the head.
        if npc.State == 0 then
            if data.rostellumIsUnder == nil then
                data.rostellumIsUnder = false
                data.rostellumUnderTimerMax = 60
                data.rostellumUnderTimer = data.rostellumUnderTimerMax + 60
                data.rostellumShootAngle = 0
            end
            if sprite:IsPlaying("Appear") ~= true then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                npc.State = 99
                sprite:Play("DigIn")
            end
        end
    
        if data.rostellumIsUnder then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        else
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
    
        if npc.Velocity.Length ~= 0 then
            npc.Velocity = Vector.Zero
        end
    
        --99: Go underground
        if npc.State == 99 then
            if sprite:IsFinished("DigIn") then
                data.rostellumIsUnder = true
                npc.Position = Game():GetRoom():FindFreePickupSpawnPosition(Game():GetRoom():GetRandomPosition(40), 1, true, false)
                data.rostellumUnderTimer = data.rostellumUnderTimerMax
                npc.State = 100
            end
        end
    
        --100: underground
        if npc.State == 100 then
            if data.rostellumUnderTimer ~= 0 then
                data.rostellumUnderTimer = data.rostellumUnderTimer - 1
            else
                npc.State = 101
                sprite:Play("DigOut")
                data.rostellumIsUnder = false
            end
        end
    
        --101: surface and shoot
        if npc.State == 101 then
            if sprite:IsEventTriggered("PreShoot") then
                data.rostellumShootAngle = targetangle
            end
            if sprite:IsEventTriggered("Shoot") then
                npc:PlaySound(FiendFolio.Sounds.AGShoot,0.5,0,false,math.random(85,95)/100)
                local proj = Isaac.Spawn(9, 0, 0, npc.Position, (target.Position - npc.Position):Resized(math.random(10,12)), npc):ToProjectile()
                        proj.Scale = 1.5
                        proj.FallingSpeed = -15 - math.random(20)/10
                        proj.FallingAccel = 0.9 + math.random(10)/10
                        proj:AddProjectileFlags(ProjectileFlags.ACID_RED)
            end
            if sprite:IsFinished("DigOut") then
                npc.State = 99
                sprite:Play("DigIn")
            end
        end

        if npc.Parent == nil or npc.Parent:IsDead() then
            npc:Remove()
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, ROSTELLUM.HeadUpdate, Isaac.GetEntityTypeByName("Rostellum Head"))


function ROSTELLUM:DamageNull(npc, _, _, _, _)
    --print("sharb")
    local data = npc:GetData()
    if npc.Type == BotB.Enums.Entities.ROSTELLUM.TYPE and npc.Variant == BotB.Enums.Entities.ROSTELLUM.VARIANT and data.isUnder == true then 
        --print("nope!")
        return false
    end
    if npc.Type == BotB.Enums.Entities.ROSTELLUM_HEAD.TYPE and npc.Variant == BotB.Enums.Entities.ROSTELLUM_HEAD.VARIANT then 
        return false
    end
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, ROSTELLUM.DamageNull, Isaac.GetEntityTypeByName("Rostellum"))