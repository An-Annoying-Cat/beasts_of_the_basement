local Mod = BotB
local PING = {}
local Entities = BotB.Enums.Entities

function PING:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.PING.TYPE and npc.Variant == BotB.Enums.Entities.PING.VARIANT then 
        if data.pingHasBeenHit == nil then
            data.pingHasBeenHit = false
            npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        end
        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        --States:
        --1: Init
        --99: Idle
        --100: Zooming around from hurt anim
        if npc.State == 0 then
            --print("balls")
            sprite:Play("Idle")
            npc.State = 99
        end
        if npc.State == 99 then
            --HAPPY HAPPY HAPPY~ (ding ding ding ding ding, ding)
        end
        if npc.State == 100 then
            if sprite:GetFrame() == 1 then
                npc.Velocity = npc.Velocity*3
            end
            if sprite:IsEventTriggered("Back") then
                sprite:Play("Idle")
                npc.State = 99
            end
        end
    end
end

function PING:DamageCheck(npc, amount, _, _, _)
    if npc.Variant ~= BotB.Enums.Entities.PING.VARIANT then return end
    --print("sharb")
    local npcConv = npc:ToNPC()
    local data = npc:GetData()
    local sprite = npc:GetSprite()
    if npc.Type == BotB.Enums.Entities.PING.TYPE and npc.Variant == BotB.Enums.Entities.PING.VARIANT then 
        npcConv.State = 100
        sprite:Play("Hurt")
        if data.pingHasBeenHit == false then
            data.pingHasBeenHit = true
            return false
        else
            return true
        end
    end
    --return true
end


Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, PING.DamageCheck, Isaac.GetEntityTypeByName("Ping"))

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, PING.NPCUpdate, Isaac.GetEntityTypeByName("Ping"))