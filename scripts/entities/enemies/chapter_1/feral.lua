local Mod = BotB
local FERAL = {}
local Entities = BotB.Enums.Entities
--print(BotB.Enums.Entities.FERAL.TYPE .. "." .. BotB.Enums.Entities.FERAL.VARIANT)
function FERAL:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()

    

    if npc.Type == BotB.Enums.Entities.FERAL.TYPE and npc.Variant == BotB.Enums.Entities.FERAL.VARIANT then 
        if data.startsSleeping == nil then
            if (npc.SubType - (npc.SubType % 128)) / 128 == 0 then
                data.startsSleeping = false
            else 
                data.startsSleeping = true
            end
            
            sprite:Play("Appear")
        end
        --States:
        --0: Init
        --99: Sleep
        --100: Chase
        if npc.State == 0 then
            --print("yeems")
            if sprite:IsEventTriggered("Back") then
                if data.startsSleeping == true then
                    npc.State = 99
                    sprite:Play("Sleep")
                else
                    npc.State = 100
                    sprite:Play("RunDown")
                end
            end
        end
        if npc.State == 99 then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            if targetdistance < 125 then
                npc.State = 100
                sprite:Play("RunDown")
            end
        end
        if npc.State == 100 then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            npc.Velocity = ((0.995 * npc.Velocity) + (0.005 * (target.Position - npc.Position))):Clamped(-10,-10,10,10)
            data.animAngle = -((targetpos - npc.Position):GetAngleDegrees()) % 360
                --print("angle should be " .. data.animAngle)
                --print("current anim is " .. sprite:GetAnimation())

                if (data.animAngle <= 45 and data.animAngle >= 0) or (data.animAngle >= 315 and data.animAngle > 360) then
                    --facing right
                    if sprite.FlipX == true then
                        sprite.FlipX = false
                    end
                    if sprite:GetAnimation() ~= "RunHori" then
                        sprite:Play("RunHori")
                    end
                elseif (data.animAngle <= 135 and data.animAngle > 45) then
                    --facing up
                    if sprite.FlipX == true then
                        sprite.FlipX = false
                    end
                    if sprite:GetAnimation() ~= "RunUp" then
                        sprite:Play("RunUp")
                    end
                elseif (data.animAngle <= 225 and data.animAngle > 135) then
                    --facing left
                    if sprite.FlipX == false then
                        sprite.FlipX = true
                    end
                    if sprite:GetAnimation() ~= "RunHori" then
                        sprite:Play("RunHori")
                    end
                elseif (data.animAngle <= 315 and data.animAngle > 225) then
                    --facing down
                    if sprite.FlipX == true then
                        sprite.FlipX = false
                    end
                    if sprite:GetAnimation() ~= "RunDown" then
                        sprite:Play("RunDown")
                    end
                end
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FERAL.NPCUpdate, Isaac.GetEntityTypeByName("Feral"))