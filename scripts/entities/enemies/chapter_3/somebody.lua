local Mod = BotB
local SOMEBODY = {}
local Entities = BotB.Enums.Entities

function SOMEBODY:NPCUpdate(npc)
    if npc.Type == BotB.Enums.Entities.SOMEBODY.TYPE and npc.Variant == BotB.Enums.Entities.SOMEBODY.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local somebodyPathfinder = npc.Pathfinder
        if npc.State == 0 then
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                if data.somethingSpawnCooldownMax == nil then
                    data.somethingSpawnCooldownMax = 120
                    data.somethingSpawnCooldown = 60
                    data.somethingSpawnLocations = {}
                end
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
            somebodyPathfinder:FindGridPath(targetpos, 0.2, 0, false)
            if data.somethingSpawnCooldown ~= 0 then
                data.somethingSpawnCooldown = data.somethingSpawnCooldown - 1
            else
                if not (Isaac.CountEntities(npc, BotB.Enums.Entities.SPEECH_BUBBLE.TYPE, BotB.Enums.Entities.SPEECH_BUBBLE.VARIANT) > 0) then
                    npc.State = 100
                    for i=1,4 do
                        data.somethingSpawnLocations[i] = Game():GetRoom():FindFreePickupSpawnPosition(Game():GetRoom():GetRandomPosition(10), 1, true, false)
                        local warningTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.WARNING_TARGET.VARIANT,0,data.somethingSpawnLocations[i],Vector(0,0),npc):ToEffect()
                        warningTarget.Scale = 0.75
                        warningTarget:GetSprite().Color = Color(1,1,1,1,0,0,0)
                    end
                    npc.Velocity = Vector.Zero
                    sprite:PlayOverlay("Attack")
                end
            end
        end
        if npc.State == 100 then
            --npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            somebodyPathfinder:FindGridPath(targetpos, 0.2, 0, false)
            npc.Velocity = Vector.Zero
            if sprite:IsOverlayFinished() then
                for i=1,4 do
                    local bubble = Isaac.Spawn(Entities.SPEECH_BUBBLE.TYPE, Entities.SPEECH_BUBBLE.VARIANT,0,data.somethingSpawnLocations[i],Vector.Zero,npc):ToNPC()
                    bubble:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
                end
                data.somethingSpawnCooldown = data.somethingSpawnCooldownMax
                npc:PlaySound(SoundEffect.SOUND_SUMMONSOUND,0.5,0,false,1)
                sprite:PlayOverlay("Head")
                npc.State = 99
            end
        end
    end
        
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SOMEBODY.NPCUpdate, Isaac.GetEntityTypeByName("Somebody"))




function SOMEBODY:BubbleUpdate(npc)
    if npc.Type == BotB.Enums.Entities.SPEECH_BUBBLE.TYPE and npc.Variant == BotB.Enums.Entities.SPEECH_BUBBLE.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local somebodyPathfinder = npc.Pathfinder
        --It's literally just a fancy meatshield.
        npc.Velocity = Vector.Zero
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        if npc.State == 0 then
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                sprite:Play("Shake")
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
            if npc.FrameCount % 2 == 0 then
                npc.HitPoints = npc.HitPoints - 1
            end
            if npc.HitPoints <= 0 then
                npc:Kill()
            end
        end
    end  
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SOMEBODY.BubbleUpdate, Isaac.GetEntityTypeByName("Speech Bubble"))

