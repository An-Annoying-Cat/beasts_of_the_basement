local Mod = BotB
local TIPPYTAP = {}
local Entities = BotB.Enums.Entities

function TIPPYTAP:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local target = npc:GetPlayerTarget()
    local targetpos = target.Position
    local data = npc:GetData()
    local tippyTapPathfinder = npc.Pathfinder
    data.isMakingTipToeSound = false
    if data.walkTimerMax == nil and data.OPENED == nil then -- Keys of data should be strings
        data.walkTimerMax = 60
        data.walkTimer = 0
        data.OPENED = false
    end
  --Make it open up instead of attacking
  if npc.State == 8 then
    if npc.Variant == Entities.TIPPYTAP.VARIANT then
            sprite:Play("Open")
            npc.State = 9
    end
end
--Opening
if npc.State == 9 then
    if npc.Variant == Entities.TIPPYTAP.VARIANT then
            if npc.StateFrame == 13 then 
                npc.State = 10 
                npc.StateFrame = 0 
                sprite:Play("WalkHori") 
            end
            if sprite:IsEventTriggered("Open") then
                data.walkTimer = data.walkTimerMax
            end
    end
end
--Shmoving
if npc.State == 10 then
    if npc.Variant == Entities.TIPPYTAP.VARIANT then
            tippyTapPathfinder:FindGridPath(targetpos, 2, 1, false) 
            if data.walkTimer <= 0 then
                npc.State = 11
                sprite:Play("Close")
            end
    end
end
--Closing
if npc.State == 11 then
    if npc.Variant == Entities.TIPPYTAP.VARIANT then
        sfx:Stop(Mod.Enums.SFX.TIPPYTAPLOOP)
            if sprite:IsEventTriggered("Back") then 
                npc.State = 3 
                npc.StateFrame = 0 
                sprite:Play("Idle") 
                tippyTapPathfinder:Reset() 
            end
            if sprite:IsEventTriggered("Close") then
                npc:PlaySound(SoundEffect.SOUND_ANIMAL_SQUISH, 1, 0, false, 1)
            end
    end
end
end
--Walking time countdown
function TIPPYTAP:WalkTimerDecrement()
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        local data = entity:GetData()
        if entity.Variant == Entities.TIPPYTAP.VARIANT and data.walkTimer ~= 0 and data.walkTimer ~= nil then
            data.walkTimer = data.walkTimer - 1
            if data.walkTimer % 2 == 0 then
                sfx:Play(BotB.Enums.SFX.TIPPYTAPSTEP, 0.5, 0, false, 1)
            end
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, TIPPYTAP.NPCUpdate, Isaac.GetEntityTypeByName("Tippytap"))
Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, TIPPYTAP.WalkTimerDecrement)