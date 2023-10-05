local Mod = BotB
local CLAY_SOLDIER = {}
local Familiars = BotB.Enums.Familiars
local Items = BotB.Enums.Items
local PLAYER_TOLOMON = Isaac.GetPlayerTypeByName("Tolomon", true)
--
local claySoldierPickupWhitelist = {
    --Goes by variant
    PickupVariant.PICKUP_HEART,
    PickupVariant.PICKUP_BOMB,
    PickupVariant.PICKUP_COIN,
    PickupVariant.PICKUP_KEY,
    PickupVariant.PICKUP_TAROTCARD,
    --PickupVariant.PICKUP_PILL,
    PickupVariant.PICKUP_LIL_BATTERY,
    --[[
    PickupVariant.PICKUP_LIL_BATTERY,
    PickupVariant.PICKUP_GRAB_BAG,
    PickupVariant.PICKUP_PILL,]]
    1022, --ff half black
    1023, --ff black blende
    1024,
    1025,
    1026,
    1028,
    1029,
    1030,
    900,
    901,
    902,
    903,
    --Anything else is BANNED
}

function CLAY_SOLDIER:claySoldierActiveItem(_, _, player, _, _, _)
	--player:AnimateCollectible(Isaac.GetItemIdByName("MILAS_HEAD"))
	--print("lol how do i card")
	--print(#Isaac.GetItemConfig():GetCards())
	--At least I can get how many cards there are!
	--local cardIDLimit = (#Isaac.GetItemConfig():GetCards())-1
	--Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,math.random(1,cardIDLimit),Isaac.GetFreeNearPosition(player.Position, 10),Vector.Zero,player)


    --player:FireBomb(player.Position, Vector(10,0), player)


    local room = Game():GetRoom()
	local roomEntities = room:GetEntities() -- cppcontainer
    local pickupTable = {}
        for i = 0, #roomEntities - 1 do
            local entity = roomEntities:Get(i)
            --print(entity.Type, entity.Variant, entity.SubType)
            if entity.Type == EntityType.ENTITY_PICKUP then
                local isPickupWhitelisted = false
                for i=1, #claySoldierPickupWhitelist do
                    if entity.Variant == claySoldierPickupWhitelist[i] then
                        isPickupWhitelisted = true
                    end
                end
                --If it's whitelisted, add it to the table
                if isPickupWhitelisted then
                    pickupTable[#pickupTable+1] = {entity.Variant, entity.SubType}
                    --print("added pickup of " .. "{" .. entity.Variant .. " , " .. entity.SubType .. "} to table")
                    entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    entity:ToPickup().Timeout = 16
                end
                --print(entity.Type, entity.Variant, entity.SubType)
                
            end
        end 

        
        
    if #pickupTable ~= 0 then
        --[[
        for i=1, #pickupTable do
            print("pickupTable["..i.."] is {" .. pickupTable[i][1] .. " , " .. pickupTable[i][2] .. "}")
        end]]
        local trackerFamiliar = Isaac.Spawn(EntityType.ENTITY_FAMILIAR,Familiars.CLAY_SOLDIER_TRACKER.VARIANT,0,player.Position,Vector.Zero,player):ToFamiliar()
        trackerFamiliar:GetData().pickupTable = CLAY_SOLDIER:pickupsToStatTable(pickupTable)
        --fuckin' troll bombs man
        for i = 0, #roomEntities - 1 do
            local entity = roomEntities:Get(i)
            --print(entity.Type, entity.Variant, entity.SubType)
            if entity.Type == EntityType.ENTITY_BOMB then
                if entity.Variant == 3 then
                    if entity.SubType == 160 then
                        trackerFamiliar:GetData().pickupTable.trollBombs = trackerFamiliar:GetData().pickupTable.trollBombs + math.random(0,1)
                        --entity:ToPickup().Timeout = 8
                        entity:Remove()
                    end
                    trackerFamiliar:GetData().pickupTable.trollBombs = trackerFamiliar:GetData().pickupTable.trollBombs + 1
                    --entity:ToPickup().Timeout = 8
                    entity:Remove()
                end
                if entity.Variant == 4 then
                    trackerFamiliar:GetData().pickupTable.trollBombs = trackerFamiliar:GetData().pickupTable.trollBombs + 2
                    --entity:ToPickup().Timeout = 8
                    entity:Remove()
                end
                if entity.Variant == 18 then
                    trackerFamiliar:GetData().pickupTable.trollBombs = trackerFamiliar:GetData().pickupTable.trollBombs + 4
                    --entity:ToPickup().Timeout = 8
                    entity:Remove()
                end
                if entity.Variant == 929 then
                    trackerFamiliar:GetData().pickupTable.trollBombs = trackerFamiliar:GetData().pickupTable.trollBombs + math.random(0,1)
                    --entity:ToPickup().Timeout = 8
                    entity:Remove()
                end
            end
        end 
        if trackerFamiliar:GetData().pickupTable ~= nil then
            for k,v  in pairs(trackerFamiliar:GetData().pickupTable) do
                if v ~= 0 then
                    print(k,v)
                end
            end
        end
        
        SFXManager():Play(SoundEffect.SOUND_DEATH_REVERSE,0.9,0,false,1.25)
        player:AnimateCollectible(Isaac.GetItemIdByName("The Lesser Key"))
    else
        player:AnimateSad()
    end
	


end
Mod:AddCallback(ModCallbacks.MC_USE_ITEM,CLAY_SOLDIER.claySoldierActiveItem,Isaac.GetItemIdByName("The Lesser Key"))

function CLAY_SOLDIER:findNearestEnemy(from)

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

function CLAY_SOLDIER:doClaySoldierAimAssist(tear)
    if tear:GetData().isFromClaySoldier == true and tear.FrameCount <= 5 and Game():GetRoom():IsClear() == false and tear:GetData().adjustmentTarget:IsDead() == false and tear:GetData().adjustmentTarget:IsInvincible() == false and tear:GetData().adjustmentTarget.HitPoints ~= 0 then
        tear.Velocity = Vector.FromAngle((tear:GetData().adjustmentTarget.Position - tear.Position):GetAngleDegrees()):Resized(tear.Velocity:Length())
        --Vector.FromAngle((tear:GetData().adjustmentTarget.Position - tear.Position):GetAngleDegrees()):Resized(tear.Velocity:Length)
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, CLAY_SOLDIER.doClaySoldierAimAssist)

local function TEARFLAG(x)
    return x >= 64 and BitSet128(0,1<<(x-64)) or BitSet128(1<<x,0)
end

function CLAY_SOLDIER:GetBalancedTearFlag()
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
        print("common", returned)
        return returned
    elseif baseIndex <= 0.75 then
        --Rare
        
        returned = rareTearFlags[math.random(1,#rareTearFlags)]
        print("rare", returned)
        return returned
    elseif baseIndex <= 0.875 then
        --Bad
        
        returned = negativeTearFlags[math.random(1,#negativeTearFlags)]
        print("shit", returned)
        return returned
    else
        --Super rare
        
        returned = superRareTearFlags[math.random(1,#superRareTearFlags)]
        print("super rare", returned)
        return returned
    end


end

--From Epic Fetus Synergies
local function floatToInt(float)
    return math.floor(float * 10000) --4 digits is enough percision in my books
  end

local function spawnRocket(player, pos, delay, damage)
    local rocket = Isaac.Spawn(1000, 31, 0, pos, Vector.Zero, player):ToEffect()
    rocket:SetTimeout(delay or 10)
    if damage then rocket.DamageSource = floatToInt(damage) end
    rocket:Update()
    return rocket
  end

  local function getMultiShot(player)
    local ret = 1
    if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then ret = ret + 1 end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) then ret = ret + 1 end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) then ret = ret + 2 end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then ret = ret + 3 end
    --tainted treasures
    if player:HasCollectible(Isaac.GetItemIdByName("Spider Freak")) then ret = ret + 6 end
    return ret
  end

local function doesRoomHaveEnemies()
    local roomEntities = Isaac.GetRoomEntities() -- table
    local doesRoomHaveEnemies = false
for i = 1, #roomEntities do
    local entity = roomEntities[i]
    if entity:IsVulnerableEnemy() then
        doesRoomHaveEnemies = true
    end
end
return doesRoomHaveEnemies
end

function CLAY_SOLDIER:FamiliarUpdate(npc)

    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = Game():GetRoom()
    local player = npc.Player

    if npc.Type == Familiars.CLAY_SOLDIER_TRACKER.TYPE and npc.Variant == Familiars.CLAY_SOLDIER_TRACKER.VARIANT then 
        --print(npc.State)
        if data.inheritedPlayerStats == nil then
            data.rawInheritedPlayerStats = {
                Damage = npc.Player.Damage,
                MaxFireDelay = npc.Player.MaxFireDelay,
                MoveSpeed = npc.Player.MoveSpeed,
                Luck = npc.Player.Luck,
                ShotSpeed = npc.Player.ShotSpeed,
                TearColor = npc.Player.TearColor,
                TearFallingAcceleration = npc.Player.TearFallingAcceleration,
                TearFallingSpeed = npc.Player.TearFallingSpeed,
                TearFlags = npc.Player.TearFlags,
                TearHeight = npc.Player.TearHeight,
                TearRange = npc.Player.TearRange,
                MultiShotNum = getMultiShot(npc.Player:ToPlayer()),
                DropChance = npc.Player.Luck,
            }
            data.inheritedPlayerStats = {
                Damage = npc.Player.Damage,
                MaxFireDelay = npc.Player.MaxFireDelay,
                MoveSpeed = npc.Player.MoveSpeed,
                Luck = npc.Player.Luck,
                ShotSpeed = npc.Player.ShotSpeed,
                TearColor = npc.Player.TearColor,
                TearFallingAcceleration = npc.Player.TearFallingAcceleration,
                TearFallingSpeed = npc.Player.TearFallingSpeed,
                TearFlags = npc.Player.TearFlags,
                TearHeight = npc.Player.TearHeight,
                TearRange = npc.Player.TearRange,
                MultiShotNum = getMultiShot(npc.Player:ToPlayer()),
                DropChance = npc.Player.Luck,
            }
            data.additionalTearFlags = TearFlags.TEAR_NORMAL
            data.fireDelay = data.inheritedPlayerStats.MaxFireDelay
            if data.pickupTable.cards ~= 0 then
                for i=0, data.pickupTable.cards do
                    data.additionalTearFlags = data.additionalTearFlags | TEARFLAG(CLAY_SOLDIER:GetBalancedTearFlag())
                    --adds a random tear flag for every card
                end
            end
            if data.pickupTable.boneHearts ~= 0 then
                data.additionalTearFlags = data.additionalTearFlags | TearFlags.TEAR_BONE
            end
            if data.pickupTable.trollBombs ~= 0 then
                data.additionalTearFlags = data.additionalTearFlags | TearFlags.TEAR_EXPLOSIVE
            end
            data.isFirstTimeSpawning = true
            data.doRecoveryTime = false
            data.homunculusRecoveryTimeMax = 240 --just a baseline
            data.homunculusRecoveryTime = data.homunculusRecoveryTimeMax
            data.isRespawning = false
        end

        if npc.State ~= 99 then
            npc.State = 99
        end
        --stats and stuff

        data.rawInheritedPlayerStats = {
            Damage = npc.Player.Damage,
            MaxFireDelay = npc.Player.MaxFireDelay,
            MoveSpeed = npc.Player.MoveSpeed,
            Luck = npc.Player.Luck,
            ShotSpeed = npc.Player.ShotSpeed,
            TearColor = npc.Player.TearColor,
            TearFallingAcceleration = npc.Player.TearFallingAcceleration,
            TearFallingSpeed = npc.Player.TearFallingSpeed,
            TearFlags = npc.Player.TearFlags,
            TearHeight = npc.Player.TearHeight,
            TearRange = npc.Player.TearRange,
            MultiShotNum = getMultiShot(npc.Player:ToPlayer()),
            DropChance = npc.Player.Luck,
        }

        data.inheritedPlayerStats = {
            Damage = npc.Player.Damage,
            MaxFireDelay = npc.Player.MaxFireDelay,
            MoveSpeed = npc.Player.MoveSpeed,
            Luck = npc.Player.Luck,
            ShotSpeed = npc.Player.ShotSpeed,
            TearColor = npc.Player.TearColor,
            TearFallingAcceleration = npc.Player.TearFallingAcceleration,
            TearFallingSpeed = npc.Player.TearFallingSpeed,
            TearFlags = npc.Player.TearFlags,
            TearHeight = npc.Player.TearHeight,
            TearRange = npc.Player.TearRange,
            MultiShotNum = getMultiShot(npc.Player:ToPlayer()),
            DropChance = npc.Player.Luck,
        }
        --[[
        if data.pickupTable ~= nil then
            for k,v  in pairs(data.pickupTable) do
                print(k,v)
            end
        end]]

        --Base damage is half player damage, but black hearts increase it
        data.inheritedPlayerStats.Damage = data.inheritedPlayerStats.Damage * (0.5 + 0.25*data.pickupTable.blackHearts)
        --Keys increase fire rate
        if data.pickupTable.keys ~= 0 then
            if data.pickupTable.goldenKeys ~= 0 then
                data.inheritedPlayerStats.MaxFireDelay = math.floor((data.rawInheritedPlayerStats.MaxFireDelay * (0.95 ^ data.pickupTable.keys)) * (0.5 ^ data.pickupTable.goldenKeys))
            else
                data.inheritedPlayerStats.MaxFireDelay = math.floor(data.rawInheritedPlayerStats.MaxFireDelay * (0.95 ^ data.pickupTable.keys))
            end       
        end
        --Bombs increase damage, copper bombs provide randomization (in both directions)      
        if data.pickupTable.bombs ~= 0 then
            if data.pickupTable.goldenBombs ~= 0 then
                data.inheritedPlayerStats.Damage = math.floor((data.rawInheritedPlayerStats.Damage * (1.125 ^ data.pickupTable.bombs)) * (2 ^ data.pickupTable.goldenBombs))
                if data.pickupTable.copperBombs ~= 0 then
                    data.inheritedPlayerStats.Damage = data.inheritedPlayerStats.Damage + (data.rawInheritedPlayerStats.Damage*((math.random()-0.5) * (2*data.pickupTable.copperBombs)))
                end
            else
                data.inheritedPlayerStats.Damage = math.floor(data.rawInheritedPlayerStats.Damage * (1.125 ^ data.pickupTable.bombs))
                if data.pickupTable.copperBombs ~= 0 then
                    data.inheritedPlayerStats.Damage = math.abs(data.inheritedPlayerStats.Damage + (data.rawInheritedPlayerStats.Damage*((math.random()-0.5) * (data.pickupTable.copperBombs))))
                end
            end       
        end
        --Coins increase chance to drop pickups, enough coins also increase multishot kinda like Greed
        if data.pickupTable.coins ~= 0 then
            local amountToAddToMultiShot = math.floor((data.pickupTable.coins - (data.pickupTable.coins % 15))/15)
            data.inheritedPlayerStats.MultiShotNum = data.rawInheritedPlayerStats.MultiShotNum + amountToAddToMultiShot
        end
        --Lucky pennies increase the base luck rate for chance based effects, so do bone hearts cuz they give a chance to fire a bone tear
        data.inheritedPlayerStats.Luck = data.rawInheritedPlayerStats.Luck + (1.5 ^ (data.pickupTable.luckyCoins + data.pickupTable.boneHearts))
        data.doAdditionalTearEffects = false
        local additionalCheck = math.random()*100
        --print(data.inheritedPlayerStats.Luck * 10 .. " versus " .. additionalCheck)
        if data.inheritedPlayerStats.Luck*10 >= additionalCheck then
            --print("GET")
            data.doAdditionalTearEffects = true
        end


        --Recovery time debuff for dudes that are just fucking loaded
        local amtPickups = 0
        for k,v in pairs(data.pickupTable) do
            if v ~= 0 then
                amtPickups = amtPickups + v
            end
        end
        --print("total of " .. amtPickups)



        if data.pickupTable.soulHearts ~= 0 then
            if data.homunculusRecoveryTimeMax ~= math.ceil((240 + (20*amtPickups)) * (0.8 ^ (data.pickupTable.soulHearts * 0.75))) then
                data.homunculusRecoveryTimeMax = math.ceil((240 + (20*amtPickups)) * (0.8 ^ (data.pickupTable.soulHearts * 0.75)))
            end
        else
            data.homunculusRecoveryTimeMax = math.ceil((240 + (20*amtPickups)))
        end

        if data.pickupTable.batteries ~= 0 then
            --move speed
            data.inheritedPlayerStats.MoveSpeed = data.rawInheritedPlayerStats.MoveSpeed * (1.125 ^ (data.pickupTable.batteries/4))
            --fire rate
            if data.pickupTable.keys ~= 0 then
                if data.pickupTable.goldenKeys ~= 0 then
                    data.inheritedPlayerStats.MaxFireDelay = math.floor(((data.rawInheritedPlayerStats.MaxFireDelay * (0.95 ^ data.pickupTable.keys)) * (0.5 ^ data.pickupTable.goldenKeys))*(0.9 ^ (data.pickupTable.batteries/4)))
                else
                    data.inheritedPlayerStats.MaxFireDelay = math.floor((data.rawInheritedPlayerStats.MaxFireDelay * (0.95 ^ data.pickupTable.keys))*(0.9 ^ (data.pickupTable.batteries/4)))
                end
            else
                data.inheritedPlayerStats.MaxFireDelay = math.floor((data.rawInheritedPlayerStats.MaxFireDelay)*(0.9 ^ (data.pickupTable.batteries/4)))
            end
            --damage
            if data.pickupTable.bombs ~= 0 then
                if data.pickupTable.goldenBombs ~= 0 then
                    data.inheritedPlayerStats.Damage = math.floor((data.rawInheritedPlayerStats.Damage * (1.125 ^ data.pickupTable.bombs)) * (2 ^ data.pickupTable.goldenBombs) * (1.5 ^ (data.pickupTable.batteries/4)))
                    if data.pickupTable.copperBombs ~= 0 then
                        data.inheritedPlayerStats.Damage = data.inheritedPlayerStats.Damage + (data.rawInheritedPlayerStats.Damage*((math.random()-0.5) * (2*data.pickupTable.copperBombs)))
                    end
                else
                    data.inheritedPlayerStats.Damage = math.floor(data.rawInheritedPlayerStats.Damage * (1.125 ^ data.pickupTable.bombs) * (1.5 ^ (data.pickupTable.batteries/4)))
                    if data.pickupTable.copperBombs ~= 0 then
                        data.inheritedPlayerStats.Damage = math.abs(data.inheritedPlayerStats.Damage + (data.rawInheritedPlayerStats.Damage*((math.random()-0.5) * (data.pickupTable.copperBombs))))
                    end
                end
            else
                data.inheritedPlayerStats.Damage = math.floor((data.rawInheritedPlayerStats.Damage * (1.5 ^ (data.pickupTable.batteries/4))))
            end
            
        end

        --print(data.inheritedPlayerStats.Damage)




        
        --handles respawning
        if data.familiarEnemy == nil or data.familiarEnemy:IsDead() then
            if data.isFirstTimeSpawning == true then
                data.isRespawning = false
                data.familiarEnemy = Isaac.Spawn(BotB.Enums.Entities.CLAY_SOLDIER.TYPE,BotB.Enums.Entities.CLAY_SOLDIER.VARIANT,0,npc.Position, Vector.Zero,npc):ToNPC()
                data.familiarEnemy.Parent = npc
                data.familiarEnemy:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT)
                data.familiarEnemy:GetData().pickupTable = data.pickupTable
                if data.pickupTable.redHearts ~= 0 then
                    data.familiarEnemy.MaxHitPoints = data.familiarEnemy.MaxHitPoints + (data.pickupTable.redHearts * data.familiarEnemy.MaxHitPoints)
                    data.familiarEnemy.HitPoints = data.familiarEnemy.MaxHitPoints
                end
                if npc.Player:GetPlayerType() == PLAYER_TOLOMON then
                    local homunculusNameTable = CLAY_SOLDIER:generateRandomHomunculusEID(npc)
                    local descTable = {
                        ["Name"] = homunculusNameTable[1],
                        ["Description"] = homunculusNameTable[2],
                    } 
                    data.familiarEnemy:GetData().eidOnTab = descTable
                    data.familiarEnemy:GetData()["EID_Description"] = descTable
    
                end
            else
                if data.chargeBar == nil then
                    data.chargeBar = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, BotB.Enums.Familiars.CLAY_SOLDIER_CHARGEBAR.VARIANT, 0, npc.Player.Position,Vector.Zero,npc.Player):ToFamiliar()
                end
                if data.homunculusRecoveryTime == nil then
                    data.homunculusRecoveryTime = data.homunculusRecoveryTimeMax
                end
                if data.homunculusRecoveryTime ~= 0 then
                    --print(data.homunculusRecoveryTime)
                    data.homunculusRecoveryTime = data.homunculusRecoveryTime - 1
                    --npc:GetSprite():Play("Charging")
                    --print(math.floor((1-(data.homunculusRecoveryTime/data.homunculusRecoveryTimeMax))*100))
                    data.chargeBar:GetSprite():SetFrame("Charging", (math.floor((1-(data.homunculusRecoveryTime/data.homunculusRecoveryTimeMax))*100)))
                else
                    data.chargeBar:GetSprite():Play("Finished")
                    data.chargeBar = nil
                    data.isRespawning = false
                    data.familiarEnemy = Isaac.Spawn(BotB.Enums.Entities.CLAY_SOLDIER.TYPE,BotB.Enums.Entities.CLAY_SOLDIER.VARIANT,0,npc.Position, Vector.Zero,npc):ToNPC()
                    data.familiarEnemy.Parent = npc
                    data.familiarEnemy:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT)
                    data.familiarEnemy:GetData().pickupTable = data.pickupTable
                    if data.pickupTable.redHearts ~= 0 then
                        data.familiarEnemy.MaxHitPoints = data.familiarEnemy.MaxHitPoints + (data.pickupTable.redHearts * data.familiarEnemy.MaxHitPoints)
                        data.familiarEnemy.HitPoints = data.familiarEnemy.MaxHitPoints
                    end
                    if npc.Player:GetPlayerType() == PLAYER_TOLOMON then
                        local homunculusNameTable = CLAY_SOLDIER:generateRandomHomunculusEID(npc)
                        local descTable = {
                            ["Name"] = homunculusNameTable[1],
                            ["Description"] = homunculusNameTable[2],
                        } 
                        data.familiarEnemy:GetData().eidOnTab = descTable
                        data.familiarEnemy:GetData()["EID_Description"] = descTable
        
                    end
                    data.homunculusRecoveryTime = data.homunculusRecoveryTimeMax
                end
            end
        else
            if data.familiarEnemy.State == 100 then
                if npc.Player:HasCollectible(CollectibleType.COLLECTIBLE_SPIRIT_SWORD, true) then
                    if data.invisibleFetus == nil or data.invisibleFetus:IsDead() then
                        data.invisibleFetus = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.FETUS,0,data.familiarEnemy.Position,Vector.Zero,npc.Player):ToTear()
                        data.invisibleFetus:AddTearFlags(TearFlags.TEAR_FETUS | TearFlags.TEAR_FETUS_SWORD)
                        data.invisibleFetus.HomingFriction = 0
                        data.invisibleFetus:GetData().isInvisibleFetus = true
                        data.invisibleFetus.Color = Color(1,1,1,1)
                        data.invisibleFetus.Visible = false
                        data.invisibleFetus.FallingSpeed = -1
                        data.invisibleFetus.FallingAcceleration = -0.2
                        data.invisibleFetus.Scale = 1.5
                        data.invisibleFetus:GetData().followThisDude = data.familiarEnemy
                    end
                end
            end
        end

        


        --[[
        for k,v in pairs(data.inheritedPlayerStats) do
            print(k,v)
        end]]
        local fdata = data.familiarEnemy:GetData()
        --States
        -- 99 - idle
        if npc.State == 99 then
            if room:IsClear() == false then
                if npc.IsFollower then
                    npc:RemoveFromFollowers()
                end              
            else
                if not npc.IsFollower then
                    npc:AddToFollowers()
                else
                    npc:FollowParent()
                end  
            end
           
            if (room:IsClear() == false or doesRoomHaveEnemies()) then
                if data.isRespawning ~= true then
                    data.followingTarget = CLAY_SOLDIER:findNearestEnemy(npc.Player)
                    npc.Position = data.followingTarget.Position
                end
                
            else
                if data.isRespawning == true or npc:GetSprite():IsPlaying("Finished") then
                    if not npc.IsFollower then
                        npc:AddToFollowers()
                    else
                        npc:FollowParent()
                    end  
                else
                    
                    --npc.Position = npc.Player.Position
                end
                
            end
            

            if data.myKnife ~= nil and data.fireAngle ~= nil and npc.Player:HasWeaponType(WeaponType.WEAPON_BONE) == false then
                data.myKnife.Rotation = data.fireAngle
            end
            if data.myKnife ~= nil then
                data.myKnife.Color = data.inheritedPlayerStats.TearColor
                data.myKnife.CollisionDamage = data.inheritedPlayerStats.Damage
                data.myKnife:AddTearFlags(data.inheritedPlayerStats.TearFlags)
            end
            if npc.Player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS, false) then
                if data.pickupTable.keys ~= 0 then
                    if data.pickupTable.goldenKeys ~= 0 then
                        data.inheritedPlayerStats.MaxFireDelay = math.floor((120 * (0.95 ^ data.pickupTable.keys)) * (0.5 ^ data.pickupTable.goldenKeys))
                    else
                        data.inheritedPlayerStats.MaxFireDelay = math.floor(120 * (0.95 ^ data.pickupTable.keys))
                    end       
                end

                if data.familiarEnemy ~= nil then                
                    if data.familiarEnemy.State == 100 then
                        if data.familiarEnemy:GetSprite():GetOverlayFrame() == 1 then
                            print("bobm")
                            local firedTear = npc.Player:ToPlayer():FireBomb(data.familiarEnemy.Position, Vector(10*data.inheritedPlayerStats.ShotSpeed,0):Rotated(data.fireAngle), npc.Player):ToBomb()
                            firedTear:AddTearFlags(data.inheritedPlayerStats.TearFlags)
                            firedTear:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_HOMING)
                        end
                    end
                end
            end

            if data.familiarEnemy ~= nil then                
                if data.familiarEnemy.State == 100 and data.fireAngle ~= 0.0 then
                    if data.familiarEnemy:GetSprite():GetOverlayFrame() == 1 then
                        --data.inheritedPlayerStats.MultiShotNum
                        local angleRange = data.inheritedPlayerStats.MultiShotNum * 22.5
                        if data.inheritedPlayerStats.MultiShotNum > 1 then
                            for i=(-0.5 * angleRange), (0.5*angleRange), 22.5 do
                                CLAY_SOLDIER:FireInheritedWeapon(npc,i)
                            end
                        else
                            CLAY_SOLDIER:FireInheritedWeapon(npc,0)
                        end
                        

                        --[[
                        if npc.Player:HasWeaponType(WeaponType.WEAPON_TEARS) then
                            local firedTear = npc.Player:FireTear(data.familiarEnemy.Position, Vector(10*data.inheritedPlayerStats.ShotSpeed,0):Rotated(data.fireAngle), true, true, false, npc.Player, 1):ToTear()
                            firedTear:AddTearFlags(data.inheritedPlayerStats.TearFlags)
                            firedTear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                        end
                        if npc.Player:HasWeaponType(WeaponType.WEAPON_TEARS) then
                            local firedTear = npc.Player:FireTear(data.familiarEnemy.Position, Vector(10*data.inheritedPlayerStats.ShotSpeed,0):Rotated(data.fireAngle), true, true, false, npc.Player, 1):ToTear()
                            firedTear:AddTearFlags(data.inheritedPlayerStats.TearFlags)
                            firedTear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                        end
                        if npc.Player:HasWeaponType(WeaponType.WEAPON_TEARS) then
                            local firedTear = npc.Player:FireTear(data.familiarEnemy.Position, Vector(10*data.inheritedPlayerStats.ShotSpeed,0):Rotated(data.fireAngle), true, true, false, npc.Player, 1):ToTear()
                            firedTear:AddTearFlags(data.inheritedPlayerStats.TearFlags)
                            firedTear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                        end
                        if npc.Player:HasWeaponType(WeaponType.WEAPON_TEARS) then
                            local firedTear = npc.Player:FireTear(data.familiarEnemy.Position, Vector(10*data.inheritedPlayerStats.ShotSpeed,0):Rotated(data.fireAngle), true, true, false, npc.Player, 1):ToTear()
                            firedTear:AddTearFlags(data.inheritedPlayerStats.TearFlags)
                            firedTear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                        end
                        if npc.Player:HasWeaponType(WeaponType.WEAPON_TEARS) then
                            local firedTear = npc.Player:FireTear(data.familiarEnemy.Position, Vector(10*data.inheritedPlayerStats.ShotSpeed,0):Rotated(data.fireAngle), true, true, false, npc.Player, 1):ToTear()
                            firedTear:AddTearFlags(data.inheritedPlayerStats.TearFlags)
                            firedTear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                        end]]
                        data.fireDelay = data.inheritedPlayerStats.MaxFireDelay
                    end
                end
            end

            data.fireDelayIncrement = 1
            if npc.Player:HasWeaponType(WeaponType.WEAPON_TECH_X) or npc.Player:HasWeaponType(WeaponType.WEAPON_FETUS) then
                data.fireDelayIncrement = 8
            end
            if data.fireDelay ~= 0 and npc.FrameCount % data.fireDelayIncrement == 0 then
                data.fireDelay = data.fireDelay - 1
            end
            if data.fireDelay < 0 then
                data.fireDelay = data.inheritedPlayerStats.MaxFireDelay
            end
            data.fireDelay = math.floor(data.fireDelay)
            --print(data.fireDelay)
        end

    end
