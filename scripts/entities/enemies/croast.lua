local Mod = BotB
local CROAST = {}
local Entities = BotB.Enums.Entities
local sfx = SFXManager()

--THIS SHIT IS SO FAR FROM FINISHED IT ISNT EVEN FUNNY

--States:
--9 = Opening
--10 = Flying
--11 = Flight timer ran out. Time to divebomb
--12 = Beginning divebomb
--13 = Divebomb sliding
--14 = Divebomb bonk
--15 = Divebomb stunned
--16 = Stun timer ran out. Back to 3 (aka idle)
--THESE LAST TWO ARE DEFINITE MAYBES
--17 = Ran into pit while divebombing. Going back into shell
--18 = Taking off after encountering a pit while divebombing



function CROAST:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local target = npc:GetPlayerTarget()
    local targetpos = target.Position
    local targetangle = (targetpos - npc.Position):GetAngleDegrees()
    local data = npc:GetData()
    local croastPathfinder = npc.Pathfinder
    local targetdistance = (targetpos - npc.Position):Length()

    if data.flyTimerMax == nil or data.approachDirection == nil then -- Keys of data should be strings
        --Data types
        --Approach direction (bool) - Is going to dive from left or right? True = right
        data.approachDirection = true
        --Flight timer
        data.flyTimerMax = 120
        data.flyTimer = 0
        --Stun timer
        data.StunTimerMax = 60
        data.StunTimer = 0
        --Flight targeting
        data.flightTarget = Vector.Zero
        data.flightTargetDistance = 0
        data.flightTargetAngle = 0
        
    end

    --Determine approach direction
    

  --Make it open up instead of attacking
    if npc.State == 8 then
        print("FUCK")
        if npc.Variant == Entities.CROAST.VARIANT then
            print("SHIT")
            sprite:Play("Shoot")
            npc.State = 9
        end
    end
--Opening
if npc.State == 9 then
    if npc.Variant == Entities.CROAST.VARIANT then
        if sprite:IsEventTriggered("Flying") then
            npc:PlaySound(SoundEffect.SOUND_ANIMAL_SQUISH, 1, 0, false, 1)
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            data.flyTimer = data.flyTimerMax
        end
            if sprite:IsEventTriggered("Back") then 
                npc.State = 10 
                npc.StateFrame = 0 
                data.flyTimer = data.flyTimerMax
                sprite:Play("Fly") 
                --Determine target
                if npc.Position.X >= targetpos.X then
                    data.approachDirection = true
                else
                    data.approachDirection = false
                end
                print(data.approachDirection)
                if data.approachDirection == true then
                    data.flightTarget = Vector(targetpos.X-150, targetpos.Y)
                else
                    data.flightTarget = Vector(targetpos.X+150, targetpos.Y)
                end
                data.flightTargetAngle = (data.flightTarget - npc.Position):GetAngleDegrees()
                npc.Velocity = Vector(10,0):Rotated(data.flightTargetAngle)
            end
            
            
    end
end

--Flying
if npc.State == 10 then
    if npc.Variant == Entities.CROAST.VARIANT then
        --Try to approach the player's side depending on data.ApproachDirection
        if data.approachDirection == true then
            data.flightTarget = Vector(targetpos.X-150, targetpos.Y)
        else
            data.flightTarget = Vector(targetpos.X+150, targetpos.Y)
        end
        data.flightTargetAngle = (data.flightTarget - npc.Position):GetAngleDegrees()

        Isaac.Spawn(EntityType.ENTITY_EFFECT,Entities.WARNING_TARGET.VARIANT,0,data.flightTarget,Vector(0,0),npc)
        data.flightTargetDistance = (data.flightTarget - npc.Position):Length()
        --npc.Velocity = (npc.Velocity + 0.1*npc.Velocity:Rotated(data.flightTargetAngle)):Resized(5)
        npc.Velocity = -((npc.Velocity * 0.4) + ((data.flightTarget - npc.Position):Resized(-30) * 0.6))
            --croastPathfinder:FindGridPath(data.flightTarget, 2, 20, true) 
            --TODO: MAKE IT STOP WHEN IT REACHES THE TARGET POSITON
            --print(data.flyTimer)
            if data.flyTimer <= 0 then
                npc.State = 11
                sprite:Play("Back")
            else
                data.flyTimer = data.flyTimer - 1
            end
    end
end

--Closing
if npc.State == 11 then
    if npc.Variant == Entities.CROAST.VARIANT then
        --sfx:Stop(Mod.Enums.SFX.CROASTLOOP)
            if sprite:IsEventTriggered("Back") then 
                npc.State = 3 
                npc.StateFrame = 0 
                sprite:Play("Idle") 
                croastPathfinder:Reset() 
            end
            if sprite:IsEventTriggered("Close") then
                npc:PlaySound(SoundEffect.SOUND_ANIMAL_SQUISH, 1, 0, false, 1)
            end
    end
end
end

--Walking time countdown
--[[
function CROAST:flyTimerDecrement()
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        local data = entity:GetData()
        if entity.Variant == Entities.CROAST.VARIANT and data.flyTimer ~= 0 and data.flyTimer ~= nil then
            data.flyTimer = data.flyTimer - 1
            if data.flyTimer % 2 == 0 then
                --sfx:Play(BotB.Enums.SFX.CROASTSTEP, 0.5, 0, false, 1)
            end
        end
    end
end
--]]

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, CROAST.NPCUpdate, Isaac.GetEntityTypeByName("Croast"))
--Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, CROAST.flyTimerDecrement)