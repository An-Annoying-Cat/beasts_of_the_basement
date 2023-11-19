local Mod = BotB
local CURSE_OF_JUSTICE = {}
local ff = FiendFolio

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Curse of Justice"), "Pickups have a 25% chance to be consumed upon spawn. #Consumed pickups are given to you all at once upon the next floor, rerolled weightlessly. #{{Warning}} Getting hurt makes one less pickup be given back at the next floor! #Multiple copies of this item makes multiple copies of the pickup be added to the prize set when a pickup is taken.")
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
--[[
function CURSE_OF_JUSTICE:doBlankWhiteCardReroll()
    local room = Game():GetRoom()
    local game = Game()
     local level = game:GetLevel()
     local roomDescriptor = level:GetCurrentRoomDesc()
     local roomConfigRoom = roomDescriptor.Data
    if not roomDescriptor.VisitedCount == 1 then return end
    local players = getPlayers()
    local doesSomeoneHaveBlankWhiteCard = false
    local bwcMultiplier= 0
	for i=1,#players,1 do
		if players[i]:ToPlayer():HasTrinket(Isaac.GetTrinketIdByName("Blank White Card")) then
			--print("dicks")
			bwcMultiplier= bwcMultiplier+ players[i]:ToPlayer():GetTrinketMultiplier(Isaac.GetTrinketIdByName("Blank White Card"))

		end
	end
    if bwcMultiplier == 0 then return end


    if roomDescriptor.VisitedCount == 1 then
        local roomEntities = room:GetEntities() -- cppcontainer
        for i = 0, #roomEntities - 1 do
            local entity = roomEntities:Get(i)
            --print(entity.Type, entity.Variant, entity.SubType)
            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_TAROTCARD then
                local spawnPos = entity.Position
                local cardIDLimit = (#Isaac.GetItemConfig():GetCards())-1
                local entityPickup = entity:ToPickup()
                entityPickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, math.random(1,cardIDLimit), true, true, true)
                --Golden trinket or mom's box: You get a choice between however many consumables instead of just one
                if bwcMultiplier > 1 then
                    if entityPickup.OptionsPickupIndex == 0 then
                        local blankWhiteCardOptionsIndex = 99 + TSIL.Pickups.GetPickupIndex(entityPickup)
                        entityPickup.OptionsPickupIndex = blankWhiteCardOptionsIndex
                        for j=1,bwcMultiplier do
                            local bwcOptionsPickupSpawn = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,math.random(1,cardIDLimit),Isaac.GetFreeNearPosition(entityPickup.Position, 10),Vector.Zero,entityPickup):ToPickup()
                            bwcOptionsPickupSpawn.OptionsPickupIndex = entityPickup.OptionsPickupIndex
                        end
                    else
                        local blankWhiteCardOptionsIndex = entityPickup.OptionsPickupIndex
                        for j=1,bwcMultiplier do
                            local bwcOptionsPickupSpawn = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,math.random(1,cardIDLimit),Isaac.GetFreeNearPosition(entityPickup.Position, 10),Vector.Zero,entityPickup):ToPickup()
                            bwcOptionsPickupSpawn.OptionsPickupIndex = blankWhiteCardOptionsIndex
                        end
                    end
                end
            end
        end    
    end
  end
  Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CURSE_OF_JUSTICE.doBlankWhiteCardReroll, 0)
]]
local mod = FiendFolio
  --yoinked from rare chests and modified with FF code
