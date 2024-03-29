local Mod = BotB
local TECH_NANO = {}
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
	EID:addCollectible(Isaac.GetItemIdByName("Tech Nano"), "Tears have a luck-based chance to contain nanobots, granting them aggressive homing and a lingering plus-shape of Technology beams upon their destruction.#Chance starts at 12.5% at 0 luck, and reaches 100% at 21 luck.")
end



function TECH_NANO:techNanoFireTear(tear)
    --print("tear!")
    if tear.SpawnerEntity.Type == EntityType.ENTITY_PLAYER then
        local tearPlayer = tear.SpawnerEntity:ToPlayer()
        tear:GetData().techNanoPlayerParent = tearPlayer
        --print("player tear!")
        if tearPlayer:HasCollectible(Items.TECH_NANO) then
            --print("player with tech nano tear!")
            local tearPlayerRNG = tearPlayer:GetCollectibleRNG(Items.TECH_NANO)
            local luckThreshold = 0.125 + (tearPlayer.Luck/24)
            if luckThreshold <= 0 then
                luckThreshold = 0.125
            end
            local techNanoRand = tearPlayerRNG:RandomFloat()
            --luckThreshold = 999
            --print(techNanoRand .. " , " .. luckThreshold)
            if techNanoRand <= luckThreshold then
                if tear.Variant ~= TearVariant.METALLIC then
                    tear.Variant = TearVariant.METALLIC 
                end
                tear:GetData().isATechNanoTear = true
            end
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR,TECH_NANO.techNanoFireTear)

function TECH_NANO:techNanoTearUpdate(tear)
    if tear:GetData().isATechNanoTear then
        local data = tear:GetData()
        if tear:HasTearFlags(TearFlags.TEAR_HOMING) ~= true then
            tear:AddTearFlags(TearFlags.TEAR_HOMING)
        end
        if tear:HasTearFlags(TearFlags.TEAR_PIERCING) then
            tear:ClearTearFlags(TearFlags.TEAR_PIERCING)
        end
        if tear:GetData().hasTechNanoAdjustments ~= true then
            tear.FallingAcceleration = -0.05
            tear.Color = Color(1,0.25,0.25)
            --tear.HomingFriction = 0.5
            tear:GetData().hasTechNanoAdjustments = true
        end
        local correctPos = tear.Position
        if tear:IsDead() then
            for i=0,270,90 do
                
                local techNanoLaser = EntityLaser.ShootAngle(2, correctPos, i, 45, Vector.Zero, tear.SpawnerEntity)
                techNanoLaser.DisableFollowParent = true
                techNanoLaser.Parent = tear.SpawnerEntity
                techNanoLaser:GetData().isATechNanoLaser = true
                techNanoLaser:GetData().techNanoLaserPos = correctPos
                techNanoLaser:GetData().techNanoParent = tear.SpawnerEntity
                techNanoLaser:SetActiveRotation(0, i+1440, 16, false)
                techNanoLaser.Timeout = 60
                techNanoLaser:SetMaxDistance(32.5)
                techNanoLaser:AddTearFlags(tear:GetData().techNanoPlayerParent.TearFlags | TearFlags.TEAR_SPECTRAL)
                techNanoLaser.CollisionDamage = tear:GetData().techNanoPlayerParent.Damage/5
            end
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE,TECH_NANO.techNanoTearUpdate)




