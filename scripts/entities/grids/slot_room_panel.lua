local Mod = BotB
local SLOT_ROOM_PANEL = {}
local Entities = BotB.Enums.Entities

function SLOT_ROOM_PANEL:NPCUpdate(npc)
    if npc.Type == EntityType.ENTITY_GENERIC_PROP and npc.Variant == BotB.Enums.Props.SLOT_ROOM_PANEL.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()

        --print("slungus")
    end
end

local mod = FiendFolio
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SLOT_ROOM_PANEL.NPCUpdate, Isaac.GetEntityTypeByName("Seducer"))

    Mod.UnbiasedPickups = {
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

--Janky, but it works
function SLOT_ROOM_PANEL:playerUpdate(player)
    local roomEntities = Isaac.GetRoomEntities() -- table
    local panelsInTheRoom = {}
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        --Self processing for the props
        if entity.Type == EntityType.ENTITY_GENERIC_PROP and entity.Variant == BotB.Enums.Props.SLOT_ROOM_PANEL.VARIANT then     
            panelsInTheRoom[#panelsInTheRoom+1] = entity
            local data = entity:GetData()
            ----print("slungus")
            local sprite = entity:GetSprite()
            if data.State == nil then
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                entity.SortingLayer = SortingLayer.SORTING_BACKGROUND
                sprite:Play("Cycle")
                data.State = 99
            end
            sprite.PlaybackSpeed = 0.25
            local measureFromPos = entity.Position
            local measureToPos = player.Position
            if data.State == 99 then
                local checkFrame = ((sprite:GetFrame()) - (sprite:GetFrame() % 4))/4
                if checkFrame == 0 then
                    data.botbSlotResult = "Coins"
                elseif checkFrame == 1 then
                    data.botbSlotResult = "Hearts"
                elseif checkFrame == 2 then
                    data.botbSlotResult = "Bombs"
                elseif checkFrame == 3 then
                    data.botbSlotResult = "Keys"
                elseif checkFrame == 4 then
                    data.botbSlotResult = "Chests"
                elseif checkFrame == 5 then
                    data.botbSlotResult = "Jackpot"
                end
                if measureToPos.X >= measureFromPos.X - 40 and measureToPos.X <= measureFromPos.X + 40 then
                    if measureToPos.Y >= measureFromPos.Y - 40 and measureToPos.Y <= measureFromPos.Y + 40 then
                        SFXManager():Play(SoundEffect.SOUND_SLOTSPAWN,1,0,false,0.6)
                        data.botbSlotIsActivated = true
                        data.State = 100
                        sprite:Play(data.botbSlotResult)
                    else
                        sprite.Color = Color(1,1,1,1)
                    end
                else
                    sprite.Color = Color(1,1,1,1)
                end
    
            end
            if data.State == 100 then
                --print(data.botbSlotResult)
            end
        end
    end
    local unactivatedPanelsInTheRoom = {}
    for i=1, #panelsInTheRoom do
        local slot = panelsInTheRoom[i]
        local sdata = slot:GetData()
        if sdata.botbSlotIsActivated ~= true then
            unactivatedPanelsInTheRoom[#unactivatedPanelsInTheRoom+1] = slot
        end
    end
    for i=1, #panelsInTheRoom do
        local slot = panelsInTheRoom[i]
        local sdata = slot:GetData()
        if sdata.botbSlotIsActivated ~= true then
            slot:GetSprite().PlaybackSpeed = 4.0 * (0.5^#unactivatedPanelsInTheRoom)
        end
    end
    if #panelsInTheRoom ~= 0 and #unactivatedPanelsInTheRoom == 0 and player:GetData().hasDoneTheSlotRoomOnThisFloor ~= true then
        local slotRoomResults = {
            Coins = 0,
            Hearts = 0,
            Bombs = 0,
            Keys = 0,
            Chests = 0,
            Jackpot = 0,
        }
        for i=1, #panelsInTheRoom do
            local finishedSlot = panelsInTheRoom[i]
            local fdata = finishedSlot:GetData()
            if fdata.botbSlotResult == "Coins" then
                slotRoomResults.Coins = slotRoomResults.Coins + 1
            end
            if fdata.botbSlotResult == "Hearts" then
                slotRoomResults.Hearts = slotRoomResults.Hearts + 1
            end
            if fdata.botbSlotResult == "Bombs" then
                slotRoomResults.Bombs = slotRoomResults.Bombs + 1
            end
            if fdata.botbSlotResult == "Keys" then
                slotRoomResults.Keys = slotRoomResults.Keys + 1
            end
            if fdata.botbSlotResult == "Chests" then
                slotRoomResults.Chests = slotRoomResults.Chests + 1
            end
            if fdata.botbSlotResult == "Jackpot" then
                slotRoomResults.Jackpot = slotRoomResults.Jackpot + 1
            end
        end
        local spawnPos = Game():GetRoom():FindFreePickupSpawnPosition(Game():GetRoom():GetCenterPos(), 1, false, false)
        local numToSpawn = 0
        if slotRoomResults.Coins > 0 then
            if slotRoomResults.Coins == 1 then
                numToSpawn = 1
            elseif slotRoomResults.Coins == 2 then
                numToSpawn = 4
            elseif slotRoomResults.Coins == 3 then
                numToSpawn = 9
            end
            for i=1,numToSpawn do
                local typeToSpawn = Mod.UnbiasedPickups["Coins"][math.random(1,#Mod.UnbiasedPickups["Coins"])].ID
                if type(typeToSpawn) == "table" then
                    Isaac.Spawn(EntityType.ENTITY_PICKUP,typeToSpawn.Var,typeToSpawn.Sub,spawnPos,Vector(math.random(1,25),0):Rotated(math.random(0,359)),player)
                else
                    Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COIN,typeToSpawn,spawnPos,Vector(math.random(1,25),0):Rotated(math.random(0,359)),player)
                end
            end
        end
        numToSpawn = 0

        if slotRoomResults.Hearts > 0 then
            if slotRoomResults.Hearts == 1 then
                numToSpawn = 1
            elseif slotRoomResults.Hearts == 2 then
                numToSpawn = 3
            elseif slotRoomResults.Hearts == 3 then
                numToSpawn = 6
            end
            for i=1,numToSpawn do
                local typeToSpawn = Mod.UnbiasedPickups["Hearts"][math.random(1,#Mod.UnbiasedPickups["Hearts"])].ID
                if type(typeToSpawn) == "table" then
                    Isaac.Spawn(EntityType.ENTITY_PICKUP,typeToSpawn.Var,typeToSpawn.Sub,spawnPos,Vector(math.random(1,25),0):Rotated(math.random(0,359)),player)
                else
                    Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_HEART,typeToSpawn,spawnPos,Vector(math.random(1,25),0):Rotated(math.random(0,359)),player)
                end
            end
        end
        numToSpawn = 0

        if slotRoomResults.Bombs > 0 then
            if slotRoomResults.Bombs == 1 then
                numToSpawn = 1
            elseif slotRoomResults.Bombs == 2 then
                numToSpawn = 3
            elseif slotRoomResults.Bombs == 3 then
                numToSpawn = 6
            end
            for i=1,numToSpawn do
                local typeToSpawn = Mod.UnbiasedPickups["Bombs"][math.random(1,#Mod.UnbiasedPickups["Bombs"])].ID
                if type(typeToSpawn) == "table" then
                    Isaac.Spawn(EntityType.ENTITY_PICKUP,typeToSpawn.Var,typeToSpawn.Sub,spawnPos,Vector(math.random(1,25),0):Rotated(math.random(0,359)),player)
                else
                    Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_BOMB,typeToSpawn,spawnPos,Vector(math.random(1,25),0):Rotated(math.random(0,359)),player)
                end
            end
        end
        numToSpawn = 0

        if slotRoomResults.Keys > 0 then
            if slotRoomResults.Keys == 1 then
                numToSpawn = 1
            elseif slotRoomResults.Keys == 2 then
                numToSpawn = 3
            elseif slotRoomResults.Keys == 3 then
                numToSpawn = 6
            end
            for i=1,numToSpawn do
                local typeToSpawn = Mod.UnbiasedPickups["Keys"][math.random(1,#Mod.UnbiasedPickups["Keys"])].ID
                if type(typeToSpawn) == "table" then
                    Isaac.Spawn(EntityType.ENTITY_PICKUP,typeToSpawn.Var,typeToSpawn.Sub,spawnPos,Vector(math.random(1,25),0):Rotated(math.random(0,359)),player)
                else
                    Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_KEY,typeToSpawn,spawnPos,Vector(math.random(1,25),0):Rotated(math.random(0,359)),player)
                end
            end
        end
        numToSpawn = 0

        if slotRoomResults.Chests > 0 then
            if slotRoomResults.Chests == 1 then
                numToSpawn = 1
            elseif slotRoomResults.Chests == 2 then
                numToSpawn = 2
            elseif slotRoomResults.Chests == 3 then
                numToSpawn = 4
            end
            for i=1,numToSpawn do
                local typeToSpawn = Mod.UnbiasedPickups["Chests"][math.random(1,#Mod.UnbiasedPickups["Chests"])].ID
                if type(typeToSpawn) == "table" then
                    Isaac.Spawn(EntityType.ENTITY_PICKUP,typeToSpawn.Var,typeToSpawn.Sub,spawnPos,Vector(math.random(1,25),0):Rotated(math.random(0,359)),player)
                else
                    Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_CHEST,typeToSpawn,spawnPos,Vector(math.random(1,25),0):Rotated(math.random(0,359)),player)
                end
            end
        end
        numToSpawn = 0

        if slotRoomResults.Jackpot > 0 then
            if slotRoomResults.Jackpot == 1 then
                numToSpawn = 2
            elseif slotRoomResults.Jackpot == 2 then
                numToSpawn = 6
            elseif slotRoomResults.Jackpot == 3 then
                numToSpawn = 10
                Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,0,spawnPos,Vector.Zero,player)
            end
            for i=1,numToSpawn do
                local spawnType = math.random(0,4)
                if spawnType == 0 then
                    --Coins
                    local typeToSpawn = Mod.UnbiasedPickups["Coins"][math.random(1,#Mod.UnbiasedPickups["Coins"])].ID
                    if type(typeToSpawn) == "table" then
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,typeToSpawn.Var,typeToSpawn.Sub,spawnPos,Vector(math.random(1,25),0):Rotated(math.random(0,359)),player)
                    else
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COIN,typeToSpawn,spawnPos,Vector(math.random(1,25),0):Rotated(math.random(0,359)),player)
                    end
                elseif spawnType == 1 then
                    --Hearts
                    local typeToSpawn = Mod.UnbiasedPickups["Hearts"][math.random(1,#Mod.UnbiasedPickups["Hearts"])].ID
                    if type(typeToSpawn) == "table" then
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,typeToSpawn.Var,typeToSpawn.Sub,spawnPos,Vector(math.random(1,25),0):Rotated(math.random(0,359)),player)
                    else
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_HEART,typeToSpawn,spawnPos,Vector(math.random(1,25),0):Rotated(math.random(0,359)),player)
                    end
                elseif spawnType == 2 then
                    --Bombs
                    local typeToSpawn = Mod.UnbiasedPickups["Bombs"][math.random(1,#Mod.UnbiasedPickups["Bombs"])].ID
                    if type(typeToSpawn) == "table" then
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,typeToSpawn.Var,typeToSpawn.Sub,spawnPos,Vector(math.random(1,25),0):Rotated(math.random(0,359)),player)
                    else
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_BOMB,typeToSpawn,spawnPos,Vector(math.random(1,25),0):Rotated(math.random(0,359)),player)
                    end
                elseif spawnType == 3 then
                    --Keys
                    local typeToSpawn = Mod.UnbiasedPickups["Keys"][math.random(1,#Mod.UnbiasedPickups["Keys"])].ID
                    if type(typeToSpawn) == "table" then
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,typeToSpawn.Var,typeToSpawn.Sub,spawnPos,Vector(math.random(1,25),0):Rotated(math.random(0,359)),player)
                    else
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_KEY,typeToSpawn,spawnPos,Vector(math.random(1,25),0):Rotated(math.random(0,359)),player)
                    end
                elseif spawnType == 4 then
                    --Chests
                    local typeToSpawn = Mod.UnbiasedPickups["Chests"][math.random(1,#Mod.UnbiasedPickups["Chests"])].ID
                    if type(typeToSpawn) == "table" then
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,typeToSpawn.Var,typeToSpawn.Sub,spawnPos,Vector(math.random(1,25),0):Rotated(math.random(0,359)),player)
                    else
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_CHEST,typeToSpawn,spawnPos,Vector(math.random(1,25),0):Rotated(math.random(0,359)),player)
                    end
                end
            end
        end
        numToSpawn = 0

        player:GetData().hasDoneTheSlotRoomOnThisFloor = true

    end
    
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, SLOT_ROOM_PANEL.playerUpdate, 0)

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

function SLOT_ROOM_PANEL:resetOnNewLevel()
    local players = getPlayers()
    for i=1, #getPlayers() do
        local player = players[i]:ToPlayer()
        if player:GetData().hasDoneTheSlotRoomOnThisFloor == true then
            player:GetData().hasDoneTheSlotRoomOnThisFloor = false
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, SLOT_ROOM_PANEL.resetOnNewLevel)