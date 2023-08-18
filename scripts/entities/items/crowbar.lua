local Mod = BotB
local CROWBAR = {}
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
	EID:addCollectible(Isaac.GetItemIdByName("Crowbar"), "Enemies above 80% of their maximum health take doubled damage.#+0.75 damage.")
end

local CrowbarBonus={
	DAMAGE=0.75
}

--Stats
function CROWBAR:onCache(player, cacheFlag)
	if not player:HasCollectible(Items.CROWBAR) then return end
	local Multiplier = player:GetCollectibleNum(Items.CROWBAR, false)
	if (cacheFlag&CacheFlag.CACHE_DAMAGE)==CacheFlag.CACHE_DAMAGE then
	  player.Damage=player.Damage+Multiplier*CrowbarBonus.DAMAGE
	end
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CROWBAR.onCache)

function CROWBAR:crowbarBonusDamage(entity,amt,flags,source,_)
    --is it not friendly and not a player
    --print("dicks")
    --print(source.Type)
    --print(flags & DamageFlag.DAMAGE_TIMER)
    if source.Entity ~= nil and source.Entity.SpawnerType == EntityType.ENTITY_PLAYER then
        --print("weenis")
            local player = source.Entity.SpawnerEntity:ToPlayer()
            if player ~= nil then
              if player:HasCollectible(Items.CROWBAR) then
                local Multiplier = player:GetCollectibleNum(Items.CROWBAR, false)
                local healthPercentage = entity.HitPoints/entity.MaxHitPoints
                --print(healthPercentage)
                if healthPercentage >= 0.8 then
                    sfx:Play(SoundEffect.SOUND_SCYTHE_BREAK,1.5,0,false,math.random(110, 120)/100)
                    local rubble = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.DARK_BALL_SMOKE_PARTICLE,0,entity.Position,Vector(0,0),entity)
                    local newamt = amt * (2*Multiplier)
                    entity:TakeDamage(newamt - amt, 0, EntityRef(entity), 0)
                    return true
                end
            end  
            end 
    end
  end
  Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CROWBAR.crowbarBonusDamage)