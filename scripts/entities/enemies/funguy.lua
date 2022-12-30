local Mod = BotB
local FUN_GUY = {}
local Entities = BotB.Enums.Entities

function FUN_GUY:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
    local targetpos = target.Position
    local targetangle = (targetpos - npc.Position):GetAngleDegrees()
    local targetdistance = (targetpos - npc.Position):Length()
    local funGuyPathfinder = npc.Pathfinder
    local room = Game():GetRoom()
    if npc.Type == BotB.Enums.Entities.FUN_GUY.TYPE and npc.Variant == BotB.Enums.Entities.FUN_GUY.VARIANT then 
        if data.isOpened == nil then
            data.isOpened = false
            data.openTimerMax = 120
            data.openTimer = data.openTimerMax
        end
        --States:
        -- 1: Init
        -- 99: Closed
        -- 100: Opening
        -- 101: Opened, running away
        -- 102: Closing
        if npc.State == 0 then
            sprite:Play("Blocking")
            npc.State = 99
        end
        if npc.State == 99 then
            npc.Velocity = Vector.Zero
            if data.openTimer <= 0 then
                data.openTimer = data.openTimerMax
                npc.State = 100
                sprite:Play("Reveal")
            end
            if targetdistance <= 10 then
                data.openTimer = data.openTimerMax
                npc.State = 100
                sprite:Play("Reveal")
            end
        end
        if npc.State == 100 then
            npc.Velocity = Vector.Zero
            if sprite:IsEventTriggered("Back") then
                npc.State = 101
                data.isOpened = true
                sprite:Play("Revealed")
            end
        end
        if npc.State == 101 then
            npc:AnimWalkFrame("WalkHori", "WalkHori", 1)
            --npc.Velocity = (0.8 * npc.Velocity) + (0.2 * Vector(5,0):Rotated(targetangle+180))
            if room:IsPositionInRoom(npc.Position+Vector(100,0):Rotated(180+targetangle), 100) then
                funGuyPathfinder:FindGridPath(npc.Position+Vector(100,0):Rotated(180+targetangle), 2, 99, true)
                funGuyPathfinder:EvadeTarget(targetpos)
            else 
                funGuyPathfinder:MoveRandomly(false)
                funGuyPathfinder:EvadeTarget(targetpos)
            end
            
            --Isaac.Spawn(EntityType.ENTITY_EFFECT,Entities.WARNING_TARGET.VARIANT,0,npc.Position+Vector(100,0):Rotated(180+targetangle),Vector(0,0),npc)
            if data.openTimer <= 0 then
                npc.Velocity = Vector.Zero
                data.openTimer = data.openTimerMax
                npc.State = 102
                sprite:Play("Hide")
            end
        end
        if npc.State == 102 then
            if sprite:IsEventTriggered("Back") then
                npc.State = 99
                data.isOpened = false
                sprite:Play("Blocking")
            end
        end

        --Timer shit
        print(data.openTimer)
        if data.openTimer >= 0 then
            data.openTimer = data.openTimer - 1
        end
    end
end

function FUN_GUY:DamageCheck(npc, amount, _, _, _)
    --print("sharb")
    local npcConv = npc:ToNPC()
    local data = npc:GetData()
    local sprite = npc:GetSprite()
    if npc.Type == BotB.Enums.Entities.FUN_GUY.TYPE and npc.Variant == BotB.Enums.Entities.FUN_GUY.VARIANT then 
        if data.isOpened == false then
            npcConv.Velocity = Vector.Zero
            return false
        else
            return true
        end
    end
    --return true
end

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FUN_GUY.NPCUpdate, Isaac.GetEntityTypeByName("Fun Guy"))
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, FUN_GUY.DamageCheck, Isaac.GetEntityTypeByName("Fun Guy"))