end
Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, CLAY_SOLDIER.FamiliarUpdate, Isaac.GetEntityVariantByName("Clay Soldier (Tracker)"))

function CLAY_SOLDIER:onNPCKill(hurt,amt,flags,src)
    local source = src.Entity
    if hurt:IsVulnerableEnemy() == false then return end
    if source ~= nil and source.Parent ~= nil then
        if not (source.Parent.Type == BotB.Enums.Entities.CLAY_SOLDIER.TYPE and source.Parent.Variant == BotB.Enums.Entities.CLAY_SOLDIER.VARIANT) then return end
        --print(source.Parent.Parent.Type, source.Parent.Parent.Variant, source.Parent.Parent.SubType)
             
        if source.Parent.Parent ~= nil then
            
            if not (source.Parent.Parent.Type == EntityType.ENTITY_FAMILIAR and source.Parent.Parent.Variant == BotB.Enums.Familiars.CLAY_SOLDIER_TRACKER.VARIANT) then return end
            local parent = source.Parent.Parent
            local pickups = parent:GetData().pickupTable
            local player = source.Parent.Parent:ToFamiliar().Player
            if pickups.cursedCoins ~= 0 then
                if math.random() < (1/(16 * (0.75 ^ (pickups.cursedCoins + (0.05 * parent:GetData().inheritedPlayerStats.Luck))))) then
                    SFXManager():Play(Isaac.GetSoundIdByName("AceVenturaLaugh"),0.05,0,false,1.5,0)
                    local minion = Isaac.Spawn(1000, EffectVariant.PICKUP_FIEND_MINION, 1, hurt.Position, Vector.Zero, player)
					minion.EntityCollisionClass = 4
					minion.Parent = player
		
					local data = minion:GetData()
					data.hollow = true
					data.canreroll = false
                end
            end
            if pickups.morbidHearts ~= 0 then
                if amt >= hurt.HitPoints then
                    if math.random() < (1/(30 * (0.75 ^ ((1 + (0.33* pickups.morbidHearts)) + (0.05 * parent:GetData().inheritedPlayerStats.Luck))))) then
                        local minion = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, Isaac.GetEntityVariantByName("Morbid Chunk"), 1, hurt.Position, Vector.Zero, player)
                        minion.EntityCollisionClass = 4
                        minion.Parent = player
            
                        local data = minion:GetData()
                        data.hollow = true
                        data.canreroll = false
                    end
                end
            end
            if pickups.hauntedCoins ~= 0 then
                if amt >= hurt.HitPoints then
                    if math.random() < (1/(24 * (0.75 ^ ((1 + pickups.hauntedCoins) + (0.05 * parent:GetData().inheritedPlayerStats.Luck))))) then
                        local minion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 1, hurt.Position, Vector.Zero, player)
                        minion.Parent = player
                    end
                end
            end
            if pickups.coins ~= 0 then
                if amt >= hurt.HitPoints then
                    if math.random() < (1/(128 * (0.9 ^ ((pickups.coins) + (0.005 * parent:GetData().inheritedPlayerStats.Luck))))) then
                        SFXManager():Play(SoundEffect.SOUND_CASH_REGISTER,0.8,0,false,1,0)
                        local minion = Isaac.Spawn(EntityType.ENTITY_PICKUP, 0, 0, Game():GetRoom():FindFreePickupSpawnPosition(hurt.Position, 1, true, false), Vector.Zero, player)
                    end
                end
            end
            if pickups.boneHearts ~= 0 then
                if amt >= hurt.HitPoints then
                    for i=0, (3*pickups.boneHearts) do
                        Isaac.Spawn(EntityType.ENTITY_FAMILIAR,FamiliarVariant.BONE_SPUR,0,hurt.Position,Vector(math.random(0,6),0):Rotated(math.random(0,359)),player)
                    end
                end
            end

            if pickups.rottenHearts ~= 0 then
                if amt >= hurt.HitPoints then
                    for i=0, (3*pickups.boneHearts) do
                        Isaac.Spawn(EntityType.ENTITY_FAMILIAR,FamiliarVariant.BONE_SPUR,0,hurt.Position,Vector(math.random(0,6),0):Rotated(math.random(0,359)),player)
                    end
                end
            end

            if pickups.trollBombs ~= 0 then
                if math.random() < (1/(16 * (0.75 ^ (pickups.trollBombs)))) then
                    SFXManager():Play(Isaac.GetSoundIdByName("AceVenturaLaugh"),2,0,false,0.9,0)
                    Isaac.Explode(hurt.Position, player, parent:GetData().inheritedPlayerStats.Damage*2)
                end
            end

            if pickups.virtuousBatteries ~= 0 then
                if amt >= hurt.HitPoints then
                    if math.random() < (1/(16 * (0.75 ^ ((1 + (pickups.virtuousBatteries)) + (0.05 * parent:GetData().inheritedPlayerStats.Luck))))) then
                        SFXManager():Play(SoundEffect.SOUND_HOLY,2,0,false,1.5,0)
                        CLAY_SOLDIER:spawnVirtuousBatteryWisp(parent:ToFamiliar().Player, nil)
                    end
                end
            end

            if pickups.fireworkBatteries ~= 0 then
                if amt >= hurt.HitPoints then
                    if true then
                        for i=0, pickups.fireworkBatteries do
                            --SFXManager():Play(SoundEffect.SOUND_HOLY,2,0,false,1.5,0)
                            local firework = Isaac.Spawn(2,932,FiendFolio:RandomInt(0,2),hurt.Position,RandomVector():Resized(10),player)
                            local fwData = firework:GetData()
                            fwData.Damage = parent:GetData().inheritedPlayerStats.Damage * math.random(1,math.floor((pickups.fireworkBatteries * 5)/2))
                            fwData.IsFireworkRocket = true --So it "works" with multidimensional baby
                            sfx:Play(FiendFolio.Sounds.ExcelsiorShoot, 0.5)
                        end
                    end
                end
            end

            if pickups.cursedBatteries ~= 0 then
                if amt >= hurt.HitPoints then
                    SFXManager():Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_BURST,1,0,false,0.8,0)
                    for i=0, (3*pickups.cursedBatteries) do
                        local zappies = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.CHAIN_LIGHTNING,0,hurt.Position,Vector.Zero,player):ToEffect()
                        zappies.CollisionDamage = parent:GetData().inheritedPlayerStats.Damage * (1 * (1.25^pickups.cursedBatteries))
                    end
                end
            end

            if pickups.rottenHearts ~= 0 then
                if amt >= hurt.HitPoints then
                    SFXManager():Play(SoundEffect.SOUND_FART_GURG,1,0,false,0.8,0)
                    local bugToSpawn = 0
                    for i=1, pickups.rottenHearts do
                        bugToSpawn = math.random(0,2)
                        if bugToSpawn == 0 then
                            Isaac.Spawn(EntityType.ENTITY_FAMILIAR,FamiliarVariant.BLUE_FLY,0,hurt.Position,Vector(6,0):Rotated(math.random(0,359)),player):ToFamiliar()
                        elseif bugToSpawn == 1 then
                            Isaac.Spawn(EntityType.ENTITY_FAMILIAR,FamiliarVariant.BLUE_SPIDER,0,hurt.Position,Vector(6,0):Rotated(math.random(0,359)),player):ToFamiliar()
                        elseif bugToSpawn == 2 then
                            Isaac.Spawn(BotB.Enums.Entities.ATTACK_ANT_ENEMY.TYPE, BotB.Enums.Entities.ATTACK_ANT_ENEMY.VARIANT, 0, hurt.Position, Vector(6,0):Rotated(math.random(0,359)), player):ToNPC()
                        elseif bugToSpawn == 3 then
                            Isaac.Spawn(EntityType.ENTITY_FAMILIAR,1026,0,hurt.Position,Vector(6,0):Rotated(math.random(0,359)),player):ToFamiliar()
                        end
                    end
                end
            end

        end  
    end
    

