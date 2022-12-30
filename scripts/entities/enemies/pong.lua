local Mod = BotB
local PONG = {}
local Entities = BotB.Enums.Entities

function PONG:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.PONG.TYPE and npc.Variant == BotB.Enums.Entities.PONG.VARIANT then 
        if data.pingHasBeenHit == nil then
            data.pingHasBeenHit = false
        end
        --States:
        --1: Init
        --99: Idle
        --100: Zooming around from hurt anim
        --101: Fucking dying
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
        if npc.State == 101 then
            if sprite:GetFrame() == 1 then
                npc.Velocity = npc.Velocity*1.5
            end
            if sprite:IsEventTriggered("Back") then
                local randoDir = targetangle + math.random(-45,45)
                local smolBoi1 = Isaac.Spawn(Entities.PING.TYPE, Entities.PING.VARIANT, 0, npc.Position, Vector(5,0):Rotated(randoDir+90),npc)
                smolBoi1:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                smolBoi1:ToNPC().State = 100
                smolBoi1:ToNPC():GetSprite():Play("Hurt")
                local smolBoi2 = Isaac.Spawn(Entities.PING.TYPE, Entities.PING.VARIANT, 0, npc.Position, Vector(5,0):Rotated(randoDir-90),npc)
                smolBoi2:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                smolBoi2:ToNPC().State = 100
                smolBoi2:ToNPC():GetSprite():Play("Hurt")
                for i=0,5,1 do
                    local rubble = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.NAIL_PARTICLE,0,npc.Position,Vector((0.1*math.random(-20,20)),(0.1*math.random(-20,20))),npc)
                    rubble.Color = Color(0.25,0.25,0.25,1)
                end
                npc:PlaySound(BotB.Enums.SFX.PONGPOP,10,0,false,math.random(60,80)/100)
                npc:Remove()
            end
        end
    end
end

function PONG:DamageCheck(npc, amount, _, _, _)
    --print("sharb")
    local npcConv = npc:ToNPC()
    local data = npc:GetData()
    local sprite = npc:GetSprite()
    if npc.Type == BotB.Enums.Entities.PONG.TYPE and npc.Variant == BotB.Enums.Entities.PONG.VARIANT then 
        if amount >= npc.HitPoints then
            npcConv.State = 101
            sprite:Play("Die")
            return false
        else
            if npc.State ~= 101 then
                npcConv.State = 100
                sprite:Play("Hurt")
                if data.pingHasBeenHit == false then
                    data.pingHasBeenHit = true
                    return false
                else
                    return true
                end
            else
                return false
            end
        end 
    end
    --return true
end


Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, PONG.DamageCheck, Isaac.GetEntityTypeByName("Pong"))

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, PONG.NPCUpdate, Isaac.GetEntityTypeByName("Pong"))