Mod.pandemoniumPickupVariantWhitelist = {
    {Var = PickupVariant.PICKUP_HEART, Type="Hearts"},
    --modded hearts
    {Var = mod.PICKUP.VARIANT.HALF_BLACK_HEART, Type="Hearts"},
    {Var = mod.PICKUP.VARIANT.BLENDED_BLACK_HEART, Type="Hearts"},
    {Var = mod.PICKUP.VARIANT.IMMORAL_HEART, Type="Hearts"},
    {Var = mod.PICKUP.VARIANT.HALF_IMMORAL_HEART, Type="Hearts"},
    {Var = mod.PICKUP.VARIANT.BLENDED_IMMORAL_HEART, Type="Hearts"},
    {Var = mod.PICKUP.VARIANT.MORBID_HEART, Type="Hearts"},
    {Var = mod.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART, Type="Hearts"},
    {Var = mod.PICKUP.VARIANT.THIRD_MORBID_HEART, Type="Hearts"},

    {Var = PickupVariant.PICKUP_COIN, Type="Coins"},
    {Var = PickupVariant.PICKUP_BOMB, Type="Bombs"},
    {Var = PickupVariant.PICKUP_KEY, Type="Keys"},
    {Var = PickupVariant.PICKUP_CHEST, Type="Chests"},
    {Var = PickupVariant.PICKUP_BOMBCHEST, Type="Chests"},
    {Var = PickupVariant.PICKUP_SPIKEDCHEST, Type="Chests"},
    {Var = PickupVariant.PICKUP_ETERNALCHEST, Type="Chests"},
    {Var = PickupVariant.PICKUP_MIMICCHEST, Type="Chests"},
    {Var = PickupVariant.PICKUP_OLDCHEST, Type="Chests"},
    {Var = PickupVariant.PICKUP_WOODENCHEST, Type="Chests"},
    {Var = PickupVariant.PICKUP_MEGACHEST, Type="Chests"},
    {Var = PickupVariant.PICKUP_HAUNTEDCHEST, Type="Chests"},
    {Var = PickupVariant.PICKUP_LOCKEDCHEST, Type="Chests"},
    --modded
    {Var = 711, Type="Chests"},
    {Var = 712, Type="Chests"},
    {Var = 713, Type="Chests"},
    {Var = 1229, Type="Chests"},

    {Var = PickupVariant.PICKUP_GRAB_BAG, Sub = 1, Type="Sacks"},
    {Var = PickupVariant.PICKUP_GRAB_BAG, Sub = 2, Type="Sacks"},
    {Var = PickupVariant.PICKUP_GRAB_BAG, Sub = 30, Type="Sacks"},
    {Var = PickupVariant.PICKUP_PILL, Type="Consumables"},
    {Var = PickupVariant.PICKUP_TAROTCARD, Type="Consumables"},
    {Var = PickupVariant.PICKUP_LIL_BATTERY, Type="Batteries"},
    --modded batteries
    {Var = 900, Type="Batteries"},
    {Var = 901, Type="Batteries"},
    {Var = 902, Type="Batteries"},
    {Var = 903, Type="Batteries"},
}

