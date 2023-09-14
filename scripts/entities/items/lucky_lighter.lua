local Mod = BotB
local LUCKY_LIGHTER = {}
local Entities = BotB.Enums.Entities
local Items = BotB.Enums.Items


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


if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Lucky Lighter"), "Tears have a luck-based chance to ignite enemies on hit for your base damage.#Fire can spread from unignited enemies to ignited ones, dealing half your base damage. #If the tear does not end up hitting an enemy, it leaves a damaging fire on the ground.#{{Luck}} Luck + 2.")
end



function LUCKY_LIGHTER:luckyLighterFireTear(tear)
    --print("tear!")
    if tear.SpawnerEntity.Type == EntityType.ENTITY_PLAYER or (tear.SpawnerEntity.Type == EntityType.ENTITY_FAMILIAR and tear.SpawnerEntity.Variant == FamiliarVariant.INCUBUS) then
        local tearPlayer = tear.SpawnerEntity:ToPlayer()
        tear:GetData().techNanoPlayerParent = tearPlayer
        --print("player tear!")
        if tearPlayer:HasCollectible(Items.LUCKY_LIGHTER) then
            --print("player with tech nano tear!")
            local tearPlayerRNG = tearPlayer:GetCollectibleRNG(Items.LUCKY_LIGHTER)
            local luckThreshold = 0.125 + (tearPlayer.Luck/24)
            if luckThreshold <= 0 then
                luckThreshold = 0.125
            end
            local luckyLighterRand = tearPlayerRNG:RandomFloat()
            --luckThreshold = 999
            --print(luckyLighterRand .. " , " .. luckThreshold)
            if luckyLighterRand <= luckThreshold then
                tear:GetData().isALuckyLighterTear = true
            end
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR,LUCKY_LIGHTER.luckyLighterFireTear)

function LUCKY_LIGHTER:luckyLighterTearUpdate(tear)
    if tear:GetData().isALuckyLighterTear then
        local data = tear:GetData()
        local tearOrigin = tear.SpawnerEntity
        local correctPos = tear.Position

        if tear:GetData().hasLuckyLighterAdjustments ~= true then
            tear.Color = Color(1,0.5,0.25)
            --tear.HomingFriction = 0.5
            tear:GetData().hasLuckyLighterAdjustments = true
        end

        if tear:IsDead() then
            --Spawn the fire
            local luckyLighterTearFire = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.RED_CANDLE_FLAME,0,correctPos,Vector.Zero,tearOrigin):ToEffect()
            luckyLighterTearFire:SetTimeout(48);
            luckyLighterTearFire.CollisionDamage = tearOrigin:ToPlayer().Damage/4
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE,LUCKY_LIGHTER.luckyLighterTearUpdate)



local luckyLighterBonus={
	LUCK=2,
}


function LUCKY_LIGHTER:onCache(player, cacheFlag)
	if not player:HasCollectible(Items.LUCKY_LIGHTER) then return end
	local Multiplier = player:GetCollectibleNum(Items.LUCKY_LIGHTER, false)
	if (cacheFlag&CacheFlag.CACHE_LUCK)==CacheFlag.CACHE_LUCK then
	  player.Luck=player.Luck+Multiplier*luckyLighterBonus.LUCK
	end
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, LUCKY_LIGHTER.onCache)



function LUCKY_LIGHTER:addTheBurn(npc, _, _, source, _)
    --print("sharb")
    if npc:IsVulnerableEnemy() and not npc:HasEntityFlags(EntityFlag.FLAG_BURN) and source.Entity ~= nil and source.Entity:GetData().isALuckyLighterTear then 
        npc:GetData().botbLuckyLighterBurnDamage = (source.Entity.SpawnerEntity:ToPlayer().Damage*0.75)
        npc:AddBurn(EntityRef(source.Entity.SpawnerEntity), 103 , npc:GetData().botbLuckyLighterBurnDamage)
        --data should be able to correctly transmit now

    end
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, LUCKY_LIGHTER.addTheBurn)