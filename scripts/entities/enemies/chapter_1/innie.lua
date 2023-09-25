local Mod = BotB
local INNIE_CW = {}
local Entities = BotB.Enums.Entities

function INNIE_CW:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()

    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.INNIE_CW.TYPE and npc.Variant == BotB.Enums.Entities.INNIE_CW.VARIANT then 
        --Data init...
        if data.innieDirection == nil then
            -- 0: Random
            -- 1: Up
            -- 2: Right
            -- 3: Down
            -- 4: Left
            data.innieDirection = npc.SubType
            --Tracks whether they're pissed
            data.inniePissed = false
            --sprite:Play("Appear")
            
        end
        --print(npc.GridCollisionClass)
        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        -- States:
        -- 1: Initialize
        -- 2: Walk
        -- 3: Shoot
        if npc.State == 0 then
            --Init
            if npc.SubType == 0 or npc.SubType == nil then
                data.innieDirection = math.random(1,4)
            end
            --
            --
            print("dir: " .. data.innieDirection)
            
            npc.State = 99

            if data.innieDirection == 1 then
                sprite:Play("WalkUp")
            elseif data.innieDirection == 2 then
                sprite:Play("WalkRight")
            elseif data.innieDirection == 3 then
                sprite:Play("WalkDown")
            elseif data.innieDirection == 4 then
                sprite:Play("WalkLeft")
            end

            
        end

        if npc.State == 99 then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            --print("bruh")
            if data.innieDirection == 1 then
                --print("up you idiot")
                npc:AnimWalkFrame("WalkUp","WalkUp",0)
                npc.Velocity = (0.5 * npc.Velocity) + (0.5 * Vector (0,-4))
            elseif data.innieDirection == 2 then
                --print("right you idiot")
                npc:AnimWalkFrame("WalkRight","WalkRight",0)
                npc.Velocity = (0.5 * npc.Velocity) + (0.5 * Vector (-4,0))
            elseif data.innieDirection == 3 then
                --print("down you idiot")
                npc:AnimWalkFrame("WalkDown","WalkDown",0)
                npc.Velocity = (0.5 * npc.Velocity) + (0.5 * Vector (0,4))
            elseif data.innieDirection == 4 then
                --print("left you idiot")
                npc:AnimWalkFrame("WalkLeft","WalkLeft",0)
                npc.Velocity = (0.5 * npc.Velocity) + (0.5 * Vector (4,0))
            end
            if npc:CollidesWithGrid() == true or data.positionFailsafe == npc.Position then
                if data.innieDirection == 1 then
                    sprite:Play("AttackUp")
                elseif data.innieDirection == 2 then
                    sprite:Play("AttackRight")
                elseif data.innieDirection == 3 then
                    sprite:Play("AttackDown")
                elseif data.innieDirection == 4 then
                    sprite:Play("AttackLeft")
                end
                npc.State = 100
            end
            data.positionFailsafe = npc.Position
        end

        if npc.State == 100 then
            if sprite:IsEventTriggered("Shoot") then
                npc:PlaySound(BotB.Enums.SFX.WHEEZE,1,0,false,math.random(50,70)/100)
                local params = ProjectileParams()
                params.HeightModifier = 15
                params.FallingSpeedModifier = -2
                params.Spread = 14
                npc:FireProjectiles(npc.Position, Vector(8,0):Rotated(targetangle),0, params)
            end
            if sprite:IsEventTriggered("Back") then
                npc.Position = Game():GetRoom():FindFreeTilePosition(npc.Position, 0)
                if data.innieDirection == 1 then
                    data.innieDirection = 4
                else
                    data.innieDirection = data.innieDirection - 1
                end
                if data.innieDirection == 1 then
                    sprite:Play("WalkUp")
                elseif data.innieDirection == 2 then
                    sprite:Play("WalkRight")
                elseif data.innieDirection == 3 then
                    sprite:Play("WalkDown")
                elseif data.innieDirection == 4 then
                    sprite:Play("WalkLeft")
                end
                npc.State = 99
            end
        end

        --print(sprite:GetAnimation())
        sprite.FlipX = true

    end

end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, INNIE_CW.NPCUpdate, Isaac.GetEntityTypeByName("Innie (CW)"))