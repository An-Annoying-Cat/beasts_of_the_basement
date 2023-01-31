local Mod = BotB
sfx = SFXManager()
game = Game()
local SHITCOIN = {}
if EID then
    EID:addEntity(5, 69, 33, "Shitcoin", "#Spans 3 randomly-selected friendly and totally unique Dips. #Worth nothing monetarily, just like real life.")
    EID:addTrinket(Mod.Enums.Trinkets.CRYPTIC_PENNY, "Increases the chance for Pennies to be replaced with Shitcoins. #Shitcoins are worth nothing monetarily (just like real life), but spawn 3 random friendly Dips on pickup.")
end
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

function SHITCOIN:GetShitcoin(pickup,collider,_)
    local data = pickup:GetData()
    local sprite = pickup:GetSprite()
    --print(pickup.Type .. "," .. pickup.Variant .. "," .. pickup.SubType)
    if pickup.SubType ~= nil and pickup.SubType == Mod.Enums.Pickups.SHITCOIN.SUBTYPE and collider.Type == EntityType.ENTITY_PLAYER then
        sfx:Play(BotB.FF.Sounds.CursedPennyNegativeSuper,1,0,false,math.random(12000,14000)/10000)
        sfx:Play(BotB.FF.Sounds.FunnyFart,0.75,0,false,0.75)

        player = collider:ToPlayer()
        local dipSubTypesTable = {0,1,2,3,4,5,6,12,13,14,20,666,667,668,669,670,671,672}
        for i=0,2,1 do
            Isaac.Spawn(EntityType.ENTITY_FAMILIAR,FamiliarVariant.DIP,dipSubTypesTable[math.random(#dipSubTypesTable)],data.Collector.Position,Vector(5,0):Rotated(math.random(360)),player)
        end
        local hud = game:GetHUD()
        local shitcoinSecondaryStrings = {
            "Nice friendly turds",
            "Non-flushable toilet",
            "Worth jack shit",
            "No refunds!",
            "Freshly minted!",
            "Guaranteed fungi-free!",
            "No monetary value!"
        }
        hud:ShowItemText("Shitcoin!", shitcoinSecondaryStrings[math.random(#shitcoinSecondaryStrings)], false)
        --data.Collector:AddCoins(15)
        --TSIL.Players.AddSmeltedTrinket(collider:ToPlayer(),TrinketType.TRINKET_STORE_CREDIT

        pickup:Die()

        return false
    end
end

function SHITCOIN:ShitcoinUpdate(pickup)
    local data = pickup:GetData()
    local sprite = pickup:GetSprite()
    if data.Collector == nil then
        data.Collector = pickup
    end
    --print(pickup:GetCoinValue())
    if pickup.SubType ~= nil and pickup.SubType == Mod.Enums.Pickups.SHITCOIN.SUBTYPE then

        if sprite:IsEventTriggered("DropSound") then
            sfx:Play(SoundEffect.SOUND_DIMEDROP,1,0,false,math.random(800, 900)/1000)
        end
    end

end

Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION,SHITCOIN.GetShitcoin,PickupVariant.PICKUP_COIN)
Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE,SHITCOIN.ShitcoinUpdate,PickupVariant.PICKUP_COIN)





function SHITCOIN:shitcoinReplace(id, var, subtype, pos, vel, spawner, seed)
    if id == EntityType.ENTITY_PICKUP and var == PickupVariant.PICKUP_COIN and subtype == 0 then
        local basereplaceChance = 2
        local replaceChance = basereplaceChance
            replaceChance = replaceChance + (2*Mod.FF.getTrinketMultiplierAcrossAllPlayers(Mod.Enums.Trinkets.CRYPTIC_PENNY))
        local chance = Mod.Functions.RNG:RandomInt(seed, 100)
        --print(chance .. " < " .. replaceChance)
        if chance < replaceChance then
            return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, BotB.Enums.Pickups.SHITCOIN.SUBTYPE, seed}
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, SHITCOIN.shitcoinReplace)