end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CLAY_SOLDIER.onNPCKill)

function CLAY_SOLDIER:onSoldierNPCHurt(hurt,amt,flags,src)
    --local source = src.Entity
    --if hurt:IsVulnerableEnemy() == false then return end
    if not (hurt.Type == BotB.Enums.Entities.CLAY_SOLDIER.TYPE and hurt.Variant == BotB.Enums.Entities.CLAY_SOLDIER.VARIANT) then return end

    if hurt.Parent ~= nil then
        
        if not (hurt.Parent.Type == EntityType.ENTITY_FAMILIAR and hurt.Parent.Variant == BotB.Enums.Familiars.CLAY_SOLDIER_TRACKER.VARIANT) then return end
            print("owie")
            local parent = hurt.Parent
            local pickups = parent:GetData().pickupTable
            local player = hurt.Parent:ToFamiliar().Player
            print(pickups.immoralHearts)
            if pickups.immoralHearts ~= 0 then
                if amt >= hurt.HitPoints then
                    for i=0, (3*pickups.immoralHearts) do
                        local minion = Isaac.Spawn(1000, EffectVariant.PICKUP_FIEND_MINION, 1, hurt.Position, Vector.Zero, player)
                        minion.EntityCollisionClass = 4
                        minion.Parent = player
            
                        local data = minion:GetData()
                        data.hollow = true
                        data.canreroll = false
                    end
                else
                    for i=0, pickups.immoralHearts do
                        local minion = Isaac.Spawn(1000, EffectVariant.PICKUP_FIEND_MINION, 1, hurt.Position, Vector.Zero, player)
                        minion.EntityCollisionClass = 4
                        minion.Parent = player
            
                        local data = minion:GetData()
                        data.hollow = true
                        data.canreroll = false
                    end
                end
                
            end

            if pickups.goldenHearts ~= 0 then
                if amt >= hurt.HitPoints then
                    for i=0, (3*pickups.goldenHearts) do
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COIN,0,hurt.Position,Vector(math.random(0,6),0):Rotated(math.random(0,359)),player)
                    end
                else
                    for i=0, pickups.goldenHearts do
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COIN,0,hurt.Position,Vector(math.random(0,6),0):Rotated(math.random(0,359)),player)
                    end
                end
            end

            if pickups.boneHearts ~= 0 then
                if amt >= hurt.HitPoints then
                    for i=0, (4*pickups.boneHearts) do
                        Isaac.Spawn(EntityType.ENTITY_FAMILIAR,FamiliarVariant.BONE_ORBITAL,0,hurt.Position,Vector(math.random(0,6),0):Rotated(math.random(0,359)),player)
                    end
                else
                    for i=0, pickups.goldenHearts do
                        Isaac.Spawn(EntityType.ENTITY_FAMILIAR,FamiliarVariant.BONE_ORBITAL,0,hurt.Position,Vector(math.random(0,6),0):Rotated(math.random(0,359)),player)
                    end
                end
            end

            if pickups.rottenHearts ~= 0 then
                if amt >= hurt.HitPoints then
                    SFXManager():Play(SoundEffect.SOUND_FART_GURG,1,0,false,0.8,0)
                    local bugToSpawn = 0
                    for i=1, pickups.rottenHearts do
                        bugToSpawn = math.random(0,1)
                        if bugToSpawn == 0 then
                            Isaac.Spawn(EntityType.ENTITY_FAMILIAR,FamiliarVariant.BLUE_FLY,math.random(5) + 1,hurt.Position,Vector.Zero,player):ToFamiliar()
                        elseif bugToSpawn == 1 then
                            Isaac.Spawn(EntityType.ENTITY_FAMILIAR,1026,math.random(1,4),hurt.Position,Vector(6,0):Rotated(math.random(0,359)),player):ToFamiliar()
                        end
                    end
                end
            end
    end
    

end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CLAY_SOLDIER.onSoldierNPCHurt)

