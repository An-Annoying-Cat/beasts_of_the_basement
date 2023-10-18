local Mod = BotB
local DADS_PANTS = {}
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
	EID:addCollectible(Isaac.GetItemIdByName("Dad's Pants"), "Heals 1 Heart on pickup. #Firing tears has a chance to spawn an attack ant, up to 5. #{{Warning}} This limit is increased to 10 if the player also has Hive Mind.")
end



function DADS_PANTS:dadsPantsFireTear(tear)
    ----print("tear!")
    if tear.SpawnerEntity.Type == EntityType.ENTITY_PLAYER then
        local tearPlayer = tear.SpawnerEntity:ToPlayer()
        tear:GetData().techNanoPlayerParent = tearPlayer
        ----print("player tear!")
        if tearPlayer:HasCollectible(Items.DADS_PANTS) then
            ----print("player with tech nano tear!")
            local tearPlayerRNG = tearPlayer:GetCollectibleRNG(Items.DADS_PANTS)
            local luckThreshold = 1/(20-(2*tearPlayer.Luck))
            if luckThreshold <= 0 then
                luckThreshold = 0.25
            end
            local techNanoRand = tearPlayerRNG:RandomFloat()
            --print(techNanoRand, " vs. ", luckThreshold)
            --luckThreshold = 999
            ----print(techNanoRand .. " , " .. luckThreshold)
            if techNanoRand <= luckThreshold then
                if tearPlayer:HasCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND) then
                    if Isaac.CountEntities(tearPlayer, BotB.Enums.Entities.ATTACK_ANT_ENEMY.TYPE, BotB.Enums.Entities.ATTACK_ANT_ENEMY.VARIANT, 0) + Isaac.CountEntities(tearPlayer, BotB.Enums.Familiars.ATTACK_ANT.TYPE,  BotB.Enums.Familiars.ATTACK_ANT.TYPE, 0) < 10 then
                        --spawn ant
                        Isaac.Spawn(BotB.Enums.Entities.ATTACK_ANT_ENEMY.TYPE, BotB.Enums.Entities.ATTACK_ANT_ENEMY.VARIANT, 0, tearPlayer.Position, Vector(2,0):Rotated(math.random(0,359)), tearPlayer):ToNPC()
                    end
                else
                    if Isaac.CountEntities(tearPlayer, BotB.Enums.Entities.ATTACK_ANT_ENEMY.TYPE, BotB.Enums.Entities.ATTACK_ANT_ENEMY.VARIANT, 0) + Isaac.CountEntities(tearPlayer, BotB.Enums.Familiars.ATTACK_ANT.TYPE,  BotB.Enums.Familiars.ATTACK_ANT.TYPE, 0) < 5 then
                        --spawn ant
                        Isaac.Spawn(BotB.Enums.Entities.ATTACK_ANT_ENEMY.TYPE, BotB.Enums.Entities.ATTACK_ANT_ENEMY.VARIANT, 0, tearPlayer.Position, Vector(2,0):Rotated(math.random(0,359)), tearPlayer):ToNPC()
                    end
                end
            end
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR,DADS_PANTS.dadsPantsFireTear)

function DADS_PANTS:dadsPantsDamageNull(entity,amt,flags,source,_)
    local src = source.Entity
    --is it not friendly and not a player
    ----print("dicks")
    ----print(source.Type)
    ----print(flags & DamageFlag.DAMAGE_TIMER)
    --local sdata = source.Entity:GetData()

    --mom's knife, ludo, dr. fetus have parent
    --technology, brimstone is direct to player
    --epic fetus and also ludo for some reason use spawner
    --spirit sword is direct to player
    --c section is parent and spawner
    --fetus whip is nil source for some reason?
    if src ~= nil and src:GetData().isATechNanoLaser == false then
        ----print(src.Type, src.Variant, src.SubType)
        local player
        if src:ToPlayer() ~= nil then
            player = src:ToPlayer()
        elseif src.Parent:ToPlayer() ~= nil then
            player = src.Parent:ToPlayer()
        elseif src.SpawnerEntity:ToPlayer() ~= nil then
            player = src.SpawnerEntity:ToPlayer()
        end
        --only if player is not using tears
        if player ~= nil then
            if not player:HasCollectible(Items.DADS_PANTS) then return end
            if player:HasWeaponType(WeaponType.WEAPON_TEARS) then return end
            if player:HasWeaponType(WeaponType.WEAPON_FETUS) then return end
            
            --use the same luck formula
            local tearPlayerRNG = player:GetCollectibleRNG(Items.DADS_PANTS)
            local luckThreshold = 1/(20-(2*player.Luck))
            if luckThreshold <= 0 then
                luckThreshold = 0.25
            end
            local techNanoRand = tearPlayerRNG:RandomFloat()
            if techNanoRand <= luckThreshold then
                --rabies
                if player:HasCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND) then
                    if Isaac.CountEntities(player, BotB.Enums.Entities.ATTACK_ANT_ENEMY.TYPE, BotB.Enums.Entities.ATTACK_ANT_ENEMY.VARIANT, 0) + Isaac.CountEntities(player, BotB.Enums.Familiars.ATTACK_ANT.TYPE,  BotB.Enums.Familiars.ATTACK_ANT.TYPE, 0) < 10 then
                        --spawn ant
                        Isaac.Spawn(BotB.Enums.Entities.ATTACK_ANT_ENEMY.TYPE, BotB.Enums.Entities.ATTACK_ANT_ENEMY.VARIANT, 0, player.Position, Vector(2,0):Rotated(math.random(0,359)), player):ToNPC()
                    end
                else
                    if Isaac.CountEntities(player, BotB.Enums.Entities.ATTACK_ANT_ENEMY.TYPE, BotB.Enums.Entities.ATTACK_ANT_ENEMY.VARIANT, 0) + Isaac.CountEntities(player, BotB.Enums.Familiars.ATTACK_ANT.TYPE,  BotB.Enums.Familiars.ATTACK_ANT.TYPE, 0) < 5 then
                        --spawn ant
                        Isaac.Spawn(BotB.Enums.Entities.ATTACK_ANT_ENEMY.TYPE, BotB.Enums.Entities.ATTACK_ANT_ENEMY.VARIANT, 0, player.Position, Vector(2,0):Rotated(math.random(0,359)), player):ToNPC()
                    end
                end
            end
        end
    end
    
    
        
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, DADS_PANTS.dadsPantsDamageNull)



