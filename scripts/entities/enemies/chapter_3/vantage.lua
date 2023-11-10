local Mod = BotB
local VANTAGE = {}
local Entities = BotB.Enums.Entities

function VANTAGE:NPCUpdate(npc)
    if npc.Type == BotB.Enums.Entities.VANTAGE.TYPE and npc.Variant == BotB.Enums.Entities.VANTAGE.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local vantagePathfinder = npc.Pathfinder
        if npc.State == 0 then
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if data.botbVantageBaseMaxHitPoints == nil then
                data.botbVantageBaseMaxHitPoints = 30
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
        --States:
        --99: chilling (lights are on)
        --100: awaken (lights out transition)
        --101: chase (lights are out)
        if npc.State == 99 then
            npc.MaxHitPoints = 0 
            npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            npc.Velocity = Vector.Zero
            if SFXManager():IsPlaying(BotB.Enums.SFX.VANTAGE_SCREECH_LOOP) == true then
                SFXManager():Stop(BotB.Enums.SFX.VANTAGE_SCREECH_LOOP)
            end
        end
        if npc.State == 101 then
            npc.MaxHitPoints = data.botbVantageBaseMaxHitPoints
            npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            vantagePathfinder:FindGridPath(targetpos, 1.25, 0, true)
            if SFXManager():IsPlaying(BotB.Enums.SFX.VANTAGE_SCREECH_LOOP) == false then
                SFXManager():Play(BotB.Enums.SFX.VANTAGE_SCREECH_LOOP,2,0,true,1)
            end
        end
    end
        
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, VANTAGE.NPCUpdate, Isaac.GetEntityTypeByName("Vantage"))



function VANTAGE:DamageCheck(npc, amount, damageFlags, source, _)
    if npc.Variant ~= BotB.Enums.Entities.VANTAGE.VARIANT then return end
    if npc.State == 99 then
        return false
    end
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, VANTAGE.DamageCheck, Isaac.GetEntityTypeByName("Vantage"))