function CLAY_SOLDIER:FireInheritedWeapon(familiar, angleOffset)
    local npc = familiar:ToFamiliar()
    local data = npc:GetData()
    local offset = angleOffset or 0
    if npc.Player:HasWeaponType(WeaponType.WEAPON_TEARS) then
        local firedTear = npc.Player:FireTear(data.familiarEnemy.Position, Vector(10*data.inheritedPlayerStats.ShotSpeed,0):Rotated(data.fireAngle + offset), true, true, false, npc.Player, 1):ToTear()
        firedTear.CollisionDamage = data.inheritedPlayerStats.Damage
        if firedTear.CollisionDamage ~= data.rawInheritedPlayerStats.Damage then --copper bomb shit
            firedTear.Scale = firedTear.Scale * (((data.inheritedPlayerStats.Damage / data.rawInheritedPlayerStats.Damage)*0.5)+0.5)
        end
        --firedTear.FallingAcceleration = data.inheritedPlayerStats.TearFallingAcceleration
        --firedTear.FallingSpeed = data.inheritedPlayerStats.TearFallingSpeed
        --firedTear.Height = data.inheritedPlayerStats.TearHeight
        firedTear:GetData().isFromClaySoldier = true
        firedTear:GetData().adjustmentTarget = data.followingTarget
        firedTear.Parent = data.familiarEnemy
        --firedTear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
        firedTear:AddTearFlags(data.inheritedPlayerStats.TearFlags)
        if data.doAdditionalTearEffects == true then
            firedTear:AddTearFlags(data.additionalTearFlags)
        end
        --print(data.fireAngle)
        
    end
    if npc.Player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
        local firedTear = npc.Player:FireBrimstone(Vector(10*data.inheritedPlayerStats.ShotSpeed,0):Rotated(data.fireAngle + offset), npc.Player, 1):ToLaser()
        firedTear.CollisionDamage = data.inheritedPlayerStats.Damage
        firedTear.Parent = data.familiarEnemy
        firedTear.Position = data.familiarEnemy.Position
        firedTear:AddTearFlags(data.inheritedPlayerStats.TearFlags)
        firedTear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
        if data.doAdditionalTearEffects == true then
            firedTear:AddTearFlags(data.additionalTearFlags)
        end
    end
    if npc.Player:HasWeaponType(WeaponType.WEAPON_LASER) then
        local firedTear = npc.Player:FireTechLaser(data.familiarEnemy.Position, LaserOffset.LASER_TECH1_OFFSET, Vector(10*data.inheritedPlayerStats.ShotSpeed,0):Rotated(data.fireAngle + offset), false, false, npc.Player):ToLaser()
        firedTear.CollisionDamage = data.inheritedPlayerStats.Damage
        firedTear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
        firedTear:AddTearFlags(data.inheritedPlayerStats.TearFlags)
        if data.doAdditionalTearEffects == true then
            firedTear:AddTearFlags(data.additionalTearFlags)
        end
        
    end
    if npc.Player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
        if data.myKnife == nil then
            data.myKnife = npc.Player:FireKnife(data.familiarEnemy, 0, false, 0, 0):ToKnife()
            data.myKnife:AddTearFlags(data.inheritedPlayerStats.TearFlags)
            data.myKnife:AddTearFlags(TearFlags.TEAR_SPECTRAL)
            data.myKnife.Rotation = data.fireAngle + offset
            data.myKnife:Shoot(1, 99)
            if data.doAdditionalTearEffects == true then
            data.myKnife:AddTearFlags(data.additionalTearFlags)
            end
            
        else
            if data.myKnife:IsFlying() == false then
                data.myKnife.Rotation = data.fireAngle + offset
                data.myKnife:Shoot(1, 99)
            end
            
        end
    end
    if npc.Player:HasWeaponType(WeaponType.WEAPON_BONE) then
        if npc.Player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE, false) then
            if data.myKnife == nil then
                data.myKnife = npc.Player:FireKnife(data.familiarEnemy, 0, false, 0, 2):ToKnife()
                data.myKnife:AddTearFlags(data.inheritedPlayerStats.TearFlags)
                data.myKnife:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                data.myKnife.Rotation = data.fireAngle + offset
                if data.doAdditionalTearEffects == true then
                    data.myKnife:AddTearFlags(data.additionalTearFlags)
                    end
                
                local dudedistance = (data.familiarEnemy.Position - npc.Position):Length()
                if dudedistance < 100 then
                    --data.myKnife:Shoot(0, 99)
                    data.myKnife.Visible = false
                    if data.invisibleFetus == nil or data.invisibleFetus:IsDead() then
                        data.invisibleFetus = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.FETUS,0,data.familiarEnemy.Position,Vector.Zero,npc.Player):ToTear()
                        data.invisibleFetus:AddTearFlags(TearFlags.TEAR_FETUS | TearFlags.TEAR_FETUS_BONE | TearFlags.TEAR_FETUS_KNIFE )
                        data.invisibleFetus.HomingFriction = 0
                        data.invisibleFetus:GetData().isInvisibleFetus = true
                        data.invisibleFetus.Color = Color(1,1,1,1)
                        data.invisibleFetus.Visible = false
                        data.invisibleFetus.FallingSpeed = -1
                        data.invisibleFetus.FallingAcceleration = -0.2
                        data.invisibleFetus.Scale = 1.5
                        data.invisibleFetus:GetData().followThisDude = data.familiarEnemy
                    end
                else
                    data.myKnife.Visible = true
                    data.myKnife:Shoot(1, 99)
                end
            else
                if data.myKnife.Variant ~= 2 then
                    data.myKnife.Variant = 2
                end
                if data.myKnife:IsFlying() == false then
                    data.myKnife.Rotation = data.fireAngle + offset
                    local dudedistance = (data.familiarEnemy.Position - npc.Position):Length()
                    if dudedistance < 100 then
                        data.myKnife.Visible = false
                        --data.myKnife:Shoot(0, 99)
                        if data.invisibleFetus == nil or data.invisibleFetus:IsDead() then
                            data.invisibleFetus = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.FETUS,0,data.familiarEnemy.Position,Vector.Zero,npc.Player):ToTear()
                            data.invisibleFetus:AddTearFlags(TearFlags.TEAR_FETUS | TearFlags.TEAR_FETUS_BONE | TearFlags.TEAR_FETUS_KNIFE )
                            data.invisibleFetus.HomingFriction = 0
                            data.invisibleFetus:GetData().isInvisibleFetus = true
                            data.invisibleFetus.Color = Color(1,1,1,1)
                            data.invisibleFetus.Visible = false
                            data.invisibleFetus.FallingSpeed = -1
                            data.invisibleFetus.FallingAcceleration = -0.2
                            data.invisibleFetus.Scale = 1.5
                            data.invisibleFetus:GetData().followThisDude = data.familiarEnemy
                        end
                    else
                        data.myKnife.Visible = true
                        data.myKnife:Shoot(1, 99)
                    end
                end
                
            end
        else
            if data.myKnife == nil then
                data.myKnife = npc.Player:FireKnife(data.familiarEnemy, 0, false, 0, 1):ToKnife()
                data.myKnife:AddTearFlags(data.inheritedPlayerStats.TearFlags)
                data.myKnife:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                data.myKnife.Rotation = data.fireAngle + offset
                if data.doAdditionalTearEffects == true then
                    data.myKnife:AddTearFlags(data.additionalTearFlags)
                    end
                    local dudedistance = (data.familiarEnemy.Position - npc.Position):Length()
                    if dudedistance < 100 then
                        data.myKnife.Visible = false
                        if data.invisibleFetus == nil or data.invisibleFetus:IsDead() then
                            data.invisibleFetus = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.FETUS,0,data.familiarEnemy.Position,Vector.Zero,npc.Player):ToTear()
                            data.invisibleFetus:AddTearFlags(TearFlags.TEAR_FETUS | TearFlags.TEAR_FETUS_BONE)
                            data.invisibleFetus.HomingFriction = 0
                            data.invisibleFetus:GetData().isInvisibleFetus = true
                            data.invisibleFetus.Color = Color(1,1,1,1)
                            data.invisibleFetus.Visible = false
                            data.invisibleFetus.FallingSpeed = -1
                            data.invisibleFetus.FallingAcceleration = -0.2
                            data.invisibleFetus.Scale = 1.5
                            data.invisibleFetus:GetData().followThisDude = data.familiarEnemy
                        end
                    else
                        data.myKnife.Visible = true
                        data.myKnife:Shoot(1, 99)
                    end
                
            else
                if data.myKnife:IsFlying() == false then
                    data.myKnife.Rotation = data.fireAngle + offset
                    local dudedistance = (data.familiarEnemy.Position - npc.Position):Length()
                    if dudedistance < 100 then
                        data.myKnife.Visible = false
                        if data.invisibleFetus == nil or data.invisibleFetus:IsDead() then
                            data.invisibleFetus = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.FETUS,0,data.familiarEnemy.Position,Vector.Zero,npc.Player):ToTear()
                            data.invisibleFetus:AddTearFlags(TearFlags.TEAR_FETUS | TearFlags.TEAR_FETUS_BONE)
                            data.invisibleFetus.HomingFriction = 0
                            data.invisibleFetus:GetData().isInvisibleFetus = true
                            data.invisibleFetus.Color = Color(1,1,1,1)
                            data.invisibleFetus.Visible = false
                            data.invisibleFetus.FallingSpeed = -1
                            data.invisibleFetus.FallingAcceleration = -0.2
                            data.invisibleFetus.Scale = 1.5
                            data.invisibleFetus:GetData().followThisDude = data.familiarEnemy
                        end
                    else
                        data.myKnife.Visible = true
                        data.myKnife:Shoot(1, 99)
                    end
                end
                
            end
        end
    end

    if npc.Player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
        local firedTear = npc.Player:FireTechXLaser(data.familiarEnemy.Position, Vector(10*data.inheritedPlayerStats.ShotSpeed,0):Rotated(data.fireAngle + offset), 50, npc.Player, 1):ToLaser()
        firedTear.CollisionDamage = data.inheritedPlayerStats.Damage
        firedTear:AddTearFlags(data.inheritedPlayerStats.TearFlags)
        firedTear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
        if data.doAdditionalTearEffects == true then
            firedTear:AddTearFlags(data.additionalTearFlags)
        end
    end


end

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("The Lesser Key"), "Grants a unique familiar who is buffed by consuming all the pickups in the room. #(Cannot consume pedestal items)")
end

