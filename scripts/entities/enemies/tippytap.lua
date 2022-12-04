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
    if data.walkTimerMax == nil then -- Keys of data should be strings
        data.walkTimerMax = 60
        data.walkTimer = 0
    end
  --Make it open up instead of attacking
  if npc.State == 8 then
    if npc.Variant == Entities.TIPPYTAP.VARIANT then
            --sfx:Play(Isaac.GetSoundIdByName("CartoonRicochet"),1,0,false,math.random(75, 85)/100)
            sprite:Play("Open")
            npc.State = 9
    end
end
--Opening
if npc.State == 9 then
    if npc.Variant == Entities.TIPPYTAP.VARIANT then
            --npc.Velocity = nilvector + (npc.Velocity * 0.6)
            --sprite:SetFrame("WalkVert", 0)

            if npc.StateFrame == 13 then 
                npc.State = 10 
                npc.StateFrame = 0 
                sprite:Play("WalkHori") 
                npc:PlaySound(Mod.Enums.SFX.TIPPYTAPLOOP, 3, 0, true, 1)
            end
            if sprite:IsEventTriggered("Open") then
                --Set it as vulnerable
                npc:IsInvincible(false)
                --npc:PlaySound(SoundEffect.SOUND_BOIL_HATCH, 1, 0, false, math.random(75,85)/100)
                --sfx:Play(Isaac.GetSoundIdByName("CartoonRicochet"),1,0,false,math.random(75, 85)/100)
                data.walkTimer = data.walkTimerMax
            end

            
            --sfx:Play(Isaac.GetSoundIdByName("CartoonRicochet"),1,0,false,math.random(75, 85)/100)
    end
end
--Shmoving
if npc.State == 10 then
    if npc.Variant == Entities.TIPPYTAP.VARIANT then
            print(data.walkTimer)
            npc:IsInvincible(false)
            --npc.Friction = 0.5
            tippyTapPathfinder:FindGridPath(targetpos, 2.5, 1, false) 
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
            --npc.Velocity = nilvector + (npc.Velocity * 0.6)
            --sprite:SetFrame("WalkVert", 0)
            --npc.Friction = 1
            if sprite:IsEventTriggered("Back") then 
                npc.State = 3 
                npc.StateFrame = 0 
                sprite:Play("Idle") 
                
                tippyTapPathfinder:Reset() 
            end
            if sprite:IsEventTriggered("Close") then
                --Set it as no longer vulnerable
                npc:IsInvincible(true)
                --npc:PlaySound(SoundEffect.SOUND_BOIL_HATCH, 1, 0, false, math.random(75,85)/100)
                --sfx:Play(Isaac.GetSoundIdByName("CartoonRicochet"),1,0,false,math.random(75, 85)/100)
            end

            
            --sfx:Play(Isaac.GetSoundIdByName("CartoonRicochet"),1,0,false,math.random(75, 85)/100)
    end
end

end

function TIPPYTAP:WalkTimerDecrement()
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        local data = entity:GetData()
        if entity.Variant == Entities.TIPPYTAP.VARIANT and data.walkTimer ~= 0 then
            data.walkTimer = data.walkTimer - 1
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, TIPPYTAP.NPCUpdate, Isaac.GetEntityTypeByName("Tippytap"))
Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, TIPPYTAP.WalkTimerDecrement)