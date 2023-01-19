---@diagnostic disable: duplicate-set-field
function TSIL.Charge.GetChargesAwayFromMax(player, activeSlot)
    activeSlot = activeSlot or ActiveSlot.SLOT_PRIMARY
    local totalCharge = TSIL.Charge.GetTotalCharge(player, activeSlot)
    local activeItem = player:GetActiveItem(activeSlot)
    local hasBattery = player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY)
    local maxCharges = TSIL.Collectibles.GetCollectibleMaxCharges(activeItem)

    local effectiveMaxCharges

    if hasBattery then
        effectiveMaxCharges = maxCharges * 2
    else
        effectiveMaxCharges = maxCharges
    end

    return effectiveMaxCharges - totalCharge;
end
