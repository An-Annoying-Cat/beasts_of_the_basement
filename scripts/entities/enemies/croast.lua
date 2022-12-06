local Mod = BotB
local CROAST = {}
local Entities = BotB.Enums.Entities

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



function CROAST:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local target = npc:GetPlayerTarget()
    local targetpos = target.Position
    local data = npc:GetData()
    local croastPathfinder = npc.Pathfinder
    if data.flyTimerMax == nil and data.OPENED == nil then -- Keys of data should be strings
        --Data types
        --Approach direction (bool) - Is going to dive from left or right? True = right
        data.approachDirection = true
        --Flight timer
        data.flyTimerMax = 60
        data.flyTimer = 0
        --Stun timer
        data.StunTimerMax = 60
        data.StunTimer = 0
        
    end
  --Make it open up instead of attacking
  if npc.State == 8 then
    if npc.Variant == Entities.CROAST.VARIANT then
            sprite:Play("Shoot")
            npc.State = 9
    end
end
--Opening
if npc.State == 9 then
    if npc.Variant == Entities.CROAST.VARIANT then
            if npc.StateFrame == 13 then 
                npc.State = 10 
                npc.StateFrame = 0 
                sprite:Play("Fly") 
            end
            if sprite:IsEventTriggered("Flying") then
                npc.EntityGridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                data.flyTimer = data.flyTimerMax
            end
    end
end
--Flying
if npc.State == 10 then
    if npc.Variant == Entities.CROAST.VARIANT then
            croastPathfinder:FindGridPath(targetpos, 2, 1, false) 
            if data.flyTimer <= 0 then
                npc.State = 11
                sprite:Play("Close")
            end
    end
end
--Closing
if npc.State == 11 then
    if npc.Variant == Entities.CROAST.VARIANT then
        sfx:Stop(Mod.Enums.SFX.CROASTLOOP)
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
function CROAST:flyTimerDecrement()
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        local data = entity:GetData()
        if entity.Variant == Entities.CROAST.VARIANT and data.flyTimer ~= 0 and data.flyTimer ~= nil then
            data.flyTimer = data.flyTimer - 1
            if data.flyTimer % 2 == 0 then
                sfx:Play(BotB.Enums.SFX.CROASTSTEP, 0.5, 0, false, 1)
            end
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, CROAST.NPCUpdate, Isaac.GetEntityTypeByName("CROAST"))
Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, CROAST.flyTimerDecrement)