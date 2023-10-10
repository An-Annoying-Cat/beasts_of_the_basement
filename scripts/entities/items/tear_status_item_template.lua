local Mod = BotB
local STRANGE_STARS = {}
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
	EID:addCollectible(Isaac.GetItemIdByName("Strange Stars"), "Your tears have a chance to apply {{StatusGlitched}} Glitched on hit. #{{StatusGlitched}} Glitched enemies are affected in a variety of different ways, of which the most common and basic is getting their AI temporarily canceled.")
end



function STRANGE_STARS:strangeStarsFireTear(tear)
    ----print("tear!")
    if tear.SpawnerEntity.Type == EntityType.ENTITY_PLAYER then
        local tearPlayer = tear.SpawnerEntity:ToPlayer()
        tear:GetData().techNanoPlayerParent = tearPlayer
        ----print("player tear!")
        if tearPlayer:HasCollectible(Items.STRANGE_STARS) then
            ----print("player with tech nano tear!")
            local tearPlayerRNG = tearPlayer:GetCollectibleRNG(Items.STRANGE_STARS)
            local luckThreshold = 0.25 + (tearPlayer.Luck/24)
            if luckThreshold <= 0 then
                luckThreshold = 0.25
            end
            local techNanoRand = tearPlayerRNG:RandomFloat()
            --luckThreshold = 999
            ----print(techNanoRand .. " , " .. luckThreshold)
            if techNanoRand <= luckThreshold then
                tear:GetData().isAStrangeStarsTear = true
            end
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR,STRANGE_STARS.strangeStarsFireTear)

function STRANGE_STARS:rabiesTearUpdate(tear)
    if tear:GetData().isAStrangeStarsTear then
        local data = tear:GetData()
        if tear:HasTearFlags(TearFlags.TEAR_HOMING) ~= true then
            tear:AddTearFlags(TearFlags.TEAR_HOMING)
        end
        if tear:HasTearFlags(TearFlags.TEAR_PIERCING) then
            tear:ClearTearFlags(TearFlags.TEAR_PIERCING)
        end
        if tear:GetData().hasStrangeStarsAdjustments ~= true then
            tear.FallingAcceleration = -0.05
            tear.Color = Color(1,1,0.25)
            --tear.HomingFriction = 0.5
            tear:GetData().hasStrangeStarsAdjustments = true
        end
        local correctPos = tear.Position
        if tear:IsDead() then
            --rabies
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE,STRANGE_STARS.rabiesTearUpdate)




function STRANGE_STARS:strangeStarsTearCollision(tear,_,_)
    if tear:GetData().isAStrangeStarsTear then
        if tear.Parent:ToPlayer() ~= nil and tear.Parent:ToPlayer():HasWeaponType(WeaponType.WEAPON_FETUS) then return end
        local correctPos = tear.Position
        --rabies
    end
end
Mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION,STRANGE_STARS.strangeStarsTearCollision)

function STRANGE_STARS:strangeStarsLaserUpdate(laser)
    --print(laser.Parent.Type,laser.SpawnerEntity.Type)
    if laser.Parent ~= nil and laser.Parent:ToPlayer() ~= nil and laser.Parent:ToPlayer():HasCollectible(Items.STRANGE_STARS) then
        laser.Color = Color(1,1,1,1,0.5,1,0)
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE,STRANGE_STARS.strangeStarsLaserUpdate)


