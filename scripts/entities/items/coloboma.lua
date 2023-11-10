local Mod = BotB
local COLOBOMA = {}
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
	EID:addCollectible(Isaac.GetItemIdByName("Coloboma"), "Your tears, while in movement, fire tears at the nearest enemy to them. #These tears inherit your stats and flags, and deal half of your {{Damage}} Damage stat. #Multiple stacks of this item increase the fire rate of your tears.")
end

function COLOBOMA:findNearestEnemy(from)

    local roomEntities = Isaac.GetRoomEntities() -- table
            local possibleTargets = {}
            local baselineLength = 9999999
            local toPos
            local bestCandidate = from
            --local bestCandidate = Entity()
            for i = 1, #roomEntities do
                local entity = roomEntities[i]
                --print(entity.Type, entity.Variant, entity.SubType)
                if entity:IsVulnerableEnemy() and not (entity.Type == BotB.Enums.Entities.CLAY_SOLDIER.TYPE and entity.Variant == BotB.Enums.Entities.CLAY_SOLDIER.VARIANT) and EntityRef(entity).IsFriendly == false then
                    if (entity.Position - from.Position):Length() < baselineLength then
                        baselineLength = (entity.Position - from.Position):Length()
                        bestCandidate = entity
                        --print(bestCandidate.Position)
                    end
                end
            end
            --toPos = bestCandidate.Position
    return bestCandidate
end

function COLOBOMA:colobomaFireTear(tear)
    ----print("tear!")
    if tear.SpawnerEntity.Type == EntityType.ENTITY_PLAYER then
        local tearPlayer = tear.SpawnerEntity:ToPlayer()
        tear:GetData().techNanoPlayerParent = tearPlayer
        ----print("player tear!")
        if tearPlayer:HasCollectible(Items.COLOBOMA) == true and tearPlayer:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) ~= true then
            ----print("player with tech nano tear!")
            local tearPlayerRNG = tearPlayer:GetCollectibleRNG(Items.COLOBOMA)
            local luckThreshold = 0.25 + (tearPlayer.Luck/24)
            if luckThreshold <= 0 then
                luckThreshold = 0.25
            end
            local techNanoRand = tearPlayerRNG:RandomFloat()
            --luckThreshold = 999
            ----print(techNanoRand .. " , " .. luckThreshold)
            if tear:GetData().botbIsImmuneToColoboma ~= true then
                tear:GetData().isAColobomaTurretTear = true
                tear:GetData().botbColobomaTearParent = tearPlayer:ToPlayer()
                if 9 - tearPlayer:GetCollectibleNum(Items.COLOBOMA, false) < 2 then
                    tear:GetData().botbColobomaDelay = 2
                    tearPlayer:GetData().botbColobomaDelay = 2
                else
                    tear:GetData().botbColobomaDelay = 8 - tearPlayer:GetCollectibleNum(Items.COLOBOMA, false)
                    tearPlayer:GetData().botbColobomaDelay = 8 - tearPlayer:GetCollectibleNum(Items.COLOBOMA, false)
                end
                
            end
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR,COLOBOMA.colobomaFireTear)

function COLOBOMA:rabiesTearUpdate(tear)

   
    if tear:GetData().isAColobomaTurretTear then
        local data = tear:GetData()
        if tear:GetData().hasColobomaAdjustments ~= true then
            tear.FallingAcceleration = -0.05
            --tear.Color = Color(1,1,1)
            --tear.HomingFriction = 0.5
            tear:GetData().hasColobomaAdjustments = true
        end
        local correctPos = tear.Position
        if tear:IsDead() then
            --rabies
        end
        if tear.FrameCount % data.botbColobomaDelay == 0 then
            --print("fire!")
            --(targetpos - npc.Position):GetAngleDegrees()
            local colobomaShouldFire = true
            local colobomaFiringAngle = (COLOBOMA:findNearestEnemy(tear).Position - tear.Position):GetAngleDegrees()
            if colobomaFiringAngle == 0 then
                colobomaShouldFire = false
            end
            if colobomaShouldFire == true then
                local colobomaFiringAngle = (COLOBOMA:findNearestEnemy(tear).Position - tear.Position):GetAngleDegrees()
                local colobomaRecursiveTear = data.botbColobomaTearParent:FireTear(tear.Position, Vector(10*data.botbColobomaTearParent.ShotSpeed,0):Rotated(colobomaFiringAngle), true, true, false, data.botbColobomaTearParent, 0.5):ToTear()
                --print("logic point 2")
                --colobomaRecursiveTear:GetData().botbIsImmuneToColoboma = true
                colobomaRecursiveTear:GetData().isAColobomaTurretTear = false
                colobomaRecursiveTear.TearFlags = tear.TearFlags
                colobomaRecursiveTear:ClearTearFlags(TearFlags.TEAR_LUDOVICO)
                for key, value in pairs(tear:GetData()) do
                    if key ~= "isAColobomaTurretTear" then
                        colobomaRecursiveTear:GetData()[key] = value
                    end
                end
                colobomaRecursiveTear:GetData().isAColobomaTurretTear = false
            end
        end
        
        
    end
    

    
end
Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE,COLOBOMA.rabiesTearUpdate)




function COLOBOMA:colobomaTearCollision(tear,_,_)
    if tear:GetData().isAColobomaTurretTear then
        if tear.Parent:ToPlayer() ~= nil and tear.Parent:ToPlayer():HasWeaponType(WeaponType.WEAPON_FETUS) then return end
        local correctPos = tear.Position
        --rabies
    end
end
Mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION,COLOBOMA.colobomaTearCollision)

