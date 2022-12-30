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
    if npc.Type == BotB.Enums.Entities.FUN_GUY.TYPE and npc.Variant == BotB.Enums.Entities.FUN_GUY.VARIANT then 
        --bruh
        if npc.State == 16 then
            npc:AnimWalkFrame("WalkHori", "WalkVert", 1)
            funGuyPathfinder:FindGridPath(npc.Position + Vector(targetdistance,0):Rotated(-1*targetangle), 5, 1, false)
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FUN_GUY.NPCUpdate, Isaac.GetEntityTypeByName("Fun Guy"))