--now to give it a synergy with dr fetus and epic fetus...
function STRANGE_STARS:strangeStarsBombUpdate(bomb)
    ----print(bomb.FrameCount)
    if bomb.FrameCount ~= 1 then return end
    if bomb.IsFetus ~= true then return end
    if bomb.Parent:ToPlayer() ~= nil then
        local player = bomb.Parent:ToPlayer()
        if not player:HasCollectible(Items.STRANGE_STARS) then return end
        local tearPlayerRNG = player:GetCollectibleRNG(Items.STRANGE_STARS)
        local luckThreshold = 0.25 + (player.Luck/24)
        if luckThreshold <= 0 then
            luckThreshold = 0.25
        end
        local techNanoRand = tearPlayerRNG:RandomFloat()
        if techNanoRand <= luckThreshold then
            --tech nano time!
            --bomb:AddTearFlags(TearFlags.TEAR_HOMING)
            bomb:GetData().isStrangeStarsFetusBomb = true
            bomb:GetData().strangeStarsFetusBombPlayer = player
        end
    end

end
Mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE,STRANGE_STARS.strangeStarsBombUpdate)
--[[
function STRANGE_STARS:strangeStarsBombUpdate2(bomb)
    --print(bomb.FrameCount)
    if bomb.FrameCount ~= 1 then return end
    if bomb.IsFetus ~= true then return end
    if bomb.Parent:ToPlayer() ~= nil then
        local player = bomb.Parent:ToPlayer()
        if not player:HasCollectible(Items.STRANGE_STARS) then return end
        local tearPlayerRNG = player:GetCollectibleRNG(Items.STRANGE_STARS)
        local luckThreshold = 0.125 + (player.Luck/24)
        if luckThreshold <= 0 then
            luckThreshold = 0.125
        end
        local techNanoRand = tearPlayerRNG:RandomFloat()
        if techNanoRand <= luckThreshold then
            --tech nano time!
            bomb:GetData().isStrangeStarsFetusBomb = true
        end
    end

end
Mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE,STRANGE_STARS.strangeStarsBombUpdate2)]]



function STRANGE_STARS:strangeStarsBombCheck(bomb) 
    ----print(entity.Type, entity.Variant, entity.SubType)
    if bomb.Type ~= 4 then 
        --epic fetus checking
        if bomb.Type == EntityType.ENTITY_EFFECT and bomb.Variant == EffectVariant.ROCKET then
            if bomb.SpawnerEntity ~= nil and bomb.SpawnerEntity:ToPlayer() ~= nil then
                local player = bomb.SpawnerEntity:ToPlayer()
                if not player:HasCollectible(Items.STRANGE_STARS) then return end
                


            end
        end
    else
        if bomb:GetData().isStrangeStarsFetusBomb ~= true then return end
        local player = bomb:GetData().strangeStarsFetusBombPlayer:ToPlayer()
        --rabies
        
    end
    
end
Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, STRANGE_STARS.strangeStarsBombCheck)


function STRANGE_STARS:rabiesDamageNull(entity,amt,flags,source,_)
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
            if not player:HasCollectible(Items.STRANGE_STARS) then return end
            if player:HasWeaponType(WeaponType.WEAPON_TEARS) then return end
            if player:HasWeaponType(WeaponType.WEAPON_FETUS) then return end
            
            --use the same luck formula
            local tearPlayerRNG = player:GetCollectibleRNG(Items.STRANGE_STARS)
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
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, STRANGE_STARS.rabiesDamageNull)


function STRANGE_STARS:rabiesAddStatus(entity,amt,flags,source,_)
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
    if src ~= nil and src:GetData().isAStrangeStarsTear == true then
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
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, STRANGE_STARS.rabiesAddStatus)






function STRANGE_STARS:rabiesNPCUpdate(npc)
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
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, STRANGE_STARS.rabiesNPCUpdate)


function STRANGE_STARS:strangeStarsEffectUpdate(npc)
    local data = npc:GetData()
    local sprite = npc:GetSprite()
    if npc.Parent ~= nil then
        if sprite:IsPlaying("Glitched") then
            if npc.Parent:GetData().botbHasGlitched == true then
                npc.Position = Vector(npc.Parent.Position.X, npc.Parent.Position.Y-(npc.SpriteScale.Y * 70))
            else
                npc:Remove()
            end
        end
    else
        npc:Remove()
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, STRANGE_STARS.strangeStarsEffectUpdate, Entities.BOTB_STATUS_EFFECT.VARIANT)local Mod = BotB
local STRANGE_STARS = {}
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
	EID:addCollectible(Isaac.GetItemIdByName("Strange Stars"), "Your tears have a chance to apply {{StatusGlitched}} Glitched on hit. #{{StatusGlitched}} Glitched enemies are affected in a variety of different ways, of which the most common and basic is getting their AI temporarily canceled.")
