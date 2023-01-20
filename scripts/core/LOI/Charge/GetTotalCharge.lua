---@diagnostic disable: duplicate-set-field
function TSIL.Charge.GetTotalCharge(player, activeSlot)
    activeSlot = activeSlot or ActiveSlot.SLOT_PRIMARY
    
    local activeCharge = player:GetActiveCharge(activeSlot)
    local batteryCharge = player:GetBatteryCharge(activeSlot)

    return activeCharge + batteryCharge
end