function CLAY_SOLDIER:NPCUpdate(npc)

    


    if npc.Type == BotB.Enums.Entities.CLAY_SOLDIER.TYPE and npc.Variant == BotB.Enums.Entities.CLAY_SOLDIER.VARIANT then 

        --print("nutsack")
        local data = npc:GetData()
        local pdata = npc.Parent:GetData()
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        --[[
        if npc.Parent ~= nil and npc.Parent.Target ~= nil then
            target = npc.Parent.Target
        end]]
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local claySoldierPathfinder = npc.Pathfinder
        local parentdistance = (npc.Parent.Position - npc.Position):Length()
        local playerdistance = (npc.Parent:ToFamiliar().Player.Position - npc.Position):Length()
        --print(parentdistance)
        local parentangle = (npc.Parent.Position - npc.Position):GetAngleDegrees()
        local pdata = npc.Parent:GetData()
        --should lead their shots now
        npc.Parent:GetData().fireAngle = ((pdata.followingTarget.Position - npc.Position) + pdata.followingTarget.Velocity):GetAngleDegrees()
        
        
        
        if npc.State == 0 then
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                --sprite:PlayOverlay("IdleDown")
                npc.State = 99
            end
            data.doEID = false
        end
        if data.doEID == nil then
            data.doEID = false
            data.noMove = false
        end
        if data.pickupTable.spicyKeys ~= 0 then
            if npc.FrameCount % math.ceil(120 * (0.5 ^ data.pickupTable.spicyKeys)) == 0 then
                local burnTarget = CLAY_SOLDIER:findNearestEnemy(npc)
                if burnTarget ~= nil then
                    if (burnTarget.Position - npc.Position):Length() >= 200 * data.pickupTable.keys then
                        burnTarget:AddBurn(EntityRef(npc.Parent:ToFamiliar().Player), (20 * (data.pickupTable.keys))+3, (pdata.inheritedPlayerStats.Damage)*0.25)
                    end
                end
            end
        end

        if data.pickupTable.legoCoins ~= 0 then
            if npc.FrameCount % 4 == 0 then
                local roomEntities = Isaac.GetRoomEntities() -- table
                for i = 1, #roomEntities do
                    local entity = roomEntities[i]
                    if entity:IsVulnerableEnemy() and not (entity.Type == BotB.Enums.Entities.CLAY_SOLDIER.TYPE and entity.Variant == BotB.Enums.Entities.CLAY_SOLDIER.VARIANT) and EntityRef(entity).IsFriendly == false then
                        if (entity.Position - npc.Position):Length() < (25*data.pickupTable.legoCoins) then
                            entity:TakeDamage(pdata.inheritedPlayerStats.Damage * 0.01, DamageFlag.DAMAGE_NOKILL, EntityRef(npc.Parent:ToFamiliar().Player), 0)
                            --print(bestCandidate.Position)
                        end
                    end
                end
            end
        end

        if data.pickupTable.chargedKeys ~= 0 and (Game():GetRoom():IsClear() == false or doesRoomHaveEnemies()) then
            if npc.FrameCount % math.ceil(120 * (0.75 ^ data.pickupTable.chargedKeys)) == 0 then
                for i=0, data.pickupTable.chargedKeys do
                    local zappies = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.CHAIN_LIGHTNING,0,npc.Position,Vector.Zero,npc):ToEffect()
                    zappies.CollisionDamage = pdata.inheritedPlayerStats.Damage * 2
                end
            end
        end

        if data.pickupTable.eternalHearts ~= 0 then
            if npc.FrameCount % 2 == 0 and npc.HitPoints ~= npc.MaxHitPoints then
                npc.HitPoints = npc.HitPoints * (1 + 0.5*(((1-(npc.HitPoints/npc.MaxHitPoints))) ^ data.pickupTable.eternalHearts))
                if npc.HitPoints >= npc.MaxHitPoints then
                    npc.HitPoints = npc.MaxHitPoints
                end
                FiendFolio.MarkForMartyrDeath(npc, player, 300 * data.pickupTable.eternalHearts, false)
            end
        end

        if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
        if npc.State == 99 then
            --
            local animAngle = parentangle % 360
            --print(animAngle)
            sprite.FlipX = false
            if animAngle % 360 > 315 or animAngle % 360 <= 45 then
                --print("sector 1")
                sprite:PlayOverlay("IdleRight")                
            elseif animAngle % 360 > 45 and animAngle % 360 <= 135 then
                --print("sector 2")
                sprite:PlayOverlay("IdleDown")

            elseif animAngle % 360 > 135 and animAngle % 360 <= 225 then
                --print("sector 3")
                sprite:PlayOverlay("IdleRight")

            elseif animAngle % 360 > 225 and animAngle % 360 <= 315 then
                sprite:PlayOverlay("IdleUp")

            end

            

            
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.75)
            local room = Game():GetRoom()
            --[[
            if claySoldierPathfinder:HasDirectPath(npc.Parent.Position) == false then
                print("yurt")
                claySoldierPathfinder:FindGridPath(room:FindFreePickupSpawnPosition(npc.Parent:ToFamiliar().Player.Position, 1, true, false), (pdata.inheritedPlayerStats.MoveSpeed)*0.5, 0, false)
            else
                print("gunt")
                claySoldierPathfinder:FindGridPath(room:FindFreePickupSpawnPosition(npc.Parent.Position, 1, true, false), (pdata.inheritedPlayerStats.MoveSpeed)*0.5, 0, true)
            end]]
            --claySoldierPathfinder:FindGridPath(room:FindFreePickupSpawnPosition(npc.Parent.Position, 1, true, false), (pdata.inheritedPlayerStats.MoveSpeed)*0.5, 0, true)
            --
            if data.noMove == false then
                claySoldierPathfinder:FindGridPath(room:FindFreePickupSpawnPosition(npc.Parent.Position, 1, true, false), (pdata.inheritedPlayerStats.MoveSpeed)*0.5, 0, true)
            else
                npc.Velocity = 0.8 * npc.Velocity
            end
            --print(targetdistance)
            --both values in the vector are the same so what does it matter?
            --
            local room = Game():GetRoom()
            --print(npc.Parent:GetData().fireDelay)
            if (room:IsClear() == false or doesRoomHaveEnemies()) and (npc.Parent.Position - npc.Parent:ToFamiliar().Player.Position):Length() > 10 and npc.Parent:GetData().fireDelay == 0 and parentdistance <= (npc.Parent:GetData().inheritedPlayerStats.TearRange/2) then
                npc.State = 100
                --
                if animAngle % 360 > 315 or animAngle % 360 <= 45 then
                    --print("sector 1")
                    sprite:PlayOverlay("ShootRight")                
                elseif animAngle % 360 > 45 and animAngle % 360 <= 135 then
                    --print("sector 2")
                    sprite:PlayOverlay("ShootDown")
    
                elseif animAngle % 360 > 135 and animAngle % 360 <= 225 then
                    --print("sector 3")
                    sprite:PlayOverlay("ShootRight")
    
                elseif animAngle % 360 > 225 and animAngle % 360 <= 315 then
                    sprite:PlayOverlay("ShootUp")
    
                end
                
                
            end
            
            --[[
            if (npc.FrameCount) % 60 == 0 then
                print("do it")
                OOZER:spawnTempRadCircle(true,500,0.5,npc.Position,npc)
            end]]
        end

        --print(sprite:GetOverlayFrame())
            if npc.State == 100 then
                if sprite:GetOverlayFrame() == 1 then
                    SFXManager():Play(SoundEffect.SOUND_TEARS_FIRE,1,0,false,math.random(800,900)/1000)
                    npc.State = 99
                end

                local room = Game():GetRoom()
            
                        --[[
            if claySoldierPathfinder:HasDirectPath(npc.Parent.Position) == false then
                print("yurt")
                claySoldierPathfinder:FindGridPath(room:FindFreePickupSpawnPosition(npc.Parent:ToFamiliar().Player.Position, 1, true, false), (pdata.inheritedPlayerStats.MoveSpeed)*0.5, 0, false)
            else
                print("gunt")
                claySoldierPathfinder:FindGridPath(room:FindFreePickupSpawnPosition(npc.Parent.Position, 1, true, false), (pdata.inheritedPlayerStats.MoveSpeed)*0.5, 0, true)
            end]]
            if data.noMove == false then
                claySoldierPathfinder:FindGridPath(room:FindFreePickupSpawnPosition(npc.Parent.Position, 1, true, false), (pdata.inheritedPlayerStats.MoveSpeed)*0.5, 0, true)
            else
                npc.Velocity = 0.8 * npc.Velocity
            end
                
                --
                if sprite:IsOverlayFinished() then
                    local animAngle = parentangle % 360
                    --print(animAngle)
                    sprite.FlipX = false
                    if animAngle % 360 > 315 or animAngle % 360 <= 45 then
                        --print("sector 1")
                        sprite:PlayOverlay("IdleRight")                
                    elseif animAngle % 360 > 45 and animAngle % 360 <= 135 then
                        --print("sector 2")
                        sprite:PlayOverlay("IdleDown")
        
                    elseif animAngle % 360 > 135 and animAngle % 360 <= 225 then
                        --print("sector 3")
                        sprite:PlayOverlay("IdleRight")
        
                    elseif animAngle % 360 > 225 and animAngle % 360 <= 315 then
                        sprite:PlayOverlay("IdleUp")
        
                    end
                    --sprite:PlayOverlay("IdleDown")
                    npc.State = 99
                end
                

            end
            --[[
            if npc.Parent:ToFamiliar().Player:GetPlayerType() == PLAYER_TOLOMON then
                --tolomon only features
                if Input.IsActionTriggered(ButtonAction.ACTION_MAP, npc.Parent:ToFamiliar().Player.ControllerIndex)  then
                    local f = Font() -- init font object
                    f:Load("font/pftempestasevencondensed.fnt") -- load a font into the font object
                    -- In a render function on every frame:
                    local healthMeter = "" .. npc.HitPoints .. "/" .. npc.MaxHitPoints .. ""
                    local widthOffset = f:GetStringWidth(healthMeter)/2
                    f:DrawString(healthMeter,Isaac.WorldToScreen(npc.Position).X - widthOffset,Isaac.WorldToScreen(npc.Position).Y-40,KColor(1,1,1,1),0,true) -- render string with loaded font on position (60, 50)
                    --Isaac.RenderText(npc.Type .. "." .. npc.Variant .. "." .. npc.SubType, Isaac.WorldToScreen(npc.Position).X - 20,Isaac.WorldToScreen(npc.Position).Y-40,1,1,1,1)
                end
            end
            ]]
            --Isaac.RenderText(npc.Type .. "." .. npc.Variant .. "." .. npc.SubType, Isaac.WorldToScreen(npc.Position).X - 20,Isaac.WorldToScreen(npc.Position).Y-40,1,1,1,1)
        --print(sprite:GetOverlayAnimation())
            if npc:HasMortalDamage() then
                
                pdata.isFirstTimeSpawning = false
                pdata.homunculusRecoveryTime = pdata.homunculusRecoveryTimeMax
                
                --data.chargeBar = recoveryChargeBar
            end

            if data.doEID == true then
                data["EID_Description"] = data.eidOnTab
            else
                data["EID_Description"] = nil
            end
            --print(data.eidOnTab)
        

    end
        
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, CLAY_SOLDIER.NPCUpdate, Isaac.GetEntityTypeByName("Clay Soldier"))


function CLAY_SOLDIER:NPCRender(npc)

    


    if npc.Type == BotB.Enums.Entities.CLAY_SOLDIER.TYPE and npc.Variant == BotB.Enums.Entities.CLAY_SOLDIER.VARIANT then 

        local pdata = npc.Parent:GetData()
        local data = npc:GetData()
        if npc.Parent:ToFamiliar().Player:GetPlayerType() == PLAYER_TOLOMON then
            --tolomon only features
            if Input.IsActionPressed(ButtonAction.ACTION_MAP, npc.Parent:ToFamiliar().Player.ControllerIndex)  then
                local f = Font() -- init font object
                f:Load("font/pftempestasevencondensed.fnt") -- load a font into the font object
                -- In a render function on every frame:
                local healthMeter = "" .. math.floor((1000*(npc.HitPoints)))/1000 .. "/" .. npc.MaxHitPoints .. ""
                local widthOffset = f:GetStringWidth(healthMeter)/2
                f:DrawString(healthMeter,Isaac.WorldToScreen(npc.Position).X - widthOffset,Isaac.WorldToScreen(npc.Position).Y-60,KColor(1,1,1,1),0,true) -- render string with loaded font on position (60, 50)
                --Isaac.RenderText(npc.Type .. "." .. npc.Variant .. "." .. npc.SubType, Isaac.WorldToScreen(npc.Position).X - 20,Isaac.WorldToScreen(npc.Position).Y-40,1,1,1,1)
                local roundedRecoveryTime = math.floor((1000*(pdata.homunculusRecoveryTimeMax/60)))/1000
                local healthMeter2 = "Recovery time: " .. roundedRecoveryTime .. " sec."
                local widthOffset2 = f:GetStringWidth(healthMeter2)/2
                f:DrawString(healthMeter2,Isaac.WorldToScreen(npc.Position).X - widthOffset2,Isaac.WorldToScreen(npc.Position).Y-50,KColor(1,1,1,1),0,true)

            end
            if Input.IsActionPressed(ButtonAction.ACTION_MAP, npc.Parent:ToFamiliar().Player.ControllerIndex)  then

                    data.doEID = true
                else
                    data.doEID = false

            end
            if Input.IsActionPressed(ButtonAction.ACTION_DROP, npc.Parent:ToFamiliar().Player.ControllerIndex)  then
                data.noMove = true
            else
                data.noMove = false
            end
        end

    end
end

Mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, CLAY_SOLDIER.NPCRender, Isaac.GetEntityTypeByName("Clay Soldier"))

function CLAY_SOLDIER:resetPosOnNewRoom ()
    local roomEntities = Isaac.GetRoomEntities() 
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        if entity.Type == BotB.Enums.Entities.CLAY_SOLDIER.TYPE and entity.Variant == BotB.Enums.Entities.CLAY_SOLDIER.VARIANT then
            for i=0, 1000 do
                entity.Position =  Game():GetRoom():FindFreePickupSpawnPosition(Game():GetRoom():GetRandomPosition(10), 1, true, false)
                if entity:ToNPC().Pathfinder:HasPathToPos(entity.Parent:ToFamiliar().Player.Position, true) == true then
                    break
                end
            end
            
           
        end
    end

end
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM,CLAY_SOLDIER.resetPosOnNewRoom)

