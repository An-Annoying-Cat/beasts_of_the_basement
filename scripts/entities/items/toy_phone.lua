local Mod = BotB
local mod = FiendFolio
local TOY_PHONE = {}
local pickups = BotB.Enums.Pickups
local sfx = SFXManager()
local Items = BotB.Enums.Items

local PhoneBonus = {
	TEAR=0.4,
	SPEED=0.2,
	LUCK=2,
	RANGE=30,
	DAMAGE=1.25,
}
local HiddenItemManager = require("scripts.core.hidden_item_manager")
if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Toy Phone"), "Simulates the press of a Reward Plate. #Has a 0.25% chance to change to a special version on use. #Might cause a strange illusion to appear... #(It will dissappear upon reentering a room and is entirely harmless.)")
    EID:addCollectible(Isaac.GetItemIdByName("Toy Phone?"), "Major all stats up. #Permanent Curse of Darkness and Curse of the Stalked. #Turns back into Toy Phone.")
end

function TOY_PHONE:toyPhoneActiveItem(_, _, player, _, slot, _)
	player:AnimateCollectible(Isaac.GetItemIdByName("Toy Phone"))
    local doSpook = math.random(1,100)
    --print(doSpook)
    if math.random(doSpook) == 1 then
        MusicManager():Fadeout(0.08)
        player:RemoveCollectible(Items.TOY_PHONE)
        player:AddCollectible(Items.TOY_PHONE_ALT, 0, false, slot)
    else
        -->:)
        local plate = Isaac.GridSpawn(GridEntityType.GRID_PRESSURE_PLATE, 1, Isaac.GetFreeNearPosition(player.Position, 1), true):ToPressurePlate()
        plate.CollisionClass = GridCollisionClass.COLLISION_NONE
        FiendFolio.scheduleForUpdate(function()
            plate:Reward()
            TSIL.GridEntities.RemoveGridEntity(plate, true)
        end, 1, ModCallbacks.MC_POST_RENDER)
        
    end
	
end
Mod:AddCallback(ModCallbacks.MC_USE_ITEM,TOY_PHONE.toyPhoneActiveItem,Isaac.GetItemIdByName("Toy Phone"))

function TOY_PHONE:toyPhoneAltActiveItem(_, _, player, _, slot, _)
    player:AnimateCollectible(Isaac.GetItemIdByName("Toy Phone?"))
    if player:GetData().spookedByToyPhone ~= true then
        player:GetData().spookedByToyPhone = true
    end
    Game():Darken(1.0, 99999)
    HiddenItemManager:Add(player, BotB.Enums.Items.TOY_PHONE_DUMMY, 0, 1)
    local level = Game():GetLevel()
    
    player:RemoveCollectible(Items.TOY_PHONE_ALT)
    player:AddCollectible(Items.TOY_PHONE, 0, false, slot)
end
Mod:AddCallback(ModCallbacks.MC_USE_ITEM,TOY_PHONE.toyPhoneAltActiveItem,Isaac.GetItemIdByName("Toy Phone?"))

function TOY_PHONE:onCache(player, cacheFlag)
	if not player:HasCollectible(Items.TOY_PHONE_DUMMY) then return end
	local Multiplier = player:GetCollectibleNum(Items.TOY_PHONE_DUMMY, false)
	if (cacheFlag&CacheFlag.CACHE_DAMAGE)==CacheFlag.CACHE_DAMAGE then
	  player.Damage=player.Damage+Multiplier*PhoneBonus.DAMAGE
	end
	if (cacheFlag&CacheFlag.CACHE_FIREDELAY)==CacheFlag.CACHE_FIREDELAY then
	  local tps=30.0/(player.MaxFireDelay+1.0)
	  player.MaxFireDelay=30.0/(math.max(0.1,tps+Multiplier*PhoneBonus.TEAR))-1
	end
	if (cacheFlag&CacheFlag.CACHE_RANGE)==CacheFlag.CACHE_RANGE then
	  player.TearRange=player.TearRange+Multiplier*PhoneBonus.RANGE
	end
	if (cacheFlag&CacheFlag.CACHE_SPEED)==CacheFlag.CACHE_SPEED then
	  player.MoveSpeed=player.MoveSpeed+Multiplier*PhoneBonus.SPEED
	end
	if (cacheFlag&CacheFlag.CACHE_LUCK)==CacheFlag.CACHE_LUCK then
	  player.Luck=player.Luck+Multiplier*PhoneBonus.LUCK
	end
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, TOY_PHONE.onCache)



function TOY_PHONE:playerUpdate(player)
    if player:GetData().spookedByToyPhone ~= true then return end
    local level = Game():GetLevel()
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
        if player.FrameCount % 99999 == 0 then
            Game():Darken(1.0, 99999)
        end
        
    end
        
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, TOY_PHONE.playerUpdate)