function TECH_NANO:techNanoTearCollision(tear,_,_)
    if tear:GetData().isATechNanoTear then
        if tear.Parent:ToPlayer() ~= nil and tear.Parent:ToPlayer():HasWeaponType(WeaponType.WEAPON_FETUS) then return end
        local correctPos = tear.Position
        for i=0,270,90 do
            local techNanoLaser = EntityLaser.ShootAngle(2, correctPos, i, 45, Vector.Zero, tear.SpawnerEntity)
            techNanoLaser.DisableFollowParent = true
            techNanoLaser.Parent = tear.SpawnerEntity
            techNanoLaser:GetData().isATechNanoLaser = true
            techNanoLaser:GetData().techNanoLaserPos = correctPos
            techNanoLaser:GetData().techNanoParent = tear.SpawnerEntity
            techNanoLaser:SetActiveRotation(0, i+1440, 16, false)
            techNanoLaser.Timeout = 60
            techNanoLaser:SetMaxDistance(32.5)
            techNanoLaser:AddTearFlags(tear:GetData().techNanoPlayerParent.TearFlags | TearFlags.TEAR_SPECTRAL)
            techNanoLaser.CollisionDamage = tear:GetData().techNanoPlayerParent.Damage/5
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION,TECH_NANO.techNanoTearCollision)

function TECH_NANO:techNanoLaserUpdate(laser)
    if laser:GetData().isATechNanoLaser then
        laser.Position = laser:GetData().techNanoLaserPos
        --laser.AngleDegrees = laser.AngleDegrees + 8
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE,TECH_NANO.techNanoLaserUpdate)


--now to give it a synergy with dr fetus and epic fetus...
function TECH_NANO:techNanoBombUpdate(bomb)
    --print(bomb.FrameCount)
    if bomb.FrameCount ~= 1 then return end
    if bomb.IsFetus ~= true then return end
    if bomb.Parent:ToPlayer() ~= nil then
        local player = bomb.Parent:ToPlayer()
        if not player:HasCollectible(Items.TECH_NANO) then return end
        local tearPlayerRNG = player:GetCollectibleRNG(Items.TECH_NANO)
        local luckThreshold = 0.125 + (player.Luck/24)
        if luckThreshold <= 0 then
            luckThreshold = 0.125
        end
        local techNanoRand = tearPlayerRNG:RandomFloat()
        if techNanoRand <= luckThreshold then
            --tech nano time!
            bomb:AddTearFlags(TearFlags.TEAR_HOMING)
            bomb:GetData().isTechNanoFetusBomb = true
            bomb:GetData().techNanoFetusBombPlayer = player
        end
    end

end
Mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE,TECH_NANO.techNanoBombUpdate)
--[[
function TECH_NANO:techNanoBombUpdate2(bomb)
    print(bomb.FrameCount)
    if bomb.FrameCount ~= 1 then return end
    if bomb.IsFetus ~= true then return end
    if bomb.Parent:ToPlayer() ~= nil then
        local player = bomb.Parent:ToPlayer()
        if not player:HasCollectible(Items.TECH_NANO) then return end
        local tearPlayerRNG = player:GetCollectibleRNG(Items.TECH_NANO)
        local luckThreshold = 0.125 + (player.Luck/24)
        if luckThreshold <= 0 then
            luckThreshold = 0.125
        end
        local techNanoRand = tearPlayerRNG:RandomFloat()
        if techNanoRand <= luckThreshold then
            --tech nano time!
            bomb:GetData().isTechNanoFetusBomb = true
        end
    end

end
Mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE,TECH_NANO.techNanoBombUpdate2)]]