--Takes the pickup table and turns it into an itemized list of hearts/coins/yada yada
function CLAY_SOLDIER:pickupsToStatTable(pickupTable)
    local data = {}
    data.pickupTable = pickupTable
    if data.pickupTable ~= nil then
            --Red hearts: half 10.1, full 10.2, double 10.5, 10.9 scared
            --Soul hearts: half 10.8, full 10.3, 10.10 blended
            --Black hearts: half (FF) 1022.0, full 10.6, blended 1023.0
            --Eternal hearts: half 10.4 (include logic for Red Ribbon)
            --Gold hearts: full 10.7
            --Bone hearts: full 10.11
            --Rotten hearts: full 10.12
            --fiend hearts: half 1025.0, full 1024.0, blended 1026.0
            --morbid hearts: full 1028.0, 2/3rds 1029.0, 1/3rd 1030.0
            for i=1, #data.pickupTable do
                if data.numRedHearts == nil then
                    data.numRedHearts = 0
                end
                if data.numSoulHearts == nil then
                    data.numSoulHearts = 0
                end
                if data.numBlackHearts == nil then
                    data.numBlackHearts = 0
                end
                if data.numEternalHearts == nil then
                    data.numEternalHearts = 0
                end
                if data.numGoldHearts == nil then
                    data.numGoldHearts = 0
                end
                if data.numBoneHearts == nil then
                    data.numBoneHearts = 0
                end
                if data.numRottenHearts == nil then
                    data.numRottenHearts = 0
                end
                if data.numImmoralHearts == nil then
                    data.numImmoralHearts = 0
                end
                if data.numMorbidHearts == nil then
                    data.numMorbidHearts = 0
                end
                --    HEARTS   --
                if data.pickupTable[i][1] == 10 and data.pickupTable[i][2] == 1 then
                    --Full hearts
                    data.numRedHearts = data.numRedHearts + 2
                end
                if data.pickupTable[i][1] == 10 and data.pickupTable[i][2] == 2 then
                    --Half hearts
                    data.numRedHearts = data.numRedHearts + 1
                end
                if data.pickupTable[i][1] == 10 and data.pickupTable[i][2] == 5 then
                    --Double hearts
                    data.numRedHearts = data.numRedHearts + 4
                end
                if data.pickupTable[i][1] == 10 and data.pickupTable[i][2] == 9 then
                    --Scared hearts
                    data.numRedHearts = data.numRedHearts + 2
                end
                if data.pickupTable[i][1] == 10 and data.pickupTable[i][2] == 8 then
                    --Half soul hearts
                    data.numSoulHearts = data.numSoulHearts + 1
                end
                if data.pickupTable[i][1] == 10 and data.pickupTable[i][2] == 3 then
                    --Soul hearts
                    data.numSoulHearts = data.numSoulHearts + 2
                end
                if data.pickupTable[i][1] == 10 and data.pickupTable[i][2] == 10 then
                    --Blended hearts
                    data.numSoulHearts = data.numSoulHearts + 1
                    data.numRedHearts = data.numRedHearts + 1
                end
                if data.pickupTable[i][1] == 1022 then
                    --Half black hearts
                    data.numBlackHearts = data.numBlackHearts + 1
                end
                if data.pickupTable[i][1] == 10 and data.pickupTable[i][2] == 6 then
                    --Black hearts
                    data.numBlackHearts = data.numBlackHearts + 2
                end
                if data.pickupTable[i][1] == 1023 then
                    --Blended black hearts
                    data.numBlackHearts = data.numBlackHearts + 1
                    data.numRedHearts = data.numRedHearts + 1
                end
                if data.pickupTable[i][1] == 10 and data.pickupTable[i][2] == 4 then
                    --Eternal hearts
                    data.numEternalHearts = data.numEternalHearts + 1
                end
                if data.pickupTable[i][1] == 10 and data.pickupTable[i][2] == 7 then
                    --Gold hearts
                    data.numGoldHearts = data.numGoldHearts + 1
                end
                if data.pickupTable[i][1] == 10 and data.pickupTable[i][2] == 11 then
                    --Bone hearts
                    data.numBoneHearts = data.numBoneHearts + 1
                end
                if data.pickupTable[i][1] == 10 and data.pickupTable[i][2] == 12 then
                    --Gold hearts
                    data.numRottenHearts = data.numRottenHearts + 2
                end
                if data.pickupTable[i][1] == 1025 then
                    --Half immoral hearts
                    data.numImmoralHearts = data.numImmoralHearts + 1
                end
                if data.pickupTable[i][1] == 1024 then
                    --Full immoral hearts
                    data.numImmoralHearts = data.numImmoralHearts + 2
                end
                if data.pickupTable[i][1] == 1026 then
                    --Blended immoral hearts
                    data.numImmoralHearts = data.numImmoralHearts + 1
                    data.numRedHearts = data.numRedHearts + 1
                end
                if data.pickupTable[i][1] == 1028 then
                    --full morbid hearts
                    data.numMorbidHearts = data.numMorbidHearts + 3
                end
                if data.pickupTable[i][1] == 1029 then
                    --2/3rds morbid hearts
                    data.numMorbidHearts = data.numMorbidHearts + 2
                end
                if data.pickupTable[i][1] == 1030 then
                    --1/3rds immoral hearts
                    data.numMorbidHearts = data.numMorbidHearts + 1
                end

                --Plain coins: penny 20.1, double 20.4, nickel 20.2, dime 20.3, sticky nickel 20.6
                --lucky coins: lucky penny 20.5
                --golden coins: golden penny 20.7
                --cursed pennies: normal 20.213, golden 20.216
                --haunted penny: 20.214
                --honey penny: 20.215
                --lego stud: 20.217
                if data.numCoins == nil then
                    data.numCoins = 0
                end
                if data.numLuckyCoins == nil then
                    data.numLuckyCoins = 0
                end
                if data.numGoldenCoins == nil then
                    data.numGoldenCoins = 0
                end
                if data.numCursedCoins == nil then
                    data.numCursedCoins = 0
                end
                if data.numHauntedCoins == nil then
                    data.numHauntedCoins = 0
                end
                if data.numHoneyCoins == nil then
                    data.numHoneyCoins = 0
                end
                if data.numLegoCoins == nil then
                    data.numLegoCoins = 0
                end
                if data.pickupTable[i][1] == 20 and data.pickupTable[i][2] == 1 then
                    --Penny
                    data.numCoins = data.numCoins + 1
                end
                if data.pickupTable[i][1] == 20 and data.pickupTable[i][2] == 4 then
                    --Double penny
                    data.numCoins = data.numCoins + 2
                end
                if data.pickupTable[i][1] == 20 and data.pickupTable[i][2] == 2 then
                    --Nickel
                    data.numCoins = data.numCoins + 5
                end
                if data.pickupTable[i][1] == 20 and data.pickupTable[i][2] == 3 then
                    --Dime
                    data.numCoins = data.numCoins + 10
                end
                if data.pickupTable[i][1] == 20 and data.pickupTable[i][2] == 6 then
                    --Sticky nickel
                    data.numCoins = data.numCoins + 5
                end
                if data.pickupTable[i][1] == 20 and data.pickupTable[i][2] == 5 then
                    --lucky penny
                    data.numCoins = data.numCoins + 1
                    data.numLuckyCoins = data.numLuckyCoins + 1
                end
                if data.pickupTable[i][1] == 20 and data.pickupTable[i][2] == 7 then
                    --golden penny
                    data.numCoins = data.numCoins + 20
                    data.numGoldenCoins = data.numGoldenCoins + 1
                end
                if data.pickupTable[i][1] == 20 and data.pickupTable[i][2] == 213 then
                    --Cursed penny
                    data.numCursedCoins = data.numCursedCoins + 1
                    data.numCoins = data.numCoins + math.random(-3,3)
                end
                if data.pickupTable[i][1] == 20 and data.pickupTable[i][2] == 216 then
                    --Golden cursed penny
                    data.numCursedCoins = data.numCursedCoins + 5
                    data.numCoins = data.numCoins + math.random(0,10)
                end
                if data.pickupTable[i][1] == 20 and data.pickupTable[i][2] == 214 then
                    --Haunted penny
                    data.numHauntedCoins = data.numHauntedCoins + 1
                    data.numCoins = data.numCoins + 1
                end
                if data.pickupTable[i][1] == 20 and data.pickupTable[i][2] == 215 then
                    --Honey penny
                    data.numHoneyCoins = data.numHoneyCoins + 1
                    data.numCoins = data.numCoins + 1
                end
                if data.pickupTable[i][1] == 20 and data.pickupTable[i][2] == 217 then
                    --Lego stud
                    data.numLegoCoins = data.numLegoCoins + 1
                    data.numCoins = data.numCoins + 1
                end
                if data.numCoins < 0 then
                    data.numCoins = math.abs(data.numCoins)
                end

                --keys
                --plain: single 30.1, double 30.3
                --golden: single 30.2
                --charged: single 30.4
                --spicy: double 30.179 30.185, triple 30.180 30.186, charged 30.181 30.187, 
                       --triple 30.182, charged 30.183, quad 30.184, 
                if data.numKeys == nil then
                    data.numKeys = 0
                end
                if data.numGoldKeys == nil then
                    data.numGoldKeys = 0
                end
                if data.numChargedKeys == nil then
                    data.numChargedKeys = 0
                end
                if data.numSpicyKeys == nil then
                    data.numSpicyKeys = 0
                end

                if data.pickupTable[i][1] == 30 and data.pickupTable[i][2] == 1 then
                    --Single key
                    data.numKeys = data.numKeys + 1
                end
                if data.pickupTable[i][1] == 30 and data.pickupTable[i][2] == 3 then
                    --Double key
                    data.numKeys = data.numKeys + 2
                end
                if data.pickupTable[i][1] == 30 and data.pickupTable[i][2] == 2 then
                    --Gold key
                    data.numKeys = data.numKeys + 10
                    data.numGoldKeys = data.numGoldKeys + 1
                end
                if data.pickupTable[i][1] == 30 and data.pickupTable[i][2] == 4 then
                    --Charged key
                    data.numKeys = data.numKeys + 1
                    data.numChargedKeys = data.numChargedKeys + 1
                end
                if (data.pickupTable[i][1] == 30 and data.pickupTable[i][2] == 179) or (data.pickupTable[i][1] == 30 and data.pickupTable[i][2] == 185) then
                    --Spicy key
                    data.numKeys = data.numKeys + 2
                    data.numSpicyKeys = data.numSpicyKeys + 2
                end
                if (data.pickupTable[i][1] == 30 and data.pickupTable[i][2] == 180) or (data.pickupTable[i][1] == 30 and data.pickupTable[i][2] == 182) or (data.pickupTable[i][1] == 30 and data.pickupTable[i][2] == 186) then
                    --Super spicy key
                    data.numKeys = data.numKeys + 3
                    data.numSpicyKeys = data.numSpicyKeys + 3
                end
                if (data.pickupTable[i][1] == 30 and data.pickupTable[i][2] == 181) or (data.pickupTable[i][1] == 30 and data.pickupTable[i][2] == 183) or (data.pickupTable[i][1] == 30 and data.pickupTable[i][2] == 187) then
                    --Charged spicy key
                    data.numKeys = data.numKeys + 2
                    data.numChargedKeys = data.numChargedKeys + 2
                    data.numSpicyKeys = data.numSpicyKeys + 2
                end
                if data.pickupTable[i][1] == 30 and data.pickupTable[i][2] == 184 then
                    --Quad spicy key
                    data.numKeys = data.numKeys + 4
                    data.numSpicyKeys = data.numSpicyKeys + 4
                end

                --Bombs
                --plain: single 40.1, double 40.2, 
                --troll: single 40.3, megatroll 40.5
                --golden: single 40.4, 
                --giga: single 40.7
                --copper: single 40.923, double 40.924, blended 40.925
                if data.numBombs == nil then
                    data.numBombs = 0
                end
                if data.numTrollBombs == nil then
                    data.numTrollBombs = 0
                end
                if data.numGoldenBombs == nil then
                    data.numGoldenBombs = 0
                end
                if data.numGigaBombs == nil then
                    data.numGigaBombs = 0
                end
                if data.numCopperBombs == nil then
                    data.numCopperBombs = 0
                end

                if data.pickupTable[i][1] == 40 and data.pickupTable[i][2] == 1 then
                    --Single bomb
                    data.numBombs = data.numBombs + 1
                end
                if data.pickupTable[i][1] == 40 and data.pickupTable[i][2] == 2 then
                    --Double bomb
                    data.numBombs = data.numBombs + 2
                end
                if data.pickupTable[i][1] == 40 and data.pickupTable[i][2] == 3 then
                    --Troll
                    data.numBombs = data.numBombs + 1
                    data.numTrollBombs = data.numTrollBombs + 1
                end
                if data.pickupTable[i][1] == 40 and data.pickupTable[i][2] == 5 then
                    --Megatroll
                    data.numBombs = data.numBombs + 2
                    data.numTrollBombs = data.numTrollBombs + 2
                end
                if data.pickupTable[i][1] == 40 and data.pickupTable[i][2] == 4 then
                    --Golden
                    data.numBombs = data.numBombs + 1
                    data.numGoldenBombs = data.numGoldenBombs + 1
                end
                if data.pickupTable[i][1] == 40 and data.pickupTable[i][2] == 7 then
                    --GIGA
                    data.numBombs = data.numBombs + 5
                    data.numGigaBombs = data.numGigaBombs + 1
                end
                if data.pickupTable[i][1] == 40 and data.pickupTable[i][2] == 923 then
                    --Copper
                    data.numBombs = data.numBombs + 1
                    data.numCopperBombs = data.numCopperBombs + 1
                end
                if data.pickupTable[i][1] == 40 and data.pickupTable[i][2] == 924 then
                    --Double Copper
                    data.numBombs = data.numBombs + 2
                    data.numCopperBombs = data.numCopperBombs + 2
                end
                if data.pickupTable[i][1] == 40 and data.pickupTable[i][2] == 925 then
                    --Blended Copper
                    data.numBombs = data.numBombs + 2
                    data.numCopperBombs = data.numCopperBombs + 1
                end


                if data.numPills == nil then
                    data.numPills = 0
                end
                if data.numGoldPills == nil then
                    data.numGoldPills = 0
                end
                if data.numHorsePills == nil then
                    data.numHorsePills = 0
                end
                if data.numGoldHorsePills == nil then
                    data.numGoldHorsePills = 0
                end

                if data.numCards == nil then
                    data.numCards = 0
                end

                if data.pickupTable[i][1] == 70 and data.pickupTable[i][2] > PillColor.PILL_GIANT_FLAG then
                    --Normal pill
                    data.numPills = data.numPills + 1
                end
                if data.pickupTable[i][1] == 70 and data.pickupTable[i][2] == PillColor.PILL_GOLD then
                    --Gold pill
                    data.numGoldPills = data.numGoldPills + 1
                end
                if data.pickupTable[i][1] == 70 and data.pickupTable[i][2] <= PillColor.PILL_GIANT_FLAG then
                    --Gold pill
                    data.numHorsePills = data.numHorsePills + 1
                    data.numPills = data.numPills + 1
                end
                if data.pickupTable[i][1] == 70 and data.pickupTable[i][2] == PillColor.PILL_GOLD + PillColor.PILL_GIANT_FLAG then
                    --Gold pill
                    data.numGoldPills = data.numGoldPills + 2
                    data.numGoldHorsePills = data.numGoldHorsePills + 1
                end

                if data.pickupTable[i][1] == 300 then
                    --Card
                    data.numCards = data.numCards + 1
                end

                --Batteries
                --90.1 normal
                --90.2 micro
                --90.3 mega
                --90.4 golden
                --900 0 firework
                --901 0 virtuous
                --902 0 potato
                --903 0 cursed
                if data.numBatteries == nil then
                    data.numBatteries = 0
                end
                if data.numGoldBatteries == nil then
                    data.numGoldBatteries = 0
                end
                if data.numFireworkBatteries == nil then
                    data.numFireworkBatteries = 0
                end
                if data.numVirtuousBatteries == nil then
                    data.numVirtuousBatteries = 0
                end
                if data.numCursedBatteries == nil then
                    data.numCursedBatteries = 0
                end

                if data.pickupTable[i][1] == 90 and data.pickupTable[i][2] == 1 then
                    --Plain batteries
                    data.numBatteries = data.numBatteries + 4
                end
                if data.pickupTable[i][1] == 90 and data.pickupTable[i][2] == 2 then
                    --micro batteries
                    data.numBatteries = data.numBatteries + 2
                end
                if data.pickupTable[i][1] == 90 and data.pickupTable[i][2] == 3 then
                    --mega batteries
                    data.numBatteries = data.numBatteries + 8
                end
                if data.pickupTable[i][1] == 90 and data.pickupTable[i][2] == 4 then
                    --mega batteries
                    data.numBatteries = data.numBatteries + 16
                    data.numGoldBatteries = data.numGoldBatteries + 1
                end
                if data.pickupTable[i][1] == 900 then
                    --fw batteries
                    data.numBatteries = data.numBatteries + 4
                    data.numFireworkBatteries = data.numFireworkBatteries + 1
                end
                if data.pickupTable[i][1] == 901 then
                    --v batteries
                    data.numBatteries = data.numBatteries + 4
                    data.numVirtuousBatteries = data.numVirtuousBatteries + 1
                end
                if data.pickupTable[i][1] == 902 then
                    --potato batteries
                    data.numBatteries = data.numBatteries + 1
                end
                if data.pickupTable[i][1] == 903 then
                    --cursed batteries
                    data.numBatteries = data.numBatteries + math.random(1,8)
                    data.numCursedBatteries = data.numCursedBatteries + 1
                end


            end
            local statTable = {
                --hearts
                redHearts=data.numRedHearts,
                soulHearts=data.numSoulHearts,
                blackHearts=data.numBlackHearts,
                eternalHearts=data.numEternalHearts,
                goldenHearts = data.numGoldHearts,
                boneHearts=data.numBoneHearts,
                rottenHearts=data.numRottenHearts,
                immoralHearts=data.numImmoralHearts,
                morbidHearts = data.numMorbidHearts,
                --Coins
                coins = data.numCoins,
                luckyCoins = data.numLuckyCoins,
                goldenCoins = data.numGoldenCoins,
                cursedCoins = data.numCursedCoins,
                hauntedCoins = data.numHauntedCoins,
                honeyCoins = data.numHoneyCoins,
                legoCoins = data.numLegoCoins,
                --Keys
                keys = data.numKeys,
                goldenKeys = data.numGoldKeys,
                chargedKeys = data.numChargedKeys,
                spicyKeys = data.numSpicyKeys,
                --Bombs
                bombs = data.numBombs,
                trollBombs = data.numTrollBombs,
                goldenBombs = data.numGoldenBombs,
                gigaBombs = data.numGigaBombs,
                copperBombs = data.numCopperBombs,
                --Cards
                cards = data.numCards,
                --Pills
                pills = data.numPills,
                horsePills = data.numHorsePills,
                goldPills = data.numGoldPills,
                goldHorsePills = data.numGoldHorsePills,
                --Batteries
                batteries = data.numBatteries,
                goldenBatteries = data.numGoldBatteries,
                fireworkBatteries = data.numFireworkBatteries,
                virtuousBatteries = data.numVirtuousBatteries,
                cursedBatteries = data.numCursedBatteries,
            }

        --[[
        for i=1, #data.pickupTable do
            print("hello i have {" .. data.pickupTable[i][1] .. " , " .. data.pickupTable[i][2] .. "}")
        end]]
        return statTable
    end

