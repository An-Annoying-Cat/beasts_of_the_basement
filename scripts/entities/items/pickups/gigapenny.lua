local Mod = BotB
sfx = SFXManager()
game = Game()
local GIGA_PENNY = {}

function GIGA_PENNY:getGigaPenny(pickup,collider,_)
    local data = pickup:GetData()
    local sprite = pickup:GetSprite()
    --print(pickup.Type .. "," .. pickup.Variant .. "," .. pickup.SubType)
    if pickup.SubType ~= nil and pickup.SubType == Mod.Enums.Pickups.GIGA_PENNY.SUBTYPE and collider.Type == Isaac.GetEntityTypeByName("Player") then
        sfx:Play(SoundEffect.SOUND_DIMEPICKUP,2,0,false,0.5)
        pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        sprite:Play("Collect")
        data.Collector = collider:ToPlayer()
        data.Collector:AddCoins(15)
        TSIL.Players.AddSmeltedTrinket(collider:ToPlayer(),TrinketType.TRINKET_STORE_CREDIT)
        return false
    end
end

function GIGA_PENNY:gigaPennyUpdate(pickup)
    local data = pickup:GetData()
    local sprite = pickup:GetSprite()
    if data.Collector == nil then
        data.Collector = pickup
    end
    --print(pickup:GetCoinValue())
    if pickup.SubType ~= nil and pickup.SubType == Mod.Enums.Pickups.GIGA_PENNY.SUBTYPE then

        if sprite:IsEventTriggered("DropSound") then
            Game():ShakeScreen(15)
            sfx:Play(SoundEffect.SOUND_DIMEDROP,2,0,false,math.random(50, 60)/100)
            sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS,1,0,false,math.random(80, 90)/100)
        end
        if sprite:IsEventTriggered("Remove") then
            pickup:Remove()
        end
    end

end

Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION,GIGA_PENNY.getGigaPenny,PickupVariant.PICKUP_GRAB_BAG)
Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE,GIGA_PENNY.gigaPennyUpdate,PickupVariant.PICKUP_GRAB_BAG)