end



function STRANGE_STARS:strangeStarsFireTear(tear)
    ----print("tear!")
    if tear.SpawnerEntity.Type == EntityType.ENTITY_PLAYER then
        local tearPlayer = tear.SpawnerEntity:ToPlayer()
        tear:GetData().techNanoPlayerParent = tearPlayer
        ----print("player tear!")
        if tearPlayer:HasCollectible(Items.STRANGE_STARS) then
            ----print("player with tech nano tear!")
            local tearPlayerRNG = tearPlayer:GetCollectibleRNG(Items.STRANGE_STARS)
            local luckThreshold = 0.25 + (tearPlayer.Luck/24)
            if luckThreshold <= 0 then
                luckThreshold = 0.25
            end
            local techNanoRand = tearPlayerRNG:RandomFloat()
            --luckThreshold = 999
            ----print(techNanoRand .. " , " .. luckThreshold)
            if techNanoRand <= luckThreshold then
                tear:GetData().isAStrangeStarsTear = true
            end
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR,STRANGE_STARS.strangeStarsFireTear)

function STRANGE_STARS:rabiesTearUpdate(tear)
    if tear:GetData().isAStrangeStarsTear then
        local data = tear:GetData()
        if tear:HasTearFlags(TearFlags.TEAR_HOMING) ~= true then
            tear:AddTearFlags(TearFlags.TEAR_HOMING)
        end
        if tear:HasTearFlags(TearFlags.TEAR_PIERCING) then
            tear:ClearTearFlags(TearFlags.TEAR_PIERCING)
        end
        if tear:GetData().hasStrangeStarsAdjustments ~= true then
            tear.FallingAcceleration = -0.05
            tear.Color = Color(1,1,0.25)
            --tear.HomingFriction = 0.5
            tear:GetData().hasStrangeStarsAdjustments = true
        end
        local correctPos = tear.Position
        if tear:IsDead() then
            --rabies
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE,STRANGE_STARS.rabiesTearUpdate)




function STRANGE_STARS:strangeStarsTearCollision(tear,_,_)
    if tear:GetData().isAStrangeStarsTear then
        if tear.Parent:ToPlayer() ~= nil and tear.Parent:ToPlayer():HasWeaponType(WeaponType.WEAPON_FETUS) then return end
        local correctPos = tear.Position
        --rabies
    end
end
Mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION,STRANGE_STARS.strangeStarsTearCollision)

function STRANGE_STARS:strangeStarsLaserUpdate(laser)
    --print(laser.Parent.Type,laser.SpawnerEntity.Type)
    if laser.Parent ~= nil and laser.Parent:ToPlayer() ~= nil and laser.Parent:ToPlayer():HasCollectible(Items.STRANGE_STARS) then
        laser.Color = Color(1,1,1,1,0.5,1,0)
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE,STRANGE_STARS.strangeStarsLaserUpdate)


--now to give it a synergy with dr fetus and epic fetus...
function STRANGE_STARS:strangeStarsBombUpdate(bomb)
    ----print(bomb.FrameCount)
    if bomb.FrameCount ~= 1 then return end
    if bomb.IsFetus ~= true then return end
    if bomb.Parent:ToPlayer() ~= nil then
        local player = bomb.Parent:ToPlayer()
        if not player:HasCollectible(Items.STRANGE_STARS) then return end
        local tearPlayerRNG = player:GetCollectibleRNG(Items.STRANGE_STARS)
        local luckThreshold = 0.25 + (player.Luck/24)
        if luckThreshold <= 0 then
            luckThreshold = 0.25
        end
        local techNanoRand = tearPlayerRNG:RandomFloat()
        if techNanoRand <= luckThreshold then
            --tech nano time!
            --bomb:AddTearFlags(TearFlags.TEAR_HOMING)
            bomb:GetData().isStrangeStarsFetusBomb = true
            bomb:GetData().strangeStarsFetusBombPlayer = player
        end
    end

