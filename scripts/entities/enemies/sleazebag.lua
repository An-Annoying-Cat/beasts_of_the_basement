local Mod = BotB
local SLEAZEBAG = {}
local Entities = BotB.Enums.Entities

function SLEAZEBAG:NPCUpdate(npc)
    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    --Sleazebag (This just plays the wheeze sound)
    if Entities.SLEAZEBAG.TYPE and npc.Variant == Entities.SLEAZEBAG.VARIANT and npc.SubType ~= nil then 
        if npc.State == 8 then npc.State = 99 sprite:PlayOverlay("HeadAttack") end 
            if npc.State == 99 then
                if npc.StateFrame == 23 then npc.State = 3 npc.StateFrame = 0 end
                if sprite:IsEventTriggered("Shoot") then
                    sfx:Play(Isaac.GetSoundIdByName("Wheeze"),1,0,false,math.random(75, 85)/100)
                    --npc:PlaySound(SoundEffect.SOUND_BOIL_HATCH, 1, 0, false, math.random(75,85)/100)
                    --local spawnedSkuzz = Isaac.Spawn(666, 60, 0, npc.Position, Vector.Zero, npc)
                end
            end
    end   
end



Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SLEAZEBAG.NPCUpdate, Isaac.GetEntityTypeByName("Sleazebag"))
