---@diagnostic disable: duplicate-set-field
local function shouldPlayFullRechargeSound(player, activeSlot)
  local activeItem = player:GetActiveItem(activeSlot)
  local activeCharge = player:GetActiveCharge(activeSlot)
  local batteryCharge = player:GetBatteryCharge(activeSlot)
  local hasBattery = player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY)
  local maxCharges = TSIL.Collectibles.GetCollectibleMaxCharges(activeItem)

  if not hasBattery then
    return activeCharge == maxCharges
  end

  return (
    batteryCharge == maxCharges or
    (activeCharge == maxCharges and batteryCharge == 0)
  )
end

local function playChargeSoundEffect(player, activeSlot)
    SFXManager():Stop(SoundEffect.SOUND_BATTERYCHARGE)
    SFXManager():Stop(SoundEffect.SOUND_BEEP)

    local playFullRechargeSound = shouldPlayFullRechargeSound(player, activeSlot)
    
    local chargeSoundEffect

    if playFullRechargeSound then
        chargeSoundEffect = SoundEffect.SOUND_BATTERYCHARGE
    else
        chargeSoundEffect = SoundEffect.SOUND_BEEP 
    end

    SFXManager():Play(chargeSoundEffect)
end

local function getChargesToAddWithAAAModifier(player, activeSlot, chargesToAdd)
    local hasAAABattery = player:HasTrinket(TrinketType.TRINKET_AAA_BATTERY)
    
    if not hasAAABattery then
        return chargesToAdd
    end

    local chargesAwayFromMax = TSIL.Charge.GetChargesAwayFromMax(player, activeSlot)
    local aaaBatteryShouldApply = chargesToAdd == chargesAwayFromMax - 1

    if aaaBatteryShouldApply then
        return chargesToAdd + 1
    else
        return chargesToAdd
    end
end

function TSIL.Charge.AddCharge(player, activeSlot, numCharges, playSoundEffect)
    activeSlot = activeSlot or ActiveSlot.SLOT_PRIMARY
    numCharges = numCharges or 1

    if playSoundEffect == nil then
        playSoundEffect = true
    end

    local hud = Game():GetHUD()

    --[[
        Ensure that there is enough space on the active item to store these amount of charges. (If we 
        add too many charges, it will grant orange "battery" charges even if the player doesn't have 
        the item).
    ]] 
    local chargesAwayFromMax = TSIL.Charge.GetChargesAwayFromMax(player, activeSlot)
    
    local chargesToAdd

    if numCharges > chargesAwayFromMax then
        chargesToAdd = chargesAwayFromMax
    else
        chargesToAdd = numCharges
    end

    local modifiedChargesToAdd = getChargesToAddWithAAAModifier(player, activeSlot, chargesToAdd)
    
    local totalCharge = TSIL.Charge.GetTotalCharge(player, activeSlot)
    local newCharge = totalCharge + modifiedChargesToAdd
    if newCharge == totalCharge then
        return 0
    end

    player:SetActiveCharge(newCharge, activeSlot)
    hud:FlashChargeBar(player, activeSlot)

    if playSoundEffect then
        playChargeSoundEffect(player, activeSlot)
    end

    return modifiedChargesToAdd
end