end
Mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE,STRANGE_STARS.strangeStarsBombUpdate)
--[[
function STRANGE_STARS:strangeStarsBombUpdate2(bomb)
    --print(bomb.FrameCount)
    if bomb.FrameCount ~= 1 then return end
    if bomb.IsFetus ~= true then return end
    if bomb.Parent:ToPlayer() ~= nil then
        local player = bomb.Parent:ToPlayer()
        if not player:HasCollectible(Items.STRANGE_STARS) then return end
        local tearPlayerRNG = player:GetCollectibleRNG(Items.STRANGE_STARS)
        local luckThreshold = 0.125 + (player.Luck/24)
        if luckThreshold <= 0 then
            luckThreshold = 0.125
        end
        local techNanoRand = tearPlayerRNG:RandomFloat()
        if techNanoRand <= luckThreshold then
            --tech nano time!
            bomb:GetData().isStrangeStarsFetusBomb = true
        end
    end

end
Mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE,STRANGE_STARS.strangeStarsBombUpdate2)]]



function STRANGE_STARS:strangeStarsBombCheck(bomb) 
    ----print(entity.Type, entity.Variant, entity.SubType)
    if bomb.Type ~= 4 then 
        --epic fetus checking
        if bomb.Type == EntityType.ENTITY_EFFECT and bomb.Variant == EffectVariant.ROCKET then
            if bomb.SpawnerEntity ~= nil and bomb.SpawnerEntity:ToPlayer() ~= nil then
                local player = bomb.SpawnerEntity:ToPlayer()
                if not player:HasCollectible(Items.STRANGE_STARS) then return end
                


            end
        end
    else
        if bomb:GetData().isStrangeStarsFetusBomb ~= true then return end
        local player = bomb:GetData().strangeStarsFetusBombPlayer:ToPlayer()
        --rabies
        
    end
    
end
Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, STRANGE_STARS.strangeStarsBombCheck)


function STRANGE_STARS:rabiesDamageNull(entity,amt,flags,source,_)
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
            if not player:HasCollectible(Items.STRANGE_STARS) then return end
            if player:HasWeaponType(WeaponType.WEAPON_TEARS) then return end
            if player:HasWeaponType(WeaponType.WEAPON_FETUS) then return end
            
            --use the same luck formula
            local tearPlayerRNG = player:GetCollectibleRNG(Items.STRANGE_STARS)
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
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, STRANGE_STARS.rabiesDamageNull)


function STRANGE_STARS:rabiesAddStatus(entity,amt,flags,source,_)
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
    if src ~= nil and src:GetData().isAStrangeStarsTear == true then
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
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, STRANGE_STARS.rabiesAddStatus)






function STRANGE_STARS:rabiesNPCUpdate(npc)
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
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, STRANGE_STARS.rabiesNPCUpdate)


function STRANGE_STARS:strangeStarsEffectUpdate(npc)
    local data = npc:GetData()
    local sprite = npc:GetSprite()
    if npc.Parent ~= nil then
        if sprite:IsPlaying("Glitched") then
            if npc.Parent:GetData().botbHasGlitched == true then
                npc.Position = Vector(npc.Parent.Position.X, npc.Parent.Position.Y-(npc.SpriteScale.Y * 70))
            else
                npc:Remove()
            end
        end
    else
        npc:Remove()
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, STRANGE_STARS.strangeStarsEffectUpdate, Entities.BOTB_STATUS_EFFECT.VARIANT)