function TECH_NANO:techNanoBombCheck(entity) 
    --print(entity.Type, entity.Variant, entity.SubType)
    if entity.Type ~= 4 then 
        --epic fetus checking
        if entity.Type == EntityType.ENTITY_EFFECT and entity.Variant == EffectVariant.ROCKET then
            if entity.SpawnerEntity ~= nil and entity.SpawnerEntity:ToPlayer() ~= nil then
                local player = entity.SpawnerEntity:ToPlayer()
                if not player:HasCollectible(Items.TECH_NANO) then return end
                for i=0,270,90 do
                    local techNanoLaser = EntityLaser.ShootAngle(2, entity.Position, i, 45, Vector.Zero, player)
                    techNanoLaser.DisableFollowParent = true
                    techNanoLaser.Parent = player
                    techNanoLaser:GetData().isATechNanoLaser = true
                    techNanoLaser:GetData().techNanoLaserPos = entity.Position
                    techNanoLaser:GetData().techNanoParent = player
                    techNanoLaser:SetActiveRotation(0, i+1440, 16, false)
                    techNanoLaser.Timeout = 60
                    techNanoLaser:SetMaxDistance(65)
                    techNanoLaser:AddTearFlags(player.TearFlags | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_BOOMERANG)
                    techNanoLaser.CollisionDamage = player.Damage/5
                end
            end
        end
    else
        if entity:GetData().isTechNanoFetusBomb ~= true then return end
        local player = entity:GetData().techNanoFetusBombPlayer
        for i=0,270,90 do
            local techNanoLaser = EntityLaser.ShootAngle(2, entity.Position, i, 45, Vector.Zero, player)
            techNanoLaser.DisableFollowParent = true
            techNanoLaser.Parent = player
            techNanoLaser:GetData().isATechNanoLaser = true
            techNanoLaser:GetData().techNanoLaserPos = entity.Position
            techNanoLaser:GetData().techNanoParent = player
            techNanoLaser:SetActiveRotation(0, i+1440, 16, false)
            techNanoLaser.Timeout = 60
            techNanoLaser:SetMaxDistance(32.5)
            techNanoLaser:AddTearFlags(player.TearFlags | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_BOOMERANG)
            techNanoLaser.CollisionDamage = player.Damage/5
        end
    end
    
end
Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, TECH_NANO.techNanoBombCheck)


function TECH_NANO:techNanoDamageNull(entity,amt,flags,source,_)
    local src = source.Entity
    --is it not friendly and not a player
    --print("dicks")
    --print(source.Type)
    --print(flags & DamageFlag.DAMAGE_TIMER)
    --local sdata = source.Entity:GetData()

    --mom's knife, ludo, dr. fetus have parent
    --technology, brimstone is direct to player
    --epic fetus and also ludo for some reason use spawner
    --spirit sword is direct to player
    --c section is parent and spawner
    --fetus whip is nil source for some reason?
    if src ~= nil and src:GetData().isATechNanoLaser == false then
        --print(src.Type, src.Variant, src.SubType)
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
            if not player:HasCollectible(Items.TECH_NANO) then return end
            if player:HasWeaponType(WeaponType.WEAPON_TEARS) then return end
            if player:HasWeaponType(WeaponType.WEAPON_FETUS) then return end
            
            --use the same luck formula
            local tearPlayerRNG = player:GetCollectibleRNG(Items.TECH_NANO)
            local luckThreshold = 0.125 + (player.Luck/24)
            if luckThreshold <= 0 then
                luckThreshold = 0.125
            end
            local techNanoRand = tearPlayerRNG:RandomFloat()
            if techNanoRand <= luckThreshold then
                --tech nano time!
                for i=0,270,90 do
                    local techNanoLaser = EntityLaser.ShootAngle(2, entity.Position, i, 45, Vector.Zero, player)
                    techNanoLaser.DisableFollowParent = true
                    techNanoLaser.Parent = player
                    techNanoLaser:GetData().isATechNanoLaser = true
                    techNanoLaser:GetData().techNanoLaserPos = entity.Position
                    techNanoLaser:GetData().techNanoParent = player
                    techNanoLaser:SetActiveRotation(0, i+1440, 16, false)
                    techNanoLaser.Timeout = 60
                    techNanoLaser:SetMaxDistance(32.5)
                    techNanoLaser:AddTearFlags(player.TearFlags | TearFlags.TEAR_SPECTRAL)
                    techNanoLaser.CollisionDamage = player.Damage/5
                end
            end
        end
    end
    
    if src ~= nil then
        if source.Entity ~= nil and source.Type == EntityType.ENTITY_LASER and src:GetData().isATechNanoLaser then
            if EntityRef(entity).IsFriendly or entity.Type == EntityType.ENTITY_PLAYER or entity.Type == EntityType.ENTITY_FAMILIAR then
                return false
            end
        end
    end
    
    
        
end
  Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, TECH_NANO.techNanoDamageNull)