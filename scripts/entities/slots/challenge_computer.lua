local Mod = BotB
local CHALLENGE_COMPUTER = {}




function CHALLENGE_COMPUTER:SlotUpdate(slot)
    local sprite = slot:GetSprite()
    local position = slot.Position
    --print(slot:GetState())
    if sprite:IsOverlayFinished("CoinInsert") then
        SFXManager():Play(Isaac.GetSoundIdByName("GoldenSlotBuzz"),1,30,false,1,0)
        sprite:Play("Prize")
        
    end
    if sprite:IsFinished("Prize") then
        local str = "CHALLENGE ACTIVATED."
            local AbacusFont = Font()
            AbacusFont:Load("font/pftempestasevencondensed.fnt")
            for i = 1, 60 do
                BotB.FF.scheduleForUpdate(function()
                    local pos = game:GetRoom():WorldToScreenPosition(position) + Vector(AbacusFont:GetStringWidth(str) * -0.5, -(slot.SpriteScale.Y * 35) - i/2)
                    local opacity
                    if i >= 30 then
                        opacity = 1 - ((i-30)/30)
                    else
                        opacity = i/15
                    end
                    AbacusFont:DrawString(str, pos.X, pos.Y, KColor(0,1,0,opacity), 0, false)
                end, i, ModCallbacks.MC_POST_RENDER)
            end
        slot:Remove()
    end
end





Mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, CHALLENGE_COMPUTER.SlotUpdate, BotB.Enums.Slots.CHALLENGE_COMPUTER.VARIANT)




function CHALLENGE_COMPUTER:SlotCollision(slot, collider, low)
    local sprite = slot:GetSprite()
    if collider:ToPlayer() ~= nil and low == false and sprite:IsPlaying("Idle") then
        SFXManager():Play(Isaac.GetSoundIdByName("GoldenSlotPolymorph"),1,0,false,1,0)
        if slot:GetState() == 1 then
            slot:SetState(2)
            sprite:Play("Wiggle")
            sprite:PlayOverlay("CoinInsert")
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, CHALLENGE_COMPUTER.SlotCollision, BotB.Enums.Slots.CHALLENGE_COMPUTER.VARIANT)