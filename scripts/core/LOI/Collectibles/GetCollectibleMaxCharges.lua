---@diagnostic disable: duplicate-set-field
function TSIL.Collectibles.GetCollectibleMaxCharges(collectibleType)
    local itemConfigItem = Isaac.GetItemConfig():GetCollectible(collectibleType)

    if not itemConfigItem then
        return 0
    else
        return itemConfigItem.MaxCharges
    end
end