if RareChests then
    local rareChestsToAddToWhitelist = {
        {Var = 5020, Type="Chests"},
        {Var = 5127,       Type="Chests"},
        {Var = 5220,       Type="Chests"},
        {Var = 5230,       Type="Chests"},
        {Var = 5240,       Type="Chests"},
        {Var = 6030,       Type="Chests"},
        {Var = 36020,      Type="Chests"},
    }
    for i=1,#rareChestsToAddToWhitelist do
        Mod.pandemoniumPickupVariantWhitelist[#Mod.pandemoniumPickupVariantWhitelist+1] = rareChestsToAddToWhitelist[i]
    end
end



Mod.UnbiasedPandemoniumPickups = {
    ["Bombs"] = {
        {ID = BombSubType.BOMB_NORMAL,               },
        {ID = BombSubType.BOMB_DOUBLEPACK,           },
        {ID = BombSubType.BOMB_TROLL,                },
        {ID = BombSubType.BOMB_GOLDEN,               },
        {ID = BombSubType.BOMB_SUPERTROLL,           },
        {ID = BombSubType.BOMB_GOLDENTROLL,          },
        {ID = FiendFolio.PICKUP.BOMB.COPPER,         },
        {ID = FiendFolio.PICKUP.BOMB.DOUBLE_COPPER,  },
        {ID = FiendFolio.PICKUP.BOMB.MIXED_DOUBLE,   },
        {ID = FiendFolio.PICKUP.BOMB.COPPER_TROLL,   },
        {ID = BombSubType.BOMB_GIGA,},
    },
    ["Coins"] = {
        {ID = CoinSubType.COIN_PENNY,                },
        {ID = CoinSubType.COIN_NICKEL,               },
        {ID = CoinSubType.COIN_DIME,                 },
        {ID = CoinSubType.COIN_DOUBLEPACK,           },
        {ID = CoinSubType.COIN_LUCKYPENNY,           },
        {ID = CoinSubType.COIN_STICKYNICKEL,         },
        {ID = CoinSubType.COIN_GOLDEN,               },
        {ID = mod.PICKUP.COIN.CURSED,                },
        {ID = mod.PICKUP.COIN.HAUNTED,               },
        {ID = mod.PICKUP.COIN.HONEY,                 },
        {ID = mod.PICKUP.COIN.GOLDENCURSED,          },
        {ID = mod.PICKUP.COIN.LEGOSTUD,              },
        {ID = {Var = 961,       Sub = 0},              },
    },
    --Be careful if adding tables, wackey only reads subtypes atm and will crash
    ["Keys"] = {
        {ID = KeySubType.KEY_NORMAL,                 },
        {ID = KeySubType.KEY_GOLDEN,                 },
        {ID = KeySubType.KEY_DOUBLEPACK,             },
        {ID = KeySubType.KEY_CHARGED,                },
        {ID = mod.PICKUP.KEY.SPICY_PERM,             },
        {ID = mod.PICKUP.KEY.SUPERSPICY_PERM,        },
        {ID = mod.PICKUP.KEY.CHARGEDSPICY_PERM,      },
    },
    ["Hearts"] = {
        {ID = HeartSubType.HEART_FULL,               },
        {ID = HeartSubType.HEART_HALF,               },
        {ID = HeartSubType.HEART_SOUL,               },
        {ID = HeartSubType.HEART_ETERNAL,            },
        {ID = HeartSubType.HEART_DOUBLEPACK,         },
        {ID = HeartSubType.HEART_BLACK,              },
        {ID = HeartSubType.HEART_GOLDEN,             },
        {ID = HeartSubType.HEART_HALF_SOUL,          },
        {ID = HeartSubType.HEART_SCARED,             },
        {ID = HeartSubType.HEART_BLENDED,            },
        {ID = HeartSubType.HEART_BONE,               },
        {ID = HeartSubType.HEART_ROTTEN,             },
        {ID = {Var = mod.PICKUP.VARIANT.HALF_BLACK_HEART,       Sub = 0},    },
        {ID = {Var = mod.PICKUP.VARIANT.BLENDED_BLACK_HEART,    Sub = 0},    },
        {ID = {Var = mod.PICKUP.VARIANT.IMMORAL_HEART,          Sub = 0},    },
        {ID = {Var = mod.PICKUP.VARIANT.HALF_IMMORAL_HEART,     Sub = 0},    },
        {ID = {Var = mod.PICKUP.VARIANT.BLENDED_IMMORAL_HEART,  Sub = 0},    },
        {ID = {Var = mod.PICKUP.VARIANT.MORBID_HEART,           Sub = 0},    },
        {ID = {Var = mod.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART, Sub = 0},    },
        {ID = {Var = mod.PICKUP.VARIANT.THIRD_MORBID_HEART,     Sub = 0},    },
    },
    ["Chests"] = {
        {ID = {Var = PickupVariant.PICKUP_CHEST,       Sub = 0},},
        {ID = {Var = PickupVariant.PICKUP_BOMBCHEST,       Sub = 0},},
        {ID = {Var = PickupVariant.PICKUP_LOCKEDCHEST,       Sub = 0},},
        {ID = {Var = PickupVariant.PICKUP_ETERNALCHEST,       Sub = 0},},
        {ID = {Var = PickupVariant.PICKUP_MIMICCHEST,       Sub = 0},},
        {ID = {Var = PickupVariant.PICKUP_HAUNTEDCHEST,       Sub = 0},},
        {ID = {Var = PickupVariant.PICKUP_OLDCHEST,       Sub = 0},},
        {ID = {Var = PickupVariant.PICKUP_WOODENCHEST,       Sub = 0},},
        {ID = {Var = PickupVariant.PICKUP_MEGACHEST,       Sub = 0},},
        {ID = {Var = PickupVariant.PICKUP_REDCHEST,       Sub = 0},},
        {ID = {Var = 711,       Sub = 0},}, --Shop
        {ID = {Var = 712,       Sub = 0},}, --Dire
        {ID = {Var = 713,       Sub = 0},}, --Glass
        {ID = {Var = 1229,       Sub = 0},}, --Toy
    },
    ["Sacks"] = {
        {ID = {Var = PickupVariant.PICKUP_GRAB_BAG,       Sub = 1},},
        {ID = {Var = PickupVariant.PICKUP_GRAB_BAG,       Sub = 2},},
        {ID = {Var = PickupVariant.PICKUP_GRAB_BAG,       Sub = 30},},
    },
    ["Batteries"] = {
        {ID = {Var = PickupVariant.PICKUP_LIL_BATTERY,       Sub = 1},},
        {ID = {Var = PickupVariant.PICKUP_LIL_BATTERY,       Sub = 2},},
        {ID = {Var = PickupVariant.PICKUP_LIL_BATTERY,       Sub = 3},},
        {ID = {Var = PickupVariant.PICKUP_LIL_BATTERY,       Sub = 4},},
        --modded
        {ID = {Var = 900,       Sub = 0},},
        {ID = {Var = 901,       Sub = 0},},
        {ID = {Var = 902,       Sub = 0},},
        {ID = {Var = 903,       Sub = 0},},
    },
    --Handle consumables on your own via D11 code
}
if RareChests then
    Mod.UnbiasedPickups["Chests"][#Mod.UnbiasedPickups["Chests"]+1] = {ID = {Var = 5020,       Sub = 0},} --Cardboard chest
    Mod.UnbiasedPickups["Chests"][#Mod.UnbiasedPickups["Chests"]+1] = {ID = {Var = 5127,       Sub = 0},} --Tomb chest
    Mod.UnbiasedPickups["Chests"][#Mod.UnbiasedPickups["Chests"]+1] = {ID = {Var = 5220,       Sub = 0},} --Cursed chest
    Mod.UnbiasedPickups["Chests"][#Mod.UnbiasedPickups["Chests"]+1] = {ID = {Var = 5230,       Sub = 0},} --Blood chest
    Mod.UnbiasedPickups["Chests"][#Mod.UnbiasedPickups["Chests"]+1] = {ID = {Var = 5240,       Sub = 0},} --Penitent chest
    Mod.UnbiasedPickups["Chests"][#Mod.UnbiasedPickups["Chests"]+1] = {ID = {Var = 6030,       Sub = 0},} --Slot chest
    Mod.UnbiasedPickups["Chests"][#Mod.UnbiasedPickups["Chests"]+1] = {ID = {Var = 36020,       Sub = 0},} --Devil chest
end

local function doesAnyoneHave(itemID, ignoreEffects)
	local game = Game()
	local numPlayers = game:GetNumPlayers()
  
	local players = {}
	for i = 0, numPlayers - 1 do
	  local player = Isaac.GetPlayer(i)
	  table.insert(players, player)
	end
    local doesAnyoneHaveIt = false
	for i=1, #players do
        local dude = players[i]:ToPlayer()
        if dude:HasCollectible(itemID,ignoreEffects) then
            doesAnyoneHaveIt = true
        end
    end
    return doesAnyoneHaveIt
end


local grng = RNG()
function CURSE_OF_JUSTICE:pickupUpdate(pickup)
    local doTheyHaveCurseOfJustice = false
    local players = getPlayers()
    local cojDummyPlayer 
    for i=1,#players do
        local player = players[i]
        if players[i]:ToPlayer():HasCollectible(Isaac.GetItemIdByName("Curse of Justice"), false) then
            cojDummyPlayer = players[i]:ToPlayer()
            doTheyHaveCurseOfJustice = true
        end
    end
    if doTheyHaveCurseOfJustice == false then return end
    --print("passed item check")
    --print(pickup:GetSprite():GetAnimation())
	if (pickup:GetSprite():IsPlaying("Appear") or pickup:GetSprite():IsPlaying("AppearFast")) and pickup:GetData().noCOJYoink ~= true and pickup.FrameCount == 2 then
        if pickup.SpawnerEntity ~= nil and pickup.SpawnerEntity:ToPlayer() == nil then return end
        --if player has Blank White Card
        --print("DO IT ALREADY DAMN")
        local didThePandemonium = false
        local rerollType = ""
        for i=1,#Mod.pandemoniumPickupVariantWhitelist do
            local whitelistIndex = Mod.pandemoniumPickupVariantWhitelist[i]
            --print("checking " .. whitelistIndex.Var, whitelistIndex.Sub, whitelistIndex.Type)
            if whitelistIndex.Sub ~= nil then
                --print("checking " .. whitelistIndex.Var, whitelistIndex.Sub, whitelistIndex.Type)
                if pickup.Variant == whitelistIndex.Var and pickup.SubType == whitelistIndex.Sub then
                    rerollType = whitelistIndex.Type
                end
            else
                if pickup.Variant == whitelistIndex.Var then
                    --print("checking " .. whitelistIndex.Var, whitelistIndex.Type)
                    rerollType = whitelistIndex.Type
                end
            end
        end
        if rerollType == "" then return end
        if math.random(0,3) == 1 then
            --print("yoinked a " .. rerollType .. "!")
            Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.CURSE_OF_JUSTICE_EFFECT.VARIANT,0,pickup.Position,Vector.Zero,pickup)
            if cojDummyPlayer ~= nil then
                cojDummyPlayer:GetData().curseOfJusticePrizeTable[#cojDummyPlayer:GetData().curseOfJusticePrizeTable+1] = rerollType
                pickup:Remove()
            end
        else
            pickup:GetData().noCOJYoink = true
        end
	end
end
Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, CURSE_OF_JUSTICE.pickupUpdate)



function CURSE_OF_JUSTICE:crossEffect(effect)
    if effect.Variant ~= BotB.Enums.Entities.CURSE_OF_JUSTICE_EFFECT.VARIANT then return end
    if effect.FrameCount == 1 then
        if effect:GetSprite().Rotation == 180 then
            SFXManager():Play(BotB.Enums.SFX.CURSE_OF_JUSTICE,1,0,false,0.75,0)
        else
            SFXManager():Play(BotB.Enums.SFX.CURSE_OF_JUSTICE,1,0,false,1,0)
        end
        
    end
    effect.Velocity = Vector.Zero
    if effect:GetSprite():IsFinished("Default") then
        effect:Remove()
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,CURSE_OF_JUSTICE.crossEffect, BotB.Enums.Entities.CURSE_OF_JUSTICE_EFFECT.VARIANT)


function CURSE_OF_JUSTICE:playerUpdate(player)
    local data = player:GetData()
    local level = Game():GetLevel()
    if player:HasCollectible(Isaac.GetItemIdByName("Curse of Justice"), false) and data.curseOfJusticePrizeTable == nil then
        --table of strings telling what kind of pickup to spawn
        data.curseOfJusticePrizeTable = {}
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, CURSE_OF_JUSTICE.playerUpdate, 0)




--handles spawning of pickups and clearing the list afterward
function CURSE_OF_JUSTICE:botbCOJloorLogic()
    --[[
    local level = Game():GetLevel()
    if Game().Challenge ~= Challenge.CHALLENGE_XXXXXXXXL then
        print("now has xxxxxxl")
        local character = player:GetPlayerType()
        game.Challenge = Challenge.CHALLENGE_XXXXXXXXL
          player:ChangePlayerType(character)
    end
    ]]
    local players = getPlayers()
    for i=1,#players,1 do
        if players[i]:ToPlayer():HasCollectible(Isaac.GetItemIdByName("Curse of Justice")) then
            --print("dicks")
            if #players[i]:ToPlayer():GetData().curseOfJusticePrizeTable ~= 0 then
                for j=1,#players[i]:ToPlayer():GetData().curseOfJusticePrizeTable do
                    print(players[i]:ToPlayer():GetData().curseOfJusticePrizeTable[j])
                    CURSE_OF_JUSTICE:SpawnUnweightedPickup(players[i]:ToPlayer():GetData().curseOfJusticePrizeTable[j])
                end
                players[i]:ToPlayer():GetData().curseOfJusticePrizeTable = {}
                --Game().Challenge = Isaac.GetChallengeIdByName("[BOTB] MyBasement.lua")
            end

        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, CURSE_OF_JUSTICE.botbCOJloorLogic, 0)



function CURSE_OF_JUSTICE:SpawnUnweightedPickup(ptype)

    local spawnPos = Game():GetRoom():FindFreePickupSpawnPosition(Game():GetRoom():GetRandomPosition(10), 1, true, false)
        if ptype == "Consumables" then
            local cardIDLimit = (#Isaac.GetItemConfig():GetCards())-1
            if math.random() < 0.25 then
                local randoPick = math.random(0,1)
                if randoPick == 0 then
                    --pill
                    local newPill = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, spawnPos, Vector.Zero, nil)
                    newPill:GetData().noPandemoniumMorph = true
                    newPill:GetData().noCOJYoink = true

                elseif randoPick == 1 then
                    --horse pill
                    local pill = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, spawnPos, Vector.Zero, nil):ToPickup()
                    pill:GetData().noPandemoniumMorph = true
                    pill:GetData().noCOJYoink = true

                    --entityPickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, true, true, true)
                    local pillToGiant = pill.SubType + PillColor.PILL_GIANT_FLAG
                    pill:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, pillToGiant, true, true, true)
                    pill:GetData().noPandemoniumMorph = true
                    pill:GetData().noCOJYoink = true
                end
            else
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, math.random(1,cardIDLimit), spawnPos, Vector.Zero, nil)
                 
            end
        else
            local typeToSpawn = Mod.UnbiasedPandemoniumPickups[ptype][math.random(1,#Mod.UnbiasedPandemoniumPickups[ptype])].ID
            --print(typeToSpawn)
            if type(typeToSpawn) == "table" then
                local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP,typeToSpawn.Var,typeToSpawn.Sub, spawnPos, Vector.Zero, nil)
                pickup:GetData().noPandemoniumMorph = true
                pickup:GetData().noCOJYoink = true
                 
                --pickup:Remove()
            else
                local rerollTypeVariant = 0
                if ptype == "Hearts" then
                    rerollTypeVariant = PickupVariant.PICKUP_HEART
                elseif ptype == "Coins" then
                    rerollTypeVariant = PickupVariant.PICKUP_COIN
                elseif ptype == "Bombs" then
                    rerollTypeVariant = PickupVariant.PICKUP_BOMB
                elseif ptype == "Keys" then
                    rerollTypeVariant = PickupVariant.PICKUP_KEY
                end
                local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP,rerollTypeVariant,typeToSpawn, spawnPos, Vector.Zero, nil)
                pickup:GetData().noCOJYoink = true
                pickup:GetData().noPandemoniumMorph = true
                 
                --pickup:Remove()
            end
        end
end


function  CURSE_OF_JUSTICE:houseplantHurt()
    --print("cocks")
    local player = Isaac.GetPlayer()
    local data = player:GetData()
        if player:HasCollectible(Isaac.GetItemIdByName("Curse of Justice")) then
            if player:ToPlayer():GetData().curseOfJusticePrizeTable ~= nil and #player:ToPlayer():GetData().curseOfJusticePrizeTable ~= 0 then
                table.remove(player:ToPlayer():GetData().curseOfJusticePrizeTable, math.random(1,#player:ToPlayer():GetData().curseOfJusticePrizeTable))
                local rotatedCross = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.CURSE_OF_JUSTICE_EFFECT.VARIANT,0,player.Position+Vector(0,-75),Vector.Zero,player):ToEffect()
                rotatedCross:GetSprite().Rotation = 180
                --player:ToPlayer():GetData().curseOfJusticePrizeTable[#player:ToPlayer():GetData().curseOfJusticePrizeTable].Remove
            end
        end
    end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG,  CURSE_OF_JUSTICE.houseplantHurt, EntityType.ENTITY_PLAYER)