function COLOBOMA:colobomaLaserUpdate(laser)
    --print(laser.Parent.Type,laser.SpawnerEntity.Type)
    if laser.Parent ~= nil and laser.Parent:ToPlayer() ~= nil and laser.Parent:ToPlayer():HasCollectible(Items.COLOBOMA) then
        laser.Color = Color(1,1,1,1,0.5,1,0)
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE,COLOBOMA.colobomaLaserUpdate)


--now to give it a synergy with dr fetus and epic fetus...
function COLOBOMA:colobomaBombUpdate(bomb)
    ----print(bomb.FrameCount)
    if bomb.FrameCount ~= 1 then return end
    if bomb.IsFetus ~= true then return end
    if bomb.Parent:ToPlayer() ~= nil then
        local player = bomb.Parent:ToPlayer()
        if not player:HasCollectible(Items.COLOBOMA) then return end
        local tearPlayerRNG = player:GetCollectibleRNG(Items.COLOBOMA)
        local luckThreshold = 0.25 + (player.Luck/24)
        if luckThreshold <= 0 then
            luckThreshold = 0.25
        end
        local techNanoRand = tearPlayerRNG:RandomFloat()
        if techNanoRand <= luckThreshold then
            --tech nano time!
            --bomb:AddTearFlags(TearFlags.TEAR_HOMING)
            bomb:GetData().isColobomaFetusBomb = true
            bomb:GetData().colobomaFetusBombPlayer = player
        end
    end

end
Mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE,COLOBOMA.colobomaBombUpdate)
--[[
function COLOBOMA:colobomaBombUpdate2(bomb)
    --print(bomb.FrameCount)
    if bomb.FrameCount ~= 1 then return end
    if bomb.IsFetus ~= true then return end
    if bomb.Parent:ToPlayer() ~= nil then
        local player = bomb.Parent:ToPlayer()
        if not player:HasCollectible(Items.COLOBOMA) then return end
        local tearPlayerRNG = player:GetCollectibleRNG(Items.COLOBOMA)
        local luckThreshold = 0.125 + (player.Luck/24)
        if luckThreshold <= 0 then
            luckThreshold = 0.125
        end
        local techNanoRand = tearPlayerRNG:RandomFloat()
        if techNanoRand <= luckThreshold then
            --tech nano time!
            bomb:GetData().isColobomaFetusBomb = true
        end
    end

end
Mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE,COLOBOMA.colobomaBombUpdate2)]]



function COLOBOMA:colobomaBombCheck(bomb) 
    ----print(entity.Type, entity.Variant, entity.SubType)
    if bomb.Type ~= 4 then 
        --epic fetus checking
        if bomb.Type == EntityType.ENTITY_EFFECT and bomb.Variant == EffectVariant.ROCKET then
            if bomb.SpawnerEntity ~= nil and bomb.SpawnerEntity:ToPlayer() ~= nil then
                local player = bomb.SpawnerEntity:ToPlayer()
                if not player:HasCollectible(Items.COLOBOMA) then return end
                


            end
        end
    else
        if bomb:GetData().isColobomaFetusBomb ~= true then return end
        local player = bomb:GetData().colobomaFetusBombPlayer:ToPlayer()
        --rabies
        
    end
    
end
Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, COLOBOMA.colobomaBombCheck)

--[[
function COLOBOMA:rabiesDamageNull(entity,amt,flags,source,_)
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
            if not player:HasCollectible(Items.COLOBOMA) then return end
            if player:HasWeaponType(WeaponType.WEAPON_TEARS) then return end
            if player:HasWeaponType(WeaponType.WEAPON_FETUS) then return end
            
            --use the same luck formula
            local tearPlayerRNG = player:GetCollectibleRNG(Items.COLOBOMA)
            local luckThreshold = 0.25 + (player.Luck/24)
            if luckThreshold <= 0 then
                luckThreshold = 0.25
            end
            local techNanoRand = tearPlayerRNG:RandomFloat()
            if techNanoRand <= luckThreshold then
                --rabies
                

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
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, COLOBOMA.rabiesDamageNull)]]

--[[
function COLOBOMA:rabiesAddStatus(entity,amt,flags,source,_)
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
    if src ~= nil and src:GetData().isAColobomaTurretTear == true then
        ----print(src.Type, src.Variant, src.SubType)
        local player
        if src:ToPlayer() ~= nil then
            player = src:ToPlayer()
        elseif src.Parent:ToPlayer() ~= nil then
            player = src.Parent:ToPlayer()
        elseif src.SpawnerEntity:ToPlayer() ~= nil then
            player = src.SpawnerEntity:ToPlayer()
        end


        local data = entity:GetData()
        if data.botbHasGlitched ~= true then
            
        else
            
        end
    end
        
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, COLOBOMA.rabiesAddStatus)]]






function COLOBOMA:rabiesNPCUpdate(npc)
    local data = npc:GetData()
    if data.botbHasGlitched == true then
        if data.botbGlitchedIndicator == nil or data.botbGlitchedIndicator:IsDead() then
            data.botbGlitchedIndicator = Isaac.Spawn(Entities.BOTB_STATUS_EFFECT.TYPE,Entities.BOTB_STATUS_EFFECT.VARIANT,0,npc.Position,Vector.Zero, npc):ToEffect()
            data.botbGlitchedIndicator.Parent = npc
            --data.botbGlitchedIndicator.ParentOffset = Vector(0,-(npc.SpriteScale.Y * 70))
            data.botbGlitchedIndicator:GetSprite():Play("Glitched", true)
        end
        

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, COLOBOMA.rabiesNPCUpdate)
