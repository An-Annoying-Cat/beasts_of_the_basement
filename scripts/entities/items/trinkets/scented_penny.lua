
local mod = FiendFolio
local game = Game()
local Mod = BotB

--Functions stolen from Fiend Folio and slightly modified (thank you Ferrium)
--Functions stolen from retribution and slightly modified (thank you xal :)
function mod.GetSafeCoinValueFromSubType(subtype)
	if subtype == CoinSubType.COIN_DIME then
		return 10
	elseif subtype == CoinSubType.COIN_NICKEL or subtype == CoinSubType.COIN_STICKYNICKEL then
		return 5
	elseif subtype == CoinSubType.COIN_DOUBLEPACK then
		return 2
	else
		return 1
	end
end
function mod.GetSafeCoinValueFromSubTypeSpoils(subtype)
    local assumedSub = subtype % 64
	if assumedSub == 2 then
		return 1
    else
        return assumedSub
    end
end


-------------------------------
--Implementation code
local blacklistedSubtypes = {
    [CoinSubType.COIN_STICKYNICKEL] = true
}

function Mod:triggerPennyPickup(player, pickup, value)
    if pickup.Variant == 20 and blacklistedSubtypes[pickup.SubType] then return end
    if not value then
        if pickup.Variant == 20 then --Default penny
            value = mod.GetSafeCoinValueFromSubType(pickup.SubType)
        elseif pickup.Variant == 1875 then --Spoils penny
            value = mod.GetSafeCoinValueFromSubTypeSpoils(pickup.SubType)
        --[[elseif pickup.Variant == 1876 then
            value = math.max(1, pickup.SubType)]]
        else
            value = 1
        end
    end

    Mod:pennyPickupScented(player, pickup, value)
end

Mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.LATE, function(_, pickup, opp)
	--print(pickup.SubType, pickup.Touched)
    if not pickup.Touched then --Maybe causes issues?
        if pickup.SubType <= CoinSubType.COIN_GOLDEN then
            if opp:ToPlayer() then
                local player = opp:ToPlayer()
                Mod:triggerPennyPickup(player, pickup)
            end
        end
    end
end, 20)

--Uncommented, not intended to trigger
--[[mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.EARLY, function(_, pickup, opp)
    --print(pickup.SubType, pickup.Touched)
    if opp:ToPlayer() then
        local player = opp:ToPlayer()
        mod:triggerPennyPickup(player, pickup)
    end
end, 1875)]]

if EID then
	EID:addTrinket(Isaac.GetTrinketIdByName("Scented Penny"), "Spawns a friendly blue ant upon picking up a coin.")
    EID:addTrinket(Isaac.GetTrinketIdByName("Scented Penny")+TrinketType.TRINKET_GOLDEN_FLAG, "Spawns {{ColorRainbow}}2{{ColorReset}} friendly blue ants upon picking up a coin.")
end

--Other funcs
function Mod:pennyPickupScented(player, pickup, value)
    if FiendFolio.anyPlayerHas(BotB.Enums.Trinkets.SCENTED_PENNY, true) then
        local amount = FiendFolio.getTrinketMultiplierAcrossAllPlayers(BotB.Enums.Trinkets.SCENTED_PENNY)
        for i=1, amount do
            local ant = Isaac.Spawn(BotB.Enums.Entities.ATTACK_ANT_ENEMY.TYPE, BotB.Enums.Entities.ATTACK_ANT_ENEMY.VARIANT, 0, player.Position, Vector(6,0):Rotated(math.random(0,359)), player):ToNPC()
            ant:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        end
    end
end
