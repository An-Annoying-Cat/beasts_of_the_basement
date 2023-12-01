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
	EID:addCollectible(Isaac.GetItemIdByName("Strange Stars"), "Your tears have a chance to apply {{StatusGlitched}} Glitched on hit. #{{StatusGlitched}} Glitched enemies are affected in a variety of entirely different and extremely chaotic ways.")
end

local function TEARFLAG(x)
    return x >= 64 and BitSet128(0,1<<(x-64)) or BitSet128(1<<x,0)
end

function STRANGE_STARS:GetBalancedTearFlag()
    local commonTearFlags = {
        0,
        1,
        3,
        6,
        8,
        10,
        14,
        15,
        23,
        24,
        33,
        50,
        51,
        57,
        58,
        61,
        71,
        74,
        79,
        80,
        82,
    }
    local rareTearFlags = {
        2,
        4,
        5,
        6,
        7,
        13,
        18,
        19,
        20,
        34,
        38,
        44,
        48,
        52,
        55,
        70,
        59,
    }
    local superRareTearFlags = {
        2,
        11,
        18,
        21,
        22,
        31,
        39,
        41,
        43,
        47,
        49,
        53,
        56,
        62,
        63,
        64,
        65,
        66,
        67,
        76,

    }
    local negativeTearFlags = {
        9,
        7,
        12,
        16,
        17,
        25,
        26,
        27,
        30,
        37,
        46,
        68,
        69, --nice
        81,
        83,
    }

    local baseIndex = math.random()
    local returned = 0
    if baseIndex <= 0.5 then
        --Common
        
        returned = commonTearFlags[math.random(1,#commonTearFlags)]
        --print("common", returned)
        return returned
    elseif baseIndex <= 0.75 then
        --Rare
        
        returned = rareTearFlags[math.random(1,#rareTearFlags)]
        --print("rare", returned)
        return returned
    elseif baseIndex <= 0.875 then
        --Bad
        
        returned = negativeTearFlags[math.random(1,#negativeTearFlags)]
        --print("shit", returned)
        return returned
    else
        --Super rare
        
        returned = superRareTearFlags[math.random(1,#superRareTearFlags)]
        --print("super rare", returned)
        return returned
    end


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
        --[[
        if tear:HasTearFlags(TearFlags.TEAR_HOMING) ~= true then
            tear:AddTearFlags(TearFlags.TEAR_HOMING)
        end
        if tear:HasTearFlags(TearFlags.TEAR_PIERCING) then
            tear:ClearTearFlags(TearFlags.TEAR_PIERCING)
        end]]
        if tear:GetData().hasStrangeStarsAdjustments ~= true then
            tear.FallingAcceleration = -0.05
            tear.Color = Color(0.25,0.25,0.25)
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


function STRANGE_STARS:strangeStarsDamageNull(entity,amt,flags,source,_)
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
    if src ~= nil then
        ----print(src.Type, src.Variant, src.SubType)
        local player

        if src:ToPlayer() ~= nil then
            player = src:ToPlayer()
        elseif src.Parent ~= nil and src.Parent:ToPlayer() ~= nil then
            player = src.Parent:ToPlayer()
        elseif src.SpawnerEntity ~= nil and src.SpawnerEntity:ToPlayer() ~= nil then
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
            --print("it's " .. techNanoRand .. " versus " .. luckThreshold)
            if techNanoRand <= luckThreshold then
                --rabies
                local data = entity:GetData()
                if data.botbHasGlitched ~= true then
                    data.botbHasGlitched = true
                    data.botbGlitchedSource = player
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
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, STRANGE_STARS.strangeStarsDamageNull)


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
            data.botbHasGlitched = true
            data.botbGlitchedSource = player
        else
            
        end
    end
        
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, STRANGE_STARS.rabiesAddStatus)






function STRANGE_STARS:rabiesNPCUpdate(npc)
    local data = npc:GetData()
    if data.botbGlitchedImmune == true then
        if data.botbHasGlitched ~= false then
            data.botbHasGlitched = false
        end
    end
    if data.botbHasGlitched == true then
        if data.botbGlitchedIndicator == nil or data.botbGlitchedIndicator:IsDead() then
            data.botbGlitchedIndicator = Isaac.Spawn(Entities.BOTB_STATUS_EFFECT.TYPE,Entities.BOTB_STATUS_EFFECT.VARIANT,0,npc.Position,Vector.Zero, npc):ToEffect()
            data.botbGlitchedIndicator.Parent = npc
            --data.botbGlitchedIndicator.ParentOffset = Vector(0,-(npc.SpriteScale.Y * 70))
            data.botbGlitchedIndicator:GetSprite():Play("Glitched", true)
        end
        if npc:HasEntityFlags(EntityFlag.FLAG_GLITCH) == false then
            npc:AddEntityFlags(EntityFlag.FLAG_GLITCH)
        end

        --Random effects
        if data.botbGlitchedStatusDuration == nil then
            --Amount of time to apply 1-frame status effects for
            data.botbGlitchedStatusDuration = 0
        end

        if math.random(1,64) == 1 then
            npc:PlaySound(SoundEffect.SOUND_EDEN_GLITCH, 0.5, 0, false, math.random(200,400)/100)
            data.botbGlitchedStatusDuration = data.botbGlitchedStatusDuration + math.random(0,8)
        end

        if data.botbGlitchedStatusDuration ~= 0 then
            local statusToApply = math.random(1,9)
            local playerRef = EntityRef(data.botbGlitchedSource)
            if statusToApply == 1 then
                --burn
                npc:AddBurn(playerRef, 3, data.botbGlitchedSource:ToPlayer().Damage)
            end
            if statusToApply == 2 then
                --charm
                npc:AddCharmed(playerRef, 3)
            end
            if statusToApply == 3 then
                --confuse
                npc:AddConfusion(playerRef, 3, false)
            end
            if statusToApply == 4 then
                --fear
                npc:AddFear(playerRef, 3)
            end
            if statusToApply == 5 then
                --freeze
                npc:AddFreeze(playerRef, 3)
            end
            if statusToApply == 5 then
                --midas
                npc:AddMidasFreeze(playerRef, 3)
            end
            if statusToApply == 6 then
                --poison
                npc:AddPoison(playerRef, 3, data.botbGlitchedSource:ToPlayer().Damage * 0.25)
            end
            if statusToApply == 7 then
                --shrink
                npc:AddShrink(playerRef, 3)
            end
            if statusToApply == 8 then
                --slowing
                npc:AddSlowing(playerRef, 3, math.random(1,100)/100, Color(0.5,0.5,0.5,0))
            end
            if statusToApply == 9 then
                --random color lol
                npc:SetColor(Color(math.random(0,255)/255,math.random(0,255)/255,math.random(0,255)/255,1), 3, 1, false, false)
            end
            data.botbGlitchedStatusDuration = data.botbGlitchedStatusDuration - 1
        end

        if math.random(1,64) == 1 then
            npc:PlaySound(SoundEffect.SOUND_EDEN_GLITCH, 0.5, 0, false, math.random(200,400)/100)
            npc.Velocity = Vector(12,0):Rotated(math.random(0,359))
        end

        if math.random(1,16) == 1 then
            local sound = math.random(1,BotB.Enums.SFX.PLUS_TEN)
            npc:PlaySound(sound, 1, 0, false, math.random(25,100)/100)
            for i = 1, 240 do
                FiendFolio.scheduleForUpdate(function()
                    if math.random(1,8) == 1 then
                        SFXManager():AdjustPitch(sound, math.random(1,500)/100)
                    end
                end, i, ModCallbacks.MC_POST_RENDER)
            end
        end

        if math.random(1,16) == 1 then
            --local sound = math.random(1,BotB.Enums.SFX.PLUS_TEN)
            --npc:PlaySound(sound, 1, 0, false, math.random(25,100)/100)
            for i = 1, 240 do
                FiendFolio.scheduleForUpdate(function()
                    if math.random(1,256) == 1 then
                        MusicManager():PitchSlide(math.random(25,250)/100)
                    end
                    if i == 240 then
                        MusicManager():PitchSlide(1)
                    end
                end, i, ModCallbacks.MC_POST_RENDER)
            end
        end

        if math.random(1,256) == 1 then
            local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT,math.random(1,99),0,npc.Position,Vector(math.random(1,30),0):Rotated(math.random(0,359)),npc):ToEffect()
            if math.random(1,8) == 1 then
                effect.Velocity = Vector.Zero
            end
            effect:SetTimeout(math.random(1,240))
        end

        if math.random(1,1010101010) == 1 then
            npc:PlaySound(BotB.Enums.SFX.PLUS_TEN, 10, 0, false, 1)
            for i=1,10 do
                for i=1,10 do
                    Isaac.Spawn(5,0,0,npc.Position,Vector(math.random(1,30),0):Rotated(math.random(0,359)),npc)
                end
            end
        end

        

        if math.random(1,32) == 1 then
            npc:PlaySound(math.random(1,BotB.Enums.SFX.PLUS_TEN), 1, 0, false, math.random(200,500)/100)
            data.additionalTearFlags = TearFlags.TEAR_NORMAL | TearFlags.TEAR_PIERCING
            local newFlagsToAdd = math.random(4,8)
            for i=0, newFlagsToAdd do
                data.additionalTearFlags = data.additionalTearFlags | TEARFLAG(math.random(1,TearFlags.TEAR_EFFECT_COUNT))
                --adds a random tear flag for every card
            end

            local firedTear = data.botbGlitchedSource:ToPlayer():FireTear(npc.Position, Vector(10*data.botbGlitchedSource:ToPlayer().ShotSpeed,0):Rotated(math.random(0,359)), true, true, false, data.botbGlitchedSource:ToPlayer(), 1):ToTear()
            firedTear.CollisionDamage = data.botbGlitchedSource:ToPlayer().Damage * 0.25
            firedTear:AddTearFlags(data.additionalTearFlags)
            firedTear.Parent = data.botbGlitchedSource:ToPlayer()
            data.additionalTearFlags = TearFlags.TEAR_NORMAL
        end
        --
        if math.random(1,512) == 1 then
            data.botbHasGlitched = false
            MusicManager():PitchSlide(1)
            --
            if math.random(1,4) == 1 then
                data.botbGlitchedImmune = true
            end
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



function BotB:glitchedTestCMD(cmd, params)
    if not cmd == "glitched" then return end
    if cmd == "glitched" then
        --local playerTable = BotB:GetPlayers()
        --print("this better have been worth the effort")
        local roomEntities = Isaac.GetRoomEntities() -- table
            for i = 1, #roomEntities do
                local entity = roomEntities[i]
                if entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly ~= true then
                    local data = entity:GetData()
                    if data.botbGlitchedImmune ~= true then
                        if data.botbHasGlitched ~= true then
                            data.botbHasGlitched = true
                        end
                    end
                end
            end
            

        


    end
    
    
end
Mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, BotB.glitchedTestCMD)