end



local tolFamiliarNames = {
    --actual ingame character names
    "Isaac", "Maggy", "Magdalene", "Cain", "Judas", "Eve", "Samson", "???", "Blue Baby", "Ethan", "Azazel", "Lazarus", "Eden", "Lost", "Lilith", "Keeper", "Apollyon", "Forgotten", "Bethany", "Jacob", "Esau",
    "Guppy", "Tammy", "Cricket", "Max", "Kalu", "Moxie", "Bob", 
    --modded characters
    "Rebekah", "Gappi", "Fiend", "Golem", "Icarus", "Mammon", "Deleted", "Awan", "Job", "Andromeda", "Samael", "Solomon", "Jezebel", "Bertran", "Sarah", "Dante", "Charon", "!!!",
    --devs :) and friends
    "Millie", "Crispy", "Kuba", "Gabs", "Moofy", "Hyper", "Puter", "Alter", "Emi", "Gabs", "Lalhs", "Meojo", "Mac", "Cheese", "Gunk", "Gen", "Eric", "Smelly", "One", 
    --characters from random shit
    "Brad", "Wayne", "Nowak", "Bosch", "Anton", "Hans", "Leviat", "Bimini", "Terry", "Cromslor", "Pinskidan", "Finn", "Jake", "Bronwyn", "Coconteppi", "Jerry", "Prismo", "Scarab", "GOLB", "Simon", "Betty", "Fionna", "Cake", "Griffin", "Justin", "Travis",
    "Cox", "Crendor", "Bluey", "Bingo", "Bandit", "Chilli", "Muffin", "Socks", "Orbo", "Peeb", "Doomguy", "Daisy", "Red", "Felix", "Faux", "DJ", "Cyber", "Boki", "Savant", "Lymia", "Isotope", "Analog",
    "Denji", "Dennis", "Asa", "Ashley", "Power", "Pawa", "Konata", "Kagami", "Tsukasa", "Miyuki", "Misao", "Wubbzy", "Walden", "Widget", "Omori", "Mari", "Aubrey", "Kel", "Basil", 
    "Airy", "Liam", "Plecak", "Bryce", "Hansen", "Amelia", "Euler", "Taylor", "Nolan", "Charlotte", "Stern", "Charlie", "Howling", "Texty", "Stone", "Folder", "Atom", 
    "Tara", "Strong", "Twilight", "Sparkle", "Pinkie", "Pie", "Rainbow", "Dash", "Apple", "Jack", "Bloom", "Big Mac", "Flutter", "Shy", "Rarity", "Spike", "Colin", "Puro",
    "Kiryu", "Majima", "Nishiki", "Akira", "Tetsuo", "Navidson", "Francis", "Gabby", "Zaggy", "Orpho", "Gale", "Ponytail", "Pogey", "Leverette", "Mama", "Zelle", "Your Dad", "Terence", "Pumpkin", "Kid", "Cupper", "Dup",
    "Izu", "Kamiya", "Cyl", "Burger", "Cornchip", "Benny", "Pete", "Courier", "Joshua", "Graham", "Doctor", "Gumball", "Tyrone", "Darwin", "Richard", "Penny", "Anais", "Carrie", "Watterson", "Calvin", "Hobbes", "Suzy", "Ami", "Kento", "Iyo", "Issa",
    "Mario", "Luigi", "Peach", "Wario", "Waluigi", "Toad", "Ena", "Moony", "Argemia", "Bob", "Patrick", "Rose", "Boykisser", "BK", "Burger King", "McDonalds", "Taco Bell", "The People's Republic Of China",
    "The United States Of America", "The United Kingdom", "Spain", "Ireland", "Tainwan", "Trans Rights", "Enby", "Wint", "Dril", "Kitty", "Melody", "Kuromi", "Romina", "Daniel", "Maru", "Hana",
    "Finnegan", "Dixie", "Muttais", "Jotaro", "Joseph", "Kakyoin", "Dio", "Solid", "Liquid", "Gas", "Plasma", "Bose-Einstein Condensate", "Peppino", "Noise", "Scrimmy", "Bingus", "Crungy", "Spingus",
    "Bippo", "Pelb", "Tootsy", "Spingus", "Doinkus", "Tume", "Blepp", "Lumpus Umpus", "Lorge", "Brumbus", "Luckie", "Master Chuk", "Master", "Screwball", "Fifi", "Potato", "Lord", "Margeline", "Henry the Squirrel", "Tappy",
    "Thomas", "Henry", "James", "Leyland", "Kirby", "Flaky", "Flippy", "Nutty", "Tran", "Leland", "Fat", "Friend", "Roybertito", "Mal0", "[REDACTED]", "[DATA EXPUNGED]", "[CENSORED]", "[REMOVED BY THE PEOPLE'S REPUBLIC OF CHINA]", "[TRUST ME YOU DON'T WANNA KNOW]",
    "Cyanide", "Bleach", "Hammond", "Care", "Marvin", "Paul", "Tiara", "Belle", "Lina", "Rainer", "Phillip", "Poisson", "Phil", "Fish", "Sylvie", "Veevee", "Manly", "Badass", "Hero", "Dipper", "Mabel", "Stan", "Soos", "Urist", "Cacame",
    "Q Girl", "Joppa", "Ash", "Spewer", "Golgotha", "Exodus", "Cloaca", "Niko", "Alula", "Calamus", "Plight", "Rue", "George", "Kelvin", "Madotsuki", "Poniko", "Uboa", "Skye", "Everest", "Madeline", "Celeste", "Theo",
    "Distant", "Cry", "Looks To The Moon", "Five Pebbles", "No Significant Harassment", "Survivor", "Monk", "Hunter", "Gourmand", "Rivulet", "Artificer", "Spearmaster", "Saint", "Enot", "Inv", "Sofanthiel", "Toby", "Noelle", "Kris", "Susie",
    "V1", "V2", "Minos", "Sisyphus", "Mother", "Corruptus", "Skibidirizz", "Ohiogyatt", "Help! I'm trapped in a name factory!", "Dreamy", "Bull", "Ambatu", "Omaygot", "Gachi", "Muchi", "[Roland 169 \'Ahh!\' sound]", "[Wilhelm scream]", "[Toilet flushing sound]",
    "[Shotgun cocking sound]", "[School fire alarm noises]", "[Stock baby crying sound]", "Hengus", "Grengus", "Belps", "Alpohol", "Claire", "Edgar", "Pim", "Mister", "Missus", "Mix", "Big", "Glaggle", "HELP!", "HEEEEEELP!",
    "Toyota", "Honda", "Mazda", "Bugatti", "Ford", "Subaru", "Car", "Bike", "Plane", "Scooter", "Segway", "Booster", "Ragdoll", "Prop", "Mingebag", "Chikn", "Chee", "Iscream", "Fwench Fwy", "Sody Pop", "Cofi", "Spherefriend", "Egg", "Heir",
    "Sklimpton", "Rick James", "Bitch", "Conan", "Fucknut", "Shitnuts", "Finger", "Waltuh", "Jesse", "Saul", "Jimmy", "Jerma", "Reimu", "Marisa", "Sanae", "Reisen", "Tewi", "[This space intentionally left blank.]", "[Sexual moan]", "[Painful groan]", "[Loud burp]", "[Fart sound]",
    "[Loud, abrasive white noise]", "[Car horn sound]", "[Stock crying sound]", "[Explosion]", "Horse", "Dog", "Cat", "Rabbit", "Bnuuy", "Doggo", "Pupper", "Kity", "Dogy", "Pringles", "Your Mom", "Ray", "William", "Johnson",
    "Ed", "Edd", "Eddy", "Rolf", "Johnny", "Dukey", "Uncle", "Grandpa", "Garnet", "Amethyst", "Pearl", "Ruby", "Sapphire", "Lapis", "Peridot", "Steven", "Greg",
    --random bullshit i and friends came up with
    "Gurt", "Skluntt", "Gorky", "Crungle", "Fuck", "Shit", "Piss", "Boner", --I am very mature
    "Chunt", "Bungleton", "Fugorp", "Fenchalor", "Beebis", "Chongo", "Scrunt", "Shanaenae", "Lakakos", "Foog",
    "Fergus", "Brempel", "Scrumble", "Wimphort", "Kevin", "Kebin", "FlingyDeengee", "Waoflumt", "Queamples",  "Gaben At Valve Software Dot Com",
    "[The entirety of Pulse Demon by Merzbow]", "Moist", "Brungtt", "Jungus", "Flobing", "Bitorong", "Bolainas", "Pilgor", "Buckley","Buttnick", "Wanka", "Ol Chap","Fred Fuchs", "Xavier", "Smokey","Luchetti", "DICKTONG", "ASSPLITS", "TILLBIRTH", "Friendlyvilleson",
    "Filbit", "Quartet", "Snarled", "Flossing", "Dingdong", "BABING", "ticktok", "Generic", "Placeholder", "Namenotfound", "Isaac", "David Streaks from The Popular Webcomic Full House", "E", "Dude", "The Cooler Dude",
    "The", "Postal", "I  I I  I I  L", "Ricardo", "Elver Galarga", "Sapee", "Rosamelano", 
    "Bolainas", "Pilgor", "Buckley", "Buttnick", "Wanka", "Ol Chap", "Fred Fuchs", "Xavier", "Smokey", "Flimflam", "Joe", "Cacarion", "Meaty", "SilSSSLLLLAMMER!",
}
local tolFamiliarLinks = {
    " ", "", "-", " and ", " with ", " or ", " without ", " when ", " at ", "...", " of ", " of the ", " for ", ": ", "_",  " because ", " for ", "/", " the "
}
local tolFamiliarLinksRare = {
    " when there's ", "'s face when ", " at the end of ", " out of ", " in the millenium of ",
    " think he ", " think she ", " think they ", " think xey ", ", voted ", ", abjurer of ", ", consumer of ", ", lover of ", ", buyer of ", ", secret crush of ", ", killer of ", ", little pissboy of ", ", friend of ",
    ", enemy of ", ", lover of ", ", divorced wife of ", ", divorced husband of ", ", divorced spouse of ", ", wife of ", ", husbando of ", ", waifu of ", ", who kins ", ", creator of ", ", progenitor of ", ", responsible for ",
    ", heir to ", ", bitch, ", ", motherfucker, "
}
local tolFamiliarPrefixes = {
    "Master ", "Mistress ", "Mr. ", "Mrs. ", "Ms. ", "Mx. ", "God-tier ", "Pretty Good ", "Decent ", "Kinda Shitty ", "Horrible ", "Proto-", "Neo-", "Macro-", "Micro-", "Anarcho-", "Dr. ", "Messrs. ", "Sir ", "Madam ", "Noble ", "Lady ", "Lord ", "Duke ", "Duchess ",
    "Prince ", "Princess ", "Queen ", "King ", "His Majesty ", "Her Majesty ", "Their Majesty, ", "Xir Majesty ", "His Excellency ", "Her Excellency ", "Their Excellency, ", "Xir Excellency ", "Professor ", "Chancellor ", "Vice Chancellor ", 
    "His Holiness ", "Her Holiness ", "Their Holiness, ", "Xir Holiness ", "His Eminence ", "Her Eminence ", "Their Eminence, ", "Xir Eminence ", "The Ultimate ", "The Final ", "The Real ", "The Last ", "The First ", "The Second ", "The First Coming of ", "The Second Coming of ",
    "Principal ", "Dean ", "Warden ", "Rector ", "Director ", "Provost ", "Chief Executive ", "Father ", "Mother ", "Sister ", "Brother ", "Elder ", "Reverend ", "Priest ", "Priestess ", "High ", "Low ", "Venerable ",
    "Judicio-", "Supreme Court Justice ", "Good Friend ", "Best Friend ", "Worst Friend ", "President ", "Prime Minister ", "Dictator ", "Senator ", "Congress Representative ", "Real ", "Psycho-", "Vino-", "Mega-", "Nano-", "Sykoh-", "Mc",
    "The ", "Super ", "Ultra ", "Mega ", "Mini ", "Tera ", "It's ", "That's ", "It's a ", "A ", "This ", "That ", "Fat ", "Big ", "Huge ", "Cream of ",
}
local tolFamiliarSuffixes = {
    "son", "erson", "kin", "daughter", "dottir", "kind", "kid", "pup", "kit", "star", "leaf", "stripe", "claw", "butt", "snoot", ", Esq.", ", M.D.", ", PhD", ", E.D.", "-san", "-tan", "-kun", "-chan", "-sama", "-sensei",
    "-senpai", "-hakase", "-heika", "-kakka", "-denka", "-domo", "-khan", "mancy", "mancer", "bender", "killer", "lover", "kisser", "drinker", "eater", "hater", "master", "fucker", "god", "shitter", "pisser", "nut", "sucker",", bitch!",
    "ford", "ley", "ing", "ington", "ingford", "ingley", "fart", "fuck", "...?",
}
--Oh Boy!
function CLAY_SOLDIER:generateRandomHomunculusEID(npc)
    local data = npc:GetData()
    --Format is based on number of total pickups collected

    --name, name+suffix, prefix+name, prefix+name+suffix, namename, 
    --link (stuff like " of ", " the ", )

    --Get total number of pickups
    local amtPickups = 0
    for k,v in pairs(data.pickupTable) do
        if v ~= 0 then
            amtPickups = amtPickups + v
        end
    end
    print("total of " .. amtPickups)
    local nameComplexity = ((amtPickups - (amtPickups % 8))/8)
    if nameComplexity <= 0 then
        nameComplexity = 1
    end
    if math.random(0,1) == 0 then
        nameComplexity = math.ceil(nameComplexity * (1+((math.random(0,4)/4)-0.5)))
    end
    local nameStr = ""
    for i=1, nameComplexity do
        --Prefix
        if nameComplexity >= 1 then
            if math.random(0,1) == 0 then
                local amtPrefixes = math.random(0,nameComplexity)
                if amtPrefixes ~= 0 then
                    for j=0, amtPrefixes do
                        nameStr = nameStr .. tolFamiliarPrefixes[math.random(1,#tolFamiliarPrefixes)]
                    end
                end
            end
        end
        
        --Name
        if math.random(0,3) == 0 and nameComplexity > 2 then
            --Multi-name
            local amtNames = math.random(1,math.ceil(nameComplexity*1.25))
            for j=0, amtNames do
                nameStr = nameStr .. tolFamiliarNames[math.random(1,#tolFamiliarNames)]
            end
        else
            --Single name
            nameStr = nameStr .. tolFamiliarNames[math.random(1,#tolFamiliarNames)]
        end
        --Suffix
        if math.random(0,1) == 0 and nameComplexity >= 1 then
            local amtSuffixes = math.random(0,nameComplexity)
            if amtSuffixes ~= 0 then
                for j=0, amtSuffixes do
                    nameStr = nameStr .. tolFamiliarSuffixes[math.random(1,#tolFamiliarSuffixes)]
                end
            end
        end

        --Link
        if nameComplexity - i > 0 then
            
            if math.random(0,3) == 0 then
                --Rare link
                nameStr = nameStr .. tolFamiliarLinksRare[math.random(1,#tolFamiliarLinksRare)]
            else
                --link
                nameStr = nameStr .. tolFamiliarLinks[math.random(1,#tolFamiliarLinks)]
            end
        end
        
    end 
    
    if nameStr == "" then
        nameStr = "[NAME UNKNOWN]"
    end
    local descStr = ""
    --[[
    if string.len(nameStr) > 60 and string.len(nameStr) < 240 then
        descStr = descStr .. "Full name: " .. nameStr .. "#"
    elseif string.len(nameStr) >= 240 then
        descStr = descStr .. "Full name: Really damn long! #"
    end]]


    local heartString = "# {{Heart}}: "
    if data.pickupTable ~= nil then
        if data.pickupTable.redHearts ~= 0 then
            heartString = heartString .. "{{ColorRed}}" .. data.pickupTable.redHearts .. "{{ColorReset}}"
        end
        if data.pickupTable.soulHearts ~= 0 then
            heartString = heartString .. "{{ColorCyan}}" .. data.pickupTable.soulHearts .. "{{ColorReset}}"
        end
        if data.pickupTable.blackHearts ~= 0 then
            heartString = heartString .. "{{ColorBlack}}" .. data.pickupTable.blackHearts .. "{{ColorReset}}"
        end
        if data.pickupTable.eternalHearts ~= 0 then
            heartString = heartString .. "{{ColorWhite}}" .. data.pickupTable.eternalHearts .. "{{ColorReset}}"
        end
        if data.pickupTable.goldenHearts ~= 0 then
            heartString = heartString .. "{{ColorYellow}}" .. data.pickupTable.goldenHearts .. "{{ColorReset}}"
        end
        if data.pickupTable.boneHearts ~= 0 then
            heartString = heartString .. "{{ColorSilver}}" .. data.pickupTable.boneHearts .. "{{ColorReset}}"
        end
        if data.pickupTable.rottenHearts ~= 0 then
            heartString = heartString .. "{{ColorGreen}}" .. data.pickupTable.rottenHearts .. "{{ColorReset}}"
        end
        if data.pickupTable.immoralHearts ~= 0 then
            heartString = heartString .. "{{ColorPink}}" .. data.pickupTable.immoralHearts .. "{{ColorReset}}"
        end
        if data.pickupTable.morbidHearts ~= 0 then
            heartString = heartString .. "{{ColorGray}}" .. data.pickupTable.morbidHearts .. "{{ColorReset}}"
        end
    end
    if heartString == "# {{Heart}}: " then
        heartString = ""
        --if the heart category would have nothing in it, just get rid of it
    else
        --add a newline
        heartString = heartString .. " "
    end

    local bombString = "# {{Bomb}}: "
    if data.pickupTable ~= nil then
        if data.pickupTable.bombs ~= 0 then
            bombString = bombString .. "{{ColorWhite}}" .. data.pickupTable.bombs .. "{{ColorReset}}"
        end
        if data.pickupTable.trollBombs ~= 0 then
            bombString = bombString .. "{{ColorSilver}}" .. data.pickupTable.trollBombs .. "{{ColorReset}}"
        end
        if data.pickupTable.goldenBombs ~= 0 then
            bombString = bombString .. "{{ColorYellow}}" .. data.pickupTable.goldenBombs .. "{{ColorReset}}"
        end
        if data.pickupTable.gigaBombs ~= 0 then
            bombString = bombString .. "{{ColorGray}}" .. data.pickupTable.gigaBombs .. "{{ColorReset}}"
        end
        if data.pickupTable.copperBombs ~= 0 then
            bombString = bombString .. "{{ColorOrange}}" .. data.pickupTable.copperBombs .. "{{ColorReset}}"
        end

    end
    if bombString == "# {{Bomb}}: " then
        bombString = ""
        --if the heart category would have nothing in it, just get rid of it
    else
        --add a newline
        bombString = bombString .. " "
    end
    
    local keyString = "# {{Key}}: "
    if data.pickupTable ~= nil then
        if data.pickupTable.keys ~= 0 then
            keyString = keyString .. "{{ColorWhite}}" .. data.pickupTable.keys .. "{{ColorReset}}"
        end
        if data.pickupTable.goldenKeys ~= 0 then
            keyString = keyString .. "{{ColorYellow}}" .. data.pickupTable.goldenKeys .. "{{ColorReset}}"
        end
        if data.pickupTable.chargedKeys ~= 0 then
            keyString = keyString .. "{{ColorOlive}}" .. data.pickupTable.chargedKeys .. "{{ColorReset}}"
        end
        if data.pickupTable.spicyKeys ~= 0 then
            keyString = keyString .. "{{ColorOrange}}" .. data.pickupTable.spicyKeys .. "{{ColorReset}}"
        end
    end
    if keyString == "# {{Key}}: " then
        keyString = ""
        --if the heart category would have nothing in it, just get rid of it
    else
        --add a newline
        keyString = keyString .. " "
    end

    local coinString = "# {{Coin}}: "
    if data.pickupTable ~= nil then
        if data.pickupTable.coins ~= 0 then
            coinString = coinString .. "{{ColorWhite}}" .. data.pickupTable.coins .. "{{ColorReset}}"
        end
        if data.pickupTable.luckyCoins ~= 0 then
            coinString = coinString .. "{{ColorLime}}" .. data.pickupTable.luckyCoins .. "{{ColorReset}}"
        end
        if data.pickupTable.goldenCoins ~= 0 then
            coinString = coinString .. "{{ColorYellow}}" .. data.pickupTable.goldenCoins .. "{{ColorReset}}"
        end
        if data.pickupTable.cursedCoins ~= 0 then
            coinString = coinString .. "{{ColorPink}}" .. data.pickupTable.cursedCoins .. "{{ColorReset}}"
        end
        if data.pickupTable.hauntedCoins ~= 0 then
            coinString = coinString .. "{{ColorCyan}}" .. data.pickupTable.hauntedCoins .. "{{ColorReset}}"
        end
        if data.pickupTable.honeyCoins ~= 0 then
            coinString = coinString .. "{{ColorOrange}}" .. data.pickupTable.honeyCoins .. "{{ColorReset}}"
        end
        if data.pickupTable.legoCoins ~= 0 then
            coinString = coinString .. "{{ColorOlive}}" .. data.pickupTable.legoCoins .. "{{ColorReset}}"
        end

    end
    if coinString == "# {{Coin}}: " then
        coinString = ""
        --if the heart category would have nothing in it, just get rid of it
    else
        --add a newline
        coinString = coinString .. " "
    end

    --[[
        --Cards
                cards = data.numCards,
                --Pills
                pills = data.numPills,
                horsePills = data.numHorsePills,
                goldPills = data.numGoldPills,
                goldHorsePills = data.numGoldHorsePills,
    ]]
    local cardString = "# {{Card}}: "
    if data.pickupTable ~= nil then
        if data.pickupTable.cards ~= 0 then
            cardString = cardString .. "{{ColorWhite}}" .. data.pickupTable.cards .. "{{ColorReset}}"
        end
    end
    if cardString == "# {{Card}}: " then
        cardString = ""
        --if the heart category would have nothing in it, just get rid of it
    else
        --add a newline
        cardString = cardString .. " "
    end
    local pillString = "# {{Pill}}: "
    if data.pickupTable ~= nil then
        if data.pickupTable.pills ~= 0 then
            pillString = pillString .. "{{ColorWhite}}" .. data.pickupTable.pills .. "{{ColorReset}}"
        end
        if data.pickupTable.horsePills ~= 0 then
            pillString = pillString .. "{{ColorGray}}" .. data.pickupTable.horsePills .. "{{ColorReset}}"
        end
        if data.pickupTable.goldPills ~= 0 then
            pillString = pillString .. "{{ColorYellow}}" .. data.pickupTable.goldPills .. "{{ColorReset}}"
        end
        if data.pickupTable.goldHorsePills ~= 0 then
            pillString = pillString .. "{{ColorOlive}}" .. data.pickupTable.goldHorsePills .. "{{ColorReset}}"
        end
    end
    if pillString == "# {{Pill}}: " then
        pillString = ""
        --if the heart category would have nothing in it, just get rid of it
    else
        --add a newline
        pillString = pillString .. " "
    end



    local batString = "# {{Battery}}: "
    if data.pickupTable ~= nil then
        if data.pickupTable.batteries ~= 0 then
            batString = batString .. "{{ColorWhite}}" .. data.pickupTable.batteries .. "{{ColorReset}}"
        end
        if data.pickupTable.goldenBatteries ~= 0 then
            batString = batString .. "{{ColorYellow}}" .. data.pickupTable.goldenBatteries .. "{{ColorReset}}"
        end
        if data.pickupTable.fireworkBatteries ~= 0 then
            batString = batString .. "{{ColorPink}}" .. data.pickupTable.fireworkBatteries .. "{{ColorReset}}"
        end
        if data.pickupTable.virtuousBatteries ~= 0 then
            batString = batString .. "{{ColorCyan}}" .. data.pickupTable.virtuousBatteries .. "{{ColorReset}}"
        end
        if data.pickupTable.cursedBatteries ~= 0 then
            batString = batString .. "{{ColorRed}}" .. data.pickupTable.cursedBatteries .. "{{ColorReset}}"
        end

    end
    if batString == "# {{Battery}}: " then
        batString = ""
        --if the heart category would have nothing in it, just get rid of it
    else
        --add a newline
        batString = batString .. " "
    end


    --stats would go here but i'll add it later

    descStr = "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Pickups: " .. heartString .. bombString .. keyString .. coinString .. cardString .. pillString .. batString .. "#Full name: " .. nameStr .. ""




    --[[
    if data.pickupTable ~= nil then
        for k,v  in pairs(data.pickupTable) do
            if v ~= 0 then
                descStr = descStr .. "Has ".. v .." of type " .. k .."#"
                --print(k,v)
            end
        end
    end]]
    local homunculusEIDTable = {nameStr, descStr}

    return homunculusEIDTable
end




function CLAY_SOLDIER:spawnVirtuousBatteryWisp(player, data)
    local PageOfVirtuesId = FiendFolio:rollPageOfVitruesEffect()
    
    local wisp = player:AddWisp(PageOfVirtuesId, player.Position, true)
    if wisp then
        sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT, 1, 0, false, 1)
    end
end



function CLAY_SOLDIER:onUpdTear(tear)
	
	--this basically exists to make doing forgotten club and spirit sword much easier
    if tear:GetData().isInvisibleFetus ~= true then return end
    local data = tear:GetData()
    if data.followThisDude == nil or data.followThisDude:IsDead() or tear.FrameCount > 40 then
        tear:Remove()
    else
        
        local sprite = tear:GetSprite()
        print(sprite:GetFrame())
        --tear:AddTearFlags(TearFlags.TEAR_FETUS | TearFlags.TEAR_FETUS_SWORD)
        tear.Scale = 1.5
        tear.Position = data.followThisDude.Position
    end
    
end
Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, CLAY_SOLDIER.onUpdTear)



function CLAY_SOLDIER:onUpdChargeBar(npc)

    if not npc.IsFollower then
        npc:AddToFollowers()
    else
        npc:FollowParent()
    end  

    if npc:GetSprite():IsFinished("Finished") then
        npc:Remove()
    end

end

Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, CLAY_SOLDIER.onUpdChargeBar, Isaac.GetEntityVariantByName("Clay Soldier (Chargebar)"))