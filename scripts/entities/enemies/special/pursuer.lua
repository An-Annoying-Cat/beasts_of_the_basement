local Mod = BotB
local PURSUER = {}
local Entities = BotB.Enums.Entities

function PURSUER:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    


    if npc.Type == BotB.Enums.Entities.PURSUER.TYPE and npc.Variant == BotB.Enums.Entities.PURSUER.VARIANT then 
        if npc.State == 0 then
            --Init
                npc.State = 99
                sprite:Play("Idle")
        end
        --States:
        --99: Watching
        --    Following
        --    Stalking
        --    Hiding
        
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_NONE then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        end
        if not npc:HasEntityFlags(EntityFlag.FLAG_PERSISTENT) then
            npc:AddEntityFlags(EntityFlag.FLAG_PERSISTENT | EntityFlag.FLAG_TRANSITION_UPDATE)
        end

        if npc.State == 99 then
            npc.Velocity = ((0.999 * npc.Velocity) + (0.001 * (target.Position - npc.Position))):Clamped(-1,-1,1,1)
        end

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, PURSUER.NPCUpdate, Isaac.GetEntityTypeByName("Pursuer"))