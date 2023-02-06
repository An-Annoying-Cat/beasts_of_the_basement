local Mod = BotB
sfx = SFXManager()
game = Game()
local GIGA_PENNY = {}

local function getPlayers()
	local game = Game()
	local numPlayers = game:GetNumPlayers()
  
	local players = {}
	for i = 0, numPlayers - 1 do
	  local player = Isaac.GetPlayer(i)
	  table.insert(players, player)
	end
  
	return players
end

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
        --TSIL.Players.AddSmeltedTrinket(collider:ToPlayer(),TrinketType.TRINKET_STORE_CREDIT)
        if data.Collector:GetData().queuedGigaPennyCoupons ~= nil then
           data.Collector:GetData().queuedGigaPennyCoupons = data.Collector:GetData().queuedGigaPennyCoupons + 1
        end
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


--Player shit (queued coupon on entering a shop)
--This part is just initializing the variable
function GIGA_PENNY:playerUpdate(player)
	local data = player:GetData()
    if data.queuedGigaPennyCoupons == nil then
		data.queuedGigaPennyCoupons = 0
	end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, GIGA_PENNY.playerUpdate, 0)


--Queued uses of Coupon when entering a shop

function GIGA_PENNY.newRoomCheck()
    local room = Game():GetRoom()
    --Shop
    local succeeded = false
    if room:GetType() == RoomType.ROOM_SHOP or room:GetType() == RoomType.ROOM_BLACK_MARKET then
        if TSIL.Entities.GetEntities(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_SHOPITEM) ~= nil then
            local players = getPlayers()
            for i=1,#players,1 do
                if players[i]:GetData().queuedGigaPennyCoupons > 0 then
                    repeat
                        players[i]:UseActiveItem(CollectibleType.COLLECTIBLE_COUPON, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
                        players[i]:GetData().queuedGigaPennyCoupons = players[i]:GetData().queuedGigaPennyCoupons - 1
                    until players[i]:GetData().queuedGigaPennyCoupons == 0
                    succeeded = true
                end
            end
        end
    elseif room:GetType() == RoomType.ROOM_DEVIL then
        if TSIL.Entities.GetEntities(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_SHOPITEM) ~= nil then
            local players = getPlayers()
            for i=1,#players,1 do
                if players[i]:GetData().queuedGigaPennyCoupons > 0 then
                    repeat
                        players[i]:UseActiveItem(CollectibleType.COLLECTIBLE_COUPON, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
                        players[i]:GetData().queuedGigaPennyCoupons = players[i]:GetData().queuedGigaPennyCoupons - 1
                    until players[i]:GetData().queuedGigaPennyCoupons == 0
                    succeeded = true
                end
            end
        end
    end
    if succeeded == true then
        sfx:Play(SoundEffect.SOUND_CASH_REGISTER, 1,0,false,1.0,0)
    end

end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM,GIGA_PENNY.newRoomCheck)


function GIGA_PENNY:gigaPennyReplace(entity)
    if entity.SubType == CoinSubType.COIN_PENNY then
        local basereplaceChance = 1
        local replaceChance = basereplaceChance
        --[[
        local playersWithCrypticPenny = getPlayers()
        if #playersWithCrypticPenny ~= 0 then
            for i=1,#playersWithCrypticPenny,1 do
                replaceChance = replaceChance + (2*playersWithCrypticPenny[i]:GetTrinketMultiplier(Isaac.GetTrinketIdByName("Cryptic Penny")))
            end
        end
        
        --print(chance .. " < " .. replaceChance)
        ]]
        local room = Game():GetRoom()
        local chance = Mod.Functions.RNG:RandomInt(room:GetAwardSeed(), 400)
        if chance < replaceChance then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, BotB.Enums.Pickups.SHITCOIN.SUBTYPE,entity.Position,entity.Velocity,entity)
            entity:Remove()
            --entity:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, BotB.Enums.Pickups.SHITCOIN.SUBTYPE)
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT,GIGA_PENNY.gigaPennyReplace,PickupVariant.